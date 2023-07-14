function DefineDLCProperties(class, preset_class, dlc, prop_class)
  local old_to_new_props = {}
  local base_props = _G[class].properties
  local base_prop_ids = {}
  for _, prop in ipairs(base_props) do
    base_prop_ids[prop.id] = prop
  end
  local i = 1
  for _, prop in ipairs(_G[prop_class].properties) do
    local main_id = prop.maingame_prop_id
    if main_id then
      local new_id = main_id .. "MainGame"
      local old_idx = table.find(base_props, "id", main_id)
      if not base_prop_ids[new_id] then
        local old_prop = base_props[old_idx]
        local new_prop = table.copy(old_prop, "deep")
        new_prop.id = main_id .. "MainGame"
        new_prop.name = old_prop.name or old_prop.id
        table.insert(base_props, old_idx + 1, new_prop)
        old_prop.no_edit = true
        old_prop.dlc_override = prop.dlc
        old_to_new_props[main_id] = new_prop.id
      end
      table.insert(base_props, old_idx + 2, prop)
    else
      table.insert(base_props, i, prop)
      i = i + 1
    end
    prop.dlc = dlc
  end
  function OnMsg.DataPreprocess()
    local class = preset_class.PresetClass or preset_class
    for _, group in ipairs(Presets[class]) do
      for _, preset in ipairs(group) do
        if preset:IsKindOf(preset_class) then
          for main_id, new_id in pairs(old_to_new_props) do
            preset:SetProperty(new_id, preset:GetProperty(main_id))
          end
        end
      end
    end
  end
  local restore_data = {}
  function OnMsg.OnPreSavePreset(preset)
    if preset:IsKindOf(preset_class) then
      for main_id, new_id in pairs(old_to_new_props) do
        restore_data[main_id] = preset:GetProperty(main_id)
        preset:SetProperty(main_id, preset:GetProperty(new_id))
        preset:SetProperty(new_id, nil)
      end
    end
  end
  function OnMsg.OnPostSavePreset(preset)
    if preset:IsKindOf(preset_class) then
      for main_id, new_id in pairs(old_to_new_props) do
        preset:SetProperty(new_id, preset:GetProperty(main_id))
        preset:SetProperty(main_id, restore_data[main_id])
        restore_data[main_id] = nil
      end
    end
  end
end
if FirstLoad then
  DLCPresetsForSaving = {}
end
DefineClass.DLCPropsPreset = {
  __parents = {"Preset"},
  GedEditor = false
}
function DLCPropsPreset:GetProperties()
  local main_class = g_Classes[self.MainPresetClass]
  local props = table.ifilter(main_class:GetProperties(), function(idx, prop)
    return prop.dlc == self.save_in
  end)
  table.insert(props, {
    id = "MainPresetClass",
    editor = "text",
    default = "",
    save_in = self.save_in
  })
  return props
end
function DLCPropsPreset:CleanupForSave(injected_props, restore_data)
  restore_data = PropertyObject.CleanupForSave(self, injected_props, restore_data)
  restore_data[#restore_data + 1] = {
    obj = self,
    key = "PresetClass",
    value = self.PresetClass
  }
  restore_data[#restore_data + 1] = {
    obj = self,
    key = "FilePerGroup",
    value = self.FilePerGroup
  }
  restore_data[#restore_data + 1] = {
    obj = self,
    key = "SingleFile",
    value = self.SingleFile
  }
  restore_data[#restore_data + 1] = {
    obj = self,
    key = "GlobalMap",
    value = self.GlobalMap
  }
  self.PresetClass = nil
  self.FilePerGroup = nil
  self.SingleFile = nil
  self.GlobalMap = nil
  return restore_data
end
function CreateDLCPresetsForSaving(preset)
  if IsKindOf(preset, "DLCPropsPreset") then
    return
  end
  local dlc_presets = {}
  for _, prop in ipairs(preset:GetProperties()) do
    local dlc = prop.dlc
    if dlc then
      local id = prop.id
      local value = preset:GetProperty(id)
      if not preset:IsDefaultPropertyValue(id, prop, value) then
        local dlc_preset = dlc_presets[dlc]
        if not dlc_preset then
          dlc_preset = DLCPropsPreset:new({
            MainPresetClass = preset.class,
            save_in = dlc,
            id = preset.id,
            group = preset.group,
            PresetClass = preset.PresetClass or preset.class,
            FilePerGroup = preset.FilePerGroup,
            SingleFile = preset.SingleFile,
            GlobalMap = preset.GlobalMap and "DLCPropsPresets"
          })
          dlc_preset:Register("")
          if preset:IsDirty() then
            dlc_preset:MarkDirty()
          end
          table.insert(DLCPresetsForSaving, dlc_preset)
          dlc_presets[dlc] = dlc_preset
        end
        dlc_presets[dlc]:SetProperty(id, value)
      end
    end
  end
end
function CleanupDLCPresetsForSaving()
  for _, preset in ipairs(DLCPresetsForSaving) do
    preset:delete()
  end
  DLCPresetsForSaving = {}
end
function DLCPropsPreset:FindOriginalPreset()
  local class = g_Classes[self.MainPresetClass]
  local preset_class = class.PresetClass or class.class
  local presets = Presets[preset_class]
  local group = presets and presets[self.group]
  return group and group[self.id]
end
function DLCPropsPreset:OnDataUpdated()
  local dlc_presets = {}
  ForEachPresetExtended("DLCPropsPreset", function(dlc_preset)
    local main_preset = dlc_preset:FindOriginalPreset()
    if main_preset then
      for _, prop in ipairs(dlc_preset:GetProperties()) do
        local id = prop.id
        if id ~= "Id" and id ~= "Group" and id ~= "SaveIn" and id ~= "MainPresetClass" then
          local value = dlc_preset:GetProperty(prop.id)
          main_preset:SetProperty(id, value)
          if prop.maingame_prop_id then
            main_preset:SetProperty(prop.maingame_prop_id, value)
          end
        end
      end
    end
    table.insert(dlc_presets, dlc_preset)
  end)
  for _, preset in ipairs(dlc_presets) do
    preset:delete()
  end
end
function OnMsg.GedPropertyEdited(ged_id, obj, id, old_value)
  if IsKindOf(obj, "Preset") then
    local prop_meta = obj:GetPropertyMetadata(id)
    if prop_meta.maingame_prop_id then
      local main_prop = obj:GetPropertyMetadata(prop_meta.maingame_prop_id)
      if main_prop.dlc_override == prop_meta.dlc then
        obj:SetProperty(main_prop.id, obj:GetProperty(id))
      end
    end
  end
end
