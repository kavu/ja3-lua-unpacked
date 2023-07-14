PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDADialog_DemoUpsell",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDAClass",
    "ZOrder",
    3,
    "Background",
    RGBA(0, 0, 0, 255),
    "HandleMouse",
    true,
    "MouseCursor",
    "UI/Cursors/Pda_Cursor.tga",
    "InitialMode",
    "browser",
    "InternalModes",
    "browser, loading, quests"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        NetGossip("Open", "PDADialog", self.context and self.context.Mode or self.InitialMode, GetCurrentPlaytime())
        NetSyncEvent("SetPDAOpened", netUniqueId, true)
        XShortcutsSetMode("UI")
        PDAClass.Open(self, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete(self)",
      "func",
      function(self)
        NetGossip("Close", "PDADialog", self.Mode, GetCurrentPlaytime())
        NetSyncEvent("SetPDAOpened", netUniqueId, false)
        XShortcutsSetMode(gv_SatelliteView and "Satellite" or "Game")
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return false
      end,
      "__class",
      "XCameraLockLayer"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return false
      end,
      "__class",
      "XHideDialogs",
      "LeaveDialogIds",
      {"CombatLog"}
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return false
      end,
      "__class",
      "XMuteSounds",
      "AudioGroups",
      set("Ambience", "AmbientLife", "Default")
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "whole container",
      "Id",
      "idPDAContainer",
      "Padding",
      box(0, 10, 0, 10)
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "background",
        "__class",
        "PDAScreen",
        "Id",
        "idPDAScreen",
        "IdNode",
        false,
        "MouseCursor",
        "UI/Cursors/Pda_Cursor.tga",
        "Image",
        "UI/PDA/T_PDA_Frame",
        "FrameBox",
        box(100, 100, 100, 100),
        "SqueezeX",
        false,
        "SqueezeY",
        false
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "pda display",
          "Id",
          "idDisplay",
          "Margins",
          box(55, 55, 55, 55)
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "time/battery etc footer",
            "Dock",
            "top",
            "DrawOnTop",
            true
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XFrame",
              "Id",
              "idTimeBatteryBG",
              "Dock",
              "box",
              "Image",
              "UI/PDA/os_header",
              "FrameBox",
              box(3, 3, 3, 3)
            }),
            PlaceObj("XTemplateWindow", nil, {
              PlaceObj("XTemplateWindow", {
                "Margins",
                box(0, 0, 135, 0),
                "HAlign",
                "right",
                "LayoutMethod",
                "HList",
                "LayoutHSpacing",
                10
              }, {
                PlaceObj("XTemplateWindow", {
                  "__context",
                  function(parent, context)
                    return Game
                  end,
                  "__class",
                  "PDAMoneyText",
                  "RolloverTemplate",
                  "PDAMoneyRollover",
                  "RolloverText",
                  T(393266668423, "<placeholder>"),
                  "RolloverTitle",
                  T(320409032571, "<placeholder>"),
                  "Id",
                  "idMoney",
                  "HAlign",
                  "right",
                  "VAlign",
                  "center",
                  "Clip",
                  false,
                  "UseClipBox",
                  false,
                  "FXMouseIn",
                  "buttonRollover",
                  "TextStyle",
                  "TimeTextBold",
                  "Translate",
                  true
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XImage",
                  "Image",
                  "UI/PDA/separate_line",
                  "ImageScale",
                  point(1000, 800)
                }),
                PlaceObj("XTemplateWindow", {
                  "__context",
                  function(parent, context)
                    return "day_display"
                  end,
                  "__class",
                  "XText",
                  "Id",
                  "idTime",
                  "VAlign",
                  "center",
                  "TextStyle",
                  "TimeText",
                  "Translate",
                  true,
                  "Text",
                  T(817977384626, "<GameColorD><DateFormattedIncludingYear></GameColorD>"),
                  "UpdateTimeLimit",
                  150,
                  "TextVAlign",
                  "center"
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XImage",
                  "Id",
                  "idCalendarIcon",
                  "VAlign",
                  "center",
                  "FoldWhenHidden",
                  true,
                  "Image",
                  "UI/PDA/T_PDA_Calendar"
                })
              }),
              PlaceObj("XTemplateWindow", {
                "Margins",
                box(0, 0, 50, 0),
                "HAlign",
                "right",
                "VAlign",
                "center",
                "LayoutMethod",
                "HList",
                "LayoutHSpacing",
                10
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XImage",
                  "Image",
                  "UI/PDA/separate_line",
                  "ImageScale",
                  point(1000, 800)
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XImage",
                  "Id",
                  "idBatterySignal",
                  "HAlign",
                  "right",
                  "Image",
                  "UI/PDA/T_PDA_SignalBattery_2"
                })
              }),
              PlaceObj("XTemplateWindow", {
                "HAlign",
                "left",
                "VAlign",
                "center",
                "LayoutMethod",
                "HList",
                "LayoutHSpacing",
                10
              }, {
                PlaceObj("XTemplateWindow", {
                  "__context",
                  function(parent, context)
                    return Game
                  end,
                  "__class",
                  "XText",
                  "Margins",
                  box(30, 0, 0, 0),
                  "VAlign",
                  "center",
                  "TextStyle",
                  "TimeText",
                  "Translate",
                  true,
                  "Text",
                  T(718885585506, "<GameColorD>A.I.M. 3.0</GameColorD>"),
                  "TextVAlign",
                  "center"
                })
              })
            })
          }),
          PlaceObj("XTemplateWindow", {"Dock", "bottom"}),
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return false
            end,
            "__class",
            "XContentTemplate",
            "Id",
            "idApplicationContent",
            "IdNode",
            false,
            "Dock",
            "box"
          }, {
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(0, -1, 0, 0),
              "Dock",
              "top",
              "LayoutMethod",
              "VList"
            }, {
              PlaceObj("XTemplateWindow", {
                "Id",
                "idUrl",
                "LayoutMethod",
                "VList",
                "FoldWhenHidden",
                true
              }, {
                PlaceObj("XTemplateWindow", nil, {
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "url bar",
                    "__class",
                    "XFrame",
                    "IdNode",
                    false,
                    "Dock",
                    "box",
                    "Image",
                    "UI/PDA/browser_pad",
                    "FrameBox",
                    box(3, 3, 3, 3)
                  }),
                  PlaceObj("XTemplateWindow", {
                    "Margins",
                    box(50, 10, 180, 5)
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "HAlign",
                      "left",
                      "VAlign",
                      "center",
                      "TextStyle",
                      "URLLabel",
                      "Translate",
                      true,
                      "Text",
                      T(373464957332, "URL:")
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XButton",
                      "IdNode",
                      false,
                      "Margins",
                      box(60, 0, 0, 0),
                      "VAlign",
                      "center",
                      "MouseCursor",
                      "UI/Cursors/Pda_Hand.tga",
                      "OnPressEffect",
                      "action",
                      "OnPressParam",
                      "actionPurchase"
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "comment",
                        "url bar",
                        "__class",
                        "XFrame",
                        "IdNode",
                        false,
                        "Dock",
                        "box",
                        "Image",
                        "UI/PDA/browser_panel",
                        "FrameBox",
                        box(3, 3, 3, 3)
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__context",
                        function(parent, context)
                          return "pda_url"
                        end,
                        "__class",
                        "XText",
                        "Margins",
                        box(5, 0, 10, 0),
                        "TextStyle",
                        "URLText",
                        "Translate",
                        true,
                        "Text",
                        T(916354022659, "https://store.steampowered.com/app/1084160/Jagged_Alliance_3/")
                      })
                    })
                  })
                })
              })
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "actionPurchase",
              "ActionGamepad",
              "ButtonA",
              "OnAction",
              function(self, host, source, ...)
                OpenUrl("https://store.steampowered.com/app/1084160/Jagged_Alliance_3/", "force external browser")
                host:Close()
              end
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "actionClose",
              "ActionShortcut",
              "Escape",
              "ActionGamepad",
              "ButtonB",
              "OnActionEffect",
              "close"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Dock",
              "box",
              "Image",
              "UI/demo_splash",
              "ImageFit",
              "stretch"
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "upsell text",
              "Margins",
              box(64, 0, 0, 75),
              "HAlign",
              "left",
              "MinWidth",
              800
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "VAlign",
                "center",
                "MaxWidth",
                700,
                "TextStyle",
                "DemoUpsellBody",
                "Translate",
                true,
                "Text",
                T(558023243375, [[
<style DemoUpsellCaption1>THANKS FOR PLAYING!</style><newline>
<style DemoUpsellBody>You can carry your savegame over to the full game and continue your fight in Grand Chien!<newline><newline><newline></style>
<style DemoUpsellCaption2>THE FULL GAME ALLOWS YOU TO:<newline></style>
<style DemoUpsellBody><image UI/PDA/hm_circle 1400> Decide the fate of Grand Chien in an open RPG structure<newline>
<image UI/PDA/hm_circle 1400> Control territory, train the locals and command multiple parties<newline>
<image UI/PDA/hm_circle 1400> Defend against enemy forces in a living, active world<newline>
<image UI/PDA/hm_circle 1400> Experience the campaign with friends in online co-op mode]])
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "PDACommonButtonClass",
                "Padding",
                box(16, 12, 16, 12),
                "Dock",
                "bottom",
                "HAlign",
                "center",
                "MaxHeight",
                1000000,
                "LayoutMethod",
                "Box",
                "OnPressEffect",
                "action",
                "OnPressParam",
                "actionPurchase",
                "Image",
                "UI/PDA/os_system_buttons_yellow",
                "FrameBox",
                box(8, 8, 8, 8),
                "SqueezeX",
                false,
                "TextStyle",
                "DemoUpsellPurchaseButton",
                "Translate",
                true,
                "Text",
                T(553023643376, "PURCHASE FULL VERSION"),
                "ColumnsUse",
                "abcca"
              })
            }),
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(50, 0, 125, 75),
              "HAlign",
              "right",
              "MinWidth",
              800
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "PDACommonButtonClass",
                "Padding",
                box(4, 0, 4, 0),
                "Dock",
                "bottom",
                "HAlign",
                "right",
                "MaxHeight",
                1000000,
                "LayoutMethod",
                "Box",
                "OnPressEffect",
                "action",
                "OnPressParam",
                "actionClose",
                "Image",
                "UI/PDA/os_system_buttons",
                "FrameBox",
                box(8, 8, 8, 8),
                "TextStyle",
                "DemoUpsellExitButton",
                "Translate",
                true,
                "Text",
                T(558097153375, "EXIT"),
                "ColumnsUse",
                "abcca"
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "PDAPopupHost",
          "Id",
          "idDisplayPopupHost",
          "Margins",
          box(20, 40, 20, 22),
          "Dock",
          "box"
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "PDA Rollovers are spawned here",
          "Id",
          "idRolloverArea",
          "Margins",
          box(80, 65, 80, 70),
          "Dock",
          "box"
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "screen effect",
          "__class",
          "XFrame",
          "Margins",
          box(20, 40, 20, 22),
          "Dock",
          "box",
          "Transparency",
          100,
          "Image",
          "UI/PDA/T_PDA_OverlayPattern",
          "TileFrame",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "power button",
          "__class",
          "XImage",
          "IdNode",
          false,
          "Margins",
          box(0, 100, 18, 0),
          "HAlign",
          "right",
          "VAlign",
          "top",
          "DrawOnTop",
          true,
          "Image",
          "UI/PDA/T_PDA_Frame_Power_Button_Pad"
        }, {
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return "layerButton"
            end,
            "__class",
            "XTextButton",
            "RolloverTemplate",
            "RolloverGeneric",
            "Id",
            "idPowerButton",
            "IdNode",
            false,
            "Margins",
            box(0, 0, -2, 0),
            "HAlign",
            "right",
            "VAlign",
            "center",
            "MinWidth",
            40,
            "MinHeight",
            51,
            "MaxWidth",
            40,
            "MaxHeight",
            51,
            "MouseCursor",
            "UI/Cursors/Pda_Hand.tga",
            "OnContextUpdate",
            function(self, context, ...)
              self:SetHandleMouse(not g_ZuluMessagePopup)
              return XContextControl.OnContextUpdate(self, context)
            end,
            "DisabledBackground",
            RGBA(255, 255, 255, 200),
            "Image",
            "UI/PDA/T_PDA_Frame_Power_Button",
            "ColumnsUse",
            "abaca"
          })
        })
      })
    })
  })
})
