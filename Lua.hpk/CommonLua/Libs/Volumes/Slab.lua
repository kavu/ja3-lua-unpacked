local default_color = RGB(100, 100, 100)
local voxelSizeX = const.SlabSizeX or 0
local voxelSizeY = const.SlabSizeY or 0
local voxelSizeZ = const.SlabSizeZ or 0
local halfVoxelSizeX = voxelSizeX / 2
local halfVoxelSizeY = voxelSizeY / 2
local halfVoxelSizeZ = voxelSizeZ / 2
local no_mat = const.SlabNoMaterial
local noneWallMat = no_mat
local gofPermanent = const.gofPermanent
local efVisible = const.efVisible
const.SuppressMultipleRoofEdges = true
DefineClass.Restrictor = {
  __parents = {"Object"},
  restriction_box = false
}
local iz = const.InvalidZ
function Restrictor:Restrict()
  local b = self.restriction_box
  if not b then
    return
  end
  local x, y, z = self:GetPosXYZ()
  x, y, z = self:RestrictXYZ(x, y, z)
  self:SetPos(x, y, z)
end
function Restrictor:RestrictXYZ(x, y, z)
  local b = self.restriction_box
  if not b then
    return x, y, z
  end
  local minx, miny, minz, maxx, maxy, maxz = b:xyzxyz()
  x = Clamp(x, minx, maxx)
  y = Clamp(y, miny, maxy)
  if z ~= iz and minz ~= iz and maxz ~= iz then
    z = Clamp(z, minz, maxz)
  end
  return x, y, z
end
DefineClass.WallAlignedObj = {
  __parents = {"AlignedObj"}
}
function WallAlignedObj:AlignObjAttached()
  local p = self:GetParent()
  local ap = self:GetPos() + self:GetAttachOffset()
  local x, y, z, angle = WallWorldToVoxel(ap, self:GetAngle())
  x, y, z = WallVoxelToWorld(x, y, z, angle)
  px, py, pz = p:GetPosXYZ()
  self:SetAttachOffset(x - px, y - py, z - pz)
  self:SetAngle(angle)
end
function WallAlignedObj:AlignObj(pos, angle)
  local x, y, z
  if pos then
    x, y, z, angle = WallWorldToVoxel(pos, angle or self:GetAngle())
  else
    x, y, z, angle = WallWorldToVoxel(self)
  end
  x, y, z = WallVoxelToWorld(x, y, z, angle)
  self:SetPosAngle(x, y, z, angle)
end
DefineClass.FloorAlignedObj = {
  __parents = {"AlignedObj"},
  GetGridCoords = rawget(_G, "WorldToVoxel")
}
function FloorAlignedObj:AlignObj(pos, angle)
  local x, y, z
  if pos then
    x, y, z, angle = WorldToVoxel(pos, angle or self:GetAngle())
  else
    x, y, z, angle = WorldToVoxel(self)
  end
  x, y, z = VoxelToWorld(x, y, z)
  self:SetPosAngle(x, y, z, angle)
end
DefineClass.CornerAlignedObj = {
  __parents = {"AlignedObj"}
}
function CornerAlignedObj:AlignObj(pos, angle)
  local x, y, z
  if pos then
    x, y, z, angle = CornerWorldToVoxel(pos, angle or self:GetAngle())
  else
    x, y, z, angle = CornerWorldToVoxel(self)
  end
  x, y, z = CornerVoxelToWorld(x, y, z, angle)
  self:SetPosAngle(x, y, z, angle)
end
DefineClass.GroundAlignedObj = {
  __parents = {"AlignedObj"},
  GetGridCoords = rawget(_G, "WorldToVoxel")
}
function GroundAlignedObj:AlignObj(pos, angle)
  local x, y, z
  if pos then
    x, y, z, angle = WorldToVoxel(pos, angle or self:GetAngle())
    if not pos:IsValidZ() then
      z = iz
    end
  else
    x, y, z, angle = WorldToVoxel(self)
    if not self:IsValidZ() then
      z = iz
    end
  end
  x, y, z = VoxelToWorld(x, y, z)
  self:SetPosAngle(x, y, z or iz, angle)
end
local FloorsComboItems = function()
  local items = {}
  for i = -5, 10 do
    items[#items + 1] = tostring(i)
  end
  return items
end
function SlabMaterialComboItems()
  return PresetGroupCombo("SlabPreset", Slab.MaterialListClass, Slab.MaterialListFilter)
end
DefineClass.CSlab = {
  __parents = {
    "EntityChangeKeepsFlags",
    "AlignedObj"
  },
  flags = {efBuilding = true},
  entity_base_name = "Slab",
  material = false,
  MaterialListClass = "SlabMaterials",
  MaterialListFilter = false,
  isVisible = true,
  always_visible = false,
  ApplyMaterialProps = empty_func,
  class_suppression_strenght = 0,
  variable_entity = true
}
function CSlab:GetBaseEntityName()
  return string.format("%s_%s", self.entity_base_name, self.material)
end
function CSlab:GetSeed(max, const)
  return BraidRandom(EncodeVoxelPos(self) + (const or 0), max)
end
function CSlab:ComposeEntityName()
  local base_entity = self:GetBaseEntityName()
  local material_preset = self:GetMaterialPreset()
  local subvariants = material_preset and material_preset.subvariants or empty_table
  if 0 < #subvariants then
    local seed = self:GetSeed()
    local remaining = subvariants
    while true do
      local subvariant, idx = table.weighted_rand(remaining, "chance", seed)
      if not subvariant then
        break
      end
      local entity = subvariant.suffix ~= "" and base_entity .. "_" .. subvariant.suffix or base_entity
      if IsValidEntity(entity) then
        return entity
      end
      remaining = remaining == subvariants and table.copy(subvariants) or remaining
      table.remove(remaining, idx)
    end
  end
  return IsValidEntity(base_entity) and base_entity or base_entity .. "_01"
end
function CSlab:UpdateEntity()
  local name = self:ComposeEntityName()
  if IsValidEntity(name) then
    self:ChangeEntity(name)
    self:ApplyMaterialProps()
  elseif self.material ~= no_mat then
    self:ReportMissingSlabEntity(name)
  end
end
if Platform.developer and config.NoPassEditsOnSlabEntityChange then
  function CSlab:ChangeEntity(entity, ...)
    DbgSetErrorOnPassEdit(self, "%s: Entity %s --> %s", self.class, self:GetEntity(), entity)
    EntityChangeKeepsFlags.ChangeEntity(self, entity, ...)
    DbgClearErrorOnPassEdit(self)
  end
end
function CSlab:GetArtMaterialPreset()
  return CObject.GetMaterialPreset(self)
end
function CSlab:GetMaterialPreset()
  local material_list = Presets.SlabPreset[self.MaterialListClass]
  return material_list and material_list[self.material]
end
function CSlab:SetSuppressor(suppressor, initiator, reason)
  reason = reason or "suppressed"
  if suppressor then
    self:TurnInvisible(reason)
  else
    self:TurnVisible(reason)
  end
  return true
end
function CSlab:ShouldUpdateEntity(agent)
  return true
end
function CSlab:TurnInvisible(reason)
  self:ClearHierarchyEnumFlags(const.efVisible)
end
function CSlab:TurnVisible(reason)
  self:SetHierarchyEnumFlags(const.efVisible)
end
function CSlab:GetMaterialType()
  local preset = self:GetMaterialPreset()
  return preset and preset.obj_material or self.material
end
local ListAddObj = function(list, obj)
  if not list[obj] then
    list[obj] = true
    list[#list + 1] = obj
  end
end
local ListForEach = function(list, func, ...)
  for _, obj in ipairs(list or empty_table) do
    if IsValid(obj) then
      procall(obj[func], obj)
    end
  end
end
local DelayedUpdateEntSlabs = {}
local DelayedUpdateVariantEntsSlabs = {}
local DelayedAlignObj = {}
function SlabUpdate()
  SuspendPassEdits("SlabUpdate", false)
  ListForEach(DelayedUpdateEntSlabs, "UpdateEntity")
  table.clear(DelayedUpdateEntSlabs)
  ListForEach(DelayedUpdateVariantEntsSlabs, "UpdateVariantEntities")
  table.clear(DelayedUpdateVariantEntsSlabs)
  ListForEach(DelayedAlignObj, "AlignObj")
  table.clear(DelayedAlignObj)
  ResumePassEdits("SlabUpdate")
end
local first = false
function OnMsg.NewMapLoaded()
  first = true
end
function DelayedSlabUpdate()
  Wakeup(PeriodicRepeatThreads.DelayedSlabUpdate)
end
DefineClass.SlabPropHolder = {
  __parents = {
    "PropertyObject"
  },
  properties = {
    {
      id = "colors",
      name = "Colors",
      editor = "nested_obj",
      base_class = "ColorizationPropSet",
      inclusive = true,
      default = false
    },
    {
      id = "interior_attach_colors",
      name = "Interior Attach Color",
      editor = "nested_obj",
      base_class = "ColorizationPropSet",
      inclusive = true,
      default = false,
      help = "Color of the interior attach for ExIn materials.",
      no_edit = function(self)
        return self.variant == "Outdoor"
      end
    },
    {
      id = "exterior_attach_colors",
      name = "Exterior Attach Color",
      editor = "nested_obj",
      base_class = "ColorizationPropSet",
      inclusive = true,
      default = false,
      help = "Color of the exterior attach for InIn materials.",
      no_edit = function(self)
        return self.variant == "Outdoor" or self.variant == "OutdoorIndoor"
      end
    },
    {
      name = "Subvariant",
      id = "subvariant",
      editor = "number",
      default = -1
    }
  }
}
DefineClass("SlabAutoResolve")
DefineClass.Slab = {
  __parents = {
    "CSlab",
    "Object",
    "DestroyableSlab",
    "HideOnFloorChange",
    "ComponentExtraTransform",
    "EditorSubVariantObject",
    "Mirrorable",
    "SlabAutoResolve"
  },
  flags = {
    gofPermanent = true,
    cofComponentColorizationMaterial = true,
    gofDetailClass0 = false,
    gofDetailClass1 = true
  },
  properties = {
    category = "Slabs",
    {
      id = "buttons",
      name = "Buttons",
      editor = "buttons",
      default = false,
      dont_save = true,
      read_only = true,
      sort_order = -1,
      buttons = {
        {
          name = "Select Parent Room",
          func = "SelectParentRoom"
        }
      }
    },
    {
      id = "material",
      name = "Material",
      editor = "preset_id",
      preset_class = "SlabPreset",
      preset_group = "SlabMaterials",
      extra_item = noneWallMat,
      default = "Planks"
    },
    {
      id = "variant",
      name = "Variant",
      editor = "dropdownlist",
      items = PresetGroupCombo("SlabPreset", "SlabVariants"),
      default = "Outdoor"
    },
    {
      id = "forceVariant",
      name = "Force Variant",
      editor = "dropdownlist",
      items = PresetGroupCombo("SlabPreset", "SlabVariants"),
      default = "",
      help = "Variants are picked automatically and settings to the variant prop are overriden by internal slab workings, use this prop to force this slab to this variant at all times."
    },
    {
      id = "indoor_material_1",
      name = "Indoor Material 1",
      editor = "dropdownlist",
      items = PresetGroupCombo("SlabPreset", "SlabIndoorMaterials", false, no_mat),
      default = no_mat,
      no_edit = function(self)
        return self.variant == "Outdoor"
      end
    },
    {
      id = "indoor_material_2",
      name = "Indoor Material 2",
      editor = "dropdownlist",
      items = PresetGroupCombo("SlabPreset", "SlabIndoorMaterials", false, no_mat),
      default = no_mat,
      no_edit = function(self)
        return self.variant == "Outdoor" or self.variant == "OutdoorIndoor"
      end
    },
    {
      id = "colors",
      name = "Colors",
      editor = "nested_obj",
      base_class = "ColorizationPropSet",
      inclusive = true,
      default = false
    },
    {
      id = "colors1",
      name = "Colors 1",
      editor = "nested_obj",
      base_class = "ColorizationPropSet",
      inclusive = true,
      default = false,
      help = "Color of mat1 attach.",
      no_edit = function(self)
        return self.variant == "Outdoor"
      end,
      dont_save = true,
      no_edit = true
    },
    {
      id = "interior_attach_colors",
      name = "Interior Attach Color",
      editor = "nested_obj",
      base_class = "ColorizationPropSet",
      inclusive = true,
      default = false,
      help = "Color of the interior attach for ExIn materials.",
      no_edit = function(self)
        return self.variant == "Outdoor"
      end
    },
    {
      id = "colors2",
      name = "Colors 2",
      editor = "nested_obj",
      base_class = "ColorizationPropSet",
      inclusive = true,
      default = false,
      help = "Color of mat2 attach",
      no_edit = function(self)
        return self.variant == "Outdoor" or self.variant == "OutdoorIndoor"
      end,
      dont_save = true,
      no_edit = true
    },
    {
      id = "exterior_attach_colors",
      name = "Exterior Attach Color",
      editor = "nested_obj",
      base_class = "ColorizationPropSet",
      inclusive = true,
      default = false,
      help = "Color of the exterior attach for InIn materials.",
      no_edit = function(self)
        return self.variant == "Outdoor" or self.variant == "OutdoorIndoor"
      end
    },
    {id = "Walkable"},
    {
      id = "ApplyToGrids"
    },
    {id = "Collision"},
    {
      id = "always_visible",
      name = "Always Visible",
      editor = "bool",
      help = "Ignores room slab logic for making slabs invisible. Only implemented for walls, other types upon request.",
      default = false
    },
    {
      id = "ColorModifier",
      dont_save = true,
      read_only = true
    },
    {
      id = "forceInvulnerableBecauseOfGameRules",
      name = "Invulnerable",
      editor = "bool",
      default = true,
      help = "In context of destruction."
    }
  },
  entity_base_name = "Slab",
  GetGridCoords = rawget(_G, "WorldToVoxel"),
  variant_objects = false,
  isVisible = true,
  invisible_reasons = false,
  room = false,
  side = false,
  floor = 1,
  collision_allowed_mask = 0,
  colors_room_member = "outer_colors",
  room_container_name = false,
  invulnerable = true,
  subvariants_table_id = "subvariants",
  bad_entity = false,
  exterior_attach_colors_from_nbr = false
}
function Slab:IsInvulnerable()
  return self.invulnerable or TemporarilyInvulnerableObjs[self]
end
function Slab:GetColorsRoomMember()
  return self.colors_room_member
end
function SetupObjInvulnerabilityColorMarkingOnValueChanged(o)
end
function Slab:SetforceInvulnerableBecauseOfGameRules(val)
  self.forceInvulnerableBecauseOfGameRules = val
  self.invulnerable = val
  SetupObjInvulnerabilityColorMarkingOnValueChanged(self)
end
function Slab:GetEntitySubvariant()
  local e = self:GetEntity()
  local strs = string.split(e, "_")
  return tonumber(strs[#strs])
end
function Slab:SelectParentRoom()
  if IsValid(self.room) then
    editor.ClearSel()
    editor.AddToSel({
      self.room
    })
  else
    print("This slab has no room.")
  end
end
function Slab:Init()
  if IsValid(self.room) then
    self:SetWarped(self.room:GetWarped())
  end
end
function Slab:GameInit()
  self:UpdateSimMaterialId()
end
function Slab:OnEditorSetProperty(prop_id, old_value, ged)
  if prop_id == "material" or prop_id == "variant" then
    self.subvariant = -1
  end
  if prop_id == "forceVariant" then
    self.variant = self.forceVariant
    self:DelayedUpdateEntity()
    self:DelayedUpdateVariantEntities()
  end
end
function Slab:SetWarped(val)
  if val then
    self:SetHierarchyGameFlags(const.gofWarped)
  else
    self:ClearHierarchyGameFlags(const.gofWarped)
  end
end
function Slab:UpdateSimMaterialId()
end
function Slab:Setmaterial(val)
  self.material = val
  self:UpdateSimMaterialId()
end
function Slab:Setvariant(val)
  self.variant = val
end
function SlabAutoResolve:SelectionPropagate()
  return self.room
end
function SlabAutoResolve:CompleteElementConstruction()
  self:UpdateSimMaterialId()
end
function Slab:Setroom(val)
  self.room = val
  self:DelayedUpdateEntity()
end
function Slab:GetDefaultColor()
  local member = self:GetColorsRoomMember()
  return member and table.get(self.room, member) or false
end
function Slab:Setcolors(val)
  local def_color = self:GetDefaultColor()
  if not val or val == empty_table or val == ColorizationPropSet then
    val = def_color
  end
  self.colors = val ~= def_color and val:Clone() or nil
  self:SetColorization(val)
  SetSlabColorHelper(self, val)
end
function Slab:Setinterior_attach_colors(val)
  local def_color = self.room and self.room.inner_colors or false
  if not val or val == empty_table or val == ColorizationPropSet then
    val = def_color
  end
  self.interior_attach_colors = val ~= def_color and val:Clone() or nil
  if self.variant_objects and self.variant_objects[1] then
    SetSlabColorHelper(self.variant_objects[1], val)
  end
end
function Slab:GetExteriorAttachColor()
  return self.exterior_attach_colors or self.exterior_attach_colors_from_nbr or self.colors or self:GetDefaultColor()
end
function Slab:Setexterior_attach_colors_from_nbr(val)
  if val == empty_table then
    val = false
  end
  if val and (not self.exterior_attach_colors_from_nbr or not rawequal(self.exterior_attach_colors_from_nbr, val)) then
    val = val:Clone()
  end
  self.exterior_attach_colors_from_nbr = val
  if self.variant_objects and self.variant_objects[2] then
    SetSlabColorHelper(self.variant_objects[2], self:GetExteriorAttachColor())
  end
end
function Slab:Setexterior_attach_colors(val)
  if val == empty_table then
    val = false
  end
  if val and (not self.exterior_attach_colors or not rawequal(self.exterior_attach_colors, val)) then
    val = val:Clone()
  end
  self.exterior_attach_colors = val
  if self.variant_objects and self.variant_objects[2] then
    SetSlabColorHelper(self.variant_objects[2], self:GetExteriorAttachColor())
  end
end
function Slab:CanMirror()
  return true
end
local invisible_mask = const.cmDynInvisible & ~const.cmVisibility
function Slab:TurnInvisible(reason)
  self.invisible_reasons = table.create_set(self.invisible_reasons, reason, true)
  if self.isVisible or self:GetEnumFlags(efVisible) ~= 0 then
    self.isVisible = false
    local mask = collision.GetAllowedMask(self)
    self.collision_allowed_mask = mask ~= 0 and mask or nil
    self:ClearHierarchyEnumFlags(efVisible)
    collision.SetAllowedMask(self, invisible_mask)
  end
end
function Slab:TurnVisible(reason)
  local invisible_reasons = self.invisible_reasons
  if reason and invisible_reasons then
    invisible_reasons[reason] = nil
  end
  if not next(invisible_reasons) and not self.isVisible then
    self.isVisible = nil
    self:SetHierarchyEnumFlags(efVisible)
    collision.SetAllowedMask(self, self.collision_allowed_mask)
    self.collision_allowed_mask = nil
    self.invisible_reasons = nil
  end
end
local sx, sy, sz = const.SlabSizeX or guim, const.SlabSizeY or guim, const.SlabSizeZ or guim
local slabgroupop_lastObjs = false
local slabgroupop_lastRealTime = false
local slab_group_op_done = function(objs)
  local rt = RealTime()
  if objs == slabgroupop_lastObjs and slabgroupop_lastRealTime and slabgroupop_lastRealTime == rt then
    return true
  end
  slabgroupop_lastObjs = objs
  slabgroupop_lastRealTime = rt
  return false
end
local slab_sides = {
  "N",
  "W",
  "S",
  "E"
}
local slab_coord_limit = shift(1, 20)
local slab_hash = function(x, y, z, side)
  local s = table.find(slab_sides, side) or 0
  return x + shift(y, 20) + shift(z, 40) + shift(s, 60)
end
function Slab:SetHeatMaterialIndex(matIndex)
  self:SetCustomData(9, matIndex)
end
function Slab:GetHeatMaterialIndex()
  return self:GetCustomData(9)
end
function Slab:RemoveDuplicates()
  local is_permanent = self:GetGameFlags(gofPermanent) ~= 0
  local gameFlags = is_permanent and gofPermanent or nil
  MapDelete(self, 0, self.class, nil, nil, gameFlags, function(o, self, is_permanent)
    return obj ~= self and (is_permanent or o:GetGameFlags(gofPermanent) == 0) and self:IsSameLocation(obj)
  end, self, is_permanent)
end
function Slab:EditorCallbackPlace(reason)
  if reason == "paste" or reason == "clone" then
    return
  end
  local x, y, z = self:GetPosXYZ()
  local surfz = terrain.GetHeight(x, y)
  z = z or surfz + voxelSizeZ - 1
  while surfz > z do
    z = z + sz
  end
  self:AlignObj(point(x, y, z))
  self:UpdateEntity()
end
function Slab:IsSameLocation(obj)
  local x1, y1, z1 = self:GetPosXYZ()
  local x2, y2, z2 = obj:GetPosXYZ()
  return x1 == x2 and y1 == y2 and z1 == z2
end
function Slab:GetWorldBBox()
  return GetSlabWorldBBox(self:GetPos(), 1, 1, self:GetAngle())
end
function Slab:GetSeed(max, const)
  return BraidRandom(EncodeVoxelPos(self) + (IsValid(self.room) and self.room.seed or 0) + (const or 0), max)
end
local cached_totals = {}
local ClearCachedTotals = function()
  cached_totals = {}
end
OnMsg.DoneMap = ClearCachedTotals
OnMsg.DataReload = ClearCachedTotals
OnMsg.PresetSave = ClearCachedTotals
function GetMaterialSubvariants(svd, subvariants_id)
  if not svd then
    return false, 0
  end
  local subvariants = not subvariants_id and svd.subvariants or subvariants_id and svd:HasMember(subvariants_id) and svd[subvariants_id]
  local key = xxhash(svd.class, svd.id, subvariants_id or "")
  local total = cached_totals[key]
  if not total then
    total = 0
    for i = 1, #(subvariants or empty_table) do
      total = total + subvariants[i].chance
    end
    cached_totals[key] = total
  end
  return subvariants, total
end
function Slab:Setsubvariant(val)
  EditorSubVariantObject.Setsubvariant(self, val)
  self:DelayedUpdateEntity()
end
function Slab:ResetSubvariant()
  EditorSubVariantObject.ResetSubvariant(self, val)
  self:UpdateEntity()
end
variantToVariantName = {
  OutdoorIndoor = "ExIn",
  IndoorIndoor = "InIn",
  Outdoor = "ExEx"
}
function Slab:GetBaseEntityName()
  return string.format("%sExt_%s_Wall_%s", self.entity_base_name, self.material, variantToVariantName[self.variant])
end
function GetRandomSubvariantEntity(random, subvariants, get_ent_func, ...)
  local t = 0
  for i = 1, #subvariants do
    t = t + subvariants[i].chance
    if i == #subvariants or random < t then
      local ret = get_ent_func(subvariants[i].suffix, ...)
      while 1 < i and not IsValidEntity(ret) do
        i = i - 1
        ret = (0 < subvariants[i].chance or i == 1) and get_ent_func(subvariants[i].suffix, ...) or false
      end
      return ret, subvariants[i].suffix
    end
  end
end
function Slab:GetSubvariantDigitStr(subvariants)
  local digit = self.subvariant
  if digit == -1 then
    return "01"
  end
  if subvariants then
    digit = (digit - 1) % #subvariants + 1
  end
  return digit < 10 and "0" .. tostring(digit) or tostring(digit)
end
function Slab:ComposeEntityName()
  local material_list = Presets.SlabPreset[self.MaterialListClass]
  local svd = material_list and material_list[self.material]
  local svdId = self.subvariants_table_id
  local baseEntity = self:GetBaseEntityName()
  if svd and svd[svdId] and 0 < #svd[svdId] then
    local subvariants, total = GetMaterialSubvariants(svd, svdId)
    if self.subvariant ~= -1 then
      local digitStr = self:GetSubvariantDigitStr()
      local ret = string.format("%s_%s", baseEntity, digitStr)
      if not IsValidEntity(ret) then
        print("Reverting slab [" .. self.handle .. "] subvariant [" .. self.subvariant .. "] because no entity [" .. ret .. "] found. The slab has a subvariant set by the user (level-designer) which produces an invalid entity, this subvariant will be reverted back to a random subvariant. Re-saving the map will save the removed set subvariant and this message will no longer appear.")
        ret = false
        self.subvariant = -1
      else
        return ret
      end
    end
    return GetRandomSubvariantEntity(self:GetSeed(total), subvariants, function(suffix, baseEntity)
      return string.format("%s_%s", baseEntity, suffix)
    end, baseEntity)
  else
    local digitStr = self:GetSubvariantDigitStr()
    local ent = string.format("%s_%s", baseEntity, digitStr)
    return IsValidEntity(ent) and ent or baseEntity
  end
end
function Slab:ComposeIndoorMaterialEntityName(mat)
  if self.destroyed_neighbours ~= 0 and self.destroyed_entity_side ~= 0 or self.is_destroyed and self.diagonal_ent_mask ~= 0 then
    return self:ComposeBrokenIndoorMaterialEntityName(mat)
  end
  local svd = (Presets.SlabPreset.SlabIndoorMaterials or empty_table)[mat]
  if svd and svd.subvariants and 0 < #svd.subvariants then
    local subvariants, total = GetMaterialSubvariants(svd)
    return GetRandomSubvariantEntity(self:GetSeed(total), subvariants, function(suffix, mat)
      return string.format("WallInt_%s_Wall_%s", mat, suffix)
    end, mat)
  else
    return string.format("WallInt_%s_Wall_01", mat)
  end
end
function SetSlabColorHelper(obj, colors)
  if obj:GetMaxColorizationMaterials() > 0 then
    obj:SetColorModifier(RGB(100, 100, 100))
    colors = colors or obj:GetDefaultColorizationSet()
    obj:SetColorization(colors, "ignore_his_max")
  else
    local color1 = (colors or ColorizationPropSet):GetEditableColor1()
    local r, g, b = GetRGB(color1)
    obj:SetColorModifier(RGB(r / 2, g / 2, b / 2))
  end
end
function Slab:ShouldUseRoomMirroring()
  return true
end
function Slab:MirroringFromRoom()
  if not IsValid(self.room) then
    return
  end
  if not self:ShouldUseRoomMirroring() then
    return
  end
  local mirror = self:CanMirror() and self:GetSeed(100, 115249) < 50
  self:SetMirrored(mirror)
  if mirror then
    for _, interior in ipairs(self.variant_objects or empty_table) do
      interior:SetMirrored(true)
    end
  end
end
function Slab:DelayedUpdateEntity()
  ListAddObj(DelayedUpdateEntSlabs, self)
  DelayedSlabUpdate()
end
function Slab:DelayedUpdateVariantEntities()
  ListAddObj(DelayedUpdateVariantEntsSlabs, self)
  DelayedSlabUpdate()
end
function Slab:DelayedAlignObj()
  ListAddObj(DelayedAlignObj, self)
  DelayedSlabUpdate()
end
function Slab:ForEachDestroyedAttach(f, ...)
  for k, v in pairs(rawget(self, "destroyed_attaches") or empty_table) do
    if IsValid(v) then
      f(v, ...)
    elseif type(v) == "table" then
      for i = 1, #v do
        local vi = v[i]
        if IsValid(vi) then
          f(vi, ...)
        end
      end
    end
  end
end
function Slab:RefreshColors()
  local clrs = self.colors or self:GetDefaultColor()
  SetSlabColorHelper(self, clrs)
  self:ForEachDestroyedAttach(function(v, clrs)
    SetSlabColorHelper(v, clrs)
  end, clrs)
end
function Slab:DestroyAttaches(...)
  Object.DestroyAttaches(self, ...)
  self.variant_objects = nil
end
function Slab:UpdateDestroyedState()
  return false
end
function Slab:GetSubvariantFromEntity(e)
  e = e or self:GetEntity()
  local strs = string.split(e, "_")
  return tonumber(strs[#strs]) or 1
end
function Slab:LockSubvariantToCurrentEntSubvariant()
  local e = self:GetEntity()
  if IsValidEntity(e) and e ~= "InvisibleObject" then
    self.subvariant = self:GetSubvariantFromEntity(e)
  end
end
function Slab:LockRandomSubvariantToCurrentEntSubvariant()
  if self.subvariant ~= -1 then
    return
  end
  self:LockSubvariantToCurrentEntSubvariant()
end
function Slab:UnlockSubvariant()
  self.subvariant = -1
end
function Slab:SetVisible(value)
  Object.SetVisible(self, value)
  if value then
    self:TurnVisible("SetVisible")
  else
    self:TurnInvisible("SetVisible")
  end
end
function Slab:ResetVisibilityFlags()
  if self.isVisible then
    self:SetHierarchyEnumFlags(const.efVisible)
  else
    self:ClearHierarchyEnumFlags(const.efVisible)
  end
end
function Slab:UpdateEntity()
  self.bad_entity = nil
  if self.destroyed_neighbours ~= 0 or self.is_destroyed then
    if self:UpdateDestroyedState() then
      return
    end
  elseif self.destroyed_entity_side ~= 0 then
    self.destroyed_entity_side = 0
    self.destroyed_entity = false
    self:RestorePreDestructionSubvariant()
  end
  local name = self:ComposeEntityName()
  if name == self:GetEntity() then
    self:UpdateSimMaterialId()
    self:MirroringFromRoom()
  elseif IsValidEntity(name) then
    self:UpdateSimMaterialId()
    self:ChangeEntity(name, "idle")
    self:MirroringFromRoom()
    self:RefreshColors()
    self:ApplyMaterialProps()
    self:ResetVisibilityFlags()
    if Platform.developer and IsEditorActive() and selo() == self then
      ObjModified(self)
    end
  elseif self.material ~= no_mat then
    self:ReportMissingSlabEntity(name)
  end
end
DefineClass.SlabInteriorObject = {
  __parents = {
    "Object",
    "ComponentAttach"
  },
  flags = {
    efCollision = false,
    efApplyToGrids = false,
    cofComponentColorizationMaterial = true
  }
}
function Slab:UpdateVariantEntities()
end
function Slab:SetProperty(id, value)
  EditorCallbackObject.SetProperty(self, id, value)
  if id == "material" then
    self:DelayedUpdateEntity()
  elseif id == "entity" or id == "variant" or id == "indoor_material_1" or id == "indoor_material_2" then
    self:DelayedUpdateEntity()
    self:DelayedUpdateVariantEntities()
  end
end
function Slab:GetContainerInRoom()
  local r = self.room
  local n = self.room_container_name
  if n and IsValid(r) then
    return r[n][self.side] or r[n]
  end
end
function Slab:RemoveFromRoomContainer()
  local t = self:GetContainerInRoom()
  if t then
    local idx = table.find(t, self)
    if idx then
      t[idx] = false
    end
  end
end
function Slab:EditorCallbackDelete()
  self:RemoveFromRoomContainer()
end
function Slab:GetEditorParentObject()
  return self.room
end
DefineClass.FloorSlab = {
  __parents = {
    "Slab",
    "FloorAlignedObj",
    "DestroyableFloorSlab"
  },
  flags = {efPathSlab = true},
  properties = {
    category = "Slabs",
    {
      id = "material",
      name = "Material",
      editor = "preset_id",
      preset_class = "SlabPreset",
      preset_group = "FloorSlabMaterials",
      extra_item = noneWallMat,
      default = "Planks"
    },
    {
      id = "variant",
      name = "Variant",
      editor = "dropdownlist",
      items = PresetGroupCombo("SlabPreset", "SlabVariants"),
      default = "",
      no_edit = true
    }
  },
  entity = "Floor_Planks",
  entity_base_name = "Floor",
  MaterialListClass = "FloorSlabMaterials",
  colors_room_member = "floor_colors",
  room_container_name = "spawned_floors"
}
FloorSlab.MirroringFromRoom = empty_func
function FloorSlab:CanMirror()
  return false
end
function FloorSlab:GetBaseEntityName()
  return string.format("%s_%s", self.entity_base_name, self.material)
end
DefineClass.CeilingSlab = {
  __parents = {
    "Slab",
    "FloorAlignedObj",
    "DestroyableFloorSlab"
  },
  flags = {
    efWalkable = false,
    efCollision = false,
    efApplyToGrids = false,
    efPathSlab = false
  },
  properties = {
    category = "Slabs",
    {
      id = "material",
      name = "Material",
      editor = "preset_id",
      preset_class = "SlabPreset",
      preset_group = "FloorSlabMaterials",
      extra_item = noneWallMat,
      default = "Planks"
    },
    {
      id = "forceInvulnerableBecauseOfGameRules",
      name = "Invulnerable",
      editor = "bool",
      default = false,
      help = "In context of destruction."
    }
  },
  entity = "Floor_Planks",
  entity_base_name = "Floor",
  MaterialListClass = "FloorSlabMaterials",
  room_container_name = "roof_objs",
  class_suppression_strenght = -10
}
function CeilingSlab:GetBaseEntityName()
  return string.format("%s_%s", self.entity_base_name, self.material)
end
DefineClass.BaseWallSlab = {
  __parents = {"CSlab"}
}
DefineClass.WallSlab = {
  __parents = {
    "Slab",
    "BaseWallSlab",
    "WallAlignedObj",
    "ComponentAttach"
  },
  entity_base_name = "Wall",
  wall_obj = false,
  GetGridCoords = rawget(_G, "WallWorldToVoxel"),
  room_container_name = "spawned_walls",
  class_suppression_strenght = 100
}
function WallSlab:UpdateVariantEntities()
  if self.variant == "Outdoor" or self.is_destroyed and self.diagonal_ent_mask == 0 then
    DoneObjects(self.variant_objects)
    self.variant_objects = nil
  elseif self.variant == "OutdoorIndoor" then
    if not self.variant_objects then
      local o1 = PlaceObject("SlabInteriorObject")
      self:Attach(o1)
      o1:SetAttachAngle(10800)
      self.variant_objects = {o1}
    else
      DoneObject(self.variant_objects[2])
      self.variant_objects[2] = nil
    end
    if IsValid(self.variant_objects[1]) then
      local e = self:ComposeIndoorMaterialEntityName(self.indoor_material_1)
      if self.variant_objects[1]:GetEntity() ~= e then
        self.variant_objects[1]:ChangeEntity(e)
      end
      self:Setinterior_attach_colors(not self.interior_attach_colors and self.room and self.room.inner_colors)
    end
  elseif self.variant == "IndoorIndoor" then
    if not self.variant_objects then
      local o1 = PlaceObject("SlabInteriorObject")
      self:Attach(o1)
      o1:SetAttachAngle(10800)
      self.variant_objects = {o1}
    end
    if not IsValid(self.variant_objects[2]) then
      local o1 = PlaceObject("SlabInteriorObject")
      self:Attach(o1)
      self.variant_objects[2] = o1
    end
    if IsValid(self.variant_objects[1]) then
      local e = self:ComposeIndoorMaterialEntityName(self.indoor_material_1)
      if self.variant_objects[1]:GetEntity() ~= e then
        self.variant_objects[1]:ChangeEntity(e)
      end
      self:Setinterior_attach_colors(not self.interior_attach_colors and self.room and self.room.inner_colors)
    end
    if IsValid(self.variant_objects[2]) then
      local e = self:ComposeIndoorMaterialEntityName(self.indoor_material_2)
      if self.variant_objects[2]:GetEntity() ~= e then
        self.variant_objects[2]:ChangeEntity(e)
      end
      SetSlabColorHelper(self.variant_objects[2], self:GetExteriorAttachColor())
    end
  end
  self:SetWarped(IsValid(self.room) and self.room:GetWarped() or self:GetWarped())
end
function WallSlab:RefreshColors()
  local clrs = self.colors or self:GetDefaultColor()
  local iclrs = not self.interior_attach_colors and self.room and self.room.inner_colors
  SetSlabColorHelper(self, clrs)
  self:ForEachDestroyedAttach(function(v, clrs, self)
    SetSlabColorHelper(v, clrs)
    local atts = v:GetAttaches()
    for i = 1, #(atts or "") do
      local a = atts[i]
      if not rawget(a, "editor_ignore") then
        local angle = a:GetAttachAngle()
        if angle == 0 then
          SetSlabColorHelper(a, self:GetExteriorAttachColor())
        else
          SetSlabColorHelper(a, iclrs)
        end
      end
    end
  end, clrs, self)
  if self.variant_objects then
    if self.variant_objects[1] then
      SetSlabColorHelper(self.variant_objects[1], not self.interior_attach_colors and self.room and self.room.inner_colors)
    end
    if self.variant_objects[2] then
      SetSlabColorHelper(self.variant_objects[2], self:GetExteriorAttachColor())
    end
  end
end
function WallSlab:EditorCallbackPlace(reason)
  Slab.EditorCallbackPlace(self, reason)
  if not self.room then
    self.always_visible = true
  end
end
WallSlab.EditorCallbackPlaceCursor = WallSlab.EditorCallbackPlace
function WallSlab:SetWallObj(obj)
  self.wall_obj = obj
  if self.always_visible then
    return
  end
  return self:SetSuppressor(obj, nil, "wall_obj")
end
function WallSlab:SetWallObjShadowOnly(shadow_only, clear_contour)
  local wall_obj = self.wall_obj
  if wall_obj then
    if (const.cmtVisible and not CMT_IsObjVisible(wall_obj)) ~= shadow_only then
      wall_obj:SetShadowOnly(shadow_only)
    end
    if wall_obj.main_wall == self then
      wall_obj:SetManagedSlabsShadowOnly(shadow_only, clear_contour)
    end
  end
end
function WallSlab:EditorCallbackDelete()
  Slab.EditorCallbackDelete(self)
  if IsValid(self.wall_obj) and self.wall_obj.main_wall == self then
    DoneObject(self.wall_obj)
  end
end
function WallSlab:GetSide(angle)
  angle = angle or self:GetAngle()
  if angle == 0 then
    return "E"
  elseif angle == 5400 then
    return "S"
  elseif angle == 10800 then
    return "W"
  else
    return "N"
  end
end
function WallSlab:IsSameLocation(obj)
  local x1, y1, z1 = self:GetPosXYZ()
  local x2, y2, z2 = obj:GetPosXYZ()
  local side1 = self:GetSide()
  local side2 = obj:GetSide()
  return x1 == x2 and y1 == y2 and z1 == z2 and side1 == side2
end
function WallSlab:ExtendWalls(objs)
  local visited, topmost = {}, {}
  for _, obj in ipairs(objs) do
    local gx, gy, gz = obj:GetGridCoords()
    local side = obj:GetSide()
    local loc = slab_hash(gx, gy, 0, side)
    if not visited[loc] then
      visited[loc] = true
      local idx = #topmost + 1
      topmost[idx] = obj
      while true do
        local wall = GetWallSlab(gx, gy, gz + 1, side)
        if IsValid(wall) then
          gz = gz + 1
          topmost[idx] = wall
        else
          break
        end
      end
    end
  end
  for _, obj in ipairs(topmost) do
    local gx, gy, gz = obj:GetGridCoords()
    SlabsPushUp(gx, gy, gz + 1)
  end
  for _, obj in ipairs(topmost) do
    local x, y, z = obj:GetPosXYZ()
    local wall = WallSlab:new()
    wall:SetPosAngle(x, y, z + sz, obj:GetAngle())
    wall:EditorCallbackClone(obj)
    wall:AlignObj()
    wall:UpdateEntity()
  end
end
DefineClass.StairSlab = {
  __parents = {
    "Slab",
    "FloorAlignedObj"
  },
  flags = {efPathSlab = true},
  properties = {
    {
      category = "Slabs",
      id = "material",
      name = "Material",
      editor = "preset_id",
      preset_class = "SlabPreset",
      preset_group = "StairsSlabMaterials",
      extra_item = noneWallMat,
      default = "WoodScaff"
    },
    {
      category = "Slab Tools",
      id = "autobuild_stair_up",
      editor = "buttons",
      buttons = {
        {name = "Extend Up", func = "UIExtendUp"}
      },
      default = false,
      dont_save = true
    },
    {
      category = "Slab Tools",
      id = "autobuild_stair_down",
      editor = "buttons",
      buttons = {
        {
          name = "Extend Down",
          func = "UIExtendDown"
        }
      },
      default = false,
      dont_save = true
    },
    {
      name = "Subvariant",
      id = "subvariant",
      editor = "number",
      default = 1,
      buttons = {
        {
          name = "Next",
          func = "CycleEntityBtn"
        }
      }
    },
    {id = "variant"},
    {
      id = "always_visible"
    },
    {
      id = "forceInvulnerableBecauseOfGameRules",
      name = "Invulnerable",
      editor = "bool",
      default = true,
      help = "In context of destruction.",
      dont_save = true,
      no_edit = true
    }
  },
  entity = "Stairs_WoodScaff_01",
  entity_base_name = "Stairs",
  MaterialListClass = "StairsSlabMaterials",
  hide_floor_slabs_above_in_range = 2
}
function StairSlab:IsInvulnerable()
  return true
end
function StairSlab:GetBaseEntityName()
  return string.format("%s_%s", self.entity_base_name, self.material)
end
function StairSlab:GetStepZ()
  return GetStairsStepZ(self)
end
function StairSlab:GetExitOffset()
  local dx, dy
  local angle = self:GetAngle()
  if angle == 0 then
    dx, dy = 0, 1
  elseif angle == 5400 then
    dx, dy = -1, 0
  elseif angle == 10800 then
    dx, dy = 0, -1
  else
    dx, dy = 1, 0
  end
  return dx, dy, 1
end
function StairSlab:TraceConnectedStairs(zdir)
  local first, last
  local dx, dy = self:GetExitOffset()
  local angle = self:GetAngle()
  dx, dy = dx * zdir, dy * zdir
  local all = {}
  local gx, gy, gz = self:GetGridCoords()
  local step = 1
  while true do
    local obj = GetStairSlab(gx + step * dx, gy + step * dy, gz + step * zdir)
    if IsValid(obj) and obj:GetAngle() == angle and obj.floor == self.floor then
      first = first or obj
      last = obj
      all[step] = obj
      step = step + 1
    else
      break
    end
  end
  return first, last, all
end
function StairSlab:UIExtendUp(parent, prop_id, ged)
  if slab_group_op_done(parent or {self}) then
    return
  end
  local first, last = self:TraceConnectedStairs(1)
  local obj = last or self
  local x, y, z = obj:GetGridCoords()
  local dx, dy, dz = obj:GetExitOffset()
  local floor = GetFloorSlab(x + dx, y + dy, z + dz)
  if IsValid(floor) then
    print("Can't extend the stairs upward, floor tile is in the way")
    return
  end
  x, y, z = obj:GetPosXYZ()
  local stair = StairSlab:new({
    material = self.material,
    subvariant = self.subvariant
  })
  stair:SetPosAngle(x + dx * sx, y + dy * sy, z + dz * sz, obj:GetAngle())
  stair:EditorCallbackClone(self)
  stair:UpdateEntity()
  self:AlignObj()
  self:UpdateEntity()
end
function StairSlab:UIExtendDown(parent, prop_id, ged)
  if slab_group_op_done(parent or {self}) then
    return
  end
  local first, last = self:TraceConnectedStairs(-1)
  local obj = last or self
  local x, y, z = obj:GetGridCoords()
  local dx, dy, dz = obj:GetExitOffset()
  local floor = GetFloorSlab(x, y, z)
  if IsValid(floor) then
    print("Can't extend the stairs upward, floor tile is in the way")
    return
  end
  x, y, z = obj:GetPosXYZ()
  local stair = StairSlab:new({
    material = self.material,
    subvariant = self.subvariant
  })
  stair:SetPosAngle(x - dx * sx, y - dy * sy, z - dz * sz, obj:GetAngle())
  stair:EditorCallbackClone(self)
  stair:UpdateEntity()
  self:AlignObj()
  self:UpdateEntity()
end
function StairSlab:AlignObj(pos, angle)
  FloorAlignedObj.AlignObj(self, pos, angle)
  if self:GetGameFlags(const.gofPermanent) == 0 then
    return
  end
  local lp = rawget(self, "last_pos")
  local p = self:GetPos()
  if lp ~= p then
    rawset(self, "last_pos", p)
    local b = self:GetObjectBBox()
    if lp then
      local s = b:size() / 2
      b = Extend(b, lp + s)
      b = Extend(b, lp - s)
    end
    ComputeSlabVisibilityInBox(b)
  end
end
DefineClass.SlabWallObject = {
  __parents = {
    "Slab",
    "WallAlignedObj"
  },
  properties = {
    category = "Slabs",
    {
      id = "variant",
      name = "Variant",
      editor = "dropdownlist",
      items = PresetGroupCombo("SlabPreset", "SlabVariants"),
      default = "",
      no_edit = true
    },
    {
      id = "width",
      name = "Width",
      editor = "number",
      min = 0,
      max = 3,
      default = 1
    },
    {
      id = "height",
      name = "Height",
      editor = "number",
      min = 1,
      max = 4,
      default = 3
    },
    {
      id = "subvariant",
      name = "Subvariant",
      editor = "number",
      default = 1,
      buttons = {
        {
          name = "Next",
          func = "CycleEntityBtn"
        }
      }
    },
    {
      id = "hide_with_wall",
      name = "Hide With Wall",
      editor = "bool",
      default = false
    },
    {
      id = "owned_slabs",
      editor = "objects",
      default = false,
      no_edit = true
    },
    {
      id = "forceInvulnerableBecauseOfGameRules",
      name = "Invulnerable",
      editor = "bool",
      default = false,
      help = "In context of destruction."
    },
    {id = "colors"},
    {
      id = "interior_attach_colors"
    },
    {
      id = "exterior_attach_colors"
    },
    {
      id = "indoor_material_1"
    },
    {
      id = "indoor_material_2"
    }
  },
  entity = "Window_Colonial_Single_01",
  material = "Planks",
  affected_walls = false,
  main_wall = false,
  last_snap_pos = false,
  room = false,
  owned_objs = false,
  invulnerable = false,
  colors_room_member = false
}
SlabWallObject.GetSide = WallSlab.GetSide
SlabWallObject.GetGridCoords = WallSlab.GetGridCoords
SlabWallObject.IsSameLocation = WallSlab.IsSameLocation
function WallSlab:GetAttachColors()
  local iclrs = not self.interior_attach_colors and self.room and self.room.inner_colors
  local clrs = self:GetExteriorAttachColor()
  return iclrs, clrs
end
function SlabWallObject:GetMaterialType()
  return self.material_type
end
function SlabWallObject:RefreshColors()
  if not self.is_destroyed then
    return
  end
  local clrs, iclrs
  local aw = self.affected_walls
  for i = 1, #(aw or "") do
    local w = aw[i]
    if w.invisible_reasons and not w.invisible_reasons.suppressed then
      iclrs, clrs = w:GetAttachColors()
      if w:GetAngle() ~= self:GetAngle() then
        local tmp = iclrs
        iclrs = clrs
        clrs = tmp
      end
      break
    end
  end
  clrs = clrs or self.colors or self:GetDefaultColor()
  iclrs = iclrs or self.room and self.room.inner_colors
  self:ForEachDestroyedAttach(function(v, self, clrs, iclrs)
    local c, ic = clrs, iclrs
    SetSlabColorHelper(v, rawget(v, "use_self_colors") and self or c or self)
    if c or ic then
      local atts = v:GetAttaches()
      for i = 1, #(atts or "") do
        local a = atts[i]
        if not rawget(a, "editor_ignore") then
          local angle = a:GetAttachAngle()
          if angle == 0 then
            if c then
              SetSlabColorHelper(a, c)
            end
          elseif ic then
            SetSlabColorHelper(a, ic)
          end
        end
      end
    end
  end, self, clrs, iclrs)
end
function SlabWallObject:SetStateSavedOnMap(val)
  self:SetState(val)
end
function SlabWallObject:GetStateSavedOnMap()
  return self:GetStateText()
end
local InsertInParentContainersHelper = function(self, room, side)
  if self:IsDoor() then
    room.spawned_doors = room.spawned_doors or {}
    room.spawned_doors[side] = room.spawned_doors[side] or {}
    table.insert(room.spawned_doors[side], self)
  else
    room.spawned_windows = room.spawned_windows or {}
    room.spawned_windows[side] = room.spawned_windows[side] or {}
    table.insert(room.spawned_windows[side], self)
  end
end
local RemoveFromParentContainerHelper = function(self, room, side)
  if self:IsDoor() then
    local spawned_doors = room.spawned_doors
    if spawned_doors and spawned_doors[side] then
      table.remove_entry(spawned_doors[side], self)
      if #spawned_doors[side] <= 0 then
        spawned_doors[side] = nil
      end
    end
  else
    local spawned_windows = room.spawned_windows
    if spawned_windows and spawned_windows[side] then
      table.remove_entry(spawned_windows[side], self)
      if #spawned_windows[side] == 0 then
        spawned_windows[side] = nil
      end
    end
  end
end
function SlabWallObject:FixNoRoom()
  if self.room then
    return
  end
  if not self.main_wall then
    return
  end
  local room = self.main_wall.room
  local side = self.main_wall.side
  self.room = room
  self.side = side
  if room and side then
    InsertInParentContainersHelper(self, room, side)
  end
end
function SlabWallObject:Setside(newSide)
  if self.side == newSide then
    return
  end
  if self.room then
    RemoveFromParentContainerHelper(self, self.room, self.side)
    if newSide then
      InsertInParentContainersHelper(self, self.room, newSide)
    end
  end
  self.side = newSide
end
function SlabWallObject:ChangeRoom(newRoom)
  if self.room == newRoom then
    return
  end
  self.restriction_box = false
  if self.room then
    RemoveFromParentContainerHelper(self, self.room, self.side)
  end
  self.room = newRoom
  if newRoom then
    InsertInParentContainersHelper(self, newRoom, self.side)
  end
end
function SlabWallObject:GetWorldBBox()
  return GetSlabWorldBBox(self:GetPos(), self.width, self.height, self:GetAngle())
end
function GetSlabWorldBBox(pos, width, height, angle)
  local x, y, z = pos:xyz()
  local b
  local minAdd = 1 < width and voxelSizeX or 0
  local maxAdd = width == 3 and voxelSizeX or 0
  local tenCm = guim / 10
  if angle == 0 then
    return box(x - tenCm, y - halfVoxelSizeX - minAdd, z, x + tenCm, y + halfVoxelSizeX + maxAdd, z + height * voxelSizeZ)
  elseif angle == 10800 then
    return box(x - tenCm, y - halfVoxelSizeX - maxAdd, z, x + tenCm, y + halfVoxelSizeX + minAdd, z + height * voxelSizeZ)
  elseif angle == 5400 then
    return box(x - halfVoxelSizeX - maxAdd, y - tenCm, z, x + halfVoxelSizeX + minAdd, y + tenCm, z + height * voxelSizeZ)
  else
    return box(x - halfVoxelSizeX - minAdd, y - tenCm, z, x + halfVoxelSizeX + maxAdd, y + tenCm, z + height * voxelSizeZ)
  end
end
function IntersectWallObjs(obj, newPos, width, height, angle)
  local ret = false
  local b = GetSlabWorldBBox(newPos or obj:GetPos(), width or obj.width, height or obj.height, angle or obj:GetAngle())
  angle = angle or obj:GetAngle()
  MapForEach(b:grow(voxelSizeX * 2, voxelSizeX * 2, voxelSizeZ * 3), "SlabWallObject", nil, nil, gofPermanent, function(o, obj, angle)
    if o ~= obj then
      local a = o:GetAngle()
      if a == angle or abs(a - angle) == 10800 then
        local hisBB = o:GetObjectBBox()
        local ib = IntersectRects(b, hisBB)
        if ib:IsValid() and Max(ib:sizex(), ib:sizey()) >= halfVoxelSizeX / 2 and ib:sizez() >= halfVoxelSizeZ / 2 then
          ret = true
          return "break"
        end
      end
    end
  end, obj, angle)
  return ret
end
SlabWallObject.MirroringFromRoom = empty_func
function SlabWallObject:CanMirror()
  return false
end
function SlabWallObject:EditorCallbackMove()
  self:AlignObj()
end
function SlabWallObject:AlignObj(pos, angle)
  local x, y, z
  if pos then
    x, y, z, angle = WallWorldToVoxel(pos:x(), pos:y(), pos:z() or iz, angle or self:GetAngle())
  else
    x, y, z, angle = WallWorldToVoxel(self)
  end
  x, y, z = WallVoxelToWorld(x, y, z, angle)
  local oldPos = self:GetPos()
  local newPos = point(x, y, z)
  if not newPos:z() then
    newPos = newPos:SetZ(snapZCeil(terrain.GetHeight(newPos:xy())))
  end
  if pos and oldPos:IsValid() and oldPos ~= newPos and IntersectWallObjs(self, newPos, self.width, self.height, angle) then
    newPos = oldPos
  end
  self:SetPosAngle(newPos:x(), newPos:y(), newPos:z() or const.InvalidZ, angle)
  self:PostEntityUpdate()
  local is_permanent = self:GetGameFlags(gofPermanent) ~= 0
  if is_permanent and self.main_wall then
    self:Setside(self.main_wall.side)
    self:ChangeRoom(self.main_wall.room)
  else
    self:Setside(false)
    self:ChangeRoom(false)
  end
end
local SlabWallObject_BaseNames = {
  "WindowVent",
  "Window",
  "Door",
  "TallDoor"
}
local SlabWallObject_BaseNames_Window = {
  "WindowVent",
  "Window",
  "WindowBig",
  "TallWindow"
}
local SlabWallObject_WidthNames = {
  "Single",
  "Double",
  "Triple",
  "Quadruple",
  [0] = "Small"
}
function SlabWallObjectName(material, height, width, variant, isDoor)
  local base = not (isDoor == nil or isDoor) and SlabWallObject_BaseNames_Window[height] or SlabWallObject_BaseNames[height] or ""
  if variant then
    local v = variant <= 0 and 1 or variant
    local str = variant < 10 and "%s_%s_%s_0%s" or "%s_%s_%s_%s"
    return string.format(str, base, material, SlabWallObject_WidthNames[width] or "", tostring(v))
  else
    return string.format("%s_%s_%s", base, material, SlabWallObject_WidthNames[width] or "")
  end
end
function SlabWallObject:EditorCallbackPlaceCursor()
  if IsValidEntity(self.class) then
    local e = self.class
    local strs = string.split(e, "_")
    local base = strs[1]
    local idxW = table.find(SlabWallObject_BaseNames_Window, base)
    local idxD = table.find(SlabWallObject_BaseNames, base)
    local isDoor = false
    if idxW then
      self.height = idxW
      if self:IsDoor() then
      end
    else
      self.height = idxD
      if not self:IsDoor() then
      end
    end
    self.material = strs[2]
    local w = table.find(SlabWallObject_WidthNames, strs[3]) or SlabWallObject_WidthNames[0] == strs[3] and 0
    self.width = w
    self.subvariant = tonumber(strs[4])
    self:UpdateEntity()
  end
end
function SlabWallObject:EditorCallbackPlace(reason)
  Slab.EditorCallbackPlace(self, reason)
  self:EditorCallbackPlaceCursor()
  self:FixNoRoom()
end
function SlabWallObject:HasEntityForSubvariant(var)
  local ret = SlabWallObjectName(self.material, self.height, self.width, var, self:IsDoor())
  return IsValidEntity(ret)
end
function SlabWallObject:HasEntityForHeight(height)
  local ret
  if self.subvariant then
    ret = SlabWallObjectName(self.material, height, self.width, self.subvariant, self:IsDoor())
    if IsValidEntity(ret) then
      return true
    end
  end
  return IsValidEntity(SlabWallObjectName(self.material, height, self.width, nil, self:IsDoor())), ret
end
function SlabWallObject:HasEntityForWidth(width)
  local ret
  if self.subvariant then
    ret = SlabWallObjectName(self.material, self.height, width, self.subvariant, self:IsDoor())
    if IsValidEntity(ret) then
      return true
    end
  end
  return IsValidEntity(SlabWallObjectName(self.material, self.height, width, nil, self:IsDoor())), ret
end
function SlabWallObject:ComposeEntityName()
  if self.subvariant then
    local ret = SlabWallObjectName(self.material, self.height, self.width, self.subvariant, self:IsDoor())
    if IsValidEntity(ret) then
      return ret
    else
      self:ReportMissingSlabEntity(ret)
    end
  end
  return SlabWallObjectName(self.material, self.height, self.width, nil, self:IsDoor())
end
function SlabWallObject:EditorCallbackDelete()
  if IsValid(self.room) then
    self.room:OnWallObjDeletedOutsideOfGedRoomEditor(self)
  end
end
function SlabWallObject:Done()
  self:RestoreAffectedSlabs()
  DoneObjects(self.owned_slabs)
  self.owned_slabs = false
  if self.owned_objs then
    DoneObjects(self.owned_objs)
  end
  self.owned_objs = false
  if not self.room or not self.side then
    return
  end
  local isDoor = self:IsDoor()
  local c
  if isDoor then
    c = self.room.spawned_doors and self.room.spawned_doors[self.side]
  else
    c = self.room.spawned_windows and self.room.spawned_windows[self.side]
  end
  if not c then
    return
  end
  table.remove_entry(c, self)
end
function SlabWallObject:ForEachAffectedWall(callback, ...)
  for _, wall in ipairs(self.affected_walls or empty_table) do
    if IsValid(wall) and wall.wall_obj == self then
      local func = type(callback) == "function" and callback or wall[callback]
      func(wall, ...)
    end
  end
end
function SlabWallObject:RestoreAffectedSlabs()
  SuspendPassEdits("SlabWallObject:RestoreAffectedSlabs")
  for _, wall in ipairs(self.affected_walls or empty_table) do
    if IsValid(wall) and wall.wall_obj == self then
      wall:SetWallObj()
    end
  end
  self.affected_walls = nil
  self.main_wall = nil
  ResumePassEdits("SlabWallObject:RestoreAffectedSlabs")
end
function SlabWallObject:SetProperty(id, value)
  Slab.SetProperty(self, id, value)
  if IsChangingMap() then
    return
  end
  if id == "width" or id == "height" then
    self:DelayedUpdateEntity()
  end
end
function SlabWallObject:PostLoad()
  self:DelayedUpdateEntity()
end
function SlabWallObject:UpdateEntity()
  if self.is_destroyed and self:UpdateDestroyedState() then
    return
  end
  self:DestroyAttaches()
  Slab.UpdateEntity(self)
  AutoAttachObjects(self)
  self:PostEntityUpdate()
  self:RefreshEntityState()
  self:RefreshClass()
end
function SlabWallObject:CycleEntity(delta)
  EditorSubVariantObject.CycleEntity(self, delta)
  self:RefreshEntityState()
  self:RefreshClass()
  self:PostEntityUpdate()
end
function SlabWallObject:RefreshClass()
  local e = self:GetEntity()
  if IsValidEntity(e) then
    local cls = g_Classes[e]
    if cls and IsKindOf(cls, "SlabWallObject") then
      setmetatable(self, cls)
    end
  end
end
function DbgChangeClassOfAllWindows()
  CreateRealTimeThread(function()
    ForEachMap(ListMaps(), function()
      MapForEach("map", "SlabWallObject", function(obj)
        obj:RefreshClass()
      end)
      SaveMap("no backup")
    end)
  end)
end
function SlabWallObject:RefreshEntityState()
end
function SlabWallObject:PostEntityUpdate()
  self:UpdateAffectedWalls()
  self:UpdateManagedSlabs()
  self:UpdateManagedObj()
end
function SlabWallObject:IsWindow()
  return not self:IsDoor()
end
function SlabWallObject:IsDoor()
  return IsKindOfClasses(self, "SlabWallDoorDecor", "SlabWallDoor") or false
end
function SlabWallObject:ForEachSlabPos(func, ...)
  local width = self.width
  local height = self.height
  if width <= 0 or height <= 0 then
    return
  end
  local x, y, z = self:GetPosXYZ()
  z = z or terrain.GetHeight(x, y)
  local side = self:GetSide()
  for w = 1, width do
    for h = 1, self.height do
      local tx, ty, tz, wf
      tz = z + (h - 1) * const.SlabSizeZ
      wf = w - width / 2 - 1
      if side == "E" then
        tx = x
        ty = y + wf * const.SlabSizeY
      elseif side == "W" then
        tx = x
        ty = y - wf * const.SlabSizeY
      elseif side == "N" then
        tx = x + wf * const.SlabSizeX
        ty = y
      else
        tx = x - wf * const.SlabSizeX
        ty = y
      end
      func(tx, ty, tz, ...)
    end
  end
end
function SlabWallObject:UpdateAffectedWalls()
  SuspendPassEdits("SlabWallObject:UpdateAffectedWalls")
  local old_aw = self.affected_walls or empty_table
  local new_aw = {}
  self.affected_walls = new_aw
  self.main_wall = nil
  local is_permanent = self:GetGameFlags(gofPermanent) ~= 0
  local gameFlags = is_permanent and gofPermanent or nil
  local x, y, z = self:GetPosXYZ()
  z = z or terrain.GetHeight(x, y)
  local side = self:GetSide()
  local width = Max(self.width, 1)
  for w = 1, width do
    for h = 1, self.height do
      local tx, ty, tz, wf
      tz = z + (h - 1) * const.SlabSizeZ
      wf = w - width / 2 - 1
      if side == "E" then
        tx = x
        ty = y + wf * const.SlabSizeY
      elseif side == "W" then
        tx = x
        ty = y - wf * const.SlabSizeY
      elseif side == "N" then
        tx = x + wf * const.SlabSizeX
        ty = y
      else
        tx = x - wf * const.SlabSizeX
        ty = y
      end
      local is_main_pos = tx == x and ty == y and tz == z
      local main_slab_candidates = is_main_pos and {}
      MapForEach(tx, ty, tz, 0, "WallSlab", nil, nil, gameFlags, function(slab, self, is_main_pos, is_permanent)
        local wall_obj = slab.wall_obj
        if IsValid(wall_obj) and wall_obj ~= self and not new_aw[slab] then
          return
        end
        if self.owned_slabs and table.find(self.owned_slabs, slab) then
          return
        end
        if wall_obj ~= self and (is_permanent or slab:GetGameFlags(gofPermanent) == 0) then
          slab:SetWallObj(self)
        end
        new_aw[slab] = true
        table.insert(new_aw, slab)
        if is_main_pos then
          table.insert(main_slab_candidates, slab)
        end
      end, self, is_main_pos, is_permanent)
      if is_main_pos and 0 < #main_slab_candidates then
        self:PickMainWall(main_slab_candidates)
      end
    end
  end
  if not self.main_wall and 0 < #new_aw then
    self:PickMainWall(new_aw)
  end
  for _, slab in ipairs(old_aw) do
    if IsValid(slab) and slab.wall_obj == self and not new_aw[slab] then
      slab:SetWallObj()
    end
  end
  ResumePassEdits("SlabWallObject:UpdateAffectedWalls")
  return old_aw
end
function SlabWallObject:PickMainWall(t)
  local iHaveRoom = not not self.room
  local roofCandidate = false
  local nonRoofCandidateDiffRoom = false
  local nonRoofRotatedCandidate = false
  self.main_wall = false
  for i = 1, #t do
    local s = t[i]
    local slabHasRoom = not not s.room
    local anyRoomMissing = not slabHasRoom or not iHaveRoom
    local slaba = s:GetAngle()
    local selfa = self:GetAngle()
    local angleIsTheSame = slaba == selfa
    local angleIsReveresed = abs(slaba - selfa) == 10800
    if (slabHasRoom and s.room == self.room or not iHaveRoom and (angleIsTheSame or angleIsReveresed)) and (anyRoomMissing or s.room.being_placed == self.room.being_placed) then
      if not IsKindOf(s, "RoofWallSlab") then
        if angleIsReveresed then
          nonRoofRotatedCandidate = s
        else
          self.main_wall = s
          return
        end
      elseif not roofCandidate then
        roofCandidate = s
      end
    elseif not anyRoomMissing and s.room ~= self.room and angleIsTheSame then
      nonRoofCandidateDiffRoom = s
    end
  end
  self.main_wall = self.main_wall or nonRoofCandidateDiffRoom or nonRoofRotatedCandidate or roofCandidate
end
function SlabWallObject:DestroyAttaches()
  if self.is_destroyed and string.find(GetStack(2), "SetAutoAttachMode") then
    return
  end
  Slab.DestroyAttaches(self, function(o, doNotDelete)
    if IsKindOf(self, "EditorTextObject") and o == self.editor_text_obj then
      return
    end
    return not doNotDelete or not IsKindOf(o, doNotDelete.class)
  end, g_Classes.ConstructionSite)
end
function SlabWallObject:SetManagedSlabsShadowOnly(val, clear_contour)
  for i = 1, #(self.owned_slabs or "") do
    local slab = self.owned_slabs[i]
    if slab then
      slab:SetShadowOnly(val)
      if clear_contour then
        slab:ClearHierarchyGameFlags(const.gofContourInner)
      end
    end
  end
end
function OnMsg.EditorCallback(id, objs)
  if id == "EditorCallbackDelete" then
    for i = 1, #objs do
      local o = objs[i]
      if IsKindOf(o, "WallSlab") and o.always_visible and o:GetClipPlane() ~= 0 then
        local x, y, z = o:GetPosXYZ()
        local swo = MapGetFirst(x, y, z, 0, "SlabWallObject")
        if swo and swo.owned_slabs then
          local idx = table.find(swo.owned_slabs, o)
          if idx then
            swo.owned_slabs[idx] = false
          end
        end
      end
    end
  end
end
function SlabWallObject:UpdateManagedSlabs()
  if self.width == 0 then
    local main = self.main_wall
    for i = 1, #(self.owned_slabs or "") do
      local s = self.owned_slabs[i]
      if not IsValid(s) then
        self.owned_slabs[i] = nil
      end
    end
    if not main or main:GetAngle() ~= self:GetAngle() or self.room and self.room ~= main.room then
      self:UpdateAffectedWalls()
      main = self.main_wall
      if not main then
        DoneObjects(self.owned_slabs)
        self.owned_slabs = false
        return
      end
    end
    if self.owned_slabs and self.owned_slabs[1] == false then
      DoneObjects(self.owned_slabs)
      self.owned_slabs = false
    end
    if not self.owned_slabs then
      self.owned_slabs = {}
      local s = WallSlab:new({always_visible = true, forceInvulnerableBecauseOfGameRules = false})
      table.insert(self.owned_slabs, s)
      s = WallSlab:new({always_visible = true, forceInvulnerableBecauseOfGameRules = false})
      table.insert(self.owned_slabs, s)
    end
    local bb = self:GetObjectBBox()
    local isVerticalAligned = self:GetAngle() % 10800 == 0
    local mx, my, mz = main:GetPosXYZ()
    local ma = main:GetAngle()
    local destroyed = self.is_destroyed
    for i = 1, 2 do
      local s = self.owned_slabs[i]
      if IsValid(s) then
        s:SetPosAngle(mx, my, mz, ma)
        s.material = main.material
        s.variant = main.variant
        s.indoor_material_1 = main.indoor_material_1
        s.indoor_material_2 = main.indoor_material_2
        s.subvariant = main.subvariant
        s:UpdateEntity()
        s:UpdateVariantEntities()
        local room = main.room
        s:SetColorModifier(main:GetColorModifier())
        s:Setcolors(main.colors or room and room.outer_colors)
        s:Setinterior_attach_colors(main.interior_attach_colors or room and room.inner_colors)
        s:Setexterior_attach_colors(main.exterior_attach_colors)
        s:Setexterior_attach_colors_from_nbr(main.exterior_attach_colors_from_nbr)
        s:SetWarped(main:GetWarped())
        collision.SetAllowedMask(s, 0)
        s.forceInvulnerableBecauseOfGameRules = false
        s.invulnerable = false
        if destroyed ~= s.is_destroyed then
          if destroyed then
            s:Destroy()
          else
            s:Repair()
          end
        end
        local p1, p2, p3
        if i == 2 then
          p3 = bb:min()
          p1 = p3 + point(0, 0, bb:sizez())
          if isVerticalAligned then
            p2 = p1 + point(bb:sizex(), 0, 0)
          else
            p2 = p1 + point(0, bb:sizey(), 0)
          end
        else
          p1 = bb:max()
          p3 = p1 - point(0, 0, bb:sizez())
          if isVerticalAligned then
            p2 = p1 - point(bb:sizex(), 0, 0)
          else
            p2 = p1 - point(0, bb:sizey(), 0)
          end
        end
        if isVerticalAligned then
          p1, p3 = p3, p1
        end
        s:SetClipPlane(PlaneFromPoints(p1, p2, p3))
      else
        self.owned_slabs[i] = false
      end
    end
  else
    if self.owned_slabs then
      DoneObjects(self.owned_slabs)
    end
    self.owned_slabs = false
  end
end
local TryGetARepresentativeWall = function(self, wall)
  local mw
  if not mw then
    local aw = self.affected_walls
    for i = 1, #(aw or "") do
      local w = aw[i]
      if w.invisible_reasons and not w.invisible_reasons.suppressed then
        mw = w
        break
      end
    end
  end
  return mw or self.main_wall
end
local TryFigureOutInteriorMaterialOnTheExteriorSide = function(self)
  local m, c, _
  local mw = TryGetARepresentativeWall(self)
  if mw then
    if self:GetAngle() == mw:GetAngle() then
      m = mw.indoor_material_2
      _, c = mw:GetAttachColors()
    else
      m = mw.indoor_material_1
      c = mw:GetAttachColors()
    end
  else
    m = self.material
  end
  return m ~= noneWallMat and m or false, c or self.colors or self:GetDefaultColor()
end
local TryFigureOutInteriorMaterial = function(self)
  local m, c, _
  local mw = TryGetARepresentativeWall(self)
  if mw then
    if self:GetAngle() == mw:GetAngle() then
      m = mw.indoor_material_1
      c = mw:GetAttachColors()
    else
      m = mw.indoor_material_2
      _, c = mw:GetAttachColors()
    end
  elseif self.room then
    m = self.room.inner_wall_mat
    c = self.room.inner_colors
  end
  return m ~= noneWallMat and m or false, c
end
local GetAttchEntName = function(e, material)
  if material then
    local e = string.format("%s_Int_%s", e, material)
    if IsValidEntity(e) then
      return e
    end
  end
  return string.format("%s_Int", e)
end
function SlabWallObject:UpdateManagedObj()
  if not self.is_destroyed then
    local setupObj = function(ea, color, idx, si)
      local t = self.owned_objs
      if not t then
        t = {}
        for i = 1, idx - 1 do
          t[i] = false
        end
        self.owned_objs = t
      end
      if not IsValid(t[idx]) then
        t[idx] = PlaceObject("Object")
      end
      local o = t[idx]
      if o:GetEntity() ~= ea then
        o:ChangeEntity(ea)
      end
      o:SetPos(self:GetSpotPos(si))
      o:SetAngle(self:GetSpotAngle2D(si))
      SetSlabColorHelper(o, color)
    end
    local manageObj = function(spotName, idx, mat_func)
      local added = false
      if self:HasSpot(spotName) then
        local si = self:GetSpotBeginIndex(spotName)
        local e = self:GetEntity()
        local material, color = mat_func(self)
        local ea = GetAttchEntName(e, material)
        if IsValidEntity(ea) then
          setupObj(ea, color, idx, si)
          added = true
        else
          print("SlabWallObject has a " .. spotName .. " spot defined but no ent found to place there [" .. ea .. "]")
        end
      end
      if not added then
        local t = self.owned_objs
        if t and IsValid(t[idx]) then
          DoneObject(t[idx])
          t[idx] = false
        end
      end
    end
    manageObj("Interior1", 1, TryFigureOutInteriorMaterial)
    manageObj("Interior2", 2, TryFigureOutInteriorMaterialOnTheExteriorSide)
    local t = self.owned_objs
    if t and not IsValid(t[1]) and not IsValid(t[2]) then
      self.owned_objs = false
    end
  else
    if self.owned_objs then
      DoneObjects(self.owned_objs)
    end
    self.owned_objs = false
  end
end
function SlabWallObject:SetShadowOnly(val, ...)
  Slab.SetShadowOnly(self, val, ...)
  for _, o in ipairs(self.owned_objs or empty_table) do
    o:SetShadowOnly(val, ...)
  end
end
function SlabWallObject:GetPlaceClass()
  return self
end
function SlabWallObject:GetError()
  local lst = MapGet(self, 0, "SlabWallObject")
  if 1 < #lst then
    return "Stacked doors/windows!"
  end
  self:ForEachSlabPos(function(x, y, z)
    local slb = MapGetFirst(x, y, z, 0, "WallSlab")
    if slb and slb.wall_obj ~= self then
      return "Stacked doors/windows!"
    end
  end)
end
DefineClass.SlabWallDoorDecor = {
  __parents = {
    "SlabWallObject"
  },
  fx_actor_class = "Door"
}
DefineClass("SlabWallDoor", "SlabWallDoorDecor")
DefineClass("SlabWallWindow", "SlabWallObject")
DefineClass("SlabWallWindowBroken", "SlabWallObject")
function GetFloorAlignedObj(gx, gy, gz, class)
  local x, y, z = VoxelToWorld(gx, gy, gz)
  return MapGetFirst(x, y, z, 0, class, nil, efVisible)
end
function GetWallAlignedObj(gx, gy, gz, dir, class)
  local x, y, z = WallVoxelToWorld(gx, gy, gz, dir)
  return MapGetFirst(x, y, z, 0, class, nil, efVisible)
end
function GetWallAlignedObjs(gx, gy, gz, dir, class)
  local x, y, z = WallVoxelToWorld(gx, gy, gz, dir)
  return MapGet(x, y, z, 0, class, nil, nil, gofPermanent) or empty_table
end
function GetFloorSlab(gx, gy, gz)
  return GetFloorAlignedObj(gx, gy, gz, "FloorSlab")
end
function GetWallSlab(gx, gy, gz, side)
  return GetWallAlignedObj(gx, gy, gz, side, "WallSlab")
end
function GetWallSlabs(gx, gy, gz, side)
  return GetWallAlignedObjs(gx, gy, gz, side, "WallSlab")
end
function GetStairSlab(gx, gy, gz)
  return GetFloorAlignedObj(gx, gy, gz, "StairSlab")
end
function EnumConnectedFloorSlabs(x, y, z, visited)
  local queue, objs = {}, {}
  visited = visited or {}
  local push = function(x, y, z)
    local hash = slab_hash(x, y, z)
    if visited[hash] then
      return
    end
    visited[hash] = true
    local slab = GetFloorSlab(x, y, z)
    if not slab or visited[slab] then
      return
    end
    visited[slab] = true
    table.insert_unique(objs, slab)
    queue[#queue + 1] = {
      x = x,
      y = y,
      z = z
    }
  end
  push(x, y, z)
  while 0 < #queue do
    local loc = table.remove(queue)
    push(loc.x + 1, loc.y, loc.z)
    push(loc.x - 1, loc.y, loc.z)
    push(loc.x, loc.y + 1, loc.z)
    push(loc.x, loc.y - 1, loc.z)
  end
  return objs
end
function EnumConnectedWallSlabs(x, y, z, side, floor, enum_adjacent_sides, zdir, visited)
  local queue, objs = {}, {}
  visited = visited or {}
  zdir = zdir or 0
  local push = function(x, y, z, side)
    local hash = slab_hash(x, y, z, side)
    if visited[hash] then
      return
    end
    visited[hash] = true
    local slab = GetWallSlab(x, y, z, side)
    if not slab or floor and slab.floor ~= floor or visited[slab] then
      return
    end
    visited[slab] = true
    table.insert_unique(objs, slab)
    queue[#queue + 1] = {
      x = x,
      y = y,
      z = z,
      side = side
    }
  end
  push(x, y, z, side)
  while 0 < #queue do
    local loc = table.remove(queue)
    if 0 <= zdir then
      push(loc.x, loc.y, loc.z + 1, loc.side)
    end
    if zdir <= 0 then
      push(loc.x, loc.y, loc.z - 1, loc.side)
    end
    if loc.side == "E" or loc.side == "W" then
      push(loc.x, loc.y + 1, loc.z, loc.side)
      push(loc.x, loc.y - 1, loc.z, loc.side)
      if enum_adjacent_sides then
        push(loc.x, loc.y, loc.z, "S")
        push(loc.x, loc.y, loc.z, "N")
        push(loc.x + 1, loc.y + 1, loc.z, "N")
        push(loc.x - 1, loc.y + 1, loc.z, "N")
        push(loc.x + 1, loc.y - 1, loc.z, "S")
        push(loc.x - 1, loc.y - 1, loc.z, "S")
      end
    else
      push(loc.x + 1, loc.y, loc.z, loc.side)
      push(loc.x - 1, loc.y, loc.z, loc.side)
      if enum_adjacent_sides then
        push(loc.x, loc.y, loc.z, "E")
        push(loc.x, loc.y, loc.z, "W")
        push(loc.x + 1, loc.y + 1, loc.z, "W")
        push(loc.x + 1, loc.y - 1, loc.z, "W")
        push(loc.x - 1, loc.y + 1, loc.z, "E")
        push(loc.x - 1, loc.y - 1, loc.z, "E")
      end
    end
  end
  return objs
end
function EnumConnectedStairSlabs(x, y, z, zdir, visited)
  local stair = GetStairSlab(x, y, z)
  local objs = {}
  visited = visited or {}
  zdir = zdir or 0
  if stair then
    objs[1] = stair
    visited[stair] = true
    local first, last, all
    if 0 <= zdir then
      first, last, all = stair:TraceConnectedStairs(1)
      table.iappend(objs, all)
      for _, obj in ipairs(all) do
        visited[obj] = true
      end
    end
    if zdir <= 0 then
      first, last, all = stair:TraceConnectedStairs(-1)
      table.iappend(objs, all)
      for _, obj in ipairs(all) do
        visited[obj] = true
      end
    end
  end
  return objs
end
function FindConnectedWallSlab(obj)
  if IsKindOf(obj, "WallSlab") then
    return obj
  elseif IsKindOf(obj, "SlabWallObject") then
    return obj.main_wall
  elseif IsKindOf(obj, "FloorSlab") then
    local x, y, z = obj:GetGridCoords()
    local tiles = EnumConnectedFloorSlabs(x, y, z)
    for _, tile in ipairs(tiles or empty_table) do
      x, y, z = tile:GetGridCoords()
      for _, side in ipairs(slab_sides) do
        local slab = GetWallSlab(x, y, z, side)
        if IsValid(slab) then
          return slab
        end
      end
    end
  end
end
function FindConnectedFloorSlab(obj)
  if IsKindOf(obj, "FloorSlab") then
    return obj
  end
  if IsKindOf(obj, "SlabWallObject") then
    obj = obj.main_wall
  end
  if IsKindOf(obj, "WallSlab") then
    local x, y, z = obj:GetGridCoords()
    local walls = EnumConnectedWallSlabs(x, y, z, obj:GetSide(), obj.floor)
    for _, wall in ipairs(walls) do
      x, y, z = wall:GetGridCoords()
      local slab = GetFloorSlab(x, y, z)
      if IsValid(slab) and slab.floor == obj.floor then
        return slab
      end
    end
  end
end
function SlabsPushUp(gx, gy, gz, visited)
  visited = visited or {}
  local walls, floors = {}, {}
  local objs
  floors = EnumConnectedFloorSlabs(gx, gy, gz, visited)
  for _, side in ipairs(slab_sides) do
    objs = EnumConnectedWallSlabs(gx, gy, gz, side, false, "enum adjacent", 1, visited)
    if 0 < #objs then
      table.iappend(walls, objs)
    end
  end
  local iwall, ifloor = 1, 1
  while iwall <= #walls or ifloor <= #floors do
    if iwall <= #walls then
      local x, y, z = walls[iwall]:GetGridCoords()
      objs = EnumConnectedWallSlabs(x, y, z, walls[iwall]:GetSide(), false, "enum adjacent", 1, visited)
      if 0 < #objs then
        table.iappend(walls, objs)
      end
      objs = EnumConnectedFloorSlabs(x, y, z, visited)
      if 0 < #objs then
        table.iappend(floors, objs)
      end
      iwall = iwall + 1
    end
    if ifloor <= #floors then
      local x, y, z = floors[ifloor]:GetGridCoords()
      for _, side in ipairs(slab_sides) do
        objs = EnumConnectedWallSlabs(x, y, z, side, false, "enum adjacent", 1, visited)
        if 0 < #objs then
          table.iappend(walls, objs)
        end
      end
      ifloor = ifloor + 1
    end
  end
  for _, obj in ipairs(floors) do
    local x, y, z = obj:GetPosXYZ()
    local gx, gy, gz = obj:GetGridCoords()
    obj:SetPos(x, y, z + sz)
    local stairs = EnumConnectedStairSlabs(gx, gy, gz)
    for i, stair in ipairs(stairs) do
      x, y, z = stair:GetPosXYZ()
      stair:SetPos(x, y, z + sz)
    end
  end
  for _, obj in ipairs(walls) do
    local x, y, z = obj:GetPosXYZ()
    obj:SetPos(x, y, z + sz)
    if IsValid(obj.wall_obj) and obj.wall_obj.main_wall == obj then
      obj.wall_obj:SetPos(x, y, z + sz)
    end
  end
end
function ComposeCornerPlugName(mat, crossingType, variant)
  variant = variant or "01"
  local ret = string.format("WallExt_%s_Cap%s_%s", mat, crossingType, variant)
  return ret
end
function ComposeCornerBeamName(mat, interiorExterior, variant, svd)
  variant = variant or "01"
  interiorExterior = interiorExterior or "Ext"
  local ret = string.format("Wall%s_%s_Corner_%s", interiorExterior, mat, variant)
  return ret
end
DefineClass.RoomCorner = {
  __parents = {
    "Slab",
    "CornerAlignedObj",
    "ComponentExtraTransform",
    "HideOnFloorChange"
  },
  properties = {
    {
      id = "ColorModifier",
      dont_save = true
    },
    {
      id = "isPlug",
      editor = "bool",
      default = false
    }
  },
  room_container_name = "spawned_corners"
}
function RoomCorner:SetProperty(id, value)
  EditorCallbackObject.SetProperty(self, id, value)
end
function RoomCorner:Setentity(val)
  if not IsValidEntity(val) then
    self:ReportMissingSlabEntity(val)
    return
  end
  self.entity = val
  self:ChangeEntity(val)
  self:ResetVisibilityFlags()
end
function RoomCorner:GetAttachColors()
  return false, false
end
function RoomCorner:UpdateEntity()
  self.bad_entity = nil
  if self.is_destroyed and self:UpdateDestroyedState() then
    return
  end
  local pos = self:GetPos()
  local newEnt = "InvisibleObject"
  local angle = 0
  local dir = self.side
  local room = self.room
  if not room then
    return
  end
  local is_permanent = self:GetGameFlags(gofPermanent) ~= 0
  local gameFlags = is_permanent and gofPermanent or nil
  local mat = self.material
  local faceThis
  if mat ~= noneWallMat then
    local amIRoof = not not IsKindOf(self, "RoofCornerWallSlab")
    local alwaysVisibleSlabsPresent = false
    local walls = MapGet(pos, voxelSizeX, "WallSlab", nil, nil, gameFlags, function(o, self, amIRoof, is_permanent)
      if not is_permanent and o:GetGameFlags(gofPermanent) ~= 0 then
        return
      end
      if not self:ShouldUpdateEntity(o) then
        return
      end
      local clsTest = amIRoof == not not IsKindOf(o, "RoofWallSlab")
      if not clsTest then
        return
      end
      local visible = o:GetEnumFlags(const.efVisible) ~= 0 or IsValid(o.wall_obj)
      if not visible then
        return
      end
      local x, y, z = o:GetPosXYZ()
      if z ~= pos:z() then
        return
      end
      alwaysVisibleSlabsPresent = alwaysVisibleSlabsPresent or o.always_visible
      return true
    end, self, amIRoof, is_permanent) or empty_table
    if (amIRoof or alwaysVisibleSlabsPresent) and 1 < #walls then
      local pos_top = pos:AddZ(voxelSizeZ)
      pos_top = pos_top:SetZ(Min(room and room:GetRoofZAndDir(pos_top) or pos_top:z(), pos_top:z()))
      for i = #walls, 1, -1 do
        local wall_i = walls[i]
        local pos_i = wall_i:GetPos()
        local height_i = wall_i.room and wall_i.room:GetRoofZAndDir(pos_i) or 0
        for j = 1, #walls do
          local wall_j = walls[j]
          if wall_j ~= wall_i then
            local pos_j = wall_j:GetPos()
            if pos_i == pos_j then
              if wall_i.room == wall_j.room or wall_i.room ~= room then
                table.remove(walls, i)
              end
              break
            elseif amIRoof and wall_i.room ~= wall_j.room then
              local go = true
              local other_room = wall_i.room ~= room and wall_i.room or wall_j.room
              if other_room ~= room and IsValid(other_room) and (other_room:GetRoofZAndDir(pos_top) or 0) > pos_top:z() then
                go = false
              end
              if go then
                local height_j = wall_j.room and wall_j.room:GetRoofZAndDir(pos_j) or 0
                if height_i < height_j then
                  table.remove(walls, i)
                  break
                end
              end
            end
          end
        end
      end
    end
    local ext_material_list = Presets.SlabPreset.SlabMaterials or empty_table
    local int_material_list = Presets.SlabPreset.SlabIndoorMaterials or empty_table
    local esvd = ext_material_list[mat]
    local is_inner_none = room.inner_wall_mat == noneWallMat
    local inner_mat_to_use = not is_inner_none and room.inner_wall_mat or mat
    local isvd = int_material_list[inner_mat_to_use]
    local variantStr = false
    if self.subvariant ~= -1 then
      local digit = self.subvariant
      variantStr = digit < 10 and "0" .. tostring(digit) or tostring(digit)
    end
    if 1 < #walls then
      if #walls == 2 then
        local p1 = walls[1]:GetPos() - pos
        local p2 = walls[2]:GetPos() - pos
        if p1:x() ~= p2:x() and p1:y() ~= p2:y() then
          local x = p1:x() ~= 0 and p1:x() or p2:x()
          local y = p1:y() ~= 0 and p1:y() or p2:y()
          if x < 0 and y < 0 then
            angle = 0
          elseif x < 0 and 0 < y then
            angle = 16200
          elseif 0 < x and 0 < y then
            angle = 10800
          elseif 0 < x and y < 0 then
            angle = 5400
          end
          local d = slabCornerAngleToDir[angle]
          if self.isPlug then
            if self.material == "Concrete" and dir ~= d then
              newEnt = ComposeCornerPlugName(mat, "D")
            end
            if newEnt == "InvisibleObject" or not IsValidEntity(newEnt) then
              newEnt = ComposeCornerPlugName(mat, "L")
            end
          elseif d ~= dir or walls[1].variant == "IndoorIndoor" or walls[2].variant == "IndoorIndoor" then
            local interior_exterior = not is_inner_none and "Int" or "Ext"
            if not variantStr and isvd then
              local subvariants, total = GetMaterialSubvariants(isvd, "corner_subvariants")
              if subvariants and 0 < #subvariants then
                local random = self:GetSeed(total)
                newEnt = GetRandomSubvariantEntity(random, subvariants, function(suffix, mat, interior_exterior)
                  return ComposeCornerBeamName(mat, interior_exterior, suffix)
                end, inner_mat_to_use, interior_exterior) or ComposeCornerBeamName(inner_mat_to_use, interior_exterior)
              end
            end
            if newEnt == "InvisibleObject" then
              newEnt = ComposeCornerBeamName(inner_mat_to_use, interior_exterior, variantStr)
            end
          else
            if not variantStr and esvd then
              local subvariants, total = GetMaterialSubvariants(esvd, "corner_subvariants")
              if subvariants and 0 < #subvariants then
                local random = self:GetSeed(total)
                newEnt = GetRandomSubvariantEntity(random, subvariants, function(suffix, mat)
                  return ComposeCornerBeamName(mat, "Ext", suffix)
                end, mat) or ComposeCornerBeamName(mat, "Ext")
              end
            end
            if newEnt == "InvisibleObject" then
              newEnt = ComposeCornerBeamName(mat, "Ext", variantStr)
            end
          end
        end
      elseif #walls == 3 then
        if self.isPlug then
          newEnt = ComposeCornerPlugName(mat, "T")
          local a1 = walls[1]:GetAngle()
          local a2 = walls[2]:GetAngle()
          local a3 = walls[3]:GetAngle()
          local delim = 10800
          local orthoEl
          if a1 % delim == a2 % delim then
            orthoEl = walls[3]
          elseif a1 % delim == a3 % delim then
            orthoEl = walls[2]
          else
            orthoEl = walls[1]
          end
          local toMe = pos - orthoEl:GetPos()
          faceThis = pos + toMe
        end
      elseif #walls == 4 and self.isPlug then
        newEnt = ComposeCornerPlugName(mat, "X")
      end
    end
  end
  if not IsValidEntity(newEnt) then
    if self.subvariant == 1 or self.subvariant == -1 then
      self:ReportMissingSlabEntity(newEnt)
      newEnt = "InvisibleObject"
    else
      print("Reverting corner [" .. self.handle .. "] subvariant [" .. self.subvariant .. "] because no entity [" .. newEnt .. "] found.")
      self.subvariant = -1
      self:UpdateEntity()
      return
    end
  end
  if newEnt ~= self.entity or IsChangingMap() then
    self:Setentity(newEnt)
    self:ApplyMaterialProps()
  end
  if faceThis then
    self:Face(faceThis)
  else
    self:SetAngle(angle)
  end
  self:SetColorFromRoom()
end
function RoomCorner:SetColorFromRoom()
  local room = self.room
  if not room then
    return
  end
  local rm = self:GetColorsRoomMember()
  self:Setcolors(self.colors or room[rm])
end
function RoomCorner:GetColorsRoomMember()
  local room = self.room
  if not room then
    return self.colors_room_member
  end
  if slabCornerAngleToDir[self:GetAngle()] == self.side or room.inner_wall_mat == noneWallMat then
    return "outer_colors"
  else
    return "inner_colors"
  end
end
g_BoxesToCompute = false
local BoxIntersect = box().Intersect
local irInside = const.irInside
local DoesBoxEncompassBox = function(b1, b2)
  return BoxIntersect(b1, b2) == irInside
end
MapGameTimeRepeat("ComputeSlabVisibility", nil, function()
  if not g_BoxesToCompute then
    WaitWakeup()
  end
  ComputeSlabVisibility()
end)
MapGameTimeRepeat("DelayedSlabUpdate", -1, function(sleep)
  SlabUpdate()
  if first then
    Msg("SlabsDoneLoading")
    first = false
  end
  WaitWakeup()
end)
function ComputeSlabVisibilityOfObjects(objs)
  local bbox = empty_box
  for _, obj in ipairs(objs) do
    bbox = AddRects(bbox, obj:GetObjectBBox())
  end
  ComputeSlabVisibilityInBox(bbox)
end
function ComputeSlabVisibilityInBox(box)
  if not box or box:IsEmpty2D() then
    return
  end
  g_BoxesToCompute = g_BoxesToCompute or {}
  local boxes = g_BoxesToCompute
  for i = 1, #boxes do
    local bi = boxes[i]
    if bi == box then
      return
    end
    if DoesBoxEncompassBox(bi, box) then
      return
    elseif DoesBoxEncompassBox(box, bi) then
      boxes[i] = box
      return
    end
  end
  NetUpdateHash("ComputeSlabVisibilityInBox", box)
  table.insert(boxes, box)
  DelayedComputeSlabVisibility()
end
function DelayedComputeSlabVisibility()
  Wakeup(PeriodicRepeatThreads.ComputeSlabVisibility)
end
local TestMaterials = function(myMat, hisMat, reverseNoneForMe, reverseNoneForHim)
  if hisMat == noneWallMat then
    return true, reverseNoneForHim and true or false
  elseif myMat == noneWallMat and hisMat ~= noneWallMat then
    return true, not reverseNoneForMe and true or false
  end
  return false
end
function Slab:IsOffset()
  return false
end
function RoofWallSlab:IsOffset()
  local x1, y1, z1 = WallVoxelToWorld(WallWorldToVoxel(self))
  local x2, y2, z2 = self:GetPosXYZ()
  return x1 ~= x2 or y1 ~= y2
end
function WallSlab:ShouldSuppressSlab(otherSlab, material_preset)
  if self:IsSuppressionDisabled(otherSlab) then
    return 0
  end
  local importance_test = self:SuppressByImportance(otherSlab)
  if importance_test ~= 0 then
    return importance_test
  end
  local amIRoof = IsKindOf(self, "RoofWallSlab")
  local isHeRoof = IsKindOf(otherSlab, "RoofWallSlab")
  if isHeRoof and not amIRoof then
    return 1
  elseif not isHeRoof and amIRoof then
    return -1
  end
  local mr = self.room
  local reverseNoneForMe = IsValid(mr) and (amIRoof and mr.none_roof_wall_mat_does_not_affect_nbrs or not amIRoof and mr.none_wall_mat_does_not_affect_nbrs) or false
  local hr = otherSlab.room
  local reverseNoneForHim = IsValid(hr) and (isHeRoof and hr.none_roof_wall_mat_does_not_affect_nbrs or not isHeRoof and hr.none_wall_mat_does_not_affect_nbrs) or false
  local r1, r2 = TestMaterials(self.material, otherSlab.material, reverseNoneForMe, reverseNoneForHim)
  if r1 then
    return r2 and 1 or -1
  end
  if isHeRoof and amIRoof then
    return 0
  end
  local material_test = self:SuppressByMaterial(otherSlab, material_preset)
  if material_test ~= 0 then
    return material_test
  end
  if IsValid(self.room) and IsValid(otherSlab.room) then
    return self.room.handle - otherSlab.room.handle
  end
  if not IsValid(self.room) and IsValid(otherSlab.room) then
    return -1
  end
  if IsValid(self.room) and not IsValid(otherSlab.room) then
    return 1
  end
  return self.handle - otherSlab.handle
end
function FloorSlab:ShouldSuppressSlab(otherSlab, material_preset)
  if self:IsSuppressionDisabled(otherSlab) then
    return 0
  end
  local importance_test = self:SuppressByImportance(otherSlab)
  if importance_test ~= 0 then
    return importance_test
  end
  local reverseNoneForMe = IsValid(self.room) and self.room.none_floor_mat_does_not_affect_nbrs or false
  local reverseNoneForHim = IsValid(otherSlab.room) and otherSlab.room.none_floor_mat_does_not_affect_nbrs or false
  local r1, r2 = TestMaterials(self.material, otherSlab.material, reverseNoneForMe, reverseNoneForHim)
  if r1 then
    return r2 and 1 or -1
  end
  local material_test = self:SuppressByMaterial(otherSlab, material_preset)
  if material_test ~= 0 then
    return material_test
  end
  if IsValid(self.room) and IsValid(otherSlab.room) then
    local amIRoof = self.room:IsRoofOnly()
    local isHeRoof = otherSlab.room:IsRoofOnly()
    if isHeRoof and not amIRoof then
      return 1
    elseif amIRoof and not isHeRoof then
      return -1
    end
    return self.room.handle - otherSlab.room.handle
  end
  if not IsValid(self.room) and IsValid(otherSlab.room) then
    return -1
  end
  if IsValid(self.room) and not IsValid(otherSlab.room) then
    return 1
  end
  return self.handle - otherSlab.handle
end
CeilingSlab.ShouldSuppressSlab = FloorSlab.ShouldSuppressSlab
cornerToWallSides = {
  East = {"East", "North"},
  South = {"East", "South"},
  West = {"West", "South"},
  North = {"West", "North"}
}
function RoomCorner:ShouldSuppressSlab(otherSlab, material_preset)
  if self:IsSuppressionDisabled(otherSlab) then
    return 0
  end
  local importance_test = self:SuppressByImportance(otherSlab)
  if importance_test ~= 0 then
    return importance_test
  end
  local amIRoof = IsKindOf(self, "RoofCornerWallSlab")
  local isHeRoof = IsKindOf(otherSlab, "RoofCornerWallSlab")
  if isHeRoof and not amIRoof then
    return 1
  elseif not isHeRoof and amIRoof then
    return -1
  elseif isHeRoof and amIRoof then
    return 0
  end
  local r1, r2 = TestMaterials(self.material, otherSlab.material)
  r2 = not r2
  if r1 then
    return r2 and 1 or -1
  end
  local material_test = self:SuppressByMaterial(otherSlab, material_preset)
  if material_test ~= 0 then
    return material_test
  end
  if IsValid(self.room) and IsValid(otherSlab.room) then
    local myC, hisC = 0, 0
    local myAdj = cornerToWallSides[self.side]
    local hisAdj = cornerToWallSides[otherSlab.side]
    for i = 1, 2 do
      myC = myC + (self.room:GetWallMatHelperSide(myAdj[i]) == noneWallMat and 1 or 0)
      hisC = hisC + (otherSlab.room:GetWallMatHelperSide(hisAdj[i]) == noneWallMat and 1 or 0)
    end
    if myC ~= hisC then
      return hisC - myC
    end
    return self.room.handle - otherSlab.room.handle
  end
  return self.handle - otherSlab.handle
end
function CSlab:ShouldSuppressSlab(otherSlab)
  return 0
end
function CSlab:SuppressByMaterial(slab, material_preset)
  local mp_self = material_preset or self:GetMaterialPreset()
  local mp_slab = slab:GetMaterialPreset()
  return (mp_self and mp_self.strength or 0) - (mp_slab and mp_slab.strength or 0)
end
function CSlab:SuppressByImportance(slab)
  return self.class_suppression_strenght - slab.class_suppression_strenght
end
function CSlab:IsSuppressionDisabled(slab)
  return self == slab or self.always_visible or slab.always_visible
end
function GetTopmostWallSlab(slab)
  return MapGetFirst(slab, 0, "WallSlab", function(o)
    return o.isVisible
  end)
end
CSlab.visibility_pass = 1
function CSlab:ComputeVisibility(passed)
  self:SetSuppressor(false)
end
function CSlab:ComputeVisibilityAround()
  ComputeSlabVisibilityInBox(self:GetObjectBBox())
end
local PassSlab = function(slab, passed)
  passed[slab] = true
end
local topMySide, topOpSide
function OnMsg.DoneMap()
  topMySide = nil
  topOpSide = nil
end
local PassWallSlabs = function(slab, self, passed, mpreset)
  if slab == self then
    return
  end
  if slab:GetAngle() == self:GetAngle() then
    local r = topMySide:ShouldSuppressSlab(slab, mpreset)
    if 0 < r then
      PassSlab(slab, passed)
      slab:SetSuppressor(topMySide, self)
    elseif r < 0 and topMySide:SetSuppressor(slab, self) then
      topMySide = slab
    end
  else
    local r = topOpSide and topOpSide:ShouldSuppressSlab(slab, mpreset) or 0
    if 0 < r then
      PassSlab(slab, passed)
      slab:SetSuppressor(topOpSide, self)
    elseif r < 0 and topOpSide:SetSuppressor(slab, self) then
      topOpSide = slab
    end
    topOpSide = topOpSide or slab
  end
end
function WallSlab:ComputeVisibility(passed)
  passed = passed or {}
  local mpreset = self:GetMaterialPreset()
  topMySide = self
  topOpSide = false
  local is_permanent = self:GetGameFlags(gofPermanent) ~= 0
  local gameFlags = is_permanent and gofPermanent or nil
  MapForEach(self, 0, "WallSlab", nil, nil, gameFlags, PassWallSlabs, self, passed, mpreset)
  local top = topMySide
  local variant = false
  local m1 = noneWallMat
  local m2 = noneWallMat
  local c2
  if top and topOpSide then
    local isTopRoof = IsKindOf(top, "RoofWallSlab")
    local isOpTopRoof = IsKindOf(topOpSide, "RoofWallSlab")
    if isTopRoof ~= isOpTopRoof then
      if isTopRoof and not isOpTopRoof then
        PassSlab(top, passed)
        if top:SetSuppressor(topOpSide, self) then
          top = topOpSide
          topOpSide = false
        end
      elseif not isTopRoof and isOpTopRoof then
        PassSlab(topOpSide, passed)
        if topOpSide:SetSuppressor(top, self) then
          topOpSide = false
        end
      end
    end
  end
  local opSideCompResult
  if topOpSide then
    variant = "IndoorIndoor"
    opSideCompResult = top:ShouldSuppressSlab(topOpSide, mpreset)
    if 0 < opSideCompResult then
      topOpSide:SetSuppressor(top, self)
      m1 = top.room and top.room.inner_wall_mat or top.indoor_material_1 or noneWallMat
      m2 = topOpSide.room and topOpSide.room.inner_wall_mat or topOpSide.indoor_material_1 or noneWallMat
      c2 = topOpSide.room and topOpSide.room.inner_colors
    elseif opSideCompResult < 0 then
      if top:SetSuppressor(topOpSide, self) then
        top = topOpSide
      end
      m1 = top.room and top.room.inner_wall_mat or top.indoor_material_1 or noneWallMat
      m2 = topMySide.room and topMySide.room.inner_wall_mat or topMySide.indoor_material_1 or noneWallMat
      c2 = topMySide.room and topMySide.room.inner_colors
      if top.wall_obj then
        passed[top] = nil
      end
    elseif opSideCompResult == 0 then
      passed[topOpSide] = nil
      m1 = top.room and top.room.inner_wall_mat or top.indoor_material_1 or noneWallMat
    end
    if m2 == noneWallMat and m1 == noneWallMat then
      variant = "Outdoor"
    elseif m2 == noneWallMat then
      variant = "OutdoorIndoor"
    elseif m1 == noneWallMat then
      variant = "Outdoor"
    end
  else
    local indoorMat = top.room and top.room.inner_wall_mat or top.indoor_material_1
    if indoorMat == noneWallMat then
      variant = "Outdoor"
    else
      variant = "OutdoorIndoor"
      m1 = indoorMat
    end
  end
  if top.material == noneWallMat and not top.always_visible then
    top:SetSuppressor(self)
  else
    if top.exterior_attach_colors == c2 then
      top:Setexterior_attach_colors(false)
    end
    if top:ShouldUpdateEntity(self) and (top.variant ~= variant or top.indoor_material_2 ~= m2 or top.exterior_attach_colors_from_nbr ~= c2) then
      local newVar = variant
      if not IsValid(top.room) then
        newVar = top.variant
        m2 = top.indoor_material_2
      end
      if top.forceVariant ~= "" then
        newVar = top.forceVariant
      end
      local defaults = getmetatable(top)
      top.variant = newVar ~= defaults.variant and newVar or nil
      top.indoor_material_2 = m2 ~= defaults.indoor_material_2 and m2 or nil
      top:Setexterior_attach_colors_from_nbr(c2)
      top:UpdateEntity()
      top:UpdateVariantEntities()
    end
    top:SetSuppressor(false, self)
  end
  if top.room and not top.room:IsRoofOnly() and IsKindOf(top, "RoofWallSlab") then
    local pos = top:GetPos()
    local adjacent_rooms = top.room.adjacent_rooms or empty_table
    for _, adj_room in ipairs(adjacent_rooms) do
      local data = adjacent_rooms[adj_room]
      if not adj_room.being_placed and not adj_room:IsRoofOnly() and adj_room.box ~= data[1] then
        local adj_box = adj_room.box:grow(1, 1, 0)
        local in_box_3d = pos:InBox(adj_box)
        if not in_box_3d and top.room.floor < adj_room.floor then
          local rb = adj_room.roof_box
          if rb then
            rb = rb:grow(1, 1, 0)
            in_box_3d = pos:InBox(rb)
          end
        end
        if in_box_3d then
          top:SetSuppressor(self)
          if topOpSide and opSideCompResult == 0 then
            topOpSide:SetSuppressor(self)
          end
          break
        end
      end
    end
  end
  topMySide = nil
  topOpSide = nil
end
local floor_top
function OnMsg.DoneMap()
  floor_top = nil
end
local FloorPassFloorAndCeilingSlabs = function(slab, self, passed, mpreset)
  if slab == self then
    return
  end
  local comp = floor_top:ShouldSuppressSlab(slab, mpreset)
  if comp == 0 then
    return
  end
  PassSlab(slab, passed)
  if 0 < comp then
    slab:SetSuppressor(floor_top, self)
  elseif floor_top:SetSuppressor(slab, self) then
    floor_top = slab
  end
end
local FloorPassRoofPlaneAndEdgeSlabs = function(slab, floor_top, topZ, passed, self)
  local dz = topZ - select(3, slab:GetPosXYZ())
  if 0 < dz and dz <= voxelSizeZ then
    PassSlab(slab, passed)
    slab:SetSuppressor(floor_top, self)
  end
end
function FloorSlab:ComputeVisibility(passed)
  passed = passed or {}
  floor_top = self
  local mpreset = self:GetMaterialPreset()
  local is_permanent = self:GetGameFlags(gofPermanent) ~= 0
  local gameFlags = is_permanent and gofPermanent or nil
  MapForEach(self, 0, "FloorSlab", "CeilingSlab", nil, nil, gameFlags, FloorPassFloorAndCeilingSlabs, self, passed, mpreset)
  if floor_top.material == noneWallMat then
    floor_top:SetSuppressor(floor_top, self)
  else
    floor_top:SetSuppressor(false, self)
    MapForEach(floor_top, halfVoxelSizeX, "RoofPlaneSlab", "RoofEdgeSlab", nil, nil, gameFlags, FloorPassRoofPlaneAndEdgeSlabs, floor_top, select(3, floor_top:GetPosXYZ()), passed, self)
  end
  floor_top = nil
end
CeilingSlab.ComputeVisibility = FloorSlab.ComputeVisibility
function SlabWallObject:ComputeVisibility(passed)
  self:UpdateAffectedWalls()
end
local roof_suppressed
function OnMsg.DoneMap()
  roof_suppressed = nil
end
local RoofPassRoofEdgeAndCornerSlabs = function(slab, self, passed, z)
  if slab == self or slab.room == self.room or slab:GetAngle() == self:GetAngle() and slab:GetMirrored() == self:GetMirrored() or self:IsSuppressionDisabled(slab) then
    return
  end
  local _, _, slab_z = slab:GetPosXYZ()
  if z < slab_z then
    roof_suppressed = true
    return
  end
  PassSlab(slab, passed)
  if slab:SetSuppressor(self) and z == slab_z then
    roof_suppressed = true
  end
end
function RoofSlab:ComputeVisibility(passed)
  passed = passed or {}
  roof_suppressed = nil
  local is_permanent = self:GetGameFlags(gofPermanent) ~= 0
  local gameFlags = is_permanent and gofPermanent or nil
  if self.room and not self.room:IsRoofOnly() then
    local passed = {}
    local CheckSuppressed = function(adj_room, pos, adjacent_rooms, slab_room, passed)
      local data = adjacent_rooms[adj_room]
      if not passed[adj_room] then
        passed[adj_room] = true
        if slab_room ~= adj_room and not adj_room:IsRoofOnly() and not adj_room.being_placed and (not data or adj_room.box ~= data[1]) then
          local adj_box = adj_room.box:grow(1, 1, 1)
          local in_box = pos:InBox(adj_box)
          if not in_box and (slab_room.floor or 0) < (adj_room.floor or 0) then
            local rb = adj_room.roof_box
            if rb then
              rb = rb:grow(1, 1, 0)
              in_box = pos:InBox(rb)
            end
          end
          if in_box then
            roof_suppressed = true
            return "break"
          end
        end
      end
    end
    local pos = self:GetPos()
    local adjacent_rooms = self.room.adjacent_rooms or empty_table
    local sbox = self:GetObjectBBox()
    EnumVolumes(sbox:grow(1, 1, 1), CheckSuppressed, pos, adjacent_rooms, self.room, passed)
    if not roof_suppressed then
      for _, adj_room in ipairs(adjacent_rooms) do
        if CheckSuppressed(adj_room, pos, adjacent_rooms, self.room, passed) == "break" then
          break
        end
      end
    end
  end
  if not roof_suppressed and const.SuppressMultipleRoofEdges and IsKindOfClasses(self, "RoofEdgeSlab", "RoofCorner") then
    local x, y, z = self:GetPosXYZ()
    MapForEach(x, y, guic, "RoofEdgeSlab", "RoofCorner", nil, nil, gameFlags, RoofPassRoofEdgeAndCornerSlabs, self, passed, z)
  end
  if roof_suppressed then
    self:SetSuppressor(self)
  else
    self:SetSuppressor(false)
  end
  roof_suppressed = nil
end
local dev = Platform.developer
RoomCorner.visibility_pass = 2
function RoomCorner:ComputeVisibility(passed)
  local _, _, z = self:GetPosXYZ()
  local topSlab = self
  local mpreset = self:GetMaterialPreset()
  local is_permanent = self:GetGameFlags(gofPermanent) ~= 0
  local gameFlags = is_permanent and gofPermanent or nil
  MapForEach(self, halfVoxelSizeX, "RoomCorner", nil, nil, gameFlags, function(slab, self, z, mpreset)
    if slab == self then
      return
    end
    local _, _, z1 = slab:GetPosXYZ()
    if z1 ~= z or self.isPlug ~= slab.isPlug then
      return
    end
    if slab:ShouldUpdateEntity(self) then
      slab:UpdateEntity()
    end
    local comp = topSlab:ShouldSuppressSlab(slab, mpreset)
    if 0 < comp then
      slab:SetSuppressor(topSlab, self)
    elseif comp < 0 and topSlab:SetSuppressor(slab, self) then
      topSlab = slab
    end
  end, self, z, mpreset)
  if topSlab:ShouldUpdateEntity(self) then
    topSlab:UpdateEntity()
  end
  if topSlab.entity ~= "InvisibleObject" and IsValidEntity(topSlab.entity) or dev and topSlab.entity == "InvisibleObject" and topSlab.is_destroyed then
    topSlab:SetSuppressor(false, self)
  else
    topSlab:SetSuppressor(topSlab, self)
  end
end
StairSlab.visibility_pass = 3
function StairSlab:ComputeVisibility(passed)
  if self:GetEnumFlags(const.efVisible) == 0 then
    return
  end
  local is_permanent = self:GetGameFlags(gofPermanent) ~= 0
  local gameFlags = is_permanent and gofPermanent or nil
  local x, y, z = self:GetPosXYZ()
  if z then
    local max = self.hide_floor_slabs_above_in_range
    for i = 1, max do
      z = z + voxelSizeZ
      MapForEach(x, y, z, 0, "FloorSlab", nil, nil, gameFlags, function(slab, self)
        slab:SetSuppressor(self)
      end, self)
    end
  else
    print(string.format("Stairs with handle[%d] have an invalid Z!", stairs_slab.handle))
  end
end
local _ComputeSlabVisibility = function(boxes)
  local passed = {}
  local max_pass = 1
  local passes
  for i = 1, #boxes do
    local _box = boxes[i]:grow(1, 1, 1)
    MapForEach(_box, "CSlab", function(slab)
      if passed[slab] then
        return
      end
      local pass = slab.visibility_pass
      if pass == 1 then
        PassSlab(slab, passed)
        slab:ComputeVisibility(passed)
      else
        max_pass = Max(max_pass, pass)
        passes = passes or {}
        passes[pass] = table.create_add(passes[pass], slab)
      end
    end)
  end
  for i = 2, max_pass do
    for _, slab in ipairs(passes[i] or empty_table) do
      if not passed[slab] then
        PassSlab(slab, passed)
        slab:ComputeVisibility(passed)
      end
    end
  end
end
function ComputeSlabVisibility()
  local boxes = g_BoxesToCompute
  g_BoxesToCompute = false
  if not boxes then
    return
  end
  SuspendPassEdits("ComputeSlabVisibility")
  procall(_ComputeSlabVisibility, boxes)
  ResumePassEdits("ComputeSlabVisibility")
  Msg("SlabVisibilityComputeDone")
end
function DeleteOrphanCorners()
  MapForEach("map", "RoomCorner", nil, nil, gofPermanent, function(o)
    if not o.room then
      DoneObject(o)
    end
  end)
end
function DeleteOrphanWalls()
  local c = 0
  MapForEach("map", "WallSlab", nil, nil, gofPermanent, function(o)
    if not o.room then
      DoneObject(o)
      c = c + 1
    end
  end)
  print("deleted: ", c)
end
function RecreateSelectedSlabFloorWall_RestoreSel(t)
  editor.ClearSel()
  for i = 1, #t do
    local entry = t[i]
    local o = MapGet(entry[2], 0, entry[1], nil, nil, gofPermanent, function(o, room)
      return o.room == room
    end, entry[3])
    if o then
      editor.AddToSel(o)
    end
  end
end
function RecreateSelectedSlabFloorWall()
  local ol = editor.GetSel()
  local restoreSel = {}
  local walls = {}
  local floors = {}
  for i = 1, #ol do
    local o = ol[i]
    local room = o.room
    if IsValid(room) then
      if IsKindOf(o, "WallSlab") then
        table.insert(restoreSel, {
          o.class,
          o:GetPos(),
          room
        })
        table.insert_unique(walls, room)
      elseif IsKindOf(o, "FloorSlab") then
        table.insert(restoreSel, {
          o.class,
          o:GetPos(),
          room
        })
        table.insert_unique(floors, room)
      end
    end
  end
  for i = 1, #walls do
    walls[i]:RecreateWalls()
  end
  for i = 1, #floors do
    floors[i]:RecreateFloor()
  end
  if 0 < #restoreSel then
    DelayedCall(0, RecreateSelectedSlabFloorWall_RestoreSel, restoreSel)
  end
end
local defaultColorMod = RGBA(100, 100, 100, 255)
function Slab:ApplyColorModFromSource(source)
  local cm = source:GetColorModifier()
  if cm ~= defaultColorMod then
    self:SetColorModifier(cm)
  end
end
function Slab:EditorCallbackClone(source)
  self.room = false
  self.subvariant = source.subvariant
  self:Setcolors(source.colors)
  self:Setinterior_attach_colors(source.interior_attach_colors)
  self:Setexterior_attach_colors(source.exterior_attach_colors)
  self:Setexterior_attach_colors_from_nbr(source.exterior_attach_colors_from_nbr)
  self:ApplyColorModFromSource(source)
end
function WallSlab:EditorCallbackClone(source)
  Slab.EditorCallbackClone(self, source)
  self:Setcolors(not source.colors and source.room and source.room.outer_colors)
  self:Setinterior_attach_colors(not source.interior_attach_colors and source.room and source.room.inner_colors)
  self:ApplyColorModFromSource(source)
end
function FloorSlab:EditorCallbackClone(source)
  Slab.EditorCallbackClone(self, source)
  self:Setcolors(not source.colors and source.room and source.room.floor_colors)
  self:ApplyColorModFromSource(source)
end
function SlabWallObject:EditorCallbackClone(source)
  if self.owned_slabs == source.owned_slabs then
    self.owned_slabs = false
  end
  self.room = false
  self.subvariant = source.subvariant
  self:SetColorization(source)
end
function RoofSlab:EditorCallbackClone(source)
  Slab.EditorCallbackClone(self, source)
  self:Setcolors(not source.colors and source.room and source.room.roof_colors)
  self:ApplyColorModFromSource(source)
  local x, y = source:GetSkew()
  self:SetSkew(x, y)
end
function OnMsg.GedPropertyEdited(ged_id, obj, prop_id, old_value)
  if obj.class == "ColorizationPropSet" then
    local ged = GedConnections[ged_id]
    local name = ged:ResolveName(obj)
    local parent = ged:GetParentObject(name)
    local prop_id = ""
    if parent then
      for _, value in ipairs(parent:GetProperties()) do
        if parent:GetProperty(value.id) == obj then
          prop_id = value.id
          break
        end
      end
    end
    if IsKindOf(parent, "Slab") then
      ged:NotifyEditorSetProperty(parent, prop_id, obj)
      parent:SetProperty(prop_id, obj)
    elseif IsKindOf(parent, "Room") then
      parent:OnEditorSetProperty(prop_id, old_value, ged)
    end
  end
end
local similarSlabPropsToMatch = {
  "entity_base_name",
  "material",
  "variant",
  "indoor_material_1",
  "indoor_material_2"
}
function EditorSelectSimilarSlabs(matchSubvariant)
  local sel = editor.GetSel()
  local o = #(sel or "") > 0 and sel[1]
  if not o then
    print("No obj selected.")
    return
  end
  if not IsKindOf(o, "Slab") then
    print("Obj not a Slab.")
    return
  end
  local newSel = {o}
  MapForEach("map", "Slab", function(s, o, newSel, similarSlabPropsToMatch)
    if o ~= s then
      local similar = true
      for i = 1, #similarSlabPropsToMatch do
        local p = similarSlabPropsToMatch[i]
        if s[p] ~= o[p] then
          similar = false
          break
        end
      end
      if similar and (not matchSubvariant or s:GetEntity() == o:GetEntity()) then
        table.insert(newSel, s)
      end
    end
  end, o, newSel, similarSlabPropsToMatch)
  editor.ClearSel()
  editor.AddToSel(newSel)
end
function DbgRestoreDefaultsFor_forceInvulnerableBecauseOfGameRules()
  MapForEach("map", "Slab", function(o)
    if not o.room then
      o.forceInvulnerableBecauseOfGameRules = g_Classes[o.class].forceInvulnerableBecauseOfGameRules
    elseif IsKindOf(o, "FloorSlab") and o.floor == 1 then
      o.forceInvulnerableBecauseOfGameRules = true
    else
      o.forceInvulnerableBecauseOfGameRules = false
    end
  end)
end
slab_missing_entity_white_list = {}
function CSlab:ReportMissingSlabEntity(ent)
  if not slab_missing_entity_white_list[ent] then
    print(string.format("[WARNING] Missing slab entity %s, reporting slab handle [%d], class [%s], material [%s], variant [%s], map [%s]", ent or tostring(ent), self.handle, self.class, self.material, self.variant, GetMapName()))
    slab_missing_entity_white_list[ent] = true
  end
  self.bad_entity = true
end
function GetBadEntitySlabsOnMap()
  return MapGet("map", "Slab", function(o)
    return o.bad_entity
  end)
end
function IsSlabPassable(o)
  if o:GetSkewX() == 0 and o:GetSkewY() == 0 then
    local sp = o:GetSpotPos(o:GetSpotBeginIndex("Slab"))
    if SnapToVoxel(sp) == sp then
      return true
    end
  end
  return false
end
function ValidateSlabs()
  local slabs = MapGet("map", "Slab", nil, nil, const.gofPermanent)
  local killedSlabs = 0
  local resetDestroyed = 0
  local passedNbrs = {}
  local slabsWithDestroyedNbrs = {}
  for _, slab in ipairs(slabs) do
    local e = slab:GetEntity()
    local isInvisibleObj = e == "InvisibleObject"
    local isInvisible = not slab.isVisible and not isInvisibleObj or slab.material == noneWallMat
    if isInvisible and not slab.room then
      DoneObject(slab)
      killedSlabs = killedSlabs + 1
    elseif isInvisible and (slab.is_destroyed or slab.destroyed_neighbours ~= 0) then
      slab:ResetDestroyedState()
      resetDestroyed = resetDestroyed + 1
    end
    if not isInvisible then
      if slab.is_destroyed then
        local proc = function(nbr, i)
          passedNbrs[nbr] = true
          local f = GetNeigbhourSideFlagTowardMe(1 << i - 1, nbr, slab)
          if nbr.destroyed_neighbours & f == 0 then
            nbr.destroyed_neighbours = nbr.destroyed_neighbours | f
          end
        end
        local nbrs = {
          slab:GetNeighbours()
        }
        nbrs[1], nbrs[2], nbrs[3], nbrs[4] = nbrs[3], nbrs[4], nbrs[1], nbrs[2]
        for i = 1, 4 do
          local nbrs2 = nbrs[i]
          if IsValid(nbrs2) then
            proc(nbrs2, i)
          else
            for j, nbr in ipairs(nbrs2) do
              proc(nbr, i)
            end
          end
        end
      elseif slab.destroyed_neighbours ~= 0 then
        slabsWithDestroyedNbrs[slab] = true
      end
    end
    if IsKindOf(slab, "Lockpickable") and slab:IsBlockedDueToRoom() and slab.lockpickState ~= "blocked" then
      slab:SetlockpickState("blocked")
    end
  end
  for slab, _ in pairs(slabsWithDestroyedNbrs) do
    if not passedNbrs[slab] then
      for i = 0, 3 do
        local dn = slab.destroyed_neighbours
        local f = 1 << i
        if dn & f ~= 0 then
          local nbr = slab:GetNeighbour(f)
          if nbr and not nbr.is_destroyed then
            slab.destroyed_neighbours = slab.destroyed_neighbours & ~f
          end
        end
      end
    end
  end
  if 0 < killedSlabs then
    print("Killed invisible roomless slabs ", killedSlabs)
  end
  if 0 < resetDestroyed then
    print("Repaired invisible destroyed slabs ", resetDestroyed)
  end
  EnumVolumes(function(v)
    if v.ceiling_mat ~= noneWallMat and not v.build_ceiling then
      v.ceiling_mat = nil
    end
  end)
end
function OnMsg.ValidateMap()
  if IsEditorActive() and not mapdata.IsRandomMap and mapdata.GameLogic then
    ValidateSlabs()
  end
end
function testInvulnerableSlabs(lst)
  lst = lst or MapGet("map", "RoomCorner", const.efVisible, function(o)
    return o.forceInvulnerableBecauseOfGameRules
  end)
  DbgClear()
  local c = 0
  for i = 1, #(lst or "") do
    DbgAddVector(lst[i])
    c = c + 1
  end
  print(c, #(lst or ""))
end
local invulnerableMaterials = {Concrete = true}
function FixInvulnerabilityStateOfOwnedSlabsOnMap()
  local makeInvul = function(o, val)
    o.invulnerable = val
    o.forceInvulnerableBecauseOfGameRules = val
  end
  EnumVolumes(function(r)
    local invul = r.outside_border
    local firstFloor = not r:IsRoofOnly() and r.floor == 1
    r:ForEachSpawnedObj(function(o, invul)
      if firstFloor and IsKindOf(o, "FloorSlab") or invul or invulnerableMaterials[o.material] and IsKindOf(o, "WallSlab") then
        makeInvul(o, true)
      else
        makeInvul(o, false)
      end
    end, invul)
  end)
end
if Platform.developer then
  function DeleteSelectedSlabsWithoutPropagation()
    for _, obj in ipairs(editor.GetSel() or empty_table) do
      rawset(obj, "dont_propagate_deletion", true)
    end
    editor.DelSelWithUndoRedo()
  end
  function Slab:Done()
    if IsEditorActive() then
      if EditorCursorObjs[self] then
        return
      end
      if not self.isVisible then
        return
      end
      if rawget(self, "dont_propagate_deletion") then
        return
      end
      MapForEach(self, 0, self.class, function(o, self)
        if o ~= self and not o.isVisible then
          rawset(o, "dont_propagate_deletion", true)
          DoneObject(o)
        end
      end, self)
    end
  end
end
