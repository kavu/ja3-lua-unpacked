PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "Zulu Dev",
  id = "AccuracyChart",
  save_in = "GameGed",
  PlaceObj("XTemplateWindow", {
    "BorderWidth",
    2,
    "HAlign",
    "center",
    "VAlign",
    "center",
    "Background",
    RGBA(190, 190, 190, 235)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Dock",
      "box",
      "Image",
      "UI/Common/aim_chance_pad"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextWindow",
      "Id",
      "idDrawChart",
      "Margins",
      box(10, 10, 10, 10),
      "Dock",
      "box"
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "DrawContent",
        "func",
        function(self, ...)
          local winx, winy = self.content_box:minxyz()
          local w, h = self.content_box:sizexyz()
          local ox, oy = 44, 24
          w = w - ox
          h = h - oy
          local last_pt
          for dist = 0, 70 do
            local acc = 100 - GetRangeAccuracy(self.context, dist * const.SlabSizeX)
            if 100 < acc then
              break
            end
            local pt = point(winx + ox + MulDivRound(w, dist, 70), winy + h - MulDivRound(h, acc, 100))
            if last_pt then
              UIL.DrawLine(last_pt, pt, const.clrWhite)
            end
            last_pt = pt
          end
        end
      })
    })
  })
})
