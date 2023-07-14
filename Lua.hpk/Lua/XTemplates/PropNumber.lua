PlaceObj("XTemplate", {
  __is_kind_of = "XPropControl",
  group = "Zulu",
  id = "PropNumber",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XPropControl",
    "RolloverTemplate",
    "RolloverGenericNoTitle",
    "RolloverAnchor",
    "right",
    "RolloverOffset",
    box(20, -5, 0, 0),
    "OnLayoutComplete",
    function(self)
      if GetUIStyleGamepad() then
        self.RolloverOnFocus = true
      end
      self:SetRolloverText(self.context.prop_meta.help)
    end,
    "LayoutMethod",
    "HList",
    "MouseCursor",
    "CommonAssets/UI/HandCursor.tga"
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
      "__class",
      "XScrollThumb",
      "Id",
      "idSlider",
      "VAlign",
      "center",
      "MinWidth",
      200,
      "MaxWidth",
      200,
      "FXPress",
      "MainMenuSliderClick",
      "Horizontal",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "ZOrder",
        0,
        "Image",
        "UI/PDA/separate_line_vertical",
        "ImageScale",
        point(1000, 3000),
        "SqueezeY",
        false
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idThumb",
        "VAlign",
        "center",
        "Image",
        "UI/PDA/imp_bar",
        "ImageScale",
        point(500, 1000),
        "ImageColor",
        RGBA(215, 159, 80, 255)
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "MoveThumb",
        "func",
        function(self, ...)
          if not self:HasMember("idThumb") then
            return
          end
          local x1, y1, x2, y2 = self.content_box:xyxy()
          local min, max = self:GetThumbRange()
          self.idThumb:SetDock("ignore")
          if self.Horizontal then
            self.idThumb:SetLayoutSpace(x1 + min, y1, max - min, y2 - y1)
            if not self.layout_update then
              Msg("OptionsChanged")
              if GetUIStyleGamepad() then
                self:PlayFX(self.FXPress, "start")
              end
              CloseOptionsChoiceSubmenu(self)
            end
          else
            self.idThumb:SetLayoutSpace(x1, y1 + min, x2 - x1, max - min)
          end
        end
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "OnMouseButtonUp(self, pos, button)",
        "func",
        function(self, pos, button)
          if not GetUIStyleGamepad() then
            self:PlayFX(self.FXPress, "start")
          end
          XScrollThumb.OnMouseButtonUp(self, pos, button)
        end
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "OnMouseButtonDown(self, pos, button)",
        "func",
        function(self, pos, button)
          if not GetUIStyleGamepad() then
            self:PlayFX(self.FXPress, "start")
          end
          XScrollThumb.OnMouseButtonDown(self, pos, button)
        end
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnPropUpdate(self, context, prop_meta, value)",
      "func",
      function(self, context, prop_meta, value)
        self.idSlider:SetBindTo(prop_meta.id)
        if prop_meta.step then
          self.idSlider:SetStepSize(prop_meta.step)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if shortcut == "DPadLeft" or shortcut == "DPadRight" or shortcut == "LeftThumbLeft" or shortcut == "LeftThumbRight" then
          local prop_meta = self.context.prop_meta
          if (shortcut == "LeftThumbLeft" or shortcut == "LeftThumbRight") and prop_meta.dpad_only then
            return
          end
          local obj = ResolvePropObj(self.context)
          local value = obj[prop_meta.id]
          local step = self.idSlider.StepSize
          local minValue = self.idSlider.Min
          local maxValue = self.idSlider.Max
          local pool = maxValue - minValue
          local stepSizeFor10Steps = pool / 10
          if step < stepSizeFor10Steps then
            step = stepSizeFor10Steps
          end
          value = (shortcut == "DPadLeft" or shortcut == "LeftThumbLeft") and Max(self.idSlider.Min, value - step) or Min(self.idSlider.Max, value + step)
          obj:SetProperty(prop_meta.id, value)
          CloseOptionsChoiceSubmenu(self)
          self.idSlider:SetScroll(value)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnXButtonRepeat(self, button, controller_id)",
      "func",
      function(self, button, controller_id)
        self:OnShortcut(XInputShortcut(button, controller_id), "gamepad")
        return "break"
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
        self.idSlider.idThumb:SetImageColor(rollover and RGBA(55, 52, 61, 255) or RGBA(215, 159, 80, 255))
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
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        CloseOptionsChoiceSubmenu(self)
      end
    })
  })
})
