if FirstLoad then
  RoofVisualsEnabled = true
  GableRoofDirections = {
    "North-South",
    "East-West"
  }
end
local voxelSizeX = const.SlabSizeX or 0
local voxelSizeY = const.SlabSizeY or 0
local voxelSizeZ = const.SlabSizeZ or 0
local halfVoxelSizeX = voxelSizeX / 2
local halfVoxelSizeY = voxelSizeY / 2
local halfVoxelSizeZ = voxelSizeZ / 2
local InvalidZ = const.InvalidZ
local noneWallMat = const.SlabNoMaterial
CardinalDirectionNames = {
  "East",
  "South",
  "West",
  "North"
}
local cardinal_direction_names = CardinalDirectionNames
local cardinal_directions = {
  0,
  5400,
  10800,
  16200,
  East = 0,
  South = 5400,
  West = 10800,
  North = 16200
}
local cardinal_steps = {
  point(voxelSizeX, 0, 0),
  point(0, voxelSizeY, 0),
  point(-voxelSizeX, 0, 0),
  point(0, -voxelSizeY, 0)
}
local cardinal_offsets = {
  {
    voxelSizeX,
    0,
    0
  },
  {
    0,
    voxelSizeY,
    5400
  },
  {
    -voxelSizeX,
    0,
    10800
  },
  {
    0,
    -voxelSizeY,
    16200
  }
}
function GetCardinalOffsets()
  return cardinal_offsets
end
DefineClass.SkewAlign = {
  __parents = {"CObject"},
  flags = {cfSkewAlign = true}
}
DefineClass.RoomRoof = {
  __parents = {
    "PropertyObject"
  },
  properties = {
    {
      category = "Roof",
      id = "roof_type",
      name = "Roof Type",
      editor = "preset_id",
      default = "",
      preset_class = "RoofTypes"
    },
    {
      category = "Roof",
      id = "roof_mat",
      name = "Roof Material",
      editor = "preset_id",
      preset_class = "SlabPreset",
      preset_group = "RoofSlabMaterials",
      default = ""
    },
    {
      category = "Roof",
      id = "roof_parapet",
      name = "Roof Parapet",
      editor = "bool",
      default = false
    },
    {
      category = "Roof",
      id = "roof_direction",
      name = "Roof Direction",
      editor = "dropdownlist",
      items = function(obj)
        return obj:IsAnyOfRoofTypes("Gable") and GableRoofDirections or cardinal_direction_names
      end,
      default = "North",
      no_edit = function(obj)
        return not obj:IsAnyOfRoofTypes("Shed", "Gable")
      end
    },
    {
      category = "Roof",
      id = "roof_inclination",
      name = "Roof Inclination",
      editor = "number",
      scale = "deg",
      default = 1200,
      min = 0,
      max = 2700,
      slider = true,
      no_edit = function(obj)
        return not obj:IsAnyOfRoofTypes("Shed", "Gable")
      end
    },
    {
      category = "Roof",
      id = "roof_additional_height",
      name = "Additional Height",
      editor = "number",
      scale = "m",
      default = 0,
      min = 0,
      max = const.SlabSizeZ,
      slider = true
    },
    {
      category = "Roof",
      name = "Has Ceiling",
      id = "build_ceiling",
      editor = "bool",
      default = true
    },
    {
      category = "Roof",
      name = "Ceiling Material",
      id = "ceiling_mat",
      editor = "preset_id",
      preset_class = "SlabPreset",
      preset_group = "FloorSlabMaterials",
      extra_item = noneWallMat,
      default = noneWallMat
    },
    {
      category = "Roof",
      id = "roof_colors",
      name = "Roof Color Modifier",
      editor = "nested_obj",
      base_class = "ColorizationPropSet",
      inclusive = true,
      default = false
    },
    {
      category = "Not Room Specific",
      id = "roofVisualsEnabled",
      name = "Toggle Roof Visuals",
      default = true,
      editor = "bool",
      dont_save = true
    },
    {
      id = "roof_objs",
      no_edit = true,
      editor = "objects",
      default = false
    },
    {
      category = "Debug",
      id = "is_roof_visible",
      editor = "bool",
      default = true,
      dont_save = true,
      read_only = true
    },
    {
      id = "RoofInclinationIP",
      name = T(770322265919, "Roof Inclination"),
      editor = "number",
      default = 0,
      no_edit = true,
      dont_save = true,
      min = 0,
      max = 2700
    },
    {
      category = "Roof",
      id = "keep_roof_passable",
      name = "Keep Roof Passable",
      editor = "bool",
      default = false
    },
    {
      category = "Roof",
      id = "roof_buttons",
      name = "Buttons",
      editor = "buttons",
      default = false,
      dont_save = true,
      read_only = true,
      buttons = {
        {
          name = "Make Roof Passable",
          func = "MakeRoofPassable"
        }
      }
    },
    {
      id = "vfx_roof_surface_controllers",
      editor = "objects",
      default = false,
      dont_save = true,
      no_edit = true
    },
    {
      id = "vfx_eaves_controllers",
      editor = "objects",
      default = false,
      dont_save = true,
      no_edit = true
    }
  },
  roof_box = false,
  prop_map = false,
  box_at_last_roof_edit = false,
  rr_recursing = false
}
function RoomRoof:GetRoofInclinationIP()
  return self.roof_inclination
end
function RebuildChimneysInBox2D()
end
function RoomRoof:SetRoofInclinationIP(roof_inclination)
  if self.roof_inclination ~= roof_inclination then
    NetSyncEvent("ObjFunc", self, "rfnSetRoofInclination", roof_inclination)
  end
end
function RoomRoof:rfnSetRoofInclination(roof_inclination)
  if self.roof_inclination ~= roof_inclination then
    self.roof_inclination = roof_inclination
    self:RecreateRoof()
    ObjModified(self)
  end
end
function RoomRoof:GetRoofSize()
  return self.size
end
function RoomRoof:GetRoofType()
  return self.roof_type
end
function RoomRoof:GetRoofEntitySet()
  local roof_mat = self.roof_mat or ""
  if roof_mat == "" then
    return
  end
  local preset = Presets.SlabPreset.RoofSlabMaterials[roof_mat]
  return preset and preset.EntitySet or ""
end
function RoomRoof:GetRoofInclination()
  if self:GetRoofType() == "Flat" then
    return 0
  end
  return self.roof_inclination
end
function RoomRoof:HasRoofSet()
  return self.roof_mat ~= "" and self.roof_type ~= ""
end
function RoomRoof:HasRoomAbove()
  local bbox = self.box:grow(const.SlabSizeX, const.SlabSizeY, const.SlabSizeZ)
  local volumes = EnumVolumes(bbox, function(volume)
    if volume.floor == self.floor + 1 then
      return true
    end
  end)
  return volumes and 0 < #volumes
end
function RoomRoof:HasRoof(scan_rooms_above)
  if self:HasRoofSet() then
    if self:IsRoofOnly() then
      return true
    end
    local mrz = self:GetPos():z() + self.size:z() * voxelSizeZ
    if self:GetBiggestEncompassingRoom(function(o)
      if not o:HasRoof() then
        return false
      end
      local rz = o:GetPos():z() + o.size:z() * voxelSizeZ
      return rz >= mrz
    end) ~= self then
      return scan_rooms_above and self:HasRoomAbove()
    end
    local adjacent_rooms = self.adjacent_rooms or empty_table
    local sb = self.box
    local minx, miny, _ = sb:min():xyz()
    local maxx, maxy, _ = sb:max():xyz()
    local boxes = {}
    local totalFace = 0
    local myFace = (maxx - minx) * (maxy - miny)
    for _, room in ipairs(adjacent_rooms) do
      local data = adjacent_rooms[room]
      local ib = data[1]
      if not room.being_placed and table.find(data[2], "Roof") and ib:sizez() == 0 then
        local hisFace = (ib:maxx() - ib:minx()) * (ib:maxy() - ib:miny())
        for i = 1, #boxes do
          local iib = IntersectRects(ib, boxes[i])
          if iib:IsValid() then
            local overlap = (iib:maxx() - iib:minx()) * (iib:maxy() - iib:miny())
            hisFace = hisFace - overlap
          end
        end
        table.insert(boxes, ib)
        totalFace = totalFace + hisFace
      end
    end
    if myFace - totalFace <= 0 then
      return scan_rooms_above and self:HasRoomAbove()
    end
    return true
  end
  return scan_rooms_above and self:HasRoomAbove()
end
function RoomRoof:IsAnyOfRoofTypes(...)
  local roof_type = self:GetRoofType()
  for i = 1, select("#", ...) do
    if roof_type == select(i, ...) then
      return true
    end
  end
end
function RoomRoof:GetRoofThickness()
  local entity_set = self:GetRoofEntitySet()
  if entity_set == "" then
    return 0
  end
  local entity_name = string.format("Roof_%s_Plane_01", entity_set)
  if not IsValidEntity(entity_name) then
    return 0
  end
  local bbox = GetEntityBoundingBox(entity_name)
  return bbox:sizez()
end
function RoomRoof:SetRoofVisibility(visible)
  local objs = self.roof_objs
  if not objs or #objs <= 0 then
    return
  end
  if self.is_roof_visible == visible then
    return
  end
  self.is_roof_visible = visible
  local hide = not visible
  for i = 1, #objs do
    local o = objs[i]
    if IsValid(o) then
      o:SetShadowOnly(hide)
    end
  end
  local wire_supporters = {}
  if g_Classes.WireSupporter and self.roof_box then
    local query_box = self.roof_box:grow(1)
    local min_z = query_box:minz()
    MapForEach(query_box, "WireSupporter", function(o, min_z, wire_supporters)
      local x, y, z = o:GetVisualPosXYZ()
      local is_on_roof = o:GetGameFlags(const.gofOnRoof) ~= 0
      if min_z <= z and is_on_roof then
        table.insert(wire_supporters, o)
      end
    end, min_z, wire_supporters)
  end
  ForEachConnectedWire(wire_supporters, function(wire)
    wire:SetVisible(visible)
  end)
  for side, t in sorted_pairs(self.spawned_windows or empty_table) do
    for i = 1, #(t or "") do
      local w = t[i]
      if w.hide_with_wall and IsKindOf(w.main_wall, "RoofWallSlab") then
        w:SetShadowOnly(hide)
      end
    end
  end
  if hide then
    ;(rawget(_G, "CollectionsToHideHideCollections") or empty_func)(self, "Roof")
  else
    ;(rawget(_G, "CollectionsToHideShowCollections") or empty_func)(self, "Roof")
  end
  self:SetVfxControllersVisibility(visible)
end
function RoomRoof:DeleteRoofObjs()
  for _, roof in ipairs(self.roof_objs) do
    if IsValid(roof) then
      DoneObject(roof)
    end
  end
  self.roof_objs = nil
end
function RoomRoof:PostProcessPlaneSlab(slab, is_flat)
  if is_flat then
    slab:ClearEnumFlags(const.efInclinedSlab)
    slab:SetEnumFlags(const.efApplyToGrids)
  elseif self:GetRoofInclination() <= const.MaxPassableTerrainSlope then
    slab:SetEnumFlags(const.efApplyToGrids | const.efInclinedSlab)
  else
    slab:ClearEnumFlags(const.efApplyToGrids | const.efInclinedSlab)
  end
end
local IsRoofTile = function(o)
  return not IsKindOfClasses(o, "RoofWallSlab", "RoofCornerWallSlab", "CeilingSlab", "DestroyableWallDecoration")
end
local slabPoint = point(voxelSizeX, voxelSizeY, voxelSizeZ)
local GetElHashId = function(o, pivots)
  pivots = pivots or o.room:GetPivots()
  if not IsRoofTile(o) then
    local s = o.side
    local dp = o:GetPos() - pivots[s]
    local x, y, z = abs(dp:x()) / voxelSizeX, abs(dp:y()) / voxelSizeY, abs(dp:z()) / voxelSizeZ
    return xxhash(s, x, y, z, IsKindOf(o, "RoomCorner") or false)
  else
    local dp = o:GetPos() - pivots[false]
    return xxhash(dp:x(), dp:y(), o:GetAngle(), o.class, rawget(o, "dir") or false)
  end
end
function RoomRoof:GetWallBeginPos(side, box)
  local b = box or self.box
  if side == "North" then
    return point(b:minx(), b:miny(), b:maxz())
  elseif side == "South" then
    return point(b:maxx(), b:maxy(), b:maxz())
  elseif side == "West" then
    return point(b:minx(), b:maxy(), b:maxz())
  else
    return point(b:maxx(), b:miny(), b:maxz())
  end
end
function RoomRoof:GetPivots(box)
  box = box or self.box
  local pivots = {}
  for _, side in ipairs(cardinal_direction_names) do
    pivots[side] = self:GetWallBeginPos(side, box)
  end
  pivots[false] = pivots.North
  return pivots
end
function RoomRoof:CleanupPropMap()
  self.prop_map = false
end
function RoomRoof:ApplyPropsFromPropObj(o, prop_map, pivots)
  prop_map = prop_map or self.prop_map
  pivots = pivots or self:GetPivots()
  if prop_map then
    local id = GetElHashId(o, pivots)
    local po = prop_map[id]
    if po then
      o:CopyProperties(po, po:GetProperties())
    end
  end
end
function RoomRoof:PopulatePropMap()
  self:CleanupPropMap()
  self.prop_map = {}
  local pivots = self:GetPivots(self.box_at_last_roof_edit or self.box)
  for i = 1, #(self.roof_objs or "") do
    local o = self.roof_objs[i]
    if IsValid(o) and not IsKindOfClasses(o, "CeilingSlab") then
      local id = GetElHashId(o, pivots)
      local propO = SlabPropHolder:new()
      propO:CopyProperties(o)
      self.prop_map[id] = propO
    end
  end
  self.prop_map.minz = self.box_at_last_roof_edit and self.box_at_last_roof_edit:maxz() or self.box:maxz()
  self.box_at_last_roof_edit = self.box
end
local visibilityStateForNewRoofPieces = true
function RoomRoof:RecreateRoof(force)
  SuspendPassEdits("RoomRoof")
  self:PopulatePropMap()
  self:DeleteRoofObjs()
  if self:HasRoofSet() and (force or self:HasRoof()) then
    visibilityStateForNewRoofPieces = self.is_roof_visible and RoofVisualsEnabled and (not IsEditorActive() or LocalStorage.FilteredCategories.Roofs)
    local roof_type = self:GetRoofType()
    local method_name = string.format("Create%sRoof", roof_type)
    local method = self[method_name]
    self.roof_objs, self.roof_box = method(self)
    if self.build_ceiling then
      self:CreateCeiling(self.roof_objs)
    end
    self:SnapObjects()
  end
  visibilityStateForNewRoofPieces = true
  self:UpdateRoofSlabVisibility()
  if not self.is_roof_visible then
    self.is_roof_visible = true
    self:SetRoofVisibility(false)
  end
  if not RoofVisualsEnabled then
    self:SetroofVisualsEnabledForRoom(false)
  end
  RebuildChimneysInBox2D(self.box)
  if self.keep_roof_passable and not self.rr_recursing then
    self.rr_recursing = true
    self:MakeRoofPassable()
    self.rr_recursing = false
  end
  ResumePassEdits("RoomRoof")
end
local up = point(0, 0, 4096)
local ptx = point(4096, 0, 0)
local pty = point(0, 4096, 0)
function RoomRoof:SnapObject(obj)
  obj:SetGameFlags(const.gofOnRoof)
  local skew = obj:GetClassFlags(const.cfSkewAlign) ~= 0
  local pos = obj:GetVisualPos()
  local roof_z, roof_dir = self:GetRoofZAndDir(pos)
  if not IsKindOf(obj, "Decal") then
    local thickness = self:GetRoofThickness()
    roof_z = roof_z + thickness
  end
  local target_pos = pos:SetZ(roof_z)
  obj:SetPos(target_pos)
  local roof_fwd_y, roof_fwd_x = sincos(roof_dir)
  local roof_fwd_z = sin(self:GetRoofInclination())
  local roof_forward = SetLen(point(roof_fwd_x, roof_fwd_y, roof_fwd_z), 4096)
  local target_up
  if skew then
    target_up = up
  else
    local roof_right = SetLen(point(-roof_fwd_y, roof_fwd_x, 0), 4096)
    local roof_up = Cross(roof_forward, roof_right) / 4096
    target_up = roof_up
  end
  local obj_axis = obj:GetAxis()
  local obj_angle = obj:GetAngle()
  local obj_up = RotateAxis(point(0, 0, 4096), obj_axis, obj_angle)
  if obj_up ~= target_up then
    local axis, angle = GetAxisAngle(obj_up, target_up)
    local axis, angle = ComposeRotation(obj_axis, obj_angle, axis, angle)
    obj:SetAxisAngle(axis, angle)
  end
  if skew then
    local roof_forward_2d = SetLen(roof_forward:SetZ(0), 4096)
    local obj_axis = obj:GetAxis()
    local obj_angle = obj:GetAngle()
    local obj_x = RotateAxis(ptx, obj_axis, obj_angle)
    local obj_y = RotateAxis(pty, obj_axis, obj_angle)
    local dot_x = Dot(roof_forward_2d, obj_x) / 4096
    local dot_y = Dot(roof_forward_2d, obj_y) / 4096
    local skew_x = MulDivRound(roof_fwd_z, dot_x * guim, 16777216)
    local skew_y = MulDivRound(roof_fwd_z, dot_y * guim, 16777216)
    obj:SetSkew(skew_x, skew_y)
  else
    obj:SetSkew(0, 0)
  end
  return target_pos, target_up
end
function RoomRoof:GetSkewAtPos(pos)
  local ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs = self:GetRoofCoordSystem(pos)
  local skew_x, skew_y = MulDivRound(-fz, guim, abs(fx + rx)), 0
  return skew_x, skew_y
end
function RoomRoof:SnapObjects()
  if not self:HasRoof() then
    return
  end
  local above_rooms = MapGet(self:GetPos(), roomQueryRadius, "Room", function(room, my_maxz)
    return room.box and my_maxz < room.box:maxz()
  end, self.box:maxz())
  local min_z = self.prop_map and self.prop_map.minz or self.roof_box:minz()
  MapForEach(self.roof_box, "CObject", false, false, false, const.gofOnRoof, false, false, function(obj, above_rooms, min_z)
    local x, y, z = obj:GetVisualPosXYZ()
    if min_z > z then
      return
    end
    for _, room in ipairs(above_rooms) do
      if IsPointInVolume2D(room, obj) then
        return
      end
    end
    self:SnapObject(obj)
  end, above_rooms, min_z)
end
function RoomRoof:RecalcRoof()
  if not self.roof_objs then
    return
  end
  local roof_type = self:GetRoofType()
  local method_name = string.format("Recalc%sRoof", roof_type)
  local method = self[method_name]
  method(self)
end
function RoomRoof:GetRoofCoordSystem(pt)
  if not self:HasRoof() then
    return
  end
  local roof_type = self:GetRoofType()
  local method_name = string.format("Get%sRoofCoordSystem", roof_type)
  local method = self[method_name]
  return method(self, pt)
end
function RoomRoof:GetRoofClippingPlane(pt)
  local ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs = self:GetRoofCoordSystem(pt)
  local p1, p2, p3 = point(ox, oy, oz), point(ox + rx * rs, oy + ry * rs, oz + rz * rs), point(ox + fx * fs, oy + fy * fs, oz + fz * fs)
  return PlaneFromPoints(p1, p2, p3)
end
local eastPt, southPt, westPt, northPt = point(4096, 0, 0), point(0, 4096, 0), point(-4096, 0, 0), point(0, -4096, 0)
function RoomRoof:GetRoofZAndDir(pt)
  if not self:HasRoof() then
    return InvalidPos():z(), 0
  end
  local ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs = self:GetRoofCoordSystem(pt)
  local z = CalcRoofZAt(ox, oy, oz, fx, fy, fz, rx, ry, rz, pt:xy())
  local dir = cardinal_directions[self.roof_direction]
  if not dir then
    local fwd = point(fx, fy, fz)
    local dots = {
      Dot(fwd, eastPt),
      Dot(fwd, southPt),
      Dot(fwd, westPt),
      Dot(fwd, northPt)
    }
    local max = Max(table.unpack(dots))
    local idx = table.find(dots, max)
    dir = cardinal_directions[idx]
  end
  return z, dir
end
function RoomRoof:UpdateRoofSlabVisibility()
  if self.roof_box and self:GetGameFlags(const.gofPermanent) ~= 0 then
    ComputeSlabVisibilityInBox(self.roof_box)
  end
end
function RoomRoof:GetFlatRoofParams()
  local px, py, pz = WorldToVoxel(self.position)
  local sx, sy, sz = self.size:xyz()
  local voxel_box = box(px, py, pz, px + sx, py + sy, pz + sz)
  return px, py, pz, sx, sy, sz, voxel_box
end
function RoomRoof:GetFlatRoofCoordSystem(pt)
  local px, py, pz, sx, sy, sz, voxel_box = self:GetFlatRoofParams()
  return SolveRoofCoordSystem(voxel_box, self.roof_additional_height, self.roof_direction, self:GetRoofInclination())
end
function RoomRoof:CreateFlatRoof()
  local px, py, pz, sx, sy, sz, voxel_box = self:GetFlatRoofParams()
  return self:CreateRoof("Flat", voxel_box, self.roof_direction, self.roof_parapet)
end
function RoomRoof:RecalcFlatRoof()
  local px, py, pz, sx, sy, sz, voxel_box = self:GetFlatRoofParams()
  self.roof_box = self:RecalcRoof_Generic("Flat", voxel_box, self.roof_direction, self.roof_parapet)
end
function RoomRoof:GetShedRoofParams()
  local px, py, pz = WorldToVoxel(self.position)
  local sx, sy, sz = self.size:xyz()
  local voxel_box = box(px, py, pz, px + sx, py + sy, pz + sz)
  return px, py, pz, sx, sy, sz, voxel_box
end
function RoomRoof:GetShedRoofCoordSystem(pt)
  local px, py, pz, sx, sy, sz, voxel_box = self:GetShedRoofParams()
  return SolveRoofCoordSystem(voxel_box, self.roof_additional_height, self.roof_direction, self:GetRoofInclination())
end
function RoomRoof:CreateShedRoof()
  local px, py, pz, sx, sy, sz, voxel_box = self:GetShedRoofParams()
  return self:CreateRoof("Shed", voxel_box, self.roof_direction, self.roof_parapet)
end
function RoomRoof:RecalcShedRoof()
  local px, py, pz, sx, sy, sz, voxel_box = self:GetShedRoofParams()
  self.roof_box = self:RecalcRoof_Generic("Shed", voxel_box, self.roof_direction, self.roof_parapet)
end
function RoomRoof:GetGableRoofBoxes()
  local px, py, pz = WorldToVoxel(self.position)
  local sx, sy, sz = self.size:xyz()
  local dir1, dir2, box1, box2, odd
  if self.roof_direction == "East-West" or self.roof_direction == "East" or self.roof_direction == "West" then
    dir1 = "South"
    dir2 = "North"
    box1 = box(px, py, pz, px + sx, py + sy / 2, pz + sz)
    box2 = box(px, py + sy / 2, pz, px + sx, py + sy, pz + sz)
    odd = sy % 2 == 1
    if odd then
      box1 = box1:grow(0, 0, 0, 1)
    end
  else
    dir1 = "East"
    dir2 = "West"
    box1 = box(px, py, pz, px + sx / 2, py + sy, pz + sz)
    box2 = box(px + sx / 2, py, pz, px + sx, py + sy, pz + sz)
    odd = sx % 2 == 1
    if odd then
      box1 = box1:grow(0, 0, 1, 0)
    end
  end
  return dir1, dir2, box1, box2, odd
end
function RoomRoof:GetGableRoofCoordSystem(pt)
  local dir1, dir2, box1, box2, odd = self:GetGableRoofBoxes()
  local bx, by, bz = box1:size():xyz()
  local sx, sy, sz = self.size:xyz()
  local dx, dy = 0, 0
  if bx < sx and sx < bx * 2 then
    dx = voxelSizeX / 2
  end
  if by < sy and sy < by * 2 then
    dy = voxelSizeY / 2
  end
  local minx, miny, minz, maxx, maxy, maxz = BoxVoxelToWorld(box1)
  minx, miny, minz, maxx, maxy, maxz = minx - 1, miny - 1, minz - 1, maxx + 1 - dx, maxy + 1 - dy, maxz + 1
  local world_box1 = box(minx, miny, minz, maxx, maxy, maxz)
  local in_box1 = pt:InBox2D(world_box1)
  local box = in_box1 and box1 or box2
  local dir = in_box1 and dir1 or dir2
  return SolveRoofCoordSystem(box, self.roof_additional_height, dir, self:GetRoofInclination())
end
function RoomRoof:CreateGableRoof()
  local dir1, dir2, box1, box2, odd = self:GetGableRoofBoxes()
  local objs1, box1 = self:CreateRoof("Gable", box1, dir1, self.roof_parapet, odd and "odd_gable_short")
  local objs2, box2 = self:CreateRoof("Gable", box2, dir2, self.roof_parapet, odd and "odd_gable_long")
  local px, py, pz = WorldToVoxel(self.position)
  local sx, sy, sz = self.size:xyz()
  local full_box = box(px, py, pz, px + sx, py + sy, pz + sz)
  local objs3 = self:CreateRoof_GableCaps(full_box, dir1, self.roof_parapet)
  local objs = {}
  table.iappend(objs, objs1 or empty_table)
  table.iappend(objs, objs2 or empty_table)
  table.iappend(objs, objs3 or empty_table)
  local box = AddRects(box1, box2)
  return objs, box
end
function RoomRoof:RecalcGableRoof()
  local dir1, dir2, box1, box2, odd = self:GetGableRoofBoxes()
  local roof_box1 = self:RecalcRoof_Generic("Gable", box1, dir1, self.roof_parapet, odd and "odd_gable_short")
  local roof_box2 = self:RecalcRoof_Generic("Gable", box2, dir2, self.roof_parapet, odd and "odd_gable_long")
  self.roof_box = AddRects(roof_box1, roof_box2)
end
function BoxVoxelToWorld(voxel_box)
  local minx, miny, minz, maxx, maxy, maxz = voxel_box:xyzxyz()
  minx, miny, minz = VoxelToWorld(minx, miny, minz)
  minx, miny = minx - halfVoxelSizeX, miny - halfVoxelSizeY
  maxx, maxy, maxz = VoxelToWorld(maxx, maxy, maxz)
  maxx, maxy = maxx - halfVoxelSizeX, maxy - halfVoxelSizeY
  return minx, miny, minz, maxx, maxy, maxz
end
function SolveRoofCoordSystem(voxel_box, z_offset, direction, inclination)
  local ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs
  local minx, miny, minz, maxx, maxy, maxz = BoxVoxelToWorld(voxel_box)
  local cx, cy, cz = (minx + maxx) / 2, (miny + maxy) / 2, maxz + z_offset
  local angle = cardinal_directions[direction]
  local sin, cos = sincos(angle)
  sin, cos = sin / 4096, cos / 4096
  local rotate_vector = function(x, y, z)
    return x * cos - y * sin, x * sin + y * cos, z
  end
  local inclination_size
  if direction == "North" or direction == "South" then
    rs, fs = voxel_box:sizexyz()
    inclination_size = const.SlabSizeX
  else
    fs, rs = voxel_box:sizexyz()
    inclination_size = const.SlabSizeY
  end
  local incl_sin, incl_cos = sincos(inclination)
  local incl_tan = MulDivRound(incl_sin, 4096, incl_cos)
  local voxel_incline = MulDivRound(inclination_size, incl_tan, 4096)
  local fx, fy, fz = rotate_vector(const.SlabSizeX, 0, voxel_incline)
  local rx, ry, rz = rotate_vector(0, const.SlabSizeY, 0)
  ox, oy, oz = cx - MulDivRound(fs, fx, 2) - MulDivRound(rs, rx, 2), cy - MulDivRound(fs, fy, 2) - MulDivRound(rs, ry, 2), cz
  return ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs
end
local RoofCoordSystemBBox = function(ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, additional_height)
  local minx, miny, minz = ox, oy, oz - additional_height
  local maxx, maxy, maxz = ox + fs * fx + rs * rx + 1, oy + fs * fy + rs * ry + 1, oz + fs * fz + rs * rz + 1
  minx, maxx = Min(minx, maxx), Max(minx, maxx)
  miny, maxy = Min(miny, maxy), Max(miny, maxy)
  minz, maxz = Min(minz, maxz), Max(minz, maxz)
  return box(minx, miny, minz, maxx, maxy, maxz)
end
local SolveRoofCornerPosition = function(ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, side)
  if side == "Front" then
    return ox + fx * fs, oy + fy * fs, oz + fz * fs
  elseif side == "Right" then
    return ox + fx * fs + rx * rs, oy + fy * fs + ry * rs, oz + fz * fs + rz * rs
  elseif side == "Back" then
    return ox + rx * rs, oy + ry * rs, oz + rz * rs
  elseif side == "Left" then
    return ox, oy, oz
  else
    return ox, oy, oz
  end
end
local SolveRoofEdgeCoordSystem = function(ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, side)
  local front_or_back = side == "Front" or side == "Back"
  local dx, dy, dz
  if front_or_back then
    dx, dy, dz = rx, ry, rz
  else
    dx, dy, dz = fx, fy, fz
  end
  local ds = front_or_back and rs or fs
  local bx, by, bz
  if side == "Left" then
    bx, by, bz = ox, oy, oz
  elseif side == "Front" then
    bx, by, bz = ox + fx * fs, oy + fy * fs, oz + fz * fs
  elseif side == "Right" then
    bx, by, bz = ox + rx * rs, oy + ry * rs, oz + rz * rs
  elseif side == "Back" then
    bx, by, bz = ox, oy, oz
  end
  return bx, by, bz, dx, dy, dz, ds
end
local GetGableClipPlane = function(ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs)
  local p1, p2 = point(ox + (fs - 1) * fx + fx / 2, oy + (fs - 1) * fy + fy / 2, oz + (fs - 1) * fz + fz / 2), point(ox + (fs - 1) * fx + rs * rx + fx / 2, oy + (fs - 1) * fy + rs * ry + fy / 2, oz + (fs - 1) * fz + rs * rz + fz / 2)
  local p3 = p2:AddZ(const.SlabSizeZ)
  return PlaneFromPoints(p1, p3, p2)
end
function CalcRoofZAt(ox, oy, oz, fx, fy, fz, rx, ry, rz, px, py)
  local ppx = MulDivRound(px - ox, guim, fx + rx)
  local ppy = MulDivRound(py - oy, guim, fy + ry)
  if abs(fx) > abs(fy) then
    return (ppx * fz + ppy * rz) / guim + oz
  else
    return (ppx * rz + ppy * fz) / guim + oz
  end
end
local SideNames = function(direction)
  local first_dir_i = table.find(cardinal_direction_names, direction)
  local sides = {}
  for i = 1, 4 do
    local dir_i = (first_dir_i - 1 + (i - 1)) % 4 + 1
    sides[i] = cardinal_direction_names[dir_i]
  end
  local side_front, side_right, side_back, side_left = table.unpack(sides)
  return side_front, side_right, side_back, side_left
end
local side_to_i = {
  Front = 0,
  Right = 1,
  Back = 2,
  Left = 3
}
function RoomRoof:CreateSlab(slab_class, params)
  local slab_classdef = g_Classes[slab_class]
  return slab_classdef:new(params)
end
function RoomRoof:CreateRoofComponents_RoofPlane(objs, ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, direction, special)
  local skew_x, skew_y = MulDivRound(-fz, guim, abs(fx + rx)), 0
  local angle = cardinal_directions[direction] + 10800
  local clip_plane
  local odd_gable = special == "odd_gable_long" or special == "odd_gable_short"
  if odd_gable then
    clip_plane = GetGableClipPlane(ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs)
  end
  local is_flat = self:GetRoofType() == "Flat"
  for fi = 1, fs do
    local gable_clip = odd_gable and fi == fs
    for ri = 1, rs do
      local x = ox + (fi - 1) * fx + (ri - 1) * rx + (fx + rx) / 2
      local y = oy + (fi - 1) * fy + (ri - 1) * ry + (fy + ry) / 2
      local z = oz + (fi - 1) * fz + (ri - 1) * rz + (fz + rz) / 2
      local slab = self:CreateSlab("RoofPlaneSlab", {
        floor = self.floor,
        room = self,
        dir = direction,
        material = self.roof_mat
      })
      self:SetupNewObj(slab, x, y, z, angle, self.roof_colors, nil, objs, gable_clip and clip_plane or nil, nil, skew_x, skew_y)
      self:PostProcessPlaneSlab(slab, is_flat)
    end
  end
end
RoomRoof.ShouldPlaceRoofEdge = return_true
function RoomRoof:CreateRoofComponents_RoofEdge(objs, ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, direction, side, special)
  if not self:ShouldPlaceRoofEdge(direction, side) then
    return
  end
  local front_or_back = side == "Front" or side == "Back"
  local edge_type = side == "Front" and "Ridge" or side == "Back" and "Eave" or "Rake"
  local bx, by, bz, dx, dy, dz, ds = SolveRoofEdgeCoordSystem(ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, side)
  bx, by, bz = bx + dx / 2, by + dy / 2, bz + dz / 2
  local skew_x, skew_y
  if side == "Front" then
    skew_x, skew_y = MulDivRound(fz, guim, abs(fx + rx)), 0
  elseif side == "Back" then
    skew_x, skew_y = MulDivRound(-fz, guim, abs(fx + rx)), 0
  else
    skew_x, skew_y = 0, MulDivRound(fz, guim, abs(fy + ry))
  end
  local mirror = side == "Right"
  local direction_i = table.find(cardinal_direction_names, direction)
  local direction_i = (direction_i - 1 + side_to_i[side]) % 4 + 1
  local angle = cardinal_directions[direction_i]
  local clip_plane
  local odd_gable = special == "odd_gable_long" or special == "odd_gable_short"
  if odd_gable then
    clip_plane = GetGableClipPlane(ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs)
  end
  for di = 1, ds do
    local x = bx + (di - 1) * dx
    local y = by + (di - 1) * dy
    local z = bz + (di - 1) * dz
    local slab = self:CreateSlab("RoofEdgeSlab", {
      floor = self.floor,
      room = self,
      dir = direction,
      roof_comp = edge_type,
      material = self.roof_mat
    })
    self:SetupNewObj(slab, x, y, z, angle, self.roof_colors, nil, objs, odd_gable and di == ds and clip_plane or nil, mirror, skew_x, skew_y)
  end
end
RoomRoof.ShouldCreateRoofCorner = return_true
function RoomRoof:CreateRoofComponents_RoofCorner(objs, ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, direction, side)
  if not self:ShouldCreateRoofCorner(direction, side) then
    return
  end
  local mirror, angle, x, y, z
  angle = cardinal_directions[direction]
  if side == "Left" or side == "Back" then
    angle = cardinal_directions[direction] + 10800
  end
  local mirror = side == "Front" or side == "Back"
  local x, y, z = SolveRoofCornerPosition(ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, side)
  local corner_type = (side == "Front" or side == "Right") and "RakeRidge" or "RakeEave"
  local skew = (side == "Front" or side == "Right") and fz or -fz
  local skew_x, skew_y = MulDivRound(skew, guim, abs(fx + rx)), 0
  local slab = self:CreateSlab("RoofCorner", {
    floor = self.floor,
    room = self,
    dir = direction,
    roof_comp = corner_type,
    material = self.roof_mat
  })
  self:SetupNewObj(slab, x, y, z, angle, self.roof_colors, nil, objs, nil, mirror, skew_x, skew_y)
end
RoomRoof.ShouldCreateRoofWallEdge = return_true
function RoomRoof:CreateRoofComponents_WallEdge(objs, ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, direction, side, clip_plane, special)
  if not self:ShouldCreateRoofWallEdge(direction, side) then
    return
  end
  local bx, by, bz, dx, dy, dz, ds = SolveRoofEdgeCoordSystem(ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, side)
  dz = 0
  bx, by = bx + dx / 2, by + dy / 2
  bz = oz - self.roof_additional_height
  local front_or_back = side == "Front" or side == "Back"
  local dir_i = table.find(cardinal_direction_names, direction)
  local side_i = side_to_i[side]
  local wall_side = cardinal_direction_names[(dir_i - 1 + side_i) % 4 + 1]
  local angle = cardinal_directions[wall_side]
  local oc = self.outer_colors
  local ic = self.inner_colors
  local dbg_outwards_vec = (side == "Left" or side == "Front") and point(dy, -dx, dz) or point(-dy, dx, dz)
  dbg_outwards_vec = SetLen(dbg_outwards_vec, guim)
  local odd_gable_long_half = special == "odd_gable_long"
  local odd_gable_short_half = special == "odd_gable_short"
  local odd_gable = odd_gable_long_half or odd_gable_short_half
  local max_height = max_int
  if odd_gable and not front_or_back then
    local size = ds
    if odd_gable_short_half then
      size = size + 1
    end
    local x, y = bx + (size - 1) * dx, by + (size - 1) * dy
    local roof_z1, roof_z2 = CalcRoofZAt(ox, oy, oz, fx, fy, fz, rx, ry, rz, x + dx / 2, y + dy / 2), CalcRoofZAt(ox, oy, oz, fx, fy, fz, rx, ry, rz, x - dx / 2, y - dy / 2)
    local min_roof_z = Min(roof_z1, roof_z2) - bz
    max_height = min_roof_z / const.SlabSizeZ
  end
  local is_flat = self:GetRoofType() == "Flat"
  for di = 1, ds do
    local x = bx + (di - 1) * dx
    local y = by + (di - 1) * dy
    local roof_z
    if clip_plane then
      local roof_z1, roof_z2 = CalcRoofZAt(ox, oy, oz, fx, fy, fz, rx, ry, rz, x + dx / 2, y + dy / 2), CalcRoofZAt(ox, oy, oz, fx, fy, fz, rx, ry, rz, x - dx / 2, y - dy / 2)
      roof_z = Max(roof_z1, roof_z2) - bz
    else
      roof_z = Max(fz * fs, const.SlabSizeZ) + self.roof_additional_height
    end
    local height = DivCeil(roof_z, const.SlabSizeZ)
    height = Min(height, max_height)
    local mat = self:GetWallMatHelperSide(wall_side)
    for j = 1, height do
      local z = bz + (di - 1) * dz + (j - 1) * const.SlabSizeZ
      local variant = self.inner_wall_mat ~= noneWallMat and "OutdoorIndoor" or "Outdoor"
      local wall = self:CreateSlab("RoofWallSlab", {
        floor = self.floor,
        material = mat,
        room = self,
        side = wall_side,
        variant = variant,
        indoor_material_1 = self.inner_wall_mat
      })
      self:SetupNewObj(wall, x, y, z, angle, oc, ic, objs, clip_plane)
    end
    if not clip_plane and self.roof_parapet and is_flat then
      local extra_dec_e = "WallDec_material_FenceTop_Body_01"
      extra_dec_e = extra_dec_e:gsub("material", mat)
      if IsValidEntity(extra_dec_e) then
        local z = bz + (di - 1) * dz + (height - 1) * const.SlabSizeZ
        local o = PlaceObject(extra_dec_e, {side = wall_side})
        o:SetGameFlags(const.gofPermanent)
        self:SetupNewObj(o, x, y, z, angle, oc or o:GetDefaultColorizationSet(), ic, objs, clip_plane)
      end
    end
  end
  if odd_gable and not front_or_back then
    local size = ds
    if odd_gable_long_half then
      size = size - 1
    end
    local di_from = 0 < fz and (max_height * const.SlabSizeZ - self.roof_additional_height) / fz or 0
    for di = di_from, size do
      local x = bx + (di - 1) * dx + dx / 2
      local y = by + (di - 1) * dy + dy / 2
      local roof_z
      if clip_plane then
        local roof_z1, roof_z2 = CalcRoofZAt(ox, oy, oz, fx, fy, fz, rx, ry, rz, x + dx / 2, y + dy / 2), CalcRoofZAt(ox, oy, oz, fx, fy, fz, rx, ry, rz, x - dx / 2, y - dy / 2)
        roof_z = Max(roof_z1, roof_z2) - bz
      else
        roof_z = Max(fz * fs, const.SlabSizeZ) + self.roof_additional_height
      end
      local height = DivCeil(roof_z, const.SlabSizeZ)
      for i = max_height + 1, height do
        local z = bz + (size - 1) * dz + (i - 1) * const.SlabSizeZ
        local mat = self:GetWallMatHelperSide(wall_side)
        local variant = self.inner_wall_mat ~= noneWallMat and "OutdoorIndoor" or "Outdoor"
        local wall = self:CreateSlab("GableRoofWallSlab", {
          floor = self.floor,
          material = mat,
          room = self,
          side = wall_side,
          variant = variant,
          indoor_material_1 = self.inner_wall_mat
        })
        self:SetupNewObj(wall, x, y, z, angle, oc, ic, objs, clip_plane)
      end
    end
  end
end
function RoomRoof:SetupNewObj(obj, x, y, z, a, colors, inner_colors, container, clip_plane, mirror, skew_x, skew_y)
  obj:SetPosAngle(x, y, z, a)
  obj:AlignObj()
  if colors then
    obj:Setcolors(colors)
  end
  if inner_colors then
    obj:Setinterior_attach_colors(inner_colors)
  end
  if clip_plane then
    obj:SetClipPlane(clip_plane)
  end
  obj:UpdateEntity()
  obj:UpdateVariantEntities()
  obj:SetMirrored(mirror or false)
  if skew_x and skew_y then
    obj:SetSkew(skew_x, skew_y)
  end
  self:ApplyPropsFromPropObj(obj)
  if container then
    table.insert(container, obj)
  end
  if not visibilityStateForNewRoofPieces then
    obj:SetHierarchyGameFlags(const.gofSolidShadow)
    obj:SetOpacity(0)
  end
end
function RoomRoof:CreateRoofComponents_WallCorner(objs, ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, direction, side, clip_plane, has_plug)
  local angle = cardinal_directions[direction]
  if side == "Left" or side == "Back" then
    angle = cardinal_directions[direction] + 10800
  end
  local bx, by = SolveRoofCornerPosition(ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, side)
  local bz = oz - self.roof_additional_height
  local skew = (side == "Front" or side == "Right") and fz or -fz
  local skew_x, skew_y = MulDivRound(skew, guim, abs(fx + rx)), 0
  local roof_z
  if clip_plane then
    roof_z = CalcRoofZAt(ox, oy, oz, fx, fy, fz, rx, ry, rz, bx, by) - bz
  else
    roof_z = Max(fz * fs, const.SlabSizeZ) + self.roof_additional_height
  end
  local height = DivCeil(roof_z, const.SlabSizeZ)
  local dir_i = table.find(cardinal_direction_names, direction)
  local side_i = side_to_i[side]
  local corner_side = cardinal_direction_names[(dir_i - 1 + side_i) % 4 + 1]
  local mat = self:GetWallMatHelperSide(corner_side)
  for i = 1, height do
    local z = bz + (i - 1) * const.SlabSizeZ
    local corner = self:CreateSlab("RoofCornerWallSlab", {
      room = self,
      material = mat,
      side = corner_side,
      isPlug = false,
      floor = self.floor
    })
    self:SetupNewObj(corner, bx, by, z, angle, self.outer_colors, nil, objs, clip_plane)
  end
  if has_plug then
    local z = bz + (height - 1) * const.SlabSizeZ
    local corner = self:CreateSlab("RoofCornerWallSlab", {
      room = self,
      material = mat,
      side = corner_side,
      isPlug = true,
      floor = self.floor
    })
    self:SetupNewObj(corner, bx, by, z, angle, self.outer_colors, nil, objs, clip_plane)
  end
  local is_flat = self:GetRoofType() == "Flat"
  if not clip_plane and self.roof_parapet and is_flat then
    local extra_dec_e = "WallDec_material_FenceTop_Corner_01"
    extra_dec_e = extra_dec_e:gsub("material", mat)
    if IsValidEntity(extra_dec_e) then
      local z = bz + (height - 1) * const.SlabSizeZ
      local o = PlaceObject(extra_dec_e, {side = corner_side})
      o:SetGameFlags(const.gofPermanent)
      local a = cardinal_directions[corner_side] - 5400
      self:SetupNewObj(o, bx, by, z, a, self.outer_colors or o:GetDefaultColorizationSet(), nil, objs, clip_plane)
    end
  end
end
local gable_cap_30_degree = -100
local gable_cap_max_adjustment = 120
function RoomRoof:AdjustGableCapZ(z)
  local inclination = self:GetRoofInclination()
  inclination = 1800 - Clamp(inclination, 0, 1800)
  return z + gable_cap_30_degree + MulDivRound(inclination, gable_cap_max_adjustment, 1800)
end
function RoomRoof:CreateRoof_GableCaps(voxel_box, direction, parapet)
  local objs = {}
  local ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs = SolveRoofCoordSystem(voxel_box, self.roof_additional_height, direction, self:GetRoofInclination())
  local bx, by, bz = ox + MulDivRound(fx, fs, 2), oy + MulDivRound(fy, fs, 2), oz + fz * fs / 2
  bz = self:AdjustGableCapZ(bz)
  local angle = cardinal_directions[direction] + 10800
  local angle_rake, angle_gable = angle + 5400, angle
  local class_rake, class_gable
  if fs % 2 == 0 then
    class_rake, class_gable = "GableCapRoofCorner", "GableCapRoofEdgeSlab"
  else
    class_rake, class_gable = "GableCapRoofEdgeSlab", "GableCapRoofPlaneSlab"
  end
  if not parapet then
    local slab = self:CreateSlab(class_rake, {
      floor = self.floor,
      room = self,
      material = self.roof_mat,
      roof_comp = "RakeGable"
    })
    self:SetupNewObj(slab, bx, by, bz, angle_rake, self.roof_colors, nil, objs)
    local slab = self:CreateSlab(class_rake, {
      floor = self.floor,
      room = self,
      material = self.roof_mat,
      roof_comp = "RakeGable"
    })
    self:SetupNewObj(slab, bx + rx * rs, by + ry * rs, bz + rz * rs, angle_rake + 10800, self.roof_colors, nil, objs, nil, true)
  end
  bx, by, bz = bx + rx / 2, by + ry / 2, bz + rz / 2
  for i = 1, rs do
    local x, y, z = bx + (i - 1) * rx, by + (i - 1) * ry, bz + (i - 1) * rz
    local slab = self:CreateSlab(class_gable, {
      floor = self.floor,
      room = self,
      material = self.roof_mat,
      roof_comp = "Gable"
    })
    self:SetupNewObj(slab, x, y, z, angle_gable, self.roof_colors, nil, objs)
  end
  return objs
end
function RoomRoof:CreateRoof(roof_type, voxel_box, direction, parapet, special)
  local objs = {}
  local odd_gable = special == "odd_gable_long" or special == "odd_gable_short"
  local odd_gable_long_half = special == "odd_gable_long"
  local inclination = self:GetRoofInclination()
  local ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs = SolveRoofCoordSystem(voxel_box, self.roof_additional_height, direction, inclination)
  local p1, p2, p3 = point(ox, oy, oz), point(ox + rx * rs, oy + ry * rs, oz + rz * rs), point(ox + fx * fs, oy + fy * fs, oz + fz * fs)
  local clip_plane = PlaneFromPoints(p1, p2, p3)
  self:CreateRoofComponents_RoofPlane(objs, ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, direction, special)
  if (roof_type ~= "Flat" or not parapet) and roof_type ~= "Gable" then
    self:CreateRoofComponents_RoofEdge(objs, ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, direction, "Front", special)
  end
  if not parapet then
    self:CreateRoofComponents_RoofEdge(objs, ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, direction, "Right", special)
  end
  if roof_type ~= "Flat" or not parapet then
    self:CreateRoofComponents_RoofEdge(objs, ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, direction, "Back", special)
  end
  if not parapet then
    self:CreateRoofComponents_RoofEdge(objs, ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, direction, "Left", special)
  end
  if not parapet then
    if roof_type ~= "Gable" then
      self:CreateRoofComponents_RoofCorner(objs, ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, direction, "Front")
      self:CreateRoofComponents_RoofCorner(objs, ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, direction, "Right")
    end
    self:CreateRoofComponents_RoofCorner(objs, ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, direction, "Back")
    self:CreateRoofComponents_RoofCorner(objs, ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, direction, "Left")
  end
  local fp, rp, bp, lp = clip_plane, clip_plane, clip_plane, clip_plane
  if parapet then
    if roof_type == "Flat" then
      fp, rp, bp, lp = false, false, false, false
    else
      rp, lp = false, false
    end
  end
  local wfs = fs
  if odd_gable and not odd_gable_long_half then
    wfs = wfs - 1
  end
  if roof_type ~= "Gable" then
    self:CreateRoofComponents_WallEdge(objs, ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, direction, "Front", fp, special)
  end
  self:CreateRoofComponents_WallEdge(objs, ox, oy, oz, fx, fy, fz, wfs, rx, ry, rz, rs, direction, "Right", rp, special)
  self:CreateRoofComponents_WallEdge(objs, ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, direction, "Back", bp, special)
  self:CreateRoofComponents_WallEdge(objs, ox, oy, oz, fx, fy, fz, wfs, rx, ry, rz, rs, direction, "Left", lp, special)
  local fcp, rcp, bcp, lcp = clip_plane, clip_plane, clip_plane, clip_plane
  if not lp and not fp then
    fcp = false
  end
  if not fp and not rp then
    rcp = false
  end
  if not rp and not bp then
    bcp = false
  end
  if not bp and not lp then
    lcp = false
  end
  local f_plug, r_plug, b_plug, l_plug = not fcp, not rcp, not bcp, not lcp
  if roof_type ~= "Gable" then
    self:CreateRoofComponents_WallCorner(objs, ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, direction, "Front", fcp, f_plug)
    self:CreateRoofComponents_WallCorner(objs, ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, direction, "Right", rcp, r_plug)
  end
  self:CreateRoofComponents_WallCorner(objs, ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, direction, "Back", bcp, b_plug)
  self:CreateRoofComponents_WallCorner(objs, ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, direction, "Left", lcp, l_plug)
  local roof_box = RoofCoordSystemBBox(ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, self.roof_additional_height)
  return objs, roof_box
end
function RoomRoof:RecalcRoof_Generic(roof_type, voxel_box, direction, parapet, special)
  local objs = self.roof_objs
  if not objs or not next(objs) then
    return
  end
  for i = 1, #objs do
    local obj = objs[i]
    if IsValid(obj) then
      obj.room = self
      obj.floor = self.floor
      if IsRoofTile(obj) then
        SetSlabColorHelper(obj, obj.colors or self.roof_colors)
      else
        SetSlabColorHelper(obj, obj.colors or self.outer_colors)
      end
    end
  end
  local odd_gable = special == "odd_gable_long" or special == "odd_gable_short"
  local odd_gable_long_half = special == "odd_gable_long"
  local inclination = self:GetRoofInclination()
  local ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs = SolveRoofCoordSystem(voxel_box, self.roof_additional_height, direction, inclination)
  local p1, p2, p3 = point(ox, oy, oz), point(ox + rx * rs, oy + ry * rs, oz + rz * rs), point(ox + fx * fs, oy + fy * fs, oz + fz * fs)
  local clip_plane = PlaneFromPoints(p1, p2, p3)
  local side_front, side_right, side_back, side_left = SideNames(direction)
  local angle_front = cardinal_directions[side_front]
  local angle_right = cardinal_directions[side_right]
  local angle_back = cardinal_directions[side_back]
  local angle_left = cardinal_directions[side_left]
  local roof_box = box(BoxVoxelToWorld(voxel_box)):grow(1)
  local walls_box = roof_box
  if odd_gable then
    local dminx, dminy, dmaxx, dmaxy = 0, 0, 0, 0
    if direction == "West" then
      dminx = 1
    end
    if direction == "North" then
      dminy = 1
    end
    if direction == "East" then
      dmaxx = 1
    end
    if direction == "South" then
      dmaxy = 1
    end
    if odd_gable_long_half then
      walls_box = walls_box:grow(MulDivRound(dminx, const.SlabSizeX, 2), MulDivRound(dminy, const.SlabSizeY, 2), MulDivRound(dmaxx, const.SlabSizeX, 2), MulDivRound(dmaxy, const.SlabSizeY, 2))
    else
      local walls_voxel_box = voxel_box:grow(-dminx, -dminy, -dmaxx, -dmaxy)
      walls_box = box(BoxVoxelToWorld(walls_voxel_box)):grow(1)
    end
  end
  local wall_objs, wall_corner_objs, roof_objs = {}, {}, {}
  local class_gable, class_rake
  if odd_gable then
    class_rake, class_gable = "RoofEdgeSlab", "RoofPlaneSlab"
  else
    class_rake, class_gable = "RoofCorner", "RoofEdgeSlab"
  end
  local is_flat = self:GetRoofType() == "Flat"
  local center = point(ox + fx * fs / 2 + rx * rs / 2, oy + fy * fs / 2 + ry * rs / 2, oz + fz * fs / 2 + rz * rs / 2)
  local right = point(rx, ry, rz)
  local box = self.box
  local north = box:min():SetZ(0)
  local south = north + point(box:sizex(), box:sizey(), 0)
  local east = north + point(box:sizex(), 0, 0)
  local west = north + point(0, box:sizey(), 0)
  local epsilon = voxelSizeX / 10
  epsilon = epsilon * epsilon
  for i = 1, #objs do
    local obj = objs[i]
    if obj then
      local pos = obj:GetPos()
      local angle = obj:GetAngle()
      if IsKindOf(obj, "RoofCornerWallSlab") and pos:InBox2D(walls_box) then
        table.insert(wall_corner_objs, obj)
        if epsilon > pos:Dist2D2(north) then
          obj.side = "North"
        elseif epsilon > pos:Dist2D2(south) then
          obj.side = "South"
        elseif epsilon > pos:Dist2D2(east) then
          obj.side = "East"
        else
          obj.side = "West"
        end
      elseif IsKindOf(obj, "RoofWallSlab") and pos:InBox2D(walls_box) then
        table.insert(wall_objs, obj)
        obj.side = slabAngleToDir[angle]
      elseif IsKindOf(obj, "RoofSlab") and pos:InBox2D(roof_box) and (not obj.dir or obj.dir == direction) then
        if (not IsKindOf(obj, "RoofPlaneSlab") or obj:GetAngle() == angle_back) and obj.dir then
          table.insert(roof_objs, obj)
        end
        obj.side = direction
        if not obj.dir then
          if IsKindOf(obj, class_gable) then
            obj.roof_comp = "Gable"
          elseif IsKindOf(obj, class_rake) then
            obj.roof_comp = "RakeGable"
          end
        elseif IsKindOf(obj, "RoofEdgeSlab") then
          if angle == angle_front then
            obj.roof_comp = "Ridge"
          elseif angle == angle_back then
            obj.roof_comp = "Eave"
          else
            obj.roof_comp = "Rake"
            if angle == angle_right then
              obj:SetMirrored(true)
            end
          end
        elseif IsKindOf(obj, "RoofCorner") then
          obj.roof_comp = (angle == angle_front or angle == angle_right) and "RakeRidge" or "RakeEave"
          if angle == angle_front == (0 > Dot(right, pos - center)) then
            obj:SetMirrored(true)
          end
        elseif IsKindOf(obj, "RoofPlaneSlab") then
          obj.roof_comp = "Plane"
          self:PostProcessPlaneSlab(obj, is_flat)
        end
      end
      obj:DelayedUpdateEntity()
    end
  end
  if 0 < inclination then
    local sx = MulDivRound(fz, guim, const.SlabSizeX)
    local sy = MulDivRound(fz, guim, const.SlabSizeY)
    for i, slab in ipairs(roof_objs) do
      local skew_x, skew_y
      local angle = slab:GetAngle()
      if angle == angle_front then
        skew_x, skew_y = sx, 0
      elseif angle == angle_right or angle == angle_left then
        skew_x, skew_y = 0, sy
      elseif angle == angle_back then
        skew_x, skew_y = -sx, 0
      end
      if skew_x and skew_y then
        slab:SetSkew(skew_x, skew_y)
      end
    end
  end
  if odd_gable then
    local gable_clip_plane = GetGableClipPlane(ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs)
    for i, slab in ipairs(roof_objs) do
      slab:SetClipPlane(gable_clip_plane)
    end
  end
  local fp, rp, bp, lp = clip_plane, clip_plane, clip_plane, clip_plane
  if parapet then
    if roof_type == "Flat" then
      fp, rp, bp, lp = false, false, false, false
    else
      rp, lp = false, false
    end
  end
  for i, wall in ipairs(wall_objs) do
    local clip_plane
    local angle = wall:GetAngle()
    if angle == angle_front then
      clip_plane = fp
    end
    if angle == angle_right then
      clip_plane = rp
    end
    if angle == angle_back then
      clip_plane = bp
    end
    if angle == angle_left then
      clip_plane = lp
    end
    if clip_plane then
      wall:SetClipPlane(clip_plane)
    end
  end
  local fcp, rcp, bcp, lcp = clip_plane, clip_plane, clip_plane, clip_plane
  if not lp and not fp then
    fcp = false
  end
  if not fp and not rp then
    rcp = false
  end
  if not rp and not bp then
    bcp = false
  end
  if not bp and not lp then
    lcp = false
  end
  for i, corner in ipairs(wall_corner_objs) do
    local clip_plane
    local angle = corner:GetAngle()
    if angle == angle_front then
      clip_plane = fcp
    end
    if angle == angle_right then
      clip_plane = rcp
    end
    if angle == angle_back then
      clip_plane = bcp
    end
    if angle == angle_left then
      clip_plane = lcp
    end
    if clip_plane then
      corner:SetClipPlane(clip_plane)
    end
  end
  return RoofCoordSystemBBox(ox, oy, oz, fx, fy, fz, fs, rx, ry, rz, rs, self.roof_additional_height)
end
function RoomRoof:Setkeep_roof_passable(val)
  self.keep_roof_passable = val
  if val then
    self:MakeRoofPassable()
  end
end
function RoomRoof:MakeRoofPassable()
  local nrah, rah = self:GetPassableRoofAdditionalHeight()
  if nrah then
    self:OnSetroof_additional_height(nrah, rah)
  end
end
function RoomRoof:GetPassableRoofAdditionalHeight()
  if not self:HasRoof() then
    return
  end
  if self:GetRoofType() ~= "Flat" then
    return
  end
  local objs = self.roof_objs
  local rs
  for i = 1, #(objs or "") do
    local o = objs[i]
    if IsKindOf(o, "RoofPlaneSlab") and o:HasSpot("Slab") then
      rs = o
      break
    end
  end
  if not rs then
    return
  end
  local rah = self.roof_additional_height
  local si = rs:GetSpotBeginIndex("Slab")
  local p = rs:GetPos()
  local sp = rs:GetSpotPos(si)
  local offs = sp - p
  local minHeight = sp:z() - rah
  local vx, vy, vz = SnapToVoxel(sp:xyz())
  if minHeight > vz then
    vz = vz + voxelSizeZ
  end
  local np = point(vx, vy, vz) - offs
  local d = np:z() - p:z()
  local nrah = rah + d
  return nrah, rah
end
function RoomRoof:GetroofVisualsEnabled()
  return RoofVisualsEnabled
end
function RoomRoof:SetroofVisualsEnabledForRoom(v)
  local roof_objs = self.roof_objs
  if roof_objs then
    for j = 1, #roof_objs do
      local roof_obj = roof_objs[j]
      if IsValid(roof_obj) then
        local opacity
        if v then
          roof_obj:ClearHierarchyGameFlags(const.gofSolidShadow)
          opacity = 100
        else
          roof_obj:SetHierarchyGameFlags(const.gofSolidShadow)
          opacity = 0
        end
        if not IsKindOf(roof_obj, "Decal") then
          roof_obj:SetOpacity(opacity)
        end
      end
    end
    MapForEach(self.roof_box, "CObject", function(o)
      if o:GetGameFlags(const.gofOnRoof) ~= 0 then
        local opacity
        if v then
          o:ClearHierarchyGameFlags(const.gofSolidShadow)
          opacity = 100
        else
          o:SetHierarchyGameFlags(const.gofSolidShadow)
          opacity = 0
        end
        if not IsKindOf(o, "Decal") then
          o:SetOpacity(opacity)
        end
      end
    end)
  end
end
function RoomRoof:SetroofVisualsEnabled(v)
  RoofVisualsEnabled = v
  MapForEach("map", "Room", function(roof)
    roof:SetroofVisualsEnabledForRoom(v)
  end)
end
function RoomRoof:OnSetroof_type(new_type, old_type)
  if old_type == new_type then
    return
  end
  self.roof_type = new_type
  if new_type == "Gable" and not table.find(GableRoofDirections, self.roof_direction) then
    self.roof_direction = GableRoofDirections[1]
  elseif table.find(GableRoofDirections, self.roof_direction) then
    self.roof_direction = cardinal_direction_names[1]
  end
  self:RecreateRoof()
end
function RoomRoof:OnSetroof_mat(new_mat, old_mat)
  if old_mat == new_mat then
    return
  end
  self.roof_mat = new_mat
  self:UnlockRoof()
  self:RecreateRoof()
end
function RoomRoof:OnSetroof_direction(new_dir, old_dir)
  if old_dir == new_dir then
    return
  end
  self.roof_direction = new_dir
  self:RecreateRoof()
end
function RoomRoof:OnSetroof_inclination(new_incl, old_incl)
  if old_incl == new_incl then
    return
  end
  self.roof_inclination = new_incl
  self:RecreateRoof()
end
function RoomRoof:OnSetroof_parapet(new_parapet, old_parapet)
  if old_parapet == new_parapet then
    return
  end
  self.roof_parapet = new_parapet
  self:RecreateRoof()
end
function RoomRoof:OnSetroof_additional_height(new_height, old_height)
  if old_height == new_height then
    return
  end
  self.roof_additional_height = new_height
  self:RecreateRoof()
end
function RoomRoof:OnSetbuild_ceiling(val)
  self.build_ceiling = val
  self:RecreateRoof()
end
function RoomRoof:OnSetceiling_mat(mat, oldmat)
  if oldmat == mat then
    return
  end
  if not self.build_ceiling then
    return
  end
  Notify(self, "SetCeilingMatToCeilingSlabs")
end
function RoomRoof:SetCeilingMatToCeilingSlabs()
  if not self.build_ceiling then
    return
  end
  local objs = self.roof_objs
  local mat = self.ceiling_mat
  local bb = box()
  for i = #(objs or ""), 1, -1 do
    local o = objs[i]
    if not IsKindOf(o, "CeilingSlab") then
      break
    end
    o.material = mat
    o:UpdateEntity()
    bb = Extend(bb, o:GetPos())
  end
  if bb:IsValid() and not bb:IsEmpty() then
    ComputeSlabVisibilityInBox(bb)
  end
end
function RoomRoof:CreateCeiling(objs)
  local mat = self.ceiling_mat
  local sx, sy = self.position:x(), self.position:y()
  local sizeX, sizeY, sizeZ = self.size:xyz()
  sx = sx + halfVoxelSizeX
  sy = sy + halfVoxelSizeY
  local gz = self:CalcZ() + sizeZ * voxelSizeZ
  SuspendPassEdits("Room:CreateCeiling")
  for xOffset = 0, sizeX - 1 do
    for yOffset = 0, sizeY - 1 do
      local x = sx + xOffset * voxelSizeX
      local y = sy + yOffset * voxelSizeY
      local ceil = self:CreateSlab("CeilingSlab", {
        floor = self.floor,
        material = mat,
        side = false,
        room = self
      })
      self:SetupNewObj(ceil, x, y, gz, 0, nil, nil, objs)
    end
  end
  ResumePassEdits("Room:CreateCeiling")
end
function RoomRoof:OnSetroof_colors(val, oldVal)
  for i = 1, #(self.roof_objs or "") do
    local o = self.roof_objs[i]
    if o and IsRoofTile(o) then
      o:Setcolors(val)
    end
  end
end
DefineClass.RoofSlab = {
  __parents = {"Slab", "Mirrorable"},
  properties = {
    {
      category = "Slabs",
      id = "material",
      name = "Material",
      editor = "preset_id",
      preset_class = "SlabPreset",
      preset_group = "RoofSlabMaterials",
      extra_item = noneWallMat,
      default = "none"
    },
    {
      category = "Slabs",
      id = "forceInvulnerableBecauseOfGameRules",
      name = "Invulnerable",
      editor = "bool",
      default = false,
      help = "In context of destruction."
    },
    {
      id = "dir",
      name = "Direction",
      editor = "choice",
      default = false,
      items = cardinal_direction_names
    },
    {id = "SkewX"},
    {id = "SkewY"},
    {
      id = "Mirrored",
      editor = "bool",
      default = false,
      dont_save = true
    }
  },
  roof_comp = false,
  colors_room_member = "roof_colors",
  entity_base_name = "Roof",
  room_container_name = "roof_objs",
  invulnerable = false
}
function RoofSlab:GetBaseEntityName()
  local material_list = Presets.SlabPreset[self.MaterialListClass] or Presets.SlabPreset.RoofSlabMaterials
  local svd = material_list[self.material]
  return string.format("%s_%s_%s", self.entity_base_name, svd.EntitySet, self.roof_comp)
end
local roofCompToSubvariantArr = {
  Plane = "subvariants",
  Eave = "eave_subvariants",
  Rake = "rake_subvariants",
  Ridge = "ridge_subvariants",
  Gable = "gable_subvariants",
  RakeGable = "rake_gable_subvariants",
  RakeRidge = "rake_ridge_subvariants",
  RakeEave = "rake_eave_subvariants"
}
function RoofSlab:ComposeEntityName()
  local material_list = Presets.SlabPreset[self.MaterialListClass] or Presets.SlabPreset.RoofSlabMaterials
  local svd = material_list[self.material]
  local sm = roofCompToSubvariantArr[self.roof_comp]
  local subvariants = svd and svd[sm]
  if subvariants and 0 < #subvariants then
    if self.subvariant ~= -1 then
      local digit = (self.subvariant - 1) % #subvariants + 1
      local digitStr = digit < 10 and "0" .. tostring(digit) or tostring(digit)
      return string.format("Roof_%s_%s_%s", svd.EntitySet, self.roof_comp, digitStr)
    else
      local subvariant, i = table.weighted_rand(subvariants, "chance", self:GetSeed())
      while subvariant do
        local name = string.format("Roof_%s_%s_%s", svd.EntitySet, self.roof_comp, subvariant.suffix)
        if IsValidEntity(name) then
          return name
        end
        i = i - 1
        subvariant = subvariants[i]
      end
    end
  end
  return string.format("Roof_%s_%s_01", self.material or noneWallMat, self.roof_comp)
end
function RoofSlab:MirroringFromRoom()
end
function RoofSlab:EditorCallbackClone(source)
  Slab.EditorCallbackClone(self, source)
  if source.room then
    source.room:RecreateRoof()
  end
end
DefineClass.RoofPlaneSlab = {
  __parents = {
    "RoofSlab",
    "HFloorAlignedObj"
  },
  flags = {efPathSlab = true},
  properties = {
    {
      category = "Slabs",
      id = "material",
      name = "Material",
      editor = "preset_id",
      preset_class = "SlabPreset",
      preset_group = "RoofSlabMaterials",
      extra_item = noneWallMat,
      default = "none"
    }
  },
  MaterialListClass = "RoofSlabMaterials",
  roof_comp = "Plane"
}
DefineClass.RoofEdgeSlab = {
  __parents = {
    "RoofSlab",
    "HWallAlignedObj"
  },
  MaterialListClass = "RoofSlabMaterials",
  roof_comp = "Rake"
}
DefineClass.RoofCorner = {
  __parents = {
    "RoofSlab",
    "HCornerAlignedObj"
  },
  MaterialListClass = "RoofSlabMaterials",
  roof_comp = "RakeRidge"
}
DefineClass.BaseRoofWallSlab = {
  __parents = {"CObject"},
  properties = {
    {
      category = "Slabs",
      id = "forceInvulnerableBecauseOfGameRules",
      name = "Invulnerable",
      editor = "bool",
      default = false,
      help = "In context of destruction."
    }
  },
  room_container_name = "roof_objs",
  invulnerable = false
}
DefineClass.RoofWallSlab = {
  __parents = {
    "BaseRoofWallSlab",
    "WallSlab"
  },
  room_container_name = "roof_objs",
  forceInvulnerableBecauseOfGameRules = false,
  invulnerable = false
}
DefineClass.GableRoofWallSlab = {
  __parents = {
    "RoofWallSlab",
    "CornerAlignedObj"
  }
}
function GableRoofWallSlab:AlignObj(pos, angle)
  CornerAlignedObj.AlignObj(self, pos, angle)
end
DefineClass("GableCapRoofPlaneSlab", "RoofPlaneSlab")
DefineClass("GableCapRoofEdgeSlab", "RoofEdgeSlab")
DefineClass("GableCapRoofCorner", "RoofCorner")
DefineClass.RoofCornerWallSlab = {
  __parents = {
    "BaseRoofWallSlab",
    "RoomCorner"
  },
  room_container_name = "roof_objs",
  forceInvulnerableBecauseOfGameRules = false,
  invulnerable = false
}
DefineClass.HWallAlignedObj = {
  __parents = {
    "WallAlignedObj"
  }
}
function HWallAlignedObj:AlignObjAttached()
  local p = self:GetParent()
  local ap = self:GetPos() + self:GetAttachOffset()
  local x, y, z, angle = WallWorldToVoxel(ap:x(), ap:y(), ap:z(), self:GetAngle())
  x, y, z = WallVoxelToWorld(x, y, z, angle)
  local my_x, my_y, my_z = self:GetPosXYZ()
  my_z = my_z or InvalidZ
  px, py, pz = p:GetPosXYZ()
  self:SetAttachOffset(x - px, y - py, my_z - pz)
  self:SetAngle(angle)
end
function HWallAlignedObj:AlignObj(pos, angle)
  local x, y, z
  if pos then
    x, y, z = pos:xyz()
    x, y, z, angle = WallWorldToVoxel(x, y, z or terrain.GetHeight(x, y), angle or self:GetAngle())
  else
    x, y, z, angle = WallWorldToVoxel(self)
  end
  local my_x, my_y, my_z = self:GetPosXYZ()
  my_z = my_z or InvalidZ
  x, y, z = WallVoxelToWorld(x, y, z, angle)
  self:SetPosAngle(x, y, my_z, angle)
end
DefineClass.HFloorAlignedObj = {
  __parents = {
    "FloorAlignedObj"
  }
}
function HFloorAlignedObj:AlignObj(pos, angle)
  local x, y, z
  if pos then
    x, y, z, angle = WorldToVoxel(pos, angle or self:GetAngle())
  else
    x, y, z, angle = WorldToVoxel(self)
  end
  local my_x, my_y, my_z = self:GetPosXYZ()
  my_z = my_z or InvalidZ
  x, y, z = VoxelToWorld(x, y, z)
  self:SetPosAngle(x, y, my_z, angle)
end
DefineClass.HCornerAlignedObj = {
  __parents = {
    "CornerAlignedObj"
  }
}
function HCornerAlignedObj:AlignObj(pos, angle)
  local x, y, z
  if pos then
    x, y, z, angle = CornerWorldToVoxel(pos, angle or self:GetAngle())
  else
    x, y, z, angle = CornerWorldToVoxel(self)
  end
  local my_x, my_y, my_z = self:GetPosXYZ()
  my_z = my_z or InvalidZ
  x, y, z = CornerVoxelToWorld(x, y, z, angle)
  self:SetPosAngle(x, y, my_z, angle)
end
local IsOutsideVolumes = function(obj)
  local inside = false
  local mr = obj.room
  local mp = obj:GetPos()
  MapForEach(obj:GetObjectBBox():grow(voxelSizeX * 30, voxelSizeY * 30, 0), "Room", function(v, mp, mr)
    if v ~= mr then
      if not v:IsRoofOnly() and v.box:PointInsideInclusive(mp) and mp:z() < v.box:maxz() then
        inside = "volume"
        return "break"
      end
      if v.roof_box and v.roof_box:PointInsideInclusive(mp) then
        inside = "roof"
        return "break"
      end
    end
  end, mp, mr)
  return not inside, inside
end
function ShouldHaveRoofEavesSegment(roof_edge)
  if not roof_edge.isVisible or roof_edge.is_destroyed then
    return false
  end
  local room = roof_edge.room
  if (roof_edge.roof_comp == "Eave" or room and room.roof_type == "Flat") and IsOutsideVolumes(roof_edge) then
    return true
  end
  return false
end
function RoomRoof:OnRoofEdgeTilesDestroyed()
  self:UpdateRoofVfxControllers()
end
function RoomRoof:OnRoofPlaneTilesDestroyed()
end
function RoomRoof:SetVfxControllersVisibility(val)
  for i = 1, #(self.vfx_roof_surface_controllers or "") do
    self.vfx_roof_surface_controllers[i]:SetVisibility(val)
  end
  for i = 1, #(self.vfx_eaves_controllers or "") do
    self.vfx_eaves_controllers[i]:SetVisibility(val)
  end
end
function RoomRoof:UpdateRoofVfxControllers()
  local b = self.roof_box
  if not self:HasRoof() or not b then
    DoneObjects(self.vfx_roof_surface_controllers)
    DoneObjects(self.vfx_eaves_controllers)
    self.vfx_roof_surface_controllers = false
    self.vfx_eaves_controllers = false
    return
  end
  local controllers = self.vfx_roof_surface_controllers
  if self.roof_type == "Gable" then
    controllers = controllers or {}
    local vc1 = IsValid(controllers[1]) and controllers[1] or PlaceObject("RoofSurface")
    local vc2 = IsValid(controllers[2]) and controllers[2] or PlaceObject("RoofSurface")
    local v11, v12, v13, v21, v22, v23
    v11 = b:min()
    if self.roof_direction == "East-West" then
      v12 = v11 + point(b:sizex(), 0, 0)
      v13 = v11 + point(0, b:sizey() / 2, 0)
      v21 = v13
      v22 = v21 + point(b:sizex(), 0, 0)
      v23 = v21 + point(0, b:sizey() / 2, 0)
    else
      v12 = v11 + point(b:sizex() / 2, 0, 0)
      v13 = v11 + point(0, b:sizey(), 0)
      v21 = v12
      v22 = v21 + point(b:sizex() / 2, 0, 0)
      v23 = v21 + point(0, b:sizey(), 0)
    end
    vc1:InitFromParent(self)
    vc2:InitFromParent(self)
    vc1:SetVertexes(v11, v12, v13)
    local _, angle = self:GetRoofZAndDir(v11)
    vc1.angle = angle + 10800
    vc2:SetVertexes(v21, v22, v23)
    vc2.angle = angle
    controllers[1] = vc1
    controllers[2] = vc2
  elseif self.roof_type == "Shed" or self.roof_type == "Flat" then
    controllers = controllers or {}
    local vc = IsValid(controllers[1]) and controllers[1] or PlaceObject("RoofSurface")
    local v1 = b:min()
    local v2 = v1 + point(b:sizex(), 0, 0)
    local v3 = v1 + point(0, b:sizey(), 0)
    vc:InitFromParent(self)
    vc:SetVertexes(v1, v2, v3)
    local _, angle = self:GetRoofZAndDir(v1)
    vc.angle = angle + 10800
    controllers[1] = vc
    if IsValid(controllers[2]) then
      DoneObject(controllers[2])
    end
    controllers[2] = nil
  else
    for i = #(controllers or ""), 1, -1 do
      DoneObject(controllers[i])
    end
    controllers = false
  end
  self.vfx_roof_surface_controllers = controllers
  local map = {}
  MapForEach(b:grow(10, 10, 10), "RoofEdgeSlab", function(o, self, map)
    if o.room == self and ShouldHaveRoofEavesSegment(o) then
      local s = slabAngleToDir[o:GetAngle()]
      map[s] = map[s] or {}
      local x, y, z = WorldToVoxel(o)
      local sigcoord
      if s == "East" or s == "West" then
        sigcoord = y
      else
        sigcoord = x
      end
      map[s][sigcoord] = o
      map[s].min = not map[s].min and sigcoord or Min(map[s].min, sigcoord)
      map[s].max = not map[s].max and sigcoord or Max(map[s].max, sigcoord)
    end
  end, self, map)
  local DetermineVertex = function(o, side, last)
    local curb = o:GetObjectBBox()
    local dir = o:GetRelativePoint(axis_x) - o:GetPos()
    local sx, sy, sz = curb:sizexyz()
    if side == "East" or side == "West" then
      local p = curb:Center() + MulDivRound(dir, sx / 2, 4096)
      local x, y, z = p:xyz()
      return point(x, y + halfVoxelSizeY * (not last and -1 or 1), z)
    else
      local p = curb:Center() + MulDivRound(dir, sy / 2, 4096)
      local x, y, z = p:xyz()
      return point(x + halfVoxelSizeX * (not last and -1 or 1), y, z)
    end
  end
  local controllers = self.vfx_eaves_controllers
  local cidx = 1
  for side, t in pairs(map) do
    local last, v1, v2
    for i = t.min, t.max + 1 do
      local cur = t[i]
      if cur then
        if not last then
          v1 = DetermineVertex(cur, side, false)
        end
      elseif last then
        v2 = DetermineVertex(last, side, true)
        controllers = controllers or {}
        local vc = IsValid(controllers[cidx]) and controllers[cidx] or PlaceObject("RoofEavesSegment")
        controllers[cidx] = vc
        cidx = cidx + 1
        vc:InitFromParent(self)
        if side == "South" or side == "West" then
          vc.vertex1 = v2
          vc.vertex2 = v1
        else
          vc.vertex1 = v1
          vc.vertex2 = v2
        end
        vc.angle = last:GetAngle()
        if vc.playing then
          vc:Stop()
          vc:Play()
        end
        v1 = nil
        v2 = nil
      end
      last = cur
    end
  end
  for i = #(controllers or ""), cidx, -1 do
    if IsValid(controllers[i]) then
      DoneObject(controllers[i])
    end
    controllers[i] = nil
  end
  if 0 >= #(controllers or "") then
    controllers = false
  end
  self.vfx_eaves_controllers = controllers
end
DefineClass.RoofFXController = {
  __parents = {"Object"},
  entity = "InvisibleObject",
  properties = {
    {
      id = "material",
      editor = "text",
      default = false
    },
    {
      id = "parent_obj",
      editor = "object",
      default = false
    },
    {
      id = "disabled",
      editor = "bool",
      default = false
    }
  },
  particles = false,
  playing = false
}
function RoofFXController:Done()
  self:Stop()
end
function RoofFXController:SetVisibility(val)
  if self.playing then
    for i = 1, #(self.particles or "") do
      if val then
        self.particles[i]:SetEnumFlags(const.efVisible)
      else
        self.particles[i]:ClearEnumFlags(const.efVisible)
      end
    end
  end
end
function RoofFXController:SetDisabled(val)
  if val then
    self:Stop()
  end
  self.disabled = val
end
function RoofFXController:InitFromParent(parent_obj)
  self:SetPos(parent_obj:GetPos())
  self:SetAngle(parent_obj:GetAngle())
  self.parent_obj = parent_obj
  self.material = parent_obj.roof_mat
end
function RoofFXController:Play()
  if self.disabled then
    return
  end
  if self.playing then
    return
  end
  PlayFX("ClearSky", "end", self, self.material)
  PlayFX("RainHeavy", "start", self, self.material)
  self.playing = true
end
function RoofFXController:Stop()
  if not self.playing then
    return
  end
  PlayFX("RainHeavy", "end", self, self.material)
  PlayFX("ClearSky", "start", self, self.material)
  DoneObjects(self.particles)
  self.particles = false
  self.playing = false
end
DefineClass.RoofEavesSegment = {
  __parents = {
    "RoofFXController"
  },
  properties = {
    {
      id = "vertex1",
      editor = "point",
      default = false
    },
    {
      id = "vertex2",
      editor = "point",
      default = false
    },
    {
      id = "angle",
      editor = "number",
      default = false
    }
  }
}
function RoofEavesSegment:Dbg()
  local v1 = self.vertex1
  local v2 = self.vertex2
  DbgAddVector(v1)
  DbgAddVector(v2)
  DbgAddVector(v1, v2 - v1)
end
function RoofEavesSegment:Play()
  if self.disabled then
    return
  end
  if self.playing then
    return
  end
  RoofFXController.Play(self)
  local d = self.vertex1:Dist2D(self.vertex2)
  local angle = CalcSignedAngleBetween2D(point(4096, 0, 0), self.vertex2 - self.vertex1)
  if angle < 0 then
    angle = 21600 + angle
  end
  local par = PlaceParticles("Rain_Pouring_Dyn")
  par:SetPos(self.vertex1)
  par:SetAngle(angle)
  par:SetParam("width", d)
  self.particles = self.particles or {}
  table.insert(self.particles, par)
end
DefineClass.RoofSurface = {
  __parents = {
    "RoofFXController"
  },
  properties = {
    {
      id = "vertex1",
      editor = "point",
      default = false
    },
    {
      id = "vertex2",
      editor = "point",
      default = false
    },
    {
      id = "vertex3",
      editor = "point",
      default = false
    },
    {
      id = "angle",
      editor = "number",
      default = false
    }
  }
}
function RoofSurface:GetOffset()
  if self.material == "Tin" then
    return 74
  elseif self.material == "Tiles" then
    return 129
  elseif self.material == "Concrete" then
    return 190
  end
  return 0
end
function RoofSurface:SetVertexes(v1, v2, v3)
  local parent_obj = self.parent_obj
  local hoff = self:GetOffset()
  local minx = Min(v1:x(), v2:x(), v3:x()) + 1
  local maxx = Max(v1:x(), v2:x(), v3:x()) - 1
  local miny = Min(v1:y(), v2:y(), v3:y()) + 1
  local maxy = Max(v1:y(), v2:y(), v3:y()) - 1
  v1 = point(minx, maxy, 0)
  v2 = point(maxx, maxy, 0)
  v3 = point(minx, miny, 0)
  v1 = v1:SetZ(parent_obj:GetRoofZAndDir(v1) + hoff)
  v2 = v2:SetZ(parent_obj:GetRoofZAndDir(v2) + hoff)
  v3 = v3:SetZ(parent_obj:GetRoofZAndDir(v3) + hoff)
  self.vertex1 = v1
  self.vertex2 = v2
  self.vertex3 = v3
end
function RoofSurface:Play()
  RoofFXController.Play(self)
  local v1 = self.vertex1
  local v2 = self.vertex2
  local v3 = self.vertex3
  local xmax = v2:Dist(v1)
  local ymax = v3:Dist(v1)
  local angle = CalcSignedAngleBetween2D(point(4096, 0, 0), v2 - v1)
  if angle < 0 then
    angle = 21600 + angle
  end
  local par = PlaceParticles("Splashes_Raindrop_Dyn")
  par:SetPos(v1)
  par:SetAngle(angle)
  par:SetParam("area", MulDivRound(xmax, ymax, 1000))
  par:SetParam("width", xmax)
  par:SetParam("height", ymax)
  self.parent_obj:SnapObject(par)
  self.particles = self.particles or {}
  table.insert(self.particles, par)
end
function CreateVfxControllersForAllRoomsOnMap()
  MapForEach("map", "RoofFXController", DoneObject)
  MapForEach("map", "Room", RoomRoof.UpdateRoofVfxControllers)
end
function PlayRoofFX()
  MapForEach("map", "RoofFXController", function(o)
    o:Play()
  end)
end
function StopRoofFX()
  MapForEach("map", "RoofFXController", function(o)
    o:Stop()
  end)
end
