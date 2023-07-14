PlaceObj("XTemplate", {
  group = "Zulu",
  id = "InteractionProgressBar",
  PlaceObj("XTemplateWindow", {
    "IdNode",
    true,
    "Margins",
    box(-50, -15, 0, 0),
    "HAlign",
    "left",
    "VAlign",
    "top",
    "MinWidth",
    100,
    "MinHeight",
    20,
    "MaxWidth",
    100,
    "LayoutVSpacing",
    -5,
    "FadeInTime",
    100,
    "FadeOutTime",
    100
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Dock",
      "top",
      "HAlign",
      "center",
      "TextStyle",
      "PDARolloverTextMedium"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "ZuluFrameProgress",
      "Id",
      "idBar",
      "Dock",
      "top",
      "HAlign",
      "left",
      "VAlign",
      "top",
      "MinHeight",
      8,
      "MaxHeight",
      8,
      "Image",
      "UI/Hud/interaction_bar_bg",
      "SqueezeX",
      false,
      "ProgressImage",
      "UI/Hud/interaction_bar_fg"
    })
  })
})
