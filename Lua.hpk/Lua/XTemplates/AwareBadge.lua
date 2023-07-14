PlaceObj("XTemplate", {
  group = "Zulu Badges",
  id = "AwareBadge",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextWindow",
    "IdNode",
    true,
    "HAlign",
    "left",
    "VAlign",
    "top",
    "LayoutMethod",
    "VList",
    "UseClipBox",
    false,
    "Background",
    RGBA(255, 255, 255, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idImage",
      "IdNode",
      false,
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinHeight",
      38,
      "MaxHeight",
      38,
      "UseClipBox",
      false,
      "Transparency",
      255,
      "Image",
      "UI/Hud/enemy_detection",
      "ImageFit",
      "height"
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
        if TargetHasBadgeOfPreset("MarkedBadge", self.context) then
          offset = 95
        elseif self.context.ui_badge and not self.context.ui_badge.visible then
          offset = 0
        end
        local _, scaledOffset = ScaleXY(self.scale, 0, offset)
        offset = scaledOffset
        y = space_y - height - offset
        height = height * 2 + offset
        self:SetBox(x, y, width, height)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self)",
      "func",
      function(self)
        XContextWindow.Open(self)
        self:CreateThread(function()
          while self.window_state ~= "destroying" do
            UnitAwareBadgeProc(self)
          end
        end)
      end
    })
  })
})
