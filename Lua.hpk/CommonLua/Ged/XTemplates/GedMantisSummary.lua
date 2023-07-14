PlaceObj("XTemplate", {
  group = "GedApps",
  id = "GedMantisSummary",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Title",
    "Mantis Summary",
    "AppId",
    "MantisSummary"
  }, {
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedTreePanel",
      "Title",
      "Mantis Summary by People",
      "Format",
      "<EditorView>",
      "OnDoubleClick",
      function(self, selection)
        self.connection:Send("rfnRunGlobal", "GedOpenMantisUser", selection)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "tags"
      end,
      "__class",
      "GedListPanel",
      "Title",
      "Mantis Summary by Tags",
      "ActionsClass",
      "PropertyObject",
      "MoveUp",
      "GedOpListMoveUp",
      "MoveDown",
      "GedOpListMoveDown",
      "Delete",
      "GedOpListDeleteItem",
      "Cut",
      "GedOpListCut",
      "Copy",
      "GedOpListCopy",
      "Paste",
      "GedOpListPaste",
      "Duplicate",
      "GedOpListDuplicate",
      "Format",
      "<tag>: <count>",
      "OnDoubleClick",
      function(self, item_idx)
        self.connection:Send("rfnRunGlobal", "GedOpenMantisTag", item_idx)
      end
    })
  })
})
