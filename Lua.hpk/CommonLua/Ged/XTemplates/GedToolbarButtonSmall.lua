PlaceObj("XTemplate", {
  __is_kind_of = "XTextButton",
  group = "GedControls",
  id = "GedToolbarButtonSmall",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XTextButton",
    "RolloverTemplate",
    "GedToolbarRollover",
    "RolloverAnchor",
    "bottom",
    "Padding",
    box(2, 1, 2, 1),
    "Dock",
    "right",
    "FoldWhenHidden",
    true,
    "Background",
    RGBA(0, 0, 0, 0),
    "RolloverBackground",
    RGBA(204, 232, 255, 255),
    "PressedBackground",
    RGBA(121, 189, 241, 255),
    "IconScale",
    point(700, 700),
    "DisabledIconColor",
    RGBA(255, 255, 255, 64)
  })
})