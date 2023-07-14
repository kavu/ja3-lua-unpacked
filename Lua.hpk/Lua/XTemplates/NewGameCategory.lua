PlaceObj("XTemplate", {
  __is_kind_of = "XButton",
  group = "Zulu",
  id = "NewGameCategory",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XButton",
    "MinHeight",
    64,
    "MaxHeight",
    64,
    "LayoutMethod",
    "HList",
    "FoldWhenHidden",
    true,
    "BorderColor",
    RGBA(0, 0, 0, 0),
    "Background",
    RGBA(255, 255, 255, 0),
    "HandleMouse",
    false,
    "FocusedBorderColor",
    RGBA(0, 0, 0, 0),
    "FocusedBackground",
    RGBA(128, 128, 128, 0),
    "DisabledBorderColor",
    RGBA(0, 0, 0, 0),
    "RolloverBackground",
    RGBA(255, 255, 255, 0),
    "PressedBackground",
    RGBA(255, 255, 255, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XBlurRect",
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
      "idImg1",
      "Dock",
      "box",
      "Transparency",
      38,
      "HandleKeyboard",
      false,
      "Image",
      "UI/Common/mm_title",
      "SqueezeX",
      false,
      "SqueezeY",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
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
      "TextStyle",
      "PDABrowserHeader",
      "Translate",
      true,
      "WordWrap",
      false,
      "TextVAlign",
      "center"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idEdit",
      "Margins",
      box(0, 0, 50, 0),
      "Dock",
      "right",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      50,
      "Visible",
      false,
      "FoldWhenHidden",
      true,
      "HandleKeyboard",
      false,
      "Image",
      "UI/Hud/rename"
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
      "IsSelectable(self)",
      "func",
      function(self)
        return false
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        if GetUIStyleGamepad() then
          self.idName:SetTextStyle(rollover and "OptionsActionButton" or "PDABrowserHeader")
          self.idEdit:SetImageColor(rollover and GameColors.B or RGB(255, 255, 255))
          if rollover then
            PlayFX("MainMenuButtonRollover")
          end
        end
      end
    })
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "Name",
    "editor",
    "text",
    "Set",
    function(self, value)
      self.idName:SetText(value)
    end,
    "Get",
    function(self)
      return self.idName:GetText()
    end,
    "name",
    T(458892235136, "Name")
  })
})
