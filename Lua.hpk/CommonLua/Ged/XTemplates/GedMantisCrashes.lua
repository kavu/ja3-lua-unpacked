PlaceObj("XTemplate", {
  group = "GedApps",
  id = "GedMantisCrashes",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Title",
    "Mantis Crashes",
    "AppId",
    "Mantis Crashes"
  }, {
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedListPanel",
      "Id",
      "idUsers",
      "Title",
      "Users",
      "Format",
      "<EditorView>",
      "SelectionBind",
      "SelectedUser"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XPanelSizer"
    }),
    PlaceObj("XTemplateWindow", nil, {
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return "SelectedUser"
        end,
        "__class",
        "GedListPanel",
        "Id",
        "idCrashes",
        "Title",
        "Crashes",
        "Format",
        "<EditorView>",
        "SelectionBind",
        "SelectedObject",
        "OnDoubleClick",
        function(self, item_idx)
          self.connection:Send("rfnRunGlobal", "GedMantisCrashesRun", self.context, item_idx)
        end
      }),
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return "SelectedUser"
        end,
        "__class",
        "GedPropPanel",
        "Dock",
        "bottom",
        "Title",
        "Props",
        "EnableSearch",
        false,
        "DisplayWarnings",
        false,
        "EnableUndo",
        false,
        "EnableCollapseDefault",
        false,
        "EnableShowInternalNames",
        false,
        "EnableCollapseCategories",
        false,
        "HideFirstCategory",
        true
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XPanelSizer"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "SelectedObject"
      end,
      "__class",
      "GedPropPanel"
    })
  })
})
