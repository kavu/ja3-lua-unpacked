PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAQuestsHistoryDayList",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextWindow",
    "IdNode",
    true,
    "Margins",
    box(0, 0, 0, 8),
    "LayoutMethod",
    "VList",
    "ContextUpdateOnOpen",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      local dlg = GetDialog(self)
      local bullet = self:ResolveId("idDayBullet")
      local backgroundWindow = self:ResolveId("idDayBackground")
      local dayText = self:ResolveId("idDayText")
      if context.day == dlg.selectedDay then
        bullet:SetImage("UI/PDA/Quest/bullet_selected")
        backgroundWindow:SetBackground(RGBA(88, 92, 68, 125))
        dayText:SetTextStyle("PDAQuestTitleInfo")
      else
        bullet:SetImage("UI/PDA/Quest/bullet")
        backgroundWindow:SetBackground(RGBA(0, 0, 0, 0))
        dayText:SetTextStyle("PDAQuestSection")
      end
    end
  }, {
    PlaceObj("XTemplateWindow", {
      "comment",
      "header",
      "Id",
      "idDayHeader",
      "LayoutMethod",
      "VList"
    }, {
      PlaceObj("XTemplateWindow", {
        "VAlign",
        "top",
        "LayoutMethod",
        "HList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContextImage",
          "Id",
          "idDayBullet",
          "Padding",
          box(16, 8, 0, 0),
          "Image",
          "UI/PDA/Quest/bullet"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContextWindow",
          "Id",
          "idDayBackground",
          "Margins",
          box(40, 0, 0, 0),
          "Dock",
          "box",
          "VAlign",
          "top",
          "MinHeight",
          36,
          "MaxHeight",
          36,
          "LayoutMethod",
          "HList"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idDayText",
            "Padding",
            box(4, 2, 2, 2),
            "TextStyle",
            "PDAQuestSection",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local dlg = GetDialog(self)
              local text = T(257959108167, "Day <day>")
              self:SetText(text)
              return XContextControl.OnContextUpdate(self, context)
            end,
            "Translate",
            true,
            "TextHAlign",
            "center",
            "TextVAlign",
            "bottom"
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "time",
            "__class",
            "XText",
            "Margins",
            box(0, 0, 4, 0),
            "Dock",
            "right",
            "HAlign",
            "right",
            "VAlign",
            "bottom",
            "TextStyle",
            "PDAQuestsNoteText",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              if context and context[1] then
                self:SetText(T({
                  147546503736,
                  "<month(t)> <day(t)> <year(t)>",
                  t = context[1].time
                }))
              end
              return XContextControl.OnContextUpdate(self, context)
            end,
            "Translate",
            true
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "line below header",
        "Margins",
        box(16, 3, 0, 0),
        "VAlign",
        "top",
        "MinHeight",
        1,
        "MaxHeight",
        1,
        "Background",
        RGBA(88, 92, 68, 255)
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "placeholder",
      "Margins",
      box(10, 0, 0, 0),
      "HAlign",
      "left",
      "MinHeight",
      20,
      "MaxHeight",
      20
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "vertical line",
        "Margins",
        box(30, 0, 0, 0),
        "HAlign",
        "left",
        "MinWidth",
        1,
        "MaxWidth",
        1,
        "Background",
        RGBA(88, 92, 68, 255)
      })
    }),
    PlaceObj("XTemplateForEach", {
      "comment",
      "occurence",
      "condition",
      function(parent, context, item, i)
        local preset = HistoryOccurences[item.id]
        return preset and preset:GetText(item.context)
      end,
      "__context",
      function(parent, context, item, i, n)
        return item
      end
    }, {
      PlaceObj("XTemplateTemplate", {
        "__template",
        "PDAQuestsHistoryOccurenceRow"
      })
    })
  })
})
