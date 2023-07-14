PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu Satellite UI",
  id = "SquadsAndMercs",
  PlaceObj("XTemplateWindow", {
    "__class",
    "SquadsAndMercsClass",
    "Id",
    "idPartyContainer",
    "HAlign",
    "left",
    "VAlign",
    "top"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextWindow",
      "Dock",
      "top"
    }, {
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return context
        end,
        "__class",
        "XContextWindow",
        "Id",
        "idTitle",
        "Margins",
        box(-10, -5, 0, 0),
        "VAlign",
        "top",
        "LayoutMethod",
        "VList",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local node = self:ResolveId("node")
          local selectedSquad = node.selected_squad
          local nameWnd = node.idName
          nameWnd:SetContext(selectedSquad)
          nameWnd:SetText(T({
            183209563903,
            "<u(Name)> [<u(SquadMemberCount())>]",
            selectedSquad
          }))
          local moraleUI = self:ResolveId("idMorale")
          local selScale = point(670, 670)
          local unSelScale = point(670, 670)
          local transSel = 0
          local transUnSel = 100
          for i, sB in ipairs(node.idSquadButtons) do
            if sB ~= moraleUI then
              local selected = sB.context and sB.context.UniqueId == g_CurrentSquad
              function sB.OnSetRollover(s, r)
                if not selected then
                  s:SetTransparency(r and 0 or transUnSel)
                end
              end
              if sB.idSelected then
                sB.idSelected:SetVisible(selected)
                sB:SetTransparency(selected and transSel or transUnSel)
                sB:SetScaleModifier(selected and selScale or unSelScale)
              end
            end
          end
        end
      }, {
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return context
          end,
          "__class",
          "XText",
          "Id",
          "idName",
          "Margins",
          box(5, 0, 0, 0),
          "Clip",
          false,
          "UseClipBox",
          false,
          "TextStyle",
          "PartyUISelectedSquad",
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
          true
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idSquadButtons",
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          -10
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "morale icon container",
            "__context",
            function(parent, context)
              return Selection
            end,
            "__condition",
            function(parent, context)
              return IsKindOf(GetDialog(parent), "IModeCommonUnitControl") or IsKindOf(GetDialog(parent), "IModeDeployment")
            end,
            "__class",
            "XContextWindow",
            "RolloverTemplate",
            "RolloverGeneric",
            "RolloverTitle",
            T(329770654888, "Morale"),
            "Id",
            "idMorale",
            "Margins",
            box(7, 1, 0, 0),
            "Dock",
            "left",
            "VAlign",
            "top",
            "FoldWhenHidden",
            true,
            "BackgroundRectGlowSize",
            1,
            "BackgroundRectGlowColor",
            RGBA(32, 35, 47, 255),
            "HandleMouse",
            true,
            "MouseCursor",
            "UI/Cursors/Hand.tga",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local icon = self:ResolveId("idMoraleIcon")
              local team = GetPoVTeam()
              local morale = team and team.morale or 0
              local text = self:ResolveId("idMoraleText")
              text:SetText(morale)
              text:SetVisible(morale ~= 0)
              if team then
                self:SetRolloverText(team:GetMoraleLevelAndEffectsText())
                function self.OnMouseButtonDown()
                  return "break"
                end
              end
              self:SetVisible(not not g_Combat)
            end
          }, {
            PlaceObj("XTemplateWindow", {
              "BorderWidth",
              2,
              "MinWidth",
              80,
              "MinHeight",
              46,
              "MaxWidth",
              80,
              "MaxHeight",
              46,
              "BorderColor",
              RGBA(52, 55, 61, 230),
              "Background",
              RGBA(32, 35, 47, 215)
            }, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "morale indicator",
                "__class",
                "XImage",
                "RolloverTemplate",
                "RolloverGeneric",
                "RolloverOffset",
                box(10, 0, 0, 0),
                "RolloverTitle",
                T(588205032436, "Morale"),
                "Id",
                "idMoraleIcon",
                "IdNode",
                false,
                "HAlign",
                "center",
                "VAlign",
                "center",
                "Image",
                "UI/Hud/morale_normal"
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idMoraleText",
                  "Margins",
                  box(-2, -2, 0, 0),
                  "HAlign",
                  "center",
                  "VAlign",
                  "center",
                  "TextStyle",
                  "PartyUIMoraleText"
                })
              })
            })
          }),
          PlaceObj("XTemplateForEach", {
            "__context",
            function(parent, context, item, i, n)
              return item
            end,
            "run_after",
            function(child, context, item, i, n, last)
              local image = item.image or "UI/Icons/SquadLogo/squad_logo_01"
              child.idSquadIcon:SetImage(image .. "_s")
            end
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XButton",
              "VAlign",
              "top",
              "BorderColor",
              RGBA(0, 0, 0, 0),
              "Background",
              RGBA(0, 0, 0, 0),
              "BackgroundRectGlowColor",
              RGBA(0, 0, 0, 0),
              "OnContextUpdate",
              function(self, context, ...)
              end,
              "FocusedBorderColor",
              RGBA(0, 0, 0, 0),
              "FocusedBackground",
              RGBA(0, 0, 0, 0),
              "DisabledBorderColor",
              RGBA(0, 0, 0, 0),
              "OnPress",
              function(self, gamepad)
                local dlg = GetDialog(self)
                local deploymentOrCommonUnit = IsKindOf(dlg, "IModeCommonUnitControl") or IsKindOf(dlg, "IModeDeployment")
                if deploymentOrCommonUnit and self.context.UniqueId == g_CurrentSquad then
                  ToggleAllUnitsSelectionInSquad(true)
                else
                  local node = self:ResolveId("node")
                  node:SelectSquad(self.context)
                  ObjModified(self.context)
                end
              end,
              "RolloverBackground",
              RGBA(0, 0, 0, 0),
              "PressedBackground",
              RGBA(0, 0, 0, 0)
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Image",
                "UI/Icons/SateliteView/merc_squad_2"
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Id",
                "idSquadIcon",
                "Margins",
                box(0, 4, 0, 0),
                "HAlign",
                "center",
                "VAlign",
                "top",
                "ScaleModifier",
                point(800, 800)
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Id",
                "idSelected",
                "HAlign",
                "center",
                "VAlign",
                "center",
                "Visible",
                false,
                "Image",
                "UI/Icons/SateliteView/squad_selection"
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "OnMouseButtonDoubleClick(self, pt, button)",
                "func",
                function(self, pt, button)
                  if not IsKindOf(GetDialog(self), "XSatelliteDialog") then
                    return
                  end
                  local squad = self.context
                  SatelliteSetCameraDest(squad.CurrentSector, 300)
                end
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "add squad",
            "__condition",
            function(parent, context)
              return not IsKindOf(GetDialog(parent), "IModeDeployment") and GetDialog(GetDialog(parent).parent) ~= GetDialog("FullscreenGameDialogs")
            end,
            "__class",
            "XButton",
            "VAlign",
            "top",
            "ScaleModifier",
            point(666, 666),
            "BorderColor",
            RGBA(0, 0, 0, 0),
            "Background",
            RGBA(0, 0, 0, 0),
            "BackgroundRectGlowColor",
            RGBA(0, 0, 0, 0),
            "Transparency",
            100,
            "FocusedBorderColor",
            RGBA(0, 0, 0, 0),
            "FocusedBackground",
            RGBA(0, 0, 0, 0),
            "DisabledBorderColor",
            RGBA(0, 0, 0, 0),
            "OnPress",
            function(self, gamepad)
              InvokeShortcutAction(GetDialog("PDADialogSatellite"), "idSquadManagement", false, true)
            end,
            "RolloverBackground",
            RGBA(0, 0, 0, 0),
            "PressedBackground",
            RGBA(0, 0, 0, 0)
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Image",
              "UI/Icons/SateliteView/merc_squad_add_2"
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFitContent",
      "IdNode",
      false,
      "Dock",
      "box",
      "Fit",
      "height"
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "Mercs Themselves (Updates on Sel Squad Change)",
        "__context",
        function(parent, context)
          return parent.parent.selected_squad
        end,
        "__class",
        "XContentTemplate",
        "Id",
        "idParty",
        "HAlign",
        "left",
        "VAlign",
        "top",
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 0, 25, 0),
          "Dock",
          "box",
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
        PlaceObj("XTemplateWindow", {
          "Id",
          "idContainer",
          "LayoutMethod",
          "VList",
          "LayoutVSpacing",
          3,
          "UseClipBox",
          false,
          "BorderColor",
          RGBA(0, 0, 0, 0)
        }, {
          PlaceObj("XTemplateGroup", {
            "__condition",
            function(parent, context)
              return context and IsKindOf(GetDialog(parent), "XSatelliteDialog")
            end
          }, {
            PlaceObj("XTemplateForEach", {
              "comment",
              "Mercs in the Current Team",
              "array",
              function(parent, context)
                return context and context.units
              end,
              "__context",
              function(parent, context, item, i, n)
                return gv_UnitData[item]
              end
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "HUDMerc",
                "OnContextUpdate",
                function(self, context, ...)
                  self.idOperationContainer.idProgressBarContainer:SetVisible(context.Operation ~= "Idle")
                end,
                "FXMouseIn",
                "MercPortraitRolloverPDA",
                "FXPress",
                "MercPortraitPressPDA",
                "OnPress",
                function(self, gamepad)
                  local prev
                  if g_SatelliteUI.context_menu then
                    local prev_context = g_SatelliteUI.context_menu[1].context
                    prev = prev_context and prev_context.unit_id
                    g_SatelliteUI:RemoveContextMenu()
                  end
                end,
                "AltPress",
                true,
                "OnAltPress",
                function(self, gamepad)
                  local prev
                  if g_SatelliteUI.context_menu then
                    local prev_context = g_SatelliteUI.context_menu[1].context
                    prev = prev_context and prev_context.unit_id
                    g_SatelliteUI:RemoveContextMenu()
                  end
                  local unit = self.context
                  if prev and prev == unit.session_id then
                    return
                  end
                  local squad_id = unit.Squad
                  local squad = gv_Squads[squad_id]
                  local sector_id = squad and squad.CurrentSector
                  if not sector_id then
                    return
                  end
                  self:SetRollover(false)
                  g_SatelliteUI:OpenContextMenu(self, sector_id, unit.Squad, unit.session_id)
                end,
                "ClassIconOnRollover",
                true
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnMouseButtonDoubleClick(self, pt, button)",
                  "func",
                  function(self, pt, button)
                    local selectedUnit = self.context
                    if not IsKindOf(selectedUnit, "UnitData") or not g_SatelliteUI then
                      return
                    end
                    local squad = selectedUnit.Squad
                    squad = squad and gv_Squads[squad]
                    SatelliteSetCameraDest(squad.CurrentSector, 300)
                  end
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "context menu observer",
                  "__context",
                  function(parent, context)
                    return "satellite_context_menu"
                  end,
                  "__class",
                  "XContextWindow",
                  "ContextUpdateOnOpen",
                  true,
                  "OnContextUpdate",
                  function(self, context, ...)
                    local hasMenu = g_SatelliteUI and g_SatelliteUI.context_menu
                    hasMenu = hasMenu and hasMenu.window_state ~= "destroying" and hasMenu.idContent
                    local isOnMe = hasMenu and hasMenu.context.unit_id == self.parent.context.session_id
                    self.parent:SetSelected(isOnMe)
                  end
                }),
                PlaceObj("XTemplateWindow", {
                  "HAlign",
                  "right",
                  "MaxHeight",
                  105,
                  "LayoutMethod",
                  "VList"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "only shows wounded and tired effect",
                    "__context",
                    function(parent, context)
                      return context.StatusEffects
                    end,
                    "__class",
                    "XContentTemplate",
                    "Id",
                    "idStatusEffectsContainer",
                    "Margins",
                    box(-3, 5, 0, 0),
                    "Dock",
                    "top",
                    "HAlign",
                    "left",
                    "VAlign",
                    "top",
                    "MaxHeight",
                    80,
                    "LayoutMethod",
                    "VList",
                    "LayoutVSpacing",
                    -2,
                    "UseClipBox",
                    false,
                    "FoldWhenHidden",
                    true,
                    "HandleMouse",
                    true,
                    "MouseCursor",
                    "UI/Cursors/Cursor.tga"
                  }, {
                    PlaceObj("XTemplateForEach", {
                      "comment",
                      "status effect",
                      "array",
                      function(parent, context)
                        return table.ifilter(context or empty_table, "ShownSatelliteView")
                      end,
                      "__context",
                      function(parent, context, item, i, n)
                        return item
                      end
                    }, {
                      PlaceObj("XTemplateTemplate", {
                        "__template",
                        "StatusEffectIcon"
                      })
                    }),
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "OnMouseButtonDown(self, pos, button)",
                      "func",
                      function(self, pos, button)
                        return "break"
                      end
                    }),
                    PlaceObj("XTemplateTemplate", {
                      "comment",
                      "contract warning",
                      "__context",
                      function(parent, context)
                        return parent:ResolveId("node").context
                      end,
                      "__template",
                      "MercContractWarningIcon",
                      "Dock",
                      "left"
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "Dock",
                    "bottom",
                    "HAlign",
                    "left",
                    "VAlign",
                    "bottom",
                    "LayoutMethod",
                    "VList",
                    "LayoutVSpacing",
                    2
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XButton",
                      "RolloverTemplate",
                      "PDAOperationRollover",
                      "RolloverAnchor",
                      "right",
                      "RolloverAnchorId",
                      "idContent",
                      "RolloverText",
                      T(963268514062, "placeholder"),
                      "Id",
                      "idOperationContainer",
                      "Margins",
                      box(-5, 4, 0, 0),
                      "Dock",
                      "bottom",
                      "HAlign",
                      "left",
                      "VAlign",
                      "bottom",
                      "MinWidth",
                      30,
                      "MinHeight",
                      30,
                      "MaxWidth",
                      30,
                      "MaxHeight",
                      30,
                      "Background",
                      RGBA(30, 37, 47, 255),
                      "BackgroundRectGlowSize",
                      1,
                      "BackgroundRectGlowColor",
                      RGBA(30, 37, 47, 255),
                      "OnContextUpdate",
                      function(self, context, ...)
                        local sector = context:GetSector()
                        self:SetVisible(true)
                        local operation_id = self.context.Operation
                        local is_operation_started = operation_id == "Idle" or operation_id == "Traveling" or operation_id == "Arriving" or sector and sector.started_operations and sector.started_operations[operation_id]
                        if not is_operation_started then
                          self:SetVisible(false)
                          return
                        end
                        local operation = SectorOperations[self.context.Operation]
                        local icon = operation and operation.icon or ""
                        if self.idOperation.Image ~= icon then
                          self.idOperation:SetImage(icon)
                        end
                        self.idOperation:SetImageColor(GameColors.J)
                        if not context.Squad then
                          return
                        end
                        local progress_top_left, progress_top_right, progress_left, progress_right, progress_bottom = 0, 0, 0, 0, 0
                        local max_progress = context.OperationInitialETA or 0
                        if 0 < max_progress then
                          local current = max_progress - GetOperationTimerETA(context, "prediction")
                          local perc = MulDivRound(current or 0, 100, max_progress)
                          progress_top_right = Min(perc, 12)
                          perc = Max(perc - progress_top_right, 0)
                          progress_right = Min(perc, 25)
                          perc = Max(perc - progress_right, 0)
                          progress_bottom = Min(perc, 25)
                          perc = Max(perc - progress_bottom, 0)
                          progress_left = Min(perc, 25)
                          perc = Max(perc - progress_left, 0)
                          progress_top_left = Min(perc, 13)
                        end
                        self.idTopLeft:SetProgress(progress_top_left)
                        self.idTopRight:SetProgress(progress_top_right)
                        self.idLeft:SetProgress(progress_left)
                        self.idRight:SetProgress(progress_right)
                        self.idBottom:SetProgress(progress_bottom)
                      end,
                      "FocusedBackground",
                      RGBA(30, 37, 47, 255),
                      "OnPress",
                      function(self, gamepad)
                        InvokeShortcutAction(false, "idOperations")
                      end,
                      "RolloverBackground",
                      RGBA(30, 37, 47, 255),
                      "PressedBackground",
                      RGBA(30, 37, 47, 255)
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "comment",
                        "operation icon",
                        "__class",
                        "XImage",
                        "Id",
                        "idOperation",
                        "HAlign",
                        "center",
                        "VAlign",
                        "center",
                        "MinWidth",
                        24,
                        "MinHeight",
                        24,
                        "MaxWidth",
                        24,
                        "MaxHeight",
                        24,
                        "Image",
                        "UI/Icons/unknown_add",
                        "ImageFit",
                        "stretch",
                        "ImageColor",
                        RGBA(61, 122, 153, 255)
                      }),
                      PlaceObj("XTemplateWindow", {
                        "Id",
                        "idProgressBarContainer",
                        "MouseCursor",
                        "UI/Cursors/Pda_Hand.tga"
                      }, {
                        PlaceObj("XTemplateWindow", {
                          "__class",
                          "OperationProgressBarSection",
                          "Id",
                          "idTopLeft",
                          "HAlign",
                          "left",
                          "VAlign",
                          "top",
                          "MinWidth",
                          15,
                          "MinHeight",
                          2,
                          "MaxWidth",
                          15,
                          "MaxHeight",
                          2,
                          "UseClipBox",
                          false,
                          "MaxProgress",
                          13
                        }),
                        PlaceObj("XTemplateWindow", {
                          "__class",
                          "OperationProgressBarSection",
                          "Id",
                          "idTopRight",
                          "Margins",
                          box(15, 0, 0, 0),
                          "HAlign",
                          "left",
                          "VAlign",
                          "top",
                          "MinWidth",
                          15,
                          "MinHeight",
                          2,
                          "MaxWidth",
                          15,
                          "MaxHeight",
                          2,
                          "UseClipBox",
                          false,
                          "MaxProgress",
                          12
                        }),
                        PlaceObj("XTemplateWindow", {
                          "__class",
                          "OperationProgressBarSection",
                          "Id",
                          "idRight",
                          "HAlign",
                          "right",
                          "VAlign",
                          "top",
                          "MinWidth",
                          2,
                          "MinHeight",
                          30,
                          "MaxWidth",
                          2,
                          "MaxHeight",
                          30,
                          "UseClipBox",
                          false,
                          "Horizontal",
                          false,
                          "MaxProgress",
                          25
                        }),
                        PlaceObj("XTemplateWindow", {
                          "__class",
                          "OperationProgressBarSection",
                          "Id",
                          "idBottom",
                          "HAlign",
                          "right",
                          "VAlign",
                          "bottom",
                          "MinWidth",
                          30,
                          "MinHeight",
                          2,
                          "MaxWidth",
                          30,
                          "MaxHeight",
                          2,
                          "UseClipBox",
                          false,
                          "MaxProgress",
                          25
                        }),
                        PlaceObj("XTemplateWindow", {
                          "__class",
                          "OperationProgressBarSection",
                          "Id",
                          "idLeft",
                          "HAlign",
                          "left",
                          "VAlign",
                          "bottom",
                          "MinWidth",
                          2,
                          "MinHeight",
                          30,
                          "MaxWidth",
                          2,
                          "MaxHeight",
                          30,
                          "UseClipBox",
                          false,
                          "Horizontal",
                          false,
                          "MaxProgress",
                          25
                        })
                      }),
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "OnMousePos",
                        "func",
                        function(self, ...)
                          return "break"
                        end
                      }),
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "Open(self)",
                        "func",
                        function(self)
                          self.idTopLeft:SetProgress(0)
                          self.idTopRight:SetProgress(0)
                          self.idLeft:SetProgress(0)
                          self.idRight:SetProgress(0)
                          self.idBottom:SetProgress(0)
                          XContextWindow.Open(self)
                        end
                      })
                    })
                  })
                })
              })
            })
          }),
          PlaceObj("XTemplateGroup", {
            "__condition",
            function(parent, context)
              return GetDialog(GetDialog(parent).parent) == GetDialog("FullscreenGameDialogs")
            end
          }, {
            PlaceObj("XTemplateForEach", {
              "comment",
              "Mercs in the Current Team",
              "array",
              function(parent, context)
                return context and context.units
              end,
              "__context",
              function(parent, context, item, i, n)
                local unit = g_Units[item]
                if unit and InventoryIsCombatMode(unit) then
                  return unit
                end
                return gv_SatelliteView and gv_UnitData[item] or g_Units[item] or gv_UnitData[item]
              end,
              "run_after",
              function(child, context, item, i, n, last)
                child.unit = context
                child:SetContext(child.unit)
                child.idx = i
              end
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "HUDMerc",
                "RolloverAnchorId",
                "idParty",
                "OnContextUpdate",
                function(self, context, ...)
                  HUDMercClass.OnContextUpdate(self, context, ...)
                  self.unit = context
                end,
                "OnPress",
                function(self, gamepad)
                  self:SelectUnit()
                end
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "Open(self)",
                  "func",
                  function(self)
                    local noClr = const.PDAUIColors.noClr
                    self.idContent:SetBackground(noClr)
                    self.idContent:SetBackgroundRectGlowSize(0)
                    local dlg = GetDialog(self)
                    local ctx = self:GetContext()
                    if ctx and dlg.selected_unit and dlg.selected_unit.session_id == ctx.session_id then
                      self:SetSelected(true)
                    end
                    HUDMercClass.Open(self)
                  end
                }),
                PlaceObj("XTemplateFunc", {
                  "name",
                  "SelectUnit(self)",
                  "func",
                  function(self)
                    local dlg = GetDialog(self)
                    local myUnit = self.unit
                    local invUnit = dlg.selected_unit
                    if IsCoOpGame() and not myUnit:IsLocalPlayerControlled() then
                      if InventoryDragItem and InventoryIsValidGiveDistance(InventoryStartDragContext, myUnit) then
                        local args = {
                          item = InventoryDragItem,
                          src_container = InventoryStartDragContext,
                          src_slot = InventoryStartDragSlotName,
                          dest_container = myUnit,
                          dest_slot = GetContainerInventorySlotName(myUnit)
                        }
                        MoveItem(args)
                        CancelDrag(dlg)
                      end
                      return
                    end
                    self:SetSelected(true)
                    if myUnit and invUnit and myUnit.session_id == invUnit.session_id then
                      return
                    end
                    if g_Units[myUnit.session_id] then
                      SelectObj(g_Units[myUnit.session_id])
                    end
                    local win, button
                    if IsEquipSlot(InventoryStartDragSlotName) then
                      local slot_ctrl = dlg:GetSlotByName(InventoryStartDragSlotName)
                      win = slot_ctrl.drag_win
                      button = slot_ctrl.drag_button
                      slot_ctrl.drag_win = false
                      local desktop = slot_ctrl.desktop
                      if desktop:GetMouseCapture() == slot_ctrl then
                        desktop:SetMouseCapture(false)
                      end
                    end
                    local prev_unit_id = invUnit.session_id
                    dlg.selected_unit = myUnit
                    dlg.compare_mode_weaponslot = self.unit.current_weapon == "Handheld A" and 1 or 2
                    local context = dlg:GetContext()
                    context.unit = myUnit
                    dlg:SetContext(context)
                    dlg:OnContextUpdate(context)
                    dlg.idUnitInfo:RespawnContent()
                    dlg:CompareWeaponSetUI()
                    local ctrl_right_area = dlg.idScrollArea
                    for _, wnd in ipairs(ctrl_right_area) do
                      local wcontext = wnd:GetContext()
                      local wnd_id = wnd:GetContext().session_id
                      local is_grayouted = InventoryUIGrayOut(wcontext)
                      wnd:SetTransparency(is_grayouted and 150 or 0)
                      if wnd and wnd_id then
                        if wnd_id == prev_unit_id then
                          wnd.idName:SetHightlighted(false)
                        end
                        if wnd_id == context.unit.session_id then
                          ctrl_right_area:ScrollIntoView(wnd)
                          wnd.idName:SetHightlighted(true)
                        end
                      end
                    end
                    for _, wnd in ipairs(self.parent) do
                      wnd:SetSelected(self == wnd)
                    end
                    if IsEquipSlot(InventoryStartDragSlotName) then
                      local dlg = GetDialog(self)
                      local slot_ctrl = dlg:GetSlotByName(InventoryStartDragSlotName)
                      slot_ctrl.drag_win = win
                      slot_ctrl.drag_button = button
                      DragSource = slot_ctrl
                      slot_ctrl.desktop:SetMouseCapture(slot_ctrl)
                    end
                    if InventoryDragItem then
                      HighlightEquipSlots(InventoryDragItem, true)
                      HighlightWeaponsForAmmo(InventoryDragItem, true)
                    end
                  end
                }),
                PlaceObj("XTemplateFunc", {
                  "name",
                  "IsDropTarget(self, draw_win, pt)",
                  "func",
                  function(self, draw_win, pt)
                    return true
                  end
                }),
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnDropEnter(self, draw_win, pt, drag_source)",
                  "func",
                  function(self, draw_win, pt, drag_source)
                    self:SetRollover(true)
                    local valid, mouse_text = InventoryIsValidGiveDistance(InventoryStartDragContext, self:GetContext())
                    if (not gv_SatelliteView or InventoryIsCombatMode()) and not valid then
                      InventoryShowMouseText(true, mouse_text)
                      return
                    end
                    if InventoryDragItem and g_Combat and IsCoOpGame() and not self.context:IsLocalPlayerControlled() then
                      mouse_text = T(406257152368, "Cannot pick") .. "\n" .. T(341907478094, "Controlled by <OtherPlayerName()>")
                    elseif InventoryDragItem then
                      mouse_text = InventoryGetMoveIsInvalidReason(self.context, InventoryStartDragContext)
                      if not mouse_text then
                        local ap_cost, unit_ap, action_name = GetAPCostAndUnit(InventoryDragItem, InventoryStartDragContext, InventoryStartDragSlotName, self.context, "Inventory", false, false)
                        mouse_text = action_name or ""
                        if InventoryIsCombatMode() and ap_cost and 0 < ap_cost then
                          mouse_text = InventoryFormatAPMouseText(unit_ap, ap_cost, mouse_text)
                        end
                      end
                    end
                    InventoryShowMouseText(not not mouse_text, mouse_text)
                  end
                }),
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnDropLeave(self, drag_win)",
                  "func",
                  function(self, drag_win)
                    self:SetRollover(false)
                    InventoryShowMouseText(false)
                  end
                }),
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnDrop(self, drag_win, pt, drag_source_win)",
                  "func",
                  function(self, drag_win, pt, drag_source_win)
                    self:SelectUnit()
                    return "not valid target"
                  end
                }),
                PlaceObj("XTemplateFunc", {
                  "name",
                  "SetHighlighted(self, selected)",
                  "func",
                  function(self, selected)
                    if type(selected) == "string" then
                      local stat = Presets.MercStat.Default[selected]
                      if stat then
                        local icon = stat.Icon
                        local value = self.context[selected]
                        self.idStatIcon:SetImage(icon)
                        self.idStatCount:SetText(value)
                      else
                        selected = true
                      end
                    end
                    self.highlighted = selected
                    if self.ClassIconOnRollover then
                      self.idClass:SetVisible(self.rollover or selected)
                    end
                    self:SetupStyle(self.rollover or selected)
                  end
                }),
                PlaceObj("XTemplateFunc", {
                  "name",
                  "SetupStyle(self, rollover)",
                  "func",
                  function(self, rollover)
                    if not self.idContent then
                      return
                    end
                    local selected = self.selected or self.highlighted or rollover
                    local noClr = const.PDAUIColors.noClr
                    local selectedColored = const.HUDUIColors.selectedColored
                    local defaultColor = const.HUDUIColors.defaultColor
                    self.idContent:SetImage(selected and "UI/PDA/os_portrait_selection" or "")
                    self.idBottomPart:SetBackground(selected and noClr or defaultColor)
                    self.idBottomPart:SetBackgroundRectGlowColor(selected and noClr or defaultColor)
                    self.idContent:SetBackground(selected and RGBA(255, 255, 255, 255) or noClr)
                    if type(self.highlighted) == "string" then
                      self.idBar:SetVisible(false)
                      self.idStatHighlight:SetVisible(true)
                    else
                      self.idBar:SetVisible(true)
                      self.idStatHighlight:SetVisible(false)
                    end
                    local name = self:ResolveId("idName")
                    if name then
                      self.idName:SetTextStyle(selected and "PDAMercNameCard" or "PDAMercNameCard_Light")
                    end
                    if self.idAPIndicator then
                      self.idAPIndicator:SetBackground(selected and selectedColored or defaultColor)
                      self.idAPIndicator:SetBackgroundRectGlowSize(selected and 0 or 1)
                      self.idAPIndicator:SetBackgroundRectGlowColor(selected and selectedColored or defaultColor)
                      self.idAPText:SetTextStyle(selected and "HUDHeaderDark" or "HUDHeader")
                    end
                  end
                }),
                PlaceObj("XTemplateFunc", {
                  "name",
                  "SetSelected(self, selected)",
                  "func",
                  function(self, selected)
                    self.selected = selected
                    self:SetupStyle()
                  end
                }),
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnSetRollover(self, rollover)",
                  "func",
                  function(self, rollover)
                    HUDMercClass.OnSetRollover(self, rollover)
                    self:SetupStyle(rollover)
                  end
                }),
                PlaceObj("XTemplateWindow", {
                  "__parent",
                  function(parent, context)
                    return parent.idPortraitBG
                  end,
                  "Id",
                  "idStatHighlight",
                  "Dock",
                  "box",
                  "VAlign",
                  "bottom",
                  "FoldWhenHidden",
                  true,
                  "DrawOnTop",
                  true
                }, {
                  PlaceObj("XTemplateWindow", {
                    "HAlign",
                    "left",
                    "VAlign",
                    "bottom",
                    "LayoutMethod",
                    "HList"
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "Padding",
                      box(2, 2, 2, 2),
                      "HAlign",
                      "right",
                      "VAlign",
                      "bottom",
                      "MinWidth",
                      24,
                      "MinHeight",
                      24,
                      "MaxWidth",
                      24,
                      "MaxHeight",
                      24,
                      "Background",
                      RGBA(32, 35, 47, 255),
                      "BackgroundRectGlowColor",
                      RGBA(32, 35, 47, 255)
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XImage",
                        "Id",
                        "idStatIcon",
                        "Image",
                        "UI/Icons/st_marksmanship",
                        "ImageFit",
                        "stretch",
                        "ImageColor",
                        RGBA(130, 128, 120, 255)
                      })
                    }),
                    PlaceObj("XTemplateWindow", {
                      "HAlign",
                      "right",
                      "VAlign",
                      "bottom",
                      "MinWidth",
                      24,
                      "MinHeight",
                      24,
                      "MaxHeight",
                      24,
                      "Background",
                      RGBA(32, 35, 47, 255),
                      "BackgroundRectGlowColor",
                      RGBA(32, 35, 47, 255)
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idStatCount",
                        "HAlign",
                        "center",
                        "VAlign",
                        "center",
                        "FoldWhenHidden",
                        true,
                        "TextStyle",
                        "HUDHeaderSmallLight",
                        "ContextUpdateOnOpen",
                        true
                      })
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {"HAlign", "right"}, {
                  PlaceObj("XTemplateWindow", {
                    "Id",
                    "idStatusHighlighter",
                    "VAlign",
                    "top",
                    "LayoutMethod",
                    "VList",
                    "Visible",
                    false,
                    "FoldWhenHidden",
                    true
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "comment",
                      "only shows wounded effect",
                      "__context",
                      function(parent, context)
                        return context.StatusEffects
                      end,
                      "__class",
                      "XContentTemplate",
                      "Id",
                      "idStatusEffectsContainer",
                      "Margins",
                      box(0, 5, 0, 0),
                      "HAlign",
                      "left",
                      "VAlign",
                      "top",
                      "LayoutMethod",
                      "VWrap",
                      "LayoutVSpacing",
                      -2,
                      "UseClipBox",
                      false,
                      "FoldWhenHidden",
                      true
                    }, {
                      PlaceObj("XTemplateForEach", {
                        "comment",
                        "status effect",
                        "array",
                        function(parent, context)
                          return context.Wounded and {
                            context[context.Wounded]
                          } or empty_table
                        end,
                        "condition",
                        function(parent, context, item, i)
                          return item
                        end,
                        "__context",
                        function(parent, context, item, i, n)
                          return item
                        end
                      }, {
                        PlaceObj("XTemplateTemplate", {
                          "__condition",
                          function(parent, context)
                            return context
                          end,
                          "__template",
                          "StatusEffectIcon",
                          "VAlign",
                          "top"
                        })
                      })
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__condition",
                    function(parent, context)
                      return IsKindOf(context, "Unit") and g_Combat
                    end,
                    "VAlign",
                    "bottom",
                    "LayoutMethod",
                    "VList",
                    "LayoutVSpacing",
                    2
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "Id",
                      "idAPIndicator",
                      "Margins",
                      box(-5, 0, 0, 0),
                      "Padding",
                      box(2, 2, 2, 2),
                      "HAlign",
                      "left",
                      "VAlign",
                      "bottom",
                      "MinWidth",
                      30,
                      "MinHeight",
                      30,
                      "MaxWidth",
                      30,
                      "MaxHeight",
                      30,
                      "Background",
                      RGBA(230, 222, 203, 255),
                      "BackgroundRectGlowColor",
                      RGBA(230, 222, 203, 255)
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idAPText",
                        "HAlign",
                        "center",
                        "VAlign",
                        "center",
                        "FoldWhenHidden",
                        true,
                        "TextStyle",
                        "HUDHeaderDark",
                        "ContextUpdateOnOpen",
                        true,
                        "OnContextUpdate",
                        function(self, context, ...)
                          if not IsKindOf(context, "Unit") then
                            return
                          end
                          self.parent:SetVisible(not not g_Combat and not context:IsDead() and not context:IsDowned())
                          self:SetText(self.Text)
                          XContextControl.OnContextUpdate(self, context)
                        end,
                        "Translate",
                        true,
                        "Text",
                        T(219068997732, "<apn(GetUIActionPoints())>")
                      })
                    })
                  })
                })
              })
            })
          }),
          PlaceObj("XTemplateGroup", {
            "__condition",
            function(parent, context)
              return IsKindOf(GetDialog(parent), "IModeCommonUnitControl") or IsKindOf(GetDialog(parent), "IModeDeployment")
            end
          }, {
            PlaceObj("XTemplateForEach", {
              "comment",
              "Mercs in the Current Team",
              "array",
              function(parent, context)
                return context and context.units
              end,
              "condition",
              function(parent, context, item, i)
                return IsKindOf(item, "Unit") and item.team and item.team.control == "UI"
              end,
              "__context",
              function(parent, context, item, i, n)
                return item
              end
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "HUDMerc",
                "OnContextUpdate",
                function(self, context, ...)
                  local unit = self.context
                  local unitSelected = not not table.find(Selection, unit)
                  self:SetSelected(Selection[1] == unit and "full" or unitSelected)
                  self:SetupStyle()
                  local showActionInfo = SelectedObj and IsCombatActionForAlly(GetDialog(self).action)
                  self.dontShowRollover = showActionInfo
                end,
                "OnPress",
                function(self, gamepad)
                  local selectedUnit = self.context
                  local igim = GetInGameInterfaceModeDlg()
                  if IsCombatActionForAlly(igim.action) and igim.action.ActionType ~= "Ranged Attack" and igim.action.ActionType ~= "Melee Attack" then
                    if SelectedObj and not SelectedObj.move_attack_target then
                      local targets = igim.action:GetTargets({
                        SelectedObj
                      })
                      if table.find(targets, selectedUnit) then
                        local _, err = CanBandageUI(SelectedObj, {target = selectedUnit})
                        if igim.action:GetUIState({
                          SelectedObj
                        }) == "enabled" and not err then
                          igim:StartMoveAndAttack(SelectedObj, igim.action, selectedUnit, SelectedObj:GetClosestMeleeRangePos(selectedUnit), {target = selectedUnit})
                        end
                      end
                    end
                    return "break"
                  end
                  local canBeControlled, reason = selectedUnit:CanBeControlled()
                  if not canBeControlled and reason ~= "not_local_turn" then
                    return "break"
                  end
                  if not (selectedUnit ~= SelectedObj or IsPointInsidePoly2D(selectedUnit:GetVisualPos(), CalcCombatZone())) or cameraTac.GetFloor() ~= GetFloorOfPos(SnapToPassSlab(selectedUnit)) then
                    SnapCameraToObj(selectedUnit, nil, GetFloorOfPos(SnapToPassSlab(selectedUnit)))
                  end
                  if g_Combat and not gv_DeploymentStarted and not IsKindOf(igim, "IModeCombatMovement") then
                    SetInGameInterfaceMode("IModeCombatMovement")
                    SelectObj(selectedUnit)
                  elseif IsKindOf(igim, "IModeExploration") then
                    igim:HandleUnitSelection({selectedUnit})
                  else
                    SelectObj(selectedUnit)
                  end
                  return "break"
                end,
                "AltPress",
                true,
                "OnAltPress",
                function(self, gamepad)
                  local selectedUnit = self.context
                  local igim = GetInGameInterfaceModeDlg()
                  local squad = gv_Squads[self.context.Squad]
                  local context = {
                    sector_id = squad.CurrentSector,
                    squad_id = squad.UniqueId,
                    actions = {
                      "idInventory",
                      "actionOpenCharacterContextMenu",
                      "actionLevelUpViewContextMenu"
                    },
                    unit_id = selectedUnit.session_id
                  }
                  local ctxMenu = XTemplateSpawn("SatelliteViewMapContextMenu", igim, context)
                  ctxMenu:SetZOrder(999)
                  ctxMenu:SetAnchor(self.box)
                  ctxMenu:Open()
                  self.desktop:SetModalWindow(ctxMenu)
                end,
                "ClassIconOnRollover",
                true
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnMouseButtonDoubleClick(self, pt, button)",
                  "func",
                  function(self, pt, button)
                    local selectedUnit = self.context
                    if not IsKindOf(selectedUnit, "Unit") or ActionCameraPlaying then
                      return
                    end
                    SnapCameraToObj(selectedUnit, "force", GetFloorOfPos(SnapToPassSlab(selectedUnit)))
                  end
                }),
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnSetRollover(self, rollover)",
                  "func",
                  function(self, rollover)
                    local context = self.context
                    local igim = GetInGameInterfaceModeDlg()
                    if igim and IsCombatActionForAlly(igim.action) then
                      if igim.action.id == "Bandage" then
                        local _, err = CanBandageUI(SelectedObj, {target = context})
                        local bandageError = err and Untranslated(_InternalTranslate(err, {
                          flavor = "",
                          ["/flavor"] = ""
                        }))
                        SetAPIndicator(bandageError and 0 or false, "bandage-error", bandageError, nil, "force")
                        context:SetHighlightReason("bandage-target", not err)
                      end
                      SetAPIndicator(false, "melee-attack")
                      SetAPIndicator(false, "unreachable")
                    end
                    local noRollover = context:IsDead() or not context:IsLocalPlayerControlled()
                    if rollover and not noRollover then
                      SetActiveBadgeExclusive(self.context)
                    elseif context.ui_badge then
                      context.ui_badge:SetActive(false, "exclusive")
                      context:SetHighlightReason("bandage-target", false)
                    end
                    if noRollover then
                      rollover = false
                    end
                    HUDMercClass.OnSetRollover(self, rollover)
                  end
                }),
                PlaceObj("XTemplateFunc", {
                  "name",
                  "SetupStyle(self, ...)",
                  "func",
                  function(self, ...)
                    if IsKindOf(GetDialog(self.parent), "IModeDeployment") then
                      local deployed = IsUnitDeployed(self.context)
                      if not deployed then
                        self.idPortrait:SetEnabled(false)
                        self.idBar.HPColor = GameColors.D
                      else
                        self.idPortrait:SetEnabled(true)
                        self.idBar.HPColor = GameColors.Player
                      end
                    end
                    HUDMercClass.SetupStyle(self, ...)
                  end
                }),
                PlaceObj("XTemplateFunc", {
                  "name",
                  "GetMouseCursor(self)",
                  "func",
                  function(self)
                    local igim = GetInGameInterfaceModeDlg()
                    if igim.action and igim.action.id == "Bandage" then
                      if CanBandageUI(SelectedObj, {
                        target = self.context
                      }) then
                        return "UI/Cursors/Healing_on.tga"
                      else
                        return "UI/Cursors/Healing_off.tga"
                      end
                    end
                    return "UI/Cursors/Hand.tga"
                  end
                }),
                PlaceObj("XTemplateWindow", {
                  "HAlign",
                  "right",
                  "VAlign",
                  "bottom",
                  "LayoutMethod",
                  "VList"
                }, {
                  PlaceObj("XTemplateWindow", nil, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XImage",
                      "RolloverTemplate",
                      "RolloverGeneric",
                      "RolloverAnchor",
                      "right",
                      "RolloverText",
                      T(563596618440, "Wounds are being bandaged."),
                      "RolloverOffset",
                      box(15, 0, 0, 0),
                      "Id",
                      "idBeingBandagedIndicator",
                      "HAlign",
                      "center",
                      "VAlign",
                      "top",
                      "MinWidth",
                      25,
                      "MinHeight",
                      25,
                      "MaxWidth",
                      25,
                      "MaxHeight",
                      25,
                      "Visible",
                      false,
                      "HandleMouse",
                      true,
                      "Image",
                      "UI/Hud/hud_bandaging",
                      "ImageFit",
                      "stretch",
                      "ImageScale",
                      point(900, 900)
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__context",
                      function(parent, context)
                        return context.StatusEffects
                      end,
                      "__class",
                      "XContentTemplate",
                      "Id",
                      "idWounded",
                      "Margins",
                      box(3, 0, 0, 0),
                      "LayoutMethod",
                      "HList",
                      "HandleMouse",
                      true,
                      "MouseCursor",
                      "UI/Cursors/Cursor.tga"
                    }, {
                      PlaceObj("XTemplateTemplate", {
                        "__context",
                        function(parent, context)
                          return table.find_value(context, "class", "Wounded")
                        end,
                        "__condition",
                        function(parent, context)
                          return not not context
                        end,
                        "__template",
                        "StatusEffectIcon"
                      }),
                      PlaceObj("XTemplateTemplate", {
                        "__context",
                        function(parent, context)
                          return table.find_value(context, "class", "Tired") or table.find_value(context, "class", "Exhausted")
                        end,
                        "__condition",
                        function(parent, context)
                          return not not context
                        end,
                        "__template",
                        "StatusEffectIcon"
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
                    "__context",
                    function(parent, context)
                      return "combat_bar_enemies"
                    end,
                    "__condition",
                    function(parent, context)
                      return not IsKindOf(GetDialog(parent), "IModeDeployment")
                    end,
                    "__class",
                    "XContextWindow",
                    "RolloverTemplate",
                    "RolloverGeneric",
                    "RolloverAnchor",
                    "right",
                    "RolloverOffset",
                    box(10, 0, 0, 0),
                    "IdNode",
                    true,
                    "HAlign",
                    "left",
                    "VAlign",
                    "bottom",
                    "ContextUpdateOnOpen",
                    true,
                    "OnContextUpdate",
                    function(self, context, ...)
                      local partyMemberWnd = self:ResolveId("node")
                      local member = partyMemberWnd.context
                      local targets = GetTargetsToShowInPartyUI(member)
                      local targetCount = #targets
                      self:SetVisible(0 < targetCount and not gv_Deployment)
                      rawset(self[1], "enemies", targets)
                      self:SetRolloverText(T({
                        914820786173,
                        "Visible Enemies: <enemyCount>",
                        enemyCount = targetCount
                      }))
                      self.idCount:SetText(targetCount)
                    end
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XImage",
                      "IdNode",
                      false,
                      "HandleMouse",
                      true,
                      "Image",
                      "UI/Hud/enemies_in_range",
                      "Columns",
                      2,
                      "ImageScale",
                      point(900, 900)
                    }, {
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "OnMouseButtonDown(self, pos, button)",
                        "func",
                        function(self, pos, button)
                          local enemies = rawget(self, "enemies")
                          if not enemies or #enemies == 0 then
                            return
                          end
                          local lastTarget = rawget(self, "target")
                          if not lastTarget or lastTarget == #enemies then
                            lastTarget = 0
                          end
                          lastTarget = lastTarget + 1
                          rawset(self, "target", lastTarget)
                          SnapCameraToObj(enemies[lastTarget], nil, GetFloorOfPos(SnapToPassSlab(enemies[lastTarget])))
                          return "break"
                        end
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idCount",
                        "HAlign",
                        "right",
                        "VAlign",
                        "top",
                        "Clip",
                        false,
                        "UseClipBox",
                        false,
                        "FoldWhenHidden",
                        true,
                        "TextStyle",
                        "VisibleEnemiesUICount"
                      })
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "Id",
                    "idAPIndicator",
                    "Margins",
                    box(-5, 0, 0, 0),
                    "Padding",
                    box(2, 2, 2, 2),
                    "HAlign",
                    "left",
                    "VAlign",
                    "bottom",
                    "MinWidth",
                    30,
                    "MinHeight",
                    30,
                    "MaxWidth",
                    30,
                    "MaxHeight",
                    30,
                    "Background",
                    RGBA(230, 222, 203, 255),
                    "BackgroundRectGlowColor",
                    RGBA(230, 222, 203, 255)
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "Id",
                      "idAPText",
                      "HAlign",
                      "center",
                      "VAlign",
                      "center",
                      "FoldWhenHidden",
                      true,
                      "TextStyle",
                      "HUDHeaderDark",
                      "ContextUpdateOnOpen",
                      true,
                      "OnContextUpdate",
                      function(self, context, ...)
                        if not IsKindOf(context, "Unit") then
                          return
                        end
                        self.parent:SetVisible(not not g_Combat and not context:IsDead() and not context:IsDowned())
                        self:SetText(self.Text)
                        XContextControl.OnContextUpdate(self, context)
                      end,
                      "Translate",
                      true,
                      "Text",
                      T(219068997732, "<apn(GetUIActionPoints())>")
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XImage",
                      "Id",
                      "idBandageIndicator",
                      "Visible",
                      false,
                      "Image",
                      "UI/Hud/Status effects/treating",
                      "ImageFit",
                      "stretch"
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__condition",
                    function(parent, context)
                      return IsKindOf(GetDialog(parent), "IModeDeployment")
                    end,
                    "RolloverTemplate",
                    "SmallRolloverGeneric",
                    "RolloverAnchor",
                    "top",
                    "RolloverText",
                    T(337393247430, "\208\144waiting deployment"),
                    "RolloverOffset",
                    box(-15, 0, 0, -15),
                    "Id",
                    "idDeployed",
                    "Margins",
                    box(-5, 0, 0, -5),
                    "HAlign",
                    "right",
                    "VAlign",
                    "bottom",
                    "HandleMouse",
                    true
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XContextImage",
                      "FoldWhenHidden",
                      true,
                      "Image",
                      "UI/Hud/notification",
                      "ContextUpdateOnOpen",
                      true,
                      "OnContextUpdate",
                      function(self, context, ...)
                        if not IsKindOf(context, "Unit") then
                          return
                        end
                        local deployed = IsUnitDeployed(context)
                        self.parent:SetVisible(not deployed)
                        XContextControl.OnContextUpdate(self, context)
                      end
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "sus bar",
                  "__parent",
                  function(parent, context)
                    return parent.idBottomPart
                  end,
                  "__condition",
                  function(parent, context)
                    return not g_Combat
                  end,
                  "__class",
                  "SmoothBar",
                  "Margins",
                  box(0, 0, 0, -3),
                  "Dock",
                  "top",
                  "VAlign",
                  "top",
                  "MinHeight",
                  3,
                  "MaxHeight",
                  3,
                  "Background",
                  RGBA(52, 55, 61, 255),
                  "BindTo",
                  "suspicion",
                  "FillColor",
                  RGBA(222, 60, 75, 255)
                }, {
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "Open(self)",
                    "func",
                    function(self)
                      self.MaxValue = SuspicionThreshold
                      SmoothBar.Open(self)
                    end
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "sus indicator",
                  "__context",
                  function(parent, context)
                    return "UnitsSusBeingRaised"
                  end,
                  "__parent",
                  function(parent, context)
                    return parent.idPortraitBG
                  end,
                  "__condition",
                  function(parent, context)
                    return not g_Combat
                  end,
                  "__class",
                  "XContextImage",
                  "Id",
                  "idSusIndicator",
                  "Margins",
                  box(0, 0, 5, 0),
                  "HAlign",
                  "right",
                  "MinWidth",
                  15,
                  "MinHeight",
                  20,
                  "MaxWidth",
                  15,
                  "MaxHeight",
                  20,
                  "Visible",
                  false,
                  "DrawOnTop",
                  true,
                  "Image",
                  "UI/Hud/enemy_detection",
                  "ImageFit",
                  "width",
                  "ContextUpdateOnOpen",
                  true,
                  "OnContextUpdate",
                  function(self, context, ...)
                    local obj = self:ResolveId("node")
                    obj = obj and obj.context
                    self:SetVisible(UnitsSusBeingRaised and obj and UnitsSusBeingRaised[obj.handle])
                  end
                })
              })
            })
          })
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "RespawnContent(self, ...)",
          "func",
          function(self, ...)
            if not self:IsVisible() and not GetParentOfKind(self, "PDAClass") then
              return
            end
            if UIRebuildSpam then
              DbgUIRebuild("party inner")
            end
            XContentTemplate.RespawnContent(self)
          end
        })
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "UpdateMeasure(self, max_width, max_height)",
        "func",
        function(self, max_width, max_height)
          if not self.measure_update then
            return
          end
          self:SetScaleModifier(point(1000, 1000))
          local _, yM = ScaleXY(self.parent.scale, 0, 150)
          max_height = max_height - yM
          XControl.UpdateMeasure(self, max_width, max_height)
          if max_height > self.measure_height then
            return
          end
          local one = point(1000, 1000)
          for _, child in ipairs(self) do
            child:SetOutsideScale(one)
          end
          self.scale = one
          XControl.UpdateMeasure(self, 1000000, 1000000)
          local content_width, content_height = ScaleXY(self.parent.scale, self.measure_width, self.measure_height)
          if content_width == 0 or content_height == 0 then
            XControl.UpdateMeasure(self, max_width, max_height)
            return
          end
          local scale_x = max_width * 1000 / content_width
          local scale_y = max_height * 1000 / content_height
          scale_x = scale_y
          self:SetScaleModifier(point(scale_x, scale_y))
          XControl.UpdateMeasure(self, max_width, max_height)
        end
      })
    })
  })
})
