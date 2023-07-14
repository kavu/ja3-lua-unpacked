PlaceObj("XTemplate", {
  group = "Zulu Badges",
  id = "MarkedBadge",
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
      52,
      "MaxHeight",
      52,
      "UseClipBox",
      false,
      "Image",
      "UI/Hud/enemy_melee_mark",
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
          local unit = self.context
          while self.window_state ~= "destroying" and IsValid(unit) and not unit:IsDead() do
            local marked, visible
            local playerUnits = GetAllPlayerUnitsOnMap()
            for _, u in ipairs(playerUnits) do
              if u.marked_target_attack_args and u.marked_target_attack_args.target == unit then
                marked = true
                if table.find(Selection, u) then
                  visible = true
                end
              end
            end
            if not marked then
              break
            end
            visible = visible and unit.visible
            self:SetVisible(visible or false)
            Sleep(100)
          end
          DeleteBadgesFromTargetOfPreset("MarkedBadge", unit)
        end)
      end
    })
  })
})
