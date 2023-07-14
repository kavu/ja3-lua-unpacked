function ResetColorModifier(parentEditor, object, property, ...)
  object:SetProperty(property, const.clrNoModifier)
end
function GetCollectionNames()
  local names = table.keys(CollectionsByName, "sort") or {}
  table.insert(names, 1, "")
  return names
end
local OnCollisionWithCameraItems = function(obj)
  local class_become_transparent = GetClassEnumFlags(obj.class, const.efCameraMakeTransparent) ~= 0
  local class_repulse_camera = GetClassEnumFlags(obj.class, const.efCameraRepulse) ~= 0
  local items = {
    {text = "no action", value = "no action"},
    {
      text = "repulse camera",
      value = "repulse camera"
    },
    {
      text = "become transparent",
      value = "become transparent"
    },
    {
      text = "repulse camera & become transparent",
      value = "repulse camera & become transparent"
    }
  }
  if class_repulse_camera then
    items[2] = {
      text = "repulse camera (class default)",
      value = false
    }
  elseif class_become_transparent then
    items[3] = {
      text = "become transparent (class default)",
      value = false
    }
  else
    items[1] = {
      text = "no action (class default)",
      value = false
    }
  end
  return items
end
OCCtoFlags = {
  ["repulse camera"] = {efCameraMakeTransparent = false, efCameraRepulse = true},
  ["become transparent"] = {efCameraMakeTransparent = true, efCameraRepulse = false}
}
if FirstLoad then
  FlagsByBits = {
    Game = {},
    Enum = {},
    Class = {},
    Component = {}
  }
  local const_keys = table.keys(const)
  local const_vars = EnumEngineVars("const.")
  for key in pairs(const_vars) do
    const_keys[#const_keys + 1] = key
  end
  for i = 1, #const_keys do
    local key = const_keys[i]
    local flags
    if string.starts_with(key, "gof") then
      flags = FlagsByBits.Game
    elseif string.starts_with(key, "ef") then
      flags = FlagsByBits.Enum
    elseif string.starts_with(key, "cf") then
      flags = FlagsByBits.Class
    elseif string.starts_with(key, "cof") then
      flags = FlagsByBits.Component
    end
    if flags then
      local value = const[key]
      if value ~= 0 then
        flags[IndexOfHighestSetBit(value) + 1] = key
      end
    end
  end
  FlagsByBits.Enum[1] = {name = "efAlive", read_only = true}
end
local efVisible = const.efVisible
local gofWarped = const.gofWarped
local efShadow = const.efShadow
local efSunShadow = const.efSunShadow
local GetSurfaceByBits = function()
  local flags = {}
  for name, flag in pairs(EntitySurfaces) do
    if IsPowerOf2(flag) then
      flags[IndexOfHighestSetBit(flag)] = name
    end
  end
  return flags
end
DefineClass.MapObject = {
  __parents = {
    "PropertyObject"
  },
  GetEntity = empty_func,
  persist_baseclass = "class",
  UnpersistMissingClass = function(self, id, permanents)
    return self
  end
}
DefineClass.CObject = {
  __parents = {
    "MapObject",
    "ColorizableObject",
    "FXObject"
  },
  __hierarchy_cache = true,
  entity = false,
  flags = {
    efSelectable = true,
    efVisible = true,
    efWalkable = true,
    efCollision = true,
    efApplyToGrids = true,
    efShadow = true,
    efSunShadow = true,
    cfConstructible = true,
    gofScaleSurfaces = true,
    cofComponentCollider = 0 < const.maxCollidersPerObject
  },
  radius = 0,
  texture = "",
  material_type = false,
  template_class = "",
  distortion_scale = 0,
  orient_mode = 0,
  orient_mode_bias = 0,
  max_allowed_radius = const.GameObjectMaxRadius,
  variable_entity = false,
  properties = {
    {
      id = "ClassFlagsProp",
      name = "ClassFlags",
      editor = "flags",
      items = FlagsByBits.Class,
      default = 0,
      dont_save = true,
      read_only = true
    },
    {
      id = "ComponentFlagsProp",
      name = "ComponentFlags",
      editor = "flags",
      items = FlagsByBits.Component,
      default = 0,
      dont_save = true,
      read_only = true
    },
    {
      id = "EnumFlagsProp",
      name = "EnumFlags",
      editor = "flags",
      items = FlagsByBits.Enum,
      default = 1,
      dont_save = true
    },
    {
      id = "GameFlagsProp",
      name = "GameFlags",
      editor = "flags",
      items = FlagsByBits.Game,
      default = 0,
      dont_save = true,
      size = 64
    },
    {
      id = "SurfacesProp",
      name = "Surfaces",
      editor = "flags",
      items = GetSurfaceByBits,
      default = 0,
      dont_save = true,
      read_only = true
    },
    {
      id = "DetailClass",
      name = "Detail Class",
      editor = "dropdownlist",
      items = {
        "Default",
        "Essential",
        "Optional",
        "Eye Candy"
      },
      default = "Default"
    },
    {
      id = "LowerLOD",
      name = "Lower LOD",
      editor = "bool",
      default = false
    },
    {
      id = "Entity",
      editor = "text",
      default = "",
      read_only = true,
      dont_save = true
    },
    {
      id = "Pos",
      name = "Pos",
      editor = "point",
      default = InvalidPos(),
      scale = "m"
    },
    {
      id = "Angle",
      editor = "number",
      default = 0,
      min = 0,
      max = 21599,
      slider = true,
      scale = "deg",
      no_validate = true
    },
    {
      id = "Scale",
      editor = "number",
      default = 100,
      slider = true,
      min = function(self)
        return self:GetMinScale()
      end,
      max = function(self)
        return self:GetMaxScale()
      end
    },
    {
      id = "Axis",
      editor = "point",
      default = axis_z,
      local_space = true
    },
    {
      id = "Opacity",
      editor = "number",
      default = 100,
      min = 0,
      max = 100,
      slider = true
    },
    {
      id = "StateCategory",
      editor = "choice",
      items = function()
        return ArtSpecConfig and ArtSpecConfig.ReturnAnimationCategories
      end,
      default = "All",
      dont_save = true
    },
    {
      id = "StateText",
      editor = "combo",
      default = "idle",
      items = function(obj)
        return obj:GetStatesTextTable(obj.StateCategory)
      end,
      show_recent_items = 7
    },
    {
      id = "TestStateButtons",
      editor = "buttons",
      default = false,
      dont_save = true,
      buttons = {
        {
          name = "Play once(c)",
          func = "BtnTestOnce"
        },
        {
          name = "Loop(c)",
          func = "BtnTestLoop"
        },
        {
          name = "Test(c)",
          func = "BtnTestState"
        },
        {
          name = "Play once",
          func = "BtnTestOnce",
          param = "no_compensate"
        },
        {
          name = "Loop",
          func = "BtnTestLoop",
          param = "no_compensate"
        },
        {
          name = "Test",
          func = "BtnTestState",
          param = "no_compensate"
        }
      }
    },
    {
      id = "ForcedLOD",
      name = "Forced LOD",
      editor = "number",
      default = 0,
      min = 0,
      slider = true,
      dont_save = true,
      help = "Forces specific lod to show.",
      max = function(obj)
        return obj:IsKindOf("GedMultiSelectAdapter") and 0 or Max(obj:GetLODsCount(), 1) - 1
      end,
      no_edit = function(obj)
        return not IsValid(obj) or not obj:HasEntity() or obj:GetEntity() == "InvisibleObject"
      end
    },
    {
      id = "Groups",
      editor = "string_list",
      default = false,
      items = function()
        return table.keys2(Groups or empty_table, "sorted")
      end,
      arbitrary_value = true
    },
    {
      id = "ColorModifier",
      editor = "rgbrm",
      default = RGB(100, 100, 100)
    },
    {
      id = "Saturation",
      name = "Saturation(Debug)",
      editor = "number",
      slider = true,
      min = 0,
      max = 255,
      default = 128
    },
    {
      id = "Gamma",
      name = "Gamma(Debug)",
      editor = "color",
      default = RGB(128, 128, 128)
    },
    {
      id = "SIModulation",
      editor = "number",
      default = 100,
      min = 0,
      max = 255,
      slider = true
    },
    {
      id = "SIModulationManual",
      editor = "bool",
      default = false,
      read_only = true
    },
    {
      id = "Occludes",
      editor = "bool",
      default = false
    },
    {
      id = "Walkable",
      editor = "bool",
      default = true
    },
    {
      id = "ApplyToGrids",
      editor = "bool",
      default = true
    },
    {
      id = "IgnoreHeightSurfaces",
      editor = "bool",
      default = false
    },
    {
      id = "Collision",
      editor = "bool",
      default = true
    },
    {
      id = "Visible",
      editor = "bool",
      default = true,
      dont_save = true
    },
    {
      id = "SunShadow",
      name = "Shadow from Sun",
      editor = "bool",
      default = function(obj)
        return GetClassEnumFlags(obj.class, efSunShadow) ~= 0
      end
    },
    {
      id = "CastShadow",
      name = "Shadow from All",
      editor = "bool",
      default = function(obj)
        return GetClassEnumFlags(obj.class, efShadow) ~= 0
      end
    },
    {
      id = "Mirrored",
      name = "Mirrored",
      editor = "bool",
      default = false
    },
    {
      id = "OnRoof",
      name = "On Roof",
      editor = "bool",
      default = false
    },
    {
      id = "DontHideWithRoom",
      name = "Don't hide with room",
      editor = "bool",
      default = false,
      no_edit = not const.SlabSizeX,
      dont_save = not const.SlabSizeX
    },
    {
      id = "SkewX",
      name = "Skew X",
      editor = "number",
      default = 0
    },
    {
      id = "SkewY",
      name = "Skew Y",
      editor = "number",
      default = 0
    },
    {
      id = "ClipPlane",
      name = "Clip Plane",
      editor = "number",
      default = 0,
      read_only = true,
      dont_save = true
    },
    {
      id = "Radius",
      name = "Radius (m)",
      editor = "number",
      default = 0,
      scale = guim,
      read_only = true,
      dont_save = true
    },
    {
      id = "Sound",
      name = "Sound",
      editor = "text",
      default = false,
      read_only = true,
      dont_save = true
    },
    {
      id = "AnimSpeedModifier",
      name = "Anim Speed Modifier",
      editor = "number",
      default = 1000,
      min = 0,
      max = 65535,
      slider = true
    },
    {
      id = "OnCollisionWithCamera",
      editor = "choice",
      default = false,
      items = OnCollisionWithCameraItems
    },
    {
      id = "Warped",
      editor = "bool",
      default = function(obj)
        return GetClassGameFlags(obj.class, gofWarped) ~= 0
      end
    },
    {
      id = "CollectionIndex",
      name = "Collection Index",
      editor = "number",
      default = 0,
      read_only = true
    },
    {
      id = "CollectionName",
      name = "Collection Name",
      editor = "choice",
      items = GetCollectionNames,
      default = "",
      dont_save = true,
      buttons = {
        {
          name = "Collection Editor",
          func = function(self)
            if self:GetRootCollection() then
              OpenCollectionEditorAndSelectCollection(self)
            end
          end
        }
      }
    }
  },
  SelectionPropagate = empty_func,
  GedTreeCollapsedByDefault = true,
  PropertyTabs = {
    {
      TabName = "Object",
      Categories = {
        Misc = true,
        ["Random Map"] = true,
        Child = true
      }
    }
  },
  IsVirtual = empty_func
}
function CObject:GetScaleLimits()
  if mapdata.ArbitraryScale then
    return 10, const.GameObjectMaxScale
  end
  local data = EntityData[self:GetEntity() or false]
  local limits = data and rawget(_G, "ArtSpecConfig") and ArtSpecConfig.ScaleLimits
  if limits then
    local cat, sub = data.editor_category, data.editor_subcategory
    local limits = cat and sub and limits[cat][sub] or cat and limits[cat]
    if limits then
      return limits[1], limits[2]
    end
  end
  return 10, 250
end
function CObject:GetMinScale()
  return self:GetScaleLimits()
end
function CObject:GetMaxScale()
  return select(2, self:GetScaleLimits())
end
function CObject:SetScaleClamped(scale)
  self:SetScale(Clamp(scale, self:GetScaleLimits()))
end
function CObject:GetEnumFlagsProp()
  return self:GetEnumFlags()
end
function CObject:SetEnumFlagsProp(val)
  self:SetEnumFlags(val)
  self:ClearEnumFlags(bnot(val))
end
function CObject:GetGameFlagsProp()
  return self:GetGameFlags()
end
local gofDetailClass0, gofDetailClass1 = const.gofDetailClass0, const.gofDetailClass1
local gofDetailClassMask = const.gofDetailClassMask
local s_DetailsValue = {
  Default = const.gofDetailClassDefaultMask,
  Essential = const.gofDetailClassEssential,
  Optional = const.gofDetailClassOptional,
  ["Eye Candy"] = const.gofDetailClassEyeCandy
}
local s_DetailsName = {}
for name, value in pairs(s_DetailsValue) do
  s_DetailsName[value] = name
end
function GetDetailClassMaskName(mask)
  return s_DetailsName[mask]
end
function CObject:SetGameFlagsProp(val)
  self:SetGameFlags(val)
  self:ClearGameFlags(bnot(val))
  self:SetDetailClass(s_DetailsName[val & gofDetailClassMask])
end
function CObject:GetClassFlagsProp()
  return self:GetClassFlags()
end
function CObject:GetComponentFlagsProp()
  return self:GetComponentFlags()
end
function CObject:GetEnumFlagsProp()
  return self:GetEnumFlags()
end
function CObject:GetSurfacesProp()
  return GetSurfacesMask(self)
end
function CObject:GetDetailClass()
  return IsValid(self) and s_DetailsName[self:GetGameFlags(gofDetailClassMask)] or s_DetailsName[0]
end
function CObject:SetDetailClass(details)
  self.DetailClass = details
  local value = s_DetailsValue[details]
  if band(value, gofDetailClass0) ~= 0 then
    self:SetGameFlags(gofDetailClass0)
  else
    self:ClearGameFlags(gofDetailClass0)
  end
  if band(value, gofDetailClass1) ~= 0 then
    self:SetGameFlags(gofDetailClass1)
  else
    self:ClearGameFlags(gofDetailClass1)
  end
end
function CObject:SetShadowOnly(bSet, time)
  if not time or IsEditorActive() then
    time = 0
  end
  if bSet then
    self:SetHierarchyGameFlags(const.gofSolidShadow)
    self:SetOpacity(0, time)
  else
    self:ClearHierarchyGameFlags(const.gofSolidShadow)
    self:SetOpacity(100, time)
  end
end
function CObject:SetGamma(value)
  local saturation = GetAlpha(self:GetSatGamma())
  self:SetSatGamma(SetA(value, saturation))
end
function CObject:GetGamma()
  return SetA(self:GetSatGamma(), 255)
end
function CObject:SetSaturation(value)
  local old = self:GetSatGamma()
  self:SetSatGamma(SetA(old, value))
end
function CObject:GetSaturation()
  return GetAlpha(self:GetSatGamma())
end
function CObject:OnEditorSetProperty(prop_id, old_value, ged, multi)
  ColorizableObject.OnEditorSetProperty(self, prop_id, old_value, ged, multi)
  if (prop_id == "Saturation" or prop_id == "Gamma") and hr.UseSatGammaModifier == 0 then
    hr.UseSatGammaModifier = 1
    RecreateRenderObjects()
  elseif prop_id == "LowerLOD" then
    if self:IsKindOf("AutoAttachObject") then
      self:SetAutoAttachMode(self:GetAutoAttachMode())
    end
  elseif prop_id == "SIModulation" then
    local prop_meta = self:GetPropertyMetadata(prop_id)
    self.SIModulationManual = self:GetProperty(prop_id) ~= prop_meta.default
  end
end
if FirstLoad then
  ObjectsShownOnPreSave = false
end
function OnMsg.PreSaveMap()
  ObjectsShownOnPreSave = {}
  MapForEach("map", "CObject", function(o)
    if o:GetGameFlags(const.gofSolidShadow) ~= 0 and not IsKindOf(o, "Decal") then
      ObjectsShownOnPreSave[o] = o:GetOpacity()
      o:SetOpacity(100)
    elseif o:GetEnumFlags(const.efVisible) == 0 then
      local skip = not IsKindOf(o, "EditorVisibleObject") and const.SlabSizeX and IsKindOf(o, "Slab")
      if not skip then
        ObjectsShownOnPreSave[o] = true
        o:SetEnumFlags(const.efVisible)
      end
    end
  end)
end
function OnMsg.PostSaveMap()
  for o, opacity in pairs(ObjectsShownOnPreSave) do
    if IsValid(o) then
      if type(opacity) == "number" then
        o:SetOpacity(opacity)
      else
        o:ClearEnumFlags(const.efVisible)
      end
    end
  end
  ObjectsShownOnPreSave = false
end
function CObject:GetOnCollisionWithCamera()
  local become_transparent_default = GetClassEnumFlags(self.class, const.efCameraMakeTransparent) ~= 0
  local repulse_camera_default = GetClassEnumFlags(self.class, const.efCameraRepulse) ~= 0
  local become_transparent = self:GetEnumFlags(const.efCameraMakeTransparent) ~= 0
  local repulse_camera = self:GetEnumFlags(const.efCameraRepulse) ~= 0
  if become_transparent_default == become_transparent and repulse_camera_default == repulse_camera then
    return false
  end
  if repulse_camera and not become_transparent then
    return "repulse camera"
  end
  if become_transparent and not repulse_camera then
    return "become transparent"
  end
  if become_transparent and repulse_camera then
    return "repulse camera & become transparent"
  end
  return "no action"
end
function CObject:SetOnCollisionWithCamera(value)
  local cmt, cr
  if value then
    local flags = OCCtoFlags[value]
    cmt = flags and flags.efCameraMakeTransparent
    cr = flags and flags.efCameraRepulse
  end
  if cmt == nil then
    cmt = GetClassEnumFlags(self.class, const.efCameraMakeTransparent) ~= 0
  end
  if cmt then
    self:SetEnumFlags(const.efCameraMakeTransparent)
  else
    self:ClearEnumFlags(const.efCameraMakeTransparent)
  end
  if cr == nil then
    cr = GetClassEnumFlags(self.class, const.efCameraRepulse) ~= 0
  end
  if cr then
    self:SetEnumFlags(const.efCameraRepulse)
  else
    self:ClearEnumFlags(const.efCameraRepulse)
  end
end
function CObject:GetCollectionName()
  local col = self:GetCollection()
  return col and col.Name or ""
end
function CObject:SetCollectionName(name)
  local col = CollectionsByName[name]
  local prev_col = self:GetCollection()
  if prev_col ~= col then
    self:SetCollection(col)
  end
end
function CObject:GetEditorRelatedObjects()
end
function CObject:GetEditorParentObject()
end
function CObject:GetMaterialType()
  return self.material_type
end
for name, value in pairs(g_CObjectFuncs) do
  CObject[name] = value
end
MapVar("__cobjectToCObject", {}, weak_keyvalues_meta)
MapVar("DeletedCObjects", {}, weak_keyvalues_meta)
function CreateLuaObject(luaobj)
  return luaobj.new(getmetatable(luaobj), luaobj)
end
local __PlaceObject = __PlaceObject
function CObject.new(class, luaobj, components)
  if luaobj and luaobj[true] then
    return luaobj
  end
  local cobject = __PlaceObject(class.class, components)
  if luaobj then
    luaobj[true] = cobject
  else
    luaobj = {
      [true] = cobject
    }
  end
  __cobjectToCObject[cobject] = luaobj
  setmetatable(luaobj, class)
  return luaobj
end
function CObject:delete(fromC)
  if not self[true] then
    return
  end
  self:RemoveLuaReference()
  self:SetCollectionIndex(0)
  DeletedCObjects[self] = true
  if not fromC then
    __DestroyObject(self)
  end
  __cobjectToCObject[self[true]] = nil
  self[true] = false
end
function CObject:GetCollection()
  local idx = self:GetCollectionIndex()
  return idx ~= 0 and Collections[idx] or false
end
function CObject:GetRootCollection()
  local idx = Collection.GetRoot(self:GetCollectionIndex())
  return idx ~= 0 and Collections[idx] or false
end
function CObject:SetCollection(collection)
  return self:SetCollectionIndex(collection and collection.Index or false)
end
function CObject:GetVisible()
  return self:GetEnumFlags(efVisible) ~= 0
end
function CObject:SetVisible(value)
  if value then
    self:SetEnumFlags(efVisible)
  else
    self:ClearEnumFlags(efVisible)
  end
end
function CObject:GetWarped()
  return self:GetGameFlags(gofWarped) ~= 0
end
function CObject:SetWarped(value)
  if value then
    self:SetGameFlags(gofWarped)
  else
    self:ClearGameFlags(gofWarped)
  end
end
function IsBeingDestructed(obj)
  return DeletedCObjects[obj]
end
function CObject:SetRealtimeAnim(bRealtime)
  if bRealtime then
    self:SetHierarchyGameFlags(const.gofRealTimeAnim)
  else
    self:ClearHierarchyGameFlags(const.gofRealTimeAnim)
  end
end
function CObject:GetRealtimeAnim()
  return self:GetGameFlags(const.gofRealTimeAnim) ~= 0
end
MapVar("Groups", {})
local find = table.find
local remove_entry = table.remove_entry
function CObject:AddToGroup(group_name)
  local group = Groups[group_name]
  if not group then
    group = {}
    Groups[group_name] = group
  end
  if not find(group, self) then
    group[#group + 1] = self
    self.Groups = self.Groups or {}
    self.Groups[#self.Groups + 1] = group_name
  end
end
function CObject:IsInGroup(group_name)
  return find(self.Groups, group_name)
end
function CObject:RemoveFromGroup(group_name)
  remove_entry(Groups[group_name], self)
  remove_entry(self.Groups, group_name)
end
function CObject:RemoveFromAllGroups()
  local Groups = Groups
  for i, group_name in ipairs(self.Groups) do
    remove_entry(Groups[group_name], self)
  end
  self.Groups = nil
end
RecursiveCallMethods.RemoveLuaReference = "procall_parents_last"
CObject.RemoveLuaReference = CObject.RemoveFromAllGroups
function CObject:SetGroups(groups)
  for _, group in ipairs(self.Groups or empty_table) do
    if not find(groups or empty_table, group) then
      self:RemoveFromGroup(group)
    end
  end
  for _, group in ipairs(groups or empty_table) do
    if not find(self.Groups or empty_table, group) then
      self:AddToGroup(group)
    end
  end
end
function CObject:GetRandomSpotAsync(type)
  return self:GetRandomSpot(type)
end
function CObject:GetRandomSpotPosAsync(type)
  return self:GetRandomSpotPos(type)
end
function CObject:NetState()
  return false
end
function CObject:GetWalkable()
  return self:GetEnumFlags(const.efWalkable) ~= 0
end
function CObject:SetWalkable(walkable)
  if walkable then
    self:SetEnumFlags(const.efWalkable)
  else
    self:ClearEnumFlags(const.efWalkable)
  end
end
function CObject:GetCollision()
  return self:GetEnumFlags(const.efCollision) ~= 0
end
function CObject:SetCollision(value)
  if value then
    self:SetEnumFlags(const.efCollision)
  else
    self:ClearEnumFlags(const.efCollision)
  end
end
function CObject:GetApplyToGrids()
  return self:GetEnumFlags(const.efApplyToGrids) ~= 0
end
function CObject:SetApplyToGrids(value)
  if not not value == self:GetApplyToGrids() then
    return
  end
  if value then
    self:SetEnumFlags(const.efApplyToGrids)
  else
    self:ClearEnumFlags(const.efApplyToGrids)
  end
  self:InvalidateSurfaces()
end
function CObject:GetIgnoreHeightSurfaces()
  return self:GetGameFlags(const.gofIgnoreHeightSurfaces) ~= 0
end
function CObject:SetIgnoreHeightSurfaces(value)
  if not not value == self:GetIgnoreHeightSurfaces() then
    return
  end
  if value then
    self:SetGameFlags(const.gofIgnoreHeightSurfaces)
  else
    self:ClearGameFlags(const.gofIgnoreHeightSurfaces)
  end
  self:InvalidateSurfaces()
end
function CObject:IsValidEntity()
  return IsValidEntity(self:GetEntity())
end
function CObject:GetSunShadow()
  return self:GetEnumFlags(const.efSunShadow) ~= 0
end
function CObject:SetSunShadow(sunshadow)
  if sunshadow then
    self:SetEnumFlags(const.efSunShadow)
  else
    self:ClearEnumFlags(const.efSunShadow)
  end
end
function CObject:GetCastShadow()
  return self:GetEnumFlags(const.efShadow) ~= 0
end
function CObject:SetCastShadow(shadow)
  if shadow then
    self:SetEnumFlags(const.efShadow)
  else
    self:ClearEnumFlags(const.efShadow)
  end
end
function CObject:GetOnRoof()
  return self:GetGameFlags(const.gofOnRoof) ~= 0
end
function CObject:SetOnRoof(on_roof)
  if on_roof then
    self:SetGameFlags(const.gofOnRoof)
  else
    self:ClearGameFlags(const.gofOnRoof)
  end
end
if const.SlabSizeX then
  function CObject:GetDontHideWithRoom()
    return self:GetGameFlags(const.gofDontHideWithRoom) ~= 0
  end
  function CObject:SetDontHideWithRoom(val)
    if val then
      self:SetGameFlags(const.gofDontHideWithRoom)
    else
      self:ClearGameFlags(const.gofDontHideWithRoom)
    end
  end
end
function CObject:GetLODsCount()
  local entity = self:GetEntity()
  return entity ~= "" and GetStateLODCount(entity, self:GetState()) or 1
end
function CObject:GetLowerLOD()
  return self:GetGameFlags(const.gofLowerLOD) ~= 0
end
function CObject:SetLowerLOD(lower_lod)
  if lower_lod then
    self:SetGameFlags(const.gofLowerLOD)
  else
    self:ClearGameFlags(const.gofLowerLOD)
  end
  self:UpdateForcedLOD()
end
function CObject:UpdateForcedLOD()
  if not CObject.SetForcedLOD then
    return
  end
  if self:GetLowerLOD() then
    local lods = self:GetLODsCount()
    local lowest_lod = 1 < lods and lods - 1 or -1
    self:SetForcedLOD(lowest_lod)
  else
    self:SetForcedLOD(-1)
  end
end
function CObject:GetDefaultPropertyValue(prop, prop_meta)
  if prop == "ApplyToGrids" then
    return GetClassEnumFlags(self.class, const.efApplyToGrids) ~= 0
  elseif prop == "Collision" then
    return GetClassEnumFlags(self.class, const.efCollision) ~= 0
  elseif prop == "Walkable" then
    return GetClassEnumFlags(self.class, const.efWalkable) ~= 0
  elseif prop == "DetailClass" then
    local details_mask = GetClassGameFlags(self.class, gofDetailClassMask)
    return GetDetailClassMaskName(details_mask)
  end
  return PropertyObject.GetDefaultPropertyValue(self, prop, prop_meta)
end
function CObject:ChooseValidState(state, next_state, ...)
  if next_state == nil then
    return state
  end
  if state and self:HasState(state) and not self:IsErrorState(state) then
    return state
  end
  return self:ChooseValidState(next_state, ...)
end
function CObject:GetStatesTextTable(category)
  local entity = IsValid(self) and self:GetEntity()
  if not IsValidEntity(entity) then
    return {}
  end
  local states = category and GetStatesFromCategory(entity, category) or self:GetStates()
  local i = 1
  while i <= #states do
    local state = states[i]
    if string.starts_with(state, "_") then
      table.remove(states, i)
    else
      if self:IsErrorState(GetStateIdx(state)) then
        states[i] = state .. " *"
      end
      i = i + 1
    end
  end
  table.sort(states)
  return states
end
function CObject:SetStateText(value, ...)
  if value:sub(-1, -1) == "*" then
    value = value:sub(1, -3)
  end
  if not self:HasState(value) then
    StoreErrorSource(self, "Missing object state " .. self:GetEntity() .. "." .. value)
  else
    self:SetState(value, ...)
  end
end
function CObject:GetStateText()
  return GetStateName(self)
end
function CObject:OnPropEditorOpen()
  self:SetRealtimeAnim(true)
end
function CObject:AttachText(text, spot)
  local obj = PlaceObject("Text")
  obj:SetText(text)
  if spot == nil then
    spot = self:GetSpotBeginIndex("Origin")
  end
  self:Attach(obj, spot)
  return obj
end
function CObject:AttachUpdatingText(f, spot)
  local obj = PlaceObject("Text")
  CreateRealTimeThread(function()
    while IsValid(obj) do
      local text, sleep = f(obj)
      obj:SetText(text or "")
      Sleep((sleep or 900) + AsyncRand(200))
    end
  end)
  if spot == nil then
    spot = self:GetSpotBeginIndex("Origin")
  end
  self:Attach(obj, spot)
  return obj
end
function CObject:Notify(method)
  Notify(self, method)
end
if Platform.editor then
  function EditorCanPlace(class_name)
    local class = g_Classes[class_name]
    return class and class:EditorCanPlace()
  end
  function CObject:EditorCanPlace()
    return IsValidEntity(self:GetEntity())
  end
end
CObject.GetObjectBySpot = empty_func
function CObject:ShowSpots(spot_type, annotation, show_spot_idx)
  if not self:HasEntity() then
    return
  end
  local start_id, end_id = self:GetAllSpots(self:GetState())
  local scale = Max(1, DivRound(10000, self:GetScale()))
  for i = start_id, end_id do
    local spot_name = GetSpotNameByType(self:GetSpotsType(i))
    if not spot_type or string.find(spot_name, spot_type) then
      local spot_annotation = self:GetSpotAnnotation(i)
      if not annotation or string.find(spot_annotation, annotation) then
        local text_obj = Text:new({editor_ignore = true})
        local text_str = self:GetSpotName(i)
        if show_spot_idx then
          text_str = i .. "." .. text_str
        end
        if spot_annotation then
          text_str = text_str .. ";" .. spot_annotation
        end
        text_obj:SetText(text_str)
        self:Attach(text_obj, i)
        local orientation_obj = CreateOrientationMesh()
        orientation_obj.editor_ignore = true
        orientation_obj:SetScale(scale)
        self:Attach(orientation_obj, i)
      end
    end
  end
end
function CObject:HideSpots()
  if not self:HasEntity() then
    return
  end
  self:DestroyAttaches("Text")
  self:DestroyAttaches("Mesh")
end
ObjectSurfaceColors = {
  ApplyToGrids = red,
  Build = purple,
  ClearRoad = white,
  Collision = green,
  Flat = const.clrGray,
  Height = cyan,
  HexShape = yellow,
  Road = black,
  Selection = blue,
  Terrain = RGBA(255, 0, 0, 128),
  TerrainHole = magenta,
  Walk = const.clrPink
}
MapVar("ObjToShownSurfaces", {}, weak_keys_meta)
MapVar("TurnedOffObjSurfaces", {})
function CObject:ShowSurfaces()
  local entity = self:GetEntity()
  if not entity then
    return
  end
  local entry = ObjToShownSurfaces[self]
  for stype, flag in pairs(EntitySurfaces) do
    if HasAnySurfaces(entity, EntitySurfaces[stype]) and stype ~= "All" and stype ~= "AllPass" and stype ~= "AllPassAndWalk" and not TurnedOffObjSurfaces[stype] and (not entry or not entry[stype]) then
      local color1 = ObjectSurfaceColors[stype] or RandColor(xxhash(stype))
      local color2 = InterpolateRGB(color1, black, 1, 2)
      local mesh = CreateObjSurfaceMesh(self, flag, color1, color2)
      mesh:SetOpacity(75)
      entry = table.create_set(entry, stype, mesh)
    end
  end
  ObjToShownSurfaces[self] = entry or empty_table
  OpenDialog("ObjSurfacesLegend")
end
function CObject:HideSurfaces()
  for stype, mesh in pairs(ObjToShownSurfaces[self]) do
    DoneObject(mesh)
  end
  ObjToShownSurfaces[self] = nil
  if not next(ObjToShownSurfaces) then
    CloseDialog("ObjSurfacesLegend")
  end
end
function OnMsg.LoadGame()
  if next(ObjToShownSurfaces) then
    OpenDialog("ObjSurfacesLegend")
  end
end
function CObject:GedTreeViewFormat()
  if IsValid(self) then
    local label = self:GetProperty("EditorLabel") or self.class
    local value = self:GetProperty("Name") or self:GetProperty("ParticlesName")
    local tname = value and (IsT(value) and _InternalTranslate(value) or type(value) == "string" and value) or ""
    if 0 < #tname then
      label = label .. " - " .. tname
    end
    return label
  end
end
function CObject:GedTreeChildren()
  local ret = IsValid(self) and self:GetAttaches() or empty_table
  return table.ifilter(ret, function(k, v)
    return not rawget(v, "editor_ignore")
  end)
end
function GetEntityAnimMoments(entity, anim, moment_type)
  local anim_entity = GetAnimEntity(entity, anim)
  local preset_group = anim_entity and Presets.AnimMetadata[anim_entity]
  local preset_anim = preset_group and preset_group[anim]
  local moments = preset_anim and preset_anim.Moments
  if moments and moment_type then
    moments = table.ifilter(moments, function(_, m, moment_type)
      return m.Type == moment_type
    end, moment_type)
  end
  return moments or empty_table
end
local GetEntityAnimMoments = GetEntityAnimMoments
function CObject:GetAnimMoments(anim, moment_type)
  return GetEntityAnimMoments(self:GetEntity(), anim or self:GetStateText(), moment_type)
end
local AnimSpeedScale = const.AnimSpeedScale
local AnimSpeedScale2 = AnimSpeedScale * AnimSpeedScale
function CObject:IterateMoments(anim, phase, moment_index, moment_type, reversed, looping, moments, duration)
  moments = moments or self:GetAnimMoments(anim)
  local count = #moments
  if count == 0 or moment_index <= 0 then
    return false, -1
  end
  duration = duration or GetAnimDuration(self:GetEntity(), anim)
  local count_down = moment_index
  local next_loop
  if not reversed then
    local time = -phase
    local idx = 1
    while true do
      if count < idx then
        if not looping then
          return false, -1
        end
        idx = 1
        time = time + duration
        if count_down == moment_index and duration < time then
          return false, -1
        end
        next_loop = true
      end
      local moment = moments[idx]
      if (not moment_type or moment_type == moment.Type) and 0 <= time + moment.Time then
        if count_down == 1 then
          return moment.Type, time + Min(duration - 1, moment.Time), moment, next_loop
        end
        count_down = count_down - 1
      end
      idx = idx + 1
    end
  else
    local time = phase - duration
    local idx = count
    while true do
      if idx == 0 then
        if not looping then
          return false, -1
        end
        idx = count
        time = time + duration
        if count_down == moment_index and duration < time then
          return false, -1
        end
        next_loop = true
      end
      local moment = moments[idx]
      if (not moment_type or moment_type == moment.Type) and 0 <= time + duration - moment.Time then
        if count_down == 1 then
          return moment.Type, time + duration - moment.Time, moment, next_loop
        end
        count_down = count_down - 1
      end
      idx = idx - 1
    end
  end
end
function CObject:GetChannelData(channel, moment_index)
  local reversed = self:IsAnimReversed(channel)
  if moment_index < 1 then
    reversed = not reversed
    moment_index = -moment_index
  end
  local looping = self:IsAnimLooping(channel)
  local anim = GetStateName(self:GetAnim(channel))
  local phase = self:GetAnimPhase(channel)
  return anim, phase, moment_index, reversed, looping
end
local ComputeTimeTo = function(anim_time, combined_speed, looping)
  if combined_speed == AnimSpeedScale2 then
    return anim_time
  end
  if combined_speed == 0 then
    return max_int
  end
  local time = anim_time * AnimSpeedScale2 / combined_speed
  if time == 0 and anim_time ~= 0 and looping then
    return 1
  end
  return time
end
function CObject:TimeToMoment(channel, moment_type, moment_index)
  if moment_index == nil and type(channel) == "string" then
    channel, moment_type, moment_index = 1, channel, moment_type
  end
  local anim, phase, index, reversed, looping = self:GetChannelData(channel, moment_index or 1)
  local _, anim_time = self:IterateMoments(anim, phase, index, moment_type, reversed, looping)
  if anim_time == -1 then
    return
  end
  local combined_speed = self:GetAnimSpeed(channel) * self:GetAnimSpeedModifier()
  return ComputeTimeTo(anim_time, combined_speed, looping)
end
function CObject:OnAnimMoment(moment, anim, remaining_duration, moment_counter, loop_counter)
  PlayFX(FXAnimToAction(anim), moment, self)
end
function CObject:PlayTimedMomentTrackedAnim(state, duration)
  return self:WaitMomentTrackedAnim(state, nil, nil, nil, nil, nil, duration)
end
function CObject:PlayAnimWithCallback(state, moment, callback, ...)
  return self:WaitMomentTrackedAnim(state, nil, nil, nil, nil, nil, nil, moment, callback, ...)
end
function CObject:PlayMomentTrackedAnim(state, count, flags, crossfade, duration, moment, callback, ...)
  return self:WaitMomentTrackedAnim(state, nil, nil, count, flags, crossfade, duration, moment, callback, ...)
end
function CObject:WaitMomentTrackedAnim(state, wait_func, wait_param, count, flags, crossfade, duration, moment, callback, ...)
  if not IsValid(self) then
    return "invalid"
  end
  if (state or "") ~= "" then
    if not self:HasState(state) then
      GameTestsError("once", "Missing animation:", self:GetEntity() .. "." .. state)
      duration = duration or 1000
    else
      self:SetState(state, flags or 0, crossfade or -1)
      local anim_duration = self:GetAnimDuration()
      if anim_duration == 0 then
        GameTestsError("once", "Zero length animation:", self:GetEntity() .. "." .. state)
        duration = duration or 1000
      else
        local channel = 1
        duration = duration or (count or 1) * anim_duration
        local moments = self:GetAnimMoments(state)
        local moment_count = table.count(moments, "Type", moment)
        if moment and callback and moment_count ~= 1 then
          StoreErrorSource(self, "The callback is supposed to be called once for animation", state, "but there are", moment_count, "moments with the name", moment)
        end
        local anim, phase, count_down, reversed, looping = self:GetChannelData(channel, 1)
        local moment_counter, loop_counter = 0, 0
        while 0 < duration do
          if not IsValid(self) then
            return "invalid"
          end
          local moment_type, time, moment_descr, next_loop = self:TimeToNextMoment(channel, count_down, anim, phase, reversed, looping, moments, anim_duration)
          local sleep_time
          if not time or time == -1 then
            sleep_time = duration
          else
            sleep_time = Min(duration, time)
          end
          if not wait_func then
            Sleep(sleep_time)
          elseif wait_func(wait_param, sleep_time) then
            return "msg"
          end
          if not IsValid(self) then
            return "invalid"
          end
          duration = duration - sleep_time
          if sleep_time == time and (duration ~= 0 or not next_loop) then
            moment_counter = moment_counter + 1
            if next_loop then
              loop_counter = loop_counter + 1
            end
            if self:OnAnimMoment(moment_type, anim, duration, moment_counter, loop_counter) == "break" then
              return "break"
            end
            if callback then
              if not moment then
                if callback(moment_type, ...) == "break" then
                  return "break"
                end
              elseif moment == moment_type then
                if callback(...) == "break" then
                  return "break"
                end
                callback = nil
              end
            end
          end
          phase = nil
          count_down = 2
        end
      end
    end
  end
  if duration and 0 < duration then
    if not wait_func then
      Sleep(duration)
    elseif wait_func(wait_param, duration) then
      return "msg"
    end
  end
  if callback and moment then
    callback(...)
  end
end
function CObject:PlayTransitionAnim(anim, moment, callback, ...)
  return self:ExecuteWeakUninterruptable(self.PlayAnimWithCallback, anim, moment, callback, ...)
end
function CObject:TimeToNextMoment(channel, index, anim, phase, reversed, looping, moments, duration)
  anim = anim or GetStateName(self:GetAnim(channel))
  phase = phase or self:GetAnimPhase(channel)
  if reversed == nil then
    reversed = self:IsAnimReversed(channel)
  end
  if looping == nil then
    looping = self:IsAnimLooping(channel)
  end
  if index < 1 then
    reversed = not reversed
    index = -index
  end
  local moment_type, anim_time, moment_descr, next_loop = self:IterateMoments(anim, phase, index, nil, reversed, looping, moments, duration)
  if anim_time == -1 then
    return
  end
  local combined_speed = self:GetAnimSpeed(channel) * self:GetAnimSpeedModifier()
  local time = ComputeTimeTo(anim_time, combined_speed, looping)
  return moment_type, time, moment_descr, next_loop
end
function CObject:TypeOfMoment(channel, moment_index)
  local anim, phase, index, reversed, looping = self:GetChannelData(channel, moment_index or 1)
  return self:IterateMoments(anim, phase, index, false, reversed, looping)
end
function CObject:GetAnimMoment(anim, moment_type, moment_index, raise_error)
  local _, anim_time = self:IterateMoments(anim, 0, moment_index or 1, moment_type, false, self:IsAnimLooping())
  if anim_time ~= -1 then
    return anim_time
  end
  if not raise_error then
    return
  end
  return self:GetAnimDuration(anim)
end
function CObject:GetAnimMomentType(anim, moment_index)
  local moment_type = self:IterateMoments(anim, 0, moment_index or 1, false, false, self:IsAnimLooping())
  if not moment_type or moment_type == "" then
    return
  end
  return moment_type
end
function CObject:GetAnimMomentsCount(anim, moment_type)
  return #self:GetAnimMoments(anim, moment_type)
end
function GetStateMoments(entity, anim)
  local moments = {}
  for idx, moment in ipairs(GetEntityAnimMoments(entity, anim)) do
    moments[idx] = {
      type = moment.Type,
      time = moment.Time
    }
  end
  return moments
end
function GetStateMomentsNames(entity, anim)
  if not IsValidEntity(entity) or GetStateIdx(anim) == -1 then
    return empty_table
  end
  local moments = {}
  for idx, moment in ipairs(GetEntityAnimMoments(entity, anim)) do
    moments[moment.Type] = true
  end
  return table.keys(moments, true)
end
function GetEntityDefaultAnimMetadata()
  local entityDefaultAnimMetadata = {}
  for name, entity_data in pairs(EntityData) do
    if entity_data.anim_components then
      local anim_components = table.map(entity_data.anim_components, function(t)
        return AnimComponentWeight:new(t)
      end)
      local animMetadata = AnimMetadata:new({
        id = "__default__",
        group = name,
        AnimComponents = anim_components
      })
      entityDefaultAnimMetadata[name] = {__default__ = animMetadata}
    end
  end
  return entityDefaultAnimMetadata
end
local ReloadAnimData = function()
  ReloadAnimComponentDefs(AnimComponents)
  ClearAnimMetaData()
  LoadAnimMetaData(Presets.AnimMetadata)
  LoadAnimMetaData(GetEntityDefaultAnimMetadata())
  local speed_scale = const.AnimSpeedScale
  for _, entity_meta in ipairs(Presets.AnimMetadata) do
    for _, anim_meta in ipairs(entity_meta) do
      local speed_modifier = anim_meta.SpeedModifier * speed_scale / 100
      SetStateSpeedModifier(anim_meta.group, GetStateIdx(anim_meta.id), speed_modifier)
    end
  end
end
OnMsg.DataLoaded = ReloadAnimData
OnMsg.DataReloadDone = ReloadAnimData
function OnMsg.PresetSave(className)
  local class = _G[className]
  if IsKindOf(class, "AnimComponent") or IsKindOf(class, "AnimMetadata") then
    ReloadAnimData()
  end
end
if FirstLoad then
  g_DevTestState = {
    thread = false,
    obj = false,
    start_pos = false,
    start_axis = false,
    start_angle = false
  }
end
function CObject:BtnTestState(main, prop_id, ged, no_compensate)
  self:TestState(nil, no_compensate)
end
function CObject:BtnTestOnce(main, prop_id, ged, no_compensate)
  self:TestState(1, no_compensate)
end
function CObject:BtnTestLoop(main, prop_id, ged, no_compensate)
  self:TestState(10000000000, no_compensate)
end
function CObject:TestState(rep, ignore_compensation)
  if not IsEditorActive() then
    print("Available in editor only")
  end
  if g_DevTestState.thread then
    DeleteThread(g_DevTestState.thread)
  end
  if g_DevTestState.obj ~= self then
    g_DevTestState.start_pos = self:GetVisualPos()
    g_DevTestState.start_angle = self:GetVisualAngle()
    g_DevTestState.start_axis = self:GetVisualAxis()
    g_DevTestState.obj = self
  end
  g_DevTestState.thread = CreateRealTimeThread(function(self, rep, ignore_compensation)
    local start_pos = g_DevTestState.start_pos
    local start_angle = g_DevTestState.start_angle
    local start_axis = g_DevTestState.start_axis
    self:SetAnim(1, self:GetState(), 0, 0)
    local duration = self:GetAnimDuration()
    if duration == 0 then
      return
    end
    local state = self:GetState()
    local step_axis, step_angle
    if not ignore_compensation then
      step_axis, step_angle = self:GetStepAxisAngle()
    end
    local rep = rep or 5
    for i = 1, rep do
      if not (IsValid(self) and IsEditorActive()) or self:GetState() ~= state then
        break
      end
      self:SetAnim(1, state, const.eDontLoop, 0)
      self:SetPos(start_pos)
      self:SetAxisAngle(start_axis, start_angle)
      if ignore_compensation then
        Sleep(duration)
      else
        local parts = 2
        for i = 1, parts do
          local start_time = MulDivRound(i - 1, duration, parts)
          local end_time = MulDivRound(i, duration, parts)
          local part_duration = end_time - start_time
          local part_step_vector = self:GetStepVector(state, start_angle, start_time, part_duration)
          self:SetPos(self:GetPos() + part_step_vector, part_duration)
          local part_rot_angle = MulDivRound(i, step_angle, parts) - MulDivRound(i - 1, step_angle, parts)
          self:Rotate(step_axis, part_rot_angle, part_duration)
          Sleep(part_duration)
          if not (IsValid(self) and IsEditorActive()) or self:GetState() ~= state then
            break
          end
        end
      end
      Sleep(400)
      if not (IsValid(self) and IsEditorActive()) or self:GetState() ~= state then
        break
      end
      self:SetPos(start_pos)
      self:SetAxisAngle(start_axis, start_angle)
      Sleep(400)
    end
    g_DevTestState.obj = false
  end, self, rep, ignore_compensation)
end
function CObject:SetColorFromTextStyle(id)
  self.textstyle_id = id
  local color = TextStyles[id].TextColor
  local _, _, _, opacity = GetRGBA(color)
  self:SetColorModifier(color)
  self:SetOpacity(opacity)
end
function CObject:SetContourRecursive(visible, id)
  if not IsValid(self) or IsBeingDestructed(self) then
    return
  end
  if visible then
    self:SetContourOuterID(true, id)
    self:ForEachAttach(function(attach)
      attach:SetContourRecursive(true, id)
    end)
  else
    self:SetContourOuterID(false, id)
    self:ForEachAttach(function(attach)
      attach:SetContourRecursive(false, id)
    end)
  end
end
function CObject:SetUnderConstructionRecursive(data)
  if not IsValid(self) or IsBeingDestructed(self) then
    return
  end
  self:SetUnderConstruction(data)
  self:ForEachAttach(function(attach)
    attach:SetUnderConstructionRecursive(data)
  end)
end
function CObject:SetContourOuterOccludeRecursive(set)
  if not IsValid(self) or IsBeingDestructed(self) then
    return
  end
  self:SetContourOuterOcclude(set)
  self:ForEachAttach(function(attach)
    attach:SetContourOuterOccludeRecursive(set)
  end)
end
function CObject:GetError()
  if not IsValid(self) then
    return
  end
  local parent = self:GetParent()
  if const.maxCollidersPerObject > 0 and not parent and self:GetEnumFlags(const.efCollision) ~= 0 and collision.GetFirstCollisionMask(self) then
    local detail_class = self:GetDetailClass()
    if detail_class == "Default" then
      local entity = self:GetEntity()
      local entity_data = EntityData[entity]
      detail_class = entity and entity_data and entity_data.entity.DetailClass or "Essential"
    end
    if detail_class ~= "Essential" then
      return "Object with colliders is not declared 'Essential'"
    end
  end
  if not parent then
    local col = self:GetCollectionIndex()
    if 0 < col and not Collections[col] then
      self:SetCollectionIndex(0)
      return string.format("Missing collection object for index %s", col)
    end
  end
end
RecursiveCallMethods.OnHoverStart = true
CObject.OnHoverStart = empty_func
RecursiveCallMethods.OnHoverUpdate = true
CObject.OnHoverUpdate = empty_func
RecursiveCallMethods.OnHoverEnd = true
CObject.OnHoverEnd = empty_func
MapVar("ContourReasons", false)
function SetContourReason(obj, contour, reason)
  if not ContourReasons then
    ContourReasons = setmetatable({}, weak_keys_meta)
  end
  local countours = ContourReasons[obj]
  if not countours then
    countours = {}
    ContourReasons[obj] = countours
  end
  local reasons = countours[contour]
  if reasons then
    reasons[reason] = true
    return
  end
  obj:SetContourRecursive(true, contour)
  countours[contour] = {
    [reason] = true
  }
end
function ClearContourReason(obj, contour, reason)
  local countours = (ContourReasons or empty_table)[obj]
  local reasons = countours and countours[contour]
  if not reasons or not reasons[reason] then
    return
  end
  reasons[reason] = nil
  if not next(reasons) then
    obj:SetContourRecursive(false, contour)
    countours[contour] = nil
    if not next(countours) then
      ContourReasons[obj] = nil
    end
  end
end
function GetGroup(name)
  local list = {}
  local group = Groups[name]
  if not group then
    return list
  end
  for i = 1, #group do
    local obj = group[i]
    if IsValid(obj) then
      list[#list + 1] = obj
    end
  end
  return list
end
function GetGroupRef(name)
  return Groups[name]
end
function GroupExists(name)
  return not not Groups[name]
end
function GetGroupNames()
  local group_names = {}
  for group, _ in pairs(Groups) do
    table.insert(group_names, group)
  end
  table.sort(group_names)
  return group_names
end
function GroupNamesWithSpace()
  local group_names = {}
  for group, _ in pairs(Groups) do
    group_names[#group_names + 1] = " " .. group
  end
  table.sort(group_names)
  return group_names
end
function SpawnGroup(name, pos, filter_func)
  local list = {}
  local templates = MapFilter(GetGroup(name, true), "map", "Template", filter_func)
  if 0 < #templates then
    local center = AveragePoint(templates)
    if pos then
      center, pos = pos, (pos - center):SetInvalidZ()
    end
    for _, obj in ipairs(templates) do
      local spawned = obj:Spawn()
      if spawned then
        if pos then
          spawned:SetPos(obj:GetPos() + pos)
        end
        list[#list + 1] = spawned
      end
    end
  end
  return list
end
function SpawnGroupOverTime(name, pos, filter, time)
  local list = {}
  local templates = MapFilter(GetGroup(name, true), "map", "Template", filter_func)
  local times, sum = {}, 0
  for i = 1, #templates do
    if templates[i]:ShouldSpawn() then
      local rand = AsyncRand(1000)
      times[i] = rand
      sum = sum + rand
    else
      times[i] = false
    end
  end
  for i, obj in ipairs(templates) do
    if times[i] then
      local spawned_obj = obj:Spawn()
      if spawned_obj then
        list[#list + 1] = spawned_obj:SetPos(pos)
        Sleep(times[i] * time / sum)
      end
    end
  end
  return list
end
__enumflags = false
__classflags = false
__componentflags = false
__gameflags = false
function OnMsg.ClassesPostprocess()
  local asWalk = EntitySurfaces.Walk
  local efWalkable = const.efWalkable
  local asCollision = EntitySurfaces.Collision
  local efCollision = const.efCollision
  local asApplyToGrids = EntitySurfaces.ApplyToGrids
  local efApplyToGrids = const.efApplyToGrids
  local cmPassability = const.cmPassability
  local cmDefaultObject = const.cmDefaultObject
  __enumflags = FlagValuesTable("MapObject", "ef", function(name, flags)
    local class = g_Classes[name]
    local entity = class:GetEntity()
    if not class.variable_entity and IsValidEntity(entity) then
      if not HasAnySurfaces(entity, asWalk) then
        flags = FlagClear(flags, efWalkable)
      end
      if not HasAnySurfaces(entity, asCollision) and not HasMeshWithCollisionMask(entity, cmDefaultObject) then
        flags = FlagClear(flags, efCollision)
      end
      if not HasAnySurfaces(entity, asApplyToGrids) and not HasMeshWithCollisionMask(entity, cmPassability) then
        flags = FlagClear(flags, efApplyToGrids)
      end
      return flags
    end
  end)
  __gameflags = FlagValuesTable("MapObject", "gof")
  __classflags = FlagValuesTable("MapObject", "cf")
  __componentflags = FlagValuesTable("MapObject", "cof")
end
function OnMsg.ClassesBuilt()
  ClearStaticClasses()
  ReloadStaticClass("MapObject", g_Classes.MapObject)
  ClassDescendants("MapObject", ReloadStaticClass)
  __enumflags = nil
  __classflags = nil
  __componentflags = nil
  __gameflags = nil
end
function OnMsg.PostDoneMap()
  for cobject, obj in pairs(__cobjectToCObject or empty_table) do
    if obj then
      obj[true] = false
    end
  end
end
DefineClass.StripCObjectProperties = {
  __parents = {"CObject"},
  properties = {
    {
      id = "ColorizationPalette"
    },
    {
      id = "ClassFlagsProp"
    },
    {
      id = "ComponentFlagsProp"
    },
    {
      id = "EnumFlagsProp"
    },
    {
      id = "GameFlagsProp"
    },
    {
      id = "SurfacesProp"
    },
    {id = "Axis"},
    {id = "Opacity"},
    {
      id = "StateCategory"
    },
    {id = "StateText"},
    {id = "Mirrored"},
    {
      id = "ColorModifier"
    },
    {id = "Occludes"},
    {
      id = "ApplyToGrids"
    },
    {id = "Walkable"},
    {id = "Collision"},
    {
      id = "OnCollisionWithCamera"
    },
    {id = "Scale"},
    {
      id = "SIModulation"
    },
    {
      id = "AnimSpeedModifier"
    },
    {id = "Visible"},
    {id = "SunShadow"},
    {id = "CastShadow"},
    {id = "Entity"},
    {id = "Angle"},
    {id = "ForcedLOD"},
    {id = "Groups"},
    {
      id = "CollectionIndex"
    },
    {
      id = "CollectionName"
    },
    {id = "Warped"},
    {id = "SkewX"},
    {id = "SkewY"},
    {id = "ClipPlane"},
    {id = "Radius"},
    {id = "Sound"},
    {id = "OnRoof"},
    {
      id = "DontHideWithRoom"
    },
    {id = "Saturation"},
    {id = "Gamma"},
    {
      id = "DetailClass"
    },
    {id = "LowerLOD"},
    {
      id = "TestStateButtons"
    }
  }
}
for i = 1, const.MaxColorizationMaterials do
  table.iappend(StripCObjectProperties.properties, {
    {
      id = string.format("EditableColor%d", i)
    },
    {
      id = string.format("EditableRoughness%d", i)
    },
    {
      id = string.format("EditableMetallic%d", i)
    }
  })
end
function CObject:AsyncCheatSpots()
  ToggleSpotVisibility({self})
end
function CObject:CheatDelete()
  DoneObject(self)
end
function CObject:__MarkEntities(entities)
  if not IsValid(self) then
    return
  end
  entities[self:GetEntity()] = true
  for j = 1, self:GetNumAttaches() do
    local attach = self:GetAttach(j)
    attach:__MarkEntities(entities)
  end
end
function CObject:MarkAttachEntities(entities)
  entities = entities or {}
  self:__MarkEntities(entities)
  return entities
end
