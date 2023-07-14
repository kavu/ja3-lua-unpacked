PlaceObj("XTemplate", {
  __is_kind_of = "XPropControl",
  group = "Common",
  id = "PropNumber",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XPropControl",
    "BorderWidth",
    2,
    "LayoutMethod",
    "HList",
    "Background",
    RGBA(255, 255, 255, 255),
    "RolloverOnFocus",
    true,
    "MouseCursor",
    "CommonAssets/UI/HandCursor.tga",
    "FocusedBackground",
    RGBA(170, 170, 170, 255)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idName",
      "MinWidth",
      300,
      "TextStyle",
      "GedTitle",
      "Translate",
      true
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XScrollThumb",
      "Id",
      "idSlider",
      "VAlign",
      "center",
      "MinWidth",
      240,
      "Horizontal",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "ZOrder",
        0,
        "Image",
        "CommonAssets/UI/Controls/Slider/slider_background.tga",
        "FrameBox",
        box(5, 0, 5, 0),
        "SqueezeY",
        false
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idThumb",
        "Padding",
        box(15, 0, 15, 0),
        "VAlign",
        "center",
        "Image",
        "CommonAssets/UI/Controls/Slider/slider_button.tga",
        "Columns",
        3
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
          value = (shortcut == "DPadLeft" or shortcut == "LeftThumbLeft") and Max(prop_meta.min, value - step) or Min(prop_meta.max, value + step)
          obj:SetProperty(prop_meta.id, value)
          ObjModified(obj)
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
    })
  })
})
