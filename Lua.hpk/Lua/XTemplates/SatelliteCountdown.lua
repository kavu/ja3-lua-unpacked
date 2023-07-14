PlaceObj("XTemplate", {
  __is_kind_of = "XContentTemplate",
  group = "Zulu Badges",
  id = "SatelliteCountdown",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContentTemplate",
    "HAlign",
    "center",
    "UseClipBox",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "__condition",
      function(parent, context)
        return context.Guardpost and context.guardpost_obj and context.guardpost_obj.next_spawn_time or GetSectorTimer(context)
      end,
      "__class",
      "XText",
      "Id",
      "idCountdown",
      "HAlign",
      "center",
      "Clip",
      false,
      "UseClipBox",
      false,
      "DrawOnTop",
      true,
      "TextStyle",
      "DescriptionTextBigGlow",
      "Translate",
      true,
      "TextHAlign",
      "center"
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "Open(self)",
        "func",
        function(self)
          XText.Open(self)
          local sector = self.context
          self:CreateThread("GuardpostCountdown", function(self, sector)
            while self.window_state ~= "destroying" do
              local time = GetSectorTimer(sector)
              if time then
                self:SetText(FormatCampaignTime(time))
              else
                self:SetText("")
              end
              Sleep(200)
            end
          end, self, sector)
        end
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "Measure(self, max_width, max_height)",
        "func",
        function(self, max_width, max_height)
          local _, height = XText.Measure(self, max_width, max_height)
          return 0, height
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
          local height = Min(self.measure_height, space_height)
          y = space_y - height
          self:SetBox(0, y, 1, height)
        end
      })
    })
  })
})
