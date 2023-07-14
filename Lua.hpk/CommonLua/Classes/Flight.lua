local FlightTile = const.FlightTile
local FlightScale = const.FlightScale
local efResting = const.efResting
local FlightDbgShow = empty_func
FlightDbgClear = empty_func
FlightDbgUpdate = empty_func
FlightDbgResults = empty_func
FlightDbgRecalc = empty_func
local pfFinished = const.pfFinished
local pfFailed = const.pfFailed
local pfTunnel = const.pfTunnel
local pfDestLocked = const.pfDestLocked
local pfSmartDestlockDist = const.pfSmartDestlockDist
local AngleDiff = AngleDiff
local Min, Max, Clamp = Min, Max, Clamp
local BS3_GetSplinePosDirCurve = BS3_GetSplinePosDirCurve
local BS3_GetSplineLength3D = BS3_GetSplineLength3D
local GetRollPitchYaw = CObject.GetRollPitchYaw
local SetRollPitchYaw = CObject.SetRollPitchYaw
local GetPitchYaw = GetPitchYaw
local GetFinalSpeedAndTime = CObject.GetFinalSpeedAndTime
local GetAccelerationAndTime = CObject.GetAccelerationAndTime
local GetVisualPosXYZ = CObject.GetVisualPosXYZ
local GetVisualDist = CObject.GetVisualDist
local GetVelocity = CObject.GetVelocity
local SetAnimSpeed = CObject.SetAnimSpeed
local SetState = CObject.SetState
local IsPassable = terrain.IsPassable
local HasFov = HasFov
local IsCloser = IsCloser
local GetStateName = GetStateName
local Equal2D = point20.Equal2D
local Point2DInside = empty_box.Point2DInside
local Intersect2D = empty_box.Intersect2D
local irInside = const.irInside
local InvalidZ = const.InvalidZ
local boxdiag = boxdiag
local developer = Platform.developer
local anim_min_time = 100
local time_ahead = 10
if not FlightTile then
  return
end
function FlightInitVars()
  FlightMap = false
  FlightEnergy = false
  FlightFrom = false
  FlightTo = false
  FlightFlags = 0
  FlightMarkFrom = false
  FlightMarkTo = false
  FlightMarkMinHeight = 0
  FlightMarkObjRadius = 0
  FlightFbox = false
  FlightEnergyMin = false
  FlightSlopePenalty = 0
  FlightTimestamp = -1
end
if FirstLoad then
  FlightInitVars()
end
function OnMsg.DoneMap()
  if FlightMap then
    FlightMap:free()
  end
  if FlightEnergy then
    FlightEnergy:free()
  end
  FlightInitVars()
end
DefineClass.FlyingObj = {
  __parents = {"SyncObject"},
  flags = {cofComponentInterpolation = true, cofComponentCurvature = true},
  properties = {
    {
      category = "Flight",
      id = "FlightMinPitch",
      name = "Pitch Min",
      editor = "number",
      default = -2700,
      scale = "deg",
      template = true
    },
    {
      category = "Flight",
      id = "FlightMaxPitch",
      name = "Pitch Max",
      editor = "number",
      default = 2700,
      scale = "deg",
      template = true
    },
    {
      category = "Flight",
      id = "FlightPitchSmooth",
      name = "Pitch Smooth",
      editor = "number",
      default = 100,
      min = 0,
      max = 500,
      scale = 100,
      slider = true,
      template = true,
      help = "Smooth the pitch angular speed changes"
    },
    {
      category = "Flight",
      id = "FlightMaxPitchSpeed",
      name = "Pitch Speed Limit (deg/s)",
      editor = "number",
      default = 5400,
      min = 0,
      max = 10800,
      scale = 60,
      slider = true,
      template = true,
      help = "Smooth the pitch angular speed changes"
    },
    {
      category = "Flight",
      id = "FlightSpeedToPitch",
      name = "Speed to Pitch",
      editor = "number",
      default = 100,
      min = 0,
      max = 100,
      scale = "%",
      slider = true,
      template = true,
      help = "How much the flight speed affects the pitch angle"
    },
    {
      category = "Flight",
      id = "FlightMaxRoll",
      name = "Roll Max",
      editor = "number",
      default = 2700,
      min = 0,
      max = 10800,
      scale = "deg",
      slider = true,
      template = true
    },
    {
      category = "Flight",
      id = "FlightMaxRollSpeed",
      name = "Roll Speed Limit (deg/s)",
      editor = "number",
      default = 5400,
      min = 0,
      max = 10800,
      scale = 60,
      slider = true,
      template = true,
      help = "Smooth the row angular speed changes"
    },
    {
      category = "Flight",
      id = "FlightRollSmooth",
      name = "Roll Smooth",
      editor = "number",
      default = 100,
      min = 0,
      max = 500,
      scale = 100,
      slider = true,
      template = true,
      help = "Smooth the row angular speed changes"
    },
    {
      category = "Flight",
      id = "FlightSpeedToRoll",
      name = "Speed to Roll",
      editor = "number",
      default = 0,
      min = 0,
      max = 100,
      scale = "%",
      slider = true,
      template = true,
      help = "How much the flight speed affects the roll angle"
    },
    {
      category = "Flight",
      id = "FlightYawSmooth",
      name = "Yaw Smooth",
      editor = "number",
      default = 100,
      min = 0,
      max = 500,
      scale = 100,
      slider = true,
      template = true,
      help = "Smooth the yaw angular speed changes"
    },
    {
      category = "Flight",
      id = "FlightMaxYawSpeed",
      name = "Yaw Speed Limit (deg/s)",
      editor = "number",
      default = 21600,
      min = 0,
      max = 43200,
      scale = 60,
      slider = true,
      template = true,
      help = "Smooth the yaw angular speed changes"
    },
    {
      category = "Flight",
      id = "FlightYawRotToRoll",
      name = "Yaw Rot to Roll",
      editor = "number",
      default = 100,
      min = 0,
      max = 300,
      scale = "%",
      slider = true,
      template = true,
      help = "Links the row angle to the yaw rotation speed"
    },
    {
      category = "Flight",
      id = "FlightYawRotFriction",
      name = "Yaw Rot Friction",
      editor = "number",
      default = 100,
      min = 0,
      max = 1000,
      scale = "%",
      slider = true,
      template = true,
      help = "Friction caused by 90 deg/s yaw rotation speed"
    },
    {
      category = "Flight",
      id = "FlightSpeedStop",
      name = "Speed Stop (m/s)",
      editor = "number",
      default = false,
      scale = guim,
      template = true,
      help = "Will use the min speed if not specified. Stopping is possible only if the deceleration distance is not zero"
    },
    {
      category = "Flight",
      id = "FlightSpeedMin",
      name = "Speed Min (m/s)",
      editor = "number",
      default = 6 * guim,
      scale = guim,
      template = true
    },
    {
      category = "Flight",
      id = "FlightSpeedMax",
      name = "Speed Max (m/s)",
      editor = "number",
      default = 15 * guim,
      scale = guim,
      template = true
    },
    {
      category = "Flight",
      id = "FlightFriction",
      name = "Friction",
      editor = "number",
      default = 30,
      min = 0,
      max = 300,
      slider = true,
      scale = "%",
      template = true,
      help = "Friction coefitient, affects the max achievable speed. Should be adjusted so that both the max speed and the achievable one are matching."
    },
    {
      category = "Flight",
      id = "FlightAccelMax",
      name = "Accel Max (m/s^2)",
      editor = "number",
      default = 10 * guim,
      scale = guim,
      template = true
    },
    {
      category = "Flight",
      id = "FlightDecelMax",
      name = "Decel Max (m/s^2)",
      editor = "number",
      default = 20 * guim,
      scale = guim,
      template = true
    },
    {
      category = "Flight",
      id = "FlightAccelDist",
      name = "Accel Dist",
      editor = "number",
      default = 20 * guim,
      scale = "m",
      template = true
    },
    {
      category = "Flight",
      id = "FlightDecelDist",
      name = "Decel Dist",
      editor = "number",
      default = 20 * guim,
      scale = "m",
      template = true
    },
    {
      category = "Flight",
      id = "FlightPathStepMax",
      name = "Path Step Max",
      editor = "number",
      default = 2 * guim,
      scale = "m",
      template = true,
      help = "Step dist at max speed"
    },
    {
      category = "Flight",
      id = "FlightPathStepMin",
      name = "Path Step Min",
      editor = "number",
      default = guim,
      scale = "m",
      template = true,
      help = "Step dist at min speed"
    },
    {
      category = "Flight",
      id = "FlightAnimStart",
      name = "Anim Fly Start",
      editor = "text",
      default = false,
      template = true
    },
    {
      category = "Flight",
      id = "FlightAnim",
      name = "Anim Fly",
      editor = "text",
      default = false,
      template = true
    },
    {
      category = "Flight",
      id = "FlightAnimDecel",
      name = "Anim Fly Decel",
      editor = "text",
      default = false,
      template = true
    },
    {
      category = "Flight",
      id = "FlightAnimStop",
      name = "Anim Fly Stop",
      editor = "text",
      default = false,
      template = true
    },
    {
      category = "Flight",
      id = "FlightAnimIdle",
      name = "Anim Fly Idle",
      editor = "text",
      default = false,
      template = true
    },
    {
      category = "Flight",
      id = "FlightAnimSpeedMin",
      name = "Anim Speed Min",
      editor = "number",
      default = 1000,
      min = 0,
      max = 1000,
      scale = 1000,
      slider = true,
      template = true
    },
    {
      category = "Flight",
      id = "FlightAnimSpeedMax",
      name = "Anim Speed Max",
      editor = "number",
      default = 1000,
      min = 1000,
      max = 3000,
      scale = 1000,
      slider = true,
      template = true
    },
    {
      category = "Flight",
      id = "FlightAnimStopFOV",
      name = "Anim Fly Stop FoV",
      editor = "number",
      default = 5400,
      min = 0,
      max = 21600,
      scale = "deg",
      slider = true,
      template = true,
      help = "Required FoV towards the target in order to switch to anim_stop/landing anim"
    },
    {
      category = "Flight Path",
      id = "FlightSimHeightMin",
      name = "Min Height",
      editor = "number",
      default = 3 * guim,
      min = guim,
      max = 50 * guim,
      slider = true,
      scale = "m",
      template = true,
      sim = true,
      help = "Min flight height. If below, the flying obj will try to go up (lift)."
    },
    {
      category = "Flight Path",
      id = "FlightSimHeightMax",
      name = "Max Height",
      editor = "number",
      default = 5 * guim,
      min = guim,
      max = 50 * guim,
      slider = true,
      scale = "m",
      template = true,
      sim = true,
      help = "Max flight height. If above, the flying obj will try to go down (weight)."
    },
    {
      category = "Flight Path",
      id = "FlightSimStayAboveMap",
      name = "Stay Above",
      editor = "bool",
      default = false,
      template = true,
      sim = true,
      help = "Avoid entering the height map. As the height map is not precise, this could lead to strange visual behavior."
    },
    {
      category = "Flight Path",
      id = "FlightSimSpeedLimit",
      name = "Speed Limit (m/s)",
      editor = "number",
      default = 10 * guim,
      min = 1,
      max = 50 * guim,
      slider = true,
      scale = guim,
      template = true,
      sim = true,
      help = "Max speed during simulation. Should be limited to ensure precision."
    },
    {
      category = "Flight Path",
      id = "FlightSimInertia",
      name = "Inertia",
      editor = "number",
      default = 100,
      min = 10,
      max = 1000,
      slider = true,
      exponent = 2,
      scale = 100,
      template = true,
      sim = true,
      help = "How inert is the object."
    },
    {
      category = "Flight Path",
      id = "FlightSimFrictionMinXY",
      name = "Friction Min XY",
      editor = "number",
      default = 20,
      min = 0,
      max = 300,
      slider = true,
      scale = "%",
      template = true,
      sim = true,
      help = "Horizontal friction min coefitient."
    },
    {
      category = "Flight Path",
      id = "FlightSimFrictionMaxXY",
      name = "Friction Max XY",
      editor = "number",
      default = 50,
      min = 0,
      max = 300,
      slider = true,
      scale = "%",
      template = true,
      sim = true,
      help = "Horizontal friction max coefitient."
    },
    {
      category = "Flight Path",
      id = "FlightSimFrictionZ",
      name = "Friction Z",
      editor = "number",
      default = 80,
      min = 0,
      max = 300,
      slider = true,
      scale = "%",
      template = true,
      sim = true,
      help = "Vertical friction coefitient."
    },
    {
      category = "Flight Path",
      id = "FlightSimAttract",
      name = "Attract",
      editor = "number",
      default = guim,
      min = 0,
      max = 30 * guim,
      slider = true,
      scale = 1000,
      template = true,
      sim = true,
      help = "Attraction force per energy unit difference. The force pushing the unit towards its final destination."
    },
    {
      category = "Flight Path",
      id = "FlightSimMaxAttract",
      name = "Max Attract",
      editor = "number",
      default = 10 * guim,
      min = 0,
      max = 30 * guim,
      slider = true,
      scale = 1000,
      template = true,
      sim = true,
      help = "Max attraction force."
    },
    {
      category = "Flight Path",
      id = "FlightSimLift",
      name = "Lift",
      editor = "number",
      default = guim / 3,
      min = 0,
      max = 30 * guim,
      slider = true,
      scale = 1000,
      template = true,
      sim = true,
      help = "Lift force per meter. The force trying to bring back UP the unit at its best height level."
    },
    {
      category = "Flight Path",
      id = "FlightSimMaxLift",
      name = "Max Lift",
      editor = "number",
      default = 10 * guim,
      min = 0,
      max = 30 * guim,
      slider = true,
      scale = 1000,
      template = true,
      sim = true,
      help = "Max lift force."
    },
    {
      category = "Flight Path",
      id = "FlightSimWeight",
      name = "Weight",
      editor = "number",
      default = guim / 3,
      min = 0,
      max = 20 * guim,
      slider = true,
      scale = 1000,
      template = true,
      sim = true,
      help = "Weight force per meter. The force trying to bring back DOWN the unit at its best height level."
    },
    {
      category = "Flight Path",
      id = "FlightSimMaxWeight",
      name = "Max Weight",
      editor = "number",
      default = 3 * guim,
      min = 0,
      max = 20 * guim,
      slider = true,
      scale = 1000,
      template = true,
      sim = true,
      help = "Max weight force."
    },
    {
      category = "Flight Path",
      id = "FlightSimMaxThrust",
      name = "Max Thrust",
      editor = "number",
      default = 10 * guim,
      min = 0,
      max = 50 * guim,
      slider = true,
      scale = 1000,
      template = true,
      sim = true,
      help = "Max cummulative thrust."
    },
    {
      category = "Flight Path",
      id = "FlightSimInterval",
      name = "Update Interval (ms)",
      editor = "number",
      default = 50,
      min = 1,
      max = 1000,
      slider = true,
      template = true,
      sim = true,
      help = "Simulation update interval. Lower values ensure better precision, but makes the sim more expensive"
    },
    {
      category = "Flight Path",
      id = "FlightSimMinStep",
      name = "Min Path Step",
      editor = "number",
      default = FlightTile / 2,
      min = 0,
      max = 100 * guim,
      scale = "m",
      slider = true,
      template = true,
      sim = true,
      help = "Min path step (approx)."
    },
    {
      category = "Flight Path",
      id = "FlightSimMaxStep",
      name = "Max Path Step",
      editor = "number",
      default = 8 * FlightTile,
      min = 0,
      max = 100 * guim,
      scale = "m",
      slider = true,
      template = true,
      sim = true,
      help = "Max path step (approx)."
    },
    {
      category = "Flight Path",
      id = "FlightSimDecelDist",
      name = "Decel Dist",
      editor = "number",
      default = 10 * guim,
      min = 1,
      max = 300 * guim,
      slider = true,
      scale = "m",
      template = true,
      sim = true,
      help = "At that distance to the target, the movement will try to go towards the target ignoring most considerations."
    },
    {
      category = "Flight Path",
      id = "FlightSimTransition",
      name = "Transition",
      editor = "number",
      default = 2000,
      min = 0,
      max = 10000,
      scale = "sec",
      slider = true,
      template = true,
      sim = true,
      help = "Used to smooth some transition effect when starting the movement."
    },
    {
      category = "Flight Path",
      id = "FlightSimLookAhead",
      name = "Look Ahead",
      editor = "number",
      default = 4000,
      min = 0,
      max = 10000,
      scale = "sec",
      slider = true,
      template = true,
      sim = true,
      help = "Give some time to adjust the flight height before reaching a too high obstacle."
    },
    {
      category = "Flight Path",
      id = "FlightSimSplineAlpha",
      name = "Spline Alpha",
      editor = "number",
      default = 1365,
      min = 0,
      max = 4096,
      scale = 4096,
      slider = true,
      template = true,
      sim = true,
      help = "Defines the spline smoothness."
    },
    {
      category = "Flight Path",
      id = "FlightSimSplineErr",
      name = "Spline Tolerance",
      editor = "number",
      default = FlightTile / 4,
      min = 0,
      max = FlightTile,
      scale = "m",
      slider = true,
      template = true,
      sim = true,
      help = "Max spline deviation form the precise trajectory. Lower values imply more path steps as the longer splines deviate stronger."
    },
    {
      category = "Flight Path",
      id = "FlightSimMaxIters",
      name = "Max Compute Iters",
      editor = "number",
      default = 131072,
      template = true,
      sim = true,
      help = "Max number of compute iterations. Used for a sanity check against infinite loops."
    },
    {
      category = "Flight Path",
      id = "FlightSlopePenalty",
      name = "Slope Penalty",
      editor = "number",
      default = 300,
      scale = "%",
      template = true,
      sim = true,
      min = 10,
      max = 1000,
      slider = true,
      exponent = 2,
      help = "How difficult it is to flight over against going around obstacles."
    },
    {
      category = "Flight Path",
      id = "FlightMinObstacleHeight",
      name = "Min Obstacle Height",
      editor = "number",
      default = 0,
      scale = "m",
      template = true,
      sim = true,
      help = "Ignored obstacle height."
    },
    {
      category = "Flight Path",
      id = "FlightObjRadius",
      name = "Object Radius",
      editor = "number",
      default = 0,
      scale = "m",
      template = true,
      sim = true,
      help = "To consider when avoiding obstacles."
    }
  },
  flight_target = false,
  flight_path = false,
  flight_path_partial = false,
  flight_path_collision = false,
  flight_spline_idx = 1,
  flight_spline_dist = 0,
  flight_spline_len = 0,
  flight_spline_time = 0,
  flight_stop_on_passable = false,
  flight_flags = 0,
  flight_dbg_enable = false,
  ResolveFlightTarget = pf.ResolveGotoTargetXYZ
}
local ffpAdjustZ = const.ffpAdjustZ
function FlyingObj:SetAdjustTargetZ(adjust)
  if adjust then
    self.flight_flags = self.flight_flags | ffpAdjustZ
  else
    self.flight_flags = self.flight_flags & ~ffpAdjustZ
  end
end
function FlyingObj:GetAdjustTargetZ()
  return self.flight_flags & ffpAdjustZ ~= 0
end
function FlyingObj:FlightStop()
  if self:TimeToPosInterpolationEnd() == 0 then
    return
  end
  local a = -self.FlightDecelMax
  local x, y, z, dt0 = self:GetFinalPosAndTime(0, a)
  if not x then
    return
  end
  self:SetPos(x, y, z, dt0)
  self:SetAcceleration(a)
end
function FlyingObj:FindFlightPath(target)
  if not IsValidPos(target) then
    return
  end
  local path, partial, collision_pos = FlightCalcPathBetween(self, target, self.flight_flags, self.FlightMinObstacleHeight, self.FlightObjRadius, self.FlightSlopePenalty)
  if not path then
    return
  end
  self.flight_path = path
  self.flight_path_partial = partial
  self.flight_path_collision = collision_pos
  self.flight_target = target
  self.flight_spline_idx = nil
  self.flight_spline_dist = nil
  self.flight_spline_len = nil
  self.flight_spline_time = nil
  return path, partial, collision_pos
end
function FlyingObj:RecalcFlightPath()
  return self:FindFlightPath(self.flight_target)
end
function FlyingObj:MarkFlightArea(target)
  return FlightMarkBetween(self, target, self.FlightMinObstacleHeight, self.FlightObjRadius)
end
function FlyingObj:LockFlightDest(x, y, z)
  return x, y, z
end
FlyingObj.UnlockFlightDest = empty_func
function FlyingObj:GetPathHash(seed)
  local flight_path = self.flight_path
  if not flight_path or #flight_path == 0 then
    return
  end
  local start_idx = self.flight_spline_idx
  local spline = flight_path[start_idx]
  local hash = xxhash(seed, spline[1], spline[2], spline[3], spline[4])
  for i = start_idx + 1, #flight_path do
    spline = flight_path[i]
    hash = xxhash(hash, spline[2], spline[3], spline[4])
  end
  return hash
end
function FlyingObj:Step(pt, ...)
  local fx, fy, fz, max_dist = self:ResolveFlightTarget(pt, ...)
  local tx, ty, tz = self:LockFlightDest(fx, fy, fz)
  if not tx then
    return pfFailed
  end
  local visual_z = ResolveZ(tx, ty, tz)
  if self:IsCloser(tx, ty, visual_z, max_dist + 1) then
    if max_dist == 0 then
      self:SetPos(tx, ty, tz)
    end
    fz = fz or InvalidZ
    tz = tz or InvalidZ
    if fx ~= tx or fy ~= ty or fz ~= tz then
      return pfDestLocked
    end
    return pfFinished
  end
  local path = self.flight_path
  local flight_target = self.flight_target
  local find_path = not path or not flight_target
  local time_now = GameTime()
  local spline_idx, spline_dist, spline_len
  local same_target = flight_target and flight_target:Equal(tx, ty, tz)
  if not find_path and not same_target then
    local error_dist = flight_target:Dist(tx, ty, tz)
    local retarget_offset_pct = 30
    local threshold_dist = error_dist * 100 / retarget_offset_pct
    local speed = self:GetVelocity()
    if 0 < speed then
      local min_retarget_time = 3000
      threshold_dist = Min(threshold_dist, speed * min_retarget_time / 1000)
    end
    local x, y, z = ResolveXYZ(flight_target)
    find_path = self:IsCloser(x, y, z, 1 + threshold_dist)
  end
  local step_finished
  if find_path then
    flight_target = point(tx, ty, tz)
    path = self:FindFlightPath(flight_target)
    if not path then
      return pfFailed
    end
    spline_idx = 0
    spline_dist = 0
    spline_len = 0
    step_finished = true
    same_target = true
  else
    spline_idx = self.flight_spline_idx
    spline_dist = self.flight_spline_dist
    spline_len = self.flight_spline_len
    step_finished = 0 <= time_now - self.flight_spline_time
  end
  if not same_target then
    tx, ty, tz = flight_target:xyz()
    visual_z = ResolveZ(tx, ty, tz)
  end
  local spline, last_step
  if spline_dist < spline_len or not step_finished then
    spline = path[spline_idx]
  else
    while spline_dist >= spline_len do
      spline_idx = spline_idx + 1
      spline = path[spline_idx]
      if not spline then
        return pfFailed
      end
      spline_dist = 0
      spline_len = BS3_GetSplineLength3D(spline)
    end
    self.flight_spline_idx = spline_idx
    self.flight_spline_len = spline_len
  end
  if not spline then
    return pfFailed
  end
  local speed_min, speed_max, speed_stop = self.FlightSpeedMin, self.FlightSpeedMax, self.FlightSpeedStop
  local v0 = GetVelocity(self)
  if step_finished then
    local min_step, max_step = self.FlightPathStepMin, self.FlightPathStepMax
    local spline_step
    if speed_min >= v0 then
      spline_step = min_step
    elseif speed_max <= v0 then
      spline_step = max_step
    else
      spline_step = min_step + (max_step - min_step) * (v0 - speed_min) / (speed_max - speed_min)
    end
    spline_step = Min(spline_step, spline_len)
    spline_dist = spline_dist + spline_step
    if spline_len < spline_dist + spline_step / 2 then
      spline_dist = spline_len
      last_step = spline_idx == #path
    end
    self.flight_spline_dist = spline_dist
  end
  speed_stop = speed_stop or speed_min
  local max_roll, roll_max_speed = self.FlightMaxRoll, self.FlightMaxRollSpeed
  local pitch_min, pitch_max = self.FlightMinPitch, self.FlightMaxPitch
  local yaw_max_speed, pitch_max_speed = self.FlightMaxYawSpeed, self.FlightMaxPitchSpeed
  local decel_dist = self.FlightDecelDist
  local remaining_len = spline_len - spline_dist
  local anim_stop
  local fly_anim = self.FlightAnim
  local x0, y0, z0 = GetVisualPosXYZ(self)
  local speed_lim = speed_max
  local x, y, z, dirx, diry, dirz, curvex, curvey, curvez, roll, pitch, yaw, accel, v, dt
  local max_dt = max_int
  if 0 < decel_dist and self:IsCloser(tx, ty, visual_z, decel_dist) then
    fly_anim = self.FlightAnimDecel or fly_anim
    local fly_anim_stop = self.FlightAnimStop
    if fly_anim and fly_anim_stop and HasFov(self, tx, ty, visual_z, self.FlightAnimStopFOV) and (not self.flight_stop_on_passable or self:CheckPassable(flight_target)) then
      dt = GetAnimDuration(self:GetEntity(), fly_anim_stop)
      x, y, z, dirx, diry, dirz = BS3_GetSplinePosDir(path[#path], 4096)
      accel, v = self:GetAccelerationAndFinalSpeed(x, y, z, dt)
      if 0 < v and v <= Max(v0, speed_min) then
        anim_stop = true
        if dirx == 0 and diry == 0 then
          dirx, diry = x - x0, y - y0
        end
        yaw = atan(diry, dirx)
        roll, pitch = 0, 0
        SetState(self, fly_anim_stop)
        SetAnimSpeed(self, 1, 1000)
      end
    end
    if not anim_stop then
      local total_remaining_len = remaining_len
      for i = spline_idx + 1, #path do
        local spline_i = path[i]
        total_remaining_len = total_remaining_len + BS3_GetSplineLength3D(spline_i)
      end
      if decel_dist > total_remaining_len then
        speed_lim = speed_stop + (speed_max - speed_stop) * total_remaining_len / decel_dist
      end
    end
  end
  if not anim_stop then
    local roll0, pitch0, yaw0 = GetRollPitchYaw(self)
    x, y, z, dirx, diry, dirz, curvex, curvey, curvez = BS3_GetSplinePosDirCurve(spline, spline_dist, spline_len)
    if dirx == 0 and diry == 0 and dirz == 0 then
      dirx, diry, dirz = x - x0, y - y0, z - z0
    end
    pitch, yaw = GetPitchYaw(dirx, diry, dirz)
    pitch, yaw = pitch or pitch0, yaw or yaw0
    local step_len = GetVisualDist(self, x, y, z)
    local friction = self.FlightFriction
    local dyaw = AngleDiff(yaw, yaw0) * 100 / (100 + self.FlightYawSmooth)
    dt = 0 < v0 and MulDivRound(1000, step_len, v0) or 0
    local yaw_rot_est = dt == 0 and 0 or Clamp(1000 * dyaw / dt, -yaw_max_speed, yaw_max_speed)
    if yaw_rot_est ~= 0 then
      friction = friction + MulDivRound(self.FlightYawRotFriction, abs(yaw_rot_est), 5400)
    end
    local speed_to_roll, speed_to_pitch = self.FlightSpeedToRoll, self.FlightSpeedToPitch
    local accel_max = self.FlightAccelMax
    local accel0 = accel_max - v0 * friction / 100
    v, dt = GetFinalSpeedAndTime(self, x, y, z, accel0, v0)
    v = v or speed_min
    v = Min(v, speed_lim)
    v = Max(v, Min(speed_min, v0))
    local at_max_speed = v == speed_max
    accel, dt = GetAccelerationAndTime(self, x, y, z, v)
    if not at_max_speed and 0 < speed_to_pitch then
      local mod_pitch = pitch * v / speed_max
      if speed_to_pitch == 100 then
        pitch = mod_pitch
      else
        pitch = pitch + (mod_pitch - pitch) * speed_to_pitch / 100
      end
    end
    pitch = Clamp(pitch, pitch_min, pitch_max)
    local dpitch = AngleDiff(pitch, pitch0) * 100 / (100 + self.FlightPitchSmooth)
    local pitch_rot = 0 < dt and Clamp(1000 * dpitch / dt, -pitch_max_speed, pitch_max_speed) or 0
    local yaw_rot = 0 < dt and Clamp(1000 * dyaw / dt, -yaw_max_speed, yaw_max_speed) or 0
    roll = -yaw_rot * self.FlightYawRotToRoll / 100
    if not at_max_speed and 0 < speed_to_roll then
      local mod_roll = roll * v / speed_max
      if speed_to_roll == 100 then
        roll = mod_roll
      else
        roll = roll + (mod_roll - roll) * speed_to_roll / 100
      end
    end
    roll = Clamp(roll, -max_roll, max_roll)
    local droll = AngleDiff(roll, roll0) * 100 / (100 + self.FlightRollSmooth)
    local roll_rot = 0 < dt and Clamp(1000 * droll / dt, -roll_max_speed, roll_max_speed) or 0
    if 0 < dt then
      droll = roll_rot * dt / 1000
      dyaw = yaw_rot * dt / 1000
      dpitch = pitch_rot * dt / 1000
    end
    roll = roll0 + droll
    yaw = yaw0 + dyaw
    pitch = pitch0 + dpitch
    if fly_anim then
      local anim = GetStateName(self)
      if anim ~= fly_anim then
        local fly_anim_start = self.FlightAnimStart
        if anim ~= fly_anim_start then
          SetState(self, fly_anim_start)
        else
          local remaining_time = self:TimeToAnimEnd()
          if remaining_time > anim_min_time then
            max_dt = remaining_time
          else
            SetState(self, fly_anim)
          end
        end
      else
        local min_anim_speed, max_anim_speed = self.FlightAnimSpeedMin, self.FlightAnimSpeedMax
        if 0 < dt and min_anim_speed < max_anim_speed then
          local curve = Max(GetLen(curvex, curvey, curvez), 1)
          local coef = 1024 + 1024 * curvez / curve + 1024 * abs(accel0) / accel_max
          local anim_speed = min_anim_speed + (max_anim_speed - min_anim_speed) * Clamp(coef, 0, 2048) / 2048
          SetAnimSpeed(self, 1, anim_speed)
        end
      end
    end
  end
  SetRollPitchYaw(self, roll, pitch, yaw, dt)
  self:SetPos(x, y, z, dt)
  self:SetAcceleration(accel)
  if not last_step and not anim_stop and dt > time_ahead then
    dt = dt - time_ahead
  end
  self.flight_spline_time = time_now + dt
  local sleep = Min(dt, max_dt)
  return sleep
end
function FlyingObj:ClearPath()
  self.flight_path = false
  self.flight_path_partial = false
  self.flight_path_collision = false
  self.flight_target = false
  self.flight_spline_idx = 1
  self.flight_flags = 0
  self:UnlockFlightDest()
end
function FlyingObj:Done()
  self:UnlockFlightDest()
end
function FlyingObj:ResetOrientation(time)
  local _, _, yaw = GetRollPitchYaw(self)
  SetRollPitchYaw(self, 0, 0, yaw, time)
end
function FlyingObj:Face(target, time)
  local pitch, yaw = GetPitchYaw(self, target)
  SetRollPitchYaw(self, 0, pitch, yaw, time)
end
function FlyingObj:GetFinalFlightPosDir()
  local path = self.flight_path
  local last_spline = path and path[#path]
  if not last_spline then
    return
  end
  return last_spline[4], last_spline[4] - last_spline[3]
end
function FlightGetHeightAt(...)
  local fh
  local flight_map, flight_box = FlightMap, FlightFbox
  if flight_map and flight_box then
    fh = FlightGetHeight(flight_map, flight_box, ...)
  end
  if fh then
    return fh, true
  end
  return terrain.GetHeight(...)
end
function FlyingObj:CanFallAt(...)
  return self:CheckPassable(...)
end
function FlyingObj:GetFallPos()
  if not self.flying then
    return self:GetPosXYZ()
  end
  local x0, y0, z0 = GetVisualPosXYZ(self)
  local vx, vy, vz = self:GetVelocityVectorXYZ()
  local gravity = const.Gravity
  local fall_time = self:GetGravityFallTime(z0, vz, gravity)
  local GetHeight = terrain.GetHeight
  local h = GetHeight(x0, y0)
  if z0 <= h or fall_time <= 0 then
    if not self:CanFallAt(x0, y0, InvalidZ) then
      return
    end
    return x0, y0
  end
  local dx, dy = vx * fall_time / 1000, vy * fall_time / 1000
  local x1, y1 = x0 + dx, y0 + dy
  local flight_fbox = self:MarkFlightArea(point(x1, y1))
  if not flight_fbox then
    return
  end
  local FindPassableZ = terrain.FindPassableZ
  local FlightGetHeight = FlightGetHeight
  local flight_map = FlightMap
  local dist = GetLen(dx, dy)
  local step = const.PassTileSize
  local x, y, z, t = x0, y0, z0, 0
  local steps = dist / step
  local k = 0
  local pfclass = self.pfclass
  while true do
    local th = GetHeight(x, y)
    local h = FlightGetHeight(flight_map, flight_fbox, x, y) or th
    if z <= h + FlightScale / 2 then
      local tol = abs(z - h) + FlightScale
      local z_pass = FindPassableZ(x, y, z, pfclass, tol)
      if not (z_pass and self:CanFallAt(x, y, z_pass)) then
        break
      end
      local z_visual_pass = z_pass == InvalidZ and th or z_pass
      t = self:GetGravityFallTime(z0 - z_visual_pass, vz, gravity)
      return x, y, z_pass, t
    end
    if k == steps then
      break
    end
    k = k + 1
    t = fall_time * k / steps
    x = x0 + vx * t / 1000
    y = y0 + vy * t / 1000
    z = z0 + (vz - gravity * t / 2000) * t / 1000
  end
end
DefineClass.FlyingMovable = {
  __parents = {"FlyingObj", "Movable"},
  properties = {
    {
      category = "Flight",
      id = "FlightWalkRadius",
      name = "Walk Radius",
      editor = "number",
      default = 32 * guim,
      scale = "m",
      template = true,
      help = "Defines the max area where to use walking"
    },
    {
      category = "Flight",
      id = "FlightWalkExcess",
      name = "Walk To Fly Excess",
      editor = "number",
      default = 30,
      scale = "%",
      min = 0,
      template = true,
      help = "How much longer should be the walk path to prefer flying"
    }
  },
  flying = false,
  flight_stop_on_passable = true
}
function FlyingMovable:OnMoved()
  if not self:GetPos():IsValidZ() then
    self:SetFlying(false)
  end
end
function FlyingMovable:SetFlying(flying)
  flying = flying or false
  if self.flying == flying then
    return
  end
  self:ClearPath()
  if not flying then
    self:SetAcceleration(0)
    self:SetAnimSpeed(1, 1000)
    self:ResetOrientation(0)
    self:UnlockFlightDest()
    self:SetEnumFlags(efResting)
  else
    self:ClearEnumFlags(efResting)
  end
  self.flying = flying
  self:OnFlyingChanged(flying)
end
FlyingMovable.OnFlyingChanged = empty_func
FlyingMovable.CanFlyTo = return_true
function FlyingMovable:PrepareToMove(dest, ...)
  if self.flying then
    return
  end
  local walk_radius = self.FlightWalkRadius
  if walk_radius then
    local tx, ty, tz = self:ResolveFlightTarget(dest, ...)
    if self:CanFlyTo(tx, ty, tz) then
      if tx and not self:IsCloser2D(tx, ty, walk_radius) then
        self:SetFlying(true)
        return
      end
      self:RestrictArea(walk_radius)
    end
  end
end
function FlyingMovable:OnStopMoving()
  if self.flying and IsPassable(self) then
    self:SetFlying(false)
  end
end
function FlyingMovable:Step(...)
  if not self.flying then
    local status = Movable.Step(self, ...)
    local walk_excess = self.FlightWalkExcess
    if not walk_excess or status == pfFinished then
      return status
    end
    local tx, ty, tz = self:ResolveFlightTarget(...)
    if not self:CanFlyTo(tx, ty, tz) then
      return status
    end
    if (0 <= status or status == pfTunnel) and not self:IsPathPartial() then
      local len = self:GetPathLen("3D")
      if len == 0 then
        return status
      end
      local last = self:GetPathPoint(1)
      local dist = self:GetVisualDist(last)
      if len < dist * (100 + walk_excess) then
        return status
      end
    end
    self:SetFlying(true)
  end
  return FlyingObj.Step(self, ...)
end
function FlyingMovable:ClearPath()
  if self.flying then
    return FlyingObj.ClearPath(self)
  end
  return Movable.ClearPath(self)
end
function FlyingMovable:GetPathHash(seed)
  if self.flying then
    return FlyingObj.GetPathHash(self, seed)
  end
  return Movable.GetPathHash(self, seed)
end
function FlyingMovable:LockFlightDest(x, y, z)
  local visual_z = ResolveZ(x, y, z)
  if not visual_z then
    return
  end
  if not (not self.outside_pathfinder and self:IsCloser(x, y, visual_z, pfSmartDestlockDist) and self:CheckPassable(x, y, z)) or PlaceDestlock(self, x, y, z) then
    return x, y, z
  end
  local flight_target = self.flight_target
  if not flight_target or flight_target:Equal(x, y, z) or not PlaceDestlock(self, flight_target) then
    flight_target = terrain.FindReachable(x, y, z, const.tfrPassClass, self, const.tfrCanDestlock, self)
    if not flight_target then
      return
    end
    local destlocked = PlaceDestlock(self, flight_target)
  end
  return flight_target:xyz()
end
function FlyingMovable:UnlockFlightDest()
  if IsValid(self) then
    return self:RemoveDestlock()
  end
end
function FlyingMovable:TryLand()
  if not self.flying then
    return
  end
  local z = terrain.FindPassableZ(self, 32 * guim)
  if not z then
    return
  end
  local visual_z = z == InvalidZ and terrain.GetHeight(self) or z
  local x, y, z0 = self:GetVisualPosXYZ()
  self:SetState("fly_to_Hover")
  local dt = self:GetAnimDuration("fly_to_Hover")
  self:SetPos(x, y, visual_z, dt)
  self:SetAcceleration(0)
  self:ResetOrientation(dt)
  self:SetAnimSpeed(1, 1000)
  Sleep(dt)
  self:SetPos(x, y, z)
  self:SetFlying(false)
  self:SetState("walk")
end
function FlyingMovable:TakeOff()
  local x, y, z0 = self:GetVisualPosXYZ()
  local z = z0 + self.FlightSimHeightMin
  self:SetState("hover_to_Fly")
  local dt = self:GetAnimDuration("hover_to_Fly")
  self:SetPos(x, y, z, dt)
  self:SetAcceleration(0)
  Sleep(dt)
  self:SetFlying(true)
  self:SetState("fly")
end
function FlyingMovable:Face(target, time)
  if self.flying then
    return FlyingObj.Face(self, target, time)
  end
  return Movable.Face(self, target, time)
end
local efFlightObstacle = const.efFlightObstacle
DefineClass.FlightObstacle = {
  __parents = {"CObject"},
  flags = {cofComponentFlightObstacle = true, efFlightObstacle = true}
}
function FlightObstacle:FlightInitObstacle()
end
function FlightObstacle:InitElementConstruction()
  self:ClearEnumFlags(efFlightObstacle)
end
function FlightObstacle:CompleteElementConstruction()
  if self:GetComponentFlags(const.cofComponentFlightObstacle) == 0 then
    return
  end
  self:SetEnumFlags(efFlightObstacle)
  self:FlightInitObstacle()
end
function FlightInitGrids()
  local flight_map, energy_map = FlightMap, FlightEnergy
  if not flight_map then
    flight_map, energy_map = FlightCreateGrids(mapdata.PassBorder)
    FlightMap, FlightEnergy = flight_map, energy_map
  end
  return flight_map, energy_map
end
function FlightMarkBetween(ptFrom, ptTo, min_height, obj_radius)
  min_height = min_height or 0
  obj_radius = obj_radius or 0
  local fbox = FlightFbox
  local now = GameTime()
  if not (fbox and FlightMap and IsValidPos(FlightMarkFrom) and IsValidPos(FlightMarkTo)) or FlightTimestamp ~= now or FlightMarkMinHeight ~= min_height or FlightMarkObjRadius ~= obj_radius or Intersect2D(boxdiag(FlightMarkFrom, FlightMarkTo), boxdiag(ptFrom, ptTo)) ~= irInside then
    local flight_map = FlightInitGrids()
    fbox = FlightMarkObstacles(flight_map, ptFrom, ptTo, min_height, obj_radius)
    if not fbox then
      return
    end
    FlightEnergyMin = false
    FlightMarkMinHeight, FlightMarkObjRadius = min_height, obj_radius
    FlightMarkFrom, FlightMarkTo = ptFrom, ptTo
    FlightFbox = fbox or false
    FlightTimestamp = now
  end
  return fbox
end
function FlightCalcEnergyTo(ptTo, fbox, slope_penalty)
  fbox = fbox or FlightFbox
  slope_penalty = slope_penalty or 0
  if not FlightEnergyMin or FlightFbox ~= fbox or FlightSlopePenalty ~= slope_penalty or not Equal2D(FlightEnergyMin, GameToFlight(ptTo)) then
    FlightEnergyMin = FlightCalcEnergy(FlightMap, FlightEnergy, ptTo, fbox, slope_penalty) or false
    FlightSlopePenalty = slope_penalty
    if not FlightEnergyMin then
      return
    end
  end
  return true
end
local flight_default_flags = const.ffpSplines | const.ffpPhysics
local FlightIsDebug = function(obj)
  return obj == SelectedObj or IsValid(obj) and obj.flight_dbg_enable
end
function FlightCalcPathBetween(ptFrom, ptTo, flags, min_height, obj_radius, slope_penalty)
  local fbox = FlightMarkBetween(ptFrom, ptTo, min_height, obj_radius)
  if not fbox then
    return
  end
  if not FlightCalcEnergyTo(ptTo, fbox, slope_penalty) then
    return
  end
  flags = flags or 0
  FlightFrom, FlightTo, FlightFlags = ptFrom, ptTo, flags
  flags = flags | flight_default_flags
  if FlightIsDebug(ptFrom) then
    flags = flags | const.ffpDebug
  end
  local splines, partial, collision_pos = FlightFindPath(ptFrom, ptTo, FlightMap, FlightEnergy, fbox, flags)
  return splines, partial, collision_pos
end
function FlightInitObstacles()
  local _, max_surf_radius = GetMapMaxObjRadius()
  local ebox = GetPlayBox():grow(max_surf_radius)
  MapForEach(ebox, efFlightObstacle, function(obj)
    return obj:FlightInitObstacle()
  end)
end
function FlightInitObstaclesList(objs)
  local GetEnumFlags = CObject.GetEnumFlags
  for _, obj in ipairs(objs) do
    if GetEnumFlags(obj, efFlightObstacle) ~= 0 then
      obj:FlightInitObstacle(obj)
    end
  end
end
function OnMsg.NewMap()
  SuspendProcessing("FlightInitObstacle", "MapLoading", true)
end
function OnMsg.PostNewMapLoaded()
  ResumeProcessing("FlightInitObstacle", "MapLoading", true)
  if not mapdata.GameLogic then
    return
  end
  FlightInitObstacles()
end
function OnMsg.PrefabPlaced(name, objs)
  if not mapdata.GameLogic or IsProcessingSuspended("FlightInitObstacle") then
    return
  end
  FlightInitObstaclesList(objs)
end
function GetSplineParams(start_pos, start_speed, end_pos, end_speed)
  local v0 = start_speed:Len()
  local v1 = end_speed:Len()
  local dist = start_pos:Dist(end_pos)
  local pa = 3 <= dist and 0 < v0 and start_pos + SetLen(start_speed, dist / 3) or start_pos
  local pb = 3 <= dist and 0 < v1 and end_pos - SetLen(end_speed, dist / 3) or end_pos
  local spline = {
    start_pos,
    pa,
    pb,
    end_pos
  }
  local len = Max(BS3_GetSplineLength3D(spline), 1)
  local time_est = MulDivRound(1000, 2 * len, v1 + v0)
  return spline, len, v0, v1, time_est
end
function WaitFollowSpline(obj, spline, len, v0, v1, step_time, min_step, max_step, orient, yaw_to_roll_pct)
  if not IsValid(obj) then
    return
  end
  len = len or S3_GetSplineLength3D(spline)
  v0 = v0 or obj:GetVelocityVector()
  v1 = v1 or v0
  step_time = step_time or 50
  min_step = min_step or Max(1, len / 100)
  max_step = max_step or Max(min_step, len / 10)
  local roll, pitch, yaw, yaw0 = 0
  if orient and (yaw_to_roll_pct or 0) ~= 0 then
    roll, pitch, yaw0 = obj:GetRollPitchYaw()
  end
  local v = v0
  local dist = 0
  while true do
    local step = Clamp(step_time * v / 1000, min_step, max_step)
    dist = dist + step
    if dist > len - step / 2 then
      dist = len
    end
    local x, y, z, dirx, diry, dirz = BS3_GetSplinePosDir(spline, dist, len)
    v = v0 + (v1 - v0) * dist / len
    local accel, dt = obj:GetAccelerationAndTime(x, y, z, v)
    if orient then
      pitch, yaw = GetPitchYaw(dirx, diry, dirz)
      if yaw0 then
        roll = 10 * AngleDiff(yaw, yaw0) * yaw_to_roll_pct / dt
        yaw0 = yaw
      end
      obj:SetRollPitchYaw(roll, pitch, yaw, dt)
    end
    obj:SetPos(x, y, z, dt)
    obj:SetAcceleration(accel)
    if dist == len then
      Sleep(dt)
      break
    end
    Sleep(dt - dt / 10)
  end
  if IsValid(obj) then
    obj:SetAcceleration(0)
  end
end
SavegameFixups.FlightInitObstacles2 = FlightInitObstacles
if developer then
  local getters = {
    FlightSimMaxSpeedXY = function(self)
      local a = self:GetProperty("FlightSimMaxAttract")
      local cf = self:GetProperty("FlightSimFrictionMinXY")
      return 0 < cf and 100 * a / cf or max_int
    end,
    FlightSimMaxSpeedUp = function(self)
      local a = self:GetProperty("FlightSimMaxLift")
      local cf = self:GetProperty("FlightSimFrictionZ")
      return 0 < cf and 100 * a / cf or max_int
    end,
    FlightSimMaxSpeedDown = function(self)
      local a = self:GetProperty("FlightSimMaxWeight")
      local cf = self:GetProperty("FlightSimFrictionZ")
      return 0 < cf and 100 * a / cf or max_int
    end,
    FlightPathIntervalMinStep = function(self)
      return 1000 * self:GetProperty("FlightPathStepMin") / self:GetProperty("FlightSpeedMin")
    end,
    FlightPathIntervalMaxStep = function(self)
      return 1000 * self:GetProperty("FlightPathStepMax") / self:GetProperty("FlightSpeedMax")
    end,
    FlightAchievableSpeed = function(self)
      local a = self:GetProperty("FlightAccelMax")
      local cf = self:GetProperty("FlightFriction")
      return 0 < cf and 100 * a / cf or max_int
    end
  }
  function _ENV:getter(prop)
    local func = getters[prop]
    if func then
      return func(self)
    end
  end
  local props = {
    {
      category = "Flight Path",
      id = "FlightSimMaxSpeedXY",
      name = "Max Speed XY",
      editor = "number",
      default = 0,
      scale = guim,
      getter = getter,
      read_only = true,
      dont_save = true,
      template = true,
      developer = true
    },
    {
      category = "Flight Path",
      id = "FlightSimMaxSpeedUp",
      name = "Max Speed Up",
      editor = "number",
      default = 0,
      scale = guim,
      getter = getter,
      read_only = true,
      dont_save = true,
      template = true,
      developer = true
    },
    {
      category = "Flight Path",
      id = "FlightSimMaxSpeedDown",
      name = "Max Speed Down",
      editor = "number",
      default = 0,
      scale = guim,
      getter = getter,
      read_only = true,
      dont_save = true,
      template = true,
      developer = true
    },
    {
      category = "Flight",
      id = "FlightAchievableSpeed",
      name = "Achievable Speed (m/s)",
      editor = "number",
      default = 0,
      scale = guim,
      getter = getter,
      read_only = true,
      dont_save = true,
      template = true,
      developer = true
    },
    {
      category = "Flight",
      id = "FlightPathIntervalMinStep",
      name = "Path Interval Min Step (ms)",
      editor = "number",
      default = 0,
      getter = getter,
      read_only = true,
      dont_save = true,
      template = true,
      developer = true
    },
    {
      category = "Flight",
      id = "FlightPathIntervalMaxStep",
      name = "Path Interval Max Step (ms)",
      editor = "number",
      default = 0,
      getter = getter,
      read_only = true,
      dont_save = true,
      template = true,
      developer = true
    }
  }
  for _, prop in ipairs(props) do
    FlyingObj["Get" .. prop.id] = getters[prop.id]
  end
  table.iappend(FlyingObj.properties, props)
  local setter = function(self, value, prop_id, prop_meta)
    self[prop_id] = value
    if FlightFrom and IsKindOf(FlightFrom, "FlyingObj") then
      FlightFrom[prop_id] = value
      FlightDbgRecalc()
    end
  end
  for _, prop_meta in ipairs(FlyingObj.properties) do
    if prop_meta.sim and not prop_meta.read_only and not prop_meta.setter then
      prop_meta.setter = setter
    end
  end
  function FlyingObj:OnEditorSetProperty(prop_id, old_value, ged)
    local prop_meta = self:GetPropertyMetadata(prop_id) or empty_table
    if prop_meta.sim then
      self:RecalcFlightPath()
    end
  end
  function FlightDbgRecalc()
    if not FlightFrom then
      return
    end
    FlightCalcPathBetween(FlightFrom, FlightTo, FlightFlags, FlightMarkMinHeight, FlightMarkObjRadius, FlightSlopePenalty)
  end
  function FlightDbgAdd(obj)
    if not obj then
      return
    end
    return CreateGameTimeThread(function(obj)
      WaitMsg("FlightDbgClear")
      if IsValid(obj) then
        DoneObject(obj)
      elseif IsValidThread(obj) then
        DeleteThread(obj)
      end
    end, obj)
  end
  function FlightDbgClear()
    Msg("FlightDbgClear")
  end
  local AppendTileVerticesLinelist = function(v_pstr, x, y, z, mark_tile, mark_color, offset_z, get_height)
    offset_z = offset_z or 0
    z = z or InvalidZ
    local d = mark_tile / 2
    local tile_box = box(x - d, y - d, x + d, y + d)
    local pts = {
      tile_box:ToPoints2D()
    }
    pts[#pts + 1] = pts[1]
    get_height = get_height or terrain.GetHeight
    local AppendVertex = v_pstr.AppendVertex
    for i = 1, 4 do
      local x1, y1 = pts[i]:xy()
      local x2, y2 = pts[i + 1]:xy()
      local z1 = (z == InvalidZ and get_height(x1, y1) or z) + offset_z
      local z2 = (z == InvalidZ and get_height(x2, y2) or z) + offset_z
      AppendVertex(v_pstr, x1, y1, z1, mark_color)
      AppendVertex(v_pstr, x2, y2, z2, mark_color)
    end
  end
  function FlightDbgUpdate(obj, splines)
    FlightDbgClear()
    splines = splines or obj and obj.flight_path
    if obj then
      if not splines then
        return
      end
      if obj ~= FlightFrom then
        FlightDbgShow({
          splines = splines,
          spline_color = cyan,
          spline_color_alt = blue
        })
        return
      end
    end
    local energy_map = FlightEnergyMin and FlightEnergy
    local flight_map = FlightMap
    local memory = FlightFrom and FlightTo
    FlightDbgShow({
      fbox = FlightFbox,
      path_from = FlightFrom,
      path_to = FlightTo,
      energy_min = FlightEnergyMin,
      energy_map = energy_map,
      flight_map = flight_map,
      show_points = true,
      splines = splines,
      spline_color = cyan,
      spline_color_alt = blue
    })
  end
  function FlightDbgResults(splines, partial, fbox)
    local should_debug = FlightIsDebug(FlightFrom)
    if not should_debug then
      return
    end
    if not config.DebugFlight then
      FlightDbgClear()
      return
    end
    FlightDbgUpdate(false, splines)
    if partial and IsValid(FlightFrom) then
      SetGameSpeed("pause")
      StoreErrorSource(FlightFrom, "Failed to reach flight destination", ResolvePoint(FlightTo))
    end
  end
  function FlightDbgTogglePaths()
    MapForEach("map", "FlyingObj", function(obj)
      if obj.flight_path then
        FlightDbgShow({
          splines = obj.flight_path,
          spline_color = RandColor(obj.handle)
        })
      end
    end)
  end
  function FlightDbgShow(params)
    params = params or {}
    local splines, points, raw_points = params.splines, params.points, params.raw_points
    local energy_map, flight_map, fbox = params.energy_map, params.flight_map, params.fbox
    local energy_min, path_from, path_to = params.energy_min, params.path_from, params.path_to
    local z_offset = FlightScale / 2
    local v_pstr
    local max_energy = const.FlightMaxEnergy
    local FlightToGame = FlightToGame
    local GetHeight = terrain.GetSurfaceHeight
    local FlightDbgAddSegment = function(ptA, ptB, color)
      FlightDbgAdd(PlacePolyLine({ptA, ptB}, color, false))
    end
    local FlightDbgAddCircle = function(pt, radius, color)
      FlightDbgAdd(PlaceCircle(pt, radius, color, false))
    end
    energy_min = energy_min and ResolvePoint(FlightToGame(energy_min))
    if energy_min and params.show_energy_map then
      FlightDbgAddSegment(energy_min, energy_min:AddZ(10 * guim), 4294901760)
    end
    local path_obj = IsValid(path_from) and path_from
    path_from = path_from and ResolvePoint(path_from)
    path_to = path_to and ResolvePoint(path_to)
    local collected_tiles = {}
    if fbox and energy_map and params.show_energy_map then
      local pts = {}
      local mine, maxe = max_energy, 0
      GridForeach(energy_map, fbox, function(e, x, y)
        mine, maxe = Min(mine, e), Max(maxe, e)
        pts[#pts + 1] = point(x, y, e)
      end, 0, max_energy - 1)
      for _, pt in ipairs(pts) do
        local x, y, e = pt:xyz()
        local z
        if flight_map then
          z = flight_map:get(x, y)
          x, y, z = FlightToGame(x, y, z)
        else
          x, y = FlightToGame(x, y)
          z = GetHeight(x, y)
        end
        local mark_color = InterpolateRGB(red, green, e - mine, maxe - mine)
        table.insert(collected_tiles, {
          x,
          y,
          z,
          mark_color
        })
      end
    elseif fbox and flight_map and params.show_flight_map then
      GridForeach(flight_map, fbox, function(v, x, y)
        local x, y, z = FlightToGame(x, y, v)
        local mark_color = 855703551
        table.insert(collected_tiles, {
          x,
          y,
          z,
          mark_color
        })
      end, 1)
    end
    if #collected_tiles ~= 0 then
      table.sort(collected_tiles, function(lhs, rhs)
        return lhs[3] < rhs[3]
      end)
      local v_pstr = pstr("", 1048576)
      local __AppendTileVertices, mark_tile
      if params.linelist then
        __AppendTileVertices = AppendTileVerticesLinelist
        mark_tile = FlightTile
      else
        __AppendTileVertices = AppendTileVertices
        mark_tile = FlightTile - 200
      end
      for _, tile in ipairs(collected_tiles) do
        local x, y, z, c = tile[1], tile[2], tile[3], tile[4]
        if z == GetHeight(x, y) then
          z = nil
        end
        __AppendTileVertices(v_pstr, x, y, z, mark_tile, c, z_offset, GetHeight)
      end
      local mesh = Mesh:new()
      mesh:SetMesh(v_pstr)
      mesh:SetVisible(true)
      mesh:SetDepthTest(true)
      mesh:SetShader(params.linelist and ProceduralMeshShaders.mesh_linelist or ProceduralMeshShaders.default_mesh)
      mesh:SetMeshFlags(const.mfWorldSpace)
      mesh:SetPos(GetTerrainCursor())
      FlightDbgAdd(mesh)
    end
    if params.inspect_map then
      CreateRealTimeThread(function()
        local emax = const.FlightMaxEnergy
        local escale = const.FlightEnergyScale
        while not WaitMsg("FlightDbgClear", 50) do
          DbgClear()
          local pt0 = GetTerrainCursor()
          local x, y = pt0:xy()
          local fx, fy = GameToFlight(x, y)
          local inside = not fbox or Point2DInside(fbox, fx, fy)
          if inside then
            local pt1 = pt0
            if flight_map then
              z = FlightGetHeight(flight_map, fbox, x, y)
              pt1 = point(x, y, z + z_offset)
            end
            if pt0 ~= pt1 then
              DbgAddSegment(pt0, pt1, blue)
            end
            if energy_map then
              local e = energy_map:get(fx, fy)
              if e == 0 or e == emax then
                e = nil
              else
                local f = point20
                for dy = -1, 1 do
                  for dx = -1, 1 do
                    if dx ~= 0 or dy ~= 0 then
                      local ei = energy_map:get(fx + dx, fy + dy)
                      if ei ~= 0 and ei ~= emax then
                        local de = (e - ei) * escale
                        local v
                        if 0 < de then
                          v = SetLen(point(dx, dy), de)
                        else
                          v = SetLen(point(-dx, -dy), -de)
                        end
                        f = f + v
                        DbgAddVector(pt1, v)
                      end
                    end
                  end
                end
                DbgAddVector(pt1, f, yellow)
              end
            end
          end
        end
      end)
    elseif splines and params.inspect_spline then
      CreateRealTimeThread(function()
        while not WaitMsg("FlightDbgClear", 50) do
          local pt = GetTerrainCursor()
          local spline
          local min_dist2 = max_int
          for _, spline_i in ipairs(splines) do
            local pt0, pt1 = spline_i[1], spline_i[4]
            local dist2 = DistSegmentToPt2D2(pt0, pt1, pt)
            if min_dist2 > dist2 then
              min_dist2 = dist2
              spline = spline_i
            end
          end
          DbgClear()
          DbgSetVectorZTest(false)
          if spline then
            local pt0, pt1 = spline[1], spline[4]
            local dist2, x, y, z = DistSegmentToPt2D2(pt0, pt1, pt)
            local k = pt0:Dist(x, y, z)
            local max_k = pt0:Dist(pt1)
            local x, y, z, dx, dy, dz, ddx, ddy, ddz = BS3_GetSplinePosDirCurve(spline, k, max_k)
            local pt_p = point(x, y, z)
            local pt_v = point(dx, dy, dz)
            local pt_a = point(ddx, ddy, ddz)
            local v = pt_v:Len()
            local a = pt_a:Len()
            local v2D = pt_v:Len2D()
            local c = 0 < v2D and Cross2D(pt_v, pt_a) / v2D or 0
            local pt_c = 0 < c and SetLen(point(-dy, dx, 0), c) or c < 0 and SetLen(point(dy, -dx, 0), -c) or point30
            local t = atan(c, v2D) / 60
            DbgAddSegment(pt_p, pt)
            DbgAddSegment(pt_p, pt_p:SetTerrainZ(), 4284900966)
            DbgAddSegment(pt, pt_p:SetTerrainZ(), 4284900966)
            DbgAddVector(pt_p, pt_v, green)
            DbgAddVector(pt_p, pt_a, red)
            DbgAddVector(pt_p, pt_c, yellow)
            DbgAddText(string.format("v %d, a %d, c %d, t %d", v, a, c, t), pt_p)
          end
        end
      end)
    end
    if raw_points and 1 < #raw_points then
      FlightDbgAdd(PlacePolyLine(raw_points, white, false))
    end
    if points and 1 < #points and params.show_points then
      if path_from then
        FlightDbgAddSegment(path_from, path_from:AddZ(10 * guim), 4278255360)
      end
      if path_to then
        FlightDbgAddSegment(path_to, path_to:AddZ(10 * guim), 4294967040)
      end
      FlightDbgAdd(PlacePolyLine(points, green, false))
      local ptA, ptB
      for i = 2, #points - 1 do
        local pt = points[i]
        if not flight_map then
          local z = GetHeight(pt)
          FlightDbgAddSegment(pt, pt:SetZ(z), 4284900966)
        else
          local z = FlightGetHeight(flight_map, fbox, pt)
          FlightDbgAddSegment(pt, pt:SetZ(z), 4284900966)
          if path_obj then
            local z_min = z + path_obj.FlightSimHeightMin
            local z_max = z + path_obj.FlightSimHeightMax
            local ptA1, ptB1 = pt:SetZ(z_max), pt:SetZ(z_min)
            if ptA then
              FlightDbgAddSegment(ptA, ptA1, 4284900864)
              FlightDbgAddSegment(ptB, ptB1, 4284900864)
            end
            ptA, ptB = ptA1, ptB1
          end
        end
      end
      if path_obj then
        FlightDbgAddCircle(points[#points], path_obj.FlightSimDecelDist, 4284900966)
      end
    end
    if splines and 0 < #splines then
      local spline_color = params.spline_color or cyan
      local spline_color_alt = params.spline_color_alt or spline_color
      for i, spline in ipairs(splines) do
        FlightDbgAdd(PlaceSpline(spline, i % 2 == 0 and spline_color or spline_color_alt, false))
      end
    end
  end
  function OnMsg.SelectedObjChange(obj, prev)
    FlightDbgClear()
    if obj and config.DebugFlight and obj:IsKindOf("FlyingObj") then
      FlightDbgUpdate(obj)
    end
  end
  function DbgToggleFlightMap(obj, obstacles)
    local mesh = obj.dbg_flight_map_mesh
    if mesh then
      DoneObject(obj.dbg_flight_map_mesh)
      obj.dbg_flight_map_mesh = nil
      return
    end
    mesh = Mesh:new()
    obj.dbg_flight_map_mesh = mesh
    local flight_map, energy_map = FlightCreateGrids(mapdata.PassBorder)
    FlightMarkObstacle(flight_map, obj)
    for _, obstacle in ipairs(obstacles) do
      FlightMarkObstacle(flight_map, obstacle)
    end
    local collected_tiles = {}
    local GetHeight = terrain.GetHeight
    GridForeach(flight_map, function(v, x, y)
      local x, y, z = FlightToGame(x, y, v)
      if z > GetHeight(x, y) then
        local mark_color = 855703551
        table.insert(collected_tiles, {
          x,
          y,
          z,
          mark_color
        })
      end
    end, 1)
    if #collected_tiles ~= 0 then
      table.sort(collected_tiles, function(lhs, rhs)
        return lhs[3] < rhs[3]
      end)
      local v_pstr = pstr("", 1048576)
      local mark_tile = FlightTile - 200
      for _, tile in ipairs(collected_tiles) do
        local x, y, z, c = tile[1], tile[2], tile[3], tile[4]
        AppendTileVertices(v_pstr, x, y, z, mark_tile, c)
      end
      mesh:SetMesh(v_pstr)
      mesh:SetVisible(true)
      mesh:SetDepthTest(true)
      mesh:SetShader(ProceduralMeshShaders.default_mesh)
      mesh:SetMeshFlags(const.mfWorldSpace)
      obj:Attach(mesh)
    end
    flight_map:free()
    energy_map:free()
  end
  function FlightObstacle:AsyncCheatFlight()
    DbgToggleFlightMap(self)
  end
  function FlyingObj:CheatRecalcPath()
    self:RecalcFlightPath()
  end
end
