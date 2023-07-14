PlaceObj("XTemplate", {
  group = "Zulu",
  id = "CoopMercsManagement",
  PlaceObj("XTemplateWindow", {
    "__class",
    "ZuluModalDialog",
    "Background",
    RGBA(30, 30, 35, 115),
    "ContextUpdateOnOpen",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      self.idContent:OnContextUpdate(self, GetSquadCoopManagementSquads())
      self.idDlg:OnContextUpdate(context)
      self.selected_merc = context
      self.selected_mercs[self.selected_merc] = true
    end,
    "GamepadVirtualCursor",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XHideDialogs",
      "LeaveDialogIds",
      {"Intro"}
    }),
    PlaceObj("XTemplateLayer", {
      "layer",
      "XCameraLockLayer"
    }),
    PlaceObj("XTemplateLayer", {
      "layer",
      "XPauseLayer"
    }),
    PlaceObj("XTemplateWindow", {
      "__condition",
      function(parent, context)
        return not gv_SatelliteView
      end,
      "__class",
      "XBlurRect",
      "TintColor",
      RGBA(255, 255, 255, 255),
      "BlurRadius",
      15,
      "Desaturation",
      80
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        SetCampaignSpeed(0, GetUICampaignPauseReason("CoopUI"))
        if g_SatelliteUI then
          g_SatelliteUI:SetSuppressSectorVisualUpdates(true)
        end
        self.selected_mercs = {}
        self.selected_merc = false
        self.selected_merc_ctrls = {}
        ZuluModalDialog.Open(self, ...)
        CreateRealTimeThread(function()
          if GetDialog("InGameMenu") then
            self:SetVisible(false)
          end
          while GetDialog("InGameMenu") do
            Sleep(10)
          end
          self:SetVisible(true)
        end)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Close",
      "func",
      function(self, ...)
        XDialog.Close(self, ...)
        ObjModified("coop button")
        ObjModified("co-op-ui")
        SetCampaignSpeed(nil, GetUICampaignPauseReason("CoopUI"))
        if g_SatelliteUI then
          g_SatelliteUI:SetSuppressSectorVisualUpdates(false)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SelectMerc(self, merc, ctrl)",
      "func",
      function(self, merc, ctrl)
        local merc_id = merc.session_id
        local prev = self.selected_merc
        if prev then
          local ctrl = self.selected_merc_ctrls[prev]
          self.selected_mercs[prev] = false
          self.selected_merc = false
          if ctrl.window_state ~= "destroying" then
            ctrl:SetSelected(false)
          end
        end
        if prev ~= merc_id then
          self.selected_mercs[merc_id] = true
          self.selected_merc = merc_id
          ctrl:SetSelected(self.selected_merc and "full")
        end
        if NetIsHost() then
          self.idActionBar:OnUpdateActions()
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idGive",
      "ActionName",
      T(347076926373, "Give"),
      "ActionToolbar",
      "ActionBarCenter",
      "ActionShortcut",
      "Insert",
      "ActionGamepad",
      "ButtonY",
      "ActionState",
      function(self, host)
        if not host.selected_merc then
          return "disabled"
        end
        local sel = host.selected_merc
        local unit = gv_SatelliteView and gv_UnitData[sel] or g_Units[sel] or gv_UnitData[sel]
        return unit and unit.ControlledBy == 1 and "enabled" or "hidden"
      end,
      "OnAction",
      function(self, host, source, ...)
        AssignMercControl(host.selected_merc, true)
      end,
      "__condition",
      function(parent, context)
        return NetIsHost()
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idTake",
      "ActionName",
      T(273444338004, "Take"),
      "ActionToolbar",
      "ActionBarCenter",
      "ActionShortcut",
      "Insert",
      "ActionGamepad",
      "ButtonY",
      "ActionState",
      function(self, host)
        if not host.selected_merc then
          return "hidden"
        end
        local sel = host.selected_merc
        local unit = gv_SatelliteView and gv_UnitData[sel] or g_Units[sel] or gv_UnitData[sel]
        return unit and unit.ControlledBy == 2 and "enabled" or "hidden"
      end,
      "OnAction",
      function(self, host, source, ...)
        AssignMercControl(host.selected_merc, false)
      end,
      "__condition",
      function(parent, context)
        return NetIsHost()
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idClose",
      "ActionName",
      T(749856723587, "Close"),
      "ActionToolbar",
      "ActionBarCenter",
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "ButtonB",
      "OnActionEffect",
      "close",
      "OnAction",
      function(self, host, source, ...)
        host:Close()
        NetEvent("CloseCoopMercsManagement")
        RefreshMercSelection()
      end,
      "__condition",
      function(parent, context)
        return NetIsHost()
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextWindow",
      "Id",
      "idDlg",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      680,
      "MinHeight",
      220,
      "MaxWidth",
      680,
      "Background",
      RGBA(52, 55, 61, 220),
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local host = NetIsHost()
        local count = CountCoopUnits(2)
        local text = ""
        if host then
          text = 0 < count and T({
            901871139404,
            " Partner's Mercs <count>",
            count = count
          }) or T(881798518541, "Partner has no mercs")
        else
          text = T({
            697391024819,
            "Mercs you can control <count>",
            count = count
          })
        end
        local node = self:ResolveId("node")
        node.idControlText:SetText(text)
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idTitle",
        "Margins",
        box(14, 5, 0, 0),
        "TextStyle",
        "PDAActivitiesSubTitleDark",
        "Translate",
        true,
        "Text",
        T(420527131948, "Mercs Control")
      }),
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return NetIsHost()
        end,
        "__class",
        "XText",
        "Id",
        "idControlText",
        "Margins",
        box(0, 7, 14, 0),
        "HAlign",
        "right",
        "TextStyle",
        "CombatTask_MercName",
        "Translate",
        true,
        "Text",
        T(124457191657, "Partner has no mercs")
      }),
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return not NetIsHost()
        end,
        "__class",
        "XText",
        "Id",
        "idControlText",
        "Margins",
        box(0, 7, 14, 0),
        "HAlign",
        "right",
        "TextStyle",
        "CombatTask_MercName",
        "Translate",
        true,
        "Text",
        T(775562201682, "Mercs you can control ")
      }),
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return GetSquadCoopManagementSquads()
        end,
        "__class",
        "XContentTemplate",
        "Id",
        "idContent",
        "Margins",
        box(14, 40, 14, 40),
        "Background",
        RGBA(32, 35, 47, 200)
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "squad list",
          "Margins",
          box(0, 5, 0, 5),
          "HAlign",
          "left",
          "MinWidth",
          670,
          "MaxWidth",
          670
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "SnappingScrollArea",
            "Id",
            "idSquadsList",
            "Margins",
            box(14, 0, 0, 0),
            "LayoutVSpacing",
            10,
            "VScroll",
            "idMercScroll"
          }, {
            PlaceObj("XTemplateForEach", {
              "comment",
              "player squad",
              "__context",
              function(parent, context, item, i, n)
                return item
              end,
              "run_after",
              function(child, context, item, i, n, last)
                child:SetId("idSquad_" .. context.squad.UniqueId)
                local sector = context.squad.CurrentSector
                local sectorColor = GetSectorControlColor(gv_Sectors[sector].Side)
                child.idSector:SetText(T({
                  764093693143,
                  "<SectorIdColored(id)>",
                  id = sector
                }))
                child.idSectorBG:SetBackground(sectorColor)
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContextWindow",
                "IdNode",
                true,
                "LayoutMethod",
                "HList",
                "LayoutHSpacing",
                10
              }, {
                PlaceObj("XTemplateCode", {
                  "run",
                  function(self, parent, context)
                    local sector = context.squad and context.squad.CurrentSector
                    local sectorObj = gv_Sectors[sector]
                    if sectorObj and sectorObj.conflict then
                      rawset(parent, "disabled", true)
                    end
                  end
                }),
                PlaceObj("XTemplateWindow", {
                  "Background",
                  RGBA(255, 255, 255, 0)
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XContextWindow",
                    "Id",
                    "idSquad",
                    "Margins",
                    box(0, 13, 0, 4),
                    "HAlign",
                    "left",
                    "MinWidth",
                    80,
                    "MaxWidth",
                    80
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "Id",
                      "idSectorBG",
                      "HAlign",
                      "left",
                      "VAlign",
                      "top",
                      "MinWidth",
                      21,
                      "MinHeight",
                      21,
                      "MaxHeight",
                      21,
                      "DrawOnTop",
                      true
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idSector",
                        "Padding",
                        box(4, 2, 4, 2),
                        "HAlign",
                        "center",
                        "VAlign",
                        "center",
                        "FoldWhenHidden",
                        true,
                        "TextStyle",
                        "PDASM_SectorName",
                        "Translate",
                        true,
                        "TextHAlign",
                        "center",
                        "TextVAlign",
                        "center"
                      })
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__context",
                      function(parent, context)
                        return context.squad
                      end,
                      "__class",
                      "XContextWindow",
                      "Margins",
                      box(0, 7, 0, 0),
                      "HAlign",
                      "center",
                      "VAlign",
                      "top",
                      "LayoutMethod",
                      "VList"
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XContextImage",
                        "Id",
                        "idCenter",
                        "IdNode",
                        false,
                        "UseClipBox",
                        false,
                        "Image",
                        "UI/PDA/T_Icon_EnemySquadPlaceholder_L",
                        "ImageScale",
                        point(900, 900),
                        "ImageColor",
                        RGBA(130, 128, 120, 255),
                        "ContextUpdateOnOpen",
                        true,
                        "OnContextUpdate",
                        function(self, context, ...)
                          self:SetImage(context.image)
                        end
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "AutoFitText",
                        "Id",
                        "idSquadName",
                        "Margins",
                        box(5, 5, 5, 0),
                        "HAlign",
                        "center",
                        "FoldWhenHidden",
                        true,
                        "TextStyle",
                        "PDASM_SectorName",
                        "ContextUpdateOnOpen",
                        true,
                        "OnContextUpdate",
                        function(self, context, ...)
                          self:SetText(context.ShortName or SquadName:GetShortNameFromName(context.Name))
                        end,
                        "Translate",
                        true
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Id",
                        "idPower",
                        "Margins",
                        box(0, 0, -3, 0),
                        "HAlign",
                        "center",
                        "Visible",
                        false,
                        "FoldWhenHidden",
                        true,
                        "TextStyle",
                        "PDASM_SectorName",
                        "ContextUpdateOnOpen",
                        true,
                        "OnContextUpdate",
                        function(self, context, ...)
                          local power = GetSquadPower(context)
                          self:SetText(T({
                            597346735330,
                            "<power> <style PDASM_PowerFlavor>P</style>",
                            power = power
                          }))
                          self:SetVisible(gv_Cheats.ShowSquadsPower)
                        end,
                        "Translate",
                        true
                      })
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XContentTemplate",
                  "LayoutMethod",
                  "HList"
                }, {
                  PlaceObj("XTemplateForEach", {
                    "map",
                    function(parent, context, array, i)
                      if not array then
                        return "empty"
                      end
                      local unit = gv_SatelliteView and gv_UnitData[array[i]] or g_Units[array[i]] or gv_UnitData[array[i]] or "empty"
                      return unit
                    end,
                    "__context",
                    function(parent, context, item, i, n)
                      return item
                    end
                  }, {
                    PlaceObj("XTemplateTemplate", {
                      "__condition",
                      function(parent, context)
                        return context ~= "empty"
                      end,
                      "__template",
                      "HUDMerc",
                      "Margins",
                      box(0, 7, 0, 0),
                      "OnLayoutComplete",
                      function(self)
                        local dlg = GetDialog(self)
                        dlg.selected_merc_ctrls[self.context.session_id] = self
                      end,
                      "MouseCursor",
                      "UI/Cursors/Pda_Hand.tga",
                      "OnContextUpdate",
                      function(self, context, ...)
                        local dlg = GetDialog(self)
                        if dlg.selected_mercs[self.context.session_id] or dlg.selected_merc == self.context.session_id then
                          dlg:SelectMerc(context, self)
                        end
                        self.full_selection_when_disabled = true
                        self.idContent.RolloverTemplate = ""
                        self:SetEnabled(self.context.ControlledBy == netUniqueId)
                      end
                    }, {
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "OnMouseButtonDown(self, pos, button)",
                        "func",
                        function(self, pos, button)
                          if not NetIsHost() then
                            return
                          end
                          if self.context ~= "empty" then
                            local dlg = GetDialog(self)
                            if dlg then
                              dlg:SelectMerc(self.context, self)
                            end
                          end
                          XButton.OnMouseButtonDown(self, pos, button)
                          return "break"
                        end
                      }),
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "OnMouseButtonDoubleClick(self, pos, button)",
                        "func",
                        function(self, pos, button)
                          if not NetIsHost() then
                            return
                          end
                          if GetUIStyleGamepad() then
                            return
                          end
                          if button == "L" then
                            local guest = self.context.ControlledBy == 1
                            AssignMercControl(self.context.session_id, guest)
                            local dlg = GetDialog(self)
                            dlg:OnContextUpdate(self.context.session_id)
                            dlg.idActionBar:OnUpdateActions()
                          end
                          XButton.OnMouseButtonDoubleClick(self, pos, button)
                          return "break"
                        end
                      })
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__condition",
                      function(parent, context)
                        return context == "empty"
                      end,
                      "__class",
                      "XContextWindow",
                      "RolloverText",
                      T(144072081433, "<placeholder>"),
                      "IdNode",
                      true,
                      "Margins",
                      box(5, 0, 5, 0)
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "Id",
                        "idEmptyBack",
                        "HAlign",
                        "left",
                        "VAlign",
                        "top",
                        "MinWidth",
                        80,
                        "MinHeight",
                        109,
                        "MaxWidth",
                        80,
                        "MaxHeight",
                        109,
                        "Background",
                        RGBA(32, 35, 47, 255)
                      })
                    })
                  })
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XZuluScroll",
              "Id",
              "idMercScroll",
              "Margins",
              box(20, 0, 0, 0),
              "Dock",
              "right",
              "FoldWhenHidden",
              false,
              "Target",
              "node",
              "FullPageAtEnd",
              false,
              "SnapToItems",
              true,
              "AutoHide",
              true
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(14, 0, 14, 5),
        "VAlign",
        "bottom"
      }, {
        PlaceObj("XTemplateWindow", {
          "__condition",
          function(parent, context)
            return NetIsHost()
          end,
          "__class",
          "XText",
          "HAlign",
          "left",
          "VAlign",
          "bottom",
          "TextStyle",
          "PDASectorInfo_Section",
          "Translate",
          true,
          "Text",
          T(146497207387, "<style UIDlgTitleLogo>[<left_click>x2]</style>Give/Take Merc")
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "controller hint",
            "__context",
            function(parent, context)
              return "GamepadUIStyleChanged"
            end,
            "__class",
            "XContextWindow",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              self.parent:SetVisible(not GetUIStyleGamepad())
            end
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__condition",
          function(parent, context)
            return not NetIsHost()
          end,
          "__class",
          "XText",
          "HAlign",
          "left",
          "VAlign",
          "bottom",
          "HandleMouse",
          false,
          "TextStyle",
          "UIDlgTitleLogo",
          "Translate",
          true,
          "Text",
          T(604117134370, "Waiting on <u(GetOtherPlayerNameFormat())> to make a decision")
        }),
        PlaceObj("XTemplateTemplate", {
          "__condition",
          function(parent, context)
            return NetIsHost()
          end,
          "__template",
          "InventoryActionBarCenter",
          "Margins",
          box(0, 0, 0, -5),
          "Dock",
          false,
          "HAlign",
          "right",
          "VAlign",
          "bottom",
          "OnLayoutComplete",
          function(self)
            local toolbar = self.idToolBar
            toolbar:SetLayoutHSpacing(15)
            local bxZero = box(0, 0, 0, 0)
            local list = toolbar[1]
            for _, btn in ipairs(list) do
              btn.idTxtContainer:SetMargins(bxZero)
              btn.idBtnShortcut:SetPadding(bxZero)
              local buttonAction = btn.action
              btn.idBtnShortcut:SetText(T({
                302963337924,
                "[<actionShortcut>]",
                actionShortcut = GetShortcutButtonT(buttonAction)
              }))
              btn.idBtnText:SetPadding(bxZero)
            end
          end
        })
      })
    })
  })
})
