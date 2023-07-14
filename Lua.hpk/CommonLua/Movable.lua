DefineClass.Destlock = {
  __parents = {
    "CObject",
    "ComponentCustomData"
  },
  flags = {
    gofOnSurface = true,
    efDestlock = true,
    efVisible = false
  },
  radius = 6 * guic
}
if Libs.Network == "sync" then
  Destlock.flags.gofSyncObject = true
end
function Destlock:GetRadius()
  return self:GetCustomData(0)
end
function Destlock:FindOwner()
  return FindDestlockOwner(self)
end
DefineClass.Movable = {
  __parents = {"Object"},
  flags = {
    cofComponentPath = true,
    cofComponentAnim = true,
    cofComponentInterpolation = true,
    cofComponentCurvature = true,
    cofComponentCollider = false,
    efPathExecObstacle = true,
    efResting = true
  },
  pfclass = 0,
  pfflags = const.pfmDestlockSmart + const.pfmCollisionAvoidance + const.pfmOrient,
  GetPathFlags = pf.GetPathFlags,
  ChangePathFlags = pf.ChangePathFlags,
  GetStepLen = pf.GetStepLen,
  SetStepLen = pf.SetStepLen,
  SetSpeed = pf.SetSpeed,
  GetSpeed = pf.GetSpeed,
  SetMoveSpeed = pf.SetMoveSpeed,
  GetMoveSpeed = pf.GetMoveSpeed,
  GetMoveAnim = pf.GetMoveAnim,
  SetMoveAnim = pf.SetMoveAnim,
  GetWaitAnim = pf.GetWaitAnim,
  SetWaitAnim = pf.SetWaitAnim,
  ClearMoveAnim = pf.ClearMoveAnim,
  GetMoveTurnAnim = pf.GetMoveTurnAnim,
  SetMoveTurnAnim = pf.SetMoveTurnAnim,
  GetRotationTime = pf.GetRotationTime,
  SetRotationTime = pf.SetRotationTime,
  GetRotationSpeed = pf.GetRotationSpeed,
  SetRotationSpeed = pf.SetRotationSpeed,
  PathEndsBlocked = pf.PathEndsBlocked,
  SetDestlockRadius = pf.SetDestlockRadius,
  GetDestlockRadius = pf.GetDestlockRadius,
  SetCollisionRadius = pf.SetCollisionRadius,
  GetCollisionRadius = pf.GetCollisionRadius,
  RestrictArea = pf.RestrictArea,
  GetRestrictArea = pf.GetRestrictArea,
  CheckPassable = pf.CheckPassable,
  GetPath = pf.GetPath,
  GetPathLen = pf.GetPathLen,
  GetPathPointCount = pf.GetPathPointCount,
  GetPathPoint = pf.GetPathPoint,
  IsPathPartial = pf.IsPathPartial,
  GetPathHash = pf.GetPathHash,
  SetPfClass = pf.SetPfClass,
  GetPfClass = pf.GetPfClass,
  Step = pf.Step,
  ResolveGotoTarget = pf.ResolveGotoTarget,
  ResolveGotoTargetXYZ = pf.ResolveGotoTargetXYZ,
  collision_radius = false,
  collision_radius_mod = 1000,
  radius = 1 * guim,
  forced_collision_radius = false,
  forced_destlock_radius = false,
  outside_pathfinder = false,
  outside_pathfinder_reasons = false,
  dbg_last_move_time = 0,
  dbg_last_move_counter = 0
}
local pfSleep = Sleep
local pfFinished = const.pfFinished
local pfTunnel = const.pfTunnel
local pfFailed = const.pfFailed
local pfStranded = const.pfStranded
local pfDestLocked = const.pfDestLocked
local pfOutOfPath = const.pfOutOfPath
function GetPFStatusText(status)
  if type(status) ~= "number" then
    return ""
  elseif 0 <= status then
    return "Moving"
  elseif status == pfFinished then
    return "Finished"
  elseif status == pfTunnel then
    return "Tunnel"
  elseif status == pfFailed then
    return "Failed"
  elseif status == pfStranded then
    return "Stranded"
  elseif status == pfDestLocked then
    return "DestLocked"
  elseif status == pfOutOfPath then
    return "OutOfPath"
  end
  return ""
end
function Movable:InitEntity()
  if not IsValidEntity(self:GetEntity()) then
    return
  end
  if self:HasState("walk") then
    self:SetMoveAnim("walk")
  elseif self:HasState("moveWalk") then
    self:SetMoveAnim("moveWalk")
  elseif not self:HasState(self:GetMoveAnim() or -1) and self:HasState("idle") then
    self:SetMoveAnim("idle")
    self:SetStepLen(guim)
  end
  if self:HasState("idle") then
    self:SetWaitAnim("idle")
  end
end
function Movable:Init()
  self:InitEntity()
  self:InitPathfinder()
end
function Movable:InitPathfinder()
  self:ChangePathFlags(self.pfflags)
  self:UpdatePfClass()
  self:UpdatePfRadius()
end
local efPathExecObstacle = const.efPathExecObstacle
local efResting = const.efResting
local pfStep = pf.Step
local pfStop = pf.Stop
function Movable:ClearPath()
  if self.outside_pathfinder then
    return
  end
  return pfStop(self)
end
if Platform.asserts then
  function Movable:Step(...)
    return pfStep(self, ...)
  end
end
function Movable:ExitPathfinder(forced)
  if not forced and self.outside_pathfinder then
    return
  end
  self:ClearPath()
  self:RemoveDestlock()
  self:UpdatePfRadius()
  self:ClearEnumFlags(efPathExecObstacle | efResting)
  self.outside_pathfinder = true
end
function Movable:EnterPathfinder(forced)
  if not forced and not self.outside_pathfinder then
    return
  end
  self.outside_pathfinder = nil
  self:UpdatePfRadius()
  self:SetEnumFlags(efPathExecObstacle & GetClassEnumFlags(self) | efResting)
end
function Movable:AddOutsidePathfinderReason(reason)
  local reasons = self.outside_pathfinder_reasons or {}
  if reasons[reason] then
    return
  end
  reasons[reason] = true
  if not self.outside_pathfinder then
    self:ExitPathfinder()
  end
  self.outside_pathfinder_reasons = reasons
end
function Movable:RemoveOutsidePathfinderReason(reason, ignore_error)
  if not IsValid(self) then
    return
  end
  local reasons = self.outside_pathfinder_reasons
  if not reasons or not reasons[reason] then
    return
  end
  reasons[reason] = nil
  if next(reasons) then
    self.outside_pathfinder_reasons = reasons
    return
  end
  self:EnterPathfinder()
  self.outside_pathfinder_reasons = nil
end
function Movable:ChangeDestlockRadius(forced_destlock_radius)
  if self.forced_destlock_radius == forced_destlock_radius then
    return
  end
  self.forced_destlock_radius = forced_destlock_radius
  self:UpdatePfRadius()
end
function Movable:RestoreDestlockRadius(forced_destlock_radius)
  if self.forced_destlock_radius ~= forced_destlock_radius then
    return
  end
  self.forced_destlock_radius = nil
  self:UpdatePfRadius()
end
function Movable:ChangeCollisionRadius(forced_collision_radius)
  if self.forced_collision_radius == forced_collision_radius then
    return
  end
  self.forced_collision_radius = forced_collision_radius
  self:UpdatePfRadius()
end
function Movable:RestoreCollisionRadius(forced_collision_radius)
  if self.forced_collision_radius ~= forced_collision_radius then
    return
  end
  self.forced_collision_radius = nil
  self:UpdatePfRadius()
end
function Movable:UpdatePfRadius()
  local forced_collision_radius, forced_destlock_radius = self.forced_collision_radius, self.forced_destlock_radius
  if self.outside_pathfinder then
    forced_collision_radius, forced_destlock_radius = 0, 0
  end
  local radius = self:GetRadius()
  self:SetDestlockRadius(forced_destlock_radius or radius)
  self:SetCollisionRadius(forced_collision_radius or self.collision_radius or radius * self.collision_radius_mod / 1000)
end
function Movable:GetPfClassData()
  return pathfind[self:GetPfClass() + 1]
end
function Movable:GetPfSpheroidRadius()
  local pfdata = self:GetPfClassData()
  local pass_grid = pfdata and pfdata.pass_grid or PF_GRID_NORMAL
  return pass_grid == PF_GRID_NORMAL and const.passSpheroidWidth or const.passLargeSpheroidWidth
end
if config.TraceEnabled then
  function Movable:SetSpeed(speed)
    pf.SetSpeed(self, speed)
  end
end
function Movable:OnCommandStart()
  if IsValid(self) then
    self:ClearPath()
  end
end
function Movable:FindPath(...)
  local pfFindPath = pf.FindPath
  while true do
    local status, partial = pfFindPath(self, ...)
    if status <= 0 then
      return status, partial
    end
    Sleep(status)
  end
end
function Movable:HasPath(...)
  local status = self:FindPath(...)
  return status == 0
end
function Movable:FindPathLen(...)
  if self:HasPath(...) then
    return pf.GetPathLen(self)
  end
end
local Sleep = Sleep
function Movable:MoveSleep(time)
  return Sleep(time)
end
function Movable:CanStartMove(status)
  return 0 <= status or status == pfTunnel or status == pfStranded or status == pfDestLocked or status == pfOutOfPath
end
function Movable:TryContinueMove(status, ...)
  if status == pfTunnel then
    if self:TraverseTunnel() then
      return true
    end
  elseif status == pfStranded then
    if self:OnStrandedFallback(...) then
      return true
    end
  elseif status == pfDestLocked then
    if self:OnDestlockedFallback(...) then
      return true
    end
  elseif status == pfOutOfPath and self:OnOutOfPathFallback(...) then
    return true
  end
end
function Movable:Goto(...)
  local err = self:PrepareToMove(...)
  if err then
    return false, pfFailed
  end
  local pfStep = self.Step
  local status = pfStep(self, ...)
  if not self:CanStartMove(status) then
    return status == pfFinished, status
  end
  self:OnStartMoving(...)
  local pfSleep = self.MoveSleep
  while true do
    if 0 < status then
      if self:OnGotoStep(status) then
        break
      end
      pfSleep(self, status)
    elseif not self:TryContinueMove(status, ...) then
      break
    end
    status = pfStep(self, ...)
  end
  self:OnStopMoving(status, ...)
  return status == pfFinished, status
end
AutoResolveMethods.OnGotoStep = "or"
Movable.OnGotoStep = empty_func
function Movable:TraverseTunnel()
  local tunnel, param = pf.GetTunnel(self)
  if not tunnel then
    return self:OnTunnelMissingFallback()
  elseif not tunnel:TraverseTunnel(self, self:GetPathPoint(-1), param) then
    self:ClearPath()
    return false
  end
  self:OnTunnelTraversed(tunnel)
  return true
end
AutoResolveMethods.OnTunnelTraversed = "call"
Movable.OnTunnelTraversed = empty_func
function Movable:OnTunnelMissingFallback()
  if Platform.developer then
    local pos = self:GetPos()
    local next_pos = self:GetPathPoint(-1)
    local text_pos = ValidateZ(pos, 3 * guim)
    DbgAddSegment(pos, text_pos, red)
    if next_pos then
      DbgAddVector(pos + point(0, 0, guim / 2), next_pos - pos, yellow)
    end
    DbgAddText("Tunnel missing!", text_pos, red)
    StoreErrorSource("silent", pos, "Tunnel missing!")
  end
  Sleep(100)
  self:ClearPath()
  return true
end
function Movable:OnOutOfPathFallback()
  Sleep(100)
  self:ClearPath()
  return true
end
AutoResolveMethods.PickPfClass = "or"
Movable.PickPfClass = empty_func
function Movable:UpdatePfClass()
  local pfclass = self:PickPfClass() or self.pfclass
  return self:SetPfClass(pfclass)
end
function Movable:DbgCheckInfinteMove(dest, ...)
  local time = GameTime() + RealTime()
  if time ~= self.dbg_last_move_time then
    self.dbg_last_move_counter = nil
    self.dbg_last_move_time = time
  elseif self.dbg_last_move_counter == 100 then
    Sleep(100)
  else
    self.dbg_last_move_counter = self.dbg_last_move_counter + 1
  end
end
function Movable:PrepareToMove(dest, ...)
end
function Movable:OnStartMoving(dest, ...)
end
function Movable:OnStopMoving(status, dest, ...)
end
function Movable:OnStrandedFallback(dest, ...)
end
function Movable:OnDestlockedFallback(dest, ...)
end
local pfmDestlock = const.pfmDestlock
local pfmDestlockSmart = const.pfmDestlockSmart
local pfmDestlockAll = pfmDestlock + pfmDestlockSmart
function Movable:Goto_NoDestlock(...)
  local flags = self:GetPathFlags(pfmDestlockAll)
  if flags == 0 then
    return self:Goto(...)
  end
  self:ChangePathFlags(0, flags)
  if flags == pfmDestlock then
    self:PushDestructor(function(self)
      if IsValid(self) then
        self:ChangePathFlags(pfmDestlock, 0)
      end
    end)
  elseif flags == pfmDestlockSmart then
    self:PushDestructor(function(self)
      if IsValid(self) then
        self:ChangePathFlags(pfmDestlockSmart, 0)
      end
    end)
  else
    self:PushDestructor(function(self)
      if IsValid(self) then
        self:ChangePathFlags(pfmDestlockAll, 0)
      end
    end)
  end
  local res = self:Goto(...)
  self:PopDestructor()
  self:ChangePathFlags(flags, 0)
  return res
end
function Movable:InterruptPath()
  pf.ChangePathFlags(self, const.pfInterrupt)
end
function OnMsg.PersistGatherPermanents(permanents, direction)
  permanents["pf.Step"] = pf.Step
  permanents["pf.FindPath"] = pf.FindPath
  permanents["pf.RestrictArea"] = pf.RestrictArea
end
DefineClass.PFTunnel = {
  __parents = {"Object"},
  dbg_tunnel_color = const.clrGreen,
  dbg_tunnel_zoffset = 0
}
function PFTunnel:Done()
  self:RemovePFTunnel()
end
function PFTunnel:AddPFTunnel()
end
function PFTunnel:RemovePFTunnel()
  pf.RemoveTunnel(self)
end
function PFTunnel:TraverseTunnel(unit, end_point, param)
  unit:SetPos(end_point)
  return true
end
function PFTunnel:TryAddPFTunnel()
  return self:AddPFTunnel()
end
function OnMsg.LoadGame()
  MapForEach("map", "PFTunnel", function(obj)
    return obj:TryAddPFTunnel()
  end)
end
function Movable:FindPathDebugCallback(status, ...)
  local params = {
    ...
  }
  local target = (...)
  local dist, target_str = 0, ""
  local target_pos
  if IsPoint(target) then
    target_pos = target
    dist = self:GetDist2D(target)
    target_str = tostring(target)
  elseif IsValid(target) then
    target_pos = target:GetVisualPos()
    dist = self:GetDist2D(target)
    target_str = string.format("%s:%d", target.class, target.handle)
  elseif type(target) == "table" then
    target_pos = target[1]
    dist = self:GetDist2D(target[1])
    for i = 1, #target do
      local p = target[i]
      local d = self:GetDist2D(p)
      if i == 1 or dist > d then
        dist = d
        target_pos = p
      end
      target_str = target_str .. tostring(p)
    end
  end
  local o = DebugPathObj:new({})
  o:SetPos(self:GetVisualPos())
  o:ChangeEntity(self:GetEntity())
  o:SetScale(30)
  o:Face(target_pos)
  o.obj = self
  o.command = self.command
  o.target = target
  o.target_pos = target_pos
  o.params = params
  o.txt = string.format("handle:%d %15s %20s, dist:%4dm, status %d, pathlen:%4.1fm, restrict_r:%.1fm, target:%s", self.handle, self.class, self.command, dist / guim, status, 1.0 * pf.GetPathLen(self) / guim, 1.0 * self:GetRestrictArea() / guim, target_str)
  printf("Path debug: time:%d, %s", GameTime(), o.txt)
  pf.SetPfClass(o, self:GetPfClass())
  pf.ChangePathFlags(o, self.pfflags)
  pf.SetCollisionRadius(o, self:GetCollisionRadius())
  pf.SetDestlockRadius(o, self:GetRadius())
  pf.RestrictArea(o, self:GetRestrictArea())
end
DefineClass.DebugPathObj = {
  __parents = {"Movable"},
  flags = {efSelectable = true},
  entity = "WayPoint",
  obj = false,
  command = "",
  target = false,
  target_pos = false,
  params = false,
  restrict_pos = false,
  restrict_radius = 0,
  txt = "",
  FindPathDebugCallback = empty_func,
  DrawPath = function(self)
    pf.FindPath(self, table.unpack(self.params))
    DrawWayPointPath(self, self.target_pos)
  end
}
function LeaderClustering(objs, dist_threshold, func, ...)
  local other_leaders
  for _, obj in ipairs(objs) do
    local leader = objs[1]
    local dist = leader:GetDist2D(obj)
    for _, leader2 in ipairs(other_leaders) do
      local dist2 = leader2:GetDist2D(obj)
      if dist > dist2 then
        leader, dist = leader2, dist2
      end
    end
    if dist_threshold < dist then
      leader = obj
      dist = 0
      other_leaders = other_leaders or {}
      other_leaders[#other_leaders + 1] = leader
    end
    func(obj, leader, dist, ...)
  end
end
function ClusteredDestinationOffsets(objs, dist_threshold, dest, func, ...)
  if #(objs or "") == 0 then
    return
  end
  local x0, y0, z0 = dest:xyz()
  local invalid_z = const.InvalidZ
  z0 = z0 or invalid_z
  if #objs == 1 then
    z0 = terrain.FindPassableZ(x0, y0, z0, objs[1].pfclass) or z0
    func(objs[1], x0, y0, z0, ...)
    return
  end
  local clusters = {}
  local base_x, base_y = 0, 0
  LeaderClustering(objs, dist_threshold, function(obj, leader, dist, clusters)
    local cluster = clusters[leader]
    if not cluster then
      cluster = {x = 0, y = 0}
      clusters[leader] = cluster
      clusters[#clusters + 1] = cluster
    end
    local x, y = obj:GetPosXYZ()
    cluster.x = cluster.x + x
    cluster.y = cluster.y + y
    base_x = base_x + x
    base_y = base_y + y
    cluster[#cluster + 1] = obj
  end, clusters)
  base_x, base_y = base_x / #objs, base_y / #objs
  local offs = dist_threshold / 4
  for idx, cluster in ipairs(clusters) do
    local x, y = cluster.x / #cluster, cluster.y / #cluster
    local dx, dy = x - base_x, y - base_y
    local len = sqrt(dx * dx + dy * dy)
    if 0 < len then
      dx, dy = dx * offs / len, dy * offs / len
    end
    x, y = x0 - x + dx, y0 - y + dy
    for _, obj in ipairs(cluster) do
      local obj_x, obj_y, obj_z = obj:GetPosXYZ()
      local x1, y1, z1 = obj_x + x, obj_y + y, z0
      z1 = terrain.FindPassableZ(x1, y1, z1, obj.pfclass) or z1
      func(obj, x1, y1, z1, ...)
    end
  end
end
MapVar("PathTestObj", false)
DefineClass.TestPathObj = {
  __parents = {"Movable"},
  flags = {
    cofComponentAnim = false,
    cofComponentInterpolation = false,
    cofComponentCurvature = false,
    efPathExecObstacle = false,
    efResting = false,
    efSelectable = false,
    efVisible = false
  },
  pfflags = 0
}
function GetPathTestObj()
  if not IsValid(PathTestObj) then
    PathTestObj = PlaceObject("TestPathObj")
    CreateGameTimeThread(function()
      DoneObject(PathTestObj)
      PathTestObj = false
    end)
  end
  return PathTestObj
end
