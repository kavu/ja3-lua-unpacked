PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu PDA",
  id = "PDABrowser",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDABrowser",
    "Id",
    "idContent",
    "MouseCursor",
    "UI/Cursors/Pda_Cursor.tga",
    "HostInParent",
    true
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        PDABrowser.Open(self, ...)
        self.clicked_links = {}
        ClearVolatileBrowserTabs()
        ObjModified("pda browser tabs")
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete",
      "func",
      function(self, ...)
        ClearVolatileBrowserTabs()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDialogModeChange(self, mode, dialog)",
      "func",
      function(self, mode, dialog)
        PDABrowser.OnDialogModeChange(self, mode, dialog)
        if mode ~= "page_error" then
          UndockBrowserTab("page_error")
        else
          DockBrowserTab("page_error")
        end
        if mode == "banner_page" then
          DockBrowserTab("banner_page")
        end
        ObjModified("pda browser tabs")
      end
    }),
    PlaceObj("XTemplateProperty", {
      "id",
      "LastModeBeforeError",
      "editor",
      "text",
      "translate",
      false,
      "Set",
      function(self, value)
        self.LastModeBeforeError = value
      end,
      "Get",
      function(self)
        return self.LastModeBeforeError
      end
    }),
    PlaceObj("XTemplateProperty", {
      "id",
      "LastModeParamBeforeError",
      "editor",
      "text",
      "translate",
      false,
      "Set",
      function(self, value)
        LastModeParamBeforeError = value
      end,
      "Get",
      function(self)
        return LastModeParamBeforeError
      end
    }),
    PlaceObj("XTemplateWindow", {
      "Margins",
      box(0, -1, 0, 0),
      "Dock",
      "top",
      "LayoutMethod",
      "VList"
    }, {
      PlaceObj("XTemplateWindow", {
        "Id",
        "idUrl",
        "LayoutMethod",
        "VList",
        "FoldWhenHidden",
        true
      }, {
        PlaceObj("XTemplateWindow", nil, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "url bar",
            "__class",
            "XFrame",
            "IdNode",
            false,
            "Dock",
            "box",
            "Image",
            "UI/PDA/browser_pad",
            "FrameBox",
            box(3, 3, 3, 3)
          }),
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(50, 10, 180, 5)
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "HAlign",
              "left",
              "VAlign",
              "center",
              "TextStyle",
              "URLLabel",
              "Translate",
              true,
              "Text",
              T(420589943681, "URL:")
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XButton",
              "IdNode",
              false,
              "Margins",
              box(60, 0, 0, 0),
              "VAlign",
              "center",
              "MouseCursor",
              "UI/Cursors/Pda_Hand.tga",
              "OnPress",
              function(self, gamepad)
                local contextMenu = XTemplateSpawn("PDABrowserDropDown", GetDialog(self), false)
                contextMenu:SetDrawOnTop(true)
                contextMenu:SetAnchor(self.box)
                contextMenu:Open()
                self.desktop:SetModalWindow(contextMenu)
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "url bar",
                "__class",
                "XFrame",
                "IdNode",
                false,
                "Dock",
                "box",
                "Image",
                "UI/PDA/browser_panel",
                "FrameBox",
                box(3, 3, 3, 3)
              }),
              PlaceObj("XTemplateWindow", {
                "__context",
                function(parent, context)
                  return "pda_url"
                end,
                "__class",
                "XText",
                "Margins",
                box(5, 0, 10, 0),
                "TextStyle",
                "URLText",
                "Translate",
                true,
                "Text",
                T(299661233439, "<PDAUrl()>")
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "tab buttons",
          "__context",
          function(parent, context)
            return "pda browser tabs"
          end,
          "__class",
          "XContentTemplate",
          "IdNode",
          false,
          "Margins",
          box(0, -2, 0, 0)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XFrame",
            "Dock",
            "box",
            "Image",
            "UI/PDA/os_header",
            "FrameBox",
            box(2, 2, 2, 2)
          }),
          PlaceObj("XTemplateWindow", {
            "Id",
            "idTabButtons",
            "Margins",
            box(55, 3, 0, 3),
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            15
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "OnDelete",
              "func",
              function(self, ...)
                local pdaBrowser = self:ResolveId("node")
                if not pdaBrowser then
                  return
                end
                local mode = pdaBrowser:GetMode()
                if mode ~= "page_error" then
                  pdaBrowser:SetProperty("LastModeBeforeError", mode)
                  pdaBrowser:SetProperty("LastModeParamBeforeError", GetDialog(pdaBrowser).mode_param)
                end
              end
            }),
            PlaceObj("XTemplateForEach", {
              "array",
              function(parent, context)
                return PDABrowserTabData
              end,
              "condition",
              function(parent, context, item, i)
                return not PDABrowserTabState[item.id] or not PDABrowserTabState[item.id].locked
              end,
              "run_after",
              function(child, context, item, i, n, last)
                local mode_param = GetDialog(child:ResolveId("node")).mode_param
                if item.id == "banner_page" and mode_param and PDABrowserSites[mode_param] then
                  item.DisplayName = PDABrowserSites[mode_param].bookmark
                end
                child:SetText(item.DisplayName)
                rawset(child, "tab_id", item.id)
                local dlg = GetDialog(child)
                child.selected = dlg.Mode == item.id
                function child:OnPress()
                  dlg:SetMode(item.id, PDABrowserTabState.banner_page.mode_param)
                  SetPDAMessangerVisibleIfUp(item.id ~= "imp")
                end
                child.idUnread:SetVisible(not IsPageInBrowserHistory(item.id, mode_param) and item.id ~= "page_error" and item.id ~= "banner_page")
                child:SetId(item.id .. "_button")
              end
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "PDABrowserButton",
                "VAlign",
                "center",
                "FXPress",
                "AIMTabsClick"
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idUnread",
                  "Padding",
                  box(2, 0, 2, 0),
                  "VAlign",
                  "center",
                  "FoldWhenHidden",
                  true,
                  "HandleMouse",
                  false,
                  "TextStyle",
                  "PDASectorInfo_ValueLight",
                  "Text",
                  "<color PDACommonButtonRed>!</color>"
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "gamepad hint",
              "__context",
              function(parent, context)
                return "GamepadUIStyleChanged"
              end,
              "__class",
              "XText",
              "VAlign",
              "center",
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
              T(448834517294, "<LeftTrigger> <RightTrigger> - Change tab")
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "idNextTabRight",
              "ActionGamepad",
              "RightTrigger",
              "OnAction",
              function(self, host, source, ...)
                local dlg = host.idContent
                local tabButtons = dlg.idTabButtons
                if not tabButtons then
                  return
                end
                local currentTabIdx = table.find(tabButtons, "tab_id", dlg:GetMode())
                currentTabIdx = currentTabIdx + 1
                if tabButtons[currentTabIdx] and tabButtons[currentTabIdx].tab_id then
                  tabButtons[currentTabIdx]:OnPress()
                elseif tabButtons[1] and tabButtons[1].tab_id then
                  tabButtons[1]:OnPress()
                end
              end
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "idPrevTabLeft",
              "ActionGamepad",
              "LeftTrigger",
              "OnAction",
              function(self, host, source, ...)
                local dlg = host.idContent
                local tabButtons = dlg.idTabButtons
                if not tabButtons then
                  return
                end
                local currentTabIdx = table.find(tabButtons, "tab_id", dlg:GetMode())
                currentTabIdx = currentTabIdx - 1
                if tabButtons[currentTabIdx] and tabButtons[currentTabIdx].tab_id then
                  tabButtons[currentTabIdx]:OnPress()
                elseif tabButtons[#tabButtons - 1] and tabButtons[#tabButtons - 1].tab_id then
                  tabButtons[#tabButtons - 1]:OnPress()
                end
              end
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContentTemplate",
      "IdNode",
      false,
      "Dock",
      "box"
    }, {
      PlaceObj("XTemplateMode", {"mode", "aim"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "PDAAIMBrowser"
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "evaluation"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "PDAAimEvaluation",
          "Id",
          "idBrowserContent"
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "imp"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "PDAImpDialog",
          "Id",
          "idBrowserContent"
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "landing"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "PDABrowserLanding"
        })
      }),
      PlaceObj("XTemplateMode", {
        "mode",
        "banner_page"
      }, {
        PlaceObj("XTemplateAction", {
          "ActionId",
          "idCloseAction",
          "ActionName",
          T(288117422463, "Close"),
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
          "OnAction",
          function(self, host, source, ...)
            local pda = GetDialog("PDADialog")
            pda:CloseAction(host)
          end,
          "FXMouseIn",
          "buttonRollover",
          "FXPress",
          "buttonPress",
          "FXPressDisabled",
          "IactDisabled"
        }),
        PlaceObj("XTemplateTemplate", {
          "__condition",
          function(parent, context)
            return GetDialog(parent).mode_param == "PDABrowserAskThieves"
          end,
          "__template",
          "PDABrowserAskThieves"
        }),
        PlaceObj("XTemplateTemplate", {
          "__condition",
          function(parent, context)
            return GetDialog(parent).mode_param == "PDABrowserBobbyRay"
          end,
          "__template",
          "PDABrowserBobbyRay",
          "IgnoreMissing",
          true
        }),
        PlaceObj("XTemplateTemplate", {
          "__condition",
          function(parent, context)
            return GetDialog(parent).mode_param == "PDABrowserSunCola"
          end,
          "__template",
          "PDABrowserSunCola"
        }),
        PlaceObj("XTemplateTemplate", {
          "__condition",
          function(parent, context)
            return GetDialog(parent).mode_param == "PDABrowserMortuary"
          end,
          "__template",
          "PDABrowserMortuary",
          "Id",
          "PDABrowserMortuary"
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "page_error"}, {
        PlaceObj("XTemplateAction", {
          "ActionId",
          "idCloseAction",
          "ActionName",
          T(458886616804, "Close"),
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
          "OnAction",
          function(self, host, source, ...)
            local pda = GetDialog("PDADialog")
            pda:CloseAction(host)
          end,
          "FXMouseIn",
          "buttonRollover",
          "FXPress",
          "buttonPress",
          "FXPressDisabled",
          "IactDisabled"
        }),
        PlaceObj("XTemplateTemplate", {
          "__template",
          "PDABrowserError"
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "VirtualCursorManager",
      "Reason",
      "Browser"
    })
  })
})
