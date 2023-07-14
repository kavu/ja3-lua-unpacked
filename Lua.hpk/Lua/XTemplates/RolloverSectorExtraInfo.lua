PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu Satellite UI",
  id = "RolloverSectorExtraInfo",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDARolloverClass",
    "BorderWidth",
    0,
    "MaxWidth",
    400,
    "UseClipBox",
    false,
    "Background",
    RGBA(0, 0, 0, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextControl",
      "Id",
      "idContent",
      "Padding",
      box(6, 6, 6, 6),
      "LayoutMethod",
      "VList",
      "LayoutVSpacing",
      5,
      "UseClipBox",
      false,
      "Background",
      RGBA(52, 55, 61, 255),
      "OnContextUpdate",
      function(self, context, ...)
        if IsKindOf(context, "Context") and context[1] and #context[1] > 0 then
          context = context[1][1]
        end
        local sector = context.sector
        if sector then
          self.idSectorId:SetText(T({
            764093693143,
            "<SectorIdColored(id)>",
            id = sector.Id
          }))
          self.idSectorSquare:SetBackground(GetSectorControlColor(sector.Side))
        end
        self.idTitle:SetText(sector.display_name)
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
        "comment",
        "sector title",
        "Dock",
        "top",
        "VAlign",
        "center",
        "UseClipBox",
        false,
        "DrawOnTop",
        true
      }, {
        PlaceObj("XTemplateWindow", {
          "Id",
          "idSectorSquare",
          "Margins",
          box(0, 0, 10, 1),
          "Dock",
          "left",
          "VAlign",
          "center",
          "MinWidth",
          25,
          "MinHeight",
          25,
          "MaxHeight",
          25
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idSectorId",
            "HAlign",
            "center",
            "VAlign",
            "center",
            "Clip",
            false,
            "TextStyle",
            "PDASatelliteRollover_SectorTitle",
            "Translate",
            true,
            "TextHAlign",
            "center",
            "TextVAlign",
            "center"
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "HAlign",
          "left",
          "VAlign",
          "center",
          "Clip",
          false,
          "UseClipBox",
          false,
          "FoldWhenHidden",
          true,
          "HandleMouse",
          false,
          "TextStyle",
          "HUDHeaderBig",
          "Translate",
          true,
          "TextVAlign",
          "center"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idParent",
        "Padding",
        box(6, 4, 6, 6),
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(10, 10, 10, 10),
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              context.em = const.BlueEMColor
              return context
            end,
            "__class",
            "XText",
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverText",
            "Translate",
            true,
            "Text",
            T(631817613193, "Available Operations:"),
            "HideOnEmpty",
            true
          }),
          PlaceObj("XTemplateForEach", {
            "array",
            function(parent, context)
              return GetOperationsInSector(context.sector.Id)
            end,
            "run_after",
            function(child, context, item, i, n, last)
              child:SetText(item.operation.display_name)
              if not item.enabled then
                child:SetTransparency(125)
              end
              if item.operation.id == "GatherIntel" and item.enabled and not context.sector.intel_discovered and context.sector.Intel then
                child:SetText(T({
                  990131144686,
                  "<em><display_name> (*)</em>",
                  item.operation
                }))
              end
            end
          }, {
            PlaceObj("XTemplateWindow", {
              "__context",
              function(parent, context)
                context.em = const.BlueEMColor
                return context
              end,
              "__class",
              "XText",
              "Margins",
              box(10, 0, 0, 0),
              "FoldWhenHidden",
              true,
              "TextStyle",
              "PDARolloverText",
              "Translate",
              true,
              "HideOnEmpty",
              true
            })
          })
        })
      })
    })
  })
})
