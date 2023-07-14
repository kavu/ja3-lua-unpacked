PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAMessengerLine",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextWindow",
    "IdNode",
    true,
    "Margins",
    box(0, 8, 0, 0),
    "LayoutMethod",
    "VList",
    "FoldWhenHidden",
    true,
    "ContextUpdateOnOpen",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      if context.textStyle ~= "MessengerChat" then
        self.idText:SetTextStyle(context.textStyle)
      elseif context.name and context.name ~= "" then
        self.idText:SetText(T(309188080002, "<style MessengerMercName><name>:</style> <text>"))
      else
        self.idText:SetText(T(688853402795, "<text>"))
      end
    end
  }, {
    PlaceObj("XTemplateWindow", {
      "Id",
      "idContent",
      "LayoutMethod",
      "VList",
      "FoldWhenHidden",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idText",
        "HAlign",
        "left",
        "TextStyle",
        "MessengerChat",
        "Translate",
        true,
        "Text",
        T(726629223218, "<name> <text>")
      })
    }),
    PlaceObj("XTemplateWindow", {
      "Id",
      "idTyping",
      "VAlign",
      "top",
      "Visible",
      false,
      "FoldWhenHidden",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idTypingText",
        "TextStyle",
        "MercStatName",
        "Translate",
        true,
        "Text",
        T(780491030656, "<text>")
      })
    })
  })
})
