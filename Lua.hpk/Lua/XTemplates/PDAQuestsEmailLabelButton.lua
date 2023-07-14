PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu PDA",
  id = "PDAQuestsEmailLabelButton",
  PlaceObj("XTemplateWindow", {
    "comment",
    "folder",
    "__class",
    "XContextWindow",
    "IdNode",
    true,
    "LayoutMethod",
    "HList",
    "FoldWhenHidden",
    true,
    "ContextUpdateOnOpen",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      local emails = GetReceivedEmailsWithLabel(context.id)
      if 0 < #emails then
        self:SetVisible(true)
        self.idIcon:SetVisible(true)
        self.idButton:SetEnabled(true)
      else
        self.idIcon:SetVisible(false)
        self.idButton:SetEnabled(false)
        if context.hiddenWhenEmpty then
          self:SetVisible(false)
        end
      end
    end
  }, {
    PlaceObj("XTemplateWindow", {
      "comment",
      "icon",
      "__class",
      "XContextImage",
      "Id",
      "idIcon",
      "Margins",
      box(0, 0, 4, 0),
      "Dock",
      "left",
      "Image",
      "UI/PDA/Quest/tab_email",
      "Columns",
      2,
      "ImageScale",
      point(900, 900),
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        if AnyUnreadEmails(context.id) then
          self:SetTransparency(0)
          self:SetDesaturation(0)
        else
          self:SetTransparency(175)
          self:SetDesaturation(255)
        end
      end
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "label",
      "__class",
      "XToggleButton",
      "Id",
      "idButton",
      "Margins",
      box(4, 0, 0, 0),
      "Padding",
      box(8, 9, 8, 9),
      "Dock",
      "box",
      "Background",
      RGBA(255, 255, 255, 0),
      "MouseCursor",
      "UI/Cursors/Pda_Hand.tga",
      "OnContextUpdate",
      function(self, context, ...)
        local emails = GetReceivedEmailsWithLabel(context.id)
        local text
        if 0 < #emails then
          text = T({
            993210992118,
            "<name> [<count>]",
            name = context.name,
            count = #emails
          })
        else
          text = T({
            629765447024,
            "<name>",
            name = context.name
          })
        end
        self:SetText(text)
      end,
      "FXPress",
      "buttonPressNotesList",
      "FXPressDisabled",
      "IactDisabled",
      "OnPress",
      function(self, gamepad)
        local emailDialog = GetDialog(self)
        emailDialog:SelectLabel(self:GetContext().id)
      end,
      "RolloverBackground",
      RGBA(215, 159, 80, 128),
      "PressedBackground",
      RGBA(215, 159, 80, 255),
      "TextStyle",
      "PDAQuests_Label",
      "Translate",
      true,
      "Text",
      T(986604898049, "<name> [count]"),
      "ToggledBackground",
      RGBA(215, 159, 80, 255)
    })
  })
})
