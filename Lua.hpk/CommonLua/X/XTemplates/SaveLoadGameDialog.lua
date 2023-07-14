PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Common",
  id = "SaveLoadGameDialog",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return SaveLoadObjectCreateAndLoad()
    end,
    "__class",
    "XDialog",
    "InitialMode",
    "load",
    "InternalModes",
    "save, load"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        CreateRealTimeThread(function(self, ...)
          LoadingScreenOpen("idLoadingScreen", "save load")
          self.context:WaitGetSaveItems()
          XDialog.Open(self, ...)
          if config.SaveGameScreenshot and self.Mode == "save" then
            WaitCaptureCurrentScreenshot()
          end
          if self.Mode == "save" then
            local first_item = self:ResolveId("idNewSave")
            if first_item then
              first_item:OnSetRollover(true)
            end
          end
          LoadingScreenClose("idLoadingScreen", "save load")
        end, self, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete",
      "func",
      function(self, ...)
        if config.SaveGameScreenshot then
          CreateRealTimeThread(function()
            Savegame.Unmount()
          end)
        end
        g_SaveGameObj = false
        g_CurrentSaveGameItemId = false
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContentTemplate",
      "Dock",
      "top"
    }, {
      PlaceObj("XTemplateMode", {"mode", "save"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "DialogTitle",
          "Text",
          T(621030754081, "SAVE GAME")
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "load"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "DialogTitle",
          "Text",
          T(404394084503, "LOAD GAME")
        })
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Delete",
      "ActionName",
      T(858497021631, "DELETE"),
      "ActionToolbar",
      "ActionBar",
      "ActionShortcut",
      "Delete",
      "ActionGamepad",
      "ButtonY",
      "OnActionEffect",
      "mode",
      "OnAction",
      function(self, host, source, ...)
        local dlg = GetDialog(host)
        local obj = GetDialogContext(dlg)
        obj:Delete(dlg)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "Margins",
      box(0, 20, 0, 0),
      "LayoutMethod",
      "HList",
      "LayoutHSpacing",
      50
    }, {
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(100, 0, 0, 0),
        "HAlign",
        "left",
        "VAlign",
        "top",
        "MinWidth",
        600,
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        20
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContentTemplate",
          "IdNode",
          false,
          "Dock",
          "top"
        }, {
          PlaceObj("XTemplateMode", {"mode", "save"}, {
            PlaceObj("XTemplateTemplate", {
              "__context",
              function(parent, context)
                return {id = 0}
              end,
              "__template",
              "MenuButton",
              "Id",
              "idNewSave",
              "Margins",
              box(0, 0, 0, 20),
              "RolloverOnFocus",
              false,
              "OnPress",
              function(self, gamepad)
                GetDialogContext(self):ShowNewSavegameNamePopup(GetDialog(self))
              end,
              "Text",
              T(640605238354, "<<< New Savegame >>>")
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "OnSetRollover(self, rollover)",
                "func",
                function(self, rollover)
                  XTextButton.OnSetRollover(self, rollover)
                  if rollover then
                    ShowSavegameDescription(self.context, GetDialog(self))
                    local list = self:ResolveId("idList")
                    if list then
                      list:SetSelection(false)
                    end
                    self:SetFocus()
                  end
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "Deselect",
                "func",
                function(self, ...)
                  self:SetRollover(false)
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "OnShortcut(self, shortcut, source, ...)",
                "func",
                function(self, shortcut, source, ...)
                  if shortcut == "DPadDown" or shortcut == "LeftThumbDown" or shortcut == "Down" then
                    local list = self:ResolveId("idList")
                    if list and 0 < #list then
                      self:Deselect()
                      list:SetSelection(1)
                    end
                    return "break"
                  end
                  return XTextButton.OnShortcut(self, shortcut, source, ...)
                end
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", nil, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XSleekScroll",
            "Id",
            "idScroll",
            "Margins",
            box(20, 0, 0, 0),
            "Dock",
            "right",
            "Target",
            "idList",
            "SnapToItems",
            true,
            "AutoHide",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XContentTemplateList",
            "Id",
            "idList",
            "BorderWidth",
            0,
            "Padding",
            box(0, 0, 0, 0),
            "LayoutVSpacing",
            20,
            "UniformRowHeight",
            true,
            "Clip",
            false,
            "Background",
            RGBA(0, 0, 0, 0),
            "FocusedBackground",
            RGBA(0, 0, 0, 0),
            "VScroll",
            "idScroll",
            "ShowPartialItems",
            false,
            "MouseScroll",
            true,
            "ForceInitialSelection",
            true
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "OnShortcut(self, shortcut, source, ...)",
              "func",
              function(self, shortcut, source, ...)
                if shortcut == "Up" and self.focused_item == 1 and GetDialogMode(self) == "save" then
                  self:SetSelection(false)
                  self:ResolveId("idNewSave"):SetRollover(true)
                  return "break"
                end
                return XContentTemplateList.OnShortcut(self, shortcut, source, ...)
              end
            }),
            PlaceObj("XTemplateForEach", {
              "comment",
              "item",
              "array",
              function(parent, context)
                return context.items
              end,
              "__context",
              function(parent, context, item, i, n)
                return item
              end,
              "run_after",
              function(child, context, item, i, n, last)
                child:SetText(context.text)
              end
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "MenuButton",
                "RolloverOnFocus",
                false,
                "OnPress",
                function(self, gamepad)
                  local dlg = GetDialog(self)
                  local mode = dlg.Mode
                  local obj = GetDialogContext(dlg)
                  if mode == "load" then
                    obj:Load(dlg, self.context)
                  elseif mode == "save" then
                    obj:ShowNewSavegameNamePopup(dlg, self.context)
                  end
                end,
                "Translate",
                false
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnSetRollover(self, rollover)",
                  "func",
                  function(self, rollover)
                    XTextButton.OnSetRollover(self, rollover)
                    local parent = self.parent
                    local selection = parent:GetSelection()
                    local item = next(selection) and parent[selection[1]]
                    if rollover and item ~= self then
                      parent:SetSelection(table.find(parent, self))
                    end
                    if rollover or item ~= self then
                      if rollover then
                        ShowSavegameDescription(self.context, GetDialog(self))
                      end
                      local new_save = self:ResolveId("idNewSave")
                      if new_save then
                        new_save:Deselect()
                      end
                    end
                  end
                })
              })
            })
          })
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "Back",
          "ActionName",
          T(127501107069, "BACK"),
          "ActionToolbar",
          "ActionBar",
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
          "OnActionEffect",
          "mode"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idDescription",
        "VAlign",
        "top",
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        5
      }, {
        PlaceObj("XTemplateWindow", {
          "HAlign",
          "left",
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Id",
            "idImage",
            "HAlign",
            "left",
            "VAlign",
            "top",
            "MaxWidth",
            630,
            "ImageFit",
            "width"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idSavegameTitle",
            "Margins",
            box(20, 0, 15, 0),
            "Padding",
            box(0, 4, 0, 4),
            "VAlign",
            "bottom",
            "MinHeight",
            50,
            "MaxWidth",
            630,
            "HandleMouse",
            false,
            "TextStyle",
            "GizmoText",
            "Translate",
            true,
            "TextVAlign",
            "center"
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(20, 20, 0, 0)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XSleekScroll",
            "Id",
            "idInfoScroll",
            "Margins",
            box(15, 0, 0, 0),
            "Dock",
            "right",
            "Target",
            "idInfoTextArea",
            "SnapToItems",
            true,
            "AutoHide",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XScrollArea",
            "Id",
            "idInfoTextArea",
            "IdNode",
            false,
            "LayoutMethod",
            "VList",
            "VScroll",
            "idInfoScroll"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idPlaytime",
              "HandleMouse",
              false,
              "TextStyle",
              "GedTitle",
              "Translate",
              true
            }),
            PlaceObj("XTemplateWindow", {
              "__condition",
              function(parent, context)
                return Platform.developer
              end,
              "__class",
              "XText",
              "Id",
              "idRevision",
              "HandleMouse",
              false,
              "TextStyle",
              "GedTitle",
              "Translate",
              true,
              "HideOnEmpty",
              true
            }),
            PlaceObj("XTemplateWindow", {
              "__condition",
              function(parent, context)
                return Platform.developer
              end,
              "__class",
              "XText",
              "Id",
              "idMap",
              "HandleMouse",
              false,
              "TextStyle",
              "GedTitle",
              "Translate",
              true,
              "HideOnEmpty",
              true
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idProblem",
              "HandleMouse",
              false,
              "TextStyle",
              "GedError",
              "Translate",
              true,
              "HideOnEmpty",
              true
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idActiveMods",
              "HandleMouse",
              false,
              "TextStyle",
              "GedTitle",
              "Translate",
              true,
              "HideOnEmpty",
              true
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idDelInfo",
              "Margins",
              box(0, 20, 0, 0),
              "HandleMouse",
              false,
              "TextStyle",
              "GedTitle",
              "Translate",
              true
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XToolBar",
      "Id",
      "idToolbar",
      "Margins",
      box(0, 60, 0, 100),
      "Dock",
      "bottom",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "LayoutHSpacing",
      20,
      "Background",
      RGBA(255, 255, 255, 6),
      "Toolbar",
      "ActionBar",
      "Show",
      "text",
      "ToolbarSectionTemplate",
      ""
    })
  })
})
