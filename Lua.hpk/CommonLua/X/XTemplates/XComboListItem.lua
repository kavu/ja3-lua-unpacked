PlaceObj("XTemplate", {
  group = "Common",
  id = "XComboListItem",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XComboListItem",
    "Padding",
    box(0, 1, 0, 1),
    "OnContextUpdate",
    function(self, context, ...)
      if type(context) == "table" then
        self:SetFocusOrder(point(1, context.idx))
        self:SetFontProps(context.combo)
        self:SetTranslate(context.translate)
        self:SetMinHeight(MulDivRound(self:GetFontHeight(), 1000, self.scale:y()))
        self.OnPress = context.on_press
        self.AltPress = not not context.on_alt_press
        self.OnAltPress = context.on_alt_press
        function self.idLabel:CalcTextColor()
          local r, g, b, a = GetRGBA(XTextButton.CalcTextColor(self))
          if self.context.dimmed then
            a = a * 50 / 100
          end
          return RGBA(r, g, b, a)
        end
        local ItemText = function(item)
          if type(item) == "table" then
            return item.name or item.text or item.id
          end
          return tostring(item)
        end
        local item = context.item
        self:SetText(ItemText(item))
        self:SetIcon(type(item) == "table" and item.Icon)
        if self:GetIcon() == "" then
          self:SetLayoutMethod("Box")
        end
        self.RolloverText = type(item) == "table" and item.help or nil
        self.idLabel:SetHAlign("stretch")
      end
      XComboListItem.OnContextUpdate(self, context)
    end
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "_RolloverBackground",
    "editor",
    "color",
    "Set",
    function(self, value)
      self:SetRolloverBackground(value)
    end,
    "Get",
    function(self)
      return self:GetRolloverBackground()
    end
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "_UseXTextControl",
    "Set",
    function(self, value)
      self:SetUseXTextControl(value)
    end,
    "Get",
    function(self)
      return self:GetUseXTextControl()
    end
  })
})
