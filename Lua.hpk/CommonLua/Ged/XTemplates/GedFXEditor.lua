PlaceObj("XTemplate", {
  RequireActionSortKeys = true,
  group = "GedApps",
  id = "GedFXEditor",
  save_in = "Ged",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "PresetEditor"
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Tools",
      "ActionSortKey",
      "3",
      "ActionName",
      T(463447631288, "Tools"),
      "ActionMenubar",
      "main",
      "OnActionEffect",
      "popup"
    }, {
      PlaceObj("XTemplateAction", {
        "ActionId",
        "UseAsFilter",
        "ActionSortKey",
        "4",
        "ActionName",
        T(540744150337, "Use as filter"),
        "ActionIcon",
        "CommonAssets/UI/Ged/filter",
        "ActionToolbar",
        "main",
        "OnAction",
        function(self, host, source, ...)
          local panel = host:GetLastFocusedPanel()
          if panel == host.idPresets and panel:GetSelection() then
            host:Op("GedOpFxUseAsFilter", panel.context, panel:GetSelection())
          end
        end,
        "ActionContexts",
        {
          "PresetsChildAction"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "CheckDuplicates",
        "ActionSortKey",
        "5",
        "ActionName",
        T(851805571588, "Check duplicates"),
        "ActionIcon",
        "CommonAssets/UI/Ged/collapse_node",
        "ActionToolbar",
        "main",
        "OnAction",
        function(self, host, source, ...)
          host:Op("GedOpFxCheckDuplicates")
        end
      })
    })
  })
})
