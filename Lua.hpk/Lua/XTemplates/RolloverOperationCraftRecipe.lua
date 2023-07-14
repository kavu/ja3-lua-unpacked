PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu",
  id = "RolloverOperationCraftRecipe",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDARolloverClass",
    "Margins",
    box(10, 10, 10, 10),
    "BorderWidth",
    0,
    "LayoutMethod",
    "HList",
    "Background",
    RGBA(240, 240, 240, 0),
    "FocusedBackground",
    RGBA(240, 240, 240, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextControl",
      "Id",
      "idContent",
      "Padding",
      box(6, 6, 6, 6),
      "VAlign",
      "top",
      "MinWidth",
      356,
      "MaxWidth",
      356,
      "LayoutMethod",
      "VList",
      "Background",
      RGBA(52, 55, 61, 255),
      "BackgroundRectGlowSize",
      2,
      "BackgroundRectGlowColor",
      RGBA(32, 35, 47, 255),
      "OnContextUpdate",
      function(self, context, ...)
        local control = context.control
        local item = control.item
        local recipe = CraftOperationsRecipes[item.recipe]
        self.idTitle:SetText(T({
          412158497796,
          "<amount> x <name>",
          name = context.DisplayName,
          amount = item.amount
        }))
        if context.Description and context.Description ~= "" then
          self.idText:SetText(context.Description)
        end
      end
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "Open",
        "func",
        function(self, ...)
          XContextControl.Open(self, ...)
          local control = self.context.control
          local offset = control and control:GetRolloverOffset()
          if offset and offset ~= box(0, 0, 0, 0) then
            self.parent:SetMargins(self.parent.Margins + offset)
          end
        end
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(0, 0, 0, 3),
        "Dock",
        "top",
        "DrawOnTop",
        true,
        "Background",
        RGBA(52, 55, 61, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "Margins",
          box(10, 0, 0, 0),
          "HAlign",
          "left",
          "Clip",
          false,
          "UseClipBox",
          false,
          "FoldWhenHidden",
          true,
          "TextStyle",
          "PDACombatActionHeader",
          "Translate",
          true,
          "TextVAlign",
          "bottom"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idParent",
        "FoldWhenHidden",
        true,
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idText",
          "Padding",
          box(6, 6, 6, 6),
          "FoldWhenHidden",
          true,
          "TextStyle",
          "PDARolloverText",
          "Translate",
          true,
          "HideOnEmpty",
          true
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(0, 6, 0, 0),
        "Padding",
        box(6, 4, 10, 4),
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        -2,
        "FoldWhenHidden",
        true,
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idIngredients",
          "Margins",
          box(10, 0, 0, 0),
          "HAlign",
          "left",
          "Clip",
          false,
          "UseClipBox",
          false,
          "FoldWhenHidden",
          true,
          "TextStyle",
          "PDABrowserNameSmall",
          "Translate",
          true,
          "Text",
          T(501701431103, "Ingredients"),
          "TextVAlign",
          "bottom"
        }),
        PlaceObj("XTemplateForEach", {
          "array",
          function(parent, context)
            return CraftOperationsRecipes[context.control.item.recipe].Ingredients
          end,
          "run_after",
          function(child, context, item, i, n, last)
            local itm = g_Classes[item.item]
            child.idIcon:SetImage(itm.Icon)
            local dlg = GetDialog(context.control)
            local sector_id = dlg.context.Id
            local operation_id = dlg[1].context[1].operation
            local res_items = SectorOperation_CalcCraftResources(sector_id, operation_id)
            local node = context.control:ResolveId("node")
            node = node and node:ResolveId("node")
            local all = node and node.Id == "idAllItems"
            child.idName:SetText(g_Classes[item.item].DisplayName)
            if all then
              local mercs = GetOperationProfessionals(sector_id, operation_id)
              local result, amount_found = HasItemInSquad(mercs[1].session_id, item.item, item.amount + (res_items[item.item] or 0))
              if amount_found then
                amount_found = amount_found - (res_items[item.item] or 0)
                amount_found = Max(amount_found, 0)
              end
              if not result then
                child.idAmount:SetText(T({
                  322717151656,
                  "<style InventoryItemsCount><GameColorI><cur></color><valign bottom 0><style InventoryItemsCountMax>/<max></style>",
                  cur = amount_found,
                  max = item.amount
                }))
              else
                child.idAmount:SetText(T({
                  709831548750,
                  "<style InventoryItemsCount><cur><valign bottom 0><style InventoryItemsCountMax>/<max></style>",
                  cur = item.amount,
                  max = item.amount
                }))
              end
            else
              child.idAmount:SetText(T({
                127840827053,
                "<style InventoryItemsCount><cur></style>",
                cur = item.amount
              }))
            end
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XContextWindow",
            "IdNode",
            true,
            "ContextUpdateOnOpen",
            true
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Id",
              "idIcon",
              "Dock",
              "left",
              "HAlign",
              "left",
              "ScaleModifier",
              point(800, 800),
              "ImageScale",
              point(500, 500)
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idName",
              "VAlign",
              "center",
              "HandleMouse",
              false,
              "ChildrenHandleMouse",
              false,
              "TextStyle",
              "PDABrowserFlavorMedium",
              "Translate",
              true
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idAmount",
              "Dock",
              "right",
              "HAlign",
              "right",
              "VAlign",
              "center",
              "HandleMouse",
              false,
              "ChildrenHandleMouse",
              false,
              "TextStyle",
              "InventoryItemsCountRollvoer",
              "Translate",
              true,
              "TextHAlign",
              "right"
            })
          })
        })
      })
    })
  })
})
