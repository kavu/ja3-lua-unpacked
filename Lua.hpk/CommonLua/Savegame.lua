sg_print = CreatePrint({})
function PlayWithoutStorage()
  return false
end
function OnMsg.CanSaveGameQuery(query)
  if GetMap() == "" then
    query.no_map = true
  end
  if GameState.Tutorial and not GetDialog(config.BugReporterXTemplateID) and not Platform.developer then
    query.tutorial = true
  end
  if IsEditorActive() then
    query.editor_active = true
  end
  if PlayWithoutStorage() then
    query.play_without_storage = true
  end
  if StoringSaveGame then
    query.storing = true
  end
  if mapdata and not mapdata.GameLogic then
    query.no_game_logic = true
  end
end
function CanSaveGame(request)
  local query = {}
  Msg("CanSaveGameQuery", query, request)
  if not next(query) then
    return "persist"
  end
  return nil, query
end
StopAutosaveThread = empty_func
Savegame = {
  _PlatformSaveFromMemory = function(savename, displayname)
    return "Not implemented"
  end,
  _PlatformLoadToMemory = function(savename)
    return "Not implemented"
  end,
  _PlatformDelete = function(savename)
    return "Not implemented"
  end,
  _PlatformList = function()
    return "Not implemented"
  end,
  _PlatformListFileNames = function()
    return "Not implemented"
  end,
  _PlatformCopy = function(savename_from, savename_to)
    return "Not implemented"
  end,
  _PlatformProlog = function()
  end,
  _PlatformEpilog = function()
  end,
  _PlatformMountToMemory = false,
  _PlatformUnmountMemory = empty_func,
  _CancelLoadToMemory = empty_func,
  _MountPoint = false,
  ScreenshotName = "screenshot.jpg",
  ScreenshotWidth = 960,
  ScreenshotHeight = 640
}
if FirstLoad then
  SavegamesList = {invalid = true, error = false}
  SavingGame = false
  StoringSaveGame = false
  SavegameRunningThread = false
end
function SavegamesList:Reset()
  self.invalid = true
  self.error = false
  table.iclear(self)
end
function SavegamesList:OnNew(metadata)
  SavegamesList:OnDelete(metadata.savename)
  table.insert(self, 1, metadata)
end
function SavegamesList:OnDelete(savename)
  local idx = table.find(self, "savename", savename)
  if idx then
    table.remove(self, idx)
  end
end
function SavegamesList:Refresh()
  if self.invalid then
    self:Reset()
    local error, list = Savegame._PlatformList()
    self.error = error
    if type(list) == "table" then
      if Platform.desktop then
        table.sortby_field_descending(list, "timestamp")
      else
        table.sortby_field_descending(list, "savename")
      end
      self.invalid = false
      for i = 1, #list do
        self[i] = list[i]
      end
    end
  end
  return self.error
end
function SavegamesList:Last()
  return not self.invalid and self[1]
end
function SavegamesList:GenerateFilename(tag)
  if self.invalid then
    return
  end
  local timestamp = os.time()
  if tag and tag ~= "" then
    return string.format("%010d.%s.sav", timestamp, tag)
  else
    return string.format("%010d.sav", timestamp)
  end
end
function OnMsg.DeviceChanged()
  SavegamesList.invalid = true
end
function Savegame._UniqueName(displayname, tag, params)
  local timestamp = os.time()
  local tag = tag and tag ~= "" and "." .. tag or ""
  if Platform.desktop then
    local displayname = CanonizeSaveGameName(displayname)
    local proposed_name = string.format("%s%s.%s", displayname, tag, "sav")
    local force_overwrite = params and params.force_overwrite
    if not force_overwrite and io.exists(GetPCSaveFolder() .. proposed_name) then
      local error, files = AsyncListFiles(GetPCSaveFolder(), string.format("%s(*)%s.%s", displayname, tag, "sav"), "relative")
      local pattern_name = EscapePatternMatchingMagicSymbols(displayname)
      local pattern = pattern_name .. "%((%d+)%)" .. (tag ~= "" and "%" or "") .. tag .. "%.sav$"
      local max_idx = 1
      for i = 1, #files do
        local index = tonumber(string.match(files[i]:lower(), pattern:lower()))
        max_idx = Max(index, max_idx)
      end
      return string.format("%s(%d)%s.%s", displayname, max_idx + 1, tag, "sav"), timestamp
    else
      return proposed_name, timestamp
    end
  else
    return string.format("%010d%s.sav", timestamp, tag), timestamp
  end
end
function Savegame._BackupName(savename)
  return savename .. ".bak"
end
function Savegame._Wrap(func)
  return function(...)
    while IsValidThread(SavegameRunningThread) do
      WaitMsg(SavegameRunningThread, 111)
    end
    local thread = CurrentThread() or false
    SavegameRunningThread = thread
    Savegame._PlatformProlog()
    local results = pack_params(sprocall(func, ...))
    if not results[1] then
      print("Savegame error:", results[2])
    end
    Savegame._PlatformEpilog()
    if thread then
      Msg(thread)
    end
    SavegameRunningThread = false
    if results[1] then
      return unpack_params(results, 2)
    else
      return "Failed"
    end
  end
end
function Savegame._InternalSave(metadata, save_callback, params)
  sg_print("Saving", metadata)
  params = params or {}
  local backup = params.backup
  Savegame.Unmount()
  local error
  if backup then
    local backupname = Savegame._BackupName(metadata.savename)
    error = Savegame._PlatformCopy(metadata.savename, backupname)
    if error then
      if error ~= "File Not Found" and error ~= "Path Not Found" then
        IgnoreError(error, "SavedataSave/backup")
      end
      error = false
    end
  end
  local mount_point
  error, mount_point = MemorySavegameCreateEmpty()
  if error then
    return error
  end
  error = SaveMetadata(mount_point, metadata)
  if error then
    return error
  end
  error = save_callback(mount_point, metadata, params)
  if not error then
    StoringSaveGame = true
    CreateRealTimeThread(function()
      Msg("StoreSaveGame", true)
      local err = Savegame._PlatformSaveFromMemory(metadata.savename, metadata.displayname)
      Msg("StoreSaveGame", false)
      if err then
        CreateErrorMessageBox(err, "savegame", nil, nil, {
          savename = T({
            129666099950,
            "\"<name>\"",
            name = Untranslated(metadata.savename)
          }),
          error_code = Untranslated(err)
        })
      end
      StoringSaveGame = false
      if not err then
        metadata.loaded = true
        SavegamesList:OnNew(metadata)
      end
    end)
  end
  return error
end
function Savegame.Unmount()
  if Savegame._MountPoint then
    Savegame._PlatformUnmountMemory()
    Savegame._MountPoint = false
  end
end
function Savegame._InternalLoad(savename, load_callback, params)
  Savegame.Unmount()
  local dir = GetPathDir(savename)
  local err, mount_point
  if dir ~= "" and io.exists(savename) then
    err, mount_point = MountToMemory_Desktop(savename)
  else
    err, mount_point = (Savegame._PlatformMountToMemory or Savegame._PlatformLoadToMemory)(savename)
  end
  if err then
    return err
  end
  err = load_callback(mount_point, params)
  if err then
    return err
  end
  Savegame._MountPoint = mount_point
end
function Savegame._InternalLoadWithBackup(savename, load_callback)
  local error_original = Savegame._InternalLoad(savename, load_callback)
  if not error_original then
    return
  end
  local error_backup = Savegame._InternalLoad(Savegame._BackupName(savename), load_callback)
  if error_backup then
    if error_backup ~= "File Not Found" and error_backup ~= "Path Not Found" then
      IgnoreError(error_backup, "SavedataLoad - load from backup")
    end
    return error_original
  end
  if error_original ~= "File Not Found" and error_original ~= "Path Not Found" then
    local error_delete = Savegame._PlatformDelete(savename)
    if error_delete then
      IgnoreError(error_delete, "SavedataLoad - delete original")
    end
  end
end
function Savegame._InternalDeleteWithBackup(savename)
  Savegame.Unmount()
  local error_backup = Savegame._PlatformDelete(Savegame._BackupName(savename))
  if error_backup and error_backup ~= "File Not Found" and error_backup ~= "Path Not Found" then
    return error_backup
  end
  local error = Savegame._PlatformDelete(savename)
  if error then
    return error
  else
    SavegamesList:OnDelete(savename)
  end
end
function Savegame._InternalListForTag(tag)
  local error = SavegamesList:Refresh()
  if error then
    return error
  end
  if type(tag) == "string" then
    local list = {}
    for i = 1, #SavegamesList do
      local match = {
        string.match(SavegamesList[i].savename, "^.*%.(%w+)%.sav$")
      }
      if match[1] and tag == match[1] or not match[1] and tag == "" then
        table.insert(list, table.copy(SavegamesList[i], "deep"))
      end
    end
    return nil, list
  else
    if type(tag) == "table" then
      local list = {}
      for i = 1, #tag do
        local error, taglist = Savegame._InternalListForTag(tag[i])
        if error then
          return error
        end
        table.iappend(list, taglist)
      end
      table.sortby_field_descending(list, "savename")
      return nil, list
    else
    end
  end
end
function Savegame._InternalCountForTag(tag)
  local error, files = Savegame._PlatformListFileNames()
  if error then
    return error
  end
  if type(tag) == "string" then
    local count = 0
    for i = 1, #(files or "") do
      local match = {
        string.match(files[i], "^.*%.(%w+)%.sav$")
      }
      if match[1] and tag == match[1] or not match[1] and tag == "" then
        count = count + 1
      end
    end
    return nil, count
  else
    if type(tag) == "table" then
      local count = 0
      for i = 1, #tag do
        local error, tag_count = Savegame._InternalCountForTag(tag[i])
        if error then
          return error
        end
        count = count + tag_count
      end
      return nil, count
    else
    end
  end
end
function Savegame._DefaultCopy(savename_from, savename_to)
  local error, mount_point = Savegame._PlatformLoadToMemory(savename_from)
  if error then
    return error
  end
  local metadata
  error, metadata = LoadMetadata(mount_point)
  if error then
    return error
  end
  return Savegame._PlatformSaveFromMemory(savename_to, metadata.displayname)
end
if Platform.desktop then
  function GetSavePath(savename)
    local dir = GetPathDir(savename)
    if dir == "" then
      savename = GetPCSaveFolder() .. savename
    end
    return savename
  end
  function Savegame._PlatformSaveFromMemory(savename, displayname)
    return SaveFromMemory_Desktop(GetSavePath(savename), displayname)
  end
  function Savegame._PlatformLoadToMemory(savename)
    return LoadToMemory_Desktop(GetSavePath(savename))
  end
  function Savegame._PlatformDelete(savename)
    return AsyncFileDelete(GetSavePath(savename))
  end
  function Savegame._PlatformCopy(savename_from, savename_to)
    return AsyncCopyFile(GetSavePath(savename_from), GetSavePath(savename_to), "raw")
  end
  function Savegame._PlatformMountToMemory(savename)
    return MountToMemory_Desktop(GetSavePath(savename))
  end
  Savegame._PlatformUnmountMemory = UnmountMemory_Desktop
  function Savegame._PlatformList()
    local error, files = AsyncListFiles(GetPCSaveFolder(), "*.sav", "relative")
    if error then
      return error
    end
    local savegames = {}
    for i = 1, #files do
      do
        local savename = files[i]
        local savelist_data = false
        local error = Savegame._InternalLoad(savename, function(folder)
          local err, metadata = LoadMetadata(folder)
          if err then
            return err
          end
          if metadata then
            if metadata.required_lua_revision and metadata.required_lua_revision > LuaRevision then
              return "File is incompatible"
            end
            metadata.savename = savename
            metadata.loaded = true
            savelist_data = metadata
          end
        end)
        if error or not savelist_data then
          local name = T(857405002607, "Damaged savegame")
          if error == "File is incompatible" then
            name = T(365970916765, "Incompatible savegame")
          end
          savelist_data = {
            corrupt = error ~= "File is incompatible",
            incompatible = error == "File is incompatible",
            savename = savename,
            displayname = _InternalTranslate(name),
            timestamp = os.time()
          }
        end
        savegames[1 + #savegames] = savelist_data
      end
    end
    return nil, savegames
  end
  function Savegame._PlatformListFileNames()
    local error, files = AsyncListFiles(GetPCSaveFolder(), "*.sav", "relative")
    if error then
      return error
    end
    return nil, files
  end
end
if Platform.playstation then
  function Savegame._PlatformList()
    local err, files = AsyncPlayStationSaveDataList()
    if err then
      return err
    end
    local savegames = {}
    for i = 1, #files do
      do
        local savename = files[i][1]
        local savelist_data = false
        local error = Savegame._InternalLoad(savename, function(folder)
          local err, metadata = LoadMetadata(folder)
          if err then
            return err
          end
          if metadata then
            metadata.savename = savename
            metadata.loaded = true
            savelist_data = metadata
          end
        end)
        savelist_data = not error and savelist_data or {
          corrupt = true,
          savename = savename,
          displayname = _InternalTranslate(T(857405002607, "Damaged savegame")),
          timestamp = os.time()
        }
        savegames[1 + #savegames] = savelist_data
      end
    end
    return nil, savegames
  end
  function Savegame._PlatformProlog()
    while StoringSaveGame do
      Sleep(1)
    end
  end
  function Savegame._PlatformListFileNames()
    local error = SavegamesList:Refresh()
    if error then
      return error
    end
    local file_names = {}
    for i = 1, #SavegamesList do
      table.insert(file_names, SavegamesList[i].savename)
    end
    return nil, file_names
  end
  function Savegame._PlatformSaveFromMemory(savename, displayname)
    local err, required_space = AsyncPlayStationSaveRequiredSize()
    if err == "Disk Full" then
      AsyncPlayStationShowFreeSpaceDialog(required_space)
      err, required_space = AsyncPlayStationSaveRequiredSize()
    end
    if err then
      return err
    end
    local err, total_size = AsyncPlayStationSaveDataTotalSize()
    if err then
      return err
    end
    if total_size + required_space > const.PlayStationMaxSaveDataSizePerUser then
      return "Save Storage Full"
    end
    return AsyncPlayStationSaveFromMemory(savename, displayname, required_space)
  end
  Savegame._PlatformLoadToMemory = AsyncPlayStationLoadToMemory
  Savegame._PlatformDelete = AsyncPlayStationSaveDataDelete
  Savegame._PlatformCopy = Savegame._DefaultCopy
end
if Platform.xbox then
  function Savegame._PlatformSaveFromMemory(savename, displayname)
    if not Xbox.IsUserSigned() then
      return "NoUser"
    end
    local err = Xbox.StoreSave(savename, displayname)
    if err then
      Xbox.DeleteSave(savename)
    end
    return err
  end
  function Savegame._PlatformLoadToMemory(savename)
    if not Xbox.IsUserSigned() then
      return "NoUser"
    end
    return Xbox.MountReadContent(savename)
  end
  function Savegame._PlatformDelete(savename)
    if not Xbox.IsUserSigned() then
      return "NoUser"
    end
    return Xbox.DeleteSave(savename)
  end
  function Savegame._PlatformList()
    if not Xbox.IsUserSigned() then
      return "NoUser"
    end
    local err, files = Xbox.GetSaveList()
    if err then
      return err
    end
    local savegames = {}
    for i = 1, #files do
      do
        local savename = files[i][1]
        local savelist_data = false
        local error = Savegame._InternalLoad(savename, function(folder)
          local err, metadata = LoadMetadata(folder)
          if err then
            return err
          end
          if metadata then
            metadata.savename = savename
            metadata.loaded = true
            savelist_data = metadata
          end
        end)
        savelist_data = not error and savelist_data or {
          corrupt = true,
          savename = savename,
          displayname = _InternalTranslate(T(857405002607, "Damaged savegame")),
          timestamp = os.time()
        }
        savegames[1 + #savegames] = savelist_data
      end
    end
    return nil, savegames
  end
  function Savegame._PlatformListFileNames()
    local error = SavegamesList:Refresh()
    if error then
      return error
    end
    local file_names = {}
    for i = 1, #SavegamesList do
      table.insert(file_names, SavegamesList[i].savename)
    end
    return nil, file_names
  end
  Savegame._PlatformCopy = Savegame._DefaultCopy
end
if Platform.switch then
  function Savegame._PlatformSaveFromMemory(savename, displayname)
    local err = SaveFromMemory_Desktop("saves:/" .. savename, displayname)
    Switch.CommitSaveData()
    return err
  end
  function Savegame._PlatformLoadToMemory(savename)
    return LoadToMemory_Desktop("saves:/" .. savename)
  end
  function Savegame._PlatformDelete(savename)
    return AsyncFileDelete("saves:/" .. savename)
  end
  function Savegame._PlatformCopy(savename_from, savename_to)
    return AsyncCopyFile("saves:/" .. savename_from, "saves:/" .. savename_to, "raw")
  end
  function Savegame._PlatformList()
    local error, files = AsyncListFiles("saves:/", "*.sav", "relative")
    if error then
      return error
    end
    local savegames = {}
    for i = 1, #files do
      do
        local savename = files[i]
        local savelist_data = false
        local error = Savegame._InternalLoad(savename, function(folder)
          local err, metadata = LoadMetadata(folder)
          if err then
            return err
          end
          if metadata then
            metadata.savename = savename
            metadata.loaded = true
            savelist_data = metadata
          end
        end)
        savelist_data = not error and savelist_data or {
          corrupt = true,
          savename = savename,
          displayname = _InternalTranslate(T(857405002607, "Damaged savegame")),
          timestamp = os.time()
        }
        savegames[1 + #savegames] = savelist_data
      end
    end
    return nil, savegames
  end
  function Savegame._PlatformListFileNames()
    local error, files = AsyncListFiles("saves:/", "*.sav", "relative")
    if error then
      return error
    end
    return nil, files
  end
end
function AddSystemMetadata(metadata)
  local required_revision = config.SavegameRequiredLuaRevision
  if required_revision == -1 then
    required_revision = LuaRevision
  end
  metadata.lua_revision = LuaRevision
  metadata.assets_revision = AssetsRevision
  metadata.required_lua_revision = required_revision
  metadata.platform = Platform
  metadata.real_time = RealTime()
  FillDlcMetadata(metadata)
end
function SaveMetadata(folder, metadata)
  AddSystemMetadata(metadata)
  return AsyncStringToFile(folder .. "savegame_metadata", TableToLuaCode(metadata))
end
function LoadMetadata(folder)
  local filename = folder .. "savegame_metadata"
  return FileToLuaValue(filename, {})
end
function UnpersistGame(folder, metadata, params)
  Msg("PreLoadGame", metadata)
  local err, version = EngineLoadGame(folder .. "persist", metadata)
  if err then
    if CurrentMapFolder == "" then
      CurrentMapFolder = GetMap()
    end
    if CurrentMap == "" then
      CurrentMap = "preloaded map"
    end
    DoneMap()
    ChangeMap("")
    return err
  end
  Msg("LoadGame", metadata, version, params)
  FixupSavegame(metadata)
  Msg("PostLoadGame", metadata, version)
end
function ReportPersistErrors()
  for _, err in ipairs(__error_table__) do
    print("Persist error:", err.error or "unknown")
    print("Persist stack:")
    for _, value in ipairs(err) do
      print("   ", tostring(value))
    end
    print()
  end
end
function PersistGame(folder)
  collectgarbage("collect")
  rawset(_G, "__error_table__", {})
  local filename = folder .. "persist"
  local err = EngineSaveGame(filename)
  ReportPersistErrors()
  if not Platform.developer then
    rawset(_G, "__error_table__", false)
  end
  return err
end
Savegame._WrappedSave = Savegame._Wrap(Savegame._InternalSave)
function Savegame.WithTag(tag, displayname, save_callback, metadata, params)
  params = params or {}
  local savename, timestamp = Savegame._UniqueName(displayname, tag, params)
  metadata = metadata or {}
  metadata.savename = savename
  metadata.displayname = displayname
  metadata.timestamp = timestamp
  metadata.playtime = GetCurrentPlaytime()
  params.backup = false
  return Savegame._WrappedSave(metadata, save_callback, params), savename
end
function Savegame.WithName(savename, displayname, save_callback, metadata, params)
  params = params or {}
  metadata = metadata or {}
  metadata.savename = savename
  metadata.displayname = displayname
  metadata.timestamp = os.time()
  metadata.playtime = GetCurrentPlaytime()
  params.backup = false
  return Savegame._WrappedSave(metadata, save_callback, params)
end
function Savegame.WithBackup(savename, displayname, save_callback, metadata, params)
  params = params or {}
  metadata = metadata or {}
  metadata.savename = savename
  metadata.displayname = displayname
  metadata.timestamp = os.time()
  metadata.playtime = GetCurrentPlaytime()
  params.backup = true
  return Savegame._WrappedSave(metadata, save_callback, params)
end
Savegame.LoadWithBackup = Savegame._Wrap(Savegame._InternalLoadWithBackup)
Savegame.Load = Savegame._Wrap(Savegame._InternalLoad)
Savegame.Delete = Savegame._Wrap(Savegame._InternalDeleteWithBackup)
Savegame.ListForTag = Savegame._Wrap(Savegame._InternalListForTag)
Savegame.CountForTag = Savegame._Wrap(Savegame._InternalCountForTag)
Savegame.CancelLoad = Savegame._CancelLoadToMemory
function GetFullMetadata(metadata, reload)
  if metadata.corrupt then
    return "File is corrupt"
  elseif metadata.incompatible then
    return "File is incompatible"
  elseif metadata.loaded and not reload then
    return
  end
  local loaded_meta
  local savename = metadata.savename
  local err = Savegame.Load(metadata.savename, function(folder)
    local load_err
    load_err, loaded_meta = LoadMetadata(folder)
    if load_err then
      return load_err
    end
    if loaded_meta and loaded_meta.required_lua_revision and loaded_meta.required_lua_revision > LuaRevision then
      return "File is incompatible"
    end
  end)
  if err then
    metadata.incompatible = err == "File is incompatible"
    metadata.corrupt = err ~= "File is incompatible"
    return err
  end
  for key, val in pairs(loaded_meta or empty_table) do
    metadata[key] = val
  end
  metadata.savename = savename
  metadata.loaded = true
end
function DeleteGame(name)
  local err = Savegame.Delete(name)
  if not err then
    Msg("SavegameDeleted", name)
  end
  return err
end
function WaitCountSaveGames()
  if PlayWithoutStorage() then
    return 0
  end
  local err, count = Savegame.CountForTag("savegame")
  return not err and count or 0
end
function GameSpecificSaveCallback(folder, metadata, params)
end
function GameSpecificLoadCallback(folder, metadata, params)
end
function GameSpecificSaveCallbackBugReport(folder, metadata)
  return PersistGame(folder)
end
function DoSaveGame(display_name, params)
  WaitChangeMapDone()
  WaitSaveGameDone()
  SavingGame = true
  params = params or {}
  Msg("SaveGameStart", params)
  local metadata = GatherGameMetadata(params)
  local autosave = params.autosave
  if autosave then
    metadata.autosave = autosave
  end
  local err, name
  if params.savename then
    err = Savegame.WithName(params.savename, display_name, GameSpecificSaveCallback, metadata, params)
    name = params.savename
  else
    err, name = Savegame.WithTag("savegame", display_name, GameSpecificSaveCallback, metadata, params)
  end
  SavingGame = false
  if not err and params.save_as_last then
    LocalStorage.last_save = name
    SaveLocalStorage()
  end
  Msg("SaveGameDone", name, autosave, err)
  return err, name
end
function WaitSaveGameDone()
  if SavingGame then
    WaitMsg("SaveGameDone")
  end
end
function SaveGame(display_name, params)
  params = params or {}
  local silent = params.silent
  if not silent then
    LoadingScreenOpen("idLoadingScreen", "save savegame")
  end
  WaitRenderMode("ui")
  local err, name = DoSaveGame(display_name, params)
  WaitRenderMode("scene")
  if not silent then
    LoadingScreenClose("idLoadingScreen", "save savegame")
  end
  return err, name
end
function LoadGame(savename, params)
  local st = GetPreciseTicks()
  params = params or {}
  LoadingScreenOpen("idLoadingScreen", "load savegame")
  WaitRenderMode("ui")
  local err = Savegame.Load(savename, LoadMetadataCallback, params)
  local loaded_map = GetMap()
  if loaded_map ~= "" then
    WaitRenderMode("scene")
  end
  if params.save_as_last and not err then
    LocalStorage.last_save = savename
    SaveLocalStorage()
  end
  LoadingScreenClose("idLoadingScreen", "load savegame")
  if err then
    print("LoadGame error:", err)
  else
    DebugPrint("Game loaded on map", CurrentMap, "in", GetPreciseTicks() - st, "ms\n")
  end
  return err
end
function SaveGameBugReport(display_name, screenshot)
  return DoSaveGame(display_name)
end
function SaveGameBugReportPStr(display_name)
  WaitChangeMapDone()
  local err, mount_point
  err, mount_point = MemorySavegameCreateEmpty()
  if err then
    return err
  end
  local metadata = GatherBugReportMetadata(display_name)
  err = SaveMetadata(mount_point, metadata)
  if err then
    return err
  end
  err = GameSpecificSaveCallbackBugReport(mount_point)
  if err then
    return err
  end
  return err, MemorySaveGamePStr(0, MemorySaveGameSize())
end
function Savegame.Import(filepath_from, savename_to)
  local err = LoadToMemory_Desktop(filepath_from)
  if err then
    return err
  end
  local savename, _ = Savegame._UniqueName(savename_to, "savegame")
  return Savegame._PlatformSaveFromMemory(savename, savename_to)
end
function Savegame.Export(savename_from, filepath_to)
  local filedir_to, _, _ = SplitPath(filepath_to)
  local err = AsyncCreatePath(filedir_to)
  if err then
    return err
  end
  err = MountPack("exported", filepath_to, "create,compress")
  if err then
    return err
  end
  err = Savegame.LoadWithBackup(savename_from, function(folder)
    local err, files = AsyncListFiles(folder, "*", "relative")
    if err then
      return err
    end
    for i = 1, #files do
      err = AsyncCopyFile(folder .. files[i], "exported/" .. files[i], "raw")
      if err then
        return err
      end
    end
  end)
  UnmountByPath("exported")
  return err
end
if not Platform.cmdline and Platform.pc and Platform.developer then
  function RegisterSavFileHandler()
    local path = ConvertToOSPath(GetExecName())
    if not path or not io.exists(path) then
      return
    end
    local name = "hg-" .. const.ProjectName
    local reg = string.format("reg add HKCU\\Software\\Classes\\%s\\shell\\open\\command /f /d \"cmd /c start \\\"%s\\\" /d \\\"%s\\\" \\\"%s\\\" -save \\\"%%1\\\"\"", name, const.ProjectName, GetCWD(), path)
    local err, code = AsyncExec(reg, "", true, true)
    if not err and code == 0 then
      reg = "reg add HKCU\\Software\\Classes\\.sav\\OpenWithProgids /f /v \"" .. name .. "\""
      err, code = AsyncExec(reg, "", true, true)
    end
  end
  if FirstLoad and config.RegisterSavFileHandler then
    CreateRealTimeThread(RegisterSavFileHandler)
  end
end
if Platform.developer then
  if FirstLoad then
    DbgSaveDesync = false
  end
  function DbgToggleSaveSyncTest()
    DbgSaveDesync = not DbgSaveDesync
    if not DbgSaveDesync then
      DbgSyncTestStop()
    end
    print("Save Sync Test:", DbgSaveDesync)
  end
  function OnMsg.LoadGame(meta)
    DeleteThread(DbgSyncTestThread)
    if not DbgSaveDesync or Libs.Network ~= "sync" then
      return
    end
    DbgSyncTestStart(table.hash(meta))
    DbgSyncTestTrack()
  end
end
