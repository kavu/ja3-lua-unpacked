PlaceObj("XTemplate", {
  group = "GedApps",
  id = "ModManager",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Translate",
    true,
    "Title",
    "Mods Manager",
    "AppId",
    "ModManager"
  }, {
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedListPanel",
      "Id",
      "idMods",
      "Title",
      "Mods",
      "ActionContext",
      "PanelActions",
      "Format",
      "<EditorView>",
      "OnDoubleClick",
      function(self, item_idx)
        self.parent:Op("GedOpEditMod", self.context, item_idx)
      end,
      "ItemActionContext",
      "ChildActions"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XPanelSizer"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "log"
      end,
      "__class",
      "GedMultiLinePanel",
      "Id",
      "idMessageLog",
      "Title",
      "Messages",
      "FormatFunc",
      "GedModMessageLog"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "File",
      "ActionName",
      T(546151333667, "File"),
      "ActionMenubar",
      "main",
      "OnActionEffect",
      "popup"
    }, {
      PlaceObj("XTemplateAction", {
        "ActionId",
        "New",
        "ActionName",
        T(687867043540, "New Mod"),
        "ActionIcon",
        "CommonAssets/UI/Ged/new.tga",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Ctrl-N",
        "OnAction",
        function(self, host, source, ...)
          host:Op("GedOpNewMod", host.idMods.context)
        end,
        "ActionContexts",
        {
          "ChildActions"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Load",
        "ActionName",
        T(719213652871, "Load"),
        "ActionIcon",
        "CommonAssets/UI/Ged/play.tga",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Ctrl-L",
        "OnAction",
        function(self, host, source, ...)
          local panel = host.idMods
          if panel:GetSelection() then
            host:Op("GedOpLoadMod", panel.context, panel:GetSelection())
          end
        end,
        "ActionContexts",
        {
          "ChildActions"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Unload",
        "ActionName",
        T(814896034284, "Unload"),
        "ActionIcon",
        "CommonAssets/UI/Ged/undo.tga",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Ctrl-U",
        "OnAction",
        function(self, host, source, ...)
          local panel = host.idMods
          if panel:GetSelection() then
            host:Op("GedOpUnloadMod", panel.context, panel:GetSelection())
          end
        end,
        "ActionContexts",
        {
          "ChildActions"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Edit",
        "ActionName",
        T(865079172599, "Edit"),
        "ActionIcon",
        "CommonAssets/UI/Ged/preview.tga",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Ctrl-E",
        "OnAction",
        function(self, host, source, ...)
          local panel = host.idMods
          if panel:GetSelection() then
            host:Op("GedOpEditMod", panel.context, panel:GetSelection())
          end
        end,
        "ActionContexts",
        {
          "ChildActions"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Delete",
        "ActionName",
        T(954766070707, "Delete Mod"),
        "ActionIcon",
        "CommonAssets/UI/Ged/delete.tga",
        "ActionToolbar",
        "main",
        "ActionShortcut",
        "Shift-Delete",
        "OnAction",
        function(self, host, source, ...)
          local panel = host.idMods
          if panel:GetSelection() then
            host:Op("GedOpRemoveMod", panel.context, panel:GetSelection())
          end
        end,
        "ActionContexts",
        {
          "ChildActions"
        }
      }),
      PlaceObj("XTemplateAction", {
        "ActionId",
        "Exit",
        "ActionName",
        T(871800305287, "Exit"),
        "OnAction",
        function(self, host, source, ...)
          host:Exit()
        end
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Cheats",
      "ActionName",
      T(580953171470, "Cheats"),
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
      "Help",
      "ActionName",
      T(515768319493, "Help"),
      "ActionIcon",
      "CommonAssets/UI/Ged/help.tga",
      "ActionMenubar",
      "main",
      "ActionToolbar",
      "main",
      "ActionShortcut",
      "F1",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpHelpMod", host.idMods.context)
      end
    })
  })
})
