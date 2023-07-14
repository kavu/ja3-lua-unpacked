PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAImpLogIn",
  PlaceObj("XTemplateProperty", {
    "id",
    "HeaderButtonId",
    "editor",
    "text",
    "translate",
    false,
    "Set",
    function(self, value)
      self.HeaderButtonId = value
    end,
    "Get",
    function(self)
      return self.HeaderButtonId
    end,
    "name",
    T(216982902846, "HeaderButtonId")
  }),
  PlaceObj("XTemplateWindow", {
    "LayoutMethod",
    "VList",
    "LayoutVSpacing",
    8
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XWindow.Open(self, ...)
        PDAImpHeaderEnable(self)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete",
      "func",
      function(self, ...)
        XWindow.OnDelete(self, ...)
        PDAImpHeaderDisable(self)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextFrame",
      "Id",
      "idLogInInfo",
      "MouseCursor",
      "UI/Cursors/Pda_Hand.tga",
      "Image",
      "UI/PDA/imp_panel",
      "FrameBox",
      box(8, 8, 8, 8),
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local dlg = GetDialog(self)
        dlg.clicked_links = dlg.clicked_links or {}
        local hyperlink = Untranslated("<h ResetPswd 0 IMP>")
        if dlg.clicked_links.pswd then
          self.idText:SetText(T({
            298769192636,
            "Forgot your <style PDAIMPHyperLinkClickedSmall><hl><underline>password?</underline></h></style>",
            hl = hyperlink
          }))
        else
          self.idText:SetText(T({
            123042917573,
            "Forgot your <style PDAIMPHyperLinkSmall><hl><underline>password?</underline></h></style>",
            hl = hyperlink
          }))
        end
        if not GetUIStyleGamepad() then
          self.idEditPswd:SetFocus()
        end
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(22, 20, 22, 8),
        "VAlign",
        "center",
        "MinWidth",
        678,
        "MaxWidth",
        678,
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "Padding",
          box(0, 0, 0, 0),
          "HAlign",
          "center",
          "VAlign",
          "top",
          "HandleMouse",
          false,
          "TextStyle",
          "PDAIMPContentTitle",
          "Translate",
          true,
          "Text",
          T(530712122173, "Log In")
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idError",
          "IdNode",
          false,
          "Margins",
          box(0, 16, 0, 0),
          "Padding",
          box(0, 0, 0, 0),
          "HAlign",
          "center",
          "VAlign",
          "top",
          "Visible",
          false,
          "FoldWhenHidden",
          true,
          "HandleMouse",
          false,
          "TextStyle",
          "PDAIMPContentText",
          "Translate",
          true,
          "Text",
          T(835243801015, "<GameColorI>Wrong password! Try again.</GameColorI>")
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Margins",
          box(0, 16, 0, 0),
          "Padding",
          box(0, 0, 0, 0),
          "HAlign",
          "center",
          "VAlign",
          "top",
          "HandleMouse",
          false,
          "TextStyle",
          "PDAIMPContentText",
          "Translate",
          true,
          "Text",
          T(330439391851, "Enter your personal authorization code")
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "IdNode",
          false,
          "Margins",
          box(0, 16, 0, 0),
          "HAlign",
          "center",
          "VAlign",
          "center",
          "MinWidth",
          324,
          "MinHeight",
          40,
          "MaxWidth",
          324,
          "Image",
          "UI/PDA/imp_bar",
          "FrameBox",
          box(5, 5, 5, 5)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idEditID",
            "Margins",
            box(10, 0, 10, 0),
            "HAlign",
            "center",
            "VAlign",
            "center",
            "MinWidth",
            324,
            "MaxWidth",
            324,
            "Enabled",
            false,
            "TextStyle",
            "PDAIMPEdit",
            "Text",
            "Private ID"
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "IdNode",
          false,
          "Margins",
          box(0, 4, 0, 0),
          "HAlign",
          "center",
          "VAlign",
          "center",
          "MinWidth",
          324,
          "MinHeight",
          40,
          "MaxWidth",
          324,
          "Image",
          "UI/PDA/imp_bar",
          "FrameBox",
          box(5, 5, 5, 5)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XEdit",
            "Id",
            "idEditPswd",
            "Margins",
            box(10, 0, 10, 0),
            "BorderWidth",
            0,
            "HAlign",
            "center",
            "VAlign",
            "center",
            "MinWidth",
            324,
            "MaxWidth",
            324,
            "Background",
            RGBA(240, 240, 240, 0),
            "MouseCursor",
            "UI/Cursors/Pda_Hand.tga",
            "FocusedBorderColor",
            RGBA(240, 240, 240, 0),
            "FocusedBackground",
            RGBA(240, 240, 240, 0),
            "DisabledBorderColor",
            RGBA(240, 240, 240, 0),
            "DisabledBackground",
            RGBA(240, 240, 240, 0),
            "TextStyle",
            "PDAIMPEdit",
            "Text",
            "XEP625",
            "Password",
            true,
            "MaxLen",
            10,
            "AutoSelectAll",
            true,
            "Ime",
            false,
            "HintColor",
            RGBA(240, 240, 240, 0)
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "OnTextChanged(self)",
              "func",
              function(self)
                PlayFX("Typing", "start")
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnShortcut(self, shortcut, source, ...)",
              "func",
              function(self, shortcut, source, ...)
                if GetUIStyleGamepad() then
                  return "break"
                end
                if shortcut == "Escape" then
                else
                  return XEdit.OnShortcut(self, shortcut, source)
                end
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnSetFocus(self, old_focus)",
              "func",
              function(self, old_focus)
                if GetUIStyleGamepad() then
                  self:OpenControllerTextInput()
                  self:SetFocus(false)
                else
                  XEdit.OnSetFocus(self, old_focus)
                end
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnMouseButtonDoubleClick(self, pos, button)",
              "func",
              function(self, pos, button)
                if GetUIStyleGamepad() then
                  return "break"
                end
              end
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idText",
          "Margins",
          box(0, 3, 0, 0),
          "HAlign",
          "center",
          "VAlign",
          "top",
          "MouseCursor",
          "UI/Cursors/Pda_Hand.tga",
          "FXMouseIn",
          "buttonRollover",
          "FXPress",
          "buttonPress",
          "FXPressDisabled",
          "IactDisabled",
          "TextStyle",
          "PDAIMPContentTextSmall",
          "Translate",
          true
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "OnHyperLink(self, hyperlink, argument, hyperlink_box, pos, button)",
            "func",
            function(self, hyperlink, argument, hyperlink_box, pos, button)
              if hyperlink == "ResetPswd" then
                local dlg = GetDialog(self)
                dlg.clicked_links = dlg.clicked_links or {}
                dlg.clicked_links.pswd = true
                ReceiveEmail("IMP2")
                dlg:SetMode("pswd_reset")
              end
            end
          })
        })
      })
    })
  })
})
