PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAImpOutcome",
  PlaceObj("XTemplateProperty", {
    "id",
    "HeaderButtonId",
    "editor",
    "text",
    "translate",
    false,
    "Set",
    function(self, value)
      self.HeaderButtonId = value
    end,
    "Get",
    function(self)
      return self.HeaderButtonId
    end,
    "name",
    T(298816813682, "HeaderButtonId")
  }),
  PlaceObj("XTemplateWindow", {
    "LayoutMethod",
    "VList",
    "LayoutVSpacing",
    8
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XWindow.Open(self, ...)
        PDAImpHeaderEnable(self)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete",
      "func",
      function(self, ...)
        XWindow.OnDelete(self, ...)
        PDAImpHeaderDisable(self)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextFrame",
      "Image",
      "UI/PDA/imp_panel",
      "FrameBox",
      box(8, 8, 8, 8),
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local texts = {}
        local max_stat = table.max(context.stats, function(m)
          return m.value
        end)
        if max_stat then
          texts[#texts + 1] = ImpQuestions["Outcome_" .. max_stat.stat].question
        end
        local pperk = context.perks.personal
        local data = ImpQuestions["Outcome_" .. pperk.perk]
        if data then
          texts[#texts + 1] = data.question
        end
        local tperk = context.perks.tactical
        data = ImpQuestions["Outcome_" .. tperk[1].perk]
        local data2 = ImpQuestions["Outcome_" .. tperk[2].perk]
        if data and data2 then
          if tperk[1].value == tperk[2].value then
            data = AsyncRand(100) < 50 and data or data2
          else
            data = tperk[1].value > tperk[2].value and data or data2
          end
        else
          data = data or data2
        end
        if data then
          texts[#texts + 1] = data.question
        end
        self.idText:SetText(table.concat(texts, [[


]]))
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(20, 20, 20, 20),
        "LayoutMethod",
        "VList",
        "ChildrenHandleMouse",
        false
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "Padding",
          box(0, 0, 0, 0),
          "HAlign",
          "left",
          "VAlign",
          "top",
          "TextStyle",
          "PDAIMPContentTitle",
          "Translate",
          true,
          "Text",
          T(177052366651, "<underline>Outcome</underline>")
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idText",
          "Padding",
          box(0, 0, 0, 0),
          "HAlign",
          "left",
          "VAlign",
          "top",
          "TextStyle",
          "PDAIMPContentText",
          "Translate",
          true
        })
      })
    })
  })
})
