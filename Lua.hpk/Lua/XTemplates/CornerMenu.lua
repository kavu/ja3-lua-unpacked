PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "Zulu",
  id = "CornerMenu",
  PlaceObj("XTemplateWindow", {
    "Id",
    "idMenu",
    "HAlign",
    "right",
    "VAlign",
    "top",
    "OnLayoutComplete",
    function(self)
      if CurrentActionCamera then
        self:SetVisible(false)
      end
    end,
    "LayoutMethod",
    "VList"
  }, {
    PlaceObj("XTemplateTemplate", {
      "__template",
      "QuestTracker",
      "FoldWhenHidden",
      true
    }),
    PlaceObj("XTemplateTemplate", {
      "__template",
      "QuestTrackerNewlyAdded"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "combat_tasks"
      end,
      "__class",
      "XContentTemplate",
      "IdNode",
      false
    }, {
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return GetCombatTasksInSector()
        end,
        "__class",
        "XContextWindow",
        "Id",
        "idCombatTasks",
        "IdNode",
        true,
        "Margins",
        box(0, 4, 0, 4),
        "LayoutMethod",
        "VList",
        "Visible",
        false,
        "FoldWhenHidden",
        true,
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          self:SetVisible(context and 0 < #context and not gv_SatelliteView and not gv_Cheats.OptionalUIHidden)
        end
      }, {
        PlaceObj("XTemplateForEach", {
          "comment",
          "Active Combat Task",
          "__context",
          function(parent, context, item, i, n)
            return item
          end
        }, {
          PlaceObj("XTemplateTemplate", {"__template", "CombatTask"})
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "tutorial hints",
      "__context",
      function(parent, context)
        return TutorialHintsState
      end,
      "__class",
      "XContentTemplate",
      "Margins",
      box(0, 1, 0, 0),
      "MinWidth",
      360,
      "MaxWidth",
      360
    }, {
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return TutorialGetCurrentHints()
        end,
        "__class",
        "XContextWindow",
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        10
      }, {
        PlaceObj("XTemplateForEach", {
          "condition",
          function(parent, context, item, i)
            return i < 5
          end,
          "__context",
          function(parent, context, item, i, n)
            return item
          end,
          "run_after",
          function(child, context, item, i, n, last)
            child.idText:SetText(item.Title)
            child.idHintSection:SetVisible(not not item.Text)
            child.idHintText:SetText(item.Text)
          end
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "GenericHUDButtonFrame"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XButton",
              "IdNode",
              false,
              "LayoutMethod",
              "VList",
              "Background",
              RGBA(0, 0, 0, 0),
              "ChildrenHandleMouse",
              true,
              "FocusedBorderColor",
              RGBA(0, 0, 0, 0),
              "FocusedBackground",
              RGBA(0, 0, 0, 0),
              "DisabledBorderColor",
              RGBA(0, 0, 0, 0),
              "OnPress",
              function(self, gamepad)
                OpenHelpMenu(self.context.preset.id)
              end,
              "RolloverBackground",
              RGBA(0, 0, 0, 0),
              "PressedBackground",
              RGBA(0, 0, 0, 0)
            }, {
              PlaceObj("XTemplateWindow", {
                "Margins",
                box(3, 2, 3, 0)
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idText",
                  "Margins",
                  box(3, 0, 0, 0),
                  "HandleMouse",
                  false,
                  "FocusedBorderColor",
                  RGBA(0, 0, 0, 0),
                  "DisabledBorderColor",
                  RGBA(0, 0, 0, 0),
                  "TextStyle",
                  "PDAQuests_SectionHeader",
                  "Translate",
                  true
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XTextButton",
                  "Margins",
                  box(3, 0, 0, 0),
                  "Dock",
                  "right",
                  "Background",
                  RGBA(0, 0, 0, 0),
                  "FocusedBorderColor",
                  RGBA(0, 0, 0, 0),
                  "FocusedBackground",
                  RGBA(0, 0, 0, 0),
                  "DisabledBorderColor",
                  RGBA(0, 0, 0, 0),
                  "OnPress",
                  function(self, gamepad)
                    TutorialDismissHint(self.context.preset)
                  end,
                  "RolloverBackground",
                  RGBA(0, 0, 0, 0),
                  "PressedBackground",
                  RGBA(0, 0, 0, 0),
                  "TextStyle",
                  "DescriptionTextLightYellowBiggerNoRollover",
                  "Text",
                  "X"
                })
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "instructions for the user",
                "Id",
                "idHintSection",
                "Margins",
                box(0, -3, 0, 0),
                "Visible",
                false,
                "FoldWhenHidden",
                true
              }, {
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "h line",
                  "__class",
                  "XFrame",
                  "Margins",
                  box(8, 0, 5, 0),
                  "VAlign",
                  "top",
                  "Image",
                  "UI/PDA/separate_line_vertical",
                  "FrameBox",
                  box(3, 0, 3, 0),
                  "SqueezeY",
                  false
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idHintText",
                  "Margins",
                  box(4, 3, 0, 0),
                  "HAlign",
                  "left",
                  "HandleMouse",
                  false,
                  "TextStyle",
                  "Hiring_Filter_blue_Unselected",
                  "Translate",
                  true
                })
              })
            })
          })
        })
      })
    })
  })
})
