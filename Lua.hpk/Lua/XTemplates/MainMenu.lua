PlaceObj("XTemplate", {
  group = "Zulu",
  id = "MainMenu",
  PlaceObj("XTemplateWindow", {
    "Id",
    "idMainMenu",
    "OnLayoutComplete",
    function(self)
      if GetDialog("PDADialog") then
        GetDialog("InGameMenu"):SetBackground(RGBA(30, 30, 35, 165))
      end
      self.desktop:SetMouseCursor("UI/Cursors/Cursor.tga")
    end,
    "LayoutMethod",
    "HList",
    "UseClipBox",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return false
      end,
      "__class",
      "XHideDialogs",
      "LeaveDialogIds",
      {
        "PDADialog",
        "InGameInterface",
        "FullscreenGameDialogs",
        "PDADialogSatellite"
      }
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        self.desktop:SetKeyboardFocus(false)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "main menu nav",
      "Id",
      "idMainMenuNav",
      "Margins",
      box(100, 0, 0, 0),
      "HAlign",
      "left",
      "LayoutMethod",
      "Grid",
      "UseClipBox",
      false
    }, {
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return not GetDialog("PDADialog") and not g_SatelliteUI
        end,
        "__class",
        "XBlurRect",
        "Margins",
        box(90, 0, 90, 0),
        "Dock",
        "box",
        "HandleKeyboard",
        false,
        "BlurRadius",
        10,
        "Mask",
        "UI/Common/mm_background"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "Id",
        "idEffect",
        "Margins",
        box(93, 0, 97, 0),
        "Dock",
        "box",
        "Transparency",
        179,
        "HandleKeyboard",
        false,
        "Image",
        "UI/Common/screen_effect",
        "ImageScale",
        point(3550, 1000),
        "TileFrame",
        true,
        "SqueezeX",
        false,
        "SqueezeY",
        false
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "strip",
        "__class",
        "XFrame",
        "UIEffectModifierId",
        "MainMenuMainBar",
        "Dock",
        "box",
        "HAlign",
        "center",
        "UseClipBox",
        false,
        "Transparency",
        64,
        "HandleKeyboard",
        false,
        "Image",
        "UI/Common/mm_background",
        "FrameBox",
        box(100, 0, 100, 0),
        "SqueezeX",
        false,
        "SqueezeY",
        false
      }),
      PlaceObj("XTemplateTemplate", {
        "__template",
        "MainMenuSquaresOnStrip"
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "demo title",
        "__condition",
        function(parent, context)
          return Platform.demo
        end,
        "__class",
        "AutoFitText",
        "Id",
        "idDemoTitle",
        "IdNode",
        false,
        "Margins",
        box(0, 50, 0, 0),
        "Dock",
        "box",
        "HAlign",
        "center",
        "VAlign",
        "top",
        "MinWidth",
        345,
        "MinHeight",
        70,
        "MaxWidth",
        345,
        "MaxHeight",
        70,
        "UseClipBox",
        false,
        "HandleKeyboard",
        false,
        "HandleMouse",
        false,
        "TextStyle",
        "MMSubemenuTitle",
        "Translate",
        true,
        "Text",
        T(603573144096, "DEMO"),
        "TextHAlign",
        "center",
        "TextVAlign",
        "center"
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "logo",
        "__class",
        "XImage",
        "Margins",
        box(0, 50, 0, 0),
        "Dock",
        "top",
        "HAlign",
        "center",
        "HandleKeyboard",
        false,
        "Image",
        "UI/Common/mm_ja3_logo",
        "ImageScale",
        point(500, 500)
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "sub menu title",
        "__class",
        "AutoFitText",
        "Id",
        "idSubMenuTittle",
        "IdNode",
        false,
        "Margins",
        box(0, -65, 0, 0),
        "HAlign",
        "center",
        "VAlign",
        "top",
        "MinWidth",
        345,
        "MinHeight",
        70,
        "MaxWidth",
        345,
        "MaxHeight",
        70,
        "UseClipBox",
        false,
        "HandleKeyboard",
        false,
        "HandleMouse",
        false,
        "TextStyle",
        "MMSubemenuTitle",
        "Translate",
        true,
        "TextHAlign",
        "center",
        "TextVAlign",
        "center"
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "sub menu title",
        "__class",
        "AutoFitText",
        "Id",
        "idSubMenuTittleDescr",
        "IdNode",
        false,
        "HAlign",
        "center",
        "VAlign",
        "top",
        "MinWidth",
        345,
        "MaxWidth",
        345,
        "UseClipBox",
        false,
        "HandleKeyboard",
        false,
        "HandleMouse",
        false,
        "TextStyle",
        "OptionsActionShortcutOff",
        "Translate",
        true,
        "HideOnEmpty",
        true,
        "TextHAlign",
        "center",
        "TextVAlign",
        "center"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XDialog",
        "Id",
        "idMainMenuButtonsContent",
        "IdNode",
        false,
        "Margins",
        box(0, 20, 0, 0),
        "HAlign",
        "center",
        "MinWidth",
        360,
        "MaxWidth",
        360,
        "GridY",
        2,
        "UseClipBox",
        false,
        "HostInParent",
        true,
        "InitialMode",
        "mm",
        "InternalModes",
        "mm, keybindings, multiplayer_games, multiplayer_host"
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "sub menu",
          "__context",
          function(parent, context)
            return "mm-buttons"
          end,
          "__class",
          "XContentTemplate",
          "Id",
          "idMainMenuButtons",
          "IdNode",
          false,
          "UseClipBox",
          false
        }, {
          PlaceObj("XTemplateMode", {"mode", "mm"}, {
            PlaceObj("XTemplateWindow", {"Id", "idCont"}, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "main buttons",
                "__class",
                "SnappingScrollArea",
                "Id",
                "idList",
                "IdNode",
                false,
                "BorderWidth",
                0,
                "Padding",
                box(0, 0, 0, 0),
                "OnLayoutComplete",
                function(self)
                  SnappingScrollArea.OnLayoutComplete(self)
                end,
                "BorderColor",
                RGBA(32, 32, 32, 0),
                "Background",
                RGBA(255, 255, 255, 0),
                "HandleMouse",
                false,
                "FocusedBackground",
                RGBA(255, 255, 255, 0),
                "VScroll",
                "idScroll",
                "GamepadInitialSelection",
                true,
                "KeepSelectionOnRespawn",
                true
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "GetItemCount(self)",
                  "func",
                  function(self)
                    return #self - self.docked_win_count + 1
                  end
                }),
                PlaceObj("XTemplateForEachAction", {
                  "toolbar",
                  "mainmenu",
                  "run_after",
                  function(child, context, action, n)
                    if action.ActionId == "idBack" or action.ActionId == "idQuit" then
                      child:SetDock("bottom")
                      child:SetMargins(box(0, 0, 0, 30))
                    end
                    if action.ActionId == "idHelp" then
                      local unreadTutorials = UnreadTutorials()
                      child.idNotification:SetVisible(unreadTutorials)
                    end
                    if action.ActionId == "idInstalledMods" then
                      child.idBtnText:SetTextStyle("MMButtonTextSelected")
                      child.focused = true
                      child.enabled = false
                    end
                    child.idBtnText:SetText(action.ActionName)
                    child:SetOnPressParam(action.ActionId)
                  end
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "__template",
                    "MainMenuButton"
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XZuluScroll",
                  "Id",
                  "idScroll",
                  "Margins",
                  box(0, 0, 15, 0),
                  "Dock",
                  "right",
                  "HAlign",
                  "right",
                  "MaxWidth",
                  5,
                  "MaxHeight",
                  50,
                  "MouseCursor",
                  "UI/Cursors/Hand.tga",
                  "Target",
                  "idList",
                  "Max",
                  50,
                  "SnapToItems",
                  true,
                  "AutoHide",
                  true
                })
              })
            })
          }),
          PlaceObj("XTemplateMode", {
            "mode",
            "multiplayer_games"
          }, {
            PlaceObj("XTemplateWindow", {"Id", "idCont"}, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "filters",
                "__context",
                function(parent, context)
                  return Presets.MultiplayerGameFilters.Default
                end,
                "__class",
                "SnappingScrollArea",
                "Id",
                "idList",
                "IdNode",
                false,
                "BorderWidth",
                0,
                "Padding",
                box(0, 0, 0, 0),
                "OnLayoutComplete",
                function(self)
                  SnappingScrollArea.OnLayoutComplete(self)
                  local btn = self[1]
                  btn.focused = true
                  btn.enabled = false
                  btn.idBtnText:SetTextStyle("MMButtonTextSelected")
                end,
                "BorderColor",
                RGBA(32, 32, 32, 0),
                "Background",
                RGBA(255, 255, 255, 0),
                "HandleMouse",
                false,
                "FocusedBackground",
                RGBA(255, 255, 255, 0),
                "VScroll",
                "idScroll",
                "GamepadInitialSelection",
                true
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "GetItemCount(self)",
                  "func",
                  function(self)
                    return #self - self.docked_win_count + 1
                  end
                }),
                PlaceObj("XTemplateForEach", {
                  "run_after",
                  function(child, context, item, i, n, last)
                    child.idBtnText:SetText(item.Name)
                    child:SetOnPressEffect("")
                    child:SetContext(item)
                  end
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "__template",
                    "MainMenuButton",
                    "OnPress",
                    function(self, gamepad)
                      for _, button in ipairs(self.parent) do
                        if button.class == "XButton" then
                          if button ~= self then
                            button.idBtnText:SetTextStyle("MMButtonText")
                            button.focused = false
                            button.enabled = true
                          else
                            button.idBtnText:SetTextStyle("MMButtonTextSelected")
                            button.focused = true
                            button.enabled = false
                          end
                        end
                      end
                      local ui = GetMultiplayerLobbyDialog(true)
                      local filterType = self.context.id
                      local subDlg = self:ResolveId("idSubContent")
                      local subDlgMod = subDlg and subDlg:GetMode()
                      if subDlgMod and subDlgMod ~= "multiplayer" then
                        self:ResolveId("idSubContent"):SetMode("multiplayer")
                      end
                      self:CreateThread(function()
                        MultiplayerFillGames(ui, filterType)
                      end)
                    end
                  })
                }),
                PlaceObj("XTemplateTemplate", {
                  "comment",
                  "join by code",
                  "__template",
                  "MainMenuButton",
                  "OnLayoutComplete",
                  function(self)
                    self:SetTransparency(self.enabled or self.focused and 0 or 178)
                    self.idBtnText:SetText(T(722664987602, "Join By Code"))
                    self:SetOnPressEffect("")
                  end,
                  "OnPress",
                  function(self, gamepad)
                    for _, button in ipairs(self.parent) do
                      if button.class == "XButton" then
                        if button ~= self then
                          button.idBtnText:SetTextStyle("MMButtonText")
                          button.focused = false
                          button.enabled = true
                        else
                          button.idBtnText:SetTextStyle("MMButtonTextSelected")
                          button.focused = true
                          button.enabled = false
                        end
                      end
                    end
                    self:CreateThread(function()
                      self:ResolveId("idSubContent"):SetMode("empty")
                      local qDlg = OpenDialog("ZuluJoinGamePopup")
                      qDlg:SetModal()
                      qDlg:SetDrawOnTop(true)
                      local res = qDlg:Wait()
                      self.idBtnText:SetTextStyle("MMButtonText")
                      self.focused = false
                      self.enabled = true
                    end)
                  end
                }),
                PlaceObj("XTemplateForEachAction", {
                  "comment",
                  "keep only the back button from mm mode",
                  "toolbar",
                  "mainmenu",
                  "condition",
                  function(parent, context, action, i)
                    return action.ActionId == "idBack"
                  end,
                  "run_after",
                  function(child, context, action, n)
                    if action.ActionId == "idQuit" or action.ActionId == "idBack" then
                      child:SetDock("bottom")
                      child:SetMargins(box(0, 0, 0, 30))
                    end
                    child.idBtnText:SetText(action.ActionName)
                    child:SetOnPressParam(action.ActionId)
                  end
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "__template",
                    "MainMenuButton"
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XZuluScroll",
                  "Id",
                  "idScroll",
                  "Margins",
                  box(0, 0, 15, 0),
                  "Dock",
                  "right",
                  "HAlign",
                  "right",
                  "MaxWidth",
                  5,
                  "MaxHeight",
                  50,
                  "MouseCursor",
                  "UI/Cursors/Hand.tga",
                  "Target",
                  "idList",
                  "Max",
                  50,
                  "SnapToItems",
                  true,
                  "AutoHide",
                  true
                })
              })
            })
          }),
          PlaceObj("XTemplateMode", {
            "mode",
            "multiplayer_host"
          }, {
            PlaceObj("XTemplateWindow", {"Id", "idCont"}, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "SnappingScrollArea",
                "Id",
                "idList",
                "IdNode",
                false,
                "BorderWidth",
                0,
                "Padding",
                box(0, 0, 0, 0),
                "BorderColor",
                RGBA(32, 32, 32, 0),
                "Background",
                RGBA(255, 255, 255, 0),
                "HandleMouse",
                false,
                "FocusedBackground",
                RGBA(255, 255, 255, 0),
                "VScroll",
                "idScroll"
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "GetItemCount(self)",
                  "func",
                  function(self)
                    return #self - self.docked_win_count + 1
                  end
                }),
                PlaceObj("XTemplateForEachAction", {
                  "comment",
                  "keep only the back button from mm mode",
                  "toolbar",
                  "mainmenu",
                  "condition",
                  function(parent, context, action, i)
                    return action.ActionId == "idBack"
                  end,
                  "run_after",
                  function(child, context, action, n)
                    if action.ActionId == "idQuit" or action.ActionId == "idBack" then
                      child:SetDock("bottom")
                      child:SetMargins(box(0, 0, 0, 30))
                    end
                    child.idBtnText:SetText(action.ActionName)
                    child:SetOnPressParam(action.ActionId)
                  end
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "__template",
                    "MainMenuButton"
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XZuluScroll",
                  "Id",
                  "idScroll",
                  "Margins",
                  box(0, 0, 15, 0),
                  "Dock",
                  "right",
                  "HAlign",
                  "right",
                  "MaxWidth",
                  5,
                  "MaxHeight",
                  50,
                  "MouseCursor",
                  "UI/Cursors/Hand.tga",
                  "Target",
                  "idList",
                  "Max",
                  50,
                  "SnapToItems",
                  true,
                  "AutoHide",
                  true
                })
              })
            })
          }),
          PlaceObj("XTemplateMode", {
            "mode",
            "keybindings"
          }, {
            PlaceObj("XTemplateWindow", {"Id", "idCont"}, {
              PlaceObj("XTemplateWindow", {
                "__context",
                function(parent, context)
                  return table.get(Presets, "BindingsMenuCategory", "Default")
                end,
                "__class",
                "SnappingScrollArea",
                "Id",
                "idList",
                "IdNode",
                false,
                "BorderWidth",
                0,
                "Padding",
                box(0, 0, 0, 0),
                "BorderColor",
                RGBA(32, 32, 32, 0),
                "Background",
                RGBA(255, 255, 255, 0),
                "HandleMouse",
                false,
                "FocusedBackground",
                RGBA(255, 255, 255, 0),
                "VScroll",
                "idScroll",
                "GamepadInitialSelection",
                true
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "GetItemCount(self)",
                  "func",
                  function(self)
                    return #self - self.docked_win_count + 1
                  end
                }),
                PlaceObj("XTemplateForEach", {
                  "condition",
                  function(parent, context, item, i)
                    local optionEntries = OptionsObj or OptionsCreateAndLoad()
                    optionEntries = optionEntries:GetProperties()
                    return table.find(optionEntries, "separator", item.Name)
                  end,
                  "run_after",
                  function(child, context, item, i, n, last)
                    if child.class == "XButton" then
                      child.idBtnText:SetText(item.Name)
                      child:SetOnPressEffect("")
                      child:SetOnPress(function(child)
                        local target = false
                        for _, prop in ipairs(child:ResolveId("idSubMenu"):ResolveId("idScrollArea")) do
                          if prop.context.prop_meta.separator == item.Name then
                            target = prop
                            break
                          end
                        end
                        if target then
                          target.parent:ScrollIntoView(target, "on-top")
                        end
                      end)
                    end
                  end
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "__template",
                    "MainMenuButton"
                  })
                }),
                PlaceObj("XTemplateForEachAction", {
                  "comment",
                  "keep only the back button from mm mode",
                  "toolbar",
                  "mainmenu",
                  "condition",
                  function(parent, context, action, i)
                    return action.ActionId == "idBack"
                  end,
                  "run_after",
                  function(child, context, action, n)
                    if action.ActionId == "idQuit" or action.ActionId == "idBack" then
                      child:SetDock("bottom")
                      child:SetMargins(box(0, 0, 0, 30))
                      child:SetParent(child.parent.parent)
                    end
                    child.idBtnText:SetText(action.ActionName)
                    child:SetOnPressParam(action.ActionId)
                  end
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "__template",
                    "MainMenuButton"
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XZuluScroll",
                  "Id",
                  "idScroll",
                  "Margins",
                  box(0, 0, 15, 0),
                  "Dock",
                  "right",
                  "HAlign",
                  "right",
                  "MaxWidth",
                  5,
                  "MaxHeight",
                  50,
                  "MouseCursor",
                  "UI/Cursors/Hand.tga",
                  "Target",
                  "idList",
                  "Max",
                  50,
                  "SnapToItems",
                  true,
                  "AutoHide",
                  true
                })
              })
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XDialog",
      "Id",
      "idSubContent",
      "IdNode",
      false,
      "Margins",
      box(-100, 0, 0, 0),
      "UseClipBox",
      false,
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        self:ResolveId("idSubMenu"):SetContext(context)
        self:ResolveId("idSubMenu"):RespawnContent()
      end,
      "HostInParent",
      true,
      "InitialMode",
      "empty",
      "InternalModes",
      "empty, options, newgame, loadgame, savegame, multiplayer, multiplayer_host,multiplayer_guest, replays, installedmods"
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "OnDialogModeChange(self, mode, dialog)",
        "func",
        function(self, mode, dialog)
          if mode == "newgame" then
            ShowForgivingModePopup()
          end
          self:ResolveId("idSubMenu"):RespawnContent()
          self:ResolveId("idControllerSupport"):OnContextUpdate()
        end
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "sub menu",
        "__class",
        "XContentTemplate",
        "Id",
        "idSubMenu",
        "Margins",
        box(0, 320, 0, 0),
        "UseClipBox",
        false
      }, {
        PlaceObj("XTemplateMode", {
          "comment",
          "empty",
          "mode",
          "empty"
        }),
        PlaceObj("XTemplateMode", {
          "mode",
          "multiplayer"
        }, {
          PlaceObj("XTemplateWindow", {
            "Id",
            "idMultiplayer",
            "VAlign",
            "top",
            "MinWidth",
            615,
            "MinHeight",
            800,
            "MaxWidth",
            615,
            "MaxHeight",
            800
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "list of games",
              "__class",
              "XContentTemplate",
              "IdNode",
              false,
              "Dock",
              "top"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "SnappingScrollArea",
                "Id",
                "idScrollArea",
                "Dock",
                "left",
                "MinWidth",
                600,
                "MinHeight",
                720,
                "MaxWidth",
                600,
                "MaxHeight",
                720,
                "VScroll",
                "idScroll",
                "GamepadInitialSelection",
                true,
                "KeepSelectionOnRespawn",
                true
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__condition",
                  function(parent, context)
                    return context and next(context.available_games)
                  end,
                  "__template",
                  "NewGameCategory",
                  "Id",
                  "idFilterName"
                }),
                PlaceObj("XTemplateForEach", {
                  "comment",
                  "games",
                  "array",
                  function(parent, context)
                    return context and context.available_games or {}
                  end,
                  "run_after",
                  function(child, context, item, i, n, last)
                    child.idGameName:SetText(item[2])
                    local game_info = item[6]
                    local preset = CampaignPresets[game_info.campaign]
                    child.idCampaignName:SetText(preset and preset.DisplayName or "")
                    child.idMods:SetText(#game_info.mods)
                    child.idDay:SetText(T({
                      891751038444,
                      "Day <cur_day>",
                      cur_day = game_info.day
                    }))
                    child.item = item
                  end
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "__template",
                    "NewGameMultiplayerGameEntry"
                  }, {
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "OnMouseButtonDoubleClick(self, pos, button)",
                      "func",
                      function(self, pos, button)
                        XButton.OnMouseButtonDoubleClick(self, pos, button)
                        if button == "L" then
                          local host = self:ResolveId("node"):ResolveId("node")
                          InvokeShortcutAction(self, "join", host, true)
                        end
                      end
                    })
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XZuluScroll",
                "Id",
                "idScroll",
                "Margins",
                box(0, 10, 8, 15),
                "Dock",
                "right",
                "HAlign",
                "right",
                "MouseCursor",
                "UI/Cursors/Hand.tga",
                "Target",
                "idScrollArea",
                "SnapToItems",
                true,
                "AutoHide",
                true
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "buttons",
            "Id",
            "idActionsToolbar",
            "Margins",
            box(0, 0, 0, 20),
            "Dock",
            "bottom"
          }, {
            PlaceObj("XTemplateAction", {
              "ActionId",
              "Refresh",
              "ActionName",
              T(106724424001, "Refresh"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "R",
              "ActionGamepad",
              "LeftShoulder",
              "OnAction",
              function(self, host, source, ...)
                CreateRealTimeThread(function()
                  MultiplayerFillGames(host)
                end)
              end,
              "FXPress",
              "MainMenuButtonClick",
              "FXPressDisabled",
              "activityAssignSelectDisabled"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "host",
              "ActionName",
              T(420669633954, "Host"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "H",
              "ActionGamepad",
              "ButtonY",
              "OnAction",
              function(self, host, source, ...)
                UIHostGame()
              end,
              "FXPress",
              "MainMenuButtonClick",
              "FXPressDisabled",
              "activityAssignSelectDisabled"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "join",
              "ActionName",
              T(329105958083, "Join"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "J",
              "ActionGamepad",
              "ButtonX",
              "ActionState",
              function(self, host)
                local list = host:ResolveId("idSubMenu")
                list = list and list.idScrollArea
                if not list then
                  return "disabled"
                end
                local selected = list:GetSelection()
                selected = selected and selected[1]
                local selectedWnd = list[selected]
                return selectedWnd and selectedWnd:IsFocused() and "enabled" or "disabled"
              end,
              "OnAction",
              function(self, host, source, ...)
                local list = host:ResolveId("idSubMenu")
                list = list and list.idScrollArea
                if not list then
                  return
                end
                local selected = list:GetSelection()
                selected = selected and selected[1]
                local selectedWnd = list[selected]
                if selectedWnd and selectedWnd.item then
                  UIJoinGame(selectedWnd.item)
                end
              end,
              "FXPress",
              "MainMenuButtonClick",
              "FXPressDisabled",
              "activityAssignSelectDisabled"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "backToMMbuttons",
              "ActionGamepad",
              "ButtonB",
              "OnAction",
              function(self, host, source, ...)
                self.host:ResolveId("idMultiplayer"):ResolveId("idActionsToolbar"):BackToMMButtons(host)
              end,
              "FXPress",
              "MainMenuButtonClick"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "backToMMbuttons",
              "ActionGamepad",
              "DPadLeft",
              "OnAction",
              function(self, host, source, ...)
                self.host:ResolveId("idMultiplayer"):ResolveId("idActionsToolbar"):BackToMMButtons(host)
              end,
              "FXPress",
              "MainMenuButtonClick"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "backToMMbuttons",
              "ActionGamepad",
              "LeftThumbLeft",
              "OnAction",
              function(self, host, source, ...)
                self.host:ResolveId("idMultiplayer"):ResolveId("idActionsToolbar"):BackToMMButtons(host)
              end,
              "FXPress",
              "MainMenuButtonClick"
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "BackToMMButtons(self, host)",
              "func",
              function(self, host)
                local list = host:ResolveId("idMainMenuButtonsContent"):ResolveId("idList")
                list:SetFocus(true)
                list:SelectFirstValidItem()
              end
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XZuluToolBarList",
              "Id",
              "idToolBar",
              "ZOrder",
              0,
              "HAlign",
              "center",
              "VAlign",
              "center",
              "MinWidth",
              500,
              "OnLayoutComplete",
              function(self)
                if self:ResolveId("idjoin") then
                  local games = GetDialog(self):ResolveId("idSubMenu"):ResolveId("idScrollArea")
                  games = GetUIStyleGamepad() and games
                  self:ResolveId("idjoin"):SetEnabled(games and 1 < #games)
                  ObjModified("action-button-mm")
                end
              end,
              "LayoutHSpacing",
              50,
              "Background",
              RGBA(255, 255, 255, 0),
              "Toolbar",
              "ActionBar",
              "Show",
              "text",
              "ButtonTemplate",
              "OptionsActionsButton"
            }, {
              PlaceObj("XTemplateFunc", {
                "comment",
                "position buttons on both corners",
                "name",
                "RebuildActions(self, ...)",
                "func",
                function(self, ...)
                  XZuluToolBarList.RebuildActions(self, ...)
                  local parent = self:GetButtonParent()
                  parent:SetMinWidth(self.MinWidth)
                end
              })
            })
          })
        }),
        PlaceObj("XTemplateMode", {
          "mode",
          "multiplayer_host"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XContextWindow",
            "Id",
            "idMultiplayer",
            "VAlign",
            "top",
            "MinWidth",
            615,
            "MinHeight",
            800,
            "MaxWidth",
            615,
            "MaxHeight",
            800
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "list",
              "__class",
              "XContextWindow",
              "Dock",
              "top"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "SnappingScrollArea",
                "Id",
                "idScrollArea",
                "Dock",
                "left",
                "MinWidth",
                600,
                "MaxWidth",
                600,
                "MaxHeight",
                590,
                "HandleKeyboard",
                false,
                "VScroll",
                "idScroll",
                "GamepadInitialSelection",
                true,
                "OnSelection",
                function(self, focused_item, selection)
                  local input = self[focused_item]:ResolveId("idCampaignNameInput")
                  if input then
                    input:SetFocus(true)
                  end
                end
              }, {
                PlaceObj("XTemplateWindow", {
                  "__condition",
                  function(parent, context)
                    return true
                  end,
                  "IdNode",
                  true,
                  "MinHeight",
                  64,
                  "MaxHeight",
                  64
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "comment",
                    "campaign",
                    "__template",
                    "NewGameCategory",
                    "RolloverTemplate",
                    "RolloverGenericFixedL",
                    "RolloverAnchor",
                    "right",
                    "RolloverText",
                    T(927017524057, "All saves and autosaves will be grouped by the name of your playthrough."),
                    "RolloverOffset",
                    box(25, 0, 0, 0),
                    "RolloverTitle",
                    T(437305157293, "Playthrough name"),
                    "Id",
                    "idCampaignName",
                    "IdNode",
                    false,
                    "HandleMouse",
                    true,
                    "OnContextUpdate",
                    function(self, context, ...)
                      local name = self.idName
                      name:SetTranslate(false)
                      if Game then
                        name:SetText(Game.playthrough_name or "Hot Diamonds")
                      elseif not NewGameObj.campaign_name or NewGameObj.campaign_name == "" then
                        name:SetText(GetCampaignNameTranslated())
                      else
                        name:SetText(NewGameObj.campaign_name)
                      end
                      self:ResolveId("idEdit"):SetVisible(not Game)
                    end
                  }, {
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "OnMouseButtonDown(self, pos, button)",
                      "func",
                      function(self, pos, button)
                        local editField = self.parent:ResolveId("idCampaignNameInput")
                        if editField then
                          PlayFX("MainMenuButtonClick", "start")
                          editField:SetText(NewGameObj.campaign_name)
                          editField:SetVisible(true)
                          editField:SelectAll()
                          GetDialog(self).parent:SetHandleMouse(true)
                          editField:SetFocus(true)
                          if GetUIStyleGamepad() then
                            editField:OpenControllerTextInput()
                          end
                        else
                          PlayFX("activityAssignSelectDisabled", "start")
                        end
                        return "break"
                      end
                    }),
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "OnShortcut(self, shortcut, source, ...)",
                      "func",
                      function(self, shortcut, source, ...)
                        if shortcut == "ButtonA" then
                          self:OnMouseButtonDown(nil, "L")
                        end
                      end
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__condition",
                    function(parent, context)
                      return not Game
                    end,
                    "__class",
                    "XTextEditor",
                    "Id",
                    "idCampaignNameInput",
                    "Margins",
                    box(5, 0, 5, 0),
                    "BorderWidth",
                    3,
                    "Padding",
                    box(14, 9, 2, 1),
                    "Dock",
                    "box",
                    "HAlign",
                    "center",
                    "VAlign",
                    "center",
                    "MinWidth",
                    600,
                    "MinHeight",
                    56,
                    "MaxWidth",
                    600,
                    "MaxHeight",
                    56,
                    "Visible",
                    false,
                    "FoldWhenHidden",
                    true,
                    "DrawOnTop",
                    true,
                    "BorderColor",
                    RGBA(215, 159, 80, 255),
                    "Background",
                    RGBA(88, 92, 68, 255),
                    "BackgroundRectGlowColor",
                    RGBA(0, 0, 0, 0),
                    "FocusedBorderColor",
                    RGBA(215, 159, 80, 255),
                    "FocusedBackground",
                    RGBA(88, 92, 68, 255),
                    "DisabledBorderColor",
                    RGBA(128, 128, 128, 0),
                    "DisabledBackground",
                    RGBA(0, 0, 0, 255),
                    "TextStyle",
                    "MMNewGameName",
                    "OnTextChanged",
                    function(self)
                      local newText = self:GetText() ~= "" and self:GetText()
                      if not newText or newText == "" then
                        newText = GetCampaignNameTranslated()
                      end
                      if self:IsFocused() then
                        PlayFX("Typing", "start")
                      end
                      local name = self.parent:ResolveId("idCampaignName")
                      name:SetName(newText)
                      NewGameObj.campaign_name = newText
                    end,
                    "ConsoleKeyboardDescription",
                    T(861459067205, "Enter Campaign Name"),
                    "WordWrap",
                    false,
                    "AllowPaste",
                    false,
                    "AllowEscape",
                    false,
                    "MaxVisibleLines",
                    1,
                    "MaxLines",
                    1,
                    "MaxLen",
                    20,
                    "HintColor",
                    RGBA(0, 0, 0, 0),
                    "SelectionBackground",
                    RGBA(124, 130, 96, 255)
                  }, {
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "OnKillFocus",
                      "func",
                      function(self, ...)
                        if self.window_state == "destroying" then
                          local context = GetDialog(self):ResolveId("node").idSubMenu.context
                          CreateRealTimeThread(function(invited_player_id)
                            NetCall("rfnPlayerMessage", invited_player_id, "lobby-info", {
                              start_info = NewGameObj,
                              no_scroll = true,
                              host_ready = context.host_ready
                            })
                          end, context and context.invited_player_id)
                          return
                        end
                        RunWhenXWindowIsReady(self, function()
                          PlayFX("MainMenuButtonClick", "start")
                          GetDialog(self)[1]:ResolveId("idActionsToolbar"):SetFocus(true)
                          if GetUIStyleGamepad() then
                            self.parent.idCampaignName:SetSelected(true)
                          else
                            self.parent.idCampaignName:SetSelected(false)
                          end
                          GetDialog(self).parent:SetHandleMouse(false)
                          self:LockScrollWhileEdit(false)
                          self:SetVisible(false)
                          if netInGame and NetIsHost() then
                            local context = GetDialog(self):ResolveId("node").idSubMenu.context
                            CreateRealTimeThread(function(invited_player_id)
                              NetCall("rfnPlayerMessage", invited_player_id, "lobby-info", {
                                start_info = NewGameObj,
                                no_scroll = true,
                                host_ready = context.host_ready
                              })
                            end, context and context.invited_player_id)
                          end
                          XTextEditor.OnKillFocus(self)
                        end)
                      end
                    }),
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "OnShortcut(self, shortcut, source, ...)",
                      "func",
                      function(self, shortcut, source, ...)
                        if shortcut == "Escape" or shortcut == "Enter" or GetUIStyleGamepad() then
                          self:OnKillFocus()
                          return "break"
                        else
                          XTextEditor.OnShortcut(self, shortcut, source, ...)
                        end
                      end
                    }),
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "OnSetFocus(self)",
                      "func",
                      function(self)
                        XTextEditor.OnSetFocus(self)
                        self:LockScrollWhileEdit(true)
                      end
                    }),
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "LockScrollWhileEdit(self, lock)",
                      "func",
                      function(self, lock)
                        local contentTemplate = GetDialog(self)[1]
                        contentTemplate:ResolveValue("idScrollArea"):SetMouseScroll(not lock)
                        contentTemplate:ResolveValue("idScroll"):SetHandleMouse(not lock)
                        contentTemplate:ResolveValue("idScroll"):SetHandleKeyboard(not lock)
                      end
                    })
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "SetSelected(self, selected)",
                    "func",
                    function(self, selected)
                      self.idCampaignName:SetSelected(selected)
                    end
                  })
                }),
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "NewGamePrivatePublicLabel"
                }),
                PlaceObj("XTemplateTemplate", {
                  "comment",
                  "join code",
                  "__template",
                  "NewGameJoinCode",
                  "IdNode",
                  false
                }),
                PlaceObj("XTemplateTemplate", {
                  "comment",
                  "player",
                  "__template",
                  "NewGameCategory",
                  "IdNode",
                  false,
                  "Name",
                  T(685762104941, "Players")
                }),
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "NewGameInviteEntry",
                  "Id",
                  "idPlayer1",
                  "OnContextUpdate",
                  function(self, context, ...)
                    self:SetName(Untranslated(netDisplayName))
                    if Game then
                      self.idCheckmark:SetVisible(false)
                      self.idInvite:SetText("")
                      return
                    end
                    local dlg_context = GetDialog(self):ResolveId("node").idSubMenu.context
                    self.idCheckmark:SetColumn(dlg_context and dlg_context.host_ready and 2 or 1)
                    self.idCheckmark:SetVisible(true)
                    self.idInvite:SetText(dlg_context and dlg_context.host_ready and T(373478656080, "READY") or T(940649323656, "NOT READY"))
                  end,
                  "FXPress",
                  "MainMenuButtonClick",
                  "Name",
                  T(895015474285, "Player 1")
                }),
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "NewGameInviteEntry",
                  "Id",
                  "idPlayer2",
                  "OnContextUpdate",
                  function(self, context, ...)
                    self.idCheckmark:SetVisible(false)
                    self.idInvite:SetVisible(true)
                    self:SetName(not (context and context.multiplayer_invite) and T(931831984727, "[Empty]") or Untranslated(context.invited_player))
                    if not context or not context.multiplayer_invite then
                      self.idInvite:SetText(T(127683166549, "Invite"))
                      return
                    end
                    if context.multiplayer_invite == "invited" then
                      self.idInvite:SetText(T(818335152323, "Cancel Invite"))
                      return
                    end
                    if context.multiplayer_invite == "accepted" then
                      self.idCheckmark:SetVisible(false)
                      self.idInvite:SetText(T(993097513296, "<GameColorD>NOT READY</GameColorD>"))
                      return
                    end
                    if context.multiplayer_invite == "ready" then
                      self.idCheckmark:SetVisible(false)
                      self.idInvite:SetText(T(423468506476, "<GameColorF>READY</GameColorF>"))
                      return
                    end
                    self.idInvite:SetText(T({""}))
                  end,
                  "FXPress",
                  "MainMenuButtonClick",
                  "Name",
                  T(875433159439, "[EMPTY]")
                }),
                PlaceObj("XTemplateTemplate", {
                  "comment",
                  "difficulty",
                  "__context",
                  function(parent, context)
                    NewGameObj = NewGameObj or table.copy(NewGameObjOriginal, "deep")
                    return NewGameObj
                  end,
                  "__template",
                  "NewGameMenuDifficulty",
                  "OnContextUpdate",
                  function(self, context, ...)
                    XButton.OnContextUpdate(self, context, ...)
                    if not Game then
                      return
                    end
                    for _, ctrl in ipairs(self.parent) do
                      if ctrl.context and ctrl.context.class == "GameDifficultyDef" and IsKindOf(ctrl, "XButton") and ctrl.idCheckmark then
                        ctrl.idCheckmark:SetDesaturation(255)
                        function ctrl.OnPress()
                          PlayFX("activityAssignSelectDisabled", "start")
                        end
                      end
                    end
                  end,
                  "Name",
                  T(409710114741, "Difficulty")
                }),
                PlaceObj("XTemplateTemplate", {
                  "comment",
                  "game rules",
                  "__context",
                  function(parent, context)
                    NewGameObj = NewGameObj or table.copy(NewGameObjOriginal, "deep")
                    return NewGameObj
                  end,
                  "__template",
                  "NewGameMenuGameRules",
                  "OnContextUpdate",
                  function(self, context, ...)
                    XButton.OnContextUpdate(self, context, ...)
                    if not Game then
                      return
                    end
                    for _, ctrl in ipairs(self.parent) do
                      if ctrl.context and ctrl.context.class == "GameRuleDef" and IsKindOf(ctrl, "XButton") and ctrl.idOnOff then
                        ctrl.idOnOff:SetEnabled(false)
                        function ctrl.OnPress()
                          PlayFX("activityAssignSelectDisabled", "start")
                        end
                      end
                    end
                  end,
                  "Name",
                  T(468039426572, "Game Rules")
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XZuluScroll",
                "Id",
                "idScroll",
                "Margins",
                box(0, 10, 8, 15),
                "Dock",
                "right",
                "HAlign",
                "right",
                "MouseCursor",
                "UI/Cursors/Hand.tga",
                "Target",
                "idScrollArea",
                "SnapToItems",
                true,
                "AutoHide",
                true
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "buttons",
            "Id",
            "idActionsToolbar",
            "Margins",
            box(0, 0, 0, 20),
            "Dock",
            "bottom"
          }, {
            PlaceObj("XTemplateAction", {
              "ActionId",
              "startNewGame",
              "ActionName",
              T(137021205855, "START GAME"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "Enter",
              "ActionGamepad",
              "ButtonX",
              "ActionState",
              function(self, host)
                if Game then
                  return "hidden"
                end
                return UICanStartGame() and "enabled" or "disabled"
              end,
              "OnAction",
              function(self, host, source, ...)
                if not NewGameObj.campaign_name or NewGameObj.campaign_name == "" then
                  NewGameObj.campaign_name = GetCampaignNameTranslated()
                end
                UIStartGame()
              end,
              "FXPress",
              "MainMenuButtonClick",
              "FXPressDisabled",
              "activityAssignSelectDisabled"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "unlistGame",
              "ActionName",
              T(413497619384, "UNLIST GAME"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "U",
              "ActionGamepad",
              "ButtonY",
              "ActionState",
              function(self, host)
                if not Game then
                  return "hidden"
                end
                if IsCoOpGame() then
                  return "hidden"
                end
              end,
              "OnAction",
              function(self, host, source, ...)
                MultiplayerLobbySetUI("empty", "unlist")
              end,
              "FXPress",
              "MainMenuButtonClick",
              "FXPressDisabled",
              "activityAssignSelectDisabled"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "backToMMbuttons",
              "ActionGamepad",
              "ButtonB",
              "OnAction",
              function(self, host, source, ...)
                self.host:ResolveId("idActionsToolbar"):BackToMMButtons(host)
              end,
              "FXPress",
              "MainMenuButtonClick"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "backToMMbuttons",
              "ActionGamepad",
              "DPadLeft",
              "OnAction",
              function(self, host, source, ...)
                self.host:ResolveId("idActionsToolbar"):BackToMMButtons(host)
              end,
              "FXPress",
              "MainMenuButtonClick"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "backToMMbuttons",
              "ActionGamepad",
              "LeftThumbLeft",
              "OnAction",
              function(self, host, source, ...)
                self.host:ResolveId("idActionsToolbar"):BackToMMButtons(host)
              end,
              "FXPress",
              "MainMenuButtonClick"
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "BackToMMButtons(self, host)",
              "func",
              function(self, host)
                local list = host:ResolveId("idMainMenuButtonsContent"):ResolveId("idList")
                list:SetFocus(true)
                list:SelectFirstValidItem()
              end
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XZuluToolBarList",
              "Id",
              "idToolBar",
              "ZOrder",
              0,
              "HAlign",
              "center",
              "VAlign",
              "center",
              "Background",
              RGBA(255, 255, 255, 0),
              "Toolbar",
              "ActionBar",
              "Show",
              "text",
              "ButtonTemplate",
              "OptionsActionsButton"
            }, {
              PlaceObj("XTemplateFunc", {
                "comment",
                "position buttons on both corners",
                "name",
                "RebuildActions(self, ...)",
                "func",
                function(self, ...)
                  XZuluToolBarList.RebuildActions(self, ...)
                  local parent = self:GetButtonParent()
                  if #parent == 2 then
                    parent[1]:SetDock("left")
                    parent[2]:SetDock("right")
                  end
                  parent:SetMinWidth(self.MinWidth)
                end
              })
            })
          })
        }),
        PlaceObj("XTemplateMode", {
          "mode",
          "multiplayer_guest"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XContextWindow",
            "Id",
            "idMultiplayer",
            "VAlign",
            "top",
            "MinWidth",
            615,
            "MinHeight",
            800,
            "MaxWidth",
            615,
            "MaxHeight",
            800
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "buttons",
              "Id",
              "idActionsToolbar",
              "Margins",
              box(-10, 0, 0, 24),
              "Dock",
              "bottom",
              "MinWidth",
              600,
              "MaxWidth",
              600
            }, {
              PlaceObj("XTemplateAction", {
                "ActionId",
                "backToMMbuttons",
                "ActionGamepad",
                "ButtonB",
                "OnAction",
                function(self, host, source, ...)
                  self.host:ResolveId("idActionsToolbar"):BackToMMButtons(host)
                end,
                "FXPress",
                "MainMenuButtonClick"
              }),
              PlaceObj("XTemplateAction", {
                "ActionId",
                "backToMMbuttons",
                "ActionGamepad",
                "DPadLeft",
                "OnAction",
                function(self, host, source, ...)
                  self.host:ResolveId("idActionsToolbar"):BackToMMButtons(host)
                end,
                "FXPress",
                "MainMenuButtonClick"
              }),
              PlaceObj("XTemplateAction", {
                "ActionId",
                "backToMMbuttons",
                "ActionGamepad",
                "LeftThumbLeft",
                "OnAction",
                function(self, host, source, ...)
                  self.host:ResolveId("idActionsToolbar"):BackToMMButtons(host)
                end,
                "FXPress",
                "MainMenuButtonClick"
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "BackToMMButtons(self, host)",
                "func",
                function(self, host)
                  local list = host:ResolveId("idMainMenuButtonsContent"):ResolveId("idList")
                  list:SetFocus(true)
                  list:SelectFirstValidItem()
                end
              })
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "list",
              "__class",
              "XContextWindow",
              "Dock",
              "top"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "SnappingScrollArea",
                "Id",
                "idScrollArea",
                "Dock",
                "left",
                "MinWidth",
                600,
                "MaxWidth",
                600,
                "MaxHeight",
                590,
                "HandleKeyboard",
                false,
                "VScroll",
                "idScroll"
              }, {
                PlaceObj("XTemplateWindow", {
                  "__condition",
                  function(parent, context)
                    return true
                  end,
                  "IdNode",
                  true,
                  "MinHeight",
                  64,
                  "MaxHeight",
                  64
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "comment",
                    "campaign",
                    "__context",
                    function(parent, context)
                      return "new settings"
                    end,
                    "__template",
                    "NewGameCategory",
                    "RolloverTemplate",
                    "RolloverGenericFixedL",
                    "RolloverAnchor",
                    "right",
                    "RolloverText",
                    T(800139563991, "All saves and autosaves will be grouped by the name of your playthrough."),
                    "RolloverOffset",
                    box(25, 0, 0, 0),
                    "RolloverTitle",
                    T(579398467064, "Playthrough name"),
                    "Id",
                    "idCampaignName",
                    "IdNode",
                    false,
                    "HandleMouse",
                    true,
                    "OnContextUpdate",
                    function(self, context, ...)
                      local name = self.idName
                      name:SetTranslate(false)
                      if not NewGameObj.campaign_name or NewGameObj.campaign_name == "" then
                        name:SetText(GetCampaignNameTranslated())
                      else
                        name:SetText(NewGameObj.campaign_name)
                      end
                    end
                  }, {
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "OnMouseButtonDown(self, pos, button)",
                      "func",
                      function(self, pos, button)
                        PlayFX("activityAssignSelectDisabled", "start")
                        return "break"
                      end
                    }),
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "OnShortcut(self, shortcut, source, ...)",
                      "func",
                      function(self, shortcut, source, ...)
                        if shortcut == "ButtonA" then
                          self:OnMouseButtonDown(nil, "L")
                        end
                      end
                    })
                  })
                }),
                PlaceObj("XTemplateTemplate", {
                  "comment",
                  "player",
                  "__template",
                  "NewGameCategory",
                  "IdNode",
                  false,
                  "Name",
                  T(722697775065, "Players")
                }),
                PlaceObj("XTemplateTemplate", {
                  "__context",
                  function(parent, context)
                    return "host_ready"
                  end,
                  "__template",
                  "NewGameInviteEntry",
                  "Id",
                  "idPlayer1",
                  "OnContextUpdate",
                  function(self, context, ...)
                    if self.window_state == "destroying" then
                      return
                    end
                    local context = GetDialog(self):ResolveId("node").idSubMenu.context or {}
                    self:SetName(Untranslated(context.invited_player))
                    if Game then
                      self.idInvite:SetText("")
                      return
                    end
                    self.idCheckmark:SetVisible(false)
                    self.idInvite:SetText(context.host_ready and T(423468506476, "<GameColorF>READY</GameColorF>") or T(655475313785, "<GameColorD>NOT READY</GameColorD>"))
                  end,
                  "FXPress",
                  "MainMenuButtonClick",
                  "Name",
                  T(895015474285, "Player 1")
                }),
                PlaceObj("XTemplateTemplate", {
                  "__context",
                  function(parent, context)
                    return "guest_ready"
                  end,
                  "__template",
                  "NewGameInviteEntry",
                  "Id",
                  "idPlayer2",
                  "OnContextUpdate",
                  function(self, context, ...)
                    if self.window_state == "destroying" then
                      return
                    end
                    self:SetName(Untranslated(netDisplayName))
                    if Game then
                      self.idCheckmark:SetVisible(false)
                      return
                    end
                    local ui = GetMultiplayerLobbyDialog()
                    local subMenu = ui and ui.idSubMenu
                    local context = subMenu and subMenu.context or {}
                    self.idCheckmark:SetColumn(context.guest_ready and 2 or 1)
                    self.idCheckmark:SetVisible(true)
                    self.idInvite:SetText(context.guest_ready and T(373478656080, "READY") or T(940649323656, "NOT READY"))
                  end,
                  "FXPress",
                  "MainMenuButtonClick",
                  "Name",
                  T(668480680004, "Player 2")
                }),
                PlaceObj("XTemplateTemplate", {
                  "comment",
                  "difficulty",
                  "__context",
                  function(parent, context)
                    return "new settings"
                  end,
                  "__template",
                  "NewGameMenuDifficulty",
                  "OnContextUpdate",
                  function(self, context, ...)
                    XButton.OnContextUpdate(self, context, ...)
                    for _, ctrl in ipairs(self.parent) do
                      if ctrl.context and ctrl.context.class == "GameDifficultyDef" and IsKindOf(ctrl, "XButton") and ctrl.idCheckmark then
                        ctrl.idCheckmark:SetDesaturation(255)
                        function ctrl.OnPress()
                          PlayFX("activityAssignSelectDisabled", "start")
                        end
                      end
                    end
                  end,
                  "Name",
                  T(409710114741, "Difficulty")
                }),
                PlaceObj("XTemplateTemplate", {
                  "comment",
                  "game rules",
                  "__context",
                  function(parent, context)
                    return "new settings"
                  end,
                  "__template",
                  "NewGameMenuGameRules",
                  "OnContextUpdate",
                  function(self, context, ...)
                    XButton.OnContextUpdate(self, context, ...)
                    for _, ctrl in ipairs(self.parent) do
                      if ctrl.context and ctrl.context.class == "GameRuleDef" and IsKindOf(ctrl, "XButton") and ctrl.idOnOff then
                        ctrl.idOnOff:SetEnabled(false)
                        function ctrl.OnPress()
                          PlayFX("activityAssignSelectDisabled", "start")
                        end
                      end
                    end
                  end,
                  "Name",
                  T(468039426572, "Game Rules")
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XZuluScroll",
                "Id",
                "idScroll",
                "Margins",
                box(0, 10, 8, 15),
                "Dock",
                "right",
                "HAlign",
                "right",
                "MouseCursor",
                "UI/Cursors/Hand.tga",
                "Target",
                "idScrollArea",
                "SnapToItems",
                true,
                "AutoHide",
                true
              })
            })
          })
        }),
        PlaceObj("XTemplateMode", {"mode", "options"}, {
          PlaceObj("XTemplateWindow", {
            "Id",
            "idOptCont",
            "VAlign",
            "top",
            "MinWidth",
            615,
            "MinHeight",
            800,
            "MaxWidth",
            615,
            "MaxHeight",
            800
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "list of options",
              "Id",
              "idOptionsListCont",
              "Dock",
              "top"
            }, {
              PlaceObj("XTemplateWindow", {
                "__context",
                function(parent, context)
                  local param = GetDialogModeParam(parent)
                  if param and param.optObj.id == "ModOptions" then
                    ModsOptionsOriginal = ModsOptionsOriginal or {}
                    local modsOptionsObj = {}
                    local loadedMods = ModsLoaded or empty_table
                    for _, mod in ipairs(loadedMods) do
                      local optionsProps = {}
                      local options = mod:GetOptionItems()
                      if next(options) and mod.options then
                        table.insert(ModsOptionsOriginal, mod.options:Clone())
                        table.insert(modsOptionsObj, mod.options)
                      end
                    end
                    return modsOptionsObj
                  else
                    OptionsObj = OptionsObj or OptionsCreateAndLoad()
                    return OptionsObj
                  end
                end,
                "__class",
                "SnappingScrollArea",
                "Id",
                "idScrollArea",
                "Dock",
                "left",
                "MinWidth",
                600,
                "MaxWidth",
                600,
                "MaxHeight",
                590,
                "VScroll",
                "idScroll",
                "GamepadInitialSelection",
                true,
                "KeepSelectionOnRespawn",
                true
              }, {
                PlaceObj("XTemplateForEach", {
                  "comment",
                  "properties",
                  "array",
                  function(parent, context)
                    local arr = IsKindOf(context, "OptionsObject") and context:GetProperties()
                    local param = GetDialogModeParam(parent)
                    if param and param.optObj.id == "ModOptions" then
                      local modsOptions = {}
                      local loadedMods = ModsLoaded or empty_table
                      for _, mod in ipairs(loadedMods) do
                        local optionsProps = {}
                        local options = mod:GetOptionItems()
                        if next(options) then
                          table.insert(modsOptions, {
                            separator = Untranslated(mod.title),
                            category = "Mod"
                          })
                        end
                        for _, option in ipairs(options) do
                          table.insert(optionsProps, option:GetOptionMeta())
                        end
                        table.iappend(modsOptions, optionsProps)
                      end
                      arr = modsOptions
                      return arr
                    elseif param and param.optObj.id == "Keybindings" then
                      local groups = {}
                      local optionEntries = OptionsObj or OptionsCreateAndLoad()
                      optionEntries = optionEntries:GetProperties()
                      for _, group in ipairs(table.get(Presets, "BindingsMenuCategory", "Default")) do
                        if table.find(optionEntries, "separator", group.Name) then
                          table.insert(groups, group)
                        end
                      end
                      local orderedGroups = {}
                      arr = table.ifilter(arr, function(idx, e)
                        if e.action_category then
                          if not orderedGroups[e.action_category] then
                            orderedGroups[e.action_category] = {}
                            table.insert(orderedGroups[e.action_category], e)
                          else
                            table.insert(orderedGroups[e.action_category], e)
                          end
                        else
                          return false
                        end
                        return e.action_category
                      end)
                      arr = {}
                      for _, group in ipairs(groups) do
                        table.iappend(arr, orderedGroups[group.id])
                      end
                      return arr
                    else
                      return arr
                    end
                  end,
                  "condition",
                  function(parent, context, item, i)
                    local param = GetDialogModeParam(parent)
                    if param then
                      if item.id == "Difficulty" and not Game then
                        return false
                      end
                      if item.id == "Sharpness" and GetDialog("PreGameMenu") then
                        return false
                      end
                      if param.optObj.id == "ModOptions" then
                        item.items = prop_eval(item.items, nil, item)
                        return true
                      end
                      item.items = prop_eval(item.items, nil, item) or OptionsData.Options[item.id]
                      return item.category == (param and param.optObj.id) and not prop_eval(item.no_edit, nil, item)
                    end
                  end,
                  "item_in_context",
                  "prop_meta",
                  "run_after",
                  function(child, context, item, i, n, last)
                    if context and IsKindOf(context[1], "ModOptionsObject") then
                      local new_context = {}
                      local sub_context_idx
                      local modId = context.prop_meta.modId
                      for idx, modObj in ipairs(context) do
                        if IsKindOf(modObj, "ModOptionsObject") and modObj.__mod.id == context.prop_meta.modId then
                          sub_context_idx = idx
                        end
                      end
                      new_context = SubContext(new_context, {
                        context[sub_context_idx],
                        prop_meta = context.prop_meta
                      })
                      child:SetContext(new_context, false)
                    end
                  end
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "__template",
                    "OptionsEntry",
                    "IdNode",
                    false
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XZuluScroll",
                "Id",
                "idScroll",
                "Margins",
                box(0, 10, 8, 15),
                "Dock",
                "right",
                "HAlign",
                "right",
                "MouseCursor",
                "UI/Cursors/Hand.tga",
                "Target",
                "idScrollArea",
                "SnapToItems",
                true,
                "AutoHide",
                true
              })
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnDelete()",
              "func",
              function()
                OptionsObj = false
                OptionsObjOriginal = false
                if config.Mods then
                  if ModsOptionsOriginal then
                    CancelModOptions()
                  end
                  ModsOptionsOriginal = false
                end
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "Open(self, ...)",
              "func",
              function(self, ...)
                XWindow.Open(self, ...)
                GetDialog(self)[1]:ResolveId("idOptionsActionsCont"):SetFocus(true)
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "buttons",
            "Id",
            "idOptionsActionsCont",
            "Margins",
            box(0, 0, 0, 20),
            "Dock",
            "bottom"
          }, {
            PlaceObj("XTemplateAction", {
              "ActionId",
              "autoDetect",
              "ActionName",
              T(717827056050, "AUTO DETECT"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "R",
              "ActionGamepad",
              "ButtonY",
              "ActionState",
              function(self, host)
                return "enabled"
              end,
              "OnAction",
              function(self, host, source, ...)
                Options.Autodetect(EngineOptions)
                local obj = ResolvePropObj(self.host:ResolveId("idScrollArea").context)
                obj:SetVideoPreset(EngineOptions.VideoPreset)
                ObjModified(obj)
                local applyButton = self.host.idToolBar:ResolveId("idapplyOptions") or self.host.idToolBar:ResolveId("idapplyDisplayOptions")
                applyButton:SetEnabled(true)
                applyButton.action.enabled = true
                ObjModified("action-button-mm")
              end,
              "FXPress",
              "MainMenuButtonClick",
              "__condition",
              function(parent, context)
                return GetDialogModeParam(parent).optObj.id == "Video"
              end
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "resetToDefaults",
              "ActionName",
              T(274572385258, "RESET"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "R",
              "ActionGamepad",
              "ButtonY",
              "ActionState",
              function(self, host)
                return self.enabled and "enabled" or "disabled"
              end,
              "OnAction",
              function(self, host, source, ...)
                local obj = ResolvePropObj(self.host:ResolveId("idScrollArea").context)
                obj:ResetOptionsByCategory(GetDialogModeParam(self.host).optObj.id, nil, IsInMultiplayerGame() and not NetIsHost() and {Difficulty = true, ForgivingModeToggle = true})
                ObjModified(obj)
                self.host.idToolBar:ResolveId("idresetToDefaults"):SetEnabled(false)
                self.enabled = false
                ObjModified("action-button-mm")
                local applyButton = self.host.idToolBar:ResolveId("idapplyOptions") or self.host.idToolBar:ResolveId("idapplyDisplayOptions")
                applyButton.action.enabled = true
                applyButton:SetEnabled(true)
                ObjModified("action-button-mm")
              end,
              "FXPress",
              "MainMenuButtonClick",
              "__condition",
              function(parent, context)
                local category = GetDialogModeParam(parent).optObj.id
                return category == "Audio" or category == "Controls" or category == "Gameplay" or category == "Display" or category == "Keybindings"
              end
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "applyOptions",
              "ActionName",
              T(916481029421, "APPLY"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "A",
              "ActionGamepad",
              "ButtonX",
              "ActionState",
              function(self, host)
                return self.enabled and "enabled" or "disabled"
              end,
              "OnAction",
              function(self, host, source, ...)
                ApplyOptions(host:ResolveId("idSubMenu"))
                self.host.idToolBar:ResolveId("idapplyOptions"):SetEnabled(false)
                self.enabled = false
                ObjModified("action-button-mm")
              end,
              "FXPress",
              "MainMenuButtonClick",
              "__condition",
              function(parent, context)
                return GetDialogModeParam(parent).optObj.id ~= "Display" and GetDialogModeParam(parent).optObj.id ~= "ModOptions"
              end
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "applyOptions",
              "ActionName",
              T(304603428188, "APPLY"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "A",
              "ActionGamepad",
              "ButtonX",
              "ActionState",
              function(self, host)
                return self.enabled and "enabled" or "disabled"
              end,
              "OnAction",
              function(self, host, source, ...)
                ApplyModOptions(self.host:ResolveId("idScrollArea").context)
                self.host.idToolBar:ResolveId("idapplyOptions"):SetEnabled(false)
                self.enabled = false
                ObjModified("action-button-mm")
              end,
              "FXPress",
              "MainMenuButtonClick",
              "__condition",
              function(parent, context)
                return GetDialogModeParam(parent).optObj.id == "ModOptions"
              end
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "applyDisplayOptions",
              "ActionName",
              T(916481029421, "APPLY"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "A",
              "ActionGamepad",
              "ButtonX",
              "ActionState",
              function(self, host)
                return self.enabled and "enabled" or "disabled"
              end,
              "OnAction",
              function(self, host, source, ...)
                ApplyDisplayOptions(host:ResolveId("idSubMenu"))
                self.host.idToolBar:ResolveId("idapplyDisplayOptions"):SetEnabled(false)
                self.enabled = false
                ObjModified("action-button-mm")
              end,
              "FXPress",
              "MainMenuButtonClick",
              "__condition",
              function(parent, context)
                return GetDialogModeParam(parent).optObj.id == "Display"
              end
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "backToMMbuttons",
              "ActionGamepad",
              "ButtonB",
              "OnAction",
              function(self, host, source, ...)
                self.host:ResolveId("idOptionsActionsCont"):BackToMMButtons(host, "alwaysBack")
              end,
              "FXPress",
              "MainMenuButtonClick"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "backToMMbuttons",
              "ActionGamepad",
              "DPadLeft",
              "OnAction",
              function(self, host, source, ...)
                self.host:ResolveId("idOptionsActionsCont"):BackToMMButtons(host, false)
              end,
              "FXPress",
              "MainMenuButtonClick"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "backToMMbuttons",
              "ActionGamepad",
              "LeftThumbLeft",
              "OnAction",
              function(self, host, source, ...)
                self.host:ResolveId("idOptionsActionsCont"):BackToMMButtons(host, false)
              end,
              "FXPress",
              "MainMenuButtonClick"
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "BackToMMButtons(self, host, alwaysBack)",
              "func",
              function(self, host, alwaysBack)
                local currentSelectionIdx = self.parent:ResolveId("idScrollArea").selection[1]
                local selectedItem = self.parent:ResolveId("idScrollArea")[currentSelectionIdx]
                if not alwaysBack and selectedItem and selectedItem.context.prop_meta.editor == "number" then
                  return
                end
                local list = host:ResolveId("idMainMenuButtonsContent"):ResolveId("idList")
                list:SetFocus(true)
                list:SelectFirstValidItem()
              end
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XZuluToolBarList",
              "Id",
              "idToolBar",
              "ZOrder",
              0,
              "HAlign",
              "center",
              "VAlign",
              "center",
              "MinWidth",
              500,
              "OnLayoutComplete",
              function(self)
                local applyBtn = self:ResolveId("idapplyOptions")
                local applyDisplayBtn = self:ResolveId("idapplyDisplayOptions")
                local resetBtn = self:ResolveId("idresetToDefaults")
                if applyBtn then
                  applyBtn.action.enabled = false
                  applyBtn:SetEnabled(false)
                  ObjModified("action-button-mm")
                end
                if applyDisplayBtn then
                  applyDisplayBtn.action.enabled = false
                  applyDisplayBtn:SetEnabled(false)
                  ObjModified("action-button-mm")
                end
                if resetBtn then
                  resetBtn.action.enabled = true
                  resetBtn:SetEnabled(true)
                  ObjModified("action-button-mm")
                end
              end,
              "Background",
              RGBA(255, 255, 255, 0),
              "Toolbar",
              "ActionBar",
              "Show",
              "text",
              "ButtonTemplate",
              "XWindow",
              "ToolbarSectionTemplate",
              "XZuluToolBarList"
            }, {
              PlaceObj("XTemplateFunc", {
                "comment",
                "position buttons on both corners",
                "name",
                "RebuildActions(self, ...)",
                "func",
                function(self, ...)
                  XZuluToolBarList.RebuildActions(self, ...)
                  local parent = self:GetButtonParent()
                  if #parent == 2 then
                    parent[1]:SetDock("left")
                    parent[2]:SetDock("right")
                  end
                  parent:SetMinWidth(self.MinWidth)
                end
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              OptionsObjOriginal = OptionsCreateAndLoad()
              return OptionsObjOriginal
            end,
            "__class",
            "XContextWindow",
            "Id",
            "idOriginalOptions",
            "Dock",
            "ignore"
          }),
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              local modsOptions
              return OptionsObjOriginal
            end,
            "__class",
            "XContextWindow",
            "Id",
            "idOriginalModOptions",
            "Dock",
            "ignore"
          })
        }),
        PlaceObj("XTemplateMode", {"mode", "newgame"}, {
          PlaceObj("XTemplateWindow", {
            "Id",
            "idNewGameCont",
            "VAlign",
            "top",
            "MinWidth",
            615,
            "MinHeight",
            800,
            "MaxWidth",
            615,
            "MaxHeight",
            800
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "list of options",
              "Id",
              "idNewGameListCont",
              "Dock",
              "top"
            }, {
              PlaceObj("XTemplateWindow", {
                "__context",
                function(parent, context)
                  NewGameObj = NewGameObj or table.copy(NewGameObjOriginal, "deep")
                  return NewGameObj
                end,
                "__class",
                "SnappingScrollArea",
                "Id",
                "idScrollArea",
                "IdNode",
                false,
                "Dock",
                "left",
                "MinWidth",
                600,
                "MaxWidth",
                600,
                "MaxHeight",
                590,
                "HandleKeyboard",
                false,
                "VScroll",
                "idScroll",
                "GamepadInitialSelection",
                true,
                "OnSelection",
                function(self, focused_item, selection)
                  local input = self[focused_item]:ResolveId("idCampaignNameInput")
                  if input then
                    input:SetFocus(true)
                  end
                end
              }, {
                PlaceObj("XTemplateWindow", {
                  "IdNode",
                  true,
                  "MinHeight",
                  64,
                  "MaxHeight",
                  64
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "comment",
                    "campaign",
                    "__template",
                    "NewGameCategory",
                    "RolloverTemplate",
                    "RolloverGenericFixedL",
                    "RolloverAnchor",
                    "right",
                    "RolloverText",
                    T(362111724197, "All saves and autosaves will be grouped by the name of your playthrough."),
                    "RolloverOffset",
                    box(25, 0, 0, 0),
                    "RolloverTitle",
                    T(901455899165, "Playthrough name"),
                    "Id",
                    "idCampaignName",
                    "IdNode",
                    false,
                    "HandleMouse",
                    true,
                    "OnContextUpdate",
                    function(self, context, ...)
                      local name = self.idName
                      name:SetTranslate(false)
                      local campaign_name = NewGameObj.campaign_name
                      if not campaign_name or campaign_name == "" then
                        campaign_name = GetCampaignNameTranslated()
                      end
                      name:SetText(campaign_name)
                      self:ResolveId("idEdit"):SetVisible(true)
                      function self.IsSelectable()
                        return true
                      end
                    end
                  }, {
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "OnMouseButtonDown(self, pos, button)",
                      "func",
                      function(self, pos, button)
                        local editField = self.parent:ResolveId("idCampaignNameInput")
                        if editField then
                          PlayFX("MainMenuButtonClick", "start")
                          editField:SetText(NewGameObj.campaign_name)
                          editField:SetVisible(true)
                          editField:SelectAll()
                          GetDialog(self).parent:SetHandleMouse(true)
                          if GetUIStyleGamepad() then
                            editField:SetFocus(true)
                            editField:OpenControllerTextInput()
                          end
                        end
                      end
                    }),
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "OnShortcut(self, shortcut, source, ...)",
                      "func",
                      function(self, shortcut, source, ...)
                        if shortcut == "ButtonA" then
                          self:OnMouseButtonDown(nil, "L")
                        end
                      end
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XTextEditor",
                    "Id",
                    "idCampaignNameInput",
                    "Margins",
                    box(5, 0, 5, 0),
                    "BorderWidth",
                    3,
                    "Padding",
                    box(14, 9, 2, 1),
                    "Dock",
                    "box",
                    "HAlign",
                    "center",
                    "VAlign",
                    "center",
                    "MinWidth",
                    600,
                    "MinHeight",
                    56,
                    "MaxWidth",
                    600,
                    "MaxHeight",
                    56,
                    "Visible",
                    false,
                    "FoldWhenHidden",
                    true,
                    "DrawOnTop",
                    true,
                    "BorderColor",
                    RGBA(215, 159, 80, 255),
                    "Background",
                    RGBA(88, 92, 68, 255),
                    "BackgroundRectGlowColor",
                    RGBA(0, 0, 0, 0),
                    "FocusedBorderColor",
                    RGBA(215, 159, 80, 255),
                    "FocusedBackground",
                    RGBA(88, 92, 68, 255),
                    "DisabledBorderColor",
                    RGBA(128, 128, 128, 0),
                    "DisabledBackground",
                    RGBA(0, 0, 0, 255),
                    "TextStyle",
                    "MMNewGameName",
                    "OnTextChanged",
                    function(self)
                      local newText = self:GetText() ~= "" and self:GetText()
                      if not newText or newText == "" then
                        newText = GetCampaignNameTranslated()
                      end
                      if self:IsFocused() then
                        PlayFX("Typing", "start")
                      end
                      local name = self.parent:ResolveId("idCampaignName")
                      name:SetName(newText)
                      NewGameObj.campaign_name = newText
                    end,
                    "ConsoleKeyboardDescription",
                    T(318014148083, "Enter Campaign Name"),
                    "WordWrap",
                    false,
                    "AllowPaste",
                    false,
                    "AllowEscape",
                    false,
                    "MaxVisibleLines",
                    1,
                    "MaxLines",
                    1,
                    "MaxLen",
                    20,
                    "HintColor",
                    RGBA(0, 0, 0, 0),
                    "SelectionBackground",
                    RGBA(124, 130, 96, 255)
                  }, {
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "OnKillFocus",
                      "func",
                      function(self, ...)
                        PlayFX("MainMenuButtonClick", "start")
                        GetDialog(self)[1]:ResolveId("idNewGameActionsCont"):SetFocus(true)
                        if GetUIStyleGamepad() then
                          self.parent.idCampaignName:SetSelected(true)
                        else
                          self.parent.idCampaignName:SetSelected(false)
                        end
                        GetDialog(self).parent:SetHandleMouse(false)
                        self:LockScrollWhileEdit(false)
                        self:SetVisible(false)
                        XTextEditor.OnKillFocus(self)
                      end
                    }),
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "OnShortcut(self, shortcut, source, ...)",
                      "func",
                      function(self, shortcut, source, ...)
                        if shortcut == "Escape" or shortcut == "Enter" or GetUIStyleGamepad() then
                          self:OnKillFocus()
                          return "break"
                        else
                          XTextEditor.OnShortcut(self, shortcut, source, ...)
                        end
                      end
                    }),
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "OnSetFocus(self)",
                      "func",
                      function(self)
                        XTextEditor.OnSetFocus(self)
                        self:LockScrollWhileEdit(true)
                      end
                    }),
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "LockScrollWhileEdit(self, lock)",
                      "func",
                      function(self, lock)
                        local contentTemplate = GetDialog(self)[1]
                        contentTemplate:ResolveValue("idScrollArea"):SetMouseScroll(not lock)
                        contentTemplate:ResolveValue("idScroll"):SetHandleMouse(not lock)
                        contentTemplate:ResolveValue("idScroll"):SetHandleKeyboard(not lock)
                      end
                    })
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "SetSelected(self, selected)",
                    "func",
                    function(self, selected)
                      self.idCampaignName:SetSelected(selected)
                    end
                  })
                }),
                PlaceObj("XTemplateTemplate", {
                  "comment",
                  "difficulty",
                  "__template",
                  "NewGameCategory",
                  "IdNode",
                  false,
                  "Name",
                  T(773633407484, "Difficulty")
                }),
                PlaceObj("XTemplateTemplate", {
                  "__context",
                  function(parent, context)
                    return GameDifficulties.Normal
                  end,
                  "__template",
                  "NewGameDiffEntry",
                  "Id",
                  "idNormal",
                  "IdNode",
                  false
                }),
                PlaceObj("XTemplateTemplate", {
                  "__context",
                  function(parent, context)
                    return GameDifficulties.Hard
                  end,
                  "__template",
                  "NewGameDiffEntry",
                  "Id",
                  "idHard",
                  "IdNode",
                  false
                }),
                PlaceObj("XTemplateTemplate", {
                  "__context",
                  function(parent, context)
                    return GameDifficulties.VeryHard
                  end,
                  "__template",
                  "NewGameDiffEntry",
                  "Id",
                  "idVeryHard",
                  "IdNode",
                  false
                }),
                PlaceObj("XTemplateTemplate", {
                  "comment",
                  "game rules",
                  "__template",
                  "NewGameCategory",
                  "IdNode",
                  false,
                  "Name",
                  T(191935465467, "Game Rules")
                }),
                PlaceObj("XTemplateTemplate", {
                  "__context",
                  function(parent, context)
                    return GameRuleDefs.ForgivingMode
                  end,
                  "__template",
                  "NewGameBoolEntry",
                  "Id",
                  "idForgivingMode",
                  "IdNode",
                  false
                }),
                PlaceObj("XTemplateTemplate", {
                  "__context",
                  function(parent, context)
                    return GameRuleDefs.DeadIsDead
                  end,
                  "__template",
                  "NewGameBoolEntry",
                  "IdNode",
                  false
                }),
                PlaceObj("XTemplateTemplate", {
                  "__context",
                  function(parent, context)
                    return GameRuleDefs.Ironman
                  end,
                  "__template",
                  "NewGameBoolEntry",
                  "IdNode",
                  false
                }),
                PlaceObj("XTemplateTemplate", {
                  "__context",
                  function(parent, context)
                    return GameRuleDefs.LethalWeapons
                  end,
                  "__template",
                  "NewGameBoolEntry",
                  "IdNode",
                  false
                }),
                PlaceObj("XTemplateTemplate", {
                  "comment",
                  "settings",
                  "__template",
                  "NewGameMenuSettings"
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XZuluScroll",
                "Id",
                "idScroll",
                "Margins",
                box(0, 10, 0, 15),
                "Dock",
                "right",
                "HAlign",
                "right",
                "UniformRowHeight",
                true,
                "MouseCursor",
                "UI/Cursors/Hand.tga",
                "Target",
                "idScrollArea",
                "SnapToItems",
                true,
                "AutoHide",
                true
              })
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnDelete()",
              "func",
              function()
                NewGameObj = false
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "Open(self, ...)",
              "func",
              function(self, ...)
                XWindow.Open(self, ...)
                GetDialog(self)[1]:ResolveId("idNewGameActionsCont"):SetFocus(true)
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "buttons",
            "Id",
            "idNewGameActionsCont",
            "Margins",
            box(0, 0, 0, 20),
            "Dock",
            "bottom"
          }, {
            PlaceObj("XTemplateAction", {
              "ActionId",
              "resetToDefaults",
              "ActionName",
              T(871480685359, "Default"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "D",
              "ActionGamepad",
              "ButtonY",
              "OnAction",
              function(self, host, source, ...)
                NewGameObj = table.copy(NewGameObjOriginal, "deep")
                for _, entry in ipairs(self.host:ResolveId("idScrollArea")) do
                  if entry.class == "XButton" then
                    entry:OnContextUpdate()
                  else
                    entry:ResolveId("idCampaignName"):OnContextUpdate()
                    entry:ResolveId("idCampaignNameInput"):OnContextUpdate()
                  end
                end
              end,
              "FXPress",
              "MainMenuButtonClick",
              "FXPressDisabled",
              "activityAssignSelectDisabled"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "startNewGame",
              "ActionName",
              T(137021205855, "START GAME"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "Enter",
              "ActionGamepad",
              "ButtonX",
              "OnAction",
              function(self, host, source, ...)
                EditorDeactivate()
                CreateRealTimeThread(function()
                  if not NewGameObj.campaign_name or NewGameObj.campaign_name == "" then
                    NewGameObj.campaign_name = GetCampaignNameTranslated()
                  end
                  StartCampaign("HotDiamonds", NewGameObj)
                  CloseMenuDialogs()
                end)
              end,
              "FXPress",
              "MainMenuButtonClick",
              "FXPressDisabled",
              "activityAssignSelectDisabled"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "backToMMbuttons",
              "ActionGamepad",
              "ButtonB",
              "OnAction",
              function(self, host, source, ...)
                self.host:ResolveId("idNewGameActionsCont"):BackToMMButtons(host)
              end,
              "FXPress",
              "MainMenuButtonClick"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "backToMMbuttons",
              "ActionGamepad",
              "DPadLeft",
              "OnAction",
              function(self, host, source, ...)
                self.host:ResolveId("idNewGameActionsCont"):BackToMMButtons(host)
              end,
              "FXPress",
              "MainMenuButtonClick"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "backToMMbuttons",
              "ActionGamepad",
              "LeftThumbLeft",
              "OnAction",
              function(self, host, source, ...)
                self.host:ResolveId("idNewGameActionsCont"):BackToMMButtons(host)
              end,
              "FXPress",
              "MainMenuButtonClick"
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "BackToMMButtons(self, host)",
              "func",
              function(self, host)
                local list = host:ResolveId("idMainMenuButtonsContent"):ResolveId("idList")
                list:SetFocus(true)
                list:SelectFirstValidItem()
              end
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XZuluToolBarList",
              "Id",
              "idToolBar",
              "ZOrder",
              0,
              "HAlign",
              "center",
              "VAlign",
              "center",
              "MinWidth",
              500,
              "OnLayoutComplete",
              function(self)
                for _, button in ipairs(self.list) do
                  local textButton = button[4]
                  local ogText = rawget(textButton, "ogText")
                  if not ogText then
                    rawset(textButton, "ogText", button.Text)
                    ogText = textButton.Text
                  end
                  local newShortcut = GetShortcutButtonT(button[4].action)
                  textButton:SetText(T({
                    828903919196,
                    "<style PDAIMPCounter>[<shortcut>]</style> <text>",
                    text = ogText,
                    shortcut = newShortcut or ""
                  }))
                end
              end,
              "Background",
              RGBA(255, 255, 255, 0),
              "Toolbar",
              "ActionBar",
              "Show",
              "text",
              "ButtonTemplate",
              "OptionsActionsButton"
            }, {
              PlaceObj("XTemplateFunc", {
                "comment",
                "position buttons on both corners",
                "name",
                "RebuildActions(self, ...)",
                "func",
                function(self, ...)
                  XZuluToolBarList.RebuildActions(self, ...)
                  local parent = self:GetButtonParent()
                  if #parent == 2 then
                    parent[1]:SetDock("left")
                    parent[2]:SetDock("right")
                  end
                  parent:SetMinWidth(self.MinWidth)
                end
              })
            })
          })
        }),
        PlaceObj("XTemplateMode", {"mode", "loadgame"}, {
          PlaceObj("XTemplateWindow", {
            "Id",
            "idLoadGameContent",
            "VAlign",
            "top",
            "MinWidth",
            615,
            "MinHeight",
            800,
            "MaxWidth",
            615,
            "MaxHeight",
            800
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "list of options",
              "Id",
              "idLoadGameListCont",
              "Dock",
              "top"
            }, {
              PlaceObj("XTemplateWindow", {
                "__condition",
                function(parent, context)
                  return Platform.developer and config.saveSearchFilter
                end,
                "__class",
                "XTextEditor",
                "Id",
                "idSearchFilter",
                "Margins",
                box(5, 0, 5, 0),
                "BorderWidth",
                3,
                "Dock",
                "top",
                "HAlign",
                "center",
                "VAlign",
                "center",
                "MinWidth",
                300,
                "MinHeight",
                40,
                "MaxWidth",
                300,
                "MaxHeight",
                40,
                "FoldWhenHidden",
                true,
                "DrawOnTop",
                true,
                "BorderColor",
                RGBA(215, 159, 80, 255),
                "Background",
                RGBA(88, 92, 68, 255),
                "BackgroundRectGlowColor",
                RGBA(0, 0, 0, 0),
                "FocusedBorderColor",
                RGBA(215, 159, 80, 255),
                "FocusedBackground",
                RGBA(88, 92, 68, 255),
                "DisabledBorderColor",
                RGBA(128, 128, 128, 0),
                "DisabledBackground",
                RGBA(0, 0, 0, 255),
                "TextStyle",
                "MMNewGameName",
                "OnTextChanged",
                function(self)
                  local listOfSaves = GetDialog(self):ResolveId("idSubMenu").idScrollArea
                  listOfSaves:Invalidate()
                  listOfSaves:InvalidateMeasure()
                  ObjModified("searchsaves")
                end,
                "WordWrap",
                false,
                "AllowPaste",
                false,
                "AllowEscape",
                false,
                "MaxVisibleLines",
                1,
                "MaxLines",
                1,
                "MaxLen",
                25,
                "HintColor",
                RGBA(0, 0, 0, 0),
                "SelectionBackground",
                RGBA(124, 130, 96, 255)
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnKillFocus",
                  "func",
                  function(self, ...)
                    GetDialog(self).parent:SetFocus(true)
                    GetDialog(self).parent:SetHandleMouse(false)
                    XTextEditor.OnKillFocus(self)
                  end
                }),
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnShortcut(self, shortcut, source, ...)",
                  "func",
                  function(self, shortcut, source, ...)
                    if shortcut == "Escape" or shortcut == "Enter" then
                      self:SetFocus(false)
                      XTextEditor.OnKillFocus(self)
                      return "break"
                    else
                      XTextEditor.OnShortcut(self, shortcut, source, ...)
                    end
                  end
                }),
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnSetFocus(self, old_focus)",
                  "func",
                  function(self, old_focus)
                    GetDialog(self).parent:SetHandleMouse(true)
                    XTextEditor.OnSetFocus(self, old_focus)
                  end
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__context",
                function(parent, context)
                  return "searchsaves"
                end,
                "__class",
                "SnappingScrollArea",
                "Id",
                "idScrollArea",
                "IdNode",
                false,
                "Dock",
                "left",
                "MinWidth",
                600,
                "MaxWidth",
                600,
                "MaxHeight",
                600,
                "HandleKeyboard",
                false,
                "VScroll",
                "idScroll"
              }, {
                PlaceObj("XTemplateForEach", {
                  "comment",
                  "item",
                  "array",
                  function(parent, context)
                    return GetSaveGamesGrouped(GetDialogModeParam(parent), GetDialog(parent):ResolveId("idSubMenu"):ResolveId("idSearchFilter") and GetDialog(parent):ResolveId("idSubMenu"):ResolveId("idSearchFilter"):GetText() or "")
                  end,
                  "__context",
                  function(parent, context, item, i, n)
                    return item
                  end,
                  "run_before",
                  function(parent, context, item, i, n, last)
                    if i == 1 then
                      for _, save in ipairs(context.saves) do
                        save.first = true
                      end
                    end
                    context.playthrough = true
                  end,
                  "run_after",
                  function(child, context, item, i, n, last)
                    child.idName:SetText(Untranslated(context.displayName))
                    child.idDate:SetText(numberToTimeDate(context.time_end, "real_time"))
                    if i == 1 then
                      child.idExpand:SetFlipY(false)
                    end
                  end
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "comment",
                    "playthrough",
                    "__template",
                    "LoadGamePlaythrough",
                    "IdNode",
                    false
                  }),
                  PlaceObj("XTemplateForEach", {
                    "comment",
                    "item",
                    "array",
                    function(parent, context)
                      return context.saves
                    end,
                    "__context",
                    function(parent, context, item, i, n)
                      return item
                    end,
                    "run_after",
                    function(child, context, item, i, n, last)
                      if context.metadata.autosave then
                        child.idAutosave:SetVisible(true)
                      end
                      child.idName:SetText(SavenameToName(context.metadata.savename))
                      local saveState = context.metadata.save_game_state
                      local saveStateTurnNumber = context.metadata.turn_phase
                      child.idSaveState:SetText(GetSaveState(saveState, saveStateTurnNumber, saveStateTurnNumber))
                      child.context = context
                      if GetUIStyleGamepad() then
                        child.RolloverOnFocus = true
                      end
                      child:SetVisible(context.first)
                      if i == 1 and context.first then
                        g_SelectedSave = child.context
                        local searchOption = GetDialog(child):ResolveId("idSubMenu"):ResolveId("idSearchFilter")
                        if not searchOption then
                          child:SetSelected(true)
                          child.parent:SetSelection(2)
                        else
                          GetDialog(child).parent:SetHandleMouse(true)
                        end
                        GetDialog(child):ResolveId("idSubSubContent"):SetMode("save", g_SelectedSave)
                        ShowSavegameDescription(g_SelectedSave, GetDialog(child):ResolveId("idSubSubContent"))
                      end
                    end
                  }, {
                    PlaceObj("XTemplateTemplate", {
                      "comment",
                      "save of playthrough",
                      "__template",
                      "SaveEntry",
                      "IdNode",
                      false
                    })
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XZuluScroll",
                "Id",
                "idScroll",
                "Margins",
                box(0, 10, 0, 30),
                "Dock",
                "right",
                "HAlign",
                "right",
                "UniformRowHeight",
                true,
                "MouseCursor",
                "UI/Cursors/Hand.tga",
                "Target",
                "idScrollArea",
                "SnapToItems",
                true,
                "AutoHide",
                true
              })
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnDelete",
              "func",
              function(self, ...)
                if config.SaveGameScreenshot then
                  CreateRealTimeThread(function()
                    Savegame.Unmount()
                  end)
                end
                g_SaveGameObj = false
                g_CurrentSaveGameItemId = false
                g_SelectedSave = false
                XWindow.OnDelete(self)
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "buttons",
            "__context",
            function(parent, context)
              return "NewSelectedSave"
            end,
            "__class",
            "XContextWindow",
            "Id",
            "idLoadGameActionsCont",
            "Margins",
            box(0, 0, 0, 20),
            "Dock",
            "bottom",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              self:ResolveId("idToolBar"):RebuildActions(GetDialog(self))
            end
          }, {
            PlaceObj("XTemplateAction", {
              "ActionId",
              "deleteSave",
              "ActionName",
              T(189828394337, "DELETE"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "D",
              "ActionGamepad",
              "ButtonY",
              "ActionState",
              function(self, host)
                return CanDeleteSave(g_SelectedSave) and "enabled" or "disabled"
              end,
              "OnAction",
              function(self, host, source, ...)
                if self:ActionState() == "enabled" then
                  local dlg = host.idSubContent
                  local obj = GetDialogModeParam(dlg)
                  obj:Delete(dlg, self.host.idScrollArea)
                end
              end,
              "FXPress",
              "MainMenuButtonClick",
              "FXPressDisabled",
              "activityAssignSelectDisabled"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "loadSave",
              "ActionName",
              T(715629993564, "LOAD  GAME"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "Enter",
              "ActionGamepad",
              "ButtonX",
              "ActionState",
              function(self, host)
                return CanLoadSave(g_SelectedSave) and "enabled" or "disabled"
              end,
              "OnAction",
              function(self, host, source, ...)
                if self:ActionState() == "enabled" then
                  local dlg = host.idSubContent
                  local obj = GetDialogModeParam(host.idSubContent)
                  obj:Load(dlg, g_SelectedSave, Platform.developer)
                end
              end,
              "FXPress",
              "MainMenuButtonClick",
              "FXPressDisabled",
              "activityAssignSelectDisabled"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "backToMMbuttons",
              "ActionGamepad",
              "ButtonB",
              "OnAction",
              function(self, host, source, ...)
                self.host:ResolveId("idLoadGameActionsCont"):BackToMMButtons(host)
              end,
              "FXPress",
              "MainMenuButtonClick"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "backToMMbuttons",
              "ActionGamepad",
              "DPadLeft",
              "OnAction",
              function(self, host, source, ...)
                self.host:ResolveId("idLoadGameActionsCont"):BackToMMButtons(host)
              end,
              "FXPress",
              "MainMenuButtonClick"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "backToMMbuttons",
              "ActionGamepad",
              "LeftThumbLeft",
              "OnAction",
              function(self, host, source, ...)
                self.host:ResolveId("idLoadGameActionsCont"):BackToMMButtons(host)
              end,
              "FXPress",
              "MainMenuButtonClick"
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "BackToMMButtons(self, host)",
              "func",
              function(self, host)
                local list = host:ResolveId("idMainMenuButtonsContent"):ResolveId("idList")
                list:SetFocus(true)
                list:SelectFirstValidItem()
              end
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XZuluToolBarList",
              "Id",
              "idToolBar",
              "ZOrder",
              0,
              "HAlign",
              "center",
              "VAlign",
              "center",
              "MinWidth",
              500,
              "Background",
              RGBA(255, 255, 255, 0),
              "Toolbar",
              "ActionBar",
              "Show",
              "text",
              "ButtonTemplate",
              "OptionsActionsButton"
            }, {
              PlaceObj("XTemplateFunc", {
                "comment",
                "position buttons on both corners",
                "name",
                "RebuildActions(self, ...)",
                "func",
                function(self, ...)
                  XZuluToolBarList.RebuildActions(self, ...)
                  local parent = self:GetButtonParent()
                  if #parent == 2 then
                    parent[1]:SetDock("left")
                    parent[2]:SetDock("right")
                  end
                  parent:SetMinWidth(self.MinWidth)
                end
              })
            })
          })
        }),
        PlaceObj("XTemplateMode", {
          "mode",
          "installedmods"
        }, {
          PlaceObj("XTemplateWindow", {
            "Id",
            "idInstalledModsContent",
            "VAlign",
            "top",
            "MinWidth",
            615,
            "MinHeight",
            800,
            "MaxWidth",
            615,
            "MaxHeight",
            800
          }, {
            PlaceObj("XTemplateWindow", {
              "Id",
              "idInstalledModsActionsCont",
              "Margins",
              box(-10, 0, 0, 24),
              "Dock",
              "bottom",
              "MinWidth",
              600,
              "MaxWidth",
              600
            }, {
              PlaceObj("XTemplateAction", {
                "ActionId",
                "backToMMbuttons",
                "ActionGamepad",
                "ButtonB",
                "OnAction",
                function(self, host, source, ...)
                  self.host:ResolveId("idInstalledModsActionsCont"):BackToMMButtons(host)
                end,
                "FXPress",
                "MainMenuButtonClick"
              }),
              PlaceObj("XTemplateAction", {
                "ActionId",
                "backToMMbuttons",
                "ActionGamepad",
                "DPadLeft",
                "OnAction",
                function(self, host, source, ...)
                  self.host:ResolveId("idInstalledModsActionsCont"):BackToMMButtons(host)
                end,
                "FXPress",
                "MainMenuButtonClick"
              }),
              PlaceObj("XTemplateAction", {
                "ActionId",
                "backToMMbuttons",
                "ActionGamepad",
                "LeftThumbLeft",
                "OnAction",
                function(self, host, source, ...)
                  self.host:ResolveId("idInstalledModsActionsCont"):BackToMMButtons(host)
                end,
                "FXPress",
                "MainMenuButtonClick"
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "BackToMMButtons(self, host)",
                "func",
                function(self, host)
                  local list = host:ResolveId("idMainMenuButtonsContent"):ResolveId("idList")
                  list:SetFocus(true)
                  list:SelectFirstValidItem()
                end
              })
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "list of installed mods",
              "Id",
              "idLoadGameListCont",
              "Dock",
              "top"
            }, {
              PlaceObj("XTemplateWindow", {
                "__context",
                function(parent, context)
                  ModsUIDialogStart()
                  return g_ModsUIContextObj
                end,
                "__class",
                "SnappingScrollArea",
                "Id",
                "idScrollArea",
                "IdNode",
                false,
                "Dock",
                "left",
                "MinWidth",
                600,
                "MaxWidth",
                600,
                "MaxHeight",
                600,
                "HandleKeyboard",
                false,
                "VScroll",
                "idScroll",
                "GamepadInitialSelection",
                true,
                "KeepSelectionOnRespawn",
                true
              }, {
                PlaceObj("XTemplateForEach", {
                  "comment",
                  "mod",
                  "array",
                  function(parent, context)
                    return table.map(context.installed_mods, context.mod_ui_entries)
                  end,
                  "run_after",
                  function(child, context, item, i, n, last)
                    if GetUIStyleGamepad() then
                      child.RolloverOnFocus = true
                    end
                    PopulateModEntry(child, item)
                  end
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "comment",
                    "mod entry",
                    "__template",
                    "ModEntry",
                    "IdNode",
                    false
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XZuluScroll",
                "Id",
                "idScroll",
                "Margins",
                box(0, 10, 0, 30),
                "Dock",
                "right",
                "HAlign",
                "right",
                "UniformRowHeight",
                true,
                "MouseCursor",
                "UI/Cursors/Hand.tga",
                "Target",
                "idScrollArea",
                "SnapToItems",
                true,
                "AutoHide",
                true
              })
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnDelete",
              "func",
              function(self, ...)
                g_SelectedMod = false
                XWindow.OnDelete(self)
              end
            })
          })
        }),
        PlaceObj("XTemplateMode", {"mode", "replays"}, {
          PlaceObj("XTemplateWindow", {
            "Id",
            "idLoadGameContent",
            "VAlign",
            "top",
            "MinWidth",
            615,
            "MinHeight",
            800,
            "MaxWidth",
            615,
            "MaxHeight",
            800
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "list of options",
              "Id",
              "idLoadGameListCont",
              "Dock",
              "top"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "SnappingScrollArea",
                "Id",
                "idScrollArea",
                "IdNode",
                false,
                "Dock",
                "left",
                "MinWidth",
                600,
                "MaxWidth",
                600,
                "MaxHeight",
                600,
                "VScroll",
                "idScroll"
              }, {
                PlaceObj("XTemplateForEach", {
                  "comment",
                  "item",
                  "array",
                  function(parent, context)
                    return GetDialogModeParam(parent)
                  end,
                  "__context",
                  function(parent, context, item, i, n)
                    return item
                  end,
                  "run_after",
                  function(child, context, item, i, n, last)
                    local folder, file, ext = SplitPath(item)
                    child.idName:SetText(file)
                  end
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "__template",
                    "ReplayEntry",
                    "IdNode",
                    false
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XZuluScroll",
                "Id",
                "idScroll",
                "Margins",
                box(0, 10, 0, 30),
                "Dock",
                "right",
                "HAlign",
                "right",
                "UniformRowHeight",
                true,
                "MouseCursor",
                "UI/Cursors/Hand.tga",
                "Target",
                "idScrollArea",
                "SnapToItems",
                true,
                "AutoHide",
                true
              })
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnDelete",
              "func",
              function(self, ...)
                if config.SaveGameScreenshot then
                  CreateRealTimeThread(function()
                    Savegame.Unmount()
                  end)
                end
                g_SaveGameObj = false
                g_CurrentSaveGameItemId = false
                g_SelectedSave = false
                XWindow.OnDelete(self)
              end
            })
          })
        }),
        PlaceObj("XTemplateMode", {"mode", "savegame"}, {
          PlaceObj("XTemplateWindow", {
            "Id",
            "idLoadGameContent",
            "VAlign",
            "top",
            "MinWidth",
            615,
            "MinHeight",
            800,
            "MaxWidth",
            615,
            "MaxHeight",
            800
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "list of options",
              "Id",
              "idLoadGameListCont",
              "Dock",
              "top"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "SnappingScrollArea",
                "Id",
                "idScrollArea",
                "IdNode",
                false,
                "Dock",
                "left",
                "MinWidth",
                600,
                "MaxWidth",
                600,
                "MaxHeight",
                600,
                "HandleKeyboard",
                false,
                "VScroll",
                "idScroll"
              }, {
                PlaceObj("XTemplateForEach", {
                  "comment",
                  "item",
                  "array",
                  function(parent, context)
                    local newSave = true
                    if IsGameRuleActive("DeadIsDead") and not Game.isDev then
                      local saveLoad = g_SaveGameObj or SaveLoadObjectCreateAndLoad()
                      local err, saves = saveLoad:ListSavegames()
                      for _, save in ipairs(saves) do
                        if save.gameid == Game.id then
                          newSave = false
                          break
                        end
                      end
                    end
                    return GetSaveGamesGrouped(GetDialogModeParam(parent), nil, newSave)
                  end,
                  "condition",
                  function(parent, context, item, i)
                    if Game.isDev then
                      return true
                    else
                      return i == 1
                    end
                  end,
                  "__context",
                  function(parent, context, item, i, n)
                    return item
                  end,
                  "run_before",
                  function(parent, context, item, i, n, last)
                    if i == 1 then
                      for _, save in ipairs(context.saves) do
                        save.first = true
                      end
                    end
                    context.playthrough = true
                  end,
                  "run_after",
                  function(child, context, item, i, n, last)
                    child.idName:SetText(Untranslated(context.displayName))
                    child.idDate:SetText(numberToTimeDate(context.time_end, "real_time"))
                    if i == 1 then
                      child.idExpand:SetFlipY(false)
                    end
                  end
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "comment",
                    "playthrough",
                    "__template",
                    "LoadGamePlaythrough",
                    "IdNode",
                    false
                  }),
                  PlaceObj("XTemplateForEach", {
                    "comment",
                    "item",
                    "array",
                    function(parent, context)
                      return context.saves
                    end,
                    "condition",
                    function(parent, context, item, i)
                      return not item.metadata.quicksave
                    end,
                    "__context",
                    function(parent, context, item, i, n)
                      return item
                    end,
                    "run_after",
                    function(child, context, item, i, n, last)
                      if context.metadata.autosave then
                        child.idSaveEntry.idAutosave:SetVisible(true)
                      end
                      child.idSaveEntry.idName:SetText(SavenameToName(context.metadata.savename))
                      local saveState = context.metadata.save_game_state
                      local saveStateTurnNumber = context.metadata.turn_phase
                      child.idSaveEntry.idSaveState:SetText(GetSaveState(saveState, saveStateTurnNumber, saveStateTurnNumber))
                      child.idSaveEntry.context = context
                      if GetUIStyleGamepad() then
                        child.idSaveEntry.RolloverOnFocus = true
                        child.idNewSave.RolloverOnFocus = true
                      end
                      local editField = child.idNewSave
                      editField.context = table.copy(context, "deep")
                      if editField.context.newSave or IsGameRuleActive("DeadIsDead") and not Game.isDev and editField.context.metadata.gameid == Game.id then
                        child.idSaveEntry:ResolveId("idImgAbove"):SetVisible(true)
                        child.idSaveEntry:ResolveId("idName"):SetTextStyle("MMOptionEntryValue")
                        local saveNameText = T(914064246115, "NEW SAVE")
                        child.idSaveEntry.idName:SetText(_InternalTranslate(saveNameText))
                        child.idSaveEntry.idSaveState:SetText("")
                        if GetUIStyleGamepad() then
                          child:SetSelected(true)
                          child.parent:SetSelection(2)
                        end
                        GetDialog(child).parent:SetHandleMouse(true)
                      end
                      child:SetVisible(Game and context.metadata.gameid == Game.id or context.first)
                    end
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "IdNode",
                      true,
                      "MinHeight",
                      64,
                      "MaxHeight",
                      64,
                      "FoldWhenHidden",
                      true
                    }, {
                      PlaceObj("XTemplateTemplate", {
                        "comment",
                        "save of playthrough",
                        "__template",
                        "SaveEntry",
                        "Id",
                        "idSaveEntry",
                        "Visible",
                        true
                      }),
                      PlaceObj("XTemplateTemplate", {
                        "comment",
                        "edit field",
                        "__template",
                        "SaveEntryEdit"
                      }),
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "SetSelected(self, selected)",
                        "func",
                        function(self, selected)
                          self.idSaveEntry:SetSelected(selected)
                        end
                      })
                    })
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XZuluScroll",
                "Id",
                "idScroll",
                "Margins",
                box(0, 10, 0, 25),
                "Dock",
                "right",
                "HAlign",
                "right",
                "UniformRowHeight",
                true,
                "MouseCursor",
                "UI/Cursors/Hand.tga",
                "Target",
                "idScrollArea",
                "SnapToItems",
                true,
                "AutoHide",
                true
              })
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnDelete",
              "func",
              function(self, ...)
                if config.SaveGameScreenshot then
                  CreateRealTimeThread(function()
                    Savegame.Unmount()
                  end)
                end
                g_SaveGameObj = false
                g_CurrentSaveGameItemId = false
                g_SelectedSave = false
                XWindow.OnDelete(self)
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "buttons",
            "__context",
            function(parent, context)
              return "NewSelectedSave"
            end,
            "__class",
            "XContextWindow",
            "Id",
            "idLoadGameActionsCont",
            "Margins",
            box(-10, 0, 0, 20),
            "Dock",
            "bottom",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              self:ResolveId("idToolBar"):RebuildActions(GetDialog(self))
            end
          }, {
            PlaceObj("XTemplateAction", {
              "ActionId",
              "deleteSave",
              "ActionName",
              T(189828394337, "DELETE"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "D",
              "ActionGamepad",
              "ButtonY",
              "ActionState",
              function(self, host)
                return CanDeleteSave(g_SelectedSave) and "enabled" or "disabled"
              end,
              "OnAction",
              function(self, host, source, ...)
                if self:ActionState() == "enabled" then
                  local dlg = host.idSubContent
                  local obj = GetDialogModeParam(dlg)
                  obj:Delete(dlg, self.host.idScrollArea)
                end
              end,
              "FXPress",
              "MainMenuButtonClick",
              "FXPressDisabled",
              "activityAssignSelectDisabled"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "saveGame",
              "ActionName",
              T(718092407657, "SAVE  GAME"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "Enter",
              "ActionGamepad",
              "ButtonX",
              "ActionState",
              function(self, host)
                return g_SelectedSave and g_SelectedSave.metadata.gameid == Game.id and "enabled" or "disabled"
              end,
              "OnAction",
              function(self, host, source, ...)
                if self:ActionState() == "enabled" then
                  local dlg = host.idSubContent
                  local obj = GetDialogModeParam(dlg)
                  CreateRealTimeThread(function(obj)
                    OverwriteSaveQuestion(obj)
                  end, obj)
                end
              end,
              "FXPress",
              "MainMenuButtonClick",
              "FXPressDisabled",
              "activityAssignSelectDisabled"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "backToMMbuttons",
              "ActionGamepad",
              "ButtonB",
              "OnAction",
              function(self, host, source, ...)
                self.host:ResolveId("idLoadGameActionsCont"):BackToMMButtons(host)
              end,
              "FXPress",
              "MainMenuButtonClick"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "backToMMbuttons",
              "ActionGamepad",
              "DPadLeft",
              "OnAction",
              function(self, host, source, ...)
                self.host:ResolveId("idLoadGameActionsCont"):BackToMMButtons(host)
              end,
              "FXPress",
              "MainMenuButtonClick"
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "backToMMbuttons",
              "ActionGamepad",
              "LeftThumbLeft",
              "OnAction",
              function(self, host, source, ...)
                self.host:ResolveId("idLoadGameActionsCont"):BackToMMButtons(host)
              end,
              "FXPress",
              "MainMenuButtonClick"
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "BackToMMButtons(self, host)",
              "func",
              function(self, host)
                local list = host:ResolveId("idMainMenuButtonsContent"):ResolveId("idList")
                list:SetFocus(true)
                list:SelectFirstValidItem()
              end
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XZuluToolBarList",
              "Id",
              "idToolBar",
              "ZOrder",
              0,
              "HAlign",
              "center",
              "VAlign",
              "center",
              "MinWidth",
              500,
              "Background",
              RGBA(255, 255, 255, 0),
              "Toolbar",
              "ActionBar",
              "Show",
              "text",
              "ButtonTemplate",
              "OptionsActionsButton"
            }, {
              PlaceObj("XTemplateFunc", {
                "comment",
                "position buttons on both corners",
                "name",
                "RebuildActions(self, ...)",
                "func",
                function(self, ...)
                  XZuluToolBarList.RebuildActions(self, ...)
                  local parent = self:GetButtonParent()
                  if #parent == 2 then
                    parent[1]:SetDock("left")
                    parent[2]:SetDock("right")
                  end
                  parent:SetMinWidth(self.MinWidth)
                end
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return NewGameObjOriginal
          end,
          "__class",
          "XContextWindow",
          "Id",
          "idOriginalNewGameObj",
          "Dock",
          "ignore"
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "GetCategoryId",
          "func",
          function(self, ...)
            local mode_param = GetDialogModeParam(self).optObj
            return mode_param.id
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "RespawnContent(self)",
          "func",
          function(self)
            local scroll = self.idScroll
            local list = self.idScrollArea
            local lastScrollPos = scroll and scroll:GetScroll()
            local lastSelected = list and list.selection and #list.selection >= 1 and list.selection
            XContentTemplate.RespawnContent(self)
            RunWhenXWindowIsReady(self, function()
              if self.idScroll and lastScrollPos then
                self.idScroll:SetScroll(lastScrollPos)
              end
              if self.idScrollArea and lastSelected then
                self.idScrollArea:SetSelection(lastSelected[1])
              end
            end)
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "controller support",
        "__context",
        function(parent, context)
          return "GamepadUIStyleChanged"
        end,
        "__class",
        "XContextWindow",
        "Id",
        "idControllerSupport",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local subMenu = self.parent and self.parent:ResolveId("idSubMenu")
          local mainMenuButtons = self.parent and self.parent:ResolveId("idList")
          local scrollArea = subMenu and subMenu:ResolveId("idScrollArea")
          if GetUIStyleGamepad() and scrollArea then
            scrollArea:SetHandleKeyboard(true)
            if not next(scrollArea.selection) then
              mainMenuButtons:SelectFirstValidItem()
            end
          else
            mainMenuButtons:SetFocus(true)
            if scrollArea then
              scrollArea:SetHandleKeyboard(false)
            end
          end
        end
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XDialog",
      "Id",
      "idSubSubContent",
      "Margins",
      box(10, 0, 0, 0),
      "UseClipBox",
      false,
      "InternalModes",
      "items, empty, save, mod"
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "sub sub menu",
        "__class",
        "XContentTemplate",
        "Id",
        "idSubSubMenu",
        "IdNode",
        false,
        "Margins",
        box(0, 320, 0, 0),
        "UseClipBox",
        false
      }, {
        PlaceObj("XTemplateMode", {
          "comment",
          "empty",
          "mode",
          "empty"
        }),
        PlaceObj("XTemplateMode", {"mode", "items"}, {
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(-20, 0, 0, 0),
            "Padding",
            box(0, 3, 0, 0),
            "VAlign",
            "top",
            "MinHeight",
            587,
            "MaxHeight",
            587
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XPopup",
              "Id",
              "idItemsContent",
              "Dock",
              false,
              "MinWidth",
              315,
              "MaxWidth",
              315,
              "BorderColor",
              RGBA(128, 128, 128, 0),
              "Background",
              RGBA(240, 240, 240, 0),
              "FocusedBorderColor",
              RGBA(128, 128, 128, 0),
              "FocusedBackground",
              RGBA(240, 240, 240, 0),
              "DisabledBorderColor",
              RGBA(0, 0, 0, 0),
              "AnchorType",
              "top-right"
            }, {
              PlaceObj("XTemplateWindow", {
                "__context",
                function(parent, context)
                  return GetDialogModeParam(parent).prop_meta.items
                end,
                "__class",
                "SnappingScrollArea",
                "Id",
                "idItemsScrollArea",
                "Margins",
                box(0, -5, 0, 0),
                "Dock",
                "left",
                "MinWidth",
                300,
                "MaxWidth",
                300,
                "VScroll",
                "idItemsScroll",
                "GamepadInitialSelection",
                true,
                "KeepSelectionOnRespawn",
                true
              }, {
                PlaceObj("XTemplateForEach", {
                  "comment",
                  "properties",
                  "condition",
                  function(parent, context, item, i)
                    local ns = item.not_selectable
                    if type(ns) == "function" then
                      ns = ns()
                    end
                    return not ns
                  end,
                  "__context",
                  function(parent, context, item, i, n)
                    return item
                  end,
                  "run_after",
                  function(child, context, item, i, n, last)
                    local currentUsedValue = GetDialogModeParam(child.parent) and GetDialogModeParam(child.parent).value
                    if currentUsedValue and currentUsedValue == context.value then
                      child.idBtnText:SetEnabled(false)
                    end
                    child.idBtnText:SetText(item.text)
                  end
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "__template",
                    "SubSubMenuButton",
                    "IdNode",
                    false,
                    "OnPress",
                    function(self, gamepad)
                      local prop_meta = GetDialogModeParam(self).prop_meta
                      if _InternalTranslate(GetDialogModeParam(self):ResolveId("idValue").Text) ~= _InternalTranslate(self.context.text) then
                        Msg("OptionsChanged")
                      end
                      local obj = ResolvePropObj(GetDialogModeParam(self).context)
                      SetProperty(obj, prop_meta.id, self.context.value)
                      local dialog = GetDialog(self):ResolveId("idSubMenu"):ResolveId("idScrollArea")
                      dialog:OnContextUpdate(OptionsObj)
                      if not GetUIStyleGamepad() then
                        GetDialog(self):SetMode("empty")
                      end
                    end,
                    "RolloverBackground",
                    RGBA(255, 255, 255, 0)
                  })
                })
              }),
              PlaceObj("XTemplateAction", {
                "ActionId",
                "idBack",
                "ActionGamepad",
                "ButtonB",
                "OnAction",
                function(self, host, source, ...)
                  if GetUIStyleGamepad() then
                    host:ResolveId("idItemsContent"):Close()
                    CloseOptionsChoiceSubmenu(host)
                  end
                end,
                "FXPress",
                "MainMenuButtonClick"
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XZuluScroll",
                "Id",
                "idItemsScroll",
                "Dock",
                "right",
                "HAlign",
                "right",
                "MouseCursor",
                "UI/Cursors/Hand.tga",
                "Target",
                "idItemsScrollArea",
                "SnapToItems",
                true,
                "AutoHide",
                true
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "Open(self, ...)",
                "func",
                function(self, ...)
                  XWindow.Open(self, ...)
                  self:SetAnchor(GetDialogModeParam(self).box)
                  GetDialogModeParam(self).isExpanded = true
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "GetSafeAreaBox(self)",
                "func",
                function(self)
                  return self.parent.box:xyxy()
                end
              })
            })
          })
        }),
        PlaceObj("XTemplateMode", {"mode", "save"}, {
          PlaceObj("XTemplateWindow", {
            "Id",
            "idSaveContent",
            "VAlign",
            "top",
            "MinWidth",
            550,
            "MaxWidth",
            550,
            "MaxHeight",
            610,
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "blur effect",
              "__condition",
              function(parent, context)
                return not GetDialog("PDADialog") and not g_SatelliteUI
              end,
              "__class",
              "XBlurRect",
              "Margins",
              box(0, 5, 0, 5),
              "Dock",
              "box",
              "BlurRadius",
              10,
              "Mask",
              "UI/Common/mm_panel",
              "FrameLeft",
              10,
              "FrameTop",
              10,
              "FrameRight",
              10,
              "FrameBottom",
              10
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XFrame",
              "Id",
              "idEffect",
              "Margins",
              box(5, 5, 5, 5),
              "Dock",
              "box",
              "Transparency",
              179,
              "HandleKeyboard",
              false,
              "Image",
              "UI/Common/screen_effect",
              "ImageScale",
              point(100000, 1000),
              "TileFrame",
              true,
              "SqueezeX",
              false,
              "SqueezeY",
              false
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "background",
              "__class",
              "XFrame",
              "UIEffectModifierId",
              "MainMenuMainBar",
              "Dock",
              "box",
              "Transparency",
              64,
              "Image",
              "UI/Common/mm_panel",
              "FrameBox",
              box(10, 10, 10, 10),
              "SqueezeX",
              false,
              "SqueezeY",
              false
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "description of save",
              "Id",
              "idDescription",
              "Margins",
              box(5, 10, 5, 10),
              "Dock",
              "top",
              "LayoutMethod",
              "VList"
            }, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "img",
                "__class",
                "XImage",
                "Id",
                "idImage",
                "Margins",
                box(0, 10, 0, 0),
                "Dock",
                "top",
                "HAlign",
                "center",
                "VAlign",
                "top",
                "MinHeight",
                250,
                "MaxWidth",
                450,
                "MaxHeight",
                250,
                "ImageFit",
                "height"
              }),
              PlaceObj("XTemplateWindow", {
                "Margins",
                box(0, 10, 0, 0),
                "Dock",
                "bottom"
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XZuluScroll",
                  "Id",
                  "idInfoScroll",
                  "Dock",
                  "right",
                  "MouseCursor",
                  "UI/Cursors/Hand.tga",
                  "Target",
                  "idInfoTextArea",
                  "SnapToItems",
                  true,
                  "AutoHide",
                  true
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "all info on save",
                  "__class",
                  "XScrollArea",
                  "Id",
                  "idInfoTextArea",
                  "IdNode",
                  false,
                  "LayoutMethod",
                  "VList",
                  "VScroll",
                  "idInfoScroll"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "title",
                    "Id",
                    "idTitleStrip",
                    "Margins",
                    box(2, 0, 2, 0),
                    "LayoutMethod",
                    "HList",
                    "Background",
                    RGBA(88, 92, 68, 127)
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "Id",
                      "idMap",
                      "Margins",
                      box(10, 0, 0, 0),
                      "Padding",
                      box(8, 2, 8, 2),
                      "MaxWidth",
                      65,
                      "Background",
                      RGBA(61, 122, 153, 255),
                      "HandleMouse",
                      false,
                      "TextStyle",
                      "SaveMapTittle",
                      "Translate",
                      true,
                      "Text",
                      T(587853407731, "I5"),
                      "WordWrap",
                      false,
                      "TextVAlign",
                      "center"
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "Id",
                      "idTimestamp",
                      "Margins",
                      box(0, 0, 10, 0),
                      "Dock",
                      "right",
                      "HandleMouse",
                      false,
                      "TextStyle",
                      "PDABrowserNameSmall",
                      "Translate",
                      true,
                      "WordWrap",
                      false,
                      "TextVAlign",
                      "center"
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "Id",
                      "idSavegameTitle",
                      "Margins",
                      box(10, 0, 0, 0),
                      "MinWidth",
                      300,
                      "MaxWidth",
                      300,
                      "HandleMouse",
                      false,
                      "TextStyle",
                      "PDABrowserHeader",
                      "WordWrap",
                      false,
                      "Shorten",
                      true,
                      "TextVAlign",
                      "center"
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "save info below name strip",
                    "Padding",
                    box(10, 10, 10, 5),
                    "LayoutMethod",
                    "VList"
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "Id",
                      "idTime",
                      "LayoutMethod",
                      "HList"
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idPlaytimeTitle",
                        "Margins",
                        box(0, 0, 5, 0),
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "SaveMapEntryTitle",
                        "Translate",
                        true,
                        "Text",
                        T(113354682765, "PLAYTIME:"),
                        "WordWrap",
                        false
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idPlaytime",
                        "Margins",
                        box(0, 0, 5, 0),
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "SaveMapEntry",
                        "Translate",
                        true,
                        "WordWrap",
                        false
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idGameDateTitle",
                        "Margins",
                        box(0, 0, 5, 0),
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "SaveMapEntryTitle",
                        "Translate",
                        true,
                        "Text",
                        T(815959877651, "GAME DATE:"),
                        "WordWrap",
                        false
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idGameDate",
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "SaveMapEntry",
                        "Translate",
                        true,
                        "Text",
                        T(564250095513, "UNKNOWN"),
                        "WordWrap",
                        false
                      })
                    }),
                    PlaceObj("XTemplateWindow", {
                      "Id",
                      "idSaveMoney",
                      "LayoutMethod",
                      "HList"
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idMoneyTitle",
                        "Margins",
                        box(0, 0, 5, 0),
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "SaveMapEntryTitle",
                        "Translate",
                        true,
                        "Text",
                        T(773175166656, "MONEY:")
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idMoney",
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "SaveMapEntry",
                        "Translate",
                        true,
                        "Text",
                        T(565560544455, "Unknown"),
                        "WordWrap",
                        false,
                        "Shorten",
                        true
                      })
                    }),
                    PlaceObj("XTemplateWindow", {
                      "Id",
                      "idSaveSquads",
                      "LayoutMethod",
                      "HList"
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idSquadsTitle",
                        "Margins",
                        box(0, 0, 5, 0),
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "SaveMapEntryTitle",
                        "Translate",
                        true,
                        "Text",
                        T(755223918707, "SQUADS AND MERCS:")
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idSquads",
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "SaveMapEntry",
                        "Translate",
                        true,
                        "Text",
                        T(181797614292, "UNKNOWN"),
                        "WordWrap",
                        false,
                        "Shorten",
                        true
                      })
                    }),
                    PlaceObj("XTemplateWindow", {
                      "Id",
                      "idSaveQuest",
                      "LayoutMethod",
                      "HList"
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idQuestTitle",
                        "Margins",
                        box(0, 0, 5, 0),
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "SaveMapEntryTitle",
                        "Translate",
                        true,
                        "Text",
                        T(366928391875, "ACTIVE QUEST: ")
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idQuest",
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "SaveMapEntry",
                        "Translate",
                        true,
                        "Text",
                        T(350323597760, "UNKNOWN"),
                        "WordWrap",
                        false,
                        "Shorten",
                        true
                      })
                    }),
                    PlaceObj("XTemplateWindow", {"Id", "idSaveMods"}, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idActiveMods",
                        "MaxHeight",
                        50,
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "LoadSaveMods",
                        "Translate",
                        true,
                        "Text",
                        T(824384517944, "<style SaveMapEntryTitle>Installed mods: </style>   Unknown"),
                        "WordWrap",
                        false,
                        "Shorten",
                        true
                      })
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__context",
                      function(parent, context)
                        return "mercs_imgs"
                      end,
                      "__class",
                      "XContentTemplate",
                      "Id",
                      "idMercPortraits",
                      "Margins",
                      box(3, 5, 0, 5),
                      "LayoutMethod",
                      "HList"
                    }, {
                      PlaceObj("XTemplateForEach", {
                        "array",
                        function(parent, context)
                          local units = GetDialogModeParam(parent) and GetDialogModeParam(parent).metadata.all_units_sorted
                          local res = table.copy(units)
                          if res and #res < 6 then
                            for i = #res, 6 do
                              table.insert(res, "empty portrait")
                            end
                          end
                          return res
                        end,
                        "run_after",
                        function(child, context, item, i, n, last)
                          if i <= 6 then
                            if item ~= "empty portrait" then
                              child.idMercImg:SetImage(g_Classes[item] and g_Classes[item].Portrait)
                            else
                              child.idEmptyBackground:SetVisible(true)
                            end
                          else
                            child:Done()
                          end
                        end
                      }, {
                        PlaceObj("XTemplateWindow", {
                          "IdNode",
                          true,
                          "Margins",
                          box(0, 0, 13, 0),
                          "MinWidth",
                          74,
                          "MaxWidth",
                          74
                        }, {
                          PlaceObj("XTemplateWindow", {
                            "__class",
                            "XImage",
                            "Id",
                            "idMercBackground",
                            "Margins",
                            box(0, 15, 0, 0),
                            "Dock",
                            "box",
                            "Image",
                            "UI/PDA/MercPortrait/T_HUD_Merc_PortraitBackground",
                            "ImageFit",
                            "stretch"
                          }),
                          PlaceObj("XTemplateWindow", {
                            "__class",
                            "XImage",
                            "Id",
                            "idMercImg",
                            "Dock",
                            "box",
                            "MinWidth",
                            74,
                            "MaxWidth",
                            74,
                            "ImageFit",
                            "width",
                            "ImageRect",
                            box(50, 0, 250, 246)
                          }),
                          PlaceObj("XTemplateWindow", {
                            "Id",
                            "idEmptyBackground",
                            "Margins",
                            box(0, 15, 0, 0),
                            "Dock",
                            "box",
                            "Visible",
                            false,
                            "Background",
                            RGBA(32, 35, 47, 255)
                          })
                        })
                      })
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "Id",
                      "idProblem",
                      "Margins",
                      box(0, 0, 0, 5),
                      "HandleMouse",
                      false,
                      "TextStyle",
                      "PDACommonButtonRed",
                      "Translate",
                      true,
                      "HideOnEmpty",
                      true
                    })
                  })
                })
              })
            })
          })
        }),
        PlaceObj("XTemplateMode", {"mode", "mod"}, {
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return context
            end,
            "Id",
            "idModContent",
            "VAlign",
            "top",
            "MinWidth",
            550,
            "MaxWidth",
            550,
            "MaxHeight",
            610,
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "blur effect",
              "__condition",
              function(parent, context)
                return not GetDialog("PDADialog") and not g_SatelliteUI
              end,
              "__class",
              "XBlurRect",
              "Margins",
              box(0, 5, 0, 5),
              "Dock",
              "box",
              "BlurRadius",
              10,
              "Mask",
              "UI/Common/mm_panel",
              "FrameLeft",
              10,
              "FrameTop",
              10,
              "FrameRight",
              10,
              "FrameBottom",
              10
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XFrame",
              "Id",
              "idEffect",
              "Margins",
              box(5, 5, 5, 5),
              "Dock",
              "box",
              "Transparency",
              179,
              "HandleKeyboard",
              false,
              "Image",
              "UI/Common/screen_effect",
              "ImageScale",
              point(100000, 1000),
              "TileFrame",
              true,
              "SqueezeX",
              false,
              "SqueezeY",
              false
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "background",
              "__class",
              "XFrame",
              "UIEffectModifierId",
              "MainMenuMainBar",
              "Dock",
              "box",
              "Transparency",
              64,
              "Image",
              "UI/Common/mm_panel",
              "FrameBox",
              box(10, 10, 10, 10),
              "SqueezeX",
              false,
              "SqueezeY",
              false
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "description of save",
              "Id",
              "idDescription",
              "Margins",
              box(5, 10, 5, 10),
              "Dock",
              "top",
              "LayoutMethod",
              "VList"
            }, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "img",
                "__class",
                "XImage",
                "Id",
                "idImage",
                "Margins",
                box(0, 10, 0, 0),
                "Dock",
                "top",
                "HAlign",
                "center",
                "VAlign",
                "top",
                "MinHeight",
                250,
                "MaxWidth",
                450,
                "MaxHeight",
                250,
                "OnLayoutComplete",
                function(self)
                end,
                "ImageFit",
                "height"
              }),
              PlaceObj("XTemplateWindow", {
                "Margins",
                box(0, 10, 0, 0),
                "Dock",
                "bottom"
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XZuluScroll",
                  "Id",
                  "idInfoScroll",
                  "Dock",
                  "right",
                  "MouseCursor",
                  "UI/Cursors/Hand.tga",
                  "Target",
                  "idInfoTextArea",
                  "SnapToItems",
                  true,
                  "AutoHide",
                  true
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "info of mod",
                  "__class",
                  "XScrollArea",
                  "Id",
                  "idInfoTextArea",
                  "IdNode",
                  false,
                  "LayoutMethod",
                  "VList",
                  "VScroll",
                  "idInfoScroll"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "title",
                    "Id",
                    "idTitleStrip",
                    "Margins",
                    box(2, 0, 2, 0),
                    "LayoutMethod",
                    "HList",
                    "Background",
                    RGBA(88, 92, 68, 127)
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XImage",
                      "Id",
                      "idEnabled",
                      "Margins",
                      box(10, 0, 0, 0),
                      "Padding",
                      box(2, 2, 2, 2),
                      "HAlign",
                      "center",
                      "MaxHeight",
                      30,
                      "OnLayoutComplete",
                      function(self)
                      end,
                      "Visible",
                      false,
                      "FoldWhenHidden",
                      true,
                      "Background",
                      RGBA(124, 130, 96, 255),
                      "Image",
                      "UI/Hud/check",
                      "ImageFit",
                      "smallest"
                    }),
                    PlaceObj("XTemplateWindow", {
                      "comment",
                      "rating",
                      "__condition",
                      function(parent, context)
                        return false
                      end,
                      "Margins",
                      box(0, 0, 10, 0),
                      "Dock",
                      "right"
                    }, {
                      PlaceObj("XTemplateForEach", {
                        "array",
                        function(parent, context)
                          local modContext = GetDialogModeParam(parent)
                          local res = {}
                          for i = 1, 5 do
                            res[i] = i <= modContext.Rating
                          end
                          return res
                        end,
                        "map",
                        function(parent, context, array, i)
                          return array and array[i]
                        end,
                        "run_after",
                        function(child, context, item, i, n, last)
                          child:SetImage(item and "UI/Hud/mod_bullet_1" or "UI/Hud/mod_bullet_2")
                        end
                      }, {
                        PlaceObj("XTemplateWindow", {
                          "__class",
                          "XImage",
                          "Margins",
                          box(0, 0, 3, 0),
                          "Dock",
                          "right",
                          "Image",
                          "UI/Hud/mod_bullet_1"
                        })
                      })
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "Id",
                      "idModTitle",
                      "Margins",
                      box(10, 0, 0, 0),
                      "MinWidth",
                      300,
                      "MaxWidth",
                      300,
                      "HandleMouse",
                      false,
                      "TextStyle",
                      "PDABrowserNameSmall",
                      "WordWrap",
                      false,
                      "Shorten",
                      true,
                      "TextVAlign",
                      "center"
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "mod info below title strip",
                    "Padding",
                    box(10, 10, 10, 5),
                    "LayoutMethod",
                    "VList"
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "Id",
                      "idAthorAndVersion",
                      "LayoutMethod",
                      "HList"
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idAuthor",
                        "Margins",
                        box(0, 0, 5, 0),
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "SaveMapEntryTitle",
                        "Translate",
                        true,
                        "Text",
                        T(231046682472, "Author:"),
                        "WordWrap",
                        false
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idAuthorName",
                        "Margins",
                        box(0, 0, 5, 0),
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "SaveMapEntry",
                        "WordWrap",
                        false
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idVersion",
                        "Dock",
                        "right",
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "SaveMapEntry",
                        "WordWrap",
                        false
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idVersionTitle",
                        "Margins",
                        box(0, 0, 5, 0),
                        "Dock",
                        "right",
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "SaveMapEntryTitle",
                        "Translate",
                        true,
                        "Text",
                        T(739710928962, "Version:"),
                        "WordWrap",
                        false
                      })
                    }),
                    PlaceObj("XTemplateWindow", {
                      "Id",
                      "idDescr",
                      "LayoutMethod",
                      "HList"
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idDescrText",
                        "MaxHeight",
                        150,
                        "OnLayoutComplete",
                        function(self)
                        end,
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "ModDescription",
                        "Shorten",
                        true
                      })
                    }),
                    PlaceObj("XTemplateWindow", {
                      "Id",
                      "idRequiredMods",
                      "Margins",
                      box(0, 10, 0, 0),
                      "LayoutMethod",
                      "HList"
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idRequiredModsTitle",
                        "Margins",
                        box(0, 0, 5, 0),
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "SaveMapEntryTitle",
                        "Translate",
                        true,
                        "Text",
                        T(895340304808, "Required Mods:")
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idListMods",
                        "HandleMouse",
                        false,
                        "TextStyle",
                        "SaveMapEntry",
                        "WordWrap",
                        false,
                        "Shorten",
                        true
                      })
                    })
                  })
                })
              })
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "Open",
              "func",
              function(self, ...)
                ShowModInfo(GetDialog(self))
                XWindow.Open(self)
              end
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "version",
      "__context",
      function(parent, context)
        return {
          ver = BuildVersion or LuaRevision,
          build = rawget(_G, "BuildName")
        }
      end,
      "__class",
      "XText",
      "Dock",
      "box",
      "HAlign",
      "right",
      "VAlign",
      "bottom",
      "HandleKeyboard",
      false,
      "HandleMouse",
      false,
      "TextStyle",
      "MainMenuVersion",
      "Translate",
      true,
      "Text",
      T(203986632743, "Version <u(ver)><opt(build, ' - ', '')>")
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XWindow.Open(self)
        local CheckAnalyticsOption = function()
          local analyticsEnabled = GetAccountStorageOptionValue("AnalyticsEnabled") == "On"
          if AccountStorage and AccountStorage.DontShowAnalyticsMsg or analyticsEnabled then
            return
          end
          local privacyTUrl = T(377448813424, "privacy.thqnordic.com/en")
          local urlFunc = function()
            return OpenUrl("https://" .. _InternalTranslate(privacyTUrl), "force-browser")
          end
          local resp = WaitQuestion(terminal.desktop, T(157718084479, "Analytics"), T({
            507045106078,
            [[
We would love to have your help in improving the game by contributing usage data. This only includes information on how you play the game, and does not involve any personal identification data or unique device information. Contributing usage data is optional, and you can opt-out at any time in the game's Options menu.

Please review our privacy policy:
<style PDAIMPHyperLink><hyperlink obj 76 62 255 underline><urlT></hyperlink></style>

Contribute usage data?]],
            urlT = privacyTUrl
          }), T(1138, "Yes"), T(920129565424, "No"), urlFunc)
          if resp == "ok" and not NetIsConnected() then
            local err = MultiplayerConnect()
            if err then
            end
          end
          OptionsObj = OptionsObj or OptionsCreateAndLoad()
          OptionsObj.AnalyticsEnabled = resp == "ok" and "On" or "Off"
          OptionsObject.WaitApplyOptions(OptionsObj)
          if not AccountStorage or not AccountStorage.DontShowAnalyticsMsg then
            AccountStorage = AccountStorage or {}
            AccountStorage.DontShowAnalyticsMsg = true
          end
          SaveAccountStorage(2000)
          OptionsObj = false
        end
        if GetDialog("PreGameMenu") and GetDialog("PreGameMenu").Mode == "" then
          g_LatestSave = false
          self:CreateThread("PreGameMenu", function()
            GetLatestSave()
            CheckAnalyticsOption()
          end)
        end
      end
    })
  })
})
