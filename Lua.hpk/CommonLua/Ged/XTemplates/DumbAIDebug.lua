PlaceObj("XTemplate", {
  group = "GedApps",
  id = "DumbAIDebug",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Title",
    "DumbAI Debugger",
    "MenubarTemplate",
    ""
  }, {
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedTextPanel",
      "Id",
      "idAIState",
      "Title",
      "Current State",
      "FormatFunc",
      "GedDumbAIDebugState"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedListPanel",
      "Id",
      "idAILog",
      "Title",
      "Actions log",
      "FormatFunc",
      "GedDumbAIDebugLog",
      "SelectionBind",
      "log_entry"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "log_entry"
      end,
      "__class",
      "GedTextPanel",
      "Id",
      "idAIState",
      "Title",
      "Current State",
      "FormatFunc",
      "GedDumbAIDebugLogEntry"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "AIThink",
      "ActionName",
      T(642175611267, "AI Think"),
      "ActionIcon",
      "CommonAssets/UI/Ged/preview.tga",
      "ActionMenubar",
      "main",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Send("GedCallMethod", "root", "AIThink")
      end
    })
  })
})
