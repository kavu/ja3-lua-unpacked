local voxelSizeX = const.SlabSizeX or 0
local voxelSizeY = const.SlabSizeY or 0
local voxelSizeZ = const.SlabSizeZ or 0
local halfVoxelSizeX = voxelSizeX / 2
local halfVoxelSizeY = voxelSizeY / 2
local halfVoxelSizeZ = voxelSizeZ / 2
local InvalidZ = const.InvalidZ
local rayOffsetHorizontal = voxelSizeX * 3
local rayOffsetVertical = voxelSizeX * 3
local boxSide = voxelSizeX * 3
local noneWallMat = "none"
local showWallDelay = 350
local hideWallDelay = 500
local hideRoomsBelowCameraFloor = false
local rayOffsetHorizontalV2 = voxelSizeX * 5
local rayOffsetVerticalV2 = voxelSizeX * 5
local CollapseWallRange = voxelSizeX * 8
local HideRoofsWhenAboveMaxFloorUpToThisMuch = 0
local HitFirstFloorWhenBelowItThisMuch = voxelSizeZ * 5
local ExtendVerticelPerFloor = voxelSizeX
local gofContourInner = const.gofContourInner
local CMTVisibilityMode_Auto = 0
local CMTVisibilityMode_AlwaysHide = 1
local CMTVisibilityMode_NeverHide = 2
local Defaults = {rayOffsetVerticalV2 = rayOffsetVerticalV2, rayOffsetHorizontalV2 = rayOffsetHorizontalV2}
AppendClass.MapDataPreset = {
  properties = {
    {
      category = "Camera",
      id = "ExtendBuildingTouchRange",
      name = "Extend Building Touch Range",
      editor = "bool",
      default = false,
      help = "Buildings will hide from further away on this map."
    }
  }
}
local SetBuildingTouchRange = function(t)
  if t == "default" then
    rayOffsetVerticalV2 = Defaults.rayOffsetVerticalV2
    rayOffsetHorizontalV2 = Defaults.rayOffsetHorizontalV2
  else
    if t == "extended" then
      rayOffsetVerticalV2 = Defaults.rayOffsetVerticalV2 * 3
      rayOffsetHorizontalV2 = Defaults.rayOffsetHorizontalV2 * 3
    else
    end
  end
end
local VisibilityMode_LuaToC = function(mode)
  if mode == true then
    return CMTVisibilityMode_NeverHide
  elseif mode == false then
    return CMTVisibilityMode_AlwaysHide
  else
    return CMTVisibilityMode_Auto
  end
end
if FirstLoad then
  WallInvisibilityThread = false
  WallInvisibilityEnabled = true
  const.CMT_TreeTopVisibilityMode = VisibilityMode_LuaToC("auto")
  const.CMT_CanopyTopVisibilityMode = VisibilityMode_LuaToC("auto")
  WallVisibilityMode = "auto"
  WallInvisibilityDebug = false
  RoofWallBoxDebug = false
  VT2TouchedBuildings = false
  VT2CollapsedWalls = false
  roomsRoofsToShow = false
  AllowPartialWallsCollapse = true
  g_DbgCRObjs = false
  g_DbgCRObjsToKill = false
  DbgCombatWallHiding = false
  g_WITPauseReasons = {}
end
function DbgCRReallyClear()
  DoneObjects(g_DbgCRObjsToKill)
  g_DbgCRObjsToKill = false
end
function DbgCRClear()
  if not g_DbgCRObjs then
    return
  end
  DelayedCall(25, DbgCRReallyClear)
  g_DbgCRObjsToKill = g_DbgCRObjsToKill or {}
  table.iappend(g_DbgCRObjsToKill, g_DbgCRObjs)
  g_DbgCRObjs = false
end
function DbgCRAddVector(origin, dir, color)
  dir = dir or axis_z * 3
  g_DbgCRObjs = g_DbgCRObjs or {}
  table.insert(g_DbgCRObjs, ShowVector(dir, origin, color))
end
function DbgCRAddBox(b, color)
  g_DbgCRObjs = g_DbgCRObjs or {}
  table.insert(g_DbgCRObjs, PlaceBox(b, color))
end
local dbgTxtObj = false
function CheatToggleWallInvisibilityDebug()
  DbgCRClear()
  WallInvisibilityDebug = not WallInvisibilityDebug
  if not WallInvisibilityDebug and IsValid(dbgTxtObj) then
    DoneObject(dbgTxtObj)
    dbgTxtObj = false
  end
end
function CheatToggleWallInvisibilityOutsideOfCombat()
  DbgCombatWallHiding = not DbgCombatWallHiding
end
local rebuildingVolumeBuildings = false
function OnMsg.BuildBuildingsData(VolumeBuildings)
  rebuildingVolumeBuildings = true
  if WallInvisibilityEnabled and ShouldStartWallInvisibilityThread() and CurrentThread() ~= WallInvisibilityThread then
    StopWallInvisibilityThread()
  end
end
function OnMsg.VolumeBuildingsRebuilt(VolumeBuildings, oldVolumeBuildings)
  rebuildingVolumeBuildings = false
  if WallInvisibilityEnabled and ShouldStartWallInvisibilityThread() and not IsEditorActive() and CurrentThread() ~= WallInvisibilityThread then
    StartWallInvisibilityThread()
  end
end
function ShouldStartWallInvisibilityThread()
  return (const.SlabSizeX or 0) ~= 0 and GetMapName() ~= ""
end
function StartWallInvisibilityThread(reason)
  g_WITPauseReasons[reason or false] = nil
  if next(g_WITPauseReasons) then
    return
  end
  if IsValidThread(WallInvisibilityThread) then
    return
  end
  WallInvisibilityThread = CreateRealTimeThread(WallInvisibilityThreadMethod)
end
function StopAllHiding(reason, delay, time)
  StopWallInvisibilityThread(reason)
  CMT_SetPause(true, reason)
  C_CCMT_ShowAllAndReset(delay, time)
end
function ResumeAllHiding(reason)
  CMT_SetPause(false, reason)
  StartWallInvisibilityThreadWithChecks(reason)
end
function StopWallInvisibilityThread(reason)
  g_WITPauseReasons[reason or false] = true
  if VT2TouchedBuildings then
    for bld, floor in pairs(VT2TouchedBuildings) do
      local meta = VolumeBuildingsMeta[bld]
      local to = meta.maxFloor
      for f = floor, to do
        ShowRoomsOnFloor(bld, f)
      end
    end
    VT2CollapsedWalls = false
    VT2TouchedBuildings = false
    CollectionsToHideProcessDelayedHides()
    CollectionsToHideProcessDelayedShows()
  end
  if IsValidThread(WallInvisibilityThread) then
    DeleteThread(WallInvisibilityThread)
    WallInvisibilityThread = false
  end
end
function ResetWallInvisibilityThread()
  ToggleWallInvisibilityEnabled()
  ToggleWallInvisibilityEnabled()
end
function ToggleWallInvisibilityEnabled()
  if WallInvisibilityEnabled then
    WallInvisibilityEnabled = false
    StopWallInvisibilityThread()
  else
    WallInvisibilityEnabled = true
    StartWallInvisibilityThread()
  end
end
function OnMsg.ChangeMap()
  StopWallInvisibilityThread()
end
function OnMsg.SetObjectDetail(stage, params)
  if stage == "init" then
    params.wall_thread = not not WallInvisibilityThread
    if params.wall_thread then
      StopWallInvisibilityThread()
    end
  elseif stage == "done" and params.wall_thread then
    StartWallInvisibilityThread()
  end
end
function StartWallInvisibilityThreadWithChecks(reason)
  if WallInvisibilityEnabled and ShouldStartWallInvisibilityThread() then
    StartWallInvisibilityThread(reason)
  end
end
function OnMsg.NewMapLoaded()
  StartWallInvisibilityThreadWithChecks()
end
function OnMsg.GameEnteringEditor()
  StopWallInvisibilityThread()
end
function OnMsg.GameExitEditor()
  if WallInvisibilityEnabled and ShouldStartWallInvisibilityThread() and not rebuildingVolumeBuildings then
    StartWallInvisibilityThread()
  end
end
function GetUnitFloor(unitPos)
  local tile, z = WalkableSlabByPoint(unitPos)
  return IsKindOf(tile, "Slab") and tile.room and tile.floor or WallInvisibilityGetCamFloor(unitPos, z)
end
function C_GetSlabFloor(slab)
  return IsKindOf(slab, "Slab") and slab.room and slab.floor or WallInvisibilityGetCamFloor(slab:GetPos(), slab:GetPos():z())
end
function WallInvisibilityGetCamFloor(pos, terrainZ)
  terrainZ = terrainZ or terrain.GetHeight(pos)
  return ((pos:z() or terrainZ) - terrainZ) / hr.CameraTacFloorHeight + 1
end
function WallInvisibilityGetCamFloorRounded(pos)
  local terrainZ = terrain.GetHeight(pos)
  return ((pos:z() or terrainZ) - terrainZ + hr.CameraTacFloorHeight / 2) / hr.CameraTacFloorHeight + 1
end
function GetFloorOfPos(pos)
  if not pos then
    return
  end
  local z
  if pos:IsValidZ() then
    local tile
    tile, z = WalkableSlabByPoint(pos, true)
    if IsKindOf(tile, "RoofPlaneSlab") and tile.floor then
      local room = tile.room
      if room and room.ignore_zulu_invisible_wall_logic then
        return tile.floor - 1
      end
      return tile.floor
    end
    if IsKindOf(tile, "Slab") and tile.floor then
      if tile.room then
        return Max(0, tile.floor - 1)
      end
      local terrainZ = terrain.GetHeight(pos)
      if abs(terrainZ - z) > guim then
        return Max(0, tile.floor)
      end
      return 0
    end
    local stairs = MapGetFirst(pos, 1, "StairSlab")
    if stairs then
      return Max(0, stairs.floor - 1)
    end
    z = nil
  else
    pos = pos:SetTerrainZ()
  end
  return Max(0, WallInvisibilityGetCamFloor(pos, z) - 1)
end
DefineClass.HideTop = {
  __parents = {"CObject"},
  Top = false
}
function HideTop:SetShadowOnly(bSet)
  if self:GetGameFlags(const.gofOnRoof) ~= 0 then
    CObject.SetShadowOnly(self, bSet)
  else
    local top = self.Top
    if top then
      top:SetShadowOnly(bSet)
    end
  end
end
function HideTop:GetTopHeight()
  local x, y, z = self:GetPosXYZ()
  z = z or terrain.GetHeight(self)
  return z + self.Top:GetEntityBBox():maxz()
end
local const_gofOnRoof = const.gofOnRoof
function HideTop:TopHidingCondition(camera_pos, lookAt, hiding_pt)
  if not self.Top then
    return
  end
  if not camera_pos then
    camera_pos, lookAt = cameraTac.GetZoomedPosLookAt()
    hiding_pt = camera_pos + (lookAt - camera_pos) / 2
  end
  return self:GetDist2D(hiding_pt) < self.hide_radius and camera_pos:z() - self:GetTopHeight() < self.hide_height
end
function HideTop:HandleCMTTrigger(camera_pos, lookAt, hiding_pt)
  self:SetShadowOnly(self:TopHidingCondition(camera_pos, lookAt, hiding_pt))
end
DefineClass.HideTopTree = {
  __parents = {"HideTop", "TreeTop"},
  hide_height = const.CMT_HideTreesCameraZDiff,
  hide_radius = const.CMT_HideTreeTopsCameraLookAt2DRadius
}
function HideTopTree:TopHidingCondition(...)
  if const.CMT_TreeTopVisibilityMode == CMTVisibilityMode_NeverHide then
    return false
  end
  if const.CMT_TreeTopVisibilityMode == CMTVisibilityMode_AlwaysHide then
    return true
  end
  return HideTop.TopHidingCondition(self, ...)
end
DefineClass.HideTopCanopy = {
  __parents = {"HideTop"},
  hide_height = const.CMT_HideCanopiesCameraZDiff,
  hide_radius = const.CMT_HideCanopyTopsCameraLookAt2DRadius
}
function HideTopCanopy:TopHidingCondition(camera_pos, lookAt, hiding_pt)
  if not self.Top then
    return
  end
  if not camera_pos then
    camera_pos, lookAt = cameraTac.GetZoomedPosLookAt()
    hiding_pt = camera_pos + (lookAt - camera_pos) / 2
  end
  if const.CMT_CanopyTopVisibilityMode == CMTVisibilityMode_NeverHide then
    return false
  end
  if const.CMT_CanopyTopVisibilityMode == CMTVisibilityMode_AlwaysHide then
    return true
  end
  if SelectedObj then
    local selo_pos = ValidateZ(SelectedObj:GetPos())
    local canopy_pos = self:GetPos():SetZ(self:GetTopHeight())
    local dist = DistSegmentToPt(selo_pos, camera_pos, canopy_pos)
    if dist < const.CMT_CanopyCamFocusObjDist and dist <= (selo_pos - canopy_pos):Len() then
      return true
    end
  end
  return HideTop.TopHidingCondition(self, camera_pos, lookAt, hiding_pt)
end
function ShowAllHideFromCameraCollections(mode)
  const.CMT_CollectionVisibilityMode = VisibilityMode_LuaToC(mode)
end
function ShowAllTreeTops(mode)
  const.CMT_TreeTopVisibilityMode = VisibilityMode_LuaToC(mode)
end
function ShowAllCanopyTops(mode)
  const.CMT_CanopyTopVisibilityMode = VisibilityMode_LuaToC(mode)
end
function table.kv_clear(t, ...)
  local count = select("#", ...)
  for i = count, 1, -1 do
    local idxed = false
    for j = 1, i - 1 do
      idxed = (idxed or t)[select(j, ...)]
    end
    if i == 1 then
      idxed = t
    end
    if not idxed then
      return
    end
    local k = select(i, ...)
    if i == count then
      idxed[k] = nil
    elseif not next(idxed[k]) then
      idxed[k] = nil
    end
  end
end
local RefreshCombatPath = function()
  if not SelectedObj then
    return
  end
  local d = GetDialog("IModeCombatMovement")
  if d then
    d:OnMousePos(terminal.GetMousePos())
  end
end
local ShouldProcessRoom = function(room)
  if room.being_placed or room.ignore_zulu_invisible_wall_logic or room.outside_border then
    return false
  end
  return true
end
local cornerSideToWallSides = {
  East = {"East", "North"},
  South = {"East", "South"},
  West = {"West", "South"},
  North = {"West", "North"}
}
local visibleWallTest = function(o)
  return o.isVisible or o.wall_obj
end
local ProcessCorners = function(corners, hide, shouldProcess, clear_countour, ...)
  local last
  clear_countour = hide and clear_countour
  local edit = IsEditorActive()
  for i = 1, #corners do
    local c = corners[i]
    if IsValid(c) then
      c = not c.isVisible and MapGetFirst(c, 0, "RoomCorner", function(o, c)
        return o.isPlug == c.isPlug and o.isVisible
      end, c) or c
      if c and c.isVisible then
        local process = not shouldProcess or shouldProcess(c, ...)
        if process == "break" then
          return
        elseif process then
          if c.isPlug and last then
            local lv = CMT_IsObjVisible(last)
            c:SetShadowOnly(not lv)
            if clear_countour then
              c:ClearHierarchyGameFlags(gofContourInner)
            end
          elseif c.isPlug then
            c:SetShadowOnly(hide)
            if clear_countour then
              c:ClearHierarchyGameFlags(gofContourInner)
            end
          else
            local x, y, z = c:GetPosXYZ()
            local a = c:GetAngle() / 60
            local w1, w2
            if not edit then
              w1 = rawget(c, "nbr1")
              w2 = rawget(c, "nbr2")
            else
              rawset(c, "nbr1", nil)
              rawset(c, "nbr2", nil)
            end
            if w1 == nil then
              if a == 0 then
                w1 = MapGetFirst(x, y - halfVoxelSizeY, z, 0, "WallSlab", visibleWallTest)
                w2 = MapGetFirst(x - halfVoxelSizeX, y, z, 0, "WallSlab", visibleWallTest)
              elseif a == 90 then
                w1 = MapGetFirst(x, y - halfVoxelSizeY, z, 0, "WallSlab", visibleWallTest)
                w2 = MapGetFirst(x + halfVoxelSizeX, y, z, 0, "WallSlab", visibleWallTest)
              elseif a == 180 then
                w1 = MapGetFirst(x, y + halfVoxelSizeY, z, 0, "WallSlab", visibleWallTest)
                w2 = MapGetFirst(x + halfVoxelSizeX, y, z, 0, "WallSlab", visibleWallTest)
              elseif a == 270 then
                w1 = MapGetFirst(x, y + halfVoxelSizeY, z, 0, "WallSlab", visibleWallTest)
                w2 = MapGetFirst(x - halfVoxelSizeX, y, z, 0, "WallSlab", visibleWallTest)
              end
              if w1 and (not w1.isVisible or not w1) then
                w1 = w1.wall_obj
              end
              if w2 and (not w2.isVisible or not w2) then
                w2 = w2.wall_obj
              end
              if not edit then
                rawset(c, "nbr1", w1)
                rawset(c, "nbr2", w2)
              end
            end
            if w1 and w2 then
              local w1v = CMT_IsObjVisible(w1)
              local w2v = CMT_IsObjVisible(w2)
              if hide and (not w1v or not w2v) then
                c:SetShadowOnly(hide)
                if clear_countour then
                  c:ClearHierarchyGameFlags(gofContourInner)
                end
              elseif not hide and w1v and w2v then
                c:SetShadowOnly(hide)
              end
            end
          end
        end
        last = c
      end
    end
  end
end
local ShouldHideObj = C_ShouldHideObj
local isInBoxesHelper = function(boxes, obj)
  local inBoxes = true
  if boxes then
    inBoxes = false
    local x, y, z = obj:GetPosXYZ()
    for j = 1, #(boxes or "") do
      local b = boxes[j]
      local process = false
      if b:sizex() > 0 then
        process = x >= b:minx() and x <= b:maxx()
      elseif 0 < b:sizey() then
        process = y >= b:miny() and y <= b:maxy()
      else
        print("Zero sized box in partial wall hiding!")
      end
      if process then
        inBoxes = true
        break
      end
    end
  end
  return inBoxes
end
local bases = {
  NorthBase = "North",
  SouthBase = "South",
  EastBase = "East",
  WestBase = "West"
}
local HideShowDoorsAndWindows = function(hide, room, side, check_prop, boxes, clear_countour)
  local doors = room.spawned_doors and room.spawned_doors[side]
  for i = 1, #(doors or empty_table) do
    local door = doors[i]
    if (check_prop == nil or true or door.hide_with_wall == check_prop) and isInBoxesHelper(boxes, door) then
      door:SetShadowOnly(hide)
      if hide and clear_countour then
        door:ClearHierarchyGameFlags(gofContourInner)
      end
    end
  end
  local windows = room.spawned_windows and room.spawned_windows[side]
  for i = 1, #(windows or empty_table) do
    local window = windows[i]
    if (check_prop == nil or true or window.hide_with_wall == check_prop) and isInBoxesHelper(boxes, window) and not IsKindOf(window.main_wall, "RoofWallSlab") then
      window:SetShadowOnly(hide)
      if hide and clear_countour then
        window:ClearHierarchyGameFlags(gofContourInner)
      end
    end
  end
end
function HideBaseWall(room, side, clear_countour, batch)
  local wall = room.spawned_walls and room.spawned_walls[side]
  local height = room.size:z()
  if 0 < height then
    local count = #(wall or empty_table)
    local cols = count / height
    for c = 0, cols - 1 do
      local idx = c * height + 1
      local slab = wall[idx]
      if IsValid(slab) then
        if slab.isVisible then
          slab:SetShadowOnly(true)
          if clear_countour then
            slab:ClearHierarchyGameFlags(gofContourInner)
          end
        else
          slab:SetWallObjShadowOnly(true, clear_countour)
        end
      end
    end
  end
  if height <= 1 and room:HasWallOnSide(side) then
    CollectionsToHideHideCollections(room, side)
  end
  HideShowDoorsAndWindows("hide", room, side, nil, nil, clear_countour)
  if not batch then
    ShowHideCorners(true, room, side, true, clear_countour)
  end
end
function ShowBaseWall(room, side, batch)
  local wall = room.spawned_walls and room.spawned_walls[side]
  local height = room.size:z()
  for i = 1, #(wall or empty_table) do
    if IsValid(wall[i]) and (i - 1) % height == 0 then
      if wall[i].isVisible then
        wall[i]:SetShadowOnly(false)
      else
        wall[i]:SetWallObjShadowOnly(false)
      end
    end
  end
  if height <= 1 and room:HasWallOnSide(side) then
    CollectionsToHideShowCollections(room, side)
  end
  HideShowDoorsAndWindows(false, room, side, false)
  if not batch then
    ShowHideCorners(false, room, side, true)
  end
end
function HideShowRoomObjects(room, bSetShadowFlag, inEditor, fnHide)
  local b = room.box
  local minz = b:minz() - guic * 10
  local maxz = b:maxz()
  local meta = VolumeBuildingsMeta[room.building]
  if meta and meta.maxFloor > room.floor then
    maxz = maxz - guic * 10
  end
  local SetVisibleHelper = fnHide and fnHide or not inEditor and function(o, bSetShadowFlag)
    o:SetShadowOnly(bSetShadowFlag)
  end or function(o, bSetShadowFlag)
    o:SetShadowOnlyImmediate(bSetShadowFlag)
  end
  C_HideShowObjects(b, minz, maxz, bSetShadowFlag, not not inEditor, SetVisibleHelper, function(cid)
    return IsCollectionLinkedToRooms(Collections[cid])
  end, function(o)
    return XEditorFilters:GetObjectMode(o) == "invisible"
  end)
end
local HideObjects = function(room)
  HideShowRoomObjects(room, true)
end
local ShowObjects = function(room)
  HideShowRoomObjects(room, false)
end
function ShowAllWalls(mode)
  WallVisibilityMode = mode
end
AppendClass.Slab = {
  __parents = {"CSlab"},
  properties = {
    category = "Slabs",
    {
      id = "hide_despite_material",
      name = "Hide Despite Material",
      editor = "bool",
      default = false,
      help = "You know how fat concrete walls don't hide? This overrides this behavior for this slab."
    }
  }
}
function HideWall(room, side, boxes, clear_countour, batch)
  if side == "Roof" then
    if RoofWallBoxDebug and room.roof_box then
      DbgAddBox(room.roof_box, RGB(255, 0, 0))
    end
    room:SetRoofVisibility(false)
    return
  end
  local base = bases[side]
  if base then
    HideBaseWall(room, base)
    return
  end
  if side == "Objects" then
    HideObjects(room)
    return
  end
  local isFloor = side == "Floor"
  local wall = (not isFloor or not room.spawned_floors) and room.spawned_walls and room.spawned_walls[side]
  local height = room.size:z()
  local shouldNotHide = not clear_countour and not isFloor and room:GetWallMatHelperSide(side) == "Concrete"
  if isFloor then
    for i = 1, #(wall or empty_table) do
      local slab = wall[i]
      if IsValid(slab) and slab.isVisible then
        slab:SetShadowOnly(true)
        if clear_countour then
          slab:ClearHierarchyGameFlags(gofContourInner)
        end
      end
    end
  elseif 0 < height and room:HasWallOnSide(side) then
    local count = #(wall or empty_table)
    local cols = count / height
    for c = 0, cols - 1 do
      for h = 2, height do
        local idx = c * height + h
        local slab = wall[idx]
        if IsValid(slab) then
          local inBoxes = isInBoxesHelper(boxes, slab)
          if inBoxes then
            if slab.isVisible then
              if not shouldNotHide or slab.variant == "IndoorIndoor" or slab.hide_despite_material then
                slab:SetShadowOnly(true)
                if clear_countour then
                  slab:ClearHierarchyGameFlags(gofContourInner)
                end
              end
            else
              slab:SetWallObjShadowOnly(true, clear_countour)
            end
          end
        end
      end
    end
  end
  if isFloor then
    return
  end
  if 1 < height and not boxes then
    CollectionsToHideHideCollections(room, side)
  end
  ShowHideCorners(true, room, side, false, clear_countour, batch)
end
function ShowWall(room, side, batch)
  if not IsValid(room) then
    return
  end
  if side == "Roof" then
    room:SetRoofVisibility(true)
    return
  end
  local base = bases[side]
  if base then
    ShowBaseWall(room, base)
    return
  end
  if side == "Objects" then
    ShowObjects(room)
    return
  end
  local isFloor = side == "Floor"
  local wall = (not isFloor or not room.spawned_floors) and room.spawned_walls and room.spawned_walls[side]
  local height = room.size:z()
  if isFloor or room:HasWallOnSide(side) then
    for i = 1, #(wall or empty_table) do
      local slab = wall[i]
      if IsValid(slab) then
        if slab.isVisible then
          slab:SetShadowOnly(false)
        elseif not isFloor and (i - 1) % height ~= 0 then
          slab:SetWallObjShadowOnly(false)
        end
      end
    end
  end
  if side == "Floor" then
    return
  end
  if 1 < height then
    CollectionsToHideShowCollections(room, side)
  end
  ShowHideCorners(false, room, side, false, nil, batch)
end
function ShowHideCorners(hide, room, side, baseOnly, clear_countour, batch)
  local sides = sideToCornerSides[side]
  local height = room.size:z()
  local rz = room:CalcZ()
  local filter
  if not batch then
    function filter(c, rz, baseOnly)
      if baseOnly then
        return rz >= c:GetPos():z() or "break"
      else
        return rz < c:GetPos():z()
      end
    end
  end
  for i = 1, #sides do
    local cs = sides[i]
    local show = false
    local adjWalls = cornerToWallSides[cs]
    local wallToCheck = adjWalls[1] == side and adjWalls[2] or adjWalls[1]
    show = room:GetWallMatHelperSide(wallToCheck) == noneWallMat
    if not show then
      local ws = cornerSideToWallSides[cs]
      show = not room.visible_walls or room.visible_walls[ws[1]] or room.visible_walls[ws[2]]
    end
    if show then
      local corners = room.spawned_corners and room.spawned_corners[cs]
      ProcessCorners(corners, hide, filter, clear_countour, rz, baseOnly)
    end
  end
  local mb = room.box
  local ars = room.adjacent_rooms_per_side and room.adjacent_rooms_per_side[side]
  local oside = GetOppositeSide(side)
  for i = 1, #(ars or "") do
    local ar = ars[i]
    sides = sideToCornerSides[oside]
    for i = 1, #sides do
      local cs = sides[i]
      local corners = ar.spawned_corners and ar.spawned_corners[cs]
      if corners and IsValid(corners[1]) and mb:Point2DInsideInclusive(corners[1]:GetPos()) then
        ProcessCorners(corners, hide, filter, clear_countour, rz, baseOnly)
      end
    end
  end
end
function IntersectSegmentWithBuildings(p1, p2, touchedBldsThisPass)
  if WallInvisibilityDebug then
    DbgCRAddVector(p1, p2 - p1)
  end
  ForEachVolumeOnSegment(p1, p2, function(room, box, p1, p2)
    if not ShouldProcessRoom(room) then
      return
    end
    local bld = room.building
    if bld then
      touchedBldsThisPass[bld] = true
    end
  end)
end
function IntersectBox2DWithBuildings(box, touchedBldsThisPass)
  if WallInvisibilityDebug then
    DbgCRAddBox(box)
  end
  EnumVolumes(box, function(room, roomPartsToHide)
    if not ShouldProcessRoom(room) then
      return
    end
    local bld = room.building
    if bld then
      touchedBldsThisPass[bld] = true
    end
  end, touchedBldsThisPass)
end
function IntersectTriangle2DWithBuildings(p1, p2, p3, touchedBldsThisPass)
  if WallInvisibilityDebug then
    p1 = p1:SetZ(terrain.GetHeight(p1) + 100)
    p2 = p2:SetZ(terrain.GetHeight(p2) + 100)
    p3 = p3:SetZ(terrain.GetHeight(p3) + 100)
    DbgCRAddVector(p1, p2 - p1)
    DbgCRAddVector(p2, p3 - p2)
    DbgCRAddVector(p1, p3 - p1)
  end
  EnumVolumes(p1, p2, p3, function(room, roomPartsToHide)
    if not ShouldProcessRoom(room) then
      return
    end
    local bld = room.building
    if bld then
      touchedBldsThisPass[bld] = true
    end
    if WallInvisibilityDebug then
      DbgCRAddVector(room:GetPos())
      DbgCRAddBox(room.box, RGB(255, 0, 0))
    end
  end, touchedBldsThisPass)
end
function ShowRoom(room)
  ShowWall(room, "Floor")
  ShowBaseWall(room, "North", "batch")
  ShowBaseWall(room, "South", "batch")
  ShowBaseWall(room, "West", "batch")
  ShowBaseWall(room, "East", "batch")
  ShowWall(room, "North", "batch")
  ShowWall(room, "West", "batch")
  ShowWall(room, "South", "batch")
  ShowWall(room, "East", "batch")
  ShowObjects(room)
  if WallInvisibilityThread == CurrentThread() then
    roomsRoofsToShow[room] = true
  else
    room:SetRoofVisibility(true)
  end
end
function HideRoom(room)
  HideWall(room, "Floor")
  HideBaseWall(room, "North", "clear_countour", "batch")
  HideBaseWall(room, "South", "clear_countour", "batch")
  HideBaseWall(room, "West", "clear_countour", "batch")
  HideBaseWall(room, "East", "clear_countour", "batch")
  HideWall(room, "North", nil, "clear_countour", "batch")
  HideWall(room, "West", nil, "clear_countour", "batch")
  HideWall(room, "South", nil, "clear_countour", "batch")
  HideWall(room, "East", nil, "clear_countour", "batch")
  HideObjects(room)
  room:SetRoofVisibility(false)
end
function HideRoomsOnFloor(bld, f)
  local floorT = bld[f]
  for i = 1, #(floorT or "") do
    local room = floorT[i]
    if ShouldProcessRoom(room) then
      HideRoom(room)
    end
  end
end
function ShowRoomsOnFloor(bld, f, roofs)
  local floorT = bld[f]
  for i = 1, #(floorT or "") do
    local room = floorT[i]
    if ShouldProcessRoom(room) then
      ShowRoom(room)
    end
  end
end
local checkWallRange = function(lookAt, r, side)
  if CollapseWallRange <= 0 then
    return true
  end
  local b = r:GetWallBox(side)
  local d2 = PointToBoxDist2D2(lookAt, b)
  return d2 <= CollapseWallRange * CollapseWallRange
end
local addWallsToCollapseHelper = function(collapsedWallsThisPass, r, vw, side, lookAt)
  if not checkWallRange(lookAt, r, side) then
    return
  end
  collapsedWallsThisPass[r][side] = "full"
  if AllowPartialWallsCollapse then
    local ars = r.adjacent_rooms
    local arps = r.adjacent_rooms_per_side and r.adjacent_rooms_per_side[side]
    local oside = GetOppositeSide(side)
    local oarps = r.adjacent_rooms_per_side and r.adjacent_rooms_per_side[oside] or empty_table
    for i = 1, #(arps or "") do
      local ar = arps[i]
      local arars = ar.adjacent_rooms_per_side[oside]
      if (not ar.visible_walls or ar.visible_walls[oside]) and not table.find(oarps, ar) and table.find(arars, r) and not ar.ignore_zulu_invisible_wall_logic then
        local data = r.adjacent_rooms[ar]
        local box = data[1]
        collapsedWallsThisPass[ar] = collapsedWallsThisPass[ar] or {}
        if collapsedWallsThisPass[ar][oside] ~= "full" then
          collapsedWallsThisPass[ar][oside] = collapsedWallsThisPass[ar][oside] or {}
          table.insert(collapsedWallsThisPass[ar][oside], box)
        end
      end
    end
  end
end
local HideAllHidesAllWalls = true
function WallInvisibilityThreadMethod_V2_PlanA()
  if IsRealTimeThread() and IsChangingMap() then
    WaitMsg("ChangeMapDone", 100000)
  end
  SetBuildingTouchRange(mapdata.ExtendBuildingTouchRange and "extended" or "default")
  BuildBuildingsData()
  VT2TouchedBuildings = {}
  VT2CollapsedWalls = {}
  roomsRoofsToShow = {}
  local up = point(0, 0, voxelSizeZ)
  local lastCamPos, lastLookAt, lastHideAll, lastIsInOverview, lastIsInCombat, lastFloor, lastVisibilityMode
  while true do
    WaitNextFrame()
    if WallInvisibilityThread ~= CurrentThread() then
      return
    end
    local camPos, lookAt = cameraTac.GetZoomedPosLookAt()
    local camFloor = cameraTac.GetFloor() + 1
    local camRoundedFloor = WallInvisibilityGetCamFloorRounded(lookAt)
    local hideAll = terminal.IsShortcutPressed("actionHideAll") or not WallVisibilityMode
    if hideAll then
      local focus = terminal.desktop.keyboard_focus
      if focus and IsKindOf(focus, "XEdit") then
        hideAll = false
      end
    end
    local showAll = type(WallVisibilityMode) == "boolean" and WallVisibilityMode == true
    local mapWideTouch = WallVisibilityMode == "mapwide" or WallVisibilityMode == "mapwide+walls"
    local isInOverview = cameraTac.GetIsInOverview() and not gv_DeploymentStarted
    local isInCombat = true
    if lastCamPos ~= camPos or lastLookAt ~= lookAt or hideAll ~= lastHideAll or lastIsInOverview ~= isInOverview or camFloor ~= lastFloor or lastIsInCombat ~= isInCombat or lastVisibilityMode ~= WallVisibilityMode then
      lastCamPos = camPos
      lastLookAt = lookAt
      lastHideAll = hideAll
      lastIsInOverview = isInOverview
      lastIsInCombat = isInCombat
      lastFloor = camFloor
      lastVisibilityMode = WallVisibilityMode
      local touchedBldsThisPass = {}
      local collapsedWallsThisPass = {}
      if WallInvisibilityDebug then
        DbgCRClear()
      end
      local dirV = lookAt - camPos
      dirV = dirV:SetZ(0)
      if dirV ~= point30 then
        if not showAll then
          if hideAll or mapWideTouch then
            for i = 1, #VolumeBuildings do
              touchedBldsThisPass[VolumeBuildings[i]] = true
            end
          else
            dirV = SetLen(dirV, rayOffsetVerticalV2 + ExtendVerticelPerFloor * Max(camRoundedFloor - 1, 0))
            local dirH = SetLen(Rotate(dirV, 5400), rayOffsetHorizontalV2)
            local center = lookAt + SetLen((camPos - lookAt):SetZ(0), voxelSizeX * 3 + halfVoxelSizeX)
            local topLeft = center + dirV + dirH + up
            local topRight = center + dirV - dirH + up
            IntersectTriangle2DWithBuildings(camPos, topRight, topLeft, touchedBldsThisPass)
          end
        end
        local camZ = lookAt:z()
        camZ = (camZ + voxelSizeZ - 1) / voxelSizeZ * voxelSizeZ
        for bld, _ in pairs(touchedBldsThisPass) do
          local meta = VolumeBuildingsMeta[bld]
          local from = meta.minFloor
          local to = meta.maxFloor
          local newFloor
          if hideAll then
            newFloor = from
            touchedBldsThisPass[bld] = from
          else
            local camFloorIsRoof = camFloor == to and meta.maxFloorIsRoof
            if meta[camFloor] and not camFloorIsRoof then
              newFloor = camFloor
              touchedBldsThisPass[bld] = camFloor
            end
          end
          if not newFloor then
            touchedBldsThisPass[bld] = nil
          else
            local oldFloor = VT2TouchedBuildings[bld]
            if not oldFloor then
              for f = to, touchedBldsThisPass[bld] + 1, -1 do
                HideRoomsOnFloor(bld, f)
              end
            elseif oldFloor ~= newFloor then
              if newFloor < oldFloor then
                for f = oldFloor, newFloor + 1, -1 do
                  HideRoomsOnFloor(bld, f)
                end
              else
                for f = oldFloor, newFloor do
                  ShowRoomsOnFloor(bld, f)
                end
              end
            end
            local floorT = bld[newFloor] or {}
            for i = 1, #floorT do
              local r = floorT[i]
              if ShouldProcessRoom(r) then
                roomsRoofsToShow[r] = nil
                if r:IsRoofOnly() then
                  HideRoom(r)
                else
                  collapsedWallsThisPass[r] = collapsedWallsThisPass[r] or {}
                  collapsedWallsThisPass[r].Roof = true
                  if hideAll and HideAllHidesAllWalls or WallVisibilityMode == "mapwide+walls" then
                    collapsedWallsThisPass[r].West = "full"
                    collapsedWallsThisPass[r].East = "full"
                    collapsedWallsThisPass[r].North = "full"
                    collapsedWallsThisPass[r].South = "full"
                  elseif not (not isInCombat or isInOverview) or hideAll then
                    local vw = r.visible_walls
                    if not vw or not (0 >= vw.total) then
                      local s = r.size
                      if not (1 >= s:z()) then
                        local p = r.position
                        collapsedWallsThisPass[r] = collapsedWallsThisPass[r] or {}
                        if camPos:x() < p:x() then
                          addWallsToCollapseHelper(collapsedWallsThisPass, r, vw, "West", lookAt)
                        end
                        if camPos:y() < p:y() then
                          addWallsToCollapseHelper(collapsedWallsThisPass, r, vw, "North", lookAt)
                        end
                        if camPos:y() > p:y() + s:y() * voxelSizeY then
                          addWallsToCollapseHelper(collapsedWallsThisPass, r, vw, "South", lookAt)
                        end
                        if camPos:x() > p:x() + s:x() * voxelSizeX then
                          addWallsToCollapseHelper(collapsedWallsThisPass, r, vw, "East", lookAt)
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
        if WallInvisibilityDebug then
          if not IsValid(dbgTxtObj) then
            dbgTxtObj = PlaceObject("Text")
            dbgTxtObj:SetTextStyle("BugReportScreenshot")
            dbgTxtObj:SetColor(RGB(0, 255, 0))
          end
          dbgTxtObj:SetPos(lookAt:AddZ(guim * 5))
          local str = string.format("Cam z is at %d;\n", camZ)
          local c = 0
          for bld, f in pairs(touchedBldsThisPass) do
            local meta = VolumeBuildingsMeta[bld]
            local b = meta[f].box
            DbgCRAddBox(b:grow(100, 100, 0), RGB(0, 255, 0))
            c = c + 1
            str = string.format("%sFloor box hit with minz %d and maxz %d and first room %s\n", str, b:minz(), b:maxz(), bld[f][1].name)
          end
          str = string.format("%s%d building floors were hit;\n", str, c)
          str = string.format([[
%s
Legend:
Green boxes - building floor bounding boxes hit;
Red boxes with line in the middle - rooms touched by the collision body;
Yellow boxes - objects within room volumes that have triggered their whole collection to hide;]], str)
          dbgTxtObj:SetText(str)
          for o, _ in pairs(dbgVolumeTriggerObjects or empty_table) do
            DbgCRAddBox(o:GetObjectBBox():grow(100, 100, 0), RGB(255, 255, 0))
          end
        end
        for bld, floor in pairs(VT2TouchedBuildings) do
          if not touchedBldsThisPass[bld] then
            local meta = VolumeBuildingsMeta[bld]
            local from = meta.minFloor
            local to = meta.maxFloor
            for f = floor, to do
              ShowRoomsOnFloor(bld, f)
            end
          end
        end
        local wallsToShow = {}
        local wallsToHide = {}
        local partialBoxes = {}
        for r, new in pairs(collapsedWallsThisPass) do
          local old = VT2CollapsedWalls[r]
          local bld = r.building
          local visibleFloor = touchedBldsThisPass[bld]
          if not visibleFloor or visibleFloor >= r.floor then
            for side, old_data in pairs(old or empty_table) do
              local new_data = new[side]
              if not new_data or old_data == "full" and new_data ~= "full" then
                wallsToShow[r] = wallsToShow[r] or {}
                table.insert_unique(wallsToShow[r], side)
              end
            end
          end
          for side, new_data in pairs(new or empty_table) do
            local old_data = old and old[side]
            if not (old and old_data) or old_data ~= new_data and (type(old_data) ~= type(old_data) or type(old_data) ~= "table" or not table.iequal(old_data, new_data)) then
              wallsToHide[r] = wallsToHide[r] or {}
              table.insert_unique(wallsToHide[r], side)
              if type(new_data) == "table" then
                partialBoxes[r] = partialBoxes[r] or {}
                partialBoxes[r][side] = new_data
              end
            end
          end
        end
        for r, old in pairs(VT2CollapsedWalls) do
          local new = collapsedWallsThisPass[r]
          if not new then
            local bld = r.building
            local f = touchedBldsThisPass[bld]
            if not f or f > r.floor then
              for side, old_data in pairs(old or empty_table) do
                wallsToShow[r] = wallsToShow[r] or {}
                table.insert_unique(wallsToShow[r], side)
              end
            end
          end
        end
        for r, t in pairs(wallsToShow) do
          for i = 1, #t do
            ShowWall(r, t[i])
          end
        end
        for r, t in pairs(wallsToHide) do
          for i = 1, #t do
            HideWall(r, t[i], partialBoxes[r] and partialBoxes[r][t[i]])
          end
        end
        for r, _ in pairs(roomsRoofsToShow) do
          r:SetRoofVisibility(true)
          roomsRoofsToShow[r] = nil
        end
        local dbgLastTouchedBldsState = touchedBldsThisPass
        local dbgLastColapseWallsState = collapsedWallsThisPass
        VT2TouchedBuildings = touchedBldsThisPass
        VT2CollapsedWalls = collapsedWallsThisPass
        if next(wallsToShow) ~= nil or next(wallsToHide) ~= nil or next(roomsRoofsToShow) ~= nil then
          Msg("WallVisibilityChanged")
        end
        CollectionsToHideProcessDelayedHides()
        CollectionsToHideProcessDelayedShows()
      end
    end
  end
end
function PointToBoxDist2D2(p, b)
  local bx, by, _ = b:Center():xyz()
  local x, y, _ = p:xyz()
  local dx = Max(abs(x - bx) - b:sizex() / 2, 0)
  local dy = Max(abs(y - by) - b:sizey() / 2, 0)
  return dx * dx + dy * dy
end
DefineClass.NonWallHidable = {}
WallInvisibilityThreadMethod = WallInvisibilityThreadMethod_V2_PlanA
if Platform.developer then
  function VolumesAboveMaxFloorVME(skip_rebuild)
    if not VolumeBuildings then
      return
    end
    if not skip_rebuild then
      BuildingsPostProcess()
    end
    for bld, meta in pairs(VolumeBuildingsMeta) do
      if meta.maxFloor > hr.CameraTacMaxFloor + 1 then
        for floor, volumes in pairs(bld) do
          for i = 1, #volumes do
            local room = volumes[i]
            if IsValid(room) and room.floor == meta.maxFloor then
              StoreErrorSource(room, "Room floor is above maximum camera floor (" .. tostring(room.floor) .. ">" .. tostring(hr.CameraTacMaxFloor) .. ")")
              break
            end
          end
        end
      end
    end
  end
  OnMsg.PostSaveMap = VolumesAboveMaxFloorVME
  OnMsg.NewMapLoadedCameraSettingsSet = VolumesAboveMaxFloorVME
  function OnMsg.VolumeBuildingsRebuilt()
    VolumesAboveMaxFloorVME(true)
  end
end
function OnMsg.CameraTacOverview(set)
  if set then
    ShowAllWalls("mapwide")
  else
    ShowAllWalls("auto")
  end
end
