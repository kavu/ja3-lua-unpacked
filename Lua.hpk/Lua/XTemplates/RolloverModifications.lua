PlaceObj("XTemplate", {
  __is_kind_of = "XContextControl",
  group = "Zulu",
  id = "RolloverModifications",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XRolloverWindow"
  }, {
    PlaceObj("XTemplateWindow", {
      "__condition",
      function(parent, context)
        return GetWeaponUpgrades(context)
      end,
      "__class",
      "XContextControl",
      "Id",
      "idContent",
      "Padding",
      box(6, 4, 6, 0),
      "MinWidth",
      356,
      "MaxWidth",
      356,
      "LayoutMethod",
      "VList",
      "LayoutVSpacing",
      5,
      "Background",
      RGBA(52, 55, 61, 255),
      "BackgroundRectGlowSize",
      1,
      "BackgroundRectGlowColor",
      RGBA(52, 55, 61, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return "g_RolloverShowMoreInfo"
        end,
        "__class",
        "XContextWindow",
        "Dock",
        "ignore",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          self.parent:SetVisible(g_RolloverShowMoreInfo)
        end
      }),
      PlaceObj("XTemplateWindow", {
        "Dock",
        "top",
        "UseClipBox",
        false,
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
          "HAlign",
          "left",
          "VAlign",
          "center",
          "MaxWidth",
          450,
          "FoldWhenHidden",
          true,
          "HandleMouse",
          false,
          "TextStyle",
          "HUDHeaderBig",
          "Translate",
          true,
          "Text",
          T(602548457051, "Modifications"),
          "TextVAlign",
          "center"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(0, 0, 0, 8),
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        8
      }, {
        PlaceObj("XTemplateForEach", {
          "array",
          function(parent, context)
            return GetWeaponUpgrades(context)
          end,
          "run_after",
          function(child, context, item, i, n, last)
            local preset = WeaponComponents[item]
            child:SetContext(preset)
            child.idTitle:SetText(preset.DisplayName or "")
            child.idDescription:SetText(preset.Description or "")
            child.idIcon:SetImage(preset.Icon)
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XContextWindow",
            "IdNode",
            true,
            "Padding",
            box(8, 8, 8, 8),
            "LayoutMethod",
            "HList",
            "Background",
            RGBA(32, 35, 47, 255)
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContextImage",
              "Id",
              "idIcon",
              "MinWidth",
              108,
              "MinHeight",
              110,
              "MaxWidth",
              108,
              "MaxHeight",
              110
            }),
            PlaceObj("XTemplateWindow", {
              "LayoutMethod",
              "VList"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idTitle",
                "TextStyle",
                "PDAActivitiesButtonSmall",
                "Translate",
                true,
                "Text",
                T(440367422932, "<DisplayName>")
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idDescription",
                "TextStyle",
                "PDABrowserText",
                "Translate",
                true,
                "Text",
                T(227814808041, "<Description>")
              })
            })
          })
        })
      })
    })
  })
})
