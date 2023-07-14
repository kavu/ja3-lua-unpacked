PlaceObj("XTemplate", {
  __is_kind_of = "XButton",
  group = "Zulu",
  id = "MainMenuButton",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XButton",
    "HAlign",
    "center",
    "VAlign",
    "center",
    "MinWidth",
    355,
    "MaxWidth",
    355,
    "OnLayoutComplete",
    function(self)
      self:SetTransparency(self.enabled or self.focused and 0 or 178)
    end,
    "BorderColor",
    RGBA(0, 0, 0, 0),
    "Background",
    RGBA(255, 255, 255, 0),
    "BackgroundRectGlowColor",
    RGBA(0, 0, 0, 0),
    "FXPress",
    "MainMenuButtonClick",
    "FXPressDisabled",
    "IactDisabled",
    "FocusedBorderColor",
    RGBA(0, 0, 0, 0),
    "FocusedBackground",
    RGBA(255, 255, 255, 0),
    "DisabledBorderColor",
    RGBA(0, 0, 0, 0),
    "DisabledBackground",
    RGBA(187, 149, 0, 0),
    "OnPressEffect",
    "action",
    "RolloverBackground",
    RGBA(215, 159, 80, 0),
    "PressedBackground",
    RGBA(255, 255, 255, 0)
  }, {
    PlaceObj("XTemplateWindow", nil, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "UIEffectModifierId",
        "MainMenuHighlight",
        "Id",
        "idImgBcgr",
        "Dock",
        "box",
        "MaxHeight",
        50,
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
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        local cont = self:ResolveId("node")
        if not cont then
          return
        end
        RunWhenXWindowIsReady(cont, function(self)
          if self.window_state == "destroying" or self.window_state == "closing" then
            return
          end
          local isRollover = GetUIStyleGamepad() and self:IsFocused() or not GetUIStyleGamepad() and rollover
          if self.enabled then
            self.idBtnText:SetTextStyle(isRollover and self.enabled and "MMButtonTextHighlight" or "MMButtonText")
            self.idNotification:SetColumn(2)
          end
          if isRollover and self.enabled then
            PlayFX("MainMenuButtonRollover")
            local center = self.idImgBcgr.box:Center()
            self.idImgBcgr:AddInterpolation({
              id = "grow",
              type = const.intRect,
              duration = 150,
              originalRect = sizebox(center, 1000, 1000),
              targetRect = sizebox(center, 1000, 0),
              flags = const.intfInverse
            })
          else
            self.idNotification:SetColumn(1)
            local center = self.idImgBcgr.box:Center()
            self.idImgBcgr:AddInterpolation({
              id = "grow",
              type = const.intRect,
              duration = 0,
              originalRect = sizebox(center, 1000, 1000),
              targetRect = sizebox(center, 1000, 0)
            })
          end
        end, self)
        self.idImgBcgr:SetTransparency(rollover and 0 or 255)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "Id",
      "idTxtContainer",
      "Margins",
      box(10, 5, 10, 5),
      "Dock",
      "box",
      "VAlign",
      "center",
      "LayoutMethod",
      "HList",
      "LayoutHSpacing",
      2,
      "UseClipBox",
      false,
      "BorderColor",
      RGBA(0, 0, 0, 0),
      "BackgroundRectGlowColor",
      RGBA(0, 0, 0, 0),
      "HandleKeyboard",
      false,
      "HandleMouse",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "text on button",
        "__class",
        "XText",
        "Id",
        "idBtnText",
        "IdNode",
        false,
        "Dock",
        "box",
        "HAlign",
        "center",
        "VAlign",
        "center",
        "Clip",
        false,
        "UseClipBox",
        false,
        "BorderColor",
        RGBA(0, 0, 0, 0),
        "BackgroundRectGlowColor",
        RGBA(0, 0, 0, 0),
        "HandleKeyboard",
        false,
        "FocusedBorderColor",
        RGBA(0, 0, 0, 0),
        "DisabledBorderColor",
        RGBA(0, 0, 0, 0),
        "TextStyle",
        "MMButtonText",
        "Translate",
        true,
        "TextHAlign",
        "center",
        "TextVAlign",
        "center"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Id",
          "idNotification",
          "Margins",
          box(-36, 0, 0, 0),
          "Dock",
          "left",
          "Visible",
          false,
          "Image",
          "UI/Hud/new",
          "ImageFit",
          "height",
          "Columns",
          2
        })
      })
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
        return self:GetEnabled()
      end
    })
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "ButtonText",
    "editor",
    "text",
    "Set",
    function(self, value)
      self.idBtnText:SetText(value)
    end,
    "Get",
    function(self)
      return self.idBtnText:GetText()
    end,
    "name",
    T(813078159912, "Button Text")
  })
})
