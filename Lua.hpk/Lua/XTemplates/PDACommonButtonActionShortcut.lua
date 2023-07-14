PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDACommonButtonActionShortcut",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextWindow",
    "IdNode",
    true,
    "ZOrder",
    0,
    "Margins",
    box(8, 0, 8, 0),
    "HAlign",
    "left",
    "VAlign",
    "center",
    "FoldWhenHidden",
    true,
    "Background",
    RGBA(32, 35, 47, 255)
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "SetEnabled(self, enabled)",
      "func",
      function(self, enabled)
        XContextControl.SetEnabled(self, enabled)
        self[1]:OnContextUpdate(self.context)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idLabel",
      "Margins",
      box(0, -3, 0, -3),
      "TextStyle",
      "PDAShortcutText",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local shortcutText = GetShortcutButtonT(context)
        if not shortcutText then
          self.parent:SetVisible(false)
          return
        end
        self.parent:SetVisible(not GetUIStyleGamepad())
        self:SetText(shortcutText or "")
        local node = self:ResolveId("node")
        if GetUIStyleGamepad() then
          self.parent:SetBackground(RGBA(0, 0, 0, 0))
        else
          self.parent:SetBackground((not node or node:GetEnabled()) and GameColors.A or GetColorWithAlpha(GameColors.A, 150))
        end
        XContextControl.OnContextUpdate(self, context)
      end,
      "Translate",
      true
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "gamepad change observer",
      "__context",
      function(parent, context)
        return "GamepadUIStyleChanged"
      end,
      "__class",
      "XContextWindow",
      "OnContextUpdate",
      function(self, context, ...)
        self.parent.idLabel:OnContextUpdate(self.parent.idLabel.context)
      end
    })
  })
})
