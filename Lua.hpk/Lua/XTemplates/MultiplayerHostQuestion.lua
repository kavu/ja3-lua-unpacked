PlaceObj("XTemplate", {
  group = "Zulu",
  id = "MultiplayerHostQuestion",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "ZuluMessageDialogTemplate",
    "HostInParent",
    false
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        ZuluModalDialog.Open(self, ...)
        self.idTitle:SetText(T(864295517686, "Host Game"))
        self.idText:SetText(T(634386990820, "Do you want to host a private or a public game?"))
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "public",
      "ActionName",
      T(600864774681, "Public"),
      "ActionToolbar",
      "ActionBar",
      "ActionShortcut",
      "P",
      "ActionGamepad",
      "ButtonA",
      "OnAction",
      function(self, host, source, ...)
        self.host:Close("public")
      end,
      "FXPress",
      "MainMenuButtonClick"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "private",
      "ActionName",
      T(454022690610, "Private"),
      "ActionToolbar",
      "ActionBar",
      "ActionShortcut",
      "R",
      "ActionGamepad",
      "ButtonX",
      "OnAction",
      function(self, host, source, ...)
        self.host:Close("private")
      end,
      "FXPress",
      "MainMenuButtonClick"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Close",
      "ActionName",
      T(607757565362, "Close"),
      "ActionToolbar",
      "ActionBar",
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "ButtonB",
      "OnAction",
      function(self, host, source, ...)
        self.host:Close()
      end,
      "FXPress",
      "MainMenuButtonClick"
    })
  })
})
