DefineClass.Preset = {
  __parents = {
    "GedEditedObject",
    "Container",
    "InitDone"
  },
  properties = {
    {
      category = "Preset",
      id = "Group",
      editor = "combo",
      default = "Default",
      items = function(obj)
        local group_class = g_Classes[obj.PresetGroupPreset]
        if group_class then
          return PresetsCombo(group_class.PresetClass or group_class.class)()
        else
          return PresetGroupsCombo(obj.PresetClass or obj.class)()
        end
      end,
      validate = function(self, value, ged)
        local groups = Presets[self.PresetClass or self.class]
        local presets = groups and groups[value]
        if presets and presets[self.id] and presets[self.id].save_in == self.save_in then
          return "A preset with the same id exists in the target group."
        end
        local group_class = g_Classes[self.PresetGroupPreset]
        if group_class then
          local map = _G[group_class.GlobalMap]
          if not map or not map[value] then
            return "Preset group doesn't exist."
          end
        elseif value == "" then
          return "Preset group can't be empty."
        end
      end,
      no_edit = function(obj)
        return not obj.HasGroups
      end
    },
    {
      category = "Preset",
      id = "SaveIn",
      name = "Save in",
      editor = "choice",
      default = "",
      items = function(obj)
        return obj:GetPresetSaveLocations()
      end
    },
    {
      category = "Preset",
      id = "Id",
      editor = "text",
      default = "",
      validate = function(self, value)
        if type(value) ~= "string" or not value:match(self.PresetIdRegex) then
          return "Id must be a valid identifier (starts with a letter, contains letters/numbers/_ only)."
        end
        local groups = Presets[self.PresetClass or self.class]
        local presets = groups and groups[self.group]
        local with_same_id = presets and presets[value]
        if with_same_id and with_same_id ~= self and with_same_id:GetSaveFolder() == self:GetSaveFolder() then
          return "A preset with this Id already exists in this group (for the same save location)."
        end
        with_same_id = self.GlobalMap and _G[self.GlobalMap][value]
        if with_same_id and with_same_id ~= self and with_same_id:GetSaveFolder() == self:GetSaveFolder() then
          return "A preset with this Id already exists."
        end
      end
    },
    {
      category = "Preset",
      id = "SortKey",
      name = "Sort key",
      editor = "number",
      default = 0,
      no_edit = function(obj)
        return not obj.HasSortKey
      end,
      dont_save = function(obj)
        return not obj.HasSortKey
      end,
      help = "An arbitrary number used to sort items in ascending order"
    },
    {
      category = "Preset",
      id = "Parameters",
      name = "Parameters",
      editor = "nested_list",
      base_class = "PresetParam",
      default = false,
      no_edit = function(self)
        return not self.HasParameters
      end,
      help = [[
Create named parameters for numeric values and use them in multiple places.

For example, if an event checks that an amount of money is present, subtracts this exact amount, and displays it in its text, you can create an Amount parameter and reference it in all three places. When you later adjust this amount, you can do it from a single place.

This can prevent omissions and errors when numbers are getting tweaked later.]]
    },
    {
      id = "param_bindings",
      editor = "prop_table",
      default = false,
      no_edit = true,
      inject_in_subobjects = function(self)
        return self.HasParameters
      end
    },
    {
      category = "Preset",
      id = "Comment",
      name = "Comment",
      editor = "text",
      default = "",
      lines = 1,
      max_lines = 10
    },
    {
      category = "Preset",
      id = "TODO",
      name = "To do",
      editor = "set",
      default = false,
      no_edit = function(self)
        return not self.TODOItems
      end,
      dont_save = function(self)
        return not self.TODOItems
      end,
      items = function(self)
        return self.TODOItems
      end
    },
    {
      category = "Preset",
      id = "Obsolete",
      editor = "bool",
      default = false,
      no_edit = function(self)
        return not self.HasObsolete
      end,
      dont_save = function(self)
        return not self.HasObsolete
      end,
      help = "Obsolete presets are kept for backwards compatibility and should not be visible in the game"
    }
  },
  group = "Default",
  id = "",
  save_in = "",
  StoreAsTable = true,
  PropertyTranslation = false,
  PersistAsReference = true,
  UnpersistedPreset = false,
  __hierarchy_cache = true,
  PresetIdRegex = "^[%w_+-]*$",
  HasGroups = true,
  PresetGroupPreset = false,
  HasSortKey = false,
  HasParameters = false,
  HasObsolete = false,
  PresetClass = false,
  FilePerGroup = false,
  SingleFile = true,
  LocalPreset = false,
  GlobalMap = false,
  FilterClass = false,
  SubItemFilterClass = false,
  AltFormat = false,
  HasCompanionFile = false,
  GeneratesClass = false,
  TODOItems = false,
  NoInstances = false,
  GedEditor = "PresetEditor",
  SingleGedEditorInstance = true,
  EditorMenubarName = "",
  EditorMenubarSortKey = "",
  EditorShortcut = false,
  EditorIcon = false,
  EditorMenubar = "Editors",
  EditorName = false,
  EditorView = Untranslated("<EditorViewPresetPrefix><def(id,'[unnamed preset]')><EditorViewPresetPostfix><EditorViewTODO><color 0 128 0><opt(u(Comment),' ','')><color 128 128 128><opt(u(save_in),' - ','')>"),
  EditorViewPresetPrefix = "",
  EditorViewPresetPostfix = "",
  EditorCustomActions = false,
  EnableReloading = true,
  ValidateAfterSave = false
}
if FirstLoad then
  g_PresetParamCache = setmetatable({}, weak_keys_meta)
  g_PresetLastSavePaths = rawget(_G, "g_PresetLastSavePaths") or setmetatable({}, weak_keys_meta)
  g_PresetAllSavePaths = setmetatable({}, weak_keys_meta)
  g_PresetDirtySavePaths = {}
  g_PresetFileTimestampAtSave = {}
  g_PresetCurrentLuaFileSavePath = false
  g_PresetForbidSerialize = false
  g_PresetRefreshingFunctionValues = false
  g_PendingPresetImageAdds = false
  PresetsLoadingFileName = false
end
function Preset:GetEditorView()
  return self.EditorView
end
function Preset:GetPresetRolloverText()
end
function Preset:GetPresetStatusText()
  return ""
end
function Preset:Done()
  local id = self.id
  local groups = Presets[self.PresetClass or self.class]
  local presets = groups[self.group]
  if presets then
    table.remove_entry(presets, self)
    if presets[id] == self then
      presets[id] = nil
      for i = #presets, 1, -1 do
        local preset_i = presets[i]
        if preset_i ~= self and preset_i.id == id then
          presets[id] = preset_i
          break
        end
      end
    end
    if #presets == 0 then
      table.remove_entry(groups, presets)
      groups[self.group] = nil
    end
  end
  local global = rawget(_G, self.GlobalMap)
  if global and global[id] == self then
    global[id] = nil
    for i = #groups, 1, -1 do
      local group_i = groups[i]
      for j = #group_i, 1, -1 do
        local preset_j = group_i[j]
        if preset_j ~= self and preset_j.id == id then
          global[id] = preset_j
          goto lbl_73
        end
      end
    end
  end
  ::lbl_73::
end
function Preset:SetGroup(group)
  if g_PresetRefreshingFunctionValues then
    self.group = group
    return
  end
  group = group ~= "" and group or "Default"
  local id = self.id
  local groups = Presets[self.PresetClass or self.class]
  local presets = groups[self.group]
  if presets then
    table.remove_entry(presets, self)
    if presets[id] == self then
      presets[id] = nil
      for i = #presets, 1, -1 do
        local preset_i = presets[i]
        if preset_i ~= self and preset_i.id == id then
          presets[id] = preset_i
          break
        end
      end
    end
    if #presets == 0 then
      table.remove_entry(groups, presets)
      groups[self.group] = nil
    end
  end
  self.group = group
  presets = groups[group]
  if not presets then
    presets = {}
    groups[group] = presets
    groups[#groups + 1] = presets
  end
  presets[#presets + 1] = self
  if id ~= "" then
    presets[id] = self
  end
  ObjModified(groups)
end
function Preset:GetGroup()
  return self.group
end
function Preset:SetId(id)
  if g_PresetRefreshingFunctionValues then
    self.id = id
    return
  end
  local groups = Presets[self.PresetClass or self.class]
  local old_id = self.id
  local global = rawget(_G, self.GlobalMap)
  if global then
    if global[old_id] == self then
      global[old_id] = nil
      for i = #groups, 1, -1 do
        local group_i = groups[i]
        for j = #group_i, 1, -1 do
          local preset_j = group_i[j]
          if preset_j ~= self and preset_j.id == old_id then
            global[old_id] = preset_j
            goto lbl_42
          end
        end
      end
    end
    ::lbl_42::
    if id ~= "" then
      local existing = global[id]
      if existing and existing ~= self then
        DebugPrint("Overriding global preset " .. id .. " using the one from " .. self.save_in .. "\n")
      end
      global[id] = self
    end
  end
  local presets = groups[self.group]
  if presets then
    if presets[old_id] == self then
      presets[old_id] = nil
      for i = #presets, 1, -1 do
        local preset_i = presets[i]
        if preset_i ~= self and preset_i.id == old_id then
          presets[old_id] = preset_i
          break
        end
      end
    end
  else
    presets = {}
    groups[self.group] = presets
    groups[#groups + 1] = presets
  end
  self.id = id
  if id ~= "" then
    presets[id] = self
  end
end
function Preset:GetId()
  return self.id
end
function Preset:SetSaveIn(save_in)
  self.save_in = save_in ~= "" and save_in or nil
end
function Preset:GetSaveIn()
  return self.save_in
end
function Preset:GetSaveLocationType()
  local save_in = self:GetSaveIn()
  if save_in == "Common" or save_in == "Ged" or save_in:starts_with("Lib") then
    return "common"
  end
  return "game"
end
function GetDefaultSaveLocations()
  local locations = DlcComboItems({text = "Common", value = "Common"})
  ForEachLib(nil, function(lib, path, locations)
    locations[#locations + 1] = {
      text = "lib " .. lib,
      value = "Libs/" .. lib
    }
  end, locations)
  return locations
end
function Preset:GetPresetSaveLocations()
  return GetDefaultSaveLocations()
end
function Preset:PostLoad()
  if self.HasParameters then
    self:ForEachSubObject(function(obj)
      if not obj:IsKindOf("PresetParam") then
        rawset(obj, "param_bindings", rawget(obj, "param_bindings") or false)
      end
    end)
  end
  if #(self.Parameters or empty_table) > 0 then
    local cache = {}
    for _, param in ipairs(self.Parameters) do
      cache[param.Name] = param.Value
    end
    g_PresetParamCache[self] = cache
  end
end
function Preset:ResolveValue(key)
  local value = self:GetProperty(key)
  if not value and g_PresetParamCache[self] then
    return g_PresetParamCache[self][key]
  end
  return value
end
function Preset:Register(id)
  local group = self.group
  local groups = Presets[self.PresetClass or self.class]
  local presets = groups[group]
  if not presets then
    presets = {}
    groups[group] = presets
    groups[#groups + 1] = presets
  end
  presets[#presets + 1] = self
  ParentTableModified(self, presets, "recursive")
  id = id or self.id
  if id ~= "" then
    presets[id] = self
    local global = rawget(_G, self.GlobalMap)
    if global then
      global[id] = self
    end
  end
end
function Preset:GetEditorViewTODO()
  local v
  local todo = self.TODO or empty_table
  for _, item in ipairs(self.TODOItems) do
    if todo[item] then
      if v then
        v[#v + 1] = " "
      else
        v = {
          " <color 255 140 0>["
        }
      end
      v[#v + 1] = item
    end
  end
  if not v then
    return ""
  end
  v[#v + 1] = "]</color>"
  return Untranslated(table.concat(v, ""))
end
function preset_reset_fn_values(preset, reloaded_obj)
  for k, v in pairs(preset) do
    if k ~= "__index" then
      local reloaded_value = reloaded_obj[k]
      if type(v) == "table" and type(reloaded_value) == "table" then
        preset_reset_fn_values(v, reloaded_value)
      elseif type(v) == "function" and type(reloaded_value) == "function" then
        preset[k] = reloaded_value
      end
    end
  end
end
function Preset:FindOriginalPreset()
  local presets = Presets[self.PresetClass or self.class][self.group]
  for _, original_preset in ipairs(presets) do
    if original_preset.id == self.id and original_preset.save_in == self.save_in then
      return original_preset
    end
  end
end
function Preset:RefreshFunctionValues()
  local original_preset = self:FindOriginalPreset()
  if original_preset then
    preset_reset_fn_values(original_preset, self)
    original_preset:MarkClean()
  end
end
local instrument_loading = function(fn_name)
  return function(...)
    local old_fn = dofile
    function dofile(name, fenv)
      PresetsLoadingFileName = name
      old_fn(name, fenv)
      PresetsLoadingFileName = false
    end
    _G[fn_name](...)
    dofile = old_fn
  end
end
LoadPresetFiles = instrument_loading("dofolder_files")
LoadPresetFolders = instrument_loading("dofolder_folders")
LoadPresetFolder = instrument_loading("dofolder")
function LoadPresets(name, fenv)
  PresetsLoadingFileName = name
  pdofile(name, fenv)
  PresetsLoadingFileName = false
end
function Preset:StoreLoadedFromPaths()
  if PresetsLoadingFileName and Platform.developer and not Platform.cmdline and not Platform.console and self.class ~= "DLCPropsPreset" then
    g_PresetLastSavePaths[self] = PresetsLoadingFileName
    local save_paths = self:GetCompanionFilesList(PresetsLoadingFileName)
    if save_paths then
      for key, name in pairs(save_paths) do
      end
      save_paths[false] = g_PresetLastSavePaths[self]
      g_PresetAllSavePaths[self] = save_paths
    end
  end
end
function Preset:__fromluacode(data, arr)
  local obj
  if self.StoreAsTable then
    obj = self:new(data)
    if g_PresetRefreshingFunctionValues then
      obj:RefreshFunctionValues()
      return
    else
      obj:Register()
    end
  else
    obj = self:new(arr)
    if g_PresetRefreshingFunctionValues then
      SetObjPropertyList(obj, data)
      obj:RefreshFunctionValues()
      return
    else
      obj:Register()
      SetObjPropertyList(obj, data)
    end
  end
  obj:StoreLoadedFromPaths()
  return obj
end
function Preset:__toluacode(...)
  return InitDone.__toluacode(self, ...)
end
function Preset:__paste(table, arr)
  local ret
  if self.StoreAsTable then
    ret = self:new(table)
  else
    ret = self:new(arr)
    function ret:SetId(id)
      self.id = id
    end
    function ret:SetGroup(group)
      self.group = group
    end
    SetObjPropertyList(ret, table)
    ret.SetId = nil
    ret.SetGroup = nil
  end
  return ret
end
function Preset:GetSaveFolder(save_in)
  save_in = save_in or self.save_in
  if save_in == "" then
    return "Data"
  end
  if save_in == "Common" then
    return "CommonLua/Data"
  end
  if save_in:starts_with("Libs/") then
    return string.format("CommonLua/%s/Data", save_in)
  end
  return string.format("svnProject/Dlc/%s/Presets", save_in)
end
function NormalizeGamePath(path)
  if not path then
    return
  end
  return path:gsub("%s*[/\\]+[/\\%s]*", "/")
end
local NormalizeSavePath = NormalizeGamePath
function Preset:GetNormalizedSavePath()
  local path = self:GetSavePath()
  if not path or path == "" then
    return false
  end
  return NormalizeSavePath(path)
end
function Preset:GetSavePath(save_in, group)
  group = group or self.group
  local class = self.PresetClass or self.class
  local folder = self:GetSaveFolder(save_in)
  if not folder then
    return
  end
  if self.FilePerGroup then
    if type(self.FilePerGroup) == "string" then
      return string.format("%s/%s/%s-%s.lua", folder, self.FilePerGroup, class, group)
    else
      return string.format("%s/%s-%s.lua", folder, class, group)
    end
  elseif self.SingleFile then
    return string.format("%s/%s.lua", folder, class)
  elseif self.GlobalMap then
    return string.format("%s/%s/%s.lua", folder, class, self.id)
  else
    return string.format("%s/%s/%s-%s.lua", folder, class, group, self.id)
  end
end
function Preset:GetCompanionFileSavePath(path)
  if not path then
    return
  end
  if path:starts_with("Data") then
    path = path:gsub("^Data", "Lua")
  elseif path:starts_with("CommonLua/Data") then
    path = path:gsub("^CommonLua/Data", "CommonLua/Classes")
  elseif path:starts_with("CommonLua/Libs/") then
    path = path:gsub("/Data/", "/Classes/")
  else
    path = path:gsub("^(svnProject/Dlc/[^/]*)/Presets", "%1/Code")
  end
  return path:gsub(".lua$", ".generated.lua")
end
function Preset:GetCompanionFilesList(save_path)
  if self.HasCompanionFile then
    return {
      [true] = self:GetCompanionFileSavePath(save_path)
    }
  end
end
local generated_preset_files_header = [[
-- ========== GENERATED BY <PresetClass> Editor<opt(u(EditorShortcut),' (',')')> DO NOT EDIT MANUALLY! ==========

]]
function Preset:GetCompanionFileHeader(key)
  local titleT = T(generated_preset_files_header, {
    PresetClass = self.class,
    EditorShortcut = self.EditorShortcut
  })
  local header = _InternalTranslate(titleT, nil, false) or exported_files_header_warning
  return pstr(header, 16384)
end
function Preset:GenerateCompanionFileCode(code, key)
end
function Preset:GetError()
  return self:CheckIfIdExistsInGlobal()
end
function Preset:CheckIfIdExistsInGlobal(preset)
  preset = preset or self
  if preset.GeneratesClass then
    local name = rawget(_G, preset.id)
    local class = g_Classes[preset.id]
    if name and name == class then
      local generated_by = class.__generated_by_class
      if preset.save_in == "" and generated_by and generated_by ~= "EntityClass" and generated_by ~= preset.class then
        return string.format("Another preset (%s - %s) has already generated a class with this name!", preset.id, class.__generated_by_class)
      elseif not generated_by then
        return string.format("The class \"%s\" already exists!", preset.id)
      end
    elseif name and name ~= class then
      return string.format("The id \"%s\" is a reserved global name!", preset.id)
    end
  end
end
function Preset:AppendGeneratedByProps(code, preset)
  preset = preset or self
  code:append(string.format([[
	__generated_by_class = "%s",

]], preset.class))
end
function Preset:GenerateCode(code)
  ValueToLuaCode(self, nil, code, {})
  code:append([[


]])
end
function Preset:LocalizationContextBase()
  if self.GlobalMap then
    return string.format("%s %s", self.class, self.id)
  else
    return string.format("%s %s %s", self.class, self.group, self.id)
  end
end
function Preset:GetLastSavePath()
  return g_PresetLastSavePaths[self] or self:GetNormalizedSavePath()
end
local create_name_template_with_id = function(name_template, id)
  return name_template:gsub("%%s", id)
end
local is_template_ui_image_property = function(prop)
  return prop.editor == "ui_image" and prop.placeholder ~= nil and prop.name_template ~= nil
end
local get_template_ext_dest_path = function(ui_image, id)
  local _1, _2, ext = SplitPath(ui_image.placeholder)
  local dest = create_name_template_with_id(ui_image.name_template, id)
  local path = "svnAssets/Source/" .. dest .. ext
  return ext, dest, path
end
function CreateAndSetDefaultUIImage(ui_image, id, object, skipNonDefault)
  local createdProperty = ""
  local ext, dest, osPathDest = get_template_ext_dest_path(ui_image, object.id)
  local osPathOrig = ui_image.placeholder
  if skipNonDefault and object[ui_image.id] ~= nil and object[ui_image.id] ~= dest then
    return createdProperty
  end
  if not io.exists(osPathDest) then
    local err = AsyncCopyFile(osPathOrig, osPathDest)
    if err then
      print("Failed copying placeholder portrait " .. osPathOrig .. " to " .. osPathDest)
      print(err)
      return err
    else
      createdProperty = "Created " .. ui_image.id .. " for " .. object.id .. "!"
      local ok, msg = SVNAddFile(osPathDest)
      if not ok then
        print("Failed to add (" .. osPathDest .. ") to SVN!")
        print(msg)
      end
    end
  end
  object[ui_image.id] = dest
  return createdProperty
end
function Preset:OnEditorNew(parent, ged, is_paste, old_id)
  if Platform.developer and is_paste then
    for id, prop_meta in pairs(self:GetProperties()) do
      if is_template_ui_image_property(prop_meta) then
        local isDefault = hasDefaultUIImage(prop_meta, self, old_id)
        if isDefault then
          self[prop_meta.id] = create_name_template_with_id(prop_meta.name_template, self.id)
        end
      end
    end
  end
end
RecursiveCallMethods.OnPreSave = "call"
function Preset:OnPreSave(by_user_request, ged)
  if not Platform.developer or not by_user_request then
    return
  end
  g_PendingPresetImageAdds = g_PendingPresetImageAdds or {}
  for id, prop_meta in pairs(self:GetProperties()) do
    if is_template_ui_image_property(prop_meta) then
      local property = CreateAndSetDefaultUIImage(prop_meta, self.id, self, false)
      if property and property ~= "" then
        table.insert(g_PendingPresetImageAdds, property)
      end
    end
  end
  if next(g_PendingPresetImageAdds) == nil then
    g_PendingPresetImageAdds = false
  end
end
RecursiveCallMethods.OnPostSave = "call"
function Preset:OnPostSave(by_user_request, ged)
end
function Preset:GetAllFileSavePaths(main_path)
  main_path = main_path or self:GetSavePath()
  local paths = self:GetCompanionFilesList(main_path) or {}
  paths[false] = main_path
  return paths
end
function OnMsg.OnFunctionSerialized(pstr, func)
end
function Preset:ShouldCleanPropForSave(id, prop_meta, value)
  local dlc = prop_meta.dlc
  return g_PresetCurrentLuaFileSavePath and dlc and dlc ~= self.save_in or PropertyObject.ShouldCleanPropForSave(self, id, prop_meta, value)
end
function Preset:GetPropertyForSave(id, prop_meta)
  local dlc = prop_meta.dlc
  if not (g_PresetCurrentLuaFileSavePath and dlc) or dlc == self.save_in then
    return self:GetProperty(id)
  end
end
function Preset:GetSaveData(file_path, preset_list, code_pstr)
  local code = code_pstr or self:GetCompanionFileHeader()
  for _, preset in ipairs(preset_list) do
    preset:GenerateCode(code)
  end
  return code
end
function Preset:GetAllFilesSaveData(file_path, preset_list)
  for _, preset in ipairs(preset_list) do
    g_PresetLastSavePaths[preset] = file_path
    local save_paths = preset:GetCompanionFilesList(file_path)
    if save_paths then
      save_paths[false] = file_path
      g_PresetAllSavePaths[preset] = save_paths
    end
  end
  local file_data = preset_list[1]:GetAllFileSavePaths(file_path)
  for key, path in pairs(file_data) do
    file_data[key] = {
      file_path = path,
      code = self:GetCompanionFileHeader(key)
    }
  end
  g_PresetCurrentLuaFileSavePath = "@" .. file_path
  file_data[false].code = self:GetSaveData(file_path, preset_list, file_data[false].code)
  g_PresetCurrentLuaFileSavePath = false
  for _, preset in ipairs(preset_list) do
    for key, data in pairs(file_data) do
      if key then
        preset:GenerateCompanionFileCode(data.code, key)
      end
    end
  end
  return file_data
end
function Preset:HandleRenameDuringSave(save_path, path_to_preset_list)
  local preset_list = path_to_preset_list[save_path]
  if #preset_list ~= 1 or self.SingleFile or self.FilePerGroup then
    return
  end
  local preset = preset_list[1]
  local last_save_path = g_PresetLastSavePaths[preset]
  if not last_save_path or last_save_path == save_path then
    return
  end
  local last_save_presets = path_to_preset_list[last_save_path]
  if not last_save_presets then
    return
  end
  local old_paths = g_PresetAllSavePaths[preset] or {
    [false] = g_PresetLastSavePaths[preset]
  }
  local new_paths = preset:GetAllFileSavePaths(save_path)
  for key, path in pairs(old_paths) do
    local ok, msg = SVNMoveFile(path, new_paths[key])
    if not ok then
      printf("Failed to move file %s to %s. %s", path, new_paths[key], tostring(msg))
    end
  end
end
local function PreloadFunctionsSourceCodes(obj, display_msg)
  if IsKindOf(obj, "PropertyObject") then
    for _, prop in ipairs(obj:GetProperties()) do
      if prop.editor == "func" or prop.editor == "expression" then
        local func = obj:GetProperty(prop.id)
        if func and not obj:IsDefaultPropertyValue(prop.id, prop, func) then
          local name, params, body = GetFuncSource(func)
          if display_msg then
            print("Fetching source code of Lua functions saved in presets...")
            display_msg = false
          end
        end
      elseif prop.editor == "nested_obj" then
        local obj = obj:GetProperty(prop.id)
        if obj then
          display_msg = PreloadFunctionsSourceCodes(obj, display_msg) and display_msg
        end
      elseif prop.editor == "nested_list" then
        for _, obj in ipairs(obj:GetProperty(prop.id) or empty_table) do
          display_msg = PreloadFunctionsSourceCodes(obj, display_msg) and display_msg
        end
      end
    end
    for _, child in ipairs(obj) do
      display_msg = PreloadFunctionsSourceCodes(child, display_msg) and display_msg
    end
  end
  return display_msg
end
function Preset:SaveFiles(file_map, by_user_request, ged)
  SuspendFileSystemChanged("SaveFiles")
  table.clear(g_PresetDirtySavePaths)
  local path_to_preset_list = table.map(file_map, function(value)
    return {}
  end)
  local class = self.PresetClass or self.class
  ForEachPresetExtended(class, function(preset, group)
    local editor_data = preset:EditorData()
    local path = editor_data.save_path or preset:GetNormalizedSavePath()
    local preset_list = path_to_preset_list[path]
    if preset_list then
      local class_exists_err = self:CheckIfIdExistsInGlobal(preset)
      if class_exists_err then
        printf(class_exists_err)
      else
        table.insert(preset_list, preset)
      end
    end
  end)
  local display_msg = true
  for path, preset_list in pairs(path_to_preset_list) do
    for _, preset in ipairs(preset_list) do
      Msg("OnPreSavePreset", preset, by_user_request, ged)
      procall(preset.OnPreSave, preset, by_user_request, ged)
      display_msg = PreloadFunctionsSourceCodes(preset, display_msg)
    end
  end
  local to_delete = {}
  for path, preset_list in sorted_pairs(path_to_preset_list) do
    self:HandleRenameDuringSave(path, path_to_preset_list)
    ContextCache = {}
    if 0 < #preset_list then
      printf("Saving %s...", path)
      local file_data = self:GetAllFilesSaveData(path, preset_list)
      local errors
      for key, data in pairs(file_data) do
        local err = SaveSVNFile(data.file_path, data.code, self.LocalPreset)
        if err then
          errors = true
          printf("Failed to save %s... %s", data.file_path, err)
        end
      end
      if not errors then
        if Platform.developer and by_user_request and not self:IsKindOfClasses("MapDataPreset", "ConstDef") then
          g_PresetRefreshingFunctionValues = true
          dofile(path)
          g_PresetRefreshingFunctionValues = false
        end
        for _, preset in ipairs(preset_list) do
          preset:MarkClean()
        end
        local ferr, timestamp = AsyncGetFileAttribute(path, "timestamp")
        if ferr then
          print("Failed to get timestamp for", path)
        else
          g_PresetFileTimestampAtSave[path] = timestamp
        end
      end
    else
      local paths = self:GetAllFileSavePaths(path)
      for key, path in pairs(paths) do
        table.insert(to_delete, path)
      end
    end
  end
  local saved_presets = {}
  for path, preset_list in pairs(path_to_preset_list) do
    for _, preset in ipairs(preset_list) do
      Msg("OnPostSavePreset", preset, by_user_request, ged)
      procall(preset.OnPostSave, preset, by_user_request, ged)
      saved_presets[preset] = path
    end
  end
  local res, err = SVNDeleteFile(to_delete)
  ResumeFileSystemChanged("SaveFiles")
  InvalidateGetFuncSourceCache()
  return saved_presets
end
function Preset:Save(by_user_request, ged)
  local dirty_paths = {}
  dirty_paths[self:GetNormalizedSavePath()] = true
  dirty_paths[self:GetLastSavePath()] = true
  self:SortPresets()
  self:SaveFiles(dirty_paths, by_user_request, ged)
  if by_user_request then
    self:OnDataSaved()
    self:OnDataUpdated()
    Msg("PresetSave", self.class, false, by_user_request, ged)
  end
end
function Preset:SaveAllCollectAndRun(force_save_all, by_user_request)
  PauseInfiniteLoopDetection("Preset:SaveAllCollectAndRun")
  local dirty_paths = {}
  local class = self.PresetClass or self.class
  ForEachPresetExtended(class, function(preset, group)
    local path = preset:GetNormalizedSavePath()
    if path and (force_save_all or preset:IsDirty()) then
      preset:EditorData().save_path = path
      dirty_paths[path] = true
      dirty_paths[g_PresetLastSavePaths[preset] or path] = true
    end
  end)
  for path, preset_class in pairs(g_PresetDirtySavePaths) do
    if preset_class == class then
      dirty_paths[path] = true
    end
  end
  local saved_presets = self:SaveFiles(dirty_paths, by_user_request)
  ResumeInfiniteLoopDetection("Preset:SaveAllCollectAndRun")
  return saved_presets
end
function Preset:SaveAll(force_save_all, by_user_request, ged)
  local class = self.PresetClass or self.class
  ReloadingDisabled["saveall_" .. class] = "wait"
  local start_time = GetPreciseTicks()
  self:SortPresets()
  ForEachPresetExtended(self, CreateDLCPresetsForSaving)
  local saved_presets = self:SaveAllCollectAndRun(force_save_all, by_user_request)
  CleanupDLCPresetsForSaving()
  self:OnDataSaved()
  self:OnDataUpdated()
  Msg("PresetSave", class, force_save_all, by_user_request, ged)
  printf("%s presets saved in %d ms", class, GetPreciseTicks() - start_time)
  ReloadingDisabled["saveall_" .. class] = false
  if by_user_request and Platform.developer and g_PendingPresetImageAdds then
    table.insert(g_PendingPresetImageAdds, [[

Don't forget to commit the assets folder!]])
    ged:ShowMessage("Placeholder images were created!", table.concat(g_PendingPresetImageAdds, "\n"))
    g_PendingPresetImageAdds = false
  end
  return saved_presets
end
function Preset:OnEditorDelete(group, ged)
  if not self.SingleFile and not self.FilePerGroup then
    local fn = self.LocalPreset and AsyncFileDelete or SVNDeleteFile
    for key, path in pairs(self:GetAllFileSavePaths()) do
      fn(path)
    end
    g_PresetLastSavePaths[self] = nil
    g_PresetAllSavePaths[self] = nil
  end
  local path = self:GetLastSavePath()
  if path then
    g_PresetDirtySavePaths[path] = self.PresetClass or self.class
  end
  if Platform.developer then
    for k, prop_meta in pairs(self:GetProperties()) do
      if is_template_ui_image_property(prop_meta) then
        local ext, dest, osPathDest = get_template_ext_dest_path(prop_meta, self.id)
        if self[prop_meta.id] == dest or self[prop_meta.id] == nil and io.exists(osPathDest) then
          local ok, msg = SVNDeleteFile(osPathDest)
          if not ok then
            print("Failed to remove (" .. osPathDest .. ") from SVN!")
            print("SVN MSG: " .. msg)
          end
        end
      end
    end
  end
end
if FirstLoad or ReloadForDlc then
  Presets = rawget(_G, "Presets") or {}
  setmetatable(Presets, {
    __newindex = function(self, key, value)
      rawset(self, key, value)
    end
  })
end
function OnMsg.ClassesBuilt()
  ClassDescendantsList("Preset", function(name, class, Presets)
    local preset_class = class.PresetClass or name
    Presets[preset_class] = Presets[preset_class] or {}
    local map = class.GlobalMap
    if map then
      rawset(_G, map, rawget(_G, map) or {})
    end
  end, Presets)
end
function OnMsg.PersistGatherPermanents(permanents, direction)
  local format = string.format
  for preset_class_name, groups in pairs(Presets) do
    local preset_class = g_Classes[preset_class_name]
    if (direction == "load" or preset_class.PersistAsReference) and preset_class_name ~= "ListItem" then
      if preset_class.GlobalMap then
        for preset_name, preset in pairs(_G[preset_class.GlobalMap]) do
          permanents[format("Preset:%s.%s", preset_class_name, preset_name)] = preset
        end
      end
      if not preset_class.GlobalMap or direction == "load" then
        for group_name, group in pairs(groups or empty_table) do
          if type(group_name) == "string" then
            for preset_name, preset in pairs(group or empty_table) do
              if type(preset_name) == "string" then
                permanents[format("Preset:%s.%s.%s", preset_class_name, group_name, preset_name)] = preset
              end
            end
          end
        end
      end
    end
  end
  permanents["Preset:UnpersistedMissingPreset.MissingPreset"] = UnpersistedMissingPreset:new({
    id = "MissingPreset"
  })
end
Preset.persist_baseclass = "Preset"
function Preset:UnpersistMissingClass(id, permanents)
  local dot = id:find(".", 9, true)
  local preset_class = g_Classes[id:sub(8, dot and dot - 1)]
  return preset_class and preset_class:UnpersistMissingPreset(id, permanents) or permanents["Preset:UnpersistedMissingPreset.MissingPreset"]
end
function Preset:UnpersistMissingPreset(id, permanents)
  if self.GlobalMap and self.UnpersistedPreset then
    local preset = table.get(_G, self.GlobalMap, self.UnpersistedPreset)
    if preset then
      return preset
    end
  end
  local preset_class_name = self.PresetClass or self.class
  for group, presets in sorted_pairs(Presets[preset_class_name]) do
    local preset = presets[1]
    if preset then
      return preset
    end
  end
end
DefineClass.UnpersistedMissingPreset = {
  __parents = {"Preset"},
  GedEditor = false
}
function Preset:OnDataSaved()
end
function Preset:OnDataReloaded()
end
function Preset:OnDataUpdated()
end
function OnMsg.DataLoaded()
  local g_Classes = g_Classes
  for class_name in pairs(Presets) do
    local class = g_Classes[class_name]
    if class then
      class:OnDataUpdated()
    end
  end
end
function PresetGetPath(target)
  if not target then
    return
  end
  local groups = Presets[target.PresetClass or target.class]
  local group = groups[target.group]
  local group_index = table.find(groups, group)
  local preset_index = table.find(group, target)
  return {group_index, preset_index}
end
function hasDefaultUIImage(ui_image, obj, oldId)
  local currentImage = obj[ui_image.id]
  local defaultImage = create_name_template_with_id(ui_image.name_template, oldId)
  return currentImage == defaultImage
end
function Preset:OnEditorSetProperty(prop_id, old_value, ged)
  local oldId = prop_id == "Id" and old_value or self.id
  local newId = self.id
  local prop_meta = self:GetPropertyMetadata(prop_id)
  if prop_id == prop_meta.id and is_template_ui_image_property(prop_meta) then
    local ext, dest, osPathDest = get_template_ext_dest_path(prop_meta, self.id)
    local patternFileExists = io.exists(osPathDest)
    if self[prop_id] and (old_value == dest or old_value == nil and patternFileExists) then
      local err = AsyncDeletePath(osPathDest)
      if err then
        print(err)
      else
        local ok, msg = SVNDeleteFile(osPathDest)
        if not ok then
          print("Failed to remove file from SVN!")
        end
      end
    end
  elseif prop_id == "Id" then
    for id, prop_meta in pairs(self:GetProperties()) do
      if is_template_ui_image_property(prop_meta) then
        local ext, prevLocalDest, prevPath = get_template_ext_dest_path(prop_meta, oldId)
        local _, nextLocalDest, nextPath = get_template_ext_dest_path(prop_meta, self.id)
        local currentImage = self[prop_meta.id]
        if hasDefaultUIImage(prop_meta, self, oldId) then
          self[prop_meta.id] = nextLocalDest
          local ok, msg = SVNMoveFile(prevPath, nextPath)
          if not ok then
            printf("Failed to move file %s to %s. %s", prevPath, nextPath, tostring(msg))
          end
        end
      end
    end
  end
  if prop_id == "Id" or prop_id == "SortKey" or prop_id == "Group" then
    self:SortPresets()
  end
end
function Preset:Compare(other)
  if self.HasSortKey then
    local k1, k2 = self.SortKey, other.SortKey
    if k1 ~= k2 then
      return k1 < k2
    end
  end
  local k1, k2 = self.id, other.id
  if k1 ~= k2 then
    return k1 < k2
  end
  return self.save_in < other.save_in
end
function Preset:SortPresets()
  local presets = Presets[self.PresetClass or self.class] or empty_table
  if self.HasSortKey then
    table.sort(presets, function(a, b)
      local k1, k2 = a[1] and a[1].SortKey or 0, b[1] and b[1].SortKey or 0
      if k1 ~= k2 then
        return k1 < k2
      end
      return a[1].group < b[1].group
    end)
  else
    table.sort(presets, function(a, b)
      return a[1].group < b[1].group
    end)
  end
  for _, group in ipairs(presets) do
    table.sort(group, self.Compare)
  end
  ObjModified(presets)
end
preset_print = CreatePrint({
  "preset",
  format = "printf",
  output = DebugPrint
})
function ValidatePresetDataIntegrity(validate_all, game_tests, verbose)
  if DbgAreDlcsMissing() then
    CreateMessageBox(nil, Untranslated("Warning"), Untranslated([[
<red>Presets were validated with DLCs missing.

Invalid errors about missing references may occur.]]))
  end
  Msg("ValidatingPresets")
  SuspendThreadDebugHook("PresetIntegrity")
  NetPauseUpdateHash("PresetIntegrity")
  for _, presets in pairs(Presets) do
    PopulateParentTableCache(presets)
  end
  local validation_start = GetPreciseTicks()
  local property_errors = {}
  for class, presets in pairs(Presets) do
    local preset_class = _G[class]
    if preset_class.ValidateAfterSave or validate_all then
      for _, group in ipairs(presets) do
        for _, preset in ipairs(group) do
          local warning = GetDiagnosticMessage(preset, verbose, verbose and "\t")
          if warning then
            table.insert(property_errors, {
              preset,
              warning[1],
              warning[2]
            })
          end
        end
      end
    end
  end
  preset_print("Preset validation took %i ms.", GetPreciseTicks() - validation_start)
  NetResumeUpdateHash("PresetIntegrity")
  ResumeThreadDebugHook("PresetIntegrity")
  Msg("ValidatingPresetsDone")
  if 0 < #property_errors then
    local indent = verbose and [[

	]] or " "
    for _, err in ipairs(property_errors) do
      local preset = err[1]
      local warn_msg = err[2]
      local warn_type = err[3]
      local address = string.format("%s.%s.%s", preset.PresetClass or preset.class, preset.group, preset:GetIdentification())
      if game_tests then
        if warn_type == "error" then
          local assert_msg = string.format([[
[ERROR] %s:%s%s.
	Use Debug->ValidatePresetDataIntegrity from the game menu for more info.]], address, indent, warn_msg)
          GameTestsErrorf(assert_msg)
        else
          local err_msg = string.format("[WARNING] %s:%s%s", address, indent, warn_msg)
          GameTestsPrintf(err_msg)
        end
      else
        local err_msg = string.format("<color %s>[!]</color> %s:%s%s", warn_type == "warning" and RGB(255, 140, 0) or RGB(240, 0, 0), address, indent, warn_msg)
        StoreErrorSource(preset, err_msg)
      end
    end
  end
  return property_errors
end
function OnMsg.PresetSave(class, force_save_all, by_user_request, ged)
  local preset_class = g_Classes[class]
  if Platform.developer and force_save_all ~= "resave_all" and preset_class.ValidateAfterSave then
    ValidatePresetDataIntegrity(false, false)
  end
end
function OnMsg.DataPostprocess()
  local start = GetPreciseTicks()
  for class, presets in pairs(Presets) do
    _G[class]:SortPresets()
    for _, group in ipairs(presets) do
      for _, preset in ipairs(group) do
        preset:PostLoad()
      end
    end
  end
  preset_print("Preset postprocess took %i ms.", GetPreciseTicks() - start)
end
function ForEachPresetExtended(class, func, ...)
  class = g_Classes[class] or class
  class = class.PresetClass or class.class
  for group_index, group in ipairs(Presets[class] or empty_table) do
    for preset_index, preset in ipairs(group) do
      if func(preset, group, ...) == "break" then
        return ...
      end
    end
  end
  return ...
end
function ForEachPreset(class, func, ...)
  class = g_Classes[class] or class
  class = class.PresetClass or class.class
  for group_index, group in ipairs(Presets[class]) do
    for preset_index, preset in ipairs(group) do
      local id = preset.id
      if (id == "" or group[id] == preset) and not preset.Obsolete and func(preset, group, ...) == "break" then
        return ...
      end
    end
  end
  return ...
end
function PresetArray(class, func, ...)
  return ForEachPreset(class, function(preset, group, presets, func, ...)
    if not func or func(preset, group, ...) then
      presets[#presets + 1] = preset
    end
  end, {}, func, ...)
end
function ForEachPresetInGroup(class, group, func, ...)
  if type(class) == "table" then
    class = class.PresetClass or class.class
  end
  group = (Presets[class] or empty_table)[group]
  for preset_index, preset in ipairs(group) do
    if group[preset.id] == preset and not preset.Obsolete and func(preset, group, ...) == "break" then
      return ...
    end
  end
  return ...
end
function ForEachPresetGroup(class, func, ...)
  if type(class) == "table" then
    class = class.PresetClass or class.class
  end
  for _, group in ipairs(Presets[class] or empty_table) do
    if group[1] and group[1].group ~= "" then
      func(group[1].group, ...)
    end
  end
  return ...
end
function PresetGroupNames(class)
  local groups = {}
  for _, group in ipairs(Presets[class] or empty_table) do
    if group[1] and group[1].group ~= "" then
      groups[#groups + 1] = group[1].group
    end
  end
  table.sort(groups)
  return groups
end
function PresetGroupsCombo(class, additional)
  return function()
    local groups = PresetGroupNames(class)
    if type(additional) == "table" then
      for i, entry in ipairs(additional) do
        table.insert(groups, i, entry)
      end
    else
      table.insert(groups, 1, "")
      if additional then
        table.insert(groups, 2, additional)
      end
    end
    return groups
  end
end
function PresetsCombo(class, group, additional, filter, format)
  return function(obj)
    local ids = {}
    local encountered = {}
    if class and class ~= "" then
      local classdef = g_Classes[class]
      if not group and classdef and classdef.GlobalMap then
        ForEachPreset(class, function(preset, preset_group, ids)
          local id = preset.id
          if id ~= "" and (not filter or filter(preset, obj)) and not encountered[id] then
            ids[#ids + 1] = id
            encountered[id] = preset
          end
        end, ids)
      else
        local class = classdef and classdef.PresetClass or class
        group = group or IsPresetWithConstantGroup(classdef) and classdef.group or false
        for _, preset in ipairs((Presets[class] or empty_table)[group]) do
          local id = preset.id
          if id ~= "" and not encountered[id] and (not filter or filter(preset, obj)) then
            ids[#ids + 1] = id
            encountered[id] = preset
          end
        end
      end
    end
    table.sort(ids)
    if type(additional) == "table" then
      for i = #additional, 1, -1 do
        table.insert(ids, 1, additional[i])
      end
    elseif additional ~= nil then
      table.insert(ids, 1, additional)
    end
    if format then
      for i, id in ipairs(ids) do
        local preset = encountered[id]
        if preset then
          ids[i] = {
            value = id,
            text = _InternalTranslate(format, preset)
          }
        else
          ids[i] = {value = id}
        end
      end
    end
    return ids
  end
end
function PresetGroupCombo(class, group, filter, first_entry, format)
  return function()
    local ids = first_entry ~= "no_empty" and {
      first_entry or ""
    } or {}
    local encountered = {}
    local classdef = g_Classes[class]
    local preset_class = classdef and classdef.PresetClass or class
    for _, preset in ipairs((Presets[preset_class] or empty_table)[group]) do
      if preset.id ~= "" and not encountered[preset.id] and (not filter or filter(preset, group)) then
        ids[#ids + 1] = format and _InternalTranslate(format, preset) or preset.id
        encountered[preset.id] = true
      end
    end
    return ids
  end
end
function PresetMultipleGroupsCombo(class, groups, filter, first_entry, format)
  return function()
    local ids = first_entry ~= "no_empty" and {
      first_entry or ""
    } or {}
    local encountered = {}
    local classdef = g_Classes[class]
    local preset_class = classdef and classdef.PresetClass or class
    for _, group in ipairs(groups or empty_table) do
      for _, preset in ipairs((Presets[preset_class] or empty_table)[group] or empty_table) do
        if preset.id ~= "" and not encountered[preset.id] and (not filter or filter(preset, group)) then
          ids[#ids + 1] = format and _InternalTranslate(format, preset) or preset.id
          encountered[preset.id] = true
        end
      end
    end
    return ids
  end
end
function PresetsPropCombo(class_or_instance, prop, additional, recursive)
  if type(class_or_instance) == "table" then
    class_or_instance = class_or_instance.PresetClass or class_or_instance.class
  end
  if type(prop) == "table" then
    prop = prop.id
  end
  if type(class_or_instance) ~= "string" then
    return
  end
  local function traverse(obj, prop, values, encountered, recursive)
    if not obj then
      return
    end
    local value = obj:ResolveValue(prop)
    if value and not encountered[value] then
      values[#values + 1] = value
      encountered[value] = true
    end
    if recursive then
      for _, prop_meta in ipairs(obj:GetProperties()) do
        local editor = prop_meta.editor
        if editor == "nested_obj" then
          traverse(obj:GetProperty(prop_meta.id), prop, values, encountered, recursive)
        elseif editor == "nested_list" then
          local value = obj:GetProperty(prop_meta.id)
          for _, subobj in ipairs(value or empty_table) do
            traverse(subobj, prop, values, encountered, recursive)
          end
        end
      end
      for _, subitem in ipairs(obj) do
        traverse(subitem, prop, values, encountered, recursive)
      end
    end
  end
  return function(obj)
    local encountered = {}
    local values = {}
    ForEachPreset(class_or_instance, function(preset, group, prop, values, encountered, recursive)
      traverse(preset, prop, values, encountered, recursive)
    end, prop, values, encountered, recursive)
    table.sort(values, function(a, b)
      return (IsT(a) and TDevModeGetEnglishText(a) or a) < (IsT(b) and TDevModeGetEnglishText(b) or b)
    end)
    if additional ~= nil and not table.find(values, additional) then
      table.insert(values, 1, additional)
    end
    return values
  end
end
function PresetsTagsCombo(class_or_instance, prop)
  if type(class_or_instance) == "table" then
    class_or_instance = class_or_instance.PresetClass or class_or_instance.class
  end
  if type(prop) == "table" then
    prop = prop.id
  end
  if type(class_or_instance) ~= "string" or type(prop) ~= "string" then
    return
  end
  return function(obj)
    local items = {}
    ForEachPreset(class_or_instance, function(preset, group, prop, items)
      local tags = preset:ResolveValue(prop)
      if next(tags) == 1 then
        for _, tag in ipairs(tags) do
          items[tag] = true
        end
      else
        for tag in pairs(tags) do
          items[tag] = true
        end
      end
    end, prop, items)
    return table.keys(items, true)
  end
end
function Preset:GenerateUniquePresetId(name)
  local id = name or self.id
  local group = self.group
  local class = self.PresetClass or self.class
  local global_map = _G[class].GlobalMap
  global_map = global_map and rawget(_G, global_map)
  group = Presets[class][group]
  if (not global_map or not global_map[id]) and (not group or not group[id]) then
    return id
  end
  local new_id
  local n = 0
  local id1, n1 = id:match("(.*)_(%d+)$")
  if id1 and n1 then
    id, n = id1, tonumber(n1)
  end
  repeat
    n = n + 1
    new_id = id .. "_" .. n
  until (not global_map or not global_map[new_id]) and not group[new_id]
  return new_id
end
function Preset:EditorContext()
  local PresetClass = self.PresetClass or self.class
  local classes = ClassDescendantsList(PresetClass, function(classname, class, PresetClass)
    return class.PresetClass == PresetClass and class.GedEditor == g_Classes[PresetClass].GedEditor and not rawget(class, "NoInstances")
  end, PresetClass)
  if not rawget(self, "NoInstances") then
    table.insert(classes, 1, PresetClass)
  end
  return {
    PresetClass = PresetClass,
    Classes = classes,
    ContainerClass = self.ContainerClass,
    ContainerTree = IsKindOf(g_Classes[self.ContainerClass], "Container") and g_Classes[self.ContainerClass].ContainerClass == self.ContainerClass or false,
    EditorShortcut = self.EditorShortcut,
    EditorCustomActions = self.EditorCustomActions and table.icopy(self.EditorCustomActions),
    FilterClass = self.FilterClass,
    SubItemFilterClass = self.SubItemFilterClass,
    AltFormat = self.AltFormat,
    WarningsUpdateRoot = "root",
    ShowUnusedPropertyWarnings = IsKindOf(g_Classes[PresetClass], "CompositeDef")
  }
end
function FindPreset(preset_class, preset_id, prop_id)
  prop_id = prop_id or "id"
  local presets = Presets[preset_class] or empty_table
  for _, group in ipairs(presets) do
    local preset = table.find_value(group, prop_id, preset_id)
    if preset then
      return preset
    end
  end
end
function FindPresetEditor(preset_class, activate)
  for _, conn in pairs(GedConnections) do
    if conn.context and conn.context.PresetClass == preset_class then
      if not activate then
        return conn
      end
      local activated = conn:Call("rfnApp", "Activate")
      if activated ~= "disconnected" then
        return conn
      end
    end
  end
end
function OpenPresetEditor(class_name, context)
  if not IsRealTimeThread() or not CanYield() then
    CreateRealTimeThread(OpenPresetEditor, class_name, context)
    return
  end
  local class = g_Classes[class_name]
  local editor_ctx = context or class:EditorContext() or empty_table
  if class.SingleGedEditorInstance then
    local ged = FindPresetEditor(editor_ctx.PresetClass, "activate")
    if ged then
      return ged
    end
  end
  local preset_class = g_Classes[class.PresetClass] or class
  local presets = Presets[preset_class.class]
  PopulateParentTableCache(presets)
  return OpenGedApp(class.GedEditor, presets, editor_ctx)
end
function Preset:OpenEditor()
  if not IsRealTimeThread() or not CanYield() then
    CreateRealTimeThread(Preset.OpenEditor, self)
    return
  end
  local ged = OpenPresetEditor(self.PresetClass or self.class)
  if ged then
    ged:SetSelection("root", PresetGetPath(self))
  end
end
function Preset:GetIdentification()
  return self.id
end
if Platform.developer and not Platform.ged then
  GedSaveCollapsedPresetGroupsThread = false
  function SaveCollapsedPresetGroups()
    local collapsed = {}
    for presets_name, groups in pairs(Presets) do
      for group_name, group in pairs(groups) do
        if type(group_name) == "string" and GedTreePanelCollapsedNodes[group] then
          table.insert(collapsed, {presets_name, group_name})
        end
      end
    end
    SetDeveloperOption("CollapsedPresetGroups", collapsed)
  end
  function LoadCollapsedPresetGroups()
    local collapsed = GetDeveloperOption("CollapsedPresetGroups")
    if not collapsed then
      return
    end
    for _, item in ipairs(collapsed) do
      local preset_group = Presets[item[1]]
      local group = preset_group and preset_group[item[2]]
      if group then
        GedTreePanelCollapsedNodes[group] = true
      end
    end
  end
  function OnMsg.GedTreeNodeCollapsedChanged()
    if GedSaveCollapsedPresetGroupsThread ~= CurrentThread then
      DeleteThread(GedSaveCollapsedPresetGroupsThread)
    end
    GedSaveCollapsedPresetGroupsThread = CreateRealTimeThread(function()
      Sleep(250)
      SaveCollapsedPresetGroups()
    end)
  end
  function OnMsg.DataLoaded()
    LoadCollapsedPresetGroups()
  end
end
DefineClass.PropertyCategory = {
  __parents = {"Preset"},
  properties = {
    {
      category = "Category",
      id = "__help",
      sort_order = -1,
      editor = "help",
      help = "By default property categories have SortKey = 0, and are listed in the order they first appear as properties are defined."
    },
    {
      category = "Category",
      id = "SortKey",
      name = "Sort key",
      editor = "number",
      default = 0
    },
    {
      category = "Category",
      id = "display_name",
      name = "Display Name",
      editor = "text",
      translate = true,
      default = T(159662765679, "<u(id)>")
    },
    {id = "SaveIn", editor = false}
  },
  PresetIdRegex = "^[%w _+-]*$",
  HasSortKey = true,
  SingleFile = true,
  GlobalMap = "PropertyCategories",
  EditorViewPresetPostfix = Untranslated("<color 128 128 128> = <SortKey>"),
  EditorMenubarName = "Property categories",
  EditorMenubar = "Editors.Engine",
  EditorIcon = "CommonAssets/UI/Icons/map sitemap structure.png"
}
if FirstLoad then
  ReloadDataFiles = false
  ReloadPresetsThread = false
  ReloadPlannedTime = false
  ReloadingDisabled = {}
end
function OnMsg.ReloadLua()
  ReloadingDisabled.reloadlua = "wait"
end
function OnMsg.Autorun()
  ReloadingDisabled.reloadlua = false
end
function PresetSaveFolders()
  local paths = {}
  for a, save_in in ipairs(table.imap(Preset.GetPresetSaveLocations(), function(v)
    return v.value
  end)) do
    table.insert(paths, Preset:GetSaveFolder(save_in))
  end
  return paths
end
function QueueReloadAllPresets(file, change, force_reload)
  if Platform.ged then
    return
  end
  if file and not string.ends_with(file, ".lua") then
    return
  end
  if table.has_value(ReloadingDisabled, "reject") then
    return
  end
  if not Platform.developer then
    return
  end
  if not force_reload and g_PresetFileTimestampAtSave[file] then
    local err, timestamp = AsyncGetFileAttribute(file, "timestamp")
    if not err and g_PresetFileTimestampAtSave[file] == timestamp then
      return
    end
  end
  Msg("DataReload")
  preset_print("----- Reload request %s, %s", file, change)
  ReloadDataFiles = ReloadDataFiles or {}
  ReloadPlannedTime = now() + 500
  if file then
    ReloadDataFiles[file] = true
  end
  ReloadPresetsThread = ReloadPresetsThread or CreateRealTimeThread(function()
    while now() < ReloadPlannedTime or table.has_value(ReloadingDisabled, "wait") do
      Sleep(25)
    end
    PauseInfiniteLoopDetection("ReloadPresetsFromFiles")
    ReloadPresetsFromFiles()
    ResumeInfiniteLoopDetection("ReloadPresetsFromFiles")
    ReloadPresetsThread = false
    Msg("DataReloadDone")
    if ReloadDataFiles and table.has_value(ReloadDataFiles, true) then
      QueueReloadAllPresets()
    end
  end)
end
local wait_any = function(functions)
  local thread = CurrentThread()
  local result = false
  for key, value in ipairs(functions) do
    CreateRealTimeThread(function()
      local worker_result = table.pack(value())
      if not result then
        result = worker_result
        Wakeup(thread)
      end
    end)
  end
  return WaitWakeup() and table.unpack(result)
end
local AskEverywhere = function(title, question)
  local game_question = StdMessageDialog:new({}, terminal.desktop, {
    question = true,
    title = title,
    text = question
  })
  game_question:Open()
  local questions = {
    function()
      return game_question:Wait()
    end
  }
  for key, value in pairs(GedConnections) do
    table.insert(questions, function()
      return value:WaitQuestion(title, question)
    end)
  end
  local result = wait_any(questions)
  if game_question.window_state ~= "destroying" then
    game_question:Close(false)
  end
  for key, value in pairs(GedConnections) do
    value:DeleteQuestion()
  end
  return result
end
function ReloadPresetsFromFiles()
  if not Platform.developer and not Platform.cmdline then
    return
  end
  print("Reloading presets.")
  preset_print("Gathering preset types with (possibly) modified runtime data.")
  local changed_file_paths = ReloadDataFiles
  ReloadDataFiles = false
  local preset_classes_modified_in_ged = {}
  local presets_to_delete = {}
  local compiled_lua_files = {}
  for name in pairs(changed_file_paths) do
    if io.exists(name) then
      local func, err = loadfile(name, nil, _ENV)
      if not func then
        print(string.format("<color red>Lua compilation error in '%s'</color>", name))
        changed_file_paths[name] = nil
      end
      compiled_lua_files[name] = func or nil
    end
  end
  for class_name, groups in pairs(Presets) do
    local class = _G[class_name]
    if class.EnableReloading then
      for _, group in ipairs(groups) do
        for _, preset in ipairs(group) do
          if changed_file_paths[preset:GetLastSavePath()] then
            presets_to_delete[preset] = true
            if preset:IsDirty() then
              preset_classes_modified_in_ged[class_name] = "conflict"
              presets_to_delete[preset] = "modified"
              preset_print("Conflict %s %s: old_hash %s, current_hash %s", class_name, preset.id, preset:EditorData().old_hash, preset:EditorData().current_hash)
            else
              preset_classes_modified_in_ged[class_name] = preset_classes_modified_in_ged[class_name] or "affected"
            end
          end
        end
      end
    end
  end
  local conflicted_classes = {}
  for class_name, value in pairs(preset_classes_modified_in_ged) do
    if value == "conflict" then
      table.insert(conflicted_classes, class_name)
    end
    preset_print("Preset file status %s %s", class_name, value)
  end
  if 0 < #conflicted_classes then
    if rawget(terminal, "BringToTop") then
      terminal.BringToTop()
    end
    local conflicted_preset_ids = table.map(table.keys(table.filter(presets_to_delete, function(k, v)
      return v == "modified"
    end)), function(preset)
      return preset.id
    end)
    local title = "Overwrite preset data?"
    local q = [[
Preset data loaded from a file is about to overwrite changes made from the editor.

]] .. "You will lose ALL changes you have made from the following editors: " .. table.concat(conflicted_classes) .. "\n" .. [[
Ged UNDO/REDO will be lost as well.

]] .. "Modified presets: " .. table.concat(conflicted_preset_ids, ", ") .. [[


Continue?]]
    local result = AskEverywhere(title, q)
    if result ~= "ok" then
      print("Reload canceled.")
      Msg("DataReloadDone")
      return false
    end
  end
  local dropped = 0
  for preset, _ in pairs(presets_to_delete) do
    preset:delete()
    dropped = dropped + 1
  end
  preset_print("Deleted %s presets.", dropped)
  local loaded_presets = {}
  local loaded_preset_count = 0
  local old_place_obj = PlaceObj
  rawset(_G, "PlaceObj", function(class, ...)
    local object_class = _G[class]
    local spawned_preset_class
    if not IsKindOf(object_class, "Preset") then
      return old_place_obj(class, ...)
    end
    spawned_preset_class = object_class.PresetClass or class
    if not _G[spawned_preset_class].EnableReloading then
      return "reloading_disabled"
    end
    preset_classes_modified_in_ged[spawned_preset_class] = preset_classes_modified_in_ged[spawned_preset_class] or "loaded"
    local object = old_place_obj(class, ...)
    loaded_presets[object] = true
    loaded_preset_count = loaded_preset_count + 1
    object:MarkDirty(false)
    return object
  end)
  SuspendObjModified("ReloadPresetsFromFiles")
  for name, func in pairs(compiled_lua_files) do
    PresetsLoadingFileName = name
    procall(func)
  end
  PresetsLoadingFileName = false
  ResumeObjModified("ReloadPresetsFromFiles")
  rawset(_G, "PlaceObj", old_place_obj)
  preset_print("Loaded %s presets", loaded_preset_count)
  for preset in pairs(loaded_presets) do
    preset:PostLoad()
  end
  if not Platform.cmdline then
    preset_print("Updating Geds.")
    for class_name in pairs(preset_classes_modified_in_ged) do
      _G[class_name]:OnDataReloaded()
      _G[class_name]:OnDataUpdated()
      GedRebindRoot(Presets[class_name], Presets[class_name])
      PopulateParentTableCache(Presets[class_name])
    end
    preset_print("Resaving for reformatting and companion files.")
    for class_name in pairs(preset_classes_modified_in_ged) do
      _G[class_name]:SaveAll()
    end
  end
  preset_print("Data reload done.")
end
if Platform.developer then
  local exclude_presets = {
    "MapDataPreset",
    "ParticleSystemPreset",
    "PersistedRenderVars",
    "ThreePointLighting",
    "HGPreset",
    "HGAccount",
    "HGInventoryAsset",
    "HGMember",
    "HGMilestone",
    "HGProjectFeature",
    "HGTest",
    "Build_Settings"
  }
  function ResaveAllPresetsTest(game_tests)
    if not IsRealTimeThread() then
      CreateRealTimeThread(ResaveAllPresetsTest, game_tests)
      return
    end
    local errors = {}
    local ok, status = SVNStatus("svnProject/", "quiet")
    if not ok then
      table.insert(errors, {
        nil,
        " Could not get status of svnProject/"
      })
      HandleErrors(errors, game_tests)
      return
    end
    SuspendThreadDebugHook("ResaveAllPresetsTest")
    SuspendFileSystemChanged("ResaveAllPresetsTest")
    if game_tests then
      ChangeMap("")
    end
    for preset_name, presets in sorted_pairs(Presets) do
      PopulateParentTableCache(presets)
    end
    local count = 0
    for preset_name, _ in sorted_pairs(Presets) do
      if not table.find(exclude_presets, preset_name) then
        local preset = _G[preset_name]
        preset:SaveAll("resave_all")
        count = count + 1
      end
    end
    Sleep(250)
    ResumeFileSystemChanged("ResaveAllPresetsTest")
    ResumeThreadDebugHook("ResaveAllPresetsTest")
    local new_ok, new_status = SVNStatus("svnProject/", "quiet")
    if not new_ok then
      table.insert(errors, {
        nil,
        " Could not get status of svnProject/"
      })
      HandleErrors(errors, game_tests)
      return
    end
    print("All presets resaved. Differences?", status ~= new_status and "Yes!!" or "No", [[

Resaved preset classes: ]], count)
    if status ~= new_status then
      local ok_diff, str = SVNDiff("svnProject/", "ignore_whitespaces", 20000)
      if not ok_diff then
        table.insert(errors, {
          nil,
          " " .. str
        })
        if str == "Running process time out" then
          table.insert(errors, {
            nil,
            "The diff might be too long!"
          })
        end
        HandleErrors(errors, game_tests)
        return
      end
      local only_whitespace_changes = str == ""
      local diff = {}
      if only_whitespace_changes then
        ok_diff, str = SVNDiff("svnProject/")
      end
      local in_entity_data_diff = false
      for s in str:gmatch("[^\r\n]+") do
        if not in_entity_data_diff then
          in_entity_data_diff = string.sub(s, 1, 6) == "Index:" and string.sub(s, -25) == "_EntityData.generated.lua"
        else
          in_entity_data_diff = string.sub(s, 1, 6) ~= "Index:" or not string.find(s, -25) ~= "_EntityData.generated.lua"
        end
        if not in_entity_data_diff then
          diff[#diff + 1] = s
        end
        if #diff == 30 then
          break
        end
      end
      local only_entity_data_changes = #diff == 0
      if not only_entity_data_changes then
        table.insert(errors, {
          nil,
          " Resaving all presets created deltas! See changed files below:",
          only_whitespace_changes and "warning" or "error"
        })
        table.insert(errors, {
          nil,
          " Use Tools->\"Resave All Presets\" from the game menu to test this.",
          "warning"
        })
        if not only_whitespace_changes then
          for full_path, folder, file in new_status:gmatch("M%s+([%w:/\\_-]+[/\\]([%w_-]+)[/\\]([%w_-]+).[%w.]+)") do
            local entity_data_file = string.find(file, "_EntityData")
            local err = string.format("Preset: %s   |   Preset type: %s   |   File: %s", string.find(file, "ClassDef") and "-" or file, folder, full_path)
            table.insert(errors, {
              nil,
              err,
              entity_data_file and "warning" or "error"
            })
          end
        end
        local whitespaces_msg = only_whitespace_changes and "[NOTE] This diff is whitespace changes only! Resave these presets and commit the files locally.\n" or ""
        local err_msg = string.format([[

Old status:
%s 
New Status:
%s 
%sDiff (up to 30 lines):
%s]], status, new_status, whitespaces_msg, table.concat(diff, "\n"))
        table.insert(errors, {
          nil,
          err_msg,
          "warning"
        })
      end
    end
    local preset_id_to_gen_file = {}
    for preset_name, presets in sorted_pairs(Presets) do
      local preset_class = _G[preset_name]
      if preset_class and preset_class.GeneratesClass then
        preset_id_to_gen_file[preset_name] = {}
        local gen_path = preset_class:GetCompanionFileSavePath(preset_class:GetSavePath())
        ForEachPresetExtended(preset_name, function(preset, group)
          local preset_gen_path = preset:GetCompanionFileSavePath(preset:GetSavePath())
          if io.exists(preset_gen_path) then
            if not preset_id_to_gen_file[preset_name][preset.save_in] then
              preset_id_to_gen_file[preset_name][preset.save_in] = {}
            end
            preset_id_to_gen_file[preset_name][preset.save_in][preset.id] = preset_gen_path
          else
            local err_msg = string.format("Generated lua file is missing for this preset: %s.%s.%s! Expected: %s", preset_name, preset.group, preset.id, preset_gen_path)
            table.insert(errors, {preset, err_msg})
          end
        end)
        local preset_folder = string.match(gen_path, "(Lua/.+)/")
        if preset_folder then
          local files = io.listfiles(preset_folder, "*.generated.lua")
          local base_class = preset_class.ObjectBaseClass or preset_class.PresetClass or ""
          local extra_def_id = "__" .. base_class
          for _, f_path in ipairs(files) do
            if not string.find(f_path, "ClassDef", 1, true) then
              local id = string.match(f_path, "/.+/(.+)%.generated%.lua$")
              local dlc = string.match(f_path, "/Dlc/(.+)/Presets/") or ""
              if preset_id_to_gen_file[preset_name][dlc][id] ~= f_path and id ~= extra_def_id then
                local err_msg = string.format("Preset entry is missing for this generated file: %s! Expected %s preset with id %s", f_path, preset_name, id)
                table.insert(errors, {nil, err_msg})
              end
            end
          end
        end
      end
    end
    HandleErrors(errors, game_tests)
  end
  function HandleErrors(errors, game_tests)
    if 0 < #errors and not DbgAreDlcsMissing() then
      for idx, err in ipairs(errors) do
        local preset = err[1]
        local msg = err[2]
        local err_type = err[3]
        if game_tests then
          if err_type == "warning" then
            GameTestsPrint(msg)
          else
            GameTestsError(msg)
          end
        else
          local err_msg = string.format("<color %s>[!]</color> %s", RGB(240, 0, 0), msg)
          if err_type == "warning" then
            StoreWarningSource(preset, err_msg)
          else
            StoreErrorSource(preset, err_msg)
          end
        end
      end
    end
  end
end
function GetAvailablePresets(presets)
  if not presets then
    return
  end
  local forbidden = {}
  Msg("GatherForbiddenPresets", presets, forbidden)
  if not next(forbidden) then
    return presets
  end
  local filtered = {}
  for _, preset in ipairs(presets) do
    if not forbidden[preset.id] then
      filtered[#filtered + 1] = preset
    end
  end
  return filtered
end
function DisplayPresetCombo(class, default, group)
  local add_item = function(preset, group, items)
    if preset:filter() then
      items[#items + 1] = {
        text = preset:GetDisplayName(),
        value = preset.id
      }
    end
  end
  local items = {default}
  if group then
    ForEachPresetInGroup(class, group, add_item, items)
  else
    ForEachPreset(class, add_item, items)
  end
  return items
end
function GetPresetOrGroupUniquePath(obj)
  return IsKindOf(obj, "Preset") and {
    obj:GetGroup(),
    obj:GetId()
  } or {
    obj[1]:GetGroup()
  }
end
function PresetOrGroupByUniquePath(class, path)
  local group, id = path[1], path[2]
  local class_table = g_Classes[class]
  local presets = Presets[class_table.PresetClass or class_table.class]
  local group = presets and presets[group]
  if not id then
    return group
  end
  return group and group[id]
end
