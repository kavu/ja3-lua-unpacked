DefineClass.ModifyWeaponDlg = {
  __parents = {
    "XContextWindow"
  },
  mouseDown = false,
  mouseUpWait = false,
  lastTickMouseDown = false,
  mouseDownRotationAxis = false,
  mouseDownRotationAngle = false,
  leftBinding = false,
  rightBinding = false,
  nodeParent = false,
  playerUnits = false,
  sector = false,
  weaponModel = false,
  weaponClone = false,
  weaponConditionOnOpen = false,
  canEdit = true,
  active_weapon_spot = false,
  spotToUI = false,
  selectedWeapon = false,
  selectedWeaponItemId = false,
  maxZoom = 200,
  minZoom = 100,
  currentZoom = 100,
  weaponSlideInThread = false,
  render_mode_open = false
}
local angleRotatePerTick = 20
local uiRefreshFreq = 200
function ModifyWeaponDlg:Open(...)
  CancelDrag()
  if GetRenderMode() == "ui" then
    self.render_mode_open = "ui"
    SetRenderMode("scene")
  end
  PlayFX("ModifyWeaponUI", "start", false, false, g_Cabinet:GetPos())
  Msg("ModifyWeaponDialogOpened")
  g_Cabinet:SetGameFlags(const.gofRealTimeAnim)
  local partsDisplay = self.idResourceIndicator
  local owner = self.context.owner
  local looted = false
  if not IsKindOfClasses(owner, "Unit", "UnitData") or owner:IsDead() or owner.Squad and gv_Squads[owner.Squad] and gv_Squads[owner.Squad].Side ~= "player1" then
    looted = true
    owner = Selection[1]
  end
  local ownerSquad = false
  if looted then
    if gv_SatelliteView then
      ownerSquad = g_SatelliteUI.selected_squad
    else
      ownerSquad = gv_Squads[g_CurrentSquad]
    end
    if not ownerSquad then
      local inventoryUnit = GetInventoryUnit()
      if inventoryUnit and inventoryUnit.Squad then
        ownerSquad = gv_Squads[inventoryUnit.Squad]
      end
    end
  else
    ownerSquad = gv_Squads[owner.Squad]
  end
  self.sector = ownerSquad and ownerSquad.CurrentSector or gv_CurrentSectorId or "A1"
  partsDisplay:SetContext(self.sector)
  XContextWindow.Open(self, ...)
  local leftBinding = GetShortcuts("actionRotLeft")
  local rightBinding = GetShortcuts("actionRotRight")
  self.leftBinding = leftBinding and GetCameraVKCodeFromShortcut(leftBinding[1]) or false
  self.rightBinding = rightBinding and GetCameraVKCodeFromShortcut(rightBinding[1]) or false
  self:CreateThread("rotateThread", function()
    while self.window_state ~= "destroying" do
      self:LogicProc()
      WaitNextFrame()
    end
  end)
  self.nodeParent = self:ResolveId("node")
  local allWeapons, selectedWeapon = GetPlayerWeapons(ownerSquad, owner, self.context.slot)
  local playerUnits = GetPlayerMercsInSector(self.sector)
  for idx, id in ipairs(playerUnits) do
    playerUnits[idx] = gv_UnitData[id]
  end
  if looted then
    allWeapons[#allWeapons + 1] = {
      weapon = self.context.weapon,
      slot = self.context.slot
    }
    selectedWeapon = self.context.weapon
    self.canEdit = false
  end
  self.idLootedWeapon:SetVisible(looted)
  self.allWeapons = allWeapons
  self.playerUnits = playerUnits
  local selectedWeaponIdx = table.find(allWeapons, "weapon", selectedWeapon)
  if not selectedWeaponIdx then
    return
  end
  self:SetWeapon(selectedWeaponIdx)
end
function ModifyWeaponDlg:SetWeapon(index, direction)
  self:CloseContextMenu()
  direction = direction or 1
  local ctx = self.allWeapons[index]
  local weapon = ctx.weapon
  local fakeOriginObject = g_Cabinet
  self:SetContext(ctx)
  self.selectedWeapon = index
  self.selectedWeaponItemId = weapon.id
  local weaponClone = weapon:UIClone()
  self.weaponClone = weaponClone
  weaponClone:ApplyModifiersList(self.weaponClone.applied_modifiers)
  rawset(weaponClone, "cloned_weapon", true)
  self.weaponConditionOnOpen = weaponClone.Condition
  NetSyncEvent("WeaponModifyLookingAtWeapon", netUniqueId, weapon.id)
  self.idWeaponMeta:SetContext(self.weaponClone, true)
  self.idCondition:SetContext(self.weaponClone, true)
  self.idTextAboveButtons:SetContext(self.weaponClone, true)
  self.idWeaponParts:DeleteChildren()
  local weaponModel = weaponClone:CreateVisualObj(self)
  weaponClone:UpdateVisualObj(weaponModel)
  weaponModel:SetPos(fakeOriginObject:GetPos())
  weaponModel:SetForcedLOD(0)
  weaponModel:SetGameFlags(const.gofRealTimeAnim)
  weaponModel:SetGameFlags(const.gofAlwaysRenderable)
  weaponModel:ClearEnumFlags(const.efVisible)
  local lDetachWeaponFromRotation = function(wep)
    local px, py, pz = wep:GetVisualPosXYZ()
    local axis = wep:GetVisualAxis()
    local angle = wep:GetVisualAngle()
    wep:Detach()
    wep:SetPos(px, py, pz)
    wep:SetAxis(axis)
    wep:SetAngle(angle)
    return px, py, pz
  end
  local lAttachModelToFakeOrigin = function(wep)
    local attachSpot = wep:GetSpotBeginIndex("Center")
    local spotPosition = wep:GetSpotPos(attachSpot)
    if wep:GetComponentFlags(const.cofComponentAttach) ~= 0 then
      wep:SetAttachOffset(fakeOriginObject:GetPos() - spotPosition)
    end
    fakeOriginObject:Attach(wep)
  end
  if IsKindOf(weapon, "Pistol") then
    self.maxZoom = 650
    self.minZoom = 400
  elseif IsKindOf(weapon, "MachineGun") then
    self.maxZoom = 120
    self.minZoom = 120
  elseif IsKindOf(weapon, "Mortar") then
    weaponModel:SetScale(70)
    self.maxZoom = 120
    self.minZoom = 120
  else
    weaponModel:SetScale(120)
    self.maxZoom = 400
    self.minZoom = 120
  end
  self.currentZoom = self.minZoom
  local spotToUI = {}
  local visualSpots = {}
  for i, slot in ipairs(Presets.WeaponUpgradeSlot.Default) do
    local slotId = slot.id
    local idx = table.find(weapon.ComponentSlots, "SlotType", slotId)
    local enabled = idx and weapon.ComponentSlots[idx].Modifiable
    if enabled then
      local wnd = XTemplateSpawn("WeaponComponentWindow", self.idWeaponParts, SubContext(weapon, {
        slot = weapon.ComponentSlots[idx],
        slotPreset = slot,
        DisplayName = slot.DisplayName
      }))
      wnd:Open()
      spotToUI[slotId] = wnd
      local spotPos = GetWeaponSpotPosForModifyUI(weaponModel, slotId)
      local _, spotPosScreen = GameToScreen(spotPos)
      visualSpots[#visualSpots + 1] = {slotId = slotId, pos = spotPosScreen}
    end
  end
  if self.weaponModel then
    local swapTimePerDistance = 5
    local lGetTimeForPath = function(obj, dest)
      local dist = dest:Dist(obj:GetPos())
      return dest, DivRound(dist, swapTimePerDistance)
    end
    local offset = 1200 * direction
    lAttachModelToFakeOrigin(weaponModel)
    self.weaponSlideInThread = CreateRealTimeThread(function(oldObj, newObj)
      local px, py, pz = lDetachWeaponFromRotation(newObj)
      newObj:SetPos(point(px + offset, py, pz))
      newObj:SetEnumFlags(const.efVisible)
      newObj:SetPos(lGetTimeForPath(newObj, point(px, py, pz)))
      local px, py, pz = lDetachWeaponFromRotation(oldObj)
      local pipi = fakeOriginObject:GetPos()
      pipi:SetX(pipi:x() - offset)
      local pt, time = lGetTimeForPath(oldObj, point(pipi:x() - offset, py, pz))
      oldObj:SetPos(pt, time)
      Sleep(time)
      DoneObject(oldObj)
      if newObj ~= self.weaponModel then
        return
      end
      newObj:SetAngle(0)
      newObj:SetAxis(axis_z)
      newObj:SetPos(fakeOriginObject:GetPos())
      lAttachModelToFakeOrigin(newObj)
      UIL.Invalidate()
    end, self.weaponModel, weaponModel)
    self.weaponModel = false
  else
    lAttachModelToFakeOrigin(weaponModel)
    weaponModel:SetEnumFlags(const.efVisible)
  end
  self.weaponModel = weaponModel
  self:ApplyZoom()
  local setWeaponCompFunc = weaponClone.SetWeaponComponent
  function weaponClone:SetWeaponComponent(...)
    setWeaponCompFunc(self, ...)
    weaponClone:UpdateVisualObj(weaponModel)
  end
  table.sort(visualSpots, function(a, b)
    local aX = a.pos and a.pos:x() or 0
    local bX = b.pos and b.pos:x() or 0
    return aX > bX
  end)
  for slotId, wnd in pairs(spotToUI) do
    local idx = table.find(visualSpots, "slotId", slotId)
    wnd:SetZOrder(idx)
  end
  self.spotToUI = spotToUI
  self:UpdateWeaponProps()
  self.idWeaponChangeTrigger:SetContext(weapon, false)
end
function ModifyWeaponDlg:Done()
  if self.render_mode_open then
    SetRenderMode("ui")
  end
  ObjModified(SelectedObj)
  InventoryUIRespawn()
  PlayFX("ModifyWeaponUI", "end")
end
function ModifyWeaponDlg:GetChangesCost(slotFilter, placedComponentOverride)
  if not self.context.weapon then
    return {}, false, true, {}
  end
  local actualWeapon = self.context.weapon
  local weapon = self.weaponClone
  local components = weapon.components
  local costs = {}
  local anyChanged = false
  for slot, itemId in pairs(actualWeapon.components) do
    local placedComponent = placedComponentOverride or components[slot] or ""
    if placedComponent ~= itemId and (not slotFilter or slot == slotFilter) then
      local item
      if slot == "Color" then
        item = Presets.WeaponColor.Default[placedComponent]
      else
        item = WeaponComponents[placedComponent]
      end
      local partCost = item and item.Cost or 0
      if partCost ~= 0 then
        if costs.Parts then
          costs.Parts = costs.Parts + partCost
        else
          costs.Parts = partCost
        end
      end
      for i, cost in ipairs(item and item.AdditionalCosts) do
        if costs[cost.Type] then
          costs[cost.Type] = costs[cost.Type] + cost.Amount
        else
          costs[cost.Type] = cost.Amount
        end
      end
      anyChanged = true
    end
  end
  if CheatEnabled("FreeParts") then
    return costs, anyChanged, true, {}
  end
  local canAfford = true
  local canAffordPerCost = {}
  for typ, cost in pairs(costs) do
    local costPreset = SectorOperationResouces[typ]
    local has = costPreset.current(self.sector)
    if cost > has then
      canAfford = false
      canAffordPerCost[typ] = false
    else
      canAffordPerCost[typ] = true
    end
  end
  return costs, anyChanged, canAfford, canAffordPerCost
end
function ModifyWeaponDlg:PayCosts(costs)
  for typ, cost in sorted_pairs(costs) do
    local costPreset = SectorOperationResouces[typ]
    costPreset.pay(self.sector, cost)
  end
end
function GetComponentsBlockedByComponent(partId, weaponClass)
  local blockComponents = {}
  for i, preset in pairs(WeaponComponentBlockPairs) do
    if preset.Weapon == weaponClass then
      if preset.ComponentBlockOne == partId then
        blockComponents[preset.ComponentBlockTwo] = true
      elseif preset.ComponentBlockTwo == partId then
        blockComponents[preset.ComponentBlockOne] = true
      end
    end
  end
  return blockComponents
end
function GetComponentBlocksAnyOfAttachedSlots(weapon, partDef)
  if partDef and partDef.BlockSlots and next(partDef.BlockSlots) then
    for i, slot in ipairs(partDef.BlockSlots) do
      local attachedCompThere = weapon.components[slot]
      local defaultComponentData = table.find_value(weapon.ComponentSlots, "SlotType", slot)
      local defaultComponent = defaultComponentData and defaultComponentData.DefaultComponent or ""
      if attachedCompThere ~= "" and attachedCompThere ~= defaultComponent then
        return true, attachedCompThere
      end
    end
  end
end
function ResetFsr2()
  if hr.TemporalGetType() == "fsr2" then
    hr.TemporalReset()
  end
end
function RestoreCloneWeaponComponents(cloneWeapon, sourceWeapon)
  local cloneComponents = cloneWeapon.components
  for slot, component in pairs(sourceWeapon.components) do
    if cloneComponents[slot] ~= component then
      cloneWeapon:SetWeaponComponent(slot, component)
    end
  end
  ResetFsr2()
end
function ModifyWeaponDlg:CanModifySlot(slot, partId)
  local weapon = self.context.weapon
  local slotName = slot.SlotType
  local blocked = false
  for name, attached in pairs(weapon.components) do
    local def = WeaponComponents[attached]
    if def and def.BlockSlots and next(def.BlockSlots) and table.find(def.BlockSlots, slotName) then
      blocked = attached
      break
    end
  end
  if blocked then
    return false, "blocked", blocked
  end
  if slot and slot.AvailableComponents then
    local anyPossible, impossibleBecauseOf = false
    for i, component in ipairs(slot.AvailableComponents) do
      local def = WeaponComponents[component]
      local blocksAny, blockedId = GetComponentBlocksAnyOfAttachedSlots(weapon, def)
      impossibleBecauseOf = impossibleBecauseOf or blockedId
      if not blocksAny then
        anyPossible = true
        break
      end
    end
    if not anyPossible then
      return false, "blocked", impossibleBecauseOf
    end
  end
  if partId then
    local partDef = WeaponComponents[partId]
    local blocksAny, blockedId = GetComponentBlocksAnyOfAttachedSlots(weapon, partDef)
    if blocksAny then
      return false, "blocked", blockedId
    end
    for name, attached in pairs(weapon.components) do
      local componentsBlock = GetComponentsBlockedByComponent(attached, weapon.class)
      if componentsBlock[partId] then
        return false, "blocked", attached
      end
    end
    local componentsWillBlock = GetComponentsBlockedByComponent(partId, weapon.class)
    for name, attached in pairs(weapon.components) do
      if componentsWillBlock[attached] then
        return false, "blocked", attached
      end
    end
  end
  local anyOptions = false
  local anyAffordable = false
  local equipped = weapon.components[slotName]
  for i, comp in ipairs(slot.AvailableComponents) do
    if comp ~= equipped then
      anyOptions = true
      local costs, _, affordable = self:GetChangesCost(slotName, comp)
      if affordable then
        anyAffordable = true
        break
      end
    end
  end
  if anyOptions and not anyAffordable then
    return true, "cantAfford"
  end
  return true
end
function ModifyWeaponDlg:SlotHasChanges(slot)
  local placedComponent = self.weaponClone.components[slot] or ""
  local originalComponent = self.context.weapon.components[slot] or ""
  return placedComponent ~= originalComponent
end
function TFormat.ModificationDifficultyToText(context_obj, difficulty, mercSkill)
  if not difficulty or not mercSkill then
    return Untranslated("Error")
  end
  local skillDiff = mercSkill - difficulty
  if skillDiff < 50 then
    return T(998267627242, "<red>Impossible</red>")
  elseif skillDiff < 70 then
    return T(722888273329, "Hard")
  elseif skillDiff < 90 then
    return T(444596827186, "Moderate")
  elseif skillDiff < 120 then
    return T(700940162389, "Easy")
  else
    return T(368429330332, "Trivial")
  end
end
function ModifyWeaponDlg:GetModificationDifficultyParams(componentToChangePreset)
  local playerMechSkill, mostSkilled = false, false
  for i, u in ipairs(self.playerUnits) do
    local mechSkill = u.Mechanical
    if not playerMechSkill or playerMechSkill < mechSkill then
      playerMechSkill = mechSkill
      mostSkilled = u.session_id
    end
  end
  if not playerMechSkill then
    return
  end
  local difficulty = componentToChangePreset and componentToChangePreset.ModificationDifficulty or 0
  return playerMechSkill, mostSkilled, difficulty, 10 < playerMechSkill - difficulty
end
function RollSkillDifficulty(playerMechSkill, difficulty)
  local skillDiff = playerMechSkill - difficulty
  local rand = AsyncRand(100)
  local result = skillDiff - rand
  if CheatEnabled("SkillCheck") and result <= 0 then
    if result == 0 then
      result = 1
    else
      result = -result
    end
  end
  local outcome = ""
  if 80 < result then
    outcome = "crit-success"
  elseif 0 < result then
    outcome = "success"
  elseif result < -80 then
    outcome = "crit-fail"
  elseif result <= 0 then
    outcome = "fail"
  end
  return outcome, result
end
function ModifyWeaponDlg:ApplyChangesSlot(modSlot, skipChance)
  if not modSlot then
    return
  end
  local actualWeapon = self.context.weapon
  local owner = self.context.owner
  local slot = self.context.slot
  if not self.canEdit then
    return
  end
  local costs, anyChanges, canAfford = self:GetChangesCost(modSlot)
  if not anyChanges or not canAfford then
    return
  end
  local componentToChangeTo = self.weaponClone.components[modSlot]
  local componentToChangePreset = WeaponComponents[componentToChangeTo]
  local playerMechSkill, bestMechSkillUnit, difficulty, allowed = self:GetModificationDifficultyParams(componentToChangePreset)
  if not playerMechSkill or not allowed then
    return
  end
  if componentToChangeTo == "" then
    skipChance = true
  end
  CreateMapRealTimeThread(function()
    local success, unit, modAdded
    if not skipChance then
      local itemOwnerUnit = table.find_value(self.playerUnits, "session_id", owner)
      local outcome, result = RollSkillDifficulty(playerMechSkill, difficulty)
      if outcome == "fail" or outcome == "crit-fail" then
        local partCosts = costs.Parts
        if partCosts then
          self:PayCosts({Parts = partCosts})
        end
        local conditionLoss = MulDivRound(result, actualWeapon.Reliability, 100)
        if outcome == "crit-fail" then
          conditionLoss = -actualWeapon.Condition
        end
        if conditionLoss ~= 0 then
          if outcome == "fail" then
            CombatLog("important", T({
              455033345702,
              "Modification failed. <weapon> has lost Condition.",
              weapon = actualWeapon.DisplayName,
              val = conditionLoss
            }))
            CombatLog("debug", T({
              Untranslated("Modification failed - <weapon> lost <val> condition"),
              weapon = actualWeapon.DisplayName,
              val = conditionLoss
            }))
          elseif outcome == "crit-fail" then
            CombatLog("important", T({
              674809527450,
              "Modification failed. <weapon> has lost Condition.",
              weapon = actualWeapon.DisplayName,
              val = conditionLoss
            }))
            CombatLog("debug", T({
              Untranslated("Modification critical failure (<val> condition loss)"),
              val = conditionLoss
            }))
          end
        else
          CombatLog("important", T(238606985729, "Modification failed."))
        end
        PlayFX("WeaponModificationFail", "start")
        NetSyncEvent("WeaponModifyCondition", owner, slot, conditionLoss)
        return
      end
      PlayFX("WeaponModificationSuccess", "start")
      if outcome == "crit-success" then
        local precentOfPartsToRefund = 50
        local costsNotRefunded = {}
        local costsString = {}
        for costType, amount in sorted_pairs(costs) do
          if costType ~= "Parts" then
            costsNotRefunded[costType] = amount
          else
            local refundedAmount = MulDivRound(amount, precentOfPartsToRefund, 100)
            local nonRefundedAmount = amount - refundedAmount
            costsNotRefunded[costType] = nonRefundedAmount
            local costPreset = SectorOperationResouces[costType]
            local name = costPreset.name
            costsString[#costsString + 1] = Untranslated(refundedAmount) .. " " .. name
          end
        end
        if 0 < #costsString then
          costsString = table.concat(costsString, ", ")
          CombatLog("important", T({
            979284579828,
            "Modification of <weapon> successful - <costs> refunded",
            weapon = actualWeapon.DisplayName,
            costs = costsString
          }))
          CombatLog("debug", T({
            Untranslated("Modification critical success - refunded <costs>."),
            costs = costsString
          }))
        else
          CombatLog("important", T({
            753849538837,
            "Modification of <weapon> successful",
            weapon = actualWeapon.DisplayName
          }))
          CombatLog("debug", T(Untranslated("Modification critical success.")))
        end
        self:PayCosts(costsNotRefunded)
      else
        self:PayCosts(costs)
        CombatLog("important", T({
          753849538837,
          "Modification of <weapon> successful",
          weapon = actualWeapon.DisplayName
        }))
      end
      unit = table.find_value(self.playerUnits, "session_id", bestMechSkillUnit)
      success = true
      modAdded = true
    else
      CombatLog("important", T({
        753849538837,
        "Modification of <weapon> successful",
        weapon = actualWeapon.DisplayName
      }))
      success = true
    end
    local clone = self.weaponClone
    clone:SetWeaponComponent(modSlot, componentToChangeTo)
    clone:UpdateVisualObj(self.weaponModel)
    local oldComponent = actualWeapon.components[modSlot]
    NetSyncEvent("WeaponModified", owner, slot, clone.components, clone.components.Color, success, modAdded, bestMechSkillUnit)
    CreateMapRealTimeThread(function()
      if oldComponent and oldComponent ~= "" then
        PlayFX("WeaponComponentDetached", "start", oldComponent)
        Sleep(1000)
      end
      if componentToChangeTo and componentToChangeTo ~= "" then
        PlayFX("WeaponComponentAttached", "start", componentToChangeTo)
      end
    end)
    if success then
      local mechanic = gv_SatelliteView and gv_UnitData[bestMechSkillUnit] or g_Units[bestMechSkillUnit]
      Msg("WeaponModifiedSuccess", actualWeapon, unit, modAdded, mechanic)
    end
  end)
end
function ModifyWeaponDlg:GetMousePos()
  local pos = terminal.GetMousePos()
  return point(MulDivRound(pos:x(), 1000, self.scale:x()), MulDivRound(pos:y(), 1000, self.scale:y()))
end
function ModifyWeaponDlg:OnMouseWheelForward()
  local currentZoom = self.currentZoom
  currentZoom = currentZoom + 25
  self.currentZoom = Clamp(currentZoom, self.minZoom, self.maxZoom)
  self:ApplyZoom()
end
function ModifyWeaponDlg:OnMouseWheelBack()
  local currentZoom = self.currentZoom
  currentZoom = currentZoom - 25
  self.currentZoom = Clamp(currentZoom, self.minZoom, self.maxZoom)
  self:ApplyZoom()
end
function ModifyWeaponDlg:ApplyZoom()
  cameraTac.SetZoom(1000 - self.currentZoom, 50)
end
function ModifyWeaponDlg:LogicProc()
  if terminal.desktop.inactive or not IsValid(g_Cabinet) then
    return
  end
  local axis, angle = g_Cabinet:GetAxis(), g_Cabinet:GetAngle()
  if self.nodeParent == terminal.desktop:GetKeyboardFocus() then
    if self.leftBinding and terminal.IsKeyPressed(self.leftBinding) then
      axis, angle = ComposeRotation(axis, angle, axis_z, angleRotatePerTick * 60)
      g_Cabinet:SetAxisAngle(axis, angle, 100)
    elseif self.rightBinding and terminal.IsKeyPressed(self.rightBinding) then
      axis, angle = ComposeRotation(axis, angle, axis_z, -angleRotatePerTick * 60)
      g_Cabinet:SetAxisAngle(axis, angle, 100)
    end
  end
  local curLeftDown = terminal.IsLRMMouseButtonPressed()
  if curLeftDown and not self.mouseDown then
    self.mouseDown = self:GetMousePos()
    self.mouseDownRotationAxis = axis
    self.mouseDownRotationAngle = angle
    if self.weaponModel and self.weaponModel.weapon then
      PlayFX("WeaponModificationRotate", "start", self.weaponModel.weapon.object_class, self.weaponModel.fx_actor_class)
    end
  elseif not curLeftDown and self.mouseDown then
    self.mouseDown = false
    self.mouseUpWait = false
  end
  if self.mouseDown and not self.mouseUpWait then
    local mouseTarget = self:GetMouseTarget(terminal.GetMousePos())
    if mouseTarget ~= self then
      return
    end
    if self.mouseDown and self:CloseContextMenu() then
      return
    end
    local currentPos = self:GetMousePos()
    if self.lastTickMouseDown and (currentPos - self.lastTickMouseDown):Len() > 1 then
      local diff = currentPos - self.mouseDown
      axis, angle = ComposeRotation(self.mouseDownRotationAxis, self.mouseDownRotationAngle, axis_z, -diff:x() * 10)
      axis, angle = ComposeRotation(axis, angle, axis_x, diff:y() * 10)
      g_Cabinet:SetAxisAngle(axis, angle, 100)
    end
    self.lastTickMouseDown = currentPos
  end
  local gamepadState = GetUIStyleGamepad() and GetActiveGamepadState()
  if gamepadState then
    local rtS = gamepadState.RightThumb
    local nRtS = rtS == point20 and point20 or Normalize(rtS)
    local gamepadId = table.find(XInput.CurrentState, gamepadState)
    local ltHeld = XInput.IsCtrlButtonPressed(gamepadId, "LeftTrigger")
    if ltHeld then
      nRtS = MulDivRound(nRtS, 25, 4096)
      local currentZoom = self.currentZoom
      currentZoom = currentZoom + nRtS:y()
      self.currentZoom = Clamp(currentZoom, self.minZoom, self.maxZoom)
      self:ApplyZoom()
      return
    end
    nRtS = MulDivRound(nRtS, 25, 4096)
    local axis, angle = g_Cabinet:GetAxis(), g_Cabinet:GetAngle()
    axis, angle = ComposeRotation(axis, angle, axis_z, -nRtS:x() * 10)
    axis, angle = ComposeRotation(axis, angle, axis_x, -nRtS:y() * 10)
    g_Cabinet:SetAxisAngle(axis, angle, 100)
  end
end
function ModifyWeaponDlg:UpdateWeaponProps()
  local container = self.idWeaponProps[1]
  if not container then
    return
  end
  local anyModified = false
  for i = 1, #container do
    local element = container[i]
    if element.HasValueChanged then
      anyModified = element:HasValueChanged()
      if anyModified then
        break
      end
    end
  end
  for i = 1, #container do
    local element = container[i]
    if element.UpdateValue then
      element:UpdateValue(anyModified and "modified")
    end
  end
  local realWeapon = self.context.weapon
  self.weaponClone.Condition = realWeapon.Condition
  ObjModified(self.sector)
  ObjModified(self.weaponClone)
  self.idCondition.idBar:UpdateValue()
  self.idToolBar:OnUpdateActions()
  ResetFsr2()
end
function ModifyWeaponDlg:SetActiveSpot(spot, reason)
  if not self.active_weapon_spot then
    self.active_weapon_spot = {}
  end
  self.active_weapon_spot[reason] = spot
  if reason == "selected" then
    if spot then
      for i, p in ipairs(self.idWeaponParts) do
        p:ApplyStyle(p.context.slotPreset.id == spot and "normal" or "deselected")
      end
    else
      for i, p in ipairs(self.idWeaponParts) do
        p:ApplyStyle("normal")
      end
    end
  end
end
function ModifyWeaponDlg:DrawBackground()
  local drawToSpot = false
  if self.active_weapon_spot then
    if self.active_weapon_spot.selected then
      drawToSpot = self.active_weapon_spot.selected
    else
      drawToSpot = self.active_weapon_spot.rollover
    end
  end
  local weaponModel = self.weaponModel
  local ui = self.spotToUI and self.spotToUI[drawToSpot]
  if weaponModel and drawToSpot and ui and not IsValidThread(self.weaponSlideInThread) then
    local spotPos = GetWeaponSpotPosForModifyUI(weaponModel, drawToSpot)
    local _, spotPosScreen = GameToScreen(spotPos)
    UIL.DrawLineAntialised(5, ui.box:min(), spotPosScreen, self.idCircle.ImageColor)
    local sizeX, sizeY = ScaleXY(self.scale, 20, 20)
    self.idCircle:SetBox(spotPosScreen:x() - sizeX / 2, spotPosScreen:y() - sizeY / 2, sizeX, sizeY)
  else
    self.idCircle:SetBox(0, 0, 0, 0)
  end
end
function GetWeaponSpotPosForModifyUI(weaponModel, drawToSpot)
  local spotIdx = -1
  local dependency = drawToSpot == "Side" and "Side1" or SlotDependencies[drawToSpot]
  if not dependency then
    local values = table.values(SlotDependencies)
    local keys = table.keys(SlotDependencies)
    for i, v in ipairs(values) do
      if v == drawToSpot then
        local key = keys[i]
        if weaponModel:GetSpotBeginIndex(key) ~= -1 then
          dependency = key
        end
      end
    end
  end
  if not dependency then
    local slotPreset = weaponModel.weapon and weaponModel.weapon.ComponentSlots
    slotPreset = slotPreset and table.find_value(slotPreset, "SlotType", drawToSpot)
    if slotPreset and slotPreset.AvailableComponents then
      local allOnSingleSpot = true
      local singleSpot = false
      for i, availComp in ipairs(slotPreset.AvailableComponents) do
        local component = WeaponComponents[availComp]
        local componentVisuals = component and component.Visuals
        for _, visual in ipairs(componentVisuals) do
          if visual.Entity and visual.Slot then
            if not singleSpot then
              singleSpot = visual.Slot
            elseif visual.Slot ~= singleSpot then
              allOnSingleSpot = false
              break
            end
          end
        end
        if not allOnSingleSpot then
          break
        end
      end
      if allOnSingleSpot then
        dependency = singleSpot
      end
    end
  end
  if dependency then
    if weaponModel.parts[dependency] then
      local partVisual = weaponModel.parts[dependency]
      local dependencySpot = partVisual:GetSpotBeginIndex(drawToSpot)
      if dependencySpot ~= -1 then
        weaponModel = partVisual
        spotIdx = dependencySpot
      end
    end
    if spotIdx == -1 then
      spotIdx = weaponModel:GetSpotBeginIndex(dependency)
    end
    if spotIdx == -1 then
      spotIdx = weaponModel:GetSpotBeginIndex(drawToSpot)
    end
  else
    spotIdx = weaponModel:GetSpotBeginIndex(drawToSpot)
  end
  return weaponModel:GetSpotPos(spotIdx)
end
local lExtraStatExceptions = {
  "Damage",
  "WeaponRange",
  "AimAccuracy",
  "CritChance",
  "BaseAP",
  "ShootAP"
}
function ModifyWeaponDlg:GetWeaponComponentsCombinedEffects(components)
  if not self.weaponClone then
    return
  end
  local collectedData = {}
  components = components or self.weaponClone.components
  for slot, comp in pairs(components) do
    if #(comp or "") ~= 0 and WeaponComponents[comp] then
      local compPreset = WeaponComponents[comp]
      local data = GetWeaponComponentDescriptionData(compPreset)
      for key, mod in pairs(data) do
        if not table.find(lExtraStatExceptions, key) then
          local value = mod.value
          if collectedData[key] and value then
            collectedData[key].value = collectedData[key].value + value
          else
            collectedData[key] = mod
          end
        end
      end
    end
  end
  local lines = {}
  for i, mod in sorted_pairs(collectedData) do
    lines[#lines + 1] = Untranslated("<bullet_point> " .. _InternalTranslate(mod.display, mod))
  end
  return table.concat(lines, "\n"), collectedData
end
DefineClass.FakeOriginObject = {
  __parents = {
    "Object",
    "ComponentInterpolation"
  },
  entity = "InvisibleObject",
  flags = {gofAlwaysRenderable = true}
}
DefineClass.WeaponComponentWindowClass = {
  __parents = {
    "XContextWindow"
  }
}
function WeaponComponentWindowClass:OnSetRollover(rollover)
  local modifyWeaponDlg = self:ResolveId("node")
  modifyWeaponDlg:SetActiveSpot(rollover and self.context.slotPreset.id, "rollover")
end
function ModifyWeaponDlg:CloseContextMenu()
  if self.idChoicePopup then
    self.idChoicePopup:Close()
    self.idChoicePopup = false
    return true
  end
  return false
end
function WeaponComponentWindowClass:ToggleOptions()
  local modifyWeaponDlg = self:ResolveId("node")
  modifyWeaponDlg:CloseContextMenu()
  local slotType = self.context.slot.SlotType
  local ctxMenu = XTemplateSpawn("WeaponModChoicePopup", modifyWeaponDlg, self.context)
  ctxMenu:SetZOrder(999)
  ctxMenu:SetAnchor(self.box)
  ctxMenu:Open()
  function ctxMenu.OnDelete()
    if not modifyWeaponDlg.context then
      return
    end
    modifyWeaponDlg:SetActiveSpot(false, "selected")
    RestoreCloneWeaponComponents(modifyWeaponDlg.weaponClone, modifyWeaponDlg.context.weapon)
    modifyWeaponDlg.idTextAboveButtons:SetVisible(true)
  end
  modifyWeaponDlg:SetActiveSpot(slotType, "selected")
  ctxMenu:SetFocus()
  modifyWeaponDlg.idTextAboveButtons:SetVisible(false)
  modifyWeaponDlg.idChoicePopup = ctxMenu
  XDestroyRolloverWindow()
end
function WeaponComponentWindowClass:OnContextUpdate(context)
  local modifyDlg = self:ResolveId("node")
  local canModify, err = modifyDlg:CanModifySlot(self.context.slot)
  local uiParent = self.idCurrent
  if err == "blocked" then
    uiParent.idStateIcon:SetImage("UI/Icons/mod_blocked")
    uiParent.idOverlay:SetVisible(true)
    uiParent.idIcon:SetDesaturation(255)
    uiParent.idImage:SetDesaturation(255)
    uiParent:SetTransparency(25)
  elseif err == "cantAfford" then
    uiParent.idStateIcon:SetImage("UI/Icons/mod_parts_lack")
    uiParent.idStateIcon:SetImageColor(GameColors.I)
    uiParent.idOverlay:SetVisible(true)
    uiParent.idIcon:SetDesaturation(255)
    uiParent.idImage:SetDesaturation(255)
    uiParent:SetTransparency(25)
  else
    uiParent.idStateIcon:SetImage("")
    uiParent.idOverlay:SetVisible(false)
    uiParent.idIcon:SetDesaturation(0)
    uiParent.idImage:SetDesaturation(0)
    uiParent:SetTransparency(0)
  end
end
function OnMsg.ChangeMap()
  CloseDialog("ModifyWeaponDlg")
end
DefineClass.WeaponComponentCost = {
  __parents = {
    "PropertyObject"
  },
  properties = {
    {
      id = "Amount",
      editor = "number",
      default = 0
    },
    {
      id = "Type",
      editor = "choice",
      items = function()
        return table.imap(SectorOperationResouces, "id")
      end,
      default = false
    }
  }
}
function WeaponComponentCost:GetEditorView()
  return Untranslated((self.Type or "") .. " " .. (self.Amount or ""))
end
DefineClass.WeaponComponentModificationStat = {
  __parents = {
    "PropertyObject"
  },
  properties = {
    {
      id = "Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "NumericalAmount",
      name = "Numerical Amount (Unused)",
      editor = "number",
      default = false
    }
  }
}
function WeaponComponentModificationStat:GetEditorView()
  return Untranslated(Untranslated(self.Name or "") .. " " .. Untranslated(self.NumericalAmount or ""))
end
function GetWeaponComponentDescriptionData(componentPreset)
  local data = {}
  for i, effectName in ipairs(componentPreset.ModificationEffects) do
    local effect = WeaponComponentEffects[effectName]
    if effect and effect.Description then
      local text = _InternalTranslate(effect.Description, componentPreset)
      text = _InternalTranslate(Untranslated(text), effect)
      data[effectName] = {
        display = Untranslated(text)
      }
    end
  end
  return data
end
function GetWeaponComponentDescription(componentPreset)
  local data = GetWeaponComponentDescriptionData(componentPreset)
  local lines = {}
  if componentPreset.Description then
    lines[#lines + 1] = T({
      componentPreset.Description,
      componentPreset
    })
  end
  local indices = {}
  for modName, mod in sorted_pairs(data) do
    local text = Untranslated("<bullet_point> " .. _InternalTranslate(mod.display, mod))
    lines[#lines + 1] = text
    local effect = WeaponComponentEffects[modName]
    if effect then
      indices[text] = effect.SortKey
    end
  end
  if #lines == 0 then
    return T(575725466022, "No changes")
  end
  table.sort(lines, function(a, b)
    local indexA = indices[a] or 0
    local indexB = indices[b] or 0
    return indexA < indexB
  end)
  return table.concat(lines, "\n"), data
end
function GetWeaponModifyProperties(item)
  local statList = {}
  local dmgPreset = Presets.WeaponPropertyDef.Default.Damage
  statList[#statList + 1] = {
    max = dmgPreset.max_progress,
    bind_to = dmgPreset.bind_to
  }
  local baseAttack = item:GetBaseAttack(false, "force")
  local baseAction = CombatActions[baseAttack]
  local baseAttackPreset = Presets.WeaponPropertyDef.Default.ShootAP
  statList[#statList + 1] = {
    GetShootAP = function(it)
      return baseAttackPreset:GetProp(it or item) / const.Scale.AP
    end,
    Getbase_ShootAP = function(it)
      return baseAttackPreset:Getbase_Prop(it or item) / const.Scale.AP
    end,
    max = 10,
    display_name = T({
      310685041358,
      "Attack Cost (<Name>)",
      Name = baseAction.DisplayNameShort or baseAction.DisplayName
    }),
    id = "ShootAP",
    reverse_bar = true,
    description = baseAttackPreset.description
  }
  local rangePreset = Presets.WeaponPropertyDef.Default.WeaponRange
  statList[#statList + 1] = {
    max = rangePreset.max_progress,
    bind_to = rangePreset.bind_to
  }
  local critPreset = item.owner and Presets.WeaponPropertyDef.Default.CritChance or Presets.WeaponPropertyDef.Default.MaxCritChance
  local weaponModDlg = GetDialog("ModifyWeaponDlg").idModifyDialog
  local crit = 0
  local unit_id = weaponModDlg.context.owner
  statList[#statList + 1] = {
    GetCritChance = function(it)
      return critPreset:GetProp(it or item, unit_id)
    end,
    Getbase_CritChance = function(it)
      return critPreset:Getbase_Prop(it or item, unit_id)
    end,
    max = critPreset.max_progress,
    display_name = critPreset.display_name,
    id = "CritChance",
    description = critPreset.description
  }
  local aimAcc = Presets.WeaponPropertyDef.Default.AimAccuracy
  statList[#statList + 1] = {
    max = aimAcc.max_progress,
    bind_to = aimAcc.bind_to
  }
  return statList
end
function DisplayWeaponPropertyInWeaponMod(property, weapon)
  if not weapon:IsWeapon() or not property:DisplayForContext(weapon) then
    return
  end
  return not not table.find(properties_to_show, property.id)
end
DefineClass.WeaponModProgressLineClass = {
  __parents = {"XWindow"},
  IdNode = true,
  MinWidth = 400,
  MinHeight = 25,
  MaxHeight = 25,
  Transparency = 0,
  HandleMouse = true,
  dataBinding = false,
  dataSource = false,
  metaSource = false,
  metaPropSource = false,
  baseValueOverride = false
}
function WeaponModProgressLineClass:Setup(propItem, weapon)
  local dataBinding = propItem.bind_to
  local dataSource = weapon
  local metaSource = false
  local metaPropSource = false
  if not dataBinding then
    dataBinding = propItem.id
    dataSource = propItem
    metaSource = propItem
    metaPropSource = propItem
  else
    metaSource = Presets.WeaponPropertyDef.Default[dataBinding]
    metaPropSource = weapon:GetPropertyMetadata(dataBinding)
  end
  if metaSource then
    self.idText:SetText(metaSource.display_name)
    self:SetRolloverTitle(metaSource.display_name)
    self:SetRolloverText(metaSource.description)
  end
  self:SetReverseBar(propItem.reverse_bar)
  self:SetMaxProgress(propItem.max)
  self.dataBinding = dataBinding
  self.dataSource = dataSource
  self.metaSource = metaSource
  self.metaPropSource = metaPropSource
  self.baseValueOverride = propItem.baseValueOverride
  self:UpdateValue()
end
function GetValueFromBinding(source, binding, dataSourceOverride)
  if source["Get" .. binding] then
    return source["Get" .. binding](dataSourceOverride)
  else
    return (dataSourceOverride or source)[binding]
  end
end
function WeaponModProgressLineClass:HasValueChanged()
  local weaponModDlg = self:ResolveId("node"):ResolveId("node")
  local binding = self.dataBinding
  local source = self.dataSource
  local value = GetValueFromBinding(source, binding)
  local actualWeapon = weaponModDlg.context.weapon
  local valActual = GetValueFromBinding(source, binding, actualWeapon) or value
  return value ~= valActual
end
function WeaponModProgressLineClass:UpdateValue(anyModified)
  local weaponModDlg = self:ResolveId("node"):ResolveId("node")
  local binding = self.dataBinding
  local source = self.dataSource
  local prop_meta = self.metaPropSource
  local value = GetValueFromBinding(source, binding)
  local val_base = value
  if self.baseValueOverride then
    val_base = self.baseValueOverride
  elseif prop_meta.modifiable and source["base_" .. prop_meta.id] then
    val_base = source["base_" .. prop_meta.id]
  else
    local baseTemplate = weaponModDlg.weaponClone and g_Classes[weaponModDlg.weaponClone.class]
    val_base = GetValueFromBinding(source, binding, baseTemplate) or value
  end
  if self:HasValueChanged() or not anyModified then
    self:SetTransparency(0)
  else
    self:SetTransparency(155)
  end
  local obj = source
  if IsKindOf(obj, "HeavyWeapon") and prop_meta.id == "Damage" then
    value = obj:GetBaseDamage()
    val_base = obj:GetBaseDamage()
  end
  local scale = prop_meta.scale
  if type(scale) == "string" then
    scale = const.Scale[scale]
  end
  scale = scale or 1
  local ctrl = self
  local reverse = ctrl:GetReverseBar()
  local text = ctrl:CreatePropValText(value, scale)
  if ctrl:GetPercentValue() then
    text = text .. "%"
  end
  self:ResolveId("idPropVal"):SetText(text)
  local max = self:GetMaxProgress()
  value = Clamp(value or 0, 0, max)
  val_base = Clamp(val_base or 0, 0, max)
  local progress = self:ResolveId("idProgressbar")
  local progress_base = self:ResolveId("idProgressbarBase")
  local differenceText = self:ResolveId("idDifference")
  progress_base:SetVisible(value ~= val_base)
  if value == val_base then
    progress:SetProgress(value)
    progress_base:SetProgress(value)
    progress_base:SetProgressImage("UI/Inventory/weapon_meter.tga")
    progress:SetProgressImage("UI/Inventory/weapon_meter.tga")
    differenceText:SetText("")
  elseif value < val_base then
    progress:SetProgress(val_base)
    progress_base:SetProgress(value)
    progress:SetProgressImage(reverse and "UI/Inventory/weapon_meter_green.tga" or "UI/Inventory/weapon_meter_red.tga")
    progress_base:SetProgressImage("UI/Inventory/weapon_meter.tga")
    differenceText:SetTextStyle(reverse and "WeaponModStatChangeGood" or "WeaponModStatChangeBad")
    differenceText:SetText(T({
      773757152128,
      "<numberWithSign(val)>",
      val = value - val_base
    }))
  elseif value > val_base then
    progress:SetProgress(value)
    progress_base:SetProgress(val_base)
    progress:SetProgressImage(reverse and "UI/Inventory/weapon_meter_red.tga" or "UI/Inventory/weapon_meter_green.tga")
    progress_base:SetProgressImage("UI/Inventory/weapon_meter.tga")
    differenceText:SetTextStyle(reverse and "WeaponModStatChangeBad" or "WeaponModStatChangeGood")
    differenceText:SetText(T({
      773757152128,
      "<numberWithSign(val)>",
      val = value - val_base
    }))
  end
  self:Invalidate()
  return value
end
function TFormat.AdditionalWeaponDescription(ctx)
  local abilities = {}
  if ctx.HandSlot == "OneHanded" then
    abilities[#abilities + 1] = T(889647869376, "One-Handed")
  elseif ctx.HandSlot == "TwoHanded" then
    abilities[#abilities + 1] = T(199744246598, "Two-Handed")
  end
  if IsKindOf(ctx, "HeavyWeapon") then
    local combatAction = ctx:GetBaseAttack()
    abilities[#abilities + 1] = CombatActions[combatAction].DisplayName
    return table.concat(abilities, ", ")
  end
  for i, ab in ipairs(ctx.AvailableAttacks) do
    abilities[#abilities + 1] = CombatActions[ab].DisplayName
  end
  abilities = table.concat(abilities, ", ")
  return abilities .. "<newline>" .. ctx.AdditionalHint
end
DefineClass.WeaponModToolbarButtonClass = {
  __parents = {
    "XTextButton"
  },
  shortcut = false,
  FXMouseIn = "buttonRollover",
  FXPress = "buttonPress",
  Padding = box(8, 0, 8, 0),
  MinHeight = 26,
  MaxHeight = 26,
  MinWidth = 124,
  SqueezeX = true
}
function WeaponModToolbarButtonClass:Open()
  local container = XTemplateSpawn("XWindow", self)
  container:SetLayoutMethod("HList")
  container:SetHAlign("center")
  container:SetVAlign("center")
  self.idLabel:SetParent(container)
  if rawget(self, "action") then
    self.shortcut = XTemplateSpawn("PDACommonButtonActionShortcut", container, self.action)
  end
  XTextButton.Open(self)
end
function WeaponModToolbarButtonClass:SetEnabled(enabled)
  XTextButton.SetEnabled(self, enabled)
  self.idLabel:SetEnabled(enabled)
  if self.shortcut then
    self.shortcut:SetEnabled(enabled)
  end
end
DefineClass.WeaponModPrefabCameraPos = {
  __parents = {"CObject"},
  flags = {efApplyToGrids = false, efCollision = false},
  entity = "City_CinemaProjector"
}
DefineClass.WeaponModCMTPlane = {
  __parents = {"CObject"},
  flags = {efApplyToGrids = false, efCollision = false},
  entity = "CMTPlane"
}
DefineClass.WeaponModChoicePopupClass = {
  __parents = {
    "XPopup",
    "XActionsHost"
  }
}
function GetPlayerWeapons(ownerSquad, selectedOwner, selectedSlot)
  local allWeapons = {}
  local selectedWeapon = false
  for i, teamMate in ipairs((ownerSquad or empty_table).units) do
    local unitData = false
    if IsKindOf(selectedOwner, "Unit") then
      unitData = g_Units[teamMate]
    elseif IsKindOf(selectedOwner, "UnitData") then
      unitData = gv_UnitData[teamMate]
    elseif not selectedOwner then
      unitData = gv_SatelliteView and gv_UnitData[teamMate] or g_Units[teamMate]
    end
    if unitData and unitData:IsLocalPlayerControlled() then
      unitData:ForEachItem("Firearm", function(item, slot)
        allWeapons[#allWeapons + 1] = {
          weapon = item,
          slot = unitData:GetItemPackedPos(item),
          slotName = slot,
          owner = teamMate
        }
      end)
      if selectedOwner and teamMate == selectedOwner.session_id then
        selectedWeapon = unitData:GetItemAtPackedPos(selectedSlot)
      end
    end
  end
  return allWeapons, selectedWeapon
end
function OpenModifyFromInventory(selUnit)
  if IsInMultiplayerGame() and g_Combat then
    return
  end
  local selObj = selUnit or Selection[1]
  if not selObj or not gv_Squads[selObj.Squad] then
    return
  end
  local allWeps = GetPlayerWeapons(gv_Squads[selObj.Squad])
  if #allWeps == 0 then
    return
  end
  local sessionId = selUnit.session_id
  local first = table.findfirst(allWeps, function(idx, wep)
    return wep.owner == sessionId
  end)
  first = first and allWeps[first] or allWeps[1]
  first.owner = gv_SatelliteView and gv_UnitData[first.owner] or g_Units[first.owner]
  OpenDialog("ModifyWeaponDlg", nil, first)
end
function TFormat.BlockedByError(context, by)
  if not by then
    return
  end
  local component = WeaponComponents[by]
  if not component then
    return
  end
  return T({
    215167554166,
    "<error>Can't modify slot, blocked by <compName>.</error>",
    compName = component.DisplayName
  })
end
local oldIsolatedFunc = GetIsolatedObjectScreenshotSelection
function GetIsolatedObjectScreenshotSelection()
  local dlg = GetDialog("ModifyWeaponDlg")
  if dlg and dlg.idModifyDialog then
    local prefab = dlg.prefab
    local prefabObjs = prefab.objs
    local objectsToShow = {
      dlg.idModifyDialog.weaponModel
    }
    for i, obj in ipairs(prefabObjs) do
      if IsKindOf(obj, "Light") then
        objectsToShow[#objectsToShow + 1] = obj
      end
    end
    return objectsToShow
  end
  return oldIsolatedFunc()
end
MapVar("g_WeaponModificationOpenOnPlayer", {})
MapVar("g_WeaponModificationWeaponLookingAt", {})
function NetSyncEvents.WeaponModifyDialogSpawn(playerId)
  if not g_WeaponModificationOpenOnPlayer then
    g_WeaponModificationOpenOnPlayer = {}
  end
  g_WeaponModificationOpenOnPlayer[playerId] = true
end
function NetSyncEvents.WeaponModifyDialogDespawn(playerId)
  if not g_WeaponModificationOpenOnPlayer then
    g_WeaponModificationOpenOnPlayer = {}
  end
  if not g_WeaponModificationWeaponLookingAt then
    g_WeaponModificationWeaponLookingAt = {}
  end
  g_WeaponModificationOpenOnPlayer[playerId] = false
  g_WeaponModificationWeaponLookingAt[playerId] = false
  ObjModified("WeaponModificationWeaponLookingChanged")
end
function NetSyncEvents.WeaponModifyLookingAtWeapon(playerId, weaponId)
  if not g_WeaponModificationWeaponLookingAt then
    g_WeaponModificationWeaponLookingAt = {}
  end
  g_WeaponModificationWeaponLookingAt[playerId] = weaponId
  g_WeaponModificationWeaponLookingAt[tostring(playerId) .. "time"] = RealTime()
  ObjModified("WeaponModificationWeaponLookingChanged")
end
function OtherPlayerLookingAtSameWeapon()
  local modifyDlg = GetDialog("ModifyWeaponDlg")
  modifyDlg = modifyDlg and modifyDlg.idModifyDialog
  if not modifyDlg then
    return
  end
  if not g_WeaponModificationWeaponLookingAt then
    return
  end
  if not IsCoOpGame() then
    return
  end
  local weaponId = modifyDlg.selectedWeaponItemId
  local otherPlayerId = GetOtherPlayerId()
  local otherPlayerWeapon = g_WeaponModificationWeaponLookingAt[otherPlayerId]
  if otherPlayerWeapon and otherPlayerWeapon == weaponId then
    local time = g_WeaponModificationWeaponLookingAt[netUniqueId .. "time"]
    local otherPlayerTime = g_WeaponModificationWeaponLookingAt[otherPlayerId .. "time"]
    if time > otherPlayerTime then
      return true
    end
  end
  return false
end
function OnMsg.NetPlayerLeft(player)
  local playerId = player and player.id
  if not playerId then
    return
  end
  NetSyncEvents.WeaponModifyDialogDespawn(playerId)
end
function CloseWeaponModificationCoOpAware()
  local inventoryUI = GetDialog("FullscreenGameDialogs")
  if inventoryUI then
    inventoryUI:Close()
  end
  local weaponModification = GetDialog("ModifyWeaponDlg")
  if weaponModification then
    weaponModification:Close()
  end
  local anyOpen = true
  while anyOpen do
    anyOpen = false
    for playerId, isOpen in sorted_pairs(g_WeaponModificationOpenOnPlayer) do
      local playerIsHere = table.find(netGamePlayers, "id", playerId)
      if isOpen and playerIsHere then
        anyOpen = true
      end
    end
    if not anyOpen then
      break
    end
    Sleep(100)
  end
  Sleep(default_interpolation_time + 50)
end
function OnMsg.CanSaveGameQuery(query)
  if GetDialog("ModifyWeaponDlg") then
    query.modify_weapon_dialog = true
  end
end
function GetWeaponComponentIcon(item, weapon)
  local icon = item.Icon
  for _, descr in ipairs(item.Visuals) do
    if descr:Match(weapon.class) and #(descr.Icon or "") > 0 then
      icon = descr.Icon
    end
  end
  return icon
end
