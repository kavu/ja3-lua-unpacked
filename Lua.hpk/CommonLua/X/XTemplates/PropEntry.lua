PlaceObj("XTemplate", {
  __is_kind_of = "XPropControl",
  group = "Common",
  id = "PropEntry",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__condition",
    function(parent, context)
      return context.prop_meta.separator
    end,
    "__class",
    "XPropControl",
    "HandleMouse",
    false,
    "ChildrenHandleMouse",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "TextStyle",
      "GedTitleDarkMode",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        self:SetText(context.prop_meta.separator)
        XContextControl.OnContextUpdate(self, context)
      end,
      "Translate",
      true,
      "TextHAlign",
      "center"
    })
  }),
  PlaceObj("XTemplateTemplate", {
    "__condition",
    function(parent, context)
      return context.prop_meta.editor == "bool"
    end,
    "__template",
    "PropBool"
  }),
  PlaceObj("XTemplateTemplate", {
    "__condition",
    function(parent, context)
      return context.prop_meta.editor == "number"
    end,
    "__template",
    "PropNumber"
  }),
  PlaceObj("XTemplateTemplate", {
    "__condition",
    function(parent, context)
      return context.prop_meta.editor == "combo" or context.prop_meta.editor == "choice"
    end,
    "__template",
    "PropChoice"
  }),
  PlaceObj("XTemplateTemplate", {
    "__condition",
    function(parent, context)
      return context.prop_meta.editor == "hotkey"
    end,
    "__template",
    "PropKeybinding"
  })
})
