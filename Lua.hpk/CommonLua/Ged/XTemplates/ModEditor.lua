PlaceObj("XTemplate", {
  group = "GedApps",
  id = "ModEditor",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Translate",
    true,
    "Title",
    "Mod Editor",
    "AppId",
    "ModEditor",
    "InitialWidth",
    1100
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self, ...)",
      "func",
      function(self, ...)
        MountFolder(self.mod_content_path, self.mod_os_path)
        return GedApp.Open(self, ...)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "File",
      "ActionName",
      T(174683227646, "File"),
      "ActionMenubar",
      "main",
      "OnActionEffect",
      "popup"
    }, {
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Save",
        "ActionName",
        T(280146583573, "Save"),
        "ActionIcon",
        "CommonAssets/UI/Ged/save.tga",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Ctrl-S",
        "OnAction",
        function(self, host, source, ...)
          host:Op("GedOpSaveMod", "root")
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "OpenFolder",
        "ActionName",
        T(595712252411, "Open Folder"),
        "ActionIcon",
        "CommonAssets/UI/Ged/explorer.tga",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Ctrl-O",
        "OnAction",
        function(self, host, source, ...)
          host:Op("GedOpOpenModFolder", "root")
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Test",
        "ActionName",
        T(269289071783, "Test"),
        "ActionIcon",
        "CommonAssets/UI/Ged/play.tga",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Ctrl-T",
        "OnAction",
        function(self, host, source, ...)
          host:Op("GedOpTestModItem", "root", host.idItems:GetSelection())
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Help",
        "ActionName",
        T(199870397665, "Help"),
        "ActionIcon",
        "CommonAssets/UI/Ged/help.tga",
        "ActionToolbar",
        "main",
        "ActionToolbarSplit",
        true,
        "ActionShortcut",
        "Ctrl-H",
        "OnAction",
        function(self, host, source, ...)
          host:Op("GedOpModItemHelp", "root", host.idItems:GetSelection())
        end
      }),
      PlaceObj("XTemplateCode", {
        "run",
        function(self, parent, context)
          if XTemplates.ModEditorPlatformActions then
            XTemplates.ModEditorPlatformActions:Eval(parent, context)
          end
        end
      }),
      PlaceObj("XTemplateGroup", {
        "__condition",
        function(parent, context)
          return Platform.steam
        end
      }, {
        PlaceObj("XTemplateAction", {
          "RolloverText",
          T(966025188900, "Upload to Steam"),
          "RolloverDisabledText",
          T(131688119141, "Uploading to Steam is unavailable"),
          "ActionId",
          "SteamUpload",
          "ActionName",
          T(740063077677, "Upload to Steam"),
          "ActionIcon",
          "CommonAssets/UI/Ged/steam.tga",
          "ActionToolbar",
          "main",
          "ActionToolbarSplit",
          true,
          "ActionState",
          function(self, host)
            return not host.steam_login and "disabled"
          end,
          "OnAction",
          function(self, host, source, ...)
            host:Op("GedOpUploadModToSteam", "root")
          end
        })
      }),
      PlaceObj("XTemplateGroup", {
        "__condition",
        function(parent, context)
          return Platform.epic
        end
      }, {
        PlaceObj("XTemplateAction", {
          "RolloverText",
          T(602897019334, "Upload to Epic Games"),
          "RolloverDisabledText",
          T(584040368360, "Uploading to Epic Games is unavailable"),
          "ActionId",
          "EpicUpload",
          "ActionName",
          T(848185994514, "Upload to Epic Games"),
          "ActionIcon",
          "CommonAssets/UI/Ged/epic_up",
          "ActionToolbar",
          "main",
          "ActionToolbarSplit",
          true,
          "ActionState",
          function(self, host)
          end,
          "OnAction",
          function(self, host, source, ...)
            host:Op("GedOpUploadModToEpic", "root")
          end
        })
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "DeleteItem",
        "ActionName",
        T(258980848206, "Delete Item"),
        "ActionIcon",
        "CommonAssets/UI/Ged/delete.tga",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Delete",
        "OnAction",
        function(self, host, source, ...)
          host:Op("GedOpDeleteModItem", "root", host.idItems:GetSelection())
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Cut",
        "ActionName",
        T(953603840716, "Cut"),
        "ActionIcon",
        "CommonAssets/UI/Ged/cut.tga",
        "ActionMenubar",
        "Edit",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Ctrl-X",
        "OnAction",
        function(self, host, source, ...)
          local panel = host:GetLastFocusedPanel()
          if panel == host.idItems then
            host:Op("GedOpCutModItem", panel.context, panel:GetSelection())
          end
        end,
        "ActionContexts",
        {
          "ContentRootPanelAction",
          "ContentChildPanelAction",
          "PresetsChildAction"
        },
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Copy",
        "ActionName",
        T(665226843151, "Copy"),
        "ActionIcon",
        "CommonAssets/UI/Ged/copy.tga",
        "ActionMenubar",
        "Edit",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Ctrl-C",
        "OnAction",
        function(self, host, source, ...)
          local panel = host:GetLastFocusedPanel()
          if panel == host.idItems then
            host:Op("GedOpCopyModItem", panel.context, panel:GetSelection())
          elseif panel == host.idItemProperties then
            host:Op("GedOpPropertyCopy", panel.context, panel:GetSelectedProperties(), panel.context)
          end
        end,
        "ActionContexts",
        {
          "PresetsChildAction",
          "ContentRootPanelAction",
          "ContentChildPanelAction",
          "PropAction"
        },
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Paste",
        "ActionName",
        T(926546358516, "Paste"),
        "ActionIcon",
        "CommonAssets/UI/Ged/paste.tga",
        "ActionMenubar",
        "Edit",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Ctrl-V",
        "OnAction",
        function(self, host, source, ...)
          local panel = host:GetLastFocusedPanel()
          if panel == host.idItems then
            host:Op("GedOpPasteModItem", panel.context, panel:GetSelection())
          elseif panel:IsKindOf("GedPropPanel") then
            host:Op("GedOpPropertyPaste", panel.context)
          end
        end,
        "ActionContexts",
        {
          "PresetsChildAction",
          "ContentRootPanelAction",
          "ContentChildPanelAction",
          "PropAction"
        },
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Duplicate",
        "ActionName",
        T(310061253073, "Duplicate"),
        "ActionIcon",
        "CommonAssets/UI/Ged/duplicate.tga",
        "ActionMenubar",
        "Edit",
        "ActionToolbar",
        "main",
        "ActionToolbarSplit",
        true,
        "ActionShortcut",
        "Ctrl-D",
        "OnAction",
        function(self, host, source, ...)
          local panel = host:GetLastFocusedPanel()
          if panel == host.idItems then
            host:Op("GedOpDuplicateModItem", panel.context, panel:GetSelection())
          end
        end,
        "ActionContexts",
        {
          "PresetsChildAction",
          "ContentRootPanelAction",
          "ContentChildPanelAction"
        },
        "replace_matching_id",
        true
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Exit",
        "ActionName",
        T(609220573003, "Exit"),
        "OnAction",
        function(self, host, source, ...)
          host:Exit()
        end
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Edit",
      "ActionName",
      T(786174819535, "Edit"),
      "ActionMenubar",
      "main",
      "OnActionEffect",
      "popup"
    }, {
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Undo",
        "ActionName",
        T(833116955862, "Undo"),
        "ActionIcon",
        "CommonAssets/UI/Ged/undo.tga",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Ctrl-Z",
        "OnAction",
        function(self, host, source, ...)
          host:Undo()
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Redo",
        "ActionName",
        T(792397678029, "Redo"),
        "ActionIcon",
        "CommonAssets/UI/Ged/redo.tga",
        "ActionToolbar",
        "main",
        "ActionToolbarSplit",
        true,
        "ActionShortcut",
        "Ctrl-Y",
        "OnAction",
        function(self, host, source, ...)
          host:Redo()
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionName",
        T(298776341838, "-----"),
        "ActionMenubar",
        "Edit"
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "MoveOutwards",
        "ActionName",
        T(875285425823, "Move Out"),
        "ActionIcon",
        "CommonAssets/UI/Ged/left.tga",
        "ActionMenubar",
        "Edit",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Alt-Left",
        "OnAction",
        function(self, host, source, ...)
          local panel = host:GetLastFocusedPanel()
          if panel == host.idItems then
            host:Op("GedOpTreeMoveItemOutwards", panel.context, panel:GetSelection())
          end
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "MoveInwards",
        "ActionName",
        T(795789990196, "Move In"),
        "ActionIcon",
        "CommonAssets/UI/Ged/right.tga",
        "ActionMenubar",
        "Edit",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Alt-Right",
        "OnAction",
        function(self, host, source, ...)
          local panel = host:GetLastFocusedPanel()
          if panel == host.idItems then
            host:Op("GedOpTreeMoveItemInwards", panel.context, panel:GetSelection())
          end
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "MoveUp",
        "ActionName",
        T(765505042894, "Move Up"),
        "ActionIcon",
        "CommonAssets/UI/Ged/up.tga",
        "ActionMenubar",
        "Edit",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Alt-Up",
        "OnAction",
        function(self, host, source, ...)
          local panel = host:GetLastFocusedPanel()
          if panel == host.idItems then
            host:Op("GedOpTreeMoveItemUp", panel.context, panel:GetSelection())
          end
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "MoveDown",
        "ActionName",
        T(905406598513, "Move Down"),
        "ActionIcon",
        "CommonAssets/UI/Ged/down.tga",
        "ActionMenubar",
        "Edit",
        "ActionToolbar",
        "main",
        "ActionToolbarSplit",
        true,
        "ActionShortcut",
        "Alt-Down",
        "OnAction",
        function(self, host, source, ...)
          local panel = host:GetLastFocusedPanel()
          if panel == host.idItems then
            host:Op("GedOpTreeMoveItemDown", panel.context, panel:GetSelection())
          end
        end
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Cheats",
      "ActionName",
      T(501723542931, "Cheats"),
      "ActionMenubar",
      "main",
      "OnActionEffect",
      "popup"
    }, {
      PlaceObj("XTemplateTemplate", {
        "__template",
        "ModEditorCheats"
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "NewItem",
      "ActionName",
      T(727038768556, "New"),
      "ActionMenubar",
      "main",
      "OnActionEffect",
      "popup",
      "ActionContexts",
      {
        "ItemModPanelAction"
      }
    }, {
      PlaceObj("XTemplateCode", {
        "run",
        function(self, parent, context)
          local submenus = {}
          for i, item in ipairs(context.mod_items) do
            local submenu = item.EditorSubmenu
            if not submenu or submenu == "" then
              submenu = "Other"
            end
            if not submenus[submenu] then
              local items = {item}
              submenus[submenu] = items
              table.insert(submenus, submenu)
            else
              table.insert(submenus[submenu], item)
            end
          end
          table.sort(submenus)
          table.remove_entry(submenus, "Other")
          table.insert(submenus, "Other")
          for i, submenu in ipairs(submenus) do
            local items = submenus[submenu]
            local submenu_id = "new" .. submenu .. "Menu"
            local submenu_action = {
              ActionId = submenu_id,
              ActionName = Untranslated(submenu) .. "...",
              OnActionEffect = "popup",
              ActionMenubar = "NewItem"
            }
            XAction:new(submenu_action, parent, context, true)
            for i, item in ipairs(items) do
              local action = {
                ActionId = "new" .. item.Class,
                ActionName = Untranslated(item.EditorName or item.Class),
                ActionIcon = item.EditorIcon,
                ActionShortcut = item.EditorShortcut,
                ActionMenubar = submenu_id,
                OnAction = function(self, host, source)
                  host:Op("GedOpNewModItem", "root", item.Class)
                end
              }
              XAction:new(action, parent, context, true)
            end
          end
        end
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedTreePanel",
      "Id",
      "idItems",
      "Title",
      "Mod Items",
      "ActionContext",
      "ItemModPanelAction",
      "Format",
      "<EditorView>",
      "SelectionBind",
      "SelectedItem, SelectedObject"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "SelectedItem"
      end,
      "__class",
      "GedBindView",
      "BindView",
      "SubItems",
      "BindRoot",
      "root",
      "BindFunc",
      "GedDynamicItemsMenu",
      "ControlId",
      "idItems",
      "GetBindParams",
      function(self, control)
        return "ModItem", control:GetSelection()
      end,
      "OnViewChanged",
      function(self, value, control)
        RebuildSubItemsActions(control, value, "New Attribute", "main", "main")
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XPanelSizer"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "SelectedObject"
      end,
      "__class",
      "GedPropPanel",
      "Id",
      "idItemProperties",
      "MinWidth",
      300,
      "Title",
      "Item Properties",
      "RootObjectBindName",
      "SelectedItem"
    })
  })
})
