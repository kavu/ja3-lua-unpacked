PlaceObj("XTemplate", {
  __is_kind_of = "GenericHUDButtonFrame",
  group = "Zulu",
  id = "EmailNotification",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "GenericHUDButtonFrame",
    "Id",
    "idEmailNotification",
    "Margins",
    box(0, 0, 0, 8),
    "Visible",
    false,
    "FoldWhenHidden",
    true,
    "FadeOutTime",
    5000
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XButton",
      "IdNode",
      false,
      "LayoutMethod",
      "VList",
      "Background",
      RGBA(0, 0, 0, 0),
      "ChildrenHandleMouse",
      true,
      "FocusedBorderColor",
      RGBA(0, 0, 0, 0),
      "FocusedBackground",
      RGBA(0, 0, 0, 0),
      "DisabledBorderColor",
      RGBA(0, 0, 0, 0),
      "OnPress",
      function(self, gamepad)
        OpenEmail("openNewest")
      end,
      "RolloverBackground",
      RGBA(0, 0, 0, 0),
      "PressedBackground",
      RGBA(0, 0, 0, 0)
    }, {
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(3, 2, 3, 0)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idText",
          "Margins",
          box(3, 0, 0, 0),
          "HandleMouse",
          false,
          "FocusedBorderColor",
          RGBA(0, 0, 0, 0),
          "DisabledBorderColor",
          RGBA(0, 0, 0, 0),
          "TextStyle",
          "PDAQuests_SectionHeader",
          "Translate",
          true,
          "Text",
          T(968854846061, "New Email")
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(0, -3, 0, 0)
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "h line",
          "__class",
          "XFrame",
          "Margins",
          box(8, 0, 5, 0),
          "VAlign",
          "top",
          "Image",
          "UI/PDA/separate_line_vertical",
          "FrameBox",
          box(3, 0, 3, 0),
          "SqueezeY",
          false
        }),
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return "email-notification"
          end,
          "__class",
          "XText",
          "Margins",
          box(4, 3, 4, 0),
          "HAlign",
          "left",
          "HandleMouse",
          false,
          "TextStyle",
          "PDAQuests_EmailText",
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            local unreadEmail = GetUnreadEmails()
            if #unreadEmail == 0 then
              return
            end
            local lastMail = unreadEmail[#unreadEmail]
            local emailPreset = Emails[lastMail.id]
            if emailPreset then
              self:SetText(T({
                833470911974,
                "From:<newline><sender>",
                sender = emailPreset.sender
              }))
            end
          end,
          "Translate",
          true,
          "WordWrap",
          false,
          "Shorten",
          true
        })
      })
    })
  })
})
