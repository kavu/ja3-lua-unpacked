PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu PDA",
  id = "PDAQuestSection",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextWindow",
    "IdNode",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idText",
      "VAlign",
      "center",
      "HandleMouse",
      false,
      "TextStyle",
      "PDAQuestSection",
      "Translate",
      true,
      "Text",
      T(559745808809, "<Name>"),
      "TextVAlign",
      "center"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XTextButton",
      "HAlign",
      "right",
      "VAlign",
      "center",
      "MouseCursor",
      "UI/Cursors/Pda_Hand.tga",
      "OnContextUpdate",
      function(self, context, ...)
        local section = self.parent
        local hidden = rawget(section, "hidekey-hidden")
        self:SetFlipY(hidden)
        self:SetText(self.Text)
        XContextControl.OnContextUpdate(self, context)
      end,
      "OnPress",
      function(self, gamepad)
        local section = self.parent
        local hidekeyPress = self.context.HideKey
        if not hidekeyPress then
          return
        end
        local hidden = rawget(section, "hidekey-hidden")
        hidden = not hidden
        section:ResolveId("node"):EnactHideKey(hidekeyPress, not hidden)
        rawset(section, "hidekey-hidden", hidden)
        self:OnContextUpdate()
      end,
      "Image",
      "UI/PDA/Quest/expand_arrow"
    })
  })
})
