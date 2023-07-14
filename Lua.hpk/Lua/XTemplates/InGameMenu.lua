PlaceObj("XTemplate", {
  group = "Zulu",
  id = "InGameMenu",
  PlaceObj("XTemplateWindow", {
    "__class",
    "ZuluModalDialog",
    "ZOrder",
    99,
    "HideInScreenshots",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XCameraLockLayer",
      "lock_id",
      "InGameMenu"
    }),
    PlaceObj("XTemplateLayer", {
      "__condition",
      function(parent, context)
        return not IsInMultiplayerGame()
      end,
      "layer",
      "XPauseLayer"
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete",
      "func",
      function(self, ...)
        Msg("InGameMenuClose")
        PlayFX("MainMenuClose", "start")
        if table.changed(hr, "InGameMenu-Particles") then
          table.restore(hr, "InGameMenu-Particles")
          table.restore(hr, "InGameMenu-Rain")
          table.restore(hr, "InGameMenu-Marking")
          HideCombatUI(false)
          HideInWorldCombatUI(false)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        ZuluModalDialog.Open(self, ...)
        PlayFX("MainMenuOpen", "start")
        if not GetDialog("PDADialog") and not GetDialog("PDADialogSatellite") and not IsInMultiplayerGame() then
          table.change(hr, "InGameMenu-Particles", {SimulateParticles = 0})
          HideCombatUI(true)
          HideInWorldCombatUI(true)
          table.change(hr, "InGameMenu-Rain", {RenderRain = 0})
          table.change(hr, "InGameMenu-Marking", {EnableObjectMarking = 0})
        end
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__condition",
      function(parent, context)
        return not GetDialog("PDADialog") and not GetDialog("PDADialogSatellite") and not IsInMultiplayerGame()
      end,
      "__class",
      "XBlurRect",
      "TintColor",
      RGBA(255, 255, 255, 255),
      "BlurRadius",
      15,
      "Desaturation",
      80
    }),
    PlaceObj("XTemplateWindow", {
      "__condition",
      function(parent, context)
        return GetDialog("PDADialog") or GetDialog("PDADialogSatellite")
      end,
      "Id",
      "idVignette",
      "Dock",
      "box",
      "Background",
      RGBA(30, 30, 35, 115),
      "Transparency",
      255
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Image",
        "UI/Vignette_2",
        "ImageFit",
        "stretch"
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "Open(self)",
        "func",
        function(self)
          XWindow.Open(self)
          self:SetTransparency(0, 600)
        end
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Close(self)",
      "func",
      function(self)
        if not self.idVignette then
          XWindow.Close(self)
          return
        end
        if self:GetThread("close-later") then
          return
        end
        self:SetBackground(0)
        self:SetId("")
        self.idContent:SetVisible(false)
        if self.idMainMenu then
          self.idMainMenu:SetVisible(false)
        end
        self.idVignette:SetTransparency(255, 400)
        self:CreateThread("close-later", function()
          Sleep(450)
          self:delete()
        end)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContentTemplate",
      "Id",
      "idContent",
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
          local mainMenuModes = {
            "Options",
            "",
            "SaveWIP",
            "LoadWIP",
            "replays",
            "Multiplayer"
          }
          local currentMode = GetDialog(self).Mode
          if not table.find(mainMenuModes, currentMode) and self:ResolveId("idMainMenu") then
            self:ResolveId("idMainMenu"):Done()
          end
        end
      }),
      PlaceObj("XTemplateAction", {
        "comment",
        "--gamepad close the menu",
        "ActionId",
        "idClose",
        "ActionGamepad",
        "Start",
        "OnAction",
        function(self, host, source, ...)
          local popup = host:ResolveId("idSubSubContent"):ResolveId("idItemsContent")
          if popup then
            popup:Close()
          end
          local dlg = host:ResolveId("idSubContent")
          local currentOpened = GetDialogModeParam(dlg)
          local mode = GetDialogMode(dlg)
          if currentOpened and mode == "options" then
            if currentOpened.optObj.id == "Display" then
              CancelDisplayOptions(host:ResolveId("idSubMenu"), "clear")
            else
              CancelOptions(host:ResolveId("idSubMenu"), "clear")
            end
          end
          CloseIngameMainMenu()
        end,
        "FXPress",
        "MainMenuButtonClick"
      }),
      PlaceObj("XTemplateMode", nil, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "IGMainActions",
          "Id",
          "idActions"
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "Options"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "OptionsActions"
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
          T(482997512259, "BACK"),
          "ActionToolbar",
          "mainmenu",
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
          "OnAction",
          function(self, host, source, ...)
            if not Game then
              MultiplayerLobbySetUI("multiplayer")
            else
              MultiplayerLobbySetUI("empty")
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
      }),
      PlaceObj("XTemplateMode", {"mode", "LoadWIP"}, {
        PlaceObj("XTemplateAction", {
          "ActionId",
          "idBack",
          "ActionName",
          T(482997512259, "BACK"),
          "ActionToolbar",
          "mainmenu",
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
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
      PlaceObj("XTemplateMode", {"mode", "SaveWIP"}, {
        PlaceObj("XTemplateAction", {
          "ActionId",
          "idBack",
          "ActionName",
          T(482997512259, "BACK"),
          "ActionToolbar",
          "mainmenu",
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
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
      PlaceObj("XTemplateMode", {"mode", "LoadOld"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "SaveLoadGameDialog"
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "idClose",
          "ActionName",
          T(374427918878, "Close"),
          "ActionToolbar",
          "ActionBar",
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
          "OnActionEffect",
          "close",
          "FXPress",
          "MainMenuButtonClick"
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "SaveOld"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "SaveLoadGameDialog",
          "InitialMode",
          "save"
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "idClose",
          "ActionName",
          T(374427918878, "Close"),
          "ActionToolbar",
          "ActionBar",
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
          "OnActionEffect",
          "close",
          "FXPress",
          "MainMenuButtonClick"
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "AddMerc"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "AddMercList"
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "idClose",
          "ActionName",
          T(374427918878, "Close"),
          "ActionToolbar",
          "ActionBar",
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
          "OnActionEffect",
          "close",
          "FXPress",
          "MainMenuButtonClick"
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "RemoveMerc"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "RemoveMercList"
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "idClose",
          "ActionName",
          T(374427918878, "Close"),
          "ActionToolbar",
          "ActionBar",
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
          "OnActionEffect",
          "close",
          "FXPress",
          "MainMenuButtonClick"
        })
      }),
      PlaceObj("XTemplateMode", {
        "mode",
        "PresetSquad"
      }, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "PresetSquadList"
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "idClose",
          "ActionName",
          T(374427918878, "Close"),
          "ActionToolbar",
          "ActionBar",
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
          "OnActionEffect",
          "close",
          "FXPress",
          "MainMenuButtonClick"
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "AddWeapon"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "AddWeaponList"
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "idClose",
          "ActionName",
          T(374427918878, "Close"),
          "ActionToolbar",
          "ActionBar",
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
          "OnActionEffect",
          "close",
          "FXPress",
          "MainMenuButtonClick"
        })
      }),
      PlaceObj("XTemplateMode", {
        "mode",
        "MercHireStatus"
      }, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "SetMercHireStatusList"
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "idClose",
          "ActionName",
          T(374427918878, "Close"),
          "ActionToolbar",
          "ActionBar",
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
          "OnActionEffect",
          "close",
          "FXPress",
          "MainMenuButtonClick"
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "CombatTest"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "CombatTestList"
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "idClose",
          "ActionName",
          T(374427918878, "Close"),
          "ActionToolbar",
          "ActionBar",
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
          "OnActionEffect",
          "close",
          "FXPress",
          "MainMenuButtonClick"
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "Cheats"}, {
        PlaceObj("XTemplateTemplate", {"__template", "CheatsList"})
      }),
      PlaceObj("XTemplateMode", {
        "mode",
        "SetLoyaltyCheat"
      }, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "SetLoyaltyCheat"
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "idClose",
          "ActionName",
          T(374427918878, "Close"),
          "ActionToolbar",
          "ActionBar",
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
          "OnActionEffect",
          "close",
          "FXPress",
          "MainMenuButtonClick"
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "replays"}, {
        PlaceObj("XTemplateAction", {
          "ActionId",
          "idBack",
          "ActionName",
          T(482997512259, "BACK"),
          "ActionToolbar",
          "mainmenu",
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
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
        })
      })
    }),
    PlaceObj("XTemplateTemplate", {"__template", "MainMenu"})
  })
})
