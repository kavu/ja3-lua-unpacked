PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu Rollover",
  id = "CrosshairLethalKill",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextWindow",
    "IdNode",
    true,
    "LayoutMethod",
    "HList"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "SetLethalKillChance(self, chance, text)",
      "func",
      function(self, chance, text)
        self.idText:SetText(text)
        local bars = 1
        if 75 < chance then
          bars = 4
        elseif 50 < chance then
          bars = 3
        elseif 25 < chance then
          bars = 2
        end
        local unfilledColor = GetColorWithAlpha(GameColors.D, 100)
        local filledColor = GameColors.I
        for i, ui in ipairs(self.idMeter) do
          local reverseIndex = #self.idMeter - i
          if bars > reverseIndex then
            ui:SetBackground(filledColor)
          else
            ui:SetBackground(unfilledColor)
          end
        end
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idText",
      "VAlign",
      "center",
      "TextStyle",
      "CrosshairStealthKill",
      "Translate",
      true
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "HAlign",
      "right",
      "VAlign",
      "top",
      "MinWidth",
      42,
      "MinHeight",
      42,
      "MaxWidth",
      42,
      "MaxHeight",
      42,
      "Transparency",
      25,
      "Image",
      "UI/Hud/death_blow",
      "ImageFit",
      "stretch"
    }),
    PlaceObj("XTemplateWindow", {
      "Id",
      "idMeter",
      "VAlign",
      "center",
      "LayoutMethod",
      "VList",
      "LayoutVSpacing",
      2,
      "FoldWhenHidden",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "MinWidth",
        8,
        "MinHeight",
        4,
        "MaxWidth",
        8,
        "MaxHeight",
        4,
        "Background",
        RGBA(130, 128, 120, 102)
      }),
      PlaceObj("XTemplateWindow", {
        "MinWidth",
        8,
        "MinHeight",
        4,
        "MaxWidth",
        8,
        "MaxHeight",
        4,
        "Background",
        RGBA(130, 128, 120, 102)
      }),
      PlaceObj("XTemplateWindow", {
        "MinWidth",
        8,
        "MinHeight",
        4,
        "MaxWidth",
        8,
        "MaxHeight",
        4,
        "Background",
        RGBA(130, 128, 120, 102)
      }),
      PlaceObj("XTemplateWindow", {
        "MinWidth",
        8,
        "MinHeight",
        4,
        "MaxWidth",
        8,
        "MaxHeight",
        4,
        "Background",
        RGBA(130, 128, 120, 102)
      })
    })
  })
})
