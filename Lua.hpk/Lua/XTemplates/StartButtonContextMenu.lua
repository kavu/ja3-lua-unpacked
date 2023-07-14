PlaceObj("XTemplate", {
  group = "Zulu ContextMenu",
  id = "StartButtonContextMenu",
  PlaceObj("XTemplateWindow", {
    "__class",
    "ZuluContextMenu",
    "Id",
    "idStartMenu",
    "Margins",
    box(0, 0, 0, 5),
    "HAlign",
    "left",
    "VAlign",
    "top",
    "LayoutMethod",
    "Box",
    "AnchorType",
    "top"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextWindow",
      "Id",
      "idContent",
      "VAlign",
      "top",
      "LayoutMethod",
      "VList",
      "UseClipBox",
      false
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "actions",
        "__class",
        "XContextWindow",
        "Padding",
        box(0, 10, 0, 10),
        "LayoutMethod",
        "VList",
        "UseClipBox",
        false,
        "Background",
        RGBA(255, 255, 255, 0),
        "BackgroundRectGlowColor",
        RGBA(0, 0, 0, 0)
      }, {
        PlaceObj("XTemplateWindow", {
          "__condition",
          function(parent, context)
            return IsKindOf(context, "IModeCommonUnitControl")
          end,
          "__class",
          "XContentTemplateList",
          "IdNode",
          false,
          "BorderWidth",
          0,
          "Padding",
          box(0, 10, 0, 10),
          "UseClipBox",
          false,
          "Background",
          RGBA(255, 255, 255, 0),
          "BackgroundRectGlowColor",
          RGBA(0, 0, 0, 0),
          "HandleMouse",
          false,
          "FocusedBackground",
          RGBA(255, 255, 255, 0),
          "WorkUnfocused",
          true
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "OnPressEffect",
            "action",
            "OnPressParam",
            "actionToggleSatellite",
            "Text",
            T(154855056952, "Sat View")
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "separator line",
            "__class",
            "XFrame",
            "Margins",
            box(18, 10, 18, 10),
            "Image",
            "UI/PDA/separate_line_vertical",
            "FrameBox",
            box(5, 0, 5, 0),
            "SqueezeY",
            false
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "IsSelectable()",
              "func",
              function()
                return false
              end
            })
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "OnPressEffect",
            "action",
            "OnPressParam",
            "actionOpenBrowser"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "StartMenuNotesButton"
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "separator line",
            "__class",
            "XFrame",
            "Margins",
            box(18, 5, 18, 6),
            "Image",
            "UI/PDA/separate_line_vertical",
            "FrameBox",
            box(5, 0, 5, 0),
            "SqueezeY",
            false
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "IsSelectable()",
              "func",
              function()
                return false
              end
            })
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "OnPressEffect",
            "action",
            "OnPressParam",
            "idSquadManagement"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "OnPressEffect",
            "action",
            "OnPressParam",
            "actionOpenCharacter"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "OnPressEffect",
            "action",
            "OnPressParam",
            "idInventory"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "OnPressEffect",
            "action",
            "OnPressParam",
            "OpenHelp",
            "Text",
            T(587856262711, "Help Center")
          }, {
            PlaceObj("XTemplateTemplate", {
              "__template",
              "PDAQuestUnreadIndicator",
              "ZOrder",
              -1,
              "Margins",
              box(-9, -4, 0, 0),
              "Visible",
              true,
              "FoldWhenHidden",
              true
            }),
            PlaceObj("XTemplateCode", {
              "run",
              function(self, parent, context)
                local unreadTutorials = UnreadTutorials()
                parent.idUnread:SetVisible(unreadTutorials)
                local pda = GetDialog("PDADialog")
                parent:SetMouseCursor(gv_SatelliteView and pda and pda.visible and "UI/Cursors/Pda_Hand.tga" or "UI/Cursors/Hand.tga")
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnSetRollover(self, rollover)",
              "func",
              function(self, rollover)
                self:base_OnSetRollover(rollover)
                self.idUnread[1]:SetRollover(rollover)
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "separator line",
            "__class",
            "XFrame",
            "Margins",
            box(18, 5, 18, 6),
            "Image",
            "UI/PDA/separate_line_vertical",
            "FrameBox",
            box(5, 0, 5, 0),
            "SqueezeY",
            false
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "IsSelectable()",
              "func",
              function()
                return false
              end
            })
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "OnPressEffect",
            "action",
            "OnPressParam",
            "actionInGameMainMenu",
            "Text",
            T(186976597220, "Menu")
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "RespawnContent(self)",
            "func",
            function(self)
              XContentTemplateList.RespawnContent(self)
              self.parent:ApplyButtonData()
            end
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__condition",
          function(parent, context)
            return IsKindOf(context, "XSatelliteDialog")
          end,
          "__class",
          "XContentTemplateList",
          "IdNode",
          false,
          "BorderWidth",
          0,
          "Padding",
          box(0, 10, 0, 10),
          "UseClipBox",
          false,
          "Background",
          RGBA(255, 255, 255, 0),
          "BackgroundRectGlowColor",
          RGBA(0, 0, 0, 0),
          "HandleMouse",
          false,
          "FocusedBackground",
          RGBA(255, 255, 255, 0),
          "WorkUnfocused",
          true
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "MouseCursor",
            "UI/Cursors/Pda_Hand.tga",
            "OnPressEffect",
            "action",
            "OnPressParam",
            "actionToggleSatellite"
          }, {
            PlaceObj("XTemplateCode", {
              "run",
              function(self, parent, context)
                parent.Text = gv_SatelliteView and T(119774168141, "Tactical View") or T(469353766968, "Sat View")
                local enabledChange = SatelliteToggleActionState()
                parent:SetEnabled(enabledChange == "enabled")
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "separator line",
            "__class",
            "XFrame",
            "Margins",
            box(18, 10, 18, 10),
            "MouseCursor",
            "UI/Cursors/Pda_Cursor.tga",
            "Image",
            "UI/PDA/separate_line_vertical",
            "FrameBox",
            box(5, 0, 5, 0),
            "SqueezeY",
            false
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "IsSelectable()",
              "func",
              function()
                return false
              end
            })
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "MouseCursor",
            "UI/Cursors/Pda_Hand.tga",
            "OnPressEffect",
            "action",
            "OnPressParam",
            "actionOpenBrowser"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "StartMenuNotesButton"
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "separator line",
            "__class",
            "XFrame",
            "Margins",
            box(18, 5, 18, 6),
            "MouseCursor",
            "UI/Cursors/Pda_Cursor.tga",
            "Image",
            "UI/PDA/separate_line_vertical",
            "FrameBox",
            box(5, 0, 5, 0),
            "SqueezeY",
            false
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "IsSelectable()",
              "func",
              function()
                return false
              end
            })
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "MouseCursor",
            "UI/Cursors/Pda_Hand.tga",
            "OnPressEffect",
            "action",
            "OnPressParam",
            "idSquadManagement"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "MouseCursor",
            "UI/Cursors/Pda_Hand.tga",
            "OnPressEffect",
            "action",
            "OnPressParam",
            "actionOpenCharacter"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "MouseCursor",
            "UI/Cursors/Pda_Hand.tga",
            "OnPressEffect",
            "action",
            "OnPressParam",
            "idInventory"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "OnPressEffect",
            "action",
            "OnPressParam",
            "OpenHelp",
            "Text",
            T(587856262711, "Help Center")
          }, {
            PlaceObj("XTemplateTemplate", {
              "__template",
              "PDAQuestUnreadIndicator",
              "ZOrder",
              -1,
              "Margins",
              box(-9, -4, 0, 0),
              "Visible",
              true,
              "FoldWhenHidden",
              true
            }),
            PlaceObj("XTemplateCode", {
              "run",
              function(self, parent, context)
                local unreadTutorials = UnreadTutorials()
                parent.idUnread:SetVisible(unreadTutorials)
                local pda = GetDialog("PDADialog")
                parent:SetMouseCursor(gv_SatelliteView and pda and pda.visible and "UI/Cursors/Pda_Hand.tga" or "UI/Cursors/Hand.tga")
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnSetRollover(self, rollover)",
              "func",
              function(self, rollover)
                self:base_OnSetRollover(rollover)
                self.idUnread[1]:SetRollover(rollover)
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "separator line",
            "__class",
            "XFrame",
            "Margins",
            box(18, 5, 18, 6),
            "MouseCursor",
            "UI/Cursors/Pda_Cursor.tga",
            "Image",
            "UI/PDA/separate_line_vertical",
            "FrameBox",
            box(5, 0, 5, 0),
            "SqueezeY",
            false
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "IsSelectable()",
              "func",
              function()
                return false
              end
            })
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "MouseCursor",
            "UI/Cursors/Pda_Hand.tga",
            "OnPressEffect",
            "action",
            "OnPressParam",
            "actionInGameMainMenu",
            "Text",
            T(186976597220, "Menu")
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "RespawnContent(self)",
            "func",
            function(self)
              XContentTemplateList.RespawnContent(self)
              self.parent:ApplyButtonData()
            end
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__condition",
          function(parent, context)
            return IsKindOf(context, "PDAClass")
          end,
          "__class",
          "XContentTemplateList",
          "IdNode",
          false,
          "BorderWidth",
          0,
          "Padding",
          box(0, 10, 0, 10),
          "UseClipBox",
          false,
          "Background",
          RGBA(255, 255, 255, 0),
          "BackgroundRectGlowColor",
          RGBA(0, 0, 0, 0),
          "HandleMouse",
          false,
          "FocusedBackground",
          RGBA(255, 255, 255, 0),
          "WorkUnfocused",
          true
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "MouseCursor",
            "UI/Cursors/Pda_Hand.tga",
            "OnPressEffect",
            "action",
            "OnPressParam",
            "actionToggleSatellite"
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "separator line",
            "__class",
            "XFrame",
            "Margins",
            box(18, 10, 18, 10),
            "MouseCursor",
            "UI/Cursors/Pda_Cursor.tga",
            "Image",
            "UI/PDA/separate_line_vertical",
            "FrameBox",
            box(5, 0, 5, 0),
            "SqueezeY",
            false
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "IsSelectable()",
              "func",
              function()
                return false
              end
            })
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "MouseCursor",
            "UI/Cursors/Pda_Hand.tga",
            "OnPressEffect",
            "action",
            "OnPressParam",
            "actionOpenBrowser"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "StartMenuNotesButton"
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "separator line",
            "__class",
            "XFrame",
            "Margins",
            box(18, 5, 18, 6),
            "MouseCursor",
            "UI/Cursors/Pda_Cursor.tga",
            "Image",
            "UI/PDA/separate_line_vertical",
            "FrameBox",
            box(5, 0, 5, 0),
            "SqueezeY",
            false
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "IsSelectable()",
              "func",
              function()
                return false
              end
            })
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "MouseCursor",
            "UI/Cursors/Pda_Hand.tga",
            "OnPressEffect",
            "action",
            "OnPressParam",
            "idSquadManagement"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "MouseCursor",
            "UI/Cursors/Pda_Hand.tga",
            "OnPressEffect",
            "action",
            "OnPressParam",
            "actionOpenCharacter"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "MouseCursor",
            "UI/Cursors/Pda_Hand.tga",
            "OnPressEffect",
            "action",
            "OnPressParam",
            "idInventory"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "OnPressEffect",
            "action",
            "OnPressParam",
            "OpenHelp",
            "Text",
            T(587856262711, "Help Center")
          }, {
            PlaceObj("XTemplateTemplate", {
              "__template",
              "PDAQuestUnreadIndicator",
              "ZOrder",
              -1,
              "Margins",
              box(-9, -4, 0, 0),
              "Visible",
              true,
              "FoldWhenHidden",
              true
            }),
            PlaceObj("XTemplateCode", {
              "run",
              function(self, parent, context)
                local unreadTutorials = UnreadTutorials()
                parent.idUnread:SetVisible(unreadTutorials)
                local pda = GetDialog("PDADialog")
                parent:SetMouseCursor(gv_SatelliteView and pda and pda.visible and "UI/Cursors/Pda_Hand.tga" or "UI/Cursors/Hand.tga")
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnSetRollover(self, rollover)",
              "func",
              function(self, rollover)
                self:base_OnSetRollover(rollover)
                self.idUnread[1]:SetRollover(rollover)
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "separator line",
            "__class",
            "XFrame",
            "Margins",
            box(18, 5, 18, 6),
            "MouseCursor",
            "UI/Cursors/Pda_Cursor.tga",
            "Image",
            "UI/PDA/separate_line_vertical",
            "FrameBox",
            box(5, 0, 5, 0),
            "SqueezeY",
            false
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "IsSelectable()",
              "func",
              function()
                return false
              end
            })
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "MouseCursor",
            "UI/Cursors/Pda_Hand.tga",
            "OnPressEffect",
            "action",
            "OnPressParam",
            "PDACloseOrBackTab",
            "Text",
            T(333111343721, "Back")
          }, {
            PlaceObj("XTemplateCode", {
              "run",
              function(self, parent, context)
                parent.idBinding:SetText(T(607175380874, "[ESC] "))
              end
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "PDAGenericCloseAction"
            })
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "RespawnContent(self)",
            "func",
            function(self)
              XContentTemplateList.RespawnContent(self)
              self.parent:ApplyButtonData()
            end
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__condition",
          function(parent, context)
            return context == GetDialog("FullscreenGameDialogs")
          end,
          "__class",
          "XContentTemplateList",
          "IdNode",
          false,
          "BorderWidth",
          0,
          "Padding",
          box(0, 10, 0, 10),
          "UseClipBox",
          false,
          "Background",
          RGBA(255, 255, 255, 0),
          "BackgroundRectGlowColor",
          RGBA(0, 0, 0, 0),
          "HandleMouse",
          false,
          "FocusedBackground",
          RGBA(255, 255, 255, 0),
          "WorkUnfocused",
          true
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "OnPressEffect",
            "action",
            "OnPressParam",
            "actionToggleSatellite",
            "OnPress",
            function(self, gamepad)
              InvokeShortcutAction(self, "idCloseInventory", self.context)
              InvokeShortcutAction(self, "actionToggleSatellite")
            end
          }, {
            PlaceObj("XTemplateCode", {
              "run",
              function(self, parent, context)
                parent.Text = gv_SatelliteView and T(119774168141, "Tactical View") or T(469353766968, "Sat View")
                local enabledChange = SatelliteToggleActionState()
                parent:SetEnabled(enabledChange == "enabled")
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "separator line",
            "__class",
            "XFrame",
            "Margins",
            box(18, 10, 18, 10),
            "Image",
            "UI/PDA/separate_line_vertical",
            "FrameBox",
            box(5, 0, 5, 0),
            "SqueezeY",
            false
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "IsSelectable()",
              "func",
              function()
                return false
              end
            })
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "OnPressEffect",
            "action",
            "OnPressParam",
            "actionOpenBrowser"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "StartMenuNotesButton"
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "separator line",
            "__class",
            "XFrame",
            "Margins",
            box(18, 10, 18, 10),
            "Image",
            "UI/PDA/separate_line_vertical",
            "FrameBox",
            box(5, 0, 5, 0),
            "SqueezeY",
            false
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "IsSelectable()",
              "func",
              function()
                return false
              end
            })
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "Enabled",
            false,
            "OnPressEffect",
            "action",
            "OnPressParam",
            "idSquadManagement"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "OnPressEffect",
            "action",
            "OnPressParam",
            "actionOpenCharacter"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "OnPressEffect",
            "action",
            "OnPressParam",
            "ModifyWeapon"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "OnPressEffect",
            "action",
            "OnPressParam",
            "OpenHelp",
            "Text",
            T(587856262711, "Help Center")
          }, {
            PlaceObj("XTemplateTemplate", {
              "__template",
              "PDAQuestUnreadIndicator",
              "ZOrder",
              -1,
              "Margins",
              box(-9, -4, 0, 0),
              "Visible",
              true,
              "FoldWhenHidden",
              true
            }),
            PlaceObj("XTemplateCode", {
              "run",
              function(self, parent, context)
                local unreadTutorials = UnreadTutorials()
                parent.idUnread:SetVisible(unreadTutorials)
                local pda = GetDialog("PDADialog")
                parent:SetMouseCursor(gv_SatelliteView and pda and pda.visible and "UI/Cursors/Pda_Hand.tga" or "UI/Cursors/Hand.tga")
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnSetRollover(self, rollover)",
              "func",
              function(self, rollover)
                self:base_OnSetRollover(rollover)
                self.idUnread[1]:SetRollover(rollover)
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "separator line",
            "__class",
            "XFrame",
            "Margins",
            box(18, 5, 18, 6),
            "Image",
            "UI/PDA/separate_line_vertical",
            "FrameBox",
            box(5, 0, 5, 0),
            "SqueezeY",
            false
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "IsSelectable()",
              "func",
              function()
                return false
              end
            })
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ContextMenuButton",
            "MinHeight",
            28,
            "MaxHeight",
            28,
            "OnPressEffect",
            "action",
            "OnPressParam",
            "idCloseInventory",
            "Text",
            T(333111343721, "Back")
          }, {
            PlaceObj("XTemplateCode", {
              "run",
              function(self, parent, context)
                parent.idBinding:SetText(T(607175380874, "[ESC] "))
              end
            })
          }),
          PlaceObj("XTemplateAction", {
            "ActionId",
            "idCloseInventory",
            "OnAction",
            function(self, host, source, ...)
              local dlg = GetDialog("FullscreenGameDialogs")
              if dlg.Mode ~= "inventory" or not dlg:GetSubdialog():OnEscape() then
                SetEnabledMouseViaGamepad(false, "Inventory")
                dlg:Close()
              end
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "RespawnContent(self)",
            "func",
            function(self)
              XContentTemplateList.RespawnContent(self)
              self.parent:ApplyButtonData()
            end
          })
        }),
        PlaceObj("XTemplateFunc", {
          "comment",
          "link actions and buttons",
          "name",
          "ApplyButtonData(self)",
          "func",
          function(self)
            local popup = self:ResolveId("node")
            for i, b in ipairs(self[1]) do
              if IsKindOf(b, "XTextButton") and b.OnPressEffect == "action" then
                local actionId = b.OnPressParam
                local action = XShortcutsTarget:ActionById(actionId)
                if action then
                  local shortcut = GetShortcutButtonT(action)
                  if GetUIStyleGamepad() then
                    b.idBinding:SetText(Untranslated(" "))
                  else
                    b.idBinding:SetText(T({
                      818767796398,
                      "[<key>] ",
                      key = shortcut or ""
                    }))
                  end
                  if not b.Text or b.Text == "" then
                    b:SetText(action.ActionName)
                  end
                  local host = GetActionsHost(b, true)
                  local actionState = action:ActionState(host)
                  actionState = actionState or "enabled"
                  b:SetEnabled(actionState == "enabled")
                  b:SetId(action.ActionId)
                  function b:OnPress()
                    if not b.no_close and popup.window_state ~= "destroying" then
                      popup:Close()
                    end
                    host:OnAction(action, self)
                  end
                end
              end
            end
          end
        }),
        PlaceObj("XTemplateCode", {
          "run",
          function(self, parent, context)
            parent:ApplyButtonData()
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "title",
        "__class",
        "XContentTemplate",
        "Dock",
        "top",
        "MinHeight",
        40,
        "MaxHeight",
        40,
        "UseClipBox",
        false,
        "DrawOnTop",
        true,
        "Background",
        RGBA(52, 55, 61, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Margins",
          box(18, 0, 0, 0),
          "HAlign",
          "left",
          "VAlign",
          "center",
          "TextStyle",
          "SatelliteContextMenuDate",
          "Translate",
          true,
          "Text",
          T(954918167848, "<date()>")
        }),
        PlaceObj("XTemplateWindow", {
          "__condition",
          function(parent, context)
            return not gv_SatelliteView
          end,
          "HAlign",
          "right",
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          2
        }, {
          PlaceObj("XTemplateForEach", {
            "array",
            function(parent, context)
              return GetEnvironmentEffects()
            end,
            "__context",
            function(parent, context, item, i, n)
              return item
            end,
            "run_after",
            function(child, context, item, i, n, last)
              child:SetImage(context.Icon)
              child:SetRolloverText(context.description)
              child:SetRolloverTitle(context.display_name)
            end
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContextImage",
              "RolloverTemplate",
              "RolloverGeneric",
              "RolloverAnchor",
              "right",
              "RolloverAnchorId",
              "node",
              "RolloverOffset",
              box(20, 0, 0, 0),
              "Margins",
              box(0, 3, 8, 3),
              "HandleMouse",
              true,
              "ImageFit",
              "height"
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateGroup", nil, {
      PlaceObj("XTemplateAction", {
        "ActionId",
        "closeGamepad",
        "ActionGamepad",
        "Back",
        "OnActionEffect",
        "close",
        "OnAction",
        function(self, host, source, ...)
          local effect = self.OnActionEffect
          local param = self.OnActionParam
          if effect == "close" and host and host.window_state ~= "destroying" then
            host:Close(param ~= "" and param or nil, source, ...)
          elseif effect == "mode" and host then
            host:SetMode(param)
          elseif effect == "back" and host then
            SetBackDialogMode(host)
          else
            if effect == "popup" then
              local actions_view = GetParentOfKind(source, "XActionsView")
              if actions_view then
                actions_view:PopupAction(self.ActionId, host, source)
              else
                XShortcutsTarget:OpenPopupMenu(self.ActionId, terminal.GetMousePos())
              end
            else
            end
          end
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "closeGamepadPS",
        "ActionGamepad",
        "TouchpadClick",
        "OnActionEffect",
        "close",
        "OnAction",
        function(self, host, source, ...)
          local effect = self.OnActionEffect
          local param = self.OnActionParam
          if effect == "close" and host and host.window_state ~= "destroying" then
            host:Close(param ~= "" and param or nil, source, ...)
          elseif effect == "mode" and host then
            host:SetMode(param)
          elseif effect == "back" and host then
            SetBackDialogMode(host)
          else
            if effect == "popup" then
              local actions_view = GetParentOfKind(source, "XActionsView")
              if actions_view then
                actions_view:PopupAction(self.ActionId, host, source)
              else
                XShortcutsTarget:OpenPopupMenu(self.ActionId, terminal.GetMousePos())
              end
            else
            end
          end
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "closeGamepadB",
        "ActionGamepad",
        "ButtonB",
        "OnActionEffect",
        "close",
        "OnAction",
        function(self, host, source, ...)
          local effect = self.OnActionEffect
          local param = self.OnActionParam
          if effect == "close" and host and host.window_state ~= "destroying" then
            host:Close(param ~= "" and param or nil, source, ...)
          elseif effect == "mode" and host then
            host:SetMode(param)
          elseif effect == "back" and host then
            SetBackDialogMode(host)
          else
            if effect == "popup" then
              local actions_view = GetParentOfKind(source, "XActionsView")
              if actions_view then
                actions_view:PopupAction(self.ActionId, host, source)
              else
                XShortcutsTarget:OpenPopupMenu(self.ActionId, terminal.GetMousePos())
              end
            else
            end
          end
        end
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnCaptureLost(self)",
      "func",
      function(self)
        if self.window_state ~= "open" then
          return
        end
        self:Close()
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__condition",
      function(parent, context)
        return GetUIStyleGamepad()
      end,
      "__class",
      "XCameraLockLayer"
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        if self:MouseInWindow(pos) then
          return
        end
        if self.window_state ~= "open" then
          return
        end
        self:Close()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if shortcut == "Escape" then
          local ctx = self.idContent.context
          self:Close()
          if ctx ~= GetDialog("FullscreenGameDialogs") then
            InvokeShortcutAction(self, "actionInGameMainMenu")
          end
          return "break"
        end
        return ZuluContextMenu.OnShortcut(self, shortcut, source, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self)",
      "func",
      function(self)
        ZuluContextMenu.Open(self)
        self:SetFocus()
        PlayFX("CommandMenuOpen", "start")
        SetDisableMouseViaGamepad(true, "context-menu")
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Close(self)",
      "func",
      function(self)
        PlayFX("CommandMenuClose", "start")
        ZuluContextMenu.Close(self)
        SetDisableMouseViaGamepad(false, "context-menu")
      end
    })
  })
})
