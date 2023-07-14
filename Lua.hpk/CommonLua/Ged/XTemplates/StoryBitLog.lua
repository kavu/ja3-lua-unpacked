PlaceObj("XTemplate", {
  group = "GedApps",
  id = "StoryBitLog",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Title",
    "Story Bit Log"
  }, {
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedTreePanel",
      "Id",
      "idTreePanel",
      "Title",
      "StoryBit Log"
    })
  })
})
