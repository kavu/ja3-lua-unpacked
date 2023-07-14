DefineClass.ModsBackend = {
  __parents = {"InitDone"},
  source = "",
  download_path = "",
  screenshots_path = "",
  display_name = "",
  page_size = 20
}
function ModsBackend.IsAvailable()
  return true
end
function ModsBackend:CanAuth()
  return false
end
function ModsBackend:IsLoggedIn()
  return false
end
function ModsBackend:AttemptingLogin()
  return false
end
function ModsBackend:CanUpload()
  return false
end
function ModsBackend:CreateMod()
  return "not impl"
end
function ModsBackend:UploadMod()
  return "not impl"
end
function ModsBackend:DeleteMod()
  return "not impl"
end
function ModsBackend:PublishMod()
  return "not impl"
end
function ModsBackend:CanInstall()
  return false
end
function ModsBackend:Subscribe(backend_id)
  return "not impl"
end
function ModsBackend:Unsubscribe(backend_id)
  return "not impl"
end
function ModsBackend:Install(backend_id)
  return "not impl"
end
function ModsBackend:Uninstall(backend_id)
  return "not impl"
end
function ModsBackend:OnUninstalled(backend_id)
end
function ModsBackend:GetInstalled()
  return false, {}
end
function ModsBackend:OnSetEnabled(mod_def_id, enabled)
  return "not impl"
end
function ModsBackend:CanFavorite()
  return false
end
function ModsBackend:SetFavorite(backend_id, favorite)
  return "not impl"
end
function ModsBackend:IsFavorited(backend_id)
  return false, false
end
function ModsBackend:CanFlag()
  return false
end
function ModsBackend:Flag(backend_id, reason, description)
  return "not impl"
end
function ModsBackend:GetFlagReasons()
  return {}
end
function ModsBackend:CanRate()
  return false
end
function ModsBackend:Rate(backend_id, rating)
  return "not impl"
end
function ModsBackend:GetRating(backend_id)
  return false, 0
end
function ModsBackend:CompareBackendID(mod_def, backend_id)
end
function ModsBackend:GetDetails(backend_id)
  return "not impl"
end
function ModsBackend:GetModsCount(query)
  return false, 0
end
function ModsBackend:GetMods(query)
  return false, {}
end
DefineClass.ModsSearchQuery = {
  __parents = {"InitDone"},
  Query = false,
  Tags = false,
  SortBy = false,
  OrderBy = false,
  Platform = false,
  Author = false,
  Page = false,
  PageSize = false,
  Favorites = false
}
if FirstLoad then
  g_ModsBackendObj = false
end
function GetModsBackendClass()
  for classname, classdef in pairs(ClassDescendants("ModsBackend")) do
    if classdef.IsAvailable() then
      return classdef
    end
  end
end
function ModsBackendObjectCreateAndLoad()
  if not g_ModsBackendObj then
    local classdef = GetModsBackendClass()
    if not classdef then
      return
    end
    g_ModsBackendObj = classdef:new()
  end
  return g_ModsBackendObj
end
function IsModsBackendLoaded()
  return not not g_ModsBackendObj
end
