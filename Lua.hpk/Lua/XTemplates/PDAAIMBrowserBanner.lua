PlaceObj("XTemplate", {
  __is_kind_of = "AIMHiringBanner",
  group = "Zulu PDA",
  id = "PDAAIMBrowserBanner",
  PlaceObj("XTemplateWindow", {
    "__class",
    "AIMHiringBanner",
    "HAlign",
    "left",
    "VAlign",
    "top",
    "MinWidth",
    260,
    "MinHeight",
    46,
    "MaxHeight",
    46
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "Id",
      "idBackground",
      "Dock",
      "box",
      "Image",
      "UI/PDA/banner_pad",
      "FrameBox",
      box(8, 8, 8, 8)
    }),
    PlaceObj("XTemplateWindow", {
      "LayoutMethod",
      "HList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idPortrait",
        "Margins",
        box(4, 3, 0, 0),
        "HAlign",
        "left",
        "VAlign",
        "top",
        "MinHeight",
        38,
        "MaxHeight",
        38,
        "Background",
        RGBA(52, 55, 61, 255),
        "ImageFit",
        "height",
        "ImageRect",
        box(36, 0, 264, 251)
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(5, 0, 5, 0),
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idMercName",
          "Margins",
          box(0, -5, 0, 0),
          "TextStyle",
          "PDAAIMBannerTitle",
          "Translate",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idBannerSubtitle",
          "Margins",
          box(0, -12, 0, 0),
          "TextStyle",
          "PDAAIMBannerSubtitle",
          "Translate",
          true
        })
      })
    })
  })
})
