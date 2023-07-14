PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "Editor",
  id = "XEditorToolbarSection",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "IdNode",
    true,
    "Margins",
    box(0, 0, 0, 2),
    "LayoutMethod",
    "VList",
    "UniformColumnWidth",
    true,
    "FoldWhenHidden",
    true,
    "HandleMouse",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "Id",
      "idSection",
      "BorderWidth",
      1,
      "Padding",
      box(2, 1, 2, 1),
      "Background",
      RGBA(42, 41, 41, 232)
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
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "divider",
      "BorderWidth",
      1,
      "MinHeight",
      1,
      "MaxHeight",
      1
    }),
    PlaceObj("XTemplateWindow", {
      "Padding",
      box(0, 3, 0, 3),
      "HAlign",
      "center",
      "VAlign",
      "center"
    }, {
      PlaceObj("XTemplateWindow", {
        "Id",
        "idActionContainer",
        "Dock",
        "box",
        "GridStretchY",
        false,
        "LayoutMethod",
        "HWrap",
        "LayoutHSpacing",
        1,
        "UniformColumnWidth",
        true,
        "DrawOnTop",
        true
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "GetContainer(self)",
      "func",
      function(self)
        return self.idActionContainer
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetName(self, name)",
      "func",
      function(self, name)
        self.idSectionName:SetText(name)
      end
    })
  })
})
