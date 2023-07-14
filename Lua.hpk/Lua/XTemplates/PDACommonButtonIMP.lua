PlaceObj("XTemplate", {
  __is_kind_of = "PDACommonButtonClass",
  group = "Zulu PDA",
  id = "PDACommonButtonIMP",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDACommonButtonClass",
    "LayoutMethod",
    "Box",
    "DisabledBackground",
    RGBA(255, 255, 255, 255),
    "Image",
    "UI/PDA/imp_buttons",
    "FrameBox",
    box(10, 10, 10, 10),
    "TextStyle",
    "PDACommonButton",
    "Translate",
    true,
    "ColumnsUse",
    "abcca"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        PDACommonButtonClass.Open(self, ...)
        if self.shortcut_gamepad then
          self.shortcut_gamepad:SetUseClipBox(false)
        end
      end
    })
  })
})
