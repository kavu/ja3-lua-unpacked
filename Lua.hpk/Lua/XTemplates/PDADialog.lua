PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDADialog",
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
                  T(196336798796, "<placeholder>"),
                  "RolloverTitle",
                  T(988235259400, "<placeholder>"),
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
                  T(603749034935, "<GameColorD><DateFormattedIncludingYear()></GameColorD>"),
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
                  T(623932582462, "<GameColorD>A.I.M. 3.0</GameColorD>"),
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
            PlaceObj("XTemplateMode", {"mode", "browser"}, {
              PlaceObj("XTemplateTemplate", {
                "__context",
                function(parent, context)
                  return false
                end,
                "__template",
                "PDABrowser"
              })
            }),
            PlaceObj("XTemplateMode", {"mode", "quests"}, {
              PlaceObj("XTemplateTemplate", {
                "__context",
                function(parent, context)
                  return false
                end,
                "__template",
                "PDANotes",
                "MouseCursor",
                "UI/Cursors/Pda_Cursor.tga"
              })
            }),
            PlaceObj("XTemplateMode", {"mode", "loading"}, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "loading",
                "Id",
                "idLoading",
                "Background",
                RGBA(76, 130, 127, 255),
                "FadeOutTime",
                200
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
          "static dog tag",
          "__class",
          "XImage",
          "Margins",
          box(0, 106, -72, 0),
          "HAlign",
          "right",
          "VAlign",
          "top",
          "DrawOnTop",
          true,
          "Image",
          "UI/PDA/T_PDA_Dogtag_Static"
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "dynamic dog tag",
          "__condition",
          function(parent, context)
            return false
          end,
          "__class",
          "XImage",
          "Margins",
          box(0, 186, -32, 0),
          "HAlign",
          "right",
          "VAlign",
          "top",
          "DrawOnTop",
          true,
          "Image",
          "UI/PDA/T_PDA_Dogtag_Swing"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XButton",
            "Dock",
            "box",
            "BorderColor",
            RGBA(0, 0, 0, 0),
            "Background",
            RGBA(0, 0, 0, 0),
            "MouseCursor",
            "UI/Cursors/Pda_Hand.tga",
            "FocusedBorderColor",
            RGBA(0, 0, 0, 0),
            "FocusedBackground",
            RGBA(0, 0, 0, 0),
            "DisabledBorderColor",
            RGBA(0, 0, 0, 0),
            "OnPress",
            function(self, gamepad)
              local tag = self.parent
              local b = tag.box
              local x, y = ScaleXY(self.scale, 45, 25)
              local anchor = point(b:minx() + x, b:miny() + y)
              tag:AddInterpolation({
                id = "size",
                type = const.intRotate,
                duration = 200,
                center = anchor,
                startAngle = 0,
                endAngle = -480,
                autoremove = true,
                flags = const.intfPingPong
              })
            end,
            "RolloverBackground",
            RGBA(0, 0, 0, 0),
            "PressedBackground",
            RGBA(0, 0, 0, 0)
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "dogtag chain",
          "__class",
          "XImage",
          "Margins",
          box(0, 20, -5, 0),
          "HAlign",
          "right",
          "VAlign",
          "top",
          "DrawOnTop",
          true,
          "Image",
          "UI/PDA/T_PDA_Dogtag_Chain"
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "pen (hidden)",
          "__class",
          "XImage",
          "Margins",
          box(0, 0, 0, -20),
          "HAlign",
          "left",
          "VAlign",
          "bottom",
          "Visible",
          false,
          "DrawOnTop",
          true,
          "Image",
          "UI/PDA/Y_PDA_PenToggle"
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
          "Visible",
          false,
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
            "OnPress",
            function(self, gamepad)
              if g_SatelliteUI then
                g_SatelliteUI:RemoveContextMenu()
              end
              if IsValidThread(LoadSectorThread) then
                return
              end
              UIEnterSector(false, "force")
            end,
            "Image",
            "UI/PDA/T_PDA_Frame_Power_Button",
            "ColumnsUse",
            "abaca"
          })
        })
      })
    }),
    PlaceObj("XTemplateAction", {
      "comment",
      "open ingame main menu",
      "ActionId",
      "IGMainMenu",
      "ActionMode",
      "Satellite",
      "ActionName",
      T(404690461260, "Ingame Main Menu"),
      "ActionShortcut",
      "Escape",
      "ActionMouseBindable",
      false,
      "OnAction",
      function(self, host, source, ...)
        OpenIngameMainMenu()
      end
    })
  })
})
