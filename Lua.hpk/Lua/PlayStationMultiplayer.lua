if not Platform.playstation then
  return
end
function PlatformHostMultiplayerGame(game_name, game_id, private)
  local msg = CreateMessageBox(terminal.desktop, T(687826475879, "Co-Op Lobby"), T(984040263007, "Connecting to PlayStation Network"), T(6879, "Cancel"), "psn-processing")
  local cancel_psn_hosting = false
  CreateRealTimeThread(function()
    local err = PSNPrepareContextAndCallbacks()
    if err then
      CloseMessageBoxesOfType("psn-processing", "psn_push_context_fail")
      return
    end
    local err, result = PSNCreatePlayerSession_Zulu(game_name, private)
    if err then
      PSNClearContextAndCallbacks()
      CloseMessageBoxesOfType("psn-processing", "psn_create_player_session_fail")
      return
    end
    local err, result = PSNSetPlayerSessionInfo("customData1", tostring(game_id))
    if err then
      PSNClearPlayerSession()
      CloseMessageBoxesOfType("psn-processing", "psn_set_player_session_info_fail")
      return
    end
    if cancel_psn_hosting then
      cancel_psn_hosting = false
      PSNClearPlayerSession()
    end
    CloseMessageBoxesOfType("psn-processing", "success")
  end)
  local result = msg:Wait()
  if result == "success" then
    return
  elseif result == "ok" then
    cancel_psn_hosting = true
    return "cancelled"
  else
    return result
  end
end
function PlatformPostHostMultiplayerGame()
  netGameInfo.console_session_id = ConsoleSessionId
  NetChangeGameInfo(netGameInfo)
end
function PlatformJoinMultiplayerGame(netGameInfo)
  playstation_print("----------------------------------------------------------- PlatformJoinMultiplayerGame")
  local err = PSNPrepareContextAndCallbacks()
  if err then
    return "psn_push_context_fail"
  end
  ConsoleSessionId = netGameInfo.console_session_id
  local err, result = PSNJoinPlayerSessionAsPlayer(ConsoleSessionId)
  if err then
    return "psn_join_player_session_fail"
  end
end
function PSNPlayerSessionEvent_SessionDeleted(json_data)
  local err, data = JSONToLua(json_data)
  if err then
    return err
  end
  if ConsoleSessionId == data then
    NetLeaveGame("psn-player-session-deleted")
  end
end
function PSNPlayerSessionEvent_PlayerDeleted(json_data)
  CreateRealTimeThread(function()
    local err, data = JSONToLua(json_data)
    if err then
      return err
    end
    local err, account_id = PSNGetUserAccountId()
    if err then
      return err
    end
    if data.member.players[1].accountId == account_id then
      NetLeaveGame("psn_player_session_kicked")
    end
  end)
end
function OnMsg.NetGameLeft(reason)
  playstation_print("Net game left")
  PlayStationStopNotifyMultiplayer()
  playstation_print("--- StopNotifyMultiplayer")
  CreateRealTimeThread(function()
    PSNClearPlayerSession()
  end)
end
function OnMsg.NetGameJoined(game_id, unique_id)
  if not Game or #netGamePlayers == 1 then
    return
  end
  local feature = "realtime-multiplay"
  for _, player in ipairs(netGamePlayers) do
    if unique_id ~= player.id and player.platform ~= "playstation" then
      feature = "realtime-cross"
    end
  end
  PlayStationStartNotifyMultiplayer(feature)
  playstation_print("--- StartNotifyMultiplayer: " .. feature)
end
function OnMsg.NetGameInfo(info)
  if info.console_session_id ~= nil then
    ConsoleSessionId = info.console_session_id
  end
end
function OnMsg.NetPlayerLeft(player, reason)
  if not Game or #netGamePlayers > 1 then
    return
  end
  playstation_print("Net player left")
  PlayStationStopNotifyMultiplayer()
  playstation_print("--- StopNotifyMultiplayer")
end
function OnMsg.NetPlayerJoin(info)
  if not Game or #netGamePlayers <= 1 then
    return
  end
  playstation_print("Net player joined")
  local feature = info.platform ~= "playstation" and "realtime-cross" or "realtime-multi"
  PlayStationStartNotifyMultiplayer(feature)
  playstation_print("--- StartNotifyMultiplayer: " .. feature)
end
function OnMsg.OrbisPSNSigninChanged(new_state)
  if not new_state and netInGame then
    NetLeaveGame("psn_signout")
  end
end
function OnMsg.OrbisNPReachabilityStateChanged(new_state)
end
function PSNCreatePlayerSession_Zulu(game_name, private)
  local players = {}
  table.insert(players, {
    accountId = "me",
    platform = "me",
    pushContexts = {
      {
        pushContextId = PlayStationCurrentPushContextId()
      }
    }
  })
  local localizedText = {}
  localizedText["en-US"] = game_name
  local playerSessions = {}
  table.insert(playerSessions, {
    maxPlayers = 2,
    member = {players = players},
    supportedPlatforms = {"PS5", "PS4"},
    localizedSessionName = {defaultLanguage = "en-US", localizedText = localizedText},
    disableSystemUiMenu = {
      "PROMOTE_TO_LEADER"
    },
    swapSupported = false,
    nonPsnSupported = false,
    joinableUserType = private and "NO_ONE" or "ANYONE",
    exclusiveLeaderPrivileges = {
      "UPDATE_JOINABLE_USER_TYPE",
      "UPDATE_INVITABLE_USER_TYPE"
    }
  })
  local body = {playerSessions = playerSessions}
  return PSNCreatePlayerSession(game_name, private, body)
end
function PlayStationJoinPlayerSession(session_id)
  playstation_print("Reading game intent as <Join Session>. Session_id: " .. tostring(session_id))
  ConsoleSessionId = session_id
  CreateRealTimeThread(function()
    local err = PlatformCheckMultiplayerRequirements()
    if err then
      return err
    end
    local err, result = PSNGetPlayerSessionInfo({
      "@default",
      "customData1"
    })
    if err then
      playstation_print(err)
      return err
    end
    local err, data = JSONToLua(result)
    if err then
      playstation_print(err)
      return err
    end
    local game_address = data.playerSessions[1].customData1
    if not game_address then
      playstation_print("Empty custom data 1")
      return "Empty custom data 1. Needs to be set to SWARM game_address."
    end
    game_address = Decode64(game_address)
    local host_name = data.playerSessions[1].leader.onlineId
    MultiplayerConnect()
    UIReceiveInvite(host_name, nil, tonumber(game_address), "CoOp", nil)
  end)
end
function CheckPlayStationPremiumFeaturesDialog()
  local msg = CreateUnclickableMessagePrompt(T(908809691453, "Multiplayer"), T(994790984817, "Connecting..."))
  local err = CheckPlayStationPremiumFeatures()
  if err then
    ConsoleSessionId = false
    msg:Close()
    CreateMessageBox(nil, T(634182240966, "Error"), T({
      871834320348,
      "Could not connect to the server! Reason: <err>",
      err = Untranslated(err)
    }), T(325411474155, "OK"))
    return err
  end
  msg:Close()
end
PlatformCheckMultiplayerRequirements = CheckPlayStationPremiumFeaturesDialog
