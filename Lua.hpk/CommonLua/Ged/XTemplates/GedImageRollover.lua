PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "GedControls",
  id = "GedImageRollover",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XRolloverWindow",
    "MaxWidth",
    400
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "MaxWidth",
      1366,
      "MaxHeight",
      768,
      "ImageFit",
      "scale-down"
    }, {
      PlaceObj("XTemplateCode", {
        "run",
        function(self, parent, context)
          parent:SetImage(context.control:GetRolloverText())
        end
      })
    }),
    PlaceObj("XTemplateWindow", {"__class", "XText"}, {
      PlaceObj("XTemplateCode", {
        "run",
        function(self, parent, context)
          local text = context.control:GetRolloverText()
          local width, height = UIL.MeasureImage(text)
          parent:SetText(tostring(width) .. "x" .. tostring(height))
        end
      })
    })
  })
})
