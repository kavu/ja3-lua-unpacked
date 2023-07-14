PlaceObj("XTemplate", {
  __is_kind_of = "XButton",
  group = "Zulu",
  id = "NewGameDiffEntry",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XButton",
    "RolloverTemplate",
    "RolloverGenericFixedL",
    "RolloverAnchor",
    "right",
    "RolloverText",
    T(980589328557, "<description>"),
    "RolloverOffset",
    box(25, 0, 0, 0),
    "RolloverTitle",
    T(514924523745, "<display_name>"),
    "UIEffectModifierId",
    "MainMenuMainBar",
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
      if IsKindOf(self.context, "GameDifficultyDef") then
        local gameObj = Game or NewGameObj
        local difficultyKey = gameObj == Game and "game_difficulty" or "difficulty"
        if self.context.id == gameObj[difficultyKey] then
          self.idCheckmark:SetColumn(2)
        else
          self.idCheckmark:SetColumn(1)
        end
      end
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
      for _, obj in ipairs(self.parent) do
        if IsKindOf(obj, "XButton") and obj == self then
          self.idCheckmark:SetColumn(2)
          NewGameObj.difficulty = self.context.id
          if netInGame and NetIsHost() then
            local context = GetDialog(self):ResolveId("node").idSubMenu.context
            if context and context.invited_player_id then
              CreateRealTimeThread(function(invited_player_id)
                NetCall("rfnPlayerMessage", invited_player_id, "lobby-info", {
                  start_info = NewGameObj,
                  no_scroll = true
                })
              end, context.invited_player_id)
            end
          end
        elseif IsKindOf(obj, "XButton") and IsKindOf(obj.context, "GameDifficultyDef") then
          obj.idCheckmark:SetColumn(1)
        end
      end
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
      "DisabledBackground",
      RGBA(255, 255, 255, 255),
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
      "DisabledBackground",
      RGBA(255, 255, 255, 255),
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
      "DisabledBackground",
      RGBA(255, 255, 255, 255),
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
      "Text",
      T(482174560280, "<display_name>"),
      "TextVAlign",
      "center",
      "SafeSpace",
      10
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idCheckmark",
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
      "FoldWhenHidden",
      true,
      "HandleKeyboard",
      false,
      "Image",
      "UI/Hud/checkmark",
      "Columns",
      2
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        self.idName:SetTextStyle(rollover and "MMOptionEntryHighlight" or "MMOptionEntry")
        if rollover then
          self.idCheckmark:SetImage("UI/Hud/checkmark_rollover")
        else
          self.idCheckmark:SetImage("UI/Hud/checkmark")
        end
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
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self)",
      "func",
      function(self)
        XButton.Open(self)
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
    T(204714528343, "Name")
  })
})
