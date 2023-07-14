function DbgJoinGame(game_type, game_id)
  if not IsRealTimeThread() then
    CreateRealTimeThread(DbgJoinGame, game_type, game_id)
    return
  end
  if not NetIsConnected() then
    local err, auth_provider, auth_provider_data, display_name = NetGetProviderLogin()
    local name = tostring(sockGetHostName() or "unknown") .. "-" .. 10000 + AsyncRand(90000)
    local err = NetConnect(config.SwarmHost, config.SwarmPort, auth_provider, auth_provider_data, display_name, config.NetCheckUpdates)
    if err then
      print("NetConnect", err)
      return err
    end
  end
  local new_game = netDisplayName .. "'s game"
  game_type = game_type or "DbgGame"
  if not game_id then
    local err, games = NetCall("rfnSearchGames", "dbg", nil, true)
    if err then
      print("rfnSearchGames", err)
      return err
    end
    local items = {}
    for i, game in ipairs(games) do
      items[i] = game[1] .. ": " .. game[2] .. " - " .. TableToLuaCode(game[6], " ")
    end
    items[#items + 1] = "New: " .. new_game
    local item = WaitListChoice(nil, items, "Join game")
    if not item then
      return
    end
    local idx = table.find(items, item)
    game_id = games[idx] and games[idx][1]
    if game_id then
      ResetGameSession()
    else
      err, game_id = NetCall("rfnCreateGame", game_type, "dbg", new_game, "public", {
        map = GetMapName()
      })
      if err then
        print("rfnCreateGame", err)
        return
      end
    end
  end
  local err = NetJoinGame(nil, game_id)
  if err then
    print("NetJoinGame", err)
    return err
  end
end
g_dbgLastParamTableHashed = false
local processing_tables = {}
local hashVal = function(v)
  if type(v) == "table" then
    if IsValid(v) then
      return xxhash(v.handle)
    else
      return hashParamTable(v)
    end
  elseif type(v) == "function" then
    return xxhash(tostring(v))
  elseif type(v) == "thread" then
    return 0
  else
    return xxhash(v)
  end
end
function hashParamTable(t)
  local ret = 0
  if not t then
    return ret
  end
  if processing_tables[t] then
    return ret
  end
  processing_tables[t] = true
  for k, v in next, t, nil do
    ret = ret ~ hashVal(k) ~ hashVal(v)
  end
  processing_tables[t] = nil
  g_dbgLastParamTableHashed = t
  return ret
end
