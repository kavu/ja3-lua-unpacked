local mantisZuluInternal = "36"
local mantisZuluExternal = "42"
local mantisZuluPublic = "44"
config.BugReporterXTemplateID = "BugReport"
const.MantisCopyUrlButton = true
config.IncludeDesyncReports = true
if Platform.steam then
  local steam_beta, steam_branch = SteamGetCurrentBetaName()
  if not (not Platform.demo and steam_beta) or steam_branch == "" or THQSteamWrapperGetPlatform() ~= "steam" then
    const.MantisProjectID = mantisZuluPublic
    const.MantisCopyUrlButton = false
    config.ForceIncludeExtraInfo = true
    config.IncludeDesyncReports = false
  elseif Platform.developer or insideHG() then
    const.MantisProjectID = mantisZuluInternal
  else
    const.MantisProjectID = mantisZuluExternal
  end
elseif Platform.developer or insideHG() then
  const.MantisProjectID = mantisZuluInternal
else
  const.MantisProjectID = mantisZuluPublic
  const.MantisCopyUrlButton = false
  config.ForceIncludeExtraInfo = true
  config.IncludeDesyncReports = false
end
if const.MantisProjectID == mantisZuluPublic then
  config.BugReporterXTemplateID = "BugReportZulu"
  config.CustomAttachSavegameText = T(976841387804, "ATTACH A SAVE OF THE CURRENT GAME")
  config.ForceIncludeScreenshot = true
end
const.Categories = {
  "Art",
  "Code",
  "Design",
  "Maps"
}
const.DefaultReporter = 81
const.DefaultCategory = 2
const.TargetVersions = {
  "23. Gold Master / 30 Jun 2023",
  "23.1 Day1 Patch / 14 Jul 2023",
  "23.2 PC Post Release Patch / 1 Aug 2023",
  "24. Console Cert ver / 3 Aug 2023",
  "25. Console Gold Master / 3 Oct 2023"
}
const.DefaultTargetVersion = "23. PC Release Version / 1 Jun 2023"
