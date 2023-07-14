PlaceObj("XTemplate", {
  __is_kind_of = "XButton",
  group = "Zulu",
  id = "QuestTracker",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return gv_Quests
    end,
    "__class",
    "XButton",
    "IdNode",
    false,
    "OnLayoutComplete",
    function(self)
      self:SetMouseCursor(gv_SatelliteView and "UI/Cursors/Pda_Hand.tga" or "UI/Cursors/Hand.tga")
    end,
    "Background",
    RGBA(0, 0, 0, 0),
    "FocusedBackground",
    RGBA(0, 0, 0, 0),
    "OnPress",
    function(self, gamepad)
      InvokeShortcutAction(self, "actionOpenNotes")
    end,
    "RolloverBackground",
    RGBA(0, 0, 0, 0),
    "PressedBackground",
    RGBA(0, 0, 0, 0)
  }, {
    PlaceObj("XTemplateTemplate", {
      "__template",
      "GenericHUDButtonFrame",
      "Id",
      "idQuestPopout",
      "Margins",
      box(0, 1, 0, 8),
      "MinWidth",
      360,
      "MaxWidth",
      360,
      "FoldWhenHidden",
      true,
      "HandleMouse",
      false
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "Open(self)",
        "parent",
        function(parent, context)
          return parent:ResolveId("node")
        end,
        "func",
        function(self)
          XContextWindow.Open(self)
        end
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContentTemplate",
        "Id",
        "idQuestContent",
        "LayoutMethod",
        "VList",
        "FoldWhenHidden",
        true
      }, {
        PlaceObj("XTemplateForEach", {
          "array",
          function(parent, context)
            return GetAllQuestsForTracker()
          end,
          "__context",
          function(parent, context, item, i, n)
            return item
          end,
          "run_after",
          function(child, context, item, i, n, last)
            child.idTitle:SetText(item.Name)
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
            true
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "quest name",
              "Padding",
              box(10, 5, 10, 0),
              "Dock",
              "top",
              "BorderColor",
              RGBA(52, 55, 61, 230)
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Margins",
                box(0, 0, 5, 0),
                "Dock",
                "left",
                "Image",
                "UI/PDA/T_Icon_MainQuest",
                "ImageScale",
                point(450, 450)
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idTitle",
                "Clip",
                false,
                "UseClipBox",
                false,
                "HandleMouse",
                false,
                "TextStyle",
                "PDAQuestName",
                "Translate",
                true
              })
            }),
            PlaceObj("XTemplateWindow", {
              "Id",
              "idNotes",
              "Margins",
              box(0, -8, 0, 0),
              "Padding",
              box(10, 10, 10, 5),
              "LayoutMethod",
              "VList"
            }, {
              PlaceObj("XTemplateForEach", {
                "comment",
                "quest objective",
                "array",
                function(parent, context)
                  return context.Notes
                end,
                "run_after",
                function(child, context, item, i, n, last)
                  child:SetText(item.Text)
                end
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Clip",
                  false,
                  "UseClipBox",
                  false,
                  "HandleMouse",
                  false,
                  "TextStyle",
                  "PDAQuestTrackerDescr",
                  "Translate",
                  true
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "separator line",
                  "__class",
                  "XFrame",
                  "Margins",
                  box(0, 5, 0, 5),
                  "FoldWhenHidden",
                  true,
                  "Image",
                  "UI/PDA/separate_line_vertical",
                  "FrameBox",
                  box(5, 0, 5, 0),
                  "SqueezeY",
                  false
                })
              }),
              PlaceObj("XTemplateCode", {
                "run",
                function(self, parent, context)
                  local lastLine = parent[#parent]
                  if lastLine then
                    lastLine:SetVisible(false)
                  end
                end
              })
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "separator line",
              "Id",
              "idSeparator",
              "Margins",
              box(6, 5, 6, 5),
              "Dock",
              "bottom",
              "MinHeight",
              1,
              "MaxHeight",
              1,
              "Visible",
              false,
              "FoldWhenHidden",
              true,
              "Background",
              RGBA(130, 128, 120, 255),
              "Transparency",
              77
            })
          })
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "RespawnContent(self)",
          "func",
          function(self)
            XContentTemplate.RespawnContent(self)
            GetDialog(self).idMenu[1]:SetVisible(0 < #self)
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "Open(self)",
          "func",
          function(self)
            XContentTemplate.Open(self)
            GetDialog(self).idMenu[1]:SetVisible(0 < #self)
          end
        })
      })
    })
  })
})
