PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu",
  id = "SectorOperationStatsTableUI",
  PlaceObj("XTemplateWindow", {
    "comment",
    "table",
    "__condition",
    function(parent, context)
      return context.operation and context.operation:SectorOperationStats(context.sector, "check")
    end,
    "__class",
    "XContentTemplate",
    "Id",
    "idStatsTable",
    "Dock",
    "bottom",
    "VAlign",
    "bottom",
    "LayoutMethod",
    "VList",
    "FoldWhenHidden",
    true,
    "ContextUpdateOnOpen",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      if not context.operation then
        return
      end
      local texts, progress = context.operation:SectorOperationStats(context.sector)
      self:ResolveId("idTable"):SetContext(texts)
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
      T(273625749465, "Sector Details")
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
      "__context",
      function(parent, context)
        return context.operation and context.operation:SectorOperationStats(context.sector) or context
      end,
      "__class",
      "XContentTemplate",
      "Id",
      "idTable",
      "LayoutMethod",
      "VList"
    }, {
      PlaceObj("XTemplateForEach", {
        "run_after",
        function(child, context, item, i, n, last)
          child.idText:SetContext(item)
          child.idText:SetNameText(item.text)
          child.idText:SetValueText(item.value)
        end
      }, {
        PlaceObj("XTemplateWindow", {
          "IdNode",
          true,
          "VAlign",
          "center",
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", {
            "LayoutMethod",
            "HList"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "HAlign",
              "left",
              "VAlign",
              "center",
              "MinWidth",
              15,
              "MinHeight",
              15,
              "MaxWidth",
              15,
              "MaxHeight",
              15,
              "Image",
              "UI/Icons/SateliteView/sa_icon_background",
              "ImageFit",
              "stretch",
              "ImageColor",
              RGBA(195, 189, 172, 255)
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XNameValueText",
              "Id",
              "idText",
              "Margins",
              box(0, 2, 0, 0),
              "Padding",
              box(14, 0, 0, 0),
              "HAlign",
              "left",
              "VAlign",
              "center",
              "MinWidth",
              355,
              "FoldWhenHidden",
              true,
              "HandleMouse",
              false,
              "TextStyle",
              "PDAActivityStatsTableText",
              "TextStyleRight",
              "PDAActivityStatsValueText"
            })
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
          })
        })
      })
    })
  })
})
