PlaceObj("XTemplate", {
  group = "Zulu",
  id = "NewGameActions",
  PlaceObj("XTemplateWindow", nil, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idBack",
      "ActionName",
      T(328568355435, "BACK"),
      "ActionToolbar",
      "mainmenu",
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "ButtonB",
      "OnActionEffect",
      "back",
      "OnAction",
      function(self, host, source, ...)
        if source and source.class == "XButton" then
          source:SetFocus(true)
        end
        host:ResolveId("idSubMenuTittle"):SetText(T(""))
        host:ResolveId("idSubContent"):SetMode("empty")
        XAction.OnAction(self, host, source)
      end,
      "FXPress",
      "MainMenuButtonClick"
    })
  })
})
