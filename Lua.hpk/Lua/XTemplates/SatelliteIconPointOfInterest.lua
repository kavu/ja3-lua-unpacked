PlaceObj("XTemplate", {
  __is_kind_of = "PointOfInterestIconClass",
  group = "Zulu Satellite UI",
  id = "SatelliteIconPointOfInterest",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PointOfInterestIconClass",
    "IdNode",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idBase",
      "HAlign",
      "left",
      "VAlign",
      "top",
      "UseClipBox",
      false,
      "Image",
      "UI/Icons/SateliteView/icon_neutral"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idUpperIcon",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "UseClipBox",
      false,
      "Image",
      "UI/Icons/SateliteView/hospital_neutral"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idLockedIcon",
      "Margins",
      box(0, 0, 0, -5),
      "HAlign",
      "center",
      "VAlign",
      "bottom",
      "UseClipBox",
      false,
      "Image",
      "UI/Icons/perks_padlock_2",
      "ImageScale",
      point(1200, 1200)
    })
  })
})
