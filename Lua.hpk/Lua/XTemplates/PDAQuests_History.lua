PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAQuests_History",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return gv_HistoryOccurences
    end,
    "__class",
    "PDAHistoryClass",
    "Margins",
    box(16, 16, 6, 16),
    "HostInParent",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "comment",
      "weeks list",
      "Dock",
      "left",
      "MinWidth",
      394,
      "MaxWidth",
      394
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "Dock",
        "box",
        "Image",
        "UI/PDA/os_background_2",
        "FrameBox",
        box(5, 5, 5, 5)
      }),
      PlaceObj("XTemplateWindow", {"comment", "content"}, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "MessengerScrollbar",
          "Id",
          "idWeeksScroll",
          "Dock",
          "right",
          "Target",
          "idWeeks",
          "AutoHide",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "SnappingScrollArea",
          "Id",
          "idWeeks",
          "Margins",
          box(8, 6, 8, 10),
          "Dock",
          "box",
          "VScroll",
          "idWeeksScroll",
          "ShowPartialItems",
          true,
          "LeftThumbScroll",
          false
        }, {
          PlaceObj("XTemplateForEach", {
            "comment",
            "week",
            "array",
            function(parent, context)
              return GetWeeksWithOccurences()
            end,
            "__context",
            function(parent, context, item, i, n)
              return item
            end
          }, {
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(0, 5, 0, 5),
              "VAlign",
              "bottom",
              "MinHeight",
              36,
              "MaxHeight",
              36,
              "LayoutMethod",
              "VList"
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "PDAQuestsHistoryWeek"
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XFrame",
                "Margins",
                box(3, 0, 0, 0),
                "Image",
                "UI/PDA/separate_line_vertical",
                "FrameBox",
                box(3, 3, 3, 3),
                "SqueezeY",
                false
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "IsSelectable(self)",
                "func",
                function(self)
                  return false
                end
              })
            }),
            PlaceObj("XTemplateForEach", {
              "comment",
              "day in the week",
              "array",
              function(parent, context)
                return GetDaysWithOccurences(context)
              end,
              "run_after",
              function(child, context, item, i, n, last)
                rawset(child, "hidekey", context)
                child:SetContext(item)
              end
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "PDAQuestsHistoryDayButton",
                "MouseCursor",
                "UI/Cursors/Pda_Hand.tga"
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "IsSelectable(self)",
                  "func",
                  function(self)
                    return true
                  end
                }),
                PlaceObj("XTemplateFunc", {
                  "name",
                  "SetSelected(self, selected)",
                  "func",
                  function(self, selected)
                    if self.idButton and selected then
                      self.idButton:OnPress()
                    end
                    self:SetFocus(selected)
                  end
                })
              })
            })
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "EnactHideKey(self, key, value)",
            "func",
            function(self, key, value)
              for i = 2, #self, 2 do
                local days = self[i]
                for i, wnd in ipairs(days) do
                  local hidekey = rawget(wnd, "hidekey")
                  if hidekey and hidekey == key then
                    wnd:SetVisible(value)
                  end
                end
              end
            end
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "selected day info",
      "Margins",
      box(25, 0, 0, 0),
      "Dock",
      "box"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContentTemplateList",
        "Id",
        "idHistoryRows",
        "BorderWidth",
        0,
        "Background",
        RGBA(255, 255, 255, 0),
        "FocusedBackground",
        RGBA(255, 255, 255, 0),
        "VScroll",
        "idHistoryScroll",
        "MouseScroll",
        true,
        "LeftThumbScroll",
        false,
        "GamepadInitialSelection",
        false
      }, {
        PlaceObj("XTemplateForEach", {
          "comment",
          "day with occurence",
          "array",
          function(parent, context)
            return GetDaysWithOccurences()
          end,
          "__context",
          function(parent, context, item, i, n)
            return SubContext(GetOccurencesByDay(item), {day = item})
          end,
          "run_before",
          function(parent, context, item, i, n, last)
            local child = NewXVirtualContent(parent, context, "PDAQuestsHistoryDayList", nil, nil, nil, nil, 94)
            child:SetId("idDay" .. context.day)
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "SetFocus(self)",
          "func",
          function(self)
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "MessengerScrollbar",
        "Id",
        "idHistoryScroll",
        "Margins",
        box(6, 0, 0, 0),
        "Dock",
        "right",
        "Target",
        "idHistoryRows",
        "AutoHide",
        true
      })
    })
  })
})
