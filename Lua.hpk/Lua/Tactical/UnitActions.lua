SpecialGrenades = {
  [1] = "ConcussiveGrenade",
  [2] = "SmokeGrenade",
  [3] = "TearGasGrenade",
  [4] = "ToxicGasGrenade",
  [5] = "Molotov",
  [6] = "FlareStick"
}
function Unit:OnAttack(action, target, results, attack_args, holdXpLog)
  if type(action) == "string" then
    action = CombatActions[action]
  end
  if IsKindOf(results.weapon, "FirearmBase") then
    results.weapon.num_safe_attacks = Max(0, results.weapon.num_safe_attacks - 1)
  end
  if IsKindOf(results.weapon, "TransmutedItemProperties") and results.weapon.RevertCondition == "attacks" then
    results.weapon.RevertConditionCounter = results.weapon.RevertConditionCounter - 1
    if results.weapon.RevertConditionCounter == 0 then
      local slot_name = self:GetItemSlot(results.weapon)
      local new, prev = results.weapon:MakeTransmutation("revert")
      self:RemoveItem(slot_name, results.weapon)
      self:AddItem(slot_name, new)
      DoneObject(prev)
      self:UpdateOutfit()
    end
  end
  if action.ActionType == "Melee Attack" and IsKindOf(target, "Unit") and not results.miss then
    target:AddStatusEffect("Exposed")
  end
  if HasPerk(self, "LastWarning") and 0 < self.team.morale and self:Random(100) < CharacterEffectDefs.LastWarning:ResolveValue("panic_chance") then
    local units = {}
    for _, hit in ipairs(results) do
      local unit = IsKindOf(hit.obj, "Unit") and not hit.obj:IsIncapacitated() and hit.obj
      local damage = hit.damage or 0
      if unit and unit:IsOnEnemySide(self) and (hit.aoe or not hit.stray) and 0 < damage then
        table.insert_unique(units, unit)
        unit:AddStatusEffect("Panicked")
        unit.ActionPoints = unit:GetMaxActionPoints()
      end
    end
  end
  if IsValidTarget(target) then
    target.attacked_this_turn = target.attacked_this_turn or {}
    table.insert(target.attacked_this_turn, self)
  end
  local kill = 0 < #(results.killed_units or empty_table)
  if kill then
    Msg("OnKill", self, results.killed_units)
  end
  local originAction = CombatActions[attack_args.origin_action_id]
  if kill and action.group ~= "SignatureAbilities" and (not originAction or originAction.group ~= "SignatureAbilities") then
    self:UpdateSignatureRecharges("kill")
  end
  if action.group == "SignatureAbilities" then
    local recharge_on_kill = action:ResolveValue("recharge_on_kill") or 0
    local rechargeTime = action:ResolveValue("rechargeTime") or const.Combat.SignatureAbilityRechargeTime
    if 0 < rechargeTime then
      self:AddSignatureRechargeTime(action.id, rechargeTime, 0 < recharge_on_kill)
    end
  end
  Msg("OnAttack", self, action, target, results, attack_args)
  Msg("OnAttacked", self, action, target, results, attack_args)
  local hitUnitFromAttack = false
  for _, hit in ipairs(results.hit_objs) do
    if IsKindOf(hit.obj, "Unit") and hit.damage and 0 < hit.damage then
      hitUnitFromAttack = true
      break
    end
  end
  if results.miss then
    Msg("AttackMiss", self, target)
    if IsKindOf(target, "Unit") and not IsMerc(target) then
      target:AddStatusEffect("AITauntCounter")
      if not hitUnitFromAttack then
        local effect = target:GetStatusEffect("AITauntCounter")
        if effect and effect.stacks >= 3 then
          PlayVoiceResponse(target, "AITaunt")
        end
      end
    end
  end
  if kill and IsMerc(self) then
    if not g_AccumulatedTeamXP then
      g_AccumulatedTeamXP = {}
    end
    for i, unit in ipairs(results.killed_units) do
      if self:IsOnEnemySide(unit) then
        RewardTeamExperience(unit, GetCampaignPlayerTeam())
      end
    end
    if not holdXpLog then
      LogAccumulatedTeamXP("debug")
    end
  end
  if next(results.killed_units) then
    local killCam = not not ActionCameraPlaying
    local waitTime = killCam and const.Combat.UnitDeathKillcamWait or const.Combat.UnitDeathWait
    Sleep(waitTime)
    if killCam then
      Msg("ActionCameraWaitSignalEnd")
    end
  end
end
function Unit:GetLastAttack()
  return self.last_attack_session_id and g_Units[self.last_attack_session_id]
end
local ResetLastAttack = function(unit)
  if unit:IsAmbientUnit() then
    return
  end
  unit.last_attack_session_id = false
  local session_id = unit.session_id
  if session_id then
    for _, u in ipairs(g_Units) do
      if u.last_attack_session_id == session_id then
        u.last_attack_session_id = false
      end
    end
  end
end
function IsBasicAttack(action, attack_args)
  local basicAttack
  if attack_args.origin_action_id then
    basicAttack = CombatActions[attack_args.origin_action_id].basicAttack
  else
    basicAttack = action.basicAttack
  end
  return basicAttack
end
OnMsg.UnitMovementDone = ResetLastAttack
OnMsg.UnitDied = ResetLastAttack
MapVar("g_CurrentAttackActions", {})
MapVar("g_Interrupt", false)
function Unit:FirearmAttack(action_id, cost_ap, args, applied_status)
  do
    local effects = {}
    for i, effect in ipairs(self.StatusEffects) do
      effects[i] = effect.class
    end
    effects = table.concat(effects, ",")
    local target_effects = "-"
    if IsKindOf(args.target, "Unit") then
      target_effects = {}
      for i, effect in ipairs(args.target.StatusEffects) do
        target_effects[i] = effect.class
      end
      target_effects = table.concat(target_effects, ",")
    end
    NetUpdateHash("Unit:FirearmAttack", action_id, cost_ap, self, effects, args.target, target_effects)
  end
  local target = args.target
  if IsPoint(target) or IsValidTarget(target) then
    local action = CombatActions[action_id]
    if HasPerk(self, "Psycho") and (action_id == "SingleShot" or action_id == "BurstFire") then
      local chance = CharacterEffectDefs.Psycho:ResolveValue("procChance")
      local roll = InteractionRand(100, "Psycho")
      if chance > roll then
        local weapon = action:GetAttackWeapons(self)
        if action_id == "SingleShot" and table.find(weapon.AvailableAttacks, "BurstFire") then
          action = CombatActions.BurstFire
          PlayVoiceResponse(self, "Psycho")
        elseif action_id == "BurstFire" and table.find(weapon.AvailableAttacks, "AutoFire") then
          action = CombatActions.AutoFire
          PlayVoiceResponse(self, "Psycho")
        end
      end
    end
    if action.StealthAttack then
      args.stealth_kill_roll = 1 + self:Random(100)
    end
    args.prediction = false
    if IsKindOf(target, "Unit") and target:LightningReaction() then
      args.chance_to_hit = 0
    end
    local results, attack_args = action:GetActionResults(self, args)
    self:ExecFirearmAttacks(action, cost_ap, attack_args, results)
  else
    self:GainAP(cost_ap)
    CombatActionInterruped(self)
  end
end
function Unit:ExecFirearmAttacks(action, cost_ap, attack_args, results)
  self:EndInterruptableMovement()
  NetUpdateHash("ExecFirearmAttacks", action, cost_ap, not not g_Combat)
  local lof_idx = table.find(attack_args.lof, "target_spot_group", attack_args.target_spot_group or "Torso")
  local lof_data = attack_args.lof[lof_idx or 1]
  local target = attack_args.target
  local target_unit = IsKindOf(target, "Unit") and IsValidTarget(target) and target
  local interrupt = attack_args.interrupt
  if interrupt then
    if ActionCameraPlaying then
      RemoveActionCamera(true)
      WaitMsg("ActionCameraRemoved", 5000)
    end
    Msg("InterruptAttackStart", self, target_unit, action)
  end
  NetUpdateHash("ExecFirearmAttacks_After_Interrupt_Cam_Wait")
  results.attack_from_stealth = not not self:HasStatusEffect("Hidden")
  for _, attack in ipairs(results.attacks or {results}) do
    if attack.fired then
      self:AttackReveal(action, attack_args, results)
      break
    end
  end
  local can_provoke_opportunity_attacks = not action or action.id ~= "CancelShot" and action.id ~= "CancelShotCone"
  if can_provoke_opportunity_attacks then
    self:ProvokeOpportunityAttacks("attack interrupt")
  end
  self:PrepareToAttack(attack_args, results)
  if can_provoke_opportunity_attacks then
    self:ProvokeOpportunityAttacks("attack interrupt")
  end
  NetUpdateHash("ExecFirearmAttacks_Start_Action_Cam")
  if attack_args.opportunity_attack_type ~= "Retaliation" then
    local cinematicKill = false
    local dontPlayForLocalPlayer = false
    if g_Combat and IsEnemyKill(self, results) then
      g_Combat:CheckPendingEnd(results.killed_units)
      local isKillCinematic
      isKillCinematic, dontPlayForLocalPlayer = IsEnemyKillCinematic(self, results, attack_args)
      if isKillCinematic then
        cameraTac.SetForceMaxZoom(false)
        SetAutoRemoveActionCamera(self, results.killed_units[1], nil, nil, nil, nil, nil, dontPlayForLocalPlayer)
        cinematicKill = true
      end
    elseif interrupt then
    end
    if not cinematicKill and IsKindOf(target, "Unit") then
      local cinematicAttack, interpolation = IsCinematicAttack(self, results, attack_args, action)
      if cinematicAttack then
        local playerUnit = IsKindOf(target, "Unit") and target:IsLocalPlayerTeam() and target or self:IsLocalPlayerTeam() and self
        local enemyUnit = playerUnit and (playerUnit == target and self or target)
        if playerUnit and enemyUnit then
          SetAutoRemoveActionCamera(playerUnit, enemyUnit, false, false, false, interpolation and default_interpolation_time, nil, dontPlayForLocalPlayer)
        end
      end
    end
  end
  NetUpdateHash("ExecFirearmAttacks_After_Action_Cam")
  local asm = self:GetAnimSpeedModifier()
  local anim_speed_mod = attack_args.anim_speed_mod or 1000
  self:SetAnimSpeedModifier(anim_speed_mod)
  self:PushDestructor(function(self)
    self:SetAnimSpeedModifier(asm)
    if IsValid(target) and target:HasMember("session_id") then
      self.last_attack_session_id = target.session_id
    else
      self.last_attack_session_id = false
    end
    local cooldown = action:ResolveValue("cooldown")
    if cooldown then
      self:SetEffectExpirationTurn(action.id, "cooldown", g_Combat.current_turn + cooldown)
    end
    if IsValid(target) then
      ObjModified(target)
    end
    if interrupt then
      Msg("InterruptAttackEnd")
    end
    table.remove(g_CurrentAttackActions)
  end)
  local ap = cost_ap and 0 < cost_ap and cost_ap or action:GetAPCost(self, attack_args)
  table.insert(g_CurrentAttackActions, {
    action = action,
    cost_ap = ap,
    attack_args = attack_args,
    results = results
  })
  local chance_to_hit = results.chance_to_hit
  local missed = results.miss
  local critical = results.crit
  local chance_crit = results.crit_chance
  local aim_state = self:GetStateText()
  local fired = false
  if results.attacks then
    local shots = results.attacks[1] and results.attacks[1].shots
    self:StartFireAnim(shots and shots[1], attack_args)
    for _, attack in ipairs(results.attacks) do
      attack.weapon:ApplyAmmoUse(self, attack.fired, attack.jammed, attack.condition)
      fired = fired or attack.fired
    end
  else
    self:StartFireAnim(results.shots and results.shots[1], attack_args)
    results.weapon:ApplyAmmoUse(self, results.fired, results.jammed, results.condition)
    fired = results.fired
  end
  if not fired then
    Sleep(self:TimeToAnimEnd())
    self:PopAndCallDestructor()
    NetUpdateHash("ExecFirearmAttacks_early_out")
    return
  end
  PushUnitAlert("noise", self, results.weapon.Noise, Presets.NoiseTypes.Default.Gunshot.display_name)
  local shot_threads = {}
  local attacks = results.attacks or {results}
  local attackArgs = results.attacks_args or {attack_args}
  if results.shots and #results.shots > 8 and g_Combat and not g_Combat:ShouldEndCombat(results.killed_units) and (not results.killed_units or #results.killed_units == 1) then
    local vr = IsMerc(self) and "Autofire" or "AIAutofire"
    PlayVoiceResponse(self, vr)
  end
  local lowChanceShot
  local base_weapon_damage = 0
  for attackIdx, attack in ipairs(attacks) do
    local attackArg = attackArgs[attackIdx]
    local fx_action = attackArg.fx_action
    if action.id == "BulletHell" then
      BulletHellOverwriteShots(attack)
    end
    local shots_per_animation = Min(3, #attack.shots)
    if action.id == "BurstFire" or action.id == "MGBurstFire" then
      shots_per_animation = #attack.shots
    end
    for i, shot in ipairs(attack.shots) do
      attack.weapon:FireBullet(self, shot, shot_threads, results, attackArg)
      if attackArg.single_fx then
        fx_action = ""
      end
      if i < #attack.shots then
        if i % shots_per_animation == 0 then
          local shotAnimDelay = attackArg.attack_anim_delay or self:TimeToAnimEnd()
          self:StartFireAnim(attack.shots[i + 1], attackArg, nil, shotAnimDelay)
        else
          Sleep(self:GetAnimDuration() / shots_per_animation)
        end
      elseif attackIdx < #attacks then
        Sleep(MulDivRound(self:GetAnimDuration() / shots_per_animation, 30, 100))
      end
      if IsMerc(self) and attack.target_hit and attack.chance_to_hit <= 20 then
        lowChanceShot = true
      end
    end
    attack.weapon:FireSpread(attack, attackArg)
    base_weapon_damage = base_weapon_damage + attack.weapon.Damage
  end
  for _, packet in ipairs(results.extra_packets) do
    if IsValidTarget(packet.target) then
      if packet.damage then
        packet.target:TakeDirectDamage(packet.damage, false, "short", packet.message)
      end
      if packet.effects then
        packet.target:ApplyDamageAndEffects(false, false, packet)
      end
    end
  end
  local time_to_fire_end = self:TimeToAnimEnd()
  if self:CanAimIK(results.weapon) then
    local restore_aim_delay = Min(300, time_to_fire_end)
    Sleep(restore_aim_delay)
    self:SetIK("AimIK", lof_data.lof_pos2, nil, nil, 0)
    Sleep(time_to_fire_end - restore_aim_delay)
    self:SetState(aim_state, const.eKeepComponentTargets)
  else
    Sleep(time_to_fire_end)
    self:SetState(aim_state, const.eKeepComponentTargets)
  end
  if self.team.player_team and not g_Combat then
    if IsValid(target_unit) and target_unit.team.neutral and target_unit.neutral_retaliate and not target_unit:IsIncapacitated() then
      target_unit.neutral_retal_attacked = true
      target_unit:SetBehavior()
      target_unit:SetCommand("Idle")
    end
    local hits = 0 < #results and results or results.area_hits
    for _, hit in ipairs(hits) do
      local unit = IsKindOf(hit.obj, "Unit") and not hit.obj:IsIncapacitated() and hit.obj
      if IsValid(unit) and unit.team.neutral and unit.neutral_retaliate then
        target_unit.neutral_retal_attacked = true
        unit:SetBehavior()
        unit:SetCommand("Idle")
      end
    end
  end
  Firearm:WaitFiredShots(shot_threads)
  while target_unit and target_unit.command == "Dodge" do
    WaitMsg("Idle")
  end
  base_weapon_damage = MulDivRound(base_weapon_damage, 120, 100)
  if attacks and next(attacks) then
    self.team.tactical_situations_vr.shotsFired = self.team.tactical_situations_vr.shotsFired and self.team.tactical_situations_vr.shotsFired + 1 or 1
    self.team.tactical_situations_vr.shotsFiredBy = self.team.tactical_situations_vr.shotsFiredBy or {}
    self.team.tactical_situations_vr.shotsFiredBy[self.session_id] = true
    PlayVoiceResponseTacticalSituation(table.find(g_Teams, self.team), "now")
    if missed then
      self.team.tactical_situations_vr.missedShots = self.team.tactical_situations_vr.missedShots and self.team.tactical_situations_vr.missedShots + 1 or 1
      PlayVoiceResponseTacticalSituation(table.find(g_Teams, self.team), "now")
      if 70 <= chance_to_hit then
        if not target_unit or not target_unit:IsCivilian() then
          PlayVoiceResponseMissHighChance(self)
        end
      elseif target_unit and 50 <= chance_to_hit and base_weapon_damage >= target_unit:GetTotalHitPoints() and IsMerc(target_unit) then
        target_unit:SetEffectValue("missed_by_kill_shot", true)
      end
    elseif missed or results.stealth_kill and IsMerc(self) and results.killed_units and #results.killed_units > 0 then
    elseif lowChanceShot and target_unit and not self:IsOnAllySide(target_unit) and not target_unit:IsCivilian() then
      PlayVoiceResponse(self, "LowChanceShot")
    end
  end
  for i, attack in ipairs(attacks) do
    local holdXpLog = i ~= #attacks
    self:OnAttack(action, target_unit, attack, attack_args, holdXpLog)
  end
  LogAttack(action, attack_args, results)
  AttackReaction(action, attack_args, results, "can retaliate")
  if not action or action.id ~= "CancelShot" and action.id ~= "CancelShotCone" then
    self:ProvokeOpportunityAttacks("attack reaction")
  end
  self:PopAndCallDestructor()
end
function Unit:MGSetup(action_id, cost_ap, args)
  self.interruptable = false
  if self.stance ~= "Prone" then
    self:DoChangeStance("Prone")
  end
  self:AddStatusEffect("StationedMachineGun")
  self:UpdateHidden()
  self:FlushCombatCache()
  self:RecalcUIActions(true)
  ObjModified(self)
  return self:MGTarget(action_id, cost_ap, args)
end
function Unit:MGTarget(action_id, cost_ap, args)
  args.permanent = true
  args.num_attacks = self:GetNumMGInterruptAttacks()
  self.interruptable = false
  return self:OverwatchAction(action_id, cost_ap, args)
end
function Unit:MGPack()
  self:InterruptPreparedAttack()
  self:RemoveStatusEffect("StationedMachineGun")
  self:UpdateHidden()
  self:FlushCombatCache()
  self:RecalcUIActions(true)
  if HasPerk(self, "KillingWind") then
    self:RemoveStatusEffect("FreeMove")
    self:AddStatusEffect("FreeMove")
  end
  ObjModified(self)
end
function Unit:OpportunityAttack(action_id, args, status)
  g_Interrupt = true
  args.interrupt = true
  PlayFX("OpportunityAttack", "start", self)
  self:FirearmAttack(action_id, 0, args, status)
end
function Unit:PinDownAttack(target, action_id, target_spot_group, aim, status)
  local args = {
    target = target,
    target_spot_group = target_spot_group,
    aim = aim,
    interrupt = true,
    opportunity_attack = true,
    opportunity_attack_type = "PinDown"
  }
  self:FirearmAttack(action_id, 0, args, status)
end
function Unit:RetaliationAttack(target, target_spot_group, action)
  self:AddStatusEffect("RetaliationCounter")
  PlayFX("OpportunityAttack", "start", self)
  local args = {
    target = target,
    target_spot_group = target_spot_group,
    interrupt = true,
    opportunity_attack = true,
    opportunity_attack_type = "Retaliation"
  }
  if string.match(action.id, "ThrowGrenade") then
    return self:ThrowGrenade(action.id, 0, args)
  end
  return self:FirearmAttack(action.id, 0, args)
end
function Unit:OpportunityMeleeAttack(target, action)
  if self.team and self.team.control == "AI" then
    PlayVoiceResponse(self, "AIMeleeOpportunist")
  end
  PlayFX("OpportunityAttack", "start", self)
  self:MeleeAttack(action.id, 0, {
    target = target,
    opportunity_attack = true,
    opportunity_attack_type = "Retaliation"
  })
end
local tf_smooth_sleep = 100
local tf_smooth_thread = false
function SetTimeFactorSmooth(tf, time)
  DeleteThread(tf_smooth_thread)
  tf_smooth_thread = CreateRealTimeThread(function()
    local curr_tf = GetTimeFactor()
    if curr_tf == tf then
      return
    end
    local delta = MulDivRound(tf - curr_tf, tf_smooth_sleep, time)
    local cmp = curr_tf < tf
    while cmp == (curr_tf + delta < tf) do
      curr_tf = curr_tf + delta
      SetTimeFactor(curr_tf)
      Sleep(tf_smooth_sleep)
    end
    SetTimeFactor(tf)
  end)
end
local smooth_tf_change_duration = 1500
function Unit:RunAndGun(action_id, cost_ap, args)
  local action = CombatActions[action_id]
  local target = args.goto_pos
  local weapon = action:GetAttackWeapons(self)
  if not weapon then
    self:GainAP(cost_ap)
    CombatActionInterruped(self)
    return
  end
  local aim_params = action:GetAimParams(self, weapon)
  local num_shots = aim_params.num_shots
  if self.stance ~= "Standing" then
    self:ChangeStance(action_id, 0, "Standing")
  end
  args.attack_rolls = {}
  args.crit_rolls = {}
  args.stealth_kill_rolls = {}
  for i = 1, num_shots do
    args.attack_rolls[i] = 1 + self:Random(100)
    args.crit_rolls[i] = 1 + self:Random(100)
    if action.StealthAttack then
      args.stealth_kill_rolls[i] = 1 + self:Random(100)
    end
  end
  args.prediction = false
  local results = action:GetActionResults(self, args)
  local action_camera = false
  if #(results.attacks or empty_table) == 0 then
    self:GainAP(cost_ap)
    CombatActionInterruped(self)
    return
  end
  local pathObj, path
  self:PushDestructor(function(self)
    if pathObj then
      DoneObject(pathObj)
    end
  end)
  pathObj = CombatPath:new()
  if action_camera then
    local tf = GetTimeFactor()
    self:PushDestructor(function()
      SetTimeFactorSmooth(tf, smooth_tf_change_duration)
    end)
  end
  local base_idle = self:GetIdleBaseAnim()
  for i, attack in ipairs(results.attacks) do
    if self:CanUseWeapon(weapon) then
      if attack.mobile_attack_pos and not IsValidTarget(attack.mobile_attack_target) then
        local enemies = action:GetTargets({self})
        attack.mobile_attack_target = FindTargetFromPos(action_id, self, action, enemies, point(point_unpack(attack.mobile_attack_pos)), weapon)
      end
      if attack.mobile_attack_pos and IsValidTarget(attack.mobile_attack_target) then
        if action_camera and i == 1 then
          SetTimeFactorSmooth(tf / 2, smooth_tf_change_duration)
        end
        local targetPos = point(point_unpack(attack.mobile_attack_pos))
        local occupiedPos = self:GetOccupiedPos()
        if self:GetDist(occupiedPos) > const.SlabSizeX / 2 and self:GetDist(targetPos) < const.SlabSizeX / 2 then
          self:SetTargetDummy(nil, nil, base_idle, 0)
        else
          pathObj:RebuildPaths(self, aim_params.move_ap)
          path = pathObj:GetCombatPathFromPos(targetPos)
          self:CombatGoto(action_id, 0, nil, path, true, i == #results.attacks and args.toDoStance)
        end
        if action_camera then
          if i == #results.attacks then
            SetTimeFactorSmooth(tf, smooth_tf_change_duration)
          end
          SetActionCamera(self, attack.mobile_attack_target)
        end
        self:SetRandomAnim(base_idle)
        local atk_action = CombatActions[attack.mobile_attack_id] or action
        local atk_args = {
          prediction = false,
          target = attack.mobile_attack_target,
          stance = "Standing",
          can_use_covers = i == #results.attacks,
          used_action_id = action_id
        }
        local atk_results, attack_args = atk_action:GetActionResults(self, atk_args)
        attack_args.origin_action_id = action_id
        attack_args.keep_ui_mode = true
        attack_args.unit_moved = true
        if atk_action.id == "KnifeThrow" then
          self:ExecKnifeThrow(atk_action, cost_ap, attack_args, atk_results)
        else
          self:ExecFirearmAttacks(atk_action, cost_ap, attack_args, atk_results)
        end
      end
    end
  end
  local cooldown = action:ResolveValue("cooldown")
  if cooldown then
    self:SetEffectExpirationTurn(action.id, "cooldown", g_Combat.current_turn + cooldown)
  end
  if action_camera then
    RemoveActionCamera()
    self:PopAndCallDestructor()
  end
  local occupiedPos = self:GetOccupiedPos()
  if self.return_pos and self.return_pos:Dist(target) < const.SlabSizeX / 2 then
    self:ReturnToCover()
  elseif self:GetDist(occupiedPos) > const.SlabSizeX / 2 and self:GetDist(target) < const.SlabSizeX / 2 then
    self:SetTargetDummyFromPos()
  else
    pathObj:RebuildPaths(self, aim_params.move_ap)
    path = pathObj:GetCombatPathFromPos(target)
    self:CombatGoto(action_id, 0, nil, path, true)
  end
  self:PopAndCallDestructor()
end
function Unit:HundredKnives(action_id, cost_ap, args)
  local action = CombatActions[action_id]
  local recharge_on_kill = action:ResolveValue("recharge_on_kill") or 0
  self:AddSignatureRechargeTime(action_id, const.Combat.SignatureAbilityRechargeTime, 0 < recharge_on_kill)
  self:RunAndGun(action_id, cost_ap, args)
end
function Unit:RecklessAssault(action_id, cost_ap, args)
  self:RunAndGun(action_id, cost_ap, args)
  self:SetTired(self.Tiredness + 1)
end
function Unit:HeavyWeaponAttack(action_id, cost_ap, args)
  local target = args.target
  if not IsPoint(target) and not IsValidTarget(target) then
    self:GainAP(cost_ap)
    CombatActionInterruped(self)
    return
  end
  self:ProvokeOpportunityAttacks("attack interrupt")
  local action = CombatActions[action_id]
  local weapon = action:GetAttackWeapons(self)
  args.prediction = false
  local results, attack_args = action:GetActionResults(self, args)
  results.attack_from_stealth = not not self:HasStatusEffect("Hidden")
  if results.fired then
    self:AttackReveal(action, attack_args, results)
  end
  self:PrepareToAttack(attack_args, results)
  self:ProvokeOpportunityAttacks("attack interrupt")
  self:PushDestructor(function()
    local ap = cost_ap and 0 < cost_ap and cost_ap or action:GetAPCost(self, attack_args)
    table.insert(g_CurrentAttackActions, {
      action = action,
      cost_ap = ap,
      attack_args = attack_args,
      results = results
    })
    local aim_pos = results and results.trajectory and results.trajectory[2] and results.trajectory[2].pos
    self:StartFireAnim(nil, attack_args, aim_pos)
    local anim_end_time = GameTime() + self:TimeToAnimEnd()
    local prev = weapon.Condition
    weapon.Condition = results.condition
    if prev ~= results.condition then
      Msg("ItemChangeCondition", weapon, prev, results.condition, self)
    end
    weapon:ApplyAmmoUse(self, results.fired, results.jammed, results.condition)
    if not results.jammed and results.trajectory then
      local ordnance = results.ordnance
      local trajectory = results.trajectory
      local action_dir = SetLen(trajectory[2].pos - trajectory[1].pos, 4096)
      local visual_obj = weapon:GetVisualObj(self)
      local actor_class = visual_obj.fx_actor_class
      visual_obj.fx_actor_class = weapon:GetFxClass()
      PlayFX("WeaponFire", "start", visual_obj, nil, trajectory[1].pos, action_dir)
      visual_obj.fx_actor_class = actor_class
      local attaches = visual_obj:GetAttaches("OrdnanceVisual")
      local projectile
      if attaches then
        projectile = attaches[1]
        projectile:Detach()
      else
        projectile = PlaceObject("OrdnanceVisual", {
          fx_actor_class = ordnance.class
        })
      end
      if IsKindOf(weapon, "RocketLauncher") then
        weapon:UpdateRocket()
        PlayFX("RocketFire", "start", projectile)
      end
      local backfire_results = table.copy(results)
      for i = #backfire_results, 1, -1 do
        if not backfire_results[i].backfire then
          table.remove(backfire_results, i)
        end
      end
      for i = #results, 1, -1 do
        if results[i].backfire then
          table.remove(results, i)
        end
      end
      ApplyExplosionDamage(self, nil, backfire_results, nil, "disable burn FXes")
      local rpm_range = const.Combat.GrenadeMaxRPM - const.Combat.GrenadeMinRPM
      local rpm = const.Combat.GrenadeMinRPM + self:Random(rpm_range)
      local rotation_axis = RotateAxis(axis_x, axis_z, CalcOrientation(trajectory[2].pos, trajectory[1].pos))
      if weapon.trajectory_type == "line" then
        rpm = 0
      end
      local throw_thread = CreateGameTimeThread(AnimateThrowTrajectory, projectile, trajectory, rotation_axis, -rpm, "GrenadeDrop")
      Sleep(self:TimeToAnimEnd())
      if IsValidThread(throw_thread) then
        local anim = self:GetAimAnim()
        self:SetState(anim, const.eKeepComponentTargets)
        while IsValidThread(throw_thread) do
          WaitMsg("GrenadeDoneThrow", 20)
        end
      end
      args.explosion_pos = results.explosion_pos or projectile:GetPos()
      results, attack_args = action:GetActionResults(self, args)
      ApplyExplosionDamage(self, projectile, results)
      LogAttack(action, attack_args, results)
      PushUnitAlert("noise", projectile, ordnance.Noise, Presets.NoiseTypes.Default.Explosion.display_name)
      if IsValid(projectile) then
        DoneObject(projectile)
      end
      AttackReaction(action, attack_args, results)
      self:OnAttack(action_id, nil, results, attack_args)
    end
    if 0 < anim_end_time - GameTime() then
      Sleep(anim_end_time - GameTime())
    end
    local dlg = GetInGameInterfaceModeDlg()
    if dlg and dlg:HasMember("dont_return_camera_on_close") then
      dlg.dont_return_camera_on_close = true
    end
    local cooldown = action:ResolveValue("cooldown")
    if cooldown then
      self:SetEffectExpirationTurn(action.id, "cooldown", g_Combat.current_turn + cooldown)
    end
    self.last_attack_session_id = false
    self:ProvokeOpportunityAttacks("attack reaction")
    table.remove(g_CurrentAttackActions)
  end)
  self:PopAndCallDestructor()
end
function Unit:FireFlare(action_id, cost_ap, args)
  local target = args.target
  if not IsPoint(target) and not IsValidTarget(target) then
    self:GainAP(cost_ap)
    CombatActionInterruped(self)
    return
  end
  self:ProvokeOpportunityAttacks("attack interrupt")
  local action = CombatActions[action_id]
  local weapon = action:GetAttackWeapons(self)
  args.prediction = false
  local results, attack_args = action:GetActionResults(self, args)
  results.attack_from_stealth = not not self:HasStatusEffect("Hidden")
  if results.fired then
    self:AttackReveal(action, attack_args, results)
  end
  self:PrepareToAttack(attack_args, results)
  self:ProvokeOpportunityAttacks("attack interrupt")
  local fire_anim = self:GetAttackAnim(action_id)
  local aim_anim = self:GetAimAnim(action_id)
  self:SetState(fire_anim)
  local duration = self:TimeToAnimEnd()
  local hit_moment = self:TimeToMoment(1, "hit") or duration / 2
  Sleep(hit_moment)
  local weapon_visual = weapon:GetVisualObj(self)
  PlayFX("FlareHandgun_Fire", "start", weapon_visual)
  local thread = not results.jammed and CreateGameTimeThread(function()
    local visual = PlaceObject("GrenadeVisual", {
      fx_actor_class = "FlareBullet"
    })
    local offset = point(0, 0, 200 * guic)
    offset = offset + Rotate(point(30 * guic, 0, 0), self:GetAngle() + 5400) + Rotate(point(20 * guic, 0, 0), self:GetAngle())
    local pos = self:GetPos()
    if not pos:IsValidZ() then
      pos = pos:SetTerrainZ()
    end
    pos = pos + offset
    visual:SetPos(pos)
    Sleep(100)
    visual:SetPos(pos + point(0, 0, 20 * guim), 1500)
    Sleep(2000)
    local explosion_pos = results.explosion_pos + point(0, 0, 10 * guic)
    local sky_pos = explosion_pos + point(0, 0, 20 * guim)
    local col, pts = CollideSegmentsNearest(sky_pos, explosion_pos)
    if col then
      explosion_pos = pts[1]
    end
    visual:SetPos(sky_pos)
    local fall_time = MulDivRound(sky_pos:Dist(explosion_pos), 1000, const.Combat.MortarFallVelocity / 5)
    visual:SetPos(explosion_pos, fall_time)
    Sleep(fall_time)
    local flare = PlaceObject("FlareOnGround", {
      visual_obj = visual,
      remaining_time = 20000,
      Despawn = true,
      campaign_time = Game.CampaignTime
    })
    flare:SetPos(explosion_pos)
    flare:UpdateVisualObj()
    PushUnitAlert("thrown", flare, self)
    Wakeup(self.command_thread)
  end)
  Sleep(duration - hit_moment)
  self:SetRandomAnim(self:GetIdleBaseAnim())
  results.weapon:ApplyAmmoUse(self, results.fired, results.jammed, results.condition)
  while IsValidThread(thread) do
    WaitWakeup(50)
  end
  self.last_attack_session_id = false
  self:ProvokeOpportunityAttacks("attack reaction")
end
function Unit:ThrowGrenade(action_id, cost_ap, args)
  self:EndInterruptableMovement()
  local stealth_attack = not not self:HasStatusEffect("Hidden")
  local target_pos = args.target
  if self.stance ~= "Standing" then
    self:ChangeStance(nil, nil, "Standing")
  end
  self:ProvokeOpportunityAttacks("attack interrupt")
  local action = CombatActions[action_id]
  local grenade = action:GetAttackWeapons(self)
  args.prediction = false
  local results, attack_args = action:GetActionResults(self, args)
  self:PrepareToAttack(attack_args, results)
  self:UpdateAttachedWeapons()
  self:ProvokeOpportunityAttacks("attack interrupt")
  if not attack_args.opportunity_attack_type == "Retaliation" and g_Combat and IsEnemyKill(self, results) then
    g_Combat:CheckPendingEnd(results.killed_units)
    local isKillCinematic, dontPlayForLocalPlayer = IsEnemyKillCinematic(self, results, attack_args)
    if isKillCinematic then
      cameraTac.SetForceMaxZoom(false)
      SetAutoRemoveActionCamera(self, results.killed_units[1], nil, nil, nil, nil, nil, dontPlayForLocalPlayer)
    end
  end
  self:RemoveStatusEffect("FirstThrow")
  local attacks = results.attacks or {results}
  local ap = cost_ap and 0 < cost_ap and cost_ap or action:GetAPCost(self, attack_args)
  table.insert(g_CurrentAttackActions, {
    action = action,
    cost_ap = ap,
    attack_args = attack_args,
    results = results
  })
  self:PushDestructor(function(self)
    self:ForEachAttach("GrenadeVisual", DoneObject)
    table.remove(g_CurrentAttackActions)
    self.last_attack_session_id = false
    local dlg = GetInGameInterfaceModeDlg()
    if dlg and dlg:HasMember("dont_return_camera_on_close") then
      dlg.dont_return_camera_on_close = true
    end
  end)
  self:SetState("gr_Standing_Attack", const.eKeepComponentTargets)
  local visual_objs = {}
  for i = 1, #attacks do
    local visual_obj = grenade:GetVisualObj(self, 1 < i)
    visual_objs[i] = visual_obj
    PlayFX("GrenadeActivate", "start", visual_obj)
  end
  local time_to_hit = self:TimeToMoment(1, "hit") or 20
  self:Face(target_pos, time_to_hit / 2)
  Sleep(time_to_hit)
  if not (not results.miss and results.killed_units) or not (#results.killed_units > 1) then
    local specialNadeVr = not table.find(SpecialGrenades, grenade.class) or IsMerc(self) and "SpecialThrowGrenade" or "AIThrowGrenadeSpecial"
    local standardNadeVr = IsMerc(self) and "ThrowGrenade" or "AIThrowGrenade"
    PlayVoiceResponse(self, specialNadeVr or standardNadeVr)
  end
  local thread = CreateGameTimeThread(function()
    local threads = {}
    for i, attack in ipairs(attacks) do
      visual_objs[i]:Detach()
      visual_objs[i]:SetHierarchyEnumFlags(const.efVisible)
      local trajectory = attack.trajectory
      if 0 < #trajectory then
        local rpm_range = const.Combat.GrenadeMaxRPM - const.Combat.GrenadeMinRPM
        local rpm = const.Combat.GrenadeMinRPM + self:Random(rpm_range)
        local rotation_axis = RotateAxis(axis_x, axis_z, CalcOrientation(trajectory[2].pos, trajectory[1].pos))
        threads[i] = CreateGameTimeThread(AnimateThrowTrajectory, visual_objs[i], trajectory, rotation_axis, rpm, "GrenadeDrop")
      else
        threads[i] = CreateGameTimeThread(ItemFallDown, visual_objs[i])
      end
    end
    grenade:OnThrow(self, visual_objs)
    while 0 < #threads do
      Sleep(25)
      for i = #threads, 1, -1 do
        if not IsValidThread(threads[i]) then
          table.remove(threads, i)
        end
      end
    end
    if 1 < #attacks then
      args.explosion_pos = {}
      for i, res in ipairs(attacks) do
        args.explosion_pos[i] = res.explosion_pos
      end
    else
      args.explosion_pos = results.explosion_pos
    end
    results, attack_args = action:GetActionResults(self, args)
    local attacks = results.attacks or {results}
    results.attack_from_stealth = stealth_attack
    local destroy_grenade
    if not self.infinite_ammo then
      grenade.Amount = grenade.Amount - #attacks
      destroy_grenade = 0 >= grenade.Amount
      if destroy_grenade then
        local slot = self:GetItemSlot(grenade)
        self:RemoveItem(slot, grenade)
      end
      ObjModified(self)
    end
    self:AttackReveal(action, attack_args, results)
    self:OnAttack(action_id, nil, results, attack_args)
    LogAttack(action, attack_args, results)
    for i, attack in ipairs(attacks) do
      grenade:OnLand(self, attack, visual_objs[i])
    end
    if destroy_grenade then
      DoneObject(grenade)
    end
    AttackReaction(action, attack_args, results)
    Msg(CurrentThread())
  end)
  Sleep(self:TimeToAnimEnd())
  self:SetRandomAnim(self:GetIdleBaseAnim())
  if IsValidThread(thread) then
    WaitMsg(thread)
  end
  self:ProvokeOpportunityAttacks("attack reaction")
  self:PopAndCallDestructor()
end
function Unit:RemoteDetonate(action_id, cost_ap, args)
  local target_pos = args.target
  local action = CombatActions[action_id]
  local detonator = action:GetAttackWeapons(self)
  local traps = detonator:GetAttackResults(false, {target_pos = target_pos})
  for i, t in ipairs(traps) do
    t.obj:TriggerTrap()
  end
end
function Unit:FaceAttackerCommand(attacker, angle)
  angle = angle or CalcOrientation(self, attacker)
  self:AnimatedRotation(angle)
  self:SetRandomAnim(self:GetIdleBaseAnim(), const.eKeepComponentTargets)
  self:SetCommand("WaitAttacker")
end
function Unit:WaitAttacker(timeout)
  Sleep(timeout or 2000)
end
function Unit:MeleeAttack(action_id, cost_ap, args)
  self:EndInterruptableMovement()
  local new_stance = self.stance ~= "Standing" and self.species == "Human" and "Standing"
  local stealth_attack = not not self:GetStatusEffect("Hidden")
  if new_stance then
    local stance = self.stance
    self:PushDestructor(function(self)
      self:GainAP(cost_ap)
      self:ChangeStance(nil, nil, stance)
    end)
    if new_stance then
      self:ChangeStance(nil, nil, "Standing")
    end
    self:PopDestructor()
  end
  local action = CombatActions[action_id]
  local weapon = action:GetAttackWeapons(self)
  local target = args.target
  if IsKindOf(target, "Unit") and not IsMeleeRangeTarget(self, nil, self.stance, target, nil, target.stance) then
    self:GainAP(cost_ap)
    ShowBadgeOfAttacker(self, false)
    return
  end
  args.attack_roll = 1 + self:Random(100)
  args.crit_roll = 1 + self:Random(100)
  if action.StealthAttack then
    args.stealth_attack = stealth_attack
    args.stealth_kill_roll = 1 + self:Random(100)
  end
  args.prediction = false
  self:PushDestructor(function(self)
    table.remove(g_CurrentAttackActions)
    if IsValid(target) and (target.command == "WaitAttacker" or target.command == "FaceAttackerCommand") then
      target:SetCommand("Idle")
    end
  end)
  local results, attack_args = action:GetActionResults(self, args)
  results.attack_from_stealth = stealth_attack
  local ap = cost_ap and 0 < cost_ap and cost_ap or action:GetAPCost(self, attack_args)
  table.insert(g_CurrentAttackActions, {
    action = action,
    cost_ap = ap,
    attack_args = attack_args,
    results = results
  })
  self:AttackReveal(action, attack_args, results)
  self.marked_target_attack_args = nil
  if not HasPerk(self, "HardBlow") then
    self:ProvokeOpportunityAttacks("attack interrupt", nil, "melee")
  end
  if not attack_args.opportunity_attack_type == "Retaliation" then
    if g_Combat and IsEnemyKill(self, results) then
      g_Combat:CheckPendingEnd(results.killed_units)
    end
    if IsKindOf(target, "Unit") and IsCinematicAttack(self, results, attack_args, action) then
      SetAutoRemoveActionCamera(self, target, false, false, false, default_interpolation_time)
    end
  end
  local anim, face_angle, fx_actor
  if self.species == "Human" then
    local base_anim
    if self.infected then
      fx_actor = "fist"
      base_anim = "inf_Standing_Attack"
    else
      local attach_forward = target.stance == "Standing" and attack_args.target_spot_group ~= "Legs" or target.stance == "Crouch" and attack_args.target_spot_group == "Head"
      if weapon.IsUnarmed then
        fx_actor = "fist"
        base_anim = attach_forward and "nw_Standing_Attack_Forward" or "nw_Standing_Attack_Down"
      else
        fx_actor = "knife"
        if IsKindOf(weapon, "MacheteWeapon") then
          fx_actor = "machete"
          base_anim = attach_forward and "mk_Standing_Machete_Attack_Forward" or "mk_Standing_Machete_Attack_Down"
        else
          base_anim = attach_forward and "mk_Standing_Attack_Forward" or "mk_Standing_Attack_Down"
        end
      end
    end
    anim = self:GetRandomAnim(base_anim)
    face_angle = CalcOrientation(self, target)
  else
    anim = "attack"
    fx_actor = "jaws"
    local can_attack
    can_attack, face_angle = IsMeleeRangeTarget(self, nil, self.stance, target, nil, target.stance)
    if self.species == "Crocodile" then
      local head_pos = SnapToVoxel(RotateRadius(const.SlabSizeX, face_angle, self))
      local adiff = AngleDiff(CalcOrientation(head_pos, target), face_angle)
      local variant = Clamp(4 + adiff / 2700, 1, 7)
      if 1 < variant then
        anim = anim .. variant
      end
    end
  end
  if face_angle then
    if self.body_type == "Large animal" then
      self:AnimatedRotation(face_angle)
    else
      self:SetOrientationAngle(face_angle, 100)
    end
  end
  if g_Combat and action_id ~= "Charge" and not args.opportunity_attack and IsKindOf(target, "Unit") and not target:IsDead() and target.stance ~= "Prone" and not target:IsDowned() and not target:HasStatusEffect("ManningEmplacement") then
    local target_face_angle
    if target.body_type == "Large animal" then
      if abs(target:AngleToObject(self)) > 5400 then
        target_face_angle = target:GetAngle() + 10800
      end
    else
      local target_angle = CalcOrientation(target, self)
      if 2700 < abs(AngleDiff(target_angle, target:GetOrientationAngle())) then
        target_face_angle = target_angle
      end
    end
    if target_face_angle then
      if target:IsCommandThread() then
        local speed_mod = target:GetAnimSpeedModifier()
        target:SetAnimSpeedModifier(1000)
        target:AnimatedRotation(target_face_angle)
        target:SetAnimSpeedModifier(speed_mod)
      elseif target:IsInterruptable() then
        self:SetRandomAnim(self:GetIdleBaseAnim())
        target:SetCommand("FaceAttackerCommand", self, target_face_angle)
        for i = 1, 200 do
          if target.command ~= "FaceAttackerCommand" then
            break
          end
          Sleep(50)
        end
      end
    end
  end
  if g_AIExecutionController and not ActionCameraPlaying then
    local targetPos = target:GetVisualPos()
    local cameraIsNear = DoPointsFitScreen({targetPos}, nil, const.Camera.BufferSizeNoCameraMov)
    if not cameraIsNear then
      AdjustCombatCamera("set", nil, targetPos, GetFloorOfPos(SnapToPassSlab(targetPos)), nil, "NoFitCheck")
    end
  end
  if not g_AITurnContours[self.handle] and g_Combat and g_AIExecutionController then
    local enemy = self.team.side == "enemy1" or self.team.side == "enemy2" or self.team.side == "neutralEnemy"
    g_AITurnContours[self.handle] = SpawnUnitContour(self, enemy and "CombatEnemy" or "CombatAlly")
    ShowBadgeOfAttacker(self, true)
  end
  ShowBadgesOfTargets({target}, "show")
  self:SetAnim(1, anim)
  local fx_target
  if IsKindOf(target, "Unit") then
    fx_target = target
  elseif IsValid(target) then
    fx_target = GetObjMaterial(target:GetPos(), target) or target
  elseif IsPoint(target) then
    fx_target = GetObjMaterial(target) or "air"
  end
  PlayFX("MeleeAttack", "start", fx_actor, fx_target, self:GetVisualPos())
  local tth = self:TimeToMoment(1, "hit") or self:TimeToAnimEnd() / 2
  repeat
    Sleep(tth)
    tth = self:TimeToMoment(1, "hit", 2)
    if tth and not results.miss and IsKindOf(target, "Unit") then
      target:Pain()
    end
  until not tth
  local attack_roll = results.attack_roll
  local roll = type(attack_roll) == "number" and attack_roll or type(attack_roll) == "table" and Untranslated(table.concat(attack_roll, ", ")) or nil
  if results.miss then
    CreateFloatingText(target, T(699485992722, "Miss"), "FloatingTextMiss")
    PlayFX("MeleeAttack", "miss", fx_actor, false, self:GetVisualPos())
  else
    local resolve_steroid_punch = action_id == "SteroidPunch" and IsValidTarget(target) and IsKindOf(target, "Unit")
    for _, hit in ipairs(results) do
      local obj = hit.obj
      if IsValid(obj) and not obj:IsDead() and 0 < hit.damage then
        if IsKindOf(obj, "Unit") then
          obj:ApplyDamageAndEffects(self, hit.damage, hit, hit.armor_decay)
        else
          obj:TakeDamage(hit.damage, self, hit)
        end
      end
    end
    PlayFX("MeleeAttack", "hit", fx_actor, fx_target, IsValid(target) and target:GetVisualPos() or self:GetVisualPos())
    if resolve_steroid_punch then
      self:ResolveSteroidPunch(args, results)
    end
  end
  self:OnAttack(action_id, target, results, attack_args)
  Sleep(self:TimeToAnimEnd())
  LogAttack(action, attack_args, results)
  if not HasPerk(self, "HardBlow") then
    self:ProvokeOpportunityAttacks("attack reaction", nil, "melee")
  end
  AttackReaction(action, attack_args, results, "can retaliate")
  ShowBadgesOfTargets({target}, "hide")
  if IsValid(target) then
    ObjModified(target)
  end
  self.last_attack_session_id = false
  self:PopAndCallDestructor()
end
function Unit:ExplodingPalm(action_id, cost_ap, args)
  return self:MeleeAttack(action_id, cost_ap, args)
end
function Unit:GetNumBrutalizeAttacks(goto_pos)
  local ap = self:GetUIActionPoints()
  if goto_pos then
    local cp = GetCombatPath(self)
    local cost = cp and cp:GetAP(goto_pos) or 0
    ap = Min(self:GetUIActionPoints(), self.ActionPoints - cost)
  end
  local action = self:GetDefaultAttackAction()
  local base_cost = action:GetAPCost(self)
  local num = 3
  if base_cost then
    num = ap / MulDivRound(base_cost, 66, 100)
  end
  return Max(3, num)
end
function Unit:Brutalize(action_id, cost_ap, args)
  local target = args.target
  if not IsKindOf(target, "Unit") then
    return
  end
  local action = CombatActions[action_id]
  local weapon = action:GetAttackWeapons(self)
  if not IsKindOf(weapon, "MeleeWeapon") then
    return
  end
  local bodyParts = target:GetBodyParts(weapon)
  local num_attacks = args.num_attacks or 3
  for i = 1, num_attacks do
    local bodyPart = table.interaction_rand(bodyParts, "Combat")
    args.target_spot_group = bodyPart.id
    args.target_spot_group = bodyPart.id
    self:MeleeAttack(action_id, 0, args)
    if not (IsValid(self) and not self:IsIncapacitated() and IsValidTarget(target)) then
      break
    end
  end
  local target = args.target
  if IsKindOf(target, "Unit") and IsValidTarget(target) then
    target:AddStatusEffect("Exposed")
  end
  self.ActionPoints = 0
  if self:IsLocalPlayerControlled() then
    GetInGameInterfaceModeDlg():NextUnit(self.team, "force")
  end
end
function Unit:MarkTarget(action_id, cost_ap, attack_args)
  if not g_Combat then
    self.marked_target_attack_args = attack_args
    ShowSneakModeTutorialPopup(self)
    ShowSneakApproachTutorialPopup(self)
    local target = attack_args.target
    CreateBadgeFromPreset("MarkedBadge", target, target)
  end
end
function Unit:CancelMark()
  self.marked_target_attack_args = nil
end
function Unit:IsMarkedForStealthAttack(attacker)
  for _, unit in ipairs(g_Units) do
    if unit ~= self and unit.marked_target_attack_args and unit.marked_target_attack_args.target == self and (not attacker or attacker == unit) then
      return true
    end
  end
end
function Unit:ThrowKnife(action_id, cost_ap, args)
  local target = args.target
  if not IsPoint(target) and not IsValidTarget(target) then
    self:GainAP(cost_ap)
    CombatActionInterruped(self)
    return
  end
  local action = CombatActions[action_id]
  if action.StealthAttack then
    args.stealth_kill_roll = 1 + self:Random(100)
  end
  args.prediction = false
  local results, attack_args = action:GetActionResults(self, args)
  self:ExecKnifeThrow(action, cost_ap, attack_args, results)
end
function Unit:ExecKnifeThrow(action, cost_ap, attack_args, results)
  self:EndInterruptableMovement()
  local target = attack_args.target
  local target_unit = IsKindOf(target, "Unit") and IsValidTarget(target) and target
  local target_pos = IsPoint(target) and target or target:GetPos()
  results.attack_from_stealth = not not self:HasStatusEffect("Hidden")
  self:AttackReveal(action, attack_args, results)
  self:ProvokeOpportunityAttacks("attack interrupt")
  if self.stance == "Prone" then
    self:DoChangeStance("Standing")
  end
  self:PrepareToAttack(attack_args, results)
  self:ProvokeOpportunityAttacks("attack interrupt")
  local weapon = action:GetAttackWeapons(self)
  self:PushDestructor(function(self)
    self:AttachActionWeapon(action)
    local visual_obj = self.custom_weapon_attach or weapon:GetVisualObj(self)
    if g_Combat and IsEnemyKill(self, results) then
      g_Combat:CheckPendingEnd(results.killed_units)
      local target
      for _, unit in ipairs(results.killed_units) do
        if unit ~= self then
          target = unit
          break
        end
      end
      local isKillCinematic, dontPlayForLocalPlayer = IsEnemyKillCinematic(self, results, attack_args)
      if target and isKillCinematic then
        cameraTac.SetForceMaxZoom(false)
        SetAutoRemoveActionCamera(self, target, nil, nil, nil, nil, nil, dontPlayForLocalPlayer)
      end
    end
    self:SetState("mk_Standing_Fire", const.eKeepComponentTargets)
    local time_to_hit = self:TimeToMoment(1, "hit") or 20
    self:Face(target_pos, time_to_hit / 2)
    Sleep(time_to_hit)
    local visual_attach_spot = visual_obj:GetAttachSpot()
    local visual_attach_parent = visual_obj:GetParent()
    local start_pos, start_angle, start_axis = visual_obj:GetSpotLoc(-1)
    visual_obj:Detach()
    visual_obj:SetPos(start_pos)
    visual_obj:SetAxisAngle(start_axis, start_angle, 0)
    PlayFX("ThrowKnife", "start", visual_obj)
    local trajectory = results.trajectory
    local throw_thread
    if 0 < #trajectory then
      local rotation_axis = RotateAxis(axis_y, axis_z, CalcOrientation(trajectory[2].pos, trajectory[1].pos))
      local rpm_range = const.Combat.KnifeMaxRPM - const.Combat.KnifeMinRPM
      local rpm = const.Combat.KnifeMinRPM + self:Random(rpm_range)
      throw_thread = CreateGameTimeThread(AnimateThrowTrajectory, visual_obj, trajectory, rotation_axis, -rpm)
    end
    while IsValidThread(throw_thread) do
      Sleep(20)
    end
    if self:IsMerc() and not self:HasStatusEffect("HundredKnives") then
      local container = target
      if not (not results.miss and IsKindOf(target, "Unit")) or not target:CanAddItem("Inventory", weapon) then
        local drop_pos = terrain.FindPassable(visual_obj, 0, -1, -1, const.pfmVoxelAligned)
        container = GetDropContainer(self, drop_pos)
      end
      local slot = self:GetItemSlot(weapon)
      local thrownKnife = weapon:SplitStack(1, "splitIfEqual")
      if container then
        thrownKnife.drop_chance = 100
        AddItemsToInventory(container, {thrownKnife})
      end
      local item_class = weapon.class
      local spare
      self:ForEachItemInSlot("Inventory", item_class, function(item)
        if item.class == item_class then
          spare = item
          return "break"
        end
      end)
      if slot and spare and weapon:MergeStack(spare) then
        self:RemoveItem("Inventory", spare)
        DoneObject(spare)
      end
      if slot and 0 >= weapon.Amount then
        self:RemoveItem(slot, weapon)
        DoneObject(weapon)
      end
      self:FlushCombatCache()
      self:RecalcUIActions()
      ObjModified(self)
      ObjModified(container)
      if IsValid(visual_obj) then
        DoneObject(visual_obj)
      end
      self:UpdateOutfit()
    elseif IsValid(visual_obj) and IsValid(visual_attach_parent) then
      visual_attach_parent:Attach(visual_obj, visual_attach_spot)
    else
      DoneObject(visual_obj)
      weapon:GetVisualObj(self)
    end
    if results.miss then
      CreateFloatingText(target, T(699485992722, "Miss"), "FloatingTextMiss")
    else
      for _, hit in ipairs(results) do
        if IsValid(hit.obj) and not hit.obj:IsDead() and 0 < hit.damage then
          if IsKindOf(hit.obj, "Unit") then
            hit.obj:ApplyDamageAndEffects(self, hit.damage, hit, hit.armor_decay)
          else
            hit.obj:TakeDamage(hit.damage, self, hit)
          end
        end
      end
      local fx_actor = "knife"
      PlayFX("MeleeAttack", "hit", fx_actor, self:GetVisualPos())
    end
    self:OnAttack(action.id, target, results, attack_args)
    LogAttack(action, attack_args, results)
    AttackReaction(action, attack_args, results, "can retaliate")
    if not attack_args.keep_ui_mode then
      SetInGameInterfaceMode("IModeCombatMovement")
    end
    self:ProvokeOpportunityAttacks("attack reaction")
    self.last_attack_session_id = false
    table.remove(g_CurrentAttackActions)
  end)
  local ap = cost_ap and 0 < cost_ap and cost_ap or action:GetAPCost(self, attack_args)
  table.insert(g_CurrentAttackActions, {
    action = action,
    cost_ap = ap,
    attack_args = attack_args,
    results = results
  })
  self:RemoveStatusEffect("FirstThrow")
  self:PopAndCallDestructor()
end
function Unit:UpdateBandageConsistency()
  if self:HasStatusEffect("BeingBandaged") then
    local medic
    for _, unit in ipairs(g_Units) do
      if unit:GetBandageTarget() == self then
        return
      end
    end
    self:RemoveStatusEffect("BeingBandaged")
  end
  if self:HasStatusEffect("BandageInCombat") then
    local patient = self:GetBandageTarget()
    if not patient or not patient:HasStatusEffect("BeingBandaged") then
      self:RemoveStatusEffect("BandageInCombat")
    end
  end
end
function Unit:Bandage(action_id, cost_ap, args)
  local goto_ap = args.goto_ap or 0
  local action_cost = cost_ap - goto_ap
  local pos = args.goto_pos
  local target = args.target
  local sat_view = args.sat_view or false
  local target_self = target == self
  if g_Combat then
    if 0 < goto_ap then
      self:PushDestructor(function(self)
        self:GainAP(action_cost)
      end)
      local result = self:CombatGoto(action_id, goto_ap, args.goto_pos)
      self:PopDestructor()
      if not result then
        self:GainAP(action_cost)
        return
      end
    end
  elseif not target_self then
    self:GotoSlab(pos)
  end
  local myVoxel = SnapToPassSlab(self:GetPos())
  if pos and myVoxel:Dist(pos) ~= 0 then
    if self.behavior == "Bandage" then
      self:SetBehavior()
    end
    if self.combat_behavior == "Bandage" then
      self:SetCombatBehavior()
    end
    self:GainAP(action_cost)
    return
  end
  local action = CombatActions[action_id]
  local medicine = GetUnitEquippedMedicine(self)
  if not medicine then
    if self.behavior == "Bandage" then
      self:SetBehavior()
    end
    if self.combat_behavior == "Bandage" then
      self:SetCombatBehavior()
    end
    self:GainAP(action_cost)
    return
  end
  self:SetBehavior("Bandage", {
    action_id,
    cost_ap,
    args
  })
  self:SetCombatBehavior("Bandage", {
    action_id,
    cost_ap,
    args
  })
  if not target_self then
    self:Face(target, 200)
    Sleep(200)
  end
  if not sat_view then
    if self.stance ~= "Crouch" then
      self:ChangeStance(false, 0, "Crouch")
    end
    if target_self then
      self:SetState("nw_Bandaging_Self_Start")
      Sleep(self:TimeToAnimEnd() or 100)
      self:ProvokeOpportunityAttacks("attack interrupt")
      self:SetState("nw_Bandaging_Self_Idle")
    else
      self:SetState("nw_Bandaging_Start")
      Sleep(self:TimeToAnimEnd() or 100)
      self:ProvokeOpportunityAttacks("attack interrupt")
      self:SetState("nw_Bandaging_Idle")
    end
    if not g_Combat and not GetMercInventoryDlg() then
      SetInGameInterfaceMode("IModeExploration")
    end
  elseif not g_Combat then
    while IsValid(target) and not target:IsDead() and target.HitPoints < target.MaxHitPoints and 0 < medicine.Condition do
      target:GetBandaged(medicine, self)
    end
  end
  self:SetCommand("CombatBandage", target, medicine)
end
function Unit:IsBeingBandaged()
  for _, unit in ipairs(g_Units) do
    if unit:GetBandageTarget() == self then
      return true
    end
  end
end
function Unit:GetBandageTarget()
  if not self:IsDead() and self.combat_behavior == "Bandage" then
    local args = self.combat_behavior_params[3]
    return args.target
  end
end
function Unit:GetBandageMedicine()
  if not self:IsDead() and self.combat_behavior == "Bandage" then
    return GetUnitEquippedMedicine(self)
  end
end
function Unit:CombatBandage(target, medicine)
  target:AddStatusEffect("BeingBandaged")
  ObjModified(target)
  if IsValid(target) then
    self:Face(target, 0)
  end
  if g_Combat then
    local heal_anim
    if self == target then
      heal_anim = "nw_Bandaging_Self_Idle"
    else
      heal_anim = "nw_Bandaging_Idle"
      PlayVoiceResponse(self, "BandageDownedUnit")
    end
    self:SetState(heal_anim, const.eKeepComponentTargets)
    self:AddStatusEffect("BandageInCombat")
    if not GetMercInventoryDlg() then
      SetInGameInterfaceMode("IModeCombatMovement")
    end
    Halt()
  else
    self:PushDestructor(function()
      self:SetCombatBehavior()
      self:SetBehavior()
      self:RemoveStatusEffect("BandageInCombat")
      target:RemoveStatusEffect("BeingBandaged")
      ObjModified(target)
      ObjModified(self)
    end)
    self:AddStatusEffect("BandageInCombat")
    while IsValid(target) and not target:IsDead() and target.HitPoints < target.MaxHitPoints and 0 < medicine.Condition do
      Sleep(5000)
      target:GetBandaged(medicine, self)
    end
    self:SetState("nw_Bandaging_End")
    Sleep(self:TimeToAnimEnd() or 100)
    self:PopAndCallDestructor()
  end
end
function Unit:EndCombatBandage(no_ui_update, instant)
  local target = self:GetBandageTarget()
  self:RemoveStatusEffect("BandageInCombat")
  ObjModified(self)
  if IsValid(target) then
    target:RemoveStatusEffect("BeingBandaged")
    ObjModified(target)
  end
  local normal_anim = self:TryGetActionAnim("Idle", self.stance)
  if not instant then
    self:PlayTransitionAnims(normal_anim)
  end
  self:SetCombatBehavior()
  if not no_ui_update and (self == SelectedObj or target == SelectedObj) and g_Combat then
    SetInGameInterfaceMode("IModeCombatMovement")
  end
  self:SetCommand("Idle")
end
function OnMsg.UnitMovementStart(unit)
  for _, u in ipairs(g_Units) do
    if u:GetBandageTarget() == unit then
      u:SetCommand("EndCombatBandage", "no update")
    end
  end
end
function Unit:DownedRally(medic, medicine)
  self:SetCombatBehavior()
  self:RemoveStatusEffect("Stabilized")
  self:RemoveStatusEffect("BleedingOut")
  self:RemoveStatusEffect("Unconscious")
  self:RemoveStatusEffect("Downed")
  self:SetTired(Min(self.Tiredness, 2))
  self.downed_check_penalty = 0
  if medic then
    if medicine then
      medicine.Condition = medicine.Condition - CombatActions.Bandage:ResolveValue("ReviveConditionLoss")
    end
    self:GetBandaged(medicine, medic)
    local slot = medic:GetItemSlot(medicine)
    if slot and 0 >= medicine.Condition then
      CombatLog("short", T({
        831717454393,
        "<merc>'s <item> has been depleted",
        merc = medic.Nick,
        item = medicine.DisplayName
      }))
      medic:RemoveItem(slot, medicine)
      DoneObject(medicine)
    end
    medic:SetCommand("EndCombatBandage")
  else
    for _, unit in ipairs(self.team.units) do
      if unit:GetBandageTarget() == self then
        unit:SetCommand("EndCombatBandage")
      end
    end
  end
  local stance = self.immortal and "Standing" or self.stance
  self.stance = stance
  local normal_anim = self:TryGetActionAnim("Idle", self.stance)
  self:PlayTransitionAnims(normal_anim)
  if g_Combat then
    self:GainAP(self:GetMaxActionPoints() - self.ActionPoints)
  end
  self.TempHitPoints = 0
  ObjModified(self)
  ObjModified(self.team)
  ForceUpdateCommonUnitControlUI("recreate")
  CreateFloatingText(self, T(979333850225, "Recovered"))
  PlayFX("UnitDownedRally", "start", self)
  Msg("OnDownedRally", medic, self)
  self:SetCommand("Idle")
end
function Unit:Retaliate(attacker, attack_reason, fnGetAttackAndWeapon)
  if not IsKindOf(attacker, "Unit") or attacker.team ~= g_Teams[g_CurrentTeam] or attacker == self then
    return false
  end
  if not (not self:IsDead() and not self:IsDowned() and self:IsAware()) or self:HasPreparedAttack() then
    return false
  end
  local retaliated = false
  local num_attacks = HasPerk(self, "Killzone") and 2 or 1
  for i = 1, num_attacks do
    local action, weapon
    if fnGetAttackAndWeapon then
      action, weapon = fnGetAttackAndWeapon(self)
    else
      weapon = self:GetActiveWeapons("Firearm")
      if IsKindOf(weapon, "HeavyWeapon") then
        weapon = nil
      else
        action = self:GetDefaultAttackAction()
      end
    end
    if not (weapon and action and self:CanAttack(attacker, weapon, action, 0, nil, "skip_ap_check")) then
      break
    end
    local lof_data = GetLoFData(self, {attacker}, {
      action_id = action.id
    })
    if lof_data[1].los == 0 then
      break
    end
    if i == 1 then
      self:SetAttackReason(attack_reason, true)
      attacker:InterruptBegin()
    end
    if IsValidTarget(attacker) then
      retaliated = true
      self:QueueCommand("RetaliationAttack", attacker, false, action)
      while not self:IsIdleCommand() do
        WaitMsg("Idle")
      end
    end
  end
  ClearAITurnContours()
  g_Interrupt = true
  self:SetAttackReason()
  return retaliated
end
function NetSyncEvents.InvetoryAction_RealoadWeapon(session_id, ap, weapon_args, src_ammo_type)
  local combat_mode = g_Units[session_id] and InventoryIsCombatMode(g_Units[session_id])
  local unit = (not gv_SatelliteView or combat_mode) and g_Units[session_id] or gv_UnitData[session_id]
  if combat_mode and gv_SatelliteView then
    unit:SyncWithSession("session")
  end
  if combat_mode and 0 < ap and unit:UIHasAP(ap) then
    unit:ConsumeAP(ap, "Reload")
  end
  local weapon = g_ItemIdToItem[weapon_args.item_id]
  unit:ReloadWeapon(weapon, src_ammo_type)
  if combat_mode and gv_SatelliteView then
    unit:SyncWithSession("map")
  end
  if unit:CanBeControlled() then
    InventoryUpdate(unit)
  end
end
function NetSyncEvents.InvetoryAction_UnjamWeapon(session_id, ap, weapon_args)
  local combat_mode = g_Units[session_id] and InventoryIsCombatMode(g_Units[session_id])
  local unit = (not gv_SatelliteView or combat_mode) and g_Units[session_id] or gv_UnitData[session_id]
  if combat_mode and gv_SatelliteView then
    unit:SyncWithSession("session")
  end
  if combat_mode and 0 < ap and unit:UIHasAP(ap) then
    unit:ConsumeAP(ap, "Unjam")
  end
  local weapon = g_ItemIdToItem[weapon_args.item_id]
  weapon:Unjam(unit)
  if combat_mode and gv_SatelliteView then
    unit:SyncWithSession("map")
  end
  if unit:CanBeControlled() then
    InventoryUpdate(unit)
  end
end
function NetSyncEvents.InvetoryAction_SwapWeapon(session_id, ap)
  local combat_mode = g_Units[session_id] and InventoryIsCombatMode(g_Units[session_id])
  local unit = (not gv_SatelliteView or combat_mode) and g_Units[session_id] or gv_UnitData[session_id]
  if combat_mode and gv_SatelliteView then
    unit:SyncWithSession("session")
  end
  if combat_mode and 0 < ap and unit:UIHasAP(ap) then
    unit:ConsumeAP(ap, "ChangeWeapon")
  end
  unit:SwapActiveWeapon()
  if combat_mode and gv_SatelliteView then
    unit:SyncWithSession("map")
  end
  if unit:CanBeControlled() then
    InventoryUpdate(unit)
  end
end
function NetSyncEvents.InvetoryAction_UseItem(session_id, item_id)
  local combat_mode = g_Units[session_id] and InventoryIsCombatMode(g_Units[session_id])
  local unit = (not gv_SatelliteView or combat_mode) and g_Units[session_id] or gv_UnitData[session_id]
  if combat_mode and gv_SatelliteView then
    unit:SyncWithSession("session")
  end
  local item = g_ItemIdToItem[item_id]
  if combat_mode then
    unit:ConsumeAP(item.APCost * const.Scale.AP)
  end
  ExecuteEffectList(item.Effects, unit)
  if combat_mode and gv_SatelliteView then
    unit:SyncWithSession("map")
  end
  if unit:CanBeControlled() then
    InventoryUpdate(unit)
  end
end
function Unit:ReloadAction(action_id, cost_ap, args)
  if args.reload_all then
    local _, _, weapons = self:GetActiveWeapons()
    for _, weapon in ipairs(weapons) do
      local ammo = weapon.ammo and weapon.ammo.class
      self:ReloadWeapon(weapon, ammo, args.reload_all)
    end
  else
    local ammo
    if args and args.target then
      ammo = self:GetItem(args.target)
    end
    if not ammo then
      local bag = self.Squad and GetSquadBagInventory(self.Squad)
      if bag then
        ammo = bag:GetItem(args.target)
      end
    end
    local weapon = args and args.weapon
    if type(weapon) == "number" then
      local w1, w2, wl = self:GetActiveWeapons()
      weapon = wl[weapon]
    else
      weapon = self:GetWeaponByDefIdOrDefault("Firearm", weapon, args and args.pos, args and args.item_id)
    end
    self:ReloadWeapon(weapon, ammo, args and args.delayed_fx)
  end
end
function Unit:UnjamWeapon(action_id, cost_ap, args)
  self:ProvokeOpportunityAttacks("attack interrupt")
  local weapon = false
  if args and args.pos then
    weapon = self:GetItemAtPackedPos(args.pos)
  elseif args and args.weapon then
    weapon = self:GetWeaponByDefIdOrDefault("Firearm", args and args.weapon, args and args.pos, args and args.item_id)
  end
  if weapon then
    weapon:Unjam(self)
  else
    local weapon1, weapon2 = self:GetActiveWeapons()
    if weapon1.jammed and not weapon1:IsCondition("Broken") then
      weapon1:Unjam(self)
    elseif weapon2.jammed and not weapon2:IsCondition("Broken") then
      weapon2:Unjam(self)
    end
  end
end
function Unit:EnterEmplacement(obj, instant)
  local visual = obj.weapon and obj.weapon:GetVisualObj()
  if not visual then
    return
  end
  local fire_spot = visual:GetSpotBeginIndex("Unit")
  local fire_pos = visual:GetSpotPos(fire_spot)
  if not instant then
    if self.stance == "Prone" then
      self:DoChangeStance("Standing")
    end
    if not IsCloser(self, fire_pos, const.SlabSizeX / 2) then
      self:Goto(fire_pos, "sl")
    end
  end
  self:SetAxis(axis_z)
  self:SetAngle(obj:GetAngle(), instant and 0 or 200)
  self:SetTargetDummy(nil, nil, "hmg_Crouch_Idle", 0, "Crouch")
  self:AddStatusEffect("ManningEmplacement")
  if instant then
    self:SetPos(fire_pos)
    self:SetState("hmg_Crouch_Idle", 0, 0)
  else
    self:SetState("hmg_Standing_to_Crouch")
    self:SetPos(fire_pos, 500)
    Sleep(self:TimeToAnimEnd())
    self:SetState("hmg_Crouch_Idle")
  end
  if self.stance ~= "Crouch" then
    self.stance = "Crouch"
    Msg("UnitStanceChanged", self)
  end
  self:SetEffectValue("hmg_emplacement", obj.handle)
  self:SetEffectValue("hmg_sector", gv_CurrentSectorId)
  obj.manned_by = self
end
function Unit:LeaveEmplacement(instant, exit_combat)
  if not self:HasStatusEffect("ManningEmplacement") then
    return
  end
  local handle = self:GetEffectValue("hmg_emplacement")
  local obj = HandleToObject[handle]
  if not obj then
    return
  end
  if exit_combat and obj.exploration_manned and self.team.player_enemy then
    return
  end
  obj.manned_by = nil
  local exit_pos = not IsPassSlab(self) and SnapToPassSlab(self)
  if instant then
    if exit_pos then
      self:SetPos(exit_pos)
    end
  else
    self:SetAnim(1, "hmg_Crouch_to_Standing")
    if exit_pos then
      Sleep(Max(0, self:TimeToAnimEnd() - 500))
      self:SetPos(exit_pos, 200)
    end
    Sleep(self:TimeToAnimEnd())
  end
  if self.stance ~= "Standing" then
    self.stance = "Standing"
    Msg("UnitStanceChanged", self)
  end
  self:RemoveStatusEffect("ManningEmplacement")
  self:SetEffectValue("hmg_emplacement")
  self:InterruptPreparedAttack()
  self:FlushCombatCache()
  self:RecalcUIActions(true)
  self:UpdateOutfit()
  ObjModified(self)
end
function Unit:StartBombard()
  local weapon = self:GetActiveWeapons("Mortar")
  if weapon and self.prepared_bombard_zone then
    weapon:ApplyAmmoUse(self, self.prepared_bombard_zone.num_shots, false, self.prepared_bombard_zone.weapon_condition)
  end
  local fired = self.prepared_bombard_zone.num_shots and self.prepared_bombard_zone.num_shots > 0
  if not fired and self.prepared_bombard_zone then
    DoneObject(self.prepared_bombard_zone)
  end
  self.prepared_bombard_zone = nil
  self:SetCombatBehavior()
end
function Unit:ExplorationStartCombatAction(action_id, ap, args)
  local action = CombatActions[action_id]
  if g_Combat or not action then
    return
  end
  self.ActionPoints = self:GetMaxActionPoints()
  ap = action:GetAPCost(self, args)
  self:AddStatusEffect("SpentAP")
  self:SetEffectValue("spent_ap", ap)
end
function Unit:LightningReaction()
  if g_Combat and g_Teams[g_Combat.team_playing] == self.team then
    return
  end
  if self.stance == "Prone" or self:HasStatusEffect("ManningEmplacement") then
    return
  end
  if self:HasStatusEffect("LightningReactionCounter") then
    return
  end
  local proc = HasPerk(self, "LightningReaction")
  if not proc and HasPerk(self, "LightningReactionNPC") then
    local chance = CharacterEffectDefs.LightningReactionNPC:ResolveValue("chance")
    local roll = InteractionRand(100, "LightningReaction")
    proc = chance > roll
  end
  if proc then
    self:AddStatusEffect("LightningReactionCounter")
    self:SetActionCommand("ChangeStance", nil, nil, "Prone")
    CreateFloatingText(self, T(726050447294, "Lightning Reaction"), nil, nil, true)
    return true
  end
end
function Unit:AddSignatureRechargeTime(id, duration, recharge_on_kill)
  if CheatEnabled("SignatureNoCD") then
    return
  end
  local recharges = self.signature_recharge or {}
  self.signature_recharge = recharges
  if string.match(id, "DoubleToss") then
    id = "DoubleToss"
  end
  local idx = recharges[id]
  if not idx then
    idx = #recharges + 1
    recharges[id] = idx
  end
  recharges[idx] = {
    id = id,
    expire_campaign_time = Game.CampaignTime + duration,
    on_kill = recharge_on_kill
  }
  self:RecalcUIActions()
  ObjModified(self)
end
function Unit:GetSignatureRecharge(id)
  if string.match(id, "DoubleToss") then
    id = "DoubleToss"
  end
  local idx = self.signature_recharge and self.signature_recharge[id]
  return idx and self.signature_recharge[idx] or false
end
function Unit:UpdateSignatureRecharges(trigger)
  local recharges = self.signature_recharge or empty_table
  for i = #recharges, 1, -1 do
    local recharge = recharges[i]
    if trigger == "kill" and recharge.on_kill or Game.CampaignTime > recharge.expire_campaign_time then
      local id = recharge.id
      self:RechargeSignature(id)
    end
  end
end
function Unit:RechargeSignature(id)
  local i = self.signature_recharge[id]
  table.remove(self.signature_recharge, i)
  self.signature_recharge[id] = nil
end
function Unit:RechargeSignatures()
  self.signature_recharge = {}
  ObjModified(self)
end
function Unit:HasSignatures()
  local perks = self:GetPerks()
  for _, perk in ipairs(perks) do
    if perk.Tier == "Personal" then
      return true
    end
  end
  return false
end
local UpdateAllRecharges = function()
  for _, unit in ipairs(g_Units) do
    unit:UpdateSignatureRecharges()
  end
end
OnMsg.SatelliteTick = UpdateAllRecharges
function Unit:Nazdarovya(action_id, cost_ap, args)
  local action = CombatActions[action_id]
  self:ApplyTempHitPoints(action:ResolveValue("tempHp"))
  self:AddStatusEffect("Drunk")
  local recharge_on_kill = action:ResolveValue("recharge_on_kill") or 0
  self:AddSignatureRechargeTime(action_id, const.Combat.SignatureAbilityRechargeTime, 0 < recharge_on_kill)
end
function Unit:DoubleToss(action_id, cost_ap, args)
  self:ThrowGrenade(action_id, cost_ap, args)
  local action = CombatActions[action_id]
  local recharge_on_kill = action:ResolveValue("recharge_on_kill") or 0
  self:AddSignatureRechargeTime("DoubleToss", const.Combat.SignatureAbilityRechargeTime, 0 < recharge_on_kill)
end
function Unit:OnMyTarget(action_id, cost_ap, args)
  local action = CombatActions[action_id]
  local fired = {}
  for _, ally in ipairs(self.team.units) do
    if ally ~= self then
      local attack = ally:OnMyTargetGetAllyAttack(args.target)
      if attack then
        local ap = ally.ActionPoints
        ally.ActionPoints = ally:GetMaxActionPoints()
        ally:SetCommand("FirearmAttack", attack.id, 0, args)
        fired[#fired + 1] = ally
        ally.ActionPoints = ap
      end
    end
  end
  while 0 < #fired do
    Sleep(100)
    for i = #fired, 1, -1 do
      if fired[i]:IsIdleCommand() then
        table.remove(fired, i)
      end
    end
  end
  local recharge_on_kill = action:ResolveValue("recharge_on_kill") or 0
  self:AddSignatureRechargeTime(action_id, const.Combat.SignatureAbilityRechargeTime, 0 < recharge_on_kill)
  SetInGameInterfaceMode("IModeCombatMovement")
end
function Unit:OnMyTargetGetAllyAttack(target)
  local attack = self.command ~= "Downed" and self:GetDefaultAttackAction("ranged")
  local weapon = attack:GetAttackWeapons(self)
  if attack and attack.id ~= "UnarmedAttack" and HasVisibilityTo(self, target) and IsKindOf(weapon, "Firearm") and not IsKindOf(weapon, "HeavyWeapon") and self:CanAttack(target, weapon, attack, nil, nil, "skip_ap_check") then
    return attack
  end
end
function Unit:SteroidPunch(action_id, cost_ap, args)
  self:MeleeAttack(action_id, cost_ap, args)
end
function Unit:ResolveSteroidPunch(args, results)
  local target = args.target
  if target:IsDead() then
    if target.on_die_attacker == self then
      target.on_die_hit_descr = target.on_die_hit_descr or {}
      target.on_die_hit_descr.death_blow = true
      target.on_die_hit_descr.falldown_callback = "SteroidPunchExplosion"
    end
    return
  end
  if target.stance == "Prone" or target:HasStatusEffect("Unconscious") then
    return
  end
  local angle = CalcOrientation(self, target)
  local pushSlabs = CombatActions.SteroidPunch:ResolveValue("pushSlabs")
  local fromPos = target:GetPos()
  local toPos = fromPos
  local toMove = 0
  while pushSlabs > toMove do
    local nextPos = GetPassSlab(RotateRadius((toMove + 1) * const.SlabSizeX, angle, fromPos))
    if not (nextPos and IsPassSlabStep(toPos, nextPos, const.TunnelTypeWalk)) or IsOccupiedExploration(nil, nextPos:xyz()) then
      break
    end
    toPos = nextPos
    toMove = toMove + 1
  end
  local orient_angle = not fromPos:Equal2D(toPos) and angle + 10800 or nil
  target:SetCommand("Punched", self, toPos, orient_angle)
end
function SteroidPunchExplosion(attacker, target, pos)
  local mockGrenade = PlaceInventoryItem("SteroidPunchGrenade")
  local ignore_targets = {
    [attacker] = true,
    [target] = true
  }
  ExplosionDamage(attacker, mockGrenade, pos, nil, nil, "disableBurnFx", ignore_targets)
end
function Unit:Punched(attacker, pos, angle)
  local anim = self:GetRandomAnim("civ_KnockDown_B")
  local hit_moment = self:GetAnimMoment(anim, "hit") or self:GetAnimMoment(anim, "end") or self:GetAnimDuration(anim) - 1
  CreateGameTimeThread(function(delay, target, pos, attacker)
    Sleep(delay)
    SteroidPunchExplosion(attacker, target, pos)
  end, hit_moment, self, pos, attacker)
  self:MovePlayAnim(anim, self:GetPos(), pos, 0, nil, true, angle, nil, nil, nil, true)
  if not self:IsDead() then
    self:DoChangeStance("Prone")
  end
end
function Unit:TakeSuppressionFire()
  self:Pain()
  if self.stance ~= "Prone" then
    self:SetActionCommand("ChangeStance", nil, nil, "Prone")
  end
end
function Unit:AlwaysReadyFindCover(enemy)
  local ap = MulDivRound(self:GetMaxActionPoints(), const.Combat.RepositionAPPercent, 100)
  local path = CombatPath:new()
  local cost_extra = GetStanceToStanceAP("Standing", "Crouch")
  path:RebuildPaths(self, ap)
  local best_ppos, best_score, best_ap, stance, score
  DbgClearVectors()
  for ppos, ap in pairs(path.paths_ap) do
    local x, y, z = point_unpack(ppos)
    local pos = point(x, y, z)
    local cover, any, coverage = self:GetCoverPercentage(enemy:GetPos(), pos, "Crouch")
    DbgAddVector(point(x, y, z), guim, const.clrGray)
    if cover and cover == const.CoverLow and self.stance == "Standing" and ap < cost_extra then
      DbgAddVector(point(x, y, z), 2 * guim, const.clrRed)
      cover = false
    end
    if cover then
      DbgAddVector(point(x, y, z), 2 * guim, const.clrYellow)
      score = cover * coverage
      if not best_ppos then
        best_ppos, best_score, best_ap, stance = ppos, score, ap
        if cover == const.CoverLow and self.stance == "Standing" then
          stance = "Crouch"
        else
          stance = nil
        end
      elseif best_score < score or score > MulDivRound(best_score, 90, 100) and ap > best_ap then
        best_ppos, best_score, best_ap, stance = ppos, score, ap
        if cover == const.CoverLow and self.stance == "Standing" then
          stance = "Crouch"
        else
          stance = nil
        end
      end
    end
  end
end
MapVar("g_AlwaysReadyThread", false)
function Unit:TryActivateAlwaysReady(enemy)
  if IsValidThread(g_AlwaysReadyThread) then
    return
  end
  local cover, any, coverage = self:GetCoverPercentage(enemy:GetPos())
  if cover then
    if cover == const.CoverLow and self.stance == "Standing" then
      CancelWaitingActions(-1)
      NetStartCombatAction("StanceCrouch", self, 0)
    end
    return
  end
  local ap = MulDivRound(self:GetMaxActionPoints(), const.Combat.RepositionAPPercent, 100)
  local cost_extra = GetStanceToStanceAP("Standing", "Crouch")
  local path = CombatPath:new()
  path:RebuildPaths(self, ap)
  local best_ppos, best_score, best_ap, stance
  for ppos, ap in pairs(path.paths_ap) do
    local pos = point(point_unpack(ppos))
    local cover, any, coverage = self:GetCoverPercentage(enemy:GetPos(), pos, "Crouch")
    if cover and cover == const.CoverLow and self.stance == "Standing" and ap < cost_extra then
      cover = false
    end
    if cover then
      local score = cover * coverage
      if not best_ppos then
        best_ppos, best_score, best_ap, stance = ppos, score, ap
        if cover == const.CoverLow and self.stance == "Standing" then
          stance = "Crouch"
        else
          stance = nil
        end
      elseif best_score < score or score > MulDivRound(best_score, 90, 100) and ap > best_ap then
        best_ppos, best_score, best_ap, stance = ppos, score, ap
        if cover == const.CoverLow and self.stance == "Standing" then
          stance = "Crouch"
        else
          stance = nil
        end
      end
    end
  end
  if not best_ppos then
    CreateFloatingText(self, T(103063369185, "Always Ready: No covers nearby"), "FloatingTextMiss")
    return
  end
  local path_to_dest = path:GetCombatPathFromPos(best_ppos)
  DoneObject(path)
  g_AlwaysReadyThread = CreateGameTimeThread(Unit.ActivateAlwaysReady, self, best_ppos, path_to_dest, stance)
end
function Unit:ActivateAlwaysReady(reposition_dest, reposition_path, stance)
  local controller = CreateAIExecutionController({
    label = "AlwaysReady",
    reposition = true,
    activator = self
  })
  local start_ap = self.ActionPoints
  self.ui_override_ap = self:GetUIActionPoints()
  local x, y, z = point_unpack(reposition_dest)
  self.reposition_dest = stance_pos_pack(x, y, z, StancesList[stance or self.stance])
  self.reposition_path = reposition_path
  CancelWaitingActions(-1)
  controller.restore_camera_obj = SelectedObj
  g_Combat:SetRepositioned(self, false)
  controller:Execute({self})
  DoneObject(controller)
  self.ActionPoints = start_ap
  self.ui_override_ap = false
  g_AlwaysReadyThread = false
end
function Unit:ChargeAttack(action_id, cost_ap, args)
  self:PushDestructor(function()
    g_TrackingChargeAttacker = false
    self.move_attack_action_id = nil
  end)
  if not g_AITurnContours[self.handle] and g_Combat and g_AIExecutionController then
    local enemy = self.team.side == "enemy1" or self.team.side == "enemy2" or self.team.side == "neutralEnemy"
    g_AITurnContours[self.handle] = SpawnUnitContour(self, enemy and "CombatEnemy" or "CombatAlly")
    ShowBadgeOfAttacker(self, true)
  end
  ShouldTrackMeleeCharge(self, args.target)
  self.move_attack_action_id = action_id
  self:SetCommandParamValue(self.command, "move_anim", "Run")
  if args.goto_pos then
    args.unit_moved = true
    self:CombatGoto(action_id, args.goto_ap or 0, args.goto_pos)
  end
  self:MeleeAttack(action_id, cost_ap, args)
  self:PopAndCallDestructor()
end
function Unit:GloryHogCharge(action_id, cost_ap, args)
  local action = CombatActions[action_id]
  self:ApplyTempHitPoints(action:ResolveValue("tempHp"))
  self:ChargeAttack(action_id, cost_ap, args)
  local recharge_on_kill = action:ResolveValue("recharge_on_kill") or 0
  self:AddSignatureRechargeTime(action_id, const.Combat.SignatureAbilityRechargeTime, 0 < recharge_on_kill)
end
function Unit:HyenaCharge(action_id, cost_ap, args)
  if self.species ~= "Hyena" then
    self:GainAP(cost_ap)
    CombatActionInterruped(self)
    return
  end
  local target = args.target
  local action = CombatActions[action_id]
  args.prediction = false
  args.unit_moved = true
  local results, attack_args = action:GetActionResults(self, args)
  local atk_pos, atk_jmp_pos = GetHyenaChargeAttackPosition(self, target, attack_args.move_ap, attack_args.jump_dist, action_id)
  if not atk_pos then
    self:GainAP(cost_ap)
    CombatActionInterruped(self)
    return
  end
  self:PushDestructor(function()
    g_TrackingChargeAttacker = false
    table.remove(g_CurrentAttackActions)
    self.move_attack_action_id = nil
  end)
  if not g_AITurnContours[self.handle] and g_Combat and g_AIExecutionController then
    local enemy = self.team.side == "enemy1" or self.team.side == "enemy2" or self.team.side == "neutralEnemy"
    g_AITurnContours[self.handle] = SpawnUnitContour(self, enemy and "CombatEnemy" or "CombatAlly")
    ShowBadgeOfAttacker(self, true)
  end
  ShouldTrackMeleeCharge(self, target)
  self.move_attack_action_id = action_id
  table.insert(g_CurrentAttackActions, {
    action = action,
    cost_ap = cost_ap,
    attack_args = attack_args,
    results = results
  })
  self:AttackReveal(action, attack_args, results)
  self:SetCommandParamValue(self.command, "move_anim", "Run")
  self:CombatGoto(action_id, attack_args.move_ap, atk_jmp_pos)
  self:Face(atk_pos)
  if not HasPerk(self, "HardBlow") then
    self:ProvokeOpportunityAttacks("attack interrupt", nil, "melee")
  end
  ShowBadgesOfTargets({target}, "show")
  self:SetState("attack_Charge")
  local fx_actor = "jaws"
  PlayFX("MeleeAttack", "start", fx_actor, self:GetVisualPos())
  local tth = self:TimeToMoment(1, "hit") or self:TimeToAnimEnd() / 2
  self:SetPos(atk_pos, self:TimeToAnimEnd())
  Sleep(tth)
  if results.miss then
    CreateFloatingText(target, T(699485992722, "Miss"), "FloatingTextMiss")
  else
    for _, hit in ipairs(results) do
      if IsValid(hit.obj) and not hit.obj:IsDead() and hit.damage > 0 then
        if IsKindOf(hit.obj, "Unit") then
          hit.obj:ApplyDamageAndEffects(self, hit.damage, hit, hit.armor_decay)
        else
          hit.obj:TakeDamage(hit.damage, self, hit)
        end
      end
    end
    PlayFX("MeleeAttack", "hit", fx_actor, self:GetVisualPos())
  end
  self:OnAttack(action_id, target, results, attack_args)
  Sleep(self:TimeToAnimEnd())
  LogAttack(action, attack_args, results)
  AttackReaction(action, attack_args, results, "can retaliate")
  if IsValid(target) then
    ObjModified(target)
  end
  self.last_attack_session_id = false
  ShowBadgesOfTargets({target}, "hide")
  self:PopAndCallDestructor()
end
function Unit:DanceForMe(action_id, cost_ap, args)
  local action = CombatActions[action_id]
  local weapon = self:GetActiveWeapons()
  local aoeParams = weapon:GetAreaAttackParams(action_id, self)
  local attackData = self:ResolveAttackParams(action_id, args.target, {})
  local attackerPos = attackData.step_pos
  local attackerPos3D = attackerPos
  if not attackerPos3D:IsValidZ() then
    attackerPos3D = attackerPos3D:SetTerrainZ()
  end
  local targetPos = args.target
  local targetAngle = CalcOrientation(attackerPos, targetPos)
  local distance = Clamp(attackerPos3D:Dist(targetPos), aoeParams.min_range * const.SlabSizeX, aoeParams.max_range * const.SlabSizeX)
  local enemies = GetEnemies(self)
  local maxValue, losValues = CheckLOS(enemies, attackerPos, distance, attackData.stance, aoeParams.cone_angle, targetAngle, false)
  if maxValue then
    for i, los in ipairs(losValues) do
      if los then
        local defaultAttack = self:GetDefaultAttackAction("ranged")
        local tempArgs = table.copy(args)
        tempArgs.target = enemies[i]
        tempArgs.target_spot_group = "Legs"
        if defaultAttack and self:CanAttack(tempArgs.target, weapon, defaultAttack, nil, nil, "skip_ap_check") then
          self:FirearmAttack(defaultAttack.id, 0, tempArgs)
        end
      end
    end
  end
  local recharge_on_kill = action:ResolveValue("recharge_on_kill") or 0
  self:AddSignatureRechargeTime(action_id, const.Combat.SignatureAbilityRechargeTime, 0 < recharge_on_kill)
  self:SetActionCommand("OverwatchAction", action_id, cost_ap, args)
end
function Unit:IceAttack(action_id, cost_ap, args)
  local target = args.target
  if not IsKindOf(target, "Unit") then
    return
  end
  local action = CombatActions[action_id]
  local weapon = self:GetActiveWeapons()
  local bodyParts = target:GetBodyParts(weapon)
  for i = #bodyParts, 1, -1 do
    if 1 > weapon.ammo.Amount then
      break
    end
    local bodyPart = bodyParts[i]
    args.target_spot_group = bodyPart.id
    args.ice_attack_num = i
    self:FirearmAttack(action_id, 0, args)
  end
  local recharge_on_kill = action:ResolveValue("recharge_on_kill") or 0
  self:AddSignatureRechargeTime(action_id, const.Combat.SignatureAbilityRechargeTime, 0 < recharge_on_kill)
end
function Unit:KalynaShot(action_id, cost_ap, args)
  self:FirearmAttack(action_id, 0, args)
  local action = CombatActions[action_id]
  local recharge_on_kill = action:ResolveValue("recharge_on_kill") or 0
  self:AddSignatureRechargeTime(action_id, const.Combat.SignatureAbilityRechargeTime, 0 < recharge_on_kill)
end
function Unit:EyesOnTheBack(action_id, cost_ap, args)
  local action = CombatActions[action_id]
  local recharge_on_kill = action:ResolveValue("recharge_on_kill") or 0
  self:AddSignatureRechargeTime(action_id, const.Combat.SignatureAbilityRechargeTime, 0 < recharge_on_kill)
  self:SetActionCommand("OverwatchAction", action_id, cost_ap, args)
end
function Unit:BulletHell(action_id, cost_ap, args)
  args.attack_anim_delay = 50
  self:SetActionCommand("FirearmAttack", action_id, cost_ap, args)
end
function BulletHellOverwriteShots(attack)
  local weapon = attack.weapon
  local halfAngle = DivRound(weapon.OverwatchAngle, 2)
  local newAngle = halfAngle
  local angleStep = MulDivRound(weapon.OverwatchAngle, 2, #attack.shots)
  for i, shot in ipairs(attack.shots) do
    shot.target_pos = RotateAxis(shot.target_pos, point(0, 0, 4069), newAngle, shot.attack_pos)
    shot.stuck_pos = RotateAxis(shot.stuck_pos, point(0, 0, 4069), newAngle, shot.attack_pos)
    if halfAngle <= abs(newAngle) then
      angleStep = -angleStep
    end
    newAngle = newAngle + angleStep
  end
end
function Unit:GrizzlyPerk(action_id, cost_ap, args)
  self:FirearmAttack(action_id, 0, args)
end
