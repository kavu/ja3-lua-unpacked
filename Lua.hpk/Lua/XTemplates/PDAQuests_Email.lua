PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAQuests_Email",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return gv_ReceivedEmails
    end,
    "__class",
    "PDAEmailsClass",
    "Margins",
    box(16, 16, 4, 16),
    "LayoutMethod",
    "HList",
    "HostInParent",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "comment",
      "Left side",
      "__class",
      "XFrame",
      "IdNode",
      false,
      "Padding",
      box(11, 14, 11, 8),
      "HAlign",
      "right",
      "MinWidth",
      394,
      "MinHeight",
      580,
      "MaxWidth",
      394,
      "LayoutMethod",
      "VList",
      "Image",
      "UI/PDA/os_background_2",
      "FrameBox",
      box(5, 5, 5, 5)
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "Inbox",
        "__class",
        "XText",
        "TextStyle",
        "PDAQuests_SectionHeader",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local text = T({
            783176295548,
            "Inbox [<count>]",
            count = #context
          })
          self:SetText(text)
          return XContextControl.OnContextUpdate(self, context)
        end,
        "Translate",
        true,
        "Text",
        T(877125939470, "INBOX")
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "Margins",
        box(4, 0, 0, 0),
        "Image",
        "UI/PDA/separate_line_vertical",
        "FrameBox",
        box(3, 3, 3, 3),
        "SqueezeY",
        false
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "Label list",
        "__class",
        "XContentTemplateList",
        "Id",
        "idLabelList",
        "IdNode",
        false,
        "Padding",
        box(26, 5, 0, 0),
        "BorderColor",
        RGBA(0, 0, 0, 0),
        "Background",
        RGBA(0, 0, 0, 0),
        "FocusedBorderColor",
        RGBA(0, 0, 0, 0),
        "FocusedBackground",
        RGBA(0, 0, 0, 0),
        "LeftThumbScroll",
        false,
        "SetFocusOnOpen",
        true
      }, {
        PlaceObj("XTemplateForEach", {
          "comment",
          "label",
          "array",
          function(parent, context)
            return PresetArray("EmailLabel")
          end,
          "__context",
          function(parent, context, item, i, n)
            return item
          end
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "PDAQuestsEmailLabelButton"
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "IsSelectable(self)",
              "func",
              function(self)
                local emailsWithLabel = GetReceivedEmailsWithLabel(self.context.id)
                return emailsWithLabel and 0 < #emailsWithLabel
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
      PlaceObj("XTemplateWindow", {
        "comment",
        "other sections",
        "Dock",
        "bottom",
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "contacts",
          "__class",
          "XText",
          "Padding",
          box(0, 0, 0, 0),
          "MinHeight",
          38,
          "Transparency",
          153,
          "Enabled",
          false,
          "TextStyle",
          "PDAQuests_SectionHeader",
          "Translate",
          true,
          "Text",
          T(209477922598, "CONTACTS"),
          "TextVAlign",
          "center"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "Image",
          "UI/PDA/separate_line_vertical",
          "FrameBox",
          box(3, 3, 3, 3),
          "SqueezeY",
          false
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "calendar",
          "__class",
          "XText",
          "Padding",
          box(0, 0, 0, 0),
          "MinHeight",
          38,
          "Transparency",
          153,
          "Enabled",
          false,
          "TextStyle",
          "PDAQuests_SectionHeader",
          "Translate",
          true,
          "Text",
          T(878879006091, "CALENDAR"),
          "TextVAlign",
          "center"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "Image",
          "UI/PDA/separate_line_vertical",
          "FrameBox",
          box(3, 3, 3, 3),
          "SqueezeY",
          false
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "tools",
          "__class",
          "XText",
          "Padding",
          box(0, 0, 0, 0),
          "MinHeight",
          38,
          "Transparency",
          153,
          "Enabled",
          false,
          "TextStyle",
          "PDAQuests_SectionHeader",
          "Translate",
          true,
          "Text",
          T(374385579432, "TOOLS"),
          "TextVAlign",
          "center"
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "Right side",
      "__class",
      "XContextWindow",
      "Margins",
      box(12, 0, 0, 0),
      "Padding",
      box(0, 0, 24, 0),
      "MinWidth",
      984,
      "MinHeight",
      580,
      "LayoutMethod",
      "VList"
    }, {
      PlaceObj("XTemplateWindow", {
        "Dock",
        "bottom",
        "HAlign",
        "left",
        "MinWidth",
        972,
        "MinHeight",
        234,
        "MaxWidth",
        972,
        "MaxHeight",
        234
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "email body",
          "__class",
          "XFrame",
          "Dock",
          "box",
          "Image",
          "UI/PDA/os_background_2",
          "FrameBox",
          box(5, 5, 5, 5)
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "MessengerScrollbar",
          "Id",
          "idBodyScroll",
          "Margins",
          box(12, 0, 0, 0),
          "Dock",
          "right",
          "Target",
          "idEmailBody",
          "AutoHide",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContentTemplateScrollArea",
          "Id",
          "idEmailBody",
          "IdNode",
          false,
          "Padding",
          box(12, 8, 12, 8),
          "VScroll",
          "idBodyScroll"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idEmailText",
            "TextStyle",
            "PDAQuests_EmailText",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local dlg = GetDialog(self)
              local email = dlg.selectedEmail
              if email then
                local preset = Emails[email.id]
                self:SetText(T({
                  preset.body,
                  email.context
                }))
              end
              return XContextControl.OnContextUpdate(self, context)
            end,
            "Translate",
            true
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "OnHyperLink(self, hyperlink, argument, hyperlink_box, pos, button)",
              "func",
              function(self, hyperlink, argument, hyperlink_box, pos, button)
                if hyperlink == "OpenIMPPage" then
                  OpenIMPPage()
                end
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XContextWindow",
            "Padding",
            box(8, 0, 8, 0),
            "Dock",
            "bottom",
            "LayoutMethod",
            "VList",
            "Visible",
            false,
            "FoldWhenHidden",
            true,
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local dlg = GetDialog(self)
              if dlg.selectedEmail then
                local preset = Emails[dlg.selectedEmail.id]
                local hasAttachment = preset.attachments and #preset.attachments > 0
                self:SetVisible(hasAttachment)
              end
            end
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XFrame",
              "Image",
              "UI/PDA/separate_line_vertical",
              "FrameBox",
              box(3, 3, 3, 3),
              "SqueezeY",
              false
            }),
            PlaceObj("XTemplateWindow", {
              "MinHeight",
              60,
              "MaxHeight",
              60,
              "LayoutMethod",
              "HList",
              "Background",
              RGBA(255, 255, 255, 0)
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Margins",
                box(0, 0, 16, 0),
                "Image",
                "UI/PDA/Quest/e_image"
              }),
              PlaceObj("XTemplateWindow", {
                "__context",
                function(parent, context)
                  return {}
                end,
                "__class",
                "XContentTemplate",
                "Id",
                "idAttachments",
                "LayoutMethod",
                "HList"
              }, {
                PlaceObj("XTemplateForEach", {
                  "comment",
                  "attachment",
                  "__context",
                  function(parent, context, item, i, n)
                    return item
                  end,
                  "run_after",
                  function(child, context, item, i, n, last)
                    child:SetText(item.name)
                  end
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XTextButton",
                    "Margins",
                    box(0, 0, 16, 0),
                    "Background",
                    RGBA(255, 255, 255, 0),
                    "MouseCursor",
                    "UI/Cursors/Pda_Hand.tga",
                    "OnPress",
                    function(self, gamepad)
                      local dlg = GetDialog(self)
                      dlg:OpenEmailAttachment(self:GetContext())
                    end,
                    "RolloverBackground",
                    RGBA(255, 255, 255, 0),
                    "PressedBackground",
                    RGBA(255, 255, 255, 0),
                    "TextStyle",
                    "PDAQuests_EmailTextDark",
                    "Translate",
                    true
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Margins",
                box(16, 0, 0, 0),
                "Dock",
                "right",
                "Image",
                "UI/PDA/Quest/flavor_icon_08"
              })
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "selected email header",
        "__class",
        "XContextWindow",
        "Id",
        "idEmailHeader",
        "Dock",
        "bottom",
        "MinHeight",
        68,
        "MaxHeight",
        68,
        "LayoutMethod",
        "VList",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local dlg = GetDialog(self)
        end
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "Image",
          "UI/PDA/separate_line_vertical",
          "FrameBox",
          box(3, 3, 3, 3),
          "SqueezeY",
          false
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 4, 0, 0),
          "LayoutMethod",
          "HList"
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "from,subject labels",
            "Margins",
            box(16, 0, 16, 0),
            "Dock",
            "left",
            "HAlign",
            "right",
            "VAlign",
            "center",
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "HAlign",
              "right",
              "TextStyle",
              "PDAQuests_EmailTextDark",
              "Translate",
              true,
              "Text",
              T(264964970444, "From:")
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "HAlign",
              "right",
              "TextStyle",
              "PDAQuests_EmailTextDark",
              "Translate",
              true,
              "Text",
              T(491148606397, "Subject:")
            })
          }),
          PlaceObj("XTemplateWindow", {
            "Dock",
            "left",
            "HAlign",
            "right",
            "VAlign",
            "center",
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "from",
              "__class",
              "XText",
              "HAlign",
              "left",
              "TextStyle",
              "PDAQuests_EmailText",
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                local dlg = GetDialog(self)
                if dlg.selectedEmail then
                  local preset = Emails[dlg.selectedEmail.id]
                  local text = preset.sender
                  self:SetText(text)
                end
                return XContextControl.OnContextUpdate(self, context)
              end,
              "Translate",
              true
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "subject",
              "__class",
              "XText",
              "HAlign",
              "left",
              "TextStyle",
              "PDAQuests_EmailText",
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                local dlg = GetDialog(self)
                local email = dlg.selectedEmail
                if email then
                  local preset = Emails[email.id]
                  self:SetText(T({
                    preset.title,
                    email.context
                  }))
                end
                return XContextControl.OnContextUpdate(self, context)
              end,
              "Translate",
              true
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "date,to labels",
            "ZOrder",
            10,
            "Dock",
            "right",
            "VAlign",
            "center",
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "HAlign",
              "right",
              "TextStyle",
              "PDAQuests_EmailTextDark",
              "Translate",
              true,
              "Text",
              T(285840265522, "Date:")
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "HAlign",
              "right",
              "TextStyle",
              "PDAQuests_EmailTextDark",
              "Translate",
              true,
              "Text",
              T(576674254373, "To:")
            })
          }),
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(16, 0, 24, 0),
            "Dock",
            "right",
            "VAlign",
            "center",
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "date",
              "__class",
              "XText",
              "HAlign",
              "left",
              "MinWidth",
              200,
              "TextStyle",
              "PDAQuests_EmailText",
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                local dlg = GetDialog(self)
                if dlg.selectedEmail then
                  local text = TFormat.EmailDate(dlg.selectedEmail)
                  self:SetText(text)
                end
                return XContextControl.OnContextUpdate(self, context)
              end,
              "Translate",
              true
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "to",
              "__class",
              "XText",
              "HAlign",
              "left",
              "MinWidth",
              200,
              "TextStyle",
              "PDAQuests_EmailText",
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                local dlg = GetDialog(self)
                if dlg.selectedEmail then
                  self:SetText(T(411053837845, "<the_boss@aim.com>"))
                else
                  self:SetText(T({""}))
                end
                return XContextControl.OnContextUpdate(self, context)
              end,
              "Translate",
              true
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "emails and scrollbar",
        "Dock",
        "top",
        "LayoutMethod",
        "HList"
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "email list",
          "MinWidth",
          952,
          "MaxWidth",
          952,
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "column names",
            "Dock",
            "top",
            "LayoutMethod",
            "HList",
            "Background",
            RGBA(88, 92, 68, 128)
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Margins",
              box(2, 0, 0, 0),
              "MinWidth",
              36,
              "MinHeight",
              36,
              "MaxWidth",
              36,
              "MaxHeight",
              36,
              "Image",
              "UI/PDA/Quest/e_trash"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "MinWidth",
              36,
              "MinHeight",
              36,
              "MaxWidth",
              36,
              "MaxHeight",
              36,
              "Image",
              "UI/PDA/Quest/e_attach"
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "from",
              "__class",
              "XText",
              "MinWidth",
              192,
              "TextStyle",
              "PDAQuests_SectionHeader",
              "Translate",
              true,
              "Text",
              T(412498186903, "FROM"),
              "TextVAlign",
              "center"
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "subject",
              "__class",
              "XText",
              "MinWidth",
              548,
              "TextStyle",
              "PDAQuests_SectionHeader",
              "Translate",
              true,
              "Text",
              T(188610492369, "SUBJECT"),
              "TextVAlign",
              "center"
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "date",
              "__class",
              "XText",
              "TextStyle",
              "PDAQuests_SectionHeader",
              "Translate",
              true,
              "Text",
              T(594926293991, "DATE"),
              "TextVAlign",
              "center"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XFrame",
            "Dock",
            "top",
            "Image",
            "UI/PDA/separate_line_vertical",
            "FrameBox",
            box(3, 3, 3, 3),
            "SqueezeY",
            false
          }),
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return GetReceivedEmails()
            end,
            "__class",
            "SnappingScrollArea",
            "Id",
            "idEmailRows",
            "IdNode",
            false,
            "Dock",
            "top",
            "MaxHeight",
            294,
            "VScroll",
            "idEmailsScroll",
            "OnContextUpdate",
            function(self, context, ...)
              if self.RespawnOnContext and self.window_state == "open" then
                self:RespawnContent()
              end
              XContextWindow.OnContextUpdate(self, context, ...)
            end
          }, {
            PlaceObj("XTemplateForEach", {
              "comment",
              "email",
              "condition",
              function(parent, context, item, i)
                return Emails[item.id]
              end,
              "__context",
              function(parent, context, item, i, n)
                return item
              end
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "PDAQuestsEmailRow"
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "MessengerScrollbar",
          "Id",
          "idEmailsScroll",
          "Margins",
          box(8, 0, 0, 0),
          "Dock",
          "right",
          "Target",
          "idEmailRows",
          "AutoHide",
          true
        })
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "EmailBodyScrollDown",
      "ActionGamepad",
      "RightThumbDown",
      "OnAction",
      function(self, host, source, ...)
        local body = self.host:ResolveId("idEmailBody")
        if body then
          body:ScrollDown()
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "EmailBodyScrollUp",
      "ActionGamepad",
      "RightThumbUp",
      "OnAction",
      function(self, host, source, ...)
        local body = self.host:ResolveId("idEmailBody")
        if body then
          body:ScrollUp()
        end
      end
    })
  })
})
