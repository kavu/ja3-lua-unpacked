PlaceObj("XTemplate", {
  group = "Zulu",
  id = "ModManagerActions",
  PlaceObj("XTemplateWindow", nil, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idBack",
      "ActionName",
      T(991483755533, "BACK"),
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
        CreateRealTimeThread(function(self, host, source)
          if source and source.class == "XButton" then
            source:SetFocus(true)
          end
          OnModManagerClose(GetPreGameMainMenu())
          host:ResolveId("idSubMenuTittle"):SetText(T(""))
          host:ResolveId("idSubMenuTittleDescr"):SetText(T(""))
          host:ResolveId("idSubContent"):SetMode("empty")
          host:ResolveId("idSubSubContent"):SetMode("empty")
          XAction.OnAction(self, host, source)
        end, self, host, source)
      end,
      "FXPress",
      "MainMenuButtonClick"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idGoToSubMenu",
      "ActionGamepad",
      "DPadRight",
      "ActionState",
      function(self, host)
        return GoToSubMenu_ActionState(self, host)
      end,
      "OnAction",
      function(self, host, source, ...)
        GoToSubMenu_OnAction(self, host, source, ...)
      end,
      "FXPress",
      "MainMenuButtonClick"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idGoToSubMenu",
      "ActionGamepad",
      "LeftThumbRight",
      "ActionState",
      function(self, host)
        return GoToSubMenu_ActionState(self, host)
      end,
      "OnAction",
      function(self, host, source, ...)
        GoToSubMenu_OnAction(self, host, source, ...)
      end,
      "FXPress",
      "MainMenuButtonClick"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idInstalledMods",
      "ActionName",
      T(395229437627, "Installed Mods"),
      "ActionToolbar",
      "mainmenu",
      "OnAction",
      function(self, host, source, ...)
        XAction.OnAction(self, host, source)
      end,
      "FXPress",
      "MainMenuButtonClick"
    })
  })
})
