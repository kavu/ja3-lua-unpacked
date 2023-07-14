PlaceObj("XTemplate", {
  __is_kind_of = "XTextButton",
  group = "Zulu Weapon Mod",
  id = "WeaponModToolbarButton",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XTextButton",
    "Background",
    RGBA(0, 0, 0, 0),
    "OnContextUpdate",
    function(self, context, ...)
      local ogText = rawget(self, "ogText")
      if not ogText then
        rawset(self, "ogText", self.Text)
        ogText = self.Text
      end
      local shortcutText = GetShortcutButtonT(self.action)
      self:SetText(T({
        828903919196,
        "<style PDAIMPCounter>[<shortcut>]</style> <text>",
        text = ogText,
        shortcut = shortcutText or ""
      }))
    end,
    "FXMouseIn",
    "buttonRollover",
    "FXPressDisabled",
    "IactDisabled",
    "FocusedBorderColor",
    RGBA(0, 0, 0, 0),
    "FocusedBackground",
    RGBA(0, 0, 0, 0),
    "DisabledBorderColor",
    RGBA(0, 0, 0, 0),
    "RolloverBackground",
    RGBA(0, 0, 0, 0),
    "PressedBackground",
    RGBA(0, 0, 0, 0),
    "TextStyle",
    "InventoryToolbarButtonCenter",
    "Translate",
    true,
    "UseXTextControl",
    true
  })
})
