PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "TacticalNotification",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDialog",
    "Id",
    "idTacticalNotification",
    "ZOrder",
    5,
    "Padding",
    box(0, 20, 0, 0),
    "HAlign",
    "center",
    "VAlign",
    "top",
    "Visible",
    false,
    "FadeOutTime",
    2000,
    "ChildrenHandleMouse",
    false,
    "InitialMode",
    "none",
    "InternalModes",
    "none, red, yellow, blue",
    "FocusOnOpen",
    ""
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContentTemplate",
      "IdNode",
      false
    }, {
      PlaceObj("XTemplateMode", {"mode", "red"}, {
        PlaceObj("XTemplateWindow", {
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", nil, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XFrame",
              "Margins",
              box(-80, 0, -80, 0),
              "Dock",
              "box",
              "Image",
              "UI/Hud/combat_notification_red",
              "FrameBox",
              box(80, 0, 80, 0),
              "Rows",
              4,
              "SqueezeY",
              false
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "Open(self)",
                "func",
                function(self)
                  XFrame.Open(self)
                  self:CreateThread("animate", function()
                    while self.window_state ~= "destroying" do
                      local currentRow = self.Row
                      currentRow = currentRow + 1
                      if currentRow == self.Rows + 1 then
                        currentRow = 1
                      end
                      self:SetRow(currentRow)
                      Sleep(700)
                    end
                  end)
                end
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__context",
              function(parent, context)
                return "UpdateTacticalNotification"
              end,
              "__class",
              "XText",
              "Id",
              "idText",
              "Margins",
              box(0, 0, 0, -2),
              "Padding",
              box(0, 0, 0, 0),
              "HAlign",
              "center",
              "VAlign",
              "center",
              "TextStyle",
              "TacticalNotification",
              "Translate",
              true,
              "TextHAlign",
              "center"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return "UpdateTacticalNotification"
            end,
            "__class",
            "XText",
            "Id",
            "idBottomText",
            "Margins",
            box(0, 0, 0, -2),
            "Padding",
            box(0, 0, 0, 0),
            "HAlign",
            "center",
            "VAlign",
            "center",
            "Clip",
            false,
            "UseClipBox",
            false,
            "TextStyle",
            "TacticalNotificationGlow",
            "Translate",
            true,
            "TextHAlign",
            "center"
          })
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "yellow"}, {
        PlaceObj("XTemplateWindow", {
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", nil, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XFrame",
              "Margins",
              box(-80, 0, -80, 0),
              "Dock",
              "box",
              "Image",
              "UI/Hud/combat_notification_yellow",
              "FrameBox",
              box(80, 0, 80, 0),
              "Rows",
              4,
              "SqueezeY",
              false
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "Open(self)",
                "func",
                function(self)
                  XFrame.Open(self)
                  self:CreateThread("animate", function()
                    while self.window_state ~= "destroying" do
                      local currentRow = self.Row
                      currentRow = currentRow + 1
                      if currentRow == self.Rows + 1 then
                        currentRow = 1
                      end
                      self:SetRow(currentRow)
                      Sleep(700)
                    end
                  end)
                end
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__context",
              function(parent, context)
                return "UpdateTacticalNotification"
              end,
              "__class",
              "XText",
              "Id",
              "idText",
              "Margins",
              box(0, 0, 0, -2),
              "Padding",
              box(0, 0, 0, 0),
              "HAlign",
              "center",
              "VAlign",
              "center",
              "TextStyle",
              "TacticalNotification",
              "Translate",
              true,
              "TextHAlign",
              "center"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return "UpdateTacticalNotification"
            end,
            "__class",
            "XText",
            "Id",
            "idBottomText",
            "Margins",
            box(0, 0, 0, -2),
            "Padding",
            box(0, 0, 0, 0),
            "HAlign",
            "center",
            "VAlign",
            "center",
            "Clip",
            false,
            "UseClipBox",
            false,
            "TextStyle",
            "TacticalNotificationGlow",
            "Translate",
            true,
            "TextHAlign",
            "center"
          })
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "blue"}, {
        PlaceObj("XTemplateWindow", {
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", nil, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XFrame",
              "Margins",
              box(-80, 0, -80, 0),
              "Dock",
              "box",
              "Image",
              "UI/Hud/combat_notification_blue",
              "FrameBox",
              box(80, 0, 80, 0),
              "Rows",
              4,
              "SqueezeY",
              false
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "Open(self)",
                "func",
                function(self)
                  XFrame.Open(self)
                  self:CreateThread("animate", function()
                    while self.window_state ~= "destroying" do
                      local currentRow = self.Row
                      currentRow = currentRow + 1
                      if currentRow == self.Rows + 1 then
                        currentRow = 1
                      end
                      self:SetRow(currentRow)
                      Sleep(700)
                    end
                  end)
                end
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__context",
              function(parent, context)
                return "UpdateTacticalNotification"
              end,
              "__class",
              "XText",
              "Id",
              "idText",
              "Margins",
              box(0, 0, 0, -2),
              "Padding",
              box(0, 0, 0, 0),
              "HAlign",
              "center",
              "VAlign",
              "center",
              "TextStyle",
              "TacticalNotification",
              "Translate",
              true,
              "TextHAlign",
              "center"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return "UpdateTacticalNotification"
            end,
            "__class",
            "XText",
            "Id",
            "idBottomText",
            "Margins",
            box(0, 0, 0, -2),
            "Padding",
            box(0, 0, 0, 0),
            "HAlign",
            "center",
            "VAlign",
            "center",
            "Clip",
            false,
            "UseClipBox",
            false,
            "TextStyle",
            "TacticalNotificationGlow",
            "Translate",
            true,
            "TextHAlign",
            "center"
          })
        })
      })
    })
  })
})
