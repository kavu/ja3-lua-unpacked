PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu PDA",
  id = "PDANotes",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDANotesClass",
    "Id",
    "idContent",
    "Dock",
    "box",
    "HostInParent",
    true,
    "FocusOnOpen",
    ""
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        NetGossip("Open", "PDANotes", self.context and self.context.Mode or self.InitialMode, GetCurrentPlaytime())
        PDANotesClass.Open(self, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Close",
      "func",
      function(self, ...)
        NetGossip("Close", "PDANotes", self.Mode, GetCurrentPlaytime())
        PDANotesClass.Close(self, ...)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__condition",
      function(parent, context)
        return not netInGame and not gv_SatelliteView
      end,
      "__class",
      "PDACampaignPausingDlg"
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "bkg frame",
      "Background",
      RGBA(76, 130, 127, 255)
    }),
    PlaceObj("XTemplateWindow", {
      "Margins",
      box(55, 18, 0, 0),
      "HAlign",
      "left",
      "VAlign",
      "top",
      "LayoutMethod",
      "VList",
      "LayoutVSpacing",
      20
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Image",
        "UI/PDA/Quest/flavor_icon_01"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Image",
        "UI/PDA/Quest/flavor_icon_02"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Image",
        "UI/PDA/Quest/flavor_icon_03"
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "content frame",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      1470,
      "MinHeight",
      880,
      "MaxWidth",
      1470,
      "MaxHeight",
      880
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "IdNode",
        false,
        "Padding",
        box(0, 1, 0, 0),
        "Dock",
        "top",
        "MinHeight",
        33,
        "MaxHeight",
        33,
        "DrawOnTop",
        true,
        "Image",
        "UI/PDA/os_header",
        "FrameBox",
        box(5, 5, 5, 5),
        "SqueezeY",
        false
      }, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(10, 0, 0, 0),
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          10
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Margins",
            box(0, 2, 0, 5),
            "Image",
            "UI/PDA/Quest/aim_tracker_logo",
            "ImageFit",
            "height"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idHeaderText",
            "VAlign",
            "bottom",
            "TextStyle",
            "PDAQuests_HeaderBig",
            "Translate",
            true,
            "Text",
            T(283279957142, "A.I.M. <valign bottom -1><style PDAQuests_HeaderSmall>TRACKER</style>"),
            "TextVAlign",
            "bottom"
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Margins",
          box(0, 0, 25, 2),
          "HAlign",
          "right",
          "VAlign",
          "bottom",
          "TextStyle",
          "PDAQuests_HeaderVersion",
          "Text",
          "V2.0C",
          "TextVAlign",
          "bottom"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "Margins",
        box(0, -3, 0, 0),
        "Dock",
        "box",
        "Image",
        "UI/PDA/os_background",
        "FrameBox",
        box(5, 5, 5, 5)
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "window",
        "Margins",
        box(0, -3, 0, 0),
        "Dock",
        "box"
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "subheader",
          "Dock",
          "top",
          "VAlign",
          "top",
          "MinHeight",
          34
        }, {
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(20, 0, 0, 0),
            "HAlign",
            "left",
            "VAlign",
            "center",
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            20
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XTextButton",
              "Background",
              RGBA(0, 0, 0, 0),
              "MouseCursor",
              "UI/Cursors/Pda_Hand.tga",
              "FXMouseIn",
              "buttonRollover",
              "FXPress",
              "buttonPress",
              "FocusedBorderColor",
              RGBA(0, 0, 0, 0),
              "FocusedBackground",
              RGBA(0, 0, 0, 0),
              "DisabledBorderColor",
              RGBA(0, 0, 0, 0),
              "OnPress",
              function(self, gamepad)
                local popupHost = GetDialog("PDADialog")
                popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")
                if not popupHost then
                  return
                end
                local dd = XTemplateSpawn("PDAQuests_DropDownMenu", popupHost)
                local b = self.parent.parent.box
                dd:SetAnchor(b)
                dd:Open()
                self.desktop:SetModalWindow(dd)
              end,
              "RolloverBackground",
              RGBA(0, 0, 0, 0),
              "PressedBackground",
              RGBA(0, 0, 0, 0),
              "TextStyle",
              "PDAQuests_MenuItem",
              "Translate",
              true,
              "Text",
              T(237294065940, "File")
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XTextButton",
              "Background",
              RGBA(0, 0, 0, 0),
              "MouseCursor",
              "UI/Cursors/Pda_Hand.tga",
              "FXMouseIn",
              "buttonRollover",
              "FXPress",
              "buttonPress",
              "FocusedBorderColor",
              RGBA(0, 0, 0, 0),
              "FocusedBackground",
              RGBA(0, 0, 0, 0),
              "DisabledBorderColor",
              RGBA(0, 0, 0, 0),
              "RolloverBackground",
              RGBA(0, 0, 0, 0),
              "PressedBackground",
              RGBA(0, 0, 0, 0),
              "TextStyle",
              "PDAQuests_MenuItem",
              "Translate",
              true,
              "Text",
              T(924049884138, "View")
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XTextButton",
              "Id",
              "idAbout",
              "Background",
              RGBA(0, 0, 0, 0),
              "MouseCursor",
              "UI/Cursors/Pda_Hand.tga",
              "FXMouseIn",
              "buttonRollover",
              "FXPress",
              "buttonPress",
              "FocusedBorderColor",
              RGBA(0, 0, 0, 0),
              "FocusedBackground",
              RGBA(0, 0, 0, 0),
              "DisabledBorderColor",
              RGBA(0, 0, 0, 0),
              "OnPress",
              function(self, gamepad)
                local popupHost = GetDialog("PDADialog")
                popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")
                if not popupHost then
                  return
                end
                local aboutM = XTemplateSpawn("PDAQuests_AboutMenu", popupHost)
                aboutM:Open()
              end,
              "RolloverBackground",
              RGBA(0, 0, 0, 0),
              "PressedBackground",
              RGBA(0, 0, 0, 0),
              "TextStyle",
              "PDAQuests_MenuItem",
              "Translate",
              true,
              "Text",
              T(164209181738, "About")
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "secured tracking",
            "Margins",
            box(0, 0, 25, 0),
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
              "XText",
              "VAlign",
              "center",
              "Transparency",
              125,
              "HandleMouse",
              false,
              "TextStyle",
              "PDAQuests_MenuItem",
              "Translate",
              true,
              "Text",
              T(672138345598, "Secured Tracking")
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/PDA/Quest/secured"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "vertical sep",
            "__class",
            "XFrame",
            "Image",
            "UI/PDA/separate_line_vertical",
            "FrameBox",
            box(3, 3, 3, 3),
            "SqueezeY",
            false
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "footer",
          "Dock",
          "bottom",
          "MinHeight",
          60
        }, {
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(20, 0, 0, 0),
            "VAlign",
            "center"
          }, {
            PlaceObj("XTemplateTemplate", {
              "__template",
              "PDAStartButton",
              "Margins",
              box(0, 0, 0, 15)
            }),
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(20, 10, 0, 0),
              "HAlign",
              "left",
              "VAlign",
              "top",
              "MinWidth",
              390
            }, {
              PlaceObj("XTemplateWindow", {
                "HAlign",
                "right",
                "OnLayoutComplete",
                function(self)
                  local node = self:ResolveId("node")
                  local startButton = node.idStartButton
                  for i, icon in ipairs(self) do
                    local intersects = BoxIntersectsBox(icon.box, startButton.box)
                    icon:SetVisible(not intersects)
                  end
                end,
                "LayoutMethod",
                "HList",
                "LayoutHSpacing",
                20
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XImage",
                  "Image",
                  "UI/PDA/Quest/flavor_icon_04"
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XImage",
                  "Image",
                  "UI/PDA/Quest/flavor_icon_05"
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XImage",
                  "Image",
                  "UI/PDA/Quest/flavor_icon_06"
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XImage",
                  "Image",
                  "UI/PDA/Quest/flavor_icon_07"
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XToolBarList",
              "Id",
              "idToolBar",
              "Margins",
              box(0, 0, 20, 0),
              "HAlign",
              "right",
              "VAlign",
              "center",
              "OnLayoutComplete",
              function(self)
                self.list:SetPadding(box(0, 0, 0, 0))
              end,
              "LayoutHSpacing",
              18,
              "Background",
              RGBA(255, 255, 255, 0),
              "Toolbar",
              "ActionBar",
              "Show",
              "text",
              "ButtonTemplate",
              "PDACommonButton"
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(20, 0, 20, 0),
          "Dock",
          "box"
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "tab bar",
            "Dock",
            "top",
            "MinHeight",
            80,
            "MaxHeight",
            80,
            "DrawOnTop",
            true
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "tab buttons",
              "__context",
              function(parent, context)
                return "quests_tab_changed"
              end,
              "__class",
              "XContextWindow",
              "Id",
              "idTabButtons",
              "Margins",
              box(0, 0, 0, -5),
              "Padding",
              box(0, 5, 0, 0),
              "LayoutMethod",
              "HList",
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                local subContentDlg = self:ResolveId("node").idSubContent
                local modes = subContentDlg:GetModes()
                local currentMode = subContentDlg.Mode
                local modeIdx = table.find(modes, currentMode)
                for i, but in ipairs(self) do
                  if but.SetSelected then
                    but:SetSelected(i == modeIdx, i, modeIdx)
                  end
                end
              end
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "PDAQuestsTabButton",
                "MouseCursor",
                "UI/Cursors/Pda_Hand.tga",
                "OnContextUpdate",
                function(self, context, ...)
                  self.idUnread:SetVisible(GetAnyQuestUnread())
                end,
                "Text",
                T(887669003209, "Notes"),
                "Image",
                "UI/PDA/Quest/tab_tasks"
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "PDAQuestUnreadIndicator",
                  "Margins",
                  box(0, 0, 45, 20),
                  "HAlign",
                  "center",
                  "MinWidth",
                  10,
                  "MaxWidth",
                  10,
                  "Visible",
                  true
                })
              }),
              PlaceObj("XTemplateTemplate", {
                "__context",
                function(parent, context)
                  return gv_ReceivedEmails
                end,
                "__template",
                "PDAQuestsTabButton",
                "MouseCursor",
                "UI/Cursors/Pda_Hand.tga",
                "OnContextUpdate",
                function(self, context, ...)
                  local unreadMails = GetUnreadEmails()
                  self.idUnread:SetVisible(unreadMails and 0 < #unreadMails)
                end,
                "Text",
                T(134810804001, "E-mail"),
                "Image",
                "UI/PDA/Quest/tab_email"
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "PDAQuestUnreadIndicator",
                  "Margins",
                  box(0, 0, 45, 20),
                  "HAlign",
                  "center",
                  "MinWidth",
                  10,
                  "MaxWidth",
                  10,
                  "Visible",
                  true
                })
              }),
              PlaceObj("XTemplateTemplate", {
                "__template",
                "PDAQuestsTabButton",
                "MouseCursor",
                "UI/Cursors/Pda_Hand.tga",
                "Text",
                T(552219169558, "History"),
                "Image",
                "UI/PDA/Quest/tab_history"
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "gamepad hint",
                "__context",
                function(parent, context)
                  return "GamepadUIStyleChanged"
                end,
                "__class",
                "XText",
                "Margins",
                box(10, 0, 0, 0),
                "VAlign",
                "center",
                "Clip",
                false,
                "UseClipBox",
                false,
                "TextStyle",
                "PDAQuests_TabLabel",
                "ContextUpdateOnOpen",
                true,
                "OnContextUpdate",
                function(self, context, ...)
                  self:SetVisible(GetUIStyleGamepad())
                  XText.OnContextUpdate(self, context, ...)
                end,
                "Translate",
                true,
                "Text",
                T(281386940388, "<LeftTrigger> <RightTrigger> - Change category")
              }),
              PlaceObj("XTemplateAction", {
                "ActionId",
                "idNextTabRight",
                "ActionGamepad",
                "RightTrigger",
                "OnAction",
                function(self, host, source, ...)
                  local dlg = host.idContent
                  local subContent = dlg.idSubContent
                  if not subContent then
                    return
                  end
                  local modes = subContent:GetModes()
                  local currentMode = subContent.Mode
                  local modeIdx = table.find(modes, currentMode)
                  modeIdx = modeIdx + 1
                  if modes[modeIdx] then
                    subContent:SetMode(modes[modeIdx])
                  else
                    subContent:SetMode(modes[1])
                  end
                end
              }),
              PlaceObj("XTemplateAction", {
                "ActionId",
                "idPrevTabLeft",
                "ActionGamepad",
                "LeftTrigger",
                "OnAction",
                function(self, host, source, ...)
                  local dlg = host.idContent
                  local subContent = dlg.idSubContent
                  if not subContent then
                    return
                  end
                  local modes = subContent:GetModes()
                  local currentMode = subContent.Mode
                  local modeIdx = table.find(modes, currentMode)
                  modeIdx = modeIdx - 1
                  if modes[modeIdx] then
                    subContent:SetMode(modes[modeIdx])
                  else
                    subContent:SetMode(modes[#modes])
                  end
                end
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "HAlign",
              "right",
              "VAlign",
              "center",
              "Image",
              "UI/PDA/Quest/aim_tracker_logo_2"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "window frame"
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
              "XDialog",
              "Id",
              "idSubContent",
              "HostInParent",
              true,
              "InitialMode",
              "tasks",
              "InternalModes",
              "tasks, email, history"
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "OnDialogModeChange(self, ...)",
                "func",
                function(self, ...)
                  XDialog.OnDialogModeChange(self, ...)
                  NetGossip("PDANotes", "Mode", self.Mode, GetCurrentPlaytime())
                  ObjModified("quests_tab_changed")
                end
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContentTemplate",
                "IdNode",
                false
              }, {
                PlaceObj("XTemplateMode", {"mode", "tasks"}, {
                  PlaceObj("XTemplateTemplate", {
                    "__template",
                    "PDAQuests_Tasks"
                  })
                }),
                PlaceObj("XTemplateMode", {"mode", "email"}, {
                  PlaceObj("XTemplateTemplate", {
                    "__template",
                    "PDAQuests_Email"
                  })
                }),
                PlaceObj("XTemplateMode", {"mode", "history"}, {
                  PlaceObj("XTemplateTemplate", {
                    "__template",
                    "PDAQuests_History"
                  })
                })
              })
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateTemplate", {
      "__template",
      "PDAGenericCloseAction"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "VirtualCursorManager",
      "Reason",
      "Notes"
    })
  })
})
