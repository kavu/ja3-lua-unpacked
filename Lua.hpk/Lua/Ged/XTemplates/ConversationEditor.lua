PlaceObj("XTemplate", {
  group = "Zulu Dev",
  id = "ConversationEditor",
  save_in = "GameGed",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "PresetEditor"
  }, {
    PlaceObj("XTemplateCode", {
      "run",
      function(self, parent, context)
        parent.idPresetContent.Delete = "GedOpDeleteConversationPhrase"
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "state"
      end,
      "__parent",
      function(parent, context)
        return parent:ResolveId("idProps")
      end,
      "__class",
      "GedPropPanel",
      "Id",
      "idRuntimeState",
      "Dock",
      "bottom",
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
      "EnableShowInternalNames",
      false,
      "EnableCollapseCategories",
      false,
      "HideFirstCategory",
      true,
      "RootObjectBindName",
      "SelectedPreset",
      "PropActionContext",
      "PropAction"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "SelectedObject"
      end,
      "__class",
      "GedBindView",
      "BindView",
      "class",
      "BindFunc",
      "GedGetObjectClass",
      "OnViewChanged",
      function(self, value, control)
        self:ResolveId("idProps").idRuntimeState:SetVisible(value == "Conversation")
      end
    })
  })
})
