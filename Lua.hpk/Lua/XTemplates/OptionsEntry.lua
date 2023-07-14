PlaceObj("XTemplate", {
  __is_kind_of = "XPropControl",
  group = "Zulu",
  id = "OptionsEntry",
  PlaceObj("XTemplateWindow", {
    "__condition",
    function(parent, context)
      return context.prop_meta.separator and (context.prop_meta.category == "Keybindings" or context.prop_meta.category == "Mod")
    end,
    "__class",
    "XPropControl",
    "MinWidth",
    600,
    "MinHeight",
    64,
    "MaxWidth",
    600,
    "MaxHeight",
    64,
    "Background",
    RGBA(255, 255, 255, 0),
    "HandleMouse",
    false,
    "ChildrenHandleMouse",
    false,
    "FocusedBorderColor",
    RGBA(0, 0, 0, 0),
    "DisabledBorderColor",
    RGBA(0, 0, 0, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "Id",
      "idImg",
      "Dock",
      "box",
      "Transparency",
      64,
      "HandleKeyboard",
      false,
      "Image",
      "UI/Common/mm_panel",
      "SqueezeX",
      false,
      "SqueezeY",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "HandleKeyboard",
      false,
      "HandleMouse",
      false,
      "TextStyle",
      "APIndicator_Accent",
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
      "center",
      "TextVAlign",
      "center"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XBlurRect",
      "Dock",
      "box",
      "BlurRadius",
      10,
      "Mask",
      "UI/Common/mm_panel",
      "FrameLeft",
      15,
      "FrameRight",
      10
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "Id",
      "idEffect",
      "Margins",
      box(5, 5, 5, 5),
      "Dock",
      "box",
      "Transparency",
      179,
      "HandleKeyboard",
      false,
      "Image",
      "UI/Common/screen_effect",
      "ImageScale",
      point(100000, 1000),
      "TileFrame",
      true,
      "SqueezeX",
      false,
      "SqueezeY",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "UIEffectModifierId",
      "MainMenuMainBar",
      "Id",
      "idImg1",
      "Dock",
      "box",
      "Transparency",
      38,
      "HandleKeyboard",
      false,
      "Image",
      "UI/Common/mm_title",
      "SqueezeX",
      false,
      "SqueezeY",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Margins",
      box(20, 0, 0, 0),
      "HAlign",
      "left",
      "VAlign",
      "center",
      "MinWidth",
      300,
      "MaxWidth",
      300,
      "HandleKeyboard",
      false,
      "HandleMouse",
      false,
      "TextStyle",
      "PDABrowserHeader",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        self:SetText(context.prop_meta.separator)
        XContextControl.OnContextUpdate(self, context)
      end,
      "Translate",
      true,
      "WordWrap",
      false,
      "TextVAlign",
      "center"
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "IsSelectable(self)",
      "func",
      function(self)
        return not self.context.prop_meta.separator or self.context.prop_meta.category ~= "Mod"
      end
    })
  }),
  PlaceObj("XTemplateTemplate", {
    "__condition",
    function(parent, context)
      return context.prop_meta.editor == "bool"
    end,
    "__template",
    "PropBool",
    "MouseCursor",
    "UI/Cursors/Hand.tga",
    "FXPress",
    "MainMenuButtonClick"
  }),
  PlaceObj("XTemplateTemplate", {
    "__condition",
    function(parent, context)
      return context.prop_meta.editor == "number"
    end,
    "__template",
    "PropNumber",
    "MouseCursor",
    "UI/Cursors/Hand.tga",
    "FXPress",
    "MainMenuSliderClick"
  }),
  PlaceObj("XTemplateTemplate", {
    "__condition",
    function(parent, context)
      return context.prop_meta.editor == "combo" or context.prop_meta.editor == "choice"
    end,
    "__template",
    "PropChoice",
    "MouseCursor",
    "UI/Cursors/Hand.tga",
    "FXPress",
    "MainMenuButtonClick"
  }),
  PlaceObj("XTemplateTemplate", {
    "__condition",
    function(parent, context)
      return context.prop_meta.editor == "hotkey"
    end,
    "__template",
    "PropKeybinding",
    "MouseCursor",
    "UI/Cursors/Hand.tga",
    "FXPress",
    "MainMenuButtonClick"
  })
})
