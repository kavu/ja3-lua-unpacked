PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu Rollover",
  id = "SquadRollover",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDARolloverClass",
    "BorderWidth",
    0,
    "Padding",
    box(6, 6, 6, 6),
    "LayoutMethod",
    "Box",
    "Background",
    RGBA(52, 55, 61, 255),
    "BackgroundRectGlowSize",
    2,
    "BackgroundRectGlowColor",
    RGBA(32, 35, 47, 255)
  }, {
    PlaceObj("XTemplateWindow", {
      "comment",
      "title",
      "__class",
      "XContextWindow",
      "Id",
      "idTop",
      "Dock",
      "top",
      "LayoutMethod",
      "HList",
      "UseClipBox",
      false,
      "DrawOnTop",
      true,
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local control = self.context.control
        local offset = control and control:GetRolloverOffset()
        if offset and offset ~= box(0, 0, 0, 0) then
          self.parent:SetMargins(self.parent.Margins + offset)
        end
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idTitle",
        "HAlign",
        "left",
        "VAlign",
        "top",
        "FoldWhenHidden",
        true,
        "HandleMouse",
        false,
        "TextStyle",
        "HUDHeaderBig",
        "Translate",
        true,
        "Text",
        T(779614644688, "<SquadNameColored()> <color HUDHeaderGrey>[<SquadMemberCount()>]</color>"),
        "TextVAlign",
        "center"
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "power",
        "__class",
        "XText",
        "Id",
        "idPower",
        "Margins",
        box(100, 0, 0, 0),
        "VAlign",
        "top",
        "Visible",
        false,
        "HandleMouse",
        false,
        "TextStyle",
        "PDAQuests_HeaderSmall",
        "Translate",
        true,
        "Text",
        T(909161685756, "<valign bottom -2>Power <valign bottom 0><style HUDHeaderBigLight><GetSquadPower()></style>"),
        "TextVAlign",
        "bottom"
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "outer content",
      "LayoutMethod",
      "VList"
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "squad members",
        "__context",
        function(parent, context)
          return ResolvePropObj(context)
        end,
        "__class",
        "XContentTemplate",
        "Id",
        "idCurrentSquadCont",
        "Margins",
        box(0, 3, 0, 0),
        "FoldWhenHidden",
        true,
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idCountText",
          "Margins",
          box(5, 2, 0, 0),
          "Dock",
          "top",
          "HAlign",
          "left",
          "VAlign",
          "top",
          "FoldWhenHidden",
          true,
          "HandleMouse",
          false,
          "TextStyle",
          "SquadMapRollover",
          "Translate",
          true,
          "HideOnEmpty",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "container that enforces size"
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "Measure(self, max_width, max_height)",
            "func",
            function(self, max_width, max_height)
              local parent = self:ResolveId("node")
              local topUI = parent:ResolveId("idTop")
              max_width = topUI.measure_width
              return XWindow.Measure(self, max_width, max_height)
            end
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "container that centers",
            "Padding",
            box(20, 3, 20, 13),
            "HAlign",
            "center"
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "wrapping container",
              "HAlign",
              "left",
              "VAlign",
              "top",
              "LayoutMethod",
              "HWrap"
            }, {
              PlaceObj("XTemplateForEach", {
                "comment",
                "Mercs in the Current Team",
                "array",
                function(parent, context)
                  return context.Side == "player1" and context and context.units or GroupEnemyMercs({context})
                end,
                "__context",
                function(parent, context, item, i, n)
                  return gv_UnitData[item] or item
                end,
                "run_after",
                function(child, context, item, i, n, last)
                  if IsKindOf(context, "UnitData") then
                    return
                  end
                  local is_militia = context.count and context.count > 0 and context.Side == "ally" and not IsMerc(context.template)
                  child.idType:SetVisible(is_militia)
                  if is_militia then
                    child.idTypeImg:SetImage("UI/PDA/MercPortrait/T_ClassIcon_" .. context.template.class .. "_Small")
                  end
                  if context.count > 1 then
                    child.idCountIcon:SetVisible(true)
                    local color, _, _, textColor = GetSectorControlColor(context.Side)
                    child.idCountText:SetText(T({
                      476743244853,
                      "<textColor>x<count></color>",
                      count = context.count,
                      textColor = textColor
                    }))
                    child.idCountIcon:SetBackground(color)
                  end
                  if context.hasShipment then
                    child.idShipment:SetVisible(true)
                  end
                  child.idName:SetText(context.DisplayName)
                  child.idPortrait:SetImage(context.template.Portrait)
                  child.idBar:SetVisible(false)
                  child.idClass:SetMargins(empty_box)
                  local max_in_line = 6
                  local rem = i % max_in_line
                  child:SetGridX(rem == 0 and max_in_line or rem)
                  child:SetGridY(i / max_in_line + (rem == 0 and 0 or 1))
                  child.idBottomPart:SetVisible(context.Side == "player1" or context.Side == "player2")
                end
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "HUDMerc",
                  "Margins",
                  box(6, 10, 0, 0),
                  "LayoutMethod",
                  "Box",
                  "FXMouseIn",
                  "",
                  "FXPress",
                  "",
                  "FXPressDisabled",
                  ""
                }, {
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "Open(self)",
                    "func",
                    function(self)
                      HUDMercClass.Open(self)
                      self.idBottomPart:SetFoldWhenHidden(true)
                      self.idBottomBar:SetFoldWhenHidden(true)
                      self.idBottomBar:SetVisible(false)
                      if not self.idBottomPart:GetVisible() then
                        self:SetMargins(box(6, 10, 0, -20))
                      end
                    end
                  }),
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "unit count icon",
                    "__class",
                    "XSquareWindow",
                    "Id",
                    "idCountIcon",
                    "ZOrder",
                    0,
                    "Margins",
                    box(0, 0, -16, 0),
                    "HAlign",
                    "left",
                    "VAlign",
                    "top",
                    "Visible",
                    false,
                    "DrawOnTop",
                    true,
                    "Background",
                    RGBA(191, 67, 77, 255)
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "Id",
                      "idCountText",
                      "HAlign",
                      "center",
                      "VAlign",
                      "center",
                      "HandleMouse",
                      false,
                      "TextStyle",
                      "PDASelectedSquad",
                      "Translate",
                      true,
                      "Text",
                      T(568248221200, "x8")
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XSquareWindow",
                    "Id",
                    "idType",
                    "ZOrder",
                    3,
                    "Margins",
                    box(0, 0, 0, 20),
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
                    "Visible",
                    false,
                    "FoldWhenHidden",
                    true,
                    "Background",
                    RGBA(32, 35, 47, 255)
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XContextImage",
                      "RolloverTemplate",
                      "SmallRolloverLine",
                      "RolloverText",
                      T(799850868066, "<Description>"),
                      "RolloverTitle",
                      T(736028978593, "<DisplayName>"),
                      "Id",
                      "idTypeImg",
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
                      "HandleMouse",
                      true,
                      "Image",
                      "UI/PDA/MercPortrait/T_ClassIcon_MilitiaElite_Small",
                      "ImageFit",
                      "stretch",
                      "ContextUpdateOnOpen",
                      true
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "diamond shipment icon",
                    "__class",
                    "XImage",
                    "Id",
                    "idShipment",
                    "IdNode",
                    false,
                    "ZOrder",
                    0,
                    "Margins",
                    box(0, -16, 0, 0),
                    "HAlign",
                    "right",
                    "VAlign",
                    "top",
                    "MinWidth",
                    46,
                    "MaxWidth",
                    46,
                    "Visible",
                    false,
                    "DrawOnTop",
                    true,
                    "Image",
                    "UI/Hud/iw_diamond",
                    "ImageFit",
                    "width"
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__parent",
                    function(parent, context)
                      return parent.idPortraitBG
                    end,
                    "__class",
                    "XContextWindow",
                    "Margins",
                    box(0, 0, 0, 9),
                    "VAlign",
                    "bottom",
                    "LayoutMethod",
                    "VList",
                    "DrawOnTop",
                    true
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__context",
                      function(parent, context)
                        return context.StatusEffects
                      end,
                      "__condition",
                      function(parent, context)
                        return IsMerc(parent.context)
                      end,
                      "__class",
                      "XContentTemplate",
                      "Id",
                      "idStatusEffectsContainer",
                      "IdNode",
                      false,
                      "HAlign",
                      "right",
                      "VAlign",
                      "top",
                      "LayoutMethod",
                      "VList",
                      "FoldWhenHidden",
                      true
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__context",
                        function(parent, context)
                          return table.ifilter(context or empty_table, "ShownSatelliteView")
                        end,
                        "__class",
                        "XContextWindow",
                        "Id",
                        "idStatusEffects",
                        "IdNode",
                        true,
                        "OnLayoutComplete",
                        function(self)
                          self:SetVisible(next(self.context or emtpy_table))
                        end,
                        "LayoutMethod",
                        "VList"
                      }, {
                        PlaceObj("XTemplateForEach", {
                          "comment",
                          "status effect",
                          "__context",
                          function(parent, context, item, i, n)
                            return item
                          end
                        }, {
                          PlaceObj("XTemplateTemplate", {
                            "__template",
                            "StatusEffectIcon",
                            "MinWidth",
                            25,
                            "MinHeight",
                            25,
                            "MaxWidth",
                            25,
                            "MaxHeight",
                            25,
                            "ImageFit",
                            "stretch"
                          })
                        })
                      })
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__condition",
                      function(parent, context)
                        return IsMerc(context)
                      end,
                      "__class",
                      "XContextWindow",
                      "Id",
                      "idOperationContainer",
                      "IdNode",
                      true,
                      "HAlign",
                      "right",
                      "MinWidth",
                      22,
                      "MinHeight",
                      22,
                      "MaxWidth",
                      22,
                      "MaxHeight",
                      22,
                      "OnLayoutComplete",
                      function(self)
                        local operation = SectorOperations[self.context.Operation]
                        self.idOperation:SetImage(operation and operation.icon or "")
                        if operation and operation.Custom then
                          self.idOperation:SetImageColor(RGB(255, 255, 255))
                        end
                      end,
                      "FoldWhenHidden",
                      true,
                      "DrawOnTop",
                      true,
                      "Background",
                      RGBA(30, 37, 47, 255),
                      "HandleMouse",
                      true,
                      "ChildrenHandleMouse",
                      false
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
                        22,
                        "MinHeight",
                        22,
                        "MaxWidth",
                        22,
                        "MaxHeight",
                        22,
                        "Background",
                        RGBA(30, 37, 47, 255),
                        "Image",
                        "UI/Icons/unknown_add",
                        "ImageFit",
                        "stretch",
                        "ImageColor",
                        RGBA(61, 122, 153, 255)
                      })
                    })
                  })
                })
              })
            })
          })
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "Open(self)",
          "func",
          function(self)
            XContentTemplate.Open(self)
            local parent = self:ResolveId("node")
            local rolloverSquad = self.context
            local sectorId = rolloverSquad.CurrentSector
            local showMulti = parent.ShowMultiSquads and not IsSquadTravelling(rolloverSquad) and not IsTraversingShortcut(rolloverSquad)
            local allSquads = showMulti and GetSquadsInSectorCombined(sectorId, true, true) or {rolloverSquad}
            table.sort(allSquads, function(a, b)
              return a == rolloverSquad
            end)
            rawset(self, "allSquads", allSquads)
            rawset(self, "selectedSquad", 1)
            self:UpdateMultiSquadSection()
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "RespawnContent(self)",
          "func",
          function(self)
            XContentTemplate.RespawnContent(self)
            self:UpdateMultiSquadSection()
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "UpdateMultiSquadSection(self)",
          "func",
          function(self)
            local selectedSquad = rawget(self, "selectedSquad")
            local allSquads = rawget(self, "allSquads")
            local node = self.parent:ResolveId("node")
            node.idInputHint:SetVisible(1 < #allSquads)
            self.idCountText:SetVisible(1 < #allSquads)
            self.idCountText:SetText(T({
              634869128953,
              "Multiple Squads <style PDASelectedSquad><current>/<total></style>",
              current = selectedSquad,
              total = #allSquads
            }))
            local selSquadObj = allSquads[selectedSquad]
            self:ResolveId("idTitle"):SetContext(selSquadObj)
            self:ResolveId("idPower"):SetContext(selSquadObj)
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idInputHint",
        "Margins",
        box(3, 5, 0, 0),
        "HAlign",
        "left",
        "VAlign",
        "center",
        "FoldWhenHidden",
        true,
        "HandleMouse",
        false,
        "TextStyle",
        "SatelliteContextMenuKeybind",
        "Translate",
        true,
        "Text",
        T(268179249615, "[<ShortcutButton('CycleSquadsInRollover')>] Cycle Squads"),
        "HideOnEmpty",
        true
      })
    })
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "ShowMultiSquads",
    "Set",
    function(self, value)
      rawset(self, "ShowMultiSquads", value)
    end,
    "Get",
    function(self)
      return rawget(self, "ShowMultiSquads")
    end
  })
})
