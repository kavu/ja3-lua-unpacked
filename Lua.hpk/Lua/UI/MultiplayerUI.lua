local ADDRESS = 1
local NAME = 2
local VISIBLE = 3
local PLAYERS = 4
local MAX_PLAYERS = 5
local INFO = 6
function OnMsg.NetPlayerMessage(name, player_name, player_id, msg, other)
end
function RefreshMercSelection()
  local sel = Selection
  for i = #sel, 1, -1 do
    local obj = sel[i]
    if IsKindOf(obj, "Unit") and not obj:IsLocalPlayerControlled() then
      SelectionRemove(obj)
    end
  end
  if #sel <= 0 then
    if g_Combat then
      g_Combat:NextUnit(false, true)
    else
      local dlg = GetInGameInterfaceModeDlg()
      if IsKindOf(dlg, "IModeExploration") then
        dlg:NextUnit()
      end
    end
  end
  if SelectedObj and IsKindOf(SelectedObj, "Unit") and g_Combat then
    local igi = GetInGameInterfaceModeDlg()
    if IsKindOf(igi, "IModeCombatMovement") and igi.window_state ~= "destroying" then
      igi:SetAttacker(SelectedObj)
    end
    ObjModified(SelectedObj)
  end
end
if FirstLoad then
  CloseCoopMercsManagement_watchdog = false
end
function OnMsg.NetGameLoaded()
  RefreshMercSelection()
end
function NetEvents.CloseCoopMercsManagement()
  local TryClose = function()
    local dlg = GetDialog("CoopMercsManagement")
    if dlg then
      dlg:Close()
      RefreshMercSelection()
      return true
    end
    return false
  end
  if not TryClose() then
    CloseCoopMercsManagement_watchdog = CreateRealTimeThread(function()
      for i = 1, 30 do
        Sleep(50)
        if TryClose() then
          CloseCoopMercsManagement_watchdog = false
          return
        end
      end
      CloseCoopMercsManagement_watchdog = false
    end)
  end
end
local lOpenCoOpManagementDialog = function()
  local coOpControl = GetDialog("CoopMercsManagement")
  if not coOpControl then
    CloseDialog("PDADialog")
    CloseDialog("ModifyWeaponDlg")
    CloseDialog("FullscreenGameDialogs")
    local popupHost = GetDialog("PDADialogSatellite")
    popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")
    OpenDialog("CoopMercsManagement", popupHost or GetInGameInterface())
  end
end
function NetSyncEvents.OpenCoopMercsManagement()
  if IsValidThread(CloseCoopMercsManagement_watchdog) then
    DeleteThread(CloseCoopMercsManagement_watchdog)
    CloseCoopMercsManagement_watchdog = false
  end
  lOpenCoOpManagementDialog()
end
local function lOpenCoOpSquadControlWhenGameTimeStarts()
  if not GameState.entered_sector then
    local g = Game
    CreateRealTimeThread(function()
      WaitMsg("EnterSector")
      if g ~= Game then
        return
      end
      lOpenCoOpSquadControlWhenGameTimeStarts()
    end)
    return
  end
  if not IsCoOpGame() then
    return
  end
  CreateGameTimeThread(function()
    local dlg = GetLoadingScreenDialog()
    while dlg do
      WaitMsg(dlg, 1000)
      dlg = GetLoadingScreenDialog()
    end
    dlg = GetDialog("XSetpieceDlg")
    while dlg do
      WaitMsg("SetpieceEnded", 1000)
      dlg = GetDialog("XSetpieceDlg")
    end
    WaitAllOtherThreads()
    if mapdata.GameLogic and HasGameSession() and IsCoOpGame() and CountCoopUnits(2) <= 0 then
      lOpenCoOpManagementDialog()
    end
  end)
end
OnMsg.NetGameLoaded = lOpenCoOpSquadControlWhenGameTimeStarts
function MultiplayerFillGames(ui, filterType)
  if not ui then
    return
  end
  filterType = filterType or ui:ResolveId("idSubMenu") and ui:ResolveId("idSubMenu").context and ui:ResolveId("idSubMenu").context.filter_type
  local msg = CreateUnclickableMessagePrompt(T(908809691453, "Multiplayer"), T(598836447701, "Updating game list..."))
  local err, available = NetCall("rfnSearchGames", "coop", nil, filterType and filterType == "friends" and "only")
  if err then
    ShowMPLobbyError(false, err)
    return err
  end
  msg:Close()
  local list_dlg = ui:ResolveId("idSubContent")
  if not list_dlg then
    return
  end
  local context = list_dlg:GetContext()
  local filtered = {}
  for _, gameInfo in ipairs(available or empty_table) do
    if gameInfo[ADDRESS] ~= netGameAddress and gameInfo[VISIBLE] == "public" and gameInfo[PLAYERS] < gameInfo[MAX_PLAYERS] and gameInfo[PLAYERS] ~= 0 and not gameInfo[INFO].private then
      local hostId = gameInfo[INFO]
      hostId = hostId and hostId.host_id
      local playstation_cross_platform = Platform.playstation ~= (gameInfo[INFO].platform and gameInfo[INFO].platform.playstation)
      if hostId and hostId ~= netAccountId and (Platform.developer or not playstation_cross_platform) then
        if playstation_cross_platform then
          gameInfo[NAME] = "[DEBUG - PS XPLAY] " .. gameInfo[NAME]
        end
        if filterType == "no_mods" and not next(gameInfo[INFO].mods) then
          table.insert(filtered, gameInfo)
        elseif filterType == "mods" and next(gameInfo[INFO].mods) then
          table.insert(filtered, gameInfo)
        elseif filterType ~= "mods" and filterType ~= "no_mods" then
          table.insert(filtered, gameInfo)
        end
      end
    end
  end
  local new_context = {
    available_games = filtered,
    invited_player = false,
    invited_player_id = false,
    multiplayer_invite = false,
    filter_type = filterType or "all"
  }
  ui:ResolveId("idSubMenu"):ResolveId("idScrollArea"):RespawnContent()
  list_dlg:SetContext(new_context)
  local menu = ui:ResolveId("idSubMenu")
  menu:SetContext(new_context)
  local filterField = menu:ResolveId("idScrollArea") and menu:ResolveId("idScrollArea"):ResolveId("idFilterName")
  if filterField then
    local nameT = MultiplayerGameFiltersList[new_context.filter_type] and MultiplayerGameFiltersList[new_context.filter_type].Name
    filterField:SetName(T({
      383256091724,
      "Filter: <name>",
      name = nameT
    }))
  end
  if not next(filtered) and GetUIStyleGamepad() then
    local list = ui:ResolveId("idMainMenuButtonsContent"):ResolveId("idList")
    local currSelIdx = list:GetSelection() and list:GetSelection()[1] or -1
    if list:GetFirstValidItemIdx() ~= currSelIdx then
      list:SelectFirstValidItem()
    end
  end
end
function CreateUnclickableMessagePrompt(title, message)
  local msg = ZuluMessageDialog:new({
    actions = empty_table
  }, terminal.desktop, {
    title = title,
    text = message,
    obj = "mp-error"
  })
  msg:Open()
  return msg
end
function CreateLateListMessageBox()
  local actions = {}
  actions[#actions + 1] = XAction:new({
    ActionId = "idOpenGame",
    ActionName = T(288784847013, "Host public"),
    ActionShortcut = "Enter",
    ActionGamepad = "ButtonA",
    ActionToolbar = "ActionBar",
    OnAction = function(self, host, source)
      host:Close("open")
      return "break"
    end
  })
  actions[#actions + 1] = XAction:new({
    ActionId = "idInvite",
    ActionName = T(471606302283, "Host private"),
    ActionShortcut = "I",
    ActionGamepad = "ButtonY",
    ActionToolbar = "ActionBar",
    OnAction = function(self, host, source)
      host:Close("invite")
      return "break"
    end
  })
  actions[#actions + 1] = XAction:new({
    ActionId = "idCancel",
    ActionName = T(6879, "Cancel"),
    ActionShortcut = "Escape",
    ActionGamepad = "ButtonB",
    ActionToolbar = "ActionBar",
    OnAction = function(self, host, source)
      host:Close("close")
      return "break"
    end
  })
  local msg = ZuluMessageDialog:new({actions = actions}, terminal.desktop, {
    title = T(245562128624, "CO-OP LOBBY"),
    text = T(311338163398, "Other players may join your ongoing game. Do you want to host a public or private game?"),
    obj = "mp-error"
  })
  msg:Open()
  return msg
end
function CloseMessageBoxesOfType(objString, response)
  for dlg, _ in pairs(g_OpenMessageBoxes) do
    if dlg and dlg.window_state == "open" then
      local msgObj = dlg.context.obj
      local tp = type(objString)
      if tp == "string" and msgObj == objString or tp == "table" and table.find(objString, msgObj) then
        dlg:Close(response)
      end
    end
  end
end
function FindMessageBoxOfType(objString)
  for dlg, _ in pairs(g_OpenMessageBoxes) do
    if dlg and dlg.window_state == "open" then
      local msgObj = dlg.context.obj
      local tp = type(objString)
      if tp == "string" and msgObj == objString or tp == "table" and table.find(objString, msgObj) then
        return true
      end
    end
  end
  return false
end
function CloseMPErrors()
  CloseInvites()
  CloseMessageBoxesOfType({
    "mp-error",
    "leave-notify",
    "joining-game"
  }, "close")
end
function ShowMPLobbyError(context, err)
  CloseMPErrors()
  local parent = GetDialog("PDADialog") and GetDialog("PDADialog"):ResolveId("idDisplayPopupHost") or terminal.desktop
  local msg
  if context == "join" then
    msg = CreateMessageBox(parent, T(634182240966, "Error"), T({
      858607081078,
      "Could not join game. Reason: <MPError(err)>",
      err = err
    }), T(325411474155, "OK"))
  elseif context == "invite" then
    msg = CreateMessageBox(parent, T(634182240966, "Error"), T({
      192164122130,
      "Could not invite player. Reason: <MPError(err)>",
      err = err
    }), T(325411474155, "OK"))
  elseif context == "connect" then
    msg = CreateMessageBox(parent, T(634182240966, "Error"), T({
      918383291777,
      "Could not connect to the server! Reason: <MPError(err)>",
      err = err
    }), T(325411474155, "OK"))
  elseif context == "disconnected" then
    msg = CreateMessageBox(parent, T(634182240966, "Error"), T({
      789332217909,
      "Lost connection to multiplayer server.",
      err = err
    }), T(325411474155, "OK"))
  elseif context == "busy" then
    msg = CreateMessageBox(parent, T(634182240966, "Error"), T(493609285611, "Player is busy."), T(325411474155, "OK"))
  elseif context == "mods" then
    msg = CreateMessageBox(parent, T(634182240966, "Error"), T({
      349914917388,
      "<ModsError(err)>",
      err = err
    }), T(325411474155, "OK"))
  else
    msg = CreateMessageBox(parent, T(634182240966, "Error"), T({
      141784216225,
      "Error: <MPError(err)>",
      err = err
    }), T(325411474155, "OK"))
  end
  msg.obj = "mp-error"
  return msg
end
local NetworkErrorsT = {
  ["game full"] = T(366423230585, "Game is full"),
  ["not found"] = T(506175657595, "Game not found"),
  disconnected = T(321476715550, "Disconnected from server"),
  rejected = T(513425499490, "Rejected"),
  ["game not found"] = T(506175657595, "Game not found"),
  restricted = T(766750482132, "Account restricted"),
  banned = T(456051298754, "Banned"),
  ["steam-auth"] = T(481937697290, "Authentication failed"),
  ["gog-auth"] = T(481937697290, "Authentication failed"),
  ["epic-auth"] = T(481937697290, "Authentication failed"),
  ["unknown-auth"] = T(481937697290, "Authentication failed"),
  ["no account"] = T(481937697290, "Authentication failed"),
  ["invalid code"] = T(138404081301, "Invalid code"),
  ["no code"] = T(209543574847, "No code"),
  ["no words"] = T(746887802931, "Could not fetch valid codes"),
  ["invalid id"] = T(542223789460, "Invalid ID"),
  ["incomplete game data"] = T(991087359493, "Incomplete game data"),
  ["host not found"] = T(966517041398, "Host not found")
}
function TFormat.MPError(ctx, err)
  local translatedT = NetworkErrorsT[err]
  return translatedT or Untranslated(err)
end
function TFormat.ModsError(ctx, err)
  local missingMods = err[1]
  local unusedMods = err[2]
  local missingModsT = {}
  local unusedModsT = {}
  for count, mod in ipairs(missingMods) do
    if count < 10 then
      table.insert(missingModsT, mod.title)
    else
      table.insert(missingModsT, "...")
      break
    end
  end
  for count, mod in ipairs(unusedMods) do
    if count < 10 then
      table.insert(unusedModsT, mod.title)
    else
      table.insert(unusedModsT, "...")
      break
    end
  end
  local missingTitles, unusedTitles
  if next(missingMods) then
    missingTitles = T({
      433171451152,
      [[
To enter this game you need to install the following mods:
<color 130 128 120><missingModsTitles></color>
]],
      missingModsTitles = Untranslated(table.concat(missingModsT, "\n"))
    })
  end
  if next(unusedMods) then
    unusedTitles = T({
      700577652991,
      [[
To enter this game you need to disable the following mods:
<color 130 128 120><unusedModsTitles></color>
]],
      unusedModsTitles = Untranslated(table.concat(unusedModsT, "\n"))
    })
  end
  return T({
    410568555900,
    "<missingMods><unusedText>",
    missingMods = missingTitles or "",
    unusedText = unusedTitles or ""
  })
end
function GetMultiplayerLobbyDialog(skip_mode_check)
  local dlg = GetDialog("InGameMenu") or GetDialog("PreGameMenu")
  if skip_mode_check then
    return dlg
  end
  local subMenu = dlg and dlg.idSubMenu
  if not subMenu then
    return false
  end
  return subMenu:ResolveId("idMultiplayer") and dlg or false
end
function MultiplayerLobbySetUI(mode, param)
  if not CanYield() then
    CreateRealTimeThread(MultiplayerLobbySetUI, mode, param)
    return
  end
  local ui = GetMultiplayerLobbyDialog(true)
  if not ui then
    return
  end
  if mode ~= "empty" then
    local err = PlatformCheckMultiplayerRequirements()
    if err then
      return
    end
  end
  if not NetIsConnected() and mode ~= "empty" then
    local msg = CreateUnclickableMessagePrompt(T(908809691453, "Multiplayer"), T(994790984817, "Connecting..."))
    local err, results = MultiplayerConnect()
    if err then
      ShowMPLobbyError("connect", err)
      mode = "empty"
    else
      msg:Close()
    end
  end
  if ui.Mode == "" and mode ~= "empty" then
    ui:SetMode("Multiplayer")
  elseif mode == "empty" then
    ui:SetMode("")
  end
  if ui:ResolveId("idSubContent").Mode ~= mode then
    ui:ResolveId("idSubContent"):SetMode(mode, param)
  end
  local buttonMode = {
    multiplayer_host = "multiplayer_host",
    multiplayer_guest = "multiplayer_host",
    multiplayer = "multiplayer_games",
    empty = "mm"
  }
  local curButtonMode = buttonMode[mode]
  ui:ResolveId("idMainMenuButtonsContent"):SetMode(curButtonMode, param)
  local titles = {
    multiplayer_host = T(245562128624, "CO-OP LOBBY"),
    multiplayer_guest = T(245562128624, "CO-OP LOBBY"),
    multiplayer = T(139802124389, "MULTIPLAYER"),
    empty = ""
  }
  local curTitle = titles[mode]
  ui:ResolveId("idSubMenuTittle"):SetText(curTitle)
  if mode == "multiplayer" then
    NewGameObj = false
    NetLeaveGame()
    CreateRealTimeThread(MultiplayerFillGames, ui, "all")
  elseif mode == "empty" and (not Game or param == "unlist") then
    NetLeaveGame("ui_closed")
  end
end
function UIHostGame()
  if not CanYield() then
    CreateRealTimeThread(UIHostGame)
    return
  end
  local dlg = OpenDialog("MultiplayerHostQuestion")
  dlg:SetModal()
  dlg:SetDrawOnTop(true)
  local res = dlg:Wait()
  if not res then
    return
  end
  NewGameObj = false
  local err = HostMultiplayerGame(res)
  if err then
    ShowMPLobbyError(false, err)
    return
  end
  MultiplayerLobbySetUI("multiplayer_host", res)
end
function UIJoinGame(game, direct)
  if not CanYield() then
    CreateRealTimeThread(UIJoinGame, game, direct)
    return
  end
  local gameId = game and game[1]
  if not gameId then
    return
  end
  local ui = GetMultiplayerLobbyDialog()
  if not direct and not ui then
    return
  end
  local err = TryNetJoinGame(gameId)
  if err then
    if not direct then
      MultiplayerFillGames(ui)
    end
    ShowMPLobbyError("join", err)
    return
  end
end
function OnMsg.NetPlayerJoin(info)
  local ui = GetMultiplayerLobbyDialog()
  ui = ui and ui.idSubMenu
  local playerId = info.account_id
  if not playerId then
    return
  end
  local context
  if ui and not Game then
    context = ui.context
    context.invited_player = info.name
    context.invited_player_id = playerId
    context.multiplayer_invite = "accepted"
    ui:SetContext(context, true)
  end
  CreateRealTimeThread(function()
    local err = NetCall("rfnPlayerMessage", playerId, "lobby-info", {
      start_info = NewGameObj,
      host_ready = context and context.host_ready,
      no_menu = not ui
    })
    if err then
      ShowMPLobbyError(false, err)
      return
    end
  end)
end
local lPreventNetPause = function()
  if NetPause and (not netInGame or table.count(netGamePlayers) <= 1) then
    PauseReasons = {}
    NetSetPause(false)
  end
end
function OnMsg.PreGameMenuOpen()
  NetLeaveGame("main menu")
  lPreventNetPause()
end
local was_client = false
function OnMsg.ChangeMap()
  was_client = netInGame and netUniqueId ~= 1
end
function OnMsg.NetDisconnect(reason)
  if reason == "ui_closed" or reason == "analytics" then
    return
  end
  local msg = ShowMPLobbyError("disconnected")
  MultiplayerLobbySetUI("empty")
  if was_client then
    CreateRealTimeThread(function()
      if msg then
        WaitMsg(msg)
      end
      if not GetDialog("PreGameMenu") then
        OpenPreGameMainMenu()
      end
    end)
  end
end
function NotifyPlayerLeft(player, reason)
  if not CanYield() then
    CreateRealTimeThread(NotifyPlayerLeft, player, reason)
    return
  end
  if IsChangingMap() then
    WaitMsg("ChangeMapDone")
  end
  WaitLoadingScreenClose()
  CloseMessageBoxesOfType("leave-notify", "close")
  local hostLeft = false
  local leave_notify_obj = "leave-notify"
  if NetIsHost(player.id) then
    hostLeft = true
    NetLeaveGame("host left")
    if not GetDialog("PreGameMenu") then
      local msg = CreateMessageBox(nil, T(687826475879, "Co-Op Lobby"), T({
        707106868307,
        "Game host - <u(name)> left the game. Returning to main menu.",
        name = player.name
      }), T(325411474155, "OK"), leave_notify_obj)
      msg:Wait()
      OpenPreGameMainMenu()
      return
    else
      CreateMessageBox(nil, T(687826475879, "Co-Op Lobby"), T({
        372566450268,
        "Game host - <u(name)> left the lobby.",
        name = player.name
      }), T(325411474155, "OK"), leave_notify_obj)
    end
  else
    CreateMessageBox(nil, T(687826475879, "Co-Op Lobby"), T({
      479640131817,
      "<u(name)> left",
      name = player.name
    }), T(325411474155, "OK"), leave_notify_obj)
    if NetPause and (not netInGame or table.count(netGamePlayers) <= 1) and not next(PauseReasons) then
      NetSetPause(false)
    end
  end
  local ui = GetMultiplayerLobbyDialog()
  ui = ui and ui.idSubMenu
  if ui then
    local context = ui.context
    context.invited_player = false
    context.invited_player_id = false
    context.multiplayer_invite = false
    ui:SetContext(context, true)
  end
  if hostLeft then
    MultiplayerLobbySetUI("multiplayer")
  end
end
OnMsg.NetPlayerLeft = NotifyPlayerLeft
local lReceiveLobbyInfo = function(name, player_id, msg, other)
  if not netInGame then
    return
  end
  NewGameObj = table.copy(other.start_info, "deep")
  if other.no_menu then
    return
  end
  local multiplayerAbleUI = GetMultiplayerLobbyDialog(true)
  local multiplayerUI = GetMultiplayerLobbyDialog()
  if multiplayerAbleUI then
    MultiplayerLobbySetUI("multiplayer_guest")
  end
  WaitAllOtherThreads()
  local ui = GetMultiplayerLobbyDialog()
  local idSubMenu = ui and ui.idSubMenu
  if not idSubMenu then
    return
  end
  local context = idSubMenu.context or {}
  context.invited_player = name
  context.invited_player_id = player_id
  context.host_ready = other.host_ready or false
  idSubMenu:SetContext(context, true)
  if not other.no_scroll and GetUIStyleGamepad() then
    CreateRealTimeThread(function(idSubMenu)
      idSubMenu.idScrollArea:SelectFirstValidItem()
    end, idSubMenu)
  end
end
function OnMsg.NetPlayerMessage(randomTableIdk, player_name, player_id, msg, other)
  if msg ~= "lobby-info" then
    return
  end
  CreateRealTimeThread(lReceiveLobbyInfo, player_name, player_id, msg, other)
end
function UICanStartGame()
  local ui = GetMultiplayerLobbyDialog()
  ui = ui and ui.idSubMenu
  if not ui then
    return false
  end
  local context = ui.context
  if not context then
    return false
  end
  local hasOtherPlayer = context.invited_player_id
  if hasOtherPlayer then
    local otherPlayerReady = context.multiplayer_invite == "ready"
    return context.host_ready and otherPlayerReady
  end
  return true
end
if FirstLoad then
  g_FirstNetStart = false
end
function ExecCoopStartGame()
  g_FirstNetStart = true
  StartCampaign(GetCurrentCampaignPreset(), NewGameObj)
  g_FirstNetStart = false
  StartHostedGame("CoOp", GatherSessionData():str())
end
function UIStartGame()
  if not CanYield() then
    CreateRealTimeThread(UIStartGame)
    return
  end
  local ui = GetMultiplayerLobbyDialog()
  ui = ui and ui.idSubMenu
  if not ui then
    return
  end
  if not UICanStartGame() then
    return
  end
  NetSend("rfnPlayerMessage", ui.context.invited_player_id, "starting_game")
  ExecCoopStartGame()
end
function OnMsg.NetPlayerMessage(name, player_name, player_id, msg)
  if not msg then
    return
  end
  if msg ~= "starting_game" then
    return
  end
  local msg = CreateUnclickableMessagePrompt(T(687826475879, "Co-Op Lobby"), T(953960332662, "Starting game..."))
  msg:CreateThread("check-for-loading", function()
    while msg.window_state ~= "destroying" do
      local anyLoadingScreen = GetLoadingScreenDialog()
      if anyLoadingScreen or GameState.gameplay then
        msg:Close()
        return
      end
      WaitMsg("GameStateChanged", 100)
    end
  end)
end
function UIHostReady(ready)
  local ui = GetMultiplayerLobbyDialog()
  ui = ui and ui.idSubMenu
  if not ui then
    return
  end
  if not netInGame or not NetIsHost() then
    return
  end
  local context = ui.context
  context.host_ready = ready
  ui:SetContext(context, true)
  if GetUIStyleGamepad() then
    ObjModified("GamepadUIStyleChanged")
  end
  if context.invited_player_id then
    NetSend("rfnPlayerMessage", context.invited_player_id, "host_ready", ready)
  end
end
function OnMsg.NetPlayerMessage(name, player_name, player_id, msg, readyState)
  if not msg then
    return
  end
  if msg ~= "guest_ready" and msg ~= "host_ready" then
    return
  end
  local ui = GetMultiplayerLobbyDialog()
  ui = ui and ui.idSubMenu
  if not ui then
    return
  end
  local context = ui.context
  if msg == "guest_ready" then
    CloseDialog("MultiplayerInvitePlayers")
    context.multiplayer_invite = readyState and "ready" or "accepted"
    ui:SetContext(context, true)
  elseif msg == "host_ready" then
    context.host_ready = readyState
    ui:SetContext(context, true)
    ObjModified("host_ready")
  end
end
function UICancelInvite()
  if not CanYield() then
    CreateRealTimeThread(UICancelInvite)
    return
  end
  local ui = GetMultiplayerLobbyDialog()
  ui = ui and ui.idSubMenu
  if not ui then
    return
  end
  local context = ui.context
  NetSend("rfnPlayerMessage", context.invited_player_id, "cancel_invite")
  context.invited_player = false
  context.invited_player_id = false
  context.multiplayer_invite = false
  ui:SetContext(context, true)
end
function OnMsg.NetPlayerMessage(someTableIdk, player_name, player_id, msg, gameId)
  if not msg then
    return
  end
  if msg ~= "cancel_invite" and msg ~= "cancel_invite_busy" then
    return
  end
  local ui = GetMultiplayerLobbyDialog()
  ui = ui and ui.idSubMenu
  if not ui then
    return
  end
  local context = ui.context
  if not context then
    return
  end
  CloseInvites()
  context.invited_player = false
  context.invited_player_id = false
  context.multiplayer_invite = false
  ui:SetContext(context, true)
  if msg == "cancel_invite_busy" then
    ShowMPLobbyError("busy")
  end
end
function CloseInvites()
  CloseDialog("MultiplayerInvitePlayers")
  CloseMessageBoxesOfType("invite", "cancel")
end
function UIReceiveInvite(name, host_id, game_id, gameType, gameName)
  if not CanYield() then
    CreateRealTimeThread(UIReceiveInvite, name, host_id, game_id, gameType, gameName)
    return
  end
  if FindMessageBoxOfType("joining-game") then
    NetCall("rfnPlayerMessage", host_id, "cancel_invite_busy", game_id)
    return
  end
  CloseInvites()
  if not g_dbgFasterNetJoin and Game then
    local gameTypePreset = MultiplayerGameTypes[gameType]
    local gameTypeName = gameTypePreset and gameTypePreset.Name or Untranslated(gameType)
    local text = T({
      642324815808,
      "Are you sure you would like to join <u(name)>'s <gameType> multiplayer game?",
      name = name,
      gameType = gameTypeName
    })
    text = text .. T(612286933019, "<newline>Unsaved game progress will be lost.")
    local res = WaitQuestion(terminal.desktop, T(127683166549, "Invite"), text, T(689884995409, "Yes"), T(782927325160, "No"), "invite")
    if res == "cancel" then
      NetCall("rfnPlayerMessage", host_id, "cancel_invite", game_id)
      return
    end
  end
  if Game then
    OpenPreGameMainMenu()
  end
  local err = TryNetJoinGame(game_id, host_id, gameName)
  if err then
    local ui = GetMultiplayerLobbyDialog()
    ui = ui and ui.idSubMenu
    if ui then
      MultiplayerFillGames(ui)
    end
    ShowMPLobbyError(false, err)
    return
  end
end
OnMsg.GameInvite = UIReceiveInvite
function GetGameInfo(game_id, game_name)
  if not game_id then
    return "no game specified"
  end
  local err, allGames = NetCall("rfnSearchGames", "coop", game_name, true)
  if err then
    return err
  end
  local gameInfo = false
  for i, gData in ipairs(allGames) do
    if gData[ADDRESS] == game_id then
      gameInfo = gData
    end
  end
  if not gameInfo then
    return "game not found"
  end
  gameInfo = gameInfo[INFO]
  if not gameInfo then
    return "incomplete game data"
  end
  return false, gameInfo
end
function GetNetGameJoinCode(id)
  local words = GetEnglishNounsTable()
  if not words or not next(words) then
    return false, "no words"
  end
  id = id or netGameAddress
  if not id or id <= 0 then
    return false, "invalid id"
  end
  local wordsZeroIndexed = #words - 1
  local leftOver = id
  local code = {}
  while 0 < leftOver do
    local index = leftOver % #words
    code[#code + 1] = words[index + 1]
    leftOver = leftOver / #words
  end
  return table.concat(code, " ")
end
function GetGameIdFromJoinCode(code)
  if not code or #code == 0 then
    return false, "no code"
  end
  local words = GetEnglishNounsTable()
  if not words or not next(words) then
    return false, "no words"
  end
  local codeParts = string.split(code, " ")
  local codeIndices = {}
  for i, c in ipairs(codeParts) do
    if not c then
      return false, "invalid code"
    end
    local index = table.find(words, string.upper(c))
    if not index then
      return false, "invalid code"
    end
    codeIndices[#codeIndices + 1] = index - 1
  end
  local gameIdReconstructed = 0
  for i = #codeIndices, 1, -1 do
    gameIdReconstructed = gameIdReconstructed * #words + codeIndices[i]
  end
  return gameIdReconstructed
end
function UIJoinGameByJoinCode(code)
  if not CanYield() then
    CreateRealTimeThread(UIJoinGameByJoinCode, code)
    return
  end
  local gameId, err = GetGameIdFromJoinCode(code)
  if err then
    ShowMPLobbyError("join", err)
    return
  end
  if not NetIsConnected() then
    local msg = CreateUnclickableMessagePrompt(T(908809691453, "Multiplayer"), T(994790984817, "Connecting..."))
    local err, results = MultiplayerConnect()
    if err then
      ShowMPLobbyError("connect", err)
      return
    else
      msg:Close()
    end
  end
  local err = TryNetJoinGame(gameId)
  if err then
    local ui = GetMultiplayerLobbyDialog()
    ui = ui and ui.idSubMenu
    if ui then
      MultiplayerFillGames(ui)
    end
    ShowMPLobbyError(false, err)
  end
end
function TryNetJoinGame(game_id, host_id, game_name)
  local msg = CreateMessageBox(terminal.desktop, T(687826475879, "Co-Op Lobby"), T(138349749027, "Joining game..."), T(6879, "Cancel"), "joining-game")
  if not host_id then
    local err, gameInfo = GetGameInfo(game_id, game_name)
    if err then
      return err
    end
    host_id = gameInfo and gameInfo.host_id
  end
  if not host_id then
    return "host not found"
  end
  local err = NetSend("rfnPlayerMessage", host_id, "request_join", game_id, game_name)
  if err then
    return err
  end
  local result = msg:Wait()
  if result == "rejected" then
    return "rejected"
  elseif result == "ok" then
    return NetSend("rfnPlayerMessage", host_id, "request_cancel", game_id)
  end
end
function HandleJoinRequestMessageProc(someTableIdk, player_name, player_id, msg, gameId, gameName)
  if ChangingMap then
    WaitChangeMapDone()
    Sleep(200)
  end
  WaitPlayerControl({no_coop_pause = true})
  while terminal.desktop.modal_window ~= terminal.desktop do
    WaitNextFrame()
  end
  if msg == "request_join" and Game and not g_dbgFasterNetJoin then
    local res = WaitQuestion(terminal.desktop, T(687826475879, "Co-Op Lobby"), T({
      242614432594,
      "<u(name)> would like to join your game. Play together?",
      name = player_name
    }), T(689884995409, "Yes"), T(782927325160, "No"), "invite")
    WaitPlayerControl({no_coop_pause = true})
    while not CanSaveGame({
      autosave_id = "combatStart"
    }) do
      WaitNextFrame()
    end
    if res == "cancel" then
      return NetCall("rfnPlayerMessage", player_id, "request_rejected")
    end
  end
  if msg == "request_join" then
    return NetSend("rfnPlayerMessage", player_id, "request_approved", gameId, gameName)
  end
  if msg == "request_approved" then
    local err, info = GetGameInfo(gameId, gameName)
    if err then
      return err
    end
    local dlcs = info.dlcs
    if dlcs then
      for i, d in ipairs(dlcs) do
        if not IsDlcAvailable(d) then
          return T({
            270767785964,
            "Missing dlc: <dlc>",
            dlc = tostring(d)
          })
        end
      end
    end
    local myDlcs = GetAvailableDlcList()
    local allPresent = false
    for i, d in ipairs(myDlcs) do
      local hasTheDlc = table.find(info.dlcs, d)
      if not hasTheDlc then
        return T({
          813744621008,
          "Host doesn't have dlc: <dlc>",
          dlc = tostring(d)
        })
      end
    end
    local missingMods = {}
    local unusedMods = {}
    local requiredMods = info.mods
    local myMods = g_ModsUIContextObj or ModsUIObjectCreateAndLoad()
    while not g_ModsUIContextObj or not g_ModsUIContextObj.installed_retrieved do
      Sleep(100)
    end
    local myEnabledMods = {}
    for mod, enabled in pairs(myMods.enabled) do
      if enabled then
        local modDef = myMods.mod_defs[mod]
        local matchIdx = table.find(requiredMods, "steamId", modDef.steam_id)
        if matchIdx then
          table.remove(requiredMods, matchIdx)
        else
          table.insert(unusedMods, modDef)
        end
      end
    end
    missingMods = requiredMods
    if next(missingMods) or next(unusedMods) then
      return {missingMods, unusedMods}, "mods"
    end
    CloseMessageBoxesOfType("joining-game", "close")
    local cancel_join = false
    local psn_error = false
    local msg = CreateMessageBox(terminal.desktop, T(687826475879, "Co-Op Lobby"), T(965240887205, "Connecting to PlayStation Network..."), T(6879, "Cancel"), "psn-processing")
    CreateRealTimeThread(function()
      local err = PlatformJoinMultiplayerGame(info)
      if err then
        psn_error = err
        CloseMessageBoxesOfType("psn-processing", "close")
        return
      end
      if cancel_join then
        PSNClearPlayerSession()
        return
      end
      CloseMessageBoxesOfType("psn-processing", "close")
    end)
    local res = msg:Wait()
    if res == "ok" then
      cancel_join = true
      return "cancelled"
    elseif res == "close" and psn_error then
      return psn_error
    end
    CloseInvites()
    return NetJoinGame(nil, gameId), "join"
  end
  if msg == "request_rejected" then
    return CloseMessageBoxesOfType("joining-game", "rejected")
  end
  if msg == "request_cancel" then
    return CloseInvites()
  end
end
function OnMsg.NetPlayerMessage(someTableIdk, player_name, player_id, msg, gameId, gameName)
  if not msg then
    return
  end
  if msg ~= "request_join" and msg ~= "request_cancel" and msg ~= "request_approved" and msg ~= "request_rejected" then
    return
  end
  CreateRealTimeThread(function()
    local err, step = HandleJoinRequestMessageProc(someTableIdk, player_name, player_id, msg, gameId, gameName)
    if err then
      ShowMPLobbyError(step, err)
      NetCall("rfnPlayerMessage", player_id, "cancel_invite")
    end
  end)
end
function OnMsg.NetPlayerJoin(info)
  if not Game then
    return
  end
  local ui = GetMultiplayerLobbyDialog()
  if ui then
    ui:Close()
  end
  CoOpSendSave()
end
PlatformCheckMultiplayerRequirements = rawget(_G, "PlatformCheckMultiplayerRequirements") or empty_func
function MultiplayerInGameHostSetUI()
  if not CanYield() then
    CreateRealTimeThread(MultiplayerInGameHostSetUI)
    return
  end
  local err = PlatformCheckMultiplayerRequirements()
  if err then
    return err
  end
  if netInGame then
    MultiplayerLobbySetUI(NetIsHost() and "multiplayer_host" or "multiplayer_guest")
    WaitAllOtherThreads()
    local ui = GetMultiplayerLobbyDialog()
    local subMenu = ui and ui.idSubMenu
    if not subMenu then
      return
    end
    if table.count(netGamePlayers) > 1 then
      local otherPlayer = netUniqueId == 1 and 2 or 1
      local otherPlayerData = netGamePlayers[otherPlayer]
      if not otherPlayerData then
        return
      end
      local context = {}
      context.multiplayer_invite = "in-game"
      context.invited_player_id = otherPlayerData.accountId
      context.invited_player = otherPlayerData.name
      subMenu:SetContext(context, true)
      if GetUIStyleGamepad() then
        CreateRealTimeThread(function(subMenu)
          subMenu.idScrollArea:SelectFirstValidItem()
        end, subMenu)
      end
    end
    return
  end
  if not NetIsConnected() then
    local msg = CreateUnclickableMessagePrompt(T(908809691453, "Multiplayer"), T(994790984817, "Connecting..."))
    local err, results = MultiplayerConnect()
    if err then
      ShowMPLobbyError("connect", err)
      return
    else
      msg:Close()
    end
  end
  local prompt = CreateLateListMessageBox()
  local resp = prompt:Wait()
  if not resp or resp == "close" then
    return
  end
  if resp == "invite" then
    local err = HostMultiplayerGame("private")
    if err then
      ShowMPLobbyError(false, err)
      return
    end
    MultiplayerLobbySetUI("multiplayer_host")
    WaitAllOtherThreads()
    local ui = GetMultiplayerLobbyDialog()
    local subMenu = ui and ui.idSubMenu
    if not ui or not subMenu then
      return
    end
  elseif resp == "open" then
    local err = HostMultiplayerGame("public")
    if err then
      ShowMPLobbyError(false, err)
      return
    end
    MultiplayerLobbySetUI("multiplayer_host")
  end
end
function OnMsg.UnitDied(unit, attacker, results)
  if netInGame and NetIsHost() then
    ObjModified("coop button")
  end
end
function OnMsg.NetPlayerInfo(player, info)
  ObjModified("coop button")
end
function OnMsg.NetGameJoined()
  ObjModified("coop button")
end
function OnMsg.NetGameLeft()
  ObjModified("coop button")
end
function OnMsg.NetPlayerLeft()
  ObjModified("coop button")
end
MapVar("last_desync_log_path", false)
MapVar("last_desync_log_data", false)
local tempdir = "AppData/BugReport"
local desync_msg = false
function NetEvents.HereIsMyHashLog(player_id, cdata, pass_grid_hash, tunnel_hash)
  Msg("OtherPlayerHashLogArrived", player_id, DecompressPstr(cdata), pass_grid_hash, tunnel_hash)
end
function NetEvents.GiveMeYourHashLog()
  if last_desync_log_data then
    NetEvent("HereIsMyHashLog", netUniqueId, CompressPstr(last_desync_log_data), terrain.HashPassability(), terrain.HashPassabilityTunnels())
  else
    print("GiveMeYourHashLog no local desync log data")
  end
end
function ReportDesync()
  Pause("ReportDesync")
  PauseCampaignTime("ReportDesync")
  local msg = CreateMessageBox(nil, T(273706464856, "Bug report"), Untranslated("Reporting..."), T(325411474155, "OK"))
  msg:PreventClose()
  Sleep(100)
  local success, err = io.createpath(tempdir)
  if not success then
    print("[ReportDesync] Failed to create a temp folder for bug report:", err)
    tempdir = ""
  end
  local my_data = last_desync_log_data
  if not my_data then
    print("[ReportDesync] no local desync log data")
  end
  local fname_base = "%s/BugReportHashLog" .. tostring(netGameAddress) .. "-%d-%d.desync.log"
  local max = 99
  local i = 1
  while max >= i do
    local name = string.format(fname_base, tempdir, i, netUniqueId)
    if not io.exists(name) then
      break
    end
    i = i + 1
  end
  if max < i then
    i = 1
  end
  local my_path = string.format(fname_base, tempdir, i, netUniqueId)
  local err = AsyncStringToFile(my_path, my_data)
  if err then
    my_path = nil
    print("[ReportDesync] failed to save local desync log:", err)
  end
  NetEvent("GiveMeYourHashLog")
  local his_path
  local ok, his_id, his_data, his_pass_grid_hash, his_tunnel_hash = WaitMsg("OtherPlayerHashLogArrived", 10000)
  if not ok or not his_data then
    print("[ReportDesync] failed to get other player hash log.")
  else
    his_path = string.format(fname_base, tempdir, i, his_id)
    err = AsyncStringToFile(his_path, his_data)
  end
  local summary = "[Desync] Game: " .. tostring(netGameAddress) .. " Player: " .. netUniqueId
  local my_pass_grid_hash = terrain.HashPassability()
  local my_tunnel_hash = terrain.HashPassabilityTunnels()
  local descr = string.format([[
PASSHASH v2
My pass grid hash:%s
His pass grid hash:%s
Pass hash equality:%s

My tunnel hash:%s
His tunnel hash:%s
Tunnel hash equality:%s]], my_pass_grid_hash, his_pass_grid_hash, tostring(my_pass_grid_hash == his_pass_grid_hash), my_tunnel_hash, his_tunnel_hash, tostring(my_tunnel_hash == his_tunnel_hash))
  local files = {my_path, his_path}
  local report_params = {
    tags = {
      "Multiplayer"
    }
  }
  WaitXBugReportDlg(summary, descr, files, report_params)
  msg:Close()
  Resume("ReportDesync")
  ResumeCampaignTime("ReportDesync")
end
function OnMsg.GameDesynced(desync_path, desync_data)
  last_desync_log_path = desync_path
  last_desync_log_data = desync_data
  CreateRealTimeThread(function()
    if desync_msg and desync_msg.window_state ~= "destroying" then
      return
    end
    WaitPlayerControl()
    local titleT = T(581122640598, "Game Desynchronized")
    local choiceResyncT = T(610827620841, "Resync")
    local choiceCloseT = T(175313021861, "Close")
    if config.IncludeDesyncReports then
      local text = T(788212590733, "Press 'Report' to submit a bug. Please describe what you were doing. It's generally not necessary for both players to report, but you can if it's something very peculiar.")
      desync_msg = CreateZuluPopupChoice(nil, {
        translate = true,
        text = text,
        title = titleT,
        choice1 = choiceResyncT,
        choice1_state_func = function()
          return NetIsHost() and "enabled" or "disabled"
        end,
        choice2 = choiceCloseT,
        choice3 = T(134550621660, "Report")
      })
    else
      local text = T(496968450861, "Sorry, a desync multiplayer error has occured. The host can use the 'Resync' button to try to continue your session.")
      desync_msg = CreateZuluPopupChoice(nil, {
        translate = true,
        text = text,
        title = titleT,
        choice1 = choiceResyncT,
        choice1_state_func = function()
          return NetIsHost() and "enabled" or "disabled"
        end,
        choice2 = choiceCloseT
      })
    end
    desync_msg:Open()
    desync_msg:SetZOrder(9999)
    local result = desync_msg:Wait()
    desync_msg = false
    if result == 1 then
      CoOpSendSave()
    elseif result == 3 then
      ReportDesync()
    end
  end)
end
function CoOpSendSave()
  if not netInGame then
    return
  end
  local metadata = GatherGameMetadata()
  AddSystemMetadata(metadata)
  CreateRealTimeThread(function()
    local err = StartHostedGame("CoOp", GatherSessionData():str(), metadata)
    if not err then
      NetSyncEvent("ZuluGameLoaded")
    end
  end)
end
function NetSteamGameInviteAccepted(game_address, lobby)
  local cid = SteamGetLobbyOwner(lobby)
  if not cid then
    return "could not find steam lobby owner (cid)"
  end
  local owner_name = SteamGetFriendPersonaName(tonumber(cid))
  if not owner_name then
    return "could not find steam lobby owner (name)"
  end
  MultiplayerConnect()
  UIReceiveInvite(owner_name, nil, game_address, "CoOp", nil)
end
function GetSteamLobbyVisibility()
  local visibility = not netGameInfo.private and "public" or "private"
  if visibility == "friends" or visibility == "public" then
    return "friendsonly"
  else
    return "invisible"
  end
end
