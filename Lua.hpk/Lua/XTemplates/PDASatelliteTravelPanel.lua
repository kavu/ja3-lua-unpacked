PlaceObj("XTemplate", {
  __is_kind_of = "XContentTemplate",
  group = "Zulu Satellite UI",
  id = "PDASatelliteTravelPanel",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return "travel_mode_changed"
    end,
    "__class",
    "XContentTemplate",
    "HAlign",
    "left",
    "MinWidth",
    360,
    "MaxWidth",
    360,
    "MaxHeight",
    400,
    "MouseCursor",
    "UI/Cursors/Pda_Cursor.tga",
    "OnContextUpdate",
    function(self, context, ...)
      if self.RespawnOnContext and self.window_state == "open" then
        self:RespawnContent()
      end
      if context then
        HideCombatLog()
      end
      XContextWindow.OnContextUpdate(self, context, ...)
    end
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "MouseInWindow(self, pt)",
      "func",
      function(self, pt)
        if g_SatelliteUI and g_SatelliteUI.context_menu and g_SatelliteUI.context_menu:MouseInWindow(pt) then
          return true
        end
        return XWindow.MouseInWindow(self, pt)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "sector info",
      "__context",
      function(parent, context)
        return g_SatelliteUI and g_SatelliteUI.travel_mode
      end,
      "__condition",
      function(parent, context)
        return context
      end,
      "__class",
      "XContextFrame",
      "HandleMouse",
      true,
      "Image",
      "UI/PDA/os_background",
      "FrameBox",
      box(2, 2, 56, 56),
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local route = context.route
        if not route or not next(route) then
          return
        end
        local lastSegment = route[#route]
        local destSectorId = lastSegment[#lastSegment]
        local destSector = gv_Sectors[destSectorId]
        local color = GetSectorControlColor(destSector.Side)
        self.idSectorId:SetText(T({
          764093693143,
          "<SectorIdColored(id)>",
          id = destSector.Id
        }))
        self.idSectorSquare:SetBackground(color)
        self.idSectorImage:SetImage(destSector.image)
        self.idTitle:SetText(destSector.display_name)
        local squad = context.squad
        self.idSquadButton.idLogo:SetContext({
          squad = squad.UniqueId,
          side = "ally"
        })
        local breakdown = GetRouteInfoBreakdown(squad, route)
        self.idRouteBreakdown:SetContext(breakdown)
        self.idRouteBreakdown.idErrors:SetContext(breakdown.errors)
        local total = breakdown.total
        if total.travelTime then
          self.idSquadSpeedMods:SetVisible(true)
          self.idTotalTime:SetVisible(true)
          self.idSquadSpeedMods:SetContext(total.travelTimeBreakdown)
          self.idTotalTime:SetNameText(T(985231638054, "Total Time"))
          self.idTotalTime:SetValueText(T({
            647718470101,
            "<timeDuration(travelTime)>",
            total
          }))
          local finishTime = Game.CampaignTime + total.travelTime
          self.idArrivalTime:SetContext({t = finishTime}, true)
          AddTimelineEvent("travelling-temp", finishTime, "travel", squad.UniqueId)
        else
          self.idSquadSpeedMods:SetVisible(false)
          self.idTotalTime:SetVisible(false)
          RemoveTimelineEvent("travelling-temp")
        end
        local routeStartId = squad.CurrentSector
        local _, colorStart = GetSectorControlColor(gv_Sectors[routeStartId].Side)
        local _, colorEnd = GetSectorControlColor(gv_Sectors[destSectorId].Side)
        local startDestStr = T({
          555461885941,
          "<clrStart><SectorId(startId)></color> > <clrEnd><SectorId(endId)></color>",
          clrStart = colorStart,
          startId = routeStartId,
          clrEnd = colorEnd,
          endId = destSectorId
        })
        self.idRouteStartDest:SetText(startDestStr)
        self.idSquadButton:SetContext(context.squad, true)
        local toolbar = self.idToolBar
        toolbar:RebuildActions(self.parent)
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "sector title",
        "__class",
        "XFrame",
        "IdNode",
        false,
        "Dock",
        "top",
        "VAlign",
        "center",
        "UseClipBox",
        false,
        "DrawOnTop",
        true,
        "Image",
        "UI/PDA/os_header",
        "FrameBox",
        box(2, 2, 37, 37)
      }, {
        PlaceObj("XTemplateWindow", {
          "Id",
          "idSectorSquare",
          "Margins",
          box(23, 0, 10, 1),
          "Dock",
          "left",
          "VAlign",
          "center",
          "MinWidth",
          26
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idSectorId",
            "HAlign",
            "center",
            "VAlign",
            "center",
            "Clip",
            false,
            "TextStyle",
            "PDASatelliteRollover_SectorTitle",
            "Translate",
            true,
            "TextHAlign",
            "center",
            "TextVAlign",
            "center"
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Id",
          "idLogo",
          "Margins",
          box(20, 0, 10, 0),
          "HAlign",
          "right",
          "VAlign",
          "center",
          "UseClipBox",
          false,
          "Image",
          "UI/PDA/HazOS",
          "ImageScale",
          point(700, 700)
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "HAlign",
          "left",
          "VAlign",
          "center",
          "Clip",
          false,
          "UseClipBox",
          false,
          "FoldWhenHidden",
          true,
          "HandleMouse",
          false,
          "TextStyle",
          "PDASectorInfo_Sector",
          "Translate",
          true,
          "TextVAlign",
          "center"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "sector image",
        "__class",
        "XImage",
        "Id",
        "idSectorImage",
        "Margins",
        box(30, 10, 10, 5),
        "Dock",
        "top",
        "HAlign",
        "center",
        "MinWidth",
        334,
        "MaxWidth",
        334,
        "HandleMouse",
        true,
        "ImageFit",
        "smallest"
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "squad",
        "__context",
        function(parent, context)
          return context.squad
        end,
        "__class",
        "XButton",
        "Id",
        "idSquadButton",
        "Margins",
        box(30, 5, 10, 5),
        "Padding",
        box(5, 5, 5, 5),
        "Dock",
        "top",
        "BorderColor",
        RGBA(0, 0, 0, 0),
        "Background",
        RGBA(0, 0, 0, 0),
        "BackgroundRectGlowColor",
        RGBA(0, 0, 0, 0),
        "MouseCursor",
        "UI/Cursors/Pda_Hand.tga",
        "OnContextUpdate",
        function(self, context, ...)
          local openMenu = g_SatelliteUI.context_menu
          openMenu = openMenu and openMenu.window_state == "open"
          if openMenu then
            self:SetBackground(GameColors.Yellow)
            self:SetRolloverBackground(GameColors.Yellow)
            self:SetPressedBackground(GameColors.Yellow)
            self.idArrow:SetFlipX(true)
            self.idArrow:SetImageColor(GameColors.DarkB)
            self.idName:SetTextStyle("PDASectorInfo_DarkBlue")
          else
            self:SetBackground(RGBA(0, 0, 0, 0))
            self:SetRolloverBackground(RGBA(0, 0, 0, 0))
            self:SetPressedBackground(RGBA(0, 0, 0, 0))
            self.idArrow:SetFlipX(false)
            self.idArrow:SetImageColor(GameColors.Yellow)
            self.idName:SetTextStyle("PDASectorInfo_Yellow")
          end
        end,
        "FocusedBorderColor",
        RGBA(0, 0, 0, 0),
        "FocusedBackground",
        RGBA(0, 0, 0, 0),
        "DisabledBorderColor",
        RGBA(0, 0, 0, 0),
        "OnPress",
        function(self, gamepad)
          local topParent = self:ResolveId("node").parent
          local popup = rawget(topParent, "popup")
          if popup and popup.window_state == "open" then
            g_SatelliteUI:RemoveContextMenu()
            rawset(topParent, "popup", false)
            return
          end
          popup = XTemplateSpawn("PDASatelliteTravelSquadSelection", topParent)
          popup:Open()
          popup:SetAnchor(self.box)
          g_SatelliteUI.context_menu = popup
          self:OnContextUpdate()
          rawset(topParent, "popup", popup)
        end,
        "RolloverBackground",
        RGBA(0, 0, 0, 0),
        "PressedBackground",
        RGBA(0, 0, 0, 0)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContextWindow",
          "RolloverTemplate",
          "SquadRollover",
          "RolloverText",
          T(382336604236, "<u(Name)>"),
          "RolloverTitle",
          T(787181340357, "<u(Name)>"),
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          5,
          "HandleMouse",
          true,
          "ChildrenHandleMouse",
          false,
          "ContextUpdateOnOpen",
          true
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "SatelliteIconCombined",
            "Id",
            "idLogo",
            "ScaleModifier",
            point(625, 625)
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idName",
            "HAlign",
            "left",
            "VAlign",
            "center",
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDASectorInfo_Yellow",
            "Translate",
            true,
            "Text",
            T(473906174896, "<u(Name)> [<u(SquadMemberCount())>]"),
            "TextVAlign",
            "center"
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Id",
          "idArrow",
          "Margins",
          box(0, 0, 8, 0),
          "Dock",
          "right",
          "Image",
          "UI/PDA/T_Icon_Play",
          "ImageColor",
          RGBA(215, 161, 87, 255)
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Padding",
        box(40, 0, 20, 0),
        "Dock",
        "top",
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 0, 0, -5)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "HAlign",
            "left",
            "TextStyle",
            "PDASectorInfo_Green_Large",
            "Translate",
            true,
            "Text",
            T(433123255268, "ROUTE")
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idRouteStartDest",
            "HAlign",
            "right",
            "TextStyle",
            "PDASectorInfo_ValueLight_Large",
            "ContextUpdateOnOpen",
            true,
            "Translate",
            true
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "h line",
          "__class",
          "XImage",
          "Margins",
          box(-10, 5, -10, 5),
          "VAlign",
          "top",
          "Image",
          "UI/PDA/separate_line_vertical",
          "ImageFit",
          "stretch-x"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XNameValueText",
          "RolloverTemplate",
          "RolloverGeneric",
          "Id",
          "idTotalTime",
          "Margins",
          box(0, 0, 0, -5),
          "FoldWhenHidden",
          true,
          "TextStyle",
          "PDASectorInfo_ValueDark",
          "TextStyleRight",
          "PDASectorInfo_ValueLight"
        }),
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return {
              t = Game.CampaignTime
            }
          end,
          "__class",
          "XNameValueText",
          "RolloverTemplate",
          "RolloverGeneric",
          "Id",
          "idArrivalTime",
          "Margins",
          box(0, 0, 0, -5),
          "OnContextUpdate",
          function(self, context, ...)
            self:SetNameText(self.NameText)
            self.idLeftText:SetContext(context)
            self:SetValueText(T(359621748713, "<time(t)> <DateFormatted(t)>"))
            self.idRightText:SetContext(context)
          end,
          "NameText",
          T(813357299773, "Arrival Time"),
          "TextStyle",
          "PDASectorInfo_ValueDark",
          "TextStyleRight",
          "PDASectorInfo_ValueLight"
        }),
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return false
          end,
          "__class",
          "XContentTemplate",
          "Id",
          "idSquadSpeedMods",
          "FoldWhenHidden",
          true
        }, {
          PlaceObj("XTemplateWindow", {
            "__condition",
            function(parent, context)
              return context
            end
          }, {
            PlaceObj("XTemplateForEach", {
              "comment",
              "travel time modifier",
              "condition",
              function(parent, context, item, i)
                return item.Category == "squad"
              end,
              "run_after",
              function(child, context, item, i, n, last)
                child:SetNameText(item.Text)
                child:SetValueText(T({
                  516091070257,
                  "<percentWithSign(val)>",
                  val = item.Value
                }))
                if item.rollover then
                  child:SetRolloverText(item.rollover)
                end
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XNameValueText",
                "RolloverTemplate",
                "RolloverGeneric",
                "TextStyle",
                "PDASectorInfo_ValueDark",
                "TextStyleRight",
                "PDASectorInfo_ValueLight"
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "h line",
          "__class",
          "XImage",
          "Margins",
          box(-10, 5, -10, 5),
          "VAlign",
          "top",
          "Image",
          "UI/PDA/separate_line_vertical",
          "ImageFit",
          "stretch-x"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Padding",
        box(30, 0, 10, 0),
        "Dock",
        "bottom",
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "h line",
          "__class",
          "XImage",
          "Margins",
          box(0, 5, 0, 10),
          "VAlign",
          "top",
          "Image",
          "UI/PDA/separate_line_vertical",
          "ImageFit",
          "stretch-x"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XToolBarList",
          "Id",
          "idToolBar",
          "Margins",
          box(0, 0, 0, 20),
          "Padding",
          box(-3, -3, -3, -3),
          "HAlign",
          "right",
          "VAlign",
          "bottom",
          "MinHeight",
          28,
          "LayoutHSpacing",
          5,
          "Background",
          RGBA(255, 255, 255, 0),
          "Toolbar",
          "TravelActionBar",
          "Show",
          "text",
          "ButtonTemplate",
          "PDACommonButton"
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "idClosePanel",
          "ActionName",
          T(647445591978, "Cancel"),
          "ActionToolbar",
          "TravelActionBar",
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
          "ActionButtonTemplate",
          "PDACommonButton",
          "OnAction",
          function(self, host, source, ...)
            g_SatelliteUI:ExitTravelMode()
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContentTemplateScrollArea",
        "Id",
        "idRouteBreakdown",
        "Margins",
        box(40, 0, 10, 0),
        "MaxHeight",
        640,
        "LayoutMethod",
        "VList",
        "Clip",
        "self",
        "VScroll",
        "idScrollbar",
        "MouseWheelStep",
        130
      }, {
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return false
          end,
          "__class",
          "XContentTemplate",
          "Id",
          "idErrors",
          "Margins",
          box(0, 0, 0, -5),
          "HAlign",
          "left",
          "VAlign",
          "top",
          "MaxWidth",
          300,
          "FoldWhenHidden",
          true
        }, {
          PlaceObj("XTemplateWindow", {
            "__condition",
            function(parent, context)
              return context
            end,
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateForEach", {
              "comment",
              "error",
              "run_after",
              function(child, context, item, i, n, last)
                child:SetText(item)
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Margins",
                box(0, -2, 0, 5),
                "TextStyle",
                "PDASectorInfo_ValueRed",
                "Translate",
                true,
                "TextVAlign",
                "center"
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__condition",
            function(parent, context)
              return context and #context == 0
            end,
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Margins",
              box(0, -2, 0, 5),
              "TextStyle",
              "PDASectorInfo_ValueLight",
              "Translate",
              true,
              "Text",
              T(905777769691, "Shift + <image UI/Icons/left_click> Place Waypoint"),
              "TextVAlign",
              "center"
            })
          })
        }),
        PlaceObj("XTemplateForEach", {
          "comment",
          "route terrain type",
          "__context",
          function(parent, context, item, i, n)
            return item
          end,
          "run_after",
          function(child, context, item, i, n, last)
            local terrainPreset = Presets.SectorTerrain.Default[item.terrain]
            local name = terrainPreset and terrainPreset.DisplayName
            local breakdown = item.travelTimeBreakdown
            for i, b in ipairs(breakdown) do
              if b.Category == "sector-special" then
                name = name .. " " .. b.Text
              end
            end
            child.idTerrainType:SetNameText(name)
            if item.invalid then
              child.idCircle:SetImage("UI/PDA/hm_circle_red")
              child.idTerrainType:SetTextStyle("PDASectorInfo_ValueRed")
            end
            if i == last then
              child.idLineDownward:SetVisible(false)
              child.idHorizontalLine:SetVisible(false)
            end
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XContextWindow",
            "IdNode",
            true,
            "Margins",
            box(10, 0, 10, 0)
          }, {
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(0, 7, 5, 0),
              "Dock",
              "left"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Id",
                "idLineDownward",
                "Margins",
                box(0, 0, 0, -8),
                "Dock",
                "box",
                "Image",
                "UI/PDA/separate_line",
                "ImageFit",
                "stretch-y"
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Id",
                "idCircle",
                "Margins",
                box(0, -2, 0, 0),
                "VAlign",
                "top",
                "Image",
                "UI/PDA/hm_circle"
              })
            }),
            PlaceObj("XTemplateWindow", {
              "LayoutMethod",
              "VList",
              "LayoutVSpacing",
              -3
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XNameValueText",
                "RolloverTemplate",
                "RolloverGeneric",
                "Id",
                "idTerrainType",
                "ValueText",
                T(185901378984, "<timeDuration(travelTime)>"),
                "TextStyle",
                "PDASectorInfo_ValueLight",
                "TextStyleRight",
                "PDASectorInfo_ValueLight"
              }),
              PlaceObj("XTemplateForEach", {
                "comment",
                "travel time modifier",
                "array",
                function(parent, context)
                  return context.travelTimeBreakdown
                end,
                "condition",
                function(parent, context, item, i)
                  return item.Category == "sector"
                end,
                "run_after",
                function(child, context, item, i, n, last)
                  child:SetNameText(item.Text)
                  if item.ValueType == "money" then
                    local cantAfford = Game.Money < item.Value
                    if cantAfford then
                      child:SetValueText(T({
                        544831255685,
                        "<color PDACommonButtonRed><money(val)></color>",
                        val = item.Value
                      }))
                    else
                      child:SetValueText(T({
                        181698541846,
                        "<money(val)>",
                        val = item.Value
                      }))
                    end
                  elseif item.ValueType == "text" then
                    child:SetValueText(item.Value)
                  else
                    child:SetValueText(T({
                      516091070257,
                      "<percentWithSign(val)>",
                      val = item.Value
                    }))
                  end
                end
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XNameValueText",
                  "RolloverTemplate",
                  "RolloverGeneric",
                  "TextStyle",
                  "PDASectorInfo_ValueDark",
                  "TextStyleRight",
                  "PDASectorInfo_ValueLight"
                })
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "h line",
                "__class",
                "XImage",
                "Id",
                "idHorizontalLine",
                "Margins",
                box(0, 5, -10, 5),
                "VAlign",
                "top",
                "Image",
                "UI/PDA/separate_line_vertical",
                "ImageFit",
                "stretch-x"
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XZuluScroll",
          "Id",
          "idScrollbar",
          "Margins",
          box(5, 0, 0, 0),
          "Dock",
          "right",
          "HAlign",
          "right",
          "Target",
          "node",
          "AutoHide",
          true
        })
      })
    })
  })
})
