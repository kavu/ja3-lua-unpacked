PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDALoadingBar",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDALoadingBar",
    "Background",
    RGBA(30, 30, 35, 115)
  }, {
    PlaceObj("XTemplateWindow", {
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      180,
      "MinHeight",
      56,
      "MaxWidth",
      180,
      "MaxHeight",
      56
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "Dock",
        "box",
        "Image",
        "UI/PDA/os_background",
        "FrameBox",
        box(5, 5, 5, 5)
      }),
      PlaceObj("XTemplateWindow", {
        "Padding",
        box(18, 3, 18, 12)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idText",
          "HAlign",
          "center",
          "VAlign",
          "top",
          "TextStyle",
          "PDARolloverTextSmaller",
          "Translate",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "IdNode",
          false,
          "HAlign",
          "center",
          "VAlign",
          "bottom",
          "MinHeight",
          14,
          "MaxHeight",
          14,
          "Image",
          "UI/PDA/os_background_2",
          "FrameBox",
          box(5, 5, 5, 5)
        }, {
          PlaceObj("XTemplateWindow", {
            "Id",
            "idBar",
            "Margins",
            box(4, 0, 4, 0),
            "HAlign",
            "center",
            "VAlign",
            "center",
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            4
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
                  ctrl:SetBackground(GameColors.Player)
                elseif tick < idx then
                  ctrl:SetBackground(GameColors.DarkA)
                else
                  ctrl:SetBackground(RGB(54, 85, 103))
                end
                local isLast = idx == tick
                if not isLast then
                  ctrl:RemoveModifier("zoom")
                  return
                end
                ctrl:AddInterpolation({
                  id = "zoom",
                  type = const.intRect,
                  duration = 0,
                  originalRect = ctrl.box,
                  originalRectAutoZoom = 1000,
                  targetRect = ctrl:CalcZoomedBox(1300),
                  targetRectAutoZoom = 1300
                })
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
                  9,
                  10,
                  11,
                  12,
                  13,
                  14
                }
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "HAlign",
                "left",
                "VAlign",
                "center",
                "MinWidth",
                6,
                "MinHeight",
                9,
                "MaxWidth",
                6,
                "MaxHeight",
                9
              })
            })
          })
        })
      })
    })
  })
})
