DefineClass.ConstDef = {
  __parents = {"Preset"},
  properties = {
    {
      id = "_",
      editor = "help",
      help = "<style GedHighlight>Defined in the Lua code; only the value is editable here.",
      no_edit = function(obj)
        return not obj.from_lua
      end,
      buttons = {
        {
          name = "Edit Code",
          func = function(obj)
            OpenFileLineInHaerald(obj.from_file, obj.from_line)
          end
        }
      }
    },
    {
      id = "type",
      editor = "choice",
      default = "number",
      items = {
        "bool",
        "number",
        "text",
        "color",
        "preset_id",
        "preset_id_list"
      }
    },
    {
      id = "value",
      editor = function(obj)
        return obj.type
      end,
      default = 0,
      item_default = "",
      scale = function(obj)
        return obj.scale
      end,
      translate = function(obj)
        return obj.translate
      end,
      preset_class = function(obj)
        return obj.preset_class
      end
    },
    {
      id = "scale",
      editor = "choice",
      default = 1,
      no_edit = function(obj)
        return obj.type ~= "number"
      end,
      items = function()
        return table.keys2(const.Scale, true, 1, 10, 100, 1000)
      end
    },
    {
      id = "translate",
      editor = "bool",
      default = false,
      no_edit = function(obj)
        return obj.type ~= "text"
      end
    },
    {
      id = "preset_class",
      editor = "choice",
      default = false,
      items = function()
        return table.keys(Presets, true)
      end,
      no_edit = function(obj)
        return obj.type ~= "preset_id_list" and obj.type ~= "preset_id"
      end
    }
  },
  EditorView = Untranslated("<id> <color GedName><ValueText><color 128 128 128><opt(u(save_in), ' - ', '')><color 0 128 0><opt(u(Comment),' ','')>"),
  EditorMenubarName = "Consts",
  EditorMenubar = "Editors.Lists",
  EditorIcon = "CommonAssets/UI/Icons/pi.png",
  from_lua = false,
  from_file = false,
  from_line = false,
  default_value = false,
  default_scale = false
}
function OnMsg.ClassesPostprocess()
  for _, prop in ipairs(ConstDef.properties) do
    if prop.id ~= "value" and prop.id ~= "scale" then
      function prop.read_only(obj)
        return obj.from_lua
      end
    end
  end
end
function ConstDef:GetDefaultPropertyValue(prop, prop_meta)
  if self.from_lua and prop == "value" then
    return self.default_value
  end
  if self.from_lua and prop == "scale" then
    return self.default_scale
  end
  return Preset.GetDefaultPropertyValue(self, prop, prop_meta)
end
function ConstDef:GetDefaultValueOf(type)
  type = type or "number"
  if type == "number" then
    return 0
  elseif type == "text" then
    return ""
  elseif type == "color" then
    return white
  elseif type == "bool" then
    return true
  end
  return false
end
function ConstDef:GetValueText()
  local t = self.type
  if t == "bool" then
    return self.value and "true" or "false"
  elseif t == "number" then
    return FormatNumberProp(tonumber(self.value) or 0, self.scale)
  elseif t == "color" then
    return string.format("%d %d %d %d", GetRGBA(self.value))
  elseif t == "preset_id_list" then
    return table.concat(self.value, ", ")
  elseif t == "preset_id" then
    return self.value or ""
  end
  return "???"
end
function ConstDef:OnEditorSetProperty(prop_id, old_value, ged)
  if prop_id == "translate" then
    self:UpdateLocalizedProperty("value", self.translate)
  end
  if prop_id == "type" then
    self.value = self:GetDefaultValueOf(self.type)
  end
end
function ConstDef:GetSavePath(save_in)
  save_in = save_in or self.save_in
  if save_in == "" then
    return "Lua/__const.lua"
  end
  if save_in == "Common" then
    return "CommonLua/Data/__const.lua"
  end
  if save_in:starts_with("Libs/") then
    return string.format("CommonLua/%s/Data/__const.lua", save_in)
  end
  return string.format("svnProject/Dlc/%s/Code/__const.lua", save_in)
end
function ConstDef:GetSaveData(file_path, presets, code_pstr)
  local code = code_pstr or pstr(exported_files_header_warning, 16384)
  for idx, preset in ipairs(presets) do
    if not preset.from_lua or ValueToLuaCode(preset.value) ~= ValueToLuaCode(preset.default_value) then
      if preset.from_lua then
        preset = setmetatable({
          id = preset.id,
          group = preset.group,
          value = preset.value,
          scale = preset.scale
        }, g_Classes.ConstDef)
      end
      if not preset.translate then
        preset.translate = nil
      end
      if not preset.preset_class then
        preset.preset_class = nil
      end
      if preset.scale == 1 then
        preset.scale = nil
      end
      if preset.group == ConstDef.group then
        preset.group = nil
      end
      if preset.id == "" then
        preset.id = nil
      end
      if preset.type == "number" then
        preset.type = nil
      end
      if preset.save_in == "" then
        preset.save_in = nil
      end
      code:append("DefineConst")
      preset:GenerateLocalizationContext(preset)
      TableToLuaCode(preset, nil, code)
      code:append("\n")
    end
  end
  return code
end
if FirstLoad then
  Presets = rawget(_G, "Presets") or {}
  PresetsLoadingFileName = false
  g_PresetLastSavePaths = rawget(_G, "g_PresetLastSavePaths") or {}
end
function ResetConstants()
  for _, group in ipairs(Presets.ConstDef) do
    for _, preset in ipairs(group) do
      local group_id = preset.group
      if group_id == "Default" then
        const[preset.id] = nil
      else
        local const_group = const[group_id]
        if const_group and rawget(const_group, preset.id) ~= nil then
          const_group[preset.id] = nil
        end
      end
    end
  end
  local old_presets = Presets.ConstDef
  Presets.ConstDef = {}
  return old_presets
end
local old_root = ResetConstants()
local groups = Presets.ConstDef
local const = const
function DefineConst(obj)
  local obj_group = obj.group or "Default"
  local group = groups[obj_group]
  if group then
    group[#group + 1] = obj
  else
    group = {obj}
    groups[obj_group] = group
    groups[#groups + 1] = group
  end
  local const_group = obj_group == "Default" and const or const[obj_group]
  if not const_group then
    const_group = {}
    const[obj_group] = const_group
  end
  local value = obj.value
  if value == nil then
    value = ConstDef:GetDefaultValueOf(obj.type)
  end
  local id = obj.id or ""
  local old_value
  if id == "" then
    const_group[#const_group + 1] = value
  else
    old_value = const_group[id]
    const_group[id] = value
    group[id] = obj
  end
  g_PresetLastSavePaths[obj] = PresetsLoadingFileName
  return old_value
end
LoadCommonConsts = empty_func
LoadDlcConsts = empty_func
local loadconsts = function(filename)
  PresetsLoadingFileName = filename
  pdofile(filename)
  PresetsLoadingFileName = false
end
function LoadConsts()
  loadconsts("CommonLua/Data/__const.lua")
  ForEachLib("Data/__const.lua", function(lib, path)
    loadconsts(path)
  end)
  loadconsts("Lua/__const.lua")
  for _, dlc_folder in ipairs(rawget(_G, "DlcFolders")) do
    loadconsts(dlc_folder .. "/Code/__const.lua")
  end
  for _, mod in ipairs(config.Mods and rawget(_G, "ModsLoaded")) do
    if mod:ItemsLoaded() then
      for j, item in ipairs(mod.items) do
        if IsKindOf(item, "ModItemConstDef") then
          item:AssignToConsts()
        end
      end
    end
  end
end
LoadConsts()
function OnMsg.PresetSave(class)
  if class == "ConstDef" then
    CreateRealTimeThread(ReloadLua)
  end
end
local FixConstMetatables = function()
  ForEachPresetExtended("ConstDef", function(preset, group, ConstDef)
    setmetatable(preset, ConstDef)
  end, ConstDef)
  ConstDef:SortPresets()
  GedRebindRoot(old_root, Presets.ConstDef)
end
OnMsg.ClassesBuilt = FixConstMetatables
ConstDef.OnDataReloaded = FixConstMetatables
function GetConst(group, name, default)
  local tbl = const[group]
  local value = tbl and tbl[name]
  if value == nil then
    printf("once", "No such const: %s.%s", group, name)
    return default
  end
  return value
end
function DefineConstFromCode(obj)
  local def_scale, def_value = obj.scale, obj.value
  local group = groups[obj.group]
  local preset = group and group[obj.id]
  if preset then
    preset.Comment = obj.Comment
    obj = preset
  end
  local info = debug.getinfo(3)
  obj.from_lua = true
  obj.from_file = info.short_src
  obj.from_line = info.currentline
  obj.default_value = def_value
  obj.default_scale = def_scale
  if not preset then
    local old_value = DefineConst(obj)
  end
end
function DefineConstInt(group, id, value, scale, comment)
  if not scale or scale == "" then
    scale = 1
  end
  value = value * (const.Scale[scale] or tonumber(scale) or 1)
  DefineConstFromCode({
    type = "number",
    group = group,
    id = id,
    value = value,
    scale = scale,
    Comment = comment
  })
end
function DefineConstString(group, id, value, comment)
  DefineConstFromCode({
    type = "text",
    group = group,
    id = id,
    value = value,
    Comment = comment
  })
end
function DefineConstBool(group, id, value, comment)
  DefineConstFromCode({
    type = "bool",
    group = group,
    id = id,
    value = value,
    Comment = comment
  })
end
