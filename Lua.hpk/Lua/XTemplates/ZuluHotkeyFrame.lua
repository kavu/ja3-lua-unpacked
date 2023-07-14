PlaceObj("XTemplate", {
  __is_kind_of = "XContextImage",
  group = "Zulu",
  id = "ZuluHotkeyFrame",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextImage",
    "Id",
    "idHotkeyFrame",
    "Padding",
    box(10, 0, 10, 0),
    "VAlign",
    "center",
    "Image",
    "UI/Hud/shortcut_button",
    "ContextUpdateOnOpen",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      local actionName = self:GetActionName()
      local text = GetShortcutButtonT(actionName)
      if GetUIStyleGamepad() then
        self:SetImage("")
        self:SetImageColor(RGBA(0, 0, 0, 0))
      else
        self:SetImageColor(RGBA(255, 255, 255, 255))
      end
      self.idHotkeyText:SetText(text)
      XContextWindow.OnContextUpdate(self, context)
    end
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idHotkeyText",
      "Padding",
      box(0, 0, 0, 0),
      "HAlign",
      "center",
      "VAlign",
      "center",
      "Clip",
      false,
      "UseClipBox",
      false,
      "TextStyle",
      "HotkeyIndicator",
      "Translate",
      true
    })
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "GamepadShortcutOverride",
    "editor",
    "text",
    "translate",
    false,
    "Set",
    function(self, value)
      rawset(self, "gamepadOverride", value)
    end,
    "Get",
    function(self)
      return rawget(self, "gamepadOverride")
    end,
    "name",
    T(388617198664, "Gamepad Button Override")
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "ActionName",
    "editor",
    "text",
    "translate",
    false,
    "Set",
    function(self, value)
      rawset(self, "actionName", value)
    end,
    "Get",
    function(self)
      return rawget(self, "actionName")
    end,
    "name",
    T(550964649987, "Action Name")
  })
})
