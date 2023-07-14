function PlatformGetFriends()
  return nil, "name", {}, {}
end
if Platform.steam then
  function OnMsg.NetPlayerInfo(player, info)
    if player.id ~= netUniqueId and info.steam_id64 then
      SteamSetPlayedWith(info.steam_id64)
    end
  end
  function OnMsg.NetGameJoined(game_id, player_id)
    for k, v in sorted_pairs(netGamePlayers) do
      if k ~= netUniqueId and v.steam_id64 then
        SteamSetPlayedWith(v.steam_id64)
      end
    end
  end
  function PlatformGetFriends()
    local friends = SteamGetFriends()
    if not friends then
      return "getting friends error"
    end
    local blocked_users = SteamGetBlockedUsers()
    if not friends then
      return "getting blocked users error"
    end
    return nil, "steam", friends, blocked_users
  end
end
if Platform.playstation then
  if FirstLoad then
    g_LastPlayStationGetFriends = 0
    g_LastFriendList = {}
    g_LastBlockList = {}
  end
  function GetUsersList(psn_id, limit, url_template, list_name)
    local users_list = {}
    local count = 0
    for start = 0, 2000, limit do
      local url = string.format(url_template, tostring(psn_id), limit, start)
      local err, http_code, result = AsyncOpWait(PSNAsyncOpTimeout, nil, "AsyncPlayStationWebApiRequest", "userProfile", url, "", "GET", "", {})
      if err or http_code ~= 200 then
        local err, http_error = JSONToLua(result)
        return err or http_code, result
      end
      local err, users = JSONToLua(result)
      if err or not users then
        return "json error"
      end
      for _, user_t in ipairs(users[list_name] or {}) do
        count = count + 1
        table.insert(users_list, user_t)
      end
      if count >= users.totalItemCount then
        break
      end
    end
    return nil, users_list
  end
  function GetPublicIds(account_ids)
    local batches = {}
    local count = 0
    local account_ids_string = ""
    for _, acc_id in pairs(account_ids) do
      if count == 99 then
        count = 0
        table.insert(batches, account_ids_string)
        account_ids_string = ""
      end
      account_ids_string = account_ids_string .. (count == 0 and "" or ",") .. acc_id
      count = count + 1
    end
    table.insert(batches, account_ids_string)
    local online_ids = {}
    local count = 0
    for _, accounts_id_string in ipairs(batches) do
      local url = string.format("/v1/users/profiles?accountIds=%s", accounts_id_string)
      local err, http_code, result = AsyncOpWait(PSNAsyncOpTimeout, nil, "AsyncPlayStationWebApiRequest", "userProfile", url, "", "GET", "", {})
      if err or http_code ~= 200 then
        local err, http_error = JSONToLua(result)
        return err or http_code, result
      end
      local err, users = JSONToLua(result)
      if err or not users then
        return "json error"
      end
      for _, user_t in ipairs(users and users.profiles or {}) do
        count = count + 1
        table.insert(online_ids, tostring(user_t.onlineId or ""))
      end
    end
    local assocs = {}
    for idx, id in ipairs(account_ids) do
      assocs[id] = online_ids[idx]
    end
    return nil, assocs
  end
  function PlatformGetFriends()
    local time = os.time()
    if time - g_LastPlayStationGetFriends > 60 then
      g_LastPlayStationGetFriends = time
      local user = "me"
      local friends_list = {}
      local err, friends_list = GetUsersList(user, 500, "/v1/users/%s/friends?limit=%d&offset=%d", "friends")
      if err then
        return "GET friendList failed: " .. err
      end
      local block_list = {}
      err, block_list = GetUsersList(user, 2000, "/v1/users/%s/blocks?limit=%d&offset=%d", "blocks")
      if err then
        return "GET blockList failed: " .. err
      end
      local total_ids = {}
      for _, id in ipairs(friends_list) do
        table.insert(total_ids, id)
      end
      for _, id in ipairs(block_list) do
        table.insert(total_ids, id)
      end
      local err, public_ids = GetPublicIds(total_ids)
      if err then
        return "GET Public IDs failed: " .. err
      end
      g_LastFriendList = {}
      for _, friend in ipairs(friends_list) do
        g_LastFriendList[friend] = public_ids[friend]
      end
      g_LastBlockList = {}
      for _, blocked in ipairs(block_list) do
        g_LastBlockList[friend] = public_ids[blocked]
      end
    end
    return nil, "psn", g_LastFriendList, g_LastBlockList
  end
end
if Platform.xbox then
  function PlatformGetFriends()
    local err, console_friends_xuid, console_friends_names = AsyncXboxGetFriends()
    if err then
      return err
    end
    local friends = {}
    for i = 1, #console_friends_xuid do
      friends[HashXUID(console_friends_xuid[i])] = console_friends_names[i]
    end
    local blocked = {}
    local err, console_blocked = AsyncXboxGetAvoidList()
    for _, XUID in ipairs(console_blocked or empty_table) do
      blocked[HashXUID(XUID)] = ""
    end
    return nil, "xboxlive", friends, blocked
  end
  function OnMsg.XboxAppStateChanged()
    if XboxAppState == "full" then
      CreateRealTimeThread(UpdatePlatformFriends, {}, {})
    end
  end
end
if Platform.switch then
  function PlatformGetFriends()
    local err, friend_ids, friend_names = Switch.GetFriends()
    if err then
      return err
    end
    local friends = {}
    for i = 1, #friend_ids do
      friends[string.format("%s:%s", netEnvironment, friend_ids[i])] = friend_names[i]
    end
    local err, blocked_ids = Switch.GetBlocked()
    if err then
      return err
    end
    local blocked = {}
    for i = 1, #blocked_ids do
      blocked[string.format("%s:%s", netEnvironment, blocked_ids[i])] = ""
    end
    return nil, "nintendo", friends, blocked
  end
end
function UpdatePlatformFriends(friends, friend_names)
  if not AccountStorage or not NetIsConnected() then
    return
  end
  local err, alias_type, platform_friends, platform_blocked = PlatformGetFriends()
  if err or not friends then
    return err
  end
  local stored_friends = AccountStorage.platform_friends or empty_table
  local stored_blocked = AccountStorage.platform_blocked or empty_table
  local platform_friends_by_name = table.invert(platform_friends)
  for account_id, status in pairs(friends) do
    local name = friend_names[account_id]
    if status == "invited" and platform_friends_by_name[name] then
      NetFriendRequest(name, platform_friends_by_name[name], alias_type)
    end
  end
  local friends_changed
  for id, name in pairs(platform_friends) do
    if not stored_friends[id] then
      friends_changed = true
      NetFriendRequest(name, id, alias_type)
    end
  end
  for id in pairs(stored_friends) do
    if not platform_friends[id] then
      friends_changed = true
      NetUnfriend(id, alias_type)
    end
  end
  for id, name in pairs(platform_blocked) do
    if not stored_blocked[id] then
      friends_changed = true
      NetBlock(name, id, alias_type)
    end
  end
  for id in pairs(stored_blocked) do
    if not platform_blocked[id] then
      friends_changed = true
      NetUnblock(id, alias_type)
    end
  end
  if friends_changed then
    AccountStorage.platform_friends = platform_friends
    AccountStorage.platform_blocked = platform_blocked
    SaveAccountStorage(5000)
  end
end
function OnMsg.FriendsChange(friends, friend_names, event)
  if not AccountStorage then
    return
  end
  if event == "init" then
    local time = os.time()
    if time - (AccountStorage.friend_reset_time or 0) > 604800 then
      AccountStorage.platform_friends = {}
      AccountStorage.platform_blocked = {}
      AccountStorage.friend_reset_time = time
    end
    CreateRealTimeThread(UpdatePlatformFriends, friends, friend_names)
  end
end
