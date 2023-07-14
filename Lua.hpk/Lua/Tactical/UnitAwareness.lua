MapVar("g_UnitAlertThread", false)
MapVar("g_RepositionMarkersClaimed", {})
MapVar("g_NoiseSources", {})
MapVar("g_SuspicionThreads", {})
MapVar("g_UnitAwarenessPending", false)
GameVar("g_AwarenessLog", {})
DefineClass.AwareReasons = {
  __parents = {"ListPreset"},
  properties = {
    {
      id = "display_name",
      name = "Display Name",
      editor = "text",
      default = false,
      translate = true
    }
  }
}
DefineClass.NoiseTypes = {
  __parents = {"Preset"},
  properties = {
    {
      id = "display_name",
      name = "Display Name",
      editor = "text",
      default = false,
      translate = true
    }
  }
}
if Platform.developer then
  local AwarenessLogMaxLines = 100
  function dbg_awareness_log(...)
    local msg = string.format("[%d] ", GameTime())
    for i = 1, select("#", ...) do
      local obj = select(i, ...)
      local item_str
      if IsValid(obj) then
        if IsKindOf(obj, "Unit") then
          item_str = string.format("%s (%d)", obj.unitdatadef_id, obj.handle)
        else
          item_str = obj.class
        end
      else
        item_str = tostring(obj)
      end
      msg = msg .. item_str
    end
    g_AwarenessLog = g_AwarenessLog or {}
    while #g_AwarenessLog >= AwarenessLogMaxLines do
      table.remove(g_AwarenessLog, 1)
    end
    table.insert(g_AwarenessLog, msg)
  end
else
  dbg_awareness_log = empty_func
end
function PushUnitAlert(trigger_type, ...)
  if CheatEnabled("DisableDiscoveryAlert") and trigger_type == "discovered" then
    return
  end
  local netUpdateParams = {
    ...
  }
  local cls = netUpdateParams[1] and netUpdateParams[1].class or ""
  local number = netUpdateParams[2] or 0
  NetUpdateHash("PushUnitAlert", trigger_type, cls, number)
  local alerted = {}
  local suspicious = 0
  local surprised = 0
  local pov_team = GetPoVTeam()
  local enemies = pov_team and pov_team.units and GetAllEnemyUnits(pov_team.units[1] or false)
  local enemies_alive
  for _, unit in ipairs(enemies) do
    if IsValidTarget(unit) then
      enemies_alive = true
      break
    end
  end
  if not enemies_alive then
    return 0, 0
  end
  if trigger_type == "attack" then
    local attacker = select(1, ...)
    local alerted_obj = select(2, ...)
    local from_stealth = select(3, ...)
    local hit_objs = select(4, ...)
    local aware_state = (from_stealth or HasPerk(attacker, "FoxPerk")) and "surprised" or "aware"
    dbg_awareness_log(attacker, " alerts: attack")
    local units = IsValid(alerted_obj) and {alerted_obj} or alerted_obj
    for _, unit in ipairs(units) do
      local state = unit:HasStatusEffect("Surprised") and "aware" or aware_state
      local is_aware = unit:IsAware() or unit.pending_aware_state == "aware"
      local reason
      if not (state ~= "surprised" or is_aware) or hit_objs and not table.find(hit_objs, unit) then
        reason = "arSurprised"
      else
        reason = "arAttack"
      end
      reason = T({
        Presets.AwareReasons.Default[reason].display_name,
        enemy = unit.Name,
        merc = attacker.Nick or attacker.Name
      })
      if unit:SetPendingAwareState(state, reason, attacker) then
        if state ~= "aware" then
          surprised = surprised + 1
        else
          alerted[#alerted + 1] = unit
        end
        dbg_awareness_log("  ", unit, " alerted")
      end
      if unit.pending_aware_state == "aware" and g_CurrentAttackActions[1] and g_CurrentAttackActions[1].attack_args and g_CurrentAttackActions[1].attack_args.target == unit then
        unit.pending_awareness_role = state == "surprised" and "surprised" or "attacked"
      end
    end
  elseif trigger_type == "death" then
    local actor = select(1, ...)
    dbg_awareness_log(actor, " alerts: dead")
    local units = table.ifilter(g_Units, function(_, u)
      return not u.dummy and u.team.side ~= "neutral" and not u:IsIncapacitated() and not u:IsAware()
    end)
    local los_any, los_targets = CheckLOS(units, actor)
    for i, unit in ipairs(units) do
      local sight = unit:GetSightRadius(actor)
      if los_targets[i] and sight >= unit:GetDist(actor) and unit:SetPendingAwareState("surprised", T({
        Presets.AwareReasons.Default.arSawDying.display_name,
        enemy = unit.Name
      })) then
        dbg_awareness_log("  ", unit, " is surprised")
        surprised = surprised + 1
      end
    end
  elseif trigger_type == "dead body" then
    local actor = select(1, ...)
    local units = select(2, ...)
    local los_any, los_targets = CheckLOS(units, actor)
    for i, unit in ipairs(units) do
      if not unit.seen_bodies[actor] then
        local sight = unit:GetSightRadius(actor)
        local aware_state = g_Combat and "surprised" or "suspicious"
        if los_targets[i] and sight >= unit:GetDist(actor) and unit:SetPendingAwareState(aware_state) then
          unit.suspicious_body_seen = actor:GetHandle()
          unit.seen_bodies[actor] = true
          dbg_awareness_log("  ", unit, " is suspicious")
          suspicious = suspicious + 1
        end
      end
    end
  elseif trigger_type == "noise" then
    local actor = select(1, ...)
    local radius = select(2, ...)
    local soundName = select(3, ...)
    if GameState.RainLight or GameState.RainHeavy then
      radius = MulDivRound(radius, Max(0, 100 + const.EnvEffects.RainNoiseMod), 100)
    end
    dbg_awareness_log(actor, " alerts: noise ", radius)
    g_NoiseSources[#g_NoiseSources + 1] = {
      actor = actor,
      pos = actor and actor:GetPos(),
      noise = radius
    }
    radius = radius * const.SlabSizeX
    local alerter = IsKindOf(actor, "Unit") and actor or nil
    local state = alerter and HasPerk(alerter, "FoxPerk") and "surprised" or "aware"
    for _, unit in ipairs(g_Units) do
      local dist = unit:GetDist(actor)
      local r = MulDivRound(radius, unit:HasStatusEffect("Distracted") and 66 or 100, 100)
      local aware = unit:IsAware("pending")
      local isPlayerAllyNotInCombat = not g_Combat and unit.team.side ~= "enemy1" and unit.team.side ~= "enemy2"
      if not isPlayerAllyNotInCombat and unit ~= actor and dist <= r and unit:SetPendingAwareState(state, T({
        Presets.AwareReasons.Default.arNoise.display_name,
        enemy = unit.Name,
        noise = soundName
      }), alerter) then
        if actor then
          unit.last_known_enemy_pos = actor:GetPos()
        end
        if state == "aware" then
          alerted[#alerted + 1] = unit
        else
          surprised = surprised + 1
        end
        dbg_awareness_log("  ", unit, " alerted")
      end
    end
  elseif trigger_type == "projector" then
    local actor = select(1, ...)
    local units = select(2, ...)
    local projector = select(3, ...)
    for i, unit in ipairs(units) do
      if IsCloser(unit, projector, ProjectorSuspiciousApplyRange) and unit:SetPendingAwareState("aware", T({
        Presets.AwareReasons.Default.arProjector.display_name,
        enemy = unit.Name
      }), actor) then
        surprised = surprised + 1
      end
    end
  elseif trigger_type == "sight" then
    local actor = select(1, ...)
    local seen = select(2, ...)
    local aware = actor:IsAware() or actor.pending_aware_state == "aware"
    local surprised = actor:HasStatusEffect("Surprised") or actor.pending_aware_state == "surprised"
    if actor:IsOnEnemySide(seen) and not aware and not surprised and actor:SetPendingAwareState("surprised") then
      suspicious = suspicious + 1
      dbg_awareness_log(actor, " is alerted (sight)")
    end
  elseif trigger_type == "thrown" then
    local obj = select(1, ...)
    local attacker = select(2, ...)
    local units = table.ifilter(g_Units, function(idx, unit)
      return not unit:IsAware("pending") and (not attacker or unit:IsOnEnemySide(attacker))
    end)
    local los_any, los_targets = CheckLOS(units, obj)
    for i, unit in ipairs(units) do
      local sight = unit:GetSightRadius(obj)
      if los_targets and los_targets[i] and sight >= unit:GetDist(obj) and unit:SetPendingAwareState("surprised", T({
        Presets.AwareReasons.Default.arThrownObject.display_name,
        enemy = unit.Name
      })) then
        dbg_awareness_log("  ", unit, " is surprised")
        surprised = surprised + 1
      end
    end
  elseif trigger_type == "script" then
    local units = select(1, ...)
    local state = select(2, ...)
    units = table.ifilter(units, function(idx, unit)
      return unit.team and not unit.team.neutral
    end)
    for _, unit in ipairs(units) do
      unit.pending_aware_state = state
      dbg_awareness_log(unit, " is alerted (script): ", state)
    end
    if state == "aware" then
      alerted = units
    end
  elseif trigger_type == "surprise" then
    local unit = select(1, ...)
    local from_suspicious = select(2, ...)
    local reason
    if from_suspicious then
      reason = T({
        Presets.AwareReasons.Default.arDeadBody.display_name,
        enemy = unit.Name
      })
    end
    if unit:SetPendingAwareState("aware", reason) then
      dbg_awareness_log(unit, " is alerted (surprise)")
      alerted[#alerted + 1] = unit
    end
  else
    if trigger_type == "discovered" then
      local unit = select(1, ...)
      local enemyUnits = GetAllEnemyUnits(unit)
      local alertedPeople = 0
      for i, enemyUnit in ipairs(enemyUnits) do
        if not enemyUnit:IsAware() and HasVisibilityTo(enemyUnit, unit) then
          alertedPeople = alertedPeople + 1
          CombatStarDetectedtVR(unit)
          if enemyUnit.pending_aware_state ~= "aware" and not enemyUnit:HasStatusEffect("Surprised") and enemyUnit:SetPendingAwareState("aware", T({
            Presets.AwareReasons.Default.arNotice.display_name,
            enemy = enemyUnit.Name,
            merc = unit.Nick or unit.Name
          }), unit) then
            alerted[#alerted + 1] = enemyUnit
            dbg_awareness_log(enemyUnit, " is alerted (combat-walk)")
          end
        end
      end
      if 0 < alertedPeople then
        unit:RemoveStatusEffect("Hidden")
      end
    else
    end
  end
  alerted = table.ifilter(alerted, function(idx, unit)
    return not unit.dummy and unit.pending_aware_state == "aware"
  end)
  if 0 < #alerted then
    local roles = {}
    PropagateAwareness(alerted, roles)
    for _, unit in ipairs(alerted) do
      if unit.pending_aware_state ~= "aware" and unit:SetPendingAwareState("aware") or roles[unit] == "alerter" then
        unit.pending_awareness_role = roles[unit] or "alerted"
      end
    end
  end
  if 0 < #alerted + surprised then
    local pendingType = 0 < #alerted and "alert" or "sus"
    if not g_UnitAwarenessPending or pendingType == "alert" then
      g_UnitAwarenessPending = pendingType
    end
  end
  return #alerted + surprised, suspicious
end
function TriggerUnitAlert(trigger_type, ...)
  local alerted, suspicious = PushUnitAlert(trigger_type, ...)
  AlertPendingUnits()
  return alerted, suspicious
end
function PropagateAwareness(alerted_units, roles, killed_units)
  local i = 1
  while i <= #alerted_units do
    local unit = alerted_units[i]
    local sight = unit:GetSightRadius()
    if not unit:IsDead() or killed_units and table.find(killed_units, unit) then
      local upos = GetPackedPosAndStance(unit)
      local allies = GetAllAlliedUnits(unit)
      for _, ally in ipairs(allies) do
        if IsValidTarget(ally) and (ally.team.side == "neutral" or not ally:IsAware() and ally.pending_aware_state ~= "aware") then
          local apos = GetPackedPosAndStance(ally)
          if apos and upos and sight >= stance_pos_dist(upos, apos) and stance_pos_visibility(upos, apos) then
            table.insert_unique(alerted_units, ally)
            if roles then
              if not roles[unit] then
                roles[unit] = "alerter"
              end
              roles[ally] = "alerted"
            end
          end
        end
      end
    end
    i = i + 1
  end
end
local ExecUnitAlert = function(reposition_units, alerted_by_enemy, first_unit)
  if not g_Combat then
    if not g_StartingCombat and g_Units and next(g_Units) then
      NetSyncEvent("ExplorationStartCombat", nil, first_unit and first_unit.session_id)
      WaitMsg("CombatStart")
    end
  elseif g_StartingCombat then
    WaitMsg("CombatStart")
  end
  if ActionCameraPlaying then
    RemoveActionCamera(true)
    WaitMsg("ActionCameraRemoved", 5000)
  end
  local sector = gv_Sectors[gv_CurrentSectorId]
  local unitList = next(alerted_by_enemy) and alerted_by_enemy or reposition_units
  alerted_by_enemy = table.ifilter(alerted_by_enemy, function(idx, unit)
    return IsValidTarget(unit) and IsValid(unit.alerted_by_enemy) and not unit:HasStatusEffect("Unconscious")
  end)
  for _, unit in ipairs(unitList) do
    if sector.awareness_sequence == "Standard" then
      unit.pending_awareness_role = unit.pending_awareness_role or "alerted"
    else
      unit.pending_awareness_role = nil
    end
  end
  PlayBestCombatNotification(unitList)
  local cam_actor, restore_cam_obj
  if g_Combat and not g_Combat.unit_reposition_shown and 0 < #alerted_by_enemy and sector.awareness_sequence == "Standard" then
    local unit
    for _, u in ipairs(alerted_by_enemy) do
      if u.pending_awareness_role == "attacked" then
        unit = u
        break
      end
    end
    unit = unit or table.interaction_rand(alerted_by_enemy, "StartCombat")
    g_Combat.unit_reposition_shown = true
    cam_actor, restore_cam_obj = unit, unit.alerted_by_enemy
    if unit and not IsCompetitiveGame() then
      cameraTac.SetZoom(0, 50)
      LockCamera(unit)
      Sleep(50)
      for _, unit in ipairs(reposition_units) do
        if IsValid(unit) and not unit:IsDead() then
          unit:AddToGroup("AlertedUnits")
        end
      end
      do
        local valid, all = {}, {}
        ForEachPresetInGroup("SetpiecePrg", "Combat", function(prg)
          for _, cmd in ipairs(prg) do
            if IsKindOfClasses(cmd, "SetpieceActionCameraSingle", "SetpieceActionCamera") then
              local target
              if IsKindOf(cmd, "SetpieceActionCameraSingle") then
                target = SetpieceActionCameraSingle.CalcTarget({unit}, cmd.TargetOffset, cmd.TargetHeight, cmd.TargetAngleOffset)
              else
                target = unit.alerted_by_enemy
              end
              local pos, lookat, preset = SetpieceActionCamera.CalcCamera(unit, target, cmd.Preset, cmd.Position)
              if cmd.Preset == "Any" or preset == cmd.Preset then
                valid[#valid + 1] = prg.id
              end
              all[#all + 1] = prg.id
            elseif IsKindOfClasses(cmd, "SetStartCombatAnim") then
              valid[#valid + 1] = prg.id
            end
          end
        end)
        valid = 0 < #valid and valid or all
        local setpiece = table.interaction_rand(valid, "StartCombat")
        local dlg = OpenDialog("XSetpieceDlg", false, {
          setpiece = setpiece,
          triggerUnits = {unit}
        })
        if dlg then
          while true do
            local ok, sp = WaitMsg("SetpieceEnded", 20000)
            if not ok or sp.id == dlg.setpiece then
              break
            end
          end
        end
        for _, unit in ipairs(reposition_units) do
          unit:RemoveFromGroup("AlertedUnits")
          unit.pending_awareness_role = nil
        end
        UnlockCamera(unit)
      end
    end
  end
  CancelWaitingActions(-1)
  if not g_StartingCombat then
    g_AIExecutionController.restore_camera_obj = restore_cam_obj or SelectedObj
  end
  g_AIExecutionController:Execute(reposition_units)
  g_UnitAlertThread = false
  g_UnitAwarenessPending = false
  DoneObject(g_AIExecutionController)
end
function AlertPendingUnits(sync_code)
  NetUpdateHash("AlertPendingUnits")
  if g_Combat and (g_Combat.start_of_turn or next(CombatActions_RunningState) ~= nil) then
    return
  end
  NetUpdateHash("AlertPendingUnits_EarlyOuts", "GameState.entering_sector", GameState.entering_sector, "IsValidThread(g_UnitAlertThread)", IsValidThread(g_UnitAlertThread), "IsSetpiecePlaying()", IsSetpiecePlaying(), "GameState.setpiece_playing", GameState.setpiece_playing, "IsRadioBanterPlaying()", IsRadioBanterPlaying(), "g_AIExecutionController", not not g_AIExecutionController, "GameState.sync_loading", GameState.sync_loading, "not gv_Sectors", not gv_Sectors, "GameState.entering_sector", GameState.entering_sector)
  if IsSetpiecePlaying() or GameState.sync_loading or g_AIExecutionController or IsValidThread(g_UnitAlertThread) or gv_SatelliteView or not gv_Sectors then
    return
  end
  if GameState.entering_sector then
    return
  end
  NetUpdateHash("AlertPendingUnits_doing_work")
  for _, unit in ipairs(g_Units) do
    if IsValidThread(unit.pain_thread) or unit.command == "ExplosionFly" or HasCombatActionInProgress(unit) then
      return
    end
  end
  local sector = gv_Sectors[gv_CurrentSectorId]
  local reposition_units, alerted_by_enemy, surprised_units = {}, {}, {}
  local start_combat, first_unit
  local end_combat = g_Combat and g_Combat:ShouldEndCombat()
  for _, unit in ipairs(g_Units) do
    local team = unit.team
    if team and team.side ~= "neutral" and not end_combat and IsValidTarget(unit) and not unit:IsAware() then
      local state = unit.pending_aware_state
      if state == "aware" then
        start_combat = true
        if sector.awareness_sequence == "Skip All" or g_Combat and team == g_Teams[g_CurrentTeam] then
          unit:RemoveStatusEffect("Unaware")
          unit:RemoveStatusEffect("Surprised")
          unit:RemoveStatusEffect("Suspicious")
          unit.pending_aware_state = nil
        else
          reposition_units[#reposition_units + 1] = unit
          first_unit = first_unit or unit.alerted_by_enemy
          if IsValidTarget(unit.alerted_by_enemy) then
            alerted_by_enemy[#alerted_by_enemy + 1] = unit
          end
        end
      elseif state == "surprised" then
        start_combat = true
        if g_Combat then
          unit:AddStatusEffect("Surprised")
          unit:RemoveStatusEffect("Suspicious")
          unit.pending_aware_state = nil
        else
          surprised_units[#surprised_units + 1] = unit
        end
      elseif state == "suspicious" then
        unit:AddStatusEffect("Suspicious")
        unit:RemoveStatusEffect("Unaware")
        unit.pending_aware_state = nil
      end
    else
      unit.pending_aware_state = nil
    end
  end
  if not (not start_combat or g_Combat) or 0 < #reposition_units then
    if 0 < #reposition_units then
      CreateAIExecutionController({label = "AlertUnits", reposition = true})
    end
    g_UnitAlertThread = CreateGameTimeThread(function()
      if not g_Combat then
        if not g_StartingCombat and g_Units and next(g_Units) then
          if sync_code then
            CreateGameTimeThread(NetSyncEvents.ExplorationStartCombat, nil, first_unit and first_unit.session_id)
          else
            NetSyncEvent("ExplorationStartCombat", nil, first_unit and first_unit.session_id)
          end
        end
        while not g_Combat do
          WaitMsg("CombatStarting", 10)
        end
        for _, unit in ipairs(g_Units) do
          if IsValidTarget(unit) and not unit:IsAware() and unit.team and unit.team.side ~= "neutral" and unit.pending_aware_state == "surprised" then
            unit:AddStatusEffect("Surprised")
            unit.pending_aware_state = nil
          end
        end
      end
      if 0 < #reposition_units then
        ExecUnitAlert(reposition_units, alerted_by_enemy, first_unit)
      end
    end)
  end
  if #reposition_units <= 0 then
    PlayBestCombatNotification(surprised_units)
    g_UnitAwarenessPending = false
  end
end
function OnMsg.VisibilityUpdate()
  if not g_Combat then
    return
  end
  local aware = {}
  for _, unit in ipairs(g_Units) do
    if not unit:IsDead() then
      local is_aware = unit:IsAware()
      if is_aware and not unit.team.player_team and unit.team.side ~= "neutral" then
        aware[#aware + 1] = unit
      end
      for _, seen in ipairs(g_Visibility[unit]) do
        if IsValid(seen) and unit:IsOnEnemySide(seen) then
          unit.last_known_enemy_pos = seen:GetPos()
          if not is_aware then
            PushUnitAlert("sight", unit, seen)
          end
        end
      end
    end
  end
  PropagateAwareness(aware)
  for _, unit in ipairs(aware) do
    if unit:SetPendingAwareState("aware") then
      unit.pending_awareness_role = "alerted"
    end
  end
  AlertPendingUnits()
end
function DeadUnitsPulse()
  if IsSetpiecePlaying() then
    return
  end
  local units = table.ifilter(g_Units, function(_, u)
    return u.team and u.team.side ~= "neutral" and not u:IsDead() and not u:IsAware("pending") and not u:HasStatusEffect("HighAlert")
  end)
  if #units <= 0 then
    return
  end
  for _, unit in ipairs(g_Units) do
    local side = unit.team and unit.team.side or "neutral"
    if unit.neutral_retaliate then
      side = "enemy1"
    end
    if unit:IsDead() and side ~= "neutral" then
      units = table.ifilter(units, function(_, u)
        return u.team.side == side and not u:HasStatusEffect("IgnoreBodies")
      end)
      if 0 < #units then
        PushUnitAlert("dead body", unit, units)
      end
    end
  end
  AlertPendingUnits()
end
OnMsg.TurnStart = DeadUnitsPulse
OnMsg.UnitDied = DeadUnitsPulse
OnMsg.Idle = AlertPendingUnits
OnMsg.CombatActionEnd = AlertPendingUnits
function OnMsg.CombatEnd()
  MapForEach("map", "Unit", function(unit)
    unit.pending_aware_state = nil
    unit.alerted_by_enemy = nil
    unit.aware_reason = nil
  end)
  dbg_awareness_log("Combat ended")
end
function OnMsg.CombatStart()
  dbg_awareness_log("Combat started")
end
function OnMsg.EnterSector()
  g_AwarenessLog = {}
end
MapGameTimeRepeat("DeadAwarenessPulseTick", 500, function()
  if not g_Combat then
    DeadUnitsPulse()
  end
end)
function Unit:SetPendingAwareState(state, reason, alerter)
  NetUpdateHash("SetPendingAwareState", state, reason, alerter, self.pending_aware_state, self:IsAware())
  if self.dummy or self.team.side == "neutral" or self:IsDead() or self:IsAware() then
    return
  end
  if reason and (not self.aware_reason or table.find(Presets.AwareReasons.Default, "display_name", reason[1]) > table.find(Presets.AwareReasons.Default, "display_name", self.aware_reason[1])) then
    self.aware_reason = reason or self.aware_reason
  end
  if not self.pending_aware_state or state == "aware" and self.pending_aware_state ~= "aware" then
    self.pending_aware_state = state
    self.alerted_by_enemy = alerter or self.alerted_by_enemy
    return true
  elseif self.pending_aware_state == state then
    self.alerted_by_enemy = self.alerted_by_enemy or alerter
    return true
  end
end
function Unit:SuspiciousRoutine()
  local def = CharacterEffectDefs.Suspicious
  Sleep(self:TimeToAngleInterpolationEnd())
  local body = self.suspicious_body_seen and HandleToObject[self.suspicious_body_seen]
  if IsValid(body) then
    self:Face(body, 500)
  end
  local anim = self:TryGetActionAnim("Suspicious", "Standing")
  if anim then
    self:SetState(anim)
  end
  local last_update = GameTime()
  local time = self:GetEffectValue("suspicious_time") or 0
  self:SetEffectValue("suspicious_time", time)
  local grow_time = def:ResolveValue("sight_grow_time")
  local sight_mod_max = def:ResolveValue("sight_modifier_max")
  local delay_time = def:ResolveValue("max_sight_delay")
  local shrink_time = def:ResolveValue("sight_shrink_time")
  repeat
    WaitMsg("CombatStarting", 100)
    if g_Combat then
      break
    end
    local time_now = GameTime()
    time = time + time_now - last_update
    last_update = time_now
    self:SetEffectValue("suspicious_time", time)
    local mod
    if grow_time > time then
      mod = MulDivRound(sight_mod_max, time, grow_time)
    elseif time < grow_time + delay_time then
      mod = sight_mod_max
    elseif time < grow_time + delay_time + shrink_time then
      local t = time - grow_time - delay_time
      mod = MulDivRound(sight_mod_max, shrink_time - t, shrink_time)
    else
      mod = nil
    end
    if self:GetEffectValue("suspicious_sight_mod") ~= mod then
      self:SetEffectValue("suspicious_sight_mod", mod)
      InvalidateUnitLOS(self)
    end
  until not mod
  self:SetEffectValue("suspicious_time", nil)
  self.suspicious_body_seen = nil
  if not g_Combat and not g_StartingCombat and self:HasStatusEffect("Suspicious") then
    local enemies = GetAllEnemyUnits(self)
    local mindist
    for _, enemy in ipairs(enemies) do
      if enemy.team and enemy.team.player_team then
        local dist = self:GetDist(enemy)
        mindist = Min(mindist or dist, dist)
      end
    end
    if mindist and mindist < Suspicious:ResolveValue("remain_unaware_min_dist") * guim then
      TriggerUnitAlert("surprise", self, "suspicious")
    else
      self:AddStatusEffect("Unaware")
    end
  end
end
local PathFromContextDest = function(unit, context, dest)
  for _, stance in ipairs(StancesList) do
    local cpath = context.combat_paths[stance]
    local path = cpath and cpath:GetCombatPathFromPos(dest)
    if path then
      return path
    end
  end
end
function Unit:ClaimRepositionMarker()
  local rep_markers = MapGetMarkers("Reposition", nil, function(marker, unit)
    if g_RepositionMarkersClaimed[marker] then
      return false
    end
    if (marker.TargetUnits or "") ~= "" and marker.TargetUnits ~= unit.unitdatadef_id then
      return false
    end
    local x, y, z = GetPassSlabXYZ(marker)
    if not x then
      return false
    end
    local has_path
    local dest = point_pack(x, y, z)
    for _, stance in ipairs(StancesList) do
      local cpath = unit.ai_context.combat_paths[stance]
      if cpath and cpath:GetAP(dest) then
        has_path = true
        break
      end
    end
    return has_path and CanOccupy(unit, x, y, z) and marker:IsMarkerEnabled()
  end, self)
  if #rep_markers == 0 then
    return
  end
  local idx = 1 + self:Random(#rep_markers)
  return rep_markers[idx]
end
function Unit:PickRepositionDest()
  local context = self.ai_context
  local behavior = context and context.behavior
  context.reposition = true
  context.forced_run = true
  context.ai_destination = false
  self.reposition_dest = false
  self.reposition_marker = false
  if not behavior then
    return
  end
  local marker = self:ClaimRepositionMarker()
  if marker then
    g_RepositionMarkersClaimed[marker] = true
    local x, y, z = GetPassSlabXYZ(marker)
    self.reposition_path = PathFromContextDest(self, context, point_pack(x, y, z))
    if self.reposition_path then
      self.reposition_dest = stance_pos_pack(x, y, z, self.stance)
      self.reposition_marker = marker
    end
  else
    behavior:Think(self)
    if context.ai_destination then
      local x, y, z = stance_pos_unpack(context.ai_destination)
      self.reposition_path = PathFromContextDest(self, context, point_pack(x, y, z))
      if self.reposition_path then
        self.reposition_dest = context.ai_destination
      end
    end
  end
end
function Unit:GetProvokePos(path, visible_only)
  local goto_dummies = self:GenerateTargetDummiesFromPath(path)
  local interrupts, provoke_idx = self:CheckProvokeOpportunityAttacks("move", goto_dummies, visible_only)
  local provoke_pos = provoke_idx and goto_dummies[provoke_idx].pos
  return provoke_pos
end
function Unit:Reposition()
  local always_ready = g_AIExecutionController and g_AIExecutionController.label == "AlwaysReady" and g_AIExecutionController.activator == self
  if not g_Combat or not always_ready and g_Combat:IsRepositioned(self) or self:HasStatusEffect("Unconscious") then
    return
  end
  g_Combat:SetRepositioned(self, true)
  self:PushDestructor(function()
    self.reposition_dest = nil
    self.reposition_path = nil
    self.reposition_marker = nil
  end)
  if not (g_Combat and (self.team ~= g_Teams[g_CurrentTeam] or always_ready)) or self.team.side == "neutral" or self.dummy then
    self:PopAndCallDestructor()
    return
  end
  local context = self.ai_context
  local path = self.reposition_path
  if path then
    local destination = point(point_unpack(path[1]))
    self:SetTargetDummyFromPos(destination, nil, true)
    local x, y, z = point_unpack(path[1])
    local o = GetOccupiedBy(x, y, z, self)
    if o and o ~= self then
      printf("Unit %d reposition to %s is occupied by another unit %d (%s)", self.handle, tostring(point(point_unpack(path[1]))), o.handle, o.command)
      printf("Unit pos %s", tostring(self:GetPos()))
      printf("Unit target dummy pos %s", self.target_dummy and tostring(self.target_dummy:GetPos()) or "")
      printf("Other pos %s", tostring(o:GetPos()))
      printf("Other target dummy pos %s", o.target_dummy and tostring(o.target_dummy:GetPos()) or "")
      printf("Other efResting=%d", o:GetEnumFlags(const.efResting))
      if o.reposition_dest then
        printf("Other reposition dest=%d,%d", stance_pos_unpack(o.reposition_dest))
      end
    end
    if not self:GetProvokePos(path) then
      SetCombatActionState(self, "PostAction")
    end
    if self.pending_awareness_role then
      self:PlayAwarenessAnim()
    else
      Sleep(self:Random(500))
    end
    self:CombatGoto("Move", self.ActionPoints, nil, path, true)
  else
    SetCombatActionState(self, "PostAction")
    if self.pending_awareness_role then
      self:PlayAwarenessAnim()
    end
  end
  self:SetTargetDummyFromPos(nil, nil, true)
  if string.match(self:GetStateText(), ".*_Combat%a+Stop.*") then
    Sleep(self:TimeToAnimEnd())
  end
  local base_idle = self:GetIdleBaseAnim(self.target_dummy.stance)
  if not IsAnimVariant(self:GetStateText(), base_idle) then
    self:PlayTransitionAnims(base_idle, self.target_dummy:GetAngle())
  end
  self:AnimatedRotation(self.target_dummy:GetAngle(), base_idle)
  self:SetRandomAnim(base_idle)
  self:PopAndCallDestructor()
end
function Unit:RepositionOpeningAttack()
  local context = self.ai_context
  if not context then
    return
  end
  local dest = GetPackedPosAndStance(self)
  local target
  if dest then
    self.ActionPoints = context.default_attack_cost
    context.dest_ap[dest] = self.ActionPoints
    context.reposition = false
    AIPrecalcDamageScore(context, {dest})
    target = (context.dest_target or empty_table)[dest]
  end
  if IsKindOf(target, "Unit") and IsValidTarget(target) then
    local bonus_chance = self:HasStatusEffect("OpeningAttackBonus") and CharacterEffectDefs.OpeningAttackBonus:ResolveValue("bonus_chance") or 0
    local chance = Max(0, 30 + self.Dexterity - target.Dexterity + bonus_chance)
    if self.AlwaysUseOpeningAttack or chance > self:Random(100) then
      local weapon = context.default_attack:GetAttackWeapons(self)
      if IsKindOf(weapon, "Firearm") and not IsKindOfClasses(weapon, "HeavyWeapon", "FlareGun") then
        local attacked
        local opening_attack = self.OpeningAttackType
        if opening_attack ~= "Default" and CombatActions[opening_attack]:GetUIState({self}) == "hidden" then
          opening_attack = false
        end
        if opening_attack == "Overwatch" then
          local args, has_ap = AIGetAttackArgs(context, CombatActions.Overwatch, nil, "None")
          if has_ap then
            local zones = AIPrecalcConeTargetZones(context, "Overwatch")
            local zone = AIEvalZones(context, zones, 1, 1)
            if zone then
              local args = {
                target = zone.target_pos
              }
              self:SetCombatBehavior("OverwatchAction", {
                "Overwatch",
                0,
                args
              })
              attacked = true
            end
          end
        elseif opening_attack == "PinDown" then
          local args, has_ap, target = AIGetAttackArgs(context, CombatActions.PinDown, nil, "None")
          if has_ap and IsValidTarget(target) and self:HasPindownLine(target, "Torso") then
            self:SetCombatBehavior("PinDown", {
              "PinDown",
              0,
              args
            })
            local arg = {target = target, target_spot_group = "Torso"}
            attacked = true
          end
        end
        if not attacked then
          self:FirearmAttack(context.default_attack.id, 0, {target = target, opportunity_attack = true})
        end
      elseif IsKindOf(weapon, "MeleeWeapon") then
        self:MeleeAttack(context.default_attack.id, 0, {target = target, opportunity_attack = true})
      end
    end
  end
  local archetype = self:GetCurrentArchetype()
  local chance = 0
  for _, behavior in ipairs(archetype.Behaviors) do
    if behavior:MatchUnit(self) then
      chance = Max(chance, behavior.TakeCoverChance)
    end
  end
  if chance > self:Random(100) then
    self:TakeCover()
  end
  self:RemoveStatusEffect("OpeningAttackBonus")
end
function IsRepositionPhase()
  return g_AIExecutionController and g_AIExecutionController.reposition
end
if Platform.developer then
  function ToggleNoiseSources()
    if not g_NoiseSources then
      return
    end
    if g_NoiseSources.shown then
      for _, obj in ipairs(g_NoiseSources.shown) do
        DoneObject(obj)
      end
      g_NoiseSources.shown = nil
      printf("displayed noise sources removed")
    else
      local list, centers, ranges = {}, {}, {}
      local avg_pos = point30
      for i, descr in ipairs(g_NoiseSources) do
        local obj = PlaceObject("Object")
        obj:ChangeEntity("MarkerMusic")
        obj:SetScale(20)
        obj:SetPos(descr.pos)
        local text = Text:new()
        text:SetText(string.format("%s (%d)", descr.actor.unitdatadef_id, descr.noise))
        obj:Attach(text)
        centers[i] = descr.pos
        ranges[i] = descr.noise * const.SlabSizeX
        list[i] = obj
      end
      if 0 < #list then
        local mesh = Mesh:new()
        local mesh_str = pstr("", 1024)
        AppendVerticesUnionCircles(centers, ranges, mesh_str)
        mesh:SetMeshFlags(const.mfWorldSpace)
        mesh:SetMesh(mesh_str)
        mesh:SetShader(ProceduralMeshShaders.enemy_aware_range)
        mesh:SetColorFromTextStyle("EnemyAwareRange")
        mesh:SetPos(avg_pos:SetInvalidZ() / #list)
        list[#list + 1] = mesh
        g_NoiseSources.shown = list
      end
      printf("%d logged noise sources displayed", #g_NoiseSources)
    end
  end
  function ResetNoiseSources()
    if not g_NoiseSources then
      return
    end
    if g_NoiseSources.shown then
      ToggleNoiseSources()
    end
    g_NoiseSources = {}
  end
  OnMsg.CombatStart = ResetNoiseSources
end
SuspicionThreshold = 160
local lSuspicionTickRate = 100
local lSuspicionTickAmount = 10
local lSuspicionTickAmountProjector = 6
ProjectorSuspiciousApplyRange = 10 * const.SlabSizeX
local lSuspicionTickAmountProne = 5
local lSuspicionTickAmountNotHidden = 16
local lSuspicionTickDownAmount = 2
local lSuspicionTickMinDist = const.SlabSizeX * 2
local lSuspicionTickDistanceModOuter = const.SlabSizeX * 4
local lCubicInIndex = GetEasingIndex("Cubic in")
MapVar("lastSusUpdate", 0)
function OnMsg.CombatEnd()
  for i, u in ipairs(g_Units) do
    u.suspicion = 0
  end
  Msg("CombatEndAfterAwarenessReset")
end
function UpdateSuspicion(alliedUnits, enemyUnits, intermediate_update)
  if GameTime() - lastSusUpdate < lSuspicionTickRate then
    return
  end
  local sneakLights
  if intermediate_update then
    sneakLights = GetSneakProjectorLights()
  end
  local sector = gv_Sectors[gv_CurrentSectorId]
  local anySusUpdated = false
  local susIncreasedBy = {}
  for i, ally in ipairs(alliedUnits) do
    ally.suspicion = ally.suspicion or 0
    if (ally:IsIdleCommand() or ally:IsInterruptable()) and IsValid(ally) then
      local allyDetectionModifier = 100
      if HasPerk(ally, "Untraceable") then
        allyDetectionModifier = allyDetectionModifier - Untraceable:ResolveValue("enemy_detection_reduction")
      end
      if ally:HasStatusEffect("Darkness") then
        allyDetectionModifier = allyDetectionModifier + const.EnvEffects.DarknessDetectionRate
      end
      allyDetectionModifier = Max(0, allyDetectionModifier)
      local raiseSusLargest = 0
      local raiseSusEnemy = false
      for i, enemy in ipairs(enemyUnits) do
        if not enemy.retreating and enemy.command ~= "ExitCombat" and not enemy:IsDead() then
          local seesAlly = HasVisibilityTo(enemy, ally)
          local sightRad, hidden, darkness = enemy:GetSightRadius(ally)
          local dist = enemy:GetDist(ally)
          local inRad = sightRad >= dist
          if inRad then
            if seesAlly then
              local vectorFront = Rotate(axis_x, enemy:GetAngle())
              local vectorBetweenUnits = Normalize(ally:GetPos() - enemy:GetPos())
              local dot = Dot(vectorFront, vectorBetweenUnits)
              if 0 < dot then
                local radiusLess = MulDivRound(sightRad, 80, 100)
              end
              if not (dist > radiusLess) then
                local distFromSightRad = sightRad - dist
                local distanceModifier = false
                if distFromSightRad < lSuspicionTickDistanceModOuter then
                  distanceModifier = Lerp(10, 100, distFromSightRad, sightRad)
                else
                  distanceModifier = 100
                end
                local frontnessModifier = false
                local maxDot = 33554432
                dot = EaseCoeff(lCubicInIndex, dot + 16777216, maxDot)
                frontnessModifier = Lerp(hidden and 30 or 40, 100, dot, maxDot)
                local closeInTheLight = false
                if hidden and not darkness and dist < lSuspicionTickMinDist and 60 < frontnessModifier then
                  closeInTheLight = true
                end
                local value = 0
                if hidden and not closeInTheLight then
                  if ally.stance == "Prone" then
                    value = lSuspicionTickAmountProne
                  else
                    value = lSuspicionTickAmount
                  end
                else
                  value = lSuspicionTickAmountNotHidden
                end
                value = MulDivRound(value, distanceModifier, 100)
                value = MulDivRound(value, frontnessModifier, 100)
                if raiseSusLargest < value then
                  raiseSusEnemy = enemy
                  raiseSusLargest = value
                end
              end
            end
          elseif not raiseSusEnemy and HasVisibilityTo(ally, enemy) then
            local extraRad = MulDivRound(sightRad, 1200, 1000)
            if dist <= extraRad then
              raiseSusEnemy = enemy
            end
          end
        end
      end
      if sneakLights and IsMerc(ally) then
        local lightIndex = IsVoxelIlluminatedByObjects(ally:GetPos(), sneakLights)
        local val = lightIndex ~= 0 and lSuspicionTickAmountProjector or 0
        if raiseSusLargest < val then
          raiseSusLargest = val
          local light = sneakLights[lightIndex]
          local originalLight = light and light.original_light
          local projector = originalLight and originalLight:GetParent()
          if projector then
            raiseSusEnemy = projector
          end
          if ally.suspicion + raiseSusLargest >= SuspicionThreshold and ally:HasStatusEffect("Hidden") then
            ally:RemoveStatusEffect("Hidden")
            CreateMapRealTimeThread(function()
              WaitPlayerControl()
              CreateFloatingText(ally, T({
                488962074575,
                "- <DisplayName>",
                Hidden
              }), nil, nil, true)
            end)
            PushUnitAlert("projector", ally, enemyUnits, projector)
          end
        end
      end
      local oldSus = ally.suspicion
      if 0 < raiseSusLargest then
        ally.suspicion = ally.suspicion + raiseSusLargest
        susIncreasedBy[#susIncreasedBy + 1] = {
          unit = raiseSusEnemy,
          amount = raiseSusLargest,
          sees = ally
        }
      else
        ally.suspicion = ally.suspicion - lSuspicionTickDownAmount
        if raiseSusEnemy then
          susIncreasedBy[#susIncreasedBy + 1] = {
            unit = raiseSusEnemy,
            amount = -1,
            sees = ally
          }
        end
      end
      ally.suspicion = Clamp(ally.suspicion, 0, SuspicionThreshold)
      if ally.suspicion ~= oldSus and ally.ui_badge then
        local wasZeroNowIsnt = oldSus == 0 and ally.suspicion > 0
        local wasntZeroNowIs = 0 < oldSus and ally.suspicion == 0
        if wasZeroNowIsnt or wasntZeroNowIs then
          ally.ui_badge:UpdateActive()
          anySusUpdated = true
        end
      end
      if ally.suspicion >= SuspicionThreshold then
        if sector.warningStateEnabled and not sector.warningReceived then
          EnterWarningState(enemyUnits, alliedUnits, ally)
          anySusUpdated = true
          break
        else
          PushUnitAlert("discovered", ally)
          return
        end
      end
    end
  end
  if anySusUpdated then
    local igi = GetInGameInterfaceModeDlg()
    if igi.crosshair then
      igi.crosshair:UpdateBadgeHiding()
    end
  end
  if not intermediate_update then
    lastSusUpdate = GameTime()
  end
  return susIncreasedBy
end
MapVar("g_CombatStartDetectedVR", false)
function CombatStarDetectedtVR(unit)
  if (not g_Combat or g_Combat:ShouldEndCombat()) and unit:IsMerc() and unit:HasStatusEffect("Hidden") then
    g_CombatStartDetectedVR = true
    PlayVoiceResponse(unit, "CombatStartDetected")
  end
end
function OnMsg.CombatStart()
  if not g_CombatStartDetectedVR and g_Combat.starting_unit then
    if g_LastAttackStealth then
      PlayVoiceResponse(g_Combat.starting_unit, "CombatStartDetected")
    else
      PlayVoiceResponse(g_Combat.starting_unit, "CombatStartPlayer")
    end
  end
end
function OnMsg.CombatEnd()
  g_CombatStartDetectedVR = false
end
function OnMsg:UnitMovementDone(action_id)
  if not (g_Combat and self.team.player_team) or self.command == "EnterCombat" then
    return
  end
  if action_id ~= "Move" then
    return
  end
  PushUnitAlert("discovered", self)
end
MapVar("WarningStateEnemies", {})
function EnterWarningState(enemyUnits, alliedUnits, triggeringUnit)
  local sector = gv_Sectors[gv_CurrentSectorId]
  if sector.inWarningState then
    return
  end
  WarningStateEnemies = enemyUnits
  local warningBanters = sector.warningBanters or {}
  if 0 < #warningBanters then
    local nearestEnemy = GetNearestEnemy(triggeringUnit)
    local banters, actors = FilterAvailableBanters(warningBanters, nil, {nearestEnemy})
    if banters then
      local idx = InteractionRand(#banters, "PlayBanterEffect") + 1
      local lookAt = CalcOrientation(nearestEnemy, triggeringUnit) or nearestEnemy:GetAngle()
      nearestEnemy:SetBehavior()
      nearestEnemy:SetCommand("Idle")
      nearestEnemy:SetAngle(lookAt)
      PlayBanter(banters[idx], actors[idx])
    end
  end
  for _, enemy in ipairs(WarningStateEnemies) do
    enemy:SetSide("neutral")
  end
  local timerId = "warningTimer_" .. sector.Id
  local timerText = sector.warningTimerText or T(243197217972, "Exit the Area")
  TimerCreate(timerId, timerText, sector.warningStateTimer)
  for _, unit in ipairs(alliedUnits) do
    unit.suspicion = 0
  end
  sector.warningReceived = true
  sector.inWarningState = true
  Msg("OnEnterWarningState")
  ExecuteSectorEvents("SE_OnEnterWarningState", sector.Id)
end
function EndWarningState()
  local sector = gv_Sectors[gv_CurrentSectorId]
  if not sector or not sector.inWarningState then
    return
  end
  for _, enemy in ipairs(WarningStateEnemies) do
    enemy:SetSide("enemy1")
  end
  local timerId = "warningTimer_" .. sector.Id
  TimerDelete(timerId)
  sector.inWarningState = false
end
function OnMsg.OnAttack(attacker)
  if IsMerc(attacker) then
    local sector = gv_Sectors[gv_CurrentSectorId]
    if sector.inWarningState then
      EndWarningState()
      attacker.suspicion = SuspicionThreshold
    end
  end
end
function OnMsg.TimerFinished(timerId)
  if string.starts_with(timerId, "warningTimer_") then
    EndWarningState()
  end
end
function OnMsg.AllSquadsLeftSector()
  EndWarningState()
end
function OnMsg.CampaignTimeAdvanced()
  EndWarningState()
end
function PlayBestCombatNotification(units)
  local bestReason = false
  local bestUnitIdx = 0
  for idx, unit in ipairs(units or empty_table) do
    if not bestReason then
      bestReason = unit.aware_reason
      bestUnitIdx = idx
    elseif unit.aware_reason and table.find(Presets.AwareReasons.Default, "display_name", unit.aware_reason[1]) > table.find(Presets.AwareReasons.Default, "display_name", bestReason[1]) then
      bestReason = unit.aware_reason
      bestUnitIdx = idx
    end
  end
  if bestReason then
    local unit = units[bestUnitIdx]
    local isAlly = unit and unit:IsPlayerAlly()
    ShowTacticalNotification(isAlly and "allyAwareReason" or "awareReason", false, bestReason)
  end
end
