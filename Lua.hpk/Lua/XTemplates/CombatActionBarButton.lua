PlaceObj("XTemplate", {
  __is_kind_of = "HUDButton",
  group = "Zulu",
  id = "CombatActionBarButton",
  PlaceObj("XTemplateWindow", {
    "__class",
    "HUDButton",
    "RolloverTemplate",
    "CombatActionRollover",
    "RolloverAnchor",
    "custom",
    "RolloverAnchorId",
    "idBarHolder",
    "RolloverOffset",
    box(0, 0, 0, 55),
    "BorderWidth",
    2,
    "BorderColor",
    RGBA(0, 0, 0, 0),
    "FocusedBorderColor",
    RGBA(255, 255, 255, 0),
    "DisabledBorderColor",
    RGBA(0, 0, 0, 0),
    "OnPressEffect",
    "action"
  }, {
    PlaceObj("XTemplateWindow", {
      "comment",
      "Precalc data observer, updates action descriptions etc",
      "__context",
      function(parent, context)
        return "unit_precalc"
      end,
      "__class",
      "XContextWindow",
      "Id",
      "idPrecalcObserver",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local button = self.parent
        local units = table.ifilter(button.context, function(idx, unit)
          return IsValidTarget(unit)
        end)
        local unit = units[1]
        if not IsValid(unit) then
          return
        end
        local combat_action = self.parent.context.action
        local underlyingAction = combat_action:ResolveAction(unit)
        if not underlyingAction then
          return
        end
        local rolloverText = combat_action:GetActionDescription(units)
        button:SetRolloverText(rolloverText)
        button:SetRolloverTitle(underlyingAction:GetActionDisplayName(units))
        button:SetEnabled(combat_action:GetVisibility(units) == "enabled")
        button:SetImage(combat_action:GetActionIcon(units))
        local passive = underlyingAction.ActionType == "Passive"
        button:SetColumns(passive and 1 or 2)
        rawset(button, "passive", passive)
        if RolloverWin and RolloverWin.window_state ~= "destroying" and RolloverControl == button then
          RolloverWin:UpdateRolloverContent()
        end
        if passive then
          button:SetText(T(970549941821, "Passive"))
        elseif GetUIStyleGamepad() then
          if button.selected and button:IsFocused() then
            local tag = GetPlatformSpecificImageTag("ButtonA", 650)
            tag = Untranslated(tag)
            button:SetText(tag)
          elseif underlyingAction.id == "Overwatch" then
            local tag = GetPlatformSpecificImageTag("ButtonY", 650)
            tag = Untranslated(tag)
            button:SetText(tag)
          elseif underlyingAction == DetermineUnitCombatActionButtonX() then
            local tag = GetPlatformSpecificImageTag("ButtonX", 650)
            tag = Untranslated(tag)
            button:SetText(tag)
          else
            button:SetText(false)
          end
        else
          local text, shortcuts
          local defaultAction = unit:GetDefaultAttackAction()
          if defaultAction and underlyingAction.id == defaultAction.id and not UIAnyEnemyAttackGood() then
            text = GetShortcutButtonT("actionFreeAim")
          end
          if not text then
            local keybindActionName = "combatAction" .. underlyingAction.id
            if underlyingAction.KeybindingFromAction then
              local act = XActionRedirectToCombatAction(underlyingAction.KeybindingFromAction, unit)
              if not act or act.id == underlyingAction.id then
                keybindActionName = underlyingAction.KeybindingFromAction
              end
            end
            text = GetShortcutButtonT(keybindActionName) or GetShortcutButtonT("combatAction" .. combat_action.id) or T(460169163499, " ")
          end
          button:SetText(T({
            775518317251,
            "[<name>]",
            name = text
          }))
        end
      end
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "controller observer",
      "__context",
      function(parent, context)
        return "GamepadUIStyleChanged"
      end,
      "__class",
      "XContextWindow",
      "Id",
      "idControllerSelection",
      "IdNode",
      true,
      "HAlign",
      "center",
      "VAlign",
      "bottom",
      "UseClipBox",
      false,
      "Visible",
      false,
      "OnContextUpdate",
      function(self, context, ...)
        local node = self:ResolveId("node")
        node.idPrecalcObserver:OnContextUpdate()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self, ...)",
      "func",
      function(self, ...)
        local units = self.context
        local unit = units[1]
        if not unit then
          HUDButton.Open(self, ...)
          return
        end
        self:SetFocusedBackground(const.PDAUIColors.titleColor)
        self:SetFocusedBorderColor(const.PDAUIColors.selBorderColor)
        local combat_action = self.context.action
        local underlyingAction = combat_action:ResolveAction(unit)
        self.OnPressParam = combat_action.id
        self:SetId(underlyingAction.id)
        HUDButton.Open(self, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Press(self, alt, force, gamepad)",
      "func",
      function(self, alt, force, gamepad)
        if alt and not self.AltPress then
          return
        end
        if not self.enabled and not force then
          local action = self.context.action
          local unit = self.context[1]
          action = action and unit and action:ResolveAction(unit)
          if action then
            CombatActionPlayCustomError(action, unit)
          end
          self:PlayFX(self.FXPressDisabled, "start")
          return
        end
        if alt then
          self:PlayFX(self.FXPress, "start")
          self:OnAltPress(gamepad)
        else
          self:PlayFX(self.FXPress, "start")
          self:OnPress(gamepad)
        end
        if self.window_state ~= "destroying" then
          local host = GetActionsHost(self, true)
          if self.action and self.action:ActionState(host) == "disabled" then
            self:SetEnabled(false)
          end
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetFocused(self, focus)",
      "func",
      function(self, focus)
        self:SetFocus(focus)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetFocus(self)",
      "func",
      function(self)
        self:SetSelected(true)
        self.idPrecalcObserver:OnContextUpdate()
        XWindow.OnSetFocus(self)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnKillFocus(self)",
      "func",
      function(self)
        self:SetSelected(false)
        self.idPrecalcObserver:OnContextUpdate()
        XWindow.OnKillFocus(self)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "IsSelectable(self)",
      "func",
      function(self)
        return true
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "GetMouseCursor(self)",
      "func",
      function(self)
        local actionId = self.Id
        local combatAction = CombatActions[actionId]
        local igi = GetDialog(self)
        if igi and igi.target and igi.action == combatAction then
          return igi.crosshair and igi.crosshair.attack_cursor or GetRangeBasedMouseCursor(igi.penalty, combatAction, "attack")
        end
        return "UI/Cursors/Hand.tga"
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetSelected(self, sel)",
      "func",
      function(self, sel)
        self.selected = sel
        self.idPrecalcObserver:OnContextUpdate()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetCurrentAction(self, sel)",
      "func",
      function(self, sel)
        local titleColor = const.PDAUIColors.titleColor
        local selBorderColor = const.PDAUIColors.selBorderColor
        local noClr = const.PDAUIColors.noClr
        local selectedColored = const.HUDUIColors.selectedColored
        local defaultColor = const.HUDUIColors.defaultColor
        self.current_action = true
        self:SetBackground(sel and titleColor or noClr)
        self:SetRolloverBackground(sel and titleColor or noClr)
        self:SetBorderColor(sel and selBorderColor or noClr)
        self:SetRolloverBorderColor(sel and selBorderColor or noClr)
        self.idText:SetTextStyle(sel and "HUDButtonKeybindActive" or "HUDButtonKeybind")
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "GetColumn(self)",
      "func",
      function(self)
        if self.selected or self.current_action then
          return 2
        end
        return XTextButton.GetColumn(self)
      end
    })
  })
})
