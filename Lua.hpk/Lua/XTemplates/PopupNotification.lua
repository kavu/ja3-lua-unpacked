PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "PopupNotification",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PopupNotificationBase",
    "ZOrder",
    100000,
    "Background",
    RGBA(30, 30, 35, 115)
  }, {
    PlaceObj("XTemplateWindow", {
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
    PlaceObj("XTemplateLayer", {
      "__condition",
      function(parent, context)
        return not netInGame
      end,
      "layer",
      "XPauseLayer"
    }),
    PlaceObj("XTemplateLayer", {
      "layer",
      "XCameraLockLayer"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionClose",
      "ActionName",
      T(970488995700, "Close"),
      "ActionToolbar",
      "ActionBarPopupNotification",
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "ButtonB",
      "ActionButtonTemplate",
      "PDACommonButton",
      "OnAction",
      function(self, host, source, ...)
        local templateHost = self.host
        templateHost:Close()
      end,
      "FXPress",
      "none"
    }),
    PlaceObj("XTemplateWindow", {
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      1070,
      "MinHeight",
      470,
      "MaxWidth",
      1070,
      "MaxHeight",
      470,
      "LayoutMethod",
      "VList",
      "LayoutVSpacing",
      -7
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "header",
        "Dock",
        "top",
        "MinHeight",
        24,
        "MaxHeight",
        24
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "Image",
          "UI/PDA/os_header",
          "FrameBox",
          box(5, 5, 5, 5),
          "SqueezeY",
          false
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "Margins",
          box(10, 0, 0, 0),
          "VAlign",
          "center",
          "HandleMouse",
          false,
          "TextStyle",
          "PDAQuests_HeaderSmall",
          "Translate",
          true,
          "Text",
          T(823567872501, "A.I.M. Help Center"),
          "TextVAlign",
          "center"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "content",
        "Dock",
        "box"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "IdNode",
          false,
          "Margins",
          box(0, -3, 0, 0),
          "Dock",
          "box",
          "Image",
          "UI/PDA/Event/T_Event_Background",
          "FrameBox",
          box(5, 5, 5, 5)
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(14, 24, 14, 0)
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "inner content (image, text etc)"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XFrame",
              "Dock",
              "box",
              "Image",
              "UI/PDA/os_background",
              "FrameBox",
              box(5, 5, 5, 5)
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Id",
              "idNotificationImageBg",
              "IdNode",
              false,
              "Margins",
              box(0, 14, 14, 14),
              "Dock",
              "right",
              "HAlign",
              "left",
              "VAlign",
              "top",
              "MinWidth",
              260,
              "MaxWidth",
              260,
              "FoldWhenHidden",
              true,
              "Image",
              "UI/PDA/Event/T_Event_ImageBackground"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Id",
                "idNotificationImage",
                "Dock",
                "box",
                "ImageFit",
                "stretch"
              })
            }),
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(14, 0, 0, 14),
              "Dock",
              "box"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idPopupTitle",
                "Margins",
                box(0, 3, 0, 0),
                "Dock",
                "top",
                "HAlign",
                "left",
                "VAlign",
                "center",
                "MinHeight",
                36,
                "MaxHeight",
                36,
                "TextStyle",
                "PDAQuests_SectionHeader",
                "Translate",
                true,
                "Text",
                T(332696285596, "<title>"),
                "TextVAlign",
                "center"
              }),
              PlaceObj("XTemplateWindow", {
                "LayoutMethod",
                "HList"
              }, {
                PlaceObj("XTemplateWindow", {
                  "Id",
                  "idHintChoices",
                  "Margins",
                  box(0, 0, 15, 0),
                  "Dock",
                  "left",
                  "Visible",
                  false,
                  "FoldWhenHidden",
                  true
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "MessengerScrollbar",
                    "Id",
                    "idScrollbar",
                    "Dock",
                    "right",
                    "FoldWhenHidden",
                    false,
                    "Target",
                    "idHintScroll",
                    "SnapToItems",
                    true,
                    "AutoHide",
                    true,
                    "UnscaledWidth",
                    16
                  }),
                  PlaceObj("XTemplateWindow", {
                    "Dock",
                    "left",
                    "MinWidth",
                    290,
                    "MaxWidth",
                    290,
                    "FoldWhenHidden",
                    true
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XFrame",
                      "Dock",
                      "box",
                      "Image",
                      "UI/PDA/os_background_2",
                      "FrameBox",
                      box(5, 5, 5, 5)
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__context",
                      function(parent, context)
                        return TutorialGetHelpMenuHints()
                      end,
                      "__class",
                      "SnappingScrollArea",
                      "Id",
                      "idHintScroll",
                      "Padding",
                      box(2, 10, 2, 0),
                      "Dock",
                      "box",
                      "LayoutVSpacing",
                      1,
                      "VScroll",
                      "idScrollbar",
                      "ShowPartialItems",
                      true,
                      "SetFocusOnOpen",
                      true
                    }, {
                      PlaceObj("XTemplateForEach", {
                        "__context",
                        function(parent, context, item, i, n)
                          return item
                        end,
                        "run_after",
                        function(child, context, item, i, n, last)
                          child.idText:SetText(item.Title)
                        end
                      }, {
                        PlaceObj("XTemplateWindow", {
                          "__class",
                          "XTextButton",
                          "Margins",
                          box(10, 0, 10, 0),
                          "Padding",
                          box(10, 0, 5, 0),
                          "LayoutHSpacing",
                          0,
                          "Background",
                          RGBA(0, 0, 0, 0),
                          "FocusedBorderColor",
                          RGBA(0, 0, 0, 0),
                          "FocusedBackground",
                          RGBA(0, 0, 0, 0),
                          "DisabledBorderColor",
                          RGBA(0, 0, 0, 0),
                          "OnPress",
                          function(self, gamepad)
                            local popupDiag = GetDialog(self)
                            popupDiag:SetSelectedHint(self.context)
                          end,
                          "RolloverBackground",
                          RGBA(0, 0, 0, 0),
                          "PressedBackground",
                          RGBA(0, 0, 0, 0)
                        }, {
                          PlaceObj("XTemplateTemplate", {
                            "__template",
                            "PDAQuestUnreadIndicator",
                            "Margins",
                            box(-13, 0, 0, 0),
                            "MinWidth",
                            10,
                            "MaxWidth",
                            10,
                            "ScaleModifier",
                            point(800, 800),
                            "Visible",
                            true
                          }),
                          PlaceObj("XTemplateWindow", {
                            "__class",
                            "XText",
                            "Id",
                            "idText",
                            "VAlign",
                            "center",
                            "TextStyle",
                            "PDAQuestTitleCompleted",
                            "Translate",
                            true
                          }),
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "SetStyle(self, style)",
                            "func",
                            function(self, style)
                              local textStyle = "PDAQuests_Label"
                              local hintId = self.context.preset.id
                              local read = TutorialHintsState.read and TutorialHintsState.read[hintId]
                              if read then
                                textStyle = "PDAQuestTitleCompleted"
                              end
                              self.idUnread:SetVisible(not read)
                              local bgColor = RGBA(0, 0, 0, 0)
                              if style == "selected" then
                                textStyle = "PDAQuests_LabelInversed"
                                bgColor = GameColors.Yellow
                              end
                              self.idText:SetTextStyle(textStyle)
                              self:SetBackground(bgColor)
                              self:SetRolloverBackground(bgColor)
                            end
                          }),
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "SetSelected(self, selected)",
                            "func",
                            function(self, selected)
                              local dlg = GetDialog(self)
                              dlg:SetSelectedHint(self.context)
                            end
                          })
                        })
                      }),
                      PlaceObj("XTemplateAction", {
                        "ActionId",
                        "actionScrollText",
                        "ActionGamepad",
                        "RightThumbDown",
                        "ActionButtonTemplate",
                        "PDACommonButton",
                        "OnAction",
                        function(self, host, source, ...)
                          local target = host:ResolveId("idTextScroll")
                          if not target then
                            return
                          end
                          target:ScrollDown()
                        end,
                        "FXPress",
                        "none"
                      }),
                      PlaceObj("XTemplateAction", {
                        "ActionId",
                        "actionScrollText",
                        "ActionGamepad",
                        "RightThumbUp",
                        "ActionButtonTemplate",
                        "PDACommonButton",
                        "OnAction",
                        function(self, host, source, ...)
                          local target = host:ResolveId("idTextScroll")
                          if not target then
                            return
                          end
                          target:ScrollUp()
                        end,
                        "FXPress",
                        "none"
                      })
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XScrollArea",
                  "Id",
                  "idTextScroll",
                  "IdNode",
                  false,
                  "Dock",
                  "box",
                  "VScroll",
                  "idTextScrollBar"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idText",
                    "Margins",
                    box(0, -2, 0, 0),
                    "HandleMouse",
                    false,
                    "TextStyle",
                    "SatelliteEventText",
                    "Translate",
                    true,
                    "Text",
                    T(545358701817, "<text>")
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "MessengerScrollbar",
                    "Id",
                    "idTextScrollBar",
                    "Margins",
                    box(10, 0, 10, 0),
                    "Dock",
                    "right",
                    "FoldWhenHidden",
                    false,
                    "Target",
                    "idTextScroll",
                    "SnapToItems",
                    true,
                    "AutoHide",
                    true,
                    "UnscaledWidth",
                    16
                  })
                })
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "bottom bar",
            "Dock",
            "bottom",
            "HAlign",
            "right",
            "VAlign",
            "center",
            "MinHeight",
            46,
            "MaxHeight",
            46
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XToolBar",
              "VAlign",
              "center",
              "OnLayoutComplete",
              function(self)
                for _, button in ipairs(self) do
                  button:SetMouseCursor("UI/Cursors/Hand.tga")
                end
              end,
              "Background",
              RGBA(255, 255, 255, 0),
              "Toolbar",
              "ActionBarPopupNotification"
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "OnButtonCreated(self, button)"
              })
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetSelectedHint(self, hint)",
      "func",
      function(self, hint)
        local hintScroll = self.idHintScroll
        if not hint then
          hint = hintScroll.context[#hintScroll.context]
        elseif type(hint) == "string" then
          hint = table.find_value(hintScroll.context, "id", hint)
        end
        if not hint then
          self.idText:SetText()
          return
        end
        local selectedWnd = false
        for i, hintWnd in ipairs(hintScroll) do
          if hintWnd.SetStyle then
            local selected = hintWnd.context == hint
            if selected then
              selectedWnd = hintWnd
              if not next(hintScroll.selection) then
                hintScroll:SetSelection(i)
              end
            end
            hintWnd:SetStyle(selected and "selected" or "default")
          end
        end
        hintScroll:ScrollIntoView(selectedWnd)
        if not TutorialHintsState.read then
          TutorialHintsState.read = {}
        end
        TutorialHintsState.read[hint.preset.id] = true
        local popupPreset = hint.popupPreset
        if popupPreset then
          if #(popupPreset.Image or "") > 0 then
            self.idNotificationImage:SetImage(popupPreset.Image)
          else
            self.idNotificationImage:SetImage("UI/Messages/message_placeholder")
          end
          self.idText:SetText(GetUIStyleGamepad() and popupPreset.GamepadText or popupPreset.Text)
        end
      end
    })
  })
})
