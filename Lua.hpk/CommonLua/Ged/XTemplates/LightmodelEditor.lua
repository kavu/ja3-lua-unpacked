PlaceObj("XTemplate", {
  group = "GedApps",
  id = "LightmodelEditor",
  save_in = "Ged",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "PresetEditor"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "ReloadImage",
      "func",
      function(self, ...)
        local texture = (...)
        print("Reloading " .. texture)
        FindXImagesAndReload(texture)
        local result = UIL.ReloadImage(texture)
        print("Reloaded", texture, result)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Lightmodel",
      "ActionSortKey",
      "2",
      "ActionName",
      T(827990586334, "Light model"),
      "ActionMenubar",
      "main",
      "ActionToolbar",
      "main",
      "OnActionEffect",
      "popup"
    }, {
      PlaceObj("XTemplateAction", {
        "ActionId",
        "take_screenshots",
        "ActionName",
        T(791247269670, "Take Screenshots"),
        "ActionIcon",
        "CommonAssets/UI/Ged/camera",
        "ActionToolbar",
        "main",
        "ActionToolbarSplit",
        true,
        "OnAction",
        function(self, host, source, ...)
          host:Send("GedCustomEditorAction", "SelectedPreset", "LightmodelEditorTakeScreenshots")
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "histogram",
        "ActionName",
        T(185656301873, "Histograms"),
        "ActionIcon",
        "CommonAssets/UI/Ged/camera",
        "ActionToolbar",
        "main",
        "ActionToolbarSplit",
        true,
        "OnAction",
        function(self, host, source, ...)
          host:Send("GedToggleHistogram")
        end
      })
    })
  })
})
