PlaceObj("XTemplate", {
  group = "GedApps",
  id = "ClassDefEditor",
  save_in = "Ged",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "PresetEditor"
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "OpenEditor",
      "ActionSortKey",
      "2",
      "ActionName",
      T(419747557885, "Open Preset Editor"),
      "ActionIcon",
      "CommonAssets/UI/Ged/explorer.tga",
      "ActionToolbar",
      "main",
      "ActionToolbarSplit",
      true,
      "ActionState",
      function(self, host)
        local class = g_Classes[rawget(host, "selected_class")]
        return not IsKindOf(class, "PresetDef") and "hidden"
      end,
      "OnAction",
      function(self, host, source, ...)
        local panel = host.idPresets
        host:Op("GedOpOpenPresetEditor", panel.context, panel:GetMultiSelection(), host.PresetClass)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "SelectedPreset"
      end,
      "__class",
      "GedBindView",
      "BindView",
      "class",
      "BindFunc",
      "GedGetObjectClass",
      "OnViewChanged",
      function(self, value, control)
        local app = GetParentOfKind(self, "GedApp")
        rawset(app, "selected_class", value)
        app:ActionsUpdated()
      end
    })
  })
})
