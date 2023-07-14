PlaceObj("XTemplate", {
  __content = function(parent, context)
    return parent.idParent
  end,
  __is_kind_of = "XContextWindow",
  group = "Zulu",
  id = "GenericHUDButtonFrame",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextWindow",
    "IdNode",
    true,
    "VAlign",
    "bottom",
    "LayoutMethod",
    "VList",
    "BackgroundRectGlowSize",
    1,
    "BackgroundRectGlowColor",
    RGBA(32, 35, 47, 255),
    "HandleMouse",
    true
  }, {
    PlaceObj("XTemplateWindow", nil, {
      PlaceObj("XTemplateWindow", {
        "Id",
        "idParent",
        "BorderColor",
        RGBA(52, 55, 61, 230),
        "Background",
        RGBA(32, 35, 47, 215)
      }),
      PlaceObj("XTemplateWindow", {
        "Dock",
        "left",
        "HAlign",
        "left",
        "MinWidth",
        2,
        "MaxWidth",
        2,
        "Background",
        RGBA(52, 55, 61, 230)
      }),
      PlaceObj("XTemplateWindow", {
        "Dock",
        "right",
        "HAlign",
        "left",
        "MinWidth",
        2,
        "MaxWidth",
        2,
        "Background",
        RGBA(52, 55, 61, 230)
      }),
      PlaceObj("XTemplateWindow", {
        "Dock",
        "bottom",
        "VAlign",
        "bottom",
        "MinHeight",
        2,
        "MaxHeight",
        2,
        "Background",
        RGBA(52, 55, 61, 230)
      })
    }),
    PlaceObj("XTemplateWindow", {
      "Dock",
      "top",
      "MinHeight",
      7,
      "MaxHeight",
      7,
      "Background",
      RGBA(52, 55, 61, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(0, 1, 2, 0),
        "HAlign",
        "right",
        "VAlign",
        "top",
        "MinWidth",
        6,
        "MinHeight",
        6,
        "MaxWidth",
        6,
        "MaxHeight",
        6,
        "Background",
        RGBA(69, 73, 81, 255)
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        return "break"
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonUp(self, pos, button)",
      "func",
      function(self, pos, button)
        return "break"
      end
    })
  })
})
