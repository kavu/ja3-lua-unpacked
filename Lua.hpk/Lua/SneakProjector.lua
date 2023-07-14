local easingIndex = GetEasingIndex("Sin in")
local Lerp = Lerp
local EaseCoeff = EaseCoeff
local easeInterval = 25
DefineClass.SneakProjector = {
  flags = {efApplyToGrids = false},
  __parents = {
    "CommandObject",
    "GameDynamicDataObject",
    "EditorObject"
  },
  properties = {
    category = "Game Logic",
    {
      id = "Positions",
      name = "Positions",
      editor = "point_list",
      helper = "relative_pos_list",
      default = false
    },
    {
      id = "SweepDuration",
      name = "Sweep Duration",
      editor = "number",
      default = 10000
    },
    {
      id = "SweepDurationPerCombatTurn",
      name = "Combat Sweep Segment (Time)",
      editor = "number",
      default = 2000
    },
    {
      id = "SweepBetween",
      name = "Time Between Sweeps",
      editor = "number",
      default = 5000
    }
  },
  base_euler = false,
  last_point = 0,
  target_point = 0,
  starting_yaw = false,
  time_passed = false,
  time_between = false,
  attaches_destroyed = false
}
function SneakProjector:SetDynamicData(data)
  self.target_point = data.target_point or 0
  self.last_point = data.last_point or 0
  self.time_passed = data.time_passed
  self.time_between = data.time_between
  self:SetCommand("Idle")
  self.starting_yaw = data.starting_yaw
  self.base_euler = data.base_euler
end
function SneakProjector:GetDynamicData(data)
  data.target_point = self.target_point
  data.last_point = self.last_point
  data.time_passed = self.time_passed
  data.time_between = self.time_between
  data.starting_yaw = self.starting_yaw
  data.base_euler = self.base_euler
end
function SneakProjector:GameInit()
  self.base_euler = {
    self:GetRollPitchYaw()
  }
end
function SneakProjector:EditorExit()
  self.base_euler = {
    self:GetRollPitchYaw()
  }
  self:SetCommand("Idle")
end
function SneakProjector:Idle()
  local enemyTeam1 = table.find_value(g_Teams, "side", "enemy1")
  local anyLivingEnemies = false
  for i, u in ipairs(enemyTeam1 and enemyTeam1.units) do
    if not u:IsDead() then
      anyLivingEnemies = true
      break
    end
  end
  if not anyLivingEnemies then
    local enemyTeam2 = table.find_value(g_Teams, "side", "enemy2")
    for i, u in ipairs(enemyTeam2 and enemyTeam2.units) do
      if not u:IsDead() then
        anyLivingEnemies = true
        break
      end
    end
  end
  if anyLivingEnemies then
    if self.attaches_destroyed then
      self:AutoAttachObjects()
      self:ForEachAttach("Light", Stealth_HandleLight)
    end
    self.attaches_destroyed = false
  else
    local lights = self:GetAttaches("Light")
    for i, l in ipairs(lights) do
      KillStealthLightForLight(l)
    end
    self:DestroyAttaches()
    self.attaches_destroyed = true
    Halt()
    return
  end
  Msg("ProjectorIdle", self)
  if not self.Positions or #self.Positions == 0 then
    Halt()
  end
  if self.last_point > #self.Positions or self.last_point == 0 then
    self.last_point = 0
  end
  self.target_point = self.last_point + 1
  if self.target_point > #self.Positions then
    self.target_point = 1
  end
  if g_Combat then
    Halt()
    return
  end
  self:SetCommand("Sweep")
end
function SneakProjector:GetYaw()
  local r, p, y = self:GetRollPitchYaw()
  return y
end
function SneakProjector:Sweep(length)
  if self:GetEnumFlags(const.efApplyToGrids) ~= 0 then
    self:ClearEnumFlags(const.efApplyToGrids)
    StoreErrorSource(self, "SneakProjector enum flags cleared!. Resave the map.")
  end
  local timePassed = self.time_passed or 0
  self.time_passed = timePassed
  local max_time
  if length == "snap-to-segment" then
    if not self.time_passed then
      length = "segment"
    else
      max_time = MulDivRound(self.time_passed, 1, self.SweepDurationPerCombatTurn) * self.SweepDurationPerCombatTurn
    end
  end
  if length == "segment" then
    max_time = timePassed + self.SweepDurationPerCombatTurn
  end
  if self.time_between then
    if max_time then
      self.time_between = self.time_between - 1
      if self.time_between == 0 then
        self.time_between = false
      end
    else
      self:BetweenSweepWait()
    end
    return
  end
  local p = self.Positions and self.Positions[self.target_point]
  if not p then
    self.last_point = self.last_point + 1
    self:SetCommand("Idle")
    return
  end
  local startingYaw = self.starting_yaw or self:GetYaw()
  self.starting_yaw = startingYaw
  local finalAngle = atan(p)
  local prevTime = GameTime()
  local sweepDuration = self.SweepDuration
  while timePassed <= sweepDuration do
    local deltaTime = GameTime() - prevTime
    timePassed = timePassed + deltaTime
    prevTime = GameTime()
    self.time_passed = timePassed
    local currentYaw = self:GetYaw()
    local lerpFunc = AngleLerp(startingYaw, finalAngle, sweepDuration, true)
    local angle = lerpFunc(EaseCoeff(easingIndex, timePassed, sweepDuration))
    self:SetRollPitchYaw(self.base_euler[1], self.base_euler[2], angle, easeInterval)
    Sleep(easeInterval)
    if not g_Combat then
      ResetVoxelStealthParamsCache()
    end
    if max_time and max_time <= timePassed then
      ResetVoxelStealthParamsCache()
      self:SetCommand("Idle")
      return
    end
  end
  self:SetRollPitchYaw(self.base_euler[1], self.base_euler[2], finalAngle)
  ResetVoxelStealthParamsCache()
  self.last_point = self.target_point
  self:Reset()
  if max_time then
    self.time_between = 1
  else
    self:BetweenSweepWait()
  end
end
function SneakProjector:BetweenSweepWait(max_time)
  local timePassed = self.time_between or 0
  self.time_between = timePassed
  while timePassed < self.SweepBetween do
    Sleep(easeInterval)
    timePassed = timePassed + easeInterval
    self.time_between = timePassed
  end
  self.time_between = false
  self:SetCommand("Idle")
end
function SneakProjector:Reset()
  self.target_point = false
  self.start_time = false
  self.time_passed = false
  self.starting_yaw = false
end
MapVar("MapHasProjectors", false)
MapVar("ProjectorsCombatTurnExecuted", false)
function OnMsg.CombatStart()
  MapForEach("map", "SneakProjector", function(obj)
    MapHasProjectors = true
    if obj.time_between then
      obj.time_between = false
      obj:SetCommand("Idle")
    else
      obj:SetCommand("Sweep", "snap-to-segment")
    end
  end)
end
local lResetExplorationSneakProjects = function()
  MapForEach("map", "SneakProjector", function(obj)
    obj:SetCommand("Idle")
  end)
  ProjectorsCombatTurnExecuted = false
end
function OnMsg.EnterSector()
  lResetExplorationSneakProjects()
end
function OnMsg.DbgStartExploration()
  lResetExplorationSneakProjects()
end
function OnMsg.CombatEnd()
  lResetExplorationSneakProjects()
end
function GetSneakProjectorLights()
  local objs = {}
  for i, o in ipairs(StealthLights) do
    local ogLight = o.original_light
    local projector = ogLight and ogLight:GetParent()
    if IsKindOf(projector, "SneakProjector") and IsValid(o) then
      objs[#objs + 1] = o
    end
  end
  return objs
end
function RunProjectorTurnAndWait()
  local projectors = MapGet("map", "SneakProjector")
  for i, p in ipairs(projectors or empty_table) do
    p:SetCommand("Sweep", "segment")
  end
  for i, p in ipairs(projectors or empty_table) do
    while p.command ~= "Idle" do
      WaitMsg("ProjectorIdle", 500)
    end
  end
  ProjectorsCombatTurnExecuted = g_Combat.current_turn
end
