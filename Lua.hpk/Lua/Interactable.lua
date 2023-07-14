InteractableCollectionMaxRange = 10 * guim
InteractableMaxRangeInTiles = 4
InteractableMaxSurfacesRadius = 12000
DefineClass.Interactable = {
  __parents = {
    "CObject",
    "PropertyObject",
    "GameDynamicDataObject",
    "EditorObject"
  },
  properties = {
    {
      category = "Interactable",
      id = "BadgePosition",
      name = "Badge Position",
      editor = "choice",
      items = {"self", "average"},
      default = "average"
    },
    {
      category = "Interactable",
      id = "range_in_tiles",
      name = "Interaction Distance (Voxels)",
      editor = "number",
      default = 2
    }
  },
  highlight = true,
  interactable_badge = false,
  intensely_highlit = false,
  until_interacted_with_highlight = false,
  until_interacted_with_highlight_suspended = false,
  highlit = false,
  interaction_last_highlight = false,
  interaction_spot = "Interaction",
  interaction_log = false,
  highlight_reasons = false,
  highlight_cooldown_time = false,
  highlight_thread = false,
  highlight_collection = true,
  marker_selectable = true,
  volume_badge_hiding = true,
  volume = false,
  volume_checking_thread = false,
  volume_hidden = false,
  enabled = true,
  discovered = false,
  spawner = false,
  visuals_spawners = false,
  visuals_cache = false,
  visuals_just_decals = false,
  los_check_obj = false,
  interact_positions = false,
  being_interacted_with = false
}
function Interactable:Init()
  self.highlight_reasons = {}
end
function Interactable:GameInit()
  self:PopulateVisualCache()
  if not self.volume_badge_hiding then
    return
  end
  local badgeSpot = self:GetInteractableBadgeSpot() or "Origin"
  self.volume = EnumVolumes(IsPoint(badgeSpot) and badgeSpot or self, "smallest")
  if IsKindOf(self, "SlabWallDoor") then
    local pos = self:GetPos()
    if not pos:IsValidZ() then
      pos = pos:SetTerrainZ()
    end
    local myFloor = WallInvisibilityGetCamFloor(pos)
    self.volume_checking_thread = CreateGameTimeThread(function(self)
      local visible, volume = true, self.volume
      while IsValid(self) do
        Sleep(500)
        if not IsEditorActive() and self.interactable_badge then
          visible = self:FloorCheckingThreadProc(myFloor, volume)
          self.interactable_badge:SetVisible(visible)
          self.volume_hidden = not visible
        end
      end
    end, self)
  elseif self.volume then
    self.volume_checking_thread = CreateGameTimeThread(function(self)
      local visible, volume = true, self.volume
      while IsValid(self) do
        Sleep(500)
        if not IsEditorActive() and self.interactable_badge then
          visible = self:VolumeCheckingThreadProc(volume)
          self.interactable_badge:SetVisible(visible)
          self.volume_hidden = not visible
        end
      end
    end, self)
  end
end
function Interactable:PopulateVisualCache()
  self.visuals_cache = false
  self.spawner = false
  local visuals = ResolveInteractableVisualObjects(self, 0, "no_cache") or empty_table
  for i, v in ipairs(visuals) do
    v:SetEnumFlags(const.efSelectable)
  end
  local imTheVisual = #visuals == 1 and visuals[1] == self
  if 0 < #visuals and self.BadgePosition ~= "self" and not imTheVisual then
    self:ClearEnumFlags(const.efSelectable)
    self.marker_selectable = false
  end
  if not imTheVisual then
    local justDecals = true
    local hasAtLeastOneDecal = false
    for i, v in ipairs(visuals) do
      local isDecal = IsKindOf(v, "Decal")
      if not isDecal and v ~= self then
        justDecals = false
      end
      hasAtLeastOneDecal = hasAtLeastOneDecal or isDecal
    end
    self.visuals_just_decals = justDecals
  end
  for i, obj in ipairs(visuals) do
    if IsKindOf(obj, "UnitMarker") then
      if not self.visuals_spawners then
        self.visuals_spawners = {}
      end
      table.insert(self.visuals_spawners, obj)
    elseif IsKindOf(obj, "ShowHideCollectionMarker") then
      if self.spawner then
        StoreErrorSource(self, "Multiple spawners (ContainerMarker/ShowHideCollection) in interactable collection")
      end
      self.spawner = obj
    end
  end
  local excludedClasses = {
    "Room",
    "Interactable",
    "GridMarker",
    "InvisibleObject"
  }
  if not self.visuals_just_decals then
    excludedClasses[#excludedClasses + 1] = "Decal"
  end
  local largest, largestSize = false, 0
  for i, vis in ipairs(visuals) do
    if not IsKindOfClasses(vis, excludedClasses) then
      local _, size = vis:GetBSphere()
      if largestSize < size then
        largest = vis
        largestSize = size
      end
    end
  end
  self.los_check_obj = largest
  self.visuals_cache = visuals
end
function Interactable:EditorExit()
  self:PopulateVisualCache()
end
function Interactable:VolumeCheckingThreadProc(volume)
  if table.find(self.highlight_reasons, "hotkey") then
    return true
  end
  if table.find(self.highlight_reasons, "cursor") then
    return true
  end
  local hiddenWalls = VT2CollapsedWalls and VT2CollapsedWalls[volume]
  if not hiddenWalls then
    return false
  end
  return true
end
function Interactable:FloorCheckingThreadProc(myFloor, volume)
  if table.find(self.highlight_reasons, "hotkey") then
    return true
  end
  if table.find(self.highlight_reasons, "cursor") then
    return true
  end
  local cameraFloor = cameraTac.GetFloor()
  if cameraFloor ~= myFloor then
    local hiddenWalls = VT2CollapsedWalls and VT2CollapsedWalls[volume]
    if not hiddenWalls or not hiddenWalls.Roof then
      return false
    end
  end
  return true
end
function Interactable:Done()
  DeleteThread(self.highlight_thread)
end
function Interactable:GetInteractionCombatAction(unit)
end
function Interactable:GetInteractionPos(unit)
  local interact_positions = self.interact_positions
  if not interact_positions then
    interact_positions = GetInteractablePos(self) or empty_table
    self.interact_positions = interact_positions
    if 0 < #interact_positions then
      local farther_pos
      for i, pos in ipairs(interact_positions) do
        if i == 1 or IsCloser2D(self, farther_pos, pos) then
          farther_pos = pos
        end
      end
      if not IsCloser2D(self, farther_pos, InteractableMaxSurfacesRadius) then
        local message = string.format("InteractableMaxSurfacesRadius(%d) is not enough. %s(%s, handle=%d) farther interact position distance is %d", InteractableMaxSurfacesRadius, self.class, self:GetEntity(), self.handle, self:GetDist2D(farther_pos))
        GameTestsError("once", message)
      end
    end
  end
  if not unit or #interact_positions == 0 then
    return
  end
  if self:HasSpot(self.interaction_spot) then
    local closest_spot_pos = interact_positions[1]
    if unit then
      for i = 2, #interact_positions do
        if IsCloser(unit, interact_positions[i], closest_spot_pos) then
          closest_spot_pos = interact_positions[i]
        end
      end
    end
    return closest_spot_pos
  end
  local result
  local count = 0
  for i, pt in ipairs(interact_positions) do
    if CanOccupy(unit, pt) then
      count = count + 1
      if i > count then
        if not result then
          result = {}
          for j = 1, count - 1 do
            result[j] = interact_positions[j]
          end
        end
        result[count] = pt
      end
    end
  end
  if count == 0 then
    return
  elseif count == #interact_positions then
    return interact_positions
  else
    if not result then
      result = {}
      for j = 1, count do
        result[j] = interact_positions[j]
      end
    end
    return result
  end
end
local interactable_range = const.SlabSizeX + const.PassTileSize / 2
local interactable_range_box = box(-interactable_range, -interactable_range, -const.SlabSizeZ, interactable_range + 1, interactable_range + 1, const.SlabSizeZ + 1)
local interactable_collision_offset = const.passSpheroidCollisionOffsetZ
function Interactable:GetInteractionPosOld(unit)
  local first, last = self:GetSpotRange(self.interaction_spot)
  if first < last then
    local closest_spot, closest_spot_pos
    for i = first, last do
      local p = SnapToPassSlab(self:GetSpotLocPosXYZ(i))
      if p and (not closest_spot or unit and IsCloser(unit, p, closest_spot_pos)) then
        closest_spot = i
        closest_spot_pos = p
      end
    end
    if closest_spot then
      local closest_spot_angle = self:GetSpotAngle2D(closest_spot)
      return closest_spot_pos, closest_spot_angle
    end
  end
  local pos_to_reach = {}
  local myPos = self:GetPos()
  pos_to_reach[1] = myPos
  local objs = ResolveInteractableVisualObjects(self)
  for i, visual_obj in ipairs(objs) do
    local center, radius = visual_obj:GetBSphere()
    table.insert(pos_to_reach, center)
  end
  local stance_idx = StancesList.Standing
  local positionsProcessed = 1
  local head_offset = const.passSpheroidCollisionOffsetZ
  while positionsProcessed < #pos_to_reach do
    local voxels = {}
    local segments = {}
    for i = positionsProcessed, #pos_to_reach do
      if 10 <= #voxels then
        break
      end
      local pos = pos_to_reach[i]
      local pos3D = pos
      if not pos3D:IsValidZ() then
        pos3D = pos:SetTerrainZ()
      end
      local center_x, center_y, center_z = pos3D:xyz()
      center_x, center_y, center_z = SnapToVoxel(center_x, center_y, SnapToVoxelZ(center_x, center_y, center_z))
      pos3D = pos3D:SetZ(pos3D:z() + head_offset)
      local voxel_enum_box = Offset(interactable_range_box, center_x, center_y, center_z)
      ForEachPassSlab(voxel_enum_box, function(x, y, z, center_x, center_y, center_z, unit, voxels, segments, stance_idx, pos3D)
        if x == center_x and y == center_y then
          local voxelz = SnapToVoxelZ(x, y, z)
          if voxelz == center_z then
            return
          end
        end
        if unit and not CanOccupy(unit, x, y, z) then
          return
        end
        table.insert(voxels, point(x, y, z))
        table.insert(segments, stance_head_pos(stance_pos_pack(x, y, z, stance_idx)))
        table.insert(segments, pos3D)
      end, center_x, center_y, center_z, unit, voxels, segments, stance_idx, pos3D)
      positionsProcessed = positionsProcessed + 1
    end
    if not next(voxels) then
      local selfPassSlab = SnapToPassSlab(self)
      if not selfPassSlab then
        return terrain.FindPassable(myPos, unit)
      end
      return empty_table
    end
    local any_hit, hit_points, hit_objs = CollideSegmentsObjs(segments)
    if not any_hit then
      return voxels
    end
    local result = false
    for i, pt in ipairs(voxels) do
      local noHit = not hit_points[i]
      local terrainHit = not hit_objs[i]
      local sharedObjectHit = false
      if not noHit and not terrainHit then
        local _, allInteractables = ResolveInteractableObject(hit_objs[i])
        sharedObjectHit = table.find(allInteractables, self)
      end
      if noHit or terrainHit or sharedObjectHit then
        result = result or {}
        table.insert(result, pt)
      end
    end
    if result then
      result.mustMove = not unit or not table.find(result, unit:GetPos())
      return result
    end
  end
  return empty_table
end
InteractionLogEvents = {"start", "end"}
InteractionLogResults = {
  Lockpick = {
    false,
    "success",
    "fail"
  },
  Break = {
    false,
    "success",
    "fail"
  },
  Interact_Disarm = {
    false,
    "success",
    "fail"
  },
  Interact_LootUnit = {false, "looted"},
  Interact_LootContainer = {false, "looted"}
}
function Interactable:LogInteraction(unit, combatActionId, event, resultSpecifier)
  if not self.interaction_log then
    self.interaction_log = {}
  end
  local interaction = {
    unit_template_id = unit.unitdatadef_id,
    action = combatActionId,
    event = event
  }
  if resultSpecifier then
    interaction.result = resultSpecifier
  end
  table.insert(self.interaction_log, interaction)
  self:InteractableHighlightUntilInteractedWith(false)
end
function Interactable:RegisterInteractingUnit(unit)
end
function Interactable:UnregisterInteractingUnit(unit)
end
function Interactable:BeginInteraction(unit)
end
function Interactable:EndInteraction(unit)
  local canInteractWith = UICanInteractWith(unit, self)
  if not canInteractWith then
    table.clear(self.highlight_reasons)
    self:HighlightIntensely(false)
  end
end
function Interactable:GetInteractionVisuals(unit)
  local action, iconOverride = self:GetInteractionCombatAction(unit or UIFindInteractWith(self))
  if action then
    return iconOverride or action.Icon
  end
end
function Interactable:UpdateInteractableBadge(visible, image)
  local badge = self.interactable_badge
  if badge and visible and badge.target == self and IsKindOf(badge.ui, "XImage") and badge.ui.Image == image then
    return
  end
  if not not badge == not not visible then
    return
  end
  if badge and not visible then
    badge:delete()
    self.interactable_badge = false
    return
  end
  if not IsValid(self) then
    return
  end
  if not badge and visible then
    badge = CreateBadgeFromPreset("InteractableBadge", {
      target = self,
      spot = self:GetInteractableBadgeSpot() or "Origin"
    }, self)
    if not badge then
      return
    end
    if self.volume_hidden then
      badge:SetVisible(false)
    end
  end
  badge.ui.idImage:SetImage(image)
  self.interactable_badge = badge
end
function Interactable:BadgeTextUpdate()
  local withCursor = table.find(self.highlight_reasons, "cursor")
  local badgeInstance = self.interactable_badge
  if not badgeInstance or badgeInstance.ui.window_state == "destroying" then
    return
  end
  if IsUnitPartOfAnyActiveBanter(self) then
    badgeInstance.ui.idText:SetVisible(false)
    return
  end
  local unit = UIFindInteractWith(self)
  if unit then
    local action = self:GetInteractionCombatAction(unit)
    badgeInstance.ui.idText:SetContext(unit)
    if action == CombatActions.Interact_Talk or action == CombatActions.Interact_Banter then
      badgeInstance.ui.idText:SetText(T({
        418007709502,
        "<ActionName> <style UIHeaderLabelsAccent>(<Nick>)</style>",
        ActionName = T({
          action:GetActionDisplayName({unit, self}),
          target = self,
          unit = unit
        }),
        Nick = unit.Nick
      }))
    elseif #Selection > 1 and not action.DontShowWith then
      badgeInstance.ui.idText:SetText(T({
        562471619295,
        "<ActionName> with <Nick>",
        ActionName = T({
          action:GetActionDisplayName({unit, self}),
          target = self,
          unit = unit
        }),
        Nick = unit.Nick
      }))
    else
      badgeInstance.ui.idText:SetText(T({
        501564765631,
        "<ActionName>",
        ActionName = T({
          action:GetActionDisplayName({unit, self}),
          target = self,
          unit = unit
        })
      }))
    end
  end
  badgeInstance.ui.idText:SetVisible(withCursor)
end
function Interactable:GetHighlightColor()
  return 3
end
function Interactable:SetHighlightColorModifier(visible)
  local color_modifier = visible and const.clrWhite or const.clrNoModifier
  self:SetColorModifier(color_modifier)
end
MapVar("InteractableColorModifierStorage", {})
function SetInteractionHighlightRecursive(obj, visible, highlight, highlight_col, clr_contour, force_passed_color)
  clr_contour = clr_contour or 3
  if highlight then
    if IsKindOf(obj, "Interactable") then
      if obj:SetHighlightColorModifier(visible) == "break" then
        return
      end
      if not force_passed_color then
        clr_contour = obj:GetHighlightColor() or clr_contour
      end
    else
      local current_mod = obj:GetColorModifier()
      if not InteractableColorModifierStorage[obj] and current_mod ~= const.clrNoModifier and current_mod ~= const.clrWhite then
        InteractableColorModifierStorage[obj] = current_mod
      end
      local color_modifier
      if visible then
        if InteractableColorModifierStorage[obj] then
          color_modifier = InterpolateRGB(InteractableColorModifierStorage[obj], const.clrWhite, 20, 255)
        else
          color_modifier = const.clrWhite
        end
      else
        color_modifier = InteractableColorModifierStorage[obj] or const.clrNoModifier
      end
      obj:SetColorModifier(color_modifier)
    end
    if visible then
      obj:SetContourOuterID(true, clr_contour)
      obj:ForEachAttach(function(att)
        att:SetContourOuterID(true, clr_contour)
      end)
    else
      obj:ClearHierarchyGameFlags(const.gofContourOuter)
      obj:SetContourOuterID(false, clr_contour)
      obj:ForEachAttach(function(att)
        att:SetContourOuterID(false, clr_contour)
      end)
    end
  end
  if IsValid(obj) then
    C_CCMT_SetObjOpacityOneMode(obj, visible and highlight == "hidden-too")
  end
  if highlight_col then
    local visual_objs = ResolveInteractableVisualObjects(obj)
    for i, obj in ipairs(visual_objs) do
      SetInteractionHighlightRecursive(obj, visible, highlight, false, clr_contour)
    end
  end
  local attaches = obj:GetAttaches() or empty_table
  for i, obj in ipairs(attaches) do
    SetInteractionHighlightRecursive(obj, visible, highlight, false, clr_contour)
  end
end
function Interactable:HighlightIntensely(visible, reason)
  local noChangeNeeded = false
  local highlight_reasons = self.highlight_reasons
  if reason then
    if visible then
      if not table.find_value(highlight_reasons, reason) then
        highlight_reasons[#highlight_reasons + 1] = reason
        if 1 < #highlight_reasons then
          noChangeNeeded = true
        end
      end
    elseif #highlight_reasons == 0 then
      noChangeNeeded = true
    else
      table.remove_value(highlight_reasons, reason)
      if 0 < #highlight_reasons then
        noChangeNeeded = true
        visible = true
      end
    end
  end
  noChangeNeeded = noChangeNeeded and self.intensely_highlit == visible
  if self.interactable_badge and self.interactable_badge.ui and reason == "cursor" then
    self.interactable_badge.ui.RolloverOnFocus = true
    if not GetUIStyleGamepad() then
      self.interactable_badge.ui:SetFocus(visible)
    end
  end
  local hotkeyHighlight = visible and reason == "hotkey"
  local badgeOnly = #highlight_reasons == 1 and highlight_reasons[1] == "badge-only"
  if not hotkeyHighlight and not badgeOnly and noChangeNeeded then
    self:BadgeTextUpdate()
    return
  end
  self.intensely_highlit = visible
  local visuals = visible and self:GetInteractionVisuals() or self.interaction_last_highlight
  self.interaction_last_highlight = visuals
  self:UpdateInteractableBadge(visible, visuals)
  local highlightOn = visible and not badgeOnly
  SetInteractionHighlightRecursive(self, highlightOn, hotkeyHighlight and "hidden-too" or true, self.highlight_collection)
  self:BadgeTextUpdate()
end
function Interactable:InteractableHighlightUntilInteractedWith(apply)
  if apply and self:HasMember("IsMarkerEnabled") and not self:IsMarkerEnabled({}) then
    return
  end
  if IsKindOf(self, "Unit") then
    self:SetHighlightReason("can_be_interacted", apply)
  end
  local visuals = self.visuals_cache
  for i, v in ipairs(visuals) do
    local dead = v:HasMember("IsDead") and v:IsDead()
    local marking = not (not apply or dead) and 11 or -1
    v:SetObjectMarking(marking)
    if marking < 0 then
      v:ClearHierarchyGameFlags(const.gofObjectMarking)
    else
      v:SetHierarchyGameFlags(const.gofObjectMarking)
    end
  end
  self.until_interacted_with_highlight = apply
end
function Interactable:UnitNearbyHighlight(time, cooldown, force)
  if not force and self.highlight_cooldown_time and GameTime() - self.highlight_cooldown_time < 0 then
    return false
  end
  local clr_contour = 5
  local period = Presets.ContourOuterParameters.Default.DefaultParameters.period_5 or 3000
  if period == 0 then
    period = 1000
  end
  self.highlight_cooldown_time = GameTime() + cooldown
  time = RoundUp(time, period)
  local visuals = self.visuals_cache
  self:InteractableHighlightUntilInteractedWith(true)
  DeleteThread(self.highlight_thread)
  self.highlight_thread = CreateGameTimeThread(function(self)
    local interactionLogCount = #(self.interaction_log or "")
    local start = GameTime()
    local tick = 0
    local proper_start = RoundUp(start, period)
    Sleep(proper_start - start)
    start = proper_start
    for i, v in ipairs(visuals) do
      v:SetContourRecursive(true, clr_contour)
    end
    while true do
      if not (GameTime() - start < time and not (interactionLogCount < #(self.interaction_log or "")) and self:GetInteractionCombatAction()) then
        break
      end
      Sleep(200)
    end
    self.highlight_thread = nil
    for i, v in ipairs(visuals) do
      v:SetContourRecursive(false, clr_contour)
    end
  end, self)
  return true
end
function Interactable:SetDynamicData(data)
  self.interaction_log = data.interaction_log
  if data.enabled ~= nil then
    self.enabled = data.enabled
  end
  if data.discovered then
    self.discovered = data.discovered
  end
  if data.until_interacted_with_highlight then
    self:InteractableHighlightUntilInteractedWith(true)
  end
end
function Interactable:GetDynamicData(data)
  if #(self.interaction_log or "") > 0 then
    data.interaction_log = self.interaction_log
  end
  if not self.enabled then
    data.enabled = self.enabled
  end
  if self.discovered then
    data.discovered = self.discovered
  end
  if self.until_interacted_with_highlight then
    data.until_interacted_with_highlight = self.until_interacted_with_highlight
  end
end
function Interactable:GetInteractableBadgeSpot()
  if self.BadgePosition ~= "average" then
    return "Origin"
  end
  local sumX = 0
  local sumY = 0
  local sumZ = 0
  local collection = ResolveInteractableVisualObjects(self)
  local count = 0
  for i, s in ipairs(collection) do
    if s:GetEnumFlags(const.efVisible) ~= 0 then
      local badgeSpot = s:GetSpotBeginIndex("Interactablebadge")
      if badgeSpot and badgeSpot ~= -1 then
        return s:GetSpotPos(badgeSpot)
      end
      badgeSpot = s:GetSpotBeginIndex("Badge")
      if badgeSpot and badgeSpot ~= -1 then
        return s:GetSpotPos(badgeSpot)
      end
      local x, y, z = s:GetPosXYZ()
      sumX = sumX + x
      sumY = sumY + y
      sumZ = sumZ + (z or terrain.GetHeight(x, y))
      count = count + 1
    end
  end
  if count == 0 then
    return "Origin"
  end
  local averagePosition = point(sumX, sumY, sumZ) / count
  return averagePosition
end
local SkipRebuildInteractables = {
  "Unit",
  "Door",
  "MachineGunEmplacement",
  "Landmine",
  "ExplosiveContainer"
}
function RebuildInteractablesList(interactables)
  local positions = GetInteractablePos(interactables)
  for i, obj in ipairs(interactables) do
    obj.interact_positions = positions[i] or empty_table
  end
end
function RebuildAreaInteractables(clip)
  local area
  if clip then
    local obj_max_radius = InteractableMaxSurfacesRadius or GetEntityMaxSurfacesRadius()
    area = clip:grow(obj_max_radius + (InteractableMaxRangeInTiles + 1) * const.SlabSizeX)
  end
  MapForEach(area or "map", "Interactable", function(o)
    if o:IsKindOfClasses(SkipRebuildInteractables) then
      return
    end
    o.interact_positions = false
  end)
end
function ResolveInteractableObject(obj)
  if not IsKindOf(obj, "CObject") then
    return
  end
  local spawner = rawget(obj, "spawner")
  if spawner and spawner ~= obj and (obj.highlight_collection or not IsKindOf(obj, "Interactable")) then
    local markerInteractable, mrkGroup = ResolveInteractableObject(spawner)
    if markerInteractable then
      return markerInteractable, mrkGroup
    end
  end
  local interactables
  if obj.visual_of_interactable then
    interactables = {
      obj.visual_of_interactable
    }
  end
  if IsKindOf(obj, "Interactable") then
    interactables = interactables or {}
    table.insert_unique(interactables, obj)
  end
  local originalObject = obj
  obj = SelectionPropagate(obj)
  if obj ~= originalObject and IsKindOf(obj, "Interactable") then
    interactables = interactables or {}
    table.insert_unique(interactables, obj)
  end
  local root_collection = obj:GetRootCollection()
  local collection_idx = root_collection and root_collection.Index or 0
  if collection_idx ~= 0 then
    local collection_objs = MapGet(obj, InteractableCollectionMaxRange, "collection", collection_idx, true, "Interactable")
    if interactables then
      table.iappend(interactables, collection_objs)
    else
      interactables = collection_objs
    end
  end
  if not interactables then
    return
  end
  local hasCollectionExclusion, allCollectionExclusion = false, true
  for i, int in ipairs(interactables) do
    if int.highlight_collection then
      allCollectionExclusion = false
    else
      hasCollectionExclusion = true
    end
  end
  if hasCollectionExclusion and not allCollectionExclusion then
    local nonExcluding = {}
    for i, int in ipairs(interactables) do
      if int.highlight_collection then
        nonExcluding[#nonExcluding + 1] = int
      end
    end
    interactables = nonExcluding
  end
  if interactables[1] and #interactables == 1 and not interactables[1].highlight_collection and originalObject ~= interactables[1] then
    return false
  end
  return interactables[1], interactables[1] and interactables[1].highlight_collection and interactables or {
    interactables[1]
  }
end
function ResolveInteractableVisualObjects(obj, flag, skipCache)
  if not obj.highlight_collection then
    return {obj}
  end
  local collection_objs = not skipCache and obj.visuals_cache
  if collection_objs then
    local count = #collection_objs
    if count == 1 and IsKindOf(collection_objs[1], "Interactable") then
      return collection_objs
    end
    if 0 < count then
      local anyDestroyed, anyNonDecal
      for i = count, 1, -1 do
        local o = collection_objs[i]
        if IsObjectDestroyed(o) then
          SetInteractionHighlightRecursive(o, false, true)
          anyDestroyed = true
          table.remove(collection_objs, i)
          count = count - 1
        elseif not anyNonDecal and not IsKindOf(o, "Decal") and o ~= obj then
          anyNonDecal = true
        end
      end
      if anyDestroyed then
        if count == 1 and collection_objs[1] == obj and not obj.marker_selectable then
          collection_objs = empty_table
        end
        obj.los_check_obj = collection_objs[1] or obj
        obj.visuals_cache = collection_objs
      end
      if not anyNonDecal and not obj.visuals_just_decals then
        obj.los_check_obj = false
        obj.visuals_cache = empty_table
      end
    end
  else
    local root_collection = obj:GetRootCollection()
    local collection_idx = root_collection and root_collection.Index or 0
    if collection_idx == 0 then
      return {obj}
    end
    collection_objs = MapGet(obj, InteractableCollectionMaxRange, "collection", collection_idx, true, flag or const.efVisible)
    if collection_objs and #collection_objs == 1 and IsKindOf(collection_objs[1], "Interactable") then
      return collection_objs
    end
  end
  if obj.visuals_spawners then
    local t = collection_objs ~= obj.visuals_cache and collection_objs
    for i, sp in ipairs(obj.visuals_spawners) do
      for i, o in ipairs(sp.objects) do
        t = t or table.copy({collection_objs})
        table.insert(t, o)
      end
    end
    collection_objs = t or collection_objs
  end
  return collection_objs
end
function OnMsg.GatherFXActions(list)
  table.insert(list, "InteractableIntenseHighlight")
  table.insert(list, "InteractableHighlight")
end
function OnMsg.GameTimeStart()
  MapForEach("map", "Interactable", function(interactable)
    if IsKindOfClasses(interactable, InteractableClassesThatAreDestroyable) then
      return
    end
    if IsKindOf(interactable, "ContainerMarker") then
      return
    end
    if IsKindOf(interactable, "Trap") and interactable.boobyTrapType ~= BoobyTrapTypeNone then
      return
    end
    local visuals = ResolveInteractableVisualObjects(interactable)
    for _, obj in ipairs(visuals) do
      if not IsKindOfClasses(obj, InteractableClassesThatAreDestroyable) then
        TemporarilyInvulnerableObjs[obj] = true
      end
    end
  end)
end
function SpawnedByEnabledMarker(obj)
  if obj:HasMember("spawner") and obj.spawner and obj.spawner:IsKindOf("GridMarker") then
    if obj.spawner == obj and not obj:IsMarkerEnabled() then
      return false
    end
    return obj.spawner:IsKindOf("ShowHideCollectionMarker") and obj.spawner.last_spawned_objects
  end
  if IsKindOf(obj, "ShowHideCollectionMarker") then
    return obj:IsMarkerEnabled() and obj:IsKindOf("ShowHideCollectionMarker") and obj.last_spawned_objects
  end
  return true
end
function OnMsg.UnitSideChanged(unit)
  if unit and unit.highlight_reasons and #unit.highlight_reasons > 0 then
    table.clear(unit.highlight_reasons)
    unit:HighlightIntensely(false)
  end
end
if Platform.developer then
  local GetObjCollectionIdx = function(obj)
    if not obj.highlight_collection then
      return
    end
    local root_collection = obj:GetRootCollection()
    local collection_idx = root_collection and root_collection.Index or 0
    if collection_idx == 0 then
      return
    end
    return collection_idx
  end
  function InteractableCollectionsTooBigVME()
    MapForEach("map", "Interactable", function(obj)
      local collection_idx = GetObjCollectionIdx(obj)
      if not collection_idx then
        return
      end
      local objPos = obj:GetPos()
      local collection_objs = MapGet("map", "collection", collection_idx, true)
      for i, colObj in ipairs(collection_objs) do
        if not IsKindOf(colObj, "Interactable") then
          local dist = colObj:GetPos():Dist(objPos)
          if dist > InteractableCollectionMaxRange then
            StoreErrorSource(colObj, "Object in interactable collection is further from than interactable than what is allowed. " .. dist .. " > " .. InteractableCollectionMaxRange)
          end
        end
      end
    end)
  end
  OnMsg.PostSaveMap = InteractableCollectionsTooBigVME
  OnMsg.NewMapLoaded = InteractableCollectionsTooBigVME
  function MakeInteractableCollectionsEssentialsOnly()
    MapForEach("map", "Interactable", function(obj)
      local collection_idx = GetObjCollectionIdx(obj)
      if not collection_idx then
        return
      end
      local collection_objs = MapGet("map", "collection", collection_idx, true)
      for i, colObj in ipairs(collection_objs) do
        if not IsKindOf(colObj, "Interactable") and colObj:GetDetailClass() ~= "Essential" then
          StoreErrorSource(colObj, "Object in collection with interactable is not 'Essential' - forcing it to save as such!", obj)
          colObj:SetDetailClass("Essential")
        end
      end
    end)
  end
  OnMsg.PreSaveMap = MakeInteractableCollectionsEssentialsOnly
end
local lInteractableVisibilityRange = 10 * guim
function OnMsg.ExplorationTick()
  if IsSetpiecePlaying() then
    return
  end
  local units = GetAllPlayerUnitsOnMap()
  for i, u in ipairs(units) do
    InteractableVisibilityUpdate(u)
  end
end
function OnMsg.CombatGotoStep(unit)
  if not Selection then
    return
  end
  if unit ~= Selection[1] then
    return
  end
  if g_Combat and not g_Combat.combat_started then
    return
  end
  DelayedCall(0, InteractableVisibilityUpdate, unit)
end
function OnMsg.ClassesGenerate(classdefs)
  local class = classdefs.ContourOuterParameters
  table.insert(class.properties, {
    id = "default_time",
    editor = "number",
    scale = 1000,
    default = 5001,
    category = "ID: 5"
  })
  table.insert(class.properties, {
    id = "default_cooldown",
    editor = "number",
    scale = 1000,
    default = 60000,
    category = "ID: 5"
  })
end
function NetSyncEvents.UnitDiscoveredInteractables(unit, interactables)
  local newLootDiscovered = false
  local nonUnitInteractableFound = false
  for i, o in ipairs(interactables) do
    local lootable = IsKindOfClasses(o, "Unit", "ItemContainer")
    if not o.discovered then
      o.discovered = true
      newLootDiscovered = lootable
      nonUnitInteractableFound = not IsKindOf(o, "Unit") and not IsKindOf(o, "CuttableFence") and not IsKindOf(o, "Landmine")
    end
    local preset = Presets.ContourOuterParameters.Default.DefaultParameters
    o:UnitNearbyHighlight(preset.default_time, preset.default_cooldown)
  end
  if nonUnitInteractableFound and not g_Combat then
    local pickedUnit = RandomSelectNearUnit(unit, const.SlabSizeX * 5)
    if newLootDiscovered then
      PlayVoiceResponse(pickedUnit, "LootFound")
    else
      PlayVoiceResponse(pickedUnit, "InteractableFound")
    end
  end
end
function InteractableVisibilityUpdate(unit)
  if IsSetpiecePlaying() then
    return
  elseif not IsValid(unit) then
    return
  elseif not unit:CanBeControlled() then
    return
  end
  local interactablesAll = MapGet(unit, lInteractableVisibilityRange, "Interactable")
  local interactablesCheck = false
  local interactablesLosCheck = false
  for i, o in ipairs(interactablesAll) do
    if (not IsKindOf(o, "Unit") or o:IsDead()) and not IsKindOf(o, "ExitZoneInteractable") and UICanInteractWith(unit, o) and not o.discovered then
      interactablesCheck = interactablesCheck or {}
      interactablesLosCheck = interactablesLosCheck or {}
      interactablesCheck[#interactablesCheck + 1] = o
      interactablesLosCheck[#interactablesLosCheck + 1] = o.los_check_obj or o
    end
  end
  if not interactablesCheck then
    return
  end
  local _, losData = CheckLOS(interactablesLosCheck, unit, lInteractableVisibilityRange)
  local discovered = false
  for i, o in ipairs(interactablesCheck) do
    if losData[i] then
      discovered = discovered or {}
      discovered[#discovered + 1] = o
    end
  end
  if not discovered then
    return
  end
  FireNetSyncEventOnce("UnitDiscoveredInteractables", unit, discovered)
end
function OnMsg.UnitDied(unit)
  if unit then
    unit.discovered = true
    if unit:IsDead() and unit:GetItemInSlot("InventoryDead") then
      unit:InteractableHighlightUntilInteractedWith(true)
    end
  end
end
function RandomSelectNearUnit(unit, distance)
  local units = {}
  for _, u in ipairs(unit.team.units) do
    if distance >= u:GetDist(unit) then
      table.insert(units, u)
    end
  end
  return table.rand(units, InteractionRand(1000000, "InteractableVR"))
end
function GetAllInteractablesOnFloors()
  if not CanYield() then
    CreateRealTimeThread(GiveMeAllInteractablesOnFloors)
    return
  end
  local interactables = {}
  ForEachMap(ListMaps(), function()
    MapForEach("map", "Interactable", function(o)
      if IsKindOf(o, "CuttableFence") and not o:GetInteractionPos() then
        return
      end
      if o:IsValidZ() and not IsKindOf(o, "Door") then
        if not interactables[CurrentMap] then
          interactables[CurrentMap] = {}
        end
        local tbl = interactables[CurrentMap]
        tbl[#tbl + 1] = tostring(o.class) .. "@" .. tostring(o:GetPos())
      end
    end)
  end)
  local err = AsyncStringToFile("AppData/Interactables.txt", TableToLuaCode(interactables))
end
function CalcInteractableMaxSurfacesRadius()
  local max_radius = 0
  for name, class in pairs(g_Classes) do
    if IsKindOf(class, "Interactable") and IsValidEntity(class:GetEntity()) then
      local r = GetEntityMaxSurfacesRadius(class:GetEntity())
      if max_radius < r then
        max_radius = r
      end
    end
  end
  return max_radius
end
function SuspendInteractableHighlights()
  MapForEach("map", "Interactable", function(m)
    if m.until_interacted_with_highlight then
      m:InteractableHighlightUntilInteractedWith(false)
      m.until_interacted_with_highlight_suspended = true
    end
  end)
end
function ResumeInteractableHightlights()
  MapForEach("map", "Interactable", function(m)
    if m.until_interacted_with_highlight_suspended then
      m:InteractableHighlightUntilInteractedWith(true)
      m.until_interacted_with_highlight_suspended = false
    end
  end)
end
