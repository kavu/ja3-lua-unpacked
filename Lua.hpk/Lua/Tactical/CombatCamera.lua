if FirstLoad then
  g_CombatCamAttackStack = {}
  const.CombatCamExplosionDelay = 1500
  const.MaxSimultaneousUnits = 5
end
local MinAPToPlay = 2 * const.Scale.AP
MapVar("s_CameraMoveLockReasons", {})
MapVar("g_AITurnContours", {})
MapVar("g_ShowTargetBadge", {})
function LockCameraMovement(reason)
  if next(s_CameraMoveLockReasons) == nil then
    cameraTac.SetLockedMovement(true)
  end
  s_CameraMoveLockReasons[reason] = true
end
function UnlockCameraMovement(reason, unlock_all)
  if unlock_all then
    for reason, _ in pairs(s_CameraMoveLockReasons) do
      s_CameraMoveLockReasons[reason] = nil
    end
  else
    s_CameraMoveLockReasons[reason] = nil
  end
  if next(s_CameraMoveLockReasons) == nil then
    cameraTac.SetLockedMovement(false)
  end
end
function AdjustCombatCamera(state, instant, target, floor, sleepTime, noFitCheck)
  if not CanYield() then
    CreateGameTimeThread(AdjustCombatCamera, state, instant, target, floor, sleepTime, noFitCheck)
    return
  end
  if state == "set" then
    if instant then
      cameraTac.SetLookAtAngle(2400)
      table.change(hr, "Enemy turn TacCamera Angle", {CameraTacLookAtAngle = 2400})
      table.change(hr, "Instant Vertical Camera Movement", {CameraTacInterpolatedVerticalMovementTime = 0})
      table.change(hr, "Enemy turn TacCamera Height", {CameraTacHeight = 1500})
      cameraTac.SetForceMaxZoom(true, 0, true)
    else
      table.change(hr, "Enemy turn TacCamera Height", {CameraTacHeight = 1500})
      table.change(hr, "Enemy turn TacCamera Angle", {CameraTacLookAtAngle = 2400})
      cameraTac.SetForceMaxZoom(true)
    end
    if target then
      floor = floor or GetFloorOfPos(SnapToPassSlab(target))
      sleepTime = sleepTime or 1000
      if noFitCheck or not DoPointsFitScreen({
        IsPoint(target) and target or target:GetVisualPos()
      }, nil, const.Camera.BufferSizeNoCameraMov) then
        SnapCameraToObj(target, "force", floor, sleepTime)
      end
    end
  elseif state == "reset" then
    hr.CameraTacClampToTerrain = true
    if table.changed(hr, "Instant Vertical Camera Movement") then
      table.restore(hr, "Instant Vertical Camera Movement")
    end
    if cameraTac.GetForceMaxZoom() then
      cameraTac.SetForceMaxZoom(false)
    end
    if table.changed(hr, "Enemy turn TacCamera Angle") then
      table.restore(hr, "Enemy turn TacCamera Angle")
    end
    if table.changed(hr, "Enemy turn TacCamera Height") then
      table.restore(hr, "Enemy turn TacCamera Height")
    end
    if target then
      floor = floor or GetFloorOfPos(SnapToPassSlab(target))
      sleepTime = sleepTime or 1000
      if noFitCheck or not DoPointsFitScreen({
        IsPoint(target) and target or target:GetVisualPos()
      }, nil, const.Camera.BufferSizeNoCameraMov) then
        SnapCameraToObj(target, "force", floor, sleepTime)
      end
    end
  end
end
function OnMsg.NewMapLoaded()
  cameraTac.SetLockedMovement(false)
  g_CombatCamAttackStack = {}
end
local CombatCam_CheckDeactivate = function()
  if not cameraTac.IsActive() or #g_CombatCamAttackStack > 0 or CurrentActionCamera or IsSetpiecePlaying() then
    return
  end
  UnlockCameraMovement("CombatCamera")
  cameraTac.SetForceMaxZoom(false)
end
local CombatCam_ScreenBuffer = 20
local CombatCam_DepthScale = 100
local CombatCam_NetZone = false
local CombatCam_ZoneThread = false
function NetSyncEvents.CalcCameraZone(zone)
  CombatCam_NetZone = zone
  if IsValidThread(CombatCam_ZoneThread) then
    Msg(CombatCam_ZoneThread)
  end
  CombatCam_ZoneThread = false
end
function CalcCombatZone(buffer, depth_scale)
  buffer = buffer or CombatCam_ScreenBuffer
  depth_scale = depth_scale or CombatCam_DepthScale
  local w, h = UIL.GetScreenSize():xy()
  local x1, y1 = MulDivRound(w, 100 - buffer, 100), MulDivRound(h, 100 - buffer, 100)
  local x2, y2 = MulDivRound(w, buffer, 100), MulDivRound(h, 100 - buffer, 100)
  local zone = {}
  local wx1, wy1 = GetTerrainCursorXY(x1, y1):xy()
  local wx2, wy2 = GetTerrainCursorXY(x2, y2):xy()
  zone[1] = point(wx1, wy1)
  zone[2] = point(wx2, wy2)
  local dx, dy = MulDivRound(wy1 - wy2, depth_scale, 100), MulDivRound(wx2 - wx1, depth_scale, 100)
  local rx, ry = GetTerrainCursorXY(w / 2, MulDivRound(h, buffer, 100)):xy()
  local rdx, rdy = rx - wx1, ry - wy1
  if dx * rdx + dy * rdy < 0 then
    dx, dy = -dx, -dy
  end
  zone[3] = point(wx2 + dx, wy2 + dy)
  zone[4] = point(wx1 + dx, wy1 + dy)
  local cx, cy = 0, 0
  for i, pos in ipairs(zone) do
    local x, y = pos:xy()
    cx, cy = cx + x, cy + y
  end
  zone.center = point(cx / 4, cy / 4)
  return zone
end
function NetSyncEvents.TestCalcCombatZone()
  local z1, z2
  CreateGameTimeThread(function()
    z1 = CombatCam_CalcZone()
  end)
  CreateGameTimeThread(function()
    z2 = CombatCam_CalcZone()
  end)
  print("TestCalcCombatZone", z1, z2)
end
function CombatCam_CalcZone(buffer, depth)
  NetUpdateHash("CombatCam_CalcZone")
  if not cameraTac.IsActive() and not IsGameReplayRunning() then
    return
  end
  local playingReplay = IsGameReplayRunning()
  local recordingReplay = not not GameRecord
  if (netInGame or playingReplay) and (not NetIsHost() or playingReplay) then
    CombatCam_NetZone = false
    if not IsValidThread(CombatCam_ZoneThread) then
      CombatCam_ZoneThread = CurrentThread()
    end
    local wokeup = WaitMsg(CombatCam_ZoneThread, 11000)
    if CombatCam_NetZone then
      local ret = CombatCam_NetZone
      return ret
    end
  end
  local zone = CalcCombatZone(buffer, depth)
  if (netInGame or recordingReplay) and (NetIsHost() or recordingReplay) then
    if not IsValidThread(CombatCam_ZoneThread) then
      CombatCam_ZoneThread = CurrentThread()
      NetSyncEvent("CalcCameraZone", zone)
    end
    WaitMsg(CombatCam_ZoneThread, 11000)
  end
  return zone
end
function CombatCam_DbgZone(zone)
  for i = 1, 4 do
    DbgAddVector(zone[i])
  end
  DbgAddVector(zone.center)
  NetUpdateHash("CombatCam_DbgZone", hashParamTable(zone), zone[1], zone[2], zone[3], zone[4])
end
function CountUnitsInZone(x, y, units, zone, return_units)
  local cx, cy = zone.center:xy()
  local count = 0
  local selected = return_units and {} or nil
  for _, u in ipairs(units) do
    local ux, uy
    if IsValid(u) then
      ux, uy = u:GetVisualPosXYZ()
    else
      ux, uy = u:xy()
    end
    local pos = point(cx + ux - x, cy + uy - y)
    if IsPointInsidePoly2D(pos, zone) then
      count = count + 1
      if selected then
        selected[#selected + 1] = u
      end
    end
  end
  return count, selected
end
local CombatCam_RemoveAttacker = function(unit)
  table.remove(g_CombatCamAttackStack, 1)
  table.remove(g_CombatCamAttackStack, 1)
  CombatCam_CheckDeactivate()
  Msg("CombatCamAttackQueueUpdate")
end
OnMsg.ActionCameraRemoved = CombatCam_CheckDeactivate
OnMsg.SetpieceDialogClosed = CombatCam_CheckDeactivate
local CombatCam_CalcAttackCamPos = function(attacker, target)
  local lookat = attacker
  local zone = CombatCam_CalcZone()
  if target and zone then
    local attack_pos = IsValid(attacker) and attacker:GetVisualPos()
    if not attack_pos then
      return
    end
    local target_pos = IsValid(target) and target:GetVisualPos() or target
    if not target_pos:IsValidZ() then
      target_pos = target_pos:SetTerrainZ()
    end
    local x, y = zone.center:xy()
    lookat = (attack_pos + target_pos) / 2
    if CountUnitsInZone(x, y, {attack_pos, target_pos}, zone) == 2 then
      return
    end
  end
  local lookat_pos = IsValid(lookat) and lookat:GetVisualPos() or lookat
  if zone and IsCloser(zone.center, lookat_pos, 5 * guim) then
    return
  end
  return lookat, zone
end
function CombatCam_ShowAttack(attacker, target)
  local zone = CombatCam_CalcZone()
  if IsPointInsidePoly2D(attacker, zone) and (not target or IsPointInsidePoly2D(target, zone)) or CurrentActionCamera then
    return
  end
  LockCameraMovement("CombatCamera")
  g_CombatCamAttackStack[#g_CombatCamAttackStack + 1] = attacker
  g_CombatCamAttackStack[#g_CombatCamAttackStack + 1] = target
  while g_CombatCamAttackStack[1] ~= attacker do
    WaitMsg("CombatCamAttackQueueUpdate", 100)
  end
  while ActionCameraPlaying do
    WaitMsg("ActionCameraRemoved", 100)
  end
  if not HasCombatActionInProgress(attacker) then
    return CombatCam_RemoveAttacker(attacker)
  end
  local lookat, zone = CombatCam_CalcAttackCamPos(attacker, target)
  if not lookat or not zone then
    return
  end
  local x, y = lookat:xy()
  if CountUnitsInZone(x, y, {attacker, target}, zone) < 2 then
    cameraTac.SetForceMaxZoom(true)
  end
  local floor = GetFloorOfPos(SnapToPassSlab(attacker))
  local pos = SnapToPassSlab(target)
  if pos then
    floor = Max(floor, GetFloorOfPos(pos))
  end
  SnapCameraToObj(lookat, "force", floor)
  Sleep(500)
end
MapVar("showAttack", false)
function CombatCam_ShowAttackNew(attacker, target, willBeinterrupted, results, freezeCamPos, changeFloorOnly)
  if CurrentActionCamera then
    return
  end
  LockCameraMovement("CombatCamera")
  cameraTac.SetForceMaxZoom(false)
  cameraTac.SetForceMaxZoom(true)
  table.insert(g_CombatCamAttackStack, 1, attacker)
  table.insert(g_CombatCamAttackStack, 2, target)
  showAttack = showAttack or CreateGameTimeThread(function()
    repeat
      local attacker = g_CombatCamAttackStack[1]
      local target = not IsPoint(g_CombatCamAttackStack[2]) and g_CombatCamAttackStack[2]:GetVisualPos() or g_CombatCamAttackStack[2]
      local isTargetUnit = IsKindOf(g_CombatCamAttackStack[2], "Unit") and g_CombatCamAttackStack[2] or false
      while ActionCameraPlaying do
        WaitMsg("ActionCameraRemoved", 100)
      end
      local floor = GetFloorOfPos(SnapToPassSlab(target))
      local pos, look = cameraTac.GetPosLookAt()
      local cameraInZone = DoPointsFitScreen({target}, look, const.Camera.BufferSizeNoCameraMov)
      if not willBeinterrupted then
        if not freezeCamPos then
          SnapCameraToObj(cameraInZone and look or target, "force", floor)
        elseif changeFloorOnly then
          cameraTac.SetFloor(floor, hr.CameraTacInterpolatedMovementTime * 10, hr.CameraTacInterpolatedVerticalMovementTime * 10)
        end
      else
        willBeinterrupted = false
      end
      ShowBadgesOfTargets(isTargetUnit and {isTargetUnit} or results, "show")
      local interrupted = false
      local consecutiveAttacks = false
      while not g_CombatCamAttackStack[1]:IsIdleCommand() do
        if g_CombatCamAttackStack[1] ~= attacker then
          interrupted = true
          break
        elseif g_CombatCamAttackStack[1] == g_CombatCamAttackStack[3] then
          table.remove(g_CombatCamAttackStack, 3)
          table.remove(g_CombatCamAttackStack, 3)
          consecutiveAttacks = true
          break
        end
        Sleep(100)
      end
      if not interrupted then
        ShowBadgesOfTargets(isTargetUnit and {isTargetUnit} or results, "hide")
        if not consecutiveAttacks then
          CombatCam_RemoveAttacker(attacker)
          ClearAITurnContours()
        end
      end
    until #g_CombatCamAttackStack <= 0
    showAttack = false
  end)
end
function ShowBadgesOfTargets(results, show)
  if show == "show" then
    for _, obj in ipairs(results.hit_objs or results) do
      if IsKindOf(obj, "Unit") and obj.ui_badge then
        table.insert(g_ShowTargetBadge, obj)
        obj.ui_badge:SetActive(true, "showTarget")
      end
    end
  elseif show == "hide" then
    for _, obj in ipairs(results.hit_objs or results) do
      if IsKindOf(obj, "Unit") and obj.ui_badge then
        local currentTeam = g_Combat and g_Teams[g_Combat.team_playing]
        if not currentTeam or currentTeam.control ~= "UI" then
          obj.ui_badge:SetActive(false, "showTarget")
        else
          obj.ui_badge.active_reasons.showTarget = false
        end
        table.remove(g_ShowTargetBadge, table.find(g_ShowTargetBadge, obj))
      end
    end
  end
end
MapVar("g_AIExecutionController", false)
function CreateAIExecutionController(obj, testActions)
  while g_AIExecutionController do
    WaitMsg("ExecutionControllerDeactivate", 500)
  end
  AIExecutionController:new(obj)
  g_AIExecutionController.testAllAttacks = testActions
  return g_AIExecutionController
end
DefineClass.AIExecutionController = {
  __parents = {"InitDone"},
  label = false,
  reposition = false,
  restore_camera_obj = false,
  claimed_markers = false,
  tracked_pois = false,
  cinematic_combat_camera = false,
  attacker = false,
  target = false,
  zone = false,
  enable_logging = false,
  override_notification = false,
  override_notification_text = false,
  units_playing = false,
  start_time = 0,
  group_to_follow = false,
  track_group = false,
  currently_playing = false,
  testAllAttacks = false,
  fallbackMoveTracking = false
}
function AIExecutionController:Init()
  g_AIExecutionController = self
  self.claimed_markers = {}
  self.units_playing = {}
  Msg("ExecutionControllerActivate")
end
function AIExecutionController:Done()
  NetUpdateHash("AIExecutionController_Done")
  UnlockCameraMovement(self, "unlock_all")
  if self.restore_camera_obj then
    AdjustCombatCamera("reset", nil, self.restore_camera_obj, nil, nil, "noFitCheck")
  end
  g_AIExecutionController = false
  Msg("ExecutionControllerDeactivate")
  ObjModified(SelectedObj)
end
function AIExecutionController:IsUnitPlaying(unit)
  return self.units_playing[unit]
end
function AIExecutionController:UpdateControlledUnits(units)
  local new_units = {}
  for _, unit in ipairs(units) do
    local should_play = not unit:IsAware() and unit.pending_aware_state or unit.ActionPoints >= MinAPToPlay
    local valid_target = IsValidTarget(unit)
    if valid_target and not unit:IsDefeatedVillain() and not unit:IsIncapacitated() and not unit.team.neutral and unit.command ~= "ExitMap" and should_play then
      if not self.units_playing[unit] then
        self.units_playing[unit] = true
        unit:UpdateHighlightMarking()
      end
      if not unit:IsAware() then
        if unit.pending_aware_state == "aware" then
          if unit:HasStatusEffect("Suspicious") or unit:HasStatusEffect("Surprised") then
            unit:AddStatusEffect("OpeningAttackBonus")
          end
          unit:RemoveStatusEffect("Suspicious")
          unit:RemoveStatusEffect("Unaware")
          unit:RemoveStatusEffect("Surprised")
          if unit:HasStatusEffect("Unconscious") then
            unit.pending_aware_state = nil
          else
            new_units[#new_units + 1] = unit
          end
        elseif unit.pending_aware_state == "surprised" then
          unit:AddStatusEffect("Surprised")
          unit.pending_aware_state = nil
        elseif unit.pending_aware_state == "suspicious" then
          unit:AddStatusEffect("Suspicious")
          unit:RemoveStatusEffect("Unaware")
          unit.pending_aware_state = nil
        end
      else
        unit.pending_aware_state = nil
        new_units[#new_units + 1] = unit
      end
    elseif valid_target then
      unit.pending_aware_state = nil
      new_units[#new_units + 1] = unit
    end
  end
  return new_units
end
MapVar("g_LastTurnAILog", {})
function AIExecutionController:Log(...)
  if self.enable_logging then
    local line = string.format(...)
    g_LastTurnAILog[#g_LastTurnAILog + 1] = string.format("[AI][%d] %s", GameTime(), line)
  end
end
function DelayAfterExplosion()
  if g_LastExplosionTime then
    NetUpdateHash("DelayAfterExplosion", g_LastExplosionTime, const.CombatCamExplosionDelay)
    Sleep(Max(0, g_LastExplosionTime + const.CombatCamExplosionDelay - GameTime()))
  end
end
local FallbackDespawnExitMapUnits = function()
  if not g_AIExecutionController or g_AIExecutionController.start_time + 3000 > GameTime() then
    return
  end
  for _, unit in ipairs(g_Units) do
    if unit.command == "ExitMap" then
      unit:SetCommand("Despawn")
    end
  end
end
if FirstLoad then
  mp_resolution_results = false
end
function NetSyncEvents.GetResolution(player_id, res)
  mp_resolution_results = mp_resolution_results or {}
  mp_resolution_results[player_id] = res
  Msg("ResUpdated")
end
function Mp_SetUserRes(res)
  CreateRealTimeThread(function()
    if GameState.sync_loading then
      WaitMsg("SyncLoadingDone")
    end
    mp_resolution_results = mp_resolution_results or {}
    NetSyncEvent("GetResolution", netUniqueId, res)
    local ok = WaitMsg("ResUpdated", 5000)
    if not ok then
    end
  end)
end
function OnMsg.SystemSize(res)
  if netInGame then
    Mp_SetUserRes(res)
  end
end
function OnMsg.NetGameJoined()
  Mp_SetUserRes(UIL.GetScreenSize())
end
function OnMsg.NetGameLeft()
  mp_resolution_results = false
end
function NetSyncEvents.Mp_DoPointsFitScreen(res)
  Msg("DoesFitScreen", res)
end
function Mp_PickSmallerPlayingField(choices)
  local player1Ratio = MulDivRound(mp_resolution_results[1]:x(), 10000, mp_resolution_results[1]:y())
  local player2Ratio = MulDivRound(mp_resolution_results[2]:x(), 10000, mp_resolution_results[2]:y())
  return player1Ratio > player2Ratio and choices[1] or choices[2]
end
function DoPointsFitScreen(points, screenCenterPos, screenBufferPerc)
  NetUpdateHash("DoPointsFitScreen")
  if not cameraTac.IsActive() and not IsGameReplayRunning() then
    return
  end
  local playingReplay = IsGameReplayRunning()
  local recordingReplay = not not GameRecord
  if netInGame and NetIsHost() and table.count(netGamePlayers) == 2 and (not mp_resolution_results or #mp_resolution_results ~= 2) then
    return
  end
  if not (not netInGame or NetIsHost()) or playingReplay then
    local ok, res = WaitMsg("DoesFitScreen", 5000)
    if not ok then
      return
    end
    return res
  end
  local doesFit = true
  local smallerResolution = table.count(netGamePlayers) == 2 and Mp_PickSmallerPlayingField(mp_resolution_results) or UIL.GetScreenSize()
  local screenSize = smallerResolution
  local screenBufferW = screenBufferPerc and MulDivRound(screenSize:x(), screenBufferPerc, 100) or 0
  local screenBufferH = screenBufferPerc and MulDivRound(screenSize:y(), screenBufferPerc, 100) or 0
  local bufferedScreenMinPoint = point(screenBufferW, screenBufferH)
  local bufferedScreenMaxPoint = smallerResolution - point(screenBufferW, screenBufferH)
  local safeArea = box(bufferedScreenMinPoint, bufferedScreenMaxPoint)
  local ptCamera, ptCameraLookAt = GetCameraPosLookAtOnPos(screenCenterPos)
  local pointsPosOnScreen = {
    GameToScreenFromView(ptCamera, ptCameraLookAt, screenSize:x(), screenSize:y(), table.unpack(points))
  }
  for _, scrnPoint in pairs(pointsPosOnScreen) do
    if not safeArea:Point2DInside(scrnPoint) then
      doesFit = false
      break
    end
  end
  if not next(pointsPosOnScreen) then
    doesFit = false
  end
  if netInGame and NetIsHost() and table.count(netGamePlayers) == 2 or recordingReplay then
    NetSyncEvent("Mp_DoPointsFitScreen", doesFit)
    local ok, res = WaitMsg("DoesFitScreen", 5000)
    if not ok then
      return
    end
    return res
  end
  return doesFit
end
local MoveAndAttack = {
  RunAndGun = true,
  MobileShot = true,
  Charge = true,
  HyenaCharge = true
}
local AOE_keywords = {
  "Soldier",
  "Control",
  "Explosives",
  "Ordnance"
}
local AOE_archetypes = {"Artillery"}
local UnitAoeChance = function(unit)
  local ai_context = unit.ai_context
  local aoe_chance = 0
  for _, keyword in ipairs(unit.AIKeywords) do
    if table.find(AOE_keywords, keyword) then
      aoe_chance = aoe_chance + 100
    end
  end
  if table.find(AOE_archetypes, ai_context.archetype.id) then
    aoe_chance = aoe_chance + 100
  end
  return Clamp(aoe_chance, 0, 100)
end
local __AIExecutionControllerExecute = function(self, units, reposition, played_units)
  if not g_Combat then
    return
  end
  local pov_team = GetPoVTeam()
  local max_sight_radius = MulDivRound(const.Combat.AwareSightRange, const.SlabSizeX * const.Combat.SightModMaxValue, 100)
  self.start_time = GameTime()
  DelayAfterExplosion()
  ObjModified(g_Combat)
  LockCameraMovement(self)
  g_AIDestEnemyLOSCache = {}
  g_AIDestIndoorsCache = {}
  if self.enable_logging then
    g_LastTurnAILog = {}
  end
  if self.override_notification then
    ShowTacticalNotification(self.override_notification, true, self.override_notification_text)
  end
  local FindAllyInUnits = function(units)
    for _, unit in ipairs(units) do
      if unit.team.side == "ally" or unit.team.player_team then
        return true
      end
    end
    return false
  end
  local allyInUnits = FindAllyInUnits(units)
  local moveAttackException, hiddenTurnShowMercs
  if not self.reposition then
    if not self.override_notification then
      if allyInUnits then
        ShowTacticalNotification("allyTurnPhase")
      else
        ShowTacticalNotification("enemyTurnPhase")
      end
    end
    for _, unit in ipairs(units) do
      if not unit:IsIncapacitated() and unit:IsAware() and unit.ActionPoints > 0 then
        unit:StartAI()
        table.insert_unique(played_units, unit)
      end
    end
    if not self.override_notification then
      if allyInUnits then
        HideTacticalNotification("allyTurnPhase")
      else
        HideTacticalNotification("enemyTurnPhase")
      end
    end
  end
  self:Log("Start turn execution (%d units)", #units)
  local awareness_anims_played
  local to_play = {}
  local engaged = false
  if 0 < #units and g_Combat and netInGame then
    local closestUnit = false
    local closestDist = max_int
    for _, unit in ipairs(pov_team.units) do
      for i = 1, #units do
        local otherUnit = units[i]
        if otherUnit == unit then
          closestUnit = unit
          goto lbl_148
        elseif not closestUnit or IsCloser(unit, otherUnit, closestUnit) then
          closestUnit = unit
        end
      end
    end
    ::lbl_148::
    if closestUnit then
      SnapCameraToObj(closestUnit, nil, nil, 1000)
      NetUpdateHash("SnapCameraToObj", closestUnit)
    end
  end
  while 0 < #units and g_Combat do
    if self.reposition and not g_Combat.enemies_engaged then
      local engage = true
      if self.label == "AlwaysReady" then
        engage = false
        for _, unit in ipairs(units) do
          engage = engage or unit ~= self.activator
        end
      end
      if engage then
        g_Combat.enemies_engaged = true
        engaged = true
        Msg("RepositionStart")
      end
    end
    units = self:UpdateControlledUnits(units)
    for i = #to_play, 1, -1 do
      local unit = to_play[i]
      if not IsValidTarget(unit) or unit:IsDefeatedVillain() or unit.command ~= "Die" or unit.command == "ExitMap" or unit.ActionPoints < MinAPToPlay then
        table.remove(to_play, i)
      end
    end
    self:Log("Processing %d units...", #units)
    local zone = CombatCam_CalcZone()
    Sleep(1)
    NetUpdateHash("CombatCam_CalcZone_Done")
    local playing
    if 0 < #to_play then
      playing = to_play
    else
      playing = self:SelectPlayingUnits(units, zone) or empty_table
    end
    to_play = {}
    self:Log("%d units selected", #playing)
    if #playing == 0 then
      break
    end
    self.currently_playing = playing
    local units_repositioning = self.reposition or not not playing[1].pending_aware_state
    if Platform.developer then
      for i = 2, #playing do
      end
    end
    local pois = {}
    local max_dest_floor = -1
    local cinematicUnits = {}
    for playing_idx, unit in ipairs(playing) do
      local dest
      if not g_Combat then
        break
      end
      if units_repositioning then
        if g_Combat and (self.label == "AlwaysReady" and unit == self.activator or not g_Combat:IsRepositioned(self)) then
          unit.ActionPoints = MulDivRound(unit:GetMaxActionPoints(), const.Combat.RepositionAPPercent, 100)
          if unit:HasStatusEffect("FreeReposition") then
            unit.free_move_ap = unit.free_move_ap + 999999
            unit.ActionPoints = unit.ActionPoints + 999999
          end
          unit:StartAI()
          if not g_Combat or unit:IsIncapacitated() then
            break
          end
          table.insert_unique(played_units, unit)
          if self.label ~= "AlwaysReady" or unit ~= self.activator then
            unit:PickRepositionDest()
          end
        end
        dest = unit.reposition_dest
        if unit.reposition_marker then
          self.claimed_markers[#self.claimed_markers] = unit.reposition_marker
        end
        self:Log("  Unit %s (%d) reposition dest: %d (%s)", unit.unitdatadef_id, unit.handle, dest, unit.reposition_marker and "marker" or "no marker")
      else
        unit.ai_context.behavior:Think(unit)
        if 1 < playing_idx then
          local dest = unit.ai_context.ai_destination
          local occupied = dest and point(stance_pos_unpack(dest)) or GetPassSlab(unit) or SnapToVoxel(unit)
          for k = 1, playing_idx - 1 do
            local unit2 = playing[k]
            local dest2 = unit2.ai_context.ai_destination
            local occupied2 = dest2 and point(stance_pos_unpack(dest2)) or GetPassSlab(unit2) or SnapToVoxel(unit2)
            if occupied == occupied2 then
              printf("Occupied ai_destination %s. AI behaviors: %s, %s", tostring(occupied), unit.ai_context.behavior.class, unit2.ai_context.behavior.class)
              for j = 1, 20 do
                unit.ai_context.behavior:Think(unit)
              end
            end
          end
        end
        if not g_Combat then
          break
        end
        unit.ai_context.behavior:TakeStance(unit)
        if not g_Combat then
          break
        end
        dest = unit.ai_context.ai_destination
        local willMove = unit.ai_context.ai_destination and stance_pos_dist(unit.ai_context.ai_destination, stance_pos_pack(unit)) ~= 0
        if willMove then
          local currPos = unit:GetVisualPos()
          local destPost = point(stance_pos_unpack(unit.ai_context.ai_destination))
          willMove = currPos:Dist(destPost) > const.Camera.MinTrackDistance
        end
        local isTargetUnit = IsKindOf(unit.ai_context.dest_target[unit.ai_context.ai_destination], "Unit")
        local target = isTargetUnit and unit.ai_context.dest_target[unit.ai_context.ai_destination]
        local middlePoint = target and (point(stance_pos_unpack(unit.ai_context.ai_destination)) + target:GetVisualPos()) / 2
        local hasAp = not unit.ai_context.dest_ap[unit.ai_context.ai_destination] or unit.ai_context.dest_ap[unit.ai_context.ai_destination] >= unit.ai_context.default_attack_cost
        local willFit = middlePoint and DoPointsFitScreen({
          target:GetVisualPos(),
          point(stance_pos_unpack(unit.ai_context.ai_destination))
        }, middlePoint, 10)
        local interrupts = unit:CheckProvokeOpportunityAttacks("attack interrupt", {
          unit.target_dummy or unit
        })
        moveAttackException = moveAttackException or unit.ai_context and unit.ai_context.movement_action and MoveAndAttack[unit.ai_context.movement_action.action_id] or MoveAndAttack[unit.action_command]
        if not self.testAllAttacks and isTargetUnit and hasAp and willMove and willFit and not interrupts and not g_Combat:GetEmplacementAssignment(unit) and target.visible then
          local aoe_chance = UnitAoeChance(unit)
          if aoe_chance ~= 100 then
            cinematicUnits[unit.handle] = aoe_chance
            table.insert(cinematicUnits, unit)
          end
        end
        self:Log("  Unit %s (%d) (archetype: %s, behavior: %s) dest: %s", unit.unitdatadef_id, unit.handle, unit.current_archetype, unit.ai_context.behavior:GetEditorView(), tostring(dest))
      end
      if HasVisibilityTo(pov_team, unit) then
        pois[#pois + 1] = unit
      end
      if dest then
        local rx, ry, rz, rs = stance_pos_unpack(dest)
        unit:ClearEnumFlags(const.efResting)
        PlaceDestlock(unit, rx, ry, rz)
        local step_pos = point(rx, ry, rz)
        local willReveal = RevealUnitBeforeMove(unit, {goto_pos = step_pos, goto_stance = rs})
        if willReveal then
          pois[#pois + 1] = unit
        end
        max_dest_floor = Max(max_dest_floor, GetFloorOfPos(step_pos))
      end
      local pos = SnapToPassSlab(unit) or unit:GetPos()
      max_dest_floor = Max(max_dest_floor, GetFloorOfPos(pos))
    end
    for i = #playing, 1, -1 do
      playing[i]:ClearPath()
    end
    if ActionCameraPlaying or CurrentActionCamera then
      RemoveActionCamera(true)
      if ActionCameraPlaying then
        WaitMsg("ActionCameraRemoved", 5000)
      end
    end
    local cinematicUnit
    for _, unit in ipairs(cinematicUnits) do
      local aoe_chance = cinematicUnits[unit.handle]
      cinematicUnit = not (cinematicUnit and aoe_chance < cinematicUnits[cinematicUnit.handle]) and cinematicUnit or unit
    end
    if cinematicUnit and not moveAttackException then
      StartCinematicCombatCamera(cinematicUnit, cinematicUnit.ai_context.dest_target[cinematicUnit.ai_context.ai_destination])
    end
    local sleep_t = 500
    local did_sleep = false
    if 0 < #pois then
      local floor
      if -1 < max_dest_floor then
        floor = Clamp(max_dest_floor, hr.CameraTacMinFloor, hr.CameraTacMaxFloor)
      end
      if not self.override_notification then
        HideTacticalNotification("turn")
        if FindAllyInUnits(pois) then
          ShowTacticalNotification(units_repositioning and "allyRepositionPhase" or "allyTurnPhase", true)
        else
          ShowTacticalNotification(units_repositioning and "enemyRepositionPhase" or "enemyTurnPhase", true)
        end
      end
    elseif not self.override_notification then
      HideTacticalNotification("turn")
      if FindAllyInUnits(playing) then
        ShowTacticalNotification(units_repositioning and "allyHiddenRepoPhase" or "allyHiddenTurnPhase", true)
      else
        ShowTacticalNotification(units_repositioning and "hiddenEnemyRepoPhase" or "hiddenEnemyTurnPhase", true)
      end
    end
    if IsCompetitiveGame() and not did_sleep then
      Sleep(sleep_t)
    end
    if not IsCompetitiveGame() then
      NetUpdateHash("__AIExecutionControllerExecute_playing", hashParamTable(playing))
    end
    self.zone = CombatCam_CalcZone()
    local attacker, mover
    if (not pois or #pois <= 0) and not hiddenTurnShowMercs then
      local selected = self:SelectObjsInZone(pov_team.units, self.zone)
      local closestMerc = false
      for _, merc in ipairs(selected) do
        if not closestMerc or IsCloser(self.zone.center, merc:GetPos(), closestMerc:GetPos()) then
          closestMerc = merc
          hiddenTurnShowMercs = true
        end
      end
      AdjustCombatCamera("set", nil, closestMerc)
    else
      AdjustCombatCamera("set")
    end
    Sleep(500)
    for i, unit in ipairs(playing) do
      if not g_AITurnContours[unit.handle] then
        local enemy = unit.team.side == "enemy1" or unit.team.side == "enemy2" or unit.team.side == "neutralEnemy"
        g_AITurnContours[unit.handle] = SpawnUnitContour(unit, enemy and "CombatEnemy" or "CombatAlly")
        ShowBadgeOfAttacker(unit, true)
      end
      local result = "continue"
      self:Log("  Unit %s (%d) movement start", unit.unitdatadef_id, unit.handle)
      if units_repositioning then
        if awareness_anims_played then
          unit.pending_awareness_role = nil
        end
        if table.find(pois, unit) and not self.cinematic_combat_camera then
          g_AIExecutionController.tracked_pois = g_AIExecutionController.tracked_pois or {}
          table.insert(g_AIExecutionController.tracked_pois, unit)
        end
        StartCombatAction("Reposition", unit, 0)
      elseif unit:HasStatusEffect("ManningEmplacement") and unit:GetArchetype() ~= Archetypes.EmplacementGunner then
        AIPlayCombatAction("MGLeave", unit, 0)
        result = "restart"
      elseif unit.ai_context.ai_destination then
        local unitAIinfo = unit.ai_context
        local lastStanding = IsLastUnitInTeam(unit.team.units)
        local willMove = stance_pos_dist(unitAIinfo.ai_destination, stance_pos_pack(unit)) ~= 0
        local isTargetUnit = IsKindOf(unitAIinfo.dest_target[unitAIinfo.ai_destination], "Unit")
        local hasAp = not unitAIinfo.dest_ap[unitAIinfo.ai_destination] or unitAIinfo.dest_ap[unitAIinfo.ai_destination] >= unitAIinfo.default_attack_cost
        if not attacker and willMove and isTargetUnit and hasAp and not lastStanding then
          attacker = unit
        elseif not mover and willMove and not isTargetUnit and not lastStanding then
          mover = unit
        end
        local trackPos = table.find(pois, unit)
        local trackMove
        if willMove and not self.cinematic_combat_camera and trackPos then
          trackMove = true
        end
        result = unit.ai_context.behavior:BeginMovement(unit, trackMove)
      end
      if result ~= "continue" then
        self:Log("  Execution interrupted: %s", result or "false")
        local limit = result == "restart" and i or i + 1
        for j = #playing, limit, -1 do
          to_play[#to_play + 1] = playing[j]
          playing[j] = nil
        end
        break
      end
    end
    if attacker then
      PlayVoiceResponse(attacker, "AIStartingTurnAttack")
    elseif mover then
      PlayVoiceResponse(mover, "AIStartingTurnMoving")
    end
    WaitAllCombatActionsEnd()
    WaitUnitsInIdle(nil, FallbackDespawnExitMapUnits)
    self.tracked_pois = nil
    self.group_to_follow = nil
    self.track_group = nil
    self.zone = nil
    awareness_anims_played = true
    self:Log("Movement phase finished (%d units playing)", #playing)
    ClearAITurnContours()
    WaitActionCamDonePlayingSync()
    for _, unit in ipairs(playing) do
      AIUpdateScoutLocation(unit)
    end
    local end_combat
    while 0 < #(playing or empty_table) and g_Combat do
      local unit, min_dist
      if cinematicUnit then
        unit = cinematicUnit
        cinematicUnit = false
      else
        unit, min_dist = PickClosestUnit(playing)
      end
      table.remove_value(playing, unit)
      if IsValid(unit) and not unit:IsDead() then
        unit.pending_aware_state = nil
        if units_repositioning then
          StartCombatAction("RepositionOpeningAttack", unit, 0)
          WaitCombatActionsEnd(unit)
          ClearAITurnContours()
          while ActionCameraPlaying do
            WaitMsg("ActionCameraRemoved", 100)
          end
          table.remove_value(units, unit)
        else
          local status = AIExecuteUnitBehavior(unit, self.testAllAttacks)
          if status ~= "restart" then
            table.remove_value(units, unit)
          else
            table.iappend(to_play, playing)
            break
          end
        end
        if not g_Combat or g_Combat:ShouldEndCombat() then
          end_combat = true
          break
        end
        Sleep(500)
      end
    end
    if end_combat then
      break
    end
    for _, unit in ipairs(g_Units) do
      if not unit:IsDead() and not unit:IsAware() and unit.pending_aware_state == "aware" then
        if not self.reposition and unit.team == g_Teams[g_CurrentTeam] then
          unit:RemoveStatusEffect("Unaware")
          unit:RemoveStatusEffect("Surprised")
          unit:RemoveStatusEffect("Suspicious")
          unit.pending_aware_state = nil
          unit:StartAI()
          table.insert_unique(played_units, unit)
        end
        table.insert_unique(units, unit)
        allyInUnits = FindAllyInUnits(units)
      end
    end
  end
  ObjModified(g_Combat)
  if self.override_notification then
    HideTacticalNotification(self.override_notification)
  else
    HideTacticalNotification("turn")
  end
  for _, marker in ipairs(self.claimed_markers) do
    g_RepositionMarkersClaimed[marker] = nil
  end
  if self.reposition and engaged then
    Msg("RepositionEnd")
    if g_Combat and not g_Combat.start_reposition_ended then
      g_Combat.start_reposition_ended = true
      Msg("CombatStartRepositionDone")
    end
  end
  self:Log("Execution finished")
  if g_Combat then
    g_Combat:EndCombatCheck()
  end
end
function OnMsg.EnterSector()
  table.restore(hr, "Enemy turn TacCamera Angle", true)
  table.restore(hr, "Enemy turn TacCamera Height", true)
end
MapVar("g_UnawareQueue", {})
function AIExecutionController:Execute(units)
  local played_units = {}
  g_LastUnitToShoot = false
  g_UnawareQueue = {}
  sprocall(__AIExecutionControllerExecute, self, units, nil, played_units)
  for _, unit in ipairs(played_units) do
    unit.ai_context = nil
  end
  local check
  for _, unit in ipairs(g_UnawareQueue) do
    unit:AddStatusEffect("Unaware")
    check = true
  end
  g_LastUnitToShoot = false
  if check and g_Combat then
    g_Combat:EndCombatCheck()
  end
end
function AIExecutionController:SelectPlayingUnits(units, zone)
  local reposition_units = table.ifilter(units, function(idx, unit)
    return unit.pending_aware_state == "aware" or unit == self.activator
  end)
  if 0 < #reposition_units then
    units = reposition_units
  else
    units = table.ifilter(units, function(idx, unit)
      return unit:IsAware() and unit.ActionPoints >= MinAPToPlay and not unit:GetBandageTarget()
    end)
    units = AIGetNextPhaseUnits(units)
  end
  local side = next(units) and units[1].team.side
  local minFloor
  for _, unit in ipairs(units) do
    local unitFloor = GetFloorOfPos(SnapToPassSlab(unit)) or 0
    if not minFloor or minFloor > unitFloor then
      minFloor = unitFloor
    end
  end
  local selected = table.copy(units or empty_table)
  selected = table.ifilter(selected, function(idx, unit)
    local unitFloor = GetFloorOfPos(SnapToPassSlab(unit)) or 0
    return unit.team.side == side and unitFloor == minFloor
  end)
  selected = self:SelectObjsInZone(selected, zone)
  if #reposition_units <= 0 then
    local interruptedGroup = false
    for idx, unit in ipairs(selected) do
      local pathDummies = unit:GenerateTargetDummiesFromPath(unit.ai_context.dest_combat_path)
      local interrupted = unit:CheckProvokeOpportunityAttacks("move", pathDummies)
      if interrupted and idx == 1 then
        interruptedGroup = true
      end
      if not not interruptedGroup ~= not not interrupted then
        table.remove(selected, idx)
      end
    end
  end
  while #(selected or empty_table) > const.MaxSimultaneousUnits do
    table.remove(selected)
  end
  return selected
end
function CountUnitsInArea(x, y, objs, r)
  local group = {}
  for _, obj in ipairs(objs) do
    local ox, oy
    if IsValid(obj) then
      ox, oy = obj:GetVisualPosXYZ()
    else
      ox, oy = obj:xy()
    end
    if IsCloser2D(x, y, ox, oy, r) then
      group[#group + 1] = obj
    end
  end
  return #group, group
end
function ClusterUnits(objs)
  objs = objs or g_Units
  local r = 0
  r = 10 * guim
  local clusters = {}
  for _, obj in ipairs(objs) do
    local x, y
    if IsValid(obj) then
      x, y = obj:GetVisualPosXYZ()
    else
      x, y = obj:xy()
    end
    local cluster = {x = x, y = y}
    clusters[#clusters + 1] = cluster
    cluster.count, cluster.objs = CountUnitsInArea(cluster.x, cluster.y, objs, r)
  end
  for idx, cluster in ipairs(clusters) do
    repeat
      local cx, cy = cluster.x, cluster.y
      local count, next_potential_objs = CountUnitsInArea(cx, cy, objs, 2 * r)
      if count > cluster.count then
        local x, y = midpoint(next_potential_objs)
        local next_count, next_objs = CountUnitsInArea(x, y, objs, r)
        local lost
        for _, obj in ipairs(cluster.objs) do
          lost = lost or not table.find(next_objs, obj)
        end
        if not lost then
          cluster.x, cluster.y = x, y
          cluster.count = next_count
          cluster.objs = next_objs
        end
      end
      local change = cx ~= cluster.x or cy ~= cluster.y
    until not change
  end
  table.sortby_field_descending(clusters, "count")
  for _, obj in ipairs(objs) do
    local cluster_idx
    for i, cluster in ipairs(clusters) do
      if table.find(cluster.objs, obj) then
        cluster_idx = i
        break
      end
    end
    for j = cluster_idx + 1, #clusters do
      table.remove_value(clusters[j].objs, obj)
    end
  end
  for i = #clusters, 1, -1 do
    clusters[i].count = #clusters[i].objs
    if clusters[i].count == 0 then
      table.remove(clusters, i)
    end
  end
  return clusters
end
function midpoint(objs)
  local cx, cy, cz = 0, 0, 0
  for _, obj in ipairs(objs) do
    local x, y, z
    if IsValid(obj) then
      x, y, z = obj:GetVisualPosXYZ()
    else
      x, y, z = obj:xyz()
    end
    cx, cy, cz = cx + x, cy + y, cz + (z or terrain.GetHeight(x, y))
  end
  if 0 < #objs then
    cx, cy, cz = cx / #objs, cy / #objs, cz / #objs
  end
  return cx, cy, cz
end
function AIExecutionController:SelectObjsInZone(objs, zone)
  if not (zone and objs) or #objs == 0 then
    return
  end
  local clusters = ClusterUnits(objs)
  local nearest, ndist
  for _, cluster in ipairs(clusters) do
    local dist = zone.center:Dist(point(cluster.x, cluster.y))
    if not nearest or ndist > dist then
      nearest, ndist = cluster, dist
    end
  end
  return nearest and nearest.objs
end
function AIExecutionController:FitObjsInZone(objs, zone, floor, sleep_time)
  if not objs or #objs == 0 then
    return
  end
  local x, y = zone.center:xy()
  local in_zone = CountUnitsInZone(x, y, objs, zone)
  floor = floor or HighestFloorOfGroup(objs)
  if in_zone < #objs then
    local center = IsValid(objs[1]) and objs[1]:GetVisualPos() or objs[1]
    for i = 2, #objs do
      center = center + (IsValid(objs[i]) and objs[i]:GetVisualPos() or objs[i])
    end
    center = center / #objs
    SnapCameraToObj(center, "force", floor, sleep_time)
    if sleep_time then
      Sleep(sleep_time)
      return true
    end
  end
  return false
end
function CenterCameraOnObj(objs, floor, sleep_time)
  if not objs or #objs == 0 then
    return
  end
  local center = IsValid(objs[1]) and objs[1]:GetVisualPos() or objs[1]
  for i = 2, #objs do
    center = center + (IsValid(objs[i]) and objs[i]:GetVisualPos() or objs[i])
  end
  center = center / #objs
  AdjustCombatCamera("set", nil, center, floor, sleep_time, "NoFitCheck")
  if sleep_time then
    Sleep(sleep_time)
    return true
  end
  return false
end
function AIExecutionController:ShowUnits(units, wait_time)
  local pov_team = GetPoVTeam()
  WaitActionCamDonePlayingSync()
  LockCameraMovement(self)
  local w, h = UIL.GetScreenSize():xy()
  local pos, restore_pt = cameraTac.GetPosLookAt()
  local restore_floor = cameraTac.GetFloor()
  local willMoveCam
  while 0 < #units and g_Combat do
    local zone = CombatCam_CalcZone()
    if not zone then
      break
    end
    local group = self:SelectObjsInZone(units, zone)
    willMoveCam = self:FitObjsInZone(group, zone, g_Teams[g_CurrentTeam].control == "UI" and restore_floor or false, wait_time) or willMoveCam
    for _, unit in ipairs(group) do
      table.remove_value(units, unit)
      pov_team.seen_units = pov_team.seen_units or {}
      table.insert(pov_team.seen_units, unit:GetHandle())
    end
  end
  if g_Combat and willMoveCam then
    SnapCameraToObj(restore_pt, nil, restore_floor)
    Sleep(500)
  end
end
function StartCinematicCombatCamera(attacker, target)
  local isNear = DoPointsFitScreen({
    attacker:GetVisualPos()
  }, nil, const.Camera.BufferSizeNoCameraMov)
  AdjustCombatCamera("set", nil, not isNear and attacker, GetFloorOfPos(SnapToPassSlab(attacker)), not isNear and 1000 or 0)
  Sleep(not isNear and 1000 or 500)
  AILockTarget(attacker)
  g_AIExecutionController.cinematic_combat_camera = true
  g_AIExecutionController.attacker = attacker
  g_AIExecutionController.target = target
end
function StopCinematicCombatCamera()
  if IsCinematicCCPlaying() then
    Sleep(1000)
    local attacker = g_AIExecutionController.attacker
    g_AIExecutionController.cinematic_combat_camera = false
    g_AIExecutionController.attacker = false
    g_AIExecutionController.target = false
    return true, attacker
  else
    return false
  end
end
function IsCinematicCCPlaying()
  return g_AIExecutionController and g_AIExecutionController.cinematic_combat_camera
end
local AICinematicCombatCamera = function()
  if not (g_AIExecutionController and not g_AIExecutionController.tracked_pois and g_AIExecutionController.cinematic_combat_camera and g_AIExecutionController.attacker) or not g_AIExecutionController.target then
    return
  end
  local midPointX, midPointY, midPointZ = midpoint({
    g_AIExecutionController.attacker,
    g_AIExecutionController.target
  })
  SnapCameraToObj(point(midPointX, midPointY, midPointZ), "force", GetFloorOfPos(SnapToPassSlab(g_AIExecutionController.target)), 5000, "none")
end
DefineConstInt("Camera", "MinTrackDistance", 3, "voxelSizeX", "The minimum distance (in slabs) required to active the tracking camera, else it will lock to init pos once. Also used for cinematic unit cond.")
local AIExecutionTrackUnits = function()
  if not (g_AIExecutionController and g_AIExecutionController.tracked_pois) or #g_AIExecutionController.tracked_pois == 0 or #g_CombatCamAttackStack > 1 then
    return
  end
  if ActionCameraPlaying then
    return
  end
  g_AIExecutionController.tracked_pois = table.ifilter(g_AIExecutionController.tracked_pois, function(idx, poi)
    return not IsKindOf(poi, "Unit") or HasCombatActionInProgress(poi)
  end)
  if not g_AIExecutionController.group_to_follow or #g_AIExecutionController.group_to_follow == 0 then
    g_AIExecutionController.group_to_follow = {}
    g_AIExecutionController.track_group = false
    local destPoints = {}
    for _, unit in ipairs(g_AIExecutionController.tracked_pois) do
      local unitFinalDestination = unit.ai_context.ai_destination or unit.reposition_dest
      if unitFinalDestination then
        local x, y, z = stance_pos_unpack(unitFinalDestination)
        local pt = point(x, y, z)
        table.insert(destPoints, pt)
        destPoints[pt] = unit
      end
    end
    local clusters = ClusterUnits(destPoints)
    table.sortby_field_descending(clusters, "count")
    local bestClusterOfDest = clusters[1]
    local objsInCluster = bestClusterOfDest and bestClusterOfDest.objs or {}
    for _, pt in ipairs(objsInCluster) do
      table.insert(g_AIExecutionController.group_to_follow, destPoints[pt])
    end
    if 0 < #destPoints and GetDistGroupInitAndDestPoint(destPoints) > const.Camera.MinTrackDistance then
      g_AIExecutionController.track_group = true
    end
    if not g_AIExecutionController.track_group and next(g_AIExecutionController.group_to_follow) and not DoPointsFitScreen({
      unpack_params(objsInCluster)
    }, nil, const.Camera.BufferSizeNoCameraMov) then
      CenterCameraOnObj(g_AIExecutionController.group_to_follow, HighestFloorOfGroup(g_AIExecutionController.group_to_follow), 500)
    end
  end
  if not g_AIExecutionController.group_to_follow or not next(g_AIExecutionController.group_to_follow) then
    return
  end
  local trackedUnitsClusters = ClusterUnits(g_AIExecutionController.group_to_follow)
  local biggestCluster
  for _, cluster in ipairs(trackedUnitsClusters) do
    if not biggestCluster or biggestCluster.count < cluster.count then
      biggestCluster = cluster
    end
  end
  local maxFloor = HighestFloorOfGroup(biggestCluster.objs)
  if biggestCluster and g_AIExecutionController.track_group then
    CenterCameraOnObj(biggestCluster.objs, maxFloor)
  end
end
local TrackMeleeCharge = function()
  if not g_TrackingChargeAttacker or not g_AIExecutionController then
    return
  end
  if IsCinematicCCPlaying() or ActionCameraPlaying then
    return
  end
  if gv_DebugMeleeCharge then
    print("tracking melee charge attacker")
  end
  SnapCameraToObj(g_TrackingChargeAttacker:GetVisualPos(), "force", GetFloorOfPos(SnapToPassSlab(g_TrackingChargeAttacker:GetVisualPos())))
end
MapGameTimeRepeat("AIExecutionTracking", 50, AIExecutionTrackUnits)
MapGameTimeRepeat("AICinematicCombat", 50, AICinematicCombatCamera)
MapGameTimeRepeat("AITrackMeleeCharge", 50, TrackMeleeCharge)
MapVar("s_EnemySightedQueue", {})
local CheckEnemySightedQueue = function()
  if #s_EnemySightedQueue == 0 then
    return
  end
  if next(CombatActions_RunningState) ~= nil or g_AIExecutionController or MoveAndAttackSyncState == 1 then
    return
  end
  local igi = GetInGameInterfaceModeDlg()
  if igi and igi.crosshair then
    CreateRealTimeThread(function()
      igi.crosshair:Close()
      if g_Combat then
        RemoveActionCamera()
        WaitMsg("ActionCameraRemoved", 1000)
        SetInGameInterfaceMode("IModeCombatMovement")
      else
        SetInGameInterfaceMode("IModeExploration")
      end
    end)
  end
  CreateAIExecutionController()
  CreateGameTimeThread(function()
    local units = s_EnemySightedQueue
    s_EnemySightedQueue = {}
    g_AIExecutionController:ShowUnits(units, 1500)
    DoneObject(g_AIExecutionController)
  end)
end
function OnMsg.EnemySighted(team, enemy)
  if GameState.sync_loading then
    return
  end
  if g_Combat and g_AIExecutionController then
    local tacNotState = GetDialog("TacticalNotification") and GetDialog("TacticalNotification").state
    local repoPhase = table.find(tacNotState, "mode", "hiddenEnemyRepoPhase")
    local normalPhase = table.find(tacNotState, "mode", "hiddenEnemyTurnPhase")
    if repoPhase or normalPhase then
      HideTacticalNotification("turn")
      ShowTacticalNotification(repoPhase and "enemyRepositionPhase" or "enemyTurnPhase", true)
    end
  end
  if g_Combat and team == GetPoVTeam() and not enemy.dummy and team == g_Teams[g_CurrentTeam] then
    local handle = enemy:GetHandle()
    if not table.find(team.seen_units or empty_table, handle) then
      s_EnemySightedQueue[#s_EnemySightedQueue + 1] = enemy
      CheckEnemySightedQueue()
      if not HasAnyCombatActionInProgress("all") then
        RestoreDefaultMode(false, false)
      end
    end
  end
end
function ClearAITurnContours(specificUnit)
  for unitHandle, contour in pairs(g_AITurnContours) do
    if not specificUnit or specificUnit.handle == unitHandle then
      DestroyMesh(contour)
      g_AITurnContours[unitHandle] = nil
      ShowBadgeOfAttacker(HandleToObject[unitHandle], false)
    end
  end
end
function OnMsg.UnitDied(unit)
  ClearAITurnContours(unit)
end
function ClearAllCombatBadges()
  for _, unit in ipairs(g_ShowTargetBadge) do
    ShowBadgeOfAttacker(unit, false)
  end
end
OnMsg.CombatActionEnd = CheckEnemySightedQueue
OnMsg.ExecutionControllerDeactivate = CheckEnemySightedQueue
function PickClosestUnit(group)
  local unit, min_dist
  for _, u in ipairs(group) do
    local target = AIGetIntendedTarget(u)
    local lookat, zone = CombatCam_CalcAttackCamPos(u, target)
    if not lookat or not zone then
      unit = u
      break
    end
    local dist = zone.center:Dist(IsValid(lookat) and lookat:GetVisualPos() or lookat)
    if not min_dist or min_dist > dist then
      unit, min_dist = u, dist
    end
  end
  return unit, min_dist
end
function ShowBadgeOfAttacker(attacker, show)
  if show then
    table.insert(g_ShowTargetBadge, attacker)
    if attacker.ui_badge then
      attacker.ui_badge:SetActive(show, "showAttacker")
    end
  elseif attacker then
    local currentTeam = g_Combat and g_Teams[g_Combat.team_playing]
    if not currentTeam or currentTeam.control ~= "UI" then
      if attacker.ui_badge then
        attacker.ui_badge:SetActive(show, "showAttacker")
      end
    elseif attacker.ui_badge then
      attacker.ui_badge.active_reasons.showAttacker = false
    end
    table.remove(g_ShowTargetBadge, table.find(g_ShowTargetBadge, attacker))
  end
end
function HighestFloorOfGroup(group)
  if not next(group) then
    return cameraTac.IsActive() and cameraTac.GetFloor()
  end
  local maxFloor
  for _, unit in ipairs(group) do
    if not maxFloor or maxFloor < (GetFloorOfPos(SnapToPassSlab(unit)) or GetFloorOfPos(unit:GetVisualPos())) then
      maxFloor = GetFloorOfPos(SnapToPassSlab(unit))
    end
  end
  return maxFloor
end
function GetDistGroupInitAndDestPoint(destPointsAndUnits)
  local current_center = destPointsAndUnits[destPointsAndUnits[1]]:GetVisualPos()
  local dest_center = destPointsAndUnits[1]
  for i = 2, #destPointsAndUnits do
    current_center = current_center + destPointsAndUnits[destPointsAndUnits[i]]:GetVisualPos()
    dest_center = dest_center + destPointsAndUnits[i]
  end
  current_center = current_center / #destPointsAndUnits
  dest_center = dest_center / #destPointsAndUnits
  return current_center:Dist(dest_center)
end
MapVar("g_TrackingChargeAttacker", false)
GameVar("gv_DebugMeleeCharge", false)
function ShouldTrackMeleeCharge(attacker, target)
  if IsCinematicCCPlaying() or ActionCameraPlaying or not g_AIExecutionController then
    g_TrackingChargeAttacker = false
    if gv_DebugMeleeCharge then
      print("skip melee charge camera logic because of non ai or cinematic camera or action camera")
    end
    return
  end
  local attackerPos = attacker:GetVisualPos()
  local targetPos = target:GetVisualPos()
  local initFitCheck = DoPointsFitScreen({attackerPos, targetPos}, nil, const.Camera.BufferSizeNoCameraMov)
  if initFitCheck then
    g_TrackingChargeAttacker = false
    if gv_DebugMeleeCharge then
      print("camera will not move as it is in a good spot")
    end
    return
  end
  local midPoint = (attackerPos + targetPos) / 2
  local secondFitCheck = DoPointsFitScreen({attackerPos, targetPos}, midPoint, const.Camera.BufferSizeNoCameraMov)
  if secondFitCheck then
    AdjustCombatCamera("set", nil, targetPos, GetFloorOfPos(SnapToPassSlab(targetPos)), nil, "NoFitCheck")
    g_TrackingChargeAttacker = false
    if gv_DebugMeleeCharge then
      print("snap the camera to the target and don't do anything else (the action would be visible)")
    end
    return
  end
  g_TrackingChargeAttacker = attacker
end
function AddToCameraTrackingBehavior(unit, args)
  if g_AIExecutionController and unit then
    if args.fallbackMove then
      local willReveal = RevealUnitBeforeMove(unit, args)
      if willReveal and not g_AITurnContours[unit.handle] then
        local enemy = unit.team.side == "enemy1" or unit.team.side == "enemy2" or unit.team.side == "neutralEnemy"
        g_AITurnContours[unit.handle] = SpawnUnitContour(unit, enemy and "CombatEnemy" or "CombatAlly")
        ShowBadgeOfAttacker(unit, true)
        g_AIExecutionController.fallbackMoveTracking = true
        args.trackMove = true
      end
    end
    if args.trackMove then
      g_AIExecutionController.tracked_pois = g_AIExecutionController.tracked_pois or {}
      table.insert(g_AIExecutionController.tracked_pois, unit)
      return args.fallbackMove, true
    end
  end
end
function OnMsg.UnitMovementDone(unit, action_id)
  if g_AIExecutionController and action_id == "Move" and g_AIExecutionController.fallbackMoveTracking then
    g_AIExecutionController.tracked_pois = nil
    g_AIExecutionController.group_to_follow = nil
    g_AIExecutionController.track_group = nil
    g_AIExecutionController.fallbackMoveTracking = nil
    ClearAITurnContours(unit)
    ShowBadgeOfAttacker(unit, false)
  end
end
function RevealUnitBeforeMove(unit, args)
  local goto_pos = args.goto_pos
  local goto_stance = StancesList.Standing
  local step_pos_duplicated_arr = {}
  local pov_team = GetPoVTeam()
  for i = 1, #pov_team.units do
    table.insert(step_pos_duplicated_arr, goto_pos)
  end
  local los_any, result = CheckLOS(step_pos_duplicated_arr, pov_team.units)
  if los_any then
    for pi, pu in ipairs(pov_team.units) do
      if (result[pi] == 2 or result[pi] == 1 and goto_stance == StancesList.Standing) and pu:GetDist(goto_pos) <= pu:GetSightRadius(unit, nil, goto_pos) then
        NetSyncEvent("RevealToTeam", unit, table.find(g_Teams, pov_team))
        return true
      end
    end
  end
end
