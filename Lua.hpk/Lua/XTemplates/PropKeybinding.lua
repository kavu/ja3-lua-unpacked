PlaceObj("XTemplate", {
  __is_kind_of = "XPropControl",
  group = "Zulu",
  id = "PropKeybinding",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XPropControl",
    "LayoutMethod",
    "HList",
    "Background",
    RGBA(255, 255, 255, 0),
    "MouseCursor",
    "CommonAssets/UI/HandCursor.tga",
    "FocusedBackground",
    RGBA(170, 170, 170, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "__condition",
      function(parent, context)
        return not GetDialog("PDADialog") and not g_SatelliteUI
      end,
      "__class",
      "XBlurRect",
      "Margins",
      box(0, 5, 0, 5),
      "Dock",
      "box",
      "BlurRadius",
      10,
      "Mask",
      "UI/Common/mm_panel",
      "FrameLeft",
      15,
      "FrameRight",
      10
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "Id",
      "idEffect",
      "Margins",
      box(5, 5, 5, 5),
      "Dock",
      "box",
      "Transparency",
      179,
      "HandleKeyboard",
      false,
      "Image",
      "UI/Common/screen_effect",
      "ImageScale",
      point(100000, 1000),
      "TileFrame",
      true,
      "SqueezeX",
      false,
      "SqueezeY",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "UIEffectModifierId",
      "MainMenuMainBar",
      "Id",
      "idImg",
      "Dock",
      "box",
      "Transparency",
      64,
      "HandleKeyboard",
      false,
      "Image",
      "UI/Common/mm_panel",
      "SqueezeX",
      false,
      "SqueezeY",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "UIEffectModifierId",
      "MainMenuHighlight",
      "Id",
      "idImgBcgr",
      "Dock",
      "box",
      "Transparency",
      255,
      "HandleKeyboard",
      false,
      "Image",
      "UI/Common/mm_panel_selected",
      "SqueezeX",
      false,
      "SqueezeY",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "AutoFitText",
      "Id",
      "idName",
      "Margins",
      box(20, 0, 0, 0),
      "HAlign",
      "left",
      "VAlign",
      "center",
      "MinWidth",
      300,
      "MaxWidth",
      300,
      "HandleKeyboard",
      false,
      "HandleMouse",
      false,
      "FocusedBorderColor",
      RGBA(0, 0, 0, 0),
      "DisabledBorderColor",
      RGBA(0, 0, 0, 0),
      "TextStyle",
      "MMOptionEntry",
      "Translate",
      true,
      "TextVAlign",
      "center",
      "SafeSpace",
      10
    }),
    PlaceObj("XTemplateWindow", {
      "MinWidth",
      260,
      "MaxWidth",
      260,
      "LayoutMethod",
      "Grid",
      "UniformColumnWidth",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idBinding1",
        "FocusedBorderColor",
        RGBA(0, 0, 0, 0),
        "DisabledBorderColor",
        RGBA(0, 0, 0, 0),
        "TextStyle",
        "MMOptionEntryValue",
        "Translate",
        true,
        "WordWrap",
        false,
        "Shorten",
        true,
        "TextHAlign",
        "center",
        "TextVAlign",
        "center"
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "OnMouseButtonDown(self, pos, button)",
          "func",
          function(self, pos, button)
            if button == "L" then
              self.desktop:SetMouseCapture(self)
              self.binding = true
              CloseOptionsChoiceSubmenu(self)
              return "break"
            end
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "OnMouseButtonUp(self, pos, button)",
          "func",
          function(self, pos, button)
            if button == "L" then
              self.desktop:SetMouseCapture(false)
              if self.binding then
                RebindKeys(1, self.parent.parent)
              end
              return "break"
            end
          end
        }),
        PlaceObj("XTemplateProperty", {"id", "binding"})
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idBinding2",
        "GridX",
        2,
        "FocusedBorderColor",
        RGBA(0, 0, 0, 0),
        "DisabledBorderColor",
        RGBA(0, 0, 0, 0),
        "TextStyle",
        "MMOptionEntryValue",
        "Translate",
        true,
        "WordWrap",
        false,
        "Shorten",
        true,
        "TextHAlign",
        "center",
        "TextVAlign",
        "center"
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "OnMouseButtonDown(self, pos, button)",
          "func",
          function(self, pos, button)
            if button == "L" then
              self.desktop:SetMouseCapture(self)
              self.binding = true
              return "break"
            end
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "OnMouseButtonUp(self, pos, button)",
          "func",
          function(self, pos, button)
            if button == "L" then
              self.desktop:SetMouseCapture(false)
              if self.binding then
                RebindKeys(2, self.parent.parent)
              end
              return "break"
            end
          end
        }),
        PlaceObj("XTemplateProperty", {"id", "binding"})
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnPropUpdate(self, context, prop_meta, value)",
      "func",
      function(self, context, prop_meta, value)
        local binding_1, binding_2 = KeybindingName(value and value[1]), KeybindingName(value and value[2])
        binding_1 = (binding_1 or "") ~= "" and binding_1
        binding_2 = (binding_2 or "") ~= "" and binding_2
        self.idBinding1:SetText(binding_1 or T(682820552090, "(  )"))
        self.idBinding2:SetText(binding_2 or T(682820552090, "(  )"))
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        XPropControl.OnMouseButtonDown(self, pos, button)
        if button == "L" then
          CloseOptionsChoiceSubmenu(self)
          return self.idBinding1:OnMouseButtonDown(pos, button)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonUp(self, pos, button)",
      "func",
      function(self, pos, button)
        if button == "L" then
          return self.idBinding1:OnMouseButtonUp(pos, button)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if shortcut == "ButtonA" then
          self:OnMouseButtonDown(nil, "L")
          self:OnMouseButtonUp(nil, "L")
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetSelected(self, selected)",
      "func",
      function(self, selected)
        self:SetFocus(selected)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        self.idName:SetTextStyle(rollover and "MMOptionEntryHighlight" or "MMOptionEntry")
        self.idBinding1:SetTextStyle(rollover and "MMOptionEntryHighlight" or "MMOptionEntryValue")
        self.idBinding2:SetTextStyle(rollover and "MMOptionEntryHighlight" or "MMOptionEntryValue")
        if rollover then
          PlayFX("MainMenuButtonRollover")
          self.idImgBcgr:SetTransparency(0, 150)
        else
          self.idImgBcgr:SetTransparency(255, 150)
        end
      end
    })
  })
})
