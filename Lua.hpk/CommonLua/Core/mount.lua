if not FirstLoad then
  return
end
if Platform.ps4 then
  OrbisStartFakeSubmitDone()
end
local unpacked = IsFSUnpacked()
if unpacked then
  LuaPackfile = false
  DataPackfile = false
  MountFolder("Data", "svnProject/Data/", "label:Data")
else
  LuaPackfile = "Packs/Lua.hpk"
  DataPackfile = "Packs/Data.hpk"
  MountPack("Data", "Packs/Data.hpk", "in_mem,label:Data")
end
if unpacked then
  MountFolder("Fonts", "svnAssets/Bin/Common/Fonts/")
  MountFolder("UI", "svnAssets/Bin/win32/UI/")
else
  MountPack("Fonts", "Packs/Fonts.hpk")
  MountPack("UI", "Packs/UI.hpk")
end
if unpacked then
  MountFolder("Misc", "svnAssets/Source/Misc")
else
  MountPack("Misc", "Packs/Misc.hpk")
end
if unpacked then
  MountFolder("Shaders", "svnProject/Shaders/", "seethrough")
  MountFolder("Shaders", "svnSrc/HR/Shaders/", "seethrough")
elseif Platform.desktop or Platform.xbox or Platform.switch then
  MountPack("Shaders", "Packs/Shaders.hpk", "seethrough")
end
if unpacked then
  MountFolder("CommonAssets", "svnSrc/CommonAssets/")
  MountFolder("BinAssets", "svnAssets/Bin/win32/BinAssets/")
  MountFolder("Meshes", "CommonAssets/Entities/Meshes/")
  MountFolder("Entities", "CommonAssets/Entities/Entities/")
  MountFolder("Animations", "CommonAssets/Entities/Animations/")
  MountFolder("Materials", "CommonAssets/Entities/Materials/")
  MountFolder("Mapping", "CommonAssets/Entities/Mapping/")
  MountFolder("TexturesMeta", "CommonAssets/Entities/TexturesMeta/", "seethrough")
  MountFolder("Fallbacks", "CommonAssets/Entities/Fallbacks/")
  MountFolder("Meshes", "svnAssets/Bin/Common/Meshes/", "seethrough")
  MountFolder("Entities", "svnAssets/Bin/Common/Entities/", "seethrough")
  MountFolder("Animations", "svnAssets/Bin/Common/Animations/", "seethrough")
  MountFolder("Materials", "svnAssets/Bin/Common/Materials/", "seethrough")
  MountFolder("Mapping", "svnAssets/Bin/Common/Mapping/", "seethrough")
  MountFolder("TexturesMeta", "svnAssets/Bin/Common/TexturesMeta/", "seethrough")
  MountFolder("Fallbacks", "svnAssets/Bin/win32/Fallbacks/", "seethrough")
else
  MountPack("Meshes", "Packs/Meshes.hpk")
  MountPack("Animations", "Packs/Animations.hpk")
  MountPack("Fallbacks", "Packs/Fallbacks.hpk")
  MountPack("BinAssets", "Packs/BinAssets.hpk")
  MountPack("", "Packs/CommonAssets.hpk", "seethrough,label:CommonAssets")
end
const.LastBinAssetsBuildRevision = tonumber(dofile("BinAssets/AssetsRevision.lua") or 0) or 0
if not Platform.ged then
  if unpacked then
    MountFolder("Sounds", "svnAssets/Source/Sounds/")
    MountFolder("Music", "svnAssets/Source/Music/")
  end
  if unpacked then
    MountFolder("Movies", "svnAssets/Bin/win32/Movies/")
  end
end
if FirstLoad and config.MemoryScreenshotSize then
  MountPack("memoryscreenshot", "", "create", config.MemoryScreenshotSize)
end
g_VoiceVariations = false
function MountLanguage()
  local unpacked = config.UnpackedLocalization or config.UnpackedLocalization == nil and IsFSUnpacked()
  UnmountByLabel("CurrentLanguage")
  g_VoiceVariations = false
  if unpacked then
    MountFolder("CurrentLanguage", "svnProject/LocalizationOut/" .. GetLanguage() .. "/CurrentLanguage/", "label:CurrentLanguage")
    local unpacked_voices = "svnAssets/Bin/win32/Voices/" .. GetVoiceLanguage() .. "/"
    if not io.exists(unpacked_voices) then
      SetVoiceLanguage("English")
      unpacked_voices = "svnAssets/Bin/win32/Voices/" .. GetVoiceLanguage() .. "/"
    end
    MountFolder("CurrentLanguage/Voices", "svnAssets/Bin/win32/Voices/" .. GetVoiceLanguage() .. "/", "label:CurrentLanguage")
    if config.VoicesTTS then
      MountFolder("CurrentLanguage/VoicesTTS", "svnAssets/Bin/win32/VoicesTTS/" .. GetVoiceLanguage() .. "/", "label:CurrentLanguage")
    end
  else
    local err = MountPack("", "Local/" .. GetLanguage() .. ".hpk", "seethrough,label:CurrentLanguage")
    if err then
      SetLanguage("English")
      MountPack("", "Local/" .. GetLanguage() .. ".hpk", "seethrough,label:CurrentLanguage")
    end
    err = MountPack("CurrentLanguage/Voices", "Local/Voices/" .. GetVoiceLanguage() .. ".hpk", "label:CurrentLanguage")
    if err then
      SetVoiceLanguage("English")
      MountPack("CurrentLanguage/Voices", "Local/Voices/" .. GetVoiceLanguage() .. ".hpk", "label:CurrentLanguage")
    end
    if config.VoicesTTS then
      MountPack("CurrentLanguage/VoicesTTS", "Local/VoicesTTS/" .. GetVoiceLanguage() .. ".hpk", "label:CurrentLanguage")
    end
  end
  if rawget(_G, "DlcDefinitions") then
    DlcMountVoices(DlcDefinitions)
  end
  if config.GedLanguageEnglish then
    if unpacked then
      MountFolder("EnglishLanguage", "svnProject/LocalizationOut/English/")
    else
      MountPack("EnglishLanguage", "Local/English.hpk")
    end
  end
  local voice_variations_path = "CurrentLanguage/Voices/variations.lua"
  if io.exists(voice_variations_path) then
    local ok, vars = pdofile(voice_variations_path)
    if ok then
      g_VoiceVariations = vars
    else
    end
  end
end
MountLanguage()
local MountTextures = function(unpacked)
  if unpacked then
    MountFolder("Textures", "CommonAssets/Entities/Textures/", "priority:high")
    MountFolder("Textures", "svnAssets/Bin/win32/Textures/", "priority:high,seethrough")
    CreateRealTimeThread(function()
      local err, billboardFolders = AsyncListFiles("svnAssets/Bin/win32/Textures/Billboards/", "*", "folders")
      for _, folder in pairs(billboardFolders) do
        MountFolder("Textures/Billboards", folder .. "/", "priority:high,seethrough")
      end
    end)
    if Platform.osx then
      MountFolder("Textures/Cubemaps", "svnAssets/Bin/osx/Textures/Cubemaps/", "priority:high")
    end
  elseif Platform.desktop or Platform.xbox or Platform.switch then
    AsyncMountPack("Textures", "Packs/Textures.hpk", "priority:high,seethrough")
    for i = 0, 9 do
      AsyncMountPack("", "Packs/Textures" .. tostring(i) .. ".hpk", "priority:high,seethrough")
    end
  else
    AsyncMountPack("Textures", "Packs/Textures.hpk", "priority:high,seethrough")
  end
end
if unpacked then
  UnmountByPath("Docs")
  MountFolder("Docs", "svnSrc/Docs/")
  MountFolder("Docs", "svnProject/Docs/", "seethrough")
  MountFolder("Docs", "svnProject/Docs/ModTools/", "seethrough")
else
  MountFolder("Docs", "ModTools/Docs/")
end
local mount_thread
if not Platform.ged then
  if unpacked then
    MountTextures(unpacked)
    MountFolder("Maps", "svnAssets/Source/Maps/")
    MountFolder("Prefabs", "svnAssets/Source/Prefabs/")
  else
    mount_thread = CreateRealTimeThread(function()
      AsyncMountPack("Music", "Packs/Music.hpk")
      AsyncMountPack("Sounds", "Packs/Sounds.hpk", "in_mem,priority:high")
      MountTextures()
      AsyncMountPack("Textures/Cubemaps", "Packs/Cubemaps.hpk", "priority:high")
      AsyncMountPack("", "Packs/AdditionalTextures.hpk", "priority:high,seethrough,label:AdditionalTextures")
      AsyncMountPack("", "Packs/AdditionalNETextures.hpk", "priority:high,seethrough,label:AdditionalNETextures")
      AsyncMountPack("Prefabs", "Packs/Prefabs.hpk")
      Msg(mount_thread)
      mount_thread = nil
    end)
  end
elseif Platform.developer then
  if unpacked then
    MountTextures(unpacked)
  else
    mount_thread = CreateRealTimeThread(function()
      MountTextures()
      Msg(mount_thread)
      mount_thread = nil
    end)
  end
end
function WaitMount()
  if IsValidThread(mount_thread) then
    WaitMsg(mount_thread)
  end
end
function UnmountBinAssets()
  if not unpacked then
    UnmountByPath("Meshes")
    UnmountByPath("Animations")
    UnmountByLabel("DlcMeshes")
    UnmountByLabel("DlcAnimations")
  end
end
CreateRealTimeThread(function()
  if unpacked then
    LuaRevision = GetUnpackedLuaRevision() or LuaRevision
    AssetsRevision = GetUnpackedLuaRevision(false, "svnAssets/.") or AssetsRevision
  else
    AssetsRevision = const.LastBinAssetsBuildRevision ~= 0 and const.LastBinAssetsBuildRevision or AssetsRevision
  end
  DebugPrint("Lua revision: " .. LuaRevision .. "\n")
  SetBuildRevision(LuaRevision)
  DebugPrint("Assets revision: " .. AssetsRevision .. "\n")
  if Platform.steam then
    DebugPrint("Steam AppID: " .. (SteamGetAppId() or "<unknown>") .. "\n")
  end
  if (BuildVersion or "") ~= "" then
    DebugPrint("Build version: " .. BuildVersion .. "\n")
  end
  if (BuildBranch or "") ~= "" then
    DebugPrint("Build branch: " .. BuildBranch .. "\n")
  end
end)
if Platform.ps4 then
  OrbisStopFakeSubmitDone()
end
