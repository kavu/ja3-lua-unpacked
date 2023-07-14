function SetupInitialCamera(dont_move_camera)
  if IsMainMenuMap() then
    return
  end
  if IsGameReplayRunning() and cameraFly.IsActive() then
    return
  end
  if not cameraTac.IsActive() then
    cameraTac.Activate(1)
    if not dont_move_camera then
      local lookat = (point(terrain.GetMapSize()) / 2):SetTerrainZ()
      cameraTac.SetCamera(lookat + point(0, 1000, 1000), lookat)
    end
    cameraTac.Normalize()
    cameraTac.SetLookAtAngle(hr.CameraTacLookAtAngle)
    cameraTac.SetFloor(0)
    cameraTac.SetZoom(1000)
  end
end
function OnMsg.NewMap()
  if Platform.developer then
    SetupInitialCamera()
    terrain.UpdateTerrainDebugDraw()
  end
end
function OnMsg.GatherSessionData()
  gv_SaveCamera = CameraBeforeActionCamera or pack_params(GetCamera())
end
function OnMsg.LoadSessionData()
  if gv_SaveCamera then
    SetCamera(unpack_params(gv_SaveCamera))
    cameraTac.SetOverview(false, true)
  end
end
function OnMsg.DoneMap()
  camera.Unlock(1)
end
OnMsg.LoadGame = SetupInitialCamera
const.DefaultCameraRTS = {
  MinHeight = 2,
  MaxHeight = 20,
  HeightInertia = 4,
  MoveSpeedNormal = 3,
  MoveSpeedFast = 8,
  RotateSpeed = 6,
  LookatDist = 22,
  LowRotationRadius = 40,
  HighRotationRadius = 40,
  CameraYawRestore = 0,
  UpDownSpeed = 150,
  MinZoom = 200,
  MaxZoom = 1000,
  BBox = box(point30, point30),
  ScrollBorder = 20
}
hr.CameraRTSRelativeZoomingMode = 1
hr.CameraRTSZoomingScrollEasing = "SinOut"
hr.CameraRTSZoomingScrollStep = "0.0005"
hr.CameraTacLookAtAngle = 3300
hr.CameraTacHeight = 1100
CameraTacMoveSpeed = 2500
GamepadCameraTacMoveSpeed = 2000
hr.CameraTacMoveSpeed = CameraTacMoveSpeed
hr.CameraTacRotationSpeed = 400
hr.CameraTacMouseEdgeScrolling = true
hr.CameraTacMinFloor = 0
hr.CameraTacOverviewTime = 60
hr.CameraTacUseInterpolatedMovement = 3
hr.CameraTacInterpolatedMovementTime = 25
hr.CameraTacInterpolatedVerticalMovementTime = 50
hr.CameraTacZoomStep = 25
hr.CameraTacZoomStepGamepad = 200
hr.CameraTacZoomTime = 50
hr.CameraTacZoomOneStepPerBtnPress = false
hr.CameraTacMaxZoom = 130
hr.CameraTacMinZoom = 65
hr.CameraTacMaxZoomOverview = 220
hr.CameraTacScrollBorder = 5
if FirstLoad then
  hr.CameraTacFloorHeight = (const.SlabSizeZ or 0) * 4
  hr.CameraTacMaxFloor = 4
  hr.CameraTacZoomEasing = "Cubic out"
  hr.CameraTacPosEasing = "Circle out"
  hr.CameraTacPosVerticalEasing = "Cubic out"
  hr.CameraTacYawEasing = "Circle out"
  hr.CameraTacClampToTerrain = true
  hr.CameraTacUseVoxelBorder = true
  hr.CameraClampToTerrainOnSetPos = false
end
function OnMsg.ShortcutsReloaded()
  local pan_up = GetShortcuts("actionPanUp")
  hr.CameraRTSKeyPanUp = GetCameraVKCodeFromShortcut(pan_up and pan_up[1])
  hr.CameraRTSKeyPanUpAlt = GetCameraVKCodeFromShortcut(pan_up and pan_up[2])
  hr.CameraTacKeyPanUp = hr.CameraRTSKeyPanUp
  hr.CameraTacKeyPanUpAlt = hr.CameraRTSKeyPanUpAlt
  local pan_down = GetShortcuts("actionPanDown")
  hr.CameraRTSKeyPanDown = GetCameraVKCodeFromShortcut(pan_down and pan_down[1])
  hr.CameraRTSKeyPanDownAlt = GetCameraVKCodeFromShortcut(pan_down and pan_down[2])
  hr.CameraTacKeyPanDown = hr.CameraRTSKeyPanDown
  hr.CameraTacKeyPanDownAlt = hr.CameraRTSKeyPanDownAlt
  local pan_left = GetShortcuts("actionPanLeft")
  hr.CameraRTSKeyPanLeft = GetCameraVKCodeFromShortcut(pan_left and pan_left[1])
  hr.CameraRTSKeyPanLeftAlt = GetCameraVKCodeFromShortcut(pan_left and pan_left[2])
  hr.CameraTacKeyPanLeft = hr.CameraRTSKeyPanLeft
  hr.CameraTacKeyPanLeftAlt = hr.CameraRTSKeyPanLeftAlt
  local pan_right = GetShortcuts("actionPanRight")
  hr.CameraRTSKeyPanRight = GetCameraVKCodeFromShortcut(pan_right and pan_right[1])
  hr.CameraRTSKeyPanRightAlt = GetCameraVKCodeFromShortcut(pan_right and pan_right[2])
  hr.CameraTacKeyPanRight = hr.CameraRTSKeyPanRight
  hr.CameraTacKeyPanRightAlt = hr.CameraRTSKeyPanRightAlt
  local rot_left = GetShortcuts("actionRotLeft")
  hr.CameraRTSKeyRotateLeft = GetCameraVKCodeFromShortcut(rot_left and rot_left[1])
  hr.CameraRTSKeyRotateLeftAlt = GetCameraVKCodeFromShortcut(rot_left and rot_left[2])
  hr.CameraTacKeyRotateLeft = hr.CameraRTSKeyRotateLeft
  hr.CameraTacKeyRotateLeftAlt = hr.CameraRTSKeyRotateLeftAlt
  local rot_right = GetShortcuts("actionRotRight")
  hr.CameraRTSKeyRotateRight = GetCameraVKCodeFromShortcut(rot_right and rot_right[1])
  hr.CameraRTSKeyRotateRightAlt = GetCameraVKCodeFromShortcut(rot_right and rot_right[2])
  hr.CameraTacKeyRotateRight = hr.CameraRTSKeyRotateRight
  hr.CameraTacKeyRotateRightAlt = hr.CameraRTSKeyRotateRightAlt
  local zoom_in = GetShortcuts("actionZoomIn")
  hr.CameraRTSKeyZoomIn = GetCameraVKCodeFromShortcut(zoom_in and zoom_in[1])
  hr.CameraRTSKeyZoomInAlt = GetCameraVKCodeFromShortcut(zoom_in and zoom_in[2])
  hr.CameraTacKeyZoomIn = hr.CameraRTSKeyZoomIn
  hr.CameraTacKeyZoomInAlt = hr.CameraRTSKeyZoomInAlt
  local zoom_out = GetShortcuts("actionZoomOut")
  hr.CameraRTSKeyZoomOut = GetCameraVKCodeFromShortcut(zoom_out and zoom_out[1])
  hr.CameraRTSKeyZoomOutAlt = GetCameraVKCodeFromShortcut(zoom_out and zoom_out[2])
  hr.CameraTacKeyZoomOut = hr.CameraRTSKeyZoomOut
  hr.CameraTacKeyZoomOutAlt = hr.CameraRTSKeyZoomOutAlt
  local overview = GetShortcuts("actionCamOverview")
  hr.CameraTacKeyOverview = -1
  hr.CameraTacKeyOverviewAlt = -1
  local temp = GetShortcuts("actionCamFloorUp")
  hr.CameraTacFloorUp = GetCameraVKCodeFromShortcut(temp and temp[1])
  temp = GetShortcuts("actionCamFloorDown")
  hr.CameraTacFloorDown = GetCameraVKCodeFromShortcut(temp and temp[1])
  temp = GetShortcuts("actionCamRotateWithMouse")
  hr.CameraTacKeyRotateWithMouse = GetCameraVKCodeFromShortcut(temp and temp[1])
end
function SetupMapBorders()
  if not mapdata then
    return
  end
  local TacCameraBorderReduction = GetUIStyleGamepad() and 0 or 10
  if mapdata.CameraUseBorderArea then
    local marker = GetBorderAreaMarker()
    if not marker then
      return
    end
    hr.CameraTacVoxelBorderWidth = marker.AreaWidth - TacCameraBorderReduction
    hr.CameraTacVoxelBorderHeight = marker.AreaHeight - TacCameraBorderReduction
    local pos = marker:GetPos()
    hr.CameraTacVoxelBorderCenterX = pos:x()
    hr.CameraTacVoxelBorderCenterY = pos:y()
  elseif 0 < mapdata.CameraArea then
    hr.CameraTacVoxelBorderWidth = mapdata.CameraArea - TacCameraBorderReduction
    hr.CameraTacVoxelBorderHeight = mapdata.CameraArea - TacCameraBorderReduction
  end
  hr.CameraTacFloorHeight = mapdata.CameraFloorHeight * const.SlabSizeZ
  hr.CameraTacMaxFloor = mapdata.CameraMaxFloor
  Msg("NewMapLoadedCameraSettingsSet")
end
OnMsg.NewMapLoaded = SetupMapBorders
OnMsg.GamepadUIStyleChanged = SetupMapBorders
