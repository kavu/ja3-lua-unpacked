PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "PreGameMenu",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDialog",
    "gamestate",
    "pregame_menu"
  }, {
    PlaceObj("XTemplateWindow", {
      "comment",
      "change charpness to 0 on open and reset on close",
      "__class",
      "XHROption",
      "Option",
      "Sharpness",
      "Value",
      0
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XDialog.Open(self, ...)
        ShowMouseCursor("PreGame")
        SetDisableMouseViaGamepad(false, "PreGameMenu")
        if Platform.xbox and XboxNewDlc then
          XboxNewDlc = false
          self:CreateThread("XboxDlc", function()
            LoadDlcs("force reload")
            OpenPreGameMainMenu("")
          end)
        end
        RemoveOutdatedMods(self)
        ChangeMap(GetMainMenuMapName())
        CreateRealTimeThread(function()
          WaitNextFrame()
          LockCamera("MainMenu")
        end)
        if Platform.steam_thq_wrapper then
          THQSteamWrapperEnableEpicAccountControl(true)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Close",
      "func",
      function(self, ...)
        XDialog.Close(self, ...)
        UnlockCamera("MainMenu")
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete",
      "func",
      function(self, ...)
        HideMouseCursor("PreGame")
        Msg("PreGameMenuClose")
        if Platform.steam_thq_wrapper then
          THQSteamWrapperEnableEpicAccountControl(false)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDialogModeChange(self, mode, dialog)",
      "func",
      function(self, mode, dialog)
        if mode == "" and Platform.steam_thq_wrapper then
          THQSteamWrapperEnableEpicAccountControl(true)
        end
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContentTemplate",
      "IdNode",
      false
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "RespawnContent(self)",
        "func",
        function(self)
          XContentTemplate.RespawnContent(self)
          ObjModified("mm-buttons")
        end
      }),
      PlaceObj("XTemplateMode", nil, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "PGMainActions"
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "Options"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "OptionsActions"
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "NewGame"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "NewGameActions"
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
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "LoadWIP"}, {
        PlaceObj("XTemplateAction", {
          "ActionId",
          "idBack",
          "ActionName",
          T(116709606999, "BACK"),
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
            host:SetMode("")
            host:ResolveId("idSubContent"):SetMode("empty")
            host:ResolveId("idSubSubContent"):SetMode("empty")
            host:ResolveId("idSubMenuTittle"):SetText(T(""))
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
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "ModManager"}, {
        PlaceObj("XTemplateTemplate", {
          "__condition",
          function(parent, context)
            return false
          end,
          "__template",
          "ModManagerDialog"
        }),
        PlaceObj("XTemplateTemplate", {
          "__template",
          "ModManagerActions"
        })
      }),
      PlaceObj("XTemplateMode", {
        "mode",
        "Multiplayer"
      }, {
        PlaceObj("XTemplateAction", {
          "ActionId",
          "idBack",
          "ActionName",
          T(116709606999, "BACK"),
          "ActionToolbar",
          "mainmenu",
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
          "OnAction",
          function(self, host, source, ...)
            if not Game and not GetPreGameMainMenu() then
              MultiplayerLobbySetUI("multiplayer")
            else
              local mp = GetMultiplayerLobbyDialog()
              if not mp or mp:ResolveId("idSubContent").Mode ~= "multiplayer_guest" and mp:ResolveId("idSubContent").Mode ~= "multiplayer_host" then
                MultiplayerLobbySetUI("empty", "unlist")
              else
                MultiplayerLobbySetUI("multiplayer")
              end
            end
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
        })
      })
    }),
    PlaceObj("XTemplateTemplate", {"__template", "MainMenu"}),
    PlaceObj("XTemplateWindow", {
      "Padding",
      box(0, 0, 32, 18)
    })
  })
})
