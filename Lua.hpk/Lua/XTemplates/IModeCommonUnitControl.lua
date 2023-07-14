PlaceObj("XTemplate", {
  Comment = "base of all ui modes (including exploration and combat movement)",
  __content = function(parent, context)
    return parent:ResolveId("idParent")
  end,
  group = "Zulu",
  id = "IModeCommonUnitControl",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return g_Combat
    end,
    "__class",
    "XContextWindow",
    "Id",
    "idCommonUnitControl",
    "OnContextUpdate",
    function(self, context, ...)
      self[1]:OnContextUpdate(Selection)
    end
  }, {
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return Selection
      end,
      "__class",
      "XContextWindow",
      "Id",
      "idContent",
      "Padding",
      box(25, 20, 25, 25),
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local visible = true
        if IsRepositionPhase() then
          visible = false
        end
        if g_Combat and not IsNetPlayerTurn() then
          visible = false
        end
        local allDead = true
        for i, u in ipairs(context) do
          if not u:IsDead() and u.command ~= "Die" then
            allDead = false
            break
          end
        end
        local node = self:ResolveId("node")
        node.idBottom:SetVisible(not allDead and not CheatEnabled("CombatUIHidden"))
        node.idWeaponUI:SetVisible(not allDead)
        self:SetVisible(visible)
        local endedTurn = g_Combat and g_Combat:IsLocalPlayerEndTurn()
        node.idBottom:SetTransparency(endedTurn and 100 or 0)
        node.idBottom:SetChildrenHandleMouse(not endedTurn)
        node.idOtherPlayerWait:SetVisible(IsInMultiplayerGame() and endedTurn)
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "Id",
        "idLeftTop",
        "MaxHeight",
        850,
        "OnLayoutComplete",
        function(self)
          if CheatEnabled("CombatUIHidden") then
            self:SetVisible(false)
          end
        end,
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "TeamMembers"
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "spacing",
          "HAlign",
          "left",
          "MinWidth",
          80,
          "MinHeight",
          20,
          "HandleMouse",
          true
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "OnMouseButtonDown(self, pos, button)",
            "func",
            function(self, pos, button)
              return "break"
            end
          })
        }),
        PlaceObj("XTemplateTemplate", {
          "__template",
          "CombatLogButton",
          "HAlign",
          "left"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return {text = "", time = 0}
          end,
          "__class",
          "XContextWindow",
          "Id",
          "idTimerUI",
          "HAlign",
          "center",
          "VAlign",
          "top",
          "LayoutMethod",
          "VList",
          "LayoutVSpacing",
          -5,
          "Visible",
          false,
          "FoldWhenHidden",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            self:SetVisible(context.time > 0)
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idTimerName",
            "HAlign",
            "center",
            "Clip",
            false,
            "UseClipBox",
            false,
            "HandleMouse",
            false,
            "TextStyle",
            "TimerUIName",
            "Translate",
            true,
            "Text",
            T(142197365815, "<text>")
          }),
          PlaceObj("XTemplateWindow", {
            "HAlign",
            "center",
            "LayoutMethod",
            "HList"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Hud/timer_line"
            }),
            PlaceObj("XTemplateWindow", {
              "HAlign",
              "center",
              "MinWidth",
              90,
              "MaxWidth",
              90
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idTimerText",
                "HAlign",
                "center",
                "Clip",
                false,
                "UseClipBox",
                false,
                "HandleMouse",
                false,
                "TextStyle",
                "TimerUI",
                "Translate",
                true,
                "Text",
                T(742832461593, "<timeSecs(time)>"),
                "TextVAlign",
                "bottom"
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Hud/timer_line",
              "FlipX",
              true
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContextWindow",
        "Id",
        "idLeft",
        "HAlign",
        "left",
        "VAlign",
        "bottom",
        "OnLayoutComplete",
        function(self)
          if CheatEnabled("CombatUIHidden") then
            self:SetVisible(false)
          end
        end
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "the parent cannot be a list due to the weapon ui's vertical part",
          "Margins",
          box(0, 0, 0, 93),
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
            "Visible",
            false,
            "TextStyle",
            "GamepadHint",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local normal_text = T(477164871036, "<ShortcutName('GamepadPrevUnit')>/<ShortcutName('GamepadNextUnit')> Select Previous/Next Merc<newline><LeftTrigger> Additional controls<newline><RightTrigger> Attack<newline><ShortcutName('ExplorationSelectionToggle')> <GamepadSelectToggleDynamicText()><newline><ShortcutName('GamepadCameraToUnitAndHighlightInteractables')> Center camera and highlight objects")
              local lt_text = T(423667150358, "<ShortcutName('Reload')> Reload<newline><ShortcutName('GamepadChangeWeapons')> Switch Weapon<newline><ShortcutName('actionCamOverview')> Overview mode<newline><ShortcutName('actionOpenCharacter')> Character Screen<newline><ShortcutName('idInventory')> Inventory<newline><ShortcutName('actionCamFloorUp')>/<ShortcutName('actionCamFloorDown')> Change floor")
              self:SetText(normal_text)
              self:DeleteThread("listener")
              self:SetVisible(GetUIStyleGamepad())
              if not GetUIStyleGamepad() then
                return
              end
              self:CreateThread("listener", function()
                while self.window_state ~= "destroying" do
                  local _, currentGamepadId = GetActiveGamepadState()
                  if IsKindOf(GetInGameInterfaceModeDlg(), "IModeCombatAttackBase") then
                    self:SetVisible(false)
                  elseif XInput.IsCtrlButtonPressed(currentGamepadId, "LeftTrigger") then
                    self:SetVisible(true)
                    self:SetText(lt_text)
                  else
                    self:SetVisible(true)
                    self:SetText(normal_text)
                  end
                  Sleep(150)
                end
              end)
            end,
            "Translate",
            true,
            "Text",
            T(910738643682, "<placeholder>"),
            "WordWrap",
            false
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "selection change observer",
              "__context",
              function(parent, context)
                return Selection
              end,
              "__class",
              "XContextWindow",
              "FoldWhenHidden",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                self.parent:OnContextUpdate()
              end
            })
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "EmailNotification",
            "HAlign",
            "left"
          })
        }),
        PlaceObj("XTemplateWindow", {
          "LayoutMethod",
          "HList"
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "HUDStartButton",
            "HAlign",
            "left"
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "spacing",
            "VAlign",
            "bottom",
            "MinWidth",
            10,
            "MinHeight",
            85,
            "HandleMouse",
            true
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "OnMouseButtonDown(self, pos, button)",
              "func",
              function(self, pos, button)
                return "break"
              end
            })
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "UIWeaponDisplay",
            "VAlign",
            "bottom"
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idBottom",
        "HAlign",
        "center",
        "VAlign",
        "bottom",
        "OnLayoutComplete",
        function(self)
          if CheatEnabled("CombatUIHidden") then
            self:SetVisible(false)
          end
        end,
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "Padding",
          box(0, 0, 0, 10),
          "HAlign",
          "center",
          "LayoutMethod",
          "HList",
          "HandleMouse",
          true
        }, {
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return "combat_bar_enemies"
            end,
            "__class",
            "XContentTemplate",
            "Id",
            "idTargets",
            "IdNode",
            false,
            "HAlign",
            "center",
            "LayoutMethod",
            "HList"
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "RespawnContent(self, ...)",
              "func",
              function(self, ...)
                if UIRebuildSpam then
                  DbgUIRebuild("enemy heads")
                end
                XContentTemplate.RespawnContent(self, ...)
                self:OnSetRollover(self:MouseInWindow(terminal.GetMousePos()))
              end
            }),
            PlaceObj("XTemplateForEach", {
              "comment",
              "enemy head to show",
              "array",
              function(parent, context)
                return Selection and Selection[1] and GetTargetsToShowAboveActionBar(Selection[1]) or empty_table
              end,
              "__context",
              function(parent, context, item, i, n)
                return item
              end,
              "run_after",
              function(child, context, item, i, n, last)
                local igi = GetDialog(child)
                local isSelected = context == igi.target
                child.idHead:SetSelected(isSelected)
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContextWindow",
                "IdNode",
                true,
                "VAlign",
                "bottom",
                "LayoutMethod",
                "VList",
                "ContextUpdateOnOpen",
                true,
                "OnContextUpdate",
                function(self, context, ...)
                  local order = g_unitOrder[SelectedObj]
                  order = order and order[context]
                  if order then
                    self:SetZOrder(order)
                  end
                end
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "EnemyHeadIconButton",
                  "Id",
                  "idHead",
                  "OnPress",
                  function(self, gamepad)
                    local dlg = GetInGameInterfaceModeDlg()
                    local attacker = Selection[1]
                    local target = self.context
                    local action = dlg.action or ShouldUseMarkTarget(attacker, target) and CombatActions.MarkTarget or attacker:GetDefaultAttackAction()
                    if not action.IsTargetableAttack and IsKindOf(dlg, "IModeCombatAreaAim") then
                      SnapCameraToObj(target)
                      return
                    end
                    local args = {target = target}
                    local attackable = CheckAndReportImpossibleAttack(attacker, action, {target = target})
                    if attackable ~= "enabled" then
                      SnapCameraToObj(target)
                      return
                    end
                    if IsKindOf(dlg, "IModeCombatAttackBase") then
                      dlg.context.aim = 0
                      if not dlg:SetTarget(target) then
                        action:UIBegin({attacker}, args)
                      end
                      return
                    end
                    action:UIBegin({attacker}, args)
                  end,
                  "AltPress",
                  true,
                  "OnAltPress",
                  function(self, gamepad)
                    local dlg = GetInGameInterfaceModeDlg()
                    local attacker = SelectedObj
                    local target = self.context
                    local action = dlg.action or ShouldUseMarkTarget(attacker, target) and CombatActions.MarkTarget or attacker:GetDefaultAttackAction()
                    local args = {target = target}
                    if not action or action:GetUIState({attacker}, args) == "disabled" then
                      return
                    end
                    local min, aim = attacker:GetAimLevelRange(action, target)
                    args.aim = aim
                    if IsKindOf(dlg, "IModeCombatAttackBase") and dlg.crosshair then
                      dlg.context.aim = aim
                      dlg:SetTarget(target)
                      dlg.context.aim = aim
                    else
                      action:UIBegin({attacker}, args)
                    end
                  end
                })
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return "combat_bar_traps"
            end,
            "__class",
            "XContentTemplate",
            "HAlign",
            "center",
            "LayoutMethod",
            "HList"
          }, {
            PlaceObj("XTemplateForEach", {
              "comment",
              "Targetable Traps",
              "array",
              function(parent, context)
                return TrapUIGroupings
              end,
              "__context",
              function(parent, context, item, i, n)
                return item.GetList(Selection and Selection[1])
              end,
              "run_after",
              function(child, context, item, i, n, last)
                if child then
                  child.idHead.idHeadIcon:SetImage(item.icon)
                  child.idHead:SetSelected(table.find(context, GetDialog(child).target))
                end
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "__condition",
                function(parent, context)
                  return context and 0 < #context
                end,
                "__class",
                "XContextWindow",
                "IdNode",
                true,
                "ZOrder",
                999999,
                "VAlign",
                "bottom",
                "MinWidth",
                41,
                "MaxWidth",
                41,
                "LayoutMethod",
                "VList"
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "EnemyHeadIconButton",
                  "Id",
                  "idHead",
                  "OnPress",
                  function(self, gamepad)
                    local attacker = SelectedObj
                    local action = attacker:GetDefaultAttackAction()
                    local target = false
                    local dlg = GetInGameInterfaceModeDlg()
                    local attackMode = IsKindOf(dlg, "IModeCombatAttackBase")
                    if attackMode and dlg.target then
                      local trapIdx = table.find(self.context, dlg.target)
                      if trapIdx then
                        trapIdx = trapIdx + 1
                        if trapIdx > #self.context then
                          trapIdx = 1
                        end
                        target = self.context[trapIdx]
                      end
                    end
                    target = target or GetBestVisibleTrap(SelectedObj, self.context)
                    local args = {target = target}
                    local state = CheckAndReportImpossibleAttack(attacker, action, args)
                    if state ~= "enabled" then
                      SnapCameraToObj(target)
                      return
                    end
                    if attackMode then
                      dlg.context.aim = 0
                      if not dlg:SetTarget(target) then
                        action:UIBegin({attacker}, args)
                      end
                      return
                    end
                    action:UIBegin({attacker}, args)
                  end
                }, {
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "UpdateStyle(self, rollover)",
                    "func",
                    function(self, rollover)
                      if not self.visible then
                        return
                      end
                      local greyOut = false
                      if SelectedObj then
                        local bestTrap, attack = GetBestVisibleTrap(SelectedObj, self.context)
                        greyOut = attack == "bad"
                      end
                      local headIcon = self.idHeadIcon
                      local previousState = rawget(self, "greyOut")
                      if greyOut == previousState then
                        return
                      end
                      rawset(self, "greyOut", greyOut)
                      headIcon:SetDesaturation(greyOut and 255 or 0)
                    end
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idMineCount",
                    "ZOrder",
                    2,
                    "Margins",
                    box(20, 0, 0, 0),
                    "HAlign",
                    "center",
                    "VAlign",
                    "bottom",
                    "Clip",
                    false,
                    "UseClipBox",
                    false,
                    "HandleMouse",
                    false,
                    "TextStyle",
                    "APIndicator_Main",
                    "ContextUpdateOnOpen",
                    true,
                    "OnContextUpdate",
                    function(self, context, ...)
                      local count = #context
                      if count <= 1 then
                        return
                      end
                      self:SetText(count)
                      XContextControl.OnContextUpdate(self, context)
                    end,
                    "TextHAlign",
                    "right",
                    "TextVAlign",
                    "bottom"
                  })
                })
              })
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
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XDrawCache",
          "Id",
          "idBottomBar",
          "HAlign",
          "center",
          "LayoutMethod",
          "HList",
          "HandleMouse",
          true
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "StanceHudButton",
            "Margins",
            box(0, 0, 10, 0),
            "VAlign",
            "bottom"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "CombatActionBar",
            "HAlign",
            "left"
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "FloorHudButton",
            "Margins",
            box(10, 0, 0, 0)
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "Open(self)",
            "func",
            function(self)
              ApplyCombatBarHidingAnimation(self, UICombatBarShown, true)
              XDrawCache.Open(self)
            end
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
        "__class",
        "XText",
        "Id",
        "idOtherPlayerWait",
        "Margins",
        box(0, 0, 0, 20),
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
        "TextStyle",
        "TimerUI",
        "Translate",
        true,
        "Text",
        T(344860845336, "WAITING FOR OTHER PLAYER")
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
        "Id",
        "idActionBarGamepadHint",
        "Margins",
        box(0, 0, 0, 20),
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
        "TextStyle",
        "GamepadHint",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          self:SetText(self.Text)
          self:SetVisible(GetUIStyleGamepad() and not UICombatBarShown)
        end,
        "Translate",
        true,
        "Text",
        T(159989740410, "<ShortcutName('GamepadActionBarFocusLeft')>/<ShortcutName('GamepadActionBarFocusRight')> Open Action Bar")
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "UICombatBarShown observer",
          "__context",
          function(parent, context)
            return "UICombatBarShown"
          end,
          "__class",
          "XContextWindow",
          "OnContextUpdate",
          function(self, context, ...)
            self.parent:OnContextUpdate()
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idRight",
        "HAlign",
        "right",
        "VAlign",
        "bottom",
        "OnLayoutComplete",
        function(self)
          if CheatEnabled("CombatUIHidden") then
            self:SetVisible(false)
          end
        end,
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateAction", {
          "ActionId",
          "Interrupt",
          "ActionName",
          T(861218270890, "Interrupt"),
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
          "ActionBindable",
          true,
          "ActionBindSingleKey",
          true,
          "ActionState",
          function(self, host)
            return LocalPlayerCanInterrupt() and "enabled" or "disabled"
          end,
          "OnAction",
          function(self, host, source, ...)
            NetStartCombatAction("Interrupt")
          end
        }),
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return "replay_ui"
          end,
          "__condition",
          function(parent, context)
            return ShowReplayUI
          end,
          "__class",
          "XContentTemplate",
          "Margins",
          box(0, 0, 0, 10),
          "Padding",
          box(8, 8, 8, 8),
          "HAlign",
          "right",
          "VAlign",
          "bottom",
          "MaxWidth",
          300,
          "LayoutMethod",
          "VList",
          "LayoutVSpacing",
          10,
          "Background",
          RGBA(32, 35, 47, 255)
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "RespawnContent(self, ...)",
            "func",
            function(self, ...)
              XContentTemplate.RespawnContent(self, ...)
              self:SetVisible(not gv_Cheats.ReplayUIHidden)
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "Open(self, ...)",
            "func",
            function(self, ...)
              XContentTemplate.Open(self, ...)
              self:SetVisible(not gv_Cheats.ReplayUIHidden)
            end
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "record ui",
            "__condition",
            function(parent, context)
              return not IsValidThread(GameReplayThread)
            end
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "currently recording",
              "__condition",
              function(parent, context)
                return IsGameReplayRecording()
              end
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "PDACommonButton",
                "OnPress",
                function(self, gamepad)
                  SaveGameRecord()
                end,
                "Text",
                T(868542726000, "Stop Recording")
              })
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "not recording",
              "__condition",
              function(parent, context)
                return not IsGameReplayRecording()
              end
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "PDACommonButton",
                "OnPress",
                function(self, gamepad)
                  ZuluStartRecordingReplay()
                end,
                "Text",
                T(929811407854, "Start Recording")
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "playback ui",
            "__condition",
            function(parent, context)
              return GameReplay and IsValidThread(GameReplayThread)
            end,
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateWindow", {"HAlign", "center"}, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "ZOrder",
                2,
                "Margins",
                box(20, 0, 0, 0),
                "HAlign",
                "center",
                "VAlign",
                "bottom",
                "Clip",
                false,
                "UseClipBox",
                false,
                "HandleMouse",
                false,
                "TextStyle",
                "APIndicator_Main",
                "ContextUpdateOnOpen",
                true,
                "OnContextUpdate",
                function(self, context, ...)
                  local text = "Current Speed: " .. GetTimeFactor()
                  if _replayDesynced then
                    text = text .. [[

DESYNCED]]
                  end
                  self:SetText(text)
                end,
                "TextHAlign",
                "center",
                "TextVAlign",
                "bottom"
              })
            }),
            PlaceObj("XTemplateWindow", {
              "HAlign",
              "center",
              "LayoutMethod",
              "HList"
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "PDACommonButton",
                "MinWidth",
                5,
                "OnPress",
                function(self, gamepad)
                  SetTimeFactor(GetTimeFactor() - 50)
                  ReplayUISpeed = GetTimeFactor()
                  ObjModified("replay_ui")
                end,
                "Text",
                T(919688466776, "<")
              }),
              PlaceObj("XTemplateTemplate", {
                "__template",
                "PDACommonButton",
                "MinWidth",
                5,
                "OnPress",
                function(self, gamepad)
                  TogglePause()
                  ObjModified("replay_ui")
                end,
                "Text",
                T(675509250942, "Pause/Resume")
              }),
              PlaceObj("XTemplateTemplate", {
                "__template",
                "PDACommonButton",
                "MinWidth",
                5,
                "OnPress",
                function(self, gamepad)
                  SetTimeFactor(GetTimeFactor() + 50)
                  ReplayUISpeed = GetTimeFactor()
                  ObjModified("replay_ui")
                end,
                "Text",
                T(883503515206, ">")
              }),
              PlaceObj("XTemplateAction", {
                "ActionId",
                "actionFasterReplayTime",
                "ActionGamepad",
                "RightShoulder",
                "ActionState",
                function(self, host)
                  return cameraFly.IsActive() and "enabled" or "disabled"
                end,
                "OnAction",
                function(self, host, source, ...)
                  SetTimeFactor(GetTimeFactor() + 50)
                  ReplayUISpeed = GetTimeFactor()
                  ObjModified("replay_ui")
                end
              }),
              PlaceObj("XTemplateAction", {
                "ActionId",
                "actionSlowerReplayTime",
                "ActionGamepad",
                "LeftShoulder",
                "ActionState",
                function(self, host)
                  return cameraFly.IsActive() and "enabled" or "disabled"
                end,
                "OnAction",
                function(self, host, source, ...)
                  SetTimeFactor(GetTimeFactor() - 50)
                  ReplayUISpeed = GetTimeFactor()
                  ObjModified("replay_ui")
                end
              })
            }),
            PlaceObj("XTemplateWindow", {
              "HAlign",
              "center",
              "LayoutMethod",
              "HList"
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "PDACommonButton",
                "MinWidth",
                5,
                "OnPress",
                function(self, gamepad)
                  StopGameRecord()
                end,
                "Text",
                T(513799794807, "Stop Playback")
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "playback ui",
            "__condition",
            function(parent, context)
              return GameReplay and not IsValidThread(GameReplayThread)
            end,
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateTemplate", {
              "__template",
              "PDACommonButton",
              "OnPress",
              function(self, gamepad)
                ReplayGameRecord(GameReplay)
              end,
              "Text",
              T(644863834766, "Play Again")
            })
          }),
          PlaceObj("XTemplateWindow", {"HAlign", "center"}, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "ZOrder",
              2,
              "HAlign",
              "center",
              "VAlign",
              "bottom",
              "Clip",
              false,
              "UseClipBox",
              false,
              "HandleMouse",
              false,
              "TextStyle",
              "APIndicator_Main",
              "ContextUpdateOnOpen",
              true,
              "Text",
              [[
Shift-I = Toggle UI
Shift-Y = Toggle World UI
Shift-J = Toggle This UI
Shift-L = Toggle Optional UI
Alt-Shift-H - Toggle Hidden Walls
Pause/Break = Pause/Resume Replay]],
              "TextVAlign",
              "bottom"
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return Selection
          end,
          "__class",
          "XContextWindow",
          "Id",
          "idParent",
          "HAlign",
          "right",
          "VAlign",
          "bottom",
          "OnLayoutComplete",
          function(self)
            for i, c in ipairs(self) do
              if i ~= #self then
                c:SetMargins(box(0, 0, 0, 5))
              end
            end
          end,
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateTemplate", {"__template", "DeployMenu"}),
          PlaceObj("XTemplateTemplate", {"__template", "CoOpButton"}),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "GenericHUDButtonFrame",
            "Id",
            "idRedeployFrame",
            "IdNode",
            false,
            "HAlign",
            "right",
            "FoldWhenHidden",
            true
          }, {
            PlaceObj("XTemplateWindow", {
              "__context",
              function(parent, context)
                return "gv_Redeployment"
              end,
              "__class",
              "HUDButton",
              "RolloverTemplate",
              "SmallRolloverGeneric",
              "RolloverAnchor",
              "center-top",
              "Padding",
              box(5, 0, 5, 0),
              "MinWidth",
              170,
              "MaxWidth",
              170,
              "LayoutMethod",
              "HList",
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                self:ResolveId("node").idRedeployFrame:SetVisible(gv_Redeployment)
              end,
              "OnPress",
              function(self, gamepad)
                NetSyncEvent("StartRedeployDeployment")
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idLargeText",
                "Margins",
                box(0, 0, 3, 0),
                "Dock",
                "box",
                "HAlign",
                "center",
                "VAlign",
                "center",
                "TextStyle",
                "HUDHeaderBig",
                "Translate",
                true,
                "Text",
                T(942156304289, "Redeploy"),
                "TextHAlign",
                "center"
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "OnSetRollover(self, rollover)",
                "func",
                function(self, rollover)
                  self.idLargeText:SetTextStyle(rollover and "HUDHeaderBigLight" or "HUDHeaderBig")
                  XButton.OnSetRollover(self, rollover)
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "Open(self)",
                "func",
                function(self)
                  HUDButton.Open(self)
                end
              }),
              PlaceObj("XTemplateAction", {
                "ActionId",
                "actionRedeploy",
                "ActionGamepad",
                "LeftTrigger-RightTrigger-DPadDown",
                "ActionState",
                function(self, host)
                  return gv_Redeployment and "enabled" or "hidden"
                end,
                "OnAction",
                function(self, host, source, ...)
                  NetSyncEvent("StartRedeployDeployment")
                end
              }),
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
                "ScaleModifier",
                point(700, 700),
                "TextStyle",
                "HUDHeaderBig",
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
                T(134620124480, "<LeftTrigger>+<RightTrigger>+<DPadDown>")
              })
            })
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "GenericHUDButtonFrame",
            "Id",
            "idRetreatFrame",
            "IdNode",
            false,
            "HAlign",
            "right",
            "FoldWhenHidden",
            true
          }, {
            PlaceObj("XTemplateWindow", {
              "__context",
              function(parent, context)
                return "gv_RetreatOrTravelOption"
              end,
              "__class",
              "HUDButton",
              "RolloverTemplate",
              "SmallRolloverGeneric",
              "RolloverAnchor",
              "center-top",
              "Id",
              "idRetreat",
              "Padding",
              box(5, 0, 5, 0),
              "MinWidth",
              170,
              "MaxWidth",
              170,
              "LayoutMethod",
              "HList",
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                local sector = gv_Sectors and gv_Sectors[gv_CurrentSectorId]
                if sector and sector.conflict then
                  self.idLargeText:SetText(T(986007225138, "RETREAT"))
                else
                  self.idLargeText:SetText(T(662628238628, "TRAVEL"))
                end
                XContextWindow.OnContextUpdate(self, context, ...)
                self:ResolveId("node").idRetreatFrame:SetVisible(gv_RetreatOrTravelOption)
              end,
              "OnPressEffect",
              "action",
              "OnPressParam",
              "idRetreatAction",
              "OnPress",
              function(self, gamepad)
                local effect = self.OnPressEffect
                if effect == "close" then
                  local win = self.parent
                  while win and not win:IsKindOf("XDialog") do
                    win = win.parent
                  end
                  if win then
                    win:Close(self.OnPressParam ~= "" and self.OnPressParam or nil)
                  end
                elseif self.action then
                  local host = GetActionsHost(self, true)
                  if host then
                    host:OnAction(self.action, self, gamepad)
                  end
                end
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idLargeText",
                "Margins",
                box(0, 0, 3, 0),
                "Dock",
                "box",
                "HAlign",
                "center",
                "VAlign",
                "center",
                "TextStyle",
                "HUDHeaderBig",
                "Translate",
                true,
                "TextHAlign",
                "center"
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "OnSetRollover(self, rollover)",
                "func",
                function(self, rollover)
                  self.idLargeText:SetTextStyle(rollover and "HUDHeaderBigLight" or "HUDHeaderBig")
                  XButton.OnSetRollover(self, rollover)
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "Open(self)",
                "func",
                function(self)
                  HUDButton.Open(self)
                  CheckRetreatButtonVisibility()
                end
              }),
              PlaceObj("XTemplateAction", {
                "ActionId",
                "idRetreatAction",
                "ActionGamepad",
                "LeftTrigger-DPadDown",
                "OnAction",
                function(self, host, source, ...)
                  local unit = Selection and Selection[1]
                  if gv_RetreatOrTravelOption then
                    gv_RetreatOrTravelOption:UnitLeaveSector(unit)
                  end
                end
              }),
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
                "ScaleModifier",
                point(700, 700),
                "TextStyle",
                "HUDHeaderBig",
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
                T(935267226434, "<LeftTrigger>+<DPadDown>")
              })
            })
          })
        })
      }),
      PlaceObj("XTemplateTemplate", {
        "__template",
        "CornerMenu",
        "OnLayoutComplete",
        function(self)
          if CurrentActionCamera then
            self:SetVisible(false)
          end
          if CheatEnabled("CombatUIHidden") then
            self:SetVisible(false)
          end
        end
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "AP prediction, is on mouse pointer",
      "__context",
      function(parent, context)
        return APIndicator
      end,
      "__class",
      "APPrediction",
      "Id",
      "idApIndicator",
      "Dock",
      "box"
    })
  })
})
