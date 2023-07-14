if not config.Mods then
  DefineModItemPreset = empty_func
  g_FontReplaceMap = false
  return
end
DefineClass.ModItemCode = {
  __parents = {"ModItem"},
  properties = {
    {
      category = "Mod",
      id = "name",
      name = T(126741858615, "Name"),
      default = "Script",
      editor = "text",
      validate = function(self, value)
        value = value:trim_spaces()
        if value == "" then
          return "Please enter a valid name"
        end
        for _, item in ipairs(self.mod.items) do
          if item.class == "ModItemCode" and item ~= self and item.name == value then
            return "A code item with that name already exists"
          end
        end
      end
    },
    {
      category = "Code",
      id = "CodeFileName",
      name = T(796986168471, "File name"),
      default = "",
      editor = "text",
      read_only = true,
      buttons = {
        {
          name = "Open",
          func = "OpenCodeFile"
        }
      }
    },
    {
      category = "Code",
      id = "CodeError",
      name = T(634182240966, "Error"),
      default = "",
      editor = "text",
      lines = 1,
      max_lines = 3,
      read_only = true,
      dont_save = true,
      translate = false,
      code = true
    },
    {
      category = "Code",
      id = "Preview",
      name = T(976782883072, "Preview"),
      default = "",
      editor = "text",
      lines = 10,
      max_lines = 30,
      wordwrap = false,
      read_only = true,
      dont_save = true,
      translate = false,
      code = true
    }
  },
  EditorName = "Code",
  EditorSubmenu = "Assets",
  preview = ""
}
function ModItemCode:OnEditorNew(mod, ged, is_paste)
  self.name = self:FindFreeFilename(self.name)
  AsyncCreatePath(self.mod.content_path .. "Code/")
  AsyncStringToFile(self:GetCodeFilePath(), "")
  return ModItem.OnEditorNew(self, mod, ged, is_paste)
end
function ModItemCode:OnEditorSetProperty(prop_id, old_value, ged)
  if prop_id == "name" then
    local old_file_name = self:GetCodeFilePath(old_value)
    local new_file_name = self:GetCodeFilePath()
    AsyncCreatePath(self.mod.content_path .. "Code/")
    local err
    if io.exists(old_file_name) then
      local data
      err, data = AsyncFileToString(old_file_name)
      err = err or AsyncStringToFile(new_file_name, data)
      if err then
        ged:ShowMessage(T(634182240966, "Error"), T({
          917766624361,
          "Error creating <file_name>",
          file_name = new_file_name
        }))
        self.name = old_value
        ObjModified(self)
        return
      end
      AsyncFileDelete(old_file_name)
    elseif not io.exists(new_file_name) then
      err = AsyncStringToFile(new_file_name, "")
    end
  end
end
function ModItemCode:GetCodeFileName(name)
  name = name or self.name or ""
  if name == "" then
    return
  end
  return string.format("Code/%s.lua", name:gsub("[/?<>\\:*|\"]", "_"))
end
function ModItemCode:OpenCodeFile()
  local file_path = self:GetCodeFilePath()
  if file_path ~= "" and io.exists(file_path) then
    CreateRealTimeThread(AsyncExec, "explorer " .. ConvertToOSPath(file_path))
  end
end
function ModItemCode:GetPreview()
  local err, code = AsyncFileToString(self:GetCodeFilePath())
  self.preview = code
  return code or ""
end
function ModItemCode:GetCodeError()
  local env = table.get(self, "mod", "env") or _ENV
  local func, err = load(self.preview, nil, nil, env)
  return err or ""
end
function ModItemCode:TestModItem(ged)
  if self.mod:UpdateCode() then
    ReloadLua()
  end
  ObjModified(self)
  ged:ShowMessage(T(192811104211, "Information"), T(561172467670, "Your code has been loaded and is currently active in the game."))
end
function OnMsg.ModCodeChanged(file, change)
  for i, mod in ipairs(ModsLoaded) do
    if not mod.packed then
      for _, item in ipairs(mod.items) do
        if item:IsKindOf("ModItemCode") and string.find_lower(file, item.name) then
          ObjModified(item)
          break
        end
      end
    end
  end
end
local DuplicateT = function(v)
  v = _InternalTranslate(v, false, false)
  return T({
    RandomLocId(),
    v
  })
end
local function DuplicateTs(obj, visited)
  visited = visited or {}
  for key, value in pairs(obj) do
    if value ~= "" and IsT(value) then
      obj[key] = DuplicateT(value)
    elseif type(value) == "table" and not visited[value] then
      visited[value] = true
      DuplicateTs(value, visited)
    end
  end
end
function DefineModItemPreset(preset, class)
  local parent_class = g_Classes[preset]
  class = class or {}
  class.GedEditor = false
  class.ModdedPresetClass = preset
  if parent_class and parent_class.PresetClass == preset then
    class.PresetClass = "ModItem" .. preset
  else
    class.PresetClass = nil
  end
  class.EditorMenubarName = false
  class.EditorView = ModItem.EditorView
  class.__parents = {
    "ModItemPreset",
    preset
  }
  class.GetError = ModItemPreset.GetError
  if (class.EditorName or "") == "" then
    class.EditorName = preset
  end
  local properties = class.properties or {}
  local id_prop = table.copy(table.find_value(Preset.properties, "id", "Id"))
  local group_prop = table.copy(table.find_value(Preset.properties, "id", "Group"))
  id_prop.category = "Mod"
  group_prop.category = "Mod"
  table.insert(properties, id_prop)
  table.insert(properties, group_prop)
  table.insert(properties, {id = "Comment", no_edit = true})
  table.insert(properties, {id = "new_in", editor = false})
  class.properties = properties
  UndefineClass("ModItem" .. preset)
  DefineClass("ModItem" .. preset, class)
  return class
end
function DefineModItemCompositeObject(preset, class)
  local class = DefineModItemPreset(preset, class)
  class.__parents = {
    "ModItemCompositeObject",
    preset
  }
  function class.new(class, obj)
    obj = CompositeDef.new(class, obj)
    obj = ModItemPreset.new(class, obj)
    return obj
  end
  function class:__toluacode(...)
    local mod = self.mod
    self.mod = nil
    local code = CompositeDef.__toluacode(self, ...)
    self.mod = mod
    return code
  end
  class.GetProperties = ModItemCompositeObject.GetProperties
  return class
end
DefineClass.ModItemCompositeObject = {
  __parents = {
    "ModItemPreset"
  },
  mod_properties_cache = false
}
function ModItemCompositeObject:GetProperties()
  local cache = self.mod_properties_cache or {}
  local object_class = self:GetObjectClass()
  if not cache[object_class] then
    local props = CompositeDef.GetProperties(self)
    for i, prop_meta in ipairs(props) do
      if prop_meta.editor == "browse" or prop_meta.editor == "ui_image" then
        props[i] = ModElementFixPathProp(prop_meta)
      end
    end
    rawset(g_Classes[self.class], "mod_properties_cache", cache)
    rawset(cache, object_class, props)
  end
  return cache[object_class]
end
DefineClass.ModItemPreset = {
  __parents = {"Preset", "ModItem"},
  properties = {
    {
      category = "Mod",
      id = "__copy_group",
      name = T(235434958666, "Copy from group"),
      default = "Default",
      editor = "combo",
      items = function(obj)
        local groups = PresetGroupsCombo(obj.PresetClass or obj.class)()
        table.remove_entry(groups, "Obsolete")
        return groups
      end,
      no_edit = function(obj)
        return not obj.HasGroups
      end,
      dont_save = true
    },
    {
      category = "Mod",
      id = "__copy",
      name = T(586992060545, "Copy from"),
      default = "",
      editor = "combo",
      items = function(obj)
        return PresetsCombo(obj.PresetClass or obj.class, not (obj.PresetClass == obj.ModdedPresetClass or obj.HasGroups) and obj.ModdedPresetClass or obj.__copy_group, nil, function(preset)
          return preset ~= obj and not preset.Obsolete
        end)
      end,
      dont_save = true
    },
    {id = "SaveIn", editor = false},
    {id = "name", editor = false},
    {id = "TODO", editor = false},
    {id = "Obsolete", editor = false}
  },
  EditorView = ModItem.EditorView,
  GedEditor = false,
  ModItemDescription = T(159662765679, "<u(id)>"),
  ModdedPresetClass = false,
  save_in = "none"
}
function ModItemPreset:SetSaveIn()
end
function ModItemPreset:GetSaveIn()
  return "none"
end
function ModItemPreset:GetSaveFolder()
  return nil
end
function ModItemPreset:GetSavePath()
  return nil
end
function ModItemPreset:Getname()
  return self.id
end
function ModItemPreset:GetSaveLocationType()
  return "mod"
end
function ModItemPreset:delete()
  Preset.delete(self)
  InitDone.delete(self)
end
function ModItemPreset:__toluacode(indent, code)
  local mod = self.mod
  self.mod = nil
  code = Preset.__toluacode(self, indent, code)
  self.mod = mod
  return code
end
function ModItemPreset:GetCodeFileName(name)
  if self.HasCompanionFile or self.GetCompanionFilesList ~= Preset.GetCompanionFilesList then
    name = name or self.id
    local sub_folder = IsKindOf(self, "CompositeDef") and self.ObjectBaseClass or self.PresetClass
    return name and name ~= "" and string.format("%s/%s.lua", sub_folder, name:gsub("[/?<>\\:*|\"]", "_"))
  end
end
function ModItemPreset:PreSave()
  self:OnPreSave()
  return ModItem.PreSave(self)
end
function ModItemPreset:PostSave()
  Msg("PresetSave", self.class)
  if self:GetCodeFileName() then
    local code = pstr("", 8192)
    self:GenerateCompanionFileCode(code)
    local path = self:GetCodeFilePath()
    local folder = SplitPath(path)
    AsyncCreatePath(folder)
    AsyncStringToFile(path, code)
  end
  return ModItem.PostSave(self)
end
function ModItemPreset:OnEditorSetProperty(prop_id, old_value, ged)
  Preset.OnEditorSetProperty(self, prop_id, old_value, ged)
  if prop_id == "Id" then
    if self:GetCodeFileName() then
      AsyncFileDelete(self:GetCodeFilePath(old_value))
    end
  elseif prop_id == "__copy" then
    local preset_class = self.PresetClass or self.class
    local preset_group = not (self.PresetClass == self.ModdedPresetClass or self.HasGroups) and self.ModdedPresetClass or self.__copy_group
    local id = self.__copy
    local preset
    ForEachPresetExtended(preset_class, function(obj)
      if obj.group == preset_group and obj.id == id and obj ~= self then
        preset = obj
        return "break"
      end
    end)
    if not preset then
      return
    end
    local do_copy = function()
      local blacklist = {
        "Id",
        "Group",
        "comment",
        "__copy"
      }
      CopyPropertiesBlacklisted(preset, self, blacklist)
      table.iclear(self)
      local count = 0
      for _, value in ipairs(preset) do
        local err, copy = CopyValue(value)
        if not err then
          count = count + 1
          self[count] = copy
        end
      end
      PopulateParentTableCache(self)
      DuplicateTs(self)
      ObjModified(ged:ResolveObj("root"))
      ObjModified(self)
    end
    self.__copy = nil
    ObjModified(self)
    if ged then
      CreateRealTimeThread(function()
        local fmt = "Do you want to copy all properties from %s.%s? The current values of the ModItem properties will be lost."
        local msg = string.format(fmt, preset_group, id)
        if ged:WaitQuestion("Warning!", msg) ~= "ok" then
          return
        end
        do_copy()
      end)
    else
      do_copy()
    end
  end
end
function ModItemPreset:TestModItem(ged)
  self:PostLoad()
  if self:GetCodeFileName() then
    self:PostSave()
    if self.mod:UpdateCode() then
      ReloadLua()
    end
    ged:ShowMessage(T(192811104211, "Information"), T(573166303378, "The new Lua code has been loaded and is currently active in the game."))
  end
end
function ModItemPreset:OnModLoad()
  ModItem.OnModLoad(self)
  self:PostLoad()
end
function ModItemPreset:GetWarning()
  local warning = g_Classes[self.ModdedPresetClass].GetWarning(self)
  return warning or self:IsDirty() and self:GetCodeFileName() and "Use the Test button or save the mod to test your changes."
end
function ModItemPreset:GetError()
  if self.id == "" then
    return "Please specify mod item Id."
  end
  return g_Classes[self.ModdedPresetClass].GetError(self)
end
function OnMsg.ClassesPostprocess()
  ClassDescendantsList("ModItemPreset", function(name, class)
    class.PresetClass = class.PresetClass or class.ModdedPresetClass
  end)
end
function OnMsg.ModsReloaded()
  for class, presets in pairs(Presets) do
    _G[class]:SortPresets()
  end
end
DefineModItemPreset("LightmodelPreset", {
  EditorName = "Lightmodel",
  properties = {
    {
      id = "cubemap_capture_preview"
    },
    {
      id = "exterior_envmap"
    },
    {
      id = "ext_env_exposure"
    },
    {
      id = "ExteriorEnvmapImage"
    },
    {
      id = "interior_envmap"
    },
    {
      id = "int_env_exposure"
    },
    {
      id = "InteriorEnvmapImage"
    },
    {
      id = "env_exterior_capture_sky_exp"
    },
    {
      id = "env_exterior_capture_sun_int"
    },
    {
      id = "env_exterior_capture_pos"
    },
    {
      id = "env_interior_capture_sky_exp"
    },
    {
      id = "env_interior_capture_sun_int"
    },
    {
      id = "env_interior_capture_pos"
    },
    {
      id = "env_capture_map"
    },
    {
      id = "env_capture"
    },
    {
      id = "env_view_site"
    },
    {id = "hdr_pano"},
    {id = "lm_capture"},
    {id = "__"}
  }
})
function ModItemLightmodelPreset:GetCubemapWarning()
end
function ModItemLightmodelPreset:TestModItem(ged)
  SetLightmodelOverride(1, LightmodelOverride ~= self and self)
end
function ModItemLightmodelPreset:OnEditorSelect(...)
  ModItemPreset.OnEditorSelect(self, ...)
  LightmodelPreset.OnEditorSelect(self, ...)
end
ModEntityClassesCombo = {
  "",
  "AnimatedTextureObject",
  "AutoAttachObject",
  "Deposition",
  "Decal",
  "FloorAlignedObj",
  "Mirrorable"
}
DefineClass.ModItemEntity = {
  __parents = {
    "ModItem",
    "EntitySpecProperties"
  },
  EditorName = "Entity",
  EditorSubmenu = "Assets",
  properties = {
    {
      category = "Mod",
      id = "name",
      name = T(126741858615, "Name"),
      default = "",
      editor = "text"
    },
    {
      category = "Mod",
      id = "entity_name",
      name = T(982011307501, "Entity Name"),
      default = "",
      editor = "text",
      read_only = true
    },
    {
      category = "Mod",
      id = "import",
      name = T(936385684523, "Import"),
      editor = "browse",
      os_path = true,
      filter = "Entity files|*.ent",
      default = "",
      buttons = {
        {name = "Import", func = "Import"}
      },
      dont_save = true
    },
    {
      category = "Mod",
      id = "reload",
      editor = "buttons",
      default = false,
      buttons = {
        {
          name = "Reload entities (slow)",
          func = "ReloadEntities"
        }
      }
    },
    {
      category = "Misc",
      id = "class_parent",
      name = "Class",
      editor = "combo",
      items = ModEntityClassesCombo,
      default = ""
    }
  }
}
if Platform.developer then
  g_HgnvCompressPath = "svnSrc/Tools/hgnvcompress/Bin/hgnvcompress.exe"
  g_HgimgcvtPath = "svnSrc/Tools/hgimgcvt/Bin/hgimgcvt.exe"
else
  g_HgnvCompressPath = "ModTools/AssetsProcessor/hgnvcompress.exe"
  g_HgimgcvtPath = "ModTools/hgimgcvt.exe"
end
function ParseEntity(root, name)
  local filename = root .. name .. ".ent"
  local err, xml = AsyncFileToString(filename)
  if err then
    return err
  end
  local entity = {
    materials = {},
    meshes = {},
    animations = {},
    textures = {}
  }
  for asset in string.gmatch(xml, "<material file=\"(.-)%.mtl\"") do
    entity.materials[#entity.materials + 1] = asset
  end
  for asset in string.gmatch(xml, "<anim file=\"(.-)%.hgac?l?\"") do
    entity.animations[#entity.animations + 1] = asset
  end
  for asset in string.gmatch(xml, "<mesh file=\"(.-)%.hgm\"") do
    entity.meshes[#entity.meshes + 1] = asset
  end
  for _, material in ipairs(entity.materials) do
    local err, mtl = AsyncFileToString(root .. material .. ".mtl")
    for map in string.gmatch(mtl, "Map Name=\"(.-)%.dds") do
      entity.textures[#entity.textures + 1] = map
    end
  end
  return nil, entity
end
function ModItemEntity:Import(root, prop_id, socket, btn_param, idx)
  local import_root, name, ext = SplitPath(self.import)
  local import_root, entity_name, ext = SplitPath(self.import)
  if not entity_name then
    ModLog(T(218114189738, "Invalid entity filename"))
    return
  end
  local entity_root = self.mod.content_path .. "Entities/"
  local err = AsyncCreatePath(entity_root)
  if err then
    ModLog(T({
      988875502395,
      "Failed to create path <u(entity_root)>",
      entity_root = entity_root
    }))
  end
  ModLog(T({
    404010916837,
    "Importing entity <u(entity_name)>",
    entity_name = entity_name
  }))
  local dest_path = entity_root .. entity_name .. ext
  err = AsyncCopyFile(self.import, dest_path)
  if err then
    ModLog(T({
      957932678150,
      "Failed to copy entity <u(entity_name)> to <u(dest_path)>",
      entity_name = entity_name,
      dest_path = dest_path
    }))
    return
  end
  local err, entity = ParseEntity(import_root, entity_name)
  if err then
    ModLog(T({
      856137472822,
      "Failed to open entity file <u(dest_path)>",
      dest_path = dest_path
    }))
    return
  end
  local CopyAssetType = function(folder, tbl, exts, asset_type)
    local dest_path = entity_root .. folder
    for _, asset in ipairs(entity[tbl]) do
      local err = AsyncCreatePath(dest_path)
      if err then
        ModLog(T({
          759029057846,
          "Failed to create path <u(dest_path)>",
          dest_path = dest_path
        }))
        break
      end
      local matched = false
      for _, ext in ipairs(type(exts) == "table" and exts or {exts}) do
        local src_filename
        if string.starts_with(asset, folder) then
          src_filename = import_root .. asset .. ext
        else
          src_filename = import_root .. folder .. asset .. ext
        end
        if io.exists(src_filename) then
          local dest_filename
          if string.starts_with(asset, folder) then
            dest_filename = entity_root .. asset .. ext
          else
            dest_filename = entity_root .. folder .. asset .. ext
          end
          err = AsyncCopyFile(src_filename, dest_filename)
          if err then
            ModLog(T({
              741423464932,
              "Failed to copy <u(src)> to <u(dest)>",
              src = src_filename,
              dest = dest_filename
            }))
          else
            ModLog(T({
              215214926820,
              "Importing <asset_type> <u(asset)>",
              asset_type = asset_type,
              asset = asset
            }))
          end
          matched = true
        end
      end
      if not matched then
        ModLog(T({
          853723998988,
          "Missing file <u(src)> referenced in entity",
          src = asset
        }))
      end
    end
  end
  CopyAssetType("Meshes/", "meshes", ".hgm", T(249757315428, "mesh"))
  CopyAssetType("Animations/", "animations", {".hga", ".hgacl"}, T(527192091105, "animation"))
  CopyAssetType("Materials/", "materials", ".mtl", T(393939724897, "material"))
  CopyAssetType("Textures/", "textures", ".dds", T(111180866946, "texture"))
  local dest_path = entity_root .. "Textures/Fallbacks/"
  for _, asset in ipairs(entity.textures) do
    local err = AsyncCreatePath(dest_path)
    if err then
      ModLog(T({
        759029057846,
        "Failed to create path <u(dest_path)>",
        dest_path = dest_path
      }))
      break
    end
    local src_filename = entity_root .. "Textures/" .. asset .. ".dds"
    local dest_filename = dest_path .. asset .. ".dds"
    local cmdline = string.format("\"%s\" \"%s\" \"%s\" --truncate %d", ConvertToOSPath(g_HgimgcvtPath), ConvertToOSPath(src_filename), ConvertToOSPath(dest_filename), 64)
    local err = AsyncExec(cmdline, ".", true)
    if err then
      ModLog(T({
        465127574053,
        "Failed to generate backup for <u(asset)>",
        asset = asset
      }))
      ModLog(Untranslated(cmdline .. "    " .. err))
    end
  end
  if self.name == "" then
    self.name = entity_name
  end
  self.entity_name = entity_name
  self:StoreImportPath()
  ObjModified(self)
end
function ModItemEntity:ReloadEntities(root, prop_id, socket, btn_param, idx)
  ChangeMap("")
  ModsLoadAssets()
  ChangeMap(ModEditorMapName)
end
function ModItemEntity:PostSave()
  ModItem.PostSave(self)
  if not self.entity_name then
    return
  end
  local data = self:ExportEntityDataForSelf()
  if not next(data) then
    return
  end
  local code = string.format("EntityData[\"%s\"] = %s", self.entity_name, ValueToLuaCode(data))
  local path = self:GetCodeFilePath()
  local folder = SplitPath(path)
  AsyncCreatePath(folder)
  AsyncStringToFile(path, code)
end
function ModItemEntity:GetCodeFileName()
  if not self.entity_name then
    return
  end
  local data = self:ExportEntityDataForSelf()
  if not next(data) then
    return
  end
  return string.format("Entities/%s.lua", self.entity_name)
end
if FirstLoad then
  EntityLoadEntities = {}
  ModsLoadTextures = {}
end
function DelayedLoadEntity(mod, entity, entity_filename)
  EntityLoadEntities[#EntityLoadEntities + 1] = {
    mod,
    entity,
    entity_filename
  }
end
function DelayedLoadTextureFallbacks(fallback_path)
  table.insert_unique(ModsLoadTextures, fallback_path)
end
function WaitDelayedLoadEntities()
  if #EntityLoadEntities > 0 then
    local list = EntityLoadEntities
    EntityLoadEntities = {}
    AsyncLoadAdditionalEntities(table.map(list, 3))
    Msg("EntitiesLoaded")
    for i, data in ipairs(list) do
      if not IsValidEntity(data[2]) then
        ModLog(T({
          175747704987,
          "Mod: <ModLabel> Entity: Failed to load <u(entity)>",
          data[1],
          entity = data[2]
        }))
      end
    end
  end
  if 0 < #ModsLoadTextures then
    local list = ModsLoadTextures
    ModsLoadTextures = {}
    AsyncLoadAdditionalTextureFallbacks(list)
  end
end
function ModItemEntity:StoreImportPath()
  if not self.mod or (self.entity_name or "") == "" then
    return
  end
  local key = string.format("%s_%s", self.mod.id, self.entity_name)
  table.set(LocalStorage, "EntityModImportPaths", key, self.import)
  SaveLocalStorageDelayed()
end
function ModItemEntity:RestoreImportPath()
  if not self.mod or (self.entity_name or "") == "" then
    return
  end
  local key = string.format("%s_%s", self.mod.id, self.entity_name)
  self.import = table.get(LocalStorage, "EntityModImportPaths", key) or self.import or ""
end
function ModItemEntity:OnEditorSetProperty(prop_id, old_value, ged)
  if prop_id == "import" then
    self:StoreImportPath()
  end
  return ModItemPreset.OnEditorSetProperty(self, prop_id, old_value, ged)
end
function ModItemEntity:OnModLoad()
  ModItem.OnModLoad(self)
  self:RestoreImportPath()
  local entity_filename = self.mod.content_path .. "Entities/" .. self.entity_name .. ".ent"
  if not io.exists(entity_filename) then
    ModLog(T({
      356281616072,
      "Failed to open entity file <u(filename)>",
      filename = entity_filename
    }))
    return
  end
  DelayedLoadEntity(self.mod, self.entity_name, entity_filename)
end
function ModItemEntity:TestModItem(ged)
  self.mod:UpdateCode()
  self:OnModLoad()
  WaitDelayedLoadEntities()
  Msg("BinAssetsLoaded")
  ReloadLua()
  if GetMap() == "" then
    ModLog(T(495557523821, "Entity testing only possible when a map is loaded"))
    return
  end
  local obj = PlaceObject("Shapeshifter")
  obj:ChangeEntity(self.entity_name)
  obj:SetPos(GetTerrainCursorXY(UIL.GetScreenSize() / 2))
  if IsEditorActive() then
    EditorViewMapObject(obj, nil, true)
  else
    ViewObject(obj)
  end
end
local DeleteIfEmpty = function(path)
  local err, files = AsyncListFiles(path, "*", "recursive")
  local err, folders = AsyncListFiles(path, "*", "recursive,folders")
  if #files == 0 and #folders == 0 then
    AsyncDeletePath(path)
  end
end
local DeleteEntity = function(entity_root, entity_name)
  local err, entity = ParseEntity(entity_root, entity_name)
  if err then
    return
  end
  for _, name in ipairs(entity.meshes) do
    AsyncFileDelete(entity_root .. "Meshes/" .. name .. ".hgm")
  end
  for _, name in ipairs(entity.animations) do
    if io.exists(entity_root .. "Animations/" .. name .. ".hga") then
      AsyncFileDelete(entity_root .. "Animations/" .. name .. ".hga")
    else
      AsyncFileDelete(entity_root .. "Animations/" .. name .. ".hgacl")
    end
  end
  for _, name in ipairs(entity.materials) do
    AsyncFileDelete(entity_root .. "Materials/" .. name .. ".mtl")
  end
  for _, name in ipairs(entity.textures) do
    AsyncFileDelete(entity_root .. "Textures/" .. name .. ".dds")
    AsyncFileDelete(entity_root .. "Textures/Fallbacks/" .. name .. ".dds")
  end
  AsyncFileDelete(entity_root .. entity_name .. ".ent")
  DeleteIfEmpty(entity_root .. "Meshes/")
  DeleteIfEmpty(entity_root .. "Animations/")
  DeleteIfEmpty(entity_root .. "Materials/")
  DeleteIfEmpty(entity_root .. "Textures/Fallbacks/")
  DeleteIfEmpty(entity_root .. "Textures/")
  DeleteIfEmpty(entity_root)
end
function ModItemEntity:OnEditorDelete(mod, ged)
  local entity_root = self.mod.content_path .. "Entities/"
  DeleteEntity(entity_root, self.entity_name)
end
function GetModEntities(typ)
  local results = {}
  for _, mod in ipairs(ModsLoaded or empty_table) do
    for _, mc in ipairs(mod.items) do
      if IsKindOf(mc, "ModItemEntity") or IsKindOf(mc, "ModItemDecalEntity") then
        results[#results + 1] = mc.entity_name
      end
    end
  end
  table.sort(results)
  return results
end
if FirstLoad then
  g_FontReplaceMap = {}
end
DefineClass.FontAsset = {
  __parents = {"InitDone"},
  properties = {
    {
      id = "FontPath",
      name = "Font path",
      editor = "font",
      default = false,
      os_path = true
    }
  }
}
function FontAsset:Done()
  if self.FontPath then
    AsyncDeletePath(self.FontPath)
  end
end
function FontAsset:LoadFont(font_path)
  local file_list = {}
  table.insert(file_list, font_path)
  return UIL.LoadFontFileList(file_list)
end
function FontAsset:OnEditorSetProperty(prop_id, old_value, ged)
  if prop_id == "FontPath" then
    GedSetUiStatus("mod_import_particle_texture", "Importing font...")
    if old_value then
      AsyncDeletePath(old_value)
    end
    if self.FontPath then
      local ok = self:LoadFont(self.FontPath)
      print(ok)
      if not ok then
        ged:ShowMessage("Failed importing font", [[
The font file could not be processed correctly. Please try another font file or format. 
Read the mod item font documentation for more details on supported formats.]])
        AsyncDeletePath(self.FontPath)
        self.FontPath = nil
      end
    end
    GedSetUiStatus("mod_import_particle_texture")
  end
  ModItem.OnEditorSetProperty(self, prop_id, old_value, ged)
end
local font_items = function()
  return UIL.GetAllFontNames()
end
DefineClass.FontReplaceMapping = {
  __parents = {"InitDone"},
  properties = {
    {
      id = "Replace",
      name = "Replace",
      editor = "choice",
      default = false,
      items = font_items
    },
    {
      id = "With",
      name = "With",
      editor = "choice",
      default = false,
      items = font_items
    }
  }
}
function FontReplaceMapping:Done()
  if self.Replace and g_FontReplaceMap then
    g_FontReplaceMap[self.Replace] = nil
  end
end
function FontReplaceMapping:OnEditorSetProperty(prop_id, old_value, ged)
  if prop_id == "Replace" and old_value and g_FontReplaceMap then
    g_FontReplaceMap[old_value] = nil
  end
  if self.Replace and self.With and g_FontReplaceMap then
    g_FontReplaceMap[self.Replace] = self.With
    Msg("TranslationChanged")
  end
  ModItem.OnEditorSetProperty(self, prop_id, old_value, ged)
end
DefineClass.ModItemFont = {
  __parents = {"ModItem"},
  properties = {
    {
      category = "Font assets",
      id = "AssetFiles",
      name = "Font asset files",
      editor = "nested_list",
      default = false,
      base_class = "FontAsset",
      auto_expand = true,
      help = "Import TTF and OTF font files to be loaded into the game"
    },
    {
      category = "Font replace mapping",
      id = "ReplaceMappings",
      name = "Font replace mappings",
      editor = "nested_list",
      default = false,
      base_class = "FontReplaceMapping",
      auto_expand = true,
      help = "Choose fonts to replace and which fonts to replace them with"
    },
    {
      category = "Font replace mapping",
      id = "TextStylesHelp",
      name = "TextStyles help",
      editor = "help",
      default = false,
      help = "You can also replace individual text styles by adding \"TextStyle\" mod items."
    }
  },
  EditorName = "Font",
  EditorSubmenu = "Assets"
}
function ModItemFont:GetFontTargetPath()
  return SlashTerminate(self.mod.content_path) .. "Fonts"
end
function ModItemFont:OnModLoad()
  self:LoadFonts()
  self:ApplyFontReplaceMapping()
  Msg("TranslationChanged")
  ModItem.OnModLoad(self)
end
function ModItemFont:OnModUnload()
  self:RemoveFontReplaceMapping()
  Msg("TranslationChanged")
  ModItem.OnModUnload(self)
end
function ModItemFont:LoadFonts()
  if not self.AssetFiles then
    return false
  end
  local file_list = {}
  for _, font_asset in ipairs(self.AssetFiles) do
    if font_asset.FontPath then
      table.insert(file_list, font_asset.FontPath)
    end
  end
  return UIL.LoadFontFileList(file_list)
end
function ModItemFont:ApplyFontReplaceMapping()
  if not self.ReplaceMappings or not g_FontReplaceMap then
    return false
  end
  for _, mapping in ipairs(self.ReplaceMappings) do
    if mapping.Replace and mapping.With then
      g_FontReplaceMap[mapping.Replace] = mapping.With
    end
  end
end
function ModItemFont:RemoveFontReplaceMapping()
  if not self.ReplaceMappings or not g_FontReplaceMap then
    return false
  end
  for _, mapping in ipairs(self.ReplaceMappings) do
    if mapping.Replace then
      g_FontReplaceMap[mapping.Replace] = nil
    end
  end
end
local size_items = {
  {
    id = "Small",
    name = "Small (10cm x 10cm)"
  },
  {
    id = "Medium",
    name = "Medium (1m x 1m)"
  },
  {
    id = "Large",
    name = "Large (10m x 10m)"
  }
}
local decal_group_items = {
  "Default",
  "Terrain",
  "TerrainOnly",
  "Unit"
}
DefineClass.ModItemDecalEntity = {
  __parents = {"ModItem"},
  EditorName = "Decal",
  EditorSubmenu = "Assets",
  properties = {
    {
      category = "Decal",
      id = "entity_name",
      name = T(241118565480, "Entity name"),
      editor = "text",
      default = ""
    },
    {
      category = "Decal",
      id = "size",
      name = T(985198350450, "Size"),
      editor = "choice",
      default = "Small",
      items = size_items
    },
    {
      category = "Decal",
      id = "BaseColorMap",
      name = T(679875664715, "Basecolor map"),
      editor = "browse",
      os_path = true,
      filter = "Image files|*.png;*.tga",
      default = "",
      mtl_map = "BaseColorDecal"
    },
    {
      category = "Decal",
      id = "NormalMap",
      name = T(475568642377, "Normal map"),
      editor = "browse",
      os_path = true,
      filter = "Image files|*.png;*.tga",
      default = "",
      mtl_map = "NormalMapDecal"
    },
    {
      category = "Decal",
      id = "RMMap",
      name = T(632564835125, "Roughness/metallic map"),
      editor = "browse",
      os_path = true,
      filter = "Image files|*.png;*.tga",
      default = "",
      mtl_map = "RMDecal"
    },
    {
      category = "Decal",
      id = "AOMap",
      name = T(877960856719, "Ambient occlusion map"),
      editor = "browse",
      os_path = true,
      filter = "Image files|*.png;*.tga",
      default = "",
      mtl_map = "AODecal"
    },
    {
      category = "Decal",
      id = "TriplanarDecal",
      name = T(685026029736, "Triplanar"),
      editor = "bool",
      default = false,
      mtl_prop = true,
      help = T(406820683275, "(When toggled the decal is projected along every axis, not only forward.")
    },
    {
      category = "Decal",
      id = "DoubleSidedDecal",
      name = T(625159885998, "Double sided"),
      editor = "bool",
      default = true,
      mtl_prop = true,
      help = T(895748319700, "When toggled the decal can be seen from the backside as well. This is useful for objects that can be hidden, like wall slabs.")
    },
    {
      category = "Decal",
      id = "DecalGroup",
      name = T(781808714900, "Group"),
      editor = "choice",
      default = "Default",
      items = decal_group_items,
      mtl_prop = true,
      help = T(398580232757, [[
Determines what objects will have the decal projected onto.

Default - everything
Terrain - the terrain, slabs and small terrain objects like grass, rocks and others
TerrainOnly - only the terrain
Unit - only units]])
    },
    {
      category = "Decal",
      id = "import_button",
      editor = "buttons",
      buttons = {
        {name = "Import", func = "Import"}
      },
      default = ""
    }
  }
}
function ModItemDecalEntity:Import(root, prop_id, ged_socket)
  GedSetUiStatus("mod_import_decal", "Importing...")
  local success = self:DoImport(root, prop_id, ged_socket)
  if not success then
    GedSetUiStatus("mod_import_decal")
    return
  end
  self:OnModLoad()
  WaitDelayedLoadEntities()
  Msg("BinAssetsLoaded")
  GedSetUiStatus("mod_import_decal")
  ged_socket:ShowMessage(T(898871916829, "Success"), T(597034295783, "Decal imported successfully!"))
end
function ModItemDecalEntity:DoImport(root, prop_id, ged_socket)
  local output_dir = ConvertToOSPath(self.mod.content_path)
  local ent_dir = output_dir .. "Entities/"
  local mesh_dir = ent_dir .. "Meshes/"
  local mtl_dir = ent_dir .. "Materials/"
  local texture_dir = ent_dir .. "Textures/"
  local fallback_dir = texture_dir .. "Fallbacks/"
  if not self:CreateDirectory(ged_socket, ent_dir, "Entities") then
    return
  end
  if not self:CreateDirectory(ged_socket, mesh_dir, "Meshes") then
    return
  end
  if not self:CreateDirectory(ged_socket, mtl_dir, "Materials") then
    return
  end
  if not self:CreateDirectory(ged_socket, texture_dir, "Textures") then
    return
  end
  if not self:CreateDirectory(ged_socket, fallback_dir, "Fallbacks") then
    return
  end
  for i, prop_meta in ipairs(self:GetProperties()) do
    if prop_meta.mtl_map then
      local path = self:GetProperty(prop_meta.id)
      if path ~= "" and not self:ImportImage(ged_socket, prop_meta.id, texture_dir, fallback_dir) then
        return
      end
    end
  end
  local ent_file = self.entity_name .. ".ent"
  local ent_output = ent_dir .. ent_file
  local mtl_file = self.entity_name .. "_mesh.mtl"
  local mtl_output = mtl_dir .. mtl_file
  local mesh_file = self.entity_name .. "_mesh.hgm"
  local mesh_output = mesh_dir .. mesh_file
  if not self:CreateEntityFile(ged_socket, ent_output, mesh_file, mtl_file) then
    return
  end
  if not self:CreateMtlFile(ged_socket, mtl_output) then
    return
  end
  if not self:CreateMeshFile(ged_socket, mesh_output) then
    return
  end
  return true
end
function ModItemDecalEntity:CreateDirectory(ged_socket, path, name)
  local err = AsyncCreatePath(path)
  if err then
    ged_socket:ShowMessage(T(368718514612, "Failed importing decal"), T({
      867697035195,
      "Failed creating <u(dir)> directory: <u(err)>.",
      dir = name,
      err = err
    }))
    return
  end
  return true
end
function ModItemDecalEntity:GetTextureFileName(prop_id, extension)
  return string.format("mod_%s_%s%s", prop_id, self.entity_name, extension)
end
function ModItemDecalEntity:ValidateImage(prop_id)
  local path = self:GetProperty(prop_id)
  if not io.exists(path) then
    local prop_name = self:GetPropertyMetadata(prop_id).name
    ged_socket:ShowMessage(T(368718514612, "Failed importing decal"), T({
      134357552712,
      "Import failed - the <kind> image was not found.",
      kind = prop_name
    }))
    return
  end
  local w, h = UIL.MeasureImage(path)
  if w ~= h then
    local prop_name = self:GetPropertyMetadata(prop_id).name
    ged_socket:ShowMessage(T(368718514612, "Failed importing decal"), T({
      306111335865,
      "The import failed because the <kind> image width and height are wrong. Image must be a square and pixel width and height must be power of two (e.g. 1024, 2048, 4096, etc.).",
      kind = prop_name
    }))
    return
  end
  if w <= 0 or band(w, w - 1) ~= 0 then
    local prop_name = self:GetPropertyMetadata(prop_id).name
    ged_socket:ShowMessage(T(368718514612, "Failed importing decal"), T({
      306111335865,
      "The import failed because the <kind> image width and height are wrong. Image must be a square and pixel width and height must be power of two (e.g. 1024, 2048, 4096, etc.).",
      kind = prop_name
    }))
    return
  end
  return true
end
function ModItemDecalEntity:ImportImage(ged_socket, prop_id, texture_dir, fallback_dir)
  if not self:ValidateImage(prop_id) then
    return
  end
  local path = self:GetProperty(prop_id)
  local texture_name = self:GetTextureFileName(prop_id, ".dds")
  local texture_output = texture_dir .. texture_name
  local cmdline = string.format("\"%s\" -dds10 -24 bc1 -32 bc3 -srgb \"%s\" \"%s\"", ConvertToOSPath(g_HgnvCompressPath), path, texture_output)
  local err = AsyncExec(cmdline, "", true, false)
  if err then
    ged_socket:ShowMessage(T(368718514612, "Failed importing decal"), T({
      870555284339,
      "Failed creating compressed image: <u(err)>.",
      err = err
    }))
    return
  end
  local fallback_output = fallback_dir .. texture_name
  cmdline = string.format("\"%s\" \"%s\" \"%s\" --truncate %d", ConvertToOSPath(g_HgimgcvtPath), texture_output, fallback_output, const.FallbackSize)
  local err = AsyncExec(cmdline, "", true, false)
  if err then
    ged_socket:ShowMessage(T(368718514612, "Failed importing decal"), T({
      760561283947,
      "Failed creating fallback image: <u(err)>.",
      err = err
    }))
    return
  end
  return true
end
function ModItemDecalEntity:CreateEntityFile(ged_socket, ent_path, mesh_file, mtl_file)
  local placeholder_entity = string.format("DecMod_%s", self.size)
  local bbox = GetEntityBoundingBox(placeholder_entity)
  local bbox_min_str = string.format("%d,%d,%d", bbox:minxyz())
  local bbox_max_str = string.format("%d,%d,%d", bbox:maxxyz())
  local bcenter, bradius = GetEntityBoundingSphere(placeholder_entity)
  local bcenter_str = string.format("%d,%d,%d", bcenter:xyz())
  local lines = {
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
    "<entity path=\"\">",
    "\t<state id=\"idle\">",
    "\t\t<mesh_ref ref=\"mesh\"/>",
    "\t</state>",
    "\t<mesh_description id=\"mesh\">",
    "\t\t<src file=\"\"/>",
    string.format("\t\t<mesh file=\"Meshes/%s\"/>", mesh_file),
    string.format("\t\t<material file=\"Materials/%s\"/>", mtl_file),
    string.format("\t\t<bsphere value=\"%s,%d\"/>", bcenter_str, bradius),
    string.format("\t\t<box min=\"%s\" max=\"%s\"/>", bbox_min_str, bbox_max_str),
    "\t</mesh_description>",
    "</entity>"
  }
  local content = table.concat(lines, "\n")
  local err = AsyncStringToFile(ent_path, content)
  if err then
    ged_socket:ShowMessage(T(368718514612, "Failed importing decal"), T({
      588496397160,
      "Failed creating entity file: <u(err)>.",
      err = err
    }))
    return
  end
  return true
end
function ModItemDecalEntity:CreateMtlFile(ged_socket, mtl_path)
  local mtl_props = {
    AlphaTestValue = 128,
    BlendType = "Blend",
    CastShadow = false,
    SpecialType = "Decal",
    Deposition = false,
    TerrainDistortedMesh = false
  }
  for i, prop_meta in ipairs(self:GetProperties()) do
    local id = prop_meta.id
    if prop_meta.mtl_map then
      local path = self:GetProperty(id)
      mtl_props[prop_meta.mtl_map] = io.exists(path)
    elseif prop_meta.mtl_prop then
      mtl_props[id] = self:GetProperty(id)
    end
  end
  local lines = {
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
    "<Materials>",
    "\t<Material>"
  }
  for i, prop_meta in ipairs(self:GetProperties()) do
    local id = prop_meta.id
    if prop_meta.mtl_map and mtl_props[prop_meta.mtl_map] then
      local path = self:GetTextureFileName(id, ".dds")
      table.insert(lines, string.format("\t\t<%s Name=\"%s\" mc=\"0\"/>", id, path))
    end
  end
  for id, value in sorted_pairs(mtl_props) do
    local value_type, value_str = type(value), ""
    if value_type == "boolean" then
      value_str = value and "1" or "0"
    else
      value_str = tostring(value)
    end
    table.insert(lines, string.format("\t\t<Property %s=\"%s\"/>", id, value_str))
  end
  table.insert(lines, "\t</Material>")
  table.insert(lines, "</Materials>")
  local content = table.concat(lines, "\n")
  local err = AsyncStringToFile(mtl_path, content)
  if err then
    ged_socket:ShowMessage(T(368718514612, "Failed importing decal"), T({
      119691983329,
      "Failed creating material file: <u(err)>.",
      err = err
    }))
    return
  end
  return true
end
function ModItemDecalEntity:CreateMeshFile(ged_socket, hgm_path)
  local placeholder_entity = string.format("DecMod_%s", self.size)
  local placeholder_file = placeholder_entity .. "_mesh.hgm"
  local placeholder_path = "Meshes/" .. placeholder_file
  local err = AsyncCopyFile(placeholder_path, hgm_path)
  if err then
    ged_socket:ShowMessage(T(368718514612, "Failed importing decal"), T({
      407000365524,
      "Could not create a mesh file: <u(err)>.",
      err = err
    }))
    return
  end
  return true
end
function ModItemDecalEntity:OnModLoad()
  ModItem.OnModLoad(self)
  local entity_filename = self.mod.content_path .. "Entities/" .. self.entity_name .. ".ent"
  if not io.exists(entity_filename) then
    ModLog(T({
      356281616072,
      "Failed to open entity file <u(filename)>",
      filename = entity_filename
    }))
    return
  end
  DelayedLoadEntity(self.mod, self.entity_name, entity_filename)
end
function ModItemDecalEntity:TestModItem(ged)
  self:OnModLoad()
  WaitDelayedLoadEntities()
  Msg("BinAssetsLoaded")
  if GetMap() == "" then
    ModLog(T(495557523821, "Entity testing only possible when a map is loaded"))
    return
  end
  local obj = PlaceObject("Shapeshifter")
  obj:ChangeEntity(self.entity_name)
  obj:SetPos(GetTerrainCursorXY(UIL.GetScreenSize() / 2))
  if IsEditorActive() then
    EditorViewMapObject(obj, nil, true)
  else
    ViewObject(obj)
  end
end
function ModItemDecalEntity:OnEditorDelete(mod, ged)
  local entity_root = self.mod.content_path .. "Entities/"
  DeleteEntity(entity_root, self.entity_name)
end
DefineClass.ModItemGameValue = {
  __parents = {"ModItem"},
  properties = {
    {id = "name", editor = false},
    {
      category = "GameValue",
      id = "category",
      name = T(353291145516, "Category"),
      default = "Gameplay",
      editor = "choice",
      items = ClassCategoriesCombo("Consts")
    },
    {
      category = "GameValue",
      id = "id",
      name = T(165832210760, "ID"),
      default = "",
      editor = "choice",
      items = ClassPropertiesCombo("Consts", "category", "")
    },
    {
      category = "GameValue",
      id = "const_name",
      name = T(126741858615, "Name"),
      default = "",
      editor = "text",
      read_only = true,
      dont_save = true
    },
    {
      category = "GameValue",
      id = "help",
      name = T(890209736860, "Help"),
      default = "",
      editor = "text",
      read_only = true,
      dont_save = true
    },
    {
      category = "GameValue",
      id = "default_value",
      name = T(273290015249, "Default value"),
      default = 0,
      editor = "number",
      read_only = true,
      dont_save = true
    },
    {
      category = "GameValue",
      id = "percent",
      name = T(106180345295, "Percent"),
      default = 0,
      editor = "number"
    },
    {
      category = "GameValue",
      id = "amount",
      name = T(163179391605, "Amount"),
      default = 0,
      editor = "number"
    },
    {
      category = "GameValue",
      id = "modified_value",
      name = T(887163766960, "Modified value"),
      default = 0,
      editor = "number",
      read_only = true,
      dont_save = true
    }
  },
  EditorName = "Game value",
  EditorSubmenu = "Gameplay"
}
function ModItemGameValue:Getconst_name()
  local metadata = Consts:GetPropertyMetadata(self.id)
  return _InternalTranslate(metadata and metadata.name or "")
end
function ModItemGameValue:OnEditorSetProperty(prop_id, old_value, ged)
  if prop_id == "category" then
    self.id = ""
  end
  ModItem.OnEditorSetProperty(self, prop_id, old_value, ged)
end
function ModItemGameValue:GetProperties()
  local properties = {}
  for _, prop_meta in ipairs(self.properties) do
    local prop_id = prop_meta.id
    if prop_id == "default_value" or prop_id == "amount" or prop_id == "modified_value" then
      local const_meta = Consts:GetPropertyMetadata(self.id)
      if const_meta then
        prop_meta = table.copy(prop_meta)
        prop_meta.scale = const_meta.scale
      end
    end
    properties[#properties + 1] = prop_meta
  end
  return properties
end
function ModItemGameValue:Gethelp()
  local metadata = Consts:GetPropertyMetadata(self.id)
  return _InternalTranslate(metadata and metadata.help or "")
end
function ModItemGameValue:Getdefault_value()
  return Consts:GetDefaultPropertyValue(self.id) or 0
end
function ModItemGameValue:Getmodified_value()
  local default_value = Consts:GetDefaultPropertyValue(self.id) or 0
  return MulDivRound(default_value, self.percent + 100, 100) + self.amount
end
function ModItemGameValue:ResetProperties()
  self.id = self:GetDefaultPropertyValue("id")
  self.const_name = self:GetDefaultPropertyValue("const_name")
  self.help = self:GetDefaultPropertyValue("help")
  self.default_value = self:GetDefaultPropertyValue("default_value")
  self.modified_value = self:GetDefaultPropertyValue("modified_value")
end
function ModItemGameValue:GetModItemDescription()
  if self.id == "" then
    return ""
  end
  local pct = self.percent ~= 0 and string.format(" %+d%%", self.percent) or ""
  local const_meta = Consts:GetPropertyMetadata(self.id)
  local prefix = 0 < self.amount and "+" or ""
  local amount = self.amount ~= 0 and prefix .. FormatNumberProp(self.amount, const_meta.scale) or ""
  return Untranslated(string.format("%s.%s %s %s", self.category, self.id, pct, amount))
end
function GenerateGameValueDoc()
  if not g_Classes.Consts then
    return
  end
  local output = {}
  local categories = ClassCategoriesCombo("Consts")()
  local out = function(...)
    output[#output + 1] = string.format(...)
  end
  local props = Consts:GetProperties()
  for _, category in ipairs(categories) do
    out("## %s", category)
    for _, prop in ipairs(props) do
      if prop.category == category then
        out([[
%s
:	*g_Consts.%s*<br>
	%s
]], _InternalTranslate(prop.name), prop.id, _InternalTranslate(prop.help or prop.name))
      end
    end
  end
  local err, suffix = AsyncFileToString("svnProject/Docs/ModTools/empty.md.html")
  if err then
    return err
  end
  output[#output + 1] = suffix
  AsyncStringToFile("svnProject/Docs/ModTools/ModItemGameValue_list.md.html", table.concat(output, "\n"))
end
function GenerateObjectDocs(base_class)
  local list = ClassDescendantsList(base_class)
  local output = {
    string.format("# Documentation for *%s objects*\n", base_class)
  }
  local base_props = g_Classes[base_class]:GetProperties()
  local hidden_dlc_list = {}
  ForEachPreset("DLCConfig", function(p)
    if not p.public then
      hidden_dlc_list[p.id] = true
    end
  end)
  local hidden_classdef_list = {}
  ForEachPreset(base_class .. "Def", function(p)
    local save_in = p:HasMember("save_in") and p.save_in or nil
    if save_in and hidden_dlc_list[save_in] then
      hidden_classdef_list[p.id] = p.save_in
    end
  end)
  for _, name in ipairs(list) do
    local class = g_Classes[name]
    if class:HasMember("Documentation") and not hidden_classdef_list[name] then
      output[#output + 1] = string.format("## %s\n", name)
      output[#output + 1] = class.Documentation
      for _, prop in ipairs(class:GetProperties()) do
        if not table.find(base_props, "id", prop.id) and prop.help and prop.help ~= "" then
          output[#output + 1] = string.format([[
%s
: %s
]], prop.name or prop.id, prop.help)
        else
        end
      end
    else
    end
  end
  OutputDocsFile(string.format("Lua%sDoc.md.html", base_class), output)
end
function OnMsg.PresetSave(class)
  if class == "ClassDef" then
    GenerateObjectDocs("Effect")
    GenerateObjectDocs("Condition")
  elseif class == "ConstDef" then
    GenerateGameValueDoc()
  end
end
local GetAllLanguages = function()
  local languages = table.copy(AllLanguages, "deep")
  table.insert(languages, 1, {
    value = "Any",
    text = T(237451197262, "Any"),
    iso_639_1 = "en"
  })
  return languages
end
DefineClass.ModItemLocTable = {
  __parents = {"ModItem"},
  properties = {
    {id = "name", editor = false},
    {
      category = "Mod",
      id = "language",
      name = T(243042020683, "Language"),
      default = "",
      editor = "dropdownlist",
      items = GetAllLanguages()
    },
    {
      category = "Mod",
      id = "filename",
      name = T(267679979446, "Filename"),
      editor = "browse",
      filter = "Comma separated values (*.csv)|*.csv",
      folder = function(obj)
        return obj.mod.content_path
      end,
      default = "",
      os_path = true
    }
  },
  EditorName = "Localization",
  EditorSubmenu = "Assets",
  ModItemDescription = T(677060079613, "<u(language)>")
}
function ModItemLocTable:OnModLoad()
  ModItem.OnModLoad(self)
  if (self.language == GetLanguage() or self.language == "Any") and io.exists(self.filename) then
    LoadTranslationTableFile(self.filename)
    Msg("TranslationChanged")
  end
end
function ModItemLocTable:TestModItem()
  if io.exists(self.filename) then
    LoadTranslationTableFile(self.filename)
    Msg("TranslationChanged")
  end
end
DefineModItemPreset("XTemplate", {
  GetSaveFolder = function()
  end,
  EditorName = "XTemplate"
})
function ModItemXTemplate:TestModItem(ged)
  GedOpPreviewXTemplate(ged, self, false)
end
function ModItemXTemplate:GetSaveFolder(...)
  return ModItemPreset.GetSaveFolder(self, ...)
end
function ModItemXTemplate:GetSavePath(...)
  return ModItemPreset.GetSavePath(self, ...)
end
DefineModItemPreset("SoundPreset", {EditorName = "Sound", EditorSubmenu = "Assets"})
function ModItemSoundPreset:OnEditorNew(...)
  SoundPreset.OnEditorNew(self, ...)
  ModItemPreset.OnEditorNew(self, ...)
end
function ModItemSoundPreset:OverrideSampleFuncs(sample)
  function sample.GetFolder()
    return {
      {
        self:GetModContentPath(),
        os_path = true
      }
    }
  end
  function sample.GetFileExt()
    return "opus"
  end
end
function ModItemSoundPreset:OnModLoad()
  for _, sample in ipairs(self or empty_table) do
    if IsKindOf(sample, "Sample") then
      self:OverrideSampleFuncs(sample)
    end
  end
  ModItemPreset.OnModLoad(self)
  LoadSoundBank(self)
end
function ModItemSoundPreset:TestModItem(ged)
  LoadSoundBank(self)
  GedPlaySoundPreset(ged)
end
function ModItemSoundPreset:GenerateUniquePresetId()
  return SoundPreset.GenerateUniquePresetId(self, "Sound")
end
local GenerateUniqueActionFXHandle = function(mod_item)
  local mod_id = mod_item.mod.id
  local index = table.find(mod_item.mod.items, mod_item)
  while true do
    local handle = string.format("%s_%d", mod_id, index)
    local any_collisions
    for i, other_item in ipairs(mod_item.mod.items) do
      if other_item ~= mod_item and IsKindOf(other_item, "ActionFX") and other_item.handle == handle then
        any_collisions = true
        break
      end
    end
    if not any_collisions then
      return handle
    else
      index = index + 1
    end
  end
end
local DefineModItemActionFX = function(preset, editor_name)
  local actionfx_mod_class = DefineModItemPreset(preset, {
    EditorName = editor_name,
    EditorSubmenu = "ActionFX",
    EditorShortcut = false
  })
  function actionfx_mod_class:OnEditorNew(...)
    g_Classes[self.ModdedPresetClass].OnEditorNew(self, ...)
    return ModItemPreset.OnEditorNew(self, ...)
  end
  function actionfx_mod_class:SetId(id)
    self.handle = id
    return Preset.SetId(self, id)
  end
  function actionfx_mod_class:GetSavePath(...)
    return ModItemPreset.GetSavePath(self, ...)
  end
  function actionfx_mod_class:delete()
    return g_Classes[self.ModdedPresetClass].delete(self)
  end
  function actionfx_mod_class:TestModItem(ged)
    PlayFX(self.Action, self.Moment, SelectedObj, SelectedObj)
  end
  function actionfx_mod_class:PreSave()
    if not self.handle and self.mod then
      if self.id == "" then
        self:SetId(self.mod:GenerateModItemId(self))
      end
      self.handle = self.id
    end
    return ModItemPreset.PreSave(self)
  end
  local properties = actionfx_mod_class.properties or {}
  table.iappend(properties, {
    {
      id = "__copy_group"
    },
    {id = "__copy"}
  })
end
DefineModItemActionFX("ActionFXSound", "Sound")
DefineModItemActionFX("ActionFXObject", "Object")
DefineModItemActionFX("ActionFXDecal", "Decal")
DefineModItemActionFX("ActionFXLight", "Light")
DefineModItemActionFX("ActionFXColorization", "Colorization")
DefineModItemActionFX("ActionFXParticles", "Particles")
DefineModItemActionFX("ActionFXRemove", "Remove")
function OnMsg.ModsReloaded()
  RebuildFXRules()
end
DefineClass.ModItemParticleTexture = {
  __parents = {"ModItem"},
  EditorName = "Particle texture",
  properties = {
    {
      category = "Texture",
      id = "filename",
      name = T(405727639773, "Image"),
      editor = "browse",
      os_path = true,
      filter = "Image files|*.png;*.tga",
      default = "",
      buttons = {
        {name = "Import", func = "Import"}
      }
    }
  }
}
function ModItemParticleTexture:Import(root, prop_id, ged_socket)
  GedSetUiStatus("mod_import_particle_texture", "Importing...")
  local output_dir = ConvertToOSPath(self.mod.content_path)
  local w, h = UIL.MeasureImage(self.filename)
  if w ~= h then
    ged_socket:ShowMessage(T(957540628844, "Failed importing texture"), T(986754301876, "The import failed because the image width and height are wrong. Image must be a square and pixel width and height must be power of two (e.g. 1024, 2048, 4096, etc.)."))
    GedSetUiStatus("mod_import_particle_texture")
    return
  end
  if w <= 0 or band(w, w - 1) ~= 0 then
    ged_socket:ShowMessage(T(957540628844, "Failed importing texture"), T(986754301876, "The import failed because the image width and height are wrong. Image must be a square and pixel width and height must be power of two (e.g. 1024, 2048, 4096, etc.)."))
    GedSetUiStatus("mod_import_particle_texture")
    return
  end
  local dir, name, ext = SplitPath(self.filename)
  local texture_name = name .. ".dds"
  local texture_dir = output_dir .. "Textures/Particles/"
  local texture_output = texture_dir .. texture_name
  local fallback_dir = texture_dir .. "Fallbacks/"
  local fallback_output = fallback_dir .. texture_name
  local err = AsyncCreatePath(texture_dir)
  if err then
    ged_socket:ShowMessage(T(957540628844, "Failed importing texture"), T({
      867697035195,
      "Failed creating <u(dir)> directory: <u(err)>.",
      dir = "Textures",
      err = err
    }))
    GedSetUiStatus("mod_import_particle_texture")
    return
  end
  err = AsyncCreatePath(fallback_dir)
  if err then
    ged_socket:ShowMessage(T(957540628844, "Failed importing texture"), T({
      867697035195,
      "Failed creating <u(dir)> directory: <u(err)>.",
      dir = "Fallbacks",
      err = err
    }))
    GedSetUiStatus("mod_import_particle_texture")
    return
  end
  local cmdline = string.format("\"%s\" -dds10 -24 bc1 -32 bc3 -srgb \"%s\" \"%s\"", ConvertToOSPath(g_HgnvCompressPath), self.filename, texture_output)
  local err, out = AsyncExec(cmdline, "", true, false)
  if err then
    ged_socket:ShowMessage(T(957540628844, "Failed importing texture"), T({
      870555284339,
      "Failed creating compressed image: <u(err)>.",
      err = err
    }))
    GedSetUiStatus("mod_import_particle_texture")
    return
  end
  cmdline = string.format("\"%s\" \"%s\" \"%s\" --truncate %d", ConvertToOSPath(g_HgimgcvtPath), texture_output, fallback_output, const.FallbackSize)
  err = AsyncExec(cmdline, "", true, false)
  if err then
    ged_socket:ShowMessage(T(957540628844, "Failed importing texture"), T({
      760561283947,
      "Failed creating fallback image: <u(err)>.",
      err = err
    }))
    GedSetUiStatus("mod_import_particle_texture")
    return
  end
  self:OnModLoad()
  GedSetUiStatus("mod_import_particle_texture")
  ged_socket:ShowMessage(T(898871916829, "Success"), T(520038498276, "Texture imported successfully!"))
end
DefineModItemPreset("ParticleSystemPreset", {
  properties = {
    {
      id = "ui",
      name = "UI Particle System",
      editor = "bool",
      default = false,
      no_edit = true
    },
    {
      id = "saving",
      editor = "bool",
      default = false,
      dont_save = true,
      no_edit = true
    }
  },
  EditorName = "Particle system"
})
function ModItemParticleSystemPreset:GetTextureFolders()
  return {
    {
      self:GetModRootPath()
    }
  }
end
function ModItemParticleSystemPreset:GetTextureBasePath()
  return ""
end
function ModItemParticleSystemPreset:GetTextureTargetPath()
  return ""
end
function ModItemParticleSystemPreset:GetTextureTargetGamePath()
  return ""
end
function ModItemParticleSystemPreset:OnEditorNew(...)
  ParticleSystemPreset.OnEditorNew(self, ...)
  ModItemPreset.OnEditorNew(self, ...)
end
function ModItemParticleSystemPreset:OnEditorSelect(...)
  ParticleSystemPreset.OnEditorSelect(self, ...)
end
function ModItemParticleSystemPreset:IsDirty()
  return ModItemPreset.IsDirty(self)
end
function ModItemParticleSystemPreset:PreSave()
  self.saving = true
  ModItem.PreSave(self)
end
function ModItemParticleSystemPreset:PostSave()
  self.saving = false
  ModItem.PostSave(self)
  ParticlesReload(self:GetId())
end
function ModItemParticleSystemPreset:PostLoad()
  ParticleSystemPreset.PostLoad(self)
  ParticlesReload(self:GetId())
end
function ModItemParticleSystemPreset:OverrideEmitterFuncs(emitter)
  function emitter.GetTextureFolders()
    return {
      {
        self:GetModContentPath(),
        os_path = false
      },
      {
        "Textures/Particles/",
        game_path = true
      }
    }
  end
  function emitter.GetTextureFilter()
    return "Texture (*.dds)|*.dds"
  end
  function emitter.GetNormalmapFilter()
    return "Texture (*.dds)|*.dds"
  end
  function emitter.ShouldNormalizeTexturePath()
    return not self.saving
  end
end
function ModItemParticleSystemPreset:OnModLoad()
  self.saving = nil
  for _, child in ipairs(self) do
    if IsKindOf(child, "ParticleEmitter") then
      self:OverrideEmitterFuncs(child)
    end
  end
  ModItemPreset.OnModLoad(self)
  local fallbacks_path = self.mod.content_path .. "Textures/Particles/Fallbacks/"
  if io.exists(fallbacks_path) then
    DelayedLoadTextureFallbacks(fallbacks_path)
  end
end
function ModItemParticleSystemPreset:Getname()
  return ModItemPreset.Getname(self)
end
function ModItemParticleSystemPreset:EditorItemsMenu()
  local items = Preset.EditorItemsMenu(self)
  local idx = table.find(items, 1, "ParticleParam")
  if idx then
    table.remove(items, idx)
  end
  return items
end
DefineModItemPreset("ConstDef", {
  EditorName = "Constant",
  EditorSubmenu = "Gameplay",
  lua_reload = true
})
ModItemConstDef.GetSavePath = ModItemPreset.GetSavePath
ModItemConstDef.GetSaveData = ModItemPreset.GetSaveData
function ModItemConstDef:AssignToConsts()
  local self_group = self.group or "Default"
  local const_group = self_group == "Default" and const or const[self_group]
  if not const_group then
    const_group = {}
    const[self_group] = const_group
  end
  local value = self.value
  if value == nil then
    value = ConstDef:GetDefaultValueOf(self.type)
  end
  local id = self.id or ""
  if id == "" then
    const_group[#const_group + 1] = value
  else
    const_group[id] = value
  end
end
function ModItemConstDef:PostSave()
  self:AssignToConsts()
  return ModItemPreset.PostSave(self)
end
function ModItemConstDef:OnModLoad()
  ModItemPreset.OnModLoad(self)
  self:AssignToConsts()
end
