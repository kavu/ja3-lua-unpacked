PlaceObj("XTemplate", {
  group = "Zulu",
  id = "BugReportZulu",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XBugReportDlg",
    "HAlign",
    "center",
    "VAlign",
    "center",
    "MinWidth",
    768,
    "MaxWidth",
    768,
    "DrawOnTop",
    true,
    "Background",
    RGBA(240, 240, 240, 0),
    "HideInScreenshots",
    true,
    "FocusSummaryOnOpen",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "HandleMouse",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "IdNode",
        false,
        "Dock",
        "top",
        "MinWidth",
        768,
        "MinHeight",
        32,
        "MaxWidth",
        768,
        "MaxHeight",
        32,
        "RelativeFocusOrder",
        "skip",
        "Image",
        "UI/PDA/os_header",
        "FrameBox",
        box(2, 2, 37, 37),
        "SqueezeX",
        false,
        "SqueezeY",
        false
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "Margins",
          box(10, 0, 0, 0),
          "TextStyle",
          "BugReporterTitle",
          "Translate",
          true,
          "TextVAlign",
          "center"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "Image",
        "UI/PDA/os_background",
        "FrameBox",
        box(2, 2, 56, 56)
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "Content container",
        "Margins",
        box(50, 25, 50, 25),
        "Dock",
        "box",
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "keep this id \"idScrollArea\"",
          "Id",
          "idScrollArea",
          "IdNode",
          true,
          "LayoutMethod",
          "VList",
          "LayoutVSpacing",
          20
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "summary",
            "VAlign",
            "center",
            "MinWidth",
            678,
            "MinHeight",
            38,
            "MaxWidth",
            678,
            "MaxHeight",
            38,
            "OnLayoutComplete",
            function(self)
            end,
            "FoldWhenHidden",
            true,
            "BorderColor",
            RGBA(32, 35, 47, 255),
            "Background",
            RGBA(32, 35, 47, 255)
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "Open",
              "func",
              function(self, ...)
                XWindow.Open(self, ...)
                local edit_control = XTemplateSpawn("EditControl", self)
                edit_control:SetId("idSummaryEdit")
                edit_control:SetUnfocusedText(T(216218894313, "SUBJECT"))
                edit_control:SetFocusedBlinkingText("")
                edit_control:SetTextStyle("BugReporterSummaryDefault")
                edit_control:SetMaxLen(124)
                edit_control:SetRelativeFocusOrder("next-in-line")
                edit_control:Open()
                local text_fld = edit_control.idEdit
                local oldOnTextChanged = text_fld.OnTextChanged
                function text_fld.OnTextChanged(this)
                  this:SetTextStyle("BugReporterSummary")
                  return oldOnTextChanged(this)
                end
                rawset(self:ResolveId("node"), "idSummary", edit_control.idEdit)
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "description",
            "__class",
            "XScrollArea",
            "Id",
            "idDescription",
            "MinWidth",
            678,
            "MinHeight",
            106,
            "MaxWidth",
            768,
            "MaxHeight",
            106,
            "GridY",
            4,
            "FoldWhenHidden",
            true,
            "Background",
            RGBA(0, 0, 0, 255),
            "FocusedBackground",
            RGBA(0, 0, 0, 255),
            "DisabledBackground",
            RGBA(0, 0, 0, 255),
            "VScroll",
            "idScroll"
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "Open",
              "func",
              function(self, ...)
                XWindow.Open(self, ...)
                local edit_control = XTemplateSpawn("EditControl", self)
                edit_control:SetId("idDescriptionEdit")
                edit_control:SetUnfocusedText(T(788597253638, "Bug description..."))
                edit_control:SetFocusedBlinkingText("")
                edit_control:SetTextStyle("BugReporterDescriptionDefault")
                edit_control:SetMultiline(true)
                edit_control:SetMaxLen(1024)
                edit_control:SetRelativeFocusOrder("next-in-line")
                edit_control:Open()
                local text_fld = edit_control.idEdit
                local oldOnTextChanged = text_fld.OnTextChanged
                function text_fld.OnTextChanged(this)
                  this:SetTextStyle("BugReporterDescription")
                  return oldOnTextChanged(this)
                end
                text_fld:SetMinVisibleLines(4)
                text_fld:SetMaxVisibleLines(4)
                text_fld:SetAllowTabs(false)
                text_fld:SetHintVAlign("top")
                text_fld:SetVScroll("idScroll")
                rawset(self:ResolveId("node"), "idDescription", text_fld)
                local scroll = XTemplateSpawn("XZuluScroll", edit_control)
                scroll:SetAutoHide(true)
                scroll:SetId("idScroll")
                scroll:SetDock("right")
                scroll:SetTarget("idEdit")
                scroll:SetMargins(box(20, 0, 0, 0))
                scroll:SetSnapToItems(true)
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "savegame",
            "FoldWhenHidden",
            true
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XCheckButton",
              "Id",
              "idSaveGame",
              "Dock",
              "left",
              "FoldWhenHidden",
              true,
              "Icon",
              "UI/Hud/checkmark_vertical",
              "IconScale",
              point(1000, 1000),
              "IconColor",
              RGBA(255, 255, 255, 255),
              "TextStyle",
              "BugReporterAttachSave",
              "Translate",
              true
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Id",
            "idScreenshot",
            "IdNode",
            false,
            "BorderWidth",
            2,
            "MinWidth",
            678,
            "MaxWidth",
            678,
            "LayoutMethod",
            "VList",
            "FoldWhenHidden",
            true,
            "BorderColor",
            RGBA(48, 57, 60, 255),
            "HandleMouse",
            true,
            "ImageFit",
            "width"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XLabel",
              "Id",
              "idScreenshotText",
              "Margins",
              box(0, 0, 0, -30),
              "Dock",
              "bottom",
              "HAlign",
              "center",
              "FoldWhenHidden",
              true,
              "TextStyle",
              "BugReporterScreenshot",
              "Translate",
              true,
              "Text",
              T(473218230166, "Click to draw, right-click to clear.")
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "send",
            "__class",
            "XList",
            "Margins",
            box(0, 20, 0, 0),
            "HAlign",
            "right",
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            50,
            "FoldWhenHidden",
            true,
            "BorderColor",
            RGBA(0, 0, 0, 0),
            "Background",
            RGBA(0, 0, 0, 0),
            "FocusedBorderColor",
            RGBA(0, 0, 0, 0),
            "FocusedBackground",
            RGBA(255, 255, 255, 0),
            "DisabledBorderColor",
            RGBA(0, 0, 0, 0)
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XFrame",
              "BorderColor",
              RGBA(0, 0, 0, 0),
              "Background",
              RGBA(255, 255, 255, 0),
              "FocusedBorderColor",
              RGBA(0, 0, 0, 0),
              "FocusedBackground",
              RGBA(255, 255, 255, 0),
              "DisabledBorderColor",
              RGBA(0, 0, 0, 0)
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XTextButton",
                "Id",
                "idOK",
                "Padding",
                box(8, 5, 8, 5),
                "MinWidth",
                124,
                "MinHeight",
                26,
                "MaxHeight",
                26,
                "LayoutHSpacing",
                15,
                "FoldWhenHidden",
                true,
                "FXMouseIn",
                "ButtonHoverBasic",
                "FXPress",
                "ButtonClickBasic",
                "DisabledBackground",
                RGBA(255, 255, 255, 255),
                "RolloverBorderColor",
                RGBA(255, 255, 255, 255),
                "PressedBorderColor",
                RGBA(255, 255, 255, 255),
                "Image",
                "UI/PDA/os_system_buttons",
                "FrameBox",
                box(10, 10, 10, 10),
                "ColumnsUse",
                "abcca",
                "ShowGamepadShortcut",
                true
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idShortcut",
                  "FoldWhenHidden",
                  true,
                  "Background",
                  RGBA(0, 0, 0, 255),
                  "FocusedBackground",
                  RGBA(0, 0, 0, 255),
                  "DisabledBorderColor",
                  RGBA(134, 134, 134, 255),
                  "DisabledBackground",
                  RGBA(134, 134, 134, 255),
                  "TextStyle",
                  "PDAShortcutText",
                  "Translate",
                  true,
                  "Text",
                  T(737086872205, "Ent"),
                  "TextHAlign",
                  "center",
                  "TextVAlign",
                  "center"
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idText",
                  "FoldWhenHidden",
                  true,
                  "TextStyle",
                  "PDACommonButtonWithRollover",
                  "Translate",
                  true,
                  "Text",
                  T(377270367615, "Send"),
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
              "BorderColor",
              RGBA(0, 0, 0, 0),
              "Background",
              RGBA(255, 255, 255, 0),
              "FocusedBorderColor",
              RGBA(0, 0, 0, 0),
              "FocusedBackground",
              RGBA(255, 255, 255, 0),
              "DisabledBorderColor",
              RGBA(0, 0, 0, 0)
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XTextButton",
                "Id",
                "idCancel",
                "Padding",
                box(8, 5, 8, 5),
                "MinWidth",
                124,
                "MinHeight",
                26,
                "MaxHeight",
                26,
                "LayoutHSpacing",
                15,
                "FoldWhenHidden",
                true,
                "FXMouseIn",
                "ButtonHoverBasic",
                "FXPress",
                "ButtonClickBasic",
                "OnPressEffect",
                "close",
                "Image",
                "UI/PDA/os_system_buttons",
                "FrameBox",
                box(10, 10, 10, 10),
                "ColumnsUse",
                "abcca",
                "ShowGamepadShortcut",
                true
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idShortcut",
                  "FoldWhenHidden",
                  true,
                  "Background",
                  RGBA(0, 0, 0, 255),
                  "FocusedBackground",
                  RGBA(0, 0, 0, 255),
                  "DisabledBorderColor",
                  RGBA(134, 134, 134, 255),
                  "DisabledBackground",
                  RGBA(134, 134, 134, 255),
                  "TextStyle",
                  "PDAShortcutText",
                  "Translate",
                  true,
                  "Text",
                  T(971728004927, "ESC"),
                  "TextHAlign",
                  "center",
                  "TextVAlign",
                  "center"
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idText",
                  "FoldWhenHidden",
                  true,
                  "TextStyle",
                  "PDACommonButtonWithRollover",
                  "Translate",
                  true,
                  "Text",
                  T(745484059274, "Close"),
                  "TextHAlign",
                  "center",
                  "TextVAlign",
                  "center"
                })
              })
            })
          })
        })
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "Open",
        "func",
        function(self, ...)
          XWindow.Open(self)
          local bugReportShortcut = GetShortcuts("idBugReport")
          local titleT = T(552289777086, "BUG REPORT")
          if bugReportShortcut then
            titleT = titleT .. " - " .. Untranslated(bugReportShortcut[1])
          end
          local titleField = self:ResolveId("idTitle")
          if titleField then
            titleField:SetText(titleT)
          end
        end
      })
    })
  })
})
