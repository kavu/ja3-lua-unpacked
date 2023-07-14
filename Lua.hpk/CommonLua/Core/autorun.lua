Loading = true
os.setlocale("C")
collectgarbage("stop")
if FirstLoad == nil then
  FirstLoad = true
  ReloadForDlc = false
  LuaRevision = 0
  OrgLuaRevision = 0
  AssetsRevision = 0
  BuildVersion = false
  BuildBranch = false
  setmetatable(_G, {
    __index = function(table, key)
      if key == "class" then
        return ""
      end
      if key == "__ancestors" then
        return empty_table
      end
      error("Attempt to use an undefined global '" .. tostring(key) .. "'", 1)
    end,
    __newindex = function(table, key, value)
      if not Loading and PersistableGlobals[key] == nil then
        error("Attempt to create a new global " .. tostring(key), 1)
      end
      rawset(table, key, value)
    end,
    __toluacode = function(value, indent)
      return indent and indent .. "_G" or "_G"
    end
  })
  _ALERT = 0
  package.path = ""
  package.searchers = {
    package.searchers[1]
  }
  editor = rawget(_G, "editor") or {}
end
PersistableGlobals = {}
pathfind = {}
config = {}
LibsList = {}
Libs = setmetatable({}, {
  __index = LibsList,
  __newindex = function(_, lib, load)
    if load then
      LibsList[lib] = load
      table.insert_unique(LibsList, lib)
    else
      LibsList[lib] = nil
      table.remove_entry(LibsList, lib)
    end
  end
})
function ForEachLib(path, func, ...)
  for _, lib in ipairs(LibsList) do
    local lib_path = path and string.format("CommonLua/Libs/%s/%s", lib, path)
    if not lib_path or io.exists(lib_path) then
      func(lib, lib_path, ...)
    end
  end
end
LoadingBlacklist = {}
if FirstLoad then
  GamepadUIStyle = {
    [1] = false
  }
end
if not Platform.cmdline then
  Platform.developer = not Platform.goldmaster and io.exists("developer.lua") or nil
end
dofile("CommonLua/Core/cthreads.lua")
dofile("CommonLua/Core/lib.lua")
dofile("CommonLua/Core/types.lua")
dofile("CommonLua/Core/ToLuaCode.lua")
dofile("CommonLua/Core/config.lua")
if not Platform.cmdline then
  if Platform.ged then
    dofile("CommonLua/Ged/__config.lua")
    dofile("CommonLua/Core/ProceduralMeshShaders.lua")
  else
    dofile("CommonLua/Core/Terrain.lua")
    dofile("CommonLua/Core/Postprocessing.lua")
    dofile("CommonLua/Core/ProceduralMeshShaders.lua")
    dofolder_files("Lua/Config")
  end
  SetBuildRevision(LuaRevision)
  local cmd = GetAppCmdLine() or ""
  if not Platform.goldmaster then
    if Platform.developer then
      dofile("developer.lua")
    end
    local cmdline_map = string.match(cmd, "-map%s+(%S+)")
    if cmdline_map then
      config.Map = cmdline_map
      config.MainMenu = false
      config.LoadAlienwareLightFX = false
    else
      if Platform.developer and io.exists("user.lua") then
        dofile("user.lua")
      end
      local cmdline_config = string.match(cmd, "-cfg%s+(%S+)")
      if cmdline_config then
        dofile(cmdline_config)
      end
    end
    config.RunCmd = string.match(cmd, "-run%s+(%S+)")
    local cmdline_save = string.match(cmd, "-save%s+\"(.+%.sav)\"")
    if cmdline_save then
      config.Savegame = cmdline_save
      config.MainMenu = false
    end
  end
  config.Mods = config.Mods and not string.match(cmd, "-nomods")
  config.ArtTest = string.match(cmd, "-arttest")
  SetEngineVar("", "Platform.developer", Platform.developer or false)
end
OnMsg.Autorun = config.Autorun
SetupVarTable(config, "config.")
if config.LuaDebugger then
  dofile("CommonLua/Core/luasocket.lua")
  dofile("CommonLua/Core/luadebugger.lua")
  dofile("CommonLua/Core/luaDebuggerOutput.lua")
  dofile("CommonLua/Core/ProjectSync.lua")
  Libs.DebugAdapter = true
else
  function bp()
  end
end
UpdateThreadDebugHook()
dofile("CommonLua/Core/const.lua")
dofile("CommonLua/Core/notify.lua")
dofile("CommonLua/Core/math.lua")
dofile("CommonLua/Core/classes.lua")
dofile("CommonLua/Core/grids.lua")
if not Platform.cmdline then
  dofile("CommonLua/Core/map.lua")
  dofile("CommonLua/Core/persist.lua")
  dofile("CommonLua/Core/terminal.lua")
  dofile("CommonLua/Core/cameralock.lua")
  dofile("CommonLua/Core/mouse.lua")
  dofile("CommonLua/Core/GlobalStorageTables.lua")
end
if Platform.cmdline then
  LuaPackfile = false
  DataPackfile = false
else
  dofile("CommonLua/Core/mount.lua")
end
dofile("CommonLua/Core/localization.lua")
dofile("CommonLua/Core/usertexts.lua")
dofile("CommonLua/Core/ParseCSV.lua")
dofile("CommonLua/Core/asyncop.lua")
LoadConfig("svnProject/config.lua")
if Platform.cmdline then
  LoadConfig("config.lua")
else
  if Platform.playstation and not Platform.goldmaster then
    local ps_errors = {}
    if Platform.ps4 then
      LoadCSV("/host/%SCE_ORBIS_SDK_DIR%/host_tools/debugging/error_code/error_table.csv", ps_errors)
    else
      if Platform.ps5 then
        LoadCSV("/host/%SCE_PROSPERO_SDK_DIR%/host_tools/debugging/error_code/error_table.csv", ps_errors)
      else
      end
    end
    SetPlayStationErrorTable(ps_errors)
  end
  if FirstLoad then
    if not Platform.ged or not Platform.developer then
      LoadTranslationTables()
    end
    if not Platform.ged then
      LoadSoundMetadata("BinAssets/sndmeta.dat")
    end
  end
  InitWindowsImeState()
end
dofile("CommonLua/Core/error.lua")
dofile("CommonLua/Core/locutils.lua")
if Platform.cmdline then
  if GetEngineVar("", "config.RunUnpacked") then
    LuaRevision = GetUnpackedLuaRevision()
  else
    pdofile("_LuaRevision.lua")
  end
  dofolder("CommonLua/HGL")
  dofile("CommonLua/Classes/Socket.lua")
  dofile("CommonLua/PropertyObject.lua")
  dofile("CommonLua/Classes/CommandObject.lua")
  dofile("CommonLua/EventLog.lua")
  dofile("CommonLua/console.lua")
  dofile("CommonLua/Classes/TupleStorage.lua")
  dofile("CommonLua/GedEditedObject.lua")
  dofile("CommonLua/Preset.lua")
  dofile("CommonLua/Reactions.lua")
  dofile("CommonLua/Classes/ModItem.lua")
  dofile("CommonLua/TableParentCache.lua")
  dofile("CommonLua/Classes/ClassDefs/ClassDef-Config.generated.lua")
  DefineClass("GedFilter")
  dofile("CommonLua/Classes/ClassDefs/ClassDef-Internal.generated.lua")
else
  if Platform.developer and Platform.pc then
    InitSourceController()
  end
  SetupVarTable(hr, "hr.")
  SetVarTableLock(hr, true)
  dofile("CommonLua/Core/options.lua")
  if Platform.ged or Platform.developer then
    dofile("CommonLua/Ged/stubs.lua")
  end
  if FirstLoad then
    Options.Startup()
    config.CriticalErrorTitle = _InternalTranslate(T(768699500779, "Critical Error"))
    config.CriticalErrorText = _InternalTranslate(T(676315741793, "Unspecified error occurred (code %s1). The game will now close."))
    config.VideoDriverError = _InternalTranslate(T(622236701127, "You need a supported DX11-compatible video card with updated drivers to play this game."))
    config.VideoModeError = _InternalTranslate(T(838205552015, "Failed to initialize video mode."))
    local err = InitRenderEngine()
    if err then
      local caption = _InternalTranslate(T(634182240966, "Error"))
      if config.GraphicsApi == "d3d11" or config.GraphicsApi == "d3d12" then
        SystemMessageBox(caption, _InternalTranslate(T(224174170996, "You need DirectX 11/12 and a DirectX 11/12-compatible graphics card to run this game.")))
      elseif config.GraphicsApi == "opengl" or Platform.linux then
        SystemMessageBox(caption, _InternalTranslate(T(564352332891, "You need an OpenGL 4.5-capable graphics card to run this game.")))
      else
        SystemMessageBox(caption, _InternalTranslate(T(595831467700, "Failed to initialize graphics subsystem.")))
      end
      quit("force")
    end
    Options.Startup()
  end
  dofolder_files("CommonLua")
  dofolder("CommonLua/Classes")
  dofolder("CommonLua/UI")
  dofolder("CommonLua/X")
  if FirstLoad and not Platform.ged then
    CreateRealTimeThread(function()
      LoadingScreenOpen("idLoadingScreen", "autorun")
    end)
  end
  if Platform.ged or Platform.developer then
    dofolder("CommonLua/Ged")
  end
  if Platform.editor then
    dofolder("CommonLua/Editor")
  end
end
if Platform.developer then
  if not Platform.cmdline then
    Libs.Dev = true
  else
    dofile("CommonLua/Libs/Dev/FileSystemChanged.lua")
    dofile("CommonLua/Libs/Dev/dump.lua")
    dofile("CommonLua/Libs/Dev/GenerateDocs.lua")
  end
end
local files = io.listfiles("CommonLua/Libs/", "__*.lua", "non recursive")
table.sort(files, CmpLower)
for _, file in ipairs(files) do
  local lib = file:sub(18, -5)
  if lib and not Libs[lib] then
    dofile(file)
  end
end
for _, lib in ipairs(LibsList) do
  local lib_path = "CommonLua/Libs/" .. lib
  local lib_file = lib_path .. ".lua"
  local exists
  if io.exists(lib_file) then
    dofile(lib_file)
    exists = true
  end
  if io.exists(lib_path) then
    dofolder(lib_path)
    exists = true
  end
  if not exists then
  end
end
getmetatable(Libs).__newindex = function(_, lib, load)
end
for _, src_folder in ipairs(config.AdditionalSources) do
  dofolder(src_folder)
end
if config.RandomMap or Platform.editor then
  dofolder("CommonLua/MapGen")
end
local err, platform_folders = AsyncListFiles("CommonLua/Platforms/", "*", "relative,folders")
table.sort(platform_folders)
for _, platform in ipairs(platform_folders) do
  if Platform[platform] then
    dofolder("CommonLua/Platforms/" .. platform)
  end
end
if not Platform.cmdline and not Platform.ged then
  dofolder("Lua")
  DlcsLoadCode()
  ModsLoadCode()
  if FirstLoad then
    CreateRealTimeThread(function()
      if Platform.desktop or Platform.ps4 or Platform.xbox then
        SetAppMouseCursor(const.DefaultMouseCursor)
      end
      local pgo_train = Platform.pgo_train and GetAppCmdLine():match("-PGOTrain")
      if not (not Platform.developer or (config.Map or "") == "" and (config.Savegame or "") == "" or Platform.xbox) or pgo_train then
        LoadingScreenOpen("idLoadingScreen", "quickstart")
        Msg("PlatformInitalization")
        LoadDlcs()
        if config.MainMenu == 1 then
          print("Attention: both config.Map and config.MainMenu are set. This may cause problems as there is probably a map loaded behind the PreGameMenu.")
        end
        WaitLoadAccountStorage()
        ModsLoadLocTables()
        local save_as_last = true
        local savegame = config.Savegame or ""
        if savegame == "last" then
          savegame = LocalStorage.last_save or ""
          save_as_last = false
        end
        if savegame ~= "" then
          local err = LoadGame(savegame, {save_as_last = save_as_last})
          if err then
            print("Failed to load", savegame, err)
          end
        else
          local map = config.Map
          if map == "last" then
            map = LocalStorage.last_map or config.LastMapDefault or ""
          end
          if map ~= "" and map ~= "none" then
            ChangeMap(map)
          end
        end
        LoadingScreenClose("idLoadingScreen", "quickstart")
        if config.RunCmd then
          dostring(config.RunCmd)
        end
        if pgo_train then
          RunPGOTrain()
        end
      else
        if rawget(_G, "PlayInitialMovies") and not Platform.developer and not Platform.publisher then
          PlayInitialMovies()
        end
        if Platform.windows_store then
          LoadingScreenOpen("idSignInLoadingScreen", "main menu")
          WindowsStore.InitXal()
          WindowsStoreSignInUser(true)
        end
        if Platform.epic then
          LoadingScreenOpen("idSignInLoadingScreen", "main menu")
          WaitStartEpic()
        end
        if Platform.xbox then
          LoadingScreenOpen("idAutorunLoadingScreen", "main menu")
          InitalizeXboxState()
          ResetTitleState()
          Msg("PlatformInitalization")
          if config.AllowInvites then
            Msg("StartAcceptingInvites")
          end
          LoadingScreenClose("idAutorunLoadingScreen", "main menu")
        else
          LoadingScreenOpen("idAutorunLoadingScreen", "main menu")
          Msg("PlatformInitalization")
          LoadDlcs()
          WaitLoadAccountStorage()
          ModsLoadLocTables()
          OpenPreGameMainMenu()
          if config.AllowInvites then
            Msg("StartAcceptingInvites")
          end
          LoadingScreenClose("idAutorunLoadingScreen", "main menu")
        end
        if Platform.windows_store or Platform.epic then
          LoadingScreenClose("idSignInLoadingScreen", "main menu")
        end
        if Platform.switch then
          CreateRealTimeThread(function()
            GetActiveSwitchController()
          end)
        end
      end
      XShortcutsSetMode("Game")
      Msg("EngineStarted")
      MsgClear("EngineStarted")
    end)
  end
end
if not Platform.cmdline and Platform.ged then
  dofolder_files("Lua/Ged")
end
function OnMsg.Autorun()
  if FirstLoad and config.LuaDebugger then
    if Platform.cmdline then
      StartDebugger()
    elseif string.match(GetAppCmdLine() or "", "-debug") then
      StartDebugger()
    end
  end
  MsgClear("Autorun")
  collectgarbage("restart")
  collectgarbage("setpause", 100)
  Loading = false
  if FirstLoad then
    FirstLoad = false
    Msg("Start")
  end
  MsgClear("Start")
end
if FirstLoad then
  if Platform.cmdline then
    if Platform.ios then
      return true
    end
    if io.exists("autorun.lua") then
      dofile("autorun.lua")
    end
    local func = CmdLineCommands[arg[1]] or function(arg)
      if arg[1] and io.exists(arg[1]) then
        SetExitCode(tonumber(dofile(arg[1]) or 0))
      else
        CmdLineCommands.help({})
      end
    end
    local err = func(arg)
    if err then
      print("Error:", err)
      SetExitCode(1)
    end
  else
    DebugPrint([[

Platform: ]] .. table.concat(table.keys(Platform, true), ", ") .. [[


]])
    if not Platform.ged then
      CreateRealTimeThread(function()
        LoadingScreenClose("idLoadingScreen", "autorun")
      end)
    end
  end
end
