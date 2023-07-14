DefineClass.IModeCombatCharge = {
  __parents = {
    "IModeCombatAttackBase"
  }
}
function IModeCombatCharge:Confirm()
  if not IsValid(SelectedObj) or not SelectedObj:CanBeControlled() then
    return
  end
  if not self.target_path and not IsMerc(self.target_pos_has_unit) then
    local blackboard = self.targeting_blackboard
    if blackboard and blackboard.no_straight_line_error then
      ReportAttackError(GetCursorPos(), AttackDisableReasons.NoLine)
    elseif blackboard and blackboard.min_dist_error then
      ReportAttackError(GetCursorPos(), AttackDisableReasons.MinDist)
    else
      ReportAttackError(GetCursorPos(), AttackDisableReasons.OutOfRange)
    end
    return
  elseif not self.target_pos then
    ReportAttackError(GetCursorPos(), AttackDisableReasons.NoTarget)
    return
  end
  return IModeCombatAttackBase.Confirm(self)
end
local combat_path_to_charge_path = function(path)
  local charge = {
    path[1]
  }
  local _prev = point(point_unpack(path[1]))
  for i = 2, #path - 1 do
    local _cur = point(point_unpack(path[i]))
    local _next = point(point_unpack(path[i + 1]))
    local v1, v2 = SetLen((_cur - _prev):SetZ(0), 4096), SetLen((_next - _cur):SetZ(0), 4096)
    if 4096 > Dot(v1, v2) / 4096 then
      charge[#charge + 1] = path[i]
      _prev = _cur
    end
  end
  charge[#charge + 1] = path[#path]
  return charge
end
function GetChargeAttackPosition(attacker, target, ap, action_id)
  local apos = attacker:GetPos()
  local tpos = GetPassSlab(target)
  local combatPath = CombatPath:new()
  if not ap then
    local action = CombatActions[action_id]
    ap = action:ResolveValue("move_ap") * const.Scale.AP
  end
  combatPath:RebuildPaths(attacker, ap)
  local atk_pos, atk_dot, atk_path, min_dist_error, not_straight_error, frontal_error
  local tiles = combatPath:GetReachableMeleeRangePositions(target, true)
  if tiles then
    local min_angle = CombatActions[action_id]:ResolveValue("minAngle") * const.Scale.deg
    local ref_dot = MulDivRound(cos(min_angle), 1000, 4096)
    for i, tile in ipairs(tiles) do
      local minDistance = CombatActions.Charge:ResolveValue("minDistance") * const.Scale.AP
      local path = combatPath:GetCombatPathFromPos(tile)
      local tooClose = minDistance > attacker:GetDist(point_unpack(tile))
      if path then
        path = combat_path_to_charge_path(path)
        local pos = point(point_unpack(tile))
        local prev_pos = point(point_unpack(path[2]))
        local move_dir = SetLen2D(pos - prev_pos, guim)
        local atk_dir = SetLen2D(pos - tpos, guim)
        local dot = Dot2D(move_dir, atk_dir) / guim
        if not atk_pos or atk_dot > dot then
          local notStraight = ref_dot < dot or #path ~= 2 and action_id ~= "GloryHog"
          frontal_error = ref_dot < dot
          atk_pos, atk_dot, atk_path, min_dist_error, not_straight_error = pos, dot, path, tooClose, notStraight
        end
      end
    end
  end
  DoneObject(combatPath)
  return atk_pos, atk_path, min_dist_error, not_straight_error, frontal_error
end
function GetHyenaChargeAttackPosition(attacker, target, ap, jump_dist, action_id)
  local action = CombatActions[action_id]
  local combatPath = CombatPath:new()
  combatPath:RebuildPaths(attacker, ap)
  local tiles = combatPath:GetReachableMeleeRangePositions(target, true)
  if not tiles then
    DoneObject(combatPath)
    return
  end
  local minDistance = action:ResolveValue("minDistance") * const.SlabSizeX
  local maxDistance = action:ResolveValue("maxDistance") * const.SlabSizeX
  jump_dist = Max(minDistance, jump_dist or const.SlabSizeX)
  local atk_pos, atk_dot, atk_path, atk_jmp_pos, min_dist_error, not_straight_error
  local min_angle = action:ResolveValue("minAngle") * const.Scale.deg
  local ref_dot = MulDivRound(cos(min_angle), 1000, 4096)
  local tpos = GetPassSlab(target) or target:GetPos()
  local apos = attacker:GetPos()
  for _, tile in ipairs(tiles) do
    local path = combatPath:GetCombatPathFromPos(tile)
    local tooClose = minDistance > attacker:GetDist(point_unpack(tile))
    if path then
      local voxels = CalcPathVoxels(path)
      local jump_pos
      local pos = point(point_unpack(tile))
      for _, voxel in ipairs(voxels) do
        local pt = point(point_unpack(voxel))
        local dist = pos:Dist(pt)
        if maxDistance < dist then
          break
        end
        if minDistance < dist then
          jump_pos = pt
        end
      end
      if jump_pos then
        local move_dir = SetLen2D(jump_pos - apos, guim)
        local jump_dir = SetLen2D(pos - jump_pos, guim)
        local atk_dir = SetLen2D(tpos - pos, guim)
        local dot_jump_atk = Dot2D(-jump_dir, atk_dir) / guim
        local dot_move_jmp = Dot2D(-move_dir, jump_dir) / guim
        local dot = Dot2D(move_dir, atk_dir) / guim
        if ref_dot >= dot_jump_atk and ref_dot >= dot_move_jmp and (not atk_pos or atk_dot > dot) then
          local notStraight = ref_dot < dot_jump_atk or ref_dot < dot_move_jmp or #path ~= 2
          atk_pos, atk_dot, atk_path, atk_jmp_pos, min_dist_error, not_straight_error = pos, dot_jump_atk, path, jump_pos, tooClose, notStraight
        end
      end
    end
  end
  DoneObject(combatPath)
  return atk_pos, atk_jmp_pos, atk_path, min_dist_error, not_straight_error
end
local fx_target_action = "TargetMelee"
local melee_charge_targeting_special_args = {
  no_ap_indicator = true,
  show_unreachable_indicator = true,
  show_stance_arrows = false,
  melee_charge = true
}
function Targeting_MeleeCharge(dialog, blackboard, command, pt)
  local action = dialog.action
  local attacker = dialog.attacker
  if dialog:PlayerActionPending(attacker) then
    command = "delete"
  end
  if command == "setup" then
    local atk_positions = {}
    local valid_targets = action:GetTargets({attacker})
    for _, target in ipairs(valid_targets) do
      local atk_pos = GetChargeAttackPosition(attacker, target, action:ResolveValue("move_ap") * const.Scale.AP, action.id)
      atk_positions[target] = point_pack(atk_pos)
    end
    blackboard.charge_attack_positions = atk_positions
  end
  if command ~= "delete" and not blackboard.combat_path then
    dialog.args_gotopos = true
    local meleeCombatPath, hash = GetMeleeAttackCombatPath(action, attacker)
    blackboard.combat_path = meleeCombatPath
    blackboard.combat_path_hash = hash
    local borderline_attack, borderline_attack_voxels = GenerateAttackContour(action, attacker, meleeCombatPath, true)
    dialog.borderline_attack = borderline_attack
    dialog.borderline_attack_voxels = borderline_attack_voxels
    dialog.borderline_turns_voxels = borderline_attack_voxels
    blackboard.contour_for = {
      unit = attacker,
      pos = attacker:GetPos()
    }
    SelectionAddedApplyFX(Selection)
  end
  Targeting_Movement(dialog, blackboard, command, pt, melee_charge_targeting_special_args)
  if command == "delete" then
    if blackboard.combat_path then
      blackboard.combat_path:delete()
      blackboard.combat_path = false
    end
    dialog.args_gotopos = false
    if blackboard.fx_target then
      PlayFX(fx_target_action, "end", blackboard.fx_target)
      blackboard.fx_target = false
    end
    DeleteMeleeVisualization(blackboard)
    UpdateMovementAvatar(dialog, nil, nil, command)
    SetAPIndicator(false, "melee-attack")
    return
  end
  local pos = dialog.target_pos
  dialog:SetTarget(false, true)
  dialog.target_pos = false
  if pos and dialog.target_path then
    local ppos = point_pack(pos)
    for unit, atk_pos in pairs(blackboard.charge_attack_positions) do
      if point_pack(unit:GetPosXYZ()) == ppos then
        dialog:SetTarget(unit, true)
        dialog.target_pos = point(point_unpack(atk_pos))
        break
      end
    end
  end
  pos = dialog.target_pos
  MeleeTargetingUpdateMovementAvatar(dialog, blackboard)
  if pos and pos == blackboard.fx_pos then
    return
  end
  blackboard.fx_pos = pos
  if pos then
    local args = {
      target = dialog.target,
      step_pos = pos,
      goto_pos = pos
    }
    ApplyDamagePrediction(attacker, action, args)
    local apCost = action:GetAPCost(attacker, {goto_pos = pos})
    SetAPIndicator(apCost, "melee-attack")
  else
    if blackboard.fx_path then
      SetAPIndicator(APIndicatorNoTarget, "unreachable")
    end
    if blackboard.fx_target then
      PlayFX(fx_target_action, "end", blackboard.fx_target)
      blackboard.fx_target = false
    end
    ClearDamagePrediction()
    SetAPIndicator(false, "melee-attack")
  end
  if blackboard.fx_target ~= dialog.target then
    if blackboard.fx_target then
      PlayFX(fx_target_action, "end", blackboard.fx_target)
    end
    if dialog.target then
      blackboard.fx_target = dialog.target
      PlayFX(fx_target_action, "start", blackboard.fx_target)
    end
  end
end
