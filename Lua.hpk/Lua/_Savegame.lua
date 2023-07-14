MapVar("SaveGameParams", false)
MapVar("SaveState", false)
MapVar("TurnPhase", false)
if FirstLoad then
  s_GameSessionExport = false
end
local s_GameSessionSavedFilename = "AppData/Save/game_session_saved.lua"
local s_GameSessionLoadedFilename = "AppData/Save/game_session_loaded.lua"
function DbgToggleGameSessionExport()
  s_GameSessionExport = not s_GameSessionExport
end
function NetSaveGameRequest(name, lastSave, overwrite)
  SaveGameParams = {
    name = name,
    lastSave = lastSave,
    overwrite = overwrite
  }
  NetSyncEvent("SaveGameRequest")
end
function SaveLoadObject:DoSavegame(name, lastSave, overwrite)
  return NetSaveGameRequest(name, lastSave, overwrite)
end
function NetSyncEvents.ZuluGameLoaded(file_name)
  Msg("ZuluGameLoaded", file_name)
end
function SaveLoadObject:DoLoadgame(name, metadata)
  WaitSaveGameDone()
  CancelAutosaveRequests()
  local id, reason, tip, metadata = GetLoadingScreenParamsFromMetadata(metadata)
  SectorLoadingScreenOpen(id, reason, tip, metadata)
  local err = LoadGame(name)
  if not err and Game then
    Game.isDev = metadata.isDev
    NetSyncEvent("ZuluGameLoaded", name)
    SectorLoadingScreenClose(id, reason, tip, metadata)
  else
    LoadingScreenClose(id, reason)
  end
  return err
end
function NetSyncEvents.SaveGameRequest()
  if g_Combat then
    CombatSaveGameRequest = true
    RunCombatActions()
  else
    MPSaveGame()
  end
end
function MPSaveGame()
  if not next(SaveGameParams) then
    return false
  end
  CreateRealTimeThread(function(SaveGameParams)
    if SaveGameParams.name then
      local parent = GetPreGameMainMenu() or GetInGameMainMenu()
      local err = SaveGameParams.overwrite and DeleteGame(SaveGameParams.lastSave.savename)
      if not err or err == "File Not Found" then
        err = SaveGame(SaveGameParams.name, {silent = true})
      end
      if err and err ~= "File Not Found" then
        CreateErrorMessageBox(err, "savegame", nil, parent, {
          savename = T({
            129666099950,
            "\"<name>\"",
            name = Untranslated(SaveGameParams.name)
          }),
          error_code = Untranslated(err)
        })
      else
        CloseMenuDialogs()
      end
      NetSyncEvent("MPSaveGameDone")
    else
      print("remote player save game")
    end
  end, SaveGameParams)
  SaveGameParams = false
end
function NetSyncEvents.MPSaveGameDone()
  Msg("MPSaveGameDone")
end
local prev_GatherGameMetadata = GatherGameMetadata
function GatherGameMetadata()
  local metadata = prev_GatherGameMetadata()
  metadata.campaign = Game and Game.Campaign
  metadata.sector = next(gv_Sectors) and gv_CurrentSectorId and _InternalTranslate(GetSectorId(gv_Sectors[gv_CurrentSectorId]))
  metadata.gameid = Game and Game.id
  metadata.playthrough_name = Game and Game.playthrough_name
  metadata.satellite = gv_SatelliteView
  metadata.save_game_state = SaveState or g_Combat and "Turn" or "Exploration"
  metadata.turn_phase = not TurnPhase and g_Combat and g_Combat.current_turn
  metadata.money = Game and Game.Money
  metadata.weather = metadata.sector and GetCurrentSectorWeather(metadata.sector)
  metadata.side = next(gv_Sectors) and gv_CurrentSectorId and gv_Sectors[gv_CurrentSectorId].Side
  metadata.intel = next(gv_Sectors) and gv_CurrentSectorId and gv_Sectors[gv_CurrentSectorId].Intel
  metadata.intel_discovered = next(gv_Sectors) and gv_CurrentSectorId and gv_Sectors[gv_CurrentSectorId].intel_discovered
  metadata.ground_sector = next(gv_Sectors) and gv_CurrentSectorId and gv_Sectors[gv_CurrentSectorId].GroundSector
  metadata.mapName = next(gv_Sectors) and gv_CurrentSectorId and TGetID(gv_Sectors[gv_CurrentSectorId].display_name)
  metadata.demoSave = Platform.demo
  local quest_tracker_quests = {}
  for _, quest in ipairs(GetAllQuestsForTracker()) do
    local notes = {}
    for _, note in ipairs(quest.Notes) do
      table.insert(notes, _InternalTranslate(note.Text))
    end
    table.insert(quest_tracker_quests, {
      questName = _InternalTranslate(quest.Name),
      questNotes = notes
    })
  end
  metadata.quest_tracker = quest_tracker_quests
  local player_squads = {}
  for _, squad in pairs(GetPlayerMercSquads()) do
    table.insert(player_squads, squad.units)
  end
  local allUnitsSorted = {}
  for name, units in pairs(player_squads) do
    for _, unit in ipairs(units) do
      table.insert(allUnitsSorted, unit)
    end
  end
  table.sort(allUnitsSorted, function(a, b)
    return gv_UnitData[a]:GetLevel() > gv_UnitData[b]:GetLevel()
  end)
  metadata.all_units_sorted = allUnitsSorted
  metadata.player_squads = player_squads
  metadata.game_date = Game and Game.CampaignTime
  metadata.active_quest = GetActiveQuest()
  metadata.isDev = Game and Game.isDev
  metadata.deadIsDead = IsGameRuleActive("DeadIsDead")
  metadata.lethal_weapons = IsGameRuleActive("LethalWeapons")
  return metadata
end
function GameSpecificSaveCallback(folder, metadata)
  local render_mode = GetRenderMode()
  if render_mode ~= "scene" then
    WaitRenderMode("scene")
  end
  WaitCaptureSavegameScreenshot(folder)
  WaitRenderMode(render_mode)
  if metadata and not metadata.autosave and not metadata.quicksave then
    LoadingScreenOpen("idLoadingScreen", "save savegame")
  end
  local save_data = GatherSessionData()
  local err = AsyncStringToFile(folder .. "game_session", save_data, nil, nil, "zstd", 12)
  if s_GameSessionExport then
    AsyncStringToFile(s_GameSessionSavedFilename, save_data)
  end
  save_data:free()
  if metadata and not metadata.autosave and not metadata.quicksave then
    LoadingScreenClose("idLoadingScreen", "save savegame")
  end
  return err
end
function GameSpecificLoadCallback(folder, metadata)
  local err, data = AsyncFileToString(folder .. "game_session")
  if err then
    return err
  end
  if not string.starts_with(data, "return") then
    data = "return " .. data
  end
  if s_GameSessionExport then
    AsyncStringToFile(s_GameSessionLoadedFilename, select(1, string.gsub(data, "\\n", "\n")))
  end
  if NetIsHost() then
    StartHostedGame("CoOp", data, metadata)
    return
  end
  err = LoadGameSessionData(data, metadata)
  return err
end
function GameSpecificSaveCallbackBugReport(folder, metadata)
  return GameSpecificSaveCallback(folder, metadata)
end
function TestSaveLoadGame(display_name)
  display_name = display_name or "test"
  DeleteGame(display_name .. ".savegame.sav")
  local err, name = SaveGame(display_name)
  err = err or LoadGame(name)
  if err then
  end
end
max_autosaves_per_id_default = {
  combat = Platform.developer and 10 or 3,
  newDay = 1,
  startCombat = 1,
  endCombat = 1,
  satelliteConflict = 1,
  sectorEnter = 1,
  exitGame = 1
}
max_autosaves_per_id = config.MaxAutosavesPerId or max_autosaves_per_id_default
if FirstLoad then
  AutosaveRequestsThread = false
  AutosaveRequest = false
  ShowIncompatableSaves = false
end
function IsAutosaveScheduled()
  return not not AutosaveRequest
end
function IsZuluLoadingScreenLoadSavegameOpen()
  local loadingScreenDlg = GetDialog("XZuluLoadingScreen")
  local reasonsOpen = loadingScreenDlg and loadingScreenDlg:GetOpenReasons()
  if reasonsOpen and reasonsOpen["load savegame"] then
    return true
  end
end
function CancelAutosaveRequests()
  AutosaveRequest = false
  DeleteThread(AutosaveRequestsThread)
end
function RequestAutosave(request)
  if not (GetMapName() ~= "ModEditor" and config.AutosaveAllowed and not config.AutosaveSuspended and not GameTesting and GetAccountStorageOptionValue("AutoSave")) or GameState.disable_autosave or IsGameRuleActive("Ironman") and request.autosave_id == "combat" or g_TestExploration or g_TestCombat or IsZuluLoadingScreenLoadSavegameOpen() then
    return
  end
  if request.mode == "immediate" then
    if CanSaveGame() then
      SaveState = request.save_state or false
      TurnPhase = request.turn_phase or false
      SaveAutosaveGame(request.autosave_id, _InternalTranslate(request.display_name))
    end
    return
  end
  AutosaveRequest = request
  if not IsValidThread(AutosaveRequestsThread) then
    AutosaveRequestsThread = CreateMapRealTimeThread(function()
      local end_autosave_timeout = now() + 30000
      while true do
        if end_autosave_timeout < now() then
          AutosaveRequest = false
          return
        end
        if CanSaveGame(AutosaveRequest) then
          SaveState = AutosaveRequest.save_state or false
          TurnPhase = AutosaveRequest.turn_phase or false
          SaveAutosaveGame(AutosaveRequest.autosave_id, _InternalTranslate(AutosaveRequest.display_name))
          AutosaveRequest = false
          return
        end
        Sleep(1)
        if IsPaused() then
          end_autosave_timeout = end_autosave_timeout + 1
        end
      end
    end)
  end
end
function SaveAutosaveGame(autosave_id, display_name)
  local tStart = GetPreciseTicks()
  local autosaves = {}
  local playthoughSaves = {}
  local err, list = Savegame.ListForTag("savegame")
  if not err then
    for _, v in ipairs(list) do
      err = GetFullMetadata(v)
      if not err and v.autosave == autosave_id and not v.deadIsDead then
        autosaves[#autosaves + 1] = v.savename
      end
      if not err and v.gameid == Game.id then
        playthoughSaves[#playthoughSaves + 1] = v.savename
      end
    end
  end
  local err, name = DoSaveGame(display_name, {autosave = autosave_id})
  if err then
    print("Error on autosave", err)
  else
    for i = max_autosaves_per_id[autosave_id] or 1, #autosaves do
      DeleteGame(autosaves[i])
    end
    if IsGameRuleActive("DeadIsDead") and Game and not Game.isDev then
      for _, save in ipairs(playthoughSaves) do
        DeleteGame(save)
      end
    end
  end
  if Platform.developer then
    printf("Autosave %s saved in %d ms", name, GetPreciseTicks() - tStart)
  end
end
SavegameSessionDataFixups = {}
SavegameSectorDataFixups = {}
GameVar("ZuluAppliedSessionDataFixups", {})
local mark_applied_session_data_fixups = function()
  for fixup in pairs(SavegameSessionDataFixups) do
    ZuluAppliedSessionDataFixups[fixup] = true
  end
end
OnMsg.InitSessionCampaignObjects = mark_applied_session_data_fixups
OnMsg.LoadSessionData = mark_applied_session_data_fixups
function OnMsg.PreSaveSectorData(sector_data)
  sector_data.applied_sector_fixups = sector_data.applied_sector_fixups or {}
  for fixup in pairs(SavegameSectorDataFixups) do
    sector_data.applied_sector_fixups[fixup] = true
  end
  sector_data.lua_revision_on_save = LuaRevision
end
function FixupSessionData(metadata, session_data)
  local lua_revision = metadata and metadata.lua_revision or 0
  rawset(_G, "ZuluAppliedSessionDataFixups", session_data.gvars.ZuluAppliedSessionDataFixups or {})
  local start_time, count = GetPreciseTicks(), 0
  for fixup, func in sorted_pairs(SavegameSessionDataFixups) do
    if not ZuluAppliedSessionDataFixups[fixup] and type(func) == "function" then
      procall(func, session_data, metadata, lua_revision)
      count = count + 1
      ZuluAppliedSessionDataFixups[fixup] = true
    end
  end
  if 0 < count then
    DebugPrint(string.format("Applied %d savegame fixup(s) in %d ms\n", count, GetPreciseTicks() - start_time))
  end
end
function FixupSectorData(sector_data, handle_data)
  local applied_sector_fixups = sector_data.applied_sector_fixups or {}
  local start_time, count = GetPreciseTicks(), 0
  for fixup, func in sorted_pairs(SavegameSectorDataFixups) do
    if not applied_sector_fixups[fixup] and type(func) == "function" then
      procall(func, sector_data, sector_data.lua_revision_on_save or 0, handle_data)
      count = count + 1
    end
  end
  if 0 < count then
    DebugPrint(string.format("Applied %d sector data fixup(s) in %d ms\n", count, GetPreciseTicks() - start_time))
  end
end
function GetSaveGamesGrouped(saveObject, filter, newSave)
  if not saveObject or not saveObject.items then
    return empty_table
  end
  local matched = saveObject.items
  if not Platform.developer then
    matched = table.ifilter(matched, function(idx, save)
      return (save.metadata.lua_revision or 0) >= config.SupportedSavegameLuaRevision
    end)
  end
  if (filter or "") ~= "" then
    matched = table.ifilter(matched, function(idx, save)
      local savemeta = save.metadata
      return string.find_lower(savemeta.savename or "", filter)
    end)
  end
  local playthroughs = {}
  local saveForCurrentGame
  for i, save in ipairs(matched) do
    local savemeta = save.metadata
    local gameId = savemeta.gameid
    local displayName = false
    if savemeta.playthrough_name then
      displayName = savemeta.playthrough_name
    end
    if savemeta.isDev then
      gameId = "Dev"
      displayName = "Developer"
    end
    if not gameId then
      gameId = "Unknown"
      displayName = "Unknown Playthrough"
    end
    if not playthroughs[gameId] then
      playthroughs[gameId] = {
        id = gameId,
        displayName = displayName,
        saves = {}
      }
      table.insert(playthroughs, playthroughs[gameId])
    end
    local playthrough = playthroughs[gameId]
    table.insert(playthrough.saves, save)
    if Game and savemeta.gameid == Game.id then
      saveForCurrentGame = true
    end
  end
  if not saveForCurrentGame and newSave and Game and not Game.isDev then
    playthroughs[Game.id] = {
      id = Game.id,
      displayName = Game.playthrough_name or T(876734643869, "New Playthrough"),
      saves = {},
      newPlaythrough = true
    }
    table.insert(playthroughs, playthroughs[Game.id])
  end
  if newSave then
    local save = {newSave = true}
    local newSaveMetadata = GatherGameMetadata()
    save.metadata = newSaveMetadata
    save.metadata.timestamp = os.time()
    save.metadata.playtime = GetCurrentPlaytime()
    local sameNameCounter = 1
    for _, save in ipairs(saveObject.items) do
      if string.match(save.savename, "NEW SAVE.*") then
        sameNameCounter = sameNameCounter + 1
      end
    end
    save.metadata.savename = _InternalTranslate(T({
      999214427188,
      "NEW SAVE<u(idx)>",
      idx = 1 < sameNameCounter and "(" .. sameNameCounter .. ")" or ""
    }))
    save.savename = save.metadata.savename
    local playthrough = playthroughs[Game.id] or playthroughs.Dev
    if not playthrough then
      playthroughs[Game.id] = {
        id = Game.id,
        displayName = save.metadata.playthrough_name,
        saves = {}
      }
      table.insert(playthroughs, playthroughs[Game.id])
      playthrough = playthroughs[Game.id]
    end
    table.insert(playthrough.saves, save)
  end
  for i, playthrough in ipairs(playthroughs) do
    table.sort(playthrough.saves, function(a, b)
      local aIsTest = string.find(a.metadata.savename, "%[TS%]")
      local bIsTest = string.find(b.metadata.savename, "%[TS%]")
      if not ((not aIsTest or not bIsTest) and (aIsTest or bIsTest)) or a.newSave or b.newSave then
        return a.metadata.timestamp > b.metadata.timestamp
      end
      if aIsTest then
        return true
      end
      if bIsTest then
        return false
      end
    end)
    local latestSave = playthrough.saves[1]
    playthrough.time_end = latestSave.metadata.timestamp
    playthrough.playtime = latestSave.metadata.playtime
    playthrough.last_save_name = latestSave.metadata.savename
    local oldestSave = playthrough.saves[#playthrough.saves]
    playthrough.time_started = oldestSave.metadata.timestamp
  end
  if Game then
    local existingPlaytrough = playthroughs[Game.id] and not Game.isDev
    table.sort(playthroughs, function(a, b)
      local aIsFirst, bIsFirst
      if not existingPlaytrough and a.id == "Dev" then
        for _, save in ipairs(a.saves) do
          if save.metadata.gameid == Game.id then
            aIsFirst = true
          end
        end
      elseif not existingPlaytrough and b.id == "Dev" then
        for _, save in ipairs(b.saves) do
          if save.metadata.gameid == Game.id then
            bIsFirst = true
          end
        end
      else
        aIsFirst = a.id == Game.id
        bIsFirst = b.id == Game.id
      end
      if aIsFirst then
        return true
      end
      if bIsFirst then
        return false
      end
      return a.time_end > b.time_end
    end)
  end
  local icr = 1
  for i, playthrough in ipairs(playthroughs) do
    if not playthrough.displayName then
      playthrough.displayName = "Playthrough " .. tostring(#playthroughs - icr)
      icr = icr + 1
    end
  end
  return playthroughs
end
function GetPlaythroughOfId(saveObject, id)
  local playthroughs = GetSaveGamesGrouped(saveObject)
  return table.find_value(playthroughs, "id", id) or empty_table
end
if FirstLoad then
  g_SelectedSaveGamePlaythrough = false
  g_SelectedSave = false
  g_CurrentlyEditingName = false
end
function SelectPlaythrough(playthrough, dlg)
  local parentList = dlg.idList
  if parentList then
    local selection = parentList:GetSelection()
    local item = next(selection) and parentList[selection[1]]
    local buttonIdx = table.find(parentList, "context", playthrough)
    local playthroughButton = parentList[buttonIdx]
    if item ~= playthroughButton then
      parentList:SetSelection(buttonIdx)
    end
  end
  g_SelectedSaveGamePlaythrough = playthrough
  ShowSavegameDescription(next(playthrough.saves) and playthrough.saves[1] or {id = 0}, dlg)
  ObjModified("playthrough-selected")
end
function DeletePlaythrough(obj, playthrough)
  CreateRealTimeThread(function()
    if WaitQuestion(GetDialog("InGameMenu"), T(824112417429, "Warning"), T({
      184731735281,
      "Are you sure you want to delete the entire playthrough <name>?",
      name = Untranslated(playthrough.id)
    }), T(689884995409, "Yes"), T(782927325160, "No")) == "ok" then
      LoadingScreenOpen("idDeleteScreen", "delete savegame")
      for i, save in ipairs(playthrough.saves) do
        DeleteGame(save.savename)
        obj:RemoveItem(save.id)
      end
      ObjModified(obj)
      LoadingScreenClose("idDeleteScreen", "delete savegame")
    end
  end)
end
if FirstLoad then
  LastSaveName = false
  LastQuicksaveName = false
end
function QuickSave()
  if not CanSaveGame() then
    return
  end
  CreateRealTimeThread(function()
    local quickSave = T(698433196478, "QuickSave")
    local saveGameName = _InternalTranslate(quickSave) .. Game.id
    WaitChangeMapDone()
    WaitSaveGameDone()
    SavingGame = true
    Msg("SaveGameStart")
    local metadata = GatherGameMetadata()
    metadata.quicksave = true
    local err, name = Savegame.WithTag("savegame", saveGameName, GameSpecificSaveCallback, metadata, {force_overwrite = true})
    while StoringSaveGame do
      Sleep(1)
    end
    if not err then
      local saveManager = g_SaveGameObj or SaveLoadObjectCreateAndLoad()
      saveManager:WaitGetSaveItems()
      local idx = table.findfirst(SavegamesList, function(_, save)
        return save.savename == name and save.real_time ~= metadata.real_time
      end)
      if idx then
        table.remove(SavegamesList, idx)
      end
    end
    SavingGame = false
    Msg("SaveGameDone", name, "quicksave")
    CombatLog("important", T(587120382251, "Quicksaved game."))
  end)
end
function QuickLoad()
  if not LastQuicksaveName then
    return
  end
  if not CanLoadGame() then
    return
  end
  CreateRealTimeThread(function()
    SkipAnySetpieces()
    local saveManager = g_SaveGameObj or SaveLoadObjectCreateAndLoad()
    saveManager:WaitGetSaveItems()
    local allSaves = saveManager.items
    local item = table.find_value(allSaves or empty_table, "savename", LastQuicksaveName)
    if not item then
      return
    end
    if not CanLoadSave(item) then
      return
    end
    if not CanLoadGame() then
      return
    end
    saveManager:Load(GetInGameInterface(), item, Platform.developer)
  end)
end
function OnMsg.ApplyAccountOptions()
  if AccountStorage then
    LastSaveName = AccountStorage.LastSaveName or false
    LastQuicksaveName = AccountStorage.LastQuicksaveName or false
  end
end
function OnMsg.SaveGameDone(filename, saveType)
  if saveType == "quicksave" then
    LastQuicksaveName = filename
    if AccountStorage then
      AccountStorage.LastQuicksaveName = LastQuicksaveName
      SaveAccountStorage(5000)
    end
  else
    LastSaveName = filename
    if AccountStorage then
      AccountStorage.LastSaveName = LastSaveName
      SaveAccountStorage(5000)
    end
  end
  SaveState = false
  TurnPhase = false
end
function OnMsg.ZuluGameLoaded(filename)
  if NetIsHost() then
    LastSaveName = filename or LastSaveName
    if AccountStorage then
      AccountStorage.LastSaveName = LastSaveName
      SaveAccountStorage(5000)
    end
  end
end
function SaveLoadObject:Save(item, name)
  name = name:trim_spaces()
  if name and name ~= "" then
    g_SaveLoadThread = IsValidThread(g_SaveLoadThread) and g_SaveLoadThread or CreateRealTimeThread(function(name, item)
      local parent = GetPreGameMainMenu() or GetInGameMainMenu()
      local err, savename, overwrite
      if item then
        if WaitQuestion(parent, T(824112417429, "Warning"), T({
          883071764117,
          "Are you sure you want to overwrite <savename>?",
          savename = "\"" .. Untranslated(item.text or item.displayname) .. "\""
        }), T(689884995409, "Yes"), T(782927325160, "No")) == "ok" then
          overwrite = true
        else
          return
        end
      end
      self:DoSavegame(name, item, overwrite)
      WaitMsg("MPSaveGameDone")
    end, name, item)
  end
end
function SavenameToName(savename)
  local new_savename = savename:match("(.*)%.savegame%.sav$")
  if not new_savename then
    return savename
  end
  new_savename = new_savename:gsub("%+", " ")
  new_savename = new_savename:gsub("%%(%d%d)", function(hex_code)
    return string.char(tonumber("0x" .. hex_code))
  end)
  return new_savename
end
local intToDate = function(numberDate)
  local date = T(77, "Unknown")
  if numberDate then
    local h, m, s = FormatElapsedTime(numberDate, "hms")
    local hours = Untranslated(string.format("%02d", h))
    local minutes = Untranslated(string.format("%02d", m))
    date = T({
      7549,
      "<hours>:<minutes>",
      hours = hours,
      minutes = minutes
    })
  end
  return date
end
function SetSavegameDescriptionTexts(dialog, data, missing_dlcs, mods_string, mods_missing)
  if not dialog or dialog.window_state == "destroying" or GetDialogMode(dialog) ~= "save" then
    return
  end
  local playtime = intToDate(data.playtime)
  local gametime = data.game_date and numberToTimeDate(data.game_date) or T(77, "Unknown")
  dialog.idSavegameTitle:SetText(data.displayname)
  dialog.idPlaytime:SetText(T({
    195994741214,
    "<playtime>",
    playtime = Untranslated(playtime)
  }))
  if dialog.idGameDate then
    dialog.idGameDate:SetText(T({
      195994741214,
      "<playtime>",
      playtime = Untranslated(gametime)
    }))
  end
  if dialog.idTimestamp then
    dialog.idTimestamp:SetText(Untranslated(numberToTimeDate(data.timestamp, "real_time")))
  end
  if rawget(dialog, "idMap") then
    dialog.idMap:SetText(T({
      508260548760,
      "<map>",
      map = Untranslated(data.sector or "-")
    }))
  end
  if rawget(dialog, "idMoney") and data.money then
    dialog.idMoney:SetText(T({
      525863698106,
      "<money(Money)>",
      Money = data.money
    }))
  end
  if rawget(dialog, "idSquads") and data.player_squads then
    local numSquads = 0
    for _, units in pairs(data.player_squads) do
      numSquads = numSquads + 1
    end
    dialog.idSquads:SetText("")
    dialog.idSquadsTitle:SetText(T({
      609475183879,
      "<style SaveMapEntry> <squads_number> </style> <squads> / <style SaveMapEntry> <mercs_number> </style> <mercs>",
      squads_number = numSquads ~= 0 and numSquads or T(418403360394, "UNKNOWN"),
      mercs_number = data.all_units_sorted and #data.all_units_sorted or T(418403360394, "UNKNOWN"),
      squads = type(numSquads) == "number" and 1 < numSquads and Presets.SquadName.Default.Squads.Name or Presets.SquadName.Default.Squad.Name,
      mercs = type(data.all_units_sorted and #data.all_units_sorted) == "number" and data.all_units_sorted and 1 < #data.all_units_sorted and T(656958980161, "Mercs") or T(521796235967, "Merc")
    }))
  end
  if rawget(dialog, "idQuest") and data.active_quest then
    dialog.idQuest:SetText(Quests[data.active_quest].DisplayName)
  end
  if data.newSave then
    dialog.idProblem:SetText("")
  else
    local problem_text = ""
    if data and data.corrupt then
      problem_text = T(384520518199, "Save file is corrupted!")
    elseif data and data.incompatible then
      problem_text = T(117116727535, "Please update the game to the latest version to load this savegame.")
    elseif Platform.demo and not data.demoSave then
      problem_text = T(327575937173, "Save file requires the full version of the game.")
    elseif missing_dlcs and missing_dlcs ~= "" then
      problem_text = T({
        309852317927,
        "Missing downloadable content: <dlcs>",
        dlcs = Untranslated(missing_dlcs)
      })
    elseif mods_missing then
      problem_text = T(196062882816, "There are missing mods!")
    elseif data.required_lua_revision and LuaRevision < data.required_lua_revision then
      problem_text = T(329542364773, "Unknown save file format!")
    elseif data.lua_revision < config.SupportedSavegameLuaRevision then
      problem_text = T(191140516897, "Incompatible save game version!")
    end
    dialog.idProblem:SetText(problem_text)
  end
  if mods_string and mods_string ~= "" then
    dialog.idActiveMods:SetText(T({
      607303347157,
      "<style SaveMapEntryTitle>Installed mods: </style> <value>",
      value = Untranslated(mods_string)
    }))
  end
end
function ShowSavegameDescription(item, dialog)
  if not item then
    return
  end
  g_CurrentSaveGameItemId = false
  DeleteThread(g_SaveGameDescrThread)
  g_SaveGameDescrThread = CreateRealTimeThread(function(item, dialog)
    Savegame.CancelLoad()
    local metadata = item.metadata
    if dialog.window_state == "destroying" then
      return
    end
    local description = dialog:ResolveId("idDescription")
    if description then
      description:SetVisible(false)
    end
    if config.SaveGameScreenshot then
      if IsValidThread(g_SaveScreenShotThread) then
        WaitMsg("SaveScreenShotEnd")
      end
      Sleep(210)
    end
    if dialog.window_state == "destroying" then
      return
    end
    if not item.newSave then
      g_CurrentSaveGameItemId = item.id
    end
    local data = {}
    local err
    if item.newSave then
      data = item.metadata
      data.newSave = true
      data.displayname = item.savename
    elseif not metadata then
      data.displayname = _InternalTranslate(T(4182, "<<< New Savegame >>>"))
      data.timestamp = os.time()
      data.playtime = GetCurrentPlaytime()
      data.new_save = true
      data.lua_revision = config.SupportedSavegameLuaRevision
    else
      err = GetFullMetadata(metadata, "reload")
      if metadata.corrupt then
        data.corrupt = true
        data.displayname = _InternalTranslate(T(6907, "Damaged savegame"))
      elseif metadata.incompatible then
        data.displayname = _InternalTranslate(T(8648, "Incompatible savegame"))
      else
        data = table.copy(metadata)
        data.displayname = SavenameToName(item.savename)
      end
    end
    local mods_list, mods_string, mods_missing
    local max_mods, more = 30
    if data.active_mods and #data.active_mods > 0 then
      mods_list = {}
      for _, mod in ipairs(data.active_mods) do
        local local_mod = not table.find_value(ModsLoaded, "id", mod.id or mod) and Mods and Mods[mod.id or mod]
        if max_mods <= #mods_list then
          more = true
          break
        end
        table.insert(mods_list, mod.title or local_mod and local_mod.title)
        if not local_mod or not table.find(AccountStorage.LoadMods, mod.id or mod) then
          mods_missing = true
        end
      end
      mods_string = TList(mods_list, ", ")
      if more then
        mods_string = mods_string .. "<nbsp>..."
      end
    end
    local dlcs_list = {}
    for _, dlc in ipairs(data.dlcs or empty_table) do
      if not IsDlcAvailable(dlc.id) then
        dlcs_list[#dlcs_list + 1] = dlc.name
      end
    end
    SetSavegameDescriptionTexts(dialog, data, TList(dlcs_list), mods_string, mods_missing)
    if config.SaveGameScreenshot then
      local image = ""
      local forced_path = (not metadata or item.newSave) and g_TempScreenshotFilePath or false
      if not forced_path and Savegame._MountPoint then
        local images = io.listfiles(Savegame._MountPoint, "screenshot*.jpg", "non recursive")
        if 0 < #(images or "") then
          image = images[1]
        end
      elseif forced_path and io.exists(forced_path) then
        image = forced_path
      end
      local image_elem = dialog:ResolveId("idImage")
      if image_elem then
        if image ~= "" and not err then
          image_elem:SetImage(image)
        else
          image_elem:SetImage("UI/Common/placeholder.tga")
        end
      end
    end
    local description = dialog:ResolveId("idDescription")
    if description then
      description:SetVisible(true)
    end
  end, item, dialog)
end
function SaveLoadObject:Delete(dlg, list)
  local item
  if GetUIStyleGamepad() then
    item = g_SelectedSave
  else
    local list = list or dlg:ResolveId("idList")
    if not list or not list.focused_item then
      return
    end
    local ctrl = list[list.focused_item]:ResolveId("idNewSave") or list[list.focused_item]
    if not ctrl then
      return
    end
    item = ctrl and not ctrl.context.saves and ctrl.context
  end
  if item then
    local savename = item.metadata.savename
    CreateRealTimeThread(function(dlg, item, savename)
      if WaitQuestion(dlg.desktop, T(824112417429, "Warning"), T({
        912614823850,
        "Are you sure you want to delete the savegame <savename>?",
        savename = "\"" .. Untranslated(SavenameToName(item.savename)) .. "\""
      }), T(689884995409, "Yes"), T(782927325160, "No")) == "ok" then
        LoadingScreenOpen("idDeleteScreen", "delete savegame")
        local err = DeleteGame(savename)
        if not err then
          if g_CurrentSaveGameItemId == item.id then
            g_CurrentSaveGameItemId = false
            DeleteThread(g_SaveGameDescrThread)
          end
          self:RemoveItem(item.id)
          self:WaitGetSaveItems()
          Sleep(5)
          dlg:SetMode(GetDialogMode(dlg), self)
          dlg.parent:ResolveId("idSubSubContent"):SetMode("empty")
          if g_LatestSave and g_LatestSave.savename == savename then
            GetLatestSave()
          end
          LoadingScreenClose("idDeleteScreen", "delete savegame")
        else
          LoadingScreenClose("idDeleteScreen", "delete savegame")
          CreateErrorMessageBox("", "deletegame", nil, dlg.desktop, {
            name = "\"" .. Untranslated(SavenameToName(item.savename)) .. "\""
          })
        end
      end
    end, dlg, item, savename)
  end
end
function SavegameSessionDataFixups.DifficultyNaming(data, metadata, lua_ver)
  if lua_ver < 305167 then
    local diffName = data.game.game_difficulty
    if diffName == "Easy" then
      data.game.game_difficulty = "Normal"
    elseif diffName == "Normal" then
      data.game.game_difficulty = "Hard"
    elseif diffName == "Hard" then
      data.game.game_difficulty = "VeryHard"
    end
  end
end
DefineClass.Kalinka = {
  __parents = {"Kalyna"}
}
DefineClass.KalinkaPerk = {
  __parents = {"KalynaPerk"}
}
function SavegameSessionDataFixups.KalinkaPerkV2(data, metadata, lua_ver)
  if 310791 < lua_ver then
    return
  end
  if CharacterEffectDefs.KalinkaPerk then
    return
  end
  local newOne = CharacterEffectDefs.KalynaPerk
  local obj = g_Classes[newOne.class]:new()
  function obj:SetId(id)
    self.id = "KalinkaPerk"
  end
  obj:CopyProperties(newOne)
  obj.SetId = nil
  obj.SetGroup = nil
  obj.Comment = "Savegame Fixup - Dont Delete"
  obj.Save = empty_func
  function obj.IsDirty()
    return false
  end
  CharacterEffectDefs.KalinkaPerk = obj
end
function SavegameSessionDataFixups.KalinkaV2(data, metadata, lua_ver)
  if 310791 < lua_ver then
    return
  end
  if UnitDataDefs.Kalinka then
    return
  end
  local newOne = UnitDataDefs.Kalyna
  local obj = g_Classes[newOne.class]:new()
  function obj:SetId(id)
    self.id = "Kalinka"
  end
  obj:CopyProperties(newOne)
  obj.SetId = nil
  obj.SetGroup = nil
  obj.Appearance = false
  obj.Comment = "Savegame Fixup - Dont Delete"
  obj.Save = empty_func
  function obj.IsDirty()
    return false
  end
  UnitDataDefs.Kalinka = obj
  Mercenaries[#Mercenaries + 1] = "Kalinka"
end
function SavegameSessionDataFixups.NewGameStartedProp(data, metadata, lua_ver)
  if data.gvars.gv_Sectors and data.gvars.gv_Sectors.I1.reveal_allowed then
    data.game.CampaignStarted = true
  end
end
function XDesktop:OnFileDrop(filename)
  if string.ends_with(filename, ".sav", true) then
    CreateRealTimeThread(function()
      Savegame.Unmount()
      local error, mount_point = (Savegame._PlatformMountToMemory or Savegame._PlatformLoadToMemory)(filename)
      local err, metadata = LoadMetadata(mount_point)
      SaveLoadObject.DoLoadgame(nil, filename, metadata)
    end)
  end
end
function OverwriteSaveQuestion(saveObj)
  local newName = g_SelectedSave.newSaveName
  if g_SelectedSave.newSave then
    saveObj:DoSavegame(newName)
    WaitMsg("MPSaveGameDone")
  elseif WaitQuestion(terminal.desktop, T(824112417429, "Warning"), T({
    883071764117,
    "Are you sure you want to overwrite <savename>?",
    savename = "\"" .. Untranslated(SavenameToName(g_SelectedSave.savename) or g_SelectedSave.displayname) .. "\""
  }), T(689884995409, "Yes"), T(782927325160, "No")) == "ok" then
    saveObj:DoSavegame(newName, g_SelectedSave, true)
    WaitMsg("MPSaveGameDone")
  else
    return "break"
  end
end
function CanLoadSave(selectedSave)
  local oldRevCheck = selectedSave and selectedSave.metadata.lua_revision and selectedSave.metadata.lua_revision >= config.SupportedSavegameLuaRevision
  local demoCheck = selectedSave and (not Platform.demo or selectedSave.metadata.demoSave)
  return selectedSave and oldRevCheck and demoCheck
end
function CanDeleteSave(selectedSave)
  return selectedSave and not selectedSave.newSave and not g_CurrentlyEditingName
end
function LoadMetadataCallback(folder, params)
  local st = GetPreciseTicks()
  local err, metadata = LoadMetadata(folder)
  if err then
    return err
  end
  DebugPrint("Load Game:", [[

	lua_revision:]], metadata.lua_revision, [[

	assets_revision:]], metadata.assets_revision, "\n")
  if metadata.dlcs and #metadata.dlcs > 0 then
    DebugPrint([[

	dlcs:]], table.concat(table.map(metadata.dlcs, "id"), ", "), "\n")
  end
  if metadata.active_mods and 0 < #metadata.active_mods then
    DebugPrint([[

	mods:]], table.concat(table.map(metadata.active_mods, "id"), ", "), "\n")
  end
  local broken, change_current_map
  local map_name = RemapMapName(metadata.map)
  config.BaseMapFolder = ""
  if map_name and metadata.BaseMapNetHash then
    local map_meta = MapData[map_name]
    local terrain_hash = metadata.TerrainHash
    local requested_map_hash = terrain_hash or metadata.BaseMapNetHash
    local different_map = requested_map_hash ~= (terrain_hash and map_meta.TerrainHash or map_meta.NetHash)
    if different_map and config.TryRestoreMapVersionOnLoad then
      for map_id, map_data in pairs(MapData) do
        local map_data_hash = terrain_hash and map_data.TerrainHash or map_data.NetHash
        if map_data_hash == requested_map_hash and (not config.CompatibilityMapTest or map_data.ForcePackOld) then
          map_name = map_id
          different_map = false
          change_current_map = true
          break
        end
      end
    end
    if different_map then
      if not LoadAnyway(T(840159075107, "The game cannot be loaded because it requires a map that is not present or has a different version.")) then
        return "different map"
      end
      broken = table.create_set(broken, "DifferentMap", true)
    end
    config.BaseMapFolder = GetMapFolder(map_name)
    if CurrentMapFolder ~= "" then
      UnmountByPath(CurrentMapFolder)
    end
    CurrentMapFolder = config.BaseMapFolder
    local err = PreloadMap(map_name)
    CurrentMapFolder = ""
    if err then
      return err
    end
  end
  if metadata.dlcs then
    local missing_dlc_shown = false
    for _, dlc in ipairs(metadata.dlcs) do
      if not IsDlcAvailable(dlc.id) then
        if Platform.developer then
          if not missing_dlc_shown then
            if not LoadAnyway(T(1000849, "The game cannot be loaded because some required downloadable content is not installed.")) then
              return "missing dlc"
            end
            missing_dlc_shown = true
          end
        else
          WaitMessage(GetLoadingScreenDialog() or terminal.desktop, T(1000599, "Warning"), T(1000849, "The game cannot be loaded because some required downloadable content is not installed."), T(1000136, "OK"))
          return "missing dlc"
        end
        broken = table.create_set(broken, "MissingDLC", true)
      end
    end
  end
  if (metadata.lua_revision or 0) < config.SupportedSavegameLuaRevision then
    if not LoadAnyway(T(3685, "This savegame is from an old version and may not function properly.")) then
      return "old version"
    end
    broken = table.create_set(broken, "WrongLuaRevision", true)
  end
  local mods_list, more = GetMissingMods(metadata.active_mods, 5)
  if 0 < #mods_list then
    local mods_string = table.concat(mods_list, "\n")
    if more then
      mods_string = mods_string .. [[

...]]
    end
    local mods_err = T({
      632339072080,
      [[
Cannot load the game. The following mods are missing or outdated:

<mods>

]],
      mods = Untranslated(mods_string)
    })
    if not IsInMultiplayerGame() then
      if not LoadAnyway(mods_err) then
        return "missing mods"
      end
    else
      WaitMessage(GetLoadingScreenDialog() or terminal.desktop, T(1000599, "Warning"), mods_err, T(1000136, "OK"))
      return "missing dlc"
    end
    broken = table.create_set(broken, "MissingMods", true)
  end
  if not broken and metadata.broken and not LoadAnyway(T(1000851, "This savegame was loaded in the past without required mods or with an incompatible game version. It may not function properly.")) then
    return "saved broken"
  end
  err = GameSpecificLoadCallback(folder, metadata, params)
  if err then
    return err
  end
  if change_current_map then
    CurrentMap = map_name
    CurrentMapFolder = GetMapFolder(map_name)
    _G.mapdata = MapData[map_name]
  end
  metadata.broken = metadata.broken or broken or false
  SavegameMeta = metadata
  LoadedRealTime = RealTime()
  DebugPrint("Game Loaded in", GetPreciseTicks() - st, "ms\n")
end
function GetLatestSave()
  local saves = g_SaveGameObj or SaveLoadObjectCreateAndLoad()
  local incompatableSaves = {}
  saves:WaitGetSaveItems()
  if #saves.items > 0 then
    local latestSave = false
    for _, save in ipairs(saves.items) do
      local demoSaveCheck = not Platform.demo or save.metadata.demoSave
      local endDemoSave = Platform.demo and not not string.match(save.savename, "End of Demo")
      local oldGameVerSave = save.metadata.lua_revision and save.metadata.lua_revision < config.SupportedSavegameLuaRevision
      if not ShowIncompatableSaves and oldGameVerSave then
        table.insert(incompatableSaves, save)
      end
      if not save.metadata.corrupt and not oldGameVerSave and demoSaveCheck and not endDemoSave then
        if not latestSave then
          latestSave = save
        elseif latestSave.metadata.timestamp < save.metadata.timestamp then
          latestSave = save
        end
      end
    end
    g_LatestSave = latestSave
  else
    g_LatestSave = false
  end
  ObjModified("mm-buttons")
  if next(incompatableSaves) then
    local resp = WaitQuestion(terminal.desktop, T(678664063272, "Incompatible saves"), T(813704684824, "Some saves have been made on an older revision and will no longer work."), T(413525748743, "Ok"), T(579030110403, "Delete saves"))
    if resp ~= "ok" then
      LoadingScreenOpen("idDeleteScreen", "deleting incompatable saves")
      local err
      for _, save in ipairs(incompatableSaves) do
        if not err then
          local savename = save.metadata.savename
          err = DeleteGame(savename)
        end
      end
      LoadingScreenClose("idDeleteScreen", "deleting incompatable saves")
      CreateMessageBox(terminal.desktop, T(678664063272, "Incompatible saves"), not err and T(362910665084, "Incompatible saves deleted.") or T(341936080475, "Failed to delete incompatible saves."), T(413525748743, "Ok"))
    end
    ShowIncompatableSaves = true
  end
end
function SaveLoadObject:Load(dlg, item, skipAreYouSure)
  if item then
    local savename = item.savename
    g_SaveLoadThread = IsValidThread(g_SaveLoadThread) and g_SaveLoadThread or CreateRealTimeThread(function(dlg, savename)
      local metadata = item.metadata
      local err
      local parent = GetPreGameMainMenu() or GetInGameMainMenu() or dlg and dlg.parent or terminal.desktop
      if metadata and not metadata.corrupt and not metadata.incompatible then
        local in_game = GameState.gameplay
        local res = config.DefaultLoadAnywayAnswer or not (not in_game or skipAreYouSure) and WaitQuestion(parent, T(824112417429, "Warning"), T(927104451536, "Are you sure you want to load this savegame? Any unsaved progress will be lost."), T(689884995409, "Yes"), T(782927325160, "No")) or "ok"
        if res == "ok" then
          err = self:DoLoadgame(savename, metadata)
          if not err then
            CloseMenuDialogs()
          else
            ProjectSpecificLoadGameFailed(dlg)
          end
        end
      else
        err = metadata and metadata.incompatible and "incompatible" or "corrupt"
      end
      if err then
        parent = GetPreGameMainMenu() or GetInGameMainMenu() or dlg and dlg.parent or terminal.desktop
        if GetUIStyleGamepad() then
          parent:ResolveId("idSubMenu"):ResolveId("idScrollArea"):SelectFirstValidItem()
        end
        CreateErrorMessageBox(err, "loadgame", nil, parent, {
          name = "\"" .. Untranslated(item.text) .. "\""
        })
      end
    end, dlg, savename)
  end
end
