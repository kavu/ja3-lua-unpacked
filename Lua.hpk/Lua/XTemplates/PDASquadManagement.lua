PlaceObj("XTemplate", {
  group = "Zulu Satellite UI",
  id = "PDASquadManagement",
  PlaceObj("XTemplateWindow", {
    "__class",
    "ZuluModalDialog",
    "Background",
    RGBA(30, 30, 35, 115),
    "FadeInTime",
    200,
    "FadeOutTime",
    200,
    "GamepadVirtualCursor",
    true
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        SetCampaignSpeed(0, GetUICampaignPauseReason("SquadManagement"))
        if g_SatelliteUI then
          g_SatelliteUI:SetSuppressSectorVisualUpdates(true)
        end
        self.selected_merc = false
        self.selected_merc_ctrl = false
        self:SetFilter("Salary")
        ZuluModalDialog.Open(self, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Close",
      "func",
      function(self, ...)
        XDialog.Close(self, ...)
        SetCampaignSpeed(nil, GetUICampaignPauseReason("SquadManagement"))
        if g_SatelliteUI then
          g_SatelliteUI:SetSuppressSectorVisualUpdates(false)
          ObjModified("ui_player_squads")
        else
          ObjModified("hud_squads")
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SelectMerc(self, merc, ctrl)",
      "func",
      function(self, merc, ctrl)
        if self.selected_merc_ctrl and self.selected_merc_ctrl.window_state ~= "destroying" and self.selected_merc_ctrl ~= ctrl then
          self.selected_merc_ctrl:SetSelected(false)
        end
        self.selected_merc = merc and merc.session_id or false
        self.selected_merc_ctrl = ctrl or false
        if ctrl then
          ctrl:SetSelected("full")
        end
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextWindow",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      1090,
      "MinHeight",
      650,
      "MaxWidth",
      1090,
      "MaxHeight",
      650
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "IdNode",
        false,
        "Dock",
        "top",
        "MinHeight",
        32,
        "MaxHeight",
        32,
        "Image",
        "UI/PDA/os_header",
        "FrameBox",
        box(5, 5, 5, 5),
        "SqueezeY",
        false
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idHeaderText",
          "Margins",
          box(16, 0, 0, 0),
          "Padding",
          box(0, 0, 0, 2),
          "VAlign",
          "center",
          "TextStyle",
          "UIDlgTitle",
          "Translate",
          true,
          "Text",
          T(942962706825, "SQUAD MANAGEMENT")
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Margins",
          box(0, 0, 16, 0),
          "HAlign",
          "right",
          "VAlign",
          "center",
          "TextStyle",
          "UIDlgTitleLogo",
          "Text",
          "V1.1B"
        })
      }),
      PlaceObj("XTemplateWindow", nil, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "Margins",
          box(0, -5, 0, 0),
          "Dock",
          "box",
          "Image",
          "UI/PDA/os_background",
          "FrameBox",
          box(5, 5, 5, 5)
        }),
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return GetSquadManagementSquads()
          end,
          "__class",
          "XContentTemplate",
          "Id",
          "idContent",
          "Margins",
          box(20, 16, 20, 0),
          "OnContextUpdate",
          function(self, context, ...)
            local squadList = self.idSquadManage
            squadList = squadList and squadList.idSquadsList
            local scroll = squadList and squadList:GetVScroll()
            scroll = scroll and squadList:ResolveId(scroll)
            local scrollValue = scroll and scroll:GetScroll()
            if self.RespawnOnContext then
              if self.window_state == "open" then
                self:RespawnContent()
              end
            else
              local respawn_value = self:RespawnExpression(context)
              if rawget(self, "respawn_value") ~= respawn_value then
                self.respawn_value = respawn_value
                if self.window_state == "open" then
                  self:RespawnContent()
                end
              end
            end
            local dlg = GetDialog(self)
            dlg:SetFilter(dlg:GetFilter())
            if scrollValue then
              local newScroll = self:ResolveId("idSquadManage")
              newScroll = newScroll and newScroll.idSquadsList
              if newScroll then
                newScroll:ScrollTo(0, scrollValue)
              end
            end
          end
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
            "Margins",
            box(16, 16, 20, 16)
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "squad list",
              "Dock",
              "left",
              "HAlign",
              "left",
              "MinWidth",
              742,
              "MaxWidth",
              742
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
                "__class",
                "SquadManagementDragAndDrop",
                "Id",
                "idSquadManage",
                "MouseCursor",
                "UI/Cursors/Pda_Cursor.tga",
                "ChildrenHandleMouse",
                true,
                "NavigateScrollArea",
                false
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "SnappingScrollArea",
                  "Id",
                  "idSquadsList",
                  "Margins",
                  box(15, 0, 0, 0),
                  "Dock",
                  "box",
                  "LayoutVSpacing",
                  10,
                  "VScroll",
                  "idMercScroll"
                }, {
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnMouseButtonDown(self, pos, button)",
                    "func",
                    function(self, pos, button)
                      return "continue"
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnMouseButtonUp(self, pos, button)",
                    "func",
                    function(self, pos, button)
                      return "continue"
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "RecalcVisibility(self)",
                    "func",
                    function(self)
                      local UIRefreshModifiers = false
                      function UIRefreshModifiers(self)
                        for i, w in ipairs(self) do
                          CallMember(w.modifiers, "OnLayoutComplete", w)
                          UIRefreshModifiers(w)
                        end
                      end
                      XContentTemplateList.RecalcVisibility(self)
                      UIRefreshModifiers(self)
                    end
                  }),
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
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XButton",
                        "IdNode",
                        false,
                        "Background",
                        RGBA(255, 255, 255, 0),
                        "FocusedBackground",
                        RGBA(255, 255, 255, 0),
                        "OnPress",
                        function(self, gamepad)
                          local squad = self:GetContext().squad
                          OpenSquadCreation(squad.UniqueId)
                        end,
                        "RolloverBackground",
                        RGBA(255, 255, 255, 0),
                        "PressedBackground",
                        RGBA(255, 255, 255, 0)
                      }, {
                        PlaceObj("XTemplateWindow", {
                          "__class",
                          "XContextWindow",
                          "Id",
                          "idSquad",
                          "Margins",
                          box(0, 13, 8, 4),
                          "HAlign",
                          "left",
                          "MinWidth",
                          80,
                          "MaxWidth",
                          80,
                          "Background",
                          RGBA(32, 35, 47, 255),
                          "BackgroundRectGlowSize",
                          1,
                          "BackgroundRectGlowColor",
                          RGBA(32, 35, 47, 255)
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
                            "HAlign",
                            "center",
                            "VAlign",
                            "bottom",
                            "LayoutMethod",
                            "VList",
                            "ContextUpdateOnOpen",
                            true,
                            "OnContextUpdate",
                            function(self, context, ...)
                              local sector = context.CurrentSector
                              local sectorColor = GetSectorControlColor(gv_Sectors[sector].Side)
                              local node = self:ResolveId("node")
                              node.idSector:SetText(T({
                                764093693143,
                                "<SectorIdColored(id)>",
                                id = sector
                              }))
                              node.idSectorBG:SetBackground(sectorColor)
                            end
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
                              RGBA(195, 189, 172, 255),
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
                      PlaceObj("XTemplateForEach", {
                        "map",
                        function(parent, context, array, i)
                          return array and gv_UnitData[array[i]] or "empty"
                        end,
                        "__context",
                        function(parent, context, item, i, n)
                          return item
                        end,
                        "run_after",
                        function(child, context, item, i, n, last)
                          if context == "empty" then
                            child:SetHandleMouse(false)
                          end
                          local node = child:ResolveId("node")
                          child:SetEnabled(not node.disabled)
                        end
                      }, {
                        PlaceObj("XTemplateTemplate", {
                          "__template",
                          "HUDMerc",
                          "Margins",
                          box(0, 7, 0, 0),
                          "OnLayoutComplete",
                          function(self)
                            if rawget(self, "dragging") then
                              return
                            end
                            local dlg = GetDialog(self)
                            if self.context ~= "empty" and (not dlg.selected_merc or dlg.selected_merc == self.context.session_id) then
                              dlg:SelectMerc(self.context, self)
                            end
                          end,
                          "MouseCursor",
                          "UI/Cursors/Pda_Hand.tga"
                        }, {
                          PlaceObj("XTemplateCode", {
                            "run",
                            function(self, parent, context)
                              parent.idBar:SetVisible(false)
                              parent.idContent.RolloverTemplate = ""
                            end
                          }),
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "OnMouseButtonDown(self, pos, button)",
                            "func",
                            function(self, pos, button)
                              local dlg = GetDialog(self)
                              if self.context ~= "empty" then
                                if self.context and not self.context:IsLocalPlayerControlled() then
                                  return "break"
                                end
                                dlg:SelectMerc(self.context, self)
                              end
                              XButton.OnMouseButtonDown(self, pos, button)
                              return "continue"
                            end
                          }),
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "OnMouseButtonUp(self, pos, button)",
                            "func",
                            function(self, pos, button)
                              XButton.OnMouseButtonUp(self, pos, button)
                              return "continue"
                            end
                          }),
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "Filter(self, filter)",
                            "func",
                            function(self, filter)
                              local context = self:GetContext()
                              if IsKindOf(context, "UnitData") then
                                if filter == "Professions" then
                                  self.idClassIconBg:SetVisible(true)
                                  self.idStatHighlight:SetVisible(false)
                                elseif filter == "Salary" then
                                  self.idClassIconBg:SetVisible(false)
                                  self.idStatIconBg:SetVisible(false)
                                  local salary = GetMercCurrentDailySalary(context.session_id)
                                  if 0 < salary then
                                    local value = T({
                                      418564557177,
                                      "<money(salary)>",
                                      salary = salary
                                    })
                                    self.idStatHighlight:SetVisible(true)
                                    self.idStatCount:SetText(value)
                                  else
                                    self.idStatHighlight:SetVisible(false)
                                  end
                                else
                                  self.idStatHighlight:SetVisible(true)
                                  self.idStatIconBg:SetVisible(true)
                                  self.idClassIconBg:SetVisible(false)
                                  local stat = Presets.MercStat.Default[filter]
                                  if stat then
                                    local icon = stat.Icon
                                    local value = T({
                                      115341592558,
                                      "<statValue>",
                                      statValue = context[filter]
                                    })
                                    self.idStatIcon:SetImage(icon)
                                    self.idStatCount:SetText(value)
                                  end
                                end
                              end
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
                            "Visible",
                            false,
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
                                "Id",
                                "idStatIconBg",
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
                                "FoldWhenHidden",
                                true,
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
                                  "FoldWhenHidden",
                                  true,
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
                                  true,
                                  "Translate",
                                  true
                                })
                              })
                            })
                          }),
                          PlaceObj("XTemplateWindow", {
                            "__parent",
                            function(parent, context)
                              return parent.idPortraitBG
                            end,
                            "__class",
                            "XContextWindow",
                            "Id",
                            "idClassIconBg",
                            "IdNode",
                            true,
                            "ZOrder",
                            3,
                            "Dock",
                            "box",
                            "HAlign",
                            "right",
                            "VAlign",
                            "bottom",
                            "MinWidth",
                            28,
                            "MinHeight",
                            28,
                            "MaxWidth",
                            28,
                            "MaxHeight",
                            28,
                            "Background",
                            RGBA(27, 31, 45, 255),
                            "ContextUpdateOnOpen",
                            true,
                            "OnContextUpdate",
                            function(self, context, ...)
                              if not IsKindOfClasses(context, "Unit", "UnitData") then
                                self:SetVisible(false)
                              else
                                self.idClassIcon:SetImage(GetMercSpecIcon(context))
                              end
                            end
                          }, {
                            PlaceObj("XTemplateWindow", {
                              "__class",
                              "XImage",
                              "Id",
                              "idClassIcon",
                              "HAlign",
                              "center",
                              "VAlign",
                              "center",
                              "MinWidth",
                              20,
                              "MinHeight",
                              20,
                              "MaxWidth",
                              20,
                              "MaxHeight",
                              20,
                              "ImageFit",
                              "stretch",
                              "ImageColor",
                              RGBA(195, 189, 172, 255)
                            })
                          })
                        })
                      })
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "new squad",
                    "Id",
                    "idNewSquad"
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__context",
                      function(parent, context)
                        return {squad = "empty"}
                      end,
                      "__class",
                      "XContextWindow",
                      "Id",
                      "idNewSquadList",
                      "IdNode",
                      true,
                      "LayoutMethod",
                      "HList",
                      "LayoutHSpacing",
                      10
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XContextWindow",
                        "Id",
                        "idSquad",
                        "Margins",
                        box(0, 13, 8, 4),
                        "HAlign",
                        "left",
                        "MinWidth",
                        80,
                        "MaxWidth",
                        80,
                        "Background",
                        RGBA(32, 35, 47, 255),
                        "BackgroundRectGlowSize",
                        1,
                        "BackgroundRectGlowColor",
                        RGBA(32, 35, 47, 255)
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
                          21
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
                          "HAlign",
                          "center",
                          "VAlign",
                          "bottom",
                          "LayoutMethod",
                          "VList"
                        }, {
                          PlaceObj("XTemplateWindow", {
                            "__class",
                            "XImage",
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
                            RGBA(130, 128, 120, 255)
                          }),
                          PlaceObj("XTemplateWindow", {
                            "__class",
                            "XText",
                            "HAlign",
                            "center",
                            "TextStyle",
                            "PDASM_NewSquadLabel",
                            "Translate",
                            true,
                            "Text",
                            T(321445201647, "NEW SQUAD")
                          })
                        })
                      }),
                      PlaceObj("XTemplateForEach", {
                        "array",
                        function(parent, context)
                          return {
                            "empty",
                            "empty",
                            "empty",
                            "empty",
                            "empty",
                            "empty"
                          }
                        end,
                        "__context",
                        function(parent, context, item, i, n)
                          return item
                        end,
                        "run_after",
                        function(child, context, item, i, n, last)
                          child.idDragAMerc:SetVisible(i == 1)
                        end
                      }, {
                        PlaceObj("XTemplateWindow", {
                          "__class",
                          "XContextWindow",
                          "IdNode",
                          true,
                          "Margins",
                          box(0, 7, 0, 0),
                          "HAlign",
                          "left",
                          "VAlign",
                          "top",
                          "MinWidth",
                          90,
                          "MaxWidth",
                          90,
                          "UseClipBox",
                          false,
                          "BorderColor",
                          RGBA(255, 255, 255, 0),
                          "Background",
                          RGBA(255, 255, 255, 0)
                        }, {
                          PlaceObj("XTemplateWindow", {
                            "comment",
                            "fake HUDMerc template to keep space taken",
                            "__class",
                            "XContextWindow",
                            "Id",
                            "idContent",
                            "MinHeight",
                            105,
                            "MaxHeight",
                            105,
                            "LayoutMethod",
                            "VList",
                            "HandleMouse",
                            true
                          }, {
                            PlaceObj("XTemplateWindow", {
                              "__class",
                              "XImage",
                              "Id",
                              "idPortraitBG",
                              "IdNode",
                              false,
                              "Margins",
                              box(5, 5, 5, 0),
                              "HAlign",
                              "center",
                              "VAlign",
                              "top",
                              "Visible",
                              false,
                              "Image",
                              "UI/Hud/portrait_background"
                            }, {
                              PlaceObj("XTemplateWindow", {
                                "__class",
                                "XImage",
                                "UIEffectModifierId",
                                "Default",
                                "Id",
                                "idPortrait",
                                "IdNode",
                                false,
                                "ZOrder",
                                2,
                                "Margins",
                                box(0, -10, 0, 0),
                                "ImageFit",
                                "stretch",
                                "ImageRect",
                                box(36, 0, 264, 246),
                                "ImageScale",
                                point(300, 300)
                              }, {
                                PlaceObj("XTemplateWindow", {
                                  "__class",
                                  "XImage",
                                  "Id",
                                  "idSkull",
                                  "Margins",
                                  box(0, 0, 2, 2),
                                  "HAlign",
                                  "right",
                                  "VAlign",
                                  "bottom",
                                  "Visible",
                                  false,
                                  "Image",
                                  "UI/Hud/dead_merc",
                                  "ImageScale",
                                  point(600, 600)
                                })
                              })
                            }),
                            PlaceObj("XTemplateWindow", {
                              "Id",
                              "idBottomPart",
                              "Margins",
                              box(5, 0, 5, 0),
                              "VAlign",
                              "bottom",
                              "LayoutMethod",
                              "VList",
                              "Background",
                              RGBA(32, 35, 47, 255),
                              "BackgroundRectGlowSize",
                              1,
                              "BackgroundRectGlowColor",
                              RGBA(32, 35, 47, 255)
                            }, {
                              PlaceObj("XTemplateWindow", {
                                "__class",
                                "XText",
                                "Id",
                                "idName",
                                "Margins",
                                box(2, 0, 0, 0),
                                "HAlign",
                                "left",
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
                                "PDAMercNameCard_Light",
                                "Translate",
                                true,
                                "Text",
                                T(132729641765, " "),
                                "TextVAlign",
                                "bottom"
                              })
                            }),
                            PlaceObj("XTemplateWindow", {
                              "Margins",
                              box(5, 6, 5, 6),
                              "Dock",
                              "box",
                              "Background",
                              RGBA(32, 35, 47, 255),
                              "BackgroundRectGlowSize",
                              1,
                              "BackgroundRectGlowColor",
                              RGBA(32, 35, 47, 255)
                            })
                          }),
                          PlaceObj("XTemplateWindow", {
                            "__class",
                            "XText",
                            "RolloverTranslate",
                            false,
                            "Id",
                            "idDragAMerc",
                            "Margins",
                            box(3, 0, 0, 0),
                            "HAlign",
                            "center",
                            "VAlign",
                            "center",
                            "MaxWidth",
                            80,
                            "Clip",
                            false,
                            "UseClipBox",
                            false,
                            "Transparency",
                            180,
                            "HandleMouse",
                            false,
                            "ChildrenHandleMouse",
                            false,
                            "TextStyle",
                            "PDASM_DragAMerc",
                            "Translate",
                            true,
                            "Text",
                            T(736930395887, "DRAG A MERC"),
                            "TextHAlign",
                            "center",
                            "TextVAlign",
                            "center"
                          })
                        })
                      })
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "MessengerScrollbar",
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
                    "AutoHide",
                    true,
                    "UnscaledWidth",
                    16
                  })
                })
              })
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "PDAFinances"
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(20, 0, 20, 0),
          "Dock",
          "bottom",
          "MinHeight",
          57,
          "MaxHeight",
          57
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "HAlign",
            "left",
            "VAlign",
            "center",
            "TextStyle",
            "AimCopyrightText",
            "Translate",
            true,
            "Text",
            T(131695298527, "<style AimCopyrightTextC><copyright></style> A.I.M. 2001")
          }),
          PlaceObj("XTemplateWindow", nil),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XToolBarList",
            "Id",
            "idToolBar",
            "Dock",
            "right",
            "HAlign",
            "right",
            "VAlign",
            "center",
            "LayoutHSpacing",
            20,
            "Background",
            RGBA(255, 255, 255, 0),
            "Toolbar",
            "ActionBar",
            "Show",
            "text",
            "ButtonTemplate",
            "PDACommonButton"
          }, {
            PlaceObj("XTemplateAction", {
              "ActionId",
              "idFilters",
              "ActionName",
              T(421561301721, "View"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "V",
              "ActionGamepad",
              "ButtonY",
              "OnAction",
              function(self, host, source, ...)
                local dlg = host
                local button = dlg and dlg.idToolBar and dlg.idToolBar.ididFilters
                if not dlg or not button then
                  return
                end
                local ctxMenu = dlg:ResolveId("idFilterMenu")
                if ctxMenu then
                  ctxMenu:Close()
                else
                  ctxMenu = XTemplateSpawn("PDASquadManagementFilterMenu", dlg, dlg)
                  ctxMenu:SetAnchor(button.box)
                  ctxMenu:SetMinWidth(button.MinWidth)
                  ctxMenu:Open()
                end
              end
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "idClose",
              "ActionName",
              T(918444511505, "Close"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "Escape",
              "ActionGamepad",
              "ButtonB",
              "OnActionEffect",
              "close"
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "RebuildActions(self, ...)",
              "func",
              function(self, ...)
                XToolBarList.RebuildActions(self, ...)
                self.ididFilters:SetMinWidth(144)
                self.ididFilters:SetMaxWidth(144)
              end
            })
          })
        })
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
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "Filter",
    "editor",
    "text",
    "default",
    "Salary",
    "translate",
    false,
    "Set",
    function(self, value)
      self.Filter = value
      local squadsList = self.idContent.idSquadManage.idSquadsList
      for _, squad in ipairs(squadsList) do
        if string.starts_with(squad.Id, "idSquad") then
          for _, hudMerc in ipairs(squad) do
            if IsKindOf(hudMerc, "HUDMercClass") then
              hudMerc:Filter(value)
            end
          end
        end
      end
    end,
    "Get",
    function(self)
      return self.Filter
    end
  })
})
