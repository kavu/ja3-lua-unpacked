PlaceObj("XTemplate", {
  group = "GedApps",
  id = "SoundTypeEditor",
  save_in = "Ged",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "PresetEditor",
    "Title",
    "Sound Type Editor"
  }, {
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "stats"
      end,
      "__parent",
      function(parent, context)
        return parent.idProps
      end,
      "__class",
      "GedPropPanel",
      "Id",
      "SoundPresetInfo",
      "Dock",
      "bottom",
      "Title",
      "Stats",
      "EnableSearch",
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
      "__class",
      "XPanelSizer"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "active_sounds"
      end,
      "__class",
      "GedPropPanel",
      "Id",
      "ActiveSoundsInfo",
      "Title",
      "Active Sounds",
      "EnableSearch",
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
  })
})
