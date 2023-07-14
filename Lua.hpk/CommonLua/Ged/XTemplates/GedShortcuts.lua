PlaceObj("XTemplate", {
  group = "Shortcuts",
  id = "GedShortcuts",
  save_in = "Ged",
  PlaceObj("XTemplateAction", {
    "comment",
    "Show console (Alt-Enter)",
    "ActionId",
    "DE_Console",
    "ActionTranslate",
    false,
    "ActionShortcut",
    "Alt-Enter",
    "OnAction",
    function(self, host, source, ...)
      ShowConsole(true)
    end,
    "__condition",
    function(parent, context)
      return Platform.developer
    end,
    "replace_matching_id",
    true
  }),
  PlaceObj("XTemplateAction", {
    "comment",
    "Inspect a live XWindow, its children, properties, focus, mouse target, etc. (Alt-X)",
    "RolloverText",
    "Inspect a live XWindow, its children, properties, focus, mouse target, etc. (Alt-X)",
    "ActionId",
    "DE_XWindowInspector",
    "ActionTranslate",
    false,
    "ActionName",
    "XWindow Inspector",
    "ActionShortcut",
    "Alt-X",
    "OnAction",
    function(self, host, source, ...)
      local dark_mode
      local ged_app = GetChildrenOfKind(terminal.desktop, "GedApp")
      if ged_app[1] then
        dark_mode = ged_app[1].dark_mode
      else
        dark_mode = GetDarkModeSetting()
      end
      OpenXWindowInspector({
        EditorShortcut = self.ActionShortcut,
        dark_mode = dark_mode
      })
    end,
    "__condition",
    function(parent, context)
      return Platform.developer
    end,
    "replace_matching_id",
    true
  })
})
