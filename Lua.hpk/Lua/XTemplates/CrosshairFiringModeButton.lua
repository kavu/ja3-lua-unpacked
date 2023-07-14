PlaceObj("XTemplate", {
  __content = function(parent, context)
    return parent.idParent
  end,
  __is_kind_of = "XButton",
  group = "Zulu",
  id = "CrosshairFiringModeButton",
  PlaceObj("XTemplateWindow", {
    "__class",
    "CrosshairCircleButton",
    "RolloverTemplate",
    "CombatActionRollover",
    "RolloverAnchorId",
    "idContainer",
    "RolloverOffset",
    box(20, 20, 20, 20),
    "HAlign",
    "left",
    "VAlign",
    "top",
    "UseClipBox",
    false,
    "BorderColor",
    RGBA(0, 0, 0, 0),
    "Background",
    RGBA(255, 255, 255, 0),
    "OnContextUpdate",
    function(self, context, ...)
      local combat_action = self.context.action
      if not combat_action then
        self:SetVisible(false)
        return
      end
      local crosshair = self:ResolveId("node")
      local selected = crosshair.context.action == combat_action
      self.idInner:SetColumn(selected and 2 or 1)
      self.idLabel:SetTextStyle(selected and "Crosshair_Label_Selected" or "Crosshair_Label")
      self.idTextContainer:SetBackground(selected and GameColors.L or GetColorWithAlpha(GameColors.A, 200))
      local icon = combat_action.IconFiringMode
      self.idInner:SetImage(icon)
      local actionEnabled = SelectedObj.ui_actions[combat_action.id]
      actionEnabled = actionEnabled == "enabled"
      self:SetEnabled(actionEnabled)
      self:SetRolloverTemplate("CombatActionRollover")
      self.idDisabled:SetVisible(not actionEnabled)
      local rolloverText = combat_action:GetActionDescription(Selection)
      self:SetRolloverText(rolloverText)
      self:SetRolloverTitle(combat_action:GetActionDisplayName(Selection))
      self.idLabel:SetText(combat_action.DisplayName)
      self.idLabel:SetVisible(true)
    end,
    "FXMouseIn",
    "CrosshairCircleButtonRollover",
    "FXPress",
    "CrosshairCircleButtonPress",
    "FocusedBorderColor",
    RGBA(0, 0, 0, 0),
    "FocusedBackground",
    RGBA(0, 0, 0, 0),
    "DisabledBorderColor",
    RGBA(0, 0, 0, 0),
    "OnPress",
    function(self, gamepad)
      local action = self.context.action
      local crosshair = self:ResolveId("node")
      crosshair:ChangeAction(action)
    end,
    "RolloverBackground",
    RGBA(0, 0, 0, 0),
    "PressedBackground",
    RGBA(0, 0, 0, 0),
    "left_side",
    true
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self)",
      "func",
      function(self)
        CrosshairCircleButton.Open(self)
        local crosshair = self:ResolveId("node")
        local firingModes = crosshair.context.firingModes
        local myFiringMode = self.context.action
        local firingModeIndex = table.find(firingModes, myFiringMode) or 1
        local x, y = CalculateCrosshairFireModeButtonOffset(firingModeIndex, #firingModes)
        self.circle_offset_x = x
        self.circle_offset_y = y
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "CreateRolloverWindow(self, gamepad, context, pos)",
      "func",
      function(self, gamepad, context, pos)
        local rollover = CrosshairCircleButton.CreateRolloverWindow(self, gamepad, context, pos)
        if rollover then
          local oldFunc = rollover.SetBox
          function rollover:SetBox(...)
            oldFunc(self, ...)
            if not self.termUI then
              return
            end
            local anchor = self:GetAnchor()
            local x = self.box:minx()
            local onTheLeft = x < anchor:minx()
            local below = self.box:miny() > anchor:maxy()
            if below then
              onTheLeft = false
            end
            local termUI = self.termUI
            if not onTheLeft then
              termUI:SetDock("right")
            else
              termUI:SetDock("left")
            end
          end
          rollover:InvalidateLayout()
          return rollover
        end
      end
    }),
    PlaceObj("XTemplateWindow", {
      "Id",
      "idTextContainer",
      "Margins",
      box(0, 6, -15, 6),
      "Padding",
      box(4, 0, 20, 0),
      "OnLayoutComplete",
      function(self)
        local anyVisible = false
        for i, c in ipairs(self) do
          if c.visible then
            anyVisible = true
          end
        end
        self:SetVisible(anyVisible)
      end,
      "UseClipBox",
      false
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idLabel",
        "Margins",
        box(0, 0, 0, -1),
        "HAlign",
        "right",
        "VAlign",
        "center",
        "Clip",
        false,
        "UseClipBox",
        false,
        "FoldWhenHidden",
        true,
        "DrawOnTop",
        true,
        "Translate",
        true,
        "TextHAlign",
        "right"
      })
    }),
    PlaceObj("XTemplateWindow", {
      "Dock",
      "right",
      "UseClipBox",
      false,
      "DrawOnTop",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idBackground",
        "HAlign",
        "center",
        "VAlign",
        "center",
        "UseClipBox",
        false,
        "DrawOnTop",
        true,
        "Image",
        "UI/Hud/target_icon_circle"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idInner",
        "HAlign",
        "center",
        "VAlign",
        "center",
        "UseClipBox",
        false,
        "DrawOnTop",
        true,
        "Columns",
        2
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idDisabled",
        "UseClipBox",
        false,
        "DrawOnTop",
        true,
        "Image",
        "UI/PDA/T_UnavailableOption",
        "DisabledImageColor",
        RGBA(255, 255, 255, 255)
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        if not self.enabled then
          return
        end
        local action = self.context.action
        local crosshair = self:ResolveId("node")
        crosshair.show_data_for_action = rollover and action or false
        crosshair:UpdateAim()
        crosshair:SetSelectedPart(crosshair.targetPart)
      end
    })
  })
})
