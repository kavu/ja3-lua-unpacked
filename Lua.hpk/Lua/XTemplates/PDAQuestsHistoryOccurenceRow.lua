PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAQuestsHistoryOccurenceRow",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextWindow",
    "IdNode",
    true,
    "MaxWidth",
    900
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idSectorId",
      "Margins",
      box(-10, -5, 0, 0),
      "HAlign",
      "left",
      "VAlign",
      "center",
      "MinWidth",
      43,
      "Clip",
      "self",
      "TextStyle",
      "PDAQuests_HistoryTimestamp",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local preset = HistoryOccurences[context.id]
        local rowContext = context.context
        if preset and preset.sector then
          local text = T({
            preset.sector
          })
          self:SetText(text)
        elseif rowContext and rowContext.sector then
          local text = T({
            rowContext.sector
          })
          self:SetText(text)
        elseif rowContext and rowContext.sectorId then
          local text = T({
            877276211685,
            "<SectorId(sector)>",
            sector = rowContext.sectorId
          })
          self:SetText(text)
        end
        return XContextControl.OnContextUpdate(self, context)
      end,
      "Translate",
      true,
      "WordWrap",
      false,
      "TextHAlign",
      "right",
      "TextVAlign",
      "center"
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "DrawWindow(self, clip_box)",
        "func",
        function(self, clip_box)
          return XText.DrawWindow(self, box(0, 0, max_int, max_int))
        end
      })
    }),
    PlaceObj("XTemplateWindow", {
      "Margins",
      box(40, 0, 0, 0),
      "LayoutMethod",
      "HList"
    }, {
      PlaceObj("XTemplateWindow", {
        "Id",
        "idVertical",
        "HAlign",
        "left",
        "MinWidth",
        1,
        "MaxWidth",
        1,
        "Background",
        RGBA(88, 92, 68, 255)
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idHorizontal",
        "Margins",
        box(0, 14, 5, 0),
        "HAlign",
        "left",
        "VAlign",
        "top",
        "MinWidth",
        15,
        "MinHeight",
        1,
        "MaxWidth",
        15,
        "MaxHeight",
        1,
        "Background",
        RGBA(88, 92, 68, 255)
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idText",
        "HAlign",
        "right",
        "VAlign",
        "center",
        "TextStyle",
        "PDAQuestsNoteText",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local preset = HistoryOccurences[context.id]
          if not preset then
            self:SetText(Untranslated("Preset not found " .. context.id))
            return
          end
          self:SetText(preset:GetText(context.context))
          return XContextControl.OnContextUpdate(self, context)
        end,
        "Translate",
        true
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idTimeText",
        "Margins",
        box(0, 0, 5, 0),
        "Dock",
        "right",
        "HAlign",
        "right",
        "TextStyle",
        "PDAQuests_HistoryTimestamp",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local text = TFormat.time(context, context.time)
          self:SetText(text)
          return XContextControl.OnContextUpdate(self, context)
        end,
        "Translate",
        true
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "placeholder",
        "Id",
        "idBottomSpace",
        "Dock",
        "bottom",
        "HAlign",
        "left",
        "MinHeight",
        8,
        "MaxHeight",
        8
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "vertical line",
          "HAlign",
          "left",
          "MinWidth",
          1,
          "MaxWidth",
          1,
          "Background",
          RGBA(88, 92, 68, 255)
        })
      })
    })
  })
})
