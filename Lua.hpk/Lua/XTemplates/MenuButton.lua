PlaceObj("XTemplate", {
  Comment = "copied from common; used for cheats, etc.",
  __is_kind_of = "XTextButton",
  group = "Zulu",
  id = "MenuButton",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XTextButton",
    "BorderWidth",
    2,
    "OnPressEffect",
    "action",
    "RolloverBackground",
    RGBA(170, 170, 170, 255),
    "RolloverBorderColor",
    RGBA(0, 0, 0, 255),
    "TextStyle",
    "PDACommonButtonChat",
    "Translate",
    true
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetFocus",
      "func",
      function(self, ...)
        XCreateRolloverWindow(self, true)
        XTextButton.OnSetFocus(self, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetSelected(self, selected)",
      "func",
      function(self, selected)
        self:SetFocus(selected)
      end
    })
  })
})
