PlaceObj("XTemplate", {
  __is_kind_of = "GedApp",
  group = "GedApps",
  id = "PresetEditTemplate",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Translate",
    true,
    "Title",
    "<PresetClass> Editor<opt(u(EditorShortcut),' (',')')>"
  }, {
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedTreePanel",
      "Id",
      "idPresets",
      "Title",
      "Items",
      "TitleFormatFunc",
      "GedFormatPresets",
      "SearchHistory",
      20,
      "SearchValuesAvailable",
      true,
      "PersistentSearch",
      true,
      "ActionsClass",
      "Preset",
      "Delete",
      "GedOpPresetDelete",
      "Cut",
      "GedOpPresetCut",
      "Copy",
      "GedOpPresetCopy",
      "Paste",
      "GedOpPresetPaste",
      "Duplicate",
      "GedOpPresetDuplicate",
      "ActionContext",
      "PresetsPanelAction",
      "SearchActionContexts",
      {
        "PresetsPanelAction",
        "PresetsChildAction"
      },
      "FormatFunc",
      "GedPresetTree",
      "Format",
      "<EditorView>",
      "FilterName",
      "PresetFilter",
      "SelectionBind",
      "SelectedPreset,SelectedObject",
      "MultipleSelection",
      true,
      "ItemClass",
      function(gedapp)
        return gedapp.PresetClass
      end,
      "RootActionContext",
      "PresetsPanelAction",
      "ChildActionContext",
      "PresetsChildAction"
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "bookmarks",
        "__context",
        function(parent, context)
          return "bookmarks"
        end,
        "__class",
        "GedTreePanel",
        "Id",
        "idBookmarks",
        "Dock",
        "bottom",
        "MaxHeight",
        350,
        "Collapsible",
        true,
        "StartsExpanded",
        true,
        "ExpandedMessage",
        "(press F2 to cycle)",
        "EmptyMessage",
        "(press Ctrl-F2 to bookmark)",
        "Title",
        "Bookmarks",
        "EnableSearch",
        false,
        "FormatFunc",
        "GedBookmarksTree",
        "Format",
        "<EditorView>",
        "SelectionBind",
        "SelectedPreset,SelectedObject,SelectedBookmark",
        "EmptyText",
        "Add a bookmark here by pressing Ctrl-F2.",
        "ChildActionContext",
        "BookmarksChildAction",
        "ShowToolbarButtons",
        false
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "Open(self, ...)",
          "func",
          function(self, ...)
            self.expanded = true
            GedTreePanel.Open(self, ...)
            self.connection:Send("rfnBindBookmarks", self.context, self.app.PresetClass)
          end
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "RemoveBookmark",
          "ActionTranslate",
          false,
          "ActionName",
          "Remove Bookmark",
          "OnAction",
          function(self, host, source, ...)
            host:Send("GedToggleBookmark", "SelectedBookmark", host.PresetClass)
          end,
          "ActionContexts",
          {
            "BookmarksChildAction"
          }
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "NextBookmark",
          "ActionTranslate",
          false,
          "ActionName",
          "Next Bookmark",
          "ActionShortcut",
          "F2",
          "OnAction",
          function(self, host, source, ...)
            local tree = host.idPresets.idBookmarks.idContainer
            local selection = tree:GetSelection()
            if not selection then
              tree:SetSelection({1})
            else
              tree:OnShortcut("Down")
              local new_selection = tree:GetSelection()
              if ValueToLuaCode(selection) == ValueToLuaCode(new_selection) then
                tree:SetSelection({1})
              end
            end
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "preset filter panel",
        "__context",
        function(parent, context)
          return "PresetFilter"
        end,
        "__class",
        "GedPropPanel",
        "Dock",
        "bottom",
        "Visible",
        false,
        "FoldWhenHidden",
        true,
        "Collapsible",
        true,
        "Title",
        "<FilterName>",
        "EnableSearch",
        false,
        "DisplayWarnings",
        false,
        "EnableUndo",
        false,
        "EnableCollapseDefault",
        false,
        "EnableShowInternalNames",
        false,
        "EnableCollapseCategories",
        false,
        "HideFirstCategory",
        true
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "see Preset:GetPresetStatusText",
        "__context",
        function(parent, context)
          return "SelectedPreset"
        end,
        "__class",
        "GedTextPanel",
        "Id",
        "idStatusBar",
        "Margins",
        box(2, 2, 2, 0),
        "Padding",
        box(2, 0, 1, 0),
        "Dock",
        "bottom",
        "FoldWhenHidden",
        true,
        "Title",
        "",
        "DisplayWarnings",
        false,
        "FormatFunc",
        "GedPresetStatusText"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XToggleButton",
          "Id",
          "idViewErrorsOnly",
          "Margins",
          box(2, 2, 2, 2),
          "BorderWidth",
          1,
          "Padding",
          box(2, 0, 2, 0),
          "Dock",
          "right",
          "VAlign",
          "center",
          "LayoutMethod",
          "VList",
          "BorderColor",
          RGBA(0, 0, 0, 0),
          "OnPress",
          function(self, gamepad)
            XToggleButton.OnPress(self, gamepad)
            local root_panel = GetParentOfKind(self, "GedTreePanel")
            local mode = not root_panel.view_errors_only
            root_panel:SetViewErrorsOnly(mode)
          end,
          "PressedBackground",
          RGBA(160, 160, 160, 255),
          "TextStyle",
          "GedError",
          "Text",
          "Errors only",
          "ToggledBackground",
          RGBA(40, 43, 48, 255),
          "ToggledBorderColor",
          RGBA(240, 0, 0, 255)
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XToggleButton",
          "Id",
          "idViewWarningsOnly",
          "Margins",
          box(2, 2, 2, 2),
          "BorderWidth",
          1,
          "Padding",
          box(2, 0, 2, 0),
          "Dock",
          "right",
          "VAlign",
          "center",
          "LayoutMethod",
          "VList",
          "BorderColor",
          RGBA(0, 0, 0, 0),
          "OnPress",
          function(self, gamepad)
            XToggleButton.OnPress(self, gamepad)
            local root_panel = GetParentOfKind(self, "GedTreePanel")
            local mode = not root_panel.view_warnings_only
            root_panel:SetViewWarningsOnly(mode)
          end,
          "PressedBackground",
          RGBA(160, 160, 160, 255),
          "TextStyle",
          "GedWarning",
          "Text",
          "Warnings only",
          "ToggledBackground",
          RGBA(40, 43, 48, 255),
          "ToggledBorderColor",
          RGBA(255, 140, 0, 255)
        }),
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return "SelectedPreset"
          end,
          "__class",
          "GedBindView",
          "BindView",
          "warning_error_count",
          "BindFunc",
          "GedPresetWarningsErrors",
          "OnViewChanged",
          function(self, value, control)
            local errsButton = self:ResolveId("idViewErrorsOnly")
            if errsButton then
              errsButton:SetVisible(value ~= 0)
            end
            local warnsButton = self:ResolveId("idViewWarningsOnly")
            if warnsButton then
              warnsButton:SetVisible(value ~= 0)
            end
            if value == 0 then
              GetParentOfKind(self, "GedTreePanel"):SetViewWarningsOnly(false)
              GetParentOfKind(self, "GedTreePanel"):SetViewErrorsOnly(false)
            end
          end
        })
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "File",
      "ActionName",
      T(923464262345, "File"),
      "ActionMenubar",
      "main",
      "OnActionEffect",
      "popup"
    }, {
      PlaceObj("XTemplateAction", {
        "ActionId",
        "idNews",
        "ActionName",
        T(689845029747, "New"),
        "ActionIcon",
        "CommonAssets/UI/Ged/new.tga",
        "ActionToolbar",
        "main",
        "OnActionEffect",
        "popup"
      }, {
        PlaceObj("XTemplateForEach", {
          "array",
          function(parent, context)
            return context.Classes
          end,
          "run_after",
          function(child, context, item, i, n, last)
            child.ActionId = "New" .. item
            child.ActionName = "New " .. item
            child.ActionTranslate = false
            function child:OnAction(host)
              host:Op("GedOpNewPreset", "root", host.idPresets:GetSelection(), item)
            end
          end
        }, {
          PlaceObj("XTemplateAction", {
            "ActionIcon",
            "CommonAssets/UI/Ged/new.tga",
            "ActionContexts",
            {
              "PresetsPanelAction"
            }
          })
        })
      }),
      PlaceObj("XTemplateCode", {
        "comment",
        "-- If single \"new\" action, move to top level",
        "run",
        function(self, parent, context)
          local newAction = parent:ActionById("idNews")
          local subitemActions = table.ifilter(parent:GetActions(), function(k, action)
            return action.ActionMenubar == "idNews"
          end)
          if #subitemActions == 1 then
            subitemActions[1]:SetActionMenubar(newAction.ActionMenubar)
            subitemActions[1]:SetActionToolbar("main")
            parent:RemoveAction(newAction)
          end
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "SavePreset",
        "ActionName",
        T(710972932371, "Save"),
        "ActionIcon",
        "CommonAssets/UI/Ged/save.tga",
        "ActionToolbar",
        "main",
        "ActionToolbarSplit",
        true,
        "ActionShortcut",
        "Ctrl-S",
        "OnAction",
        function(self, host, source, ...)
          host:OnSaving()
          host:Send("GedPresetSave", "SelectedPreset", host.PresetClass)
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "SavePresetForce",
        "ActionName",
        T(430241313051, "Force Save All"),
        "ActionIcon",
        "CommonAssets/UI/Ged/save.tga",
        "ActionShortcut",
        "Ctrl-Shift-S",
        "OnAction",
        function(self, host, source, ...)
          host:OnSaving()
          host:Send("GedPresetSave", "SelectedPreset", host.PresetClass, "force_save_all")
        end
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "SVNShowLog",
        "ActionTranslate",
        false,
        "ActionName",
        "SVN Show Log",
        "OnAction",
        function(self, host, source, ...)
          host:Op("GedOpSVNShowLog", "SelectedPreset")
        end,
        "ActionContexts",
        {
          "PresetsChildAction"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "SVNShowDiff",
        "ActionTranslate",
        false,
        "ActionName",
        "SVN Diff",
        "OnAction",
        function(self, host, source, ...)
          host:Op("GedOpSVNShowDiff", "SelectedPreset")
        end,
        "ActionContexts",
        {
          "PresetsChildAction"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "SVNShowBlame",
        "ActionTranslate",
        false,
        "ActionName",
        "SVN Blame",
        "OnAction",
        function(self, host, source, ...)
          host:Op("GedOpSVNShowBlame", "SelectedPreset")
        end,
        "ActionContexts",
        {
          "PresetsChildAction"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "LocatePreset",
        "ActionTranslate",
        false,
        "ActionName",
        "Find preset references",
        "OnAction",
        function(self, host, source, ...)
          host:Op("GedOpLocatePreset", "SelectedPreset")
        end,
        "ActionContexts",
        {
          "PresetsChildAction"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "GoToNext",
        "ActionTranslate",
        false,
        "ActionName",
        "Next reference",
        "ActionShortcut",
        "Ctrl-G",
        "OnAction",
        function(self, host, source, ...)
          host:Op("GedOpGoToNext", "SelectedPreset")
        end,
        "ActionContexts",
        {
          "PresetsChildAction"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "AddRemoveBookmark",
        "ActionTranslate",
        false,
        "ActionName",
        "Add / Remove Bookmark",
        "ActionIcon",
        "CommonAssets/UI/Ged/bookmark_icon",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Ctrl-F2",
        "OnAction",
        function(self, host, source, ...)
          host:Send("GedToggleBookmark", "SelectedPreset", host.PresetClass)
        end,
        "ActionContexts",
        {
          "PresetsChildAction"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "ToggleDisplayWarnings",
        "ActionTranslate",
        false,
        "ActionName",
        "Toggle Display Warnings",
        "ActionIcon",
        "CommonAssets/UI/Ged/exclamation.tga",
        "ActionToolbar",
        "main",
        "ActionToolbarSplit",
        true,
        "ActionShortcut",
        "Ctrl-W",
        "ActionToggle",
        true,
        "ActionToggled",
        function(self, host)
          return host.actions_toggled.ToggleDisplayWarnings
        end,
        "OnAction",
        function(self, host, source, ...)
          host:SetActionToggled("ToggleDisplayWarnings", not host.actions_toggled.ToggleDisplayWarnings)
          for _, panel in ipairs(host.all_panels) do
            if IsKindOf(panel, "GedPropPanel") or IsValid(panel) then
              local display_warnings = not host.actions_toggled.ToggleDisplayWarnings
              panel:SetDisplayWarnings(display_warnings)
              if not display_warnings then
                panel:UnbindView("warning")
                panel.idWarningText:SetVisible(false)
              else
                panel:BindView("warning", "GedGetWarning")
              end
            end
          end
        end
      })
    }),
    PlaceObj("XTemplateCode", {
      "comment",
      "-- Custom Editor Actions",
      "run",
      function(self, parent, context)
        local has_toggle_actions = false
        for func_name, data in sorted_pairs(context.EditorCustomActions or empty_table) do
          if type(func_name) ~= "string" then
            func_name = data.FuncName
          end
          if type(func_name) ~= "string" or func_name == "" then
            func_name = false
          end
          local action = XAction:new({
            ActionId = data.Name,
            ActionName = data.Name or "Unnamed",
            ActionTranslate = false,
            ActionToggle = data.IsToggledFuncName,
            ActionShortcut = data.Shortcut or "",
            ActionMenubar = data.Menubar,
            ActionToolbar = data.Toolbar or "",
            ActionIcon = data.Icon or "CommonAssets/UI/Ged/cog.tga",
            ActionSortKey = data.SortKey or "10000",
            RolloverText = data.Rollover
          }, parent)
          if func_name then
            function action:OnAction(host)
              if data.IsToggledFuncName then
                parent.actions_toggled[data.Name] = not parent.actions_toggled[data.Name]
              end
              host:Send("GedCustomEditorAction", "SelectedPreset", func_name)
            end
          else
            action.OnActionEffect = "popup"
          end
          if data.IsToggledFuncName then
            has_toggle_actions = true
            function action:ActionToggled(host)
              return host.actions_toggled[data.Name]
            end
          end
        end
        if has_toggle_actions then
          CreateRealTimeThread(function()
            for _, data in sorted_pairs(context.EditorCustomActions or empty_table) do
              if data.IsToggledFuncName then
                parent.actions_toggled[data.Name] = parent:Call("GedGetToggledActionState", data.IsToggledFuncName)
              end
            end
            parent:ActionsUpdated()
          end)
        end
      end
    }),
    PlaceObj("XTemplateCode", {
      "comment",
      "-- Setup preset filter, alt format",
      "run",
      function(self, parent, context)
        parent.idPresets.FilterClass = parent.FilterClass
        parent.idPresets.AltFormat = parent.AltFormat
      end
    })
  })
})
