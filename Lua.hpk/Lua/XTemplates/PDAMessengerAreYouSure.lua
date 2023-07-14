PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAMessengerAreYouSure",
  PlaceObj("XTemplateWindow", {
    "__class",
    "ZuluModalDialog",
    "Id",
    "idAreYouSure",
    "Dock",
    "box",
    "Background",
    RGBA(30, 30, 35, 115),
    "ContextUpdateOnOpen",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      self.idDuration:SetText(T({
        541555379607,
        "Time: <right><days> days",
        days = context.duration
      }))
      self.idPrice:SetText(T({
        951792823996,
        "Hiring: <right><money(mercPrice)>",
        mercPrice = context.price
      }))
      self.idMedical:SetVisible(context.medical > 0)
      self.idMedical:SetText(T({
        800163233850,
        "Medical: <right><money(price)>",
        price = context.medical
      }))
    end
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionClose",
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "ButtonB",
      "OnAction",
      function(self, host, source, ...)
        host:Close()
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionConfirm",
      "ActionGamepad",
      "ButtonA",
      "OnAction",
      function(self, host, source, ...)
        host:Close("ok")
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "IdNode",
      false,
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      310,
      "MinHeight",
      200,
      "Image",
      "UI/PDA/Chat/T_Call_Background",
      "FrameBox",
      box(2, 2, 2, 2)
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "header",
        "Dock",
        "top",
        "LayoutMethod",
        "HList",
        "LayoutHSpacing",
        5,
        "Background",
        RGBA(65, 130, 158, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Margins",
          box(10, 0, 0, 0),
          "VAlign",
          "center",
          "TextStyle",
          "PDAMessengerHeader",
          "Translate",
          true,
          "Text",
          T(428681090363, "A.I.M. CONTRACT"),
          "TextVAlign",
          "center"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "footer (this needs to be first to be considered for the box)",
        "Margins",
        box(10, 2, 10, 10),
        "Dock",
        "bottom",
        "LayoutMethod",
        "HList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "Dock",
          "box",
          "Image",
          "UI/PDA/Chat/line_frame",
          "FrameBox",
          box(3, 3, 3, 3),
          "TransparentCenter",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 3, 0, 3),
          "Dock",
          "box",
          "HAlign",
          "center",
          "MinWidth",
          250,
          "LayoutMethod",
          "HList"
        }, {
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return parent:ResolveId("node")
            end,
            "__class",
            "XTextButton",
            "Id",
            "idAdvance",
            "Margins",
            box(5, 0, 5, 0),
            "HAlign",
            "center",
            "VAlign",
            "center",
            "MinWidth",
            120,
            "LayoutMethod",
            "VList",
            "LayoutVSpacing",
            5,
            "FoldWhenHidden",
            true,
            "Background",
            RGBA(255, 255, 255, 0),
            "MouseCursor",
            "UI/Cursors/Pda_Hand.tga",
            "OnContextUpdate",
            function(self, context, ...)
              local limit = self.UpdateTimeLimit
              if limit == 0 or limit <= RealTime() - self.last_update_time then
                self:SetText(self.Text)
              elseif not self:GetThread("ContextUpdate") then
                self:CreateThread("ContextUpdate", function(self)
                  Sleep(self.last_update_time + self.UpdateTimeLimit - RealTime())
                  self:OnContextUpdate()
                end, self)
              end
            end,
            "FocusedBackground",
            RGBA(255, 255, 255, 0),
            "OnPressEffect",
            "action",
            "OnPressParam",
            "actionConfirm",
            "RolloverBackground",
            RGBA(255, 255, 255, 0),
            "PressedBackground",
            RGBA(255, 255, 255, 0),
            "Icon",
            "UI/PDA/Chat/T_Call_Offer",
            "TextStyle",
            "PDACommonButtonChat",
            "Translate",
            true,
            "Text",
            T(245246324573, "Confirm")
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "gamepad hint",
              "__context",
              function(parent, context)
                return "GamepadUIStyleChanged"
              end,
              "__parent",
              function(parent, context)
                return parent.idIcon
              end,
              "__class",
              "XText",
              "Margins",
              box(0, 0, -5, -5),
              "HAlign",
              "right",
              "VAlign",
              "bottom",
              "Clip",
              false,
              "UseClipBox",
              false,
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                self:SetVisible(GetUIStyleGamepad())
                XText.OnContextUpdate(self, context, ...)
              end,
              "Translate",
              true,
              "Text",
              T(790070189912, "<ButtonASmall>")
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XFrame",
            "Margins",
            box(5, 0, 5, 0),
            "HAlign",
            "center",
            "MinHeight",
            3,
            "MaxHeight",
            3,
            "Image",
            "UI/PDA/Chat/T_Call_Line_Vertical",
            "SqueezeX",
            false,
            "SqueezeY",
            false
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XTextButton",
            "Id",
            "idClose",
            "Margins",
            box(5, 0, 5, 0),
            "HAlign",
            "right",
            "VAlign",
            "center",
            "MinWidth",
            120,
            "LayoutMethod",
            "VList",
            "LayoutVSpacing",
            5,
            "FoldWhenHidden",
            true,
            "Background",
            RGBA(255, 255, 255, 0),
            "MouseCursor",
            "UI/Cursors/Pda_Hand.tga",
            "FocusedBackground",
            RGBA(255, 255, 255, 0),
            "OnPressEffect",
            "action",
            "OnPressParam",
            "actionClose",
            "RolloverBackground",
            RGBA(255, 255, 255, 0),
            "PressedBackground",
            RGBA(255, 255, 255, 0),
            "Icon",
            "UI/PDA/Chat/T_Call_Hang_Up",
            "TextStyle",
            "PDACommonButtonChat",
            "Translate",
            true,
            "Text",
            T(934584920929, "Cancel")
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "gamepad hint",
              "__context",
              function(parent, context)
                return "GamepadUIStyleChanged"
              end,
              "__parent",
              function(parent, context)
                return parent.idIcon
              end,
              "__class",
              "XText",
              "Margins",
              box(0, 0, -5, -5),
              "HAlign",
              "right",
              "VAlign",
              "bottom",
              "Clip",
              false,
              "UseClipBox",
              false,
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                self:SetVisible(GetUIStyleGamepad())
                XText.OnContextUpdate(self, context, ...)
              end,
              "Translate",
              true,
              "Text",
              T(749617366030, "<ButtonBSmall>")
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(10, 5, 10, 2),
        "Dock",
        "box",
        "MinHeight",
        75,
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "Dock",
          "box",
          "Image",
          "UI/PDA/Chat/line_frame",
          "FrameBox",
          box(3, 3, 3, 3),
          "TransparentCenter",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idDuration",
          "Margins",
          box(10, 5, 10, 5),
          "TextStyle",
          "PDACommonButton",
          "Translate",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "LayoutMethod",
          "VList",
          "LayoutVSpacing",
          -5
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XFrame",
            "Margins",
            box(3, 0, 3, 10),
            "VAlign",
            "top",
            "MinHeight",
            3,
            "MaxHeight",
            3,
            "Image",
            "UI/PDA/Chat/T_Call_Line_Horizontal",
            "FrameBox",
            box(5, 5, 5, 5),
            "SqueezeX",
            false,
            "SqueezeY",
            false
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idPrice",
            "Margins",
            box(10, 0, 10, 0),
            "TextStyle",
            "PDACommonButton",
            "Translate",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idMedical",
            "Margins",
            box(10, 0, 10, 0),
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDACommonButton",
            "Translate",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "VAlign",
            "bottom",
            "MinHeight",
            15,
            "MaxHeight",
            15
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Padding",
        box(10, 10, 10, 0),
        "Dock",
        "box"
      }, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 0, 8, 0),
          "Dock",
          "left",
          "MinWidth",
          170,
          "MaxWidth",
          170,
          "LayoutMethod",
          "VList",
          "LayoutVSpacing",
          5
        })
      })
    })
  })
})
