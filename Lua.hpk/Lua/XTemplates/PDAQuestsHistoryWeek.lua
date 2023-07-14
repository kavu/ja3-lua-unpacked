PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu PDA",
  id = "PDAQuestsHistoryWeek",
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
      "PDAQuests_SectionHeader",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local text = T({
          327003882779,
          "Week <week>",
          week = context
        })
        self:SetText(text)
        return XContextControl.OnContextUpdate(self, context)
      end,
      "Translate",
      true,
      "Text",
      T(466367765749, "Week"),
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
        local hidekeyPress = self:GetContext()
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
