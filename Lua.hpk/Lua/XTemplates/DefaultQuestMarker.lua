PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "Zulu Badges",
  id = "DefaultQuestMarker",
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
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "comment",
      "combat observer",
      "__context",
      function(parent, context)
        return "CombatChanged"
      end,
      "__class",
      "XContextWindow",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        self.parent:UpdateVisibility()
      end
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "quest observer",
      "__context",
      function(parent, context)
        return gv_Quests
      end,
      "__class",
      "XContextWindow",
      "OnContextUpdate",
      function(self, context, ...)
        self.parent:UpdateVisibility()
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "VisibilityUpdate"
      end,
      "__class",
      "XContextWindow",
      "OnContextUpdate",
      function(self, context, ...)
        self.parent:UpdateVisibility()
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idImage",
      "HAlign",
      "left",
      "VAlign",
      "top",
      "UseClipBox",
      false,
      "Image",
      "UI/Hud/iw_quest"
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
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "UpdateVisibility(self)",
      "func",
      function(self)
        local isActiveQuest = self.context == GetActiveQuest()
        local visible = true
        local badgeInstance = self["xbadge-instance"]
        local target = badgeInstance and badgeInstance.target
        if IsKindOf(target, "Unit") and visible then
          visible = target.visible
        end
        if badgeInstance and badgeInstance.arrowUI then
          badgeInstance.arrowUI:SetVisible(visible)
        end
        self.idImage:SetVisible(visible)
      end
    })
  })
})
