MapVar("g_precalcCache", {})
function CalcLOFSegmentBulletDamage(segment_hit_data, attack_args)
  for k, v in pairs(attack_args) do
    if not segment_hit_data[k] then
      segment_hit_data[k] = v
    end
  end
  local stuck = true
  local ally_hits_count = 0
  local enemy_hits_count = 0
  local allyHit
  if segment_hit_data.hits then
    segment_hit_data.record_breakdown = false
    segment_hit_data.weapon:BulletCalcDamage(segment_hit_data)
    for _, hit in ipairs(segment_hit_data.hits) do
      if hit.is_target then
        stuck = false
      end
      if hit.enemy_hit then
        enemy_hits_count = enemy_hits_count + 1
      elseif hit.ally_hit then
        ally_hits_count = ally_hits_count + 1
        allyHit = allyHit or hit.obj.session_id
      end
    end
  end
  segment_hit_data.stuck = stuck
  segment_hit_data.ally_hits_count = ally_hits_count
  segment_hit_data.enemy_hits_count = enemy_hits_count
  segment_hit_data.allyHit = allyHit
end
local CalcLOFBulletDamage = function(attack_data, attack_args)
  if not attack_data then
    return
  end
  local stuck = true
  local best_ally_hits_count
  for j, segment_hit_data in ipairs(attack_data.lof) do
    CalcLOFSegmentBulletDamage(segment_hit_data, attack_args)
    stuck = stuck and segment_hit_data.stuck
    if not best_ally_hits_count or best_ally_hits_count > segment_hit_data.ally_hits_count then
      best_ally_hits_count = segment_hit_data.ally_hits_count
    end
  end
  attack_data.stuck = stuck
  attack_data.best_ally_hits_count = best_ally_hits_count or 0
  for k, v in pairs(attack_args) do
    if attack_data[k] == nil then
      attack_data[k] = v
    end
  end
end
function GetLoFData(attacker, targets, attack_args)
  local target = (IsPoint(targets) or IsValid(targets)) and targets
  local action_id = attack_args and attack_args.action_id or attacker:GetDefaultAttackAction("ranged").id
  local action = action_id and CombatActions[action_id]
  local weapon = attack_args and attack_args.weapon or action and action:GetAttackWeapons(attacker)
  local weapon_visual = attack_args and attack_args.weapon_visual or IsKindOf(weapon, "Firearm") and weapon:GetVisualObj(attacker) or false
  if not weapon then
    return not target and {}
  end
  local lof_args = attack_args and table.copy(attack_args) or {}
  lof_args.action_id = action_id
  lof_args.obj = attacker
  lof_args.weapon = weapon
  lof_args.weapon_visual = weapon_visual
  lof_args.output_collisions = true
  if lof_args.prediction == nil then
    lof_args.prediction = true
  end
  if not lof_args.penetration_class and IsKindOf(weapon, "BaseWeapon") then
    lof_args.penetration_class = weapon:GetPenetrationClass()
  end
  lof_args.output_collisions = true
  if not weapon or weapon.WeaponType == "GrenadeLauncher" then
    lof_args.aimIK = false
  else
    lof_args.aimIK = attacker:CanAimIK(weapon)
  end
  if not lof_args.attack_pos and IsKindOf(weapon, "FirearmBase") and weapon.emplacement_weapon and weapon_visual then
    lof_args.emplacement_weapon = true
    lof_args.attack_pos = weapon_visual:GetSpotLocPos(weapon_visual:GetSpotBeginIndex("Muzzle"))
    lof_args.step_pos = weapon_visual:GetSpotPos(weapon_visual:GetSpotBeginIndex("Unit"))
  end
  lof_args.force_hit_seen_target = not config.DisableForcedHitSeenTarget
  if action_id == "Overwatch" then
    lof_args.can_stuck_on_unit = false
  end
  local targets_attack_data
  local lof_idx = target and lof_args.prediction and lof_args.lof and lof_args.target_spot_group and table.find(lof_args.lof, "target_spot_group", lof_args.target_spot_group)
  if lof_idx then
    targets_attack_data = table.copy(lof_args)
    targets_attack_data.lof = {
      lof_args.lof[lof_idx]
    }
  else
    targets_attack_data = CheckLOF(targets, lof_args)
    lof_args.target = nil
    lof_args.target_dummy = nil
    lof_args.target_pos = nil
    lof_args.lof = nil
    if IsKindOf(weapon, "Firearm") then
      if target then
        CalcLOFBulletDamage(targets_attack_data, lof_args)
      else
        for i, attack_data in ipairs(targets_attack_data) do
          CalcLOFBulletDamage(attack_data, lof_args)
        end
      end
    end
  end
  return targets_attack_data
end
function UIIsEnemyAttackGood(enemy)
  local cache = g_UIAttackCachePredicted and g_UIAttackCachePredicted or g_UIAttackCache
  if not (cache and Selection) or not Selection[1] then
    return false
  end
  if not cache.goodAttack then
    return false
  end
  return not not cache.goodAttack[enemy]
end
function UIIsObjectAttackGood(enemy)
  local cache = g_UIAttackCachePredicted and g_UIAttackCachePredicted or g_UIAttackCache
  if not (cache and Selection) or not Selection[1] then
    return false
  end
  if not cache.goodAttackObject then
    return false
  end
  return not not cache.goodAttackObject[enemy]
end
function UIGetEnemiesGoodAttack()
  local cache = g_UIAttackCachePredicted and g_UIAttackCachePredicted or g_UIAttackCache
  local currentUnit = Selection and Selection[1]
  if not cache or not currentUnit then
    return false
  end
  if not cache.goodAttack then
    return false
  end
  if cache.for_unit ~= currentUnit.session_id then
    return false
  end
  return cache.goodAttack
end
function UIAnyEnemyAttackGood(action)
  if not (g_UIAttackCache and Selection) or not Selection[1] then
    return false
  end
  if not action then
    return not not g_UIAttackCache.anyEnemyGoodAttack
  end
  local unit = Selection[1]
  local weapon = action:GetAttackWeapons(unit)
  if not IsKindOfClasses(weapon, "Firearm", "MeleeWeapon") then
    return false
  end
  local max_range = action:GetMaxAimRange(unit, weapon)
  max_range = max_range or weapon.WeaponRange
  max_range = max_range and max_range * const.SlabSizeX
  local lof_args = {
    obj = unit,
    action_id = action.id,
    weapon = weapon,
    range = max_range,
    clamp_to_target = true,
    step_pos = unit:GetOccupiedPos()
  }
  local visibleEnemies = action:GetTargets({unit})
  if action.ActionType == "Ranged Attack" then
    local lof_data = visibleEnemies and 0 < #visibleEnemies and GetLoFData(unit, visibleEnemies, lof_args)
    for i, e in ipairs(visibleEnemies) do
      local lof = lof_data[i]
      lof_data[e] = lof
      local isGoodAttack = false
      for i, bodyPartLof in ipairs(lof and lof.lof) do
        local bodyPartGood = not bodyPartLof.stuck and not bodyPartLof.outside_attack_area and bodyPartLof.target_los
        if bodyPartGood then
          return true
        end
      end
    end
  elseif action.ActionType == "Melee Attack" then
    local targets = GetMeleeAttackTargets(unit)
    for i, e in ipairs(targets) do
      if unit:IsOnEnemySide(e) then
        return true
      end
    end
    if action:GetAnyTarget(Selection) then
      return true
    end
  end
  return false
end
function UIEnemyCanSee(enemy)
  if not Selection or not Selection[1] then
    return true
  end
  return HasVisibilityTo(Selection[1], enemy)
end
function UIGetCachedLoFOrReal(attacker, target, action, gotoPos, weapon, forceNoCache)
  local canUseCache = not forceNoCache
  if not (Selection and Selection[1]) or attacker ~= Selection[1] then
    canUseCache = false
  elseif not g_UIAttackCache or not g_UIAttackCache.lof_cache then
    canUseCache = false
  elseif g_UIAttackCache.lof_cache_src.attackerId ~= attacker.session_id then
    canUseCache = false
  elseif g_UIAttackCache.lof_cache_src.actionId ~= action.id then
    canUseCache = false
  elseif g_UIAttackCache.lof_cache_src.fromPos ~= gotoPos then
    canUseCache = false
  elseif g_UIAttackCache.lof_cache_src.weapon ~= weapon then
    canUseCache = false
  elseif not g_UIAttackCache.lof_cache[target] then
    canUseCache = false
  end
  if canUseCache then
    return g_UIAttackCache.lof_cache[target]
  else
    local lof_params = {
      action_id = action.Id,
      weapon = weapon,
      step_pos = gotoPos
    }
    local lof_data = GetLoFData(attacker, target, lof_params)
    return lof_data
  end
end
function GetTargetsToShowAboveActionBar(attacker)
  if not attacker then
    return {}
  end
  local team = attacker.team
  local visibleUnits = team and g_Visibility[team] or empty_table
  local visibleEnemies = table.ifilter(visibleUnits, function(idx, o)
    return IsValid(o) and attacker:IsOnEnemySide(o) and not o:HasStatusEffect("Hidden")
  end)
  return visibleEnemies
end
function GetTargetsToShowInPartyUI(attacker)
  if not attacker then
    return {}
  end
  local visibleUnits = attacker and g_Visibility[attacker] or empty_table
  local visibleEnemies = table.ifilter(visibleUnits, function(idx, o)
    return IsValid(o) and attacker:IsOnEnemySide(o) and not o:HasStatusEffect("Hidden")
  end)
  return visibleEnemies
end
MapVar("g_UIAttackCache", function()
  return {}
end)
function PrecalcLOFUI(unit, action, pos, cacheTable)
  if not Selection then
    return
  end
  if unit ~= Selection[1] or unit:IsDead() then
    return
  end
  local startTime = GetPreciseTicks()
  local defaultAction
  if action and action.ActionType == "Ranged Attack" then
    defaultAction = action
  end
  defaultAction = defaultAction or unit:GetDefaultAttackAction("ranged") or unit:GetDefaultAttackAction() or action
  if defaultAction.group == "FiringModeMetaAction" then
    defaultAction = GetUnitDefaultFiringModeActionFromMetaAction(unit, defaultAction, true)
  end
  local unitWeapon = defaultAction:GetAttackWeapons(unit)
  if not IsKindOfClasses(unitWeapon, "Firearm", "MeleeWeapon") then
    return
  end
  local max_range = defaultAction:GetMaxAimRange(unit, unitWeapon)
  max_range = max_range or unitWeapon.WeaponRange
  max_range = max_range and max_range * const.SlabSizeX
  local lof_args = {
    obj = unit,
    action_id = defaultAction.id,
    weapon = unitWeapon,
    range = max_range,
    clamp_to_target = true,
    step_pos = pos or unit:GetOccupiedPos()
  }
  cacheTable = cacheTable or g_UIAttackCache
  cacheTable.for_unit = unit.session_id
  if not cacheTable.goodAttack then
    cacheTable.goodAttack = {}
  end
  table.clear(cacheTable.goodAttack)
  local goodAttackCache = cacheTable.goodAttack
  local anyGoodAttack = false
  local anyEnemyGoodAttack = false
  local visibleEnemies = defaultAction:GetTargets({unit})
  if defaultAction.ActionType == "Ranged Attack" then
    local lof_data = visibleEnemies and 0 < #visibleEnemies and GetLoFData(unit, visibleEnemies, lof_args)
    for i, e in ipairs(visibleEnemies) do
      local lof = lof_data[i]
      lof_data[e] = lof
      local isGoodAttack = false
      for i, bodyPartLof in ipairs(lof and lof.lof) do
        local bodyPartGood = not bodyPartLof.stuck and not bodyPartLof.outside_attack_area and bodyPartLof.target_los
        if bodyPartGood then
          isGoodAttack = true
          break
        end
      end
      anyGoodAttack = anyGoodAttack or isGoodAttack
      anyEnemyGoodAttack = anyEnemyGoodAttack or isGoodAttack and unit:IsOnEnemySide(e)
      goodAttackCache[e] = isGoodAttack
    end
    cacheTable.lof_cache = lof_data
    cacheTable.lof_cache_src = {
      attackerId = unit.session_id,
      actionId = defaultAction.id,
      fromPos = pos,
      weapon = unitWeapon
    }
  elseif defaultAction.ActionType == "Melee Attack" then
    local targets = GetMeleeAttackTargets(unit)
    if targets and 0 < #targets then
      anyGoodAttack = true
      for i, e in ipairs(targets) do
        goodAttackCache[e] = true
        anyEnemyGoodAttack = anyEnemyGoodAttack or unit:IsOnEnemySide(e)
      end
    end
  else
    cacheTable.lof_cache = false
    cacheTable.lof_cache_src = false
  end
  cacheTable.anyGoodAttack = anyGoodAttack
  cacheTable.anyEnemyGoodAttack = anyEnemyGoodAttack
  cacheTable.enemies = visibleEnemies
  if not cacheTable.goodAttackObject then
    cacheTable.goodAttackObject = {}
  end
  table.clear(cacheTable.goodAttackObject)
  local goodAttackObject = cacheTable.goodAttackObject
  if defaultAction.ActionType == "Ranged Attack" then
    local visibleTraps = g_AttackableVisibility[unit]
    if visibleTraps and 0 < #visibleTraps then
      lof_args.target_spot_group = ""
      local lof_data = GetLoFData(unit, visibleTraps, lof_args)
      for i, lof in ipairs(lof_data) do
        local isGoodAttack = lof and not lof.stuck and not lof.outside_attack_area and lof.los ~= 0
        local obj = visibleTraps[i]
        goodAttackObject[obj] = isGoodAttack
      end
    end
  end
  if cacheTable ~= g_UIAttackCache then
    return
  end
  UpdateEnemyUIOrderForUnit(unit)
  ObjModified("unit_precalc")
  ObjModified("any_precalc")
  local igi = GetInGameInterfaceModeDlg()
  if igi and igi.crosshair and igi.crosshair.window_state ~= "destroying" then
    igi.crosshair.cached_results = false
    igi.crosshair:UpdateAim()
  end
  if UIRebuildSpam then
    print("UnitRecalc", GetPreciseTicks() - startTime)
  end
end
function PrecalcUIIfNeeded(unit)
  if not Selection or not Selection[1] then
    return
  end
  if unit and unit ~= Selection[1] then
    return
  end
  if g_Combat and not g_Combat.combat_started then
    return
  end
  if gv_SatelliteView or IsSetpiecePlaying() then
    return
  end
  if not unit:IsIdleCommand() or HasCombatActionInProgress(unit) then
    return
  end
  DelayedCall(0, PrecalcLOFUI, unit)
  return true
end
OnMsg.UnitStanceChanged = PrecalcUIIfNeeded
OnMsg.TurnStart = PrecalcUIIfNeeded
OnMsg.GameOptionsChanged = PrecalcUIIfNeeded
OnMsg.UnitAwarenessChanged = PrecalcUIIfNeeded
local lSelectionChangedRecalc = function()
  local unit = Selection[1]
  if unit and IsKindOf(unit, "Unit") then
    unit:RecalcUIActions()
    PrecalcUIIfNeeded(unit)
    ObjModified("combat_bar")
  end
end
function OnMsg.SelectionChange()
  if g_Combat then
    return
  end
  lSelectionChangedRecalc()
end
function OnMsg.SelectedObjChange()
  if not g_Combat then
    return
  end
  lSelectionChangedRecalc()
end
function OnMsg.CoOpPartnerSelectionChanged(unitsSelected)
  local primarySelect = unitsSelected and unitsSelected[1]
  local unit = primarySelect and g_Units[primarySelect]
  if unit then
    unit:RecalcUIActions()
  end
end
function OnMsg.ExplorationTick()
  if g_Combat then
    return
  end
  if IsSetpiecePlaying() then
    return
  end
  local selUnit = Selection[1]
  if selUnit and selUnit.command ~= "GotoSlab" then
    if not PrecalcUIIfNeeded(selUnit) then
      return
    end
    selUnit:FlushCombatCache()
    selUnit:RecalcUIActions()
  end
end
function OnMsg.CombatComputedVisibility()
  if not g_Combat or not SelectedObj then
    return
  end
  PrecalcUIIfNeeded(SelectedObj)
  SelectedObj:RecalcUIActions()
end
function OnMsg.TargetDummiesChanged(unit)
  if not SelectedObj then
    return
  end
  if g_Combat and not g_Combat.combat_started then
    return
  end
  local weapon = SelectedObj:GetActiveWeapons()
  local range = AIGetWeaponCheckRange(SelectedObj, weapon, SelectedObj:GetDefaultAttackAction())
  if not range then
    return
  end
  if range < SelectedObj:GetDist(unit) then
    return
  end
  PrecalcUIIfNeeded(SelectedObj)
end
MapVar("g_UIAttackCachePredicted", false)
function UIEnemyHeadIconsPredictionMode(enable)
  if not enable then
    if not g_UIAttackCachePredicted then
      return
    end
    g_UIAttackCachePredicted = false
    ObjModified("unit_precalc")
    ObjModified("any_precalc")
    return
  end
  if g_UIAttackCachePredicted then
    return
  end
  g_UIAttackCachePredicted = {}
  local dlg = GetInGameInterfaceModeDlg()
  dlg.effects_target_pos_last = false
end
function OnMsg.EffectsTargetPosUpdated(dialog, pt)
  if not g_UIAttackCachePredicted then
    return
  end
  local unit = Selection[1]
  if not unit then
    return
  end
  PrecalcLOFUI(unit, rawget(dialog, "action"), pt, g_UIAttackCachePredicted)
  if not g_UIAttackCachePredicted.visibility then
    g_UIAttackCachePredicted.visibility = {}
  end
  table.clear(g_UIAttackCachePredicted.visibility)
  local visibility = g_UIAttackCachePredicted.visibility
  local stanceToTake = dialog.targeting_blackboard and dialog.targeting_blackboard.playerToDoStanceAtEnd or unit.stance
  for i, e in ipairs(g_UIAttackCachePredicted.enemies) do
    visibility[e] = unit:CanSee(e, pt, stanceToTake)
  end
  ObjModified("unit_precalc")
  ObjModified("any_precalc")
end
function Unit:FlushCombatCache()
  self.combat_cache = false
end
itemCombatSkillsList = {
  "ThrowGrenadeA",
  "ThrowGrenadeB",
  "ThrowGrenadeC",
  "ThrowGrenadeD",
  "Bandage",
  "ChangeWeapon",
  "RemoteDetonation"
}
function Unit:ShouldSwapWeapons()
  local alt = self.current_weapon == "Handheld A" and "Handheld B" or "Handheld A"
  if not self:GetItemInSlot(self.current_weapon, "BaseWeapon") then
    return not not self:GetItemInSlot(alt, "BaseWeapon")
  elseif not self:GetItemInSlot(self.current_weapon, "Firearm") and not self:GetItemInSlot(self.current_weapon, "MeleeWeapon") then
    return not not self:GetItemInSlot(alt, "Firearm") or not not self:GetItemInSlot(alt, "MeleeWeapon")
  end
  return false
end
local add_weapon_attacks = function(actions, unit, weapon)
  if IsKindOf(weapon, "MachineGun") and not unit:HasStatusEffect("StationedMachineGun") then
    table.insert_unique(actions, "MGSetup")
  elseif IsKindOf(weapon, "HeavyWeapon") then
    table.insert_unique(actions, weapon:GetBaseAttack())
  elseif IsKindOf(weapon, "Firearm") then
    for _, id in ipairs(weapon.AvailableAttacks or empty_table) do
      table.insert_unique(actions, id)
    end
  elseif IsKindOf(weapon, "MeleeWeapon") then
    if weapon.Charge then
      table.insert_unique(actions, "Charge")
    else
      table.insert_unique(actions, "Brutalize")
    end
  elseif not weapon then
    table.insert_unique(actions, "Brutalize")
  end
end
function Unit:GetThrowableKnife()
  local cur_set = self.current_weapon
  local alt_set = cur_set == "Handheld A" and "Handheld B" or "Handheld A"
  local weapon
  self:ForEachItemInSlot(cur_set, function(item)
    if IsKindOf(item, "MeleeWeapon") and item.CanThrow then
      weapon = item
      return "break"
    end
  end)
  if weapon then
    return weapon
  end
  self:ForEachItemInSlot(alt_set, function(item)
    if IsKindOf(item, "MeleeWeapon") and item.CanThrow then
      weapon = item
      return "break"
    end
  end)
  return weapon
end
function Unit:EnumUIActions()
  local actions = {}
  if g_Combat or IsUnitPrimarySelectionCoOpAware(self) and not g_Overwatch[self] then
    local action = self:GetDefaultAttackAction()
    actions[1] = action.id
    local main_weapon, offhand_weapon = self:GetActiveWeapons()
    add_weapon_attacks(actions, self, main_weapon)
    if IsKindOf(main_weapon, "FlareGun") or IsKindOf(offhand_weapon, "FlareGun") then
      add_weapon_attacks(actions, self, offhand_weapon)
    end
    if self:GetThrowableKnife() then
      actions[#actions + 1] = "KnifeThrow"
    end
    if table.find(actions, "DualShot") then
      table.insert_unique(actions, "LeftHandShot")
      table.insert_unique(actions, "RightHandShot")
    end
    if IsKindOf(main_weapon, "FirearmBase") then
      for slot, sub in sorted_pairs(main_weapon.subweapons) do
        add_weapon_attacks(actions, self, sub)
      end
      if main_weapon:HasComponent("EnableFullAuto") then
        table.insert_unique(actions, "AutoFire")
      end
    end
    if #actions == 0 then
      actions[1] = "UnarmedAttack"
    end
  end
  for _, skill in ipairs(Presets.CombatAction.SignatureAbilities) do
    local id = skill.id
    if string.match(id, "DoubleToss") then
      id = "DoubleToss"
    end
    if id and self:HasStatusEffect(id) then
      actions[#actions + 1] = skill.id
    end
  end
  ForEachPresetInGroup("CombatAction", "Default", function(def)
    actions[#actions + 1] = def.id
  end)
  if g_Combat or IsUnitPrimarySelectionCoOpAware(self) then
    if self:GetItemInSlot("Handheld A", "Grenade", 1, 1) then
      actions[#actions + 1] = "ThrowGrenadeA"
    end
    if self:GetItemInSlot("Handheld A", "Grenade", 2, 1) then
      actions[#actions + 1] = "ThrowGrenadeB"
    end
    if self:GetItemInSlot("Handheld B", "Grenade", 1, 1) then
      actions[#actions + 1] = "ThrowGrenadeC"
    end
    if self:GetItemInSlot("Handheld B", "Grenade", 2, 1) then
      actions[#actions + 1] = "ThrowGrenadeD"
    end
    if GetUnitEquippedMedicine(self) then
      actions[#actions + 1] = "Bandage"
    end
    if GetUnitEquippedDetonator(self) then
      actions[#actions + 1] = "RemoteDetonation"
    end
  end
  actions[#actions + 1] = "ItemSkills"
  return actions
end
function Unit:RecalcUIActions(force)
  local actions
  if self:GetBandageTarget() then
    actions = {
      "StopBandaging"
    }
  elseif self:HasStatusEffect("StationedMachineGun") or self:HasStatusEffect("ManningEmplacement") then
    actions = {}
    local action = self:GetDefaultAttackAction()
    actions[#actions + 1] = action.id
    ForEachPresetInGroup("CombatAction", "MachineGun", function(def)
      if def.id ~= "MGSetup" then
        actions[#actions + 1] = def.id
      end
    end)
    actions[#actions + 1] = "Reload"
    actions[#actions + 1] = "Unjam"
  else
    actions = self:EnumUIActions()
    if not actions then
      return
    end
  end
  local ui_actions = {}
  local vis_idx = 1
  local old_actions = self.ui_actions
  self.ui_actions = ui_actions
  if actions then
    table.sort(actions, function(a, b)
      local actionA = CombatActions[a]
      local actionB = CombatActions[b]
      return actionA.SortKey < actionB.SortKey
    end)
    local firingModes = {}
    for i = 1, #actions do
      local id = actions[i]
      local caction = CombatActions[id]
      local state = "hidden"
      local firingModeId = caction.FiringModeMember
      if firingModeId then
        if caction.ShowIn == "CombatActions" and (g_Combat or #(Selection or empty_table) == 1 or caction.MultiSelectBehavior ~= "hidden") then
          local target = caction.RequireTargets and caction:GetDefaultTarget(self)
          state = caction:GetVisibility({self}, target)
        end
        if state ~= "hidden" then
          if not firingModes[firingModeId] then
            firingModes[firingModeId] = {}
          end
          table.insert(firingModes[firingModeId], id)
          ui_actions[id] = state
        end
      end
    end
    local dual_shot_state
    for modeName, mode in pairs(firingModes) do
      if modeName == "AttackDual" then
        for i, m in ipairs(mode) do
          if ui_actions[m] == "enabled" then
            dual_shot_state = "enabled"
          end
        end
      end
    end
    for modeName, mode in pairs(firingModes) do
      local defaultFireMode = mode[1]
      if 1 < #mode and (modeName ~= "AttackDual" or dual_shot_state ~= "hidden") then
        ui_actions[modeName] = "enabled"
        local defaultAction = self:GetDefaultAttackAction(false, "force_ungrouped")
        if defaultAction.FiringModeMember == modeName and ui_actions[defaultAction.id] == "enabled" then
          defaultFireMode = defaultAction.id
        else
          for i, m in ipairs(mode) do
            if ui_actions[m] == "enabled" then
              defaultFireMode = m
              break
            end
          end
        end
      else
        ui_actions[modeName] = "disabled"
      end
      if modeName ~= "AttackDual" and dual_shot_state == "enabled" then
        ui_actions[modeName] = "hidden"
        for i, m in ipairs(mode) do
          ui_actions[m] = "hidden"
        end
      elseif dual_shot_state ~= "enabled" and modeName == "AttackDual" then
        for i, m in ipairs(mode) do
          ui_actions[m] = "hidden"
        end
      end
      mode.take_idx_from = mode[1]
      ui_actions[modeName .. "default"] = defaultFireMode
    end
    local doubleTossCount = 0
    local grenadeModes = {}
    for i = 1, #actions do
      local id = actions[i]
      local caction = CombatActions[id]
      local state = "hidden"
      if caction.ShowIn == "CombatActions" or caction.ShowIn == "SignatureAbilities" then
        if ui_actions[id] then
          state = ui_actions[id]
        elseif g_Combat or #(Selection or empty_table) == 1 or caction.MultiSelectBehavior ~= "hidden" then
          local target = caction.RequireTargets and CombatActionGetOneAttackableEnemy(caction, self)
          state = caction:GetVisibility({self}, target)
        end
      end
      if state ~= "hidden" then
        local action_type
        if string.match(id, "DoubleToss") then
          action_type = "DoubleToss"
        elseif string.match(id, "ThrowGrenade") then
          action_type = "ThrowGrenade"
        end
        if action_type then
          grenadeModes[action_type] = grenadeModes[action_type] or {}
          local weapon = caction:GetAttackWeapons(self)
          if not weapon or grenadeModes[action_type][weapon.class] then
            state = "hidden"
            if action_type == "DoubleToss" then
              doubleTossCount = doubleTossCount + 1
              if doubleTossCount == 4 then
                state = "disabled"
              end
            end
          end
          if weapon then
            grenadeModes[action_type][weapon.class] = grenadeModes[action_type][weapon.class] or {}
            local equipped = self.current_weapon == "Handheld A" and (id == "ThrowGrenadeA" or id == "ThrowGrenadeB") or self.current_weapon == "Handheld B" and (id == "ThrowGrenadeC" or id == "ThrowGrenadeD")
            grenadeModes[action_type][weapon.class][id] = equipped
          end
        end
      end
      if state ~= "hidden" then
        local firingModeId = caction.FiringModeMember
        if firingModeId and ui_actions[firingModeId] == "enabled" then
          if firingModes[firingModeId].take_idx_from == id then
            table.insert(ui_actions, vis_idx, firingModeId)
            vis_idx = vis_idx + 1
          end
        elseif CombatActions[id].group ~= "Hidden" then
          table.insert(ui_actions, vis_idx, id)
          vis_idx = vis_idx + 1
        end
        ui_actions[id] = state
      elseif caction.ShowIn ~= "Special" and not caction.ShowIn then
        ui_actions[#ui_actions + 1] = id
      end
    end
    for action, _ in pairs(grenadeModes) do
      for grenadeType, _ in pairs(grenadeModes[action]) do
        for actionName, _ in pairs(grenadeModes[action][grenadeType]) do
          if grenadeModes[action][grenadeType][actionName] and not table.find(ui_actions, actionName) then
            for otherActionName, _ in pairs(grenadeModes[action][grenadeType]) do
              if table.find(ui_actions, otherActionName) then
                ui_actions[otherActionName] = nil
                ui_actions[actionName] = "enabled"
                ui_actions[table.find(ui_actions, otherActionName)] = actionName
                break
              end
            end
          end
        end
      end
    end
  end
  for i, id in ipairs(ui_actions) do
    local caction = CombatActions[id]
    if caction.group == "SignatureAbilities" then
      if ui_actions[13] then
        do
          local swapped = table.remove(ui_actions, 13)
          ui_actions[i] = swapped
          ui_actions[13] = id
        end
        break
      end
      table.remove(ui_actions, i)
      if #ui_actions < 12 then
        for j = #ui_actions + 1, 12 do
          ui_actions[j] = "empty"
        end
      end
      ui_actions[13] = id
      break
    end
  end
  if 14 < vis_idx then
    for i, itemSkill in ipairs(itemCombatSkillsList) do
      if ui_actions[itemSkill] then
        local actionIdx = table.find(ui_actions, itemSkill)
        if actionIdx then
          table.remove(ui_actions, actionIdx)
          vis_idx = vis_idx - 1
        end
      end
    end
    vis_idx = vis_idx + 1
  else
    ui_actions.ItemSkills = false
  end
  if self == Selection[1] then
    local allMatch = false
    if old_actions then
      allMatch = true
      for i, a in ipairs(old_actions) do
        if ui_actions[i] ~= a or old_actions[a] ~= ui_actions[a] then
          allMatch = false
          break
        end
      end
    end
    if not allMatch or force then
      ObjModified("combat_bar")
    end
  end
  return ui_actions
end
local OnUnitInventoryChanged = function(obj)
  obj:FlushCombatCache()
  Notify(obj, "OnGearChanged")
  if not obj:IsNPC() then
    obj:RecalcUIActions()
  end
  if obj == SelectedObj then
    if g_Combat and GetInGameInterfaceMode() ~= "IModeCombatMovement" then
      SetInGameInterfaceMode("IModeCombatMovement")
    end
    PrecalcUIIfNeeded(obj)
  end
end
function OnMsg.InventoryChange(obj)
  if not IsKindOf(obj, "Unit") then
    return
  end
  if HasCombatActionInProgress(obj) then
    CreateGameTimeThread(function()
      WaitCombatActionsEnd(obj)
      OnUnitInventoryChanged(obj)
    end)
  else
    OnUnitInventoryChanged(obj)
  end
end
function OnMsg.WeaponReloaded(unit)
  if IsKindOf(unit, "Unit") then
    CreateRealTimeThread(function()
      unit:RecalcUIActions()
      PrecalcUIIfNeeded(unit)
    end)
  end
end
MapVar("g_UIActionsThread", false)
local lastUIActionsUpdateTime = false
local lUIActionsUpdate = function()
  if g_Combat and not g_Combat.combat_started then
    return
  end
  if IsValidThread(g_UIActionsThread) or g_UIActionsThread and GameTime() == lastUIActionsUpdateTime then
    return
  end
  lastUIActionsUpdateTime = GameTime()
  g_UIActionsThread = CreateGameTimeThread(function()
    if IsSetpiecePlaying() then
      return
    end
    if not SelectedObj then
      return
    end
    WaitCombatActionsEnd(SelectedObj)
    if not SelectedObj then
      return
    end
    SelectedObj:FlushCombatCache()
    SelectedObj:RecalcUIActions()
    g_UIActionsThread = false
  end)
end
OnMsg.CombatStart = lUIActionsUpdate
OnMsg.TurnStart = lUIActionsUpdate
OnMsg.CombatEnd = lUIActionsUpdate
OnMsg.CombatActionEnd = lUIActionsUpdate
OnMsg.UnitAPChanged = lUIActionsUpdate
function OnMsg.UnitMovementDone(unit)
  if unit:IsAmbientUnit() then
    return
  end
  if not g_Combat and (not unit.team or not unit.team:IsPlayerControlled()) then
    return
  end
  for _, u in ipairs(g_Units) do
    if u == unit or u:GetLastAttack() == unit then
      u.last_attack_session_id = false
    end
  end
  lUIActionsUpdate()
end
MapVar("g_unitOrder", {})
function UpdateEnemyUIOrder(team)
  if not team or not team.player_team then
    return
  end
  g_unitOrder = {}
  for i, u in ipairs(team.units) do
    UpdateEnemyUIOrderForUnit(u)
  end
end
function UpdateEnemyUIOrderForUnit(unit)
  local unitOrder = {}
  for i, otherU in ipairs(g_Units) do
    local unitPos = SnapToPassSlab(otherU) or otherU
    local dist = unit:GetDist(unitPos)
    if UIIsEnemyAttackGood(otherU) then
      dist = -(max_int - dist)
    end
    unitOrder[otherU] = dist
  end
  g_unitOrder[unit] = unitOrder
end
function OnMsg.TurnStart(teamId)
  UpdateEnemyUIOrder(g_Teams[teamId])
end
function OnMsg.UnitMovementDone(obj)
  UpdateEnemyUIOrder(obj and obj.team)
end
