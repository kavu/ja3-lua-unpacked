PlaceObj("XTemplate", {
  group = "Zulu Badges",
  id = "NpcBadge",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextWindow",
    "IdNode",
    true,
    "HAlign",
    "left",
    "VAlign",
    "top",
    "UseClipBox",
    false,
    "ContextUpdateOnOpen",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      local combatOrSetpiece = g_Combat or IsSetpiecePlaying()
      local exitingMap = context and context.command == "ExitMap"
      local unitIsVisible = context.visible
      local isEnemy = false
      if Selection and Selection[1] then
        isEnemy = context:IsOnEnemySide(Selection[1])
      end
      local visible = not combatOrSetpiece and not exitingMap and unitIsVisible and not isEnemy
      self.idImage:SetVisible(visible)
    end
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idImage",
      "IdNode",
      false,
      "HAlign",
      "left",
      "VAlign",
      "top",
      "UseClipBox",
      false,
      "BorderColor",
      RGBA(0, 0, 0, 0),
      "FocusedBorderColor",
      RGBA(0, 0, 0, 0),
      "DisabledBorderColor",
      RGBA(0, 0, 0, 0),
      "Image",
      "UI/Hud/iw_npc"
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "setpiece observer",
      "__context",
      function(parent, context)
        return "setpiece_observe"
      end,
      "__class",
      "XContextWindow",
      "Visible",
      false,
      "OnContextUpdate",
      function(self, context, ...)
        self.parent:OnContextUpdate(self.parent.context)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetLayoutSpace(self, space_x, space_y, space_width, space_height)",
      "func",
      function(self, space_x, space_y, space_width, space_height)
        local margins_x1, margins_y1, margins_x2, margins_y2 = self:GetEffectiveMargins()
        local box = self.box
        local x, y = box:minx(), box:miny()
        local width = Min(self.measure_width, space_width)
        local height = Min(self.measure_height, space_height)
        x = space_x - width / 2
        local offset = const.Healthbar.BadgeIconsHeight
        local _, scaledOffset = ScaleXY(self.scale, 0, offset)
        offset = scaledOffset
        y = space_y - height - offset
        height = height * 2 + offset
        self:SetBox(x, y, width, height)
      end
    })
  })
})
