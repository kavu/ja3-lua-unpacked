PlaceObj("XTemplate", {
  __is_kind_of = "XListItem",
  group = "Editor",
  id = "ListItemIconText",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XListItem",
    "MaxWidth",
    300,
    "LayoutMethod",
    "HList"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idImage",
      "MinWidth",
      10,
      "MinHeight",
      10,
      "MaxWidth",
      30,
      "MaxHeight",
      30,
      "BaseColorMap",
      true
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XLabel",
      "Id",
      "idText",
      "VAlign",
      "center",
      "MinWidth",
      60,
      "MaxWidth",
      300
    })
  })
})
