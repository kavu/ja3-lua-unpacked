PlaceObj("XTemplate", {
  __is_kind_of = "XButton",
  group = "Zulu",
  id = "NewGameJoinCode",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XButton",
    "RolloverTemplate",
    "RolloverGenericFixedL",
    "RolloverAnchor",
    "right",
    "RolloverText",
    T(387236887162, "Copies the join code to the clipboard. Another player can use this code to join your game via the <em>Join by Code</em> option from the Multiplayer section in the Main Menu."),
    "RolloverOffset",
    box(25, 0, 0, 0),
    "RolloverTitle",
    T(261271998143, "Join Code"),
    "MinHeight",
    64,
    "MaxHeight",
    64,
    "LayoutMethod",
    "HList",
    "BorderColor",
    RGBA(0, 0, 0, 0),
    "Background",
    RGBA(255, 255, 255, 0),
    "OnContextUpdate",
    function(self, context, ...)
      self.idName:SetText(T({
        648952937285,
        "Join Code: <u(code)>",
        code = GetNetGameJoinCode()
      }))
    end,
    "FXPress",
    "CheckBoxClick",
    "FXPressDisabled",
    "activityAssignSelectDisabled",
    "FocusedBorderColor",
    RGBA(0, 0, 0, 0),
    "FocusedBackground",
    RGBA(128, 128, 128, 0),
    "DisabledBorderColor",
    RGBA(0, 0, 0, 0),
    "OnPress",
    function(self, gamepad)
      if not GetUIStyleGamepad() then
        self.parent:SetFocus(true)
      end
      CopyToClipboard(GetNetGameJoinCode())
    end,
    "RolloverBackground",
    RGBA(255, 255, 255, 0),
    "PressedBackground",
    RGBA(255, 255, 255, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XBlurRect",
      "Margins",
      box(0, 5, 0, 5),
      "Dock",
      "box",
      "BlurRadius",
      10,
      "Mask",
      "UI/Common/mm_background",
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
      "__context",
      function(parent, context)
        return "GamepadUIStyleChanged"
      end,
      "__class",
      "XContentTemplate",
      "Dock",
      "right"
    }, {
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return not GetUIStyleGamepad()
        end,
        "__class",
        "XContextImage",
        "Id",
        "idHintAction",
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
        "MaxHeight",
        35,
        "FoldWhenHidden",
        true,
        "HandleKeyboard",
        false,
        "Image",
        "UI/Icons/left_click",
        "ImageFit",
        "height"
      }),
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return GetUIStyleGamepad()
        end,
        "__class",
        "XContextImage",
        "Id",
        "idHintActionGamepad",
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
        "MaxHeight",
        35,
        "FoldWhenHidden",
        true,
        "HandleKeyboard",
        false,
        "ImageFit",
        "height",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          self:SetImage(GetPlatformSpecificImagePath("ButtonA"))
        end
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        self.idName:SetTextStyle(rollover and "MMOptionEntryHighlight" or "MMOptionEntry")
        if rollover then
          PlayFX("MainMenuButtonRollover")
          self.idImgBcgr:SetTransparency(0, 150)
        else
          self.idImgBcgr:SetTransparency(255, 150)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if shortcut == "ButtonA" then
          self:Press()
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
    })
  })
})
