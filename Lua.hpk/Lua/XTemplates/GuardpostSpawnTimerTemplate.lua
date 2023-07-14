PlaceObj("XTemplate", {
  __is_kind_of = "GuardpostSpawnTimer",
  group = "Zulu",
  id = "GuardpostSpawnTimerTemplate",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GuardpostSpawnTimer",
    "ZOrder",
    0,
    "HAlign",
    "center",
    "VAlign",
    "top",
    "MinHeight",
    13,
    "MaxHeight",
    13,
    "UseClipBox",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "UseClipBox",
      false,
      "Background",
      RGBA(32, 35, 47, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "Id",
        "idBar",
        "Margins",
        box(2, 0, 2, 0),
        "LayoutMethod",
        "HList",
        "LayoutHSpacing",
        5,
        "UseClipBox",
        false
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "Update(self,tick)",
          "func",
          function(self, tick)
            for i = 1, #self do
              self:UpdateCtrl(i, tick)
            end
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "UpdateCtrl(self, idx, tick)",
          "func",
          function(self, idx, tick)
            local ctrl = self[idx]
            if idx <= tick then
              ctrl:SetBackground(GameColors.Enemy)
            elseif tick < idx then
              ctrl:SetBackground(GameColors.Grey)
            end
          end
        }),
        PlaceObj("XTemplateForEach", {
          "array",
          function(parent, context)
            return {
              1,
              2,
              3,
              4,
              5,
              6,
              7,
              8,
              9
            }
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "VAlign",
            "center",
            "MinWidth",
            13,
            "MinHeight",
            9,
            "MaxWidth",
            13,
            "MaxHeight",
            9,
            "UseClipBox",
            false
          })
        })
      })
    })
  })
})
