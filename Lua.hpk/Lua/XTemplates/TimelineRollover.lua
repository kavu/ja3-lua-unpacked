PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu",
  id = "TimelineRollover",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDARolloverClass",
    "UseClipBox",
    false,
    "BorderColor",
    RGBA(128, 128, 128, 0),
    "Background",
    RGBA(240, 240, 240, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextControl",
      "Id",
      "idContent",
      "Padding",
      box(6, 4, 6, 6),
      "MinWidth",
      400,
      "MaxWidth",
      400,
      "LayoutMethod",
      "VList",
      "LayoutVSpacing",
      5,
      "UseClipBox",
      false,
      "Background",
      RGBA(52, 55, 61, 255)
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "Open",
        "func",
        function(self, ...)
          XContextControl.Open(self, ...)
          local control = self.context.control
          local offset = control and control:GetRolloverOffset()
          if offset and offset ~= box(0, 0, 0, 0) then
            self.parent:SetMargins(self.parent.Margins + offset)
          end
          self.idTitle:SetText(control:GetRolloverTitle())
          local hintTxt = control:GetRolloverHint()
          self.idHint:SetText(hintTxt)
          self.idHintContainer:SetVisible(not not hintTxt)
          local event = self.context.event
          local dueTime = event.due
          local timeLeft = dueTime - Game.CampaignTime
          local pdaDialog = GetDialog("PDADialog")
          local remaining = T({
            366780543124,
            "Time Remaining: <right><style PDARolloverTextMedium><timeLeft></style>",
            timeLeft = FormatCampaignTime(timeLeft, "all")
          })
          local exactDue = T({
            361706829696,
            "Event Due: <right><style PDARolloverTextMedium><DateFormatted(t)> <time(t)></style>",
            t = dueTime
          })
          local multiEvents = self.context.otherEvents
          multiEvents = multiEvents and 0 < #multiEvents
          if multiEvents then
            remaining = T(945296513395, "<style PDATimelineMultiEventSubheader>First Event</style><newline>") .. remaining
          end
          local rolloverData = self.context.rolloverData
          self.idTimeContainer:SetVisible(not rolloverData or not rolloverData.futureEvent)
          self.idTime:SetText(T({
            888723273529,
            "<remaining><newline><left><exactDue>",
            remaining = remaining,
            exactDue = exactDue
          }))
          if multiEvents then
          end
          local inputHint = T(467579936265, "<image UI/Icons/left_click 1700> View Event Sector")
          local eventData = SatelliteTimelineEvents[event.typ]
          if eventData and not multiEvents then
            local text = eventData:OnClick(event)
            if text then
              text = T({
                566805811277,
                "<image UI/Icons/right_click 1700> <text>",
                text = text
              })
              inputHint = text .. " " .. inputHint
            end
          end
          self.idInputHint:SetText(inputHint)
        end
      }),
      PlaceObj("XTemplateWindow", {
        "Dock",
        "top",
        "DrawOnTop",
        true,
        "Background",
        RGBA(52, 55, 61, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "Margins",
          box(10, 0, 0, 0),
          "Padding",
          box(0, 0, 0, 0),
          "Clip",
          false,
          "UseClipBox",
          false,
          "FoldWhenHidden",
          true,
          "TextStyle",
          "PDACombatActionHeader",
          "Translate",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "HAlign",
          "right",
          "VAlign",
          "center",
          "MinWidth",
          21,
          "MinHeight",
          21,
          "MaxWidth",
          21,
          "MaxHeight",
          21,
          "Background",
          RGBA(69, 73, 81, 255)
        })
      }),
      PlaceObj("XTemplateWindow", {
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateForEach", {
          "comment",
          "event data",
          "array",
          function(parent, context)
            return context.rolloverData
          end,
          "__context",
          function(parent, context, item, i, n)
            return item
          end,
          "run_after",
          function(child, context, item, i, n, last)
            local textsConcat = table.concat(item.texts, "\n")
            child.idText:SetText(textsConcat)
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XContextWindow",
            "IdNode",
            true,
            "Margins",
            box(0, 6, 0, 0),
            "Padding",
            box(8, 8, 8, 8),
            "LayoutMethod",
            "VList",
            "Background",
            RGBA(32, 35, 47, 255)
          }, {
            PlaceObj("XTemplateWindow", {
              "Background",
              RGBA(32, 35, 47, 255)
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idText",
                "Clip",
                false,
                "UseClipBox",
                false,
                "TextStyle",
                "PDARolloverText",
                "Translate",
                true
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__condition",
              function(parent, context)
                return context and context.mercs and #context.mercs > 0
              end,
              "Id",
              "idMercs",
              "Margins",
              box(0, 6, 0, 0),
              "LayoutMethod",
              "HWrap",
              "LayoutHSpacing",
              8,
              "LayoutVSpacing",
              8,
              "FoldWhenHidden",
              true,
              "Background",
              RGBA(32, 35, 47, 255)
            }, {
              PlaceObj("XTemplateForEach", {
                "array",
                function(parent, context)
                  return context.mercs
                end,
                "__context",
                function(parent, context, item, i, n)
                  return item
                end
              }, {
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "just a list of mercs",
                  "__class",
                  "XContextWindow",
                  "IdNode",
                  true,
                  "HAlign",
                  "center",
                  "VAlign",
                  "top",
                  "ScaleModifier",
                  point(800, 800),
                  "ContextUpdateOnOpen",
                  true,
                  "OnContextUpdate",
                  function(self, context, ...)
                    local unit = g_Classes[context]
                    self.idPortrait:SetImage(unit.Portrait)
                  end
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
                    "MaxHeight",
                    55,
                    "ImageFit",
                    "height",
                    "ImageRect",
                    box(36, 0, 264, 246)
                  })
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__condition",
              function(parent, context)
                return context and context.mercs and context.mercs.leftSide and context.mercs.rightSide
              end,
              "__class",
              "XContextWindow",
              "Id",
              "idMercs",
              "FoldWhenHidden",
              true,
              "Background",
              RGBA(32, 35, 47, 255)
            }, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "left/right split",
                "__class",
                "XContextWindow",
                "IdNode",
                true,
                "Dock",
                "bottom",
                "VAlign",
                "top",
                "LayoutMethod",
                "HWrap",
                "LayoutHSpacing",
                30,
                "LayoutVSpacing",
                10
              }, {
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "left",
                  "__context",
                  function(parent, context)
                    return context.mercs.leftSide
                  end,
                  "__class",
                  "XContextWindow",
                  "IdNode",
                  true,
                  "LayoutMethod",
                  "VList",
                  "LayoutHSpacing",
                  10,
                  "ContextUpdateOnOpen",
                  true,
                  "OnContextUpdate",
                  function(self, context, ...)
                    self.idText:SetText(context.Name)
                  end
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idText",
                    "Margins",
                    box(-2, 0, 0, 0),
                    "Clip",
                    false,
                    "UseClipBox",
                    false,
                    "FoldWhenHidden",
                    true,
                    "TextStyle",
                    "PDAQuests_HeaderSmall",
                    "Translate",
                    true,
                    "HideOnEmpty",
                    true
                  }),
                  PlaceObj("XTemplateWindow", {
                    "LayoutMethod",
                    "HWrap",
                    "LayoutHSpacing",
                    8,
                    "LayoutVSpacing",
                    8
                  }, {
                    PlaceObj("XTemplateForEach", {
                      "array",
                      function(parent, context)
                        return context.List
                      end,
                      "__context",
                      function(parent, context, item, i, n)
                        return item
                      end,
                      "run_after",
                      function(child, context, item, i, n, last)
                        local unit = g_Classes[context]
                        child.idPortrait:SetImage(unit.Portrait)
                      end
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XImage",
                        "HAlign",
                        "center",
                        "VAlign",
                        "top",
                        "ScaleModifier",
                        point(800, 800),
                        "Image",
                        "UI/Hud/portrait_background",
                        "ImageFit",
                        "stretch"
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
                          "MaxHeight",
                          52,
                          "ImageFit",
                          "height",
                          "ImageRect",
                          box(36, 0, 264, 246)
                        })
                      })
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "left",
                  "__context",
                  function(parent, context)
                    return context.mercs.rightSide
                  end,
                  "__class",
                  "XContextWindow",
                  "IdNode",
                  true,
                  "LayoutMethod",
                  "VList",
                  "LayoutHSpacing",
                  10,
                  "ContextUpdateOnOpen",
                  true,
                  "OnContextUpdate",
                  function(self, context, ...)
                    self.idText:SetText(context.Name)
                  end
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idText",
                    "Margins",
                    box(-2, 0, 0, 0),
                    "Clip",
                    false,
                    "UseClipBox",
                    false,
                    "FoldWhenHidden",
                    true,
                    "TextStyle",
                    "PDAQuests_HeaderSmall",
                    "Translate",
                    true,
                    "HideOnEmpty",
                    true
                  }),
                  PlaceObj("XTemplateWindow", {
                    "LayoutMethod",
                    "HWrap",
                    "LayoutHSpacing",
                    8,
                    "LayoutVSpacing",
                    8
                  }, {
                    PlaceObj("XTemplateForEach", {
                      "array",
                      function(parent, context)
                        return context.List
                      end,
                      "__context",
                      function(parent, context, item, i, n)
                        return item
                      end,
                      "run_after",
                      function(child, context, item, i, n, last)
                        local unit = g_Classes[context]
                        child.idPortrait:SetImage(unit.Portrait)
                      end
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XImage",
                        "HAlign",
                        "center",
                        "VAlign",
                        "top",
                        "ScaleModifier",
                        point(800, 800),
                        "Image",
                        "UI/Hud/portrait_background",
                        "ImageFit",
                        "stretch"
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
                          "MaxHeight",
                          52,
                          "ImageFit",
                          "height",
                          "ImageRect",
                          box(36, 0, 264, 246)
                        })
                      })
                    })
                  })
                })
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idHintContainer",
          "Margins",
          box(0, 6, 0, 0),
          "Padding",
          box(8, 8, 8, 8),
          "FoldWhenHidden",
          true,
          "Background",
          RGBA(32, 35, 47, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idHint",
            "Clip",
            false,
            "UseClipBox",
            false,
            "TextStyle",
            "PDARolloverTextHint",
            "Translate",
            true
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idTimeContainer",
          "Margins",
          box(0, 6, 0, 0),
          "Padding",
          box(8, 8, 8, 8),
          "FoldWhenHidden",
          true,
          "Background",
          RGBA(32, 35, 47, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idTime",
            "Clip",
            false,
            "UseClipBox",
            false,
            "TextStyle",
            "PDARolloverText",
            "Translate",
            true
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idInputContainer",
          "Margins",
          box(0, 6, 0, 0),
          "Padding",
          box(8, 8, 8, 8),
          "FoldWhenHidden",
          true,
          "Background",
          RGBA(32, 35, 47, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idInputHint",
            "Clip",
            false,
            "UseClipBox",
            false,
            "TextStyle",
            "PDARolloverText",
            "Translate",
            true
          })
        })
      })
    })
  })
})
