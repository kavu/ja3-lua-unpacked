DefineClass.NetCloudSocket = {
  __parents = {"DataSocket"},
  callback_id = false,
  friends = false,
  friend_names = false,
  chat_room_guests = false,
  chat_room = false,
  timeout = Platform.ps4 and 21600000 or nil,
  msg_size_max = 16777216
}
function NetCloudSocket:OnDisconnect(reason)
  DataSocket.OnDisconnect(self, reason)
  if netSwarmSocket == self then
    NetForceDisconnect(reason or true)
  end
end
function NetCloudSocket:rfnNewLogin()
  if netSwarmSocket == self then
    print("Net: account logged in from another computer")
  end
end
function NetCloudSocket:rfnLeaveGame(reason)
  CreateRealTimeThread(NetLeaveGame, reason)
end
function NetCloudSocket:rfnChatMsg(player_name, account_id, platform, message)
  if not self.friends or self.friends[account_id] ~= "blocked" then
    CreateRealTimeThread(function(player_name, account_id, message)
      if Platform.xbox then
        local idx = table.find(netSwarmSocket.chat_room_guests, 1, account_id)
        if not idx then
          return
        end
        local xuid = netSwarmSocket.chat_room_guests[idx][5]
        local allowed = CheckPermissionWithUser(xuid, "ViewTargetPresence")
        if not allowed then
          return
        end
        allowed = CheckPermissionWithUser(xuid, "CommunicateUsingText")
        if not allowed then
          return
        end
      end
      if Platform.xbox then
        message = FilterString(message, "full")
        player_name = FilterString(player_name, "keep first")
      elseif Platform.switch then
        message = AsyncSwitchMaskProfanityWordsInText(message)
      end
      Msg("Chat", player_name, account_id, message)
    end, player_name, account_id, message)
  end
end
function NetCloudSocket:rfnChatSysMsg(message, ...)
  Msg("SysChat", message, ...)
end
function NetCloudSocket:rfnGuestJoin(id, info)
  if self.chat_room_guests then
    self.chat_room_guests[id] = info
    Msg("SysChat", "join", unpack_params(info))
    Msg("ChatRoomGuestsChange", self.chat_room_guests)
  end
end
function NetCloudSocket:rfnGuestLeave(id)
  if self.chat_room_guests then
    local info = self.chat_room_guests[id]
    self.chat_room_guests[id] = false
    Msg("SysChat", "leave", unpack_params(info))
    Msg("ChatRoomGuestsChange", self.chat_room_guests)
  end
end
function NetCloudSocket:rfnWhisper(sender_name, sender_account_id, message)
  if NetIsOfficialConnection() and (not self.friends or self.friends[sender_account_id or false] ~= "blocked") then
    if Platform.switch then
      message = AsyncSwitchMaskProfanityWordsInText(message)
    end
    Msg("Whisper", sender_name, sender_account_id, message)
  end
end
function NetChatMsg(message)
  if not netSwarmSocket then
    return "disconnected"
  end
  if utf8.len(message) > 200 then
    return "params"
  end
  return netSwarmSocket:Call("rfnChatMsg", message)
end
function NetJoinChatRoom(room, index)
  local platform
  local id = false
  if Platform.xbox then
    platform = "xbox"
    id = Xbox.GetXuid()
  elseif Platform.desktop then
    platform = "desktop"
  elseif Platform.ps4 then
    platform = "ps4"
  elseif Platform.switch then
    platform = "switch"
  end
  local err, room_info, guests = NetCall("rfnJoinChatRoom", room, type(index) == "number" and index or nil, platform, GetLanguage(), id)
  if err == "same" then
    return
  end
  if err then
    return err
  end
  if netSwarmSocket then
    netSwarmSocket.chat_room_guests = guests or {}
    netSwarmSocket.chat_room = room_info
  end
  Msg("JoinChatRoom", err, netSwarmSocket and netSwarmSocket.chat_room, guests)
end
function NetLeaveChatRoom()
  local err = NetCall("rfnLeaveChatRoom")
  if netSwarmSocket then
    netSwarmSocket.chat_room_guests = {}
    netSwarmSocket.chat_room = false
  end
  Msg("LeaveChatRoom", err)
  return err
end
function NetEnumChatRooms(room)
  return NetCall("rfnEnumChatRooms", room)
end
if FirstLoad then
  PSNAllowOfficialConnection = false
  XboxAllowOfficialConnection = false
  NintendoAllowOfficialConnection = false
end
function NetMakeUserOffline()
  CreateRealTimeThread(NetLeaveChatRoom)
  NetLeaveGame()
  NetDisconnect()
  PSNAllowOfficialConnection = false
  XboxAllowOfficialConnection = false
  NintendoAllowOfficialConnection = false
end
function OnMsg.NetDisconnect()
  PSNAllowOfficialConnection = false
  XboxAllowOfficialConnection = false
  NintendoAllowOfficialConnection = false
end
function NetIsOfficialConnection()
  if not (NetIsConnected() and (not Platform.ps4 or PSNAllowOfficialConnection) and (not Platform.xbox or XboxAllowOfficialConnection)) or Platform.switch and not NintendoAllowOfficialConnection then
    return
  end
  return not netRestrictedAccount
end
function NetGetXUID(account_id)
  return NetCall("rfnGetXUID", account_id)
end
function NetCloudSocket:GetCallbackId()
  if not self.callback_id then
    local err, callback_id = self:Call("rfnGetCallbackId")
    if err then
      return err
    end
    self.callback_id = {callback_id}
  end
  return false, self.callback_id[1]
end
function NetCloudSocket:rfnCallback(...)
  if self.callback_id then
    Msg(self.callback_id, ...)
  end
end
function NetCloudSocket:rfnFriendList(friends_list, invitations, invitations_sent, blocked)
  local friends, friend_names = {}, {}
  self.friends = friends
  self.friend_names = friend_names
  for k, v in pairs(friends_list) do
    friends[k] = "offline"
    friend_names[k] = v
  end
  for k, v in pairs(invitations) do
    friends[k] = "invited"
    friend_names[k] = v
  end
  for k, v in pairs(invitations_sent) do
    friends[k] = "invite_sent"
    friend_names[k] = v
  end
  for k, v in pairs(blocked) do
    friends[k] = "blocked"
    friend_names[k] = v
  end
  Msg("FriendsChange", friends, friend_names, "init")
end
function NetCloudSocket:rfnFriendStatus(player_name, account_id, status)
  self.friends = self.friends or {}
  self.friend_names = self.friend_names or {}
  status = type(status) == "number" and (status == 0 and "offline" or status == 1 and "online" or status == 2 and "playing") or status
  self.friends[account_id] = status
  self.friend_names[account_id] = player_name
  Msg("FriendsChange", self.friends, self.friend_names, "status")
end
function NetCloudSocket:rfnAddFriend(account_id, player_name)
  self.friends[account_id] = "offline"
  self.friend_names[account_id] = player_name
  Msg("FriendsChange", self.friends, self.friend_names, "add")
end
function NetCloudSocket:rfnUnfriend(account_id)
  self.friends[account_id] = nil
  self.friend_names[account_id] = nil
  Msg("FriendsChange", self.friends, self.friend_names, "remove")
end
function NetCloudSocket:rfnBlock(player_name, account_id)
  self.friends = self.friends or {}
  self.friend_names = self.friend_names or {}
  self.friends[account_id] = "blocked"
  self.friend_names[account_id] = player_name
  Msg("FriendsChange", self.friends, self.friend_names, "block")
end
function NetCloudSocket:rfnUnblock(account_id)
  self.friends[account_id] = nil
  self.friend_names[account_id] = nil
  Msg("FriendsChange", self.friends, self.friend_names, "unblock")
end
function NetCloudSocket:rfnFriendRequest(account_id, player_name)
  self.friends = self.friends or {}
  self.friend_names = self.friend_names or {}
  self.friends[account_id] = "invited"
  self.friend_names[account_id] = player_name
  Msg("FriendsChange", self.friends, self.friend_names, "request")
  Msg("FriendRequest", account_id, player_name)
end
function NetCloudSocket:rfnInviteFriend(account_id, player_name)
  self.friends = self.friends or {}
  self.friend_names = self.friend_names or {}
  self.friends[account_id] = "invite_sent"
  self.friend_names[account_id] = player_name
  Msg("FriendsChange", self.friends, self.friend_names, "invite")
end
function NetCloudSocket:rfnPing()
end
if FirstLoad then
  g_UsedTickets = {}
end
function NetCloudSocket:rfnUsedTickets(tickets)
  g_UsedTickets = tickets or {}
end
function OnMsg.NetDisconnect()
  g_UsedTickets = {}
end
function NetFriendRequest(player_name, alias, alias_type)
  if not netSwarmSocket then
    return "disconnected"
  end
  return netSwarmSocket:Call("rfnFriendRequest", player_name, alias, alias_type)
end
function NetUnfriend(alias, alias_type)
  if not netSwarmSocket then
    return "disconnected"
  end
  return netSwarmSocket:Call("rfnUnfriend", alias, alias_type)
end
function NetBlock(player_name, alias, alias_type)
  if not netSwarmSocket then
    return "disconnected"
  end
  return netSwarmSocket:Call("rfnBlock", player_name, alias, alias_type)
end
function NetUnblock(alias, alias_type, account_id)
  if not netSwarmSocket then
    return "disconnected"
  end
  return netSwarmSocket:Call("rfnUnblock", alias, alias_type, account_id)
end
function NetReportPlayer(player_name, alias, alias_type, reason)
  if not netSwarmSocket then
    return "disconnected"
  end
  return netSwarmSocket:Call("rfnReport", player_name, alias, alias_type, reason)
end
function NetPingPlayer(account_id)
  if not netSwarmSocket then
    return "disconnected"
  end
  return netSwarmSocket:Call("rfnPingPlayer", account_id)
end
function NetCloudSocket:rfnInvite(player_name, player_account_id, game_address, ...)
  if not NetIsOfficialConnection() then
    return
  end
  if not (self.friends and player_account_id) or self.friends[player_account_id] ~= "blocked" then
    Msg("GameInvite", player_name, player_account_id, game_address, ...)
  end
  return LocalPlayersCount >= 2 and "in local coop" or nil
end
function NetCloudSocket:rfnPlayerMessage(player_name, player_account_id, data_type, ...)
  if not NetIsOfficialConnection() then
    return
  end
  if not self.friends or self.friends[player_account_id or false] ~= "blocked" then
    local response = {}
    Msg("NetPlayerMessage", response, player_name, player_account_id, data_type, ...)
    return unpack_params(response)
  end
end
function NetCloudSocket:rfnSavegame(player_account_id, savegame)
  if netInGame then
    local player_id = table.find(netGamePlayers, "account_id", player_account_id)
    if player_id then
      Msg("NetSavegame", player_id, player_account_id, savegame)
    end
  end
end
if FirstLoad then
  netAutomatch = false
end
function NetStartAutomatch(match_type, info)
  NetCancelAutomatch()
  netAutomatch = match_type
  local err, time, players, quality = NetCall("rfnStartMatch", match_type, info)
  if err then
    netAutomatch = false
    Msg("NetMatchFound")
  end
  return err, time, players, quality
end
function NetCancelAutomatch()
  if netAutomatch then
    netAutomatch = false
    Msg("NetMatchFound")
    NetSend("rfnCancelMatch")
  end
end
function NetCloudSocket:rfnMatchFound(match_type, game_id)
  if netAutomatch == match_type then
    Msg("NetMatchFound", match_type, game_id)
    netAutomatch = false
  end
end
OnMsg.NetDisconnect = NetCancelAutomatch
