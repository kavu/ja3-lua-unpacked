PlaceObj("XTemplate", {
  __is_kind_of = "XSatelliteDialog",
  group = "Zulu Satellite UI",
  id = "PDASatellite",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return Game
    end,
    "__class",
    "XSatelliteDialog",
    "ZOrder",
    3,
    "Dock",
    "box",
    "MouseCursor",
    "UI/Cursors/Pda_Cursor.tga",
    "OnContextUpdate",
    function(self, context, ...)
      local pausedByTimeline = GetPauseUIReasonExists("Timeline")
      local pausedByAnythingOtherThanTimeline = IsCampaignPaused() and (not pausedByTimeline or table.count(CampaignPauseReasons) > 1)
      local speed_holder = self.idSpeedControls
      if pausedByAnythingOtherThanTimeline then
        speed_holder.idPause:SetVisible(false)
        speed_holder.idPlay:SetVisible(true)
      else
        speed_holder.idPause:SetVisible(true)
        speed_holder.idPlay:SetVisible(false)
      end
      speed_holder:SetTransparency(pausedByTimeline and 125 or 0)
      if Game.CampaignTime == Game.CampaignTimeStart then
        speed_holder.idPlay:StartBlinking()
        speed_holder.idPause:StartBlinking()
      else
        speed_holder.idPlay:StopBlinking(true)
        speed_holder.idPause:StopBlinking()
      end
      local _, sector = IsConflictMode()
      local inConflict = CampaignPauseReasons.SatelliteConflict
      local conflictDlg = GetDialog("SatelliteConflict")
      local conflictDlgOpen = conflictDlg and conflictDlg.window_state ~= "destroying"
      self.idConflictMode:SetVisible(inConflict)
      if inConflict then
        self.idConflictMode.idConflictText:SetRolloverText(GetConflictCustomDescr(sector))
      end
      local rolloverText = inConflict and T(716696128257, "Can't unpause at this time - an ongoing conflict requires your attention") or T(953037675369, "Start/Pause Sat View time. Upcoming events can be seen in the timeline to the right")
      speed_holder.idPlay:SetRolloverText(rolloverText)
      speed_holder.idPause:SetRolloverText(rolloverText)
      local pausedByNoMercs = CampaignPauseReasons.NoMercs
      self.idNoMercsText:SetVisible(pausedByNoMercs)
      if pausedByNoMercs then
        self.idConflictMode:SetVisible(false)
        speed_holder.idPlay:SetRolloverText(T(992707760847, "You have no current merc contracts. Hire someone from the A.I.M. browser in the command menu."))
      end
      local pausedByOther = not inConflict and not pausedByNoMercs and IsCampaignPausedByRemotePlayerOnly()
      self.idOtherPlayerText:SetVisible(pausedByOther)
      local normal_mode = not self.idConflictMode:GetVisible()
      self.idNormalMode:SetVisible(normal_mode)
      local paused = IsCampaignPaused()
      if normal_mode then
        self.idNormalMode.idPausedText:SetVisible(paused)
      end
      self.idPausedIcon:SetVisible(paused)
      self.idPausedFrame:SetVisible(paused)
      self.idPausedFrame:SetBackground(inConflict and GameColors.I or GameColors.J)
      local timeLine = g_SatTimelineUI
      if timeLine then
        timeLine.paused_color = paused and GetColorWithAlpha(inConflict and GameColors.I or GameColors.J, 55)
      end
      local shouldHavePauseThread = not not paused
      local hasPauseThread = not not self:GetThread("pause-blink")
      if shouldHavePauseThread ~= hasPauseThread then
        local node = self:ResolveId("node")
        if shouldHavePauseThread then
          local blinkOn = false
          self:CreateThread("pause-blink", function()
            while self.window_state ~= "destroying" do
              self.idNormalMode.idPausedText:SetTextStyle(blinkOn and "SatelliteMode_BlinkOn" or "SatelliteMode")
              self.idTime:SetText(blinkOn and T(103382034079, "<dayNightIcon()> <style TimelineLabel_BlinkOn><time()></style> <day_name()>, <DateFormatted()>") or T(442467444132, "<dayNightIcon()> <time()> <day_name()>, <DateFormatted()>"))
              node.idPDAScreen:SetImage(PDADiodeImages[blinkOn])
              Sleep(450)
              blinkOn = not blinkOn
            end
          end)
        else
          self:DeleteThread("pause-blink")
          self.idNormalMode.idPausedText:SetTextStyle("SatelliteMode")
          self.idTime:SetText(T(442467444132, "<dayNightIcon()> <time()> <day_name()>, <DateFormatted()>"))
          node.idPDAScreen:SetImage(PDADiodeImages[false])
        end
      end
    end
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "Id",
      "idPausedFrame",
      "Margins",
      box(19, 0, 23, 0),
      "Dock",
      "box",
      "FadeInTime",
      300,
      "FadeOutTime",
      300,
      "Image",
      "UI/PDA/pause_border",
      "FrameBox",
      box(9, 9, 9, 9)
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "cursor hint text",
      "Id",
      "idCursorHintText",
      "IdNode",
      true,
      "Margins",
      box(30, 30, 0, 0),
      "Dock",
      "ignore",
      "UseClipBox",
      false,
      "Visible",
      false,
      "DrawOnTop",
      true,
      "ChildrenHandleMouse",
      false
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "UpdateLayout(self, ...)",
        "func",
        function(self, ...)
          local margins_x1, margins_y1, margins_x2, margins_y2 = ScaleXY(self.scale, self.Margins:xyxy())
          self:SetBox(margins_x1, margins_y1, self.measure_width - margins_x1, self.measure_height - margins_y1)
          return XText.UpdateLayout(self, ...)
        end
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "DrawWindow(self, clip_box)",
        "func",
        function(self, clip_box)
          clip_box = g_SatelliteUI.box
          UIL.PushClipRect(clip_box, false)
          local modifiers = self.modifiers
          local prev_int = UIL.ModifiersGetTop()
          if modifiers then
            local i = 1
            while i <= #modifiers do
              local int = modifiers[i]
              if UIL.PushModifier(int) then
                i = i + 1
              else
                remove(modifiers, i)
                if #modifiers == 0 then
                  self.modifiers = nil
                end
              end
            end
          end
          self:DrawBackground()
          self:DrawContent(clip_box)
          self:DrawChildren(clip_box)
          UIL.ModifiersSetTop(prev_int)
          UIL.PopClipRect()
          self.invalidated = nil
        end
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "cursor hint text",
        "__class",
        "XText",
        "Id",
        "idText",
        "HAlign",
        "left",
        "VAlign",
        "top",
        "Clip",
        false,
        "UseClipBox",
        false,
        "HandleMouse",
        false,
        "ChildrenHandleMouse",
        false,
        "TextStyle",
        "PDACursorHint",
        "Translate",
        true
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XSatelliteViewMap"
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "map scale flavor",
      "Margins",
      box(0, 25, 50, 0),
      "HAlign",
      "right",
      "VAlign",
      "top",
      "LayoutMethod",
      "VList",
      "Visible",
      false,
      "ChildrenHandleMouse",
      false
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "HAlign",
        "right",
        "VAlign",
        "top",
        "TextStyle",
        "PDARolloverText",
        "Translate",
        true,
        "Text",
        T(404650097901, "Sat View"),
        "TextHAlign",
        "right"
      }),
      PlaceObj("XTemplateWindow", {
        "LayoutMethod",
        "HList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "HAlign",
          "left",
          "VAlign",
          "top",
          "TextStyle",
          "PDARolloverText",
          "Translate",
          true,
          "Text",
          T(586207290890, "2km")
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 10, 0, 0),
          "HAlign",
          "left",
          "VAlign",
          "top",
          "LayoutMethod",
          "HList"
        }, {
          PlaceObj("XTemplateWindow", {
            "HAlign",
            "left",
            "VAlign",
            "top",
            "MinWidth",
            1,
            "MinHeight",
            10,
            "MaxWidth",
            1,
            "MaxHeight",
            10,
            "Background",
            RGBA(195, 189, 172, 255)
          }),
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(0, 10, 0, 20),
            "HAlign",
            "left",
            "VAlign",
            "top",
            "MinWidth",
            100,
            "MinHeight",
            1,
            "MaxWidth",
            100,
            "MaxHeight",
            1,
            "Background",
            RGBA(195, 189, 172, 255)
          }),
          PlaceObj("XTemplateWindow", {
            "HAlign",
            "left",
            "VAlign",
            "top",
            "MinWidth",
            1,
            "MinHeight",
            10,
            "MaxWidth",
            1,
            "MaxHeight",
            10,
            "Background",
            RGBA(195, 189, 172, 255)
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return Game
      end,
      "__class",
      "XContextWindow",
      "Margins",
      box(50, 10, 0, 20),
      "ContextUpdateOnOpen",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "Id",
        "idLeft",
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return "ui_player_squads"
          end,
          "__class",
          "XContentTemplate",
          "IdNode",
          false,
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateTemplate", {
            "__context",
            function(parent, context)
              return GetGroupedSquads(false, false, true)
            end,
            "__template",
            "SquadsAndMercs",
            "MouseCursor",
            "UI/Cursors/Pda_Cursor.tga"
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "SelectSquad(self, ...)",
              "func",
              function(self, ...)
                local changed, new_squad, old_squad = SquadsAndMercsClass.SelectSquad(self, ...)
                if changed then
                  Msg("SatelliteNewSquadSelected", new_squad, old_squad)
                end
                local node = self:ResolveId("node")
                node.idCombatLogButton:InvalidateLayout()
              end
            })
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "RespawnContent(self)",
            "func",
            function(self)
              XContentTemplate.RespawnContent(self)
              local container = self:ResolveId("idPartyContainer")
              Msg("SatelliteNewSquadSelected", container.selected_squad, false, false)
            end
          })
        }),
        PlaceObj("XTemplateTemplate", {
          "__template",
          "CombatLogButton",
          "Margins",
          box(0, 20, 0, 0),
          "HAlign",
          "left",
          "MouseCursor",
          "UI/Cursors/Pda_Hand.tga"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "HAlign",
        "left",
        "VAlign",
        "bottom",
        "MinWidth",
        200,
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "controller hint",
          "__context",
          function(parent, context)
            return "GamepadUIStyleChanged"
          end,
          "__class",
          "XText",
          "HAlign",
          "left",
          "VAlign",
          "bottom",
          "Clip",
          false,
          "UseClipBox",
          false,
          "TextStyle",
          "PDARolloverTextShadow",
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            self:SetText(self.Text)
            self:DeleteThread("listener")
            if not GetUIStyleGamepad() then
              self:SetVisible(false)
              return
            end
            self:CreateThread("listener", function()
              while self.window_state ~= "destroying" do
                local _, currentGamepadId = GetActiveGamepadState()
                local show = XInput.IsCtrlButtonPressed(currentGamepadId, "LeftTrigger")
                self:SetVisible(show)
                Sleep(150)
              end
            end)
            XText.OnContextUpdate(self, context, ...)
          end,
          "Translate",
          true,
          "Text",
          T(733508089108, [[
<ShortcutButton('', 'LeftTrigger-DPadUp')> - Max Zoom In
<ShortcutButton('', 'LeftTrigger-DPadDown')> - Max Zoom Out
<ShortcutButton('actionOpenCharacter')> - Character Screen
<ShortcutButton('idInventory')> - Inventory]]),
          "WordWrap",
          false
        }),
        PlaceObj("XTemplateTemplate", {
          "__template",
          "EmailNotification"
        }),
        PlaceObj("XTemplateTemplate", {
          "__template",
          "HUDStartButton",
          "HAlign",
          "left",
          "MouseCursor",
          "UI/Cursors/Pda_Hand.tga"
        })
      })
    }),
    PlaceObj("XTemplateTemplate", {
      "__template",
      "CornerMenu",
      "Margins",
      box(0, 25, 50, 0)
    }),
    PlaceObj("XTemplateTemplate", {
      "__template",
      "PDASatelliteTravelPanel",
      "Id",
      "idTravelPanel"
    }),
    PlaceObj("XTemplateWindow", {
      "Padding",
      box(0, 6, 0, 0),
      "LayoutMethod",
      "VList"
    }, {
      PlaceObj("XTemplateWindow", {
        "Id",
        "idConflictMode",
        "IdNode",
        true,
        "Visible",
        false,
        "FoldWhenHidden",
        true,
        "FadeInTime",
        300,
        "FadeOutTime",
        300
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idConflictText",
          "Padding",
          box(40, 0, 40, 0),
          "HAlign",
          "center",
          "VAlign",
          "top",
          "Background",
          RGBA(191, 67, 77, 255),
          "TextStyle",
          "SatelliteMode",
          "Translate",
          true,
          "Text",
          T(997436410314, "CONFLICT")
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idNormalMode",
        "IdNode",
        true,
        "Visible",
        false,
        "FoldWhenHidden",
        true
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idPausedText",
          "Padding",
          box(40, 0, 40, 0),
          "HAlign",
          "center",
          "VAlign",
          "top",
          "Background",
          RGBA(52, 55, 61, 255),
          "FadeInTime",
          300,
          "FadeOutTime",
          300,
          "TextStyle",
          "SatelliteMode",
          "Translate",
          true,
          "Text",
          T(834405160995, "PAUSED")
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idPausedIcon",
        "Margins",
        box(0, 10, 0, 0),
        "HAlign",
        "center",
        "LayoutMethod",
        "HList",
        "FadeInTime",
        300,
        "FadeOutTime",
        300
      }, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 0, 10, 0),
          "HAlign",
          "left",
          "VAlign",
          "top",
          "MinWidth",
          20,
          "MinHeight",
          50,
          "MaxWidth",
          20,
          "MaxHeight",
          50,
          "Background",
          RGBA(195, 189, 172, 120)
        }),
        PlaceObj("XTemplateWindow", {
          "HAlign",
          "left",
          "VAlign",
          "top",
          "MinWidth",
          20,
          "MinHeight",
          50,
          "MaxWidth",
          20,
          "MaxHeight",
          50,
          "Background",
          RGBA(195, 189, 172, 120)
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idConflictText",
      "Margins",
      box(0, 0, 30, 100),
      "HAlign",
      "center",
      "VAlign",
      "bottom",
      "Clip",
      false,
      "UseClipBox",
      false,
      "Visible",
      false,
      "HandleMouse",
      false,
      "ChildrenHandleMouse",
      false,
      "TextStyle",
      "SatelliteRed",
      "Translate",
      true,
      "Text",
      T(582492723577, "CAN'T UNPAUSE DURING ONGOING CONFLICT")
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idNoMercsText",
      "Margins",
      box(0, 0, 30, 100),
      "HAlign",
      "center",
      "VAlign",
      "bottom",
      "Clip",
      false,
      "UseClipBox",
      false,
      "Visible",
      false,
      "HandleMouse",
      false,
      "ChildrenHandleMouse",
      false,
      "TextStyle",
      "SatelliteRed",
      "Translate",
      true,
      "Text",
      T(299478088097, "CAN'T UNPAUSE - NO CURRENT MERC CONTRACTS")
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idOtherPlayerText",
      "Margins",
      box(0, 0, 30, 100),
      "HAlign",
      "center",
      "VAlign",
      "bottom",
      "Clip",
      false,
      "UseClipBox",
      false,
      "Visible",
      false,
      "HandleMouse",
      false,
      "ChildrenHandleMouse",
      false,
      "TextStyle",
      "SatelliteRed",
      "Translate",
      true,
      "Text",
      T(315834681880, "Cannot unpause the game because another player has opened a game menu.")
    }),
    PlaceObj("XTemplateWindow", {
      "Id",
      "idTimelineContainer",
      "Margins",
      box(0, 0, 0, 20),
      "HAlign",
      "center",
      "VAlign",
      "bottom"
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
        "Id",
        "idTimeInner",
        "HAlign",
        "center",
        "VAlign",
        "bottom",
        "MinHeight",
        65,
        "MaxHeight",
        65,
        "LayoutMethod",
        "HList"
      }, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(14, 0, 14, 0),
          "MinWidth",
          200,
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idTime",
            "HAlign",
            "center",
            "TextStyle",
            "TimelineLabel",
            "Translate",
            true,
            "Text",
            T(442467444132, "<dayNightIcon()> <time()> <day_name()>, <DateFormatted()>"),
            "UpdateTimeLimit",
            150
          }),
          PlaceObj("XTemplateWindow", {
            "Id",
            "idSpeedControls",
            "IdNode",
            true,
            "LayoutHSpacing",
            12,
            "HandleMouse",
            true
          }, {
            PlaceObj("XTemplateTemplate", {
              "__template",
              "PDASmallButton",
              "RolloverTemplate",
              "RolloverGeneric",
              "RolloverAnchor",
              "center-top",
              "RolloverOffset",
              box(0, 0, 0, 45),
              "Id",
              "idPlay",
              "VAlign",
              "top",
              "MinHeight",
              24,
              "MaxHeight",
              24,
              "FXPress",
              "SpeedControl",
              "OnPress",
              function(self, gamepad)
                GetActionsHost(XShortcutsTarget):ActionById("actionPause"):OnAction()
                local conflictSector = AnyNonWaitingConflict()
                if conflictSector then
                  OpenSatelliteConflictDlg(conflictSector)
                end
              end,
              "Image",
              "UI/PDA/os_system_buttons_yellow",
              "CenterImage",
              "UI/PDA/T_Icon_Play",
              "CenterImageColorization",
              RGBA(52, 55, 61, 255)
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "PDASmallButton",
              "RolloverTemplate",
              "RolloverGeneric",
              "RolloverAnchorId",
              "node",
              "Id",
              "idPause",
              "VAlign",
              "top",
              "MinHeight",
              24,
              "MaxHeight",
              24,
              "FXPress",
              "SpeedControl",
              "OnPress",
              function(self, gamepad)
                GetActionsHost(XShortcutsTarget):ActionById("actionPause"):OnAction()
              end,
              "CenterImageColorization",
              RGBA(52, 55, 61, 255)
            }),
            PlaceObj("XTemplateTemplate", {
              "__condition",
              function(parent, context)
                return false
              end,
              "__template",
              "PDASmallButton",
              "RolloverTemplate",
              "RolloverGeneric",
              "RolloverAnchor",
              "center-top",
              "RolloverOffset",
              box(0, 0, 0, 45),
              "Id",
              "idFast",
              "HAlign",
              "left",
              "VAlign",
              "top",
              "MinWidth",
              24,
              "MinHeight",
              24,
              "MaxWidth",
              24,
              "MaxHeight",
              24,
              "FXPress",
              "SpeedControl",
              "OnPress",
              function(self, gamepad)
                GetActionsHost(XShortcutsTarget):ActionById("actionFastSpeed"):OnAction()
              end,
              "CenterImage",
              "UI/PDA/T_Icon_FastForward",
              "CenterImageColorization",
              RGBA(52, 55, 61, 255)
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
              box(0, -2, 5, 0),
              "HAlign",
              "right",
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                local show = GetUIStyleGamepad()
                self:SetVisible(show)
                if IsCampaignPaused() then
                  self:SetText(T(132967088063, "<ShortcutButton('actionResumeGamepad')>"))
                else
                  self:SetText(T(761353842944, "<ShortcutButton('actionPause')>"))
                end
              end,
              "Translate",
              true
            }, {
              PlaceObj("XTemplateWindow", {
                "__context",
                function(parent, context)
                  return Game
                end,
                "__class",
                "XContextWindow",
                "OnContextUpdate",
                function(self, context, ...)
                  self.parent:OnContextUpdate()
                end
              })
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnMouseButtonDown(self, pos, button)",
              "func",
              function(self, pos, button)
                return "break"
              end
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(3, 11, 3, 11)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XFrame",
            "Margins",
            box(-3, -3, -3, -3),
            "Dock",
            "box",
            "Image",
            "UI/PDA/os_background_2",
            "FrameBox",
            box(5, 5, 5, 5)
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "SatelliteTimeline"
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "start indicator flag",
            "__class",
            "XImage",
            "Margins",
            box(-10, 0, 0, 0),
            "HAlign",
            "left",
            "Image",
            "UI/PDA/flag"
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "SatelliteTimelineIconBase",
          "Id",
          "idTimelineFutureEvent",
          "Margins",
          box(-18, -10, -25, 0),
          "HAlign",
          "right",
          "VAlign",
          "top",
          "MouseCursor",
          "UI/Cursors/Pda_Cursor.tga"
        }, {
          PlaceObj("XTemplateCode", {
            "run",
            function(self, parent, context)
              parent.MultipleEventsText = T(936050151964, "Future Events (<count>)")
            end
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(14, 0, 14, 0),
          "MinWidth",
          200,
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return Game
            end,
            "__class",
            "XText",
            "RolloverTemplate",
            "PDAMoneyRollover",
            "RolloverAnchor",
            "center-top",
            "RolloverText",
            T(196336798796, "<placeholder>"),
            "RolloverOffset",
            box(0, 0, 0, 18),
            "RolloverTitle",
            T(988235259400, "<placeholder>"),
            "Id",
            "idPredictedIncome",
            "HAlign",
            "center",
            "TextStyle",
            "TimelineLabel",
            "Translate",
            true,
            "Text",
            T(629107118633, "<money(Money)> <style TimelineLabelAccent><GetDailyMoneyChange()></style>")
          }),
          PlaceObj("XTemplateTemplate", {
            "__context",
            function(parent, context)
              return "gv_SatelliteView"
            end,
            "__template",
            "PDACommonButton",
            "RolloverTemplate",
            "RolloverGeneric",
            "RolloverAnchor",
            "center-top",
            "RolloverText",
            T(169477433361, "You can assign mercs in this sector to different Operations like healing wounds, repairing items or training. Operations take time and often require additional resources in the sector."),
            "RolloverOffset",
            box(0, 0, 0, 45),
            "Id",
            "idOperationsBtn",
            "VAlign",
            "bottom",
            "MinHeight",
            30,
            "MaxHeight",
            30,
            "OnContextUpdate",
            function(self, context, ...)
              if not self.action then
                return
              end
              local btnenabled, reason = self.action:ActionState()
              self:SetEnabled(btnenabled == "enabled")
              self:SetRolloverDisabledText(reason or "")
              self.RolloverDisabledText = reason or ""
            end,
            "OnPressEffect",
            "action",
            "OnPressParam",
            "idOperations",
            "Text",
            T(835363512903, "OPERATIONS")
          }, {
            PlaceObj("XTemplateCode", {
              "run",
              function(self, parent, context)
                local host = GetActionsHost(parent, true)
                if parent.OnPressEffect == "action" then
                  local value = parent.OnPressParam
                  parent.action = host and host:ActionById(value) or nil
                  if not parent.action then
                    parent.action = XShortcutsTarget:ActionById(value) or nil
                  end
                end
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "GetRolloverTemplate(self)",
              "func",
              function(self)
                return (self.enabled or self.RolloverDisabledText ~= "") and self.RolloverTemplate
              end
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "Margins",
      box(0, 0, 50, 20),
      "HAlign",
      "right",
      "VAlign",
      "bottom",
      "LayoutMethod",
      "HList"
    }, {
      PlaceObj("XTemplateTemplate", {
        "__template",
        "CoOpButton",
        "Margins",
        box(0, 0, 5, 0)
      }),
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return "satellite_filters"
        end,
        "__class",
        "XContextWindow",
        "Margins",
        box(0, 5, 0, 0),
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        5,
        "HandleMouse",
        true,
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local mode = g_SatelliteUI.filter_info_mode
          mode = mode or "default"
          for i, b in ipairs(self) do
            local selected = b.OnPressParam == mode
            b:SetSelected(selected)
          end
        end
      }, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "PDAFilterSmallButton",
          "RolloverOffset",
          box(0, 5, 15, 0),
          "OnPress",
          function(self, gamepad)
            if not g_SatelliteUI then
              return
            end
            g_SatelliteUI:ToggleFilterMode(self.OnPressParam)
          end,
          "CenterImage",
          "UI/PDA/SatelliteFilters/Default"
        }),
        PlaceObj("XTemplateTemplate", {
          "__template",
          "PDAFilterSmallButton",
          "RolloverText",
          T(958800089413, "Notes"),
          "RolloverOffset",
          box(0, 5, 15, 0),
          "Id",
          "idTasks",
          "OnPressParam",
          "quests",
          "OnPress",
          function(self, gamepad)
            if not g_SatelliteUI then
              return
            end
            g_SatelliteUI:ToggleFilterMode(self.OnPressParam)
          end,
          "CenterImage",
          "UI/PDA/SatelliteFilters/Quests"
        }),
        PlaceObj("XTemplateTemplate", {
          "__template",
          "PDAFilterSmallButton",
          "RolloverText",
          T(995776296311, "Squads and Operations"),
          "RolloverOffset",
          box(0, 5, 15, 0),
          "Id",
          "idSquads",
          "OnPressParam",
          "squads",
          "OnPress",
          function(self, gamepad)
            if not g_SatelliteUI then
              return
            end
            g_SatelliteUI:ToggleFilterMode(self.OnPressParam)
          end,
          "CenterImage",
          "UI/PDA/SatelliteFilters/Squads"
        }),
        PlaceObj("XTemplateTemplate", {
          "__template",
          "PDAFilterSmallButton",
          "RolloverText",
          T(496606825348, "Items & Stash"),
          "RolloverOffset",
          box(0, 5, 15, 0),
          "Id",
          "idStash",
          "OnPressParam",
          "stash",
          "OnPress",
          function(self, gamepad)
            if not g_SatelliteUI then
              return
            end
            g_SatelliteUI:ToggleFilterMode(self.OnPressParam)
          end,
          "CenterImage",
          "UI/PDA/SatelliteFilters/Stash"
        }),
        PlaceObj("XTemplateTemplate", {
          "__template",
          "PDAFilterSmallButton",
          "RolloverText",
          T(756927934064, "Buildings"),
          "RolloverOffset",
          box(0, 5, 15, 0),
          "Id",
          "idBuildings",
          "OnPressParam",
          "buildings",
          "OnPress",
          function(self, gamepad)
            if not g_SatelliteUI then
              return
            end
            g_SatelliteUI:ToggleFilterMode(self.OnPressParam)
          end,
          "CenterImage",
          "UI/PDA/SatelliteFilters/Buildings"
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "VirtualCursorManager",
      "Reason",
      "Satellite"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return Game
      end,
      "__class",
      "XText",
      "Id",
      "idDebugAggro",
      "Margins",
      box(50, 50, 50, 100),
      "HAlign",
      "right",
      "VAlign",
      "bottom",
      "Clip",
      false,
      "UseClipBox",
      false,
      "HandleMouse",
      false,
      "ChildrenHandleMouse",
      false,
      "TextStyle",
      "SatelliteRed",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        self:SetVisible(gv_DebugShowSatelliteAggro)
        if not gv_DebugShowSatelliteAggro then
          return
        end
        self:SetText("Aggro: " .. (gv_SatelliteAggro or 0) .. "/" .. const.Satellite.AggroAttackThreshold)
      end
    })
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "idClose",
    "ActionName",
    T(986732433213, "CloseSatellite"),
    "ActionState",
    function(self, host)
      if CabinetInTravelMode() then
        return "disabled"
      end
      return "enabled"
    end,
    "OnAction",
    function(self, host, source, ...)
      if not CanCloseSatelliteView() then
        return
      end
      local sat_dlg = GetSatelliteDialog()
      if sat_dlg and sat_dlg.selected_squad and sat_dlg.selected_squad.CurrentSector then
        UIEnterSector(sat_dlg.selected_squad.CurrentSector)
        return
      end
    end
  })
})
