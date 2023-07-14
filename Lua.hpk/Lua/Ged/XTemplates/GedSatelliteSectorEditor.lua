PlaceObj("XTemplate", {
  group = "GedApps",
  id = "GedSatelliteSectorEditor",
  save_in = "GameGed",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Title",
    "Satellite Sectors Editor",
    "AppId",
    "GedSatelliteSectorEditor",
    "CommonActionsInMenubar",
    false,
    "CommonActionsInToolbar",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "MinWidth",
      300,
      "LayoutMethod",
      "VPanel"
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "filter",
        "__context",
        function(parent, context)
          return "SectorsFilter"
        end,
        "__class",
        "GedPropPanel",
        "Id",
        "idSectorsFilter",
        "Dock",
        "bottom",
        "Title",
        "Filter",
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
      }),
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return "root"
        end,
        "__class",
        "GedListPanel",
        "Id",
        "idSectors",
        "Title",
        "Satellite Sectors",
        "FilterName",
        "SectorsFilter",
        "FilterClass",
        "SatelliteSectorGedFilter",
        "SelectionBind",
        "SelectedObject",
        "MultipleSelection",
        true
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "SelectedObject"
      end,
      "__class",
      "GedPropPanel",
      "MinWidth",
      500,
      "Title",
      "Properties",
      "ActionsClass",
      "PropertyObject",
      "Copy",
      "GedOpPropertyCopy",
      "Paste",
      "GedOpPropertyPaste"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Save",
      "ActionName",
      T(759599468155, "Save"),
      "ActionIcon",
      "CommonAssets/UI/Ged/save.tga",
      "ActionToolbar",
      "main",
      "ActionShortcut",
      "Ctrl-S",
      "OnAction",
      function(self, host, source, ...)
        host:Send("GedPresetSave", "SelectedPrg", "CampaignPreset", "force_save")
      end
    })
  })
})
