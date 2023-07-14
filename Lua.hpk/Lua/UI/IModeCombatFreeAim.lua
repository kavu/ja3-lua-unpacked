DefineClass.IModeCombatFreeAim = {
  __parents = {
    "IModeCombatAttackBase"
  },
  lock_camera = false,
  attack_pos = false,
  tile_free_attack = false,
  fx_free_attack = false,
  disable_mouse_indicator = true,
  mouse_world_pos = false
}
function IModeCombatFreeAim:Done()
  if self.fx_free_attack then
    SetInteractionHighlightRecursive(self.fx_free_attack, false, true)
    self.fx_free_attack = false
  end
  self.tile_free_attack = false
  ClearDamagePrediction()
  SetAPIndicator(false, "free-aim")
  UpdateAllBadges()
end
function IModeCombatFreeAim:UpdateTarget(...)
  if not SelectedObj or not SelectedObj:IsIdleCommand() then
    return
  end
  IModeCombatAttackBase.UpdateTarget(self, ...)
  local tile, fx_target = self:GetFreeAttackTarget(self.potential_target, self.attacker:GetPos())
  if self.fx_free_attack ~= fx_target then
    self.tile_free_attack = tile
    if self.fx_free_attack then
      SetInteractionHighlightRecursive(self.fx_free_attack, false, true)
      self.fx_free_attack = false
    end
    if fx_target then
      self.fx_free_attack = fx_target
      SetInteractionHighlightRecursive(fx_target, true, true)
    end
    local attacker = SelectedObj or Selection[1]
    local action = self.action
    if action.id and tile then
      NetSyncEvent("Aim", attacker, action.id, tile)
    end
  end
end
function IModeCombatFreeAim:SetTarget()
  return false
end
function IModeCombatFreeAim:UpdateLinesOfFire()
end
function IModeCombatFreeAim:ShowCoversShields(world_pos, cover)
  IModeCommonUnitControl.ShowCoversShields(self, world_pos, cover)
end
function IModeCombatFreeAim:OnMouseButtonDown(pt, button)
  if not IsValid(SelectedObj) or not SelectedObj:CanBeControlled() then
    return
  end
  local gamepadClick = false
  if not button and GetUIStyleGamepad() then
    gamepadClick = true
  end
  if button == "L" or gamepadClick then
    if IsValidThread(self.real_time_threads and self.real_time_threads.move_and_attack) then
      return
    end
    local target, target_obj = self:GetFreeAttackTarget(self.potential_target, self.attacker:GetPos())
    if GetUIStyleGamepad() and self.action.AimType == "cone" and self.target_as_pos then
      target = self.target_as_pos
    end
    if self.action.id == "MGBurstFire" then
      local overwatch = g_Overwatch[SelectedObj]
      if overwatch and overwatch.permanent then
        if SelectedObj:HasStatusEffect("ManningEmplacement") and IsCloser2D(SelectedObj, target, guim) then
          ReportAttackError(target or SelectedObj, AttackDisableReasons.OutOfRange)
          return
        end
        local angle = overwatch.orient or CalcOrientation(SelectedObj:GetPos(), overwatch.target_pos)
        if not CheckLOS(target, SelectedObj, overwatch.dist, SelectedObj.stance, overwatch.cone_angle, angle) then
          ReportAttackError(target or SelectedObj, AttackDisableReasons.OutOfRange)
          return
        end
      end
    elseif self.action.ActionType == "Melee Attack" then
      if IsValid(target_obj) then
        local step_pos = self.attacker:GetClosestMeleeRangePos(target_obj)
        if step_pos then
          local args = {
            target = target_obj,
            goto_pos = step_pos,
            free_aim = true
          }
          if CheckAndReportImpossibleAttack(self.attacker, self.action, args) == "enabled" then
            if self.action.IsTargetableAttack then
              self.action:UIBegin({
                self.attacker
              }, args)
            else
              self:StartMoveAndAttack(self.attacker, self.action, target_obj, step_pos, args)
            end
          end
          return "break"
        elseif g_Combat then
          ReportAttackError(GetCursorPos(), AttackDisableReasons.TooFar)
          return
        end
      else
        ReportAttackError(GetCursorPos(), AttackDisableReasons.NoTarget)
        return
      end
    end
    if self.attacker ~= target then
      FreeAttack(SelectedObj, target, self.action, self.context.free_aim, self.target_as_pos)
    else
      ReportAttackError(target or SelectedObj, AttackDisableReasons.InvalidSelfTarget)
    end
    return
  end
  return IModeCombatAttackBase.OnMouseButtonDown(self, pt, button)
end
function IModeCombatFreeAim:GetFreeAttackTarget(target, attackerPos)
  local spawnFXObject, objForFX
  if IsValid(target) then
    objForFX = target
    return target, objForFX
  else
    target = self:GetUnitUnderMouse()
    if not target then
      local solid, transparent = GetPreciseCursorObj()
      local obj = transparent or solid
      obj = not IsKindOf(obj, "Slab") and SelectionPropagate(obj) or obj
      if obj and not obj:IsInvulnerable() and (not (not IsKindOf(obj, "CombatObject") or obj.is_destroyed) or ShouldDestroyObject(obj)) then
        target = obj
      end
    end
    if IsKindOf(target, "MachineGunEmplacement") then
      target = false
    end
    if IsKindOf(target, "DynamicSpawnLandmine") then
      spawnFXObject = target
      target = target:GetAttach(1)
    end
    if target then
      objForFX = target
      local hitSpotIdx = target:GetSpotBeginIndex("Hit")
      if hitSpotIdx ~= -1 then
        hitSpotIdx = target:GetNearestSpot("Hit", attackerPos)
      end
      if 0 < hitSpotIdx then
        target = target:GetSpotPos(hitSpotIdx)
      else
        local bbox = GetEntityBBox(target:GetEntity())
        target = target:GetVisualPos() + bbox:Center()
      end
    else
      target = GetCursorPos()
    end
  end
  local parentObj = spawnFXObject or target
  if parentObj and not parentObj:IsValidZ() then
    parentObj = parentObj:SetTerrainZ()
  end
  return spawnFXObject or target, objForFX
end
function FreeAttack(unit, target, action, isFreeAim, target_as_pos)
  if not target then
    return
  end
  unit = unit or SelectedObj
  if not IsValid(unit) or unit:IsDead() then
    return
  end
  if not CanYield() then
    return CreateRealTimeThread(FreeAttack, unit, target, action, isFreeAim, target_as_pos)
  end
  if IsKindOf(target, "Unit") then
    local args = {target = target, free_aim = isFreeAim}
    local state, reason = action:GetUIState({unit}, args)
    if state == "enabled" or state == "disabled" and reason == AttackDisableReasons.InvalidTarget then
      action:UIBegin({unit}, args)
    else
      CheckAndReportImpossibleAttack(unit, action, args)
    end
    return
  end
  SelectObj(unit)
  local cursor_pos = terminal.GetMousePos()
  if GetUIStyleGamepad() then
    local front
    front, cursor_pos = GameToScreen(GetCursorPos())
  end
  RequestPixelWorldPos(cursor_pos)
  WaitNextFrame(6)
  local preciseAttackPt = ReturnPixelWorldPos()
  if action.AimType == "cone" and target_as_pos then
    preciseAttackPt = target_as_pos
  end
  local camera_pos = camera.GetEye()
  local segment_end_pos = camera_pos + SetLen(preciseAttackPt - camera_pos, camera_pos:Dist(preciseAttackPt) + guim)
  local rayObj, pt, normal = GetClosestRayObj(camera_pos, segment_end_pos, const.efVisible, 0, function(o)
    if o:GetOpacity() == 0 then
      return false
    end
    return true
  end, 0, const.cmDefaultObject)
  local args = {
    target = pt or target
  }
  if action.group == "FiringModeMetaAction" then
    action = GetUnitDefaultFiringModeActionFromMetaAction(unit, action)
  end
  local state, reason = action:GetUIState({unit}, args)
  if state == "enabled" or state == "disabled" and reason == AttackDisableReasons.InvalidTarget then
    action:Execute({unit}, args)
  else
    CheckAndReportImpossibleAttack(unit, action, args)
  end
end
