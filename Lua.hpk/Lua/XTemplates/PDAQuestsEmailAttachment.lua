PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu PDA",
  id = "PDAQuestsEmailAttachment",
  PlaceObj("XTemplateWindow", {
    "comment",
    "content frame",
    "__class",
    "XContextWindow",
    "Id",
    "idAttachmentWindow",
    "IdNode",
    true,
    "ZOrder",
    100,
    "Margins",
    box(416, 0, 0, 0),
    "Dock",
    "box",
    "HAlign",
    "center",
    "VAlign",
    "center",
    "MinWidth",
    836,
    "MinHeight",
    632,
    "MaxWidth",
    836,
    "MaxHeight",
    632,
    "UseClipBox",
    false,
    "DrawOnTop",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "IdNode",
      false,
      "Padding",
      box(0, 1, 0, 0),
      "Dock",
      "top",
      "MinHeight",
      32,
      "MaxHeight",
      32,
      "DrawOnTop",
      true,
      "Image",
      "UI/PDA/os_header",
      "FrameBox",
      box(5, 5, 5, 5),
      "SqueezeY",
      false
    }, {
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(10, 0, 0, 0),
        "LayoutMethod",
        "HList",
        "LayoutHSpacing",
        10
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idHeaderText",
          "VAlign",
          "bottom",
          "TextStyle",
          "PDAQuests_HeaderBig",
          "Translate",
          true,
          "Text",
          T(294802212474, "A.I.M. <valign bottom -1><style PDAQuests_HeaderSmall>VIEWER</style>"),
          "TextVAlign",
          "bottom"
        })
      }),
      PlaceObj("XTemplateTemplate", {
        "__template",
        "PDASmallButton",
        "ZOrder",
        10,
        "Margins",
        box(0, 0, 2, 0),
        "Dock",
        "right",
        "HAlign",
        "center",
        "VAlign",
        "center",
        "MinWidth",
        20,
        "MinHeight",
        20,
        "MaxWidth",
        20,
        "MaxHeight",
        20,
        "CenterImage",
        ""
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "ZOrder",
          10,
          "Dock",
          "box",
          "HAlign",
          "center",
          "VAlign",
          "center",
          "Text",
          "?",
          "TextHAlign",
          "center",
          "TextVAlign",
          "center"
        })
      }),
      PlaceObj("XTemplateTemplate", {
        "__template",
        "PDASmallButton",
        "Margins",
        box(0, 0, 2, 0),
        "Dock",
        "right",
        "HAlign",
        "center",
        "VAlign",
        "center",
        "MinWidth",
        20,
        "MinHeight",
        20,
        "MaxWidth",
        20,
        "MaxHeight",
        20,
        "OnPress",
        function(self, gamepad)
          local attachmentWindow = self:ResolveId("node")
          attachmentWindow:Close()
        end,
        "CenterImage",
        ""
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "ZOrder",
          10,
          "Dock",
          "box",
          "HAlign",
          "center",
          "VAlign",
          "center",
          "Text",
          "X",
          "TextHAlign",
          "center",
          "TextVAlign",
          "center"
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "IdNode",
      false,
      "Margins",
      box(0, -3, 0, 0),
      "Padding",
      box(18, 0, 18, 0),
      "Dock",
      "box",
      "LayoutMethod",
      "VList",
      "Image",
      "UI/PDA/os_background",
      "FrameBox",
      box(5, 5, 5, 5)
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "name",
        "__class",
        "XText",
        "HAlign",
        "center",
        "VAlign",
        "center",
        "MinHeight",
        44,
        "MaxHeight",
        44,
        "TextStyle",
        "PDAQuests_AttachmentText",
        "ContextUpdateOnOpen",
        true,
        "Translate",
        true,
        "Text",
        T(522188795966, "<name>"),
        "TextHAlign",
        "center",
        "TextVAlign",
        "center"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContextImage",
        "Dock",
        "box",
        "MinWidth",
        800,
        "MinHeight",
        450,
        "MaxWidth",
        800,
        "MaxHeight",
        450,
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          self:SetImage(context.picture)
        end
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContextWindow",
        "Dock",
        "bottom",
        "MinHeight",
        74,
        "MaxHeight",
        74,
        "LayoutMethod",
        "Grid"
      }, {
        PlaceObj("XTemplateWindow", {
          "HAlign",
          "left",
          "VAlign",
          "center",
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Padding",
            box(0, 0, 0, 0),
            "TextStyle",
            "PDAQuests_AttachmentText",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              self:SetText(context.resolution)
              return XContextControl.OnContextUpdate(self, context)
            end,
            "Translate",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Padding",
            box(0, 0, 0, 0),
            "TextStyle",
            "PDAQuests_AttachmentText",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              self:SetText(context.size)
              return XContextControl.OnContextUpdate(self, context)
            end,
            "Translate",
            true
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "100%",
          "__class",
          "XText",
          "HAlign",
          "center",
          "VAlign",
          "center",
          "GridX",
          2,
          "TextStyle",
          "PDAQuests_AttachmentTextBig",
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            self:SetText(context.scale)
            return XContextControl.OnContextUpdate(self, context)
          end,
          "Translate",
          true,
          "TextHAlign",
          "center",
          "TextVAlign",
          "center"
        }),
        PlaceObj("XTemplateWindow", {
          "HAlign",
          "right",
          "VAlign",
          "center",
          "GridX",
          3,
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Padding",
            box(0, 0, 0, 0),
            "TextStyle",
            "PDAQuests_AttachmentText",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local dlg = GetDialog(self)
              self:SetText(TFormat.EmailDate(dlg.selectedEmail))
              return XContextControl.OnContextUpdate(self, context)
            end,
            "Translate",
            true,
            "Text",
            T(761034571924, "800x420x24bpp")
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Padding",
            box(0, 0, 0, 0),
            "TextStyle",
            "PDAQuests_AttachmentText",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local dlg = GetDialog(self)
              self:SetText(TFormat.EmailTime(dlg.selectedEmail))
              return XContextControl.OnContextUpdate(self, context)
            end,
            "Translate",
            true,
            "Text",
            T(962997734955, "82kb"),
            "TextHAlign",
            "right"
          })
        })
      })
    })
  })
})
