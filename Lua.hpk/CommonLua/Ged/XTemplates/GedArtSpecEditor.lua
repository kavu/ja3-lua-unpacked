PlaceObj("XTemplate", {
  group = "GedApps",
  id = "GedArtSpecEditor",
  save_in = "Ged",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "PresetEditor"
  }, {
    PlaceObj("XTemplateCode", {
      "comment",
      "Setup custom delete op",
      "run",
      function(self, parent, context)
        parent.idPresets.Delete = "GedOpDeleteEntitySpecs"
      end
    }),
    PlaceObj("XTemplateCode", {
      "comment",
      "Remove warning from middle panel",
      "run",
      function(self, parent, context)
        parent.idPresetContent:SetDisplayWarnings(false)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "CleanupObsoleteAssets",
      "ActionSortKey",
      "2",
      "ActionName",
      T(300345162237, "Clean-up Obsolete Assets"),
      "ActionIcon",
      "CommonAssets/UI/Ged/cleaning_brush.tga",
      "ActionMenubar",
      "Edit",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpCleanupObsoleteAssets", false, "assets")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "CleanupObsoleteMappings",
      "ActionSortKey",
      "2",
      "ActionName",
      T(801994818389, "Clean-up Obsolete Mappings"),
      "ActionIcon",
      "CommonAssets/UI/Ged/cleaning_brush.tga",
      "ActionMenubar",
      "Edit",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpCleanupObsoleteAssets", false, "mappings")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "CleanupObsoleteMappings",
      "ActionSortKey",
      "3",
      "ActionName",
      T(667525727814, "Search for Entity Usage"),
      "ActionIcon",
      "CommonAssets/UI/Ged/explorer.tga",
      "ActionMenubar",
      "Edit",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Op("CheckEntityUsage", "root", host.idPresets:GetMultiSelection())
      end
    })
  })
})
