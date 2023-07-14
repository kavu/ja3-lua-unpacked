PlaceObj("XTemplate", {
  group = "Zulu",
  id = "QuestsEditor",
  save_in = "GameGed",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "PresetEditor",
    "Title",
    "Quests Editor"
  }, {
    PlaceObj("XTemplateCode", {
      "comment",
      "custom Delete op for quests",
      "run",
      function(self, parent, context)
        parent.idPresets.Delete = "GedOpDeleteQuest"
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XPanelSizer"
    }),
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
      "Runtime State",
      "SearchHistory",
      5,
      "DisplayWarnings",
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
