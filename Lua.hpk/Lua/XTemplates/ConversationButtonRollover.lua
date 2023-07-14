PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu",
  id = "ConversationButtonRollover",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XRolloverWindow",
    "BorderWidth",
    0,
    "MaxWidth",
    420,
    "UseClipBox",
    false,
    "Background",
    RGBA(240, 240, 240, 0),
    "FocusedBackground",
    RGBA(240, 240, 240, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextControl",
      "Id",
      "idContent",
      "UseClipBox",
      false,
      "OnContextUpdate",
      function(self, context, ...)
        local control = context.control
        self.idText:SetText(control:GetRolloverText() or context.RolloverText ~= "" and context.RolloverText)
        self.idText:SetContext(context)
      end
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
        end
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "shadow",
        "__class",
        "XFrame",
        "IdNode",
        false,
        "Margins",
        box(0, 15, 10, 0),
        "UseClipBox",
        false,
        "Background",
        RGBA(0, 0, 0, 255),
        "FocusedBackground",
        RGBA(255, 255, 255, 0),
        "Image",
        "UI/Conversation/T_Choice_Rollover_Background"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "IdNode",
        false,
        "Margins",
        box(10, 0, 0, 15),
        "UseClipBox",
        false,
        "Background",
        RGBA(195, 189, 172, 255),
        "FocusedBackground",
        RGBA(255, 255, 255, 0),
        "Image",
        "UI/Conversation/T_Choice_Rollover_Background"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idText",
          "Padding",
          box(10, 10, 10, 10),
          "Clip",
          false,
          "UseClipBox",
          false,
          "TextStyle",
          "ConversationChoiceRollover",
          "Translate",
          true
        })
      })
    })
  })
})
