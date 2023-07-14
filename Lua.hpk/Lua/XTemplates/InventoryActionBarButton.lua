PlaceObj("XTemplate", {
  __is_kind_of = "XButton",
  group = "Zulu",
  id = "InventoryActionBarButton",
  PlaceObj("XTemplateWindow", {
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
    "SqueezeX",
    true,
    "Translate",
    true,
    "ColumnsUse",
    "abcca"
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
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idBtnShortcut",
        "Clip",
        false,
        "UseClipBox",
        false,
        "HandleMouse",
        false,
        "TextStyle",
        "InventoryToolbarButtonShortcut",
        "Translate",
        true
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
        "InventoryToolbarButton",
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
        local short_cut = GetShortcutButtonT(self.action)
        if GetUIStyleGamepad() and short_cut then
          self.idBtnShortcut:SetText(short_cut)
          return
        end
        local name = KeyNames[VKStrNamesInverse[self.action.ActionShortcut]]
        if name then
          if self.action.OnShortcutUp then
            self.idBtnShortcut:SetText(T({
              385406869936,
              "<style InventoryToolbarButton>Hold</style> <name>",
              name = short_cut
            }))
          else
            self.idBtnShortcut:SetText(short_cut)
          end
        else
          self.idBtnShortcut:SetText(Untranslated(const.TagLookupTable[self.action.ActionShortcut]))
        end
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
    })
  })
})
