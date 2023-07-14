PlaceObj("XTemplate", {
  __is_kind_of = "XButton",
  group = "Zulu",
  id = "SmallStanceHudButton",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XButton",
    "RolloverTemplate",
    "CombatActionRollover",
    "RolloverAnchor",
    "center-top",
    "RolloverAnchorId",
    "node",
    "RolloverOffset",
    box(0, 0, 0, 15),
    "BorderWidth",
    2,
    "Padding",
    box(3, 3, 3, 3),
    "BorderColor",
    RGBA(52, 55, 60, 255),
    "Background",
    RGBA(255, 255, 255, 0),
    "OnContextUpdate",
    function(self, context, ...)
      local combat_action = self.context.action
      local rolloverText = combat_action:GetActionDescription(false)
      if combat_action.UseFreeMove and Selection[1] then
        local cost = combat_action:GetAPCost(Selection[1])
        if 0 < cost then
          local ui_adjusted_cost, ap_now, free = Selection[1]:GetUIAdjustedActionCost(cost, true, true)
          if ui_adjusted_cost == 0 and free then
            rolloverText = rolloverText .. T(930244805673, "<newline><newline><flavor>AP cost deducted from Free Move</flavor>")
          end
        end
      end
      self:SetRolloverText(rolloverText)
      self:SetRolloverTitle(combat_action:GetActionDisplayName(false))
    end,
    "FXMouseIn",
    "StanceButtonRollover",
    "FXPress",
    "StanceButtonPress",
    "FXPressDisabled",
    "StanceButtonDisabled",
    "FocusedBorderColor",
    RGBA(52, 55, 60, 255),
    "FocusedBackground",
    RGBA(255, 255, 255, 0),
    "DisabledBorderColor",
    RGBA(52, 55, 60, 255),
    "OnPress",
    function(self, gamepad)
      if #(Selection or "") > 0 then
        self.context.action:UIBegin(Selection)
        if gamepad and self.context.action:GetUIState(Selection) == "enabled" then
          local igi = GetInGameInterfaceModeDlg()
          igi:SetFocus()
        end
      end
    end,
    "RolloverBackground",
    RGBA(255, 255, 255, 0),
    "RolloverBorderColor",
    RGBA(52, 55, 60, 255),
    "PressedBackground",
    RGBA(255, 255, 255, 0),
    "PressedBorderColor",
    RGBA(52, 55, 60, 255)
  }, {
    PlaceObj("XTemplateWindow", {
      "Id",
      "idInner",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      15,
      "MinHeight",
      15,
      "MaxWidth",
      15,
      "MaxHeight",
      15,
      "Background",
      RGBA(52, 55, 60, 255)
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "controller hint",
      "__context",
      function(parent, context)
        return "GamepadUIStyleChanged"
      end,
      "__class",
      "XText",
      "Id",
      "idControllerHint",
      "Dock",
      "ignore",
      "HAlign",
      "left",
      "VAlign",
      "bottom",
      "ScaleModifier",
      point(500, 500),
      "Clip",
      false,
      "UseClipBox",
      false,
      "TextStyle",
      "HUDHeaderBig",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        self.parent:UpdateSelectionState()
        XText.OnContextUpdate(self, context, ...)
      end,
      "Translate",
      true,
      "Text",
      T(796492295103, "<ButtonA>")
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "UpdateLayout(self)",
        "func",
        function(self)
          local parent = self.parent
          local parentb = parent.box
          self:SetBox(parentb:minx() + self.measure_width / 1.5, parentb:miny() + self.measure_height / 2, self.measure_width, self.measure_height)
          XText.UpdateLayout(self)
        end
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetSelected(self, selected)",
      "func",
      function(self, selected)
        self:UpdateSelectionState(selected)
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
      "UpdateSelectionState(self, selected)",
      "func",
      function(self, selected)
        if selected == nil then
          local button = self
          local list = button and button.parent
          local selection = list:GetSelection()
          selection = selection and selection[1]
          local selectionButton = list[selection]
          if selectionButton == button then
            selected = true
          end
        end
        selected = selected and GetUIStyleGamepad()
        self.idControllerHint:SetVisible(selected)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetFocused(self, focus)",
      "func",
      function(self, focus)
        self:SetFocus(focus)
      end
    })
  })
})
