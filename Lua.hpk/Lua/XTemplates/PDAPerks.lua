PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu PDA",
  id = "PDAPerks",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDAPerks",
    "Id",
    "idPerks",
    "MinWidth",
    1002,
    "MinHeight",
    730,
    "MaxWidth",
    1002,
    "MaxHeight",
    730,
    "ContextUpdateOnOpen",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      self.unit = context
      self.PerkPoints = context.perkPoints
      self:ResolveId("idPerksContent"):RespawnContent()
    end
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "IdNode",
      false,
      "Padding",
      box(19, 16, 19, 0),
      "Image",
      "UI/PDA/os_background_2",
      "FrameBox",
      box(3, 3, 3, 3)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContentTemplate",
        "Id",
        "idPerksContent"
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "to check layout completion",
          "Dock",
          "bottom",
          "OnLayoutComplete",
          function(self)
            local dlg = GetDialog(self)
            Msg("PerksLayoutDone", dlg)
          end,
          "FoldWhenHidden",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "MessengerScrollbar",
          "Id",
          "idPerksScroll",
          "Dock",
          "bottom",
          "Target",
          "idPerksScrollArea",
          "AutoHide",
          true,
          "Horizontal",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "top bar",
          "Padding",
          box(4, 0, 4, 0),
          "Dock",
          "top",
          "MinWidth",
          918,
          "MinHeight",
          40,
          "MaxWidth",
          918,
          "MaxHeight",
          40,
          "LayoutMethod",
          "HList",
          "Background",
          RGBA(88, 92, 68, 128)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Margins",
            box(4, 0, 4, 0),
            "VAlign",
            "center",
            "Image",
            "UI/PDA/level_up"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "TextStyle",
            "PDABrowserHeader",
            "Translate",
            true,
            "Text",
            T(336562821518, "Perks Level up"),
            "TextVAlign",
            "bottom"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idPointsText",
            "ZOrder",
            10,
            "Dock",
            "right",
            "TextStyle",
            "PDABrowserHeader",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local dlg = GetDialog(self)
              if dlg.PerkPoints <= 0 then
                self:SetText(T(324504304637, "No Available perks"))
              elseif not self:IsThreadRunning("blink-anim") then
                self:CreateThread("blink-anim", function()
                  local blink = false
                  while self.window_state ~= "destroying" or dlg.PerkPoints >= 1 do
                    if blink then
                      self:SetTextStyle("InventoryToolbarButtonCenter")
                      blink = false
                    else
                      blink = true
                      self:SetTextStyle("PDABrowserHeader")
                    end
                    Sleep(800)
                  end
                end)
              end
            end,
            "Translate",
            true,
            "Text",
            T(294890393549, "Available perks"),
            "TextVAlign",
            "bottom"
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "points",
            "__context",
            function(parent, context)
              return "perk_points"
            end,
            "__class",
            "XText",
            "Margins",
            box(8, 0, 0, 0),
            "Dock",
            "right",
            "MinWidth",
            24,
            "MaxWidth",
            24,
            "TextStyle",
            "PDABrowserPoints",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local dlg = GetDialog(self)
              self:SetText(T({
                310974211077,
                "<points>",
                points = dlg.PerkPoints
              }))
            end,
            "Translate",
            true,
            "Text",
            T(311301754183, "<perkPoints>"),
            "TextVAlign",
            "center"
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "grid",
          "__class",
          "XScrollArea",
          "Id",
          "idPerksScrollArea",
          "Margins",
          box(0, 4, 0, 0),
          "MinWidth",
          918,
          "MaxWidth",
          918,
          "GridStretchX",
          false,
          "OnLayoutComplete",
          function(self)
            local wheelstep = 80
            if GetDialog(self).totalPerks > 90 then
              self:SetMouseWheelStep(wheelstep)
            else
              self:SetMouseWheelStep(0)
            end
          end,
          "LayoutMethod",
          "Grid",
          "HScroll",
          "idPerksScroll",
          "MouseWheelStep",
          0
        }, {
          PlaceObj("XTemplateWindow", {
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "Stats text",
              "__class",
              "XText",
              "Padding",
              box(0, 0, 0, 0),
              "MinWidth",
              180,
              "MaxWidth",
              180,
              "TextStyle",
              "PDABrowserSubtitle",
              "Translate",
              true,
              "Text",
              T(577935949359, "Stats"),
              "WordWrap",
              false
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XFrame",
              "Margins",
              box(0, 0, -10000, 0),
              "DrawOnTop",
              true,
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
            "empty 2nd row",
            "GridY",
            2
          }),
          PlaceObj("XTemplateForEach", {
            "comment",
            "GetPerkStatAmountGroups()",
            "array",
            function(parent, context)
              return GetPerkStatAmountGroups()
            end,
            "item_in_context",
            "amountGroup",
            "run_after",
            function(child, context, item, i, n, last)
              child:SetGridX(i + 1)
              if i == 1 then
                child:SetMargins(box(4, 0, 0, 0))
              end
            end
          }, {
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(26, 0, 0, 0),
              "LayoutMethod",
              "HList"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XFrame",
                "Margins",
                box(0, 0, 0, 4),
                "Image",
                "UI/PDA/separate_line",
                "FrameBox",
                box(3, 3, 3, 3),
                "SqueezeX",
                false
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Margins",
                box(4, 0, 0, 0),
                "Padding",
                box(0, 0, 0, 0),
                "TextStyle",
                "PDABrowserSubtitle",
                "ContextUpdateOnOpen",
                true,
                "OnContextUpdate",
                function(self, context, ...)
                  self:SetText(Untranslated(context.amountGroup))
                end,
                "Translate",
                true
              })
            })
          }),
          PlaceObj("XTemplateForEach", {
            "comment",
            "stat",
            "array",
            function(parent, context)
              return UnitPropertiesStats:GetAttributes()
            end,
            "item_in_context",
            "statProp",
            "run_after",
            function(child, context, item, i, n, last)
              child:SetGridY(i + 2)
            end
          }, {
            PlaceObj("XTemplateWindow", {
              "VAlign",
              "bottom",
              "LayoutMethod",
              "VList"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Padding",
                box(0, 0, 0, 0),
                "TextStyle",
                "PDABrowserHeader",
                "ContextUpdateOnOpen",
                true,
                "OnContextUpdate",
                function(self, context, ...)
                  self:SetText(context.statProp.name)
                end,
                "Translate",
                true,
                "TextVAlign",
                "bottom"
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XFrame",
                "Margins",
                box(0, 0, -10000, 0),
                "DrawOnTop",
                true,
                "Image",
                "UI/PDA/separate_line_vertical",
                "FrameBox",
                box(3, 3, 3, 3),
                "SqueezeY",
                false
              })
            })
          }),
          PlaceObj("XTemplateForEach", {
            "comment",
            "attribute",
            "array",
            function(parent, context)
              return UnitPropertiesStats:GetAttributes()
            end,
            "item_in_context",
            "statProp",
            "__context",
            function(parent, context, item, i, n)
              return SubContext(context, {perkUIRow = i})
            end
          }, {
            PlaceObj("XTemplateForEach", {
              "comment",
              "GetPerkStatAmountGroups()",
              "array",
              function(parent, context)
                return GetPerkStatAmountGroups()
              end,
              "item_in_context",
              "amountGroup",
              "__context",
              function(parent, context, item, i, n)
                return SubContext(context, {perkUIColumn = i})
              end,
              "run_after",
              function(child, context, item, i, n, last)
                child:SetGridX(context.perkUIColumn + 1)
                child:SetGridY(context.perkUIRow + 2)
                if context.perkUIColumn == 1 then
                  child:SetMargins(box(4, 30, 0, 4))
                end
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "Margins",
                box(32, 30, 0, 4),
                "LayoutMethod",
                "HList"
              }, {
                PlaceObj("XTemplateForEach", {
                  "array",
                  function(parent, context)
                    return PresetArray(CharacterEffectCompositeDef)
                  end,
                  "condition",
                  function(parent, context, item, i)
                    return item.object_class == "Perk" and item.Stat == context.statProp.id and item.StatValue == context.amountGroup and table.find({
                      "Bronze",
                      "Silver",
                      "Gold"
                    }, item.Tier)
                  end,
                  "run_after",
                  function(child, context, item, i, n, last)
                    local dlg = GetDialog(child)
                    child:SetPerkId(item.id)
                    if not dlg:CanUnlockPerk(context, item) then
                      child:SetEnabled(false)
                    end
                    child.bottomAnchor = true
                    dlg.totalPerks = dlg.totalPerks + 1
                  end
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "__template",
                    "PDAPerkLevelUp",
                    "RolloverTemplate",
                    "PDAPerkRollover",
                    "Margins",
                    box(3, 3, 3, 3),
                    "DisabledBorderColor",
                    RGBA(0, 0, 0, 0)
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "blue background bar related to the stat",
                "__condition",
                function(parent, context)
                  return false
                end,
                "__class",
                "XContextWindow",
                "ZOrder",
                -10,
                "Margins",
                box(30, 26, -30, 2),
                "OnLayoutComplete",
                function(self)
                  local context = self:GetContext()
                  local statValue = context[context.statProp.id]
                  local group = context.amountGroup
                  local nextGroup = group + 10
                  if statValue <= group then
                    self:SetVisible(false)
                  elseif statValue > group and statValue < nextGroup then
                    local width = self.box:sizex()
                    local newWidth = MulDivRound(width, statValue - group, 10)
                    self:SetBox(self.box:minx(), self.box:miny(), newWidth, self.box:sizey())
                  end
                end,
                "Background",
                RGBA(61, 122, 153, 69),
                "ContextUpdateOnOpen",
                true,
                "OnContextUpdate",
                function(self, context, ...)
                  local x = context.perkUIColumn
                  local y = context.perkUIRow
                  self:SetGridX(x + 1)
                  self:SetGridY(y + 2)
                end
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContextWindow",
                "ZOrder",
                -10,
                "Margins",
                box(28, 0, -28, 0),
                "Background",
                RGBA(52, 55, 61, 178),
                "ContextUpdateOnOpen",
                true,
                "OnContextUpdate",
                function(self, context, ...)
                  local x = context.perkUIColumn
                  local y = context.perkUIRow
                  self:SetGridX(x + 1)
                  self:SetGridY(y + 2)
                  self:SetVisible(x % 2 == 0)
                end
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idPerksWarning",
            "Margins",
            box(0, 15, 0, 15),
            "HAlign",
            "center",
            "VAlign",
            "center",
            "GridX",
            2,
            "GridY",
            8,
            "GridWidth",
            3,
            "Visible",
            false,
            "TextStyle",
            "PDAPerksWarning",
            "Translate",
            true,
            "Text",
            T(713633774841, "Deselect a perk to choose a new one"),
            "TextHAlign",
            "center",
            "TextVAlign",
            "center"
          })
        })
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self, ...)",
      "func",
      function(self, ...)
        XDialog.Open(self, ...)
        TutorialHintsState.PerksMenu = true
        TutorialHintVisibilityEvaluate()
      end
    })
  })
})
