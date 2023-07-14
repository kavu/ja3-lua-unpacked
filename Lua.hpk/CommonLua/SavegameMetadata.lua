MapVar("SavegameMeta", false)
MapVar("LoadedRealTime", false)
PersistableGlobals.SavegameMeta = false
PersistableGlobals.LoadedRealTime = false
function GetLoadedModsSavegameData()
  if not config.Mods then
    return
  end
  local active_mods = SavegameMeta and SavegameMeta.active_mods or {}
  for _, mod in ipairs(ModsLoaded or empty_table) do
    local idx = table.find(active_mods, "id", mod.id) or #active_mods + 1
    active_mods[idx] = {
      id = mod.id,
      title = mod.title,
      version = mod.version,
      lua_revision = mod.lua_revision
    }
  end
  return active_mods
end
function GatherGameMetadata(params)
  params = params or empty_table
  local save_terrain_grid_delta = config.SaveTerrainGridDelta and not params.include_full_terrain
  local map = RemapMapName(GetMapName())
  local mapdata = MapData[map] or mapdata
  local metadata = {
    map = map,
    active_mods = GetLoadedModsSavegameData(),
    BaseMapNetHash = save_terrain_grid_delta and mapdata.NetHash or nil,
    TerrainHash = save_terrain_grid_delta and mapdata.TerrainHash or nil,
    GameTime = GameTime(),
    broken = SavegameMeta and SavegameMeta.broken or nil
  }
  Msg("GatherGameMetadata", metadata)
  config.BaseMapFolder = save_terrain_grid_delta and GetMapFolder(map) or ""
  return metadata
end
function GetMissingMods(active_mods, max_mods)
  local mods_list, more = {}
  for _, mod in ipairs(active_mods or empty_table) do
    local local_mod = table.find_value(ModsLoaded, "id", mod.id or mod) or Mods[mod.id or mod]
    if not (not ((mod.lua_revision or 0) > LuaRevision) and not ((mod.lua_revision or 9999999) < ModMinLuaRevision) and local_mod and table.find(AccountStorage.LoadMods, mod.id or mod)) or local_mod and local_mod.version < (mod.version or 0) then
      if max_mods <= #mods_list then
        more = true
        break
      end
      mods_list[#mods_list + 1] = mod.title or local_mod and local_mod.title
    end
  end
  return mods_list, more
end
function LoadAnyway(err, alt_option)
  DebugPrint([[

Load anyway]], ":", _InternalTranslate(err), [[


]])
  local default_load_anyway = config.DefaultLoadAnywayAnswer
  if default_load_anyway ~= nil then
    return default_load_anyway
  end
  local parent = GetLoadingScreenDialog() or terminal.desktop
  local choice = WaitMultiChoiceQuestion(parent, T(1000599, "Warning"), err, nil, T(3686, "Load anyway"), T(1000246, "Cancel"), alt_option)
  return choice ~= 2, choice == 3
end
function LoadMetadataCallback(folder, params)
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
    local map_hash = map_meta and (terrain_hash and map_meta.TerrainHash or map_meta.NetHash)
    local different_map = requested_map_hash ~= map_hash
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
  local mods_list, more = GetMissingMods(metadata.active_mods, 3)
  if 0 < #mods_list then
    local mods_string = table.concat(mods_list, "\n")
    if more then
      mods_string = mods_string .. [[

...]]
    end
    local mod_backend = GetModsBackendClass()
    local mods_err = T({
      1000850,
      [[
The following mods are missing or outdated:

<mods>

Some features may not work.]],
      mods = Untranslated(mods_string)
    })
    if config.Mods and mod_backend then
      local ok, alt = LoadAnyway(mods_err, T(639324617584, "Download mods"))
      if not ok then
        return "missing mods"
      end
      if alt then
        CreateRealTimeThread(OpenBackendModsUI)
        return "download mods"
      end
    elseif not LoadAnyway(mods_err) then
      return "missing mods"
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
end
function GetOrigRealTime()
  local orig_real_time = LoadedRealTime and SavegameMeta and SavegameMeta.real_time
  if not orig_real_time then
    return RealTime()
  end
  return RealTime() - LoadedRealTime + orig_real_time
end
MapVar("OrigLuaRev", function()
  return LuaRevision
end)
MapVar("OrigAssetsRev", function()
  return AssetsRevision
end)
function OnMsg.BugReportStart(print_func)
  local lua_revision = SavegameMeta and SavegameMeta.lua_revision
  if lua_revision then
    local supported_str = lua_revision >= config.SupportedSavegameLuaRevision and "/" or " (unsupported!) /"
    print_func("Savegame Rev:", lua_revision, supported_str, SavegameMeta.assets_revision)
  end
  if OrigLuaRev and OrigLuaRev ~= LuaRevision then
    print_func("Game Start Rev:", OrigLuaRev, OrigAssetsRev)
  end
  if SavegameMeta and type(SavegameMeta.broken) == "table" then
    print_func("Savegame Errors:", table.concat(table.keys(SavegameMeta.broken, true), ","))
  end
end
