function GetGridMarkerTypesCombo()
  local marker_types = PresetGroupCombo("GridMarkerType", "Default")()
  ClassDescendantsList("GridMarker", function(name, class_def)
    local props = class_def.properties
    local prop = table.find_value(props, "id", "Type")
    table.insert_unique(marker_types, prop.default)
  end)
  return marker_types
end
DefineClass.VoxelSnappingObj = {
  __parents = {
    "EditorCallbackObject"
  }
}
function VoxelSnappingObj:SnapToVoxel()
  self:SetPos(SnapToVoxel(self:GetPos()))
end
function VoxelSnappingObj:EditorCallbackPlace()
  self:SnapToVoxel()
end
function VoxelSnappingObj:EditorCallbackMove()
  self:SnapToVoxel()
end
function GridMarkerFightAreaCombo(first)
  local markers = MapGetMarkers()
  local items = {first}
  for _, marker in ipairs(markers) do
    if marker.FightAreaId ~= "" then
      items[#items + 1] = marker.FightAreaId
    end
  end
  return items
end
DefineClass.GridMarker = {
  __parents = {
    "EditorMarker",
    "GameDynamicDataObject",
    "VoxelSnappingObj",
    "StripCObjectProperties",
    "StripComponentAttachProperties"
  },
  enum_flags = {efCollision = false},
  properties = {
    {
      category = "Grid Marker",
      id = "Type",
      name = "Type",
      editor = "dropdownlist",
      items = function()
        return GetGridMarkerTypesCombo()
      end,
      default = "Position"
    },
    {
      category = "Grid Marker",
      id = "Groups",
      name = "Groups",
      editor = "string_list",
      items = function()
        return GridMarkerGroupsCombo()
      end,
      default = false,
      arbitrary_value = true
    },
    {
      category = "Grid Marker",
      id = "Group",
      name = "Group-for-load-compat",
      editor = "text",
      default = "",
      no_edit = true
    },
    {
      category = "Grid Marker",
      id = "ID",
      name = "ID",
      editor = "text",
      help = "Unique ID of the marker - leave alone, unless necessary",
      default = ""
    },
    {
      category = "Grid Marker",
      id = "Comment",
      name = "Comment",
      editor = "text",
      help = "Anything that would help you organize the markers",
      default = ""
    },
    {
      category = "Marker",
      id = "AreaWidth",
      name = "Area Width",
      editor = "number",
      default = 1,
      help = "Defining a voxel-aligned rectangle with North-South and East-West axis"
    },
    {
      category = "Marker",
      id = "AreaHeight",
      name = "Area Height",
      editor = "number",
      default = 1,
      help = "Defining a voxel-aligned rectangle with North-South and East-West axis"
    },
    {
      category = "Marker",
      id = "Reachable",
      name = "Reachable only",
      editor = "bool",
      default = true,
      help = "Area of marker includes only tiles reachable from marker position, not the entire rectangle"
    },
    {
      category = "Marker",
      id = "GroundVisuals",
      name = "Ground Visuals",
      editor = "bool",
      default = false,
      help = "Show ground mesh on the marker area"
    },
    {
      category = "Marker",
      id = "DeployRolloverText",
      name = "Deploy Rollover Text",
      editor = "text",
      default = "",
      translate = true,
      no_edit = function(self)
        return self.Type ~= "Entrance" and self.Type ~= "DeployArea"
      end,
      help = "Show floating text when area is rollovered"
    },
    {
      category = "Marker",
      id = "Color",
      no_edit = true,
      default = RGB(255, 255, 255)
    },
    {
      category = "Trigger Logic",
      id = "Trigger",
      name = "Trigger",
      editor = "dropdownlist",
      items = {
        "once",
        "activation",
        "deactivation",
        "always",
        "change"
      },
      default = "once",
      help = [[
Effects are executed:
  once - once per game playthrough
  activation - every period when the conditions change from false to true
  always - every period when the conditions are true
  change - every time the conditions change between true and false]]
    },
    {
      category = "Trigger Logic",
      id = "TriggerConditions",
      name = "Trigger Conditions",
      editor = "nested_list",
      base_class = "Condition",
      default = false,
      help = "Conditions to check periodically"
    },
    {
      category = "Trigger Logic",
      id = "SequentialTriggerEffects",
      name = "Execute Trigger Effects Sequentially",
      editor = "bool",
      default = true,
      help = "Whether effects should wait for each other when executing in order."
    },
    {
      category = "Trigger Logic",
      id = "TriggerEffects",
      name = "Trigger Effects",
      editor = "nested_list",
      base_class = "Effect",
      default = false,
      help = "Effects to execute, depending of trigger and conditions result that are checked periodicaly"
    },
    {
      category = "Enabled Logic",
      id = "EnabledConditions",
      name = "Enable Conditions",
      editor = "nested_list",
      base_class = "Condition",
      default = false,
      help = "Conditions that enable or disable the marker"
    },
    {
      category = "Spawn Object",
      id = "Routine",
      editor = "combo",
      default = "Ambient",
      items = function(self)
        return UnitRoutines
      end,
      no_edit = function(self)
        return not IsGridMarkerWithDefenderRole(self)
      end
    },
    {
      category = "Spawn Object",
      id = "RoutineArea",
      editor = "combo",
      default = "self",
      items = function(self)
        local g = table.copy(GridMarkerGroupsCombo())
        g[1 + #g] = "self"
        return g
      end,
      no_edit = function(self)
        return not IsGridMarkerWithDefenderRole(self)
      end
    },
    {
      category = "Spawn Object",
      id = "Name",
      editor = "text",
      translate = true,
      default = "",
      lines = 1,
      no_edit = function(self)
        return not IsGridMarkerWithDefenderRole(self)
      end
    },
    {
      category = "Spawn Object",
      id = "Suspicious",
      editor = "bool",
      default = false,
      help = "Set spawned units to Suspicious state",
      no_edit = function(self)
        return not IsGridMarkerWithDefenderRole(self)
      end
    },
    {
      category = "Archetype",
      id = "Archetypes",
      name = "Preferred Archetypes",
      editor = "string_list",
      items = function()
        return PresetsCombo("EnemyRole")
      end,
      default = false,
      no_edit = function(self)
        return not IsGridMarkerWithDefenderRole(self)
      end,
      help = "Used for Defender priority markers"
    },
    {
      id = "ArchetypesTriState",
      name = "UnitRoles",
      category = "Archetype",
      editor = "set",
      default = false,
      three_state = true,
      items = function()
        return PresetsCombo("EnemyRole")
      end,
      help = "Only allow or forbid. Not functional if preffered archetypes is used."
    },
    {
      category = "Archetype",
      id = "UnitDef",
      name = "Unit Definition",
      editor = "dropdownlist",
      default = false,
      items = function(self)
        return PresetsCombo("UnitDataCompositeDef")
      end,
      help = "Used for Defender priority markers"
    },
    {
      category = "Fight Area",
      id = "FightAreaId",
      name = "Fight Area ID",
      editor = "text",
      default = "",
      help = "if non-empty the marker area will be registered as a fight area, allowing units to be assigned to it via this ID"
    },
    {
      category = "Fight Area",
      id = "FightArea3d",
      name = "3D",
      editor = "bool",
      default = false,
      no_edit = function(self)
        return self.FightAreaId == ""
      end
    },
    {id = "Handle"},
    {
      id = "spawned_by_template"
    },
    {
      id = "Angle",
      editor = "number",
      default = 0,
      scale = "deg"
    },
    {
      id = "CollectionIndex",
      name = "Collection Index",
      editor = "number",
      default = 0,
      read_only = true
    }
  },
  activation_thread = false,
  contour_polyline = false,
  area_ground_mesh = false,
  EditorRolloverText = "Base grid marker with area",
  EditorIcon = "CommonAssets/UI/Icons/radar.tga",
  last_conditions_eval = false,
  trigger_count = 0,
  area_thickness_divisor = 30,
  area_positions = false,
  area_effect = false,
  fl_text = false,
  ground_visuals = false,
  recalc_area_on_pass_rebuild = true,
  hide_reason = false
}
function GridMarker:Init()
  g_GridMarkersContainer:AddToLabel("GridMarker", self)
  g_GridMarkersContainer:AddToLabel(self.Type, self)
  self:UpdateVisuals(self.Type)
end
function GridMarker:GameInit()
  self.activation_thread = CreateGameTimeThread(self.TriggerThreadProc, self)
end
function GridMarker:Done()
  if IsValidThread(self.activation_thread) then
    DeleteThread(self.activation_thread)
    self.activation_thread = false
  end
  self:HideArea()
  RecalcGroups(self)
  self:RemoveFloatTxt()
  g_GridMarkersContainer:RemoveFromLabel("GridMarker", self)
  g_GridMarkersContainer:RemoveFromLabel(self.Type, self)
end
function GridMarker:SetPos(...)
  EditorMarker.SetPos(self, ...)
  self:RecalcAreaPositions()
end
function GridMarker:SetAreaWidth(val)
  self.AreaWidth = val
  self:RecalcAreaPositions()
end
function GridMarker:SetAreaHeight(val)
  self.AreaHeight = val
  self:RecalcAreaPositions()
end
function GetGridRangeContour(marker)
  local chamf_div = marker.area_thickness_divisor
  local contour_width = marker.Type == "BorderArea" and const.ContoursWidth or 2 * const.SlabSizeX / chamf_div
  local radius2D = const.SlabSizeX / chamf_div
  local contour
  if marker.Type == "BorderArea" then
    local bbox = marker:GetBBox()
    local mx, my, mz = marker:GetPosXYZ()
    local z = (mz or terrain.GetHeight(mx, my)) + const.ContoursOffsetZ
    local x1 = bbox:minx() - const.SlabSizeX / 2
    local x2 = bbox:maxx() + const.SlabSizeX / 2
    local y1 = bbox:miny() - const.SlabSizeY / 2
    local y2 = bbox:maxy() + const.SlabSizeY / 2
    contour = {
      GetMapBorderPstr(box(x1, y1, z, x2, y2, z), contour_width, radius2D)
    }
  elseif marker.Reachable or marker.Type == "BorderArea" then
    local positions = marker:GetAreaPositions(true)
    contour = GetRangeContour(positions, contour_width, radius2D)
  else
    local bbox = marker:GetBBox()
    local mx, my, mz = marker:GetPosXYZ()
    local z = (mz or terrain.GetHeight(mx, my)) + const.ContoursOffsetZ
    local x1 = bbox:minx() - const.SlabSizeX / 2
    local x2 = bbox:maxx() + const.SlabSizeX / 2
    local y1 = bbox:miny() - const.SlabSizeY / 2
    local y2 = bbox:maxy() + const.SlabSizeY / 2
    local box_contour = GetRectContourPStr(box(x1, y1, z, x2, y2, z), contour_width, radius2D)
    if box_contour then
      contour = {box_contour}
    end
  end
  return contour
end
function GridMarker:RecalcAreaPositions(force_show)
  self.area_positions = false
  if self.Type == "BorderArea" then
    g_BorderAreaRangeContour = GetGridRangeContour(self) or false
  end
  if force_show or self:IsAreaVisible() then
    self:ShowArea()
  end
end
function GridMarker:EditorEnter()
  if self:GetGameFlags(const.gofPermanent) == 0 then
    return
  end
  EditorMarker.EditorEnter(self)
  self:RecalcAreaPositions()
  self:SetVisible(true)
end
function GridMarker:EditorExit()
  if self:GetGameFlags(const.gofPermanent) == 0 then
    return
  end
  self:SetVisible(false)
  EditorMarker.EditorExit(self)
  self:RecalcAreaPositions()
end
function GridMarker:RemoveFloatTxt()
  if self.fl_text then
    self.fl_text:delete()
    self.fl_text = false
  end
end
function GridMarker:SetVisible(bShow)
  if bShow then
    self:UpdateVisuals(self.Type)
    self:SetEnumFlags(const.efVisible)
    if self:IsAreaVisible() then
      self:ShowArea()
    end
  else
    if not self:IsAreaVisible() then
      self:HideArea()
    end
    self:DestroyAttaches("Text")
    self:ClearEnumFlags(const.efVisible)
  end
end
function GridMarker:SetColor(clr)
  self.Color = clr
  self:SetColorModifier(clr)
end
function GridMarker:EditorGetText()
  return false
end
function GridMarker:GetDuplicatedStateHash()
  return self:CalculatePersistHash()
end
function GridMarker:SetType(marker_type)
  self:UpdateVisuals(marker_type)
  g_GridMarkersContainer:RemoveFromLabel(self.Type, self)
  self.Type = marker_type
  g_GridMarkersContainer:AddToLabel(marker_type, self)
  if self.Type == "BorderArea" and rawget(self, "Reachable") == nil then
    self:SetProperty("Reachable", false)
  end
  if self:IsAreaVisible() then
    self:ShowArea()
  end
end
function GridMarker:SetGroups(groups)
  CObject.SetGroups(self, groups)
  self:UpdateVisuals(self.Type)
end
function GridMarker:SetID(id)
  self.ID = id
  self:UpdateVisuals(self.Type)
end
function GridMarker:UpdateVisuals(marker_type, force)
  if IsChangingMap() then
    return
  end
  local marker_type_item = Presets.GridMarkerType.Default[marker_type]
  if marker_type_item and (force or marker_type ~= self.Type or self:GetEntity() ~= marker_type_item.Entity) then
    self:ChangeEntity(marker_type_item.Entity or self.entity)
    self:SetScale(marker_type_item.Scale or 100)
    if self.AreaWidth == self:GetDefaultPropertyValue("AreaWidth") and self.AreaHeight == self:GetDefaultPropertyValue("AreaHeight") then
      self.AreaWidth = marker_type_item.AreaWidth
      self.AreaHeight = marker_type_item.AreaHeight
    end
    if (not self.Groups or #self.Groups == 0) and marker_type_item.MarkerGroup and marker_type_item.MarkerGroup ~= "" then
      self:AddToGroup(marker_type_item.MarkerGroup)
    end
    self.area_thickness_divisor = MulDivRound(const.SlabSizeX, 2, marker_type_item.AreaThickness)
  end
  if marker_type_item then
    self:SetColorModifier(marker_type_item.Color)
  end
  self:UpdateText(marker_type_item)
end
function GridMarker:UpdateText(marker_type_item)
  self:DestroyAttaches("Text")
  local bbox = GetEntityBoundingBox(self:GetEntity())
  local ztop = bbox:max():z() + 50 * guic
  local text = PlaceObject("Text")
  self:Attach(text)
  if self.Groups and #self.Groups > 0 and self.ID and self.ID ~= "" then
    text:SetText(string.format("%s-%s", table.concat(self.Groups, ","), self.ID))
  elseif self.Groups and #self.Groups > 0 then
    text:SetText(table.concat(self.Groups, ","))
  elseif self.ID and self.ID ~= "" then
    text:SetText(self.ID)
  else
    text:SetText("")
  end
  if marker_type_item then
    text:SetColorModifier(marker_type_item.Color)
  end
  text:SetAttachOffset(point(0, 0, ztop))
end
function GridMarker:SnapToVoxel()
  VoxelSnappingObj.SnapToVoxel(self)
  RefreshOverlappingGridMarkersOffset()
end
function GridMarker:SetAngle(angle, ...)
  EditorMarker.SetAngle(self, CardinalDirection(angle), ...)
end
function GridMarker:SetAxisAngle(axis, angle, ...)
  EditorMarker.SetAxisAngle(self, axis, CardinalDirection(angle), ...)
end
function GridMarker:TriggerThreadProc()
  if not self.TriggerConditions and not self.TriggerEffects then
    return
  end
  Sleep(1)
  while IsValid(self) do
    self:ActivateTrigger({})
    Sleep(1000)
  end
end
function GridMarker:ActivateTrigger(context)
  if self.Trigger == "once" and self.last_conditions_eval then
    return
  end
  if IsSetpiecePlaying() then
    return
  end
  if not Game or not Game.CampaignStarted then
    return
  end
  local prev_conditions_eval = self.last_conditions_eval
  self.last_conditions_eval = self:EvaluateTriggerConditions(context)
  if not (self.Trigger ~= "always" and (self.Trigger ~= "once" or not self.last_conditions_eval) and (not ((self.Trigger == "activation" or self.Trigger == "change") and self.last_conditions_eval) or prev_conditions_eval)) or (self.Trigger == "deactivation" or self.Trigger == "change") and not self.last_conditions_eval and prev_conditions_eval then
    self:ExecuteTriggerEffects(context)
  end
end
function GridMarker:EvaluateTriggerConditions(context)
  return self:IsMarkerEnabled() and EvalConditionList(self.TriggerConditions, self, context)
end
function GridMarker:ExecuteTriggerEffects(context)
  self.trigger_count = self.trigger_count + 1
  ObjModified(self)
  if self.SequentialTriggerEffects then
    ExecuteSequentialEffects(self.TriggerEffects, "ObjAndContext", self.handle, context)
  else
    ExecuteEffectList(self.TriggerEffects, self, context)
  end
end
function GridMarker:IsMarkerEnabled(context)
  if not self.EnabledConditions then
    return true
  end
  for i, condition in ipairs(self.EnabledConditions) do
    if not condition:Evaluate(self, context) then
      return false
    end
  end
  return true
end
function GridMarker:SetDynamicData(data)
  self.last_conditions_eval = data.last_conditions_eval
  self.trigger_count = data.trigger_count
end
function GridMarker:GetDynamicData(data)
  data.last_conditions_eval = self.last_conditions_eval or nil
  data.trigger_count = self.trigger_count ~= 0 and self.trigger_count or nil
end
function GridMarker:IsVoxelInsideArea2D(x, y)
  local markerOnTerrain = not self:IsValidZ()
  local pos_voxel_x, pos_voxel_y, pos_voxel_z = WorldToVoxel(self)
  local area_width = self.AreaWidth
  local area_left = pos_voxel_x - area_width / 2
  if x < area_left then
    return
  end
  if x >= area_left + area_width then
    return
  end
  local area_height = self.AreaHeight
  local area_top = pos_voxel_y - area_height / 2
  if y < area_top then
    return
  end
  if y >= area_top + area_height then
    return
  end
  return pos_voxel_z, markerOnTerrain
end
function GridMarker:IsVoxelInsideArea(x, y, z)
  local pos_voxel_z, markerOnTerrain = self:IsVoxelInsideArea2D(x, y)
  if not pos_voxel_z then
    return
  end
  local passSlabAtQueryPos = GetPassSlab(VoxelToWorld(x, y, z))
  local markerAndQueryPosOnTerrain = passSlabAtQueryPos and not passSlabAtQueryPos:IsValidZ() and markerOnTerrain
  if not markerAndQueryPosOnTerrain and z then
    local passSlabAtQueryPosAtMarkerHeight = GetPassSlab(VoxelToWorld(x, y, pos_voxel_z))
    if passSlabAtQueryPosAtMarkerHeight and passSlabAtQueryPosAtMarkerHeight == passSlabAtQueryPos then
      passSlabAtQueryPosAtMarkerHeight = false
    end
    return not passSlabAtQueryPosAtMarkerHeight and abs(pos_voxel_z - z) <= 2
  end
  return true
end
function GridMarker:GetMarkerCornerPositions()
  local positions = self:GetAreaPositions()
  local pos_voxel_x, pos_voxel_y = self:GetPosXYZ()
  local area_width = self.AreaWidth * const.SlabSizeX
  local area_height = self.AreaHeight * const.SlabSizeY
  local area_left = pos_voxel_x - area_width / 2
  local area_right = area_left + area_width
  local area_top = pos_voxel_y - area_height / 2
  local area_bottom = area_top + area_height
  local left_top = point(area_left, area_top)
  local right_top = point(area_right, area_top)
  local left_bottom = point(area_left, area_bottom)
  local right_bottom = point(area_right, area_bottom)
  local left_top_min_dist = max_int
  local right_top_min_dist = max_int
  local left_bottom_min_dist = max_int
  local right_bottom_min_dist = max_int
  local result = {}
  for _, pos_packed in ipairs(positions) do
    local pos = point(point_unpack(pos_packed))
    local dist = pos:Dist2D2(left_top)
    if left_top_min_dist > dist then
      left_top_min_dist = dist
      result[1] = {pos}
    end
    dist = pos:Dist2D2(right_top)
    if right_top_min_dist > dist then
      right_top_min_dist = dist
      result[2] = {pos}
    end
    dist = pos:Dist2D2(left_bottom)
    if left_bottom_min_dist > dist then
      left_bottom_min_dist = dist
      result[4] = {pos}
    end
    dist = pos:Dist2D2(right_bottom)
    if right_bottom_min_dist > dist then
      right_bottom_min_dist = dist
      result[3] = {pos}
    end
  end
  return result
end
function GridMarker:GetAreaPositions(ignore_occupied)
  if not self.area_positions then
    self.area_positions = {}
  end
  local recached = false
  if (not IsEditorActive() or not IsDeployMarker(self)) and self.Reachable then
    local key = "reachable|" .. tostring(not not ignore_occupied)
    if not self.area_positions[key] then
      local voxels = {}
      local width = self.AreaWidth * const.SlabSizeX
      local height = self.AreaHeight * const.SlabSizeY
      if width == 0 or height == 0 then
        return voxels
      end
      local pos = GetPassSlab(self) or self:GetPos()
      local area_left = pos:x() - width / 2
      local area_top = pos:y() - height / 2
      local restrict_area = box(area_left, area_top, area_left + width, area_top + height)
      self.area_positions[key] = GetCombatPathDestinations(nil, pos, nil, nil, nil, nil, restrict_area, ignore_occupied, "move_through_occupied", "avoid_mines")
      recached = true
      if not ignore_occupied and not g_Combat then
        local allUnits = MapGet("map", "Unit")
        local unitPositionsPacked = {}
        for i, u in ipairs(allUnits) do
          if u:IsValidPos() and (not gv_Deployment or IsUnitDeployed(u)) then
            local snapped = SnapToVoxel(u:GetPos())
            local packed = point_pack(snapped)
            unitPositionsPacked[packed] = true
          end
        end
        local positions = self.area_positions[key]
        local total = #positions
        for i = 1, total do
          local pos = positions[i]
          if unitPositionsPacked[pos] then
            positions[i] = nil
          end
        end
        table.compact(positions)
      end
    end
    return self.area_positions[key], recached
  end
  if not self.area_positions.all then
    self.area_positions.all = self:GetAllVoxels()
    recached = true
  end
  return self.area_positions.all, recached
end
function GridMarker:GetAreaPositionsOutsideRepulsors(ignore_occupied)
  local area_positions, recached = GridMarker.GetAreaPositions(self, ignore_occupied)
  if recached or not self.area_positions["outside-repulse"] then
    self.area_positions["outside-repulse"] = FilterPackedPositionsRepulsionZone(area_positions)
  end
  return self.area_positions["outside-repulse"], recached
end
function GridMarker:GetBBox()
  local stepx = const.SlabSizeX
  local stepy = const.SlabSizeY
  local sizex = self.AreaWidth * stepx
  local sizey = self.AreaHeight * stepy
  local posx, posy, posz = self:GetPosXYZ()
  local bbox = sizebox(posx - sizex / 2, posy - sizey / 2, sizex, sizey)
  local border_box = not IsEditorActive() and GetBorderAreaLimits()
  if border_box then
    bbox = IntersectRects(bbox, border_box)
  end
  local x1, y1 = VoxelToWorld(WorldToVoxel(bbox:minx(), bbox:miny()))
  local x2, y2 = VoxelToWorld(WorldToVoxel(bbox:maxx(), bbox:maxy()))
  if x1 < bbox:minx() then
    x1 = x1 + (bbox:minx() - x1 + stepx - 1) / stepx * stepx
  end
  if y1 < bbox:miny() then
    y1 = y1 + (bbox:miny() - y1 + stepy - 1) / stepy * stepy
  end
  if x2 >= bbox:maxx() then
    x2 = x2 - (x2 - bbox:maxx() + stepx) / stepx * stepx
  end
  if y2 >= bbox:maxy() then
    y2 = y2 - (y2 - bbox:maxy() + stepy) / stepy * stepy
  end
  local z = SnapToVoxelZ(posx, posy, posz)
  return box(x1, y1, z, x2, y2, z)
end
function GridMarker:GetAllVoxels(filter)
  local bbox = self:GetBBox()
  local x1 = bbox:minx()
  local x2 = bbox:maxx()
  local y1 = bbox:miny()
  local y2 = bbox:maxy()
  local z = bbox:minz()
  local voxels = {}
  local insert = table.insert
  local stepx = const.SlabSizeX
  local stepy = const.SlabSizeY
  for x = x1, x2, stepx do
    for y = y1, y2, stepy do
      insert(voxels, point_pack(x, y, z))
    end
  end
  return voxels
end
local corner_offs = {
  A = {
    a = point(20 * guic, 20 * guic, 0)
  },
  B = {
    b = point(-20 * guic, 20 * guic, 0)
  },
  C = {
    c = point(-20 * guic, -20 * guic, 0)
  },
  D = {
    d = point(20 * guic, -20 * guic, 0)
  }
}
function GridMarker:GetAreaTrianglePtOffs(i, j, width, height)
  local corner = i == 1 and j == 1 and "A" or i == width and j == 1 and "B" or i == width and j == height and "C" or i == 1 and j == height and "D"
  return corner_offs[corner] or empty_table
end
function GridMarker:GetAreaTriangleFadeArg(pt, center, width, height)
  local w = width * const.SlabSizeX
  local h = height * const.SlabSizeY
  local max_dist, dist
  if w > h then
    max_dist = h / 2
    dist = abs(pt:y() - center:y())
  else
    max_dist = w / 2
    dist = abs(pt:x() - center:x())
  end
  return 100 - MulDivRound(dist, 100, max_dist)
end
local slab_x = const.SlabSizeX
local slab_y = const.SlabSizeY
function GridMarker:GetAreaBox()
  local center_x, center_y = self:GetPosXYZ()
  local width, height = self.AreaWidth, self.AreaHeight
  local x = center_x - width / 2 * slab_x - slab_x / 2
  local y = center_y - height / 2 * slab_y - slab_y / 2
  local area = box(x, y, x + width * slab_x, y + height * slab_y)
  local border = GetBorderAreaLimits()
  return border and IntersectRects(border, area) or area
end
function GridMarker:GetAreaTrianglePstr()
  local v_pstr = pstr("")
  if IsDeployMarker(self) then
    local voxels = self:GetAreaPositions(true)
    local xAvg, yAvg = AppendVerticesAOETilesWithDF(v_pstr, table.map(voxels, function(v)
      return point(point_unpack(v))
    end), {}, {}, RGB(255, 255, 255), 100)
    return v_pstr
  end
  local white = const.clrWhite
  local center = self:GetPos()
  local first_x = center:x() - self.AreaWidth / 2 * slab_x - slab_x / 2
  local first_y = center:y() - self.AreaHeight / 2 * slab_y - slab_y / 2
  local first_z = center:z()
  local voxels = {}
  local z_offset = guim / 4
  local width, height = self.AreaWidth, self.AreaHeight
  if not IsEditorActive() then
    local border = GetBorderAreaLimits()
    if border then
      local new_box = IntersectRects(border, box(first_x, first_y, first_x + self.AreaWidth * slab_x, first_y + self.AreaHeight * slab_y))
      center = new_box:Center()
      width = (new_box:sizex() + slab_x / 2) / slab_x
      height = (new_box:sizey() + slab_y / 2) / slab_y
      first_x = new_box:minx()
      first_y = new_box:miny()
    end
  end
  for i = 1, width do
    for j = 1, height do
      local x = first_x + (i - 1) * slab_x
      local y = first_y + (j - 1) * slab_y
      local a = point(x, y, SnapToVoxelZ(x, y, first_z) + z_offset)
      local b = point(x + slab_x, y, SnapToVoxelZ(x + slab_x, y, first_z) + z_offset)
      local c = point(x + slab_x, y + slab_y, SnapToVoxelZ(x + slab_x, y + slab_y, first_z) + z_offset)
      local d = point(x, y + slab_y, SnapToVoxelZ(x, y + slab_y, first_z) + z_offset)
      local offs = self:GetAreaTrianglePtOffs(i, j)
      local a_arg = self:GetAreaTriangleFadeArg(a, center, width, height)
      local b_arg = self:GetAreaTriangleFadeArg(b, center, width, height)
      local c_arg = self:GetAreaTriangleFadeArg(c, center, width, height)
      local d_arg = self:GetAreaTriangleFadeArg(d, center, width, height)
      v_pstr:AppendVertex(a + (offs.a or point30), white, a_arg)
      v_pstr:AppendVertex(b + (offs.b or point30), white, b_arg)
      v_pstr:AppendVertex(d + (offs.d or point30), white, d_arg)
      v_pstr:AppendVertex(b + (offs.b or point30), white, b_arg)
      v_pstr:AppendVertex(c + (offs.c or point30), white, c_arg)
      v_pstr:AppendVertex(d + (offs.d or point30), white, d_arg)
    end
  end
  return v_pstr
end
function GridMarker:IsAreaVisible()
  if IsEditorActive() then
    return LocalStorage.FilteredCategories.GridMarker ~= "invisible" and (table.find(mv_SelectedGridMarkers, self) or self.Type == "Entrance" or self.Type == "BorderArea")
  end
  if not self:IsMarkerEnabled() then
    return false
  end
  local conflict = GetSectorConflict()
  if self.Type == "Entrance" then
    if gv_DeploymentStarted and gv_Deployment == "attack" then
      return true
    end
    if not gv_DeploymentStarted and (not conflict or not conflict.disable_travel) then
      local exitInteractable = MapGetMarkers("ExitZoneInteractable", self.Groups and self.Groups[1])
      exitInteractable = exitInteractable and exitInteractable[1]
      return exitInteractable and exitInteractable:GetNextSector()
    end
  end
  if gv_DeploymentStarted and gv_Deployment == "defend" and (self.Type == "Defender" or self.Type == "DefenderPriority") then
    return true
  end
  if self.Type == "BorderArea" then
    if self.hide_reason and next(self.hide_reason) then
      return false
    end
    return true
  end
  return false
end
function GridMarker:IsAreaShown()
  return not not self.contour_polyline
end
function GridMarker:UpdateHideReason(reason, hide)
  hide = hide or nil
  if not self.hide_reason then
    self.hide_reason = {}
  end
  self.hide_reason[reason] = hide
  if self:IsAreaVisible() then
    self:ShowArea()
  else
    self:HideArea()
  end
end
local updateBorderMarkerVisiblity = function(reason, hide)
  local marker = GetBorderAreaMarker()
  marker:UpdateHideReason(reason, hide)
end
function OnMsg.SettingActionCamera()
  updateBorderMarkerVisiblity("actioncamera", true)
end
function OnMsg.ActionCameraRemoved()
  updateBorderMarkerVisiblity("actioncamera", false)
end
function OnMsg.SetpieceStarting()
  updateBorderMarkerVisiblity("setpiece", true)
end
function OnMsg.SetpieceEnding()
  updateBorderMarkerVisiblity("setpiece", false)
end
function GridMarker:ShowArea()
  self:HideArea()
  if self.AreaWidth == 0 or self.AreaHeight == 0 then
    return
  end
  local marker_type = Presets.GridMarkerType.Default[self.Type]
  local area_color = marker_type and marker_type.Color or self.Color
  local shader_or_material = IsEditorActive() and "default_mesh"
  local contour
  if self.Type == "BorderArea" then
    shader_or_material = CRM_RangeContourControllerPreset:GetById(IsEditorActive() and "MapBorderAreaEdgeEditor" or "MapBorderAreaEdge"):Clone()
    shader_or_material.fade_inout_start = RealTime()
    shader_or_material:SetIsInside(true)
    contour = g_BorderAreaRangeContour
  else
    contour = GetGridRangeContour(self)
  end
  if IsDeployMarker(self) and not IsEditorActive() then
    self.area_ground_mesh = GridMarkerDeploymentVisuals:new({marker = self})
    self.area_ground_mesh:SetPos(point30)
  else
    self.contour_polyline = contour and PlaceContourPolyline(contour, area_color, shader_or_material) or false
    if self.ground_visuals or IsEditorActive() and self.GroundVisuals then
      local textstyle = "DeploymentArea"
      local mat = false
      self.area_ground_mesh = PlaceGroundRectMesh(self:GetAreaTrianglePstr(), textstyle, mat)
    end
  end
end
function GridMarker:HideArea()
  if self.contour_polyline then
    DestroyContourPolyline(self.contour_polyline)
    self.contour_polyline = false
  end
  if self.area_ground_mesh then
    self.area_ground_mesh:delete()
    self.area_ground_mesh = false
  end
end
function GridMarker:IsMarkerAreaPosition(pt)
  if not self.Reachable then
    return true
  end
  local packed_pos = point_pack(SnapToPassSlab(pt) or pt)
  local area_positions = self:GetAreaPositions(true)
  if table.find(area_positions, packed_pos) then
    return true
  end
  return false
end
function GridMarker:IsInsideArea2D(pt)
  if self.Reachable then
    pt = IsPoint(pt) and pt or pt:GetPos()
    return self:IsMarkerAreaPosition(pt)
  else
    local x, y = WorldToVoxel(pt)
    return self:IsVoxelInsideArea2D(x, y)
  end
end
function GridMarker:IsInsideArea(pt)
  if self.Reachable then
    pt = IsPoint(pt) and pt or pt:GetPos()
    return self:IsMarkerAreaPosition(pt)
  else
    local x, y, z = WorldToVoxel(pt)
    return self:IsVoxelInsideArea(x, y, z)
  end
end
function GridMarker:OnEditorSetProperty(prop_id, old_value)
  if prop_id == "AreaWidth" or prop_id == "AreaHeight" or prop_id == "Reachable" or prop_id == "Color" or prop_id == "GroundVisuals" then
    self:RecalcAreaPositions()
  end
end
local EditorSelectObjects = function(objects)
  if not IsEditorActive() then
    EditorActivate()
  end
  editor.ClearSel()
  editor.AddToSel(objects)
end
function GridMarker:EditorCallbackPlace()
  VoxelSnappingObj.EditorCallbackPlace(self)
  if GedGridMarkerEditor then
    UpdateGedGridMarkerRoot()
    ObjModified(GedGridMarkerEditorRoot)
  end
  editor.ClearSel()
  editor.AddToSel({self})
end
function GridMarker:EditorCallbackClone(marker)
  if GedGridMarkerEditor then
    UpdateGedGridMarkerRoot("with_cursor_obj")
    ObjModified(GedGridMarkerEditorRoot)
  end
end
function GridMarker:EditorCallbackMove()
  EditorMarker.EditorCallbackMove(self)
  VoxelSnappingObj.EditorCallbackMove(self)
  self:RecalcAreaPositions("force show")
end
function GridMarker:EditorCallbackDelete()
  GedGridMarkerEditorRebuildRootOnDeletedMarker()
end
function GridMarker:OnEditorDelete()
  GedGridMarkerEditorRebuildRootOnDeletedMarker()
end
function GridMarker:GetError()
  local firstVal
  for name, value in pairs(self.ArchetypesTriState) do
    if type(firstVal) ~= "boolean" then
      firstVal = value
    end
    if value ~= firstVal then
      return "Marker has both allowed and forbidden entries in ArchetypesTriState."
    end
  end
end
function GridMarker:GetWarning()
  if self.Type == "Entrance" and (not self.Groups or #self.Groups == 0) then
    return "Entrance marker has no group!"
  end
  if self.Type == "Entrance" and not self.Reachable then
    return "Entrance marker should be set to reachable only to prevent units from getting stuck!"
  end
end
function GridMarker:AddPosition(positions, around_center)
  local pos, idx
  if around_center then
    idx = table.find(positions, point_pack(self:GetPos():SetInvalidZ()))
    if idx then
      pos = positions[idx]
    else
      local min_dist = max_int
      for i, packed_pt in ipairs(positions) do
        local pt = point(point_unpack(packed_pt))
        local dist = pt:Dist(self:GetPos())
        if min_dist > dist then
          pos = packed_pt
          idx = i
          min_dist = dist
        end
      end
    end
  end
  if not pos then
    pos, idx = table.interaction_rand(positions, "GridMarker")
  end
  if idx then
    positions[idx] = positions[#positions]
    positions[#positions] = nil
  end
  return point(point_unpack(pos))
end
function GridMarker:GetRandomPositions(number, around_center, positions, req_pos, avoid_close_pos)
  positions = positions or self:GetAreaPositions()
  if not next(positions) then
    return empty_table, self:GetAngle()
  end
  if not req_pos then
    if around_center then
      req_pos = self:GetPos()
    else
      local packedPoint = table.interaction_rand(positions, "GridMarker")
      req_pos = point(point_unpack(packedPoint))
    end
  end
  local level_z = req_pos:IsValidZ() and req_pos:z() or terrain.GetHeight(req_pos)
  local x, y = req_pos:xy()
  local first = SnapToPassSlab(point(x, y, SnapToVoxelZ(x, y, level_z)))
  if first and not self.Reachable and not first:IsValidZ() then
    first = first:SetZ(SnapToVoxelZ(x, y, level_z))
  end
  local reqPositionPacked = first and point_pack(first)
  local result = first and {first} or {}
  if first then
    local close_dist = number * guim
    local distances = {}
    for i = 1, #positions do
      local packedPos = positions[i]
      if packedPos ~= reqPositionPacked then
        local pt = point(point_unpack(packedPos))
        local distance = pt:Dist(first)
        local score
        if avoid_close_pos then
          score = close_dist < distance and distance or max_int
        else
          score = close_dist > distance and distance or max_int
        end
        if pt:IsValidZ() and first:IsValidZ() and pt:z() ~= first:z() then
          score = score + close_dist + 100
        end
        distances[#distances + 1] = {score = score, pos = pt}
      end
    end
    table.stable_sort(distances, function(a, b)
      return a.score < b.score
    end)
    local close_positions = {}
    for i = 1, number do
      if distances[i] then
        close_positions[#close_positions + 1] = distances[i].pos
      end
    end
    for i = 1, #close_positions do
      if number <= #result then
        break
      end
      result[#result + 1] = close_positions[i]
    end
  end
  for i = 1, #positions do
    if number <= #result then
      break
    end
    local packedPos = positions[i]
    if packedPos and packedPos ~= reqPositionPacked then
      result[#result + 1] = point(point_unpack(packedPos))
    end
  end
  return result, self:GetAngle()
end
function GridMarker:GetExtraEditorText(texts)
end
function GridMarker:GetGroupsText()
  if not self.Groups then
    return ""
  end
  return table.concat(self.Groups, ",")
end
function GridMarker:GetEditorTypeText()
  return Untranslated("[<Type>]")
end
function GridMarker:GetEditorText()
  local texts = {
    Untranslated("<style GedName><EditorTypeText></style> <GroupsText> <ID><if(not_eq(trigger_count,0))><color 0 196 0>(<trigger_count> triggers)<color></if></style>")
  }
  if self.Comment ~= "" then
    texts[#texts + 1] = Untranslated("\t<style GedComment><Comment></style>")
  end
  GetEditorConditionsAndEffectsText(texts, self)
  self:GetExtraEditorText(texts)
  return table.concat(texts, "\n")
end
function GridMarker:SetGroup(g)
  self.Groups = {g}
end
local SortMarkers = function(markers)
  table.sort(markers, function(a, b)
    local a_type = IsKindOf(a, "AmbientLifeMarker") and "AL" or a.Type
    local b_type = IsKindOf(b, "AmbientLifeMarker") and "AL" or b.Type
    if a_type < b_type then
      return true
    elseif a_type > b_type then
      return false
    else
      return (a.Groups and a.Groups[1] or "") < (b.Groups and b.Groups[1] or "")
    end
  end)
end
function GetGridMarkers(no_sorting, with_cursor_obj, no_AL_markers)
  if GetMap() == "" or IsChangingMap() then
    return {}
  end
  local filter = function(marker, with_cursor_obj)
    return (with_cursor_obj or not EditorCursorObjs[marker]) and not marker:IsKindOf("SetpieceMarker")
  end
  local markers = MapGetMarkers("GridMarker", nil, filter, with_cursor_obj)
  if not no_AL_markers then
    table.iappend(markers, MapGet("map", "AmbientLifeMarker", filter, with_cursor_obj))
  end
  if not no_sorting then
    SortMarkers(markers)
  end
  return markers
end
function UpdateGedGridMarkerRoot(with_cursor_obj)
  local grid_markers = GetGridMarkers(nil, with_cursor_obj)
  table.clear(GedGridMarkerEditorRoot)
  for _, marker in ipairs(grid_markers) do
    table.insert(GedGridMarkerEditorRoot, marker)
  end
end
function GedGridMarkerEditorRebuildRootOnDeletedMarker()
  if not GedGridMarkerEditor then
    return
  end
  CreateRealTimeThread(function()
    UpdateGedGridMarkerRoot()
    ObjModified(GedGridMarkerEditorRoot)
  end)
end
if FirstLoad then
  XEditorShowGridMarkersAreas = false
end
function XEditorUpdateGridMarkersAreas()
  MapForEachMarker(nil, nil, function(marker)
    if XEditorShowGridMarkersAreas then
      marker:ShowArea()
    elseif not table.find(mv_SelectedGridMarkers, marker) then
      marker:HideArea()
    end
  end)
end
MapVar("gv_AllMarkersGroups", false)
function GridMarkerGroupsCombo()
  if not gv_AllMarkersGroups then
    local groups = {}
    local markers = GetGridMarkers("no sorting", nil, "no AL markers")
    for _, marker in ipairs(markers) do
      for _, group in ipairs(marker.Groups or empty_table) do
        groups[group] = true
      end
    end
    gv_AllMarkersGroups = table.keys2(groups, true)
  end
  local items = table.icopy(gv_AllMarkersGroups)
  local groups = table.keys2(Groups or empty_table, "sorted")
  table.append(items, groups)
  return items
end
function OnMsg.ChangeMapDone()
  gv_AllMarkersGroups = false
  gv_AllMarkersGroups = GridMarkerGroupsCombo()
end
if FirstLoad then
  GedGridMarkerEditor = false
  GedGridMarkerEditorRoot = false
  s_DestroyingContainers = false
end
function OverlappingGridMarkersOffset(markers)
  markers = markers or GetGridMarkers("no sorting", "with_cursor_obj")
  local pos_markers = {}
  for _, marker in ipairs(markers) do
    local pos = marker:GetPos()
    local id
    if pos:z() then
      id = string.format("%d-%d-%d", pos:x(), pos:y(), pos:z())
    else
      id = string.format("%d-%d", pos:x(), pos:y())
    end
    pos_markers[id] = pos_markers[id] or {}
    table.insert(pos_markers[id], marker)
  end
  for _, overlap_markers in pairs(pos_markers) do
    if 1 < #overlap_markers then
      OffsetOverlappingMarkers(overlap_markers)
    end
  end
end
if FirstLoad then
  OffsetMarkers = {}
end
local dir = point(0, const.SlabSizeY / 4)
local up = point(0, 0, 4096)
local angle = 5400
function OffsetOverlappingMarkers(markers)
  local pos_packed = point_pack(markers[1]:GetPos())
  for idx, marker in ipairs(markers) do
    if 4 < idx then
      break
    end
    table.insert(OffsetMarkers, marker)
    local pos = marker:GetPos()
    marker:SetPos(pos + (pos:IsValidZ() and dir:SetZ(0) or dir))
    dir = RotateAxis(dir, up, angle)
  end
end
function RemoveOverlappingGridMarkersOffset()
  for _, marker in pairs(OffsetMarkers) do
    if IsValid(marker) then
      VoxelSnappingObj.SnapToVoxel(marker)
    end
  end
  OffsetMarkers = {}
end
function RefreshOverlappingGridMarkersOffset()
  if GedGridMarkerEditor and not terminal.IsKeyPressed(const.vkAlt) then
    RemoveOverlappingGridMarkersOffset()
    OverlappingGridMarkersOffset()
  end
end
function GedGridMarkerEditorContext()
  local classes = ClassDescendantsListInclusive("GridMarker")
  local context = {}
  context.rollovers = {}
  context.icons = {}
  for _, cls in ipairs(classes) do
    context.rollovers[cls] = g_Classes[cls].EditorRolloverText
    context.icons[cls] = g_Classes[cls].EditorIcon
  end
  context.WarningsUpdateRoot = "root"
  return context
end
function SelectMarkerInGedGridMarkerEditor(selected_markers)
  if not selected_markers or #selected_markers == 0 then
    return
  end
  local selected_marker_indeces = {}
  for _, marker in ipairs(selected_markers) do
    table.insert(selected_marker_indeces, table.find(GedGridMarkerEditorRoot, marker))
  end
  GedGridMarkerEditor:SetSelection("root", selected_marker_indeces)
end
function OpenGedGridMarkersEditor(selected_markers)
  if GedGridMarkerEditor then
    if selected_markers then
      SelectMarkerInGedGridMarkerEditor(selected_markers)
    end
    return
  end
  CreateRealTimeThread(function()
    if not GedGridMarkerEditor or not IsValid(GedGridMarkerEditor) then
      GedGridMarkerEditorRoot = GetGridMarkers()
      GedGridMarkerEditor = OpenGedApp("GedGridMarkerEditor", GedGridMarkerEditorRoot, GedGridMarkerEditorContext()) or false
      if GedGridMarkerEditor then
        OverlappingGridMarkersOffset(GedGridMarkerEditorRoot)
      end
      SelectMarkerInGedGridMarkerEditor(selected_markers, GedGridMarkerEditorRoot)
    end
  end)
end
function GridMarkerEditorSelect(root, obj, prop_id, socket)
  CreateRealTimeThread(function(root, obj, prop_id, socket)
    if not GedGridMarkerEditor then
      GedGridMarkerEditorRoot = GetGridMarkers()
      GedGridMarkerEditor = OpenGedApp("GedGridMarkerEditor", GedGridMarkerEditorRoot, GedGridMarkerEditorContext()) or false
      if GedGridMarkerEditor then
        OverlappingGridMarkersOffset(GedGridMarkerEditorRoot)
      end
    end
    local handle = string.match(prop_id, "h_(.*)_")
    local idx = table.find(GedGridMarkerEditorRoot, "handle", tonumber(handle or "0"))
    if idx then
      GedGridMarkerEditor:SetSelection("root", idx)
    end
  end, root, obj, prop_id, socket)
end
local SelectionFromGed
function OnMsg.GedOnEditorSelect(obj, selected, ged_editor)
  if selected and ged_editor == GedGridMarkerEditor then
    SelectionFromGed = true
    EditorSelectObjects({obj})
    SelectionFromGed = false
  end
end
function OnMsg.GedOnEditorMultiSelect(data, selected, ged_editor)
  if selected and ged_editor == GedGridMarkerEditor then
    SelectionFromGed = true
    EditorSelectObjects(data.__objects)
    SelectionFromGed = false
  end
end
function SelectInGedEditorSelected(objects)
  if not GedGridMarkerEditor or SelectionFromGed then
    return
  end
  CreateRealTimeThread(function(objects)
    local ged_selection = {}
    for _, obj in ipairs(objects) do
      if IsKindOf(obj, "GridMarker") then
        local marker_ged_idx = table.find(GedGridMarkerEditorRoot, obj)
        if marker_ged_idx then
          table.insert(ged_selection, marker_ged_idx)
        end
      end
    end
    local filter = GedGridMarkerEditor:FindFilter("root")
    if filter then
      for _, idx in ipairs(ged_selection) do
        if not filter:FilterObject(GedGridMarkerEditorRoot[idx]) then
          GedGridMarkerEditor:ResetFilter("root")
          break
        end
      end
    end
    GedGridMarkerEditor:SetSelection("root", ged_selection)
  end, objects)
end
MapVar("mv_SelectedGridMarkers", {})
function OnMsg.EditorSelectionChanged(objects)
  objects = objects or {}
  local old_markers = mv_SelectedGridMarkers
  mv_SelectedGridMarkers = {}
  for _, obj in ipairs(old_markers) do
    if obj and IsValid(obj) and not obj:IsAreaVisible() and not XEditorShowGridMarkersAreas then
      obj:HideArea()
    end
  end
  for _, obj in ipairs(objects) do
    if IsKindOf(obj, "GridMarker") then
      obj:ShowArea()
      mv_SelectedGridMarkers[#mv_SelectedGridMarkers + 1] = obj
    end
  end
  SelectInGedEditorSelected(objects)
end
DefineClass.GridMarkerFilter = {
  __parents = {"GedFilter"},
  properties = {
    {
      id = "Type",
      name = "Type",
      editor = "dropdownlist",
      items = function()
        return GetGridMarkerTypesCombo()
      end,
      default = ""
    },
    {
      id = "Group",
      name = "Group",
      editor = "dropdownlist",
      items = function()
        return GridMarkerGroupsCombo()
      end,
      default = ""
    },
    {
      id = "QuestId",
      name = "Quest id",
      editor = "preset_id",
      default = "",
      preset_class = "QuestsDef"
    }
  }
}
function GridMarkerFilter:CheckQuestFilter(marker)
  return CheckMarkerQuestDependencies(marker, self.QuestId)
end
function GridMarkerFilter:FilterObject(marker)
  if self.Type ~= "" and self.Type ~= marker.Type then
    return false
  end
  if self.Group ~= "" and not table.find(marker.Groups, self.Group) then
    return false
  end
  if self.QuestId ~= "" and not self:CheckQuestFilter(marker) then
    return false
  end
  return true
end
function GridMarkerFilter:DoneFiltering(displayed_items, filtered)
  local markers = GetGridMarkers()
  for idx, marker in ipairs(markers) do
    if marker:GetGameFlags(const.gofPermanent) ~= 0 then
      marker:SetVisible(not filtered[idx])
    end
  end
end
function OnMsg.GedClosing(ged_id)
  if GedGridMarkerEditor and GedGridMarkerEditor.ged_id == ged_id then
    RemoveOverlappingGridMarkersOffset()
    GedGridMarkerEditor = false
  end
end
function OnMsg.GedPropertyEdited(ged_id, object, prop_id, old_value)
  if GedGridMarkerEditor and GedGridMarkerEditor.ged_id == ged_id then
    local obj = GedGridMarkerEditor:ResolveObj("root")
    if prop_id == "Groups" then
      RecalcGroups()
    end
    ObjModified(obj)
  end
end
OnMsg.SaveMap = RemoveOverlappingGridMarkersOffset
OnMsg.PostSaveMap = OverlappingGridMarkersOffset
function OnMsg.ChangeMap()
  if GedGridMarkerEditor then
    GedGridMarkerEditor:Send("rfnApp", "Exit")
  end
end
function GedOpPlaceGridMarker(socket, marker, marker_type)
  XEditorStartPlaceObject(marker_type == "GridMarker" and "GridMarker-Position" or marker_type)
end
function MapGetMarkers(marker_type, group, filter, ...)
  local all_markers = g_GridMarkersContainer.labels[marker_type or "GridMarker"]
  local markers = {}
  for _, marker in ipairs(all_markers) do
    if (not group or group == "" or marker:IsInGroup(group)) and (not filter or filter(marker, ...)) then
      table.insert(markers, marker)
    end
  end
  return markers
end
function MapCountMarkers(marker_type, group, filter, ...)
  local all_markers = g_GridMarkersContainer.labels[marker_type or "GridMarker"]
  local count = 0
  for _, marker in ipairs(all_markers) do
    if (not group or group == "" or marker:IsInGroup(group)) and (not filter or filter(marker, ...)) then
      count = count + 1
    end
  end
  return count
end
function MapForEachMarker(marker_type, group, exec, ...)
  local args = {
    ...
  }
  g_GridMarkersContainer:ForEachInLabel(marker_type or "GridMarker", function(marker, ...)
    if not group or group == "" or marker:IsInGroup(group) then
      exec(marker, ...)
    end
  end, table.unpack(args))
end
function MapGetFirstMarker(marker_type, filter)
  return g_GridMarkersContainer:GetFirstInLabel(marker_type or "GridMarker", filter)
end
function UpdateEntranceAreasVisibility()
  if CurrentMap == "" or IsChangingMap() then
    return
  end
  MapForEachMarker("Entrance", false, function(marker)
    if marker:IsAreaVisible() then
      marker:ShowArea()
    else
      marker:HideArea()
    end
  end)
end
function OnMsg.ValidateMap()
  if not mapdata.GameLogic or not IsCampaignMap(GetMapName()) then
    return
  end
  local defender_markers = 0
  local border_area_markers = 0
  local first_ba_marker
  MapForEach("map", "GridMarker", function(marker)
    if marker.Type == "Entrance" and not SnapToPassSlab(marker) then
      StoreErrorSource(marker, string.format("Entrance marker '%s' on impassable!", marker.class))
    end
    if marker.Type == "Defender" then
      defender_markers = defender_markers + 1
    elseif marker.Type == "BorderArea" then
      if not first_ba_marker then
        first_ba_marker = marker
      end
      border_area_markers = border_area_markers + 1
    end
    if 0 < defender_markers and 1 < border_area_markers then
      return "break"
    end
  end)
  if defender_markers == 0 then
    local w, h = terrain.GetMapSize()
    StoreWarningSource(point(w / 2, h / 2), "This map has no defender markers, where should defenders be placed in case of a conflict?")
  end
  local msg = BorderAreaMarkerMessage(border_area_markers)
  if msg then
    StoreErrorSource(first_ba_marker, msg)
  end
end
OnMsg.ValidateMap = ValidateGameObjectProperties("GridMarker")
function GetBorderAreaMarker()
  local label = g_GridMarkersContainer.labels.BorderArea
  return label and label[1]
end
MapVar("g_InteractableAreaMarkers", {})
MapVar("g_BorderAreaRangeContour", false)
MapVar("g_GridMarkersContainer", false)
function OnMsg.NewMap()
  for _, marker in ipairs(g_InteractableAreaMarkers) do
    marker:RemoveFloatTxt()
  end
  table.clear(g_InteractableAreaMarkers)
  g_GridMarkersContainer = LabelContainer:new({})
end
function OnMsg.NewMapLoaded()
  MapForEachMarker("Entrance", nil, function(marker)
    table.insert(g_InteractableAreaMarkers, marker)
  end)
  local bam = GetBorderAreaMarker()
  if IsValid(bam) then
    local x, y = WorldToVoxel(bam)
    local voxel_left = x - bam.AreaWidth / 2
    local voxel_top = y - bam.AreaHeight / 2
    local left, top = VoxelToWorld(voxel_left - 1, voxel_top - 1)
    local right, bottom = VoxelToWorld(voxel_left + bam.AreaWidth, voxel_top + bam.AreaHeight)
    local width, height = terrain.GetMapSize()
    terrain.SetForcedImpassableBox(0, 0, width, top, true)
    terrain.SetForcedImpassableBox(0, bottom, width, height, true)
    terrain.SetForcedImpassableBox(0, top, left, bottom, true)
    terrain.SetForcedImpassableBox(right, top, width, bottom, true)
  end
end
function OnMsg.PostNewMapLoaded()
  MapForEachMarker("GridMarker", nil, function(marker)
    marker:RecalcAreaPositions()
  end)
  UpdateEntranceAreasVisibility()
end
local batchedWork = false
local maxPerTick = 4
local maxTicksPerTick = 3
local delay = 33
local function ProcessGridMarkersOnPassChanged()
  local c = 0
  local ignoreCount = IsChangingMap() or IsEditorActive()
  local start = GetPreciseTicks()
  for marker, _ in pairs(batchedWork) do
    c = c + 1
    batchedWork[marker] = nil
    if marker:IsAreaShown() and marker:GetGameFlags(const.gofPermanent) ~= 0 then
      marker:RecalcAreaPositions()
    end
    if not ignoreCount and (c >= maxPerTick or GetPreciseTicks() - start >= maxTicksPerTick) then
      break
    end
  end
  if next(batchedWork) then
    DelayedCall(delay, ProcessGridMarkersOnPassChanged)
  else
    batchedWork = false
  end
end
function OnMsg.OnPassabilityChanged(clip)
  if IsEditorSaving() then
    return
  end
  batchedWork = batchedWork or {}
  clip = clip:grow(const.SlabSizeX * 10)
  MapForEach(clip, "GridMarker", function(marker, batchedWork)
    if marker.recalc_area_on_pass_rebuild and marker.Reachable and marker.Type ~= "BorderArea" then
      batchedWork[marker] = true
    end
  end, batchedWork)
  DelayedCall(delay, ProcessGridMarkersOnPassChanged)
end
function BorderAreaMarkerMessage(count)
  if 1 < count then
    return "Border area markers should be no more than one per map."
  elseif count == 0 then
    return "Border area marker not present on map."
  end
end
local slab_x = const.SlabSizeX
local slab_y = const.SlabSizeY
function GetBorderAreaLimits()
  local bam = GetBorderAreaMarker()
  if not IsValid(bam) then
    return
  end
  local bam_pos_x, bam_pos_y = bam:GetPosXYZ()
  local border_min_x = bam_pos_x - slab_x * (bam.AreaWidth / 2) - slab_x / 2
  local border_min_y = bam_pos_y - slab_y * (bam.AreaHeight / 2) - slab_y / 2
  local border_max_x = border_min_x + bam.AreaWidth * slab_x
  local border_max_y = border_min_y + bam.AreaHeight * slab_y
  return box(border_min_x, border_min_y, border_max_x, border_max_y)
end
function RemoveNeighborVoxelsFromTable(pos, voxels)
  local x1, y1, z1 = VoxelToWorld(WorldToVoxel(pos))
  for i = #voxels, 1, -1 do
    local x2, y2, z2 = VoxelToWorld(WorldToVoxel(point_unpack(voxels[i])))
    if z1 == z2 and abs(x1 - x2) <= slab_x and abs(y1 - y2) <= slab_y then
      table.remove(voxels, i)
    end
  end
end
function GetReachablePositionsFromPos(pos, count)
  if count == 1 then
    return {pos}
  end
  local width = count * const.SlabSizeX
  local height = count * const.SlabSizeY
  local path = PlaceObject("CombatPath")
  local area_left = pos:x() - width / 2
  local area_top = pos:y() - height / 2
  path.restrict_area = box(area_left, area_top, area_left + width, area_top + height)
  path:RebuildPaths(nil, 200000, pos)
  local voxels = table.keys(path.paths_ap, true)
  local positions = {pos}
  RemoveNeighborVoxelsFromTable(pos, voxels)
  for i = 1, count - 1 do
    local v = table.rand(voxels, point_pack(pos))
    local pos_v = point(point_unpack(v))
    table.insert(positions, pos_v)
    RemoveNeighborVoxelsFromTable(pos_v, voxels)
  end
  return positions
end
function GetInteractableAreaMarkerRollover(m)
  if gv_DeploymentStarted then
    return (not SelectedObj or IsFirstSquadDeployment(SelectedObj.Squad)) and GetDeploymentAreaRollover(m)
  end
end
ArchetypesSorted = false
function ArchetypesCombo()
  if not ArchetypesSorted then
    ArchetypesSorted = table.keys2(Archetypes, true)
  end
  return ArchetypesSorted
end
DefineClass.RepositionMarker = {
  __parents = {"GridMarker"},
  properties = {
    {
      category = "Marker",
      id = "Color",
      name = "Color",
      editor = "color",
      default = RGB(255, 0, 255)
    },
    {
      category = "Grid Marker",
      id = "Type",
      name = "Type",
      editor = "text",
      default = "Reposition",
      no_edit = true
    },
    {
      category = "Grid Marker",
      id = "Groups",
      name = "Groups",
      editor = "string_list",
      no_edit = true
    },
    {
      category = "Marker",
      id = "AreaHeight",
      name = "Area Height",
      editor = "number",
      default = 0,
      no_edit = true
    },
    {
      category = "Marker",
      id = "AreaWidth",
      name = "Area Width",
      editor = "number",
      default = 0,
      no_edit = true
    },
    {
      category = "Marker",
      id = "Reachable",
      name = "Reachable only",
      editor = "bool",
      default = false,
      no_edit = true
    },
    {
      category = "Logic",
      id = "Trigger",
      name = "Trigger",
      editor = "dropdownlist",
      default = "once",
      items = {
        "once",
        "activation",
        "deactivation",
        "always",
        "change"
      },
      no_edit = true
    },
    {
      category = "Logic",
      id = "Effects",
      name = "Effects",
      editor = "nested_list",
      default = false,
      base_class = "Effect",
      no_edit = true
    },
    {
      category = "Archetype",
      id = "Archetypes",
      name = "Preferred Archetypes",
      editor = "string_list",
      default = false,
      no_edit = true
    },
    {
      category = "Logic",
      id = "TargetUnits",
      name = "Target Units",
      editor = "dropdownlist",
      items = PresetsCombo("UnitDataCompositeDef"),
      default = ""
    }
  },
  EditorRolloverText = "AI Reposition location",
  EditorIcon = "CommonAssets/UI/Icons/refresh repost retweet.tga",
  recalc_area_on_pass_rebuild = false
}
function LightsMarkerGroups()
  local light_marker_groups = {}
  local groups = GetBehaviorGroups()
  for _, group in ipairs(groups) do
    local objects = Groups[group]
    for _, obj in ipairs(objects) do
      if IsKindOf(obj, "LightsMarker") then
        table.insert(light_marker_groups, group)
        break
      end
    end
  end
  return light_marker_groups
end
DefineClass.LightsMarker = {
  __parents = {"GridMarker"},
  EditorRolloverText = "Lights Turn On/Off Marker",
  EditorIcon = "CommonAssets/UI/Icons/refresh repost retweet.tga",
  lights_off = false,
  lights_intensities = false
}
function LightsMarker:TurnLightOff(light)
  self.lights_intensities = self.lights_intensities or {}
  if not self.lights_intensities[light] then
    self.lights_intensities[light] = light:GetIntensity()
  end
  light:SetIntensity(0)
end
function LightsMarker:TurnLightOn(light)
  if not self.lights_intensities then
    return
  end
  if self.lights_intensities[light] then
    light:SetIntensity(self.lights_intensities[light])
  end
  self.lights_intensities[light] = nil
  if not next(self.lights_intensities) then
    self.lights_intensities = false
  end
end
function LightsMarker:GetDynamicData(data)
  data.lights_off = self.lights_off
  if not self.lights_intensities then
    return
  end
  data.lights_intensities = {}
  for light, intensity in pairs(self.lights_intensities) do
    if light.handle then
      data.lights_intensities[light.handle] = intensity
    end
  end
end
function LightsMarker:SetDynamicData(data)
  self.lights_off = data.lights_off
  if not data.lights_intensities then
    return
  end
  local invalid_handles = {}
  self.lights_intensities = {}
  for handle, intensity in pairs(data.lights_intensities) do
    local light = HandleToObject[handle]
    if light then
      self.lights_intensities[light] = intensity
      light:SetIntensity(0)
    else
      table.insert(invalid_handles, handle)
    end
  end
  for _, handle in ipairs(invalid_handles) do
    self.lights_intensities[handle] = nil
  end
  if not next(self.lights_intensities) then
    self.lights_intensities = false
  end
end
function MapGetLightsMarkers(marker_type, group, filter, ...)
  return MapGetMarkers(marker_type, group, function(marker, ...)
    return marker:IsKindOf("LightsMarker") and (not filter or filter(marker, ...))
  end, ...)
end
function OnMsg.ZuluGameLoaded()
  local lights_markers = MapGetLightsMarkers()
  local lights = GetLights()
  for _, light in ipairs(lights) do
    for _, marker in ipairs(lights_markers) do
      if marker.lights_off and (not marker.lights_intensities or not marker.lights_intensities[light]) and marker:IsInsideArea2D(light:GetPos()) then
        marker:TurnLightOff(light)
      end
    end
  end
end
function GetEditorFilterNonLeafMarkerClasses()
  return {"UnitMarker"}
end
function EditorViewAbridged(obj, id, filter_type)
  local value = obj.class
  if obj:HasMember("GetEditorView") then
    value = _InternalTranslate(T({
      obj:GetEditorView(),
      obj
    }))
    if not filter_type or filter_type == "quest" then
      value = value:gsub(" %(" .. id .. "%)", "")
      value = value:gsub("[Qq]uest " .. id .. ":? ", "")
    elseif filter_type == "conversation" then
      value = value:gsub(" " .. id, "")
    elseif filter_type == "banter" then
    end
  end
  return value
end
if Platform.developer and FirstLoad then
  g_DebugMarkersInfo = false
end
function GatherMarkerScriptingData()
  local markers_data = {}
  local map_name = GetMapName()
  local grid_markers = GetGridMarkers(nil, nil, "no AL markers")
  for idx, marker in ipairs(grid_markers) do
    local data = {}
    local name = string.format("%s#%03d", marker.Type, marker.handle % 1000)
    if marker.ID ~= "" then
      name = name .. " " .. marker.ID
    end
    if PropObjHasMember(marker, "DisplayName") and marker.DisplayName and marker.DisplayName ~= "" then
      name = name .. " \"" .. _InternalTranslate(marker.DisplayName) .. "\""
    end
    if marker.Groups and next(marker.Groups) then
      name = name .. " (" .. table.concat(marker.Groups, ", ") .. ")"
    end
    local BanterEffects = {}
    marker:ForEachSubObject("BanterFunctionObjectBase", function(effect, parents)
      table.insert_unique(BanterEffects, effect)
    end)
    local LootTableIds = {}
    marker:ForEachSubObject("ConditionalLoot", function(condLoot, parents)
      if condLoot.LootTableId then
        table.insert_unique(LootTableIds, condLoot.LootTableId)
      end
    end)
    local path = marker.Type .. " " .. marker.ID
    local data = {
      type = marker.Type,
      name = name,
      path = path,
      handle = marker.handle,
      map = map_name,
      Groups = marker.Groups,
      BanterGroups = next(marker.BanterGroups) and marker.BanterGroups or nil,
      SpecificBanters = next(marker.SpecificBanters) and marker.SpecificBanters or nil,
      BanterTriggerEffects = next(BanterEffects) and BanterEffects or nil,
      ApproachedBanters = next(marker.ApproachedBanters) and marker.ApproachedBanters or nil,
      ApproachBanterGroup = marker.ApproachBanterGroup or nil,
      LootTableIds = next(LootTableIds) and LootTableIds or nil
    }
    local items = {}
    marker:ForEachSubObject("QuestFunctionObjectBase", function(obj, parents)
      table.insert_unique(items, {
        filter_type = "quest",
        type = obj.class,
        reference_id = obj.QuestId,
        editor_view_abridged = EditorViewAbridged(obj, obj.QuestId, "quest"),
        var = rawget(obj, "Prop") or rawget(obj, "Vars"),
        var2 = rawget(obj, "Prop2")
      })
    end)
    marker:ForEachSubObject("ConversationFunctionObjectBase", function(obj, parents)
      table.insert_unique(items, {
        filter_type = "conversation",
        type = obj.class,
        reference_id = obj.Conversation,
        editor_view_abridged = EditorViewAbridged(obj, obj.Conversation, "conversation")
      })
    end)
    marker:ForEachSubObject("BanterFunctionObjectBase", function(obj, parents)
      for _, banter_str in ipairs(obj.Banters) do
        table.insert_unique(items, {
          filter_type = "banter",
          type = obj.class,
          reference_id = banter_str,
          editor_view_abridged = EditorViewAbridged(obj, banter_str, "banter")
        })
      end
    end)
    data.items = (next(items) or IsKindOf(marker, "UnitMarker")) and items or nil
    local hasBanter = data.BanterGroups or data.SpecificBanters or data.BanterTriggerEffects or data.ApproachedBanters or data.ApproachBanterGroup
    local hasLootTable = data.LootTableIds
    if IsKindOf(marker, "UnitMarker") or next(items) or hasBanter or hasLootTable then
      table.insert_unique(markers_data, data)
    end
  end
  if markers_data and next(markers_data) then
    table.sortby_field(markers_data, "handle")
    g_DebugMarkersInfo = g_DebugMarkersInfo or {}
    g_DebugMarkersInfo[map_name] = markers_data
  end
  return markers_data
end
function ForEachDebugMarkerData(info_type, ref_id, call_fn)
  for map, markers_data in sorted_pairs(g_DebugMarkersInfo or empty_table) do
    for _, marker in ipairs(markers_data) do
      local items = marker.items
      for _, item in ipairs(items) do
        if item.filter_type == info_type and item.reference_id == ref_id then
          call_fn(marker, item)
        end
      end
    end
  end
end
function IsGridMarkerWithDefenderRole(marker)
  local preset = marker and Presets.GridMarkerType.Default[marker.Type]
  return preset and preset.DefenderRole
end
function CheckMarkersPos()
  local allGridMarkers = GetGridMarkers("no sorting", nil, "no AL markers")
  local border = GetBorderAreaLimits()
  for _, marker in ipairs(allGridMarkers) do
    if not IsKindOf(marker, "ShowHideCollectionMarker") and border and not border:Point2DInside(marker:GetPos()) then
      StoreErrorSource(marker, "Marker placed outside the border.")
    end
  end
end
function OnMsg.SaveMap()
  CheckMarkersPos()
  if not Platform.developer then
    return
  end
  local markers_data = GatherMarkerScriptingData()
  local folder = GetMap()
  if markers_data and next(markers_data) then
    local path = folder .. "markers.debug.lua"
    SaveSVNFile(path, TableToLuaCode(markers_data, nil, pstr("", 1024)))
  end
end
local LoadDebugMarkersInfo = function(map)
  local file = GetMapFolder(map) .. "markers.debug.lua"
  if io.exists(file) then
    local err, str = AsyncFileToString(GetMapFolder(map) .. "markers.debug.lua")
    if str then
      local _, markers_data = LuaCodeToTuple(str)
      local map_name = markers_data and markers_data[1].map
      if map_name then
        g_DebugMarkersInfo = g_DebugMarkersInfo or {}
        g_DebugMarkersInfo[map_name] = markers_data
      end
    end
  end
end
function OnMsg.ChangeMapDone(map)
  if GetMap() ~= "" then
    MapForEachMarker(false, false, function(marker)
      marker:UpdateVisuals(marker.Type)
    end)
  end
  if Platform.developer then
    if not g_DebugMarkersInfo then
      g_DebugMarkersInfo = g_DebugMarkersInfo or {}
      for map, data in sorted_pairs(MapData) do
        LoadDebugMarkersInfo(map)
      end
    else
      LoadDebugMarkersInfo(map)
    end
  end
end
function SaveDebugMarkersLootTablesCSV()
  local csv = {}
  for map, data in sorted_pairs(g_DebugMarkersInfo) do
    local map_data = {}
    for _, marker in ipairs(data) do
      for _, loot_table_id in ipairs(marker.LootTableIds) do
        map_data[loot_table_id] = map_data[loot_table_id] or 0
        map_data[loot_table_id] = map_data[loot_table_id] + 1
      end
    end
    for k, v in sorted_pairs(map_data) do
      csv[#csv + 1] = {
        map = map,
        id = k,
        count = v
      }
    end
  end
  local fields = {
    "map",
    "id",
    "count"
  }
  local filename = "DebugMarkersLootTables.csv"
  local err = SaveCSV(filename, csv, fields, fields, ",")
  print(err or "CSV saved to", ":", ConvertToOSPath(filename), "")
end
function LootPerSectorCSV()
  if not SelectedObj or not SelectedObj:IsKindOf("Unit") then
    print("Run this with a merc selected on a gameplay map, please")
    return
  end
  local csv = {}
  local class_to_group = {}
  for group, items in pairs(Presets.InventoryItemCompositeDef) do
    if type(group) ~= "number" then
      for _, class in ipairs(items) do
        class_to_group[class.id] = group
      end
    end
  end
  local current_sector_id = gv_CurrentSectorId
  local map_to_sector = {}
  local campaign = Game and Game.Campaign or rawget(_G, "DefaultCampaign") or "HotDiamonds"
  local campaign_presets = rawget(_G, "CampaignPresets") or empty_table
  for _, sector in ipairs(campaign_presets[campaign] and campaign_presets[campaign].Sectors or empty_table) do
    if sector.Map then
      map_to_sector[sector.Map] = sector
      gv_CurrentSectorId = sector.Id
      local _, enemySquads = GetSquadsInSector(sector.Id, "excludeTravelling", false, "excludeArriving")
      local items = {}
      for i = #enemySquads, 1, -1 do
        for j = #enemySquads[i].units, 1, -1 do
          do
            local id = enemySquads[i].units[j]
            local unit = gv_UnitData[id]
            Unit.DropLoot(unit)
            unit:ForEachItem(function(item, slot_name, left, top, items)
              csv[#csv + 1] = {
                map = sector.Map,
                dropped_from = ObjectClass(unit),
                label1 = sector.Label1 or "none",
                label2 = sector.Label2 or "none",
                tier = string.format("%d.%d", sector.MapTier / 10, sector.MapTier % 10),
                class = ObjectClass(item),
                item_group = class_to_group[ObjectClass(item)] or "none",
                count = item.Amount or 1,
                condition = item.Condition or 0,
                guaranteed_drop = item.guaranteed_drop and 1 or 0,
                drop_chance = item.drop_chance
              }
            end, items)
          end
        end
      end
    end
  end
  for map, data in sorted_pairs(g_DebugMarkersInfo) do
    local map_data = {}
    local loot = {}
    local sector = map_to_sector[map]
    if sector then
      gv_CurrentSectorId = sector.Id
      for _, marker in ipairs(data) do
        for _, loot_table_id in ipairs(marker.LootTableIds) do
          if not LootDefs[loot_table_id] then
            print("Invalid loot id in ", marker)
          else
            LootDefs[loot_table_id]:GenerateLoot(SelectedObj, {}, AsyncRand(), loot)
          end
        end
      end
      for _, item in ipairs(loot) do
        csv[#csv + 1] = {
          map = map,
          dropped_from = "Marker",
          label1 = sector.Label1 or "none",
          label2 = sector.Label2 or "none",
          tier = string.format("%d.%d", sector.MapTier / 10, sector.MapTier % 10),
          class = ObjectClass(item),
          item_group = class_to_group[ObjectClass(item)] or "none",
          count = item.Amount or 1,
          condition = item.Condition or 0,
          guaranteed_drop = item.guaranteed_drop and 1 or 0,
          drop_chance = item.drop_chance
        }
      end
    end
  end
  gv_CurrentSectorId = current_sector_id
  local fields = {
    "map",
    "dropped_from",
    "tier",
    "label1",
    "label2",
    "class",
    "item_group",
    "count",
    "condition",
    "drop_chance",
    "guaranteed_drop"
  }
  local filename = "LootPerSector.csv"
  local err = SaveCSV(filename, csv, fields, fields, ",")
  print(err or "CSV saved to", ":", ConvertToOSPath(filename), "")
end
function OnMsg.EditorCategoryFilterChanged(c, filter)
  if c == "Markers" then
    local markers = GetGridMarkers("no sorting", nil, "no AL markers")
    for _, marker in ipairs(markers) do
      marker:SetVisible(filter ~= "invisible")
    end
  end
end
DefineClass.SaveMapCheckMarker = {
  __parents = {"Object"}
}
if Platform.developer then
  function GetShowHideCollectionMarkerBiggestRange()
    local biggest
    ForEachMap(nil, function()
      local map_biggest
      MapForEach("map", "ShowHideCollectionMarker", function(marker)
        local collection_idx = marker:GetCollectionIndex()
        if collection_idx and collection_idx ~= 0 then
          MapForEach("map", "collection", collection_idx, true, function(o)
            local dist = marker:GetDist(o)
            map_biggest = (not map_biggest or dist > map_biggest) and dist or map_biggest
          end)
        end
      end)
      if map_biggest then
        biggest = (not biggest or map_biggest > biggest) and map_biggest or biggest
        print(string.format("%s: %d / %d", GetMapName(), map_biggest, biggest))
      else
        print(string.format("No SaveMapCheckMarker objects on map %s", GetMapName()))
      end
    end)
    if biggest then
      print(string.format("Biggest Range: %d", biggest))
    end
    return biggest
  end
end
