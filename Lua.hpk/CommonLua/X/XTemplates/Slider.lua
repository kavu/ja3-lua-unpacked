PlaceObj("XTemplate", {
  __is_kind_of = "XScrollThumb",
  group = "Common",
  id = "Slider",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XScrollThumb",
    "Margins",
    box(0, 16, 0, 16),
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
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "parent",
      function(parent, context)
        return parent:ResolveId("node")
      end,
      "func",
      function(self, shortcut, source, ...)
        if shortcut == "LeftShoulder" or shortcut == "RightShoulder" then
          local children = GetChildrenOfKind(self, "XScrollThumb")
          if children and children[1] and children[1].BindTo then
            local slider = children[1]
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
        end
        return XSection.OnShortcut(self, shortcut, source, ...)
      end
    })
  })
})
