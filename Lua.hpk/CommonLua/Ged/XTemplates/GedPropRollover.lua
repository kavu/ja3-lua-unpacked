PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "GedControls",
  id = "GedPropRollover",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XRolloverWindow",
    "MaxWidth",
    800,
    "DrawOnTop",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Margins",
      box(8, 4, 8, 4)
    }, {
      PlaceObj("XTemplateCode", {
        "run",
        function(self, parent, context)
          parent:SetText(context.control:GetRolloverText())
        end
      })
    })
  })
})
