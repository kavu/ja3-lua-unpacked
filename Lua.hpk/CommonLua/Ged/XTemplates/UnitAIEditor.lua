PlaceObj("XTemplate", {
  group = "GedApps",
  id = "UnitAIEditor",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Translate",
    true,
    "Title",
    "UnitAI Editor",
    "InitialWidth",
    1200,
    "InitialHeight",
    600
  }, {
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedTreePanel",
      "Id",
      "idPrgs",
      "MinWidth",
      200,
      "Title",
      "Program",
      "ActionContext",
      "PrgsPanelAction",
      "SearchActionContexts",
      {
        "PrgsPanelAction"
      },
      "FormatFunc",
      "GedPresetTree",
      "Format",
      "<EditorView>",
      "SelectionBind",
      "SelectedPrg,SelectedObject,SelectedPrg2",
      "MultipleSelection",
      true,
      "RootActionContext",
      "PrgsRootAction",
      "ChildActionContext",
      "PrgsChildAction"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XPanelSizer"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "SelectedPrg"
      end,
      "__class",
      "GedTreePanel",
      "Id",
      "idCommands",
      "Title",
      "Commands",
      "ActionContext",
      "CommandPanelAction",
      "SearchActionContexts",
      {
        "CommandPanelAction"
      },
      "Format",
      "<TreeView>",
      "SelectionBind",
      "SelectedObject",
      "MultipleSelection",
      true,
      "RootActionContext",
      "CommandRootAction",
      "ChildActionContext",
      "CommandChildAction"
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
      "idProps",
      "Title",
      "Properties",
      "ActionContext",
      "PropAction",
      "SearchActionContexts",
      {"PropAction"},
      "RootObjectBindName",
      "SelectedPrg",
      "PropActionContext",
      "PropAction"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XPanelSizer"
    }),
    PlaceObj("XTemplateWindow", {
      "Id",
      "idLuaContainer"
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "Lua exported code",
        "__context",
        function(parent, context)
          return "SelectedPrg"
        end,
        "__class",
        "GedMultiLinePanel",
        "Id",
        "idLuaCode",
        "MinWidth",
        400,
        "HandleKeyboard",
        false,
        "Title",
        "Lua",
        "Format",
        "<def(Code,'')>"
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "BindViews(self, ...)",
          "func",
          function(self, ...)
            GedMultiLinePanel.BindViews(self)
            if not self:BindView("error_line", "GedFormatXPrgError") then
              self:BindView("code_selection", "GedFormatXPrgCodeSelection")
            end
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "OnKillFocus(self, ...)",
          "func",
          function(self, ...)
            if self.window_state == "destroying" then
              return
            end
            if not self:SelectError() then
              self:SelectCommandCode()
            end
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "OnContextUpdate(self, context, view)",
          "func",
          function(self, context, view)
            GedMultiLinePanel.OnContextUpdate(self, context, view)
            if not self:SelectError() then
              self:SelectCommandCode()
            end
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "SelectError(self)",
          "func",
          function(self)
            local line = tonumber(self:Obj(self.context .. "|error_line"))
            if line then
              self.idContainer:SetCursor(line, 0)
              self.idContainer:SetCursor(line, 10000, true)
              self.idContainer:ScrollCursorIntoView()
              return true
            end
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "SelectCommandCode(self)",
          "func",
          function(self)
            local code = self:Obj(self.context .. "|code_selection")
            if code and code[1] and code[2] then
              self.idContainer:SetCursor(code[1], 0)
              self.idContainer:SetCursor(code[2], 10000, true)
              self.idContainer:ScrollCursorIntoView()
              return true
            end
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return "SelectedPrg2"
        end,
        "__class",
        "GedMultiLinePanel",
        "Id",
        "idLuaError",
        "Dock",
        "bottom",
        "MinWidth",
        400,
        "FoldWhenHidden",
        true,
        "HandleKeyboard",
        false,
        "Title",
        "Lua",
        "Format",
        "<def(Error,'')>"
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "OnContextUpdate(self, context, view)",
          "func",
          function(self, context, view)
            GedMultiLinePanel.OnContextUpdate(self, context, view)
            self:SetVisible(#self.idContainer:GetText() > 0)
          end
        })
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "File",
      "ActionName",
      T(948732019662, "File"),
      "ActionMenubar",
      "main",
      "OnActionEffect",
      "popup"
    }, {
      PlaceObj("XTemplateAction", {
        "ActionId",
        "NewPrg",
        "ActionName",
        T(556464891609, "New Prg"),
        "ActionIcon",
        "CommonAssets/UI/Ged/new.tga",
        "ActionToolbar",
        "main",
        "OnAction",
        function(self, host, source, ...)
          host:Op("GedOpNewPreset", "root", host.idPrgs:GetSelection(), host.PresetClass)
        end,
        "ActionContexts",
        {
          "PrgsRootAction",
          "PrgsPanelAction"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "SavePrg",
        "ActionName",
        T(162535700852, "Save"),
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
          host:Send("GedPresetSave", "SelectedPrg", host.PresetClass)
        end,
        "ActionContexts",
        {
          "PrgsChildAction",
          "CommandChildAction",
          "CommandRootAction"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "ForceSaveAllPrg",
        "ActionName",
        T(434679393664, "Force Save All"),
        "ActionIcon",
        "CommonAssets/UI/Ged/save.tga",
        "ActionShortcut",
        "Ctrl-Shift-S",
        "OnAction",
        function(self, host, source, ...)
          host:OnSaving()
          host:Send("GedPresetSave", "SelectedPrg", host.PresetClass, "force_save_all")
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
          host:Op("GedOpSVNShowLog", "SelectedPrg")
        end,
        "ActionContexts",
        {
          "PrgsChildAction"
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
          host:Op("GedOpSVNShowDiff", "SelectedPrg")
        end,
        "ActionContexts",
        {
          "PrgsChildAction"
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
          host:Op("GedOpSVNShowBlame", "SelectedPrg")
        end,
        "ActionContexts",
        {
          "PrgsChildAction"
        }
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Edit",
      "ActionName",
      T(865980146926, "Edit"),
      "ActionMenubar",
      "main",
      "OnActionEffect",
      "popup"
    }, {
      PlaceObj("XTemplateAction", {
        "ActionId",
        "MoveUp",
        "ActionName",
        T(185621365384, "Move Up"),
        "ActionIcon",
        "CommonAssets/UI/Ged/up.tga",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Alt-Up",
        "OnAction",
        function(self, host, source, ...)
          local panel = host:GetLastFocusedPanel()
          if panel == host.idCommands then
            host:Op("GedOpTreeMoveItemUp", panel.context, panel:GetMultiSelection())
          end
        end,
        "ActionContexts",
        {
          "CommandChildAction",
          "CommandRootAction"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "MoveDown",
        "ActionName",
        T(111040886672, "Move Down"),
        "ActionIcon",
        "CommonAssets/UI/Ged/down.tga",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Alt-Down",
        "OnAction",
        function(self, host, source, ...)
          local panel = host:GetLastFocusedPanel()
          if panel == host.idCommands then
            host:Op("GedOpTreeMoveItemDown", panel.context, panel:GetMultiSelection())
          end
        end,
        "ActionContexts",
        {
          "CommandChildAction",
          "CommandRootAction"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "MoveOutwards",
        "ActionName",
        T(984343171402, "Move Out"),
        "ActionIcon",
        "CommonAssets/UI/Ged/left.tga",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Alt-Left",
        "OnAction",
        function(self, host, source, ...)
          local panel = host:GetLastFocusedPanel()
          if panel == host.idCommands then
            host:Op("GedOpTreeMoveItemOutwards", panel.context, panel:GetMultiSelection())
          end
        end,
        "ActionContexts",
        {
          "CommandChildAction",
          "CommandRootAction"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "MoveInwards",
        "ActionName",
        T(346253453974, "Move In"),
        "ActionIcon",
        "CommonAssets/UI/Ged/right.tga",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Alt-Right",
        "OnAction",
        function(self, host, source, ...)
          local panel = host:GetLastFocusedPanel()
          if panel == host.idCommands then
            host:Op("GedOpTreeMoveItemInwards", panel.context, panel:GetSelection())
          end
        end,
        "ActionContexts",
        {
          "CommandChildAction",
          "CommandRootAction"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Delete",
        "ActionName",
        T(116422019899, "Delete"),
        "ActionIcon",
        "CommonAssets/UI/Ged/delete.tga",
        "ActionToolbar",
        "main",
        "ActionToolbarSplit",
        true,
        "ActionShortcut",
        "Delete",
        "OnAction",
        function(self, host, source, ...)
          local panel = host:GetLastFocusedPanel()
          if panel == host.idPrgs then
            host:Op("GedOpPresetDelete", panel.context, panel:GetMultiSelection())
          elseif panel == host.idCommands then
            host:Op("GedOpTreeDeleteItem", panel.context, panel:GetMultiSelection())
          end
        end,
        "ActionContexts",
        {
          "PrgsChildAction",
          "CommandChildAction",
          "CommandRootAction"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionName",
        T(205229988402, "-----")
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Undo",
        "ActionName",
        T(586638531914, "Undo"),
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
        T(337422381388, "Redo"),
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
        T(205229988402, "-----")
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Cut",
        "ActionName",
        T(661644791099, "Cut"),
        "ActionIcon",
        "CommonAssets/UI/Ged/cut.tga",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Ctrl-X",
        "OnAction",
        function(self, host, source, ...)
          local panel = host:GetLastFocusedPanel()
          if panel == host.idPrgs then
            host:Op("GedOpPresetCut", panel.context, panel:GetMultiSelection(), "XPrg")
          elseif panel == host.idCommands then
            host:Op("GedOpTreeCut", panel.context, panel:GetMultiSelection(), "XPrgCommand")
          end
        end,
        "ActionContexts",
        {
          "PrgsChildAction",
          "CommandChildAction",
          "CommandRootAction"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Copy",
        "ActionName",
        T(410671052718, "Copy"),
        "ActionIcon",
        "CommonAssets/UI/Ged/copy.tga",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Ctrl-C",
        "OnAction",
        function(self, host, source, ...)
          local panel = host:GetLastFocusedPanel()
          if panel == host.idPrgs then
            host:Op("GedOpPresetCopy", panel.context, panel:GetMultiSelection(), "XPrg")
          elseif panel == host.idCommands then
            host:Op("GedOpTreeCopy", panel.context, panel:GetMultiSelection(), "XPrgCommand")
          elseif panel:IsKindOf("GedPropPanel") then
            self:Op("GedOpPropertyCopy", panel.context, panel:GetSelectedProperties(), panel.context)
          end
        end,
        "ActionContexts",
        {
          "PropAction",
          "PrgsChildAction",
          "CommandRootAction"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Paste",
        "ActionName",
        T(161980212288, "Paste"),
        "ActionIcon",
        "CommonAssets/UI/Ged/paste.tga",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Ctrl-V",
        "OnAction",
        function(self, host, source, ...)
          local panel = host:GetLastFocusedPanel()
          if panel == host.idPrgs then
            host:Op("GedOpPresetPaste", panel.context, panel:GetMultiSelection(), "XPrg")
          elseif panel == host.idCommands then
            host:Op("GedOpTreePaste", panel.context, panel:GetMultiSelection(), "XPrgCommand")
          elseif panel:IsKindOf("GedPropPanel") then
            self:Op("GedOpPropertyPaste", panel.context)
          end
        end,
        "ActionContexts",
        {
          "PropAction",
          "PrgsChildAction",
          "CommandRootAction"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Duplicate",
        "ActionName",
        T(813358135659, "Duplicate"),
        "ActionIcon",
        "CommonAssets/UI/Ged/duplicate.tga",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Ctrl-D",
        "OnAction",
        function(self, host, source, ...)
          local panel = host:GetLastFocusedPanel()
          if panel == host.idPrgs then
            host:Op("GedOpPresetDuplicate", panel.context, panel:GetMultiSelection())
          elseif panel == host.idCommands then
            host:Op("GedOpTreeDuplicate", panel.context, panel:GetMultiSelection())
          end
        end,
        "ActionContexts",
        {
          "PrgsChildAction",
          "CommandChildAction",
          "CommandRootAction"
        }
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Prg",
      "ActionName",
      T(520146974925, "Prg"),
      "ActionMenubar",
      "main",
      "OnActionEffect",
      "popup",
      "ActionContexts",
      {
        "CommandPanelAction"
      }
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Condition",
      "ActionName",
      T(885408776889, "Condition"),
      "ActionMenubar",
      "main",
      "ActionToolbarSplit",
      true,
      "OnActionEffect",
      "popup",
      "ActionContexts",
      {
        "CommandPanelAction"
      }
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Object",
      "ActionName",
      T(925998964504, "Object"),
      "ActionMenubar",
      "main",
      "OnActionEffect",
      "popup",
      "ActionContexts",
      {
        "CommandPanelAction"
      }
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Move",
      "ActionName",
      T(128715807740, "Move"),
      "ActionMenubar",
      "main",
      "OnActionEffect",
      "popup",
      "ActionContexts",
      {
        "CommandPanelAction"
      }
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Execute",
      "ActionName",
      T(106465668170, "Execute"),
      "ActionMenubar",
      "main",
      "OnActionEffect",
      "popup",
      "ActionContexts",
      {
        "CommandPanelAction"
      }
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Define",
      "ActionName",
      T(223759203414, "Define"),
      "ActionMenubar",
      "main",
      "OnActionEffect",
      "popup",
      "ActionContexts",
      {
        "CommandPanelAction"
      }
    }),
    PlaceObj("XTemplateCode", {
      "run",
      function(self, parent, context)
        PrgEditorBuildMenuCommands(parent, "XPrgUnitAICommand")
        PrgEditorBuildMenuCommands(parent, "XPrgBasicCommand")
      end
    })
  })
})
