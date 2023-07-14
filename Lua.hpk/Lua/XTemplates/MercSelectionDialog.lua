PlaceObj("XTemplate", {
  __is_kind_of = "ZuluModalDialog",
  group = "Zulu PDA",
  id = "MercSelectionDialog",
  PlaceObj("XTemplateWindow", {
    "comment",
    "content frame",
    "__class",
    "ZuluModalDialog",
    "Dock",
    "box",
    "Background",
    RGBA(32, 35, 47, 120)
  }, {
    PlaceObj("XTemplateWindow", {
      "HAlign",
      "center",
      "VAlign",
      "center"
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
          box(10, 0, 0, 0)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idHeaderText",
            "VAlign",
            "center",
            "TextStyle",
            "PDABrowserTitle",
            "Translate",
            true,
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
        "Padding",
        box(8, 8, 8, 8),
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
          "__class",
          "XFrame",
          "IdNode",
          false,
          "Margins",
          box(0, 0, 0, 8),
          "Image",
          "UI/PDA/os_background_2",
          "FrameBox",
          box(5, 5, 5, 5)
        }, {
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return GetSquadsOnMap("refs")
            end,
            "__class",
            "SnappingScrollArea",
            "Id",
            "idMercRows",
            "IdNode",
            false,
            "Padding",
            box(15, 5, 15, 15),
            "MinWidth",
            670,
            "MaxHeight",
            590,
            "Clip",
            false,
            "VScroll",
            "idMercScroll"
          }, {
            PlaceObj("XTemplateForEach", {
              "comment",
              "squad",
              "array",
              function(parent, context)
                return context
              end,
              "__context",
              function(parent, context, item, i, n)
                return item
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "squad row",
                "IdNode",
                true,
                "Padding",
                box(0, 5, 0, 0),
                "LayoutMethod",
                "VList"
              }, {
                PlaceObj("XTemplateWindow", {
                  "LayoutMethod",
                  "HList"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XContextWindow",
                    "Id",
                    "idSquad",
                    "Margins",
                    box(0, 13, 18, 4),
                    "HAlign",
                    "left",
                    "MinWidth",
                    80,
                    "MaxWidth",
                    80,
                    "Background",
                    RGBA(32, 35, 47, 255),
                    "BackgroundRectGlowSize",
                    1,
                    "BackgroundRectGlowColor",
                    RGBA(32, 35, 47, 255)
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__context",
                      function(parent, context)
                        return context
                      end,
                      "__class",
                      "XContextWindow",
                      "HAlign",
                      "center",
                      "VAlign",
                      "bottom",
                      "LayoutMethod",
                      "VList"
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XContextImage",
                        "Id",
                        "idCenter",
                        "IdNode",
                        false,
                        "UseClipBox",
                        false,
                        "Image",
                        "UI/PDA/T_Icon_EnemySquadPlaceholder_L",
                        "ImageScale",
                        point(900, 900),
                        "ImageColor",
                        RGBA(195, 189, 172, 255),
                        "ContextUpdateOnOpen",
                        true,
                        "OnContextUpdate",
                        function(self, context, ...)
                          self:SetImage(context.image)
                        end
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "AutoFitText",
                        "Id",
                        "idSquadName",
                        "Margins",
                        box(5, 5, 5, 0),
                        "HAlign",
                        "center",
                        "FoldWhenHidden",
                        true,
                        "TextStyle",
                        "PDASM_SectorName",
                        "ContextUpdateOnOpen",
                        true,
                        "OnContextUpdate",
                        function(self, context, ...)
                          self:SetText(context.ShortName or SquadName:GetShortNameFromName(context.Name))
                        end,
                        "Translate",
                        true
                      })
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "Id",
                    "idMercs",
                    "LayoutMethod",
                    "HList",
                    "LayoutHSpacing",
                    10
                  }, {
                    PlaceObj("XTemplateForEach", {
                      "comment",
                      "merc",
                      "array",
                      function(parent, context)
                        return context.units
                      end,
                      "__context",
                      function(parent, context, item, i, n)
                        return gv_UnitData[item]
                      end
                    }, {
                      PlaceObj("XTemplateTemplate", {
                        "__template",
                        "HUDMerc",
                        "OnContextUpdate",
                        function(self, context, ...)
                          local dlg = GetDialog(self)
                          self:SetSelected(dlg.SelectedMercId == context.session_id)
                        end,
                        "OnPress",
                        function(self, gamepad)
                          local mercProfiles = GetDialog(self)
                          local context = self:GetContext()
                          mercProfiles:SetSelectedMercId(context.session_id)
                        end,
                        "LevelUpIndicator",
                        false
                      }, {
                        PlaceObj("XTemplateFunc", {
                          "name",
                          "OnMouseButtonDoubleClick(self, pos, button)",
                          "func",
                          function(self, pos, button)
                            local dlg = GetDialog(self)
                            local selectAction = dlg:ActionById("idSelectAction")
                            dlg:OnAction(selectAction)
                          end
                        }),
                        PlaceObj("XTemplateFunc", {
                          "name",
                          "CreateRolloverWindow(self, ...)",
                          "func",
                          function(self, ...)
                            local w = HUDMercClass.CreateRolloverWindow(self, ...)
                            if w then
                              w:SetMargins(box(0, 0, 0, 0))
                            end
                            return w
                          end
                        })
                      })
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XFrame",
                  "Margins",
                  box(0, 8, 0, 0),
                  "Image",
                  "UI/PDA/separate_line_vertical",
                  "FrameBox",
                  box(3, 3, 3, 3),
                  "SqueezeY",
                  false
                })
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "MessengerScrollbar",
            "Id",
            "idMercScroll",
            "Dock",
            "right",
            "Target",
            "idMercRows",
            "AutoHide",
            true
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XToolBarList",
          "Id",
          "idToolBar",
          "IdNode",
          false,
          "Dock",
          "bottom",
          "HAlign",
          "center",
          "LayoutHSpacing",
          32,
          "Background",
          RGBA(255, 255, 255, 0),
          "Toolbar",
          "ActionBar",
          "ButtonTemplate",
          "PDACommonButton"
        }, {
          PlaceObj("XTemplateAction", {
            "ActionId",
            "idSelectAction",
            "ActionName",
            T(965852386218, "Select"),
            "ActionToolbar",
            "ActionBar",
            "ActionShortcut",
            "S",
            "ActionGamepad",
            "ButtonA",
            "ActionState",
            function(self, host)
              local mercProfiles = GetDialog(host)
              return mercProfiles.SelectedMercId and "enabled" or "disabled"
            end,
            "OnAction",
            function(self, host, source, ...)
              local mercProfiles = GetDialog(host)
              host:Close(mercProfiles.SelectedMercId)
            end
          }),
          PlaceObj("XTemplateAction", {
            "ActionId",
            "idCloseAction",
            "ActionName",
            T(563060593643, "Close"),
            "ActionToolbar",
            "ActionBar",
            "ActionShortcut",
            "Escape",
            "ActionGamepad",
            "ButtonB",
            "OnAction",
            function(self, host, source, ...)
              local dlg = GetDialog(host)
              dlg:Close()
            end
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "squad observer",
        "__context",
        function(parent, context)
          return "hud_squads"
        end,
        "__class",
        "XContextWindow",
        "OnContextUpdate",
        function(self, context, ...)
          local node = self:ResolveId("node")
          node.idMercRows:SetContext(GetSquadsOnMap("refs"))
        end
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        local squadChanged = false
        local squadIdx, mercIdx = self:GetGamepadSelection()
        if shortcut == "DPadLeft" or shortcut == "DPadRight" or shortcut == "DPadUp" or shortcut == "DPadDown" then
          if shortcut == "DPadLeft" then
            mercIdx = mercIdx - 1
          elseif shortcut == "DPadRight" then
            mercIdx = mercIdx + 1
          elseif shortcut == "DPadUp" then
            squadIdx = squadIdx - 1
            squadChanged = true
          elseif shortcut == "DPadDown" then
            squadIdx = squadIdx + 1
            squadChanged = true
          end
          local squads = self.idMercRows.context
          local selectedSquad = squads[squadIdx]
          if not selectedSquad then
            return "break"
          end
          local sqUnits = selectedSquad.units
          local selectedMerc = sqUnits[mercIdx]
          if not selectedMerc and squadChanged then
            if mercIdx < 1 then
              mercIdx = 1
            else
              mercIdx = #sqUnits
            end
            selectedMerc = sqUnits[mercIdx]
          end
          if not selectedMerc then
            return "break"
          end
          self:SetSelectedMercId(selectedMerc)
          return "break"
        end
        return ZuluModalDialog.OnShortcut(self, shortcut, source, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self)",
      "func",
      function(self)
        ZuluModalDialog.Open(self)
        self:ApplyGamepadSelection()
        self:CreateThread("satellite-observer", function()
          WaitMsg("OpenSatelliteView")
          self:Close()
        end)
        self:CreateThread("gamestate-changed", function()
          WaitMsg("GameStateChanged")
          self:Close()
        end)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "ApplyGamepadSelection(self)",
      "func",
      function(self)
        local squadIdx, mercIdx = self:GetGamepadSelection()
        for squadId, squadWnd in ipairs(self.idMercRows) do
          for mercId, mercWnd in ipairs(squadWnd.idMercs) do
            if squadId == squadIdx and mercId == mercIdx then
              self:SetSelectedMercId(mercWnd.context.session_id)
              return
            end
          end
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "GetGamepadSelection(self)",
      "func",
      function(self)
        for squadId, squadWnd in ipairs(self.idMercRows) do
          for mercId, mercWnd in ipairs(squadWnd.idMercs) do
            if mercWnd.selected then
              return squadId, mercId
            end
          end
        end
        if GetUIStyleGamepad() then
          return 1, 1
        end
      end
    })
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "MercProfiles",
    "id",
    "SelectedMercId",
    "editor",
    "text",
    "translate",
    false,
    "Set",
    function(self, value)
      self.SelectedMercId = value
      self:ResolveId("idMercRows"):RespawnContent()
      self.idToolBar:RebuildActions(self)
    end,
    "Get",
    function(self)
      return self.SelectedMercId
    end,
    "name",
    T(844638853048, "Selected Merc Id")
  })
})
