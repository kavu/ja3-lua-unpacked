PlaceObj("XTemplate", {
  __is_kind_of = "XLayer",
  group = "Common",
  id = "Fade",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {"__class", "XLayer"}, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XDialog",
      "Id",
      "idFade",
      "ZOrder",
      1000,
      "Visible",
      false,
      "Background",
      RGBA(0, 0, 0, 255),
      "FadeInTime",
      1000,
      "FadeOutTime",
      1000,
      "RolloverZoomInTime",
      1000,
      "RolloverZoomOutTime",
      1000
    })
  })
})
