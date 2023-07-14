PlaceObj("XTemplate", {
  __is_kind_of = "XScrollThumb",
  group = "Zulu",
  id = "Slider",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XScrollThumb",
    "Margins",
    box(0, 16, 0, 16),
    "MinHeight",
    15,
    "MouseCursor",
    "UI/Cursors/Hand.tga",
    "Horizontal",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "ZOrder",
      0,
      "VAlign",
      "center",
      "MinHeight",
      3,
      "MaxHeight",
      3,
      "MouseCursor",
      "UI/Cursors/Hand.tga",
      "Image",
      "UI/PDA/separate_line_vertical",
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
      "VAlign",
      "center",
      "MouseCursor",
      "UI/Cursors/Hand.tga",
      "Image",
      "UI/Common/slider_cursor"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "gamepadScrollLeft",
      "ActionGamepad",
      "LeftShoulder",
      "OnAction",
      function(self, host, source, ...)
        local children = GetChildrenOfKind(host, "XScrollThumb")
        if children and children[1] and children[1].ScrollAction then
          if (children[1].BindTo or "") ~= "" then
            return children[1]:ScrollAction("LeftShoulder")
          else
            return children[1]:ScrollActionUnbound("LeftShoulder")
          end
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "gamepadScrollRight",
      "ActionGamepad",
      "RightShoulder",
      "OnAction",
      function(self, host, source, ...)
        local children = GetChildrenOfKind(host, "XScrollThumb")
        if children and children[1] and children[1].ScrollAction then
          if (children[1].BindTo or "") ~= "" then
            return children[1]:ScrollAction("RightShoulder")
          else
            return children[1]:ScrollActionUnbound("RightShoulder")
          end
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "ScrollAction(self, shortcut)",
      "func",
      function(self, shortcut)
        local slider = self
        local prop = slider.BindTo
        local obj = slider.context
        local amount = obj:GetProperty(prop)
        local prop_meta = obj:GetPropertyMetadata(prop)
        local step = shortcut == "LeftShoulder" and -(prop_meta.step or 1) or prop_meta.step or 1
        local new_amount = amount + step
        local min = type(prop_meta.min) == "function" and prop_meta.min(obj) or prop_meta.min
        local max = type(prop_meta.max) == "function" and prop_meta.max(obj) or prop_meta.max
        if min then
          new_amount = Max(new_amount, min)
        end
        if max then
          new_amount = Min(new_amount, max)
        end
        obj:SetProperty(prop, new_amount)
        ObjModified(obj)
        return "break"
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "ScrollActionUnbound(self, shortcut)",
      "func",
      function(self, shortcut)
        local slider = self
        local amount = slider.Scroll
        local min = slider.Min
        local max = slider.Max
        local step = (shortcut == "LeftShoulder" and -1 or 1) * self.StepSize
        local new_amount = amount + step
        if min then
          new_amount = Max(new_amount, min)
        end
        if max then
          new_amount = Min(new_amount, max)
        end
        slider:ScrollTo(new_amount)
        return "break"
      end
    })
  })
})
