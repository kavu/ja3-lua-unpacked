PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu",
  id = "SectorOperationCraftResTableUI",
  PlaceObj("XTemplateWindow", {
    "comment",
    "table",
    "__condition",
    function(parent, context)
      return context.operation and (context.operation.id == "CraftAmmo" or context.operation.id == "CraftExplosives")
    end,
    "__class",
    "XContentTemplate",
    "Id",
    "idStatsTable",
    "Margins",
    box(0, 10, 0, 10),
    "Dock",
    "bottom",
    "HAlign",
    "left",
    "VAlign",
    "bottom",
    "MinWidth",
    355,
    "LayoutMethod",
    "VList",
    "FoldWhenHidden",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      if not context.operation then
        return
      end
      self:ResolveId("idTable"):SetContext(context)
    end,
    "RespawnOnContext",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "HandleMouse",
      false,
      "TextStyle",
      "PDAActivitiesSubTitleDark",
      "Translate",
      true,
      "Text",
      T(468826056787, "Components List")
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "VAlign",
      "top",
      "Image",
      "UI/PDA/separate_line_vertical",
      "FrameBox",
      box(2, 0, 2, 0),
      "SqueezeY",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContentTemplate",
      "Id",
      "idTable",
      "HAlign",
      "left",
      "MinWidth",
      355,
      "LayoutMethod",
      "VList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XScrollArea",
        "Id",
        "idScrollArea",
        "IdNode",
        false,
        "Margins",
        box(0, 10, 0, 0),
        "MaxHeight",
        240,
        "LayoutMethod",
        "VList",
        "VScroll",
        "idScrollbar"
      }, {
        PlaceObj("XTemplateForEach", {
          "array",
          function(parent, context)
            return context.operation and SectorOperations_CraftAdditionalResources(context.sector.Id, context.operation.id)
          end,
          "run_after",
          function(child, context, item, i, n, last)
            local itm = g_Classes[item.res]
            child.idIcon:SetImage(itm.Icon)
            child.idName:SetText(itm.DisplayName)
            child.idAmount:SetText(T({
              709831548750,
              "<style InventoryItemsCount><cur><valign bottom 0><style InventoryItemsCountMax>/<max></style>",
              cur = Untranslated(item.queued_val or 0),
              max = Untranslated(item.amount_found or 0)
            }))
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "IdNode",
            true,
            "Margins",
            box(10, 0, 10, 0),
            "HAlign",
            "left",
            "MinWidth",
            355,
            "MaxWidth",
            355,
            "LayoutMethod",
            "HList"
          }, {
            PlaceObj("XTemplateWindow", {
              "Dock",
              "left",
              "HAlign",
              "left",
              "LayoutMethod",
              "HList"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idName",
                "HAlign",
                "left",
                "VAlign",
                "center",
                "MaxWidth",
                250,
                "FoldWhenHidden",
                true,
                "HandleMouse",
                false,
                "TextStyle",
                "PDAActivityStatsTableText",
                "Translate",
                true
              })
            }),
            PlaceObj("XTemplateWindow", {
              "Dock",
              "right",
              "LayoutMethod",
              "HList"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idAmount",
                "HAlign",
                "right",
                "VAlign",
                "center",
                "FoldWhenHidden",
                true,
                "HandleMouse",
                false,
                "TextStyle",
                "InventoryItemsCountRollvoer",
                "Translate",
                true
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Id",
                "idIcon",
                "HAlign",
                "right",
                "ScaleModifier",
                point(600, 600),
                "Image",
                "UI/Icons/SateliteView/sa_icon_background",
                "ImageScale",
                point(500, 500)
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XZuluScroll",
          "Id",
          "idScrollbar",
          "Margins",
          box(0, 0, 3, 0),
          "Dock",
          "right",
          "UseClipBox",
          false,
          "Target",
          "idScrollArea",
          "SnapToItems",
          true,
          "AutoHide",
          true
        })
      })
    })
  })
})
