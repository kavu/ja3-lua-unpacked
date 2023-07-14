PlaceObj("XTemplate", {
  __is_kind_of = "XTextButton",
  group = "Zulu Satellite UI",
  id = "SatelliteViewMapContextMenuAction",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XTextButton",
    "UseClipBox",
    false,
    "FoldWhenHidden",
    true,
    "Background",
    RGBA(255, 255, 255, 0),
    "BackgroundRectGlowColor",
    RGBA(255, 255, 255, 0),
    "FocusedBackground",
    RGBA(255, 255, 255, 0),
    "OnPress",
    function(self, gamepad)
      if self.action then
        local host = GetActionsHost(self, true)
        if host then
          host:OnAction(self.action, self)
          local cabinet = g_SatelliteUI
          cabinet:RemoveContextMenu()
        end
      end
    end,
    "RolloverBackground",
    RGBA(215, 159, 80, 255),
    "PressedBackground",
    RGBA(255, 255, 255, 0),
    "TextStyle",
    "ConversationChoiceNormal",
    "Translate",
    true
  })
})
