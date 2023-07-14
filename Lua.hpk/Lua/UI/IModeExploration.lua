DefineClass.IModeExploration = {
  __parents = {
    "IModeCommonUnitControl"
  },
  follow_thread = false,
  move_units = false,
  move_positions = false,
  move_end_time = false,
  move_thread = false,
  fx_unit_rollover = false,
  drag_start_pos = false,
  drag_selection_obj = false,
  IdleBanterThread = false,
  mouse_pos = false,
  mouse_lbutton_handle = false,
  mouse_rbutton_handle = false,
  cursor_voxel = false,
  last_move_units = false,
  last_move_pos = false,
  suppress_camera_init = false,
  can_start_combat = false
}
function IModeExploration:Init(parent, context)
  if context then
    for k, v in pairs(context) do
      if self:HasMember(k) and not self[k] then
        self[k] = v
      end
    end
  end
end
MapVar("g_VoiceResponseTemporaryDisablingThread", false)
MapVar("InactiveBanterPlayed", false)
function IModeExploration:Open()
  IModeCommonUnitControl.Open(self)
  if not IsValidThread(g_VoiceResponseTemporaryDisablingThread) then
    local vrEnabled = g_VoiceResponsesEnabled
    g_VoiceResponsesEnabled = false
    g_VoiceResponseTemporaryDisablingThread = CreateRealTimeThread(function()
      WaitMsg("SelectionChange", 1)
      g_VoiceResponsesEnabled = vrEnabled
    end)
  end
  self.move_units = {}
  self.move_positions = {}
  self.IdleBanterThread = CreateGameTimeThread(function()
    while not InactiveBanterPlayed do
      local gotMessage = WaitMsg("UserInputMade", 120000)
      if not gotMessage and not WaitPlayerControl() then
        local inventoryOrOtherDialog = GetDialog("FullscreenGameDialogs")
        if inventoryOrOtherDialog and inventoryOrOtherDialog.window_state == "open" then
          WaitMsg(inventoryOrOtherDialog)
        else
          local pdaDialog = GetDialog("PDADialogSatellite") or GetDialog("PDADialog")
          if pdaDialog and pdaDialog.window_state == "open" then
            WaitMsg(pdaDialog)
          elseif Selection[1] and Selection[1]:IsIdleCommand() then
            local povTeam = GetPoVTeam()
            local unitsCount = #povTeam.units
            local unitIdx = povTeam and AsyncRand(unitsCount) + 1
            local randomUnit
            if unitIdx then
              randomUnit = povTeam.units[unitIdx]
              local c = unitIdx % unitsCount + 1
              while not (c == unitIdx or randomUnit:IsLocalPlayerControlled()) or randomUnit:IsDead() or randomUnit:IsDowned() do
                randomUnit = povTeam.units[c]
                c = c % unitsCount + 1
              end
              randomUnit = randomUnit:IsLocalPlayerControlled() and randomUnit or false
            end
            local played = randomUnit and PlayVoiceResponseInternal(randomUnit, "Idle", true)
            if played then
              InactiveBanterPlayed = true
              break
            end
          end
        end
      end
    end
  end)
end
function IModeExploration:Close()
  DeleteThread(self.move_thread)
  DeleteThread(self.IdleBanterThread)
  DeleteThread(self.follow_thread)
  if self.fx_unit_rollover then
    local unit = self.fx_unit_rollover:GetParent()
    if g_SelectionContours[unit] then
      g_SelectionContours[unit].contour:SetVisible(true)
    end
    SpawnUnitContour(false, false, self.fx_unit_rollover)
  end
  IModeCommonUnitControl.Close(self)
end
function IModeExploration:OnMouseButtonDown(pt, button, time)
  if type(pt) == "number" then
  end
  local result = InterfaceModeDialog.OnMouseButtonDown(self, button, pt, time)
  if result and result ~= "continue" then
    return result
  end
  if not button and GetUIStyleGamepad() then
    self.move_button_down_time = RealTime()
    if self.world_cursor then
      PlayFX("GamepadCursorMoveHold", "start", self.world_cursor)
    end
    return "break"
  end
  if button == "L" then
    self.mouse_lbutton_handle = true
    if not self.desktop.last_mouse_target or self:IsWithin(self.desktop.last_mouse_target) then
      self.drag_start_pos = pt
      self.desktop:SetMouseCapture(self)
      self:DeleteThread("lock-camera")
      self:CreateThread("lock-camera", function()
        local cameraPos, eyePos = GetCamera()
        while true do
          Sleep(300)
          local cameraPosNew, eyePosNew = GetCamera()
          if cameraPos == cameraPosNew and eyePos == eyePosNew then
            break
          end
          cameraPos, eyePos = cameraPosNew, eyePosNew
        end
        LockCamera("Multiselection")
      end)
    end
    return "break"
  elseif button == "R" then
    self.mouse_rbutton_handle = true
  end
  return "continue"
end
function IModeExploration:OnMouseButtonUp(pt, button, time)
  local result = InterfaceModeDialog.OnMouseButtonUp(self, button, pt, time)
  if result and result ~= "continue" then
    return result
  end
  if self.starting_combat then
    return "break"
  end
  local drag_start_pos = self.drag_start_pos
  local left = button == "L" and self.mouse_lbutton_handle
  local right = button == "R" and self.mouse_rbutton_handle
  if left then
    self.mouse_lbutton_handle = false
  elseif right then
    self.mouse_rbutton_handle = false
  end
  local gamepadClick = false
  if not button and GetUIStyleGamepad() then
    gamepadClick = true
  end
  if left or right or gamepadClick then
    IModeCommonUnitControl.UpdateTarget(self, GetCursorPos())
    if pt and drag_start_pos and left then
      local breakInput = false
      if drag_start_pos:Dist2D(pt) > 10 then
        local start_pos = drag_start_pos
        local max_step = 12 * guim
        local all_objects = GatherObjectsInScreenRect(start_pos, pt, "Unit", max_step)
        self:HandleUnitSelection(all_objects)
        breakInput = true
      end
      self:CancelMultiselection()
      if breakInput then
        return "break"
      end
    end
    local target_unit = IsKindOf(self.potential_target, "Unit") and self.potential_target
    if (gamepadClick or left) and target_unit and #Selection > 0 then
      local team = g_CurrentTeam and g_Teams[g_CurrentTeam]
      if team and target_unit.team:IsEnemySide(team) and not target_unit:IsDead() then
        local action = Selection[1]:GetDefaultAttackAction()
        if ShouldUseMarkTarget(Selection[1], target_unit) then
          action = CombatActions.MarkTarget
        end
        if action.AimType == "melee" then
          for _, attacker in ipairs(Selection) do
            if attacker.marked_target_attack_args and attacker.marked_target_attack_args.target == target_unit then
              return "break"
            end
          end
          local targets = action:GetTargets({
            Selection[1]
          })
          if not table.find(targets, target_unit) then
            return "break"
          end
        end
        action:UIBegin(Selection, {target = target_unit})
        return "break"
      end
    end
    if (gamepadClick or left) and self.potential_target and self:HandleUnitSelection({
      self.potential_target
    }) then
      return "break"
    end
    local moveWithLeft = GetAccountStorageOptionValue("LeftClickMoveExploration")
    local interactButton = false
    if moveWithLeft then
      interactButton = right
    else
      interactButton = left
    end
    if next(Selection) and (interactButton or gamepadClick) then
      local interactable, unit, follow
      if IsValid(self.potential_interactable) then
        interactable = self.potential_interactable
        unit, follow = UIFindInteractWith(interactable, false)
      end
      if not unit then
        interactable, unit = self:GetInteractableUnderCursor()
      end
      if unit then
        UIInteractWith(unit, interactable)
        if follow then
          local followers = Selection
          for _, u in ipairs(followers) do
            if u ~= unit then
              local pos = u:GetInteractionPosWith(interactable)
              if pos then
                CombatActions.Move:Execute({u}, {goto_pos = pos})
              end
            end
          end
        end
        return "break"
      end
    end
    if left and not moveWithLeft then
      return "break"
    end
    if right and moveWithLeft then
      return "break"
    end
    local passPos = GetPassSlab(GetCursorPos("walkable"))
    if gamepadClick then
      local moveUnits = Selection
      local timeHeld = self.move_button_down_time and RealTime() - self.move_button_down_time or 0
      if timeHeld > const.GamePadButtonHoldTime then
        local team = GetFilteredCurrentTeam()
        moveUnits = team and team.units or moveUnits
      end
      self:InitiateUnitMovement(passPos, moveUnits, GetCursorPos())
      if self.world_cursor then
        PlayFX("GamepadCursorMoveHold", "end", self.world_cursor)
      end
    else
      self:InitiateUnitMovement(passPos, Selection)
    end
    return "break"
  end
  return "continue"
end
function IModeExploration:InitiateUnitMovement(pos, unitPool, fx_pos)
  if pos then
    unitPool = unitPool or Selection
    local units = {}
    for i, unit in ipairs(unitPool) do
      if unit:CanBeControlled() and unit.interruptable then
        table.insert(units, unit)
      end
    end
    if #units == 0 then
      return
    end
    local voice_response_unit = table.rand(units)
    local is_hidden = voice_response_unit:HasStatusEffect("Hidden")
    local line = "Order"
    if voice_response_unit:HasStatusEffect("Hidden") then
      line = "CombatMovementStealth"
    elseif 1 < #units then
      line = "GroupOrder"
    end
    if line then
      PlayVoiceResponse(voice_response_unit, line)
    end
    self:MoveUnitsTo(units, pos, "ui_triggered", fx_pos or pos)
    PlayFX("MercMoveCommand_OutOfCombat", "start")
  else
    PlayFX("Unreachable", "start")
  end
end
function IModeExploration:OnMousePos(pt, button)
  self.mouse_pos = pt
  local cursorPos = GetCursorPos()
  self:UpdateTarget(cursorPos)
  if cursorPos then
    local vx, vy, vz = WorldToVoxel(cursorPos)
    local voxel = point_pack(vx, vy, vz)
    if voxel ~= self.cursor_voxel then
      self.cursor_voxel = voxel
      if self.drag_start_pos and pt then
        self:MultiselectionUpdateRect(pt)
      end
    end
  end
  local combatActionsChoiceActive = self.combatActionsPopup and self.combatActionsPopup.window_state ~= "destroying"
  local tutorialPopupContext = CurrentTutorialPopup and CurrentTutorialPopup:IsVisible() and CurrentTutorialPopup:ResolveId("idText"):GetContext()
  local isRelatedPopup = tutorialPopupContext and (tutorialPopupContext.id == "Bandage" or tutorialPopupContext.id == "SneakMode")
  if not GetUIStyleGamepad() and not terminal.desktop.inactive and not combatActionsChoiceActive then
    local bottom = self.idBottomBar
    ApplyCombatBarHidingAnimation(self.idBottomBar, isRelatedPopup or pt:y() > self.idBottom.box:miny() - self.idBottom.box:sizey())
  end
  IModeCommonUnitControl.OnMousePos(self, pt)
end
function IModeExploration:UpdateTarget(...)
  IModeCommonUnitControl.UpdateTarget(self, ...)
  local potential_target = self:CanSelectObj(self.potential_target) and self.potential_target
  if IsValid(self.fx_unit_rollover) and self.fx_unit_rollover:GetParent() then
    local unit = self.fx_unit_rollover:GetParent()
    local selection_contour = g_SelectionContours[unit]
    if selection_contour and not IsKindOf(unit.traverse_tunnel, "SlabTunnelLadder") then
      selection_contour.contour:SetVisible(true)
    end
  end
  local unit = potential_target
  if IsKindOf(unit, "Unit") and IsKindOf(unit.traverse_tunnel, "SlabTunnelLadder") then
    unit = nil
  end
  self.fx_unit_rollover = SpawnUnitContour(unit, "ExplorationSelect", self.fx_unit_rollover)
  if self.fx_unit_rollover then
    local unit = potential_target
    local selection_contour = g_SelectionContours[unit]
    if selection_contour then
      selection_contour.contour:SetVisible(false)
    end
  end
end
function IModeExploration:MultiselectionUpdateRect(pt)
  local UIScale = GetUIScale()
  local start_x, start_y = MulDivRound(self.drag_start_pos, 1000, UIScale):xy()
  local pt_x, pt_y = pt:xy()
  pt_x = MulDivRound(pt_x, 1000, UIScale)
  pt_y = MulDivRound(pt_y, 1000, UIScale)
  local aspectRatioConstraint = GetAspectRatioConstraintAmount()
  start_x = start_x - aspectRatioConstraint
  pt_x = pt_x - aspectRatioConstraint
  local left = Min(start_x, pt_x)
  local right = Max(start_x, pt_x)
  local top = Min(start_y, pt_y)
  local bottom = Max(start_y, pt_y)
  local rect_element = self.idSelection
  rect_element:SetVisible(true)
  rect_element:SetMargins(box(left, top, 0, 0))
  rect_element:SetMinWidth(right - left)
  rect_element:SetMinHeight(bottom - top)
  local start_pos = self.drag_start_pos
  local max_step = 12 * guim
  local temp_objects = GatherObjectsInScreenRect(start_pos, pt, "Unit", max_step)
  if next(temp_objects) and self:CanSelectObj(temp_objects[1]) then
    local first_obj = temp_objects[1]
    self.drag_selection_obj = first_obj
  else
    self.drag_selection_obj = false
  end
end
function IModeExploration:OnKillFocus()
  self:CancelMultiselection()
end
function IModeExploration:OnDelete()
  self:CancelMultiselection()
end
function IModeExploration:CancelMultiselection()
  if self.desktop.mouse_capture == self then
    self.desktop:SetMouseCapture(false)
  end
  if self.drag_start_pos then
    self.idSelection:SetVisible(false)
    self.drag_start_pos = false
    self.drag_selection_obj = false
    self:DeleteThread("lock-camera")
    UnlockCamera("Multiselection")
  end
end
function IModeExploration:CanSelectObj(obj)
  return IsKindOf(obj, "Unit") and obj:CanBeControlled()
end
function IModeExploration:SelectUnits(units)
  local filtered = {}
  local n = 0
  for i, unit in ipairs(units) do
    if self:CanSelectObj(unit) then
      n = n + 1
      filtered[n] = unit
    end
  end
  if n == 0 then
    return
  end
  local changed = false
  for i = #Selection, 1, -1 do
    local u = Selection[i]
    if not table.find(filtered, u) then
      SelectionRemove(u)
      changed = true
    end
  end
  for _, u in ipairs(filtered) do
    if not table.find(Selection, u) then
      SelectionAdd(u)
      changed = true
    end
  end
  return changed
end
function IModeExploration:HandleUnitSelection(units)
  local shift = GetCameraVKCodeFromShortcut("Shift")
  if terminal.IsKeyPressed(shift) and #units ~= 0 then
    for _, unit in ipairs(Selection) do
      if table.find(units, unit) then
        table.remove_entry(units, unit)
      else
        table.insert(units, unit)
      end
    end
  end
  return self:SelectUnits(units)
end
function UpdateMarkerAreaEffects()
  if not gv_CurrentSectorId then
    return
  end
  UpdateInteractableAreaMarkersEffects()
end
function UpdateBorderAreaMarkerVisibility(cursor_pos)
  local voxel_cursor_x, voxel_cursor_y, voxel_cursor_z = WorldToVoxel(cursor_pos)
  local m = GetBorderAreaMarker()
  if not m then
    return
  end
  local mw_x, mw_y = WorldToVoxel(m)
  local left = mw_x - m.AreaWidth / 2
  local right = left + m.AreaWidth
  local up = mw_y - m.AreaHeight / 2
  local down = up + m.AreaHeight
  local voxel_range = 12
  if not m.contour_polyline then
    if left >= voxel_cursor_x - voxel_range or right <= voxel_cursor_x + voxel_range or up >= voxel_cursor_y - voxel_range or down <= voxel_cursor_y + voxel_range then
      m:UpdateHideReason("area_visiblity", false)
    end
  else
    local is_inside = voxel_cursor_x >= left and voxel_cursor_x < right and voxel_cursor_y >= up and voxel_cursor_y < down
    local material = m.contour_polyline[1].CRMaterial
    material:SetIsInside(is_inside, "notimereset")
    local markerPos = m:GetPos()
    if not markerPos:IsValidZ() then
      markerPos = markerPos:SetZ(terrain.GetHeight(markerPos))
    end
    material.dirty = true
    material.ZOffset = 0
    for key, value in ipairs(m.contour_polyline) do
      value:SetCRMaterial(material)
    end
    if left < voxel_cursor_x - voxel_range and right > voxel_cursor_x + voxel_range and up < voxel_cursor_y - voxel_range and down > voxel_cursor_y + voxel_range then
      m:UpdateHideReason("area_visiblity", true)
    end
  end
end
function UpdateInteractableAreaMarkersEffects()
  for _, marker in ipairs(g_InteractableAreaMarkers) do
    if marker.area_ground_mesh then
      if marker:IsInsideArea(GetCursorPos()) then
        marker.area_ground_mesh.hover = true
        marker.area_ground_mesh:UpdateState()
        if not marker.area_effect then
          marker.area_effect = true
        end
        local text = GetInteractableAreaMarkerRollover(marker)
        if marker.fl_text then
          if not text or _InternalTranslate(text) ~= _InternalTranslate(marker.fl_text:GetText()) then
            marker:RemoveFloatTxt()
            if text then
              marker.fl_text = ShowFloatingTextNoExpire(marker, text, "BadgeNameActive")
            end
          end
        elseif text then
          marker.fl_text = ShowFloatingTextNoExpire(marker, text, "BadgeNameActive")
        end
        return
      end
      if marker.area_effect then
        marker.area_effect = false
        marker:RemoveFloatTxt()
      end
      marker.area_ground_mesh.hover = false
      marker.area_ground_mesh:UpdateState()
    end
  end
end
function IModeExploration:StartFollow(units, pos)
  self.last_move_units = units
  self.last_move_pos = pos
  if IsValidThread(self.follow_thread) then
    return
  end
  self.follow_thread = CreateGameTimeThread(function(self)
    local vr_move_pos = false
    while true do
      Sleep(const.ExplorationFollowDelay)
      local units = self.last_move_units
      if not units or #units == 0 then
        return
      end
      for i = #units, 1, -1 do
        local u = units[i]
        if not IsValid(u) or not u:CanBeControlled() then
          table.remove(units, i)
        end
      end
      local followers
      local max_dist2D = 4 * const.SlabSizeX
      local pos = self.last_move_pos
      local z = pos:IsValidZ() and pos:z() or terrain.GetHeight(pos)
      for _, unit in ipairs(units) do
        local unitsInSquad = GetMapUnitsInSquad(unit.Squad)
        for _, u in ipairs(unitsInSquad) do
          if not table.find(followers, u) and not table.find(units, u) and u:CanBeControlled() and (not IsCloser2D(u, pos, max_dist2D) or abs(select(3, u:GetVisualPosXYZ()) - z) > const.SlabSizeZ) then
            followers = followers or {}
            followers[#followers + 1] = u
          end
        end
      end
      if not followers then
        return
      end
      if vr_move_pos ~= self.last_move_pos then
        local vr_units = {}
        for i, f in ipairs(followers) do
          vr_units[#vr_units + 1] = f
        end
        for i, u in ipairs(units) do
          vr_units[#vr_units + 1] = u
        end
        local voice_response_unit = table.rand(vr_units)
        PlayVoiceResponse(voice_response_unit, "GroupOrder")
        vr_move_pos = self.last_move_pos
      end
      self:MoveUnitsTo(followers, pos)
    end
  end, self)
end
function IModeExploration:StopFollow()
  DeleteThread(self.follow_thread)
  DeleteThread(self.move_thread)
  self.follow_thread = false
  self.move_thread = false
end
function IModeExploration:MoveUnitsTo(units, pos, ui_triggered, cursor_pos)
  if not IsValidThread(self.move_thread) then
    self.move_units = {}
    self.move_positions = {}
  end
  local move_units = self.move_units
  local move_positions = self.move_positions
  local dest = GetUnitsDestinations(units, pos)
  if ui_triggered then
    for i = 1, #dest do
      local pos = dest[i] and (GetPassSlab(point_unpack(dest[i])) or point(point_unpack(dest[i]))) or pos
      if cursor_pos and i == 1 and #units == 1 then
        pos = cursor_pos
      end
      if GetUIStyleGamepad() then
        local worldCursor = self.world_cursor
        if worldCursor then
          PlayFX("GamepadCursorMoveCommand", "start", worldCursor, false, pos)
        end
      else
        PlaceShrinkingObj(self.movement_decal, self.movement_decal_shrink_time, pos, self.movement_decal_scale, self.movement_decal_color, units[i] and units[i]:HasStatusEffect("Hidden") and "MoveCommandHidden")
      end
    end
  end
  local prev_count = #move_units
  local packed_pos
  for i, unit in ipairs(units) do
    if not move_positions[unit] then
      table.insert(move_units, unit)
    end
    if dest[i] then
      move_positions[unit] = dest[i]
    else
      packed_pos = packed_pos or point_pack(pos)
      move_positions[unit] = packed_pos
    end
  end
  if prev_count == #move_units then
    return
  end
  for j = #move_units, prev_count + 2, -1 do
    local k = prev_count + 1 + AsyncRand(j - prev_count)
    move_units[j], move_units[k] = move_units[k], move_units[j]
  end
  self.move_end_time = GameTime() + 200
  if IsValidThread(self.follow_thread) and self.follow_thread ~= CurrentThread() then
    DeleteThread(self.follow_thread)
    self.follow_thread = false
  end
  if IsValidThread(self.move_thread) then
    return
  end
  self.move_thread = CreateGameTimeThread(function(self)
    while #(self.move_units or empty_table) > 0 do
      local unit = self.move_units[1]
      table.remove(self.move_units, 1)
      local packed_pos = self.move_positions[unit]
      self.move_positions[unit] = nil
      local units = {unit}
      if IsValid(unit) and unit:IsValidPos() and unit:CanBeControlled() and CombatActions.Move:GetUIState(units) == "enabled" then
        local pos = GetPassSlab(point_unpack(packed_pos)) or point(point_unpack(packed_pos))
        CombatActions.Move:Execute(units, {goto_pos = pos})
      end
      if #self.move_units > 0 then
        local total = self.move_end_time - now()
        local average = total / #self.move_units
        local delay = 0 < average and average / 2 + AsyncRand(average / 2) or 0
        self.move_end_time = self.move_end_time - (average - delay)
        if 0 < delay then
          Sleep(delay)
        end
      end
    end
    self.move_thread = false
  end, self)
end
function OnMsg.UnitControlChanged(unit, control)
  ForceUpdateCommonUnitControlUI()
  local myControlNow = unit:IsLocalPlayerControlled()
  if myControlNow and not SelectedObj then
    SelectObj(unit)
    SnapCameraToObj(unit)
    return
  end
  if not myControlNow and SelectedObj == unit then
    if g_Combat then
      g_Combat:NextUnit(false, true)
    else
      local dlg = GetInGameInterfaceModeDlg()
      if IsKindOf(dlg, "IModeExploration") then
        dlg:NextUnit()
      end
    end
  end
  local lsdlg = GetLoadingScreenDialog()
  if lsdlg then
    lsdlg:SetFocus()
  end
end
function OnMsg.NetSentInterrupt()
  local dlg = GetDialog("IModeExploration")
  if dlg then
    dlg:StopFollow()
  end
end
function OnMsg.SetpieceStarted()
  local dlg = GetInGameInterfaceModeDlg()
  if IsKindOf(dlg, "IModeCommonUnitControl") then
    dlg:UpdateTarget()
  end
  if interactablesOn then
    HighlightAllInteractables(false)
  end
  for i, u in ipairs(Selection) do
    HandleMovementTileContour({u})
  end
  for _, marker in ipairs(g_InteractableAreaMarkers) do
    if marker.area_ground_mesh then
      marker.area_ground_mesh:SetVisible(false)
    end
  end
end
function OnMsg.SetpieceEnded()
  for i, u in ipairs(Selection) do
    SelectionAddedApplyFX(u)
  end
  local dlg = GetInGameInterfaceModeDlg()
  if IsKindOf(dlg, "IModeCommonUnitControl") then
    dlg:UpdateTarget()
  end
  for _, marker in ipairs(g_InteractableAreaMarkers) do
    if marker.area_ground_mesh then
      marker.area_ground_mesh:SetVisible(true)
    end
  end
end
GameVar("gv_TacFloor", false)
function OnMsg.GatherSessionData()
  gv_TacFloor = cameraTac:GetFloor()
end
function OnMsg.LoadSessionData()
  if gv_TacFloor then
    cameraTac.SetFloor(gv_TacFloor)
  end
  g_TestExploration = false
end
