PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAImpText",
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
    T(934614065801, "HeaderButtonId")
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
      "Id",
      "idInfo",
      "Image",
      "UI/PDA/imp_panel",
      "FrameBox",
      box(8, 8, 8, 8),
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local dlg = GetDialog(self)
        local mode_param = dlg.mode_param
        local texts = GetIMPTexts(mode_param)
        self.idTitle:SetText(texts.title)
        if texts.texts then
          self.idText:SetText(table.concat(texts.texts, [[


]]))
        else
          self.idText:SetText(texts.text)
        end
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(22, 22, 22, 22),
        "VAlign",
        "center",
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        16,
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
          true
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
