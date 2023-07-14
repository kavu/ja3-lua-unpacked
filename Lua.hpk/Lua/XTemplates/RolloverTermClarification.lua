PlaceObj("XTemplate", {
  group = "Zulu Rollover",
  id = "RolloverTermClarification",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextWindow",
    "IdNode",
    true,
    "Margins",
    box(10, 0, 10, 0),
    "Dock",
    "left",
    "VAlign",
    "bottom",
    "MaxWidth",
    400,
    "UseClipBox",
    false,
    "ChildrenHandleMouse",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextControl",
      "Id",
      "idContent",
      "Padding",
      box(6, 6, 6, 6),
      "LayoutMethod",
      "VList",
      "LayoutVSpacing",
      5,
      "UseClipBox",
      false,
      "Background",
      RGBA(52, 55, 61, 255),
      "BackgroundRectGlowSize",
      2,
      "BackgroundRectGlowColor",
      RGBA(32, 35, 47, 255),
      "OnContextUpdate",
      function(self, context, ...)
        local control = context.control
        if control and control.yellow then
          self:SetBackground(0)
        end
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return context and context.control and context.control.yellow
        end,
        "__class",
        "XFrame",
        "Id",
        "idYellowBackground",
        "IdNode",
        false,
        "Margins",
        box(-7, -7, -7, -7),
        "Dock",
        "box",
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        5,
        "UseClipBox",
        false,
        "Image",
        "UI/PDA/imp_panel_2",
        "FrameBox",
        box(5, 5, 5, 5)
      }),
      PlaceObj("XTemplateForEach", {
        "array",
        function(parent, context)
          return context.terms
        end,
        "__context",
        function(parent, context, item, i, n)
          return Presets.GameTerm.Default[item]
        end,
        "run_after",
        function(child, context, item, i, n, last)
          if not context then
            return
          end
          child.idTitle:SetText(context.Name)
          child.idText:SetText(context.Description)
          if child.parent.context and child.parent.context.control and child.parent.context.control.yellow then
            child.idText:SetTextStyle("PDASectorInfo_Section")
            child:SetBackground(0)
          end
        end
      }, {
        PlaceObj("XTemplateWindow", {
          "IdNode",
          true,
          "Background",
          RGBA(32, 35, 47, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "LayoutMethod",
            "VList",
            "LayoutVSpacing",
            3
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idTitle",
              "Padding",
              box(8, 5, 8, -3),
              "FoldWhenHidden",
              true,
              "TextStyle",
              "PDACombatActionHeader",
              "Translate",
              true,
              "HideOnEmpty",
              true
            }),
            PlaceObj("XTemplateWindow", {
              "LayoutMethod",
              "VList",
              "LayoutVSpacing",
              3
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idText",
                "Padding",
                box(8, 0, 8, 5),
                "FoldWhenHidden",
                true,
                "TextStyle",
                "PDARolloverText",
                "Translate",
                true,
                "HideOnEmpty",
                true
              })
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "more info observer",
      "__context",
      function(parent, context)
        return "g_RolloverShowMoreInfo"
      end,
      "__class",
      "XContextWindow",
      "Dock",
      "ignore",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        self.parent:SetVisible(next(self.parent.context.terms) and g_RolloverShowMoreInfo)
      end
    })
  })
})
