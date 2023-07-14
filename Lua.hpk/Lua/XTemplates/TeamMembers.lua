PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "Zulu",
  id = "TeamMembers",
  PlaceObj("XTemplateWindow", {
    "comment",
    "Top left party window",
    "__context",
    function(parent, context)
      return "hud_squads"
    end,
    "__class",
    "XContentTemplate",
    "Id",
    "idParty",
    "HAlign",
    "left",
    "VAlign",
    "top",
    "LayoutMethod",
    "VList"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "RespawnContent(self, ...)",
      "func",
      function(self, ...)
        if UIRebuildSpam then
          DbgUIRebuild("party ui")
        end
        XContentTemplate.RespawnContent(self, ...)
      end
    }),
    PlaceObj("XTemplateTemplate", {
      "__context",
      function(parent, context)
        return GetSquadsOnMapUI()
      end,
      "__template",
      "SquadsAndMercs"
    })
  })
})
