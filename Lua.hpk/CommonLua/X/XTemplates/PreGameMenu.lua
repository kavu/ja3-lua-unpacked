PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Common",
  id = "PreGameMenu",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDialog",
    "Background",
    RGBA(70, 70, 70, 255),
    "gamestate",
    "pregame_menu"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XDialog.Open(self, ...)
        ShowMouseCursor("PreGame")
        if Platform.xbox and XboxNewDlc then
          XboxNewDlc = false
          self:CreateThread("XboxDlc", function()
            LoadDlcs("force reload")
            OpenPreGameMainMenu()
          end)
        end
        RemoveOutdatedMods(self)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete",
      "func",
      function(self, ...)
        HideMouseCursor("PreGame")
        Msg("PreGameMenuClose")
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContentTemplate"
    }, {
      PlaceObj("XTemplateMode", nil, {
        PlaceObj("XTemplateTemplate", {"__template", "PGMain"})
      }),
      PlaceObj("XTemplateMode", {"mode", "Options"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "OptionsDialog"
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "Load"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "SaveLoadGameDialog"
        })
      })
    })
  })
})
