PlaceObj("XTemplate", {
  Comment = "old - to remove",
  __is_kind_of = "XScrollThumb",
  group = "Zulu",
  id = "InventoryScroll",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XZuluScroll",
    "Margins",
    box(0, 16, 0, 16),
    "MinWidth",
    13,
    "MouseCursor",
    "UI/Cursors/Hand.tga",
    "ChildrenHandleMouse",
    true,
    "Max",
    9999,
    "MinThumbSize",
    50
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "ZOrder",
      0,
      "HAlign",
      "center",
      "MinWidth",
      2,
      "MaxWidth",
      2,
      "MouseCursor",
      "UI/Cursors/Hand.tga",
      "Image",
      "UI/Inventory/T_Backpack_Scrollbar_Line",
      "TileFrame",
      true
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XTextButton",
      "Id",
      "idThumb",
      "ZOrder",
      0,
      "MinWidth",
      13,
      "MinHeight",
      32,
      "MaxWidth",
      13,
      "MaxHeight",
      32,
      "Image",
      "UI/Inventory/T_Backpack_Scrollbar_Handle",
      "Columns",
      3,
      "ColumnsUse",
      "abccc"
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "OnMouseButtonDown(self, pos, button)",
        "func",
        function(self, pos, button)
          XTextButton.OnMouseButtonDown(self, pos, button)
          return "continue"
        end
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "OnMouseButtonUp(self, pos, button)",
        "func",
        function(self, pos, button)
          XTextButton.OnMouseButtonUp(self, pos, button)
          return "continue"
        end
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "OnMousePos(self, pos)",
        "func",
        function(self, pos)
          XTextButton.OnMousePos(self, pos)
          return "continue"
        end
      })
    })
  })
})
