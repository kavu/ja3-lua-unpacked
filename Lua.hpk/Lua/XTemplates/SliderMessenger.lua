PlaceObj("XTemplate", {
  __is_kind_of = "XScrollThumb",
  group = "Zulu",
  id = "SliderMessenger",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XScrollThumb",
    "MouseCursor",
    "UI/Cursors/Hand.tga",
    "Horizontal",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "ZOrder",
      0,
      "Margins",
      box(3, 8, 0, 0),
      "MouseCursor",
      "UI/Cursors/Hand.tga",
      "Image",
      "UI/PDA/Chat/T_Call_Offer_Bar"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idThumb",
      "VAlign",
      "top",
      "MinWidth",
      11,
      "MinHeight",
      22,
      "MaxWidth",
      11,
      "MaxHeight",
      22,
      "MouseCursor",
      "UI/Cursors/Hand.tga",
      "Image",
      "UI/PDA/Chat/T_Call_Offer_Slider"
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "MoveThumb(self)",
      "func",
      function(self)
        if not self:HasMember("idThumb") then
          return
        end
        local x1, y1, x2, y2 = self.content_box:xyxy()
        local thumb_size = self:GetThumbSize()
        local max = self.content_box:sizex() - thumb_size / 2
        local scrollMin, scrollMax, scrolledTo = self.Min, self.Max, self.Scroll
        local pos = x1 + (scrolledTo - scrollMin) * max / (scrollMax - scrollMin)
        self.idThumb:SetDock("ignore")
        self.idThumb:SetLayoutSpace(pos, y1, thumb_size, y2 - y1)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetEnabled(self, enabled)",
      "func",
      function(self, enabled)
        XScrollThumb.SetEnabled(self, enabled)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "UpdateLayout(self, ...)",
      "func",
      function(self, ...)
        XScrollThumb.UpdateLayout(self)
        local x, y, mx, my = self.box:xyxy()
        local extra = ScaleXY(self.scale, 6, 0)
        self.interaction_box = box(x - extra, y, mx + extra, my)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetScroll(self, scrollTo)",
      "func",
      function(self, scrollTo)
        local oldScroll = self.Scroll
        local changed = XScrollThumb.SetScroll(self, scrollTo)
        if changed and oldScroll ~= 0 then
          PlayFX("PDAMessengerSliderMoved", "start")
        end
        return changed
      end
    })
  })
})
