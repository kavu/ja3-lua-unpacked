PlaceObj("XTemplate", {
  __is_kind_of = "XImage",
  group = "Zulu",
  id = "StatusEffectIcon",
  PlaceObj("XTemplateWindow", {
    "__class",
    "StatusEffectIcon",
    "MouseCursor",
    "UI/Cursors/Cursor.tga"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Padding",
      box(0, 2, 4, 0),
      "HAlign",
      "right",
      "VAlign",
      "bottom",
      "Clip",
      false,
      "UseClipBox",
      false,
      "HandleMouse",
      false,
      "ChildrenHandleMouse",
      false,
      "TextStyle",
      "DescriptionTextWhiteGlow",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        self:SetVisible(context.stacks and context.stacks > 1)
        self:SetText(Untranslated(context.stacks))
        XContextControl.OnContextUpdate(self, context)
      end,
      "Translate",
      true,
      "TextHAlign",
      "right",
      "TextVAlign",
      "bottom"
    })
  })
})
