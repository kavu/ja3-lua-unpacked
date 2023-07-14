PlaceObj("XTemplate", {
  __content = function(parent, context)
    return parent.idParent
  end,
  __is_kind_of = "XButton",
  group = "Zulu",
  id = "SatellitePopupButton",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XButton",
    "UseClipBox",
    false,
    "BorderColor",
    RGBA(255, 255, 255, 0),
    "Background",
    RGBA(255, 255, 255, 0),
    "MouseCursor",
    "UI/Cursors/Pda_Hand.tga",
    "ChildrenHandleMouse",
    true,
    "FocusedBorderColor",
    RGBA(255, 255, 255, 0),
    "FocusedBackground",
    RGBA(255, 255, 255, 0),
    "DisabledBorderColor",
    RGBA(255, 255, 255, 0),
    "RolloverBackground",
    RGBA(255, 255, 255, 0),
    "PressedBackground",
    RGBA(255, 255, 255, 0)
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if shortcut == "+ButtonA" then
          self:OnPress()
          return "break"
        end
        return XButton.OnShortcut(self, shortcut, source, ...)
      end
    }),
    PlaceObj("XTemplateWindow", {"HAlign", "left"}, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "Id",
        "idSelectedBG",
        "Margins",
        box(-10, -5, -30, -10),
        "Dock",
        "box",
        "UseClipBox",
        false,
        "Visible",
        false,
        "Image",
        "UI/Common/conversation_choice_rollover",
        "FrameBox",
        box(5, 0, 5, 0),
        "SqueezeX",
        false
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idText",
        "IdNode",
        false,
        "ZOrder",
        2,
        "Padding",
        box(15, 2, 0, 2),
        "HAlign",
        "left",
        "VAlign",
        "center",
        "Clip",
        false,
        "UseClipBox",
        false,
        "HandleMouse",
        false,
        "TextStyle",
        "Satellite_MercList_PopupMember",
        "Translate",
        true,
        "Text",
        T(140375097334, "<display_name>")
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContextWindow",
        "Id",
        "idParent"
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idArrow",
      "Padding",
      box(0, 0, 15, 0),
      "HAlign",
      "right",
      "VAlign",
      "center",
      "UseClipBox",
      false,
      "Visible",
      false,
      "Image",
      "UI/Icons/arrow",
      "Columns",
      2
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        local selected = self:GetSelected()
        self.idSelectedBG:SetVisible(rollover or selected)
        if not self.enabled then
          return
        end
        local style = "Satellite_MercList_PopupMember"
        if rollover or selected then
          style = "Satellite_MercList_PopupMember_Reverse"
        end
        self.idText:SetTextStyle(style)
        for i, c in ipairs(self.idParent) do
          c:OnSetRollover(rollover)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetEnabled(self, enabled)",
      "func",
      function(self, enabled)
        local desat = 255
        local style = "Satellite_MercList_PopupMember_Disabled"
        local trans = 128
        if enabled then
          desat = 0
          style = "Satellite_MercList_PopupMember"
          trans = 0
        end
        self.idSelectedBG:SetDesaturation(desat)
        self.idText:SetTextStyle(style)
        self.idSelectedBG:SetTransparency(trans)
        XButton.SetEnabled(self, enabled)
        self:OnSetRollover(self.rollover)
      end
    })
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "Translate",
    "default",
    true,
    "Set",
    function(self, value)
      self.idText:SetTranslate(value)
    end,
    "Get",
    function(self)
      return self.idText:GetTranslate()
    end,
    "name",
    T(650179990112, "Translate"),
    "help",
    T(388424695756, "Whether to translate the text")
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
      self.idText:SetText(value)
    end,
    "Get",
    function(self)
      return self.idText:GetText()
    end,
    "name",
    T(698725388757, "Text"),
    "help",
    T(237322778424, "Button Text")
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "Arrow",
    "Set",
    function(self, value)
      self.idArrow:SetVisible(value)
    end,
    "Get",
    function(self)
      return self.idArrow:GetVisible()
    end,
    "name",
    T(852092291608, "Arrow Icon")
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "General",
    "id",
    "Selected",
    "Set",
    function(self, value)
      rawset(self, "selected", value)
      if value then
        self.idArrow:SetColumn(2)
        self.idSelectedBG:SetDesaturation(255)
      else
        self.idArrow:SetColumn(1)
        self.idSelectedBG:SetDesaturation(0)
      end
      self:OnSetRollover(value)
    end,
    "Get",
    function(self)
      return rawget(self, "selected") or false
    end,
    "name",
    T(302769111263, "Selected"),
    "help",
    T(602603338992, "Whether to use the selected style.")
  })
})
