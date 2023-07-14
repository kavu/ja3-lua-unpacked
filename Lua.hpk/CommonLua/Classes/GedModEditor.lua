local IsGedAppOpened = function(template_id)
  if not rawget(_G, "GedConnections") then
    return false
  end
  for key, conn in pairs(GedConnections) do
    if conn.app_template == template_id then
      return true
    end
  end
  return false
end
function IsModEditorOpened()
  return IsGedAppOpened("ModEditor")
end
function IsModManagerOpened()
  return IsGedAppOpened("ModManager")
end
ModEditorMapName = "ModEditor"
function IsModEditorMap(map_name)
  map_name = map_name or GetMapName()
  return map_name == ModEditorMapName or table.get(MapData, map_name, "ModEditor") or false
end
if not config.Mods then
  return
end
if FirstLoad then
  ModUploadThread = false
end
function OpenModEditor(mod)
  LoadLuaParticleSystemPresets()
  for _, presets in pairs(Presets) do
    PopulateParentTableCache(presets)
  end
  local mod_path = ModConvertSlashes(mod:GetModRootPath())
  local context = {
    mod_items = GedItemsMenu("ModItem"),
    dlcs = g_AvailableDlc or {},
    mod_path = mod_path,
    mod_os_path = ConvertToOSPath(mod_path),
    mod_content_path = mod:GetModContentPath(),
    WarningsUpdateRoot = "root",
    suppress_property_buttons = {
      "GedOpPresetIdNewInstance",
      "GedRpcEditPreset",
      "OpenTagsEditor"
    }
  }
  Msg("GatherModEditorLogins", context)
  local editor = OpenGedApp("ModEditor", Container:new({mod}), context)
  if editor then
    editor:Send("rfnApp", "SetSelection", "root", {1})
  end
  return editor
end
function OnMsg.GedOpened(ged_id)
  local conn = GedConnections[ged_id]
  if conn and conn.app_template == "ModEditor" then
    SetMute(false)
  end
end
if FirstLoad then
  ModdingHelpShownOnEditorOpen = false
end
function ModEditorOpen(mod)
  CreateRealTimeThread(function()
    if not IsModEditorMap(CurrentMap) then
      ChangeMap(ModEditorMapName)
      CloseMenuDialogs()
    end
    if mod then
      OpenModEditor(mod)
    else
      if IsModManagerOpened() then
        return
      end
      local context = {
        dlcs = g_AvailableDlc or {}
      }
      SortModsList()
      local ged = OpenGedApp("ModManager", ModsList, context)
      if ged then
        ged:BindObj("log", ModMessageLog)
      end
      if not ModdingHelpShownOnEditorOpen then
        ModdingHelpShownOnEditorOpen = true
        if not Platform.developer then
          GedOpHelpMod()
        end
      end
    end
  end)
end
function GedModMessageLog(obj)
  return table.concat(obj, "\n")
end
function OnMsg.NewMapLoaded()
  if IsModEditorMap() then
    ReloadShortcuts()
  end
end
function OnMsg.ModsReloaded()
  if IsModManagerOpened() then
    SortModsList()
    ObjModified(ModsList)
  end
end
function GedOpNewMod(socket, obj)
  local title = socket:WaitUserInput(T(200174645592, "Enter Mod Title"), "")
  if not title then
    return
  end
  title = title:trim_spaces()
  if #title == 0 then
    socket:ShowMessage(T(634182240966, "Error"), T(112659155240, "No name provided"))
    return
  end
  local err, mod = CreateMod(title)
  if err then
    socket:ShowMessage(GetErrorTitle(err, "mods", mod), GetErrorText(err, "mods"))
    return
  end
  return table.find(ModsList, mod)
end
function GedOpLoadMod(socket, obj, item_idx)
  local mod = ModsList[item_idx]
  if mod.items then
    return
  end
  table.insert_unique(AccountStorage.LoadMods, mod.id)
  ModsReloadItems()
  ObjModified(ModsList)
end
function GedOpUnloadMod(socket, obj, item_idx)
  local mod = ModsList[item_idx]
  if not mod.items then
    return
  end
  table.remove_value(AccountStorage.LoadMods, mod.id)
  for id, ged in pairs(GedConnections) do
    if ged.app_template == "ModEditor" then
      local root = ged:ResolveObj("root")
      if root and root[1] == mod then
        ged:Close()
      end
    end
  end
  ModsReloadItems()
  ObjModified(ModsList)
end
function GedOpEditMod(socket, obj, item_idx)
  local mod = ModsList[item_idx]
  if not mod then
    return
  end
  local force_reload
  if mod.source ~= "appdata" and mod.source ~= "additional" or mod.packed then
    local mod_folder = mod.title:gsub("[/?<>\\:*|\"]", "_")
    local unpack_path = string.format("AppData/Mods/%s/", mod_folder)
    unpack_path = string.gsub(ConvertToOSPath(unpack_path), "\\", "/")
    local res = socket:WaitQuestion(T(521819598348, "Confirm Copy"), T({
      814173350691,
      "Mod '<u(title)>' files will be copied to <u(path)>",
      mod,
      path = unpack_path
    }))
    if res ~= "ok" then
      return
    end
    ModLog(T({
      348544010518,
      "Copying <ModLabel> to <u(path)>",
      mod,
      path = unpack_path
    }))
    AsyncDeletePath(unpack_path)
    AsyncCreatePath(unpack_path)
    local pack_path = mod.path .. ModsPackFileName
    local err
    if io.exists(pack_path) then
      err = AsyncUnpack(pack_path, unpack_path)
      if not err then
        UnmountByPath(mod.content_path)
      end
    elseif CanLoadUnpackedMods() then
      local folders
      err, folders = AsyncListFiles(mod.content_path, "*", "recursive,relative,folders")
      if not err then
        for _, folder in ipairs(folders) do
          local err = AsyncCreatePath(unpack_path .. folder)
          if err then
            ModLog(T({
              311163830130,
              "Error creating folder <u(folder)>: <u(err)>",
              folder = folder,
              err = err
            }))
            break
          end
        end
        local files
        err, files = AsyncListFiles(mod.content_path, "*", "recursive,relative")
        if not err then
          for _, file in ipairs(files) do
            local err = AsyncCopyFile(mod.content_path .. file, unpack_path .. file, "raw")
            if err then
              ModLog(T({
                403285832388,
                "Error copying <u(file)>: <u(err)>",
                file = file,
                err = err
              }))
            end
          end
        else
          ModLog(T({
            600384081290,
            "Error looking up files of <ModLabel>: <u(err)>",
            mod,
            err = err
          }))
        end
      else
        ModLog(T({
          836115199867,
          "Error looking up folders of <ModLabel>: <u(err)>",
          mod,
          err = err
        }))
      end
    end
    if not err then
      mod:ChangePaths(unpack_path, unpack_path)
      mod.packed = false
      mod.source = "appdata"
      force_reload = true
      mod:SaveDef("serialize_only")
    else
      ModLog(T({
        578088043400,
        "Error copying <ModLabel>: <err>",
        mod,
        err = T({err})
      }))
    end
  end
  if force_reload or not mod:ItemsLoaded() then
    table.insert_unique(AccountStorage.LoadMods, mod.id)
    mod.force_reload = true
    ModsReloadItems(nil, "force_reload")
    ObjModified(ModsList)
  end
  if mod:ItemsLoaded() then
    ModEditorOpen(mod)
  end
end
function GedOpRemoveMod(socket, obj, item_idx)
  local mod = ModsList[item_idx]
  local reasons = {}
  Msg("GatherModDeleteFailReasons", mod, reasons)
  if next(reasons) then
    socket:ShowMessage(T(634182240966, "Error"), table.concat(reasons, "\n"))
  else
    local res = socket:WaitQuestion(T(118482924523, "Are you sure?"), T({
      820846615088,
      "Do you want to delete all <ModLabel> files?",
      mod
    }))
    if res == "cancel" then
      return
    end
    table.remove(ModsList, item_idx)
    local err = DeleteMod(mod)
    if err then
      socket:ShowMessage(GetErrorTitle(err, "mods"), GetErrorText(err, "mods", mod))
    end
    return Clamp(item_idx, 1, #ModsList)
  end
end
function GedOpHelpMod(socket, obj)
  local help_file = string.format("%s", ConvertToOSPath(DocsRoot .. "index.md.html"))
  help_file = string.gsub(help_file, "[\n\r]", "")
  if io.exists(help_file) then
    help_file = string.gsub(help_file, " ", "%%20")
    OpenUrl("file:///" .. help_file, "force external browser")
  end
end
function GedOpTriggerCheat(socket, obj, cheat, ...)
  if string.starts_with(cheat, "Cheat") then
    local func = rawget(_G, cheat)
    if func then
      func(...)
    end
  end
end
function CreateMod(title)
  for _, mod in ipairs(ModsList) do
    if mod.title == title then
      return "exists"
    end
  end
  local path = string.format("AppData/Mods/%s/", title:gsub("[/?<>\\:*|\"]", "_"))
  if io.exists(path .. "metadata.lua") then
    return "exists"
  end
  AsyncCreatePath(path)
  local authors = {}
  Msg("GatherModAuthorNames", authors)
  local author
  for platform, name in pairs(authors) do
    if platform ~= "steam" then
      author = name
      break
    end
  end
  author = author or authors.steam or "unknown"
  local env = LuaModEnv()
  local id = ModDef:GenerateId()
  local mod = ModDef:new({
    title = title,
    author = author,
    id = id,
    path = path,
    content_path = ModContentPath .. id .. "/",
    env = env
  })
  Msg("ModDefCreated", mod)
  mod:SetupEnv()
  mod:MountContent()
  Mods[mod.id] = mod
  ModsList[#ModsList + 1] = mod
  SortModsList()
  ObjModified(ModsList)
  CacheModDependencyGraph()
  local items_err = AsyncStringToFile(path .. "items.lua", "return {}")
  local def_err = mod:SaveDef()
  return def_err or items_err, mod
end
function DeleteMod(mod)
  local err = AsyncDeletePath(mod.path)
  if err then
    return err
  end
  Mods[mod.id] = nil
  table.remove_entry(ModsList, mod)
  table.remove_entry(ModsLoaded, mod)
  table.remove_entry(AccountStorage.LoadMods, mod.id)
  ObjModified(ModsList)
  mod:delete()
end
function GedOpNewModItem(socket, root, class_or_instance)
  local mod = root[1]
  local item = class_or_instance
  local presets
  if type(item) == "string" then
    item = _G[item]:new({mod = mod})
    if IsKindOf(item, "Preset") then
      item.id = item:GenerateUniquePresetId()
      item:Register()
      GedNotifyRecursive(item, "OnEditorNew", mod, socket)
      item:PostLoad()
      item:MarkDirty()
      item:SortPresets()
      presets = Presets[item.PresetClass or item.class]
      UpdateParentTable(item, presets[item.group])
      PopulateParentTableCache(item)
    else
      GedNotifyRecursive(item, "OnEditorNew", mod, socket)
    end
  end
  local mod_items = mod.items
  mod_items[#mod_items + 1] = item
  mod:SortItems()
  GedNotifyRecursive(item, "OnAfterEditorNew", mod, socket)
  if presets then
    ObjModified(presets)
  end
  ObjModified(root)
  local selection = {
    1,
    table.find(mod_items, item)
  }
  return selection, function()
    GedOpTreeDeleteItem(socket, root, selection)
  end
end
local ResolveModItemPath = function(root, path)
  if not path or #path < 2 then
    return "invalid selection"
  end
  local mod = root[path[1]]
  local mod_items = mod.items
  local item = mod_items[path[2]]
  local current_item, parent, last_idx = item, mod_items, path[2]
  for i = 3, #path do
    last_idx = path[i]
    parent = current_item
    current_item = parent[last_idx]
  end
  return current_item, parent, last_idx
end
function GedOpDuplicateModItem(socket, root, path)
  if not path or #path < 2 then
    return "invalid selection"
  end
  local original_item, parent, last_idx = ResolveModItemPath(root, path)
  if not (original_item and parent) or not last_idx then
    return "cannot find selected item"
  end
  local old_id = original_item.id
  local new_items = GedDuplicateObjects(parent, {last_idx})
  local new_item = new_items and new_items[1]
  if not new_item then
    return "cannot duplicate item"
  end
  if IsKindOf(new_item, "ModItem") then
    new_item.mod = original_item.mod
  end
  if IsKindOf(new_item, "Preset") then
    new_item.id = new_item:GenerateUniquePresetId()
    new_item:Register()
    GedNotifyRecursive(new_item, "OnEditorNew", parent, socket, "paste", old_id)
    new_item:PostLoad()
    new_item:MarkDirty()
    new_item:SortPresets()
    local presets = Presets[new_item.PresetClass or new_item.class]
    UpdateParentTable(new_item, presets[new_item.group])
    PopulateParentTableCache(new_item)
  else
    GedNotifyRecursive(new_item, "OnEditorNew", parent, socket, "paste", old_id)
  end
  local new_idx = last_idx + 1
  table.insert(parent, new_idx, new_item)
  if IsKindOf(new_item, "ModItemCode") then
    local err = AsyncCopyFile(original_item:GetCodeFilePath(), new_item:GetCodeFilePath(), "raw")
    if err then
      print("Ged: Error duplicating mod code", err)
    end
  end
  GedNotifyRecursive(new_item, "OnAfterEditorNew", parent, socket, "paste")
  GedObjectModified(root)
  local new_path = table.icopy(path)
  new_path[#new_path] = new_idx
  return new_path, function()
    GedOpTreeDeleteItem(socket, root, new_path)
  end
end
function GedOpCutModItem(socket, root, path)
  if not path or #path < 2 then
    return "invalid selection"
  end
  GedOpCopyModItem(socket, root, path)
  return GedOpDeleteModItem(socket, root, path, "force")
end
function GedOpCopyModItem(socket, root, path)
  if not path or #path < 2 then
    return "invalid selection"
  end
  local original_item, parent, last_idx = ResolveModItemPath(root, path)
  if not (original_item and parent) or not last_idx then
    return "cannot find selected item"
  end
  local base_class = IsKindOf(original_item, "ModItem") and "ModItem" or original_item.class
  GedCopyToClipboard(parent, base_class, {last_idx})
end
local ResolveModItemToPasteIn = function(root, path, clipboard_class)
  if not path or #path < 2 then
    return "invalid selection"
  end
  local hierarchy = {}
  local mod = root[path[1]]
  local mod_items = mod.items
  hierarchy[1] = mod_items
  local item = mod_items[path[2]]
  hierarchy[2] = item
  local current_item, parent, last_idx = item, mod_items, path[2]
  for i = 3, #path do
    last_idx = path[i]
    parent = current_item
    current_item = parent[last_idx]
    hierarchy[i] = current_item
  end
  local parent, base_class, new_path
  for i = #hierarchy, 2, -1 do
    local item = hierarchy[i]
    local item_parent = hierarchy[i - 1]
    local container_class = IsKindOf(item_parent, "Container") and item_parent.ContainerClass or IsKindOf(item_parent, "XTemplateElement") and "XTemplateElement" or false
    if container_class and container_class ~= "" and IsKindOf(clipboard_class, container_class) then
      new_path = {}
      for j = 1, i do
        new_path[j] = path[j]
      end
      new_path[#new_path] = new_path[#new_path] + 1
      parent = item_parent
      base_class = container_class
      break
    end
  end
  if not (parent and base_class) or not new_path then
    local item = hierarchy[#hierarchy]
    local container_class = IsKindOf(item, "Container") and item.ContainerClass or IsKindOf(item, "XTemplateElement") and "XTemplateElement" or false
    if container_class and container_class ~= "" and IsKindOf(clipboard_class, container_class) then
      new_path = table.icopy(path)
      new_path[#new_path + 1] = #item + 1
      parent = item
      base_class = container_class
    end
  end
  return parent, base_class, new_path
end
function GedOpPasteModItem(socket, root, path)
  if not path then
    return "invalid selection"
  end
  if GedClipboard.base_class == "PropertiesContainer" then
    return GedOpPropertyPaste(socket)
  end
  local parent, new_item, new_path, undo
  local clipboard_class = g_Classes[GedClipboard.base_class]
  if not clipboard_class then
    return "invalid clipboard content"
  end
  if IsKindOf(clipboard_class, "ModItem") then
    local mod = root[1]
    local mod_items = mod.items
    local new_items = GedRestoreFromClipboard("ModItem")
    parent = mod_items
    new_item = new_items[1]
    new_item.mod = mod
    new_path = {
      1,
      (path[2] or #parent) + 1
    }
  else
    local base_class
    parent, base_class, new_path = ResolveModItemToPasteIn(root, path, clipboard_class)
    if not parent or not base_class then
      return "cannot find where to paste"
    end
    local new_items = GedRestoreFromClipboard(base_class)
    new_item = new_items[1]
  end
  if not parent or not new_item then
    return "failed pasting"
  end
  local old_id = new_item.id
  if IsKindOf(new_item, "Preset") then
    new_item.id = new_item:GenerateUniquePresetId()
    new_item:Register()
    GedNotifyRecursive(new_item, "OnEditorNew", parent, socket, "paste", old_id)
    new_item:PostLoad()
    new_item:MarkDirty()
    new_item:SortPresets()
    local groups = Presets[new_item.PresetClass or new_item.class]
    UpdateParentTable(new_item, groups[new_item.group])
    PopulateParentTableCache(new_item)
  else
    GedNotifyRecursive(new_item, "OnEditorNew", parent, socket, "paste", old_id)
  end
  local code_item_file_path
  if IsKindOf(new_item, "ModItemCode") then
    code_item_file_path = new_item:GetCodeFilePath()
  end
  local index = new_path[#new_path]
  table.insert(parent, index, new_item)
  if IsKindOf(new_item, "ModItemCode") then
    local err = AsyncCopyFile(code_item_file_path, new_item:GetCodeFilePath(), "raw")
    if err then
      print("Ged: Error duplicating mod code", err)
    end
  end
  GedNotifyRecursive(new_item, "OnAfterEditorNew", parent, socket, "paste")
  GedObjectModified(root)
  return new_path, function()
    GedOpTreeDeleteItem(socket, root, new_path)
  end
end
function GedOpDeleteModItem(socket, root, path, force)
  if #path < 2 then
    return "invalid path"
  end
  local mod = root[1]
  local mod_items = mod.items
  local item, parent = mod_items
  for i = 2, #path do
    parent = item
    item = parent[path[i]]
  end
  if not parent or not item then
    return "cannot find selected item"
  end
  if not force then
    local item_name = ""
    if IsKindOf(item, "ModItemPreset") then
      item_name = item.id
    elseif IsKindOf(item, "ModItem") then
      item_name = item.name
    elseif IsKindOf(item, "XTemplateElement") and IsKindOf(item, "XTemplateWindow") then
      item_name = item.__class
    end
    if item_name == "" then
      if IsKindOf(item, "PropertyObject") and item:HasMember("EditorName") then
        item_name = item.EditorName
      else
        item_name = item.class
      end
    end
    if string.starts_with(item_name:lower(), "new ") then
      item_name = string.sub(item_name, 5)
    end
    if "ok" ~= socket:WaitQuestion(T(986829419084, "Confirmation"), T({
      435161105463,
      "Please confirm the deletion of item '<u(name)>'!",
      name = item_name
    })) then
      return
    end
  end
  if 2 < #path then
    return GedOpTreeDeleteItem(socket, root, path)
  else
    local index = path[#path]
    local item = table.remove(parent, index)
    item.mod = nil
    local undo_data = ValueToLuaCode(item)
    item.mod = mod
    local undo_ondelete = item:OnEditorDelete(mod, socket)
    item:delete()
    ObjModified(root)
    local selection = {
      1,
      Clamp(index, 1, #parent)
    }
    return selection, function()
      local err, item = LuaCodeToTuple(undo_data, LuaValueEnv({}))
      if err then
        print("Ged: Error restoring object", err)
        return "failed to restore the object"
      end
      item.mod = mod
      GedOpNewModItem(socket, root, item)
      if undo_ondelete then
        undo_ondelete()
      end
    end
  end
end
function GedOpSaveMod(socket, root)
  PauseInfiniteLoopDetection("GedOpSaveMod")
  local mod = root[1]
  local err, code_dirty = mod:SaveDef()
  mod:SaveItems()
  mod:SaveOptions()
  if code_dirty then
    ReloadLua()
  end
  SortModsList()
  ObjModified(ModsList)
  ResumeInfiniteLoopDetection("GedOpSaveMod")
end
local CreatePackageForUpload = function(mod, params)
  local content_path = mod.content_path
  local temp_path = "TmpData/ModUpload/"
  local pack_path = temp_path .. "Pack/"
  local shots_path = temp_path .. "Screenshots/"
  AsyncDeletePath(temp_path)
  AsyncCreatePath(pack_path)
  AsyncCreatePath(shots_path)
  mod:SaveDef()
  mod:SaveItems()
  mod:SaveOptions()
  params.screenshots = {}
  for i = 1, 5 do
    local screenshot = mod["screenshot" .. i]
    if io.exists(screenshot) then
      local path, name, ext = SplitPath(screenshot)
      local new_name = ModsScreenshotPrefix .. name .. ext
      local new_path = shots_path .. new_name
      local err = AsyncCopyFile(screenshot, new_path)
      if not err then
        local os_path = ConvertToOSPath(new_path)
        table.insert(params.screenshots, os_path)
      end
    end
  end
  local files_to_pack = {}
  local substring_begin = #mod.content_path + 1
  local err, all_files = AsyncListFiles(mod.content_path, nil, "recursive")
  for i, file in ipairs(all_files) do
    local ignore
    for j, filter in ipairs(mod.ignore_files) do
      if MatchWildcard(file, filter) then
        ignore = true
        break
      end
    end
    if not ignore then
      table.insert(files_to_pack, {
        src = file,
        dst = string.sub(file, substring_begin)
      })
    end
  end
  local err = AsyncPack(pack_path .. ModsPackFileName, content_path, files_to_pack)
  if err then
    return false, T({
      243097197797,
      "Failed creating content package file (<err>)",
      err = err
    })
  end
  params.os_pack_path = ConvertToOSPath(pack_path .. ModsPackFileName)
  return true, nil
end
if FirstLoad then
  ModUploadDeveloperWarningShown = false
end
function UploadMod(ged_socket, mod, params, prepare_fn, upload_fn)
  ModUploadThread = CreateRealTimeThread(function(ged_socket, mod, params, prepare_fn, upload_fn)
    local DoUpload = function()
      local ReportError = function(ged_socket, message)
        if IsT(message) then
          local msg = T({
            478576792479,
            "Mod <ModLabel> was not uploaded! Error: <err>",
            mod,
            err = message
          })
          ModLog(msg)
          ged_socket:ShowMessage(T(634182240966, "Error"), msg)
        else
          ModLog(T({
            478576792479,
            "Mod <ModLabel> was not uploaded! Error: <err>",
            mod,
            err = Untranslated(message)
          }))
        end
      end
      local success, message
      success, message = prepare_fn(ged_socket, mod, params)
      if not success then
        ReportError(ged_socket, message)
        return
      end
      success, message = CreatePackageForUpload(mod, params)
      if not success then
        ReportError(ged_socket, message)
        return
      end
      success, message = upload_fn(ged_socket, mod, params)
      if not success then
        ReportError(ged_socket, message)
      else
        local msg = T({
          561889745203,
          "Mod <ModLabel> was successfully uploaded!",
          mod
        })
        ModLog(msg)
        ged_socket:ShowMessage(T(898871916829, "Success"), msg)
        if insideHG() then
          if Platform.goldmaster then
            ged_socket:ShowMessage(Untranslated("Reminder"), Untranslated("After publishing a mod, make sure to copy it to svnAssets/Source/Mods/ and commit."))
          elseif Platform.developer and not ModUploadDeveloperWarningShown then
            ged_socket:ShowMessage(Untranslated("Reminder"), Untranslated("Publishing sample mods should be done using the target GoldMaster version of the game."))
            ModUploadDeveloperWarningShown = true
          end
        end
      end
    end
    PauseInfiniteLoopDetection("UploadMod")
    GedSetUiStatus("mod_upload", "Uploading...")
    DoUpload()
    GedSetUiStatus("mod_upload")
    ResumeInfiniteLoopDetection("UploadMod")
  end, ged_socket, mod, params, prepare_fn, upload_fn)
end
function ValidateModBeforeUpload(ged_socket, mod)
  if IsValidThread(ModUploadThread) then
    ged_socket:ShowMessage(T(634182240966, "Error"), T(385084592410, "There is an active mod upload"))
    return "upload in progress"
  end
  if mod.last_changes == "" then
    ged_socket:ShowMessage(T(634182240966, "Error"), T(111635834565, "You need to write something into 'Last Changes' before uploading a mod."))
    return "no 'last changes'"
  end
end
function GedOpTestModItem(socket, root, path)
  if #path < 2 then
    return
  end
  local mod_item = root[1].items[path[2]]
  mod_item:TestModItem(socket)
end
function GedOpOpenModFolder(socket, root)
  local mod = root[1]
  local path = ConvertToOSPath(SlashTerminate(mod.path))
  CreateRealTimeThread(function()
    AsyncExec(string.format("cmd /c start /D \"%s\" .", path))
  end)
end
function GedOpModItemHelp(socket, root, path)
  if #path == 2 then
    local mod_item = root[1].items[path[2]]
    if mod_item then
      local filename = DocsRoot .. mod_item.class .. ".md.html"
      if io.exists(filename) then
        local path_to_mod_item = ConvertToOSPath(filename)
        OpenAddress(path_to_mod_item)
        return
      end
    end
  end
  local path_to_index = ConvertToOSPath(DocsRoot .. "index.md.html")
  if io.exists(path_to_index) then
    OpenAddress(path_to_index)
  end
end
