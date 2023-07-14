const.LOFIgnoreHitDistance = const.SlabSizeX
const.MaxLOFRange = 141 * const.SlabSizeX
const.CombatObjectMaxRadius = 2 * const.SlabSizeX
const.UnitHitRadius = const.SlabSizeX / 3
const.LOSCoverMaxConeAngle = 7200
const.LOSSlabMaxConeAngle = 9600
const.LOSProneHeight = 40 * guic
const.LOSCrouchHeight = 90 * guic
const.LOSStandingHeight = 130 * guic
const.LOSPointsDistForward = const.SlabSizeX / 3
const.LOSPointsDistAside = const.SlabSizeX / 10
const.AreaAttackStandingSpots = {
  "Head",
  "Torso",
  "Elbowl",
  "Elbowr"
}
const.AreaAttackProneSpots = {"Head"}
const.ConeAttackGroundMin = 20 * guic
const.ConeAttackGroundMax = 200 * guic
const.DefaultTargetSpots = {"Hit"}
const.uvVisible = 1
const.uvNPC = 2
const.uvRevealed = 4
const.usObscured = 1
const.usConcealed = 2
MapVar("TargetDummies", {}, weak_keys_meta)
DefineClass.HittableObject = {
  __parents = {"CObject"}
}
local SetDefaultTargetSpots = function()
  local prone_points = {}
  local prone_heights = {
    30 * guic
  }
  local prone_radius = 30 * guic
  local x = 40 * guic
  for i, h in ipairs(prone_heights) do
    table.insert(prone_points, point(x, 0, h))
    table.insert(prone_points, point(x, prone_radius, h))
    table.insert(prone_points, point(x, -prone_radius, h))
  end
  SetAreaAttackProneHitPos(prone_points)
  local standing_points = {}
  local standing_heights = {
    80 * guic,
    130 * guic
  }
  local standing_radius = 30 * guic
  for i, h in ipairs(standing_heights) do
    table.insert(standing_points, point(x, 0, h))
    table.insert(standing_points, point(x, standing_radius, h))
    table.insert(standing_points, point(x, -standing_radius, h))
  end
  SetAreaAttackStandingHitPos(standing_points)
end
SetDefaultTargetSpots()
OnMsg.EntitiesLoaded = UpdateUnitColliders
OnMsg.DataLoaded = UpdateUnitColliders
OnMsg.PresetSave = UpdateUnitColliders
local immune_to_half_area_damage_classes = {"Landmine"}
function GetAreaAttackHitModifier(obj, los_value)
  if (los_value or 0) == 0 then
    return 0
  elseif obj:IsInvulnerable() then
    return 0
  elseif los_value == 1 then
    if IsKindOf(obj, "Unit") then
      if obj.stance == "Prone" then
        return 0
      end
    elseif IsKindOfClasses(obj, immune_to_half_area_damage_classes) then
      return 0
    end
    return 50
  end
  return 100
end
function GetAreaAttackHitModifiers(action_id, attack_args, targets)
  local action = CombatActions[action_id]
  local cone_angle = action.AimType == "cone" and attack_args.cone_angle or -1
  if not attack_args.distance then
    attack_args.distance = attack_args.max_range and attack_args.max_range * const.SlabSizeX or -1
  end
  local maxvalue, los_values = CheckLOS(targets, attack_args.step_pos, attack_args.distance, attack_args.stance, cone_angle, attack_args.target)
  local modifiers = {}
  for i, value in ipairs(los_values) do
    modifiers[i] = GetAreaAttackHitModifier(targets[i], value)
  end
  return modifiers
end
function GetAOETiles(step_pos, stance, distance, cone_angle, target, force2d)
  local step_positions, step_objs = GetStepPositionsInArea(step_pos, distance, cone_angle, target, force2d)
  local maxvalue, los_values = CheckLOS(step_positions, step_pos, -1, stance, -1, false, false)
  return step_positions, step_objs, los_values
end
function GetAreaAttackResults(aoe_params, damage_bonus, applied_status, damage_override)
  local prediction = aoe_params.prediction
  local attacker = aoe_params.attacker
  local step_pos = not aoe_params.step_pos and IsValid(attacker) and attacker:GetPos()
  local occupied_pos = not aoe_params.occupied_pos and IsKindOf(attacker, "Unit") and attacker:GetOccupiedPos()
  local stance = aoe_params.stance or IsKindOf(attacker, "Unit") and attacker.stance or "Standing"
  local target_pos = aoe_params.target_pos or step_pos
  local explosion = aoe_params.explosion
  local cone_angle = aoe_params.cone_angle or -1
  local range
  if aoe_params.max_range and aoe_params.min_range and aoe_params.max_range ~= aoe_params.min_range then
    range = Clamp(attacker:GetDist(target_pos), aoe_params.min_range * const.SlabSizeX, aoe_params.max_range * const.SlabSizeX)
  else
    range = aoe_params.max_range and aoe_params.max_range * const.SlabSizeX or -1
  end
  local weapon = aoe_params.weapon
  local dont_destroy_covers = aoe_params.dont_destroy_covers
  local targets, los_values = GetAreaAttackTargets(step_pos, stance, prediction, range, cone_angle, target_pos, occupied_pos, dont_destroy_covers)
  targets = table.ifilter(targets, function(idx, target)
    return not IsKindOf(target, "Landmine")
  end)
  if IsValid(attacker) and not aoe_params.can_be_damaged_by_attack then
    local idx = table.find(targets, attacker)
    if idx then
      table.remove(targets, idx)
      table.remove(los_values, idx)
    end
  end
  local results = {
    start_pos = step_pos,
    target_pos = target_pos,
    range = range,
    cone_angle = cone_angle,
    aoe_type = aoe_params.aoe_type,
    explosion = explosion
  }
  if #targets == 0 then
    return results, 0, 0, {}
  end
  local total_damage, friendly_fire_dmg = 0, 0
  if not step_pos:IsValidZ() then
    step_pos = step_pos:SetTerrainZ()
  end
  local impact_force = weapon:GetImpactForce()
  for i, obj in ipairs(targets) do
    local dmg_mod = aoe_params.damage_mod
    local nominal_dmg = attacker and IsKindOf(attacker, "Unit") and attacker:GetBaseDamage(weapon, obj) or weapon.BaseDamage
    if aoe_params.damage_override then
      nominal_dmg = aoe_params.damage_override
    end
    if not prediction then
      nominal_dmg = RandomizeWeaponDamage(nominal_dmg)
    end
    local hit = {}
    results[i] = hit
    hit.obj = obj
    hit.aoe = true
    hit.area_attack_modifier = GetAreaAttackHitModifier(obj, los_values[i])
    if explosion then
      local center_range = aoe_params.center_range or 1
      if 1 < center_range then
        hit.explosion_center = obj:GetDist(target_pos) <= center_range * const.SlabSizeX
      else
        hit.explosion_center = GetPassSlab(target_pos) == GetPassSlab(obj)
      end
    end
    if 0 < hit.area_attack_modifier then
      local dmg = 0
      if dmg_mod ~= "no damage" then
        dmg_mod = dmg_mod + aoe_params.attribute_bonus
        dmg = MulDivRound(nominal_dmg, Max(0, dmg_mod), 100)
      end
      if 0 < dmg and not explosion and IsValid(attacker) and aoe_params.falloff_damage and aoe_params.falloff_start then
        local dist = attacker:GetDist(obj)
        local falloff_factor = Clamp(0, 100, MulDivRound(dist, 100, range) - aoe_params.falloff_start)
        if 0 < falloff_factor then
          local damage_start, damage_end = dmg, MulDivRound(dmg, aoe_params.falloff_damage, 100)
          dmg = Max(1, MulDivRound(damage_start, 100 - falloff_factor, 100) + MulDivRound(damage_end, falloff_factor, 100))
        end
      end
      weapon:PrecalcDamageAndStatusEffects(attacker, obj, step_pos, dmg, hit, applied_status, nil, nil, nil, prediction)
      local damage
      if damage_override then
        damage = damage_override
      else
        damage = MulDivRound(hit.damage, 100 + (damage_bonus or 0), 100)
      end
      local dmg_mod = hit.area_attack_modifier
      if explosion and IsKindOf(obj, "Unit") then
        if obj.stance == "Prone" then
          dmg_mod = dmg_mod + const.Combat.ExplosionProneDamageMod
          if HasPerk(obj, "HitTheDeck") then
            local mod = CharacterEffectDefs.HitTheDeck:ResolveValue("explosiveLessDamage")
            dmg_mod = dmg_mod - mod
          end
        elseif obj.stance == "Crouch" then
          dmg_mod = dmg_mod + const.Combat.ExplosionCrouchDamageMod
        end
      end
      damage = MulDivRound(damage, Max(0, dmg_mod), 100)
      if aoe_params.stealth_attack_roll and IsKindOf(attacker, "Unit") and IsKindOf(obj, "Unit") and not obj.villain and not obj:IsDead() then
        if aoe_params.stealth_attack_roll < attacker:CalcStealthKillChance(weapon, obj) then
          damage = MulDivRound(obj:GetTotalHitPoints(), 100 + obj:Random(50), 100)
          hit.stealth_kill = true
        end
        hit.stealth_kill_chance = attacker:CalcStealthKillChance(weapon, obj)
      end
      hit.damage = damage
      if IsKindOf(attacker, "Unit") and IsKindOf(obj, "Unit") then
        total_damage = total_damage + damage
        if not obj:IsOnEnemySide(attacker) then
          friendly_fire_dmg = friendly_fire_dmg + damage
        end
      end
      hit.impact_force = impact_force + weapon:GetDistanceImpactForce(obj:GetDist(step_pos))
    else
      hit.damage = 0
      hit.stuck = true
      hit.armor_decay = empty_table
      hit.effects = empty_table
    end
    if aoe_params.explosion_fly and IsKindOf(hit.obj, "Unit") and hit.damage >= const.Combat.GrenadeMinDamageForFly then
      hit.explosion_fly = true
    end
  end
  results.total_damage = total_damage
  results.friendly_fire_dmg = friendly_fire_dmg
  results.hit_objs = targets
  return results, total_damage, friendly_fire_dmg, targets
end
if FirstLoad then
  g_InvisibleUnitOpacity = 0
  g_ExperimentalModeLOS = "slab block only"
end
config.SlabEntityList = ""
function DbgCycleExperimentalLOS()
  config.SlabEntityList = ""
  if not g_ExperimentalModeLOS then
    g_ExperimentalModeLOS = "all visible"
    print("LOS: All enemies are visibles")
  elseif g_ExperimentalModeLOS == "all visible" then
    g_ExperimentalModeLOS = "slab block only"
    config.SlabEntityList = "Floor,Stairs,WallExt,WallInt,Door,TallDoor,Window,WindowBig,WindowVent,Roof"
    print("LOS: Only Slab objects block vision")
  else
    g_ExperimentalModeLOS = false
    print("LOS: Normal mode.")
  end
end
local IsVisibleTo = function(self, other)
  if g_ExperimentalModeLOS == "all visible" then
    return true
  end
  if not other.team:IsEnemySide(self.team) then
    return true
  end
  if self:CanSee(other) then
    return true
  end
  return false
end
MapVar("g_Visibility", {})
MapVar("g_SightConditions", {})
MapVar("g_RevealedUnits", {})
MapVar("g_VisibilityUpdated", false)
MapVar("g_SetpieceFullVisibility", false)
function NetSyncEvents.RevealToTeam(unit, teamId)
  unit:RevealTo(g_Teams[teamId])
end
function Unit:RevealTo(obj, combat)
  combat = combat or g_Combat
  if not combat then
    return
  end
  if not IsKindOfClasses(obj, "Unit", "CombatTeam") then
    return
  end
  local team = IsValid(obj) and obj.team or obj
  g_RevealedUnits[team] = g_RevealedUnits[team] or {}
  table.insert_unique(g_RevealedUnits[team], self)
  self:RemoveStatusEffect("Spotted")
  self:RemoveStatusEffect("Hidden")
  self:AddStatusEffect("Revealed")
  if not HasVisibilityTo(team, self) then
    g_Visibility[team] = g_Visibility[team] or {}
    table.insert(g_Visibility[team], self)
  end
  g_Visibility[team][self] = bor(g_Visibility[team][self] or 0, const.uvRevealed)
  InvalidateDiplomacy()
  if g_Combat then
    g_Combat:ApplyVisibility()
  end
  for _, unit in ipairs(team.units) do
    if VisibilityCheckAll(unit, self, nil, const.uvVisible) and unit:HasStatusEffect("Unaware") then
      PushUnitAlert("sight", unit, self)
    end
  end
  AlertPendingUnits()
end
function VisibilityCheckAll(observer, other, visibility, mask)
  local trap = IsKindOf(other, "Trap")
  local unit = IsKindOf(other, "Unit")
  if not trap and not unit then
    return true
  end
  if trap then
    local trapVis = g_AttackableVisibility[observer] or empty_table
    trapVis = trapVis[other] and const.uvVisible or 0
    return band(trapVis, mask) == mask
  end
  visibility = visibility or g_Visibility
  local value = visibility[observer] and visibility[observer][other] or 0
  return band(value, mask) == mask
end
function VisibilityCheckAny(observer, other, visibility, mask)
  local trap = IsKindOf(other, "Trap")
  local unit = IsKindOf(other, "Unit")
  if not trap and not unit then
    return true
  end
  if trap then
    local trapVis = g_AttackableVisibility[observer] or empty_table
    trapVis = trapVis[other] and const.uvVisible or 0
    return band(trapVis, mask) ~= 0
  end
  visibility = visibility or g_Visibility
  local value = visibility[observer] and visibility[observer][other] or 0
  return band(value, mask) ~= 0
end
function HasVisibilityTo(observer, other, visibility)
  local trap = IsKindOf(other, "Trap")
  local unit = IsKindOf(other, "Unit")
  if not trap and not unit then
    return true
  end
  if trap then
    local trapVis = g_AttackableVisibility[observer] or empty_table
    return trapVis[other]
  end
  visibility = visibility or g_Visibility
  local value = visibility[observer] and visibility[observer][other] or 0
  return value >= const.uvVisible
end
function VisibilityGetValue(observer, other, visibility)
  local trap = IsKindOf(other, "Trap")
  local unit = IsKindOf(other, "Unit")
  if not trap and not unit then
    return const.uvVisible
  end
  if trap then
    local trapVis = g_AttackableVisibility[observer] or empty_table
    return trapVis[other] and const.uvVisible or 0
  end
  visibility = visibility or g_Visibility
  return visibility[observer] and visibility[observer][other] or 0
end
function IsFullVisibility()
  return CheatEnabled("FullVisibility")
end
function CheckSightCondition(observer, other, condition)
  local value = (g_SightConditions[observer] or empty_table)[other] or 0
  return band(value, condition) == condition
end
local HandleSortFunction = function(a, b)
  return a.handle < b.handle
end
function Unit:ComputeVisibleUnits(visibility)
  local unit_visibility = {}
  local team = self.team
  local uvVisible = const.uvVisible
  for unit, los in pairs(g_UnitsLOS[self]) do
    local vis_value = los and uvVisible or 0
    if not unit:IsOnEnemySide(self) and unit:IsNPC() and not unit:HasStatusEffect("HiddenNPC") then
      vis_value = bor(vis_value, const.uvNPC)
    end
    if uvVisible <= vis_value then
      table.insert(unit_visibility, unit)
    end
    unit_visibility[unit] = vis_value
  end
  table.sort(unit_visibility, HandleSortFunction)
  return unit_visibility
end
function GetMaxSightRadius()
  return MulDivRound(const.Combat.AwareSightRange, const.SlabSizeX * const.Combat.SightModMaxValue, 100)
end
local is_script_target = function(unit, target_groups)
  for _, group in ipairs(unit.Groups) do
    if target_groups[group] then
      return true
    end
  end
end
local UpdateUnitsLOS = function(unitsLOS)
  local player_units = {}
  local enemy_units = {}
  local neutral_units = {}
  local dead_units = {}
  local enemyNeutral_Side = GameState.Conflict and "enemy1" or "neutral"
  local script_target_groups = {}
  for group, mods in pairs(gv_AITargetModifiers) do
    for target_group, value in pairs(mods) do
      script_target_groups[target_group] = true
    end
  end
  local insert = table.insert
  for _, unit in ipairs(g_Units) do
    local team = unit.team
    local side = team and team.side
    if side == "enemyNeutral" then
      side = enemyNeutral_Side
    end
    if not unit:IsValidPos() then
    elseif unit:IsDead() then
      if side and side ~= "neutral" and not team.player_team then
        insert(dead_units, unit)
      end
    elseif side == "neutral" then
      if is_script_target(unit, script_target_groups) then
        insert(enemy_units, unit)
      else
        insert(neutral_units, unit)
      end
    elseif team and team.player_team then
      insert(player_units, unit)
    elseif side then
      insert(enemy_units, unit)
    end
    local los_tbl = unitsLOS[unit]
    if los_tbl then
      table.clear(los_tbl)
    else
      los_tbl = setmetatable({}, weak_keys_meta)
      unitsLOS[unit] = los_tbl
    end
    los_tbl[unit] = 2
  end
  local src_units, target_units = {}, {}
  for i, unit1 in ipairs(player_units) do
    for j, unit2 in ipairs(player_units) do
      if unit1 ~= unit2 then
        insert(src_units, unit1)
        insert(target_units, unit2)
      end
    end
    for j, unit2 in ipairs(enemy_units) do
      insert(src_units, unit1)
      insert(target_units, unit2)
    end
    for j, unit2 in ipairs(neutral_units) do
      insert(src_units, unit1)
      insert(target_units, unit2)
    end
  end
  for i, unit1 in ipairs(enemy_units) do
    for j, unit2 in ipairs(player_units) do
      insert(src_units, unit1)
      insert(target_units, unit2)
    end
    local side1 = unit1.team.side
    if side1 == "enemyNeutral" then
      side1 = enemyNeutral_Side
    end
    for j, unit2 in ipairs(enemy_units) do
      local side2 = unit2.team.side
      if side2 == "enemyNeutral" then
        side2 = enemyNeutral_Side
      end
      if side1 ~= side2 then
        insert(src_units, unit1)
        insert(target_units, unit2)
      end
    end
    for j, unit2 in ipairs(dead_units) do
      local side2 = unit2.team.side
      if side2 == "enemyNeutral" then
        side2 = enemyNeutral_Side
      end
      if side1 == side2 then
        insert(src_units, unit1)
        insert(target_units, unit2)
      end
    end
  end
  if 0 < #src_units then
    local los_any, result = CheckLOS(target_units, src_units)
    local uvVisible = const.uvVisible
    for i, vis_value in ipairs(result) do
      unitsLOS[src_units[i]][target_units[i]] = vis_value
    end
  end
end
function ComputeUnitsVisibility()
  UpdateUnitsLOS(g_UnitsLOS)
  local visibility = {}
  for _, t in ipairs(g_Teams) do
    local tvis = {}
    visibility[t] = tvis
    for i, ru in ipairs(g_RevealedUnits[t]) do
      if not ru:IsDead() then
        table.insert(tvis, ru)
        tvis[ru] = const.uvRevealed
      end
    end
  end
  for _, unit in ipairs(g_Units) do
    if IsValid(unit) and unit:IsValidPos() and not unit:IsDead() and unit.team.side ~= "neutral" then
      visibility[unit] = unit:ComputeVisibleUnits(visibility)
    end
  end
  local old_visual = {}
  local uvVisible = const.uvVisible
  for i, unit in ipairs(g_Units) do
    old_visual[i] = unit.enemy_visual_contact
    unit.enemy_visual_contact = false
    local uteam = unit.team
    local tvis = visibility[uteam]
    local uvis = visibility[unit]
    for key, value in sorted_handled_obj_key_pairs(uvis) do
      if IsValid(key) then
        local tval = bor(tvis[key] or 0, value)
        if uvVisible <= tval and not HasVisibilityTo(uteam, key, visibility) then
          tvis[#tvis + 1] = key
        end
        tvis[key] = tval
      end
    end
  end
  for _, team in ipairs(g_Teams) do
    local vis = visibility[team]
    for _, team2 in ipairs(g_Teams) do
      if team ~= team2 and team:IsAllySide(team2) then
        local vis2 = visibility[team2]
        for key, value in sorted_handled_obj_key_pairs(vis) do
          if IsValid(key) and uvVisible <= value and not HasVisibilityTo(team2, key, visibility) then
            vis2[#vis2 + 1] = key
            vis2[key] = bor(vis2[key], const.uvRevealed)
          end
        end
      end
    end
  end
  g_SightConditions = {}
  local FogUnkownFoeDistance = const.EnvEffects.FogUnkownFoeDistance
  local DustStormUnkownFoeDistance = const.EnvEffects.DustStormUnkownFoeDistance
  for i, unit in ipairs(g_Units) do
    g_SightConditions[unit] = {}
    if unit:IsAware("pending") then
      for _, other in ipairs(visibility[unit]) do
        if IsValid(other) and other:IsOnEnemySide(unit) then
          other.enemy_visual_contact = true
          if g_Combat and g_Teams[g_CurrentTeam] == other.team and other:HasStatusEffect("Hidden") and other.team.player_team and other.in_combat_movement then
            other:AddStatusEffect("Spotted")
            other:SetEffectValue("Spotted-" .. unit.team.side, true)
          end
        end
      end
    end
    for _, other in ipairs(visibility[unit.team]) do
      local value = 0
      if IsValid(other) then
        if GameState.Fog and not other.indoors and not IsCloser(unit, other, FogUnkownFoeDistance) then
          value = bor(value, const.usConcealed)
        end
        if GameState.DustStorm and not other.indoors and not IsCloser(unit, other, DustStormUnkownFoeDistance) then
          value = bor(value, const.usObscured)
        end
      end
      g_SightConditions[unit][other] = value
    end
  end
  for _, team in ipairs(g_Teams) do
    if team.player_team then
      local seen = visibility[team]
      for _, unit in ipairs(seen) do
        if IsValid(unit) and unit:HasStatusEffect("HiddenNPC") and VisibilityCheckAll(team, unit, visibility, uvVisible) then
          unit:RemoveStatusEffect("HiddenNPC")
        end
      end
    end
  end
  for i, unit in ipairs(g_Units) do
    if IsValid(unit) and unit.enemy_visual_contact ~= old_visual[i] then
      unit:UpdateHidden()
      Msg("UnitStealthChanged", unit)
    end
  end
  g_VisibilityUpdated = true
  return visibility
end
local Visibility_UnitsHash = function()
  local hash
  for _, unit in ipairs(g_Units) do
    local sight = unit:GetSightRadius()
    local stance_idx = StancesList[unit.stance]
    if unit:IsValidPos() then
      hash = xxhash(stance_pos_pack(unit, stance_idx), sight, hash)
    end
    if unit.visibility_override then
      hash = xxhash(stance_pos_pack(unit.visibility_override.pos, stance_idx), sight, hash)
    end
  end
  for _, list in ipairs(g_RevealedUnits) do
    for _, unit in ipairs(list) do
      hash = xxhash(unit:GetHandle(), hash)
    end
  end
  return hash
end
local Visibility_ResultsHash = function()
  local hash
  for _, unit in ipairs(g_Units) do
    local uvis = g_Visibility[unit]
    hash = xxhash(unit.handle, hash)
    for _, target in ipairs(uvis) do
      hash = xxhash(target.handle, uvis[target], hash)
    end
  end
  return hash
end
function Combat:UpdateVisibility()
  local hash = Visibility_UnitsHash()
  if hash == self.visibility_update_hash then
    return
  end
  self.visibility_update_hash = hash
  local prev_visibility = g_Visibility
  g_Visibility = ComputeUnitsVisibility()
  for ti, team in ipairs(g_Teams) do
    if prev_visibility then
      local prev = prev_visibility[team] or empty_table
      for _, unit in ipairs(prev) do
        if IsValid(unit) and not unit:IsDead() and unit.team ~= team and unit.team:IsEnemySide(team) and not HasVisibilityTo(team, unit) then
          team:OnEnemyLost(unit)
        end
      end
      for _, unit in ipairs(g_Visibility[team]) do
        if unit.team:IsEnemySide(team) and not HasVisibilityTo(team, unit, prev_visibility) then
          if unit:HasStatusEffect("Spotted") then
            unit:SetEffectValue("Spotted-" .. team.side, true)
          else
            team:OnEnemySighted(unit)
            unit:RevealTo(team)
          end
        end
      end
    end
  end
  if prev_visibility then
    for _, unit in ipairs(g_Units) do
      for _, other in ipairs(g_Visibility[unit]) do
        if unit:IsOnEnemySide(other) and not HasVisibilityTo(unit, other, prev_visibility) then
          unit:OnEnemySighted(other)
        end
      end
    end
  end
  Msg("CombatComputedVisibility")
end
local IsInsideClosedVolume = function(unit)
  local volume = EnumVolumes(unit, "smallest")
  local building = volume and volume.building
  if building then
    local open_floor = VT2TouchedBuildings and VT2TouchedBuildings[building]
    return not open_floor or open_floor ~= volume.floor
  end
end
function IsOnFadedSlab(obj)
  local uz
  if IsValid(obj) then
    uz = select(3, obj:GetPosXYZ())
  elseif IsPoint(obj) then
    uz = obj:z()
  end
  local slab = uz and MapGetFirst(obj, const.SlabSizeX / 2, "FloorSlab", "RoofSlab", const.efVisible, function(slab, uz)
    local sz = select(3, slab:GetPosXYZ())
    if sz and abs(uz - sz) < const.SlabSizeZ / 2 then
      local cmt_state = C_CCMT_GetObjCMTState(slab)
      if cmt_state == const.cmtHidden or cmt_state == const.cmtFadingOut then
        return true
      end
    end
  end, uz)
  if slab then
    return true
  end
  return false
end
local CameraObscureSpots = {
  High = {
    "Head",
    "Torso",
    "Elbowl",
    "Elbowr",
    "Kneel",
    "Kneer"
  },
  Medium = {
    "Head",
    "Torso",
    "Elbowl",
    "Elbowr"
  },
  [false] = {"Torso"}
}
function OnMsg.SetObjectDetail(action, params)
  if action == "done" then
    SetCameraObscureSpots(CameraObscureSpots[EngineOptions.ObjectDetail] or CameraObscureSpots[false])
  end
end
function ApplyUnitVisibility(active_units, pov_team, visibility, force)
  local innerInfo = gv_CurrentSectorId and g_Units.Livewire and g_Units.Livewire.team == pov_team and gv_Sectors[gv_CurrentSectorId].intel_discovered
  active_units = IsKindOf(active_units, "Unit") and {active_units} or active_units
  local observers = g_Combat and {
    SelectedObj or nil
  } or Selection or {}
  local full_visibility = IsFullVisibility()
  local sector = (gv_DeploymentStarted or gv_Deployment) and gv_Sectors[gv_CurrentSectorId]
  local pov_team_hidden = sector and sector.enabled_auto_deploy and pov_team.control == "UI"
  local is_current_team_pov_team = g_Teams[g_CurrentTeam] == pov_team
  local uvVisible = const.uvVisible
  local deployment_markers
  local camera_visibility_check_list = {}
  for i, unit in ipairs(g_Units) do
    if not IsValid(unit) then
    elseif unit:HasStatusEffect("SetpieceHidden") or unit:HasStatusEffect("ScriptingHidden") or IsValid(unit.death_fx_object) then
      unit:SetVisible(false, "force")
      unit:SetHighlightReason("visibility", nil)
    elseif gv_Deployment and IsMerc(unit) then
    elseif full_visibility then
      unit:SetVisible(true)
      unit:SetHighlightReason("visibility", false)
      unit:SetHighlightReason("concealed", false)
      unit:SetHighlightReason("obscured", false)
      unit:SetHighlightReason("faded", false)
    elseif not IsSetpieceActor(unit) then
      if IsValid(unit.prepared_attack_obj) then
        if unit.team:IsEnemySide(pov_team) then
          unit.prepared_attack_obj:SetColorFromTextStyle("PreparedAttackEnemy")
        else
          unit.prepared_attack_obj:SetColorFromTextStyle("PreparedAttackFriendly")
        end
      end
      if unit.team == pov_team then
        if unit.on_die_hit_descr and unit.on_die_hit_descr.death_explosion then
          unit:SetVisible(false)
          unit:SetHighlightReason("visibility", nil)
        elseif IsOnFadedSlab(unit) then
          unit:SetVisible(not pov_team_hidden)
          unit:SetHighlightReason("visibility", true)
        else
          unit:SetVisible(not pov_team_hidden)
          table.insert(camera_visibility_check_list, unit)
        end
      elseif unit:IsDead() then
        if unit.on_die_hit_descr and unit.on_die_hit_descr.death_explosion then
          unit:SetVisible(false, "force")
          unit:SetHighlightReason("visibility", nil)
        elseif IsOnFadedSlab(unit) then
          local interaction
          for _, au in ipairs(active_units) do
            if unit:GetInteractionCombatAction(au) then
              interaction = true
              break
            end
          end
          if interaction then
            unit:SetVisible(true)
            unit:SetHighlightReason("visibility", true)
          else
            unit:SetVisible(false, "force")
            unit:SetHighlightReason("visibility", nil)
          end
        else
          unit:SetVisible(true)
          unit:SetHighlightReason("visibility", nil)
        end
        unit:SetHighlightReason("concealed", unit:UIConcealed("skip"))
        unit:SetHighlightReason("obscured", unit:UIObscured())
      else
        local seen_by_player = innerInfo or HasVisibilityTo(pov_team, unit) and not unit:HasStatusEffect("Hidden")
        if not seen_by_player then
          if deployment_markers == nil then
            deployment_markers = (gv_DeploymentStarted or gv_Deployment) and GetAvailableDeploymentMarkers() or empty_table
            if #deployment_markers == 0 then
              deployment_markers = false
            end
          end
          if deployment_markers and IsUnitSeenByAnyDeploymentMarker(unit, deployment_markers) then
            seen_by_player = true
          end
        end
        if seen_by_player then
          unit:SetVisible(true)
          local los_active
          local on_faded_slab = IsOnFadedSlab(unit)
          if not on_faded_slab then
            if is_current_team_pov_team then
              for _, observer in ipairs(active_units) do
                if VisibilityCheckAll(observer, unit, nil, uvVisible) then
                  los_active = true
                  break
                end
              end
            else
              los_active = true
            end
          end
          unit:SetHighlightReason("concealed", unit:UIConcealed("skip"))
          unit:SetHighlightReason("obscured", unit:UIObscured())
          if on_faded_slab or not los_active then
            unit:SetHighlightReason("visibility", true)
          else
            table.insert(camera_visibility_check_list, unit)
          end
          unit:SetHighlightReason("faded", on_faded_slab)
        elseif unit:HasStatusEffect("DiamondCarrier") then
          unit:SetVisible(true)
          unit:SetHighlightReason("visibility", true)
        else
          unit:SetVisible(false)
        end
      end
    end
  end
  if 0 < #camera_visibility_check_list then
    local camera_visibility = IsVisibleFromCamera(camera_visibility_check_list)
    for i, unit in ipairs(camera_visibility_check_list) do
      unit:SetHighlightReason("visibility", not camera_visibility[i])
    end
  end
end
function Combat:ApplyVisibility(active_unit)
  active_unit = active_unit or SelectedObj or self.starting_unit
  local pov_team = GetPoVTeam()
  local playerControlled = g_Teams[g_CurrentTeam]:IsPlayerControlled()
  if pov_team ~= g_Teams[g_CurrentTeam] or playerControlled and not SelectedObj then
    active_unit = pov_team.units
  end
  ApplyUnitVisibility(active_unit, pov_team, g_Visibility)
  NetUpdateHash("CombatApplyVisibility", GameTime())
  Msg("CombatApplyVisibility", pov_team)
end
function Combat:ShouldEndDueToNoVisibility()
  if Game and Game.game_type == "PvP" then
    return
  end
  local any_visibility
  for _, t in ipairs(g_Teams) do
    if g_Visibility[t] and #g_Visibility[t] > 0 then
      for i, tt in ipairs(g_Teams) do
        if t:IsEnemySide(tt) and g_Visibility[tt] and #g_Visibility[tt] > 0 then
          any_visibility = true
          break
        end
        if any_visibility then
          break
        end
      end
      if any_visibility then
        break
      end
    end
  end
  if any_visibility then
    self.turns_no_visibility = 0
  else
    self.turns_no_visibility = self.turns_no_visibility + 1
  end
  return self.turns_no_visibility > #g_Teams * 2
end
MapVar("g_VisibilityUpdateThread", false)
MapVar("g_UnitsLOS", {}, weak_keys_meta)
function InvalidateUnitLOS(unit)
  g_UnitsLOS[unit] = nil
  for u, los_tbl in pairs(g_UnitsLOS) do
    los_tbl[unit] = nil
  end
  VisibilityUpdate()
end
function InvalidateVisibility(force)
  g_UnitsLOS = {}
  VisibilityUpdate(force)
end
MapVar("g_VisibilityLastUpdateTime", 0)
MapVar("g_VisiblityUpdatesCount", 0)
MapVar("g_VisiblityUpdatesTime", 0)
MapVar("g_VisiblityUpdatesReportTime", GetPreciseTicks())
MapVar("g_VisibilityUpdateSuspendReasons", {})
MapVar("ReportVisibilityUpdates", false)
MapVar("g_VisibilityExplorationTick", false)
MapVar("g_VisibilityExplorationDirty", false)
MapGameTimeRepeat("ExplorationVisibilityUpdate", 500, function()
  if not g_VisibilityExplorationDirty then
    return
  end
  g_VisibilityExplorationTick = true
  InvalidateVisibility()
  g_VisibilityExplorationDirty = false
  g_VisibilityExplorationTick = false
end)
function SuspendVisibiltyUpdates(reason)
  g_VisibilityUpdateSuspendReasons[reason] = true
end
function ResumeVisibiltyUpdates(reason)
  g_VisibilityUpdateSuspendReasons[reason] = nil
  if next(g_VisibilityUpdateSuspendReasons) == nil then
    VisibilityUpdate()
    return true
  end
end
function OnMsg.CombatActionStart(unit)
  if not g_Combat then
    return
  end
  SuspendVisibiltyUpdates(unit)
end
function OnMsg.CombatActionEnd(unit)
  if not g_Combat then
    return
  end
  CreateGameTimeThread(function()
    if ResumeVisibiltyUpdates(unit) then
      WaitMsg("VisibilityUpdate")
    end
    if g_Combat then
      g_Combat:EndCombatCheck()
    end
  end)
end
local lExplorationVisibilityApply = function()
  if g_Combat or g_StartingCombat or IsSetpiecePlaying() then
    return
  end
  local prev_visibility = g_Visibility or empty_table
  g_Visibility = ComputeUnitsVisibility()
  local pov_team = GetPoVTeam()
  if not pov_team then
    return
  end
  local active_units = Selection
  if not active_units or #active_units == 0 then
    active_units = SelectedObj
  end
  ApplyUnitVisibility(active_units, pov_team, g_Visibility)
  local sees_enemy
  for _, seen in ipairs(g_Visibility[pov_team]) do
    if seen.team and pov_team:IsEnemySide(seen.team) and not seen:IsDead() then
      if not HasVisibilityTo(pov_team, seen, prev_visibility) then
        Msg("EnemySightedExploration", seen)
      end
      sees_enemy = true
    end
  end
  if g_TestCombat and sees_enemy then
    NetSyncEvent("ExplorationStartCombat")
  end
end
function VisibilityUpdate(force)
  local cleanup = {}
  for reason, _ in sorted_handled_obj_key_pairs(g_VisibilityUpdateSuspendReasons) do
    if IsKindOf(reason, "Unit") and reason:IsDead() then
      cleanup[#cleanup + 1] = reason
    end
  end
  for _, reason in ipairs(cleanup) do
    g_VisibilityUpdateSuspendReasons[reason] = nil
  end
  NetUpdateHash("VisibilityUpdate()", GameTime(), #table.keys(g_VisibilityUpdateSuspendReasons), force)
  if next(g_VisibilityUpdateSuspendReasons) ~= nil and not force then
    return
  end
  if not IsValidThread(g_VisibilityUpdateThread) then
    if not g_Combat then
      g_VisibilityExplorationDirty = true
      if not g_VisibilityExplorationTick then
        return
      end
    end
    g_VisibilityLastUpdateTime = GameTime()
    g_VisibilityUpdateThread = CreateGameTimeThread(function(force)
      local tStart = GetPreciseTicks()
      if g_Combat then
        if force then
          g_Combat.visibility_update_hash = false
        end
        g_Combat:UpdateVisibility()
        g_Combat:ApplyVisibility()
      else
        lExplorationVisibilityApply()
      end
      NetUpdateHash("VisibilityUpdate", GameTime(), Visibility_UnitsHash(), Visibility_ResultsHash())
      Msg("VisibilityUpdate")
      ObjModified("VisibilityUpdate")
      g_VisibilityUpdateThread = false
      if ReportVisibilityUpdates then
        local time_now = GetPreciseTicks()
        local update_time = time_now - tStart
        g_VisiblityUpdatesCount = g_VisiblityUpdatesCount + 1
        g_VisiblityUpdatesTime = g_VisiblityUpdatesTime + update_time
        if time_now - g_VisiblityUpdatesReportTime > 1000 then
          printf("%d visibility updates in the last second, %d ms spent updating in total, %d ms per call", g_VisiblityUpdatesCount, g_VisiblityUpdatesTime, g_VisiblityUpdatesTime / g_VisiblityUpdatesCount)
          g_VisiblityUpdatesCount = 0
          g_VisiblityUpdatesTime = 0
          g_VisiblityUpdatesReportTime = time_now
        end
      end
    end, force)
  end
end
function NetSyncEvents.RecalcVisibility()
  WaitRecalcVisibility = false
  if g_Combat then
    g_Combat:UpdateVisibility()
    g_Combat:ApplyVisibility()
  end
end
MapVar("WaitRecalcVisibility", false)
function OnMsg.SelectionChange()
  if g_Combat and g_Combat.combat_started then
    WaitRecalcVisibility = true
    NetSyncEvent("RecalcVisibility")
  end
end
function OnMsg.UnitMovementDone(unit)
  UpdateIndoors(unit)
  InvalidateUnitLOS(unit)
end
OnMsg.CombatGotoStep = InvalidateUnitLOS
OnMsg.UnitStanceChanged = InvalidateUnitLOS
function OnMsg.UnitDieStart(...)
  if g_Combat then
    g_Combat.visibility_update_hash = false
  end
  InvalidateUnitLOS(...)
  g_VisibilityUpdated = false
end
function OnMsg.OnPassabilityChanged()
  if IsEditorActive() then
    return
  end
  InvalidateVisibility("force")
end
function OnMsg.OverwatchChanged()
  NetUpdateHash("VU_OverwatchChanged")
  VisibilityUpdate()
end
OnMsg.GameExitEditor = InvalidateVisibility
OnMsg.UnitAwarenessChanged = InvalidateUnitLOS
OnMsg.UnitStealthChanged = InvalidateVisibility
function OnMsg.GroupChangeSide()
  NetUpdateHash("VU_GroupChangeSide")
  VisibilityUpdate()
end
function OnMsg.DiplomacyInvalidated()
  NetUpdateHash("VU_DiplomacyInvalidated")
  VisibilityUpdate()
end
function OnMsg.TurnStart(team)
  team = g_Teams[team]
  for _, unit in ipairs(team.units) do
    for _, list in pairs(g_RevealedUnits) do
      table.remove_value(list, unit)
    end
    unit:RemoveStatusEffect("Revealed")
  end
  local units = g_Visibility[team]
  g_RevealedUnits[team] = g_RevealedUnits[team] or {}
  for _, unit in ipairs(units) do
    if team:IsEnemySide(unit.team) then
      unit:RevealTo(team)
    end
  end
end
function ReapplyUnitVisibility(force)
  local pov_team = GetPoVTeam()
  if not pov_team then
    return
  end
  local active_units = Selection
  if not active_units or #active_units == 0 then
    active_units = SelectedObj or pov_team.units
  end
  ApplyUnitVisibility(active_units, pov_team, g_Visibility, force)
end
OnMsg.WallVisibilityChanged = ReapplyUnitVisibility
function OnMsg.SetObjectDetail(stage)
  if stage == "done" then
    ReapplyUnitVisibility()
  end
end
local last_camera_hash = 0
MapRealTimeRepeat("unit_visibility", 250, function()
  if not cameraTac.IsActive() then
    return
  end
  local eye, lookat = cameraTac.GetPosLookAt()
  local hash = xxhash(GetMap(), eye, lookat)
  if hash ~= last_camera_hash then
    ReapplyUnitVisibility()
    last_camera_hash = hash
  end
end)
function OnMsg.EntitiesLoaded()
  SetupEntityObstructionMasks()
end
AppendClass.EntitySpecProperties = {
  properties = {
    {
      id = "obstruction",
      name = "Blocks line of sight",
      editor = "bool",
      category = "Misc",
      default = false,
      entitydata = true
    }
  }
}
function SetupEntityObstructionMasks(cheatEnabled)
  local obstruction_entities = {}
  local cover_entities = {}
  local materials = Presets.ObjMaterial.Default
  for k in pairs(GetAllEntities()) do
    local t = EntityData[k]
    if t then
      local entity = t.entity
      local material = entity and materials[entity.material_type]
      if t.editor_category == "Slab" and t.editor_subcategory ~= "Window" and t.editor_subcategory ~= "Door" or t.editor_category == "Rock" or entity and entity.obstruction or material and material.impenetrable or k:find("WallExt") or k:find("WallInt") or k:find("Floor") or k:find("Roof") or k:find("Stairs") or k:find("Vehicle") or k:find("WaterPlane") then
        obstruction_entities[#obstruction_entities + 1] = k
      end
      if not (cheatEnabled and material) or not material.is_prop and 1 < material.armor_class then
        cover_entities[#cover_entities + 1] = k
      end
    end
  end
  SetEntityObstructionMasks(obstruction_entities, cover_entities)
end
