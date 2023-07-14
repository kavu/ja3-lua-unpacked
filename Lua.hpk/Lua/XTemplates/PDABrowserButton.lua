PlaceObj("XTemplate", {
  __is_kind_of = "XSelectableTextButton",
  group = "Zulu PDA",
  id = "PDABrowserButton",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XSelectableTextButton",
    "Margins",
    box(0, 0, 15, 0),
    "Padding",
    box(5, 2, 5, 2),
    "Dock",
    "left",
    "LayoutMethod",
    "Box",
    "FoldWhenHidden",
    true,
    "MouseCursor",
    "UI/Cursors/Pda_Hand.tga",
    "DisabledBackground",
    RGBA(255, 255, 255, 255),
    "Image",
    "UI/PDA/T_PDA_BrowserButton",
    "TextStyle",
    "PDACommonButton",
    "ColumnsUse",
    "abcca"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "UpdateState(self)",
      "func",
      function(self)
        XSelectableTextButton.UpdateState(self)
        local state = self.cosmetic_state
        if state == "selected" then
          self:SetColumnsUse("ccccc")
        else
          self:SetColumnsUse("bbccb")
        end
      end
    })
  })
})
