PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDABrowserBanner",
  PlaceObj("XTemplateProperty", {
    "id",
    "LinkId",
    "editor",
    "text",
    "translate",
    false,
    "Set",
    function(self, value)
      self.LinkId = value
    end,
    "Get",
    function(self)
      return self.LinkId
    end
  }),
  PlaceObj("XTemplateWindow", {
    "__class",
    "XButton",
    "IdNode",
    false,
    "HAlign",
    "center",
    "VAlign",
    "center",
    "MouseCursor",
    "UI/Cursors/Pda_Hand.tga",
    "OnPress",
    function(self, gamepad)
      local mode = self.LinkId:starts_with("Error") and "page_error" or "banner_page"
      DockBrowserTab(mode)
      GetPDABrowserDialog():SetMode(mode, self.LinkId)
    end
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Image",
      "UI/PDA/imp_banner_01"
    })
  })
})
