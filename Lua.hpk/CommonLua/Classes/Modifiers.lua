RecursiveCallMethods.OnModifiableValueChanged = "call"
DefineClass.Modifiable = {
  __parents = {
    "ContinuousEffectContainer"
  },
  modifications = false
}
local remove = table.remove
local ifind = table.ifind
local ChangeValue = function(self, prop, value)
  local old_value = self[prop]
  if old_value ~= value then
    self[prop] = value
    local prev_msg, index = ifind(PostMsgList, "OnModifiableValueChanged", self, prop)
    if prev_msg then
      old_value = prev_msg[4]
      remove(PostMsgList, index)
    end
    if old_value ~= value then
      PostMsg("OnModifiableValueChanged", self, prop, old_value, value)
    end
  end
end
function OnMsg.OnModifiableValueChanged(obj, prop, old_value, value)
  procall(obj.OnModifiableValueChanged, obj, prop, old_value, value)
end
function Modifiable:AddModifier(id, prop, ...)
  local modifier = Modifier:ModCreate(...)
  if not modifier then
    return
  end
  modifier.id = id or nil
  self:AddModifierObj(modifier, prop)
  return modifier
end
function Modifiable:AddModifierObj(modifier, prop)
  prop = prop or modifier.prop
  local modifications = self.modifications
  if not modifications then
    modifications = {}
    self.modifications = modifications
  end
  local modification_list = modifications[prop]
  if not modification_list then
    local prop_meta = self:GetPropertyMetadata(prop)
    if prop_meta then
      modification_list = Modifier:new({
        min = prop_meta.min or nil,
        max = prop_meta.max or nil
      })
    else
      modification_list = Modifier:new()
    end
    modifications[prop] = modification_list
  end
  if modifier.id then
    table.remove_entry(modification_list, "id", modifier.id)
  end
  if modifier.container then
    table.remove_entry(modification_list, "container", modifier.container)
  end
  modification_list[#modification_list + 1] = modifier
  modification_list:ModAccumulate()
  return ChangeValue(self, prop, modification_list:ModApply(self["base_" .. prop]))
end
function Modifiable:RemoveModifier(id, prop)
  local modifications = self.modifications
  local modification_list = modifications and modifications[prop]
  if not modification_list or not table.remove_entry(modification_list, "id", id) then
    return
  end
  local value = self["base_" .. prop]
  if 0 < #modification_list then
    modification_list:ModAccumulate()
    value = modification_list:ModApply(value)
  else
    modifications[prop] = nil
  end
  return ChangeValue(self, prop, value)
end
function Modifiable:RemoveModifierObj(modifier, prop)
  prop = prop or modifier.prop
  local modifications = self.modifications
  local modification_list = modifications and modifications[prop or false]
  if not modification_list then
    return
  end
  if not table.remove_entry(modification_list, modifier) and (not modifier.container or not table.remove_entry(modification_list, "container", modifier.container)) then
    return
  end
  local value = self["base_" .. prop]
  if 0 < #modification_list then
    modification_list:ModAccumulate()
    value = modification_list:ModApply(value)
  else
    modifications[prop] = nil
  end
  return ChangeValue(self, prop, value)
end
function Modifiable:ChangedModifier(prop)
  local modifications = self.modifications
  local modification_list = modifications and modifications[prop or false]
  if not modification_list then
    return
  end
  modification_list:ModAccumulate()
  return ChangeValue(self, prop, modification_list:ModApply(self["base_" .. prop]))
end
function Modifiable:ModifyValue(value, prop)
  local modifications = self.modifications
  local modification_list = modifications and modifications[prop]
  if modification_list then
    value = modification_list:ModApply(value)
  end
  return value
end
function Modifiable:GetBase(prop)
  return self["base_" .. prop]
end
function Modifiable:SetBase(prop, value, base_prop)
  base_prop = base_prop or "base_" .. prop
  local base_value = self[base_prop]
  if base_value == value then
    return
  end
  self[base_prop] = value
  local modifications = self.modifications
  local modification_list = modifications and modifications[prop]
  if modification_list then
    value = modification_list:ModApply(value)
  end
  return ChangeValue(self, prop, value)
end
function Modifiable:AddBase(prop, value)
  if value ~= 0 then
    self:SetBase(prop, value + self["base_" .. prop])
  end
end
function Modifiable:GetClassValue(prop)
  return getmetatable(self)[prop]
end
function Modifiable:RestoreBase(prop)
  self:SetBase(prop, self:GetClassValue(prop))
end
function Modifiable:RestoreModifiableValue(prop)
  local value = self:GetClassValue(prop)
  local modifications = self.modifications
  local modification_list = modifications and modifications[prop]
  if modification_list then
    value = modification_list:ModApply(value)
  end
  return ChangeValue(self, prop, value)
end
function Modifiable:GetPropertyModifierTexts(prop)
  local modifications = self.modifications
  if not modifications then
    return empty_table
  end
  local modification_list = modifications[prop]
  if not modification_list then
    return empty_table
  end
  local mod_texts = {}
  for _, mod in ipairs(modification_list) do
    if mod.display_text then
      mod_texts[#mod_texts + 1] = T({
        mod.display_text,
        mod
      })
    end
  end
  return mod_texts
end
function Modifiable:ModifierById(id, prop)
  local modifications = self.modifications
  if not modifications then
    return false
  end
  if prop then
    local modification_list = modifications[prop]
    return modification_list and table.find_value(modification_list, "id", id)
  else
    for _, modification_list in pairs(modifications) do
      local mod = table.find_value(modification_list, "id", id)
      if mod then
        return mod
      end
    end
  end
end
Modifiable.OnModifiableValueChanged = empty_func
function OnMsg.ClassesPostprocess()
  ClassDescendants("Modifiable", function(name, class)
    for _, prop_meta in ipairs(class.properties) do
      if prop_meta.modifiable and prop_meta.editor == "number" then
        local prop_id = prop_meta.id
        local value = rawget(class, prop_id)
        if value ~= nil then
          rawset(class, "base_" .. prop_id, value)
        end
      end
    end
  end)
end
if Platform.developer then
  function OnMsg.ClassesPreprocess(classdefs)
    for name, def in pairs(classdefs) do
      for _, meta in ipairs(def.properties) do
        if meta.modifiable then
          local prop = meta.id
          if def["Get" .. prop] or def["Set" .. prop] then
            printf("Class %s should not have Get/Set accessor functions for the modifiable property %s", name, prop)
          end
        end
      end
    end
  end
end
DefineClass.Modifier = {
  __parents = {
    "PropertyObject"
  },
  display_text = "",
  id = "",
  prop = false,
  mul = 1000,
  add = 0,
  min = false,
  max = false,
  add_min = 0,
  add_max = 0
}
function Modifier:ModCreate(mul, add, text, add_min, add_max, min, max)
  if (mul or 1000) == 1000 and (add or 0) == 0 and (add_min or 0) == 0 and (add_max or 0) == 0 then
    return
  end
  local modifier = self:new()
  modifier:ModSet(mul, add, text, add_min, add_max, min, max)
  return modifier
end
function Modifier:ModSet(mul, add, text, add_min, add_max, min, max)
  self.mul = mul ~= 1000 and mul or nil
  self.add = add ~= 0 and add or nil
  self.display_text = text ~= "" and text or nil
  self.add_min = add_min ~= 0 and add_min or nil
  self.add_max = add_max ~= 0 and add_max or nil
  self.min = min or nil
  self.max = max or nil
end
local MulDivRound = MulDivRound
local Clamp = Clamp
function Modifier:ModApply(value)
  value = MulDivRound(value + self.add, self.mul, 1000)
  local min, max = self.min, self.max
  min = min and min + self.add_min
  max = max and max + self.add_max
  return Clamp(value, min, max)
end
function Modifier:ModAccumulate(mod_list)
  local mul, add, add_min, add_max = 1000, 0, 0, 0
  for _, mod in ipairs(mod_list or self) do
    add = add + mod.add
    mul = MulDivRound(mul, mod.mul, 1000)
    add_min = add_min + mod.add_min
    add_max = add_max + mod.add_max
  end
  self.add = add ~= 0 and add or nil
  self.mul = mul ~= 1000 and mul or nil
  self.add_min = add_min ~= 0 and add_min or nil
  self.add_max = add_max ~= 0 and add_max or nil
end
DefineClass.ObjectModifier = {
  __parents = {"InitDone", "Modifier"},
  target = false,
  is_applied = false
}
function ObjectModifier:Init()
  self:TurnOn()
end
function ObjectModifier:Done()
  self:TurnOff()
end
function ObjectModifier:ResolveObject(obj)
  return obj
end
function ObjectModifier:TurnOn()
  if self.is_applied then
    return
  end
  local target = self:ResolveObject(self.target)
  if target then
    target:AddModifierObj(self)
  end
  self.is_applied = true
end
function ObjectModifier:TurnOff()
  if not self.is_applied then
    return
  end
  local target = self:ResolveObject(self.target)
  if target then
    target:RemoveModifierObj(self)
  end
  self.is_applied = false
end
function ObjectModifier:Change(...)
  self:ModSet(...)
  if self.is_applied then
    local target = self:ResolveObject(self.target)
    if target then
      target:ChangedModifier(self.prop)
    end
  end
end
function ObjectModifier:IsApplied()
  return self.is_applied
end
DefineClass.MultipleObjectsModifier = {
  __parents = {"InitDone", "Modifier"},
  targets = false,
  is_applied = false
}
function MultipleObjectsModifier:Init()
  self:TurnOn()
end
function MultipleObjectsModifier:Done()
  self:TurnOff()
end
function MultipleObjectsModifier:ResolveObject(obj)
  return obj
end
function MultipleObjectsModifier:TurnOn()
  if self.is_applied then
    return
  end
  for i, target in ipairs(self.targets or empty_table) do
    target = self:ResolveObject(target)
    if target then
      target:AddModifierObj(self)
    end
  end
  self.is_applied = true
end
function MultipleObjectsModifier:TurnOff()
  if not self.is_applied then
    return
  end
  for i, target in ipairs(self.targets or empty_table) do
    target = self:ResolveObject(target)
    if target then
      target:RemoveModifierObj(self)
    end
  end
  self.is_applied = false
end
function MultipleObjectsModifier:CleanInvalidTargets()
  table.validate(self.targets)
end
function MultipleObjectsModifier:CanDelete()
  for i, target in ipairs(self.targets or empty_table) do
    if IsValid(target) then
      return false
    end
  end
  return true
end
function MultipleObjectsModifier:Change(...)
  self:ModSet(...)
  if self.is_applied then
    for i, target in ipairs(self.targets or empty_table) do
      target = self:ResolveObject(target)
      if target then
        target:ChangedModifier(self.prop)
      end
    end
  end
end
function MultipleObjectsModifier:AddTarget(target)
  table.insert(self.targets, target)
  if self.is_applied then
    target = self:ResolveObject(target)
    if target then
      target:AddModifierObj(self)
    end
  end
end
function MultipleObjectsModifier:RemoveTarget(target)
  local found = table.remove_entry(self.targets, target)
  if found and self.is_applied then
    target = self:ResolveObject(target)
    if target then
      target:RemoveModifierObj(self)
    end
  end
end
if FirstLoad then
  ModifiablePropsComboItems = {}
  ModifiablePropScale = {}
end
local UpdateModifiablePropScales = function()
  local scale = {}
  ClassDescendants("Modifiable", function(name, classdef, scale)
    local class_props = classdef:GetProperties()
    for i = 1, #class_props do
      local prop = class_props[i]
      if prop.modifiable and prop.editor == "number" then
        local new_scale = prop.scale
        local existing_scale = scale[prop.id]
        if not existing_scale then
          scale[prop.id] = new_scale
        elseif existing_scale ~= new_scale then
        end
      end
    end
  end, scale)
  ModifiablePropsComboItems = table.keys(scale)
  table.sort(ModifiablePropsComboItems, CmpLower)
  ModifiablePropScale = scale
end
function OnMsg.ClassesBuilt()
  UpdateModifiablePropScales()
end
function OnMsg.BinAssetsLoaded()
  UpdateModifiablePropScales()
end
function ClassModifiablePropsCombo(obj)
  local existing, props = {}, {}
  local class_props = obj:GetProperties()
  for i = 1, #class_props do
    local prop = class_props[i]
    if prop.modifiable and prop.editor == "number" and not existing[prop.id] then
      existing[prop.id] = true
      props[#props + 1] = {
        value = prop.id,
        text = prop.name or prop.id
      }
    end
  end
  TSort(props, "text")
  return props
end
function ClassModifiablePropsNonTranslatableCombo(obj)
  if type(obj) == "string" then
    obj = g_Classes[obj]
  end
  if not obj then
    return ModifiablePropsComboItems
  end
  local props = {}
  for _, prop in ipairs(obj:GetProperties()) do
    if prop.modifiable and prop.editor == "number" then
      props[#props + 1] = prop.id
    end
  end
  table.sort(props)
  return props
end
function NestedObjectsCombo(obj)
  if type(obj) == "string" then
    obj = g_Classes[obj]
  end
  if not obj then
    return {}
  end
  local items = {}
  local props = obj:GetProperties()
  for _, prop in ipairs(props) do
    if prop.editor == "nested_obj" or prop.editor == "nested_list" then
      items[#items + 1] = prop.id
    end
  end
  table.sort(items)
  table.insert(items, 1, "")
  return items
end
DefineClass.ModifyProperty = {
  __parents = {
    "ContinuousEffect",
    "Modifier"
  },
  properties = {
    {id = "Id"},
    {
      id = "obj_class",
      name = "Object Class",
      help = "Apply to objects of this class only (optional)",
      editor = "choice",
      default = false,
      items = function(self)
        return ClassDescendantsList("Modifiable")
      end,
      no_edit = function(self)
        return not self.HasClassProp
      end,
      dont_save = function(self)
        return not self.HasClassProp
      end
    },
    {
      id = "sub_object",
      name = "Sub-object",
      help = "Use to specify the sub-object to be modified (optional)",
      editor = "string_list",
      default = false,
      item_default = "",
      items = function(self)
        return self:HasMember("obj_class") and NestedObjectsCombo(self.obj_class) or {}
      end,
      arbitrary_value = false,
      max_items = -1,
      no_edit = function(self)
        return not self.obj_class or not self.HasSubObjectProp
      end,
      dont_save = function(self)
        return not self.HasSubObjectProp
      end
    },
    {
      id = "id",
      name = "Id",
      help = "Only the last modifier with this id will be active (optional)",
      editor = "text",
      default = false,
      no_edit = function(self)
        return not self.HasIdProp
      end,
      dont_save = function(self)
        return not self.HasIdProp
      end
    },
    {
      id = "prop",
      name = "Property",
      help = "Name of a numeric property to modify",
      editor = "choice",
      default = false,
      items = function(self)
        return ClassModifiablePropsNonTranslatableCombo(self.obj_class)
      end
    },
    {
      id = "add",
      name = "Add",
      help = "Additive modifier, applied before Mul",
      editor = "number",
      default = 0,
      scale = function(self)
        return self:GetModScale()
      end
    },
    {
      id = "mul",
      name = "Mul",
      help = "Multiplicative modifier",
      editor = "number",
      default = 1000,
      min = 0,
      scale = 1000
    },
    {
      id = "add_min",
      name = "Change min",
      help = "Add to modified value min",
      editor = "number",
      default = 0,
      scale = function(self)
        return self:GetModScale()
      end
    },
    {
      id = "add_max",
      name = "Change max",
      help = "Add to modified value max",
      editor = "number",
      default = 0,
      scale = function(self)
        return self:GetModScale()
      end
    },
    {
      id = "display_text",
      name = "Display Text",
      help = "Can be used to display in the UI this modifier",
      editor = "text",
      default = "",
      translate = true,
      no_edit = function(self)
        return self.HasDisplayTextProp
      end,
      dont_save = function(self)
        return self.HasDisplayTextProp
      end
    }
  },
  CreateInstance = false,
  RequiredObjClasses = {"Modifiable"},
  Documentation = "Applies a modifier to a property within the object parameter of this effect.",
  EditorNestedObjCategory = "Continuous Effects",
  EditorView = T(744151871819, "Modify <u(SubObjectEditorView)><u(prop)><AddEditorView><MulEditorView> <u(id)>"),
  HasClassProp = true,
  HasSubObjectProp = true,
  HasIdProp = true,
  HasDisplayTextProp = true
}
function ModifyProperty:GetSubObjectEditorView()
  if next(self.sub_object or empty_table) then
    return table.concat(self.sub_object, ".") .. "."
  end
  return ""
end
function ModifyProperty:GetAddEditorView()
  if self.add == 0 then
    return ""
  end
  local scale = self:GetModScale()
  local text = (self.add < 0 and Untranslated(" -") or Untranslated(" +")) .. FormatAsFloat(abs(self.add), type(scale) == "number" and scale or const.Scale[scale] or 1, 3, true)
  return type(scale) == "string" and text .. Untranslated(scale) or text
end
function ModifyProperty:GetMulEditorView()
  if self.mul == 1000 then
    return ""
  end
  return Untranslated(" x") .. FormatAsFloat(self.mul, 1000, 3, true)
end
function ModifyProperty:GetModScale()
  return ModifiablePropScale[self.prop] or 1
end
function ModifyProperty:ResolveObject(obj)
  if self.obj_class and not obj:IsKindOf(self.obj_class) then
    return
  end
  for i, field in ipairs(self.sub_object or empty_table) do
    obj = type(obj) == "table" and rawget(obj, field)
  end
  return obj
end
function ModifyProperty:OnStart(obj, context)
  obj = self:ResolveObject(obj)
  if obj then
    obj:AddModifierObj(self)
  end
end
ModifyProperty.__exec = ModifyProperty.OnStart
function ModifyProperty:OnStop(obj, context)
  obj = self:ResolveObject(obj)
  if obj then
    obj:RemoveModifierObj(self)
  end
end
function ModifyProperty:GetError()
  if not self.prop then
    return "Missing property to modify"
  elseif self.add == 0 and self.mul == 1000 and self.add_min == 0 and self.add_max == 0 then
    return "Default values result in no modification"
  end
end
DefineClass.ModifiersPreset = {
  __parents = {"Preset"},
  properties = {
    {
      category = "Effect",
      id = "Modifiers",
      name = "Modifiers",
      editor = "nested_list",
      default = false,
      base_class = "ModifyUnit",
      all_descendants = true
    }
  },
  EditorMenubarName = false
}
function ModifiersPreset:ApplyModifiers(obj)
  for _, modifier in ipairs(self.Modifiers or empty_table) do
    modifier:OnStart(obj, self)
  end
end
function ModifiersPreset:UnapplyModifiers(obj)
  for _, modifier in ipairs(self.Modifiers or empty_table) do
    modifier:OnStop(obj, self)
  end
end
function ModifiersPreset:PostLoad()
  for _, modifier in ipairs(self.Modifiers or empty_table) do
    modifier.container = self
  end
  Preset.PostLoad(self)
end
