local old_NetWaitGameStart = NetWaitGameStart
g_dbgFasterNetJoin = false
function NetWaitGameStart(timeout)
  if netGamePlayers and table.count(netGamePlayers) <= 1 then
    NetGameSend("rfnStartGame")
    netDesync = false
    return false
  end
  return old_NetWaitGameStart(timeout)
end
local shield_vars = {}
local orig_cbs = {}
function OnMsg.ChangeMap()
  shield_vars = {}
end
function FireNetSyncEventOnHostOnce(event, ...)
  if netInGame and not NetIsHost() then
    return
  end
  FireNetSyncEventOnce(event, ...)
end
function FireNetSyncEventOnce(event, ...)
  if GetMapName() == "" then
    return
  end
  if GameReplayScheduled then
    return
  end
  local shieldVarName = string.format("%s%d_fired", event, xxhash(Serialize(...)))
  local svv = shield_vars[shieldVarName]
  local time = AdvanceToGameTimeLimit or GameTime()
  if svv and time - svv < 1500 then
    return
  end
  orig_cbs[event] = orig_cbs[event] or NetSyncEvents[event]
  NetSyncEvents[event] = function(...)
    shield_vars[shieldVarName] = nil
    NetSyncEvents[event] = orig_cbs[event]
    orig_cbs[event] = nil
    NetSyncEvents[event](...)
  end
  shield_vars[shieldVarName] = time
  NetSyncEvent(event, ...)
end
function IsInMultiplayerGame()
  return netInGame and table.count(netGamePlayers) > 1
end
function GetOtherNetPlayerInfo()
  local otherPlayer = netUniqueId == 1 and 2 or 1
  return netGamePlayers[otherPlayer]
end
function LoadNetGame(game_type, game_data, metadata)
  local success, err = sprocall(_LoadNetGame, game_type, game_data, metadata)
  return not success and err or false
end
function CloseDialogForReal(dlg_name, result)
  local dlg = CloseDialog(dlg_name, result)
  if dlg and dlg.window_state ~= "destroying" then
    dlg:Close(result)
  end
end
function _LoadNetGame(game_type, game_data, metadata)
  NetSyncEventFence()
  SectorLoadingScreenOpen(GetLoadingScreenParamsFromMetadata(metadata))
  WaitChangeMapDone()
  Msg("PreLoadNetGame")
  CancelDrag()
  CloseDialog("PDADialog")
  CloseDialog("PreGameMenu")
  CloseDialog("PopupNotification")
  CloseDialogForReal("ModifyWeaponDlg", true)
  CloseDialog("FullscreenGameDialogs")
  CloseBugReporter()
  ResetZuluStateGlobals()
  Sleep(10)
  NetSyncEventFence("init_buffer")
  NetStartBufferEvents()
  local err = LoadGameSessionData(game_data, metadata)
  NetStopBufferEvents()
  if not err then
    Msg("NetGameLoaded")
  end
  SectorLoadingScreenClose(GetLoadingScreenParamsFromMetadata(metadata))
end
function NetEvents.LoadGame(game_type, game_data, metadata)
  CreateRealTimeThread(function()
    local err = LoadNetGame(game_type, Decompress(game_data), metadata)
    err = err or NetWaitGameStart()
    if err then
      NetLeaveGame(err)
      print("LoadNetGame failed:", err)
      OpenPreGameMainMenu("")
    end
  end)
end
function OnMsg.ResetGameSession()
  NetLeaveGame("ResetGameSession")
end
function OnMsg.NetGameJoined(game_id, unique_id)
  if Game and NetIsHost() then
    NetGameSend("rfnStartGame")
    AdvanceToGameTimeLimit = GameTime()
  end
end
function StartHostedGame(game_type, game_data, metadata)
  LoadingScreenOpen(GetLoadingScreenParamsFromMetadata(metadata, "host game"))
  if IsChangingMap() then
    WaitMsg("ChangeMapDone", 5000)
  end
  NetGameCall("rfnStopGame")
  Pause("net")
  if not string.starts_with(game_data, "return") then
    game_data = "return " .. game_data
  end
  local err = NetEvent("LoadGame", game_type, Compress(game_data), metadata)
  if err then
    print("NetEvent failed:", err)
  else
    err = LoadNetGame(game_type, game_data, metadata)
    if err then
      print("LoadNetGame failed:", err)
      OpenPreGameMainMenu("")
    else
      err = NetWaitGameStart()
      if err then
        print("NetWaitGameStart failed:", err)
        OpenPreGameMainMenu("")
      end
    end
  end
  if err then
    NetLeaveGame("host error")
  end
  Resume("net")
  LoadingScreenClose(GetLoadingScreenParamsFromMetadata(metadata, "host game"))
  return err
end
PlatformHostMultiplayerGame = _G and rawget(_G, "PlatformHostMultiplayerGame") or empty_func
PlatformPostHostMultiplayerGame = _G and rawget(_G, "PlatformPostHostMultiplayerGame") or empty_func
PlatformJoinMultiplayerGame = _G and rawget(_G, "PlatformJoinMultiplayerGame") or empty_func
function HostMultiplayerGame(gameType)
  if not NetIsConnected() then
    local err = MultiplayerConnect()
    if err then
      print("NetConnect", err)
      return err
    end
  end
  local mods = g_ModsUIContextObj or ModsUIObjectCreateAndLoad()
  while not g_ModsUIContextObj or not g_ModsUIContextObj.installed_retrieved do
    Sleep(100)
  end
  local enabledMods = {}
  for mod, enabled in pairs(mods.enabled) do
    if enabled then
      local modDef = {
        luaRev = mods.mod_defs[mod].lua_revision,
        title = mods.mod_defs[mod].title,
        steamId = mods.mod_defs[mod].steam_id
      }
      table.insert(enabledMods, modDef)
    end
  end
  local game_name = netDisplayName .. "'s game"
  local private = gameType and gameType == "private"
  local info = {
    map = GetMapName(),
    campaign = Game and Game.Campaign or rawget(_G, "DefaultCampaign") or "HotDiamonds",
    mods = enabledMods,
    day = Game and TFormat.day() or 1,
    host_id = netAccountId,
    name = game_name,
    private = private,
    platform = Platform
  }
  local err, game_id = NetCall("rfnCreateGame", "CoopGame", "coop", game_name, "public", info)
  if err then
    print("rfnCreateGame", err)
    return err
  end
  err = PlatformHostMultiplayerGame(game_name, game_id, private)
  if err then
    return err
  end
  err = NetJoinGame(nil, game_id)
  if err then
    print("NetJoinGame", err)
    return err
  end
  PlatformPostHostMultiplayerGame()
end
function MultiplayerConnect()
  local err, auth_provider, auth_provider_data, display_name = NetGetProviderLogin()
  if err then
    return err
  end
  local name = tostring(sockGetHostName() or "unknown") .. "-" .. 10000 + AsyncRand(90000)
  local err = NetConnect(config.SwarmHost, config.SwarmPort, auth_provider, auth_provider_data, display_name, config.NetCheckUpdates)
  if err then
    print("NetConnect", err)
    return err
  end
  return false, name, display_name
end
function AssignMercControl(merc_id, guest)
  if not NetIsHost() then
    return
  end
  local value = not not guest
  NetEchoEvent("AssignControl", merc_id, value)
end
function NetEvents.AssignControl(merc_id, value)
  local unit_data = gv_UnitData and gv_UnitData[merc_id]
  if not unit_data then
    return
  end
  local prop_value = value and 2 or 1
  unit_data:SetProperty("ControlledBy", prop_value)
  local unit = g_Units[merc_id]
  if unit then
    unit.ControlledBy = prop_value
    Msg("UnitControlChanged", unit, prop_value)
  else
    Msg("UnitDataControlChanged", unit_data, prop_value)
  end
  ObjModified(unit_data)
end
if FirstLoad then
  g_CoOpReadyToEnd = false
end
function NetSyncEvents.CoOpReadyToEndTurn(player_id, isReady)
  if not g_CoOpReadyToEnd then
    g_CoOpReadyToEnd = {}
  end
  g_CoOpReadyToEnd[player_id] = isReady
  if player_id == netUniqueId then
    ObjModified(SelectedObj)
    SelectObj(false)
  end
  local endTurnButton = GetInGameInterfaceModeDlg():ResolveId("idTurn")
  if endTurnButton then
    endTurnButton:OnContextUpdate(Selection)
  end
  local otherPlayerHasNoLivingUnits = true
  local team = GetCurrentTeam()
  for i, u in ipairs(team.units) do
    if not u:IsDead() and not u:IsLocalPlayerControlled() then
      otherPlayerHasNoLivingUnits = false
      break
    end
  end
  if otherPlayerHasNoLivingUnits then
    NetSyncEvent("EndTurn", netUniqueId)
    return
  end
  if not NetIsHost() or #g_CoOpReadyToEnd ~= #netGamePlayers then
    return
  end
  for uid, ready in pairs(g_CoOpReadyToEnd) do
    if not ready then
      return
    end
  end
  NetSyncEvent("EndTurn", netUniqueId)
end
function FireNetSyncEventOnHost(...)
  if not netInGame or NetIsHost() then
    NetSyncEvent(...)
  end
end
function NetStartBufferEvents()
  netBufferedEvents = netBufferedEvents or {}
end
if FirstLoad then
  players_clicked_sync = false
  players_clicked_hooks = false
end
function ClickSyncDump()
  print(players_clicked_sync)
end
function InitPlayersClickedSync(reason, on_done_waiting, on_player_clicked)
  players_clicked_sync = players_clicked_sync or {}
  players_clicked_hooks = players_clicked_hooks or {}
  players_clicked_sync[reason] = {}
  players_clicked_hooks[reason] = {on_done_waiting = on_done_waiting, on_player_clicked = on_player_clicked}
  local t = players_clicked_sync[reason]
  for _, data in pairs(netGamePlayers) do
    t[data.id] = false
  end
end
function HaveAllPlayersClicked(reason)
  if not players_clicked_sync then
    return true
  end
  local t = players_clicked_sync[reason]
  if not t then
    return true
  end
  for _, v in pairs(t) do
    if not v then
      return false
    end
  end
  return true
end
function DoneWaitingForPlayersToClick(reason)
  if players_clicked_sync and players_clicked_sync[reason] then
    players_clicked_sync[reason] = nil
    local hooks = players_clicked_hooks[reason]
    players_clicked_hooks[reason] = nil
    if hooks.on_done_waiting then
      hooks.on_done_waiting()
    end
  end
end
function OnMsg.NetGameLeft(reason)
  for click_reason, data in pairs(players_clicked_sync or empty_table) do
    DoneWaitingForPlayersToClick(click_reason)
  end
end
function OnMsg.NetPlayerLeft(player, reason)
  for click_reason, data in sorted_pairs(players_clicked_sync or empty_table) do
    data[player.id] = nil
    if HaveAllPlayersClicked(click_reason) then
      DoneWaitingForPlayersToClick(click_reason)
    end
  end
end
function NetSyncEvents.PlayerClickedReady(player_id, reason, event_id)
  if not PlayersClickedSync_IsInitializedForReason(reason) then
    return
  end
  local t = players_clicked_sync[reason]
  if t[player_id] ~= false then
    return
  end
  t[player_id] = true
  local all_clicked = HaveAllPlayersClicked(reason)
  if all_clicked then
    DoneWaitingForPlayersToClick(reason)
  else
    local hooks = players_clicked_hooks[reason]
    if hooks.on_player_clicked then
      hooks.on_player_clicked(player_id, t)
    end
  end
end
function IsWaitingForPlayerToClick(player_id, reason)
  if players_clicked_sync and players_clicked_sync[reason] then
    return players_clicked_sync[reason][player_id] == false
  end
  return false
end
function PlayersClickedSync_IsInitializedForReason(reason)
  if players_clicked_sync and players_clicked_sync[reason] then
    return true
  end
  return false
end
function LocalPlayerClickedReady(reason)
  if netGameInfo.started and IsWaitingForPlayerToClick(netUniqueId, reason) then
    NetSyncEvent("PlayerClickedReady", netUniqueId, reason)
  end
end
local lCloseSyncedDlg = function(self, msg)
  if self.window_state ~= "destroying" and self.window_state ~= "closing" then
    self:Close()
    Msg(msg)
  end
end
local lOnPlayerClickedSyncDlg = function(self, player_id, data)
  if not self.idSkipHint:GetVisible() then
    self.idSkipHint:SetVisible(true)
  end
  if data[netUniqueId] then
    self.idSkipHint:SetText(T(221873989540, "Waiting for the other player..."))
  else
    self.idSkipHint:SetText(T({
      181264542969,
      "<Count>/<Total> players skipped the cutscene",
      Count = table.count(data, function(k, v)
        return v
      end),
      Total = table.count(netGamePlayers)
    }))
  end
end
function _ENV:ComicOnShortcut(shortcut, source, ...)
  if RealTime() - self.openedAt < 500 then
    return "break"
  end
  if 500 > RealTime() - terminal.activate_time then
    return "break"
  end
  if IsInMultiplayerGame() then
    if shortcut ~= "Escape" and shortcut ~= "ButtonB" and shortcut ~= "MouseL" then
      return
    end
    LocalPlayerClickedReady("Outro")
  else
    if not self.idSkipHint:GetVisible() then
      self.idSkipHint:SetVisible(true)
      return "break"
    end
    if shortcut ~= "Escape" and shortcut ~= "ButtonB" and shortcut ~= "MouseL" then
      return
    end
    self:Close()
  end
  return "break"
end
function _ENV:ComicOnOpen(...)
  XDialog.Open(self, ...)
  rawset(self, "openedAt", RealTime())
  if GetUIStyleGamepad(nil, self) then
    self.idSkipHint:SetText(T(576896503712, "<ButtonB> Skip"))
  else
    self.idSkipHint:SetText(T(696052205292, "<style SkipHint>Escape: Skip</style>"))
  end
  if IsInMultiplayerGame() then
    InitPlayersClickedSync("Outro", function()
      OutroClose(self)
    end, function(player_id, data)
      lOnPlayerClickedSyncDlg(self, player_id, data)
    end)
  end
end
function _ENV:OutroClose()
  lCloseSyncedDlg(self, "OutroClosed")
end
function _ENV:IntroClose()
  lCloseSyncedDlg(self, "IntroClosed")
end
function _ENV:IntroOnBtnClicked()
  if IsInMultiplayerGame() then
    if not PlayersClickedSync_IsInitializedForReason("Intro") then
      return
    end
    LocalPlayerClickedReady("Intro")
  else
    IntroClose(self)
  end
  return "break"
end
function _ENV:IntroOnOpen()
  if IsInMultiplayerGame() then
    InitPlayersClickedSync("Intro", function()
      IntroClose(self)
    end, function(player_id, data)
      lOnPlayerClickedSyncDlg(self, player_id, data)
    end)
  end
end
function WaitSyncLoadingDone()
  if GameState.sync_loading then
    WaitGameState({sync_loading = false})
  end
end
function NetSyncEvents.SyncLoadingStart()
  ChangeGameState("sync_loading", true)
end
function NetEvents.SyncLoadingStartEcho()
  local Dispatch = function()
    CreateGameTimeThread(function()
      local idx = table.find(SyncEventsQueue, 2, "SyncLoadingStart")
      local t = idx and SyncEventsQueue[idx][1]
      PauseInfiniteLoopDetection("SyncLoadingHack")
      while not GameState.sync_loading and IsValidThread(PeriodicRepeatThreads.SyncEvents) and t == GameTime() do
        WaitAllOtherThreads()
      end
      ResumeInfiniteLoopDetection("SyncLoadingHack")
      ChangeGameState("sync_loading", true)
    end)
  end
  CreateRealTimeThread(function()
    WaitAllOtherThreads()
    local idx = table.find(SyncEventsQueue, 2, "SyncLoadingStart")
    local attempts = 4
    local attempt = 0
    while not idx and not IsChangingMap() do
      Sleep(5)
      idx = table.find(SyncEventsQueue, 2, "SyncLoadingStart")
      attempt = attempt + 1
      if attempts < attempt then
        break
      end
    end
    if not idx and not idx then
      Dispatch()
      return
    end
    local ev = idx and SyncEventsQueue[idx]
    local t = ev[1]
    local ts = GameTime()
    while t > GameTime() and ts <= GameTime() and not IsChangingMap() do
      Sleep(Min(t - GameTime(), 12))
    end
    Dispatch()
  end)
end
function NetSyncEvents.SyncLoadingDone()
  ChangeGameState("sync_loading", false)
  Msg("SyncLoadingDone")
end
function OnMsg.GameStateChanged(changed)
  if (not netInGame or NetIsHost()) and changed.loading then
    NetSyncEvent("SyncLoadingStart")
    CreateRealTimeThread(function()
      WaitLoadingScreenClose()
      NetSyncEvent("SyncLoadingDone")
    end)
  end
end
function IsNetGameStarted()
  return not netInGame or netGameInfo.started
end
if FirstLoad then
  sent_events = {}
  events_sent_while_disconnecting = {}
  disconnecting = false
end
function OnMsg.NewMap()
  disconnecting = false
end
local DispatchList = function(lst)
  for i = 1, #lst do
    NetSyncEvent(lst[i][1], unpack_params(lst[i][2]))
  end
  table.clear(lst)
end
function OnMsg.ClassesGenerate()
  local orig_func = _G.NetSyncEvent
  function _G.NetSyncEvent(event, ...)
    if netInGame or disconnecting then
      sent_events[#sent_events + 1] = {
        event,
        pack_params(...)
      }
      if disconnecting then
        return
      end
    end
    orig_func(event, ...)
  end
end
local findFirstSentEvent = function(event)
  for i = 1, #sent_events do
    if sent_events[i][1] == event then
      return i
    end
  end
end
function OnMsg.SyncEvent(event, ...)
  if not disconnecting and not netInGame then
    return
  end
  if #sent_events <= 0 then
    return
  end
  local idx = findFirstSentEvent(event)
  if idx then
    if idx ~= 1 then
      table.move(sent_events, idx + 1, #sent_events, 1)
      local to = #sent_events - idx + 1
      for j = #sent_events, to, -1 do
        sent_events[j] = nil
      end
    else
      table.remove(sent_events, idx)
    end
  end
end
function OnMsg.NetDisconnect()
  if #sent_events <= 0 then
    return
  end
  disconnecting = true
  print("Thread Created", #sent_events)
  CreateGameTimeThread(function()
    while #SyncEventsQueue > 0 do
      local t = GetThreadStatus(PeriodicRepeatThreads.SyncEvents)
      if t > GameTime() then
        Sleep(t - GameTime())
      end
      WaitAllOtherThreads()
      InterruptAdvance()
    end
    disconnecting = false
    print("RE-Sending events", #sent_events)
    DispatchList(sent_events)
  end)
end
local events = 0
local thread = false
function TestDisc()
  DeleteThread(thread)
  events = 0
  thread = CreateRealTimeThread(function()
    for i = 1, 500 do
      NetSyncEvent("Testing", i)
      events = events + 1
      Sleep(10)
    end
  end)
end
function NetSyncEvents.Testing(i)
  events = events - 1
  print("!!!!!!!!!!!!!!!Testing received!", i, events)
end
MapVar("g_NetSyncFence", false)
if FirstLoad then
  g_NetSyncFenceWaiting = false
  g_NetSyncFenceInitBuffer = false
end
function OnMsg.SyncLoadingDone()
  if g_NetSyncFenceWaiting then
    return
  end
  FenceDebugPrint("SyncLoadingDone")
  g_NetSyncFence = false
end
function NetSyncEvents.FenceReceived(playerId)
  if not g_NetSyncFence then
    g_NetSyncFence = {}
  end
  FenceDebugPrint("-------FenceReceived", g_NetSyncFence, playerId)
  g_NetSyncFence[playerId] = true
  local eventNotFound = false
  for id, player in pairs(netGamePlayers) do
    if not g_NetSyncFence[id] then
      eventNotFound = true
      break
    end
  end
  if not eventNotFound then
    if g_NetSyncFenceInitBuffer then
      StartBufferingAfterFence()
      g_NetSyncFenceInitBuffer = false
    end
    Msg(g_NetSyncFence)
  end
end
function FenceDebugPrint(...)
  do return end
  local args = {
    ...
  }
  for i, a in ipairs(args) do
    args[i] = tostring(a)
  end
  DebugPrint(table.concat(args, ", ") .. "\n")
end
function StartBufferingAfterFence()
  NetStartBufferEvents()
  local q = SyncEventsQueue
  for i = 1, #(q or "") do
    local event_data = q[i]
    netBufferedEvents[#netBufferedEvents + 1] = pack_params(event_data[2], event_data[3], nil, nil)
  end
  table.clear(q)
  NetGameSend("rfnClearHash")
  if IsValidThread(PeriodicRepeatThreads.NetHashThread) then
    DeleteThread(PeriodicRepeatThreads.NetHashThread)
  end
end
function NetSyncEventFence(init_buffer)
  if IsGameReplayRunning() then
    if not g_NetSyncFence then
      g_NetSyncFence = {}
    end
    g_NetSyncFenceWaiting = true
    while not g_NetSyncFence[netUniqueId] do
      WaitMsg(g_NetSyncFence, 100)
    end
    g_NetSyncFenceWaiting = false
    g_NetSyncFence = false
    Msg("ReplayFenceCleared")
    return "replay"
  end
  if GetMapName() == "" then
    return "Not on map"
  end
  if GetGamePause() then
    return "Game paused"
  end
  FenceDebugPrint("FENCE PRE-START", g_NetSyncFence, "netGamePlayers count:", table.count(netGamePlayers), g_NetSyncFenceWaiting)
  if not g_NetSyncFence then
    g_NetSyncFence = {}
  end
  NetSyncEvent("FenceReceived", netUniqueId)
  FenceDebugPrint("FENCE START", g_NetSyncFence)
  local timeout = GetPreciseTicks()
  g_NetSyncFenceWaiting = true
  g_NetSyncFenceInitBuffer = init_buffer or false
  while IsInMultiplayerGame() or not g_NetSyncFence[netUniqueId] do
    if GetPreciseTicks() - timeout > 60000 then
      FenceDebugPrint("NETFENCE TIMEOUT")
      break
    end
    local ok = WaitMsg(g_NetSyncFence, 100)
    if ok then
      FenceDebugPrint("FENCE Msg received")
      break
    end
  end
  g_NetSyncFenceWaiting = false
  g_NetSyncFenceInitBuffer = false
  FenceDebugPrint("FENCE DONE", IsInMultiplayerGame(), GetPreciseTicks() - timeout)
  g_NetSyncFence = false
end
if Platform.developer and false then
  function OnMsg.ClassesGenerate()
    local f = _G.NetSyncEvent
    function _G.NetSyncEvent(event, ...)
      return f(event, ...)
    end
  end
end
if Platform.developer then
  local hashes
  function OnMsg.InitSatelliteView()
    hashes = false
  end
  function OnMsg.ChangeMap()
    hashes = false
  end
  function NetSyncEvents.SatDesync(...)
    if not netDesync then
      hashes = false
      NetSyncEvents.Desync(...)
    end
  end
  function NetEvents.SyncHashesOnSatMap(player_id, time, hash)
    if netDesync then
      return
    end
    hashes = hashes or {}
    hashes[player_id] = hashes[player_id] or {}
    hashes[player_id][time] = hash
    local h1 = hashes[1] and hashes[1][time]
    local h2 = hashes[2] and hashes[2][time]
    if h1 and h2 then
      hashes = false
      if h1 ~= h2 then
        NetSyncEvent("SatDesync", netGameAddress, time, player_id, h1, h2)
      end
    end
  end
  function OnMsg.NewHour()
    if IsInMultiplayerGame() and not netDesync then
      NetEchoEvent("SyncHashesOnSatMap", netUniqueId, Game.CampaignTime, NetGetHashValue())
    end
  end
end
function NetEvents.RemoveClient(id, reason)
  if netUniqueId == id then
    NetLeaveGame(reason or "kicked")
  end
end
function OnSatViewClosed()
  if not gv_SatelliteView then
    return
  end
  gv_SatelliteView = false
  ObjModified("gv_SatelliteView")
  Msg("CloseSatelliteView")
end
function NetSyncEvents.SatelliteViewClosed()
  OnSatViewClosed()
end
if Platform.developer then
  function LaunchAnotherClient(varargs)
    local exec_path = GetExecDirectory() .. "/" .. GetExecName()
    local path = string.format("\"%s\" -no_interactive_asserts -slave_for_mp_testing", exec_path)
    if varargs then
      if type(varargs) == "string" then
        varargs = {varargs}
      end
      for i, v in ipairs(varargs) do
        path = string.format("%s %s", path, v)
      end
    end
    print("os.exec", path)
    os.exec(path)
  end
  local lRunErrFunc = function(func_name, ...)
    local err = _G[func_name](...)
    if err then
      GameTestsPrintf("Function returned an error[" .. func_name .. "]: " .. err)
    end
    return err
  end
  local lDbgHostMultiplayerGame = function()
    return lRunErrFunc("HostMultiplayerGame", "private")
  end
  function lDbgMultiplayerConnect()
    return lRunErrFunc("MultiplayerConnect")
  end
  function HostMpGameAndLaunchAndJoinAnotherClient(test_func_name)
    print("HostMpGameAndLaunchAndJoinAnotherClient...")
    Pause("JoiningClients")
    local err = lDbgMultiplayerConnect()
    err = err or lDbgHostMultiplayerGame()
    if err then
      Resume("JoiningClients")
      return err
    end
    local address = netGameAddress
    local varargs = {
      "-test_mp_game_address=" .. tostring(address)
    }
    if test_func_name then
      table.insert(varargs, "-test_mp_func_name=" .. test_func_name)
    end
    LaunchAnotherClient(varargs)
    print("Waiting for client!")
    local ok = WaitMsg("NetGameLoaded", 90000)
    Resume("JoiningClients")
    if not ok then
      local err = "Timeout waiting for other client to launch/join!"
      print(err)
      return err
    end
  end
  function TestCoopNewGame()
    if not IsRealTimeThread() then
      CreateRealTimeThread(TestCoopNewGame)
      return
    end
    if not g_MPTestSocket then
      local varargs = {
        "-test_mp_dont_auto_quit"
      }
      InitMPTestListener()
      LaunchAnotherClient(varargs)
      if not WaitOtherClientReady() then
        return
      end
    end
    NetGameCall("rfnStopGame")
    DoneGame()
    CloseMPErrors()
    lDbgMultiplayerConnect()
    lDbgHostMultiplayerGame()
    g_MPTestSocket:Send("rfnJoinMeInGame", netGameAddress)
    if not WaitOtherClientReady() then
      return
    end
    ExecCoopStartGame()
  end
  if FirstLoad then
    TestCoopFuncs = {}
    g_MPTestingSlave = false
    g_MPTestingSocketPort = 6666
    g_MPTestListener = false
    g_MPTestSocket = false
  end
  DefineClass.MPTestSocket = {
    __parents = {
      "MessageSocket"
    },
    socket_type = "MPTestSocket"
  }
  function MPTestSocket:CheckHashes()
    CreateRealTimeThread(function()
      local hisHash = self:Call("rfnGiveMeYourHash")
      print("Hashes equal:", NetGetHashValue() == hisHash)
    end)
  end
  function MPTestSocket:rfnGiveMeYourHash()
    return NetGetHashValue()
  end
  function MPTestSocket:rfnQuit()
    quit()
  end
  function MPTestSocket:rfnHandshake()
    print("Handshake received")
    if g_MPTestSocket ~= self then
      if IsValid(g_MPTestSocket) then
        g_MPTestSocket:Send("rfnQuit")
        g_MPTestSocket:delete()
      end
      g_MPTestSocket = self
    end
    if not g_MPTestSocket then
      g_MPTestSocket = self
      g_MPTestSocket:Send("rfnHandshake")
    else
    end
    g_MPTestSocket.master = not g_MPTestingSlave
    g_MPTestSocket.slave = g_MPTestingSlave
  end
  function WaitOtherClientReady()
    local ok, remote_err = WaitMsg("MPTest_OtherClientReady", 90000)
    if not ok then
      print("Timeout waiting for other client to boot")
    end
    return ok and not remote_err
  end
  function MPTestSocket:rfnReady(err)
    if err then
      print("rfnReady", err)
    end
    Msg("MPTest_OtherClientReady", err)
  end
  function MPTestSocket:rfnJoinMeInGame(game_address)
    CreateRealTimeThread(function()
      local err = lDbgMultiplayerConnect()
      err = err or lRunErrFunc("NetJoinGame", nil, game_address)
      if err then
        print("rfnJoinMeInGame", err)
      end
      Sleep(100)
      CloseMPErrors()
      self:Send("rfnReady", err)
    end)
  end
  function MPTestSocket:rfnTest(...)
    print("rfnTest", ...)
  end
  function InitMPTestListener()
    if IsValid(g_MPTestListener) then
      g_MPTestListener:delete()
      g_MPTestListener = false
    end
    g_MPTestListener = BaseSocket:new({
      socket_type = "MPTestSocket"
    })
    local err
    local port_start = g_MPTestingSocketPort
    local port_end = port_start + 100
    for port = port_start, port_end do
      err = g_MPTestListener:Listen("*", port)
      if not err then
        g_MPTestListener.port = port
        break
      elseif err == "address in use" then
        print("InitMPTestListener: Address in use. Trying with another port...")
      else
        print("InitMPTestListener: failed", err)
        g_MPTestListener:delete()
        g_MPTestListener = false
        return false
      end
      Sleep(100)
    end
    print("InitMPTestListener Initialized @ port", g_MPTestListener.port)
    return true
  end
  function MPTestConnectSocket()
    if not IsRealTimeThread() then
      CreateRealTimeThread(MPTestConnectToSlave)
      return
    end
    if IsValid(g_MPTestSocket) then
      g_MPTestSocket:delete()
      g_MPTestSocket = false
    end
    local err
    local port_start = g_MPTestingSocketPort
    local port_end = port_start + 100
    g_MPTestSocket = MPTestSocket:new()
    for port = port_start, port_end do
      err = g_MPTestSocket:WaitConnect(2000, "localhost", port)
      if not err then
        break
      end
      if err == "no connection" then
        print("MPTestConnectSocket: not found on port", port, "trying next")
      else
        print("MPTestConnectSocket: failed", err)
        g_MPTestSocket:delete()
        g_MPTestSocket = false
        return false
      end
      Sleep(100)
    end
    if not err then
      print("MPTestConnectSocket Connected!")
      g_MPTestSocket:Send("rfnHandshake")
      return true
    else
      print("MPTestConnectSocket Failed to connect!")
      return false
    end
  end
  function OnMsg.Start()
    do return end
    local cmd = GetAppCmdLine()
    local is_slave_for_mp_testing = string.match(GetAppCmdLine() or "", "-slave_for_mp_testing")
    if is_slave_for_mp_testing then
      g_MPTestingSlave = true
      CreateRealTimeThread(function()
        WaitMsg("ChangeMapDone")
        print("im a slave", GetAppCmdLine())
        local address_str = string.match(GetAppCmdLine() or "", "-test_mp_game_address=(%S+)")
        local address = tonumber(address_str)
        if address then
          Pause("JoiningClients")
          local err
          err = lDbgMultiplayerConnect()
          err = err or lRunErrFunc("NetJoinGame", nil, address)
          if err then
            Sleep(5000)
            quit()
          end
          WaitMsg("NetGameLoaded")
          Resume("JoiningClients")
        end
        local test_func_name = string.match(GetAppCmdLine() or "", "-test_mp_func_name=(%S+)")
        if test_func_name then
          local func = TestCoopFuncs[test_func_name]
          if not func then
            print("Could not find test func from test_coop_func_name vararg!")
          else
            sprocall(func)
          end
        end
        print("client mp thread done!")
        if g_MPTestSocket then
          g_MPTestSocket:Send("rfnReady")
        end
        local dont_quit = string.match(GetAppCmdLine() or "", "-test_mp_dont_auto_quit")
        if not dont_quit then
          print("Quiting..")
          Sleep(5000)
          quit()
        end
      end)
    end
    if string.match(GetAppCmdLine() or "", "-mp_test_listen") then
      CreateRealTimeThread(InitMPTestListener)
    end
    if string.match(GetAppCmdLine() or "", "-mp_test_connect") then
      CreateRealTimeThread(function()
        Sleep(100)
        MPTestConnectSocket()
      end)
    end
  end
  function GoToMM()
    if not IsRealTimeThread() then
      print("Not in rtt!")
      return
    end
    Sleep(100)
    OpenPreGameMainMenu()
    Sleep(100)
  end
  if FirstLoad then
    TestAllAttacksThreads = {
      KillPopupsThread = false,
      WatchDog = false,
      GameTimeProc = false,
      RealTimeProc = false
    }
  end
  local lKillUIPopups = function()
    Sleep(10)
    DeleteThread(TestAllAttacksThreads.KillPopupsThread)
    TestAllAttacksThreads.KillPopupsThread = CreateRealTimeThread(function()
      while true do
        local dlg = GetDialog("CoopMercsManagement") or GetDialog("PopupNotification")
        if dlg then
          dlg:Close()
        end
        Sleep(200)
      end
    end)
  end
  local lTestDone = function()
    NetLeaveGame()
    NetDisconnect()
    Sleep(500)
    CloseMPErrors()
    print("HostStartAllAttacksCoopTest done")
  end
  local lHostWatchDog = function()
    if IsValidThread(TestAllAttacksThreads.WatchDog) then
      DeleteThread(TestAllAttacksThreads.WatchDog)
    end
    TestAllAttacksThreads.WatchDog = CreateRealTimeThread(function()
      while TestAllAttacksTestRunning do
        if netDesync then
          GameTestsError("Test desynced!")
          break
        end
        if table.count(netGamePlayers) ~= 2 then
          GameTestsError("Client player left before test was done!")
          break
        end
        Sleep(250)
      end
      while IsChangingMap() do
        WaitMsg("ChangeMapDone")
      end
      DeleteThread(TestAllAttacksThreads.KillPopupsThread)
      DeleteThread(TestAllAttacksThreads.RealTimeProc)
      DeleteThread(TestAllAttacksThreads.GameTimeProc)
      lTestDone()
    end)
  end
  function HostStartAllAttacksCoopTest()
    for k, v in pairs(TestAllAttacksThreads) do
      DeleteThread(v)
      TestAllAttacksThreads[k] = false
    end
    if not IsRealTimeThread() then
      CreateRealTimeThread(HostStartAllAttacksCoopTest)
      return
    end
    local err
    GameTestsNightly_AllAttacks(function()
      err = HostMpGameAndLaunchAndJoinAnotherClient("TestAllAttacksClientSideFunc")
      if err then
        GameTestsError("HostMpGameAndLaunchAndJoinAnotherClient returned and error: " .. err)
        return err
      end
      lKillUIPopups()
      lHostWatchDog()
    end)
    lTestDone()
  end
  function TestCoopFuncs.TestAllAttacksClientSideFunc()
    lKillUIPopups()
    while not TestAllAttacksThreads.GameTimeProc do
      Sleep(10)
    end
    while TestAllAttacksThreads.GameTimeProc do
      if netDesync or table.count(netGamePlayers) ~= 2 then
        print("netDesync", netDesync)
        print("table.count(netGamePlayers)", table.count(netGamePlayers))
        return
      end
      Sleep(250)
    end
  end
end
function OnMsg.NetGameLeft(reason)
  if PauseReasons.net then
    Resume("net")
  end
end
function NetSyncEvents.tst()
  ResetVoxelStealthParamsCache()
end
function NetGossip(gossip, ...)
  if gossip and netAllowGossip and GetAccountStorageOptionValue("AnalyticsEnabled") == "On" then
    return NetSend("rfnGossip", gossip, ...)
  end
end
function OnMsg.GameOptionsChanged()
  CreateRealTimeThread(function()
    if GetAccountStorageOptionValue("AnalyticsEnabled") == "On" then
      if not NetIsConnected() then
        local err = MultiplayerConnect()
        if err then
        end
      end
    elseif not netInGame and NetIsConnected() then
      NetForceDisconnect("analytics")
    end
  end)
end
function TryConnectToServer()
  if Platform.cmdline then
    return
  end
  g_TryConnectToServerThread = g_TryConnectToServerThread or CreateRealTimeThread(function()
    WaitInitialDlcLoad()
    while not AccountStorage do
      WaitMsg("AccountStorageChanged")
    end
    if Platform.xbox then
      WaitMsg("XboxUserSignedIn")
    end
    local wait = 60000
    while config.SwarmConnect do
      if not NetIsConnected() and GetAccountStorageOptionValue("AnalyticsEnabled") == "On" then
        local err, auth_provider, auth_provider_data, display_name = NetGetProviderLogin(false)
        if err then
          err, auth_provider, auth_provider_data, display_name = NetGetAutoLogin()
        end
        err = err or NetConnect(config.SwarmHost, config.SwarmPort, auth_provider, auth_provider_data, display_name, config.NetCheckUpdates, "netClient")
        if err == "failed" or err == "version" then
          return
        end
        if not err and config.SwarmConnect == "ping" or err == "bye" then
          NetDisconnect("netClient")
          return
        end
        wait = wait * 2
        if err == "maintenance" or err == "not ready" then
          wait = 300000
        end
      end
      if NetIsConnected() then
        wait = 60000
        if config.SwarmConnect == "ping" then
          NetDisconnect("netClient")
          return
        end
        WaitMsg("NetDisconnect")
      end
      Sleep(wait)
    end
  end)
end
function NetSyncEvents.NewMapLoaded(map, net_hash, map_random, seed_text)
end
function OnMsg.PostNewMapLoaded()
  FireNetSyncEventOnHost("NewMapLoaded", CurrentMap, mapdata.NetHash, MapLoadRandom, Game and Game.seed_text)
end
