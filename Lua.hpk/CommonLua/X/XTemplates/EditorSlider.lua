PlaceObj("XTemplate", {
  __is_kind_of = "XScrollThumb",
  group = "Editor",
  id = "EditorSlider",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XScrollThumb",
    "MinHeight",
    15,
    "Background",
    RGBA(240, 240, 240, 255),
    "Horizontal",
    true,
    "MinThumbSize",
    10,
    "FixedSizeThumb",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "Id",
      "idThumb",
      "Dock",
      "ignore",
      "Background",
      RGBA(169, 169, 169, 255),
      "DisabledBackground",
      RGBA(169, 169, 169, 96),
      "Image",
      "CommonAssets/UI/round-frame-20.tga",
      "ImageScale",
      point(500, 500),
      "FrameBox",
      box(9, 9, 9, 9)
    })
  })
})
