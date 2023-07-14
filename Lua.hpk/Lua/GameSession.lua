DefineClass.CampaignObject = {
  __parents = {
    "PropertyObject"
  }
}
function CampaignObject:SetId(id)
  self.Id = id
  local template = self:GetCampaignTemplate()
  if template then
    setmetatable(self, {
      __index = template,
      __toluacode = template.__toluacode
    })
  end
end
function CampaignObject:GetCampaignTemplate()
  if self.template_key and Game and Game.Campaign and CampaignPresets[Game.Campaign] then
    local campaign = CampaignPresets[Game.Campaign]
    local subobjects = campaign[self.template_key]
    return table.find_value(subobjects, "Id", self.Id)
  end
end
function CampaignObject:GetDefaultPropertyValue(prop, prop_meta)
  prop_meta = prop_meta or self:GetPropertyMetadata(prop)
  if prop_meta and prop ~= "Id" then
    local template = self:GetCampaignTemplate()
    if template then
      return template:GetProperty(prop)
    end
  end
  return PropertyObject.GetDefaultPropertyValue(self, prop, prop_meta)
end
function CampaignObject:LoadFirstPriorityProps(obj, prop_data)
  local idx = table.find(prop_data, "Id")
  if idx then
    obj:SetId(prop_data[idx + 1])
  end
  idx = table.find(prop_data, "template_key")
  if idx then
    obj.template_key = prop_data[idx + 1]
  end
end
function CampaignObject:__fromluacode(prop_data, arr)
  local obj = self:new(arr)
  self:LoadFirstPriorityProps(obj, prop_data)
  SetObjPropertyList(obj, prop_data)
  return obj
end
GameVar("gv_NextSquadUniqueId", 1)
GameVar("gv_CurrentSectorId", false)
GameVar("gv_ActiveCombat", false)
GameVar("gv_SatelliteView", false)
GameVar("gv_Sectors", {})
GameVar("gv_ConflictSectorIds", {})
GameVar("gv_Cities", {})
GameVar("gv_Sides", {})
GameVar("gv_Squads", {})
GameVar("gv_UnitData", {})
GameVar("gv_Quests", {})
GameVar("gv_OldQuestStatus", {})
GameVar("gv_NextUnitDataUniqueId", 1)
GameVar("gv_SaveCamera", false)
GameVar("gv_DisabledPopups", {})
GameVar("gv_Cheats", {})
GameVar("gv_LastSectorTakenByPlayer", false)
GameVar("gv_AITargetModifiers", {})
PersistableGlobals.NetTimeFactor = false
local persistable_pause_reasons = {
  UI = true,
  SatelliteConflict = true,
  EndGame = true
}
if FirstLoad then
  CampaignPauseReasons = {}
  PDAOpenedByPlayer = {}
  g_LatestSave = false
  g_PersistentUnitData = false
end
function OnMsg.SaveGameStart(game)
  LastPlaytime = GetCurrentPlaytime()
  PlaytimeCheckpoint = GetPreciseTicks()
  Game.playthrough_time = LastPlaytime
end
function OnMsg.ZuluGameLoaded(game)
  LastPlaytime = Game.playthrough_time
  g_PersistentUnitData = {}
  for i, ud in sorted_pairs(gv_UnitData) do
    if ud.PersistentSessionId then
      local unitList = g_PersistentUnitData[ud.PersistentSessionId] or {}
      unitList[#unitList + 1] = ud
      g_PersistentUnitData[ud.PersistentSessionId] = unitList
    end
  end
end
function OnMsg.NewGame()
  g_PersistentUnitData = {}
end
function OnMsg.UnitDataCreated(ud)
  if not ud.PersistentSessionId then
    return
  end
  if not g_PersistentUnitData then
    g_PersistentUnitData = {}
  end
  local unitList = g_PersistentUnitData[ud.PersistentSessionId] or {}
  unitList[#unitList + 1] = ud
  g_PersistentUnitData[ud.PersistentSessionId] = unitList
end
function OnMsg.NewGame(game)
  local diffMoneyChangePerc = PercentModifyByDifficulty(GameDifficulties[Game.game_difficulty]:ResolveValue("startMoneyBonus"))
  game.Money = game.Money or MulDivRound(const.Satellite.StartingMoney, diffMoneyChangePerc, 100)
  game.Components = game.Components or 0
  game.DailyIncome = game.DailyIncome or 0
  game.CampaignTime = game.CampaignTime or const.StoryBits.StartDate
  hr.UILLuaTime = game.CampaignTime
  game.CampaignTimeStart = game.CampaignTime
  game.CampaignTimeFactor = game.CampaignTimeFactor or const.Satellite.CampaignTimeNormalSpeed
  game.PersistableCampaignPauseReasons = {}
  CampaignPauseReasons = {}
end
function OnMsg.PreLoadSessionData()
  CampaignPauseReasons = table.copy(Game.PersistableCampaignPauseReasons)
  for k, v in pairs(CampaignPauseReasons) do
    if not persistable_pause_reasons[k] then
      CampaignPauseReasons[k] = nil
    end
  end
  ObjModified(CampaignPauseReasons)
end
function PauseCampaignTime(reason)
  if Game then
    SetCampaignSpeed(0, reason)
  end
end
function ResumeCampaignTime(reason)
  if Game then
    SetCampaignSpeed(Game.CampaignTimeFactor, reason)
  end
end
function SetCampaignSpeed(speed, reason)
  NetSyncEvent("SetCampaignSpeed", speed, reason)
end
function _SetCampaignSpeed(speed, reason)
  if not Game then
    return
  end
  NetUpdateHash("_SetCampaignSpeed", Game.CampaignTime, speed, reason)
  local old_is_paused = IsCampaignPaused()
  local old_factor = Game and Game.CampaignTimeFactor
  if reason then
    if speed == 0 then
      CampaignPauseReasons[reason] = true
      if persistable_pause_reasons[reason] then
        Game.PersistableCampaignPauseReasons[reason] = true
      end
    else
      CampaignPauseReasons[reason] = nil
      if persistable_pause_reasons[reason] then
        Game.PersistableCampaignPauseReasons[reason] = nil
      end
    end
  end
  if speed and 0 < speed then
    Game.CampaignTimeFactor = speed
  end
  ObjModified(Game)
  if IsCampaignPaused() ~= old_is_paused or Game and Game.CampaignTimeFactor ~= old_factor then
    Msg("CampaignSpeedChanged")
  end
  ObjModified(CampaignPauseReasons)
end
function IsCampaignPaused()
  return not not next(CampaignPauseReasons)
end
local host_suffix, guest_suffix = "_mp_coop_host", "_mp_coop_guest"
function GetUICampaignPauseReason(reason)
  local is_host = not netInGame or NetIsHost()
  return string.format("%s%s", reason, is_host and host_suffix or guest_suffix)
end
function GetPauseUIReasonExists(reason)
  local guestExist = string.format("%s%s", reason, guest_suffix)
  local hostExist = string.format("%s%s", reason, host_suffix)
  guestExist = CampaignPauseReasons[guestExist]
  hostExist = CampaignPauseReasons[hostExist]
  return guestExist or hostExist, guestExist, hostExist
end
function OnMsg.NetGameLeft()
  PDAOpenedByPlayer[2] = nil
end
function OnMsg.NetPlayerLeft(player, reason)
  PDAOpenedByPlayer[player.id] = nil
end
function OnMsg.ChangeMap()
  PDAOpenedByPlayer = {}
end
function NetSyncEvents.SetPDAOpened(playerId, state)
  local inMpGame = netInGame and table.count(netGamePlayers) > 1
  local isHost = not inMpGame or NetIsHost(playerId)
  PDAOpenedByPlayer[playerId] = state
  local pausedByPDAOpen = PDAOpenedByPlayer[1] and PDAOpenedByPlayer[2]
  if not inMpGame then
    pausedByPDAOpen = PDAOpenedByPlayer[netUniqueId]
  end
  _SetCampaignSpeed(pausedByPDAOpen and 0 or false, "PDAOpened")
end
function IsCampaignPausedByOtherPlayer()
  if netInGame then
    local suffix = NetIsHost() and guest_suffix or host_suffix
    for k, v in pairs(CampaignPauseReasons) do
      if v and string.match(k, string.format("%s$", suffix)) then
        return true
      end
    end
  end
  return false
end
function ClearRemotePauseReasons(reasons)
  local cleared = {}
  local suffix = NetIsHost() and guest_suffix or host_suffix
  for k, v in pairs(reasons) do
    if v and type(k) == "string" and string.match(k, string.format("%s$", suffix)) then
      cleared[#cleared + 1] = k
      reasons[k] = nil
    end
  end
  return cleared
end
function GetAllSuffixReasons(reasons)
  local res = {}
  for k, v in pairs(reasons) do
    if v and type(k) == "string" and (k:ends_with(guest_suffix) or k:ends_with(host_suffix)) then
      res[#res + 1] = k
    end
  end
  return res
end
function GetRemoteSuffixReasons(reasons)
  local res = {}
  for k, v in pairs(reasons) do
    if v and type(k) == "string" and k:ends_with(guest_suffix) then
      res[#res + 1] = k
    end
  end
  return res
end
function OnMsg.NetPlayerLeft(player, reason)
  ClearRemotePauseReasons(CampaignPauseReasons)
  local cleared = GetRemoteSuffixReasons(PauseReasons)
  for i, r in ipairs(cleared) do
    _SetPauseLayerPause(false, r)
  end
end
function ClearAllSuffixReasons(reasons)
  local suffixReasons = GetAllSuffixReasons(reasons)
  for i, sR in ipairs(suffixReasons) do
    reasons[sR] = false
  end
end
function OnMsg.ChangeMapDone()
  ClearAllSuffixReasons(CampaignPauseReasons)
  ClearAllSuffixReasons(PauseReasons)
end
function OnMsg.NetGameLeft()
  ClearAllSuffixReasons(CampaignPauseReasons)
  local cleared = GetAllSuffixReasons(PauseReasons)
  for i, r in ipairs(cleared) do
    _SetPauseLayerPause(false, r)
  end
end
function IsCampaignPausedByRemotePlayerOnly()
  return DoPauseReasonsContainRemotePlayerOnlyPause(CampaignPauseReasons)
end
function IsGamePausedByRemotePlayerOnly()
  return DoPauseReasonsContainRemotePlayerOnlyPause(PauseReasons)
end
function IsCampaignOrGamePausedByRemotePlayerOnly()
  local pausedByRemote, reason = IsCampaignPausedByRemotePlayerOnly()
  if pausedByRemote then
    return pausedByRemote, reason
  end
  return IsGamePausedByRemotePlayerOnly()
end
function DoPauseReasonsContainRemotePlayerOnlyPause(reasons)
  if netInGame then
    local his_suffix = NetIsHost() and guest_suffix or host_suffix
    local my_suffix = NetIsHost() and host_suffix or guest_suffix
    local has_mine = false
    local has_his, his_reason = false
    for k, v in pairs(reasons) do
      if v and type(k) == "string" then
        if not has_his and string.match(k, string.format("%s$", his_suffix)) then
          has_his = true
          his_reason = k
        elseif not has_mine and string.match(k, string.format("%s$", my_suffix)) then
          has_mine = true
        end
      end
    end
    return has_his and not has_mine, his_reason
  end
  return false
end
function NetSyncEvents.SetCampaignSpeed(speed, reason)
  _SetCampaignSpeed(speed, reason)
end
function NetSyncEvents.SetLayerPause(pause, reason, keep_sounds)
  CreateGameTimeThread(function()
    _SetPauseLayerPause(pause, reason, keep_sounds)
  end)
end
function SetPauseLayerPause(pause, layer, keep_sounds)
  if layer then
  end
  local r = type(layer) == "string" and layer or type(layer) == "table" and layer.class or "UnknownPause"
  r = GetUICampaignPauseReason(r)
  if GetMapName() ~= "" and not IsChangingMap() then
    NetSyncEvent("SetLayerPause", pause, r, keep_sounds)
  else
    _SetPauseLayerPause(pause, r, keep_sounds)
  end
end
function _SetPauseLayerPause(pause, layer, keep_sounds)
  if pause then
    Pause(layer, keep_sounds)
  else
    Resume(layer)
  end
  local dlg = GetDialog("MPPauseHint")
  if dlg then
    dlg:OnContextUpdate(dlg.context)
  end
end
function OnMsg.SaveGameStart(save)
  if save and not save.autosave then
    SetPauseLayerPause(true, "SavingGame")
  end
end
function OnMsg.SaveGameDone(save)
  SetPauseLayerPause(false, "SavingGame")
end
function IsCampaignMap(map_name)
  for _, preset in pairs(CampaignPresets) do
    for _, sector in pairs(preset.Sectors or empty_table) do
      if sector.Map == map_name then
        return true
      end
    end
  end
end
local SingleplayerPauseCampaignTime = function(pause, reason)
  if gv_SatelliteView and not IsInMultiplayerGame() then
    _SetCampaignSpeed(pause and 0 or Game.CampaignTimeFactor, reason)
  end
end
function OnMsg.BugReportStart()
  PauseCampaignTime(GetUICampaignPauseReason("InGameMenu"))
end
function OnMsg.BugReportEnd()
  ResumeCampaignTime(GetUICampaignPauseReason("InGameMenu"))
end
function CloseBugReporter()
  local template_id = config.BugReporterXTemplateID
  local dlg = GetDialog(template_id)
  if not dlg then
    return
  end
  dlg:Close()
end
OnMsg.OpenSatelliteView = CloseBugReporter
OnMsg.CloseSatelliteView = CloseBugReporter
function OnMsg.InGameMenuOpen()
  SingleplayerPauseCampaignTime(true, "InGameMenu")
end
function OnMsg.InGameMenuClose()
  SingleplayerPauseCampaignTime(false, "InGameMenu")
end
function OnMsg.EnterSector()
  OpenDialog("MPPauseHint", GetInGameInterface())
end
function GatherSessionData()
  local time_start = GetPreciseTicks()
  PauseInfiniteLoopDetection("GatherSessionData")
  Msg("GatherSessionData")
  if Platform.developer then
  end
  local time_to_lua_code = GetPreciseTicks()
  g_PresetForbidSerialize = true
  local save_data = pstr("return "):append(TupleToLuaCodePStr({
    game = Game,
    gvars = GetPersistableGameVarValues()
  }))
  g_PresetForbidSerialize = false
  if Platform.developer then
    local time = GetPreciseTicks() - time_to_lua_code
  end
  Msg("GatherSessionDataEnd")
  ResumeInfiniteLoopDetection("GatherSessionData")
  if Platform.developer then
  end
  return save_data
end
function GetGameVarFromSession(session_data, name)
  return session_data.gvars[name]
end
function GetSectorDataFromSession(session_data, sector_id)
  return session_data.gvars.gv_Sectors[sector_id].sector_data
end
local GameDataToLuaValue = function(data, env)
  local func, err = load(data, nil, nil, env)
  if not func then
    return err
  end
  local ok, data = procall(func)
  if not ok then
    return data or "runtime err"
  end
  return nil, data
end
function LoadGameSessionData(data, metadata)
  collectgarbage("stop")
  SkipAnySetpieces()
  ChangeGameState({loading_savegame = true})
  if GetMap() == "" then
    ResetGameTime()
  else
    ChangeMap("")
  end
  ClearItemIdData()
  ZuluNewGame()
  local env = LuaValueEnv({
    PlaceInventoryItem = PlaceInventoryItem,
    PlaceUnitData = PlaceUnitData,
    PlaceStatusEffect = PlaceCharacterEffect,
    PlaceCharacterEffect = PlaceCharacterEffect,
    InvalidPos = InvalidPos,
    GetMissingSourceFallback = function()
      print("Loading SaveGame Environment: Func source missing!")
      return function()
        print("Loading SaveGame Environment: Missing func!")
      end
    end
  })
  local err, data = GameDataToLuaValue(data, env)
  if not err then
    FixupSessionData(metadata, data)
    for _, name in ipairs(GameVars) do
      if data.gvars[name] == nil then
        local value = GameVarValues[name]
        if type(value) == "function" then
          value = value()
        end
        _G[name] = value or false
      else
        _G[name] = data.gvars[name]
      end
    end
    Game = data.game
    Game.Campaign = Game.Campaign or DefaultCampaign
    if not IsKindOf(Game, "GameSettings") then
      Game = GameSettings:new(Game)
    end
    Game.loaded_from_id = Game.save_id
    Game.combat_outcomes = Game.combat_outcomes or {
      defeats = {},
      retreats = {},
      victories = {}
    }
    NetGossip("LoadGame", Game.id, Game.loaded_from_id, GetGameSettingsTable(Game), Game.combat_outcomes, GetCurrentPlaytime(), Game and Game.CampaignTime)
    local custom_merc = data.gvars.g_ImpTest and data.gvars.g_ImpTest.final
    if custom_merc and custom_merc.created then
      if type(custom_merc.name) == "string" then
        custom_merc.name = CreateUserText(custom_merc.name, "name")
      end
      if type(custom_merc.nick) == "string" then
        custom_merc.nick = CreateUserText(custom_merc.nick, "name")
      end
      local merc_unit_data = data.gvars.gv_UnitData[custom_merc.merc_template.id]
      merc_unit_data.Name = custom_merc.name
      merc_unit_data.Nick = custom_merc.nick
      local user_texts = {
        custom_merc.name,
        custom_merc.nick
      }
      local loading = _InternalTranslate(LoadingUnitName)
      SetCustomFilteredUserTexts(user_texts, {loading, loading})
      local errors = AsyncFilterUserTexts(user_texts)
      if errors then
        for _, err in ipairs(errors) do
          SetCustomFilteredUserText(err.user_text)
        end
      end
    end
    Msg("PreLoadSessionData", data)
    local sat_view = gv_SatelliteView
    local sectorToEnter = gv_ActiveCombat or gv_CurrentSectorId
    if sectorToEnter then
      local floatingTextConfig = config.FloatingTextEnabled
      config.FloatingTextEnabled = false
      EnterSector(sectorToEnter)
      config.FloatingTextEnabled = floatingTextConfig
    end
    if sat_view or not sectorToEnter then
      if gv_SaveCamera then
        SetCamera(unpack_params(gv_SaveCamera))
        gv_SaveCamera = false
      end
      OpenSatelliteView(nil, InitialConflictNotStarted() and not AnyPlayerSquads() and "openLandingPage", "force_loading", "wait")
    end
    while IsChangingMap() or GetMap() == "" do
      WaitMsg("ChangeMapDone", 200)
    end
    Msg("LoadSessionData")
  end
  local browser_history = data.gvars.PDABrowserHistoryState
  if not IsDlcAvailable("future") then
    for i, v in ipairs(browser_history) do
      if v.mode == "banner_page" and v.mode_param == "PDABrowserBobbyRay" then
        table.remove(browser_history, i)
        break
      end
    end
  end
  ChangeGameState({loading_savegame = false})
  collectgarbage("collect")
  collectgarbage("restart")
  return err
end
function InitSessionCampaignObjects(class, session_objs, template_key)
  local campaign_objs = CampaignPresets[Game.Campaign][template_key]
  for i = 1, #campaign_objs do
    local id = campaign_objs[i].Id
    if not session_objs[id] then
      session_objs[id] = class:new({template_key = template_key})
      session_objs[id]:SetId(id)
    end
  end
end
function ZuluNewGame(new_game_params, campaign)
  local unit_data = new_game_params and new_game_params.KeepUnitData and gv_UnitData
  DoneGame()
  local game = GameClass:new()
  game.save_id = random_encode64(48)
  game.combat_outcomes = {
    defeats = {},
    retreats = {},
    victories = {}
  }
  Game = game
  ApplyNewGameOptions(new_game_params)
  InitGameVars()
  if campaign then
    Game.Campaign = campaign.id
    Game.CampaignTime = campaign.starting_timestamp
    hr.UILLuaTime = Game.CampaignTime
    Game.CampaignTimeStart = Game.CampaignTime
  end
  if unit_data then
    gv_UnitData = unit_data
  end
  if not GameState.loading_savegame then
    NetGossip("NewGame", game.id, game.save_id, GetGameSettingsTable(game))
    local campaign = GetCurrentCampaignPreset()
    NetGossip("CampaignStage", campaign and campaign.id, "early", GetCurrentPlaytime(), Game.CampaignTime)
  end
  Msg("NewGame", game)
  CloseMenuDialogs()
  return game
end
function OnMsg.CombatEnd(combat)
  local team = GetCampaignPlayerTeam()
  local defeated = not team or team:IsDefeated()
  local stats_tbl = defeated and Game.combat_outcomes.defeats or Game.combat_outcomes.victories
  stats_tbl[gv_CurrentSectorId] = (stats_tbl[gv_CurrentSectorId] or 0) + 1
  NetGossip("Combat", "Outcomes", Game.combat_outcomes, GetCurrentPlaytime(), Game and Game.CampaignTime)
end
function OnMsg.ConflictEnd(sector, _, __, ___, ____, isRetreat)
  if not isRetreat then
    return
  end
  local sector_id = sector.Id
  Game.combat_outcomes.retreats[sector_id] = (Game.combat_outcomes.retreats[sector_id] or 0) + 1
  NetGossip("Combat", "Retreat", sector_id, GetCurrentPlaytime(), Game and Game.CampaignTime)
  NetGossip("Combat", "Outcomes", Game.combat_outcomes, GetCurrentPlaytime(), Game and Game.CampaignTime)
end
function NewGameSession(campaign, new_game_params)
  LogData = {}
  Msg("NewGameSessionStart")
  ZuluNewGame(new_game_params, campaign)
  InitSessionCampaignObjects(SatelliteSector, gv_Sectors, "Sectors")
  InitSessionCampaignObjects(CampaignCity, gv_Cities, "Cities")
  InitSessionCampaignObjects(CampaignSide, gv_Sides, "Sides")
  for i, mId in ipairs(Mercenaries) do
    CreateUnitData(mId, mId, InteractionRand())
  end
  Msg("InitSessionCampaignObjects")
end
function HasGameSession()
  return not not next(gv_Sectors or empty_table)
end
DefaultCampaign = "HotDiamonds"
function StartCampaign(campaign_id, new_game_params)
  local campaign = CampaignPresets[campaign_id or false] or GetCurrentCampaignPreset()
  if campaign.DisclaimerOnStart then
    local duration = ReadDurationFromText(_InternalTranslate(campaign.DisclaimerOnStart))
    local dlg = SplashText(campaign.DisclaimerOnStart, "DisclaimerOnStart", 600, 1500, duration)
    dlg:SetMouseCursor("UI/Cursors/Hand.tga")
    dlg:Wait()
  end
  LoadingScreenOpen("idLoadingScreen", "new game")
  ClearItemIdData()
  NewGameSession(campaign, new_game_params)
  campaign:OnStartCampaign()
  LoadingScreenClose("idLoadingScreen", "new game")
end
function QuickStartCampaign(campaign_id, new_game_params)
  local campaign = CampaignPresets[campaign_id or false] or GetCurrentCampaignPreset()
  local init_sector = campaign.InitialSector
  ClearItemIdData()
  NewGameSession(campaign, new_game_params)
  SectorLoadingScreenOpen("idQuickStartCampaign", "quick start", init_sector)
  MapForEach("map", "Unit", DoneObject)
  Game.Money = const.Satellite.StartingMoneyQuickStart
  Game.isDev = true
  local unit_ids = GetTestCampaignSquad()
  CreateNewSatelliteSquad({
    Side = "player1",
    CurrentSector = init_sector,
    Name = SquadName:GetNewSquadName("player1")
  }, unit_ids, 14, 1234567)
  for _, unitId in ipairs(unit_ids) do
    Msg("MercHired", unitId, 1234, 14)
    SetMercStateFlag(unitId, "CurrentDailySalary", DivRound(1234, 14))
  end
  campaign:OnStartCampaign("QuickStart")
  gv_InitialHiringDone = true
  SectorLoadingScreenClose("idQuickStartCampaign", "quick start")
  EnterFirstSector(init_sector, "force")
end
function GetTestCampaignSquad()
  local starting_parties = {
    {
      "Igor",
      "Kalyna",
      "Omryn",
      "Livewire"
    },
    {
      "Barry",
      "MD",
      "Steroid",
      "Igor"
    },
    {
      "Mouse",
      "Igor",
      "Grunty",
      "Fauda"
    },
    {
      "Tex",
      "MD",
      "Buns"
    },
    {
      "Wolf",
      "Steroid",
      "Fox",
      "Kalyna"
    },
    {
      "Red",
      "Fauda",
      "Kalyna",
      "Igor"
    },
    {
      "Thor",
      "Buns",
      "Steroid",
      "Livewire"
    }
  }
  return table.rand(starting_parties)
end
GameVar("gv_InitialHiringDone", false)
GameVar("gv_AIMBrowserEverClosed", false)
function InitialConflictNotStarted()
  return not GameState.entered_sector and not gv_InitialHiringDone
end
function OnMsg.EnterSector()
  gv_InitialHiringDone = true
end
function CanLoadGame()
  if not ((not netInGame or NetIsHost()) and not GetDialog("ModifyWeaponDlg") and Game) or IsGameReplayRunning() or IsGameReplayRecording() or AutosaveRequest then
    return false
  end
  return true
end
function OnMsg.CanSaveGameQuery(query)
  if not Game then
    query.no_game = true
  elseif not Game.CampaignStarted then
    query.no_real_campaign = true
  end
end
function HireInitialMercsWarning(callback, ...)
  local args = {
    ...
  }
  CreateRealTimeThread(function()
    if WaitQuestion(GetInGameInterface(), T(1000599, "Warning"), T(133085287026, "You have no team. Are you sure you want to start?"), T(689884995409, "Yes"), T(782927325160, "No")) == "ok" then
      callback(table.unpack(args))
    end
  end)
end
function OnMsg.DoneMap()
  CloseDialog("InGameInterface")
  CloseDialog("BadgeHolderDialog")
  CloseDialog("FloatingTextDialog")
end
DefineClass.GameDynamicDataObject = {
  __parents = {"Object"}
}
DefineClass.GameDynamicSpawnObject = {
  __parents = {
    "GameDynamicDataObject"
  },
  spawner = false
}
local save_val = function(data, name, val, default)
  data[name] = val ~= default and val or nil
end
local axis_z = axis_z
local invalid_pos = InvalidPos()
function GameDynamicSpawnObject:GetDynamicData(data)
  save_val(data, "pos", self:GetPos(), invalid_pos)
  save_val(data, "angle", self:GetAngle(), 0)
  save_val(data, "axis", self:GetAxis(), axis_z)
  save_val(data, "scale", self:GetScale(), 100)
end
local load_val = function(obj, data, name, setter)
  local v = data[name]
  if v then
    obj[setter](obj, data[name])
  end
end
function GameDynamicSpawnObject:SetDynamicData(data)
  load_val(self, data, "pos", "SetPos")
  load_val(self, data, "angle", "SetAngle")
  load_val(self, data, "axis", "SetAxis")
  load_val(self, data, "scale", "SetScale")
end
function GameDynamicSpawnObject:GetError()
  local detail_class = self:GetDetailClass()
  if detail_class == "Default" then
    local entity = self:GetEntity()
    local entity_data = EntityData[self:GetEntity()]
    detail_class = entity and entity_data and entity_data.entity.DetailClass or "Essential"
  end
  if detail_class ~= "Essential" then
    return string.format("'%s' goes to savegame but is '%s'(must be Essential)!", self.class, detail_class)
  end
end
function ApplyDynamicData()
  local sector_data_code = gv_Sectors[gv_CurrentSectorId] and gv_Sectors[gv_CurrentSectorId].sector_data
  local err, sector_data = LuaCodeToTuple(sector_data_code)
  if err then
    return
  end
  if next(sector_data) == nil then
    return
  end
  SuspendPassEdits("ApplyDynamicData")
  local dataToHandle = {}
  for i, data in ipairs(sector_data.dynamic_data) do
    local handle = data.handle
    dataToHandle[handle] = data
  end
  FixupSectorData(sector_data, dataToHandle)
  local spawn_data = sector_data.spawn
  local deleted = false
  local deleted_corpse_marker = {}
  local length = #(spawn_data or "")
  for i = 1, length, 2 do
    local class = spawn_data[i]
    if class == "Unit" then
      local handle = spawn_data[i + 1]
      local data = dataToHandle[handle]
      local sessionId = data.session_id
      local ud = gv_UnitData[sessionId]
      if not ud then
        spawn_data[i] = nil
        spawn_data[i + 1] = nil
        deleted = true
      end
    elseif IsKindOf(g_Classes[class], "AL_CorpseMarker") then
      local handle = spawn_data[i + 1]
      local data = dataToHandle[handle]
      if not data.corpse then
        spawn_data[i] = nil
        spawn_data[i + 1] = nil
        deleted = true
        deleted_corpse_marker[handle] = true
      end
    end
  end
  if deleted then
    table.compact(spawn_data)
  end
  for i = 1, #(spawn_data or ""), 2 do
    local class = spawn_data[i]
    local handle = spawn_data[i + 1]
    PlaceObject(class, {
      handle = handle or nil
    })
  end
  local loaded = {}
  for _, data in ipairs(sector_data.dynamic_data) do
    local handle = data.handle
    local obj = HandleToObject[handle]
    if IsValid(obj) then
      if IsKindOf(obj, "AmbientLifeMarker") then
        loaded[handle] = true
        procall(obj.SetDynamicData, obj, data)
        if IsKindOfClasses(obj, "AL_Mourn", "AL_Maraud") and obj.corpse then
          local corpse_handle = obj.corpse.handle
          loaded[corpse_handle] = true
          procall(obj.corpse.SetDynamicData, obj.corpse, dataToHandle[corpse_handle])
        end
      elseif IsKindOf(obj, "Unit") and data.behavior == "Visit" then
        local marker_handle = data.behavior_params[1] and data.behavior_params[1][1]
        if marker_handle and deleted_corpse_marker[marker_handle] then
          data.behavior = false
          data.behavior_params = false
        end
      end
    end
  end
  RebuildVisitables()
  local load_last = {}
  for _, data in ipairs(sector_data.dynamic_data) do
    local handle = data.handle
    if not loaded[handle] then
      local obj = HandleToObject[handle]
      if IsValid(obj) then
        if IsKindOf(obj, "Interactable") then
          table.insert(load_last, data)
        else
          loaded[handle] = true
          procall(obj.SetDynamicData, obj, data)
        end
      end
    end
  end
  for _, data in ipairs(load_last) do
    local handle = data.handle
    local obj = HandleToObject[handle]
    loaded[handle] = true
    procall(obj.SetDynamicData, obj, data)
  end
  Msg("LoadDynamicData", sector_data)
  ResumePassEdits("ApplyDynamicData")
end
if FirstLoad then
  g_TestingSaveLoadSystem = false
end
local gofPermanent = const.gofPermanent
function GatherSectorDynamicData()
  if not (GameState.entered_sector and gv_CurrentSectorId) or IsChangingMap() then
    return
  end
  local time = GetPreciseTicks()
  local spawn_data = {}
  local dynamic_data = {}
  local data = {}
  local persist_non_permanent = function(obj)
    if obj:GetGameFlags(gofPermanent) ~= 0 then
      return
    end
    local handle = obj:GetHandle()
    spawn_data[#spawn_data + 1] = obj.class
    spawn_data[#spawn_data + 1] = handle
    procall(obj.GetDynamicData, obj, data)
    if next(data) ~= nil then
      data.handle = handle
      dynamic_data[#dynamic_data + 1] = data
      data = {}
    end
  end
  MapForEach("map", "GameDynamicSpawnObject", persist_non_permanent)
  MapForEach("detached", "Unit", persist_non_permanent)
  PauseInfiniteLoopDetection("Saving")
  MapForEach("map", "GameDynamicDataObject", nil, nil, gofPermanent, function(obj)
    procall(obj.GetDynamicData, obj, data)
    if next(data) ~= nil then
      data.handle = obj:GetHandle()
      dynamic_data[#dynamic_data + 1] = data
      data = {}
    end
  end)
  ResumeInfiniteLoopDetection("Saving")
  table.sortby_field(dynamic_data, "handle")
  local spawnDataPaired = {}
  for i = 1, #spawn_data, 2 do
    local class = spawn_data[i]
    local handle = spawn_data[i + 1]
    spawnDataPaired[#spawnDataPaired + 1] = {class = class, handle = handle}
  end
  table.sortby_field(spawnDataPaired, "handle")
  table.iclear(spawn_data)
  for i, pair in ipairs(spawnDataPaired) do
    spawn_data[#spawn_data + 1] = pair.class
    spawn_data[#spawn_data + 1] = pair.handle
  end
  if Platform.developer and g_TestingSaveLoadSystem then
    g_LoadingHintsNextIdx = 1
    local badKeys = {
      "vangle",
      "vpos",
      "vpos_time",
      "vangle_time"
    }
    for i, dat in ipairs(dynamic_data) do
      for i, key in ipairs(badKeys) do
        if dat[key] then
          dat[key] = nil
        end
      end
    end
  end
  local sector_data = {spawn = spawn_data, dynamic_data = dynamic_data}
  Msg("SaveDynamicData", sector_data)
  Msg("PreSaveSectorData", sector_data)
  gv_Sectors[gv_CurrentSectorId] = gv_Sectors[gv_CurrentSectorId] or {}
  gv_Sectors[gv_CurrentSectorId].sector_data = tostring(TableToLuaCode(sector_data, nil, pstr("", 1024)))
  if Platform.developer then
    local len = #gv_Sectors[gv_CurrentSectorId].sector_data
    time = GetPreciseTicks() - time
    printf("Sector %s data saved in %d b (%d kb) for %dms", gv_CurrentSectorId, len, len / 1024, time)
  end
end
function SavegameSectorDataFixups.FormatChange(sector_data)
  local spawn_data = {}
  for i, data in ipairs(sector_data.spawn) do
    spawn_data[i * 2 - 1] = data[1]
    spawn_data[i * 2] = data[2]
  end
  sector_data.spawn = spawn_data
  local dynamic_data = sector_data.dynamic_data
  for i, data in ipairs(dynamic_data) do
    if data[1] == "exploration_selection" then
      sector_data.exploration_selection = data[2]
    else
      data[2].handle = data[1]
      dynamic_data[i] = data[2]
    end
  end
  for key, data in pairs(dynamic_data) do
    if type(key) == "string" then
      sector_data[key] = data
    end
  end
end
local members_to_nil = {
  "on_die_hit_descr",
  "default_move_style",
  "cur_move_style",
  "cur_idle_style",
  "on_die_hit_descr",
  "infected",
  "aware"
}
function SavegameSessionDataFixups.OptimizeUnitMembers(data)
  local sectors = GetGameVarFromSession(data, "gv_Sectors")
  for sector, sector_data_org in pairs(sectors) do
    local modified
    local err, sector_data = LuaCodeToTuple(sector_data_org.sector_data)
    if err then
      print(string.format("OptimizeSectorDatas error for sector %s: %s", sector, err))
    elseif next(sector_data) ~= nil then
      for _, data in ipairs(sector_data.dynamic_data) do
        local mod
        for _, member_name in ipairs(members_to_nil) do
          if data[member_name] == false then
            data[member_name] = nil
            mod = true
          end
        end
        if mod then
          modified = (modified or 0) + 1
        end
      end
    end
    if modified then
      sector_data_org.sector_data = tostring(TableToLuaCode(sector_data, nil, pstr("", 1024)))
    end
  end
end
function OnMsg.GatherSessionData()
  GatherSectorDynamicData()
end
function UpdateSpawners()
  FireNetSyncEventOnHostOnce("UpdateSpawners")
end
function NetSyncEvents.UpdateSpawners()
  UpdateSpawnersLocal()
end
function UpdateSpawnersLocal()
  if IsEditorActive() or GameState.loading_savegame or not mapdata.GameLogic then
    return
  end
  SuspendPassEdits("UpdateSpawners")
  MapForEach("map", "ConditionalSpawnMarker", function(obj)
    local _, despawn_cond = obj:GetSpawnDespawnConditions()
    if despawn_cond then
      obj:Update()
    end
  end)
  MapForEach("map", "ConditionalSpawnMarker", function(obj)
    obj:Update()
  end)
  ResumePassEdits("UpdateSpawners")
  g_TriggerEnemySpawners = false
end
OnMsg.QuestParamChanged = UpdateSpawners
OnMsg.CombatStart = UpdateSpawners
OnMsg.TurnStart = UpdateSpawners
OnMsg.CombatStartRepositionDone = UpdateSpawners
OnMsg.DbgStartExploration = UpdateSpawners
OnMsg.CloseConversationDialog = UpdateSpawners
function OnMsg.CloseSatelliteView()
  if GameState.loading_savegame then
    return
  end
  UpdateSpawnersLocal()
end
function OnMsg.CombatEnd(combat)
  if not combat.test_combat then
    UpdateSpawners()
  end
end
function OnMsg.PostNewMapLoaded()
  if not GameState or not GameState.loading_savegame then
    UpdateSpawners()
  end
end
function OnMsg.OnDbgLoadLocation()
  UpdateSpawners()
end
function GenerateUniqueUnitDataId(base, sector, unit)
  gv_NextUnitDataUniqueId = (gv_NextUnitDataUniqueId or 0) + 1
  return string.format("%s:%s:%s:%d", base, sector, unit, gv_NextUnitDataUniqueId - 1)
end
function OnMsg.PreLoadSessionData()
  for i, mId in ipairs(Mercenaries) do
    local unitData = CreateUnitData(mId, mId, InteractionRand())
    local props = UnitPropertiesStats:GetProperties()
    for _, prop in ipairs(props) do
      if prop.category == "Stats" then
        unitData:SetBase(prop.id, unitData[prop.id])
      end
    end
  end
end
function UpdateCombatExplorationConflictState(reset_all)
  if reset_all then
    ChangeGameState({
      Combat = false,
      Exploration = false,
      Conflict = false,
      ConflictScripted = false
    })
  else
    local combat = not not g_Combat
    local conflict = not not IsConflictMode(gv_CurrentSectorId)
    ChangeGameState({
      Combat = combat,
      Exploration = not combat,
      Conflict = conflict,
      ConflictScripted = conflict
    })
  end
end
local lUpdateCombatExplorationConflictStateNoReset = function()
  UpdateCombatExplorationConflictState()
end
OnMsg.CombatEnd = lUpdateCombatExplorationConflictStateNoReset
OnMsg.CombatStart = lUpdateCombatExplorationConflictStateNoReset
OnMsg.ConflictEnd = lUpdateCombatExplorationConflictStateNoReset
OnMsg.ConflictStart = lUpdateCombatExplorationConflictStateNoReset
OnMsg.ExplorationStart = lUpdateCombatExplorationConflictStateNoReset
OnMsg.EnterSector = lUpdateCombatExplorationConflictStateNoReset
function OnMsg.NewGameSessionStart()
  UpdateCombatExplorationConflictState("reset")
end
function OnMsg.GameStateChanged(changed)
  if changed.Combat == true then
    SetGroupVolumeReason("combat", "Ambience", 500, 1000)
  elseif changed.Combat == false then
    SetGroupVolumeReason("combat", "Ambience", const.SoundMaxVolume, 1000)
  end
end
AppendClass.MapDataPreset = {
  properties = {
    {
      category = "Zulu",
      id = "Region",
      editor = "preset_id",
      default = "Jungle",
      preset_class = "GameStateDef",
      preset_group = "region"
    },
    {
      category = "Zulu",
      id = "MainMenuRegion",
      editor = "combo",
      default = "Default",
      items = function(self)
        return PresetsCombo("GameStateDef", "region", "Default")
      end,
      name = "Region for main menu",
      help = "Choose a region to use as a main menu scene for this map, overriding the normal region of the map"
    },
    {
      category = "Zulu",
      id = "Weather",
      name = "Force weather",
      editor = "combo",
      default = "none",
      items = function(self)
        return PresetsCombo("GameStateDef", "weather", "none")
      end
    },
    {
      category = "Zulu",
      id = "Tod",
      name = "Force time of day",
      editor = "combo",
      default = "none",
      items = function(self)
        return PresetsCombo("GameStateDef", "time of day", "none")
      end
    },
    {category = "Audio", id = "Reverb"},
    {
      category = "Audio",
      id = "ReverbIndoor",
      name = "Reverb Indoor",
      editor = "preset_id",
      extra_item = "default from Region",
      default = "default from Region",
      preset_class = "ReverbDef",
      preset_group = "Default"
    },
    {
      category = "Audio",
      id = "ReverbOutdoor",
      name = "Reverb Outdoor",
      editor = "preset_id",
      extra_item = "default from Region",
      default = "default from Region",
      preset_class = "ReverbDef",
      preset_group = "Default"
    }
  }
}
AppendClass.GameStateDef = {
  properties = {
    {
      id = "ReverbIndoor",
      name = "Reverb Indoor",
      editor = "preset_id",
      default = "AboveGround_Indoor",
      preset_class = "ReverbDef",
      preset_group = "Default",
      no_edit = function(self)
        return self.group ~= "region"
      end
    },
    {
      id = "ReverbOutdoor",
      name = "Reverb Outdoor",
      editor = "preset_id",
      default = "AboveGround_Outdoor",
      preset_class = "ReverbDef",
      preset_group = "Default",
      no_edit = function(self)
        return self.group ~= "region"
      end
    },
    {
      id = "WeatherCycle",
      name = "Weather Cycle",
      editor = "choice",
      default = false,
      no_edit = function(self)
        return self.group ~= "region"
      end,
      items = function(self)
        return table.keys2(WeatherCycle)
      end
    }
  }
}
function OnMsg.GameStateChanged(changed)
  if ChangingMap then
    return
  end
  local GameStateDefs = GameStateDefs
  for state_id, state in sorted_pairs(changed) do
    local state_def = GameStateDefs[state_id]
    if state_def and state_def.group == "weather" then
      DelayedCall(0, ApplyWindMarkers)
      break
    end
  end
end
MapVar("Timers", {})
function TimerCreate(id, text, time)
  table.remove_entry(Timers, Timers[id])
  local timer = {
    id = id,
    text = text or "",
    time = time or 0,
    last_update = GameTime()
  }
  Timers[id] = timer
  Timers[#Timers + 1] = timer
  TimersUpdateTime(gv_ActiveCombat == gv_CurrentSectorId and 0)
  return timer
end
function TimerGetData(id)
  return Timers[id]
end
function TimerWait(id)
  while true do
    local data = TimerGetData(id)
    if not data or data.time <= 0 or data.StopTCE then
      return data and (data.StopTCE and "break" or "finished")
    end
    WaitMsg("TimerFinished")
  end
end
function TimerDelete(id)
  table.remove_entry(Timers, Timers[id])
  Timers[id] = nil
  TimersUpdateTime(gv_ActiveCombat == gv_CurrentSectorId and 0)
end
function TimersUpdateTime(delta)
  local dialog = GetInGameInterfaceModeDlg()
  local control = dialog and dialog:ResolveId("idTimerText")
  local context = control and control.context
  local now = GameTime()
  for i = #Timers, 1, -1 do
    local timer = Timers[i]
    local time = timer.time - (delta and delta or now - timer.last_update)
    if time <= 0 then
      timer.time = 0
      Msg("TimerFinished", timer.id)
    else
      timer.time = time
      timer.last_update = now
      if context then
        context.text = timer.text
        context.time = time
        ObjModified(context)
        context = nil
      end
    end
  end
  if context and context.time > 0 then
    context.time = 0
    ObjModified(context)
  end
end
function OnMsg.CombatStart()
  TimersUpdateTime()
end
function OnMsg.CombatEnd()
  TimersUpdateTime(0)
end
function OnMsg.NewCombatTurn(team)
  if g_CurrentTeam and g_Teams[g_CurrentTeam].control == "UI" then
    TimersUpdateTime(const.Combat.TimerTurnTime or 0)
  end
end
function OnMsg.SaveDynamicData(data)
  for _, timer in ipairs(Timers) do
    data.Timers = data.Timers or {}
    data.Timers[#data.Timers + 1] = {
      id = timer.id,
      time = timer.time,
      textId = timer.text and TGetID(timer.text)
    }
  end
end
function OnMsg.LoadDynamicData(data)
  Timers = data.Timers or Timers
  for _, timer in ipairs(Timers) do
    timer.last_update = GameTime()
    if not timer.text and timer.textId then
      timer.text = T({
        timer.textId,
        TranslationTable[timer.textId]
      }) or Untranslated("Name not localized")
    end
    Timers[timer.id] = timer
  end
end
function lGetGameStartTypes()
  local types = {
    {
      id = "Campaign",
      Name = T(831335436250, "NEW GAME"),
      func = function()
        EditorDeactivate()
        local IGmain = GetDialog("InGameMenu")
        if IGmain then
          CloseDialog("InGameMenu")
        end
        local dlg = GetDialog("PreGameMenu")
        if not dlg then
          CreateRealTimeThread(function()
            ResetGameSession()
            local dlg = OpenDialog("PreGameMenu")
            dlg:SetMode("NewGame")
            dlg:ResolveId("idSubMenuTittle"):SetText(T(831335436250, "NEW GAME"))
            dlg:ResolveId("idSubContent"):SetMode("newgame")
            Msg("PreGameMenuOpen")
          end)
        elseif dlg.Mode ~= "NewGame" then
          dlg:SetMode("NewGame")
          dlg:ResolveId("idSubMenuTittle"):SetText(T(831335436250, "NEW GAME"))
          dlg:ResolveId("idSubContent"):SetMode("newgame")
        end
      end
    },
    {
      id = "QuickStart",
      Name = T(419695626381, "QUICK START"),
      func = function()
        EditorDeactivate()
        CreateRealTimeThread(QuickStartCampaign, "HotDiamonds", {difficulty = "Normal"})
      end
    }
  }
  return types
end
GameStartTypes = lGetGameStartTypes()
function ApplyNewGameOptions(newGameObj)
  if newGameObj then
    OptionsObj = OptionsObj or OptionsCreateAndLoad()
    Game.playthrough_name = newGameObj.campaign_name
    if newGameObj.difficulty then
      Game.game_difficulty = newGameObj.difficulty
      OptionsObj.Difficulty = newGameObj.difficulty
    end
    for gameRule, value in pairs(newGameObj.game_rules) do
      if value then
        Game:AddGameRule(gameRule)
      end
    end
    SetForgivingModeOption()
    if newGameObj.settings and not IsInMultiplayerGame() then
      for option, value in pairs(newGameObj.settings) do
        OptionsObj[option] = value
      end
    end
    CreateRealTimeThread(function()
      OptionsObject.WaitApplyOptions(OptionsObj)
      OptionsObj = false
    end)
  end
end
function OnMsg.DevUIMapChangePrep()
  local campaign = CampaignPresets["HotDiamonds" or false] or GetCurrentCampaignPreset()
  NewGameSession(campaign)
end
function IsDemoSector(sector)
  return not not table.find(Presets.Build_Settings.Demo.DemoMaps.Value, sector)
end
function OnMsg.GatherGameEntities(_, additional_blacklist_textures)
  local blacklist_sectors = {}
  for _, preset in ipairs(Presets.CampaignPreset or empty_table) do
    for _, campaign in ipairs(preset or empty_table) do
      for _, sector in ipairs(campaign.Sectors or empty_table) do
        if not IsDemoSector(sector.Map) then
          blacklist_sectors[sector.Id] = campaign.id
        end
      end
    end
  end
  local sectors = table.keys(blacklist_sectors, "sorted")
  for _, sector in ipairs(sectors) do
    local image = string.format("UI/LoadingScreens/%s/%s.dds", blacklist_sectors[sector], sector)
    table.insert(additional_blacklist_textures, image)
  end
end
