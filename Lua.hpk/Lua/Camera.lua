MapVar("g_SnapCameraEnabled", true)
local lCameraCollisionMask = const.cmCameraMask | const.cmTerrain
local lCameraCollisionQueryFlags = const.cqfSingleResult | const.cqfSorted
function GetCameraSnapToObjectParams(pos, floor)
  local ptCamera, ptCameraLookAt = cameraTac.GetPosLookAtEnd()
  if not pos then
    return ptCamera, ptCameraLookAt
  end
  pos = not pos:IsValidZ() and pos:SetTerrainZ() or pos
  ptLastCameraPos, ptLastCameraLookAt = ptCamera, ptCameraLookAt
  local cameraVector = ptCameraLookAt - ptCamera
  ptCamera = pos - cameraVector
  ptCameraLookAt = pos
  local first = true
  collision.Collide(ptCamera, ptCameraLookAt - ptCamera, lCameraCollisionQueryFlags, 0, lCameraCollisionMask, function(o, _, hitX, hitY, hitZ)
    if not first then
      return
    end
    first = false
    ptCameraLookAt = point(hitX, hitY, hitZ)
    ptCamera = ptCameraLookAt - cameraVector
  end)
  return ptCamera, ptCameraLookAt, floor or GetFloorOfPos(pos)
end
function GetCameraPosLookAtOnPos(pos)
  local ptCamera, ptCameraLookAt = cameraTac.GetZoomedPosLookAtEnd()
  if not pos then
    return ptCamera, ptCameraLookAt
  end
  pos = not pos:IsValidZ() and pos:SetTerrainZ() or pos
  local cameraVector = ptCameraLookAt - ptCamera
  ptCamera = pos - cameraVector
  ptCameraLookAt = pos
  local first = true
  collision.Collide(ptCamera, ptCameraLookAt - ptCamera, lCameraCollisionQueryFlags, 0, lCameraCollisionMask, function(o, _, hitX, hitY, hitZ)
    if not first then
      return
    end
    first = false
    ptCameraLookAt = point(hitX, hitY, hitZ)
    ptCamera = ptCameraLookAt - cameraVector
  end)
  return ptCamera, ptCameraLookAt
end
function SnapCameraToObj(obj, force, floor, time, easingType)
  if not g_SnapCameraEnabled then
    return
  end
  if not cameraTac.IsActive() then
    return
  end
  if force == "player-input" then
    force = false
    if cameraTac.IsInputMovingCamera() then
      return
    end
  end
  local pos = IsValid(obj) and obj:GetPos() or obj
  if IsPoint(pos) and (not (IsCameraLocked() or gv_Deployment) or force) then
    local ptCamera, ptCameraLookAt, floor = GetCameraSnapToObjectParams(pos, floor)
    local easing
    if easingType and easingType ~= "none" then
      easing = GetEasingIndex(easingType)
    else
      easing = hr.CameraTacPosEasing
    end
    cameraTac.SetPosLookAtAndFloor(ptCamera, ptCameraLookAt, floor, time or 1000, easing)
    return time or 500, ptCamera, ptCameraLookAt
  end
  return 0
end
function SnapCameraToObjFloor(obj, force)
  if not g_SnapCameraEnabled or cameraTac.GetIsInOverview() then
    return
  end
  if not cameraTac.IsActive() then
    return
  end
  if IsValid(obj) and (not IsCameraLocked() or force) then
    local floor = GetFloorOfPos(obj:GetPos())
    cameraTac.SetFloor(floor, hr.CameraTacInterpolatedMovementTime * 10, hr.CameraTacInterpolatedVerticalMovementTime * 10)
  end
end
function _ENV:DoesTargetFitOnScreen(target)
  if GetUIStyleGamepad() then
    return false
  end
  local paddingX, paddingY = const.Camera.CrosshairPaddingX, const.Camera.CrosshairPaddingY
  local _, sx, sy = GameToScreenXY(target)
  local crosshair_dimX, crosshair_dimY = ScaleXY(self.scale, paddingX, paddingY)
  if sx - crosshair_dimX / 2 < 0 or sy - crosshair_dimY / 2 < 0 then
    return false
  end
  local screen_size = UIL.GetScreenSize()
  if sx + crosshair_dimX / 2 >= screen_size:x() or sy + crosshair_dimY / 2 >= screen_size:y() then
    return false
  end
  return true
end
function CameraPositionFromUnitOrientation(unit, time)
  local ptCamera, ptCameraLookAt = GetCamera()
  local cameraVector = ptCameraLookAt - ptCamera
  if unit.entrance_marker then
    local pos = unit.entrance_marker:GetPos()
    if not pos:IsValidZ() then
      pos = pos:SetTerrainZ()
    end
    local axis, marker_orient = unit.entrance_marker:GetOrientation()
    local cam_orient = CalcOrientation(ptCamera, ptCameraLookAt)
    local cameraVector = RotateAxis(cameraVector, axis, marker_orient - cam_orient)
    ptCamera = pos - cameraVector
    ptCameraLookAt = pos
    cameraTac.SetPosLookAtAndFloor(ptCamera, ptCameraLookAt, GetFloorOfPos(pos), time or 1)
  elseif time then
    local ptCamera, ptCameraLookAt = GetCamera()
    if not ptCamera then
      return
    end
    local pos = unit:GetPos()
    if not pos:IsValidZ() then
      pos = pos:SetTerrainZ()
    end
    ptCamera = pos - cameraVector
    ptCameraLookAt = pos
    cameraTac.SetPosLookAtAndFloor(ptCamera, ptCameraLookAt, GetFloorOfPos(ptCameraLookAt), time or 1)
  else
    ViewPos(unit:GetPos())
    cameraTac.Rotate(-mapdata.MapOrientation * 60)
  end
end
local max_trans_len = 15 * guim
function HandleCameraTargetFixed(src, tar)
  if not cameraTac.GetForceMaxZoom() or src == tar then
    return
  end
  local t_pos = IsPoint(tar) and tar or tar:GetPos()
  t_pos = not t_pos:IsValidZ() and t_pos:SetTerrainZ() or t_pos
  local front, t_pos_sc = GameToScreen(t_pos)
  local shrink = 300
  local box = g_DesktopBox:grow(shrink, shrink, -shrink, -shrink)
  if t_pos_sc:InBox(box) then
    return
  end
  local ptCamera, ptCameraLookAt = GetCamera()
  local s_pos = src:GetPos()
  local trans_vector_tar = t_pos:SetZ(0) - s_pos:SetZ(0)
  local len = s_pos:Dist2D(t_pos) / 2
  len = len > max_trans_len and max_trans_len or len
  trans_vector_tar = SetLen(trans_vector_tar, len)
  local trans_vector_src = s_pos:SetZ(0) - ptCameraLookAt:SetZ(0)
  local trans_vector = trans_vector_src + trans_vector_tar
  cameraTac.SetCamera(ptCamera + trans_vector, ptCameraLookAt + trans_vector, 500, "Sin out")
end
function ResetTacticalCamera()
  local mapOrient = (mapdata.MapOrientation - 90) * 60
  local ptCamera, ptCameraLookAt = GetCamera()
  local cameraVector = ptCameraLookAt - ptCamera
  local cam_orient = CalcOrientation(ptCamera, ptCameraLookAt)
  if SelectedObj then
    local pos = SelectedObj:GetPos():SetTerrainZ()
    local cameraVector = RotateAxis(cameraVector, axis_z, mapOrient - cam_orient)
    ptCamera = pos - cameraVector
    ptCameraLookAt = pos
    cameraTac.SetCamera(ptCamera, ptCameraLookAt)
  else
    cameraTac.Rotate(cam_orient - mapOrient)
  end
  cameraTac.SetFloor(0)
end
MapVar("floorFollowData", false)
local lClearFollowRecord = function()
  floorFollowData = false
end
OnMsg.ChangeMapDone = lClearFollowRecord
OnMsg.SelectedObjChange = lClearFollowRecord
OnMsg.TacCamFloorChanged = lClearFollowRecord
local lFloorFollowRecord = function(unit)
  if not table.find(Selection, unit) then
    return
  end
  local currentFloor = cameraTac.GetFloor()
  local movementStartFloor = GetFloorOfPos(unit:GetPos())
  if movementStartFloor ~= currentFloor then
    return
  end
  floorFollowData = {unit = unit}
end
OnMsg.UnitMovementStart = lFloorFollowRecord
OnMsg.UnitGoToStart = lFloorFollowRecord
local lFloorFollowCheckAndApply = function(unit)
  if not floorFollowData then
    return
  end
  if floorFollowData.unit ~= unit then
    return
  end
  SnapCameraToObjFloor(unit)
  lClearFollowRecord()
end
OnMsg.UnitMovementDone = lFloorFollowCheckAndApply
OnMsg.UnitGoTo = lFloorFollowCheckAndApply
function SetCameraFov(fovX)
  SetAutoFovX()
end
