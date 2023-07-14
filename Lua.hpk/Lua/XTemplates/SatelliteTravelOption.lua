PlaceObj("XTemplate", {
  group = "Zulu",
  id = "SatelliteTravelOption",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XPopup",
    "Id",
    "idTravelOptionPopup",
    "ZOrder",
    5,
    "Margins",
    box(0, 0, 0, 20),
    "BorderWidth",
    0,
    "HAlign",
    "left",
    "VAlign",
    "top",
    "MinWidth",
    300,
    "LayoutMethod",
    "Box",
    "UseClipBox",
    false,
    "DrawOnTop",
    true,
    "BorderColor",
    RGBA(240, 240, 240, 12),
    "Background",
    RGBA(240, 240, 240, 0),
    "FocusedBorderColor",
    RGBA(240, 240, 240, 12),
    "FocusedBackground",
    RGBA(240, 240, 240, 12),
    "DisabledBorderColor",
    RGBA(240, 240, 240, 12)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContentTemplate",
      "Id",
      "idPopupWindow",
      "UseClipBox",
      false
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "Margins",
        box(0, 20, 0, 0),
        "Dock",
        "box",
        "UseClipBox",
        false,
        "BorderColor",
        RGBA(255, 255, 255, 10),
        "FocusedBorderColor",
        RGBA(255, 255, 255, 10),
        "FocusedBackground",
        RGBA(255, 255, 255, 10),
        "DisabledBorderColor",
        RGBA(255, 255, 255, 10),
        "Image",
        "UI/Common/rollover_pad",
        "FrameBox",
        box(0, 0, 0, 10),
        "SqueezeX",
        false
      }),
      PlaceObj("XTemplateWindow", {
        "Padding",
        box(0, 0, 0, 15),
        "LayoutMethod",
        "VList",
        "UseClipBox",
        false
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "header",
          "Margins",
          box(-10, 0, -10, 0),
          "UseClipBox",
          false
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Dock",
            "box",
            "UseClipBox",
            false,
            "BorderColor",
            RGBA(255, 255, 255, 10),
            "Background",
            RGBA(255, 255, 255, 0),
            "FocusedBorderColor",
            RGBA(255, 255, 255, 10),
            "FocusedBackground",
            RGBA(255, 255, 255, 10),
            "DisabledBorderColor",
            RGBA(255, 255, 255, 10),
            "Image",
            "UI/Common/rollover_title"
          })
        }),
        PlaceObj("XTemplateTemplate", {
          "__template",
          "SatellitePopupButton",
          "Id",
          "idLandPathButton",
          "FoldWhenHidden",
          true,
          "OnPress",
          function(self, gamepad)
            self:ResolveId("node").context.useLandPath()
          end,
          "Text",
          T(714426681228, "Use Land Path")
        }),
        PlaceObj("XTemplateTemplate", {
          "__template",
          "SatellitePopupButton",
          "Id",
          "idWaterPathButton",
          "FoldWhenHidden",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            self:SetVisible(not context.occupied)
          end,
          "OnPress",
          function(self, gamepad)
            self:ResolveId("node").context.useWaterPath()
          end,
          "Text",
          T(143680182460, "Use Boat (<money(cost)>)")
        }),
        PlaceObj("XTemplateTemplate", {
          "__template",
          "SatellitePopupButton",
          "Id",
          "idCloseButton",
          "OnPress",
          function(self, gamepad)
            self:ResolveId("node").context:onExit()
          end,
          "Text",
          T(737848567080, "CLOSE")
        })
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        self:ResolveId("node").context:onExit()
        return "break"
      end
    })
  })
})
