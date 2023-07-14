if FirstLoad then
  g_DefaultColorsPalette = "Default colors"
end
local prop_cat = "Colorization Palette"
DefineClass.ColorizableObject = {
  __parents = {
    "PropertyObject"
  },
  flags = {cofComponentColorizationMaterial = true},
  properties = {
    {
      category = "Colorization Palette",
      id = "ColorizationPalette",
      name = "Colorization Palette",
      editor = "choice",
      default = g_DefaultColorsPalette,
      preset_class = "ColorizationPalettePreset",
      items = function(self)
        if not IsValid(self) then
          return false
        end
        local entity = self:GetEntity() ~= "" and self:GetEntity() or self.class
        local palettes = g_EntityToColorPalettes_Cache[entity]
        palettes = palettes and table.map(palettes, function(pal)
          return pal.PaletteName
        end) or {}
        palettes[#palettes + 1] = g_DefaultColorsPalette
        palettes[#palettes + 1] = ""
        return palettes
      end,
      no_edit = function(self)
        return self:ColorizationPropsNoEdit("palette") and true
      end,
      dont_save = function(self)
        return self:ColorizationPropsDontSave("palette") and true
      end,
      read_only = function(self)
        return self:ColorizationReadOnlyReason("palette") and true
      end,
      buttons = {
        {
          name = "Edit",
          is_hidden = function(self)
            return not IsValid(self) or self:GetColorizationPalette() == ""
          end,
          func = function(self, root, prop_id, socket)
            local palette_value = self:GetColorizationPalette()
            local preset_obj
            if palette_value == "" then
              return
            end
            if palette_value == g_DefaultColorsPalette then
              local entity = self:GetEntity() ~= "" and self:GetEntity() or self.class
              ForEachPreset("EntitySpec", function(preset)
                if preset.id == entity then
                  preset_obj = preset
                  return "break"
                end
              end)
              local ged = OpenPresetEditor("EntitySpec")
              if ged then
                ged:SetSelection("root", PresetGetPath(preset_obj))
              end
              return
            end
            local select_idx
            ForEachPreset("ColorizationPalettePreset", function(preset)
              for idx, entry in ipairs(preset) do
                if entry.class == "CPPaletteEntry" and entry.PaletteName == palette_value then
                  preset_obj = preset
                  select_idx = idx
                  return "break"
                end
              end
            end)
            if not preset_obj then
              return
            end
            GedRpcEditPreset(socket, "SelectedObject", prop_id, preset_obj.id)
            local ged = FindPresetEditor("ColorizationPalettePreset")
            if ged then
              ged:SetSelection("SelectedPreset", {select_idx})
            end
          end
        }
      }
    }
  },
  env_colorized = false
}
local CanEntityBeColorized = function(entity)
  local entity_data = EntityData[entity]
  if not entity_data then
    return false
  end
  return ColorizationMaterialsCount(entity) > 0 and (not entity_data.entity or not entity_data.entity.env_colorized)
end
function ColorizableObject:CanBeColorized()
  local entity = self:GetEntity() ~= "" and self:GetEntity() or self.class
  return not self.env_colorized and CanEntityBeColorized(entity)
end
function ColorizableObject:GetColorizationPalette()
  if not IsValid(self) then
    return
  end
  return self:GetColorizationPaletteName()
end
function ColorizableObject:SetColorsFromTable(colors)
  if colors.EditableColor1 then
    self:SetEditableColor1(colors.EditableColor1)
  end
  if colors.EditableColor2 then
    self:SetEditableColor2(colors.EditableColor2)
  end
  if colors.EditableColor3 then
    self:SetEditableColor3(colors.EditableColor3)
  end
  if colors.EditableRoughness1 then
    self:SetEditableRoughness1(colors.EditableRoughness1)
  end
  if colors.EditableRoughness2 then
    self:SetEditableRoughness2(colors.EditableRoughness2)
  end
  if colors.EditableRoughness3 then
    self:SetEditableRoughness3(colors.EditableRoughness3)
  end
  if colors.EditableMetallic1 then
    self:SetEditableMetallic1(colors.EditableMetallic1)
  end
  if colors.EditableMetallic2 then
    self:SetEditableMetallic2(colors.EditableMetallic2)
  end
  if colors.EditableMetallic3 then
    self:SetEditableMetallic3(colors.EditableMetallic3)
  end
end
function ColorizableObject:SetColorsByColorizationPaletteName(palette_name, previous_palette)
  if not palette_name or palette_name == "" then
    palette_name = previous_palette or ""
  end
  if palette_name == g_DefaultColorsPalette then
    local default_colors = self:GetDefaultColorizationSet()
    if default_colors then
      self:SetColorsFromTable(default_colors)
      return
    end
    self:SetEditableColor1(self:GetDefaultPropertyValue("EditableColor1"))
    self:SetEditableColor2(self:GetDefaultPropertyValue("EditableColor2"))
    self:SetEditableColor3(self:GetDefaultPropertyValue("EditableColor3"))
    self:SetEditableRoughness1(self:GetDefaultPropertyValue("EditableRoughness1"))
    self:SetEditableRoughness2(self:GetDefaultPropertyValue("EditableRoughness2"))
    self:SetEditableRoughness3(self:GetDefaultPropertyValue("EditableRoughness3"))
    self:SetEditableMetallic1(self:GetDefaultPropertyValue("EditableMetallic1"))
    self:SetEditableMetallic2(self:GetDefaultPropertyValue("EditableMetallic2"))
    self:SetEditableMetallic3(self:GetDefaultPropertyValue("EditableMetallic3"))
    return
  end
  local entity = self:GetEntity() ~= "" and self:GetEntity() or self.class
  for _, palette in ipairs(g_EntityToColorPalettes_Cache[entity]) do
    if palette.PaletteName == palette_name and palette.PaletteColors then
      self:SetColorsFromTable(palette.PaletteColors)
      break
    end
  end
end
local real_set_modifier = function(object, setter, value, ...)
  if IsValid(object) then
    object[setter](object, value, ...)
  end
end
function ColorizableObject:SetColorizationPalette(palette_name)
  if not IsValid(self) then
    return
  end
  palette_name = palette_name or ""
  self:SetColorizationPaletteName(palette_name)
  self:SetColorsByColorizationPaletteName(palette_name)
end
function ColorizableObject:ColorizationPropsNoEdit(i)
  if type(i) == "number" then
    return i > self:GetMaxColorizationMaterials()
  end
  return false
end
function ColorizableObject:GetMaxColorizationMaterials()
  if not IsValid(self) or self.env_colorized then
    return const.MaxColorizationMaterials
  end
  return Min(const.MaxColorizationMaterials, ColorizationMaterialsCount(self))
end
function ColorizableObject:OnEditorSetProperty(prop_id, old_value, ged, multi)
  if string.match(prop_id, "Editable") and self:GetColorizationPalette() ~= "" then
    local new_value = self:GetProperty(prop_id)
    self:SetColorizationPalette("")
    self:SetProperty(prop_id, new_value)
  end
end
function ColorizableObject:ColorizationReadOnlyReason(usage)
  if IsValid(self) and self:GetParent() then
    return "Object is an attached one. AutoAttaches are not persisted and colorization is either inherited from the parent or set explicitly in the AutoAttach editor."
  end
  local palette_value = self:GetColorizationPalette()
  if palette_value and palette_value ~= "" and usage ~= "palette" then
    return "A Colorization Palette preset is chosen and the colors are loaded from there."
  end
  if IsKindOf(self, "AppearanceObject") then
    return "AppearanceObjects are managed in the Appearance Editor."
  end
  return false
end
function ColorizableObject:ColorizationReadOnlyText()
  local reason = self:ColorizationReadOnlyReason()
  return reason and "Colorization is read only:\n" .. reason
end
function ColorizableObject:ColorizationPropsDontSave(i)
  local no_edit_result = self:ColorizationPropsNoEdit(i)
  if no_edit_result then
    return true
  end
  if self:ColorizationReadOnlyReason() then
    return true
  end
  if type(i) == "number" then
    local palette_value = self:GetColorizationPalette()
    if palette_value and palette_value ~= "" then
      return true
    end
  end
  return false
end
local default_color = const.ColorPaletteWhitePoint
local default_roughness = 0
local default_metallic = 0
for i = 1, const.MaxColorizationMaterials or 0 do
  local color = string.format("Color%d", i)
  local roughness = string.format("Roughness%d", i)
  local metallic = string.format("Metallic%d", i)
  local color_prop = string.format("Editable%s", color)
  local roughness_prop = string.format("Editable%s", roughness)
  local metallic_prop = string.format("Editable%s", metallic)
  local reset = string.format("ResetColorizationMaterial%d", i)
  _G[reset] = function(parentEditor, object, property, ...)
    object:SetProperty(color_prop, default_color)
    object:SetProperty(roughness_prop, default_roughness)
    object:SetProperty(metallic_prop, default_metallic)
    ObjModified(object)
  end
  local no_edit = function(self)
    return self:ColorizationPropsNoEdit(i) and true
  end
  local no_save = function(self)
    return self:ColorizationPropsDontSave(i) and true
  end
  table.iappend(ColorizableObject.properties, {
    {
      id = color_prop,
      category = prop_cat,
      name = string.format("%d: Base Color", i),
      editor = "color",
      default = default_color,
      no_edit = no_edit,
      dont_save = no_save,
      alpha = false,
      buttons = {
        {
          name = "Reset",
          func = reset,
          is_hidden = function(obj)
            if IsKindOf(obj, "GedMultiSelectAdapter") then
              for _, o in ipairs(obj.__objects) do
                if IsKindOf(0, "ColorizableObject") and o:ColorizationReadOnlyReason() then
                  return true
                end
              end
              return false
            end
            return obj:ColorizationReadOnlyReason()
          end
        }
      },
      autoattach_prop = true,
      read_only = function(obj)
        return obj:ColorizationReadOnlyReason() and true
      end,
      help = ColorizableObject.ColorizationReadOnlyText
    },
    {
      id = roughness_prop,
      category = prop_cat,
      name = string.format("%d: Roughness", i),
      editor = "number",
      default = default_roughness,
      slider = true,
      min = -128,
      max = 127,
      no_edit = no_edit,
      dont_save = no_save,
      autoattach_prop = true,
      read_only = function(obj)
        return obj:ColorizationReadOnlyReason() and true
      end,
      help = ColorizableObject.ColorizationReadOnlyText
    },
    {
      id = metallic_prop,
      category = prop_cat,
      name = string.format("%d: Metallic", i),
      editor = "number",
      default = default_metallic,
      slider = true,
      min = -128,
      max = 127,
      no_edit = no_edit,
      dont_save = no_save,
      autoattach_prop = true,
      read_only = function(obj)
        return obj:ColorizationReadOnlyReason() and true
      end,
      help = ColorizableObject.ColorizationReadOnlyText
    }
  })
  ColorizableObject[color_prop] = default_color
  ColorizableObject[roughness_prop] = default_roughness
  ColorizableObject[metallic_prop] = default_metallic
  local set_func_color = string.format("Set%s", color)
  ColorizableObject["Set" .. color_prop] = function(object, property, ...)
    if not IsValid(object) then
      object[color_prop] = property
      return
    end
    return object[set_func_color](object, property, ...)
  end
  local get_func_color = string.format("Get%s", color)
  ColorizableObject["Get" .. color_prop] = function(object, property, ...)
    if not IsValid(object) then
      return object[color_prop]
    end
    return object[get_func_color](object)
  end
  local set_func_roughness = string.format("Set%s", roughness)
  ColorizableObject["Set" .. roughness_prop] = function(object, property, ...)
    if not IsValid(object) then
      object[roughness_prop] = property
      return
    end
    return object[set_func_roughness](object, property, ...)
  end
  local get_func_roughness = string.format("Get%s", roughness)
  ColorizableObject["Get" .. roughness_prop] = function(object, property, ...)
    if not IsValid(object) then
      return object[roughness_prop]
    end
    return object[get_func_roughness](object)
  end
  local set_func_metallic = string.format("Set%s", metallic)
  ColorizableObject["Set" .. metallic_prop] = function(object, property, ...)
    if not IsValid(object) then
      object[metallic_prop] = property
      return
    end
    return object[set_func_metallic](object, property, ...)
  end
  local get_func_metallic = string.format("Get%s", metallic)
  ColorizableObject["Get" .. metallic_prop] = function(object, property, ...)
    if not IsValid(object) then
      return object[metallic_prop]
    end
    return object[get_func_metallic](object)
  end
end
local GeneratePropNames = function(prefixes, count)
  local t = {}
  for i = 1, count do
    for _, prefix in ipairs(prefixes) do
      table.insert(t, prefix .. i)
    end
  end
  return t
end
local setter_names = GeneratePropNames({
  "SetEditableColor",
  "SetEditableRoughness",
  "SetEditableMetallic"
}, const.MaxColorizationMaterials)
local getter_names = GeneratePropNames({
  "GetEditableColor",
  "GetEditableRoughness",
  "GetEditableMetallic"
}, const.MaxColorizationMaterials)
local prop_names = GeneratePropNames({
  "EditableColor",
  "EditableRoughness",
  "EditableMetallic"
}, const.MaxColorizationMaterials)
local defaults = {}
for i = 1, const.MaxColorizationMaterials do
  table.iappend(defaults, {
    default_color,
    default_roughness,
    default_metallic
  })
end
function ColorizableObject:AreColorsModified()
  local count = const.MaxColorizationMaterials
  for i = 1, count * 3 do
    if not self:IsPropertyDefault(prop_names[i]) then
      return true
    end
  end
  return false
end
function SetColorizationNoSetter(dst, src)
  local count = const.MaxColorizationMaterials
  for i = 1, count * 3 do
    local getter_name = getter_names[i]
    local value = src[getter_name](src)
    dst[prop_names[i]] = value
  end
end
function SetColorizationNoGetter(dst, src)
  local count = const.MaxColorizationMaterials
  for i = 1, count * 3 do
    local setter_name = setter_names[i]
    local value = src[prop_names[i]]
    dst[setter_name](dst, value)
  end
end
function ColorizableObject:GetColorsAsTable()
  if not self[getter_names[1]] then
    return
  end
  local ret
  local count = self:GetMaxColorizationMaterials()
  for i = 1, count * 3 do
    local getter_name = getter_names[i]
    local prop_name = prop_names[i]
    local value = self[getter_name](self)
    if value ~= defaults[i] then
      ret = ret or {}
      ret[prop_name] = value
    end
  end
  return ret
end
function ColorizableObject:SetColorization(obj, ignore_his_max)
  if obj then
    if not obj[getter_names[1]] then
      self:SetColorizationPalette(obj.ColorizationPalette or "")
      SetColorizationNoGetter(self, obj)
      return
    end
    local his_max = IsKindOf(obj, "ColorizableObject") and obj:GetMaxColorizationMaterials() or const.MaxColorizationMaterials
    local count = not ignore_his_max and Min(self:GetMaxColorizationMaterials(), his_max) or self:GetMaxColorizationMaterials()
    self:SetColorizationPalette(obj:GetColorizationPalette() or "")
    for i = 1, count * 3 do
      local setter_name = setter_names[i]
      local getter_name = getter_names[i]
      local value = obj[getter_name](obj)
      self[setter_name](self, value)
    end
  else
    self:SetColorizationPalette("")
    local count = self:GetMaxColorizationMaterials()
    for i = 1, count * 3 do
      self[setter_names[i]](self, defaults[i])
    end
  end
end
function ColorizableObject:SetMaterialColor(idx, value)
  self[setter_names[idx * 3 - 2]](self, value)
end
function ColorizableObject:SetMaterialRougness(idx, value)
  self[setter_names[idx * 3 - 1]](self, value)
end
function ColorizableObject:SetMaterialMetallic(idx, value)
  self[setter_names[idx * 3]](self, value)
end
function ColorizableObject:GetMaterialColor(idx, value)
  return self[getter_names[idx * 3 - 2]](self, value)
end
function ColorizableObject:GetMaterialRougness(idx, value)
  return self[getter_names[idx * 3 - 1]](self, value)
end
function ColorizableObject:GetMaterialMetallic(idx, value)
  return self[getter_names[idx * 3]](self, value)
end
if Platform.developer then
  if FirstLoad then
    ColorizationMatrixObjects = {}
  end
  function CreateGameObjectColorizationMatrix()
    for key, value in ipairs(ColorizationMatrixObjects) do
      DoneObject(value)
    end
    ColorizationMatrixObjects = {}
    local selected = editor.GetSel()
    if not selected or #selected == 0 then
      print("Please, select a valid object.")
      return false
    end
    local first = selected[1]
    if not IsValid(first) then
      print("Object was invalid.")
      return false
    end
    local width = first:GetEntityBBox():sizex()
    local length = first:GetEntityBBox():sizey()
    local start_pos = first:GetPos()
    local colors = {
      RGB(0, 0, 0),
      RGB(200, 200, 200),
      RGB(100, 100, 100),
      RGB(120, 10, 10),
      RGB(10, 120, 10),
      RGB(10, 10, 120),
      RGB(90, 90, 30),
      RGB(90, 30, 90),
      RGB(30, 90, 90)
    }
    local roughness_metallic = {
      point(0, 0),
      point(-80, 0),
      point(0, -80),
      point(80, 0),
      point(0, 80),
      point(80, 80),
      point(-80, -80)
    }
    for x, rm in ipairs(roughness_metallic) do
      for idx, color in ipairs(colors) do
        local obj = PlaceObject("Shapeshifter")
        obj:ChangeEntity(first:GetEntity())
        obj:SetPos(start_pos + point(x * width, idx * length))
        for c = 1, const.MaxColorizationMaterials do
          local method_name = "SetEditableColor" .. c
          obj[method_name](obj, colors[(idx + c - 2) % #colors + 1])
          method_name = "SetEditableRoughness" .. c
          obj[method_name](obj, rm:x())
          method_name = "SetEditableMetallic" .. c
          obj[method_name](obj, rm:y())
        end
        table.insert(ColorizationMatrixObjects, obj)
      end
    end
  end
end
DefineClass.ColorizationPropSet = {
  __parents = {
    "ColorizableObject"
  }
}
function ColorizationPropSet:GetEditorView()
  local clrs = {}
  local count = self:GetMaxColorizationMaterials()
  for i = 1, count do
    local color_get = string.format("GetEditableColor%d", i)
    local color = self[color_get] and self[color_get](self)
    local r, g, b = GetRGB(color)
    clrs[#clrs + 1] = string.format("<color %d %d %d>C%d</color>", r, g, b, i)
  end
  return Untranslated(table.concat(clrs, " "))
end
function ColorizationPropSet:Clone()
  local result = ColorizationPropSet:new({})
  result:SetColorization(self)
  return result
end
function ColorizationPropSet:OnEditorSetProperty(prop_id, old_value, ged)
  local parent = ged.selected_object
  if not parent then
    return
  end
  local list, parent_prop_id = parent:FindSubObjectLocation(self)
  if list ~= parent then
    return
  end
  return parent:OnEditorSetProperty(parent_prop_id, nil, ged)
end
function ColorizationPropSet:EqualsByValue(other)
  if rawequal(self, other) then
    return true
  end
  if not IsKindOf(self, "ColorizationPropSet") then
    return false
  end
  if not IsKindOf(other, "ColorizationPropSet") then
    return false
  end
  for i = 1, const.MaxColorizationMaterials or 0 do
    local color_get = string.format("GetEditableColor%d", i)
    local roughness_get = string.format("GetEditableRoughness%d", i)
    local metallic_get = string.format("GetEditableMetallic%d", i)
    if self[color_get] and other[color_get] and self[color_get](self) ~= other[color_get](other) then
      return false
    end
    if self[roughness_get] and other[roughness_get] and self[roughness_get](self) ~= other[roughness_get](other) then
      return false
    end
    if self[metallic_get] and other[metallic_get] and self[metallic_get](self) ~= other[metallic_get](other) then
      return false
    end
  end
  return true
end
ColorizationPropSet.__eq = ColorizationPropSet.EqualsByValue
function GetEnvColorizedGroups()
  return {}
end
function EnvColorizedTerrainColor(terrain_obj)
  local color_mod = terrain_obj.color_modifier
  return color_mod
end
local GetDefaultColorizationSet = function(entity_name)
  if not entity_name then
    return
  end
  local entity_data = EntityData[entity_name]
  if not entity_data then
    return
  end
  local default_colors = entity_data.default_colors
  if default_colors and next(default_colors) then
    return default_colors
  end
end
function ColorizableObject.GetDefaultColorizationSet(obj)
  return GetDefaultColorizationSet(obj:GetEntity())
end
if Platform.developer then
  function OnMsg.EditorCallback(id, objects, reason)
    if (id == "EditorCallbackPlace" or id == "EditorCallbackPlaceCursor") and reason ~= "undo" then
      for i = 1, #objects do
        local obj = objects[i]
        local colorizable = obj and IsKindOf(obj, "ColorizableObject") and not IsKindOf(obj, "Light")
        if colorizable and not obj:ColorizationReadOnlyReason("palette") and obj:GetColorizationPaletteName() == g_DefaultColorsPalette then
          obj:SetColorizationPalette(g_DefaultColorsPalette)
        end
      end
    end
  end
end
local ApplyLatestColorPalettes = function()
  if GetMap() == "" then
    return
  end
  MapForEach("map", "CObject", function(obj)
    local palette_value = obj:GetColorizationPalette()
    if palette_value and palette_value ~= "" then
      obj:SetColorsByColorizationPaletteName(palette_value)
    end
  end)
end
if FirstLoad then
  g_EntityToColorPalettes_Cache = {}
end
DefineClass.ColorizationPalettePreset = {
  __parents = {"Preset"},
  properties = {},
  GlobalMap = "ColorizationPalettePresets",
  GedEditor = "ColorizationPaletteEditor",
  EditorMenubarName = "Colorization Palettes Editor",
  EditorMenubar = "Editors.Art",
  EditorIcon = "CommonAssets/UI/Icons/colour creativity palette.png",
  ContainerClass = "CPEntry"
}
DefineClass.CPEntry = {
  __parents = {"InitDone"}
}
DefineClass.CPPaletteEntry = {
  __parents = {"CPEntry"},
  properties = {
    {
      id = "PaletteName",
      name = "Palette Name",
      editor = "text",
      default = false
    },
    {
      id = "PaletteColors",
      name = "Color Palette",
      editor = "nested_obj",
      base_class = "ColorizationPropSet",
      auto_expand = true,
      inclusive = true,
      default = false
    }
  },
  EditorView = Untranslated("<color 0 143 0>Palette</color> - <PaletteName> <GetColorsPreviewString>")
}
function CPPaletteEntry:OnEditorSetProperty(prop_id, old_value, ged)
  ApplyLatestColorPalettes()
end
function CPPaletteEntry:GetColorsPreviewString()
  if not self.PaletteColors then
    return ""
  end
  local c1, c2, c3 = "", "", ""
  if self.PaletteColors.EditableColor1 then
    local r, g, b = GetRGB(self.PaletteColors.EditableColor1)
    c1 = string.format("<color %s %s %s>C1</color>", r, g, b)
  end
  if self.PaletteColors.EditableColor2 then
    local r, g, b = GetRGB(self.PaletteColors.EditableColor2)
    c2 = string.format("<color %s %s %s>C2</color>", r, g, b)
  end
  if self.PaletteColors.EditableColor3 then
    local r, g, b = GetRGB(self.PaletteColors.EditableColor3)
    c3 = string.format("<color %s %s %s>C3</color>", r, g, b)
  end
  return string.format("- %s %s %s", c1, c2, c3)
end
local GetColorizableEntities = function()
  local result = {}
  for entity_name, entity_data in pairs(EntityData) do
    if CanEntityBeColorized(entity_name) then
      result[#result + 1] = entity_name
    end
  end
  return result
end
DefineClass.CPEntityEntry = {
  __parents = {"CPEntry"},
  properties = {
    {
      id = "ForEntity",
      name = "For Entity",
      editor = "choice",
      items = GetColorizableEntities,
      default = false
    }
  },
  EditorView = Untranslated("<color 143 0 0>Entity</color> - <ForEntity>")
}
local RebuildCPMappingCaches = function()
  g_EntityToColorPalettes_Cache = {}
  ForEachPreset("ColorizationPalettePreset", function(preset)
    local palette_names = {}
    local palettes = {}
    local entities = {}
    for _, entry in ipairs(preset) do
      if entry.class == "CPPaletteEntry" and entry.PaletteName and entry.PaletteColors then
        palettes[#palettes + 1] = entry
      elseif entry.class == "CPEntityEntry" and entry.ForEntity then
        entities[#entities + 1] = entry
      end
    end
    for _, entity in ipairs(entities) do
      g_EntityToColorPalettes_Cache[entity.ForEntity] = palettes
    end
  end)
end
function OnMsg.PresetSave(class)
  if class == "ColorizationPalettePreset" then
    RebuildCPMappingCaches()
    ApplyLatestColorPalettes()
  end
  if class == "EntitySpec" then
    ApplyLatestColorPalettes()
  end
end
OnMsg.DataLoaded = RebuildCPMappingCaches
OnMsg.DataReloadDone = RebuildCPMappingCaches
function OnMsg.NewMapLoaded()
  MapForEach("map", "Object", const.efRoot, function(obj)
    if not obj:CanBeColorized() then
      return
    end
    local palette_value = obj:GetColorizationPalette()
    if palette_value == g_DefaultColorsPalette then
      obj:SetColorsByColorizationPaletteName(palette_value)
    end
  end)
end
function GetColorsByColorizationPaletteName(entity, palette_value)
  if palette_value == g_DefaultColorsPalette then
    local default_colors = GetDefaultColorizationSet(entity)
    if default_colors then
      return RGBRM(default_colors.EditableColor1, default_colors.EditableRoughness1, default_colors.EditableMetallic1), RGBRM(default_colors.EditableColor2, default_colors.EditableRoughness2, default_colors.EditableMetallic2), RGBRM(default_colors.EditableColor3, default_colors.EditableRoughness3, default_colors.EditableMetallic3)
    end
  end
  for _, palette in ipairs(g_EntityToColorPalettes_Cache[entity] or empty_table) do
    if palette.PaletteName == palette_name and palette.PaletteColors then
      local colors = palette.PaletteColors
      return RGBRM(colors.EditableColor1, colors.EditableRoughness1, colors.EditableMetallic1), RGBRM(colors.EditableColor2, colors.EditableRoughness2, colors.EditableMetallic2), RGBRM(colors.EditableColor3, colors.EditableRoughness3, colors.EditableMetallic3)
    end
  end
end
