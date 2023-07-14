PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAGenericCloseAction",
  PlaceObj("XTemplateAction", {
    "ActionId",
    "PDACloseOrBackTab",
    "ActionSortKey",
    "999",
    "ActionName",
    T(567724535949, "Close"),
    "ActionToolbar",
    "ActionBar",
    "ActionShortcut",
    "Escape",
    "ActionGamepad",
    "ButtonB",
    "OnAction",
    function(self, host, source, ...)
      local dlg = GetDialog(host)
      dlg:CloseAction(host)
    end
  })
})
