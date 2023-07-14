PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu Satellite UI",
  id = "RolloverQuests",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDARolloverClass",
    "BorderWidth",
    0,
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
        if context.quest and context.quest.preset then
          self.idTitle:SetText(context.quest.preset.DisplayName)
          local lines = {}
          for i, l in ipairs(context.quest.notes) do
            lines[#lines + 1] = FormatQuestLineUI(l, context.quest.state, "visible")
          end
          self.idText:SetText(table.concat(lines, "\n"))
        elseif context.quest and next(context.quest) then
          self.idTitle:SetText(1 < #context.quest and T(882126902415, "Multiple Quests") or context.quest[1].preset.DisplayName)
          local lines = {}
          for i, q in ipairs(context.quest) do
            for j, l in ipairs(q.notes) do
              lines[#lines + 1] = Untranslated((i == 1 and "<bullet_point> " or "") .. _InternalTranslate(FormatQuestLineUI(l, context.quest.state, "visible"), q.state))
            end
          end
          self.idParent:SetContext(lines)
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
          "HAlign",
          "center",
          "VAlign",
          "center",
          "MinWidth",
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
          "Text",
          T(189800741094, "<display_name>"),
          "TextVAlign",
          "center"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContentTemplate",
        "Id",
        "idParent",
        "Padding",
        box(6, 6, 6, 6),
        "MaxWidth",
        800,
        "MaxHeight",
        800,
        "LayoutMethod",
        "VWrap",
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateForEach", {
          "array",
          function(parent, context)
            return parent.context
          end,
          "run_after",
          function(child, context, item, i, n, last)
            child.idText:SetText(item)
            if i == last then
              child.idSeparator:SetVisible(false)
            else
              child.idSeparator:SetVisible(true)
            end
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XContextWindow",
            "IdNode",
            true,
            "MaxWidth",
            400
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idText",
              "Margins",
              box(10, 3, 10, 3),
              "FoldWhenHidden",
              true,
              "TextStyle",
              "PDARolloverText",
              "Translate",
              true,
              "HideOnEmpty",
              true
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "separator line",
              "__class",
              "XFrame",
              "Id",
              "idSeparator",
              "Dock",
              "bottom",
              "FoldWhenHidden",
              true,
              "Transparency",
              128,
              "Image",
              "UI/PDA/separate_line_vertical",
              "FrameBox",
              box(5, 0, 5, 0),
              "SqueezeY",
              false
            })
          })
        })
      })
    })
  })
})
