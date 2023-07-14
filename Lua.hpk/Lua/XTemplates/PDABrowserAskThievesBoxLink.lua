PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDABrowserAskThievesBoxLink",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XText",
    "Margins",
    box(0, 3, 0, 0),
    "HAlign",
    "left",
    "VAlign",
    "top",
    "MouseCursor",
    "UI/Cursors/Pda_Hand.tga",
    "FXMouseIn",
    "buttonRollover",
    "FXPress",
    "buttonPress",
    "FXPressDisabled",
    "IactDisabled",
    "FocusedBackground",
    RGBA(255, 0, 0, 0),
    "TextStyle",
    "PDABrowserThievesBoxLinks",
    "Translate",
    true
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        self:SetText(self:GetProperty("HyperlinkText"))
        self:SetTextStyle(HyperlinkVisited(GetPDABrowserDialog(), self:GetProperty("HyperlinkLinkId")) and "PDABrowserThievesBoxLinksVisited" or "PDABrowserThievesBoxLinks")
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown",
      "func",
      function(self, ...)
        XText.OnMouseButtonDown(self, ...)
        local pdaBrowser = GetPDABrowserDialog()
        VisitHyperlink(pdaBrowser, self:GetProperty("HyperlinkLinkId"))
        self:SetTextStyle("PDABrowserThievesBoxLinksVisited")
        pdaBrowser:SetMode("page_error", "Error404")
      end
    })
  }),
  PlaceObj("XTemplateProperty", {
    "comment",
    "HyperlinkLinkId",
    "category",
    "General",
    "id",
    "HyperlinkLinkId",
    "editor",
    "text",
    "translate",
    false,
    "Set",
    function(self, value)
      self.HyperlinkLinkId = value
    end,
    "Get",
    function(self)
      return self.HyperlinkLinkId
    end
  }),
  PlaceObj("XTemplateProperty", {
    "comment",
    "HyperlinkText",
    "category",
    "General",
    "id",
    "HyperlinkText",
    "editor",
    "text",
    "Set",
    function(self, value)
      self.HyperlinkText = value
    end,
    "Get",
    function(self)
      return self.HyperlinkText
    end
  })
})
