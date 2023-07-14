PlaceObj("XTemplate", {
  __is_kind_of = "XContextControl",
  group = "Zulu PDA",
  id = "PDAImpHyperlinkHeader",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return "update link"
    end,
    "__class",
    "XContextControl",
    "HAlign",
    "center",
    "VAlign",
    "top",
    "MinWidth",
    56,
    "MinHeight",
    56,
    "MouseCursor",
    "UI/Cursors/Pda_Hand.tga",
    "OnContextUpdate",
    function(self, context, ...)
      XContextControl.OnContextUpdate(self, context)
      local dlg = GetDialog(self)
      if dlg.clicked_links[rawget(self, "linkid")] then
        self.idLink:SetTextStyle("PDAIMPHyperLinkClicked")
        self.idLink:OnSetRollover(true)
      end
    end,
    "FXMouseIn",
    "buttonRollover",
    "FXPress",
    "buttonPress",
    "FXPressDisabled",
    "IactDisabled"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idLink",
      "Dock",
      "box",
      "HAlign",
      "left",
      "VAlign",
      "center",
      "TextStyle",
      "PDAIMPContentTitleActive",
      "Translate",
      true
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        XContextControl.OnMouseButtonDown(self, pos, button)
        if not self:GetEnabled() then
          return " break"
        end
        if button == "L" then
          local dlg = GetDialog(self)
          local link_id = rawget(self, "LinkId")
          dlg.clicked_links = dlg.clicked_links or {}
          dlg.clicked_links[link_id] = true
          self:OnClick(dlg)
          return " break"
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnClick(self, dlg)",
      "func",
      function(self, dlg)
        dlg:SetMode(self.dlg_mode)
      end
    })
  }),
  PlaceObj("XTemplateFunc", {
    "name",
    "SetEnabled(self, enabled)",
    "func",
    function(self, enabled)
      XContextControl.SetEnabled(enabled)
      self.idLink:SetEnabled(enabled)
    end
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "LinkId",
    "editor",
    "text",
    "default",
    "link",
    "translate",
    false,
    "Set",
    function(self, value)
      rawset(self, "LinkId", value)
    end,
    "Get",
    function(self)
      return rawget(self, "LinkId")
    end,
    "help",
    T(800244591703, "Link Id to save clicked links")
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "dlg_mode",
    "editor",
    "text",
    "default",
    "error",
    "translate",
    false,
    "Set",
    function(self, value)
      rawset(self, "dlg_mode", value)
    end,
    "Get",
    function(self)
      return rawget(self, "dlg_mode")
    end,
    "name",
    T(905236412897, "Mode"),
    "help",
    T(884925934366, "Change dialog mode")
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "Text",
    "editor",
    "text",
    "Set",
    function(self, value)
      self.idLink:SetText(value)
    end,
    "Get",
    function(self)
      return self.idLink:GetText()
    end,
    "name",
    T(127827187720, "Text"),
    "help",
    T(122819879657, "Links' text")
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "TextHAlign",
    "editor",
    "choice",
    "default",
    "center",
    "items",
    function(self)
      return {
        "left",
        "center",
        "right"
      }
    end,
    "Set",
    function(self, value)
      self.idLink:SetTextHAlign(value)
    end,
    "Get",
    function(self)
      return self.idLink:GetTextHAlign()
    end
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "TextVAlign",
    "editor",
    "choice",
    "default",
    "center",
    "items",
    function(self)
      return {
        "top",
        "center",
        "bottom"
      }
    end,
    "Set",
    function(self, value)
      self.idLink:SetTextVAlign(value)
    end,
    "Get",
    function(self)
      return self.idLink:GetTextVAlign()
    end
  })
})
