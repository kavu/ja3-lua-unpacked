PlaceObj("XTemplate", {
  group = "Zulu Badges",
  id = "EnemyDeploymentBadge",
  PlaceObj("XTemplateWindow", {
    "HAlign",
    "left",
    "VAlign",
    "top",
    "UseClipBox",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "HAlign",
      "left",
      "VAlign",
      "top",
      "UseClipBox",
      false,
      "Image",
      "UI/Hud/enemy_incoming"
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
