PlaceObj("XTemplate", {
  group = "Zulu Dev",
  id = "BanterEditor",
  save_in = "GameGed",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "PresetEditor",
    "Title",
    "Banter Editor"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XPanelSizer"
    }),
    PlaceObj("XTemplateWindow", nil, {
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return "state"
        end,
        "__class",
        "GedPropPanel",
        "Id",
        "idRuntimeState",
        "Title",
        "References",
        "EnableSearch",
        false,
        "ActionContext",
        "PropPanelAction",
        "SearchActionContexts",
        {
          "PropPanelAction",
          "PropAction"
        },
        "EnableUndo",
        false,
        "EnableCollapseDefault",
        false,
        "HideFirstCategory",
        true,
        "RootObjectBindName",
        "SelectedPreset",
        "PropActionContext",
        "PropAction"
      })
    })
  })
})
