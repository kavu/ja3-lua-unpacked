PlaceObj("XTemplate", {
  __is_kind_of = "XContextImage",
  group = "Zulu Badges",
  id = "CoOpOtherPlayerMark",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextImage",
    "MinWidth",
    25,
    "MinHeight",
    25,
    "MaxWidth",
    25,
    "MaxHeight",
    25,
    "UseClipBox",
    false,
    "Image",
    "UI/Hud/coop_partner",
    "ImageFit",
    "stretch"
  }, {
    PlaceObj("XTemplateWindow", {
      "comment",
      "observer",
      "__context",
      function(parent, context)
        return "co-op-ui"
      end,
      "__class",
      "XContextWindow",
      "OnContextUpdate",
      function(self, context, ...)
        self.parent:OnContextUpdate(self.parent.context)
      end
    })
  })
})
