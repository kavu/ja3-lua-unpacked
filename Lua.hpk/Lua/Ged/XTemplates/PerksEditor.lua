PlaceObj("XTemplate", {
  __is_kind_of = "GedApp",
  group = "Zulu Dev",
  id = "PerksEditor",
  save_in = "GameGed",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "PresetEditor"
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "AddPerk",
      "ActionName",
      T(607410363628, "Add Perk"),
      "ActionIcon",
      "CommonAssets/UI/Ged/plus-one.tga",
      "ActionToolbar",
      "main",
      "ActionToolbarSplit",
      true,
      "OnAction",
      function(self, host, source, ...)
        local panel = host:GetLastFocusedPanel()
        if panel == host.idPresets then
          host:Op("AddPerk", panel.context, panel:GetMultiSelection(), host.PresetClass)
        end
      end,
      "replace_matching_id",
      true
    })
  })
})
