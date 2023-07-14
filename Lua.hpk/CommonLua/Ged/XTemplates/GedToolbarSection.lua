PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "GedControls",
  id = "GedToolbarSection",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "IdNode",
    true,
    "Margins",
    box(2, 2, 2, 2),
    "BorderWidth",
    1,
    "LayoutMethod",
    "VList",
    "LayoutVSpacing",
    2,
    "BorderColor",
    RGBA(160, 160, 160, 255),
    "HandleMouse",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XLabel",
      "Id",
      "idSectionName",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "Text",
      "Name"
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "divider",
      "MinHeight",
      1,
      "Background",
      RGBA(160, 160, 160, 255)
    }),
    PlaceObj("XTemplateWindow", {
      "Id",
      "idActionContainer",
      "LayoutMethod",
      "HWrap",
      "LayoutHSpacing",
      2
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetName(self, name)",
      "func",
      function(self, name)
        self.idSectionName:SetText(name)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "GetContainer(self)",
      "func",
      function(self)
        return self.idActionContainer
      end
    })
  })
})
