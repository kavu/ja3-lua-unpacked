PlaceObj("XTemplate", {
  group = "Common",
  id = "BugReport",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XBugReportDlg",
    "Margins",
    box(0, 20, 0, 20),
    "BorderWidth",
    2,
    "HAlign",
    "center",
    "VAlign",
    "center",
    "MaxWidth",
    950,
    "MaxHeight",
    1100,
    "DrawOnTop",
    true,
    "BorderColor",
    RGBA(128, 131, 136, 255),
    "HideInScreenshots",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XMoveControl",
      "Dock",
      "top",
      "Background",
      RGBA(160, 160, 160, 255),
      "FocusedBackground",
      RGBA(160, 160, 160, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XLabel",
        "Margins",
        box(4, 2, 4, 2),
        "Dock",
        "left",
        "TextStyle",
        "GedTitle",
        "Text",
        "Bug Report"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XTextButton",
        "Padding",
        box(1, 1, 1, 1),
        "Dock",
        "right",
        "VAlign",
        "center",
        "LayoutHSpacing",
        0,
        "Background",
        RGBA(0, 0, 0, 0),
        "OnPressEffect",
        "close",
        "RolloverBackground",
        RGBA(204, 232, 255, 255),
        "PressedBackground",
        RGBA(121, 189, 241, 255),
        "TextStyle",
        "GedTitle",
        "Text",
        "X"
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "Content container",
      "Padding",
      box(15, 7, 15, 7),
      "Dock",
      "box",
      "LayoutMethod",
      "VList",
      "Background",
      RGBA(255, 255, 255, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XScrollArea",
        "Id",
        "idScrollArea",
        "Margins",
        box(0, 5, 0, 0),
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        15,
        "VScroll",
        "idScroll"
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "Combo container",
          "__context",
          function(parent, context)
            return "appendToExistingBug"
          end,
          "__class",
          "XContextWindow",
          "Id",
          "idComboContainer",
          "LayoutMethod",
          "HWrap",
          "LayoutHSpacing",
          20,
          "LayoutVSpacing",
          10,
          "OnContextUpdate",
          function(self, context, ...)
            local node = self:ResolveId("node")
            if node and node.idAppendToExistingBug and (node.idAppendToExistingBug:GetText() or "") ~= "" then
              if node.idAssignTo then
                node.idAssignTo:SetEnabled(false)
              end
              if node.idPriority then
                node.idPriority:SetEnabled(false)
              end
              if node.idCategory then
                node.idCategory:SetEnabled(false)
              end
              if node.idTargetVersion then
                node.idTargetVersion:SetEnabled(false)
              end
            else
              if node.idAssignTo then
                node.idAssignTo:SetEnabled(true)
              end
              if node.idPriority then
                node.idPriority:SetEnabled(true)
              end
              if node.idCategory then
                node.idCategory:SetEnabled(true)
              end
              if node.idTargetVersion then
                node.idTargetVersion:SetEnabled(true)
              end
            end
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "Reporter",
            "RolloverText",
            T(714018055914, "Rollover"),
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            33,
            "FoldWhenHidden",
            true
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XLabel",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "FocusedBackground",
              RGBA(255, 255, 255, 255),
              "Text",
              "Reporter:"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XCombo",
              "Id",
              "idReporter",
              "MinWidth",
              170,
              "MaxWidth",
              170,
              "RelativeFocusOrder",
              "next-in-line",
              "OnContextUpdate",
              function(self, context, ...)
                local node = self:ResolveId("node")
                if node and node.idReporter and node.idAppendToExistingBug then
                  local reporter = node.idReporter:GetValue()
                  if (reporter or "") == "" or reporter == " " then
                    node.idAppendToExistingBug:SetEnabled(false)
                  else
                    node.idAppendToExistingBug:SetEnabled(true)
                  end
                end
              end,
              "OnValueChanged",
              function(self, value)
                self:OnContextUpdate(self, self.context)
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "Assign to",
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            10
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XLabel",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "FocusedBackground",
              RGBA(255, 255, 255, 255),
              "Text",
              "Assign to:"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XCombo",
              "Id",
              "idAssignTo",
              "MinWidth",
              170,
              "MaxWidth",
              170,
              "RelativeFocusOrder",
              "next-in-line",
              "MRUStorageId",
              "BugReporterAssignTo"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "Severity",
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            37
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XLabel",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "FocusedBackground",
              RGBA(255, 255, 255, 255),
              "Text",
              "Severity:"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XCombo",
              "Id",
              "idSeverity",
              "MinWidth",
              140,
              "MaxWidth",
              140,
              "RelativeFocusOrder",
              "next-in-line"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "Priority",
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            10
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XLabel",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "FocusedBackground",
              RGBA(255, 255, 255, 255),
              "Text",
              "Priority:"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XCombo",
              "Id",
              "idPriority",
              "MinWidth",
              140,
              "MaxWidth",
              140,
              "RelativeFocusOrder",
              "next-in-line"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "Category",
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            33
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XLabel",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "FocusedBackground",
              RGBA(255, 255, 255, 255),
              "Text",
              "Category:"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XCombo",
              "Id",
              "idCategory",
              "MinWidth",
              130,
              "MaxWidth",
              130,
              "RelativeFocusOrder",
              "next-in-line"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "Target version",
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            10
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XLabel",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "FocusedBackground",
              RGBA(255, 255, 255, 255),
              "Text",
              "Target version:"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XCombo",
              "Id",
              "idTargetVersion",
              "MinWidth",
              200,
              "MaxWidth",
              200,
              "RelativeFocusOrder",
              "next-in-line"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "Reproducibility",
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            10
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XLabel",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "FocusedBackground",
              RGBA(255, 255, 255, 255),
              "Text",
              "Reproducibility:"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XCombo",
              "Id",
              "idReproducibility",
              "MinWidth",
              170,
              "MaxWidth",
              170,
              "RelativeFocusOrder",
              "next-in-line"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "append to existing bug",
            "Id",
            "idAppendToExistingBugContainer"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XLabel",
              "Dock",
              "left",
              "VAlign",
              "center",
              "MinWidth",
              100,
              "FocusedBackground",
              RGBA(255, 255, 255, 255),
              "Text",
              "Append to existing issue:"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XEdit",
              "Id",
              "idAppendToExistingBug",
              "Margins",
              box(5, 0, 0, 0),
              "HAlign",
              "left",
              "MinWidth",
              110,
              "MaxWidth",
              110,
              "RelativeFocusOrder",
              "next-in-line",
              "DisabledBorderColor",
              RGBA(0, 0, 0, 255),
              "DisabledBackground",
              RGBA(124, 124, 124, 255),
              "OnTextChanged",
              function(self)
                ObjModified("appendToExistingBug")
              end,
              "Hint",
              "mantis id or link"
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "Tags container",
          "__context",
          function(parent, context)
            return "appendToExistingBug"
          end,
          "__class",
          "XContentTemplate",
          "Id",
          "idTagsContainer",
          "IdNode",
          false,
          "LayoutMethod",
          "VList",
          "LayoutVSpacing",
          20
        }, {
          PlaceObj("XTemplateWindow", {
            "Id",
            "idGameTags",
            "LayoutMethod",
            "HList"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XLabel",
              "Dock",
              "left",
              "HAlign",
              "center",
              "VAlign",
              "top",
              "MinWidth",
              100,
              "FocusedBackground",
              RGBA(255, 255, 255, 255),
              "Text",
              "Tags:"
            }),
            PlaceObj("XTemplateWindow", {
              "LayoutMethod",
              "HWrap",
              "LayoutHSpacing",
              8,
              "LayoutVSpacing",
              5
            }, {
              PlaceObj("XTemplateForEach", {
                "array",
                function(parent, context)
                  return Platform.ged and g_GedApp.bug_report_tags or PresetArray("BugReportTag", function(tag)
                    return not tag.Automatic and not tag.Platform and (insideHG() or tag.ShowInExternal)
                  end)
                end,
                "run_after",
                function(child, context, item, i, n, last)
                  child:SetId("id" .. item.id)
                  child:SetText(item.id)
                  local node = child:ResolveId("node")
                  if node and node.idAppendToExistingBug and (node.idAppendToExistingBug:GetText() or "") ~= "" then
                    child:SetEnabled(false)
                  end
                end
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XToggleButton",
                  "BorderWidth",
                  1,
                  "BorderColor",
                  RGBA(128, 128, 128, 255),
                  "Background",
                  RGBA(0, 0, 0, 0),
                  "FocusedBackground",
                  RGBA(41, 160, 244, 255),
                  "DisabledBackground",
                  RGBA(124, 124, 124, 255),
                  "RolloverBackground",
                  RGBA(41, 160, 244, 255),
                  "RolloverBorderColor",
                  RGBA(128, 128, 128, 255),
                  "PressedBackground",
                  RGBA(41, 160, 244, 255),
                  "PressedBorderColor",
                  RGBA(128, 128, 128, 255),
                  "ToggledBackground",
                  RGBA(41, 160, 244, 255),
                  "ToggledBorderColor",
                  RGBA(128, 128, 128, 255)
                })
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__condition",
            function(parent, context)
              return not Platform.ged
            end,
            "Id",
            "idPlatformTags",
            "LayoutMethod",
            "HList"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XLabel",
              "Id",
              "idPlatformTagsLabel",
              "Dock",
              "left",
              "HAlign",
              "center",
              "VAlign",
              "top",
              "MinWidth",
              100,
              "FocusedBackground",
              RGBA(255, 255, 255, 255),
              "Text",
              "Platforms:"
            }),
            PlaceObj("XTemplateWindow", {
              "HAlign",
              "center",
              "LayoutMethod",
              "HWrap",
              "LayoutHSpacing",
              8,
              "LayoutVSpacing",
              5
            }, {
              PlaceObj("XTemplateForEach", {
                "array",
                function(parent, context)
                  return Platform.ged and g_GedApp.bug_report_tags or PresetArray("BugReportTag", function(tag)
                    return not tag.Automatic and tag.Platform and (insideHG() or tag.ShowInExternal)
                  end)
                end,
                "run_after",
                function(child, context, item, i, n, last)
                  local id = item.id
                  child:SetId("id" .. id)
                  child:SetText(id)
                  child:SetToggled(id ~= "Windows" and Platform[BugReportPlatformTagsToName[id]])
                  local node = child:ResolveId("node")
                  if node and node.idAppendToExistingBug and (node.idAppendToExistingBug:GetText() or "") ~= "" then
                    child:SetEnabled(false)
                  end
                end
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XToggleButton",
                  "BorderWidth",
                  1,
                  "BorderColor",
                  RGBA(128, 128, 128, 255),
                  "Background",
                  RGBA(0, 0, 0, 0),
                  "FocusedBackground",
                  RGBA(41, 160, 244, 255),
                  "DisabledBackground",
                  RGBA(124, 124, 124, 255),
                  "RolloverBackground",
                  RGBA(41, 160, 244, 255),
                  "RolloverBorderColor",
                  RGBA(128, 128, 128, 255),
                  "PressedBackground",
                  RGBA(41, 160, 244, 255),
                  "PressedBorderColor",
                  RGBA(128, 128, 128, 255),
                  "ToggledBackground",
                  RGBA(41, 160, 244, 255),
                  "ToggledBorderColor",
                  RGBA(128, 128, 128, 255)
                })
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {"comment", "summary"}, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XLabel",
            "Dock",
            "left",
            "VAlign",
            "center",
            "MinWidth",
            100,
            "FocusedBackground",
            RGBA(255, 255, 255, 255),
            "Text",
            "Summary:"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XEdit",
            "Id",
            "idSummary",
            "RelativeFocusOrder",
            "next-in-line",
            "MaxLen",
            124,
            "Plugins",
            {
              "XSpellcheckPlugin"
            }
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "description"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XLabel",
            "Dock",
            "left",
            "VAlign",
            "top",
            "MinWidth",
            100,
            "FocusedBackground",
            RGBA(255, 255, 255, 255),
            "Text",
            "Description:"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XMultiLineEdit",
            "Id",
            "idDescription",
            "RelativeFocusOrder",
            "next-in-line",
            "AllowTabs",
            false,
            "MinVisibleLines",
            5,
            "Plugins",
            {
              "XSpellcheckPlugin"
            }
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "API Token",
          "FoldWhenHidden",
          true
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XLabel",
            "Dock",
            "left",
            "VAlign",
            "center",
            "MinWidth",
            100,
            "FocusedBackground",
            RGBA(255, 255, 255, 255),
            "Text",
            "API Token:"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XEdit",
            "Id",
            "idAPIToken",
            "RelativeFocusOrder",
            "next-in-line"
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "savegame/send",
          "Margins",
          box(0, 5, 0, 7)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XCheckButton",
            "Id",
            "idScreenshotCheck",
            "Margins",
            box(5, 0, 5, 0),
            "Dock",
            "left",
            "OnPress",
            function(self, gamepad)
              XCheckButton.OnPress(self)
              self:ResolveId("idScreenshot"):SetVisible(self:GetCheck())
            end,
            "Text",
            "Screenshot",
            "Check",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XCheckButton",
            "Id",
            "idExtraInfo",
            "Margins",
            box(5, 0, 5, 0),
            "Dock",
            "left",
            "OnPress",
            function(self, gamepad)
              XCheckButton.OnPress(self)
              local is_checked = self:GetCheck()
              self:ResolveId("idSaveGame"):SetVisible(is_checked)
              self:ResolveId("idLastAutosave"):SetVisible(is_checked)
            end,
            "Text",
            "Extra Info",
            "Check",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XCheckButton",
            "Id",
            "idSaveGame",
            "Margins",
            box(5, 0, 5, 0),
            "Dock",
            "left",
            "Text",
            "Attach savegame"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XCheckButton",
            "Id",
            "idLastAutosave",
            "Margins",
            box(5, 0, 5, 0),
            "Dock",
            "left",
            "Text",
            "Attach last autosave"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XTextButton",
            "Id",
            "idCancel",
            "Margins",
            box(5, 0, 5, 0),
            "Padding",
            box(2, 2, 2, 2),
            "Dock",
            "right",
            "MinWidth",
            100,
            "LayoutMethod",
            "VList",
            "Background",
            RGBA(38, 146, 227, 255),
            "FocusedBackground",
            RGBA(24, 123, 197, 255),
            "DisabledBackground",
            RGBA(128, 128, 128, 255),
            "OnPressEffect",
            "close",
            "RolloverBackground",
            RGBA(24, 123, 197, 255),
            "PressedBackground",
            RGBA(13, 113, 187, 255),
            "Image",
            "CommonAssets/UI/round-frame-20.tga",
            "ImageScale",
            point(500, 500),
            "FrameBox",
            box(9, 9, 9, 9),
            "TextStyle",
            "GedButton",
            "Text",
            "Cancel"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XTextButton",
            "Id",
            "idOK",
            "Margins",
            box(5, 0, 5, 0),
            "Padding",
            box(2, 2, 2, 2),
            "Dock",
            "right",
            "MinWidth",
            100,
            "LayoutMethod",
            "VList",
            "Background",
            RGBA(38, 146, 227, 255),
            "FocusedBackground",
            RGBA(24, 123, 197, 255),
            "DisabledBackground",
            RGBA(128, 128, 128, 255),
            "RolloverBackground",
            RGBA(24, 123, 197, 255),
            "PressedBackground",
            RGBA(13, 113, 187, 255),
            "Image",
            "CommonAssets/UI/round-frame-20.tga",
            "ImageScale",
            point(500, 500),
            "FrameBox",
            box(9, 9, 9, 9),
            "TextStyle",
            "GedButton",
            "Text",
            "OK"
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
          1,
          "MinWidth",
          200,
          "MinHeight",
          200,
          "FoldWhenHidden",
          true,
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
            "Dock",
            "bottom",
            "HAlign",
            "center",
            "TextStyle",
            "BugReportScreenshot",
            "Text",
            "Click to draw, right-click to clear."
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XSleekScroll",
      "Id",
      "idScroll",
      "HAlign",
      "right",
      "Target",
      "idScrollArea",
      "SnapToItems",
      true,
      "AutoHide",
      true
    })
  })
})
