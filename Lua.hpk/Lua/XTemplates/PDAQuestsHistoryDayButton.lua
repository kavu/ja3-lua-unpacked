PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu PDA",
  id = "PDAQuestsHistoryDayButton",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDAQuestsHistoryDayButtonClass",
    "IdNode",
    true,
    "Padding",
    box(22, 0, 0, 0),
    "MinHeight",
    36,
    "MaxHeight",
    36,
    "FoldWhenHidden",
    true,
    "HandleMouse",
    true,
    "ContextUpdateOnOpen",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      local button = self:ResolveId("idButton")
      button:SetContext(context)
      local icon = self:ResolveId("idIcon")
      icon:SetContext(context)
    end
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextImage",
      "Id",
      "idIcon",
      "Margins",
      box(8, 0, 4, 0),
      "Dock",
      "left",
      "Image",
      "UI/PDA/Quest/bullet_selected"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XToggleButton",
      "Id",
      "idButton",
      "IdNode",
      false,
      "Margins",
      box(4, 0, 0, 0),
      "Background",
      RGBA(255, 255, 255, 0),
      "MouseCursor",
      "UI/Cursors/Pda_Hand.tga",
      "OnContextUpdate",
      function(self, context, ...)
        local text = T({
          257959108167,
          "Day <day>",
          day = context
        })
        self:SetText(text)
        return XContextControl.OnContextUpdate(self, context)
      end,
      "FXMouseIn",
      "buttonRollover",
      "FXPress",
      "buttonPressNotesList",
      "FXPressDisabled",
      "IactDisabled",
      "FocusedBackground",
      RGBA(215, 159, 80, 255),
      "DisabledBorderColor",
      RGBA(0, 0, 0, 0),
      "OnPress",
      function(self, gamepad)
        local dlg = GetDialog(self)
        dlg:SelectDay(self:GetContext())
      end,
      "RolloverBackground",
      RGBA(215, 159, 80, 128),
      "PressedBackground",
      RGBA(215, 159, 80, 255),
      "TextStyle",
      "PDAQuests_Label",
      "Translate",
      true,
      "ToggledBackground",
      RGBA(215, 159, 80, 255)
    })
  })
})
