PlaceObj("XTemplate", {
  __is_kind_of = "XButton",
  group = "Zulu",
  id = "InventoryActionBarButtonCenter",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return "GamepadUIStyleChanged"
    end,
    "__class",
    "XTextButton",
    "Background",
    RGBA(255, 255, 255, 0),
    "FXMouseIn",
    "buttonRollover",
    "FXPress",
    "buttonPressGeneric",
    "FXPressDisabled",
    "IactDisabled",
    "FocusedBackground",
    RGBA(255, 255, 255, 0),
    "RolloverBackground",
    RGBA(255, 255, 255, 0),
    "PressedBackground",
    RGBA(255, 255, 255, 0),
    "Translate",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "Id",
      "idTxtContainer",
      "Margins",
      box(10, 5, 10, 5),
      "Dock",
      "box",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "LayoutMethod",
      "HList",
      "LayoutHSpacing",
      2
    }, {
      PlaceObj("XTemplateWindow", nil, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idBtnShortcut",
          "HAlign",
          "center",
          "VAlign",
          "center",
          "Clip",
          false,
          "UseClipBox",
          false,
          "HandleMouse",
          false,
          "TextStyle",
          "InventoryToolbarButtonCenterShortcut",
          "Translate",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Id",
          "idBtnHoldShortcut",
          "ScaleModifier",
          point(650, 650),
          "FoldWhenHidden",
          true,
          "Image",
          "UI/DesktopGamepad/hold0",
          "ImageScale",
          point(650, 650)
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idBtnText",
        "Clip",
        false,
        "UseClipBox",
        false,
        "HandleMouse",
        false,
        "TextStyle",
        "InventoryToolbarButtonCenter",
        "Translate",
        true
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetRollover(self, rollover)",
      "func",
      function(self, rollover)
        self:SetRolloverMode(rollover)
        XTextButton.SetRollover(self, rollover)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetEnabled(self, enabled)",
      "func",
      function(self, enabled)
        XTextButton.SetEnabled(self, enabled)
        XText.SetEnabled(self.idBtnText, enabled)
        XText.SetEnabled(self.idBtnShortcut, enabled)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetRolloverMode(self, rollover)",
      "func",
      function(self, rollover)
        local image = "UI/Common/conversation_choice"
        if rollover then
          image = "UI/Common/conversation_choice_rollover"
        end
        local enabled = self:GetEnabled()
        if not enabled then
          return
        end
        XText.SetRollover(self.idBtnText, rollover)
        XText.SetRollover(self.idBtnShortcut, rollover)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetSelected(self, selected)",
      "func",
      function(self, selected)
        if GetUIStyleGamepad() then
          self:SetFocus(selected)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetText(self, value)",
      "func",
      function(self, value)
        self.idBtnText:SetText(value)
        self.Text = value
        self.idBtnHoldShortcut:SetVisible(false)
        if GetUIStyleGamepad() then
          local short_cut = GetShortcutButtonT(self.action)
          if short_cut then
            self.idBtnShortcut:SetText(short_cut)
            self.idBtnHoldShortcut:SetVisible(self.action.ActionGamepadHold)
            return
          end
        end
        local name = GetShortcutButtonT(self.action)
        self.idBtnShortcut:SetText(T({
          775518317251,
          "[<name>]",
          name = name
        }))
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetTranslate(self, value)",
      "func",
      function(self, value)
        self.idBtnText:SetTranslate(value)
        self.idBtnShortcut:SetTranslate(value)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self)",
      "func",
      function(self)
        XTextButton.Open(self)
        if self.action then
          self:SetText(self.action.ActionName)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnHoldButtonTick(self, i, shortcut)",
      "func",
      function(self, i, shortcut)
        self.idBtnHoldShortcut:SetVisible(not not i)
        self.idBtnHoldShortcut:SetImage("UI/DesktopGamepad/hold" .. i)
      end
    })
  })
})
