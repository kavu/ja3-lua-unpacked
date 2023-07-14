PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu PDA",
  id = "PDAImpHyperlink",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return "update link"
    end,
    "__class",
    "XContextControl",
    "HAlign",
    "left",
    "VAlign",
    "top",
    "LayoutMethod",
    "VList",
    "LayoutVSpacing",
    -5,
    "MouseCursor",
    "UI/Cursors/Pda_Hand.tga",
    "OnContextUpdate",
    function(self, context, ...)
      XContextWindow.OnContextUpdate(self, context)
      local dlg = GetDialog(self)
      local pdaBrowser = GetPDABrowserDialog()
      if HyperlinkVisited(pdaBrowser, self:GetProperty("LinkId")) then
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
      "HAlign",
      "left",
      "VAlign",
      "top",
      "MaxWidth",
      150,
      "MaxHeight",
      30,
      "MouseCursor",
      "UI/Cursors/Pda_Hand.tga",
      "FXMouseIn",
      "buttonRollover",
      "FXPress",
      "buttonPress",
      "FXPressDisabled",
      "IactDisabled",
      "TextStyle",
      "PDAIMPHyperLink",
      "Translate",
      true,
      "WordWrap",
      false,
      "Shorten",
      true
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "OnMouseButtonDown(self, pos, button)",
        "func",
        function(self, pos, button)
          XText.OnMouseButtonDown(self, pos, button)
          if button == "L" then
            if not self.parent:GetEnabled() then
              return
            end
            VisitHyperlink(GetPDABrowserDialog(), self.parent:GetProperty("LinkId"))
            self:SetTextStyle(rawget(self.parent, "Small") and "PDAIMPHyperLinkClickedSmall" or "PDAIMPHyperLinkClicked")
            self.parent:OnClick(GetDialog(self))
            ObjModified("update link")
          end
        end
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnClick(self, dlg)",
      "func",
      function(self, dlg)
        local pda_browser_dialog = GetPDABrowserDialog()
        if self:GetProperty("err_param"):starts_with("Error") then
          pda_browser_dialog:SetMode("page_error", self:GetProperty("err_param"))
        else
          dlg:SetMode("error", rawget(self, "err_param"))
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetEnabled(self, enabled)",
      "func",
      function(self, enabled)
        XContextControl.SetEnabled(self, enabled)
      end
    })
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
    T(956770454231, "Link Id to save clicked links")
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "Small",
    "translate",
    false,
    "Set",
    function(self, value)
      rawset(self, "Small", value)
      self.idLink:SetTextStyle("PDAIMPHyperLinkSmall")
    end,
    "Get",
    function(self)
      return rawget(self, "Small")
    end,
    "help",
    T(956770454231, "Link Id to save clicked links")
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
    T(263266603375, "Text"),
    "help",
    T(495939305203, "Links' text")
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "TextHAlign",
    "editor",
    "choice",
    "default",
    "left",
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
    "top",
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
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "ErrParam",
    "editor",
    "text",
    "translate",
    false,
    "Set",
    function(self, value)
      rawset(self, "err_param", value)
    end,
    "Get",
    function(self)
      rawget(self, "err_param")
    end,
    "name",
    T(917125459917, "ErrorParam")
  })
})
