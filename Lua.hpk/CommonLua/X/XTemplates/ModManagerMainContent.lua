PlaceObj("XTemplate", {
  group = "ModManager",
  id = "ModManagerMainContent",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "Id",
    "idContentWrapper"
  }, {
    PlaceObj("XTemplateWindow", {
      "comment",
      "content",
      "Id",
      "idContent",
      "LayoutMethod",
      "VList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return IsModsBackendLoaded()
        end,
        "Dock",
        "top",
        "LayoutMethod",
        "HList",
        "LayoutHSpacing",
        12
      }, {
        PlaceObj("XTemplateWindow", {
          "__condition",
          function(parent, context)
            return IsUserCreatedContentAllowed() and GetUIStyleGamepad()
          end,
          "__class",
          "XTextButton",
          "Id",
          "idLeftTrigger",
          "Background",
          RGBA(0, 0, 0, 0),
          "FocusedBackground",
          RGBA(0, 0, 0, 0),
          "OnPress",
          function(self, gamepad)
            self:ResolveId("idBrowse"):Press()
          end,
          "RolloverBackground",
          RGBA(0, 0, 0, 0),
          "PressedBackground",
          RGBA(0, 0, 0, 0)
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "browse button",
          "__condition",
          function(parent, context)
            return IsUserCreatedContentAllowed()
          end
        }, {
          PlaceObj("XTemplateMode", {"mode", "browse"}, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XTextButton",
              "Id",
              "idBrowse",
              "Padding",
              box(0, 0, 0, 3),
              "Background",
              RGBA(0, 0, 0, 0),
              "FocusedBackground",
              RGBA(0, 0, 0, 0),
              "OnPress",
              function(self, gamepad)
                ModsUISetDialogMode(self, "browse")
              end,
              "RolloverBackground",
              RGBA(0, 0, 0, 0),
              "PressedBackground",
              RGBA(0, 0, 0, 0),
              "Translate",
              true,
              "Text",
              T(451852350969, "BROWSE ALL")
            })
          }),
          PlaceObj("XTemplateMode", {"mode", "installed"}, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XTextButton",
              "Id",
              "idBrowse",
              "Padding",
              box(0, 0, 0, 3),
              "Background",
              RGBA(0, 0, 0, 0),
              "FocusedBackground",
              RGBA(0, 0, 0, 0),
              "OnPress",
              function(self, gamepad)
                ModsUISetDialogMode(self, "browse")
              end,
              "RolloverBackground",
              RGBA(0, 0, 0, 0),
              "PressedBackground",
              RGBA(0, 0, 0, 0),
              "Translate",
              true,
              "Text",
              T(451852350969, "BROWSE ALL")
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "installed button"
        }, {
          PlaceObj("XTemplateMode", {"mode", "browse"}, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XTextButton",
              "Id",
              "idInstalled",
              "Padding",
              box(0, 0, 0, 3),
              "Background",
              RGBA(0, 0, 0, 0),
              "FocusedBackground",
              RGBA(0, 0, 0, 0),
              "OnPress",
              function(self, gamepad)
                ModsUISetDialogMode(self, "installed")
              end,
              "RolloverBackground",
              RGBA(0, 0, 0, 0),
              "PressedBackground",
              RGBA(0, 0, 0, 0),
              "Translate",
              true,
              "Text",
              T(949405693034, "INSTALLED MODS")
            }, {
              PlaceObj("XTemplateWindow", {
                "Margins",
                box(15, 0, 10, 0),
                "VAlign",
                "center"
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Padding",
                  box(0, 0, 0, 0),
                  "HAlign",
                  "center",
                  "VAlign",
                  "center",
                  "HandleMouse",
                  false,
                  "Translate",
                  true,
                  "Text",
                  T(855054268382, "<InstalledModsCount>")
                })
              })
            })
          }),
          PlaceObj("XTemplateMode", {"mode", "installed"}, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XTextButton",
              "Id",
              "idInstalled",
              "Padding",
              box(0, 0, 0, 3),
              "Background",
              RGBA(0, 0, 0, 0),
              "FocusedBackground",
              RGBA(0, 0, 0, 0),
              "OnPress",
              function(self, gamepad)
                ModsUISetDialogMode(self, "installed")
              end,
              "RolloverBackground",
              RGBA(0, 0, 0, 0),
              "PressedBackground",
              RGBA(0, 0, 0, 0),
              "Translate",
              true,
              "Text",
              T(949405693034, "INSTALLED MODS")
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__condition",
          function(parent, context)
            return IsUserCreatedContentAllowed() and GetUIStyleGamepad()
          end,
          "__class",
          "XTextButton",
          "Id",
          "idRightTrigger",
          "Background",
          RGBA(0, 0, 0, 0),
          "FocusedBackground",
          RGBA(0, 0, 0, 0),
          "OnPress",
          function(self, gamepad)
            self:ResolveId("idInstalled"):Press()
          end,
          "RolloverBackground",
          RGBA(0, 0, 0, 0),
          "PressedBackground",
          RGBA(0, 0, 0, 0)
        }),
        PlaceObj("XTemplateCode", {
          "run",
          function(self, parent, context)
            if GetUIStyleGamepad() then
              local left = parent:ResolveId("idLeftTrigger")
              if left then
                left:SetIcon(GetPlatformSpecificImagePath("LT"))
              end
              local right = parent:ResolveId("idRightTrigger")
              if right then
                right:SetIcon(GetPlatformSpecificImagePath("RT"))
              end
            end
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(0, 0, 0, 10),
        "Dock",
        "box"
      }, {
        PlaceObj("XTemplateWindow", nil, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "info sort",
            "Padding",
            box(0, 10, 38, 10),
            "Dock",
            "top",
            "MinHeight",
            50,
            "MaxHeight",
            50
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContentTemplate",
              "IdNode",
              false,
              "LayoutMethod",
              "HList"
            }, {
              PlaceObj("XTemplateMode", {"mode", "installed"}, {
                PlaceObj("XTemplateWindow", {
                  "__condition",
                  function(parent, context)
                    return context:GetInstalledFilterCount() > 0
                  end,
                  "__class",
                  "XText",
                  "VAlign",
                  "center",
                  "FoldWhenHidden",
                  true,
                  "HandleMouse",
                  false,
                  "Translate",
                  true,
                  "Text",
                  T(698646285904, "<InstalledFilterCount> active filters,")
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idTextInstalled",
                  "VAlign",
                  "center",
                  "FoldWhenHidden",
                  true,
                  "HandleMouse",
                  false,
                  "Translate",
                  true,
                  "Text",
                  T(731628863769, "<InstalledModsCount> Installed / <EnabledModsCount> Enabled")
                })
              }),
              PlaceObj("XTemplateMode", {"mode", "browse"}, {
                PlaceObj("XTemplateWindow", {
                  "__condition",
                  function(parent, context)
                    return context:GetFilterCount() > 0
                  end,
                  "__class",
                  "XText",
                  "VAlign",
                  "center",
                  "FoldWhenHidden",
                  true,
                  "HandleMouse",
                  false,
                  "Translate",
                  true,
                  "Text",
                  T(579750785264, "<FilterCount> active filters,")
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idTextAvailable",
                  "VAlign",
                  "center",
                  "FoldWhenHidden",
                  true,
                  "HandleMouse",
                  false,
                  "Translate",
                  true,
                  "Text",
                  T(922587274886, "<ModsCount> Available")
                })
              }),
              PlaceObj("XTemplateMode", {"mode", "installed"}, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XCheckButton",
                  "Id",
                  "idAllToggleEnabled",
                  "Dock",
                  "right",
                  "VAlign",
                  "center",
                  "FoldWhenHidden",
                  true,
                  "OnContextUpdate",
                  function(self, context, ...)
                    XCheckButton.OnContextUpdate(self, context, ...)
                    self:Update()
                  end,
                  "OnPress",
                  function(self, gamepad)
                    ModsUISetAllModsEnabledState(GetDialog(self), not self:GetCheck())
                    XCheckButton.OnPress(self, gamepad)
                  end
                }, {
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "Update",
                    "func",
                    function(self, ...)
                      self:SetEnabled(next(self.context.installed_mods))
                      self:SetCheck(ModsUIGetEnableAllButtonState())
                    end
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "sort",
                "Id",
                "idCtrlsSort",
                "Dock",
                "right",
                "VAlign",
                "center"
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XLabel",
                  "Id",
                  "idSortLabel",
                  "Dock",
                  "left",
                  "VAlign",
                  "center",
                  "Translate",
                  true,
                  "Text",
                  T(570258089761, "SORT: ")
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XTextButton",
                  "Id",
                  "idSortButton",
                  "OnPress",
                  function(self, gamepad)
                    local dlg = GetDialog(self)
                    ModsUIToggleSortPC(dlg.idContentWrapper, "ModManagerPopup")
                  end,
                  "Translate",
                  true
                }, {
                  PlaceObj("XTemplateMode", {"mode", "browse"}, {
                    PlaceObj("XTemplateCode", {
                      "run",
                      function(self, parent, context)
                        local btn = GetParentOfKind(parent, "XTextButton")
                        btn:SetText(T(335892826750, "<SortTextUppercase>"))
                      end
                    })
                  }),
                  PlaceObj("XTemplateMode", {"mode", "installed"}, {
                    PlaceObj("XTemplateCode", {
                      "run",
                      function(self, parent, context)
                        local btn = GetParentOfKind(parent, "XTextButton")
                        btn:SetText(T(619338386138, "<InstalledSortTextUppercase>"))
                      end
                    })
                  })
                })
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "Id",
            "idAboveList"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XSleekScroll",
              "Id",
              "idScroll",
              "Dock",
              "right",
              "Target",
              "idList",
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
              "MinHeight",
              732,
              "MaxHeight",
              732,
              "GridStretchX",
              false,
              "GridStretchY",
              false,
              "LayoutVSpacing",
              4,
              "Background",
              RGBA(255, 255, 255, 0),
              "FocusedBackground",
              RGBA(0, 0, 0, 0),
              "VScroll",
              "idScroll",
              "MouseScroll",
              true,
              "GamepadInitialSelection",
              false,
              "OnContextUpdate",
              function(self, context, ...)
                local mode = GetDialogMode(self)
                if mode == "browse" then
                  self:ResolveId("idListSpinner"):SetVisible(not context.counted)
                  self:ResolveId("idNoResults"):SetVisible(not context.offline and context.counted and context:GetModsCount() == 0)
                  self:ResolveId("idOffline"):SetVisible(context.counted and context.offline and context:GetModsCount() == 0)
                elseif mode == "installed" then
                  self:ResolveId("idListSpinner"):SetVisible(not context.installed_retrieved)
                  self:ResolveId("idNoInstalledMods"):SetVisible(context.installed_retrieved and context:GetInstalledModsCount() == 0)
                end
                XContentTemplateList.OnContextUpdate(self, context, ...)
                if #self == 0 then
                  ModsUISetSelectedMod(false)
                end
              end
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "Open",
                "func",
                function(self, ...)
                  if GetUIStyleGamepad() then
                    self:SetMinWidth(1584)
                    self:SetMaxWidth(1584)
                    self:SetMinHeight(620)
                    self:SetMaxHeight(620)
                  end
                  XContentTemplateList.Open(self, ...)
                  local context = self.context
                  local mode = GetDialogMode(self)
                  local selection = 1
                  local scroll_y = 0
                  if mode == "browse" then
                    selection = context.last_browse_item or 1
                    scroll_y = context.last_browse_y or 0
                  elseif mode == "installed" then
                    selection = context.last_installed_item or 1
                    scroll_y = context.last_installed_y or 0
                  end
                  self:DeleteThread("scrolling")
                  self:CreateThread("scrolling", function(self, selection, scroll_y)
                    if GetUIStyleGamepad() then
                      self:SetSelection(Min(#self, selection))
                    else
                      self:ScrollTo(0, scroll_y)
                    end
                  end, self, selection, scroll_y)
                  if mode == "browse" then
                    self:ResolveId("idListSpinner"):SetVisible(not context.counted)
                    self:ResolveId("idNoResults"):SetVisible(not context.offline and context.counted and context:GetModsCount() == 0)
                    self:ResolveId("idOffline"):SetVisible(context.counted and context.offline and context:GetModsCount() == 0)
                  elseif mode == "installed" then
                    self:ResolveId("idListSpinner"):SetVisible(not context.installed_retrieved)
                    self:ResolveId("idNoInstalledMods"):SetVisible(context.installed_retrieved and context:GetInstalledModsCount() == 0)
                  end
                end
              }),
              PlaceObj("XTemplateMode", {"mode", "browse"}, {
                PlaceObj("XTemplateForEach", {
                  "array",
                  function(parent, context)
                    return table.map(context.searched_mods, context.mod_ui_entries)
                  end,
                  "run_before",
                  function(parent, context, item, i, n, last)
                    local width, height = 387, 269
                    if GetUIStyleGamepad() then
                      width, height = 524, 367
                    end
                    local child = NewXVirtualContent(parent, item, "ModsUIBrowseListItem", width, height)
                    child:SetGridX((i - 1) % 3 + 1)
                    child:SetGridY((i - 1) / 3 + 1)
                    child:SetHAlign("left")
                  end
                })
              }),
              PlaceObj("XTemplateMode", {"mode", "installed"}, {
                PlaceObj("XTemplateForEach", {
                  "array",
                  function(parent, context)
                    return table.map(context.installed_mods, context.mod_ui_entries)
                  end,
                  "run_before",
                  function(parent, context, item, i, n, last)
                    local width, height = 1174, 94
                    if GetUIStyleGamepad() then
                      width, height = 1583, 100
                    end
                    local child = NewXVirtualContent(parent, item, "ModManagerInstalledMod", width, height)
                    child:SetGridX(1)
                    child:SetGridY(i)
                  end
                })
              })
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "ModManagerLoadingAnim",
              "Id",
              "idListSpinner",
              "FoldWhenHidden",
              true
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idNoResults",
              "Dock",
              "box",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "Visible",
              false,
              "FoldWhenHidden",
              true,
              "HandleMouse",
              false,
              "Translate",
              true,
              "Text",
              T(341040457448, "No mods match the search criteria"),
              "TextHAlign",
              "center",
              "TextVAlign",
              "center"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idNoInstalledMods",
              "Dock",
              "box",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "Visible",
              false,
              "FoldWhenHidden",
              true,
              "HandleMouse",
              false,
              "Translate",
              true,
              "Text",
              T(492269718300, "No installed mods match the search criteria"),
              "TextHAlign",
              "center",
              "TextVAlign",
              "center"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idOffline",
              "Dock",
              "box",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "Visible",
              false,
              "FoldWhenHidden",
              true,
              "HandleMouse",
              false,
              "Translate",
              true,
              "Text",
              T(687823167004, "Mod info could not be retrieved from the server. Check your network connection."),
              "TextHAlign",
              "center",
              "TextVAlign",
              "center"
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(10, 10, 0, 0),
          "Dock",
          "right",
          "MinWidth",
          350,
          "MaxWidth",
          350,
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "search box",
            "Margins",
            box(15, 0, 15, 0),
            "Dock",
            "top",
            "MinWidth",
            300,
            "MaxWidth",
            300
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XEdit",
              "Id",
              "idSearch",
              "MaxLen",
              255,
              "AutoSelectAll",
              true
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "OnShortcut(self, shortcut, source, ...)",
                "func",
                function(self, shortcut, source, ...)
                  if shortcut == "Enter" then
                    self:ResolveId("idSearchButton"):Press()
                    return "break"
                  end
                  return XEdit.OnShortcut(self, shortcut, source, ...)
                end
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XTextButton",
              "Id",
              "idSearchButton",
              "HAlign",
              "right",
              "VAlign",
              "center",
              "OnPress",
              function(self, gamepad)
                local mode = GetDialogMode(self)
                local context = self.context
                local text = self:ResolveId("idSearch"):GetText()
                if text == _InternalTranslate(T(10485, "Search mods...")) then
                  text = ""
                end
                local old_query = mode == "browse" and context.query or context.installed_query
                if old_query ~= text then
                  if mode == "browse" then
                    context.query = text
                    context:GetMods()
                  else
                    context.installed_query = text
                    context:GetInstalledMods()
                  end
                end
              end
            }),
            PlaceObj("XTemplateCode", {
              "run",
              function(self, parent, context)
                local mode = GetDialogMode(parent)
                local query = mode == "browse" and context.query or context.installed_query
                query = query ~= "" and query or _InternalTranslate(T(10485, "Search mods..."))
                parent:ResolveId("idSearch"):SetText(query)
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "clear tags",
            "__parent",
            function(parent, context)
              return GetDialog(parent):ResolveId("idBottomBar")
            end,
            "Dock",
            "right",
            "MinWidth",
            325,
            "MaxWidth",
            325
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XTextButton",
              "HAlign",
              "left",
              "OnContextUpdate",
              function(self, context, ...)
                XTextButton.OnContextUpdate(self, context, ...)
                local mode = GetDialogMode(self)
                local t = mode == "browse" and "temp_tags" or "temp_installed_tags"
                t = context[t]
                local compatible = mode == "browse" and "only_compatible" or "only_compatible_installed"
                compatible = context[compatible]
                self:SetVisible(not not next(t) or compatible)
              end,
              "OnPress",
              function(self, gamepad)
                local dlg = GetDialog(self)
                local mode = dlg:GetMode()
                local changed = ModsUIClearFilter(mode)
                if changed then
                  local obj = ResolvePropObj(dlg.context)
                  if mode == "installed" then
                    ModsUISetInstalledTags()
                    obj:GetInstalledMods()
                  else
                    ModsUISetTags()
                    obj:GetMods()
                  end
                end
              end,
              "Translate",
              true,
              "Text",
              T(704603652674, "CLEAR ALL TAGS")
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "tags title",
            "__class",
            "XLabel",
            "Margins",
            box(15, 20, 0, 0),
            "Padding",
            box(0, 0, 0, 0),
            "Dock",
            "top",
            "Translate",
            true,
            "Text",
            T(590534981842, "TAGS")
          }),
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(15, 10, 0, 0),
            "Dock",
            "box"
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "tags list",
              "__class",
              "XList",
              "Id",
              "idTagsList",
              "VScroll",
              "idTagsScroll"
            }, {
              PlaceObj("XTemplateForEach", {
                "array",
                function(parent, context)
                  return PredefinedModTags
                end,
                "__context",
                function(parent, context, item, i, n)
                  return item
                end,
                "run_after",
                function(child, context, item, i, n, last)
                  local dlg = GetDialog(child)
                  local mode = dlg:GetMode()
                  local obj = ResolvePropObj(dlg.context)
                  local temp_table = mode == "installed" and "temp_installed_tags" or "temp_tags"
                  local tags_table = mode == "installed" and "set_installed_tags" or "set_tags"
                  local name = context.display_name
                  child.idCheck:SetText(name)
                  local checked = obj[tags_table][name]
                  child.idCheck:SetCheck(checked)
                  function child.idCheck:OnChange(check)
                    obj[temp_table][name] = check or nil
                    if mode == "installed" then
                      ModsUISetInstalledTags()
                      obj:GetInstalledMods()
                    else
                      ModsUISetTags()
                      obj:GetMods()
                    end
                  end
                end
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "ModManagerTagListItem",
                  "OnContextUpdate",
                  function(self, context, ...)
                    local temp_table = GetDialog(self):GetMode() == "installed" and "temp_installed_tags" or "temp_tags"
                    self.idCheck:SetCheck(g_ModsUIContextObj[temp_table][context.display_name])
                  end
                })
              }),
              PlaceObj("XTemplateTemplate", {
                "__context",
                function(parent, context)
                  return ModsUIGameCompatibleTagContext
                end,
                "__template",
                "ModManagerTagListItem",
                "OnContextUpdate",
                function(self, context, ...)
                  local value = GetDialog(self):GetMode() == "installed" and "only_compatible_installed" or "only_compatible"
                  self.idCheck:SetCheck(g_ModsUIContextObj[value])
                end
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "Open",
                  "func",
                  function(self, ...)
                    XListItem.Open(self, ...)
                    self.idCheck:SetText(_InternalTranslate(T(12427, "Game version compatible")))
                    local dlg = GetDialog(self)
                    local mode = dlg:GetMode()
                    local obj = ResolvePropObj(dlg.context)
                    local value = mode == "installed" and "temp_only_compatible_installed" or "temp_only_compatible"
                    local checked = obj[value]
                    self.idCheck:SetCheck(checked)
                    function self.idCheck:OnChange(check)
                      obj[value] = check or nil
                      if mode == "installed" then
                        ModsUISetInstalledTags()
                        obj:GetInstalledMods()
                      else
                        ModsUISetTags()
                        obj:GetMods()
                      end
                    end
                  end
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XSleekScroll",
              "Id",
              "idTagsScroll",
              "Dock",
              "right",
              "Target",
              "idTagsList",
              "AutoHide",
              true
            })
          })
        })
      })
    })
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "idClose",
    "ActionName",
    T(743155730858, "CLOSE"),
    "ActionToolbar",
    "bottommenu",
    "ActionShortcut",
    "Escape",
    "OnActionEffect",
    "back",
    "OnAction",
    function(self, host, source, ...)
      local shown = ModsUIIsPopupShown(host)
      if shown then
        if shown == "sort" and not GetUIStyleGamepad() then
          ModsUIToggleSortPC(host)
        else
          ModsUIClosePopup(host)
        end
      else
        CreateRealTimeThread(ModsUIDialogEnd, host)
      end
    end
  }),
  PlaceObj("XTemplateAction", {
    "ActionId",
    "idModEditor",
    "ActionName",
    T(469131084747, "MOD EDITOR"),
    "ActionToolbar",
    "bottommenu",
    "OnAction",
    function(self, host, source, ...)
      if IsUserCreatedContentAllowed() then
        CreateRealTimeThread(function(host)
          ModsUIDialogEnd(host, ModEditorOpen)
        end, host)
      end
    end
  }),
  PlaceObj("XTemplateGroup", {
    "__condition",
    function(parent, context)
      return GetUIStyleGamepad()
    end
  }, {
    PlaceObj("XTemplateMode", {"mode", "browse"}, {
      PlaceObj("XTemplateAction", {
        "ActionId",
        "open",
        "ActionName",
        T(594494773035, "Open"),
        "ActionToolbar",
        "ActionBarLeft",
        "ActionGamepad",
        "ButtonA",
        "ActionState",
        function(self, host)
          return ModsUIShowItemAction(host) or "hidden"
        end,
        "OnAction",
        function(self, host, source, ...)
          ModsUISetDialogMode(host, "details", g_ModsUIContextObj:GetSelectedMod())
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "enable",
        "ActionName",
        T(646340216090, "Enable"),
        "ActionToolbar",
        "ActionBarLeft",
        "ActionGamepad",
        "ButtonY",
        "ActionState",
        function(self, host)
          return ModsUIShowItemAction(host, "enabled", false) or "hidden"
        end,
        "OnAction",
        function(self, host, source, ...)
          ModsUIToggleEnabled(nil, host)
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "disable",
        "ActionName",
        T(241331183269, "Disable"),
        "ActionToolbar",
        "ActionBarLeft",
        "ActionGamepad",
        "ButtonY",
        "ActionState",
        function(self, host)
          return ModsUIShowItemAction(host, "enabled", true) or "hidden"
        end,
        "OnAction",
        function(self, host, source, ...)
          ModsUIToggleEnabled(nil, host)
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "install",
        "ActionName",
        T(351353414605, "Install"),
        "ActionToolbar",
        "ActionBarLeft",
        "ActionGamepad",
        "ButtonX",
        "ActionState",
        function(self, host)
          if g_DownloadingMods[host.context.selected_mod_id] then
            return "disabled"
          end
          return ModsUIShowItemAction(host, "installed", false) and IsModsBackendLoaded() or "hidden"
        end,
        "OnAction",
        function(self, host, source, ...)
          if not g_ModsBackendObj:IsLoggedIn() then
            ModsUIOpenLoginPopup(host.idContentWrapper)
          else
            ModsUIInstallMod()
          end
          host:UpdateActionViews(host)
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "uninstall",
        "ActionName",
        T(174683399082, "Uninstall"),
        "ActionToolbar",
        "ActionBarLeft",
        "ActionGamepad",
        "ButtonX",
        "ActionState",
        function(self, host)
          return ModsUIShowItemAction(host, "installed", true) and IsModsBackendLoaded() or "hidden"
        end,
        "OnAction",
        function(self, host, source, ...)
          ModsUIUninstallMod()
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "search",
        "ActionName",
        T(530535622110, "Search"),
        "ActionToolbar",
        "ActionBarRight",
        "ActionGamepad",
        "Back",
        "ActionState",
        function(self, host)
          return not ModsUIIsPopupShown(host) or "hidden"
        end,
        "OnAction",
        function(self, host, source, ...)
          ModsUIConsoleSearch(host.idContentWrapper)
          host:UpdateActionViews(host)
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "filter",
        "ActionName",
        T(283589763270, "Filter"),
        "ActionToolbar",
        "ActionBarRight",
        "ActionGamepad",
        "Start",
        "ActionState",
        function(self, host)
          return not ModsUIIsPopupShown(host) or "hidden"
        end,
        "OnAction",
        function(self, host, source, ...)
          ModsUIChooseFilter(host.idContentWrapper)
          host:UpdateActionViews(host)
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "sort",
        "ActionName",
        T(600084142632, "Sort"),
        "ActionToolbar",
        "ActionBarRight",
        "ActionGamepad",
        "RightThumbClick",
        "ActionState",
        function(self, host)
          return not ModsUIIsPopupShown(host) or "hidden"
        end,
        "OnAction",
        function(self, host, source, ...)
          ModsUIChooseSort(host.idContentWrapper)
          host:UpdateActionViews(host)
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "back",
        "ActionName",
        T(889105824841, "Back"),
        "ActionToolbar",
        "ActionBarRight",
        "ActionShortcut",
        "Escape",
        "ActionGamepad",
        "ButtonB",
        "ActionState",
        function(self, host)
          return not ModsUIIsPopupShown(host) or "hidden"
        end,
        "OnAction",
        function(self, host, source, ...)
          CreateRealTimeThread(ModsUIDialogEnd, host)
        end
      })
    }),
    PlaceObj("XTemplateMode", {"mode", "installed"}, {
      PlaceObj("XTemplateAction", {
        "ActionId",
        "open",
        "ActionName",
        T(594494773035, "Open"),
        "ActionToolbar",
        "ActionBarLeft",
        "ActionGamepad",
        "ButtonA",
        "ActionState",
        function(self, host)
          return ModsUIShowItemAction(host) or "hidden"
        end,
        "OnAction",
        function(self, host, source, ...)
          ModsUISetDialogMode(host, "details", g_ModsUIContextObj:GetSelectedMod("installed_mods"))
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "enable",
        "ActionName",
        T(646340216090, "Enable"),
        "ActionToolbar",
        "ActionBarLeft",
        "ActionGamepad",
        "ButtonY",
        "ActionState",
        function(self, host)
          return ModsUIShowItemAction(host, "enabled", false) or "hidden"
        end,
        "OnAction",
        function(self, host, source, ...)
          ModsUIToggleEnabled(nil, host, "installed_mods")
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "disable",
        "ActionName",
        T(241331183269, "Disable"),
        "ActionToolbar",
        "ActionBarLeft",
        "ActionGamepad",
        "ButtonY",
        "ActionState",
        function(self, host)
          return ModsUIShowItemAction(host, "enabled", true) or "hidden"
        end,
        "OnAction",
        function(self, host, source, ...)
          ModsUIToggleEnabled(nil, host, "installed_mods")
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "uninstall",
        "ActionName",
        T(174683399082, "Uninstall"),
        "ActionToolbar",
        "ActionBarLeft",
        "ActionGamepad",
        "ButtonX",
        "ActionState",
        function(self, host)
          return ModsUIShowItemAction(host, "installed", true) and IsModsBackendLoaded() or "hidden"
        end,
        "OnAction",
        function(self, host, source, ...)
          ModsUIUninstallMod(nil, "installed_mods")
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "disableAll",
        "ActionName",
        T(812851576389, "Disable All"),
        "ActionToolbar",
        "ActionBarLeft",
        "ActionGamepad",
        "LeftThumbClick",
        "ActionState",
        function(self, host)
          return ModsUIShowItemAction(host) and ModsUIGetEnableAllButtonState() == true or "hidden"
        end,
        "OnAction",
        function(self, host, source, ...)
          ModsUISetAllModsEnabledState(host, false)
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "enableAll",
        "ActionName",
        T(875315745274, "Enable All"),
        "ActionToolbar",
        "ActionBarLeft",
        "ActionGamepad",
        "LeftThumbClick",
        "ActionState",
        function(self, host)
          return ModsUIShowItemAction(host) and ModsUIGetEnableAllButtonState() == false or "hidden"
        end,
        "OnAction",
        function(self, host, source, ...)
          ModsUISetAllModsEnabledState(host, true)
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "search",
        "ActionName",
        T(530535622110, "Search"),
        "ActionToolbar",
        "ActionBarRight",
        "ActionGamepad",
        "Back",
        "ActionState",
        function(self, host)
          return not ModsUIIsPopupShown(host) or "hidden"
        end,
        "OnAction",
        function(self, host, source, ...)
          ModsUIConsoleSearch(host.idContentWrapper)
          host:UpdateActionViews(host)
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "filter",
        "ActionName",
        T(283589763270, "Filter"),
        "ActionToolbar",
        "ActionBarRight",
        "ActionGamepad",
        "Start",
        "ActionState",
        function(self, host)
          return not ModsUIIsPopupShown(host) or "hidden"
        end,
        "OnAction",
        function(self, host, source, ...)
          ModsUIChooseFilter(host.idContentWrapper)
          host:UpdateActionViews(host)
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "sort",
        "ActionName",
        T(600084142632, "Sort"),
        "ActionToolbar",
        "ActionBarRight",
        "ActionGamepad",
        "RightThumbClick",
        "ActionState",
        function(self, host)
          return not ModsUIIsPopupShown(host) or "hidden"
        end,
        "OnAction",
        function(self, host, source, ...)
          ModsUIChooseSort(host.idContentWrapper)
          host:UpdateActionViews(host)
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "back",
        "ActionName",
        T(889105824841, "Back"),
        "ActionToolbar",
        "ActionBarRight",
        "ActionShortcut",
        "Escape",
        "ActionGamepad",
        "ButtonB",
        "ActionState",
        function(self, host)
          return not ModsUIIsPopupShown(host) or "hidden"
        end,
        "OnAction",
        function(self, host, source, ...)
          CreateRealTimeThread(ModsUIDialogEnd, host)
        end
      })
    })
  })
})
