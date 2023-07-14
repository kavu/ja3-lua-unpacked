PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu Satellite UI",
  id = "PDAOperationRollover",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDARolloverClass",
    "Margins",
    box(30, 1, 0, 0),
    "UseClipBox",
    false,
    "BorderColor",
    RGBA(128, 128, 128, 0),
    "Background",
    RGBA(240, 240, 240, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextControl",
      "Id",
      "idContent",
      "Padding",
      box(6, 4, 6, 6),
      "MinWidth",
      350,
      "MaxWidth",
      350,
      "LayoutMethod",
      "VList",
      "LayoutVSpacing",
      5,
      "UseClipBox",
      false,
      "Background",
      RGBA(52, 55, 61, 255),
      "BackgroundRectGlowSize",
      1,
      "BackgroundRectGlowColor",
      RGBA(52, 55, 61, 255),
      "OnContextUpdate",
      function(self, context, ...)
        local timeLeftNumeric = GetOperationTimeLeft(context, context.Operation, {prediction = true})
        if 0 < timeLeftNumeric then
          local time = FormatCampaignTime(timeLeftNumeric, "all")
          self.idTextTime:SetText(T({
            823162191312,
            "Time left: <time>",
            time = time
          }))
        else
          self.idTextTime:SetText("")
        end
        local operationPreset = context and SectorOperations[context.Operation]
        self.idTitle:SetText(operationPreset and operationPreset.display_name)
        self.idText:SetText(operationPreset and operationPreset:GetDescription(context))
        if next(context.OperationProfessions) and #context.OperationProfessions == 1 then
          local profession = table.find_value(operationPreset.Professions, "id", context.OperationProfession)
          if profession and profession.description and profession.description ~= "" then
            self.idText:SetText(profession.description)
            self.idTitle:SetText(profession.display_name)
          end
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
          "Padding",
          box(0, 0, 0, 0),
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
          "Text",
          T(593850847736, "<Name>")
        }),
        PlaceObj("XTemplateWindow", {
          "HAlign",
          "right",
          "VAlign",
          "center",
          "MinWidth",
          21,
          "MinHeight",
          21,
          "MaxWidth",
          21,
          "MaxHeight",
          21,
          "Background",
          RGBA(69, 73, 81, 255)
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idParent",
        "Padding",
        box(8, 8, 8, 8),
        "LayoutMethod",
        "VList",
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idText",
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
          "__class",
          "XText",
          "Id",
          "idTextTime",
          "Clip",
          false,
          "UseClipBox",
          false,
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
