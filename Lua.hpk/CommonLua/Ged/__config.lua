config.GedLanguageEnglish = true
if config.GedLanguageEnglish then
  function GetLanguage()
    return "English"
  end
end
config.GraphicsApi = GetDefaultGraphicsApi()
config.RunUnfocused = 1
config.Map = false
config.MainMenu = 0
config.FullscreenMode = 0
config.Width = 1200
config.Height = 700
config.DisableOptions = true
hr.EnableShaderCompilation = 1
hr.ShowShaderCompilation = 1
hr.ShaderOptimization = 0
hr.RenderTrails = 0
hr.EnablePostprocess = 1
config.SoundTypesPath = "CommonLua/Ged/__SoundTypes.lua"
config.Music = 0
config.ObjectPoolMem = 16384
config.CBMemory = 524288
config.BonesMemory = 524288
config.MemorySavegameSize = 33554432
hr.UIL_TextureWidth = 4096
hr.UIL_TextureHeight = 4096
if not Platform.goldmaster then
  dofile("Lua/Dev/MantisConfig.lua")
  function OnMsg.BugReportStart(print_func)
    for _, app in ipairs(terminal.desktop) do
      if app:IsKindOf("GedApp") then
        print_func("GedApp: " .. app:GetAppId() .. " Class: " .. (app:HasMember("PresetClass") and app.PresetClass or "none"))
        print_func("State: " .. TableToLuaCode(app:GetState()))
      end
    end
  end
end
config.DefaultExternalTextEditorTempFile = "tempedit.lua"
config.DefaultExternelTextEditorCmd = "start notepad++ %s"
config.DefaultTextEditPlugins = {
  "XExternalTextEditorPlugin"
}
