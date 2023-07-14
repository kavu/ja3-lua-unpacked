PlaceObj("XTemplate", {
  Comment = "and AutoResolve",
  group = "Zulu Satellite UI",
  id = "SatelliteConflict",
  PlaceObj("XTemplateWindow", {
    "__class",
    "SatelliteConflictClass",
    "ZOrder",
    5,
    "Dock",
    "box",
    "Background",
    RGBA(30, 30, 35, 115),
    "FadeInTime",
    200,
    "FadeOutTime",
    200,
    "ContextUpdateOnOpen",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "comment",
      "Background",
      "__class",
      "XFrame",
      "IdNode",
      false,
      "Dock",
      "box",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "LayoutMethod",
      "VList",
      "Image",
      "UI/PDA/os_background",
      "FrameBox",
      box(8, 8, 8, 8)
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "TitleBar",
        "__context",
        function(parent, context)
          return context.autoResolve and context.sector or context
        end,
        "__class",
        "XFrame",
        "Image",
        "UI/PDA/os_header",
        "FrameBox",
        box(5, 5, 5, 5)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "Id",
          "idSectorBG",
          "IdNode",
          false,
          "Padding",
          box(2, 0, 2, 0),
          "Dock",
          "left",
          "VAlign",
          "center",
          "MinWidth",
          32,
          "Image",
          "UI/PDA/os_header",
          "FrameBox",
          box(5, 5, 20, 5)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idSector",
            "HAlign",
            "center",
            "VAlign",
            "center",
            "FoldWhenHidden",
            true,
            "TextStyle",
            "ConflictTitleBar",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              if context.Side == "enemy1" or context.Side == "enemy2" then
                self.parent:SetImage("UI/PDA/sector_enemy")
              elseif context.Side == "player1" or context.Side == "player2" or context.Side == "ally" then
                self.parent:SetImage("UI/PDA/sector_ally")
              else
                self.parent:SetImage("UI/PDA/os_header")
              end
              self:SetText(T({
                764093693143,
                "<SectorIdColored(id)>",
                id = context.Id
              }))
            end,
            "Translate",
            true,
            "WordWrap",
            false
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "SectorName",
          "__class",
          "XText",
          "Margins",
          box(5, 0, 0, 0),
          "HAlign",
          "left",
          "VAlign",
          "center",
          "HandleKeyboard",
          false,
          "HandleMouse",
          false,
          "TextStyle",
          "ConflictTitleBar",
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            local text = context.display_name
            self:SetText(T(text))
          end,
          "Translate",
          true
        }),
        PlaceObj("XTemplateTemplate", {
          "__template",
          "PDASmallButton",
          "Id",
          "idClose",
          "Margins",
          box(2, 2, 4, 2),
          "Dock",
          "right",
          "HAlign",
          "center",
          "VAlign",
          "center",
          "MinWidth",
          16,
          "MinHeight",
          16,
          "MaxWidth",
          16,
          "MaxHeight",
          16,
          "OnPressEffect",
          "action",
          "OnPressParam",
          "actionClosePanel",
          "Text",
          "x",
          "CenterImage",
          ""
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "IdNode",
        false,
        "Margins",
        box(8, 8, 8, 8),
        "LayoutMethod",
        "VList",
        "Image",
        "UI/PDA/os_background",
        "FrameBox",
        box(8, 8, 8, 8)
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "conflict descr",
          "__class",
          "XContextWindow",
          "Margins",
          box(8, 8, 8, 0),
          "Padding",
          box(16, 0, 16, 16),
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            local conflictTitle, styleOfT
            if context.autoResolve then
              conflictTitle = TFormat.AutoResolveOutcomeText(context, context.player_outcome)
              styleOfT = (context.player_outcome == "decisive_win" or context.player_outcome == "win") and "ConflictVictory" or "ConflictDefeat"
            else
              conflictTitle = GetConflictCustomTitle(context)
            end
            self:ResolveId("idConflictTitle"):SetText(conflictTitle)
            if styleOfT then
              self:ResolveId("idConflictTitle"):SetTextStyle(styleOfT)
            end
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "conf title",
            "__class",
            "XText",
            "Id",
            "idConflictTitle",
            "Dock",
            "top",
            "HandleKeyboard",
            false,
            "HandleMouse",
            false,
            "TextStyle",
            "ConflictName",
            "Translate",
            true,
            "Text",
            T(956375235737, "Conflict Title")
          }),
          PlaceObj("XTemplateWindow", {
            "__condition",
            function(parent, context)
              return not context.autoResolve
            end,
            "__class",
            "XContextWindow",
            "LayoutMethod",
            "HList"
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "notes image",
              "__class",
              "XImage",
              "VAlign",
              "top",
              "Image",
              "UI/PDA/Event/T_Event_TextIcon"
            }),
            PlaceObj("XTemplateWindow", {
              "LayoutMethod",
              "VList"
            }, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "descr",
                "__class",
                "XText",
                "Margins",
                box(8, 0, 0, 8),
                "Padding",
                box(0, -4, 0, 0),
                "HAlign",
                "left",
                "VAlign",
                "top",
                "MaxWidth",
                660,
                "HandleKeyboard",
                false,
                "HandleMouse",
                false,
                "TextStyle",
                "ConflictDescription",
                "Translate",
                true,
                "Text",
                T(450572883293, "<SectorConflictCustomDescr()>"),
                "TextVAlign",
                "center"
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "warning",
                "__class",
                "XText",
                "Margins",
                box(8, 0, 0, 8),
                "Padding",
                box(0, -4, 0, 0),
                "HAlign",
                "left",
                "VAlign",
                "top",
                "MaxWidth",
                660,
                "Visible",
                false,
                "FoldWhenHidden",
                true,
                "HandleKeyboard",
                false,
                "HandleMouse",
                false,
                "TextStyle",
                "ConflictWarning",
                "ContextUpdateOnOpen",
                true,
                "OnContextUpdate",
                function(self, context, ...)
                  local woundedCount, tiredCount = GetSatelliteConflictWarnings(context.ally_squads)
                  if 0 < woundedCount then
                    local text = T({
                      139417786956,
                      "Warning! Severely wounded merc(s): <number>",
                      number = woundedCount
                    })
                    self:SetText(text)
                    self:SetVisible(true)
                  elseif 0 < tiredCount then
                    local text = T({
                      355864070748,
                      "Warning! Tired merc(s): <number>",
                      number = tiredCount
                    })
                    self:SetText(text)
                    self:SetVisible(true)
                  end
                end,
                "Translate",
                true,
                "TextVAlign",
                "center"
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "Margins",
          box(18, 0, 18, 0),
          "Image",
          "UI/PDA/separate_line_vertical",
          "FrameBox",
          box(3, 3, 3, 3),
          "SqueezeY",
          false
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "mid",
          "Margins",
          box(8, 8, 8, 8),
          "Padding",
          box(8, 4, 8, 8)
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "teams",
            "Margins",
            box(0, 0, 0, 4),
            "LayoutMethod",
            "Grid",
            "UniformColumnWidth",
            true
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "left",
              "__context",
              function(parent, context)
                return context.autoResolve and context.allySquads or GetSquadsInSector(context.Id, "excludeTravelling", "includeMilitia", "excludeArriving", "excludeRetreating")
              end,
              "Margins",
              box(4, 4, 4, 4),
              "LayoutMethod",
              "HList"
            }, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "team",
                "Padding",
                box(6, 0, 0, 0),
                "Dock",
                "left",
                "LayoutMethod",
                "VList"
              }, {
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "teamName",
                  "__class",
                  "XText",
                  "Margins",
                  box(0, 0, 0, -4),
                  "Padding",
                  box(0, 0, 0, 0),
                  "TextStyle",
                  "ConflictMercsHeader",
                  "Translate",
                  true,
                  "Text",
                  T(482781302306, "MERCENARIES")
                }),
                PlaceObj("XTemplateWindow", {
                  "__context",
                  function(parent, context)
                    return "sidePower"
                  end,
                  "__class",
                  "XText",
                  "Id",
                  "idPower",
                  "Padding",
                  box(0, 0, 0, 0),
                  "Visible",
                  false,
                  "FoldWhenHidden",
                  true,
                  "TextStyle",
                  "ConflictPower",
                  "ContextUpdateOnOpen",
                  true,
                  "OnContextUpdate",
                  function(self, context, ...)
                    local dlg = GetDialog(self)
                    if dlg.playerMod == 100 then
                      self:SetText(T({
                        Untranslated("Power: <power>"),
                        power = dlg.playerPower
                      }))
                    else
                      local factionBasePower = MulDivRound(dlg.playerPower, 100, dlg.playerMod)
                      local modPower = dlg.playerPower - factionBasePower
                      self:SetText(T({
                        Untranslated("Modified Power: <factionBasePower>(<prefix><modPower>)"),
                        factionBasePower = factionBasePower,
                        modPower = modPower,
                        prefix = 0 <= modPower and "+" or ""
                      }))
                    end
                    self:SetVisible(gv_Cheats.ShowSquadsPower)
                  end,
                  "Translate",
                  true,
                  "HideOnEmpty",
                  true
                }),
                PlaceObj("XTemplateWindow", {
                  "__context",
                  function(parent, context)
                    return "sidePower"
                  end,
                  "__class",
                  "AutoFitText",
                  "Id",
                  "idPredictedOutcome",
                  "Padding",
                  box(0, 0, 10, 0),
                  "FoldWhenHidden",
                  true,
                  "TextStyle",
                  "ConflictPower",
                  "ContextUpdateOnOpen",
                  true,
                  "OnContextUpdate",
                  function(self, context, ...)
                    local dlg = GetDialog(self)
                    if not dlg.context.autoResolve and IsAutoResolveEnabled(dlg.context) and not SatelliteConflictAppliedOnSector(dlg.context) then
                      self:SetText(T({
                        981974661159,
                        "Predicted outcome: <outcome>",
                        outcome = TFormat.AutoResolveOutcomeText(context, dlg.context.predicted_outcome)
                      }))
                    end
                  end,
                  "Translate",
                  true,
                  "HideOnEmpty",
                  true
                })
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "count",
                "__class",
                "XText",
                "Margins",
                box(0, -10, 20, 0),
                "Dock",
                "right",
                "TextStyle",
                "ConflictMercsCount",
                "Translate",
                true,
                "Text",
                T(172135194761, "<UnitsCountOnly()>")
              })
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "line separator",
              "__class",
              "XImage",
              "Margins",
              box(4, 4, 4, 4),
              "Dock",
              "box",
              "HAlign",
              "center",
              "DrawOnTop",
              true,
              "Image",
              "UI/PDA/separate_line",
              "ImageFit",
              "stretch-y"
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "right",
              "__context",
              function(parent, context)
                return context.autoResolve and context.enemySquads or GetEnemiesInSector(context.Id, "excludeTravelling")
              end,
              "Margins",
              box(4, 4, 4, 4),
              "GridX",
              2,
              "LayoutMethod",
              "HList"
            }, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "team",
                "Padding",
                box(0, 0, 6, 0),
                "Dock",
                "right",
                "LayoutMethod",
                "VList"
              }, {
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "teamName",
                  "__class",
                  "XText",
                  "Margins",
                  box(0, 0, 0, -4),
                  "Padding",
                  box(0, 0, 0, 0),
                  "HAlign",
                  "right",
                  "TextStyle",
                  "ConflictEnemyHeader",
                  "Translate",
                  true,
                  "Text",
                  T(468588739879, "ENEMIES")
                }),
                PlaceObj("XTemplateWindow", {
                  "__context",
                  function(parent, context)
                    return "sidePower"
                  end,
                  "__class",
                  "XText",
                  "Id",
                  "idEnemyPower",
                  "Padding",
                  box(0, 0, 0, 0),
                  "HAlign",
                  "right",
                  "Visible",
                  false,
                  "FoldWhenHidden",
                  true,
                  "TextStyle",
                  "ConflictPower",
                  "ContextUpdateOnOpen",
                  true,
                  "OnContextUpdate",
                  function(self, context, ...)
                    local dlg = GetDialog(self)
                    local factionPower = dlg.enemyPower
                    if factionPower == 0 then
                      self:SetText(T({""}))
                    else
                      self:SetText(T({
                        934537768478,
                        "Estimated Power: <factionPower>",
                        factionPower = factionPower
                      }))
                    end
                    self:SetVisible(gv_Cheats.ShowSquadsPower)
                  end,
                  "Translate",
                  true,
                  "HideOnEmpty",
                  true
                })
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "count",
                "__class",
                "XText",
                "Margins",
                box(20, -10, 0, 0),
                "Dock",
                "left",
                "TextStyle",
                "ConflictEnemyCount",
                "ContextUpdateOnOpen",
                true,
                "OnContextUpdate",
                function(self, context, ...)
                  if not self.Text then
                    self:SetText(T({""}))
                  end
                  XContextControl.OnContextUpdate(self, context)
                end,
                "Translate",
                true,
                "Text",
                T(172135194761, "<UnitsCountOnly()>")
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "squads",
            "__class",
            "XFrame",
            "IdNode",
            false,
            "Dock",
            "bottom",
            "LayoutMethod",
            "Grid",
            "UniformColumnWidth",
            true,
            "UniformRowHeight",
            true,
            "Image",
            "UI/PDA/os_background_2",
            "FrameBox",
            box(8, 8, 8, 8)
          }, {
            PlaceObj("XTemplateTemplate", {
              "__context",
              function(parent, context)
                return context.autoResolve and context.allySquads or GetSquadsInSector(context.Id, "excludeTravelling", "includeMilitia", "excludeArriving", "excludeRetreating")
              end,
              "__template",
              "SatelliteConflictSquadsAndMercs",
              "Margins",
              box(0, 0, 8, 0)
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "line separator",
              "__class",
              "XFrame",
              "Margins",
              box(0, 2, 0, 2),
              "DrawOnTop",
              true,
              "Image",
              "UI/PDA/separate_line",
              "FrameBox",
              box(3, 3, 3, 3),
              "SqueezeX",
              false
            }),
            PlaceObj("XTemplateTemplate", {
              "__context",
              function(parent, context)
                return context.autoResolve and context.enemySquads or GetEnemiesInSector(context.Id, "excludeTravelling")
              end,
              "__template",
              "SatelliteConflictSquadsAndEnemies",
              "Margins",
              box(8, 0, 0, 0),
              "GridX",
              2
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return context.autoResolve and IsOutcomeWin(context.player_outcome) and context.loot
        end,
        "__condition",
        function(parent, context)
          return context
        end,
        "__class",
        "XContentTemplate",
        "Margins",
        box(8, 0, 8, 8)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "IdNode",
          false,
          "Dock",
          "box",
          "Image",
          "UI/PDA/os_background",
          "FrameBox",
          box(8, 8, 8, 8)
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "loot",
          "__class",
          "XInventoryItemEmbed",
          "Padding",
          box(10, 10, 10, 10),
          "HAlign",
          "center",
          "MaxWidth",
          1000,
          "LayoutMethod",
          "HWrap",
          "LayoutHSpacing",
          10,
          "LayoutVSpacing",
          10,
          "FoldWhenHidden",
          true,
          "BorderColor",
          RGBA(60, 63, 68, 255),
          "Background",
          RGBA(42, 45, 54, 120),
          "HideWhenEmpty",
          true
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "SetVisible(self, visible)",
            "func",
            function(self, visible)
              XContextWindow.SetVisible(self, visible)
              self.parent:SetVisible(visible)
            end
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(8, 0, 8, 8),
        "LayoutMethod",
        "HList"
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "ActionBarLeft",
          "__class",
          "XToolBarList",
          "Id",
          "idToolbar",
          "Dock",
          "left",
          "LayoutHSpacing",
          16,
          "Background",
          RGBA(255, 255, 255, 0),
          "Toolbar",
          "ActionBarLeft",
          "ButtonTemplate",
          "PDACommonButton"
        }, {
          PlaceObj("XTemplateAction", {
            "comment",
            "red enabled",
            "RolloverTemplate",
            "RolloverGeneric",
            "RolloverOffset",
            box(0, 0, 0, 10),
            "ActionId",
            "actionFight",
            "ActionName",
            T(587415184963, "FIGHT"),
            "ActionToolbar",
            "ActionBarLeft",
            "ActionShortcut",
            "Enter",
            "ActionGamepad",
            "ButtonA",
            "ActionBindable",
            true,
            "ActionButtonTemplate",
            "PDACommonButtonRed",
            "ActionState",
            function(self, host)
              local sector = host.context
              return CanGoInMap(sector.Id) and #GetSquadsInSector(sector.Id, "excludeTravelling", false, "excludeArriving", "excludeRetreating") > 0 and "enabled" or "hidden"
            end,
            "OnAction",
            function(self, host, source, ...)
              if IsValidThread(host.EnterSectorThread) then
                return
              end
              local sector = host.context
              Msg("AutoResolveChoice", sector.Id, "Fight")
              host.EnterSectorThread = CreateRealTimeThread(UIEnterSector, sector.Id, true)
            end,
            "__condition",
            function(parent, context)
              return not context.autoResolve
            end
          }),
          PlaceObj("XTemplateAction", {
            "comment",
            "normal disabled",
            "RolloverTemplate",
            "RolloverGeneric",
            "RolloverOffset",
            box(0, 0, 0, 10),
            "ActionId",
            "actionFight",
            "ActionName",
            T(587415184963, "FIGHT"),
            "ActionToolbar",
            "ActionBarLeft",
            "ActionShortcut",
            "Enter",
            "ActionGamepad",
            "ButtonA",
            "ActionBindable",
            true,
            "ActionButtonTemplate",
            "PDACommonButton",
            "ActionState",
            function(self, host)
              local sector = host.context
              return CanGoInMap(sector.Id) and #GetSquadsInSector(sector.Id, "excludeTravelling", false, "excludeArriving", "excludeRetreating") > 0 and "hidden" or "disabled"
            end,
            "__condition",
            function(parent, context)
              return not context.autoResolve
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "RebuildActions(self, ...)",
            "func",
            function(self, ...)
              XToolBarList.RebuildActions(self, ...)
              local fightButton = self.idactionFight
              if fightButton then
                function fightButton.GetRolloverAnchor()
                  return "center-top"
                end
                fightButton.GetRolloverDisabledText = empty_func
                local oldGet = fightButton.GetRolloverText
                function fightButton:GetRolloverText()
                  local enabled = self:GetEnabled()
                  if enabled then
                    return
                  end
                  local node = self:ResolveId("node")
                  local sector = node.context
                  local canGo, reason = CanGoInMap(sector.Id)
                  if not canGo and reason == "enemy waiting" then
                    return T(254777828903, "More squads are en route. The conflict will start when they arrive!")
                  end
                end
              end
            end
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "ActionBar",
          "__class",
          "XToolBarList",
          "Id",
          "idToolbar2",
          "Dock",
          "right",
          "LayoutHSpacing",
          16,
          "Background",
          RGBA(255, 255, 255, 0),
          "Toolbar",
          "ActionBar",
          "ButtonTemplate",
          "PDACommonButton"
        }, {
          PlaceObj("XTemplateAction", {
            "ActionId",
            "actionLoot",
            "ActionName",
            T(206805847041, "Take Loot"),
            "ActionToolbar",
            "ActionBar",
            "ActionGamepad",
            "ButtonX",
            "ActionBindable",
            true,
            "ActionState",
            function(self, host)
              if #host.context.loot > 0 and IsOutcomeWin(host.context.player_outcome) then
                for i, squad in ipairs(host.context.allySquads) do
                  if not squad.militia then
                    return "enabled"
                  end
                end
                return "disabled"
              end
              return "hidden"
            end,
            "OnAction",
            function(self, host, source, ...)
              local context = host:GetContext()
              local inventoryUnit = context.first_alive_merc
              if inventoryUnit then
                local squad = inventoryUnit.Squad
                local squadObj = gv_Squads[squad]
                local unitInventories = {}
                for i, u in ipairs(squadObj.units) do
                  local ud = gv_UnitData[u]
                  local inventory = ud
                  unitInventories[#unitInventories + 1] = inventory
                end
                local items = context.loot
                TakeLootFromAutoResolve(unitInventories, items, context.sector.Id)
              end
            end,
            "__condition",
            function(parent, context)
              return context.autoResolve and context.loot and #context.loot > 0
            end
          }),
          PlaceObj("XTemplateAction", {
            "ActionId",
            "actionInventory",
            "ActionName",
            T(950505733606, "Inventory"),
            "ActionToolbar",
            "ActionBar",
            "ActionGamepad",
            "ButtonY",
            "ActionBindable",
            true,
            "ActionState",
            function(self, host)
              if IsOutcomeWin(host.context.player_outcome) then
                for i, squad in ipairs(host.context.allySquads) do
                  if not squad.militia then
                    return "enabled"
                  end
                end
                return "disabled"
              end
              return "hidden"
            end,
            "OnAction",
            function(self, host, source, ...)
              local context = host:GetContext()
              local inventoryUnit = context.first_alive_merc
              if inventoryUnit then
                host:Close()
                OpenInventory(inventoryUnit, false, "autoResolve")
              end
            end,
            "__condition",
            function(parent, context)
              return context.autoResolve
            end
          }),
          PlaceObj("XTemplateAction", {
            "ActionId",
            "actionAuto",
            "ActionName",
            T(519097043558, "Auto-resolve"),
            "ActionToolbar",
            "ActionBar",
            "ActionShortcut",
            "T",
            "ActionGamepad",
            "ButtonY",
            "ActionBindable",
            true,
            "ActionState",
            function(self, host)
              local sector = host.context
              return IsAutoResolveEnabled(sector) and "enabled" or "disabled"
            end,
            "OnAction",
            function(self, host, source, ...)
              local sector = host.context
              Msg("AutoResolveChoice", sector.Id, "AutoResolve")
              NetSyncEvent("UIAutoResolveConflict", sector.Id, gv_AutoResolveUseOrdnance)
              if host.window_state == "open" then
                host:Close()
              end
            end,
            "__condition",
            function(parent, context)
              return not context.autoResolve and not SatelliteConflictAppliedOnSector(context)
            end
          }),
          PlaceObj("XTemplateAction", {
            "RolloverTemplate",
            "RolloverGeneric",
            "RolloverDisabledText",
            T(287983219145, "You must manage the retreat from Tactical View"),
            "RolloverOffset",
            box(0, 0, 0, 10),
            "ActionId",
            "actionRetreat",
            "ActionName",
            T(103711931406, "Retreat"),
            "ActionToolbar",
            "ActionBar",
            "ActionShortcut",
            "R",
            "ActionGamepad",
            "LeftTrigger-ButtonB",
            "ActionBindable",
            true,
            "ActionState",
            function(self, host)
              local sector = host.context
              local conflict = sector.conflict
              local hasPreviousSector = conflict and conflict.spawn_mode == "attack" and conflict.prev_sector_id
              if hasPreviousSector then
                if not ForceReloadSectorMap and gv_CurrentSectorId == sector.Id then
                  return "disabled"
                end
                local sect = gv_Sectors[hasPreviousSector]
                if sect.Passability == "Water" then
                  return "disabled"
                end
                return "enabled"
              end
              return "disabled"
            end,
            "OnAction",
            function(self, host, source, ...)
              local sector = host.context
              NetSyncEvent("UISatelliteRetreat", sector.Id)
              if host.window_state ~= "destroying" then
                host:Close()
              end
            end,
            "__condition",
            function(parent, context)
              return not context.autoResolve
            end
          }),
          PlaceObj("XTemplateAction", {
            "ActionId",
            "actionClosePanel",
            "ActionName",
            T(382425858931, "Close"),
            "ActionToolbar",
            "ActionBar",
            "ActionShortcut",
            "Escape",
            "ActionGamepad",
            "ButtonB",
            "ActionBindable",
            true,
            "OnAction",
            function(self, host, source, ...)
              host:Close()
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "RebuildActions(self, ...)",
            "func",
            function(self, ...)
              XToolBarList.RebuildActions(self, ...)
              local retreatButton = self.idactionRetreat
              if retreatButton then
                function retreatButton.GetRolloverAnchor()
                  return "center-top"
                end
                retreatButton.GetRolloverDisabledText = empty_func
                local oldGet = retreatButton.GetRolloverText
                function retreatButton:GetRolloverText()
                  local enabled = self:GetEnabled()
                  if enabled then
                    return
                  end
                  return oldGet(self)
                end
              end
            end
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__condition",
          function(parent, context)
            return not context.autoResolve and not SatelliteConflictAppliedOnSector(context)
          end,
          "__class",
          "XContextWindow",
          "Margins",
          box(48, 0, 0, 0),
          "Dock",
          "right",
          "LayoutMethod",
          "HList",
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            self:SetVisible(IsAutoResolveEnabled(context))
          end
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
            "Margins",
            box(0, 0, 5, 0),
            "HAlign",
            "left",
            "VAlign",
            "center",
            "ScaleModifier",
            point(650, 650),
            "FoldWhenHidden",
            true,
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
            T(506262611339, "<LeftTrigger><ButtonX>")
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XFrame",
            "IdNode",
            false,
            "HAlign",
            "center",
            "VAlign",
            "center",
            "Image",
            "UI/PDA/os_background_2",
            "FrameBox",
            box(3, 3, 3, 3)
          }, {
            PlaceObj("XTemplateWindow", {
              "__context",
              function(parent, context)
                return "gv_AutoResolveUseOrdnance"
              end,
              "__class",
              "XToggleButton",
              "RolloverTemplate",
              "RolloverGeneric",
              "RolloverAnchor",
              "center-top",
              "RolloverText",
              T(885820202251, [[
Allow the usage of heavy weapons and grenades during auto-resolve.
Increases Power.]]),
              "RolloverOffset",
              box(0, 0, 0, 10),
              "Background",
              RGBA(0, 0, 0, 0),
              "OnContextUpdate",
              function(self, context, ...)
                self:SetToggled(gv_AutoResolveUseOrdnance)
              end,
              "FocusedBackground",
              RGBA(0, 0, 0, 0),
              "OnPress",
              function(self, gamepad)
                gv_AutoResolveUseOrdnance = not gv_AutoResolveUseOrdnance
                self:SetToggled(gv_AutoResolveUseOrdnance)
                GetDialog(self):UpdatePowers()
                XTextButton.OnPress(self)
              end,
              "RolloverBackground",
              RGBA(0, 0, 0, 0),
              "Image",
              "UI/PDA/T_Icon_Zoom_In",
              "ToggledBackground",
              RGBA(255, 255, 255, 255)
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Margins",
            box(8, 0, 0, 0),
            "VAlign",
            "center",
            "TextStyle",
            "ConflictDescriptionDark",
            "OnContextUpdate",
            function(self, context, ...)
              local limit = self.UpdateTimeLimit
              if limit == 0 or limit <= RealTime() - self.last_update_time then
                self:SetText(self.Text)
              elseif not self:GetThread("ContextUpdate") then
                self:CreateThread("ContextUpdate", function(self)
                  Sleep(self.last_update_time + self.UpdateTimeLimit - RealTime())
                  self:OnContextUpdate()
                end, self)
              end
            end,
            "Translate",
            true,
            "Text",
            T(429999545520, "Use ordnance")
          })
        })
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "actionToggleOrdnance",
        "ActionGamepad",
        "LeftTrigger-ButtonX",
        "ActionState",
        function(self, host)
        end,
        "OnAction",
        function(self, host, source, ...)
          gv_AutoResolveUseOrdnance = not gv_AutoResolveUseOrdnance
          ObjModified("gv_AutoResolveUseOrdnance")
        end
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "Open(self)",
        "func",
        function(self)
          XWindow.Open(self)
          RunWhenXWindowIsReady(self, function()
            local popUpTime = 200
            local fadeInTime = 200
            self:AddInterpolation({
              id = "size",
              type = const.intRect,
              duration = popUpTime,
              originalRect = self.box,
              targetRect = self:CalcZoomedBox(800),
              flags = const.intfInverse
            })
            self:AddInterpolation({
              id = "alpha",
              type = const.intAlpha,
              duration = popUpTime,
              startValue = 0,
              endValue = 255
            })
          end)
        end
      })
    })
  })
})
