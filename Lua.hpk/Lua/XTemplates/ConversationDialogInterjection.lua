PlaceObj("XTemplate", {
  group = "Zulu",
  id = "ConversationDialogInterjection",
  PlaceObj("XTemplateWindow", {"IdNode", true}, {
    PlaceObj("XTemplateWindow", {
      "Margins",
      box(0, 0, 12, 0),
      "Dock",
      "left",
      "UseClipBox",
      false
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idLongestInterjectionName",
        "Clip",
        false,
        "UseClipBox",
        false,
        "Visible",
        false,
        "FadeInTime",
        100,
        "FadeOutTime",
        100,
        "HandleMouse",
        false,
        "TextStyle",
        "PDARolloverHeader",
        "Translate",
        true
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idCharacterName",
        "Clip",
        false,
        "UseClipBox",
        false,
        "FadeInTime",
        100,
        "FadeOutTime",
        100,
        "HandleMouse",
        false,
        "TextStyle",
        "ConversationNameInterjection",
        "Translate",
        true
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        context.em = "<color 196 175 117>"
        return context
      end,
      "__class",
      "XText",
      "Id",
      "idPhrase",
      "Padding",
      box(2, 6, 2, 2),
      "HAlign",
      "left",
      "VAlign",
      "top",
      "OnLayoutComplete",
      function(self)
        local dlg = GetDialog(self)
        dlg:SetupBackgroundSizeAndScrolling(self)
      end,
      "Clip",
      false,
      "UseClipBox",
      false,
      "FadeInTime",
      100,
      "FadeOutTime",
      100,
      "HandleMouse",
      false,
      "TextStyle",
      "ConversationPhrase",
      "Translate",
      true
    })
  })
})
