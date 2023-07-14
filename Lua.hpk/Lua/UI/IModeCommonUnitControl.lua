redirectedIgiEvents = {
  "OnMousePos",
  "OnMouseButtonUp",
  "OnMouseButtonDown",
  "OnMouseWheelForward",
  "OnMouseWheelBack",
  "OnMouseButtonDoubleClick"
}
function OnMsg.InGameInterfaceCreated(igi)
  igi.HandleMouse = true
  for i, e in ipairs(redirectedIgiEvents) do
    igi[e] = function(self, ...)
      for i, w in ipairs(self) do
        if w.visible and w[e](w, ...) == "break" then
          return "break"
        end
      end
    end
  end
end
function SetInGameInterfaceMode(mode, context)
  SetDialogMode("InGameInterface", mode, context)
end
DefineClass.InterfaceModeDialog = {
  __parents = {"XDialog"}
}
local oldCreateFloatingText = CreateFloatingText
function CreateFloatingText(target, ...)
  if CheatEnabled("CombatUIHidden") then
    return false
  end
  if IsKindOf(target, "Unit") and (not IsValid(target) or target:IsDead() or target:GetEnumFlags(const.efVisible) == 0) then
    return
  end
  if IsPoint(target) and not target:IsValidZ() then
    target = target:SetTerrainZ()
  end
  return oldCreateFloatingText(target, ...)
end
DefineClass.IModeCommonUnitControl = {
  __parents = {
    "GamepadUnitControl"
  },
  HandleMouse = false,
  combatActionsPopup = false,
  fx_interactables = false,
  potential_target = false,
  potential_interactable = false,
  potential_interactable_action = false,
  potential_target_is_enemy = false,
  action_targets = false,
  show_world_ui = false,
  target_pos = false,
  target_pos_has_unit = false,
  target_pos_occupied = false,
  effects_target_pos = false,
  effects_target_pos_last = false,
  cover_objs = false,
  fx_lof_offset = guim,
  fx_lof = false,
  movement_decal = "DecUIUnitTarget",
  movement_decal_scale = 130,
  movement_decal_shrink_time = 700,
  movement_decal_color = RGB(204, 204, 204)
}
function IModeCommonUnitControl:Init()
  self.cover_objs = {}
  self:CreateThread("highlightInteractables", function(ctrl)
    local dontAddNewInteractables
    while ctrl.window_state ~= "destroying" do
      dontAddNewInteractables = IsSetpiecePlaying() or not ctrl:IsVisible() or not ctrl:HighlightNewInteractables() or next(g_ZuluMessagePopup)
      dontAddNewInteractables = not (g_Combat and SelectedObj) or dontAddNewInteractables or not SelectedObj:IsIdleCommand() or HasCombatActionInProgress(SelectedObj)
      if not cameraTac.IsActive() then
        dontAddNewInteractables = true
      end
      ctrl:UpdateInteractablesHighlight(dontAddNewInteractables)
      Sleep(100)
    end
  end, self)
end
if FirstLoad then
  LastLoadedOrLoadingIMode = false
end
function IModeCommonUnitControl:Open(...)
  LastLoadedOrLoadingIMode = self.class
  SelectionAddedApplyFX(Selection)
  GamepadUnitControl.Open(self, ...)
end
function IModeCommonUnitControl:Close(...)
  self:UpdateInteractablesHighlight(true)
  return GamepadUnitControl.Close(self, ...)
end
function IModeCommonUnitControl:ClearMemberObj(member_name)
  if self[member_name] then
    DoneObject(self[member_name])
    self[member_name] = nil
  end
end
function IModeCommonUnitControl:ClearMemberObjArray(member_name, keep_table)
  for _, obj in ipairs(self[member_name]) do
    DoneObject(obj)
  end
  if keep_table then
    if self[member_name] then
      table.iclear(self[member_name])
    end
  else
    self[member_name] = nil
  end
end
function IModeCommonUnitControl:HighlightNewInteractables()
  return true
end
MapVar("UnitsSusBeingRaised", function()
  return {}
end)
function SpawnDetectionIndicator(unit)
  local lineMesh = MercDetectionIndicator:new({unit = unit})
  lineMesh:SetGameFlags(const.gofLockedOrientation)
  lineMesh.unit = unit
  unit:Attach(lineMesh)
  return lineMesh
end
function OnMsg.UnitSetIdleSuspicious(unit)
  FireNetSyncEventOnHostOnce("UnitSetIdleSuspicious", unit)
end
function NetSyncEvents.UnitSetIdleSuspicious(unit)
  unit:SetCommand("IdleSuspicious")
end
function EnsureUnitHasAwareBadge(unit)
  if not TargetHasBadgeOfPreset("AwareBadge", unit) then
    CreateBadgeFromPreset("AwareBadge", unit, unit)
    if IsKindOf(unit, "Unit") then
      PlayVoiceResponse(unit, "Startled")
      Msg("UnitSetIdleSuspicious", unit)
    end
  end
end
function UnitAwareBadgeProc(badge)
  local enemy = badge.context
  if g_Combat or g_StartingCombat or not IsValid(enemy) then
    DeleteBadgesFromTargetOfPreset("AwareBadge", enemy)
    return
  end
  local badgeShouldBeVisible = false
  local exp = g_Exploration
  local enemyData = exp and exp.nearby_enemies and exp.nearby_enemies[enemy]
  local enemyRaisingSus = enemyData and enemyData.amount > 0
  if IsKindOf(enemy, "SneakProjector") then
    if not enemyRaisingSus then
      DeleteBadgesFromTargetOfPreset("AwareBadge", enemy)
      return
    end
    badgeShouldBeVisible = true
  else
    local enemySus = enemy:HasStatusEffect("Suspicious")
    local shouldBeVisible = enemySus or enemyRaisingSus
    if enemy:IsDead() or not shouldBeVisible then
      DeleteBadgesFromTargetOfPreset("AwareBadge", enemy)
      return
    end
    badgeShouldBeVisible = enemy.visible
  end
  local image = badge.idImage
  local invisible = badge.idImage.transparency == 255
  if invisible then
    local fadeTime = 200
    local growTime = 500
    badge.idImage:SetTransparency(0, fadeTime)
    local interpData = {
      id = "pulse",
      type = const.intRect,
      duration = growTime,
      originalRect = sizebox(0, 0, 1000, 1000),
      targetRect = sizebox(0, 0, 1300, 1300),
      flags = const.intfPingPong,
      OnLayoutComplete = IntRectCenterRelative
    }
    badge.idImage:AddInterpolation(interpData)
  end
  badge:SetVisible(badgeShouldBeVisible)
  Sleep(100)
end
function OnMsg.UnitAwarenessChanged(obj)
  if obj:HasStatusEffect("Suspicious") then
    EnsureUnitHasAwareBadge(obj)
  end
end
function AppendVerticesUnionCircles(circle_centers, circle_radiuses, mesh_str)
  local color = const.clrWhite
  local subdiv = 128
  local width = guim * 4 / 10
  local dash = 70
  local z_offset = guim / 2
  AppendVerticesUnionCirclesMesh(mesh_str, circle_centers, circle_radiuses, subdiv, width, dash, z_offset, color)
end
DefineClass.FloorDisplay = {
  __parents = {"XWindow"},
  Id = "idFloorHintCursor",
  Clip = false,
  UseClipBox = false,
  HAlign = "left",
  VAlign = "top",
  FadeOutTime = 300,
  ZOrder = 100
}
function FloorDisplay:Open()
  local floorDisplay = XTemplateSpawn("FloorHUDButtonClass", self)
  local subWnd = XTemplateSpawn("XWindowReverseDraw", floorDisplay)
  subWnd:SetId("idFloorDisplay")
  subWnd:SetLayoutMethod("VList")
  subWnd:SetLayoutVSpacing(-4)
  subWnd:SetId("idFloorDisplay")
  XWindow.Open(self)
end
function FloorDisplay:ResetHiding()
  if self:GetThread("disappear") then
    self:DeleteThread("disappear")
  end
  self:SetVisible(true, true)
  self:CreateThread("disappear", function()
    Sleep(500)
    self:SetVisible(false)
    Sleep(self.FadeOutTime + 1)
    self:Close()
  end)
end
function IModeCommonUnitControl:OnMouseWheelForward()
  if terminal.IsKeyPressed(const.vkShift) then
    self:ShowFloorDisplay()
  end
end
function IModeCommonUnitControl:OnMouseWheelBack()
  if terminal.IsKeyPressed(const.vkShift) then
    self:ShowFloorDisplay()
  end
end
function OnMsg.TacCamFloorChanged()
  local igi = GetInGameInterfaceModeDlg()
  if igi and IsValidThread(igi.gamepad_thread) then
    igi:ShowFloorDisplay()
  end
end
function IModeCommonUnitControl:Done()
  self:DeleteThread("UpdateMousePos")
  self:ClosePopup()
  self:ClearTargetCovers()
  self:ClearLinesOfFire()
end
function IModeCommonUnitControl:ClosePopup(newPopupAction)
  if self.combatActionsPopup and self.combatActionsPopup.window_state ~= "destroying" then
    local popupAction = self.combatActionsPopup.action
    self.combatActionsPopup:Close()
    self.combatActionsPopup = false
    if popupAction and newPopupAction and newPopupAction.id == popupAction.id then
      return true
    end
  end
end
local ExtractCombatActionTargetChoiceText = function(target, menu_pos)
  if IsKindOf(target, "Unit") then
    return target:GetDisplayName()
  end
  if IsKindOf(target, "PropertyObject") then
    if target:HasMember("DisplayName") then
      return target:GetProperty("DisplayName")
    end
  elseif target.DisplayName then
    return target.DisplayName
  end
  return T({
    639303826024,
    "<u(class)> <i>",
    class = target.class,
    i = menu_pos
  })
end
function IModeCommonUnitControl:ShowCombatActionTargetChoice(action, units, choices, callback, suppress_toggle)
  choices = choices or action:GetTargets(units)
  if #choices == 0 then
    return
  end
  local context = {}
  for idx, target in ipairs(choices) do
    local closest_unit = units[1]
    if 1 < #units then
      closest_unit = IsValid(target) and ChooseClosestObject(units, target) or units[1]
    end
    local combat_action
    if action.id == "Interact" then
      combat_action = target:GetInteractionCombatAction(closest_unit)
    else
      combat_action = action
    end
    if combat_action then
      local state = action:GetUIState({closest_unit}, {target = target})
      if state == "enabled" then
        local text
        if combat_action.group == "Interactions" then
          local display_name = combat_action:GetActionDisplayName(closest_unit)
          local apCost = (combat_action:GetAPCost(closest_unit) or 0) / const.Scale.AP
          text = T({
            display_name,
            unit = closest_unit,
            target = target
          })
          if g_Combat then
            text = text .. T({
              654731275801,
              " (<apCost> AP)",
              apCost = apCost
            })
          end
        else
          text = ExtractCombatActionTargetChoiceText(target, idx)
        end
        table.insert(context, {
          text = text,
          action = action,
          unit = closest_unit,
          target = target,
          callback = callback,
          uiCtx = rawget(target, "uiCtx"),
          rolloverTemplate = rawget(target, "rolloverTemplate"),
          icon = combat_action.Icon,
          disabled = rawget(target, "disabled")
        })
      end
    end
  end
  if not rawget(choices, "always_show") and #context == 1 and not context[1].disabled then
    ExecuteCombatChoice(context[1])
    return
  end
  if RolloverControl and IsKindOf(RolloverControl, "XTextButton") and RolloverWin then
    RolloverWin:Close()
    RolloverWin = false
  end
  if self:ClosePopup(action) and not suppress_toggle then
    return
  end
  local combatUnitPanel = self:ResolveId("idCombatUnitPanel")
  local actionButtonsBar = self:ResolveId("idActionButtonsBar")
  local actionsContainer = self:ResolveId("idCombatActionsContainer")
  local actionsChoicePopup = XTemplateSpawn("CombatActionsChoice", self, context)
  rawset(actionsChoicePopup, "action", action)
  actionsChoicePopup.width_wnd = actionsContainer
  self.combatActionsPopup = actionsChoicePopup
  local actionButton = table.find_value(actionsContainer, "Id", action.id)
  actionsChoicePopup:SetAnchor(actionButton.box)
  actionsChoicePopup:SetAnchorType("center-top")
  actionsChoicePopup:SetId("idCombatActionsPopup")
  actionsChoicePopup:Open()
  actionsChoicePopup.idChoiceActionsContainer:SetFocus()
  actionsChoicePopup.idChoiceActionsContainer:SetFocusedItem(1)
  actionButton:OnSetRollover(false, true)
  function actionsChoicePopup.OnDelete()
    if actionButton.window_state == "destroying" then
      return
    end
    actionButton:OnSetRollover(false, true)
  end
  function self.SetBox(this, ...)
    XDialog.SetBox(this, ...)
    local popup = this.combatActionsPopup
    if not popup then
      return
    end
    if not actionButton or actionButton.window_state == "destroying" then
      return
    end
    popup:SetAnchor(actionButton.box)
    popup:InvalidateLayout()
  end
  return actionsChoicePopup
end
function IModeCommonUnitControl:NextUnit(team, force, ignore_snap, prev)
  team = team or g_Teams and g_Teams[g_CurrentTeam]
  if not team or team.control ~= "UI" then
    return
  end
  local fTeam = GetFilteredCurrentTeam(team)
  local units = fTeam.units
  local current_unit = SelectedObj
  local idx = table.find(units, current_unit) or 1
  local n = #units
  if not units or not next(units) then
    return
  end
  local j = idx
  while true do
    if prev then
      j = j - 1
    else
      j = j + 1
    end
    if j < 1 then
      j = n
    end
    if n < j then
      j = 0
    end
    if j == 0 then
      j = 1
    end
    local unit = units[j]
    if not unit then
      return
    end
    if self:UnitAvailableForNextUnitSelection(unit) then
      SelectObj(unit)
      if not ignore_snap then
        SnapCameraToObj(unit, "player-input")
      end
      return
    end
    if j == idx then
      return
    end
  end
end
function IModeCommonUnitControl:UnitAvailableForNextUnitSelection(unit)
  return unit:CanBeControlled() and not unit:IsDowned()
end
function ExecuteCombatChoice(data)
  if data.callback then
    data.callback(data.unit, data.target, table.unpack(data.args or empty_table))
  else
    data.action:Execute({
      data.unit
    }, {
      target = data.target,
      table.unpack(data.args or empty_table)
    })
  end
end
function UICanInteractWith(unit, target, skip_cost, sync)
  if not IsValid(unit) or not IsValid(target) then
    return false
  end
  if not unit:CanBeControlled() then
    return false
  end
  return unit:CanInteractWith(target, false, skip_cost, nil, sync)
end
function CanInteractWith_SyncHelper(unit, target, skip_cost, sync)
  if not IsValid(unit) or not IsValid(target) then
    return false
  end
  if not unit:IsDisabled() then
    return false
  end
  return unit:CanInteractWith(target, false, skip_cost, nil, sync)
end
function UIFindInteractWith(target, skipApCost)
  if skipApCost == nil then
    skipApCost = true
  end
  local action = false
  for i, sU in ipairs(Selection) do
    action = target:GetInteractionCombatAction(sU)
    if action then
      break
    end
  end
  if not action then
    return false
  end
  local behavior = action.MultiSelectBehavior
  if behavior == "first" then
    for i, sU in ipairs(Selection) do
      if UICanInteractWith(sU, target, skipApCost) then
        return sU
      end
    end
  else
    local obj = ChooseClosestObject(Selection, target, UICanInteractWith, skipApCost)
    return obj, behavior == "all" and "follow"
  end
end
function UIInteractWith(unit, target)
  if not IsValid(target) then
    return
  end
  if not IsKindOf(target, "Interactable") then
    target = ResolveInteractableObject(target)
    if target then
      return
    end
  end
  local igi = GetInGameInterfaceModeDlg()
  if IsKindOf(igi, "IModeExploration") then
    local pos = unit:GetInteractionPosWith(target)
  end
  local interactionAction = target:GetInteractionCombatAction(unit)
  if interactionAction.id == "Interact_Attack" then
    local args = {target = target}
    local action = unit:GetDefaultAttackAction("ranged")
    local state = action and CheckAndReportImpossibleAttack(unit, action, args)
    if state and state == "enabled" then
      action:UIBegin({unit}, args)
    end
    return
  end
  CombatActions.Interact:Execute({unit}, {target = target})
end
local lInteractablePriorityList = {Unit = 1}
function IModeCommonUnitControl:GetInteractableUnderCursor()
  local interactables = {}
  local solid = PreciseCursorObjAreaClosestOfType(false, lInteractablePriorityList)
  local obj = solid or SelectFromTerrainPoint(GetTerrainCursor())
  local interactable, all = ResolveInteractableObject(obj)
  if all and 0 < #all then
    table.iappend(interactables, all)
  elseif interactable then
    table.insert(interactables, interactable)
  else
    local obj = GetTerrainCursorObjSel()
    if obj and obj:IsKindOf("Decal") then
      obj = ResolveInteractableObject(obj)
      if obj then
        table.insert(interactables, obj)
      end
    end
  end
  if GetUIStyleGamepad() then
    local resolvedObjectsGamepad = {}
    self.potential_interactable_gamepad_resolved = resolvedObjectsGamepad
    local vAround = GetVoxelBBox(GetCursorPos(), 0.5, "with_z", "dont_snap")
    MapForEach(vAround, "CObject", const.efSelectable + const.efVisible, function(obj)
      if vAround:PointInside(obj:GetPos()) then
        local int = ResolveInteractableObject(obj)
        if int then
          interactables[#interactables + 1] = int
          resolvedObjectsGamepad[int] = obj
        end
      end
    end)
  end
  local cursor_pos = GetUIStyleGamepad() and GetCursorPos() or GetTerrainCursor()
  local camera_pos = camera.GetEye()
  local rayObj, pt, normal = GetClosestVisibleRayObj(camera_pos, cursor_pos)
  if rayObj and not IsKindOf(rayObj, "TerrainCollision") then
    local interactable, all = ResolveInteractableObject(rayObj)
    if all and 0 < #all then
      table.iappend(all, interactables)
      interactables = all
    elseif interactable then
      table.insert(interactables, 1, interactable)
    end
  end
  local units = MapGet(cursor_pos, guim * 3, "Unit")
  for i, u in ipairs(units) do
    if u:IsDead() and u:GetItemInSlot("InventoryDead") then
      local collided = GetBodyHitArea(camera_pos, cursor_pos, u)
      if collided then
        table.insert(interactables, u)
      end
    end
  end
  local checked = {}
  for i, target in ipairs(interactables) do
    if not checked[target] then
      checked[target] = true
      local unit = UIFindInteractWith(target)
      if unit then
        return target, unit
      end
    end
  end
end
function IModeCommonUnitControl:UpdateInteractablesHighlight(noNew)
  if not next(Selection) or not self.show_world_ui then
    noNew = true
  end
  local new_interactables = {}
  if not noNew then
    local selectedObj = Selection[1]
    local intensely_highlighted = self:GetInteractableUnderCursor()
    if self.potential_target and self.potential_target ~= intensely_highlighted and not IsKindOf(intensely_highlighted, "GameDynamicSpawnObject") then
      intensely_highlighted = false
    end
    if intensely_highlighted then
      new_interactables[#new_interactables + 1] = intensely_highlighted
    end
    if intensely_highlighted and intensely_highlighted ~= self.potential_interactable then
      PlayFX("InteractRollover", "start", selectedObj, intensely_highlighted)
    end
    local action = intensely_highlighted and intensely_highlighted:GetInteractionCombatAction(selectedObj)
    intensely_highlighted = action and intensely_highlighted
    self.potential_interactable = intensely_highlighted
    self.potential_interactable_action = action
    if intensely_highlighted then
      intensely_highlighted:HighlightIntensely(true, "cursor")
      if not g_Combat then
        HandleMovementTileContour()
      end
    end
  end
  local new_interactables_set = table.invert(new_interactables)
  if self.fx_interactables then
    for i, obj in ipairs(self.fx_interactables) do
      if IsValid(obj) and not new_interactables_set[obj] then
        obj:HighlightIntensely(false, "cursor")
      end
    end
  end
  self.fx_interactables = new_interactables
end
MapVar("interactablesOn", false)
if FirstLoad then
  interactableHighlightThread = false
end
local interactableHighlightUpdateInterval = 200
local interactableOnScreenMargin = 500
function OnMsg.ChangeMap()
  if interactableHighlightThread then
    DeleteThread(interactableHighlightThread)
    interactableHighlightThread = false
  end
end
function HighlightCustomUnitInteractables(disable)
  local UnitHighlightIntensely = Unit.HighlightIntensely
  if disable then
    for i, u in ipairs(g_Units) do
      UnitHighlightIntensely(u, false, "badge-only")
    end
  else
    local highlight_action = Presets.CombatAction.Interactions.Interact_UnitCustomInteraction
    for i, u in ipairs(g_Units) do
      local isCustomUnitInteraction = u.visible and u:GetInteractionInfo() == highlight_action
      UnitHighlightIntensely(u, isCustomUnitInteraction, "badge-only")
    end
  end
end
function HighlightAllInteractables(setOn)
  if setOn and IsSetpiecePlaying() then
    return
  end
  interactablesOn = setOn
  UpdateAllBadgesAndModes()
  if interactableHighlightThread then
    DeleteThread(interactableHighlightThread)
    interactableHighlightThread = false
  end
  if CurrentMap == "" or IsChangingMap() then
    return
  end
  local haveSelection = Selection and #Selection > 0 and Selection[1]
  if not interactablesOn or not haveSelection then
    MapForEach("map", "Interactable", function(o)
      o:HighlightIntensely(false, "hotkey")
    end)
    return
  end
  TutorialHintsState.HighlightItems = TutorialHintsState.HighlightItemsShown and true
  interactableHighlightThread = CreateRealTimeThread(function()
    local interactables = MapGet("map", "Interactable", function(o)
      return not IsKindOf(o, "Door")
    end)
    while not GetDialog("PDADialogSatellite") do
      local haveSelection = Selection and #Selection > 0 and Selection[1]
      local interaction_enabled = haveSelection and haveSelection:CanBeControlled()
      if interaction_enabled and haveSelection:IsLocalPlayerControlled() and GetDialog("FullscreenGameDialogs") then
        interaction_enabled = false
      end
      local screenSize_x, screenSize_y = UIL.GetScreenSize():xy()
      local screen_width = screenSize_x + interactableOnScreenMargin
      local screen_height = screenSize_y + interactableOnScreenMargin
      for i, o in ipairs(interactables) do
        local nonALUnit, is_unit
        if IsKindOf(o, "Unit") and not o:IsDead() then
          nonALUnit = not o.ephemeral
          is_unit = true
        end
        if IsValid(o) and (nonALUnit or o.discovered) then
          local highlight
          if interaction_enabled then
            local front, screen_x, screen_y = GameToScreenXY(o)
            if front and 0 < screen_x and 0 < screen_y and screen_width > screen_x and screen_height > screen_y then
              local action
              highlight, action = haveSelection:CanInteractWith(o, false)
              if highlight and is_unit and action ~= CombatActions.Interact_Talk and not o.ImportantNPC then
                highlight = false
              end
            end
          end
          o:HighlightIntensely(highlight or false, "hotkey")
        end
      end
      Sleep(interactableHighlightUpdateInterval)
    end
  end)
end
if FirstLoad then
  g_MovementFX_Cursor = false
  g_MovementFX_Selection = {}
end
function SelectionAddedApplyFX(obj, pos)
  local mode_dlg = GetInGameInterfaceModeDlg()
  if not IsKindOf(mode_dlg, "IModeCommonUnitControl") then
    return
  end
  local units = IsKindOf(obj, "Unit") and {obj} or obj
  local action = g_Combat and (mode_dlg.borderline_attack and "CombatAttack" or "CombatMove") or "Exploration"
  HandleMovementTileContour(units, pos or false, action)
end
OnMsg.SelectionAdded = SelectionAddedApplyFX
function OnMsg.SelectionRemoved(obj)
  local mode_dlg = GetInGameInterfaceModeDlg()
  if not IsKindOf(mode_dlg, "IModeCommonUnitControl") and not g_Combat then
    return
  end
  HandleMovementTileContour({obj})
end
function PreciseCursorObjAreaClosestOfType(classFilter, priorityList)
  local objs, distances, _ = GetPreciseCursorObjsArea()
  local found, dist, foundPriority = false, false, false
  for i, obj in ipairs(objs) do
    local distanceToObj = distances[i] or 0
    local closer = not found or dist > distanceToObj
    if priorityList and closer then
      local thisObjPriority = priorityList[obj.class] or -1
      local higherPriority = not foundPriority or foundPriority < thisObjPriority
      found = obj
      dist = distanceToObj
      foundPriority = thisObjPriority
    elseif classFilter and IsKindOf(obj, classFilter) and closer then
      found = obj
      dist = distanceToObj
    end
  end
  return found
end
function IModeCommonUnitControl:GetUnitUnderMouse()
  local unit = PreciseCursorObjAreaClosestOfType("Unit")
  if unit then
    return unit
  end
  local unitInVoxel = GetUnitInVoxel()
  if unitInVoxel then
    return unitInVoxel
  end
  if GetUIStyleGamepad() then
    if g_Combat then
      return
    end
    local u = false
    local cursorPos = GetCursorPos()
    local vAround = GetVoxelBBox(cursorPos, 0.5, "with_z", "dont_snap")
    MapForEach(vAround, "Unit", const.efVisible, function(obj)
      if IsMerc(obj) then
        return false
      end
      if vAround:PointInside(obj:GetPos()) and (not u or IsCloser(obj, cursorPos, u)) then
        u = obj
      end
    end)
    return u
  else
    local camera = camera.GetEye()
    local cursor = GetTerrainCursor()
    for i, u in ipairs(g_Units) do
      local collided = GetBodyHitArea(camera, cursor, u)
      if collided then
        return u
      end
    end
  end
end
local lShouldBeHighlightedEnemy = function(u)
  return SelectedObj and IsKindOf(u, "Unit") and not u:IsDead() and u:IsOnEnemySide(SelectedObj)
end
local lGetHigherLowerTunnelPositions = function(p1, p2, highestPoint, lowestPoint)
  if not p1:IsValidZ() then
    p1 = p1:SetTerrainZ()
  end
  if not p2:IsValidZ() then
    p2 = p2:SetTerrainZ()
  end
  if not highestPoint or p1:z() > highestPoint:z() then
    highestPoint = p1
  end
  if not highestPoint or p2:z() > highestPoint:z() then
    highestPoint = p2
  end
  if not lowestPoint or p1:z() < lowestPoint:z() then
    lowestPoint = p1
  end
  if not lowestPoint or p2:z() < lowestPoint:z() then
    lowestPoint = p2
  end
  return highestPoint, lowestPoint
end
function IModeCommonUnitControl:FloorChangeTooltipLogic(deleteOnly)
  local cursorPos = SnapToVoxel(GetCursorPos())
  local px, py, pz = cursorPos:xyz()
  local highestPoint = false
  local lowestPoint = false
  ForEachPassSlabStep(px, py, pz, const.TunnelTypeLadder, function(x, y, z, tunnel)
    if not tunnel then
      return
    end
    local p1 = tunnel:GetPos()
    local p2 = tunnel.end_point
    highestPoint, lowestPoint = lGetHigherLowerTunnelPositions(p1, p2, highestPoint, lowestPoint)
  end)
  local eye = camera.GetEye()
  local obj = MapGetFirst(eye, cursorPos, guim, "Ladder")
  if obj then
    local p1, p2 = obj:GetTunnelPositions()
    if p1 and p2 then
      highestPoint, lowestPoint = lGetHigherLowerTunnelPositions(p1, p2, highestPoint, lowestPoint)
    end
  end
  local floor = cameraTac.GetFloor()
  local highestPointFloor = highestPoint and GetFloorOfPos(highestPoint)
  local lowestPointFloor = lowestPoint and GetFloorOfPos(lowestPoint)
  local dest = GetUIStyleGamepad() and GetTerrainGamepadCursor() or GetTerrainCursor()
  local roofPlaneSlab = GetClosestRayObj(eye, dest, const.efVisible, 0, function(obj)
    return IsKindOf(obj, "RoofPlaneSlab")
  end)
  if roofPlaneSlab and roofPlaneSlab.room and roofPlaneSlab.room.is_roof_visible then
    lowestPointFloor = -1
  end
  local text = false
  if not deleteOnly and highestPointFloor ~= lowestPointFloor then
    if highestPointFloor and floor < highestPointFloor then
      text = T(399501620165, "(<ShortcutButton('actionCamFloorUp')>) Floor Up")
    end
    if lowestPointFloor and floor > lowestPointFloor then
      text = T(509798634721, "(<ShortcutButton('actionCamFloorDown')>) Floor Down")
    end
  end
  local delete = not text or deleteOnly
  SetAPIndicator(not delete and 0, "floor-change", text, "appending", true)
end
local no_extreme_range_indicator = {
  Overwatch = true,
  ThrowGrenadeA = true,
  ThrowGrenadeB = true,
  ThrowGrenadeC = true,
  ThrowGrenadeD = true,
  DoubleTossA = true,
  DoubleTossB = true,
  DoubleTossC = true,
  DoubleTossD = true,
  MarkTarget = true
}
function ShouldUseMarkTarget(attacker, target)
  if not (not g_Combat and IsKindOf(attacker, "Unit") and IsKindOf(target, "Unit") and attacker:IsOnEnemySide(target)) or target:IsDead() then
    return
  end
  if attacker.marked_target_attack_args and attacker.marked_target_attack_args.target == target then
    return
  end
  local weapon = attacker:GetActiveWeapons() or attacker:GetActiveWeapons("UnarmedWeapon")
  if not IsKindOfClasses(weapon, "MeleeWeapon", "UnarmedWeapon") then
    return
  end
  local voxels = GetMeleeRangePositions(attacker)
  local pos = target:GetPos()
  local ppos = point_pack(SnapToPassSlab(pos) or pos)
  if not table.find(voxels, ppos) and CombatActions.MarkTarget:GetUIState({attacker}) == "enabled" then
    return true
  end
end
function IModeCommonUnitControl:UpdateTarget(pos)
  self.target_pos = false
  local enemy_pos
  local mouse_obj = pos and self:GetUnitUnderMouse()
  local freeAimMode = not self.crosshair and (IsKindOf(self, "IModeCombatFreeAim") or IsKindOf(self, "IModeCombatAreaAim"))
  freeAimMode = freeAimMode or self.crosshair and self.crosshair.context.free_aim
  local mouseUIFocus = self.desktop.last_mouse_target
  if mouseUIFocus and not mouse_obj and not GetUIStyleGamepad() then
    local n = self.desktop.last_mouse_target:ResolveId("node")
    if IsKindOf(n, "CombatBadge") then
      mouse_obj = n.context
    end
  end
  if not cameraTac.IsActive() then
    mouse_obj = false
  end
  if IsKindOf(mouse_obj, "Unit") and mouse_obj.visible and not mouse_obj:IsDead() then
    if not freeAimMode or mouse_obj ~= SelectedObj then
      self.potential_target = mouse_obj
      self.target_pos = mouse_obj:GetPos()
      self.potential_target_is_enemy = lShouldBeHighlightedEnemy(mouse_obj)
    else
      self.potential_target = false
    end
  elseif pos then
    local pass_pos = GetPassSlab(pos)
    self.potential_target = false
    self.potential_target_is_enemy = false
    self.penalty = 0
    if pass_pos then
      self.target_pos = pass_pos
      local unit = GetUnitInVoxel(pass_pos)
      if unit and not unit:IsDead() then
        self.potential_target = unit
        self.potential_target_is_enemy = lShouldBeHighlightedEnemy(unit)
      end
    end
  end
  local updatePenalty = self.potential_target and self.potential_target_is_enemy or self.potential_interactable_action and self.potential_interactable_action.id == "Interact_Attack" or freeAimMode and self.potential_target ~= SelectedObj or self.target and not self.potential_target
  local freeAttackTarget
  if pos and SelectedObj and updatePenalty then
    if IsKindOf(SelectedObj:GetActiveWeapons(), "MeleeWeapon") and self.action and self.action.id == "KnifeThrow" then
      local target = self.potential_target or self.target or GetUnitInVoxel(GetPassSlab(pos))
      if freeAimMode and SelectedObj:GetPos():Dist(target and target:GetPos() or pos) > CombatActions.KnifeThrow:GetMaxAimRange(SelectedObj, SelectedObj:GetActiveWeapons()) * const.SlabSizeX then
        self.penalty = -100
      else
        self.penalty = 0
      end
    elseif IsKindOf(SelectedObj:GetActiveWeapons(), "MeleeWeapon") or not SelectedObj:GetActiveWeapons() then
      local action = rawget(self, "action") or SelectedObj:GetDefaultAttackAction()
      local weapon = action:GetAttackWeapons(SelectedObj)
      local target = self.potential_target or self.target or GetUnitInVoxel(GetPassSlab(pos))
      if IsKindOf(self, "IModeCombatFreeAim") then
        local _, target_obj = self:GetFreeAttackTarget(self.potential_target, self.attacker:GetPos())
        target = IsValid(target_obj) and target_obj
      end
      freeAttackTarget = target
      local inRange = SelectedObj:CanAttack(target or pos, weapon, action, 0, nil, nil, freeAimMode)
      if not inRange then
        self.penalty = -100
      end
    elseif not SelectedObj:GetActiveWeapons() then
      self.penalty = 0
    else
      local target_pos
      local target_unit = self.potential_target or self.target
      if not IsValid(target_unit) then
        target_pos = GetPassSlab(pos) or SnapToVoxel(pos)
        target_unit = GetUnitInVoxel(target_pos)
      end
      local distanceToUnit = SelectedObj:GetVisualDist(target_unit or target_pos:IsValidZ() and target_pos or target_pos:SetTerrainZ())
      local wep = SelectedObj:GetActiveWeapons()
      self.penalty = wep:GetAccuracy(distanceToUnit) - 100
      if self.action and IsValid(target_unit) and not freeAimMode then
        if self.action_targets then
          self.action_targets = self.action:GetTargets({
            SelectedObj
          }) or empty_table
        end
        if not table.find(self.action_targets, target_unit) then
          self.penalty = -200
        end
      end
    end
    local action = rawget(self, "action") or SelectedObj:GetDefaultAttackAction()
    if action.group == "FiringModeMetaAction" then
      action = GetUnitDefaultFiringModeActionFromMetaAction(SelectedObj, action)
    end
    if not freeAimMode and ShouldUseMarkTarget(SelectedObj, mouse_obj) then
      action = CombatActions.MarkTarget
    end
    local apCost = action:GetAPCost(SelectedObj, {target = mouse_obj})
    if not rawget(self, "disable_mouse_indicator") and (freeAimMode or lShouldBeHighlightedEnemy(mouse_obj)) then
      if freeAimMode then
        if self.action and self.action.id == "Overwatch" then
          SetAPIndicator(0 < apCost and apCost or false, "attack")
        else
          SetAPIndicator(0 < apCost and apCost or false, "attack", T(333335408841, "Free Aim"))
          if action.ActionType == "Melee Attack" then
            if not freeAttackTarget then
              SetAPIndicator(1, "attack", T(316692410666, "No Target"), "appending")
              self.penalty = 0
            elseif freeAttackTarget == SelectedObj then
              SetAPIndicator(1, "attack", T(638642719736, "Invalid Target"), "appending")
              self.penalty = 0
            end
          end
        end
      elseif action.id == "MeleeAttack" and IsKindOf(self, "IModeExploration") then
        local weapon = action:GetAttackWeapons(SelectedObj)
        local can_attack, reason = SelectedObj:CanAttack(mouse_obj, weapon, action)
        if can_attack then
          SetAPIndicator(0 < apCost and apCost or false, "attack")
        else
          SetAPIndicator(0 < apCost and apCost or false, "attack")
          SetAPIndicator(1, "attack", reason, "appending")
        end
      elseif action.id == "MarkTarget" then
        SetAPIndicator(1, "attack", T(163504056969, "Prepare Takedown"), "appending")
      elseif not action or action.AimType ~= "melee-charge" then
        SetAPIndicator(0 < apCost and apCost or false, "attack")
      end
      self.penalty = self.penalty or 0
      if self.penalty <= -200 then
        SetAPIndicator(1, "range", T(853501212617, "NO SIGHT"), "appending")
      elseif self.penalty <= -100 and not no_extreme_range_indicator[action.id] then
        SetAPIndicator(1, "range", T(239610127119, "OUT OF RANGE"), "appending")
      else
        SetAPIndicator(false, "range")
      end
    end
  else
    SetAPIndicator(false, "attack")
    SetAPIndicator(false, "range")
  end
  self:UpdateCursorImage()
  local attackMode = IsKindOf(self, "IModeCombatAttackBase")
  if (not mouseUIFocus or not mouseUIFocus:IsWithin(self)) and (not attackMode or not self.target) and not next(g_ShowTargetBadge) then
    SetActiveBadgeExclusive(self.potential_target and self.potential_target.ui_badge and self.potential_target)
  end
  local myTurn = Selection and 0 < #Selection and (not g_Combat or IsNetPlayerTurn())
  self:FloorChangeTooltipLogic(not myTurn)
  self.target_pos_has_unit = false
  self.target_pos_occupied = false
  local selUnit = Selection[1]
  local selUnitTeam = selUnit and selUnit.team
  if self.target_pos and selUnitTeam then
    local unitInVoxel = GetUnitInVoxel(self.target_pos)
    if unitInVoxel and table.find(selUnitTeam.units, unitInVoxel) or HasVisibilityTo(selUnitTeam, unitInVoxel) then
      self.target_pos_has_unit = unitInVoxel
    end
    local unitOccupyingVoxel = GetOccupiedBy(self.target_pos, selUnit)
    if unitOccupyingVoxel ~= selUnit and (unitOccupyingVoxel and table.find(selUnitTeam.units, unitOccupyingVoxel) or HasVisibilityTo(selUnitTeam, unitOccupyingVoxel)) then
      self.target_pos_occupied = unitOccupyingVoxel
    end
  end
  local tx, ty, tz = self:GetEffectsTargetVoxel()
  self.effects_target_pos = myTurn and tx and point(SnapToVoxel(VoxelToWorld(tx, ty, tz)))
  if self.effects_target_pos_last ~= self.effects_target_pos then
    Msg("EffectsTargetPosUpdated", self, self.effects_target_pos)
  end
  self:UpdateTargetCovers()
  self:UpdateLinesOfFire()
  self.effects_target_pos_last = self.effects_target_pos
  return self.potential_target_is_enemy
end
function IModeCommonUnitControl:ClearTargetCovers()
  self:ClearMemberObjArray("cover_objs", "keep")
end
function IModeCommonUnitControl:UpdateTargetCovers(force)
  if not self:ShouldShowEffects("ShowCovers") then
    self:ClearTargetCovers()
    return
  end
  if not force and self.effects_target_pos and self.effects_target_pos == self.effects_target_pos_last then
    return
  end
  self:ClearTargetCovers()
  if self.effects_target_pos then
    self:ShowCoversShields(self.effects_target_pos, self.potential_target_is_enemy and self.potential_target or false)
  end
end
function GetRangeBasedMouseCursor(accuracy, action, willAttack)
  if action and action.ActionType == "Melee Attack" then
    return "UI/Cursors/Attack_melee.tga"
  end
  if willAttack then
    local igi = GetInGameInterfaceModeDlg()
    if igi and igi.crosshair then
      local aim = igi.crosshair.aim
      if aim == 0 then
        return "UI/Cursors/Attack.tga"
      elseif aim == igi.crosshair.maxAimPossible then
        return "UI/Cursors/Attack_2.tga"
      else
        return "UI/Cursors/Attack_1.tga"
      end
    end
    return "UI/Cursors/Attack.tga"
  end
  if not accuracy or accuracy == 0 or action and action.id == "Overwatch" then
    return "UI/Cursors/Range.tga"
  elseif accuracy <= -100 then
    return "UI/Cursors/Range_2.tga"
  else
    return "UI/Cursors/Range_1.tga"
  end
  return "UI/Cursors/Hand.tga"
end
function IModeCommonUnitControl:UpdateCursorImage()
  local movement = IsKindOf(self, "IModeCombatMovement")
  local exploration = IsKindOf(self, "IModeExploration")
  local canInteract = movement or exploration
  local freeAimMode = not self.crosshair and (IsKindOf(self, "IModeCombatFreeAim") or IsKindOf(self, "IModeCombatAreaAim"))
  freeAimMode = freeAimMode or self.crosshair and self.crosshair.context.free_aim
  if self.action == CombatActions.Bandage then
    if self.potential_target and CanBandageUI(SelectedObj, {
      target = self.potential_target
    }) then
      self.desktop:SetMouseCursor("UI/Cursors/Healing_on.tga")
    else
      self.desktop:SetMouseCursor("UI/Cursors/Healing_off.tga")
    end
  elseif canInteract and IsKindOf(self.potential_interactable, "Interactable") then
    local action = self.potential_interactable_action
    if action == CombatActions.Interact_Talk or action == CombatActions.Interact_Banter then
      self.desktop:SetMouseCursor("UI/Cursors/Speaking.tga")
    elseif action and action.id == "Interact_Attack" then
      local action = not self.action and SelectedObj and SelectedObj:GetDefaultAttackAction()
      local cursor = GetRangeBasedMouseCursor(self.penalty, action)
      self.desktop:SetMouseCursor(cursor)
    else
      self.desktop:SetMouseCursor("UI/Cursors/Interact.tga")
    end
  elseif self.potential_target and self.potential_target_is_enemy or freeAimMode then
    local action = not self.action and SelectedObj and SelectedObj:GetDefaultAttackAction()
    local clickWillAttack = self.crosshair and self.crosshair.context.target == self.potential_target
    local cursor = GetRangeBasedMouseCursor(self.penalty, action, clickWillAttack)
    self.desktop:SetMouseCursor(cursor)
  elseif movement and self.movement_mode then
    if self.target_path then
      self.desktop:SetMouseCursor("UI/Cursors/Travel.tga")
    else
      self.desktop:SetMouseCursor("UI/Cursors/Impassable.tga")
    end
  elseif exploration and not GetDialog("SatelliteCabinet") and not self.potential_target then
    local inBadge = terminal.desktop.last_mouse_target and terminal.desktop.last_mouse_target["xbadge-instance"]
    if inBadge then
      return
    end
    if GetCursorPassSlab() then
      self.desktop:SetMouseCursor("UI/Cursors/Travel.tga")
    else
      self.desktop:SetMouseCursor("UI/Cursors/Impassable.tga")
    end
  else
    self.desktop:SetMouseCursor()
  end
end
function IModeCommonUnitControl:OnMousePos(pt)
  local meFocused = self:IsWithin(self.desktop.last_mouse_target)
  local overBadge = GetParentOfKind(self.desktop.last_mouse_target, "BadgeHolderDialog")
  local showIndicator = meFocused or overBadge or IsCombatActionForAlly(self.action)
  if self.crosshair then
    showIndicator = false
  end
  local apIndicator = self:ResolveId("idApIndicator")
  if apIndicator and showIndicator ~= apIndicator.visible then
    apIndicator:SetVisible(showIndicator)
  end
  self.show_world_ui = showIndicator
end
function IModeCommonUnitControl:ShouldShowEffects(setting)
  if CheatEnabled("IWUIHidden") then
    return false
  end
  if IsKindOf(self, "IModeCombatBase") and self.crosshair then
    return false
  end
  if not Selection[1] or not Selection[1]:CanBeControlled() then
    return false
  end
  if IsSetpiecePlaying() then
    return false
  end
  local value = GetAccountStorageOptionValue(setting)
  setting = type(value) == "boolean" and value and "Always" or value
  local show = false
  if setting == "Always" then
    return true
  elseif setting == "Combat" and IsKindOf(self, "IModeCombatBase") and self.effects_target_pos and GetPassSlabXYZ(self.effects_target_pos) then
    show = true
  end
  if show then
    local movementModeNoTarget = self.movement_mode and not self.potential_target
    local unitTarget = IsKindOf(self, "IModeCombatMovement") and IsKindOf(self.potential_target, "Unit")
    show = movementModeNoTarget or unitTarget
  end
  return show
end
function IModeCommonUnitControl:GetEffectsTargetVoxel(pos)
  pos = pos or self.target_pos
  if not pos then
    return
  end
  local wx, wy, wz = pos:xyz()
  wz = wz or terrain.GetHeight(wx, wy)
  local gx, gy, gz = WorldToVoxel(wx, wy, wz)
  while true do
    local x, y, z = VoxelToWorld(gx, gy, gz)
    if wz > z then
      gz = gz + 1
    else
      break
    end
  end
  return gx, gy, gz
end
local cover_shields = {
  [const.CoverLow] = "IwCoverHalf",
  [const.CoverHigh] = "IwCoverFull"
}
function IModeCommonUnitControl:ShowCoversShields(world_pos, stance, attack_pos, force_inactive)
  local covers = GetCoversAt(world_pos)
  if not covers then
    return
  end
  stance = stance or self.targeting_blackboard and self.targeting_blackboard.playerToDoStanceAtEnd or Selection[1].stance
  local attack_dir
  if attack_pos then
    if attack_pos:Dist(world_pos) > 0 then
      attack_dir = SetLen(world_pos - attack_pos, guim)
    else
      attack_dir = Rotate(point(guim, 0, 0), Selection[1]:GetAngle())
    end
  end
  for i = 0, 3 do
    local angle = i * 90 * 60
    local cover = covers[angle]
    local cover_class = cover and cover_shields[cover]
    if attack_dir then
      local dir = Rotate(point(guim, 0, 0), angle)
      if 0 > Dot2D(dir, attack_dir) then
        cover_class = false
      end
    end
    if cover_class then
      do
        local colormod = const.CoverUIColorModifier
        if force_inactive or cover == const.CoverLow and stance == "Standing" then
          colormod = const.InactiveCoverUIColorModifier
          cover_class = "IwCoverBroken"
        end
        local showAlways = GetAccountStorageOptionValue("ShowCovers") and GetAccountStorageOptionValue("ShowCovers") == "Always"
        if not self.potential_target_is_enemy and (IsKindOf(self, "IModeCombatMovement") or IsKindOf(self, "IModeCombatMovingAttack") or showAlways) then
          local obj = PlaceObject(cover_class)
          table.insert(self.cover_objs, obj)
          obj:SetEnumFlags(const.efVisible)
          obj:SetAngle(angle)
          obj:SetScale(70)
          obj:SetColorModifier(colormod)
          obj:SetPos(world_pos)
        end
        if cover_class == "IwCoverHalf" or cover_class == "IwCoverFull" then
          CreateGameTimeThread(function()
            local delayTime = 0
            Sleep(delayTime)
            local mov_avatar = self.targeting_blackboard and self.targeting_blackboard.movement_avatar
            if not mov_avatar and not self.potential_target_is_enemy then
              return
            end
            local wallParticle = self.potential_target_is_enemy and PlaceParticles("UI_CoverGlow_Idle_Enemy") or PlaceParticles("UI_CoverGlow_Idle")
            table.insert(self.cover_objs, wallParticle)
            wallParticle:SetAngle(angle + 5400)
            local offset
            local offsetNumber = const.SlabSizeX / 2
            if angle == 0 then
              offset = point(-offsetNumber, 0, 0)
            elseif angle == 5400 then
              offset = point(0, -offsetNumber, 0)
            elseif angle == 10800 then
              offset = point(offsetNumber, 0, 0)
            elseif angle == 16200 then
              offset = point(0, offsetNumber, 0)
            end
            wallParticle:SetPos(world_pos + offset)
          end)
        end
      end
    end
  end
end
function GetCoverShieldBonusEffect(unit, stance, side)
  local posForEffect
  if IsKindOf(unit, "Unit") then
    posForEffect = unit:GetPos()
  else
    posForEffect = unit
  end
  local covers = GetCoversAt(posForEffect)
  if not covers then
    return
  end
  local unitStance = stance or unit.stance
  local side = side or unit.team.side
  local isEnemy = side == "enemy1" or side == "enemy2" or side == "enemyNeutral"
  for i = 0, 3 do
    local angle = i * 90 * 60
    local cover = covers[angle]
    local cover_class = cover and cover_shields[cover]
    if cover_class then
      if cover == const.CoverLow and unitStance == "Standing" then
        cover_class = "IwCoverBroken"
      end
      if cover_class == "IwCoverHalf" or cover_class == "IwCoverFull" then
        CreateGameTimeThread(function()
          local delayTime = 0
          Sleep(delayTime)
          local shieldCoverConfirm = isEnemy and PlaceParticles("UI_CoverGlow_Confirm_Enemy") or PlaceParticles("UI_CoverGlow_Confirm")
          shieldCoverConfirm:SetAngle(angle + 5400)
          local offset
          local offsetNumber = const.SlabSizeX / 2
          if angle == 0 then
            offset = point(-offsetNumber, 0, 0)
          elseif angle == 5400 then
            offset = point(0, -offsetNumber, 0)
          elseif angle == 10800 then
            offset = point(offsetNumber, 0, 0)
          elseif angle == 16200 then
            offset = point(0, offsetNumber, 0)
          end
          shieldCoverConfirm:SetPos(posForEffect + offset)
        end)
      end
    end
  end
end
function OnMsg.UnitAnyMovementStart(unit, target, toDoStance)
  if unit:IsMerc() then
    GetCoverShieldBonusEffect(target, toDoStance or unit.stance, "player")
  end
end
function IModeCommonUnitControl:ClearLinesOfFire()
  for _, o in ipairs(self.fx_lof or empty_table) do
    DoneObject(o)
  end
  self.fx_lof = false
end
DefineClass.CRM_VisionLinePreset = {
  __parents = {"CRMaterial"},
  group = "VisionLinePreset",
  shader_id = "vision_line",
  properties = {
    {
      uniform = true,
      id = "fill_width",
      editor = "number",
      default = 200,
      scale = 1000,
      min = 0,
      max = 1000,
      slider = true
    },
    {
      uniform = true,
      id = "fill_color",
      editor = "color",
      default = RGB(0, 255, 0)
    },
    {
      uniform = true,
      id = "glow_color",
      editor = "color",
      default = RGB(255, 255, 255)
    },
    {
      uniform = true,
      id = "anim_speed",
      editor = "number",
      scale = 1000,
      default = 1000,
      slider = true,
      min = 0,
      max = 10000
    },
    {
      uniform = true,
      id = "glow_density",
      editor = "number",
      scale = 1000,
      default = 1000,
      slider = true,
      min = 0,
      max = 1000
    },
    {
      uniform = true,
      id = "glow_segment",
      editor = "number",
      scale = 1000,
      default = 1000,
      slider = true,
      min = 0,
      max = 100000000
    },
    {
      uniform = true,
      id = "end_fade_distance",
      editor = "number",
      scale = 1000,
      default = 1000,
      slider = true,
      min = 0,
      max = 10000000
    },
    {
      uniform = true,
      id = "end_fade_falloff",
      editor = "number",
      scale = 1000,
      default = 3000,
      slider = true,
      min = 0,
      max = 10000
    },
    {
      uniform = true,
      id = "length",
      editor = "number",
      scale = 1000,
      default = 1,
      no_edit = true
    },
    {
      uniform = true,
      id = "half_width",
      editor = "number",
      scale = 1000,
      default = 250,
      help = "Generated geometry width"
    }
  }
}
function IModeCommonUnitControl:UpdateLinesOfFire(force)
  local show = self:ShouldShowEffects("ShowLOF") and not IsKindOf(self, "IModeCombatMovingAttack") and not CurrentActionCamera
  local displayLinesPotentialTarget = false
  local attacker = Selection[1]
  if attacker then
    displayLinesPotentialTarget = self.potential_target == SelectedObj
  end
  if not displayLinesPotentialTarget and show then
    show = self.target_path
  end
  show = show and (g_UIAttackCachePredicted or displayLinesPotentialTarget)
  show = show and attacker and attacker:IsIdleCommand()
  if not show then
    self:ClearLinesOfFire()
    return
  end
  if show and not self.fx_lof then
    force = true
  end
  if self.effects_target_pos == self.effects_target_pos_last and not force then
    return
  end
  local unitInVoxel = self.target_pos_has_unit
  local sectorOccupied = self.target_pos_occupied
  if (sectorOccupied or unitInVoxel) and not displayLinesPotentialTarget then
    return
  end
  self:ClearLinesOfFire()
  self.fx_lof = {}
  local passableVox = self.effects_target_pos
  if not passableVox then
    return
  end
  local passableVoxZ = false
  if not passableVox:IsValidZ() then
    passableVoxZ = terrain.GetHeight(passableVox:x(), passableVox:y())
  else
    passableVoxZ = passableVox:z()
  end
  local enemiesGoodAttack = UIGetEnemiesGoodAttack()
  for enemy, isGoodAttack in pairs(enemiesGoodAttack) do
    if isGoodAttack then
      local color = Mesh.ColorFromTextStyle("LineOfFire")
      local x, y, z = enemy:GetPosXYZ()
      z = enemy:IsValidZ() and z or terrain.GetHeight(x, y)
      local dir = point(x - passableVox:x(), y - passableVox:y(), z - passableVoxZ)
      local length = dir:Len()
      local meshPtr = pstr("")
      CRTrail_AppendLineSegment(meshPtr, point(passableVox:x(), passableVox:y(), passableVoxZ), point(x, y, z), false, false, false)
      local fx_lof = PlaceObject("Mesh")
      fx_lof:SetMeshFlags(const.mfWorldSpace)
      table.insert(self.fx_lof, fx_lof)
      local mat = CRM_VisionLinePreset:GetById("DefaultVision")
      mat = mat:Clone()
      mat.length = length
      fx_lof:SetCRMaterial(mat)
      fx_lof:SetPos(passableVox:SetZ(passableVoxZ + self.fx_lof_offset))
      fx_lof:SetMesh(meshPtr)
    end
  end
end
function IModeCommonUnitControl:ToggleHide()
  local state = CombatActions.Hide:GetUIState(Selection)
  local action = state == "hidden" and CombatActions.Reveal or CombatActions.Hide
  if action:GetUIState(Selection) == "enabled" then
    action:UIBegin(Selection)
  end
end
function IModeCommonUnitControl:SetVisible(vis, ...)
  GamepadUnitControl.SetVisible(self, vis, ...)
  if vis then
    local combatLogButton = self.idCombatLogButton
    if combatLogButton then
      combatLogButton:InvalidateLayout()
    end
  end
end
function UpdateTakeCoverAction()
  local dlg = GetInGameInterfaceModeDlg()
  if not IsKindOf(dlg, "IModeCommonUnitControl") then
    return
  end
  local btn = dlg:ResolveId("TakeCover")
  if btn then
    btn:SetContext(btn.context)
  end
end
local UpdateTakeCoverOnUnitEvent = function()
  UpdateTakeCoverAction()
end
OnMsg.UnitMovementDone = UpdateTakeCoverOnUnitEvent
OnMsg.CombatActionEnd = UpdateTakeCoverOnUnitEvent
function OnMsg.GatherFXActions(list)
  table.insert(list, "Move")
end
function OnMsg.OptionsApply()
  ObjModified(SelectedObj)
end
function ForceUpdateCommonUnitControlUI(recreate, igiMOverride)
  local mode = igiMOverride or GetInGameInterfaceModeDlg()
  local context_window = mode and mode:ResolveId("idCommonUnitControl")
  if context_window then
    context_window:OnContextUpdate(nil, recreate)
  end
end
function OnMsg.RepositionStart()
  ObjModified(Selection)
  SetInGameInterfaceMode("IModeCombatMovement")
end
function OnMsg.SetpieceStarting()
  local dlg = GetInGameInterfaceModeDlg()
  if IsKindOf(dlg, "IModeCombatAttackBase") then
    SetInGameInterfaceMode("IModeCombatMovement")
  end
end
function OnMsg.RepositionEnd()
  ObjModified(Selection)
end
OnMsg.CombatStarting = ForceUpdateCommonUnitControlUI
function OnMsg.TurnStart()
  ObjModified(Selection)
end
function OnMsg.CombatActionEnd(unit)
  if unit == SelectedObj then
    ObjModified(Selection)
  end
end
function OnMsg.SelectionChange(sel)
  if not Selection or #Selection == 0 then
    return
  end
  local unit = Selection[1]
  if not IsKindOf(unit, "Unit") then
    return
  end
  local dlg = GetInGameInterfaceModeDlg()
  if IsKindOf(dlg, "IModeCombatAttackBase") then
    SetInGameInterfaceMode("IModeCombatMovement")
    return
  end
  if IsKindOf(dlg, "IModeCommonUnitControl") then
    dlg:ClosePopup()
  end
end
DefineClass.StealthVignetteDialog = {
  __parents = {"XImage", "XDialog"},
  Dock = "box",
  ImageFit = "stretch",
  Image = "UI/Vignette",
  ZOrder = -5,
  Visible = false,
  FocusOnOpen = "",
  FadeInTime = 800,
  FadeOutTime = 500
}
local lUpdateStealthVignette = function()
  local targetTransparency = 255
  local hidden = false
  local prone = false
  if Selection and #Selection > 0 then
    for i = 1, #Selection do
      local u = Selection[i]
      hidden = hidden or u:HasStatusEffect("Hidden")
      prone = prone or u.stance == "Prone"
    end
  end
  local targetTransparency = 255
  if hidden and prone then
    targetTransparency = 0
  elseif hidden then
    targetTransparency = 100
  end
  local vignetteDialog = GetDialog("StealthVignetteDialog")
  if not vignetteDialog then
    OpenDialog("StealthVignetteDialog", GetInGameInterface())
    vignetteDialog = GetDialog("StealthVignetteDialog")
  end
  local vignetteOn = vignetteDialog:GetTransparency()
  if targetTransparency == vignetteOn then
    return
  end
  vignetteDialog:SetTransparency(targetTransparency, 400)
end
if FirstLoad then
  UIRebuildSpam = false
end
function DbgUIRebuild(where)
  print("ui rebuild at", where)
end
function OnMsg.ExplorationComputedVisibility()
  ObjModified("combat_bar_enemies")
end
function OnMsg.CombatComputedVisibility()
  if #Selection == 0 then
    return
  end
  ObjModified("combat_bar_enemies")
end
function OnMsg.SelectionChange()
  if g_Combat then
    return
  end
  ObjModified("hud_squads")
  ObjModified("combat_bar_enemies")
end
function OnMsg.SelectedObjChange()
  if not g_Combat then
    return
  end
  ObjModified("hud_squads")
  ObjModified(Selection)
  ObjModified("combat_bar_enemies")
end
function OnMsg.CloseSatelliteView()
  ObjModified("hud_squads")
end
function OnMsg.TeamsUpdated()
  ObjModified("hud_squads")
end
OnMsg.UnitStealthChanged = lUpdateStealthVignette
OnMsg.SelectionChange = lUpdateStealthVignette
OnMsg.UnitStanceChanged = lUpdateStealthVignette
function OnMsg.GameExitEditor()
  local igi = GetInGameInterfaceModeDlg()
  if igi and igi.crosshair then
    SelectObj(igi.crosshair.context.attacker)
    return
  end
  SelectObj(nil)
end
function OnMsg.UnitDied(unit)
  if unit ~= SelectedObj then
    return
  end
  if g_Combat then
    if g_AIExecutionController then
      CreateMapRealTimeThread(function()
        while g_AIExecutionController do
          WaitMsg("ExecutionControllerDeactivate", 500)
        end
        if SelectedObj ~= unit or not g_Combat then
          return
        end
        g_Combat:NextUnit(nil, "force")
      end)
      return
    end
    g_Combat:NextUnit(nil, "force")
  else
    local dlg = GetInGameInterfaceModeDlg()
    if IsKindOf(dlg, "IModeExploration") then
      dlg:NextUnit(nil, true)
    end
  end
end
function GetReloadOptionsForWeapon(weapon, unit, skipSubWeapon)
  if not unit and #Selection == 0 then
    return {}
  end
  unit = unit or Selection[1]
  local weapons = {}
  if not skipSubWeapon and IsKindOf(weapon, "Firearm") then
    for slot, item in sorted_pairs(weapon.subweapons) do
      if IsKindOf(item, "Firearm") then
        weapons[#weapons + 1] = item
      end
    end
  end
  weapons[#weapons + 1] = weapon
  local options = {}
  local errors = {}
  for _, wpn in ipairs(weapons) do
    local availableAmmo = unit:GetAvailableAmmos(wpn, nil, "unique")
    local available, err = IsWeaponAvailableForReload(wpn, availableAmmo)
    if available then
      for i, ammo in ipairs(availableAmmo) do
        options[#options + 1] = {weapon = wpn, ammo = ammo}
      end
    else
      errors[wpn] = err
    end
  end
  return options, errors
end
function GetQuickReloadWeaponAndAmmo(parent, weapon)
  local wep = weapon or parent:ResolveId("node"):ResolveId("node").context
  if not wep then
    return false
  end
  local unit = SelectedObj
  if not unit then
    return false
  end
  local _, __, wl = unit:GetActiveWeapons()
  local idx = table.find(wl, wep)
  local ammos = unit:GetAvailableAmmos(wep, nil, "unique")
  local can, err = IsWeaponAvailableForReload(wep, ammos)
  if not can then
    return false, err
  end
  if can and err == AttackDisableReasons.FullClipHaveOther then
    return false, err
  end
  local currentAmmo = wep.ammo and wep.ammo.class
  if currentAmmo then
    local haveMoreFromCurrent = table.find(ammos, "class", currentAmmo)
    currentAmmo = haveMoreFromCurrent and ammos[haveMoreFromCurrent] or ammos[1]
  else
    currentAmmo = ammos[1]
  end
  return idx, currentAmmo
end
function QuickReloadButton(parent, weapon, delayed_fx)
  local unit = SelectedObj
  local wepIdx, ammo = GetQuickReloadWeaponAndAmmo(parent, weapon)
  if not wepIdx then
    return
  end
  CombatActions.Reload:Execute({unit}, {
    weapon = wepIdx,
    target = ammo.class,
    delayed_fx = delayed_fx,
    item_id = weapon and weapon.id
  })
  return true
end
if FirstLoad then
  UICombatBarShown = true
  UICombatBarShowLast = true
  UIHidingThread = false
end
function OnMsg.IGIModeChanging(prev, new)
  UICombatBarShown = true
  local dlg = GetInGameInterfaceModeDlg()
  local bar = dlg and dlg:ResolveId("idBottomBar")
  if bar then
    ApplyCombatBarHidingAnimation(bar, true, true)
    if new == "IModeExploration" then
      ApplyCombatBarHidingAnimation(bar, false)
    end
  end
end
function OnMsg.GameOptionsChanged()
  local dlg = GetInGameInterfaceModeDlg()
  local bar = dlg and dlg:ResolveId("idBottomBar")
  if bar then
    ApplyCombatBarHidingAnimation(bar, true, true)
  end
end
local lHideCombatBarAfter = 200
local lCombatBarAnimation = 150
function _ENV:ApplyCombatBarHidingAnimation(show, instantClose)
  if UICombatBarShowLast == show then
    return
  end
  UICombatBarShowLast = show
  if IsValidThread(UIHidingThread) then
    DeleteThread(UIHidingThread)
    UIHidingThread = false
  end
  if LastLoadedOrLoadingIMode ~= "IModeExploration" then
    show = true
  end
  if not GetAccountStorageOptionValue("HideActionBar") or CurrentTutorialPopup and CurrentTutorialPopup.attachedToAB then
    show = true
  end
  if UICombatBarShown == show then
    return
  end
  local lRunFunc = function(func)
    func()
    return false
  end
  ToggleTargetIconsTransparency(self, show)
  local closeTime = instantClose and 0 or lHideCombatBarAfter
  local threadFunc = instantClose and lRunFunc or CreateRealTimeThread
  UIHidingThread = threadFunc(function()
    if not show then
      Sleep(closeTime)
    end
    UICombatBarShown = show
    ObjModified("UICombatBarShown")
    if self.window_state == "destroying" then
      return
    end
    local b = self.box
    local mod = {
      id = "combat_bar_hiding",
      type = const.intRect,
      duration = lCombatBarAnimation,
      originalRect = b,
      targetRect = sizebox(b:minx(), UIL.GetScreenSize():y(), b:sizex(), b:sizey())
    }
    if show then
      mod.flags = const.intfInverse
    end
    self:AddInterpolation(mod)
  end)
  return show and lCombatBarAnimation or closeTime
end
function ToggleTargetIconsTransparency(bar, show)
  if not bar then
    return
  end
  local idTargets = bar.parent:ResolveId("idTargets")
  if not idTargets then
    return
  end
  if show then
    idTargets:SetTransparency(0)
  else
    idTargets:SetTransparency(50)
  end
end
GameVar("gv_LastPartialSquadSelection", {})
function ToggleAllUnitsSelectionInSquad(selectAllOnly)
  local igi = GetInGameInterfaceModeDlg()
  if IsKindOf(igi, "IModeDeployment") and gv_DeploymentStarted then
    local units = GetCurrentDeploymentSquadUnits()
    SelectionSet(units)
    return
  end
  if not IsKindOf(igi, "IModeExploration") then
    return
  end
  local team = GetFilteredCurrentTeam()
  if WholeTeamSelected() and not selectAllOnly then
    if #gv_LastPartialSquadSelection > 0 and gv_LastPartialSquadSelection[1].Squad == team.units[1].Squad then
      igi:SelectUnits(gv_LastPartialSquadSelection)
    else
      igi:SelectUnits({
        team.units[1]
      })
    end
  else
    if PartialSquadSelected() then
      gv_LastPartialSquadSelection = table.copy(Selection)
    else
      gv_LastPartialSquadSelection = {}
    end
    igi:SelectUnits(team.units)
  end
end
function PartialSquadSelected()
  if g_Combat then
    return true
  end
  local team = GetFilteredCurrentTeam()
  if #Selection >= #team.units then
    return false
  end
  for i, s in ipairs(Selection) do
    if not table.find(team.units, s) then
      return false
    end
  end
  return true
end
function TFormat.GamepadSelectToggleDynamicText()
  if WholeTeamSelected() then
    return T(760771207071, "Select Single Merc")
  end
  return T(864206208463, "Select All")
end
function OnMsg.UnitPropertiesSynced()
  ObjModified("hud_squads")
end
function OnMsg.CreateRolloverWindow()
  ObjModified("RolloverWin")
end
function OnMsg.DestroyRolloverWindow()
  ObjModified("RolloverWin")
end
local lStancesInOrder = {
  "Prone",
  "Crouch",
  "Standing"
}
l_StanceBufferingThreads = false
function lChangeStanceForUnit(unit, nextStance, wait)
  if wait then
    WaitCombatActionsPostAction(unit)
  end
  local nextStanceAction = nextStance and CombatActions["Stance" .. nextStance]
  if nextStanceAction and nextStanceAction:GetUIState({unit}) == "enabled" then
    nextStanceAction:UIBegin({unit})
  end
end
function ChangeStanceExploration(direction)
  if not l_StanceBufferingThreads then
    l_StanceBufferingThreads = {}
  end
  for i, unit in ipairs(Selection) do
    local curStance = unit.stance
    local bufferData = l_StanceBufferingThreads[unit]
    local bufferedThread = false
    if bufferData and IsValidThread(bufferData.thread) then
      curStance = bufferData.stance
      bufferedThread = true
    end
    local stanceIdx = table.find(lStancesInOrder, curStance)
    local directionMod = direction == "up" and 1 or -1
    local nextStance = lStancesInOrder[stanceIdx + directionMod]
    local nextStanceAction = nextStance and CombatActions["Stance" .. nextStance]
    if nextStanceAction then
      if HasCombatActionInProgress(unit) and CombatActions_RunningState[unit] ~= "PostAction" then
        if bufferedThread then
          DeleteThread(bufferData.thread)
        end
        local thread = CreateMapRealTimeThread(lChangeStanceForUnit, unit, nextStance, "wait")
        l_StanceBufferingThreads[unit] = {thread = thread, stance = nextStance}
      else
        lChangeStanceForUnit(unit, nextStance)
      end
    end
  end
end
function GetMercPortraitWindow(unit)
  if not IsKindOf(unit, "Unit") or not unit:IsMerc() then
    return
  end
  local party = GetInGameInterfaceModeDlg():ResolveId("idParty")
  local container = party and party.idPartyContainer
  party = container and container.idParty
  party = party and party[2]
  for idx, win in ipairs(party) do
    if win.context and win.context.session_id == unit.session_id then
      return win
    end
  end
end
