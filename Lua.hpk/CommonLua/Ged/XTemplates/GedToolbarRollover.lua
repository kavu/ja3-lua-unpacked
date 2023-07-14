PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "GedControls",
  id = "GedToolbarRollover",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XRolloverWindow",
    "MaxWidth",
    400
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
          local rollover = context.control:GetRolloverText()
          parent:SetTranslate(IsT(rollover))
          parent:SetText(rollover)
        end
      })
    })
  })
})
