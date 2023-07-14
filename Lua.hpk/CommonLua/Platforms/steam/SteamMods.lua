if not config.Mods then
  return
end
function OnMsg.GatherModEditorLogins(context)
  context.steam_login = IsSteamAvailable() and not not SteamGetUserId64()
end
function OnMsg.GatherModAuthorNames(authors)
  if IsSteamAvailable() then
    authors.steam = SteamGetPersonaName()
  end
end
function OnMsg.GatherModDownloadCode(codes)
  local steam_ids = {}
  for i, mod in ipairs(ModsLoaded) do
    if mod.source == "steam" then
      table.insert(steam_ids, mod.steam_id)
    end
  end
  if #steam_ids == 0 then
    return
  end
  codes.steam = string.format("DebugDownloadSteamMods%s", TableToLuaCode(steam_ids, " "))
end
function OnMsg.GatherModDefFolders(folders)
  if SteamIsWorkshopAvailable() then
    local steam_folders = SteamWorkshopItems()
    if 0 < #steam_folders then
      local workshop_item_ids = {}
      for i, folder in ipairs(steam_folders) do
        local dir, name = SplitPath(folder)
        workshop_item_ids[#workshop_item_ids + 1] = name
      end
      mod_print("once", "Steam mods: %s", table.concat(workshop_item_ids, ", "))
    end
    for i = 1, #steam_folders do
      steam_folders[i] = string.gsub(steam_folders[i], "\\", "/")
      steam_folders[i] = {
        path = steam_folders[i],
        source = "steam"
      }
    end
    table.iappend(folders, steam_folders)
  end
end
function GedOpUploadModToSteam(socket, root)
  local mod = root[1]
  local err = ValidateModBeforeUpload(socket, mod)
  if err then
    return
  end
  if "ok" ~= socket:WaitQuestion(T(986829419084, "Confirmation"), T({
    929503917793,
    "Mod <ModLabel> will be uploaded to Steam",
    mod
  })) then
    return
  end
  local params = {}
  UploadMod(socket, mod, params, Steam_PrepareForUpload, Steam_Upload)
end
function OnMsg.GatherModDeleteFailReasons(mod, reasons)
  if mod.source == "steam" then
    table.insert(reasons, T(517466957756, "This mod is downloaded from Steam and cannot be deleted - go in your Steam client and unsubscribe it from there."))
  end
end
function OnMsg.ClassesGenerate(classdefs)
  local steam_properties = {
    {
      category = "Mod",
      id = "steam_id",
      name = T(254392044758, "Steam ID"),
      editor = "number",
      default = 0,
      read_only = true,
      no_edit = not Platform.steam
    }
  }
  for i, steam_prop in ipairs(steam_properties) do
    table.insert(ModDef.properties, steam_prop)
  end
end
function OnMsg.ModBlacklistPrefixes(list)
  list[#list + 1] = "Steam"
  list[#list + 1] = "OnSteam"
  list[#list + 1] = "AsyncSteam"
end
