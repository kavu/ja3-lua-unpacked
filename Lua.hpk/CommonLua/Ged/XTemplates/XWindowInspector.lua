PlaceObj("XTemplate", {
  group = "GedApps",
  id = "XWindowInspector",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Title",
    "XWindow Inspector",
    "AppId",
    "XWindowInspector",
    "CommonActionsInMenubar",
    false,
    "CommonActionsInToolbar",
    false
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "RolloverMode",
      "ActionTranslate",
      false,
      "ActionName",
      "Rollover Mode",
      "ActionIcon",
      "CommonAssets/UI/Ged/rollover-mode.tga",
      "ActionToolbar",
      "main",
      "ActionToggle",
      true,
      "ActionToggled",
      function(self, host)
        return host.actions_toggled.RolloverMode
      end,
      "OnAction",
      function(self, host, source, ...)
        host.actions_toggled.RolloverMode = not host.actions_toggled.RolloverMode
        host:Send("GedRpcRolloverMode", host.actions_toggled.RolloverMode)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "InspectFocusedWindow",
      "ActionTranslate",
      false,
      "ActionName",
      "Inspect Focused Window",
      "ActionIcon",
      "CommonAssets/UI/Ged/view.tga",
      "ActionToolbar",
      "main",
      "ActionToolbarSplit",
      true,
      "OnAction",
      function(self, host, source, ...)
        host:Send("GedRpcInspectFocusedWindow")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "FocusLogging",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Focus Logging",
      "ActionIcon",
      "CommonAssets/UI/Ged/log-focused.tga",
      "ActionToolbar",
      "main",
      "ActionToggle",
      true,
      "ActionToggled",
      function(self, host)
        return host.actions_toggled.FocusLogging
      end,
      "OnAction",
      function(self, host, source, ...)
        host.actions_toggled.FocusLogging = not host.actions_toggled.FocusLogging
        host:Send("GedRpcToggleFocusLogging", host.actions_toggled.FocusLogging)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "RolloverLogging",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Rollover Logging",
      "ActionIcon",
      "CommonAssets/UI/Ged/log-mousetarget.tga",
      "ActionToolbar",
      "main",
      "ActionToggle",
      true,
      "ActionToggled",
      function(self, host)
        return host.actions_toggled.RolloverLogging
      end,
      "OnAction",
      function(self, host, source, ...)
        host.actions_toggled.RolloverLogging = not host.actions_toggled.RolloverLogging
        host:Send("GedRpcToggleRolloverLogging", host.actions_toggled.RolloverLogging)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ContextLogging",
      "ActionTranslate",
      false,
      "ActionName",
      "Toggle Context Logging",
      "ActionIcon",
      "CommonAssets/UI/Ged/log-dataset.tga",
      "ActionToolbar",
      "main",
      "ActionToolbarSplit",
      true,
      "ActionToggle",
      true,
      "ActionToggled",
      function(self, host)
        return host.actions_toggled.ContextLogging
      end,
      "OnAction",
      function(self, host, source, ...)
        host.actions_toggled.ContextLogging = not host.actions_toggled.ContextLogging
        host:Send("GedRpcToggleContextLogging", host.actions_toggled.ContextLogging)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "SetToW1",
      "ActionTranslate",
      false,
      "ActionName",
      "Set to _G.w1",
      "ActionIcon",
      "CommonAssets/UI/Ged/log-dataset.tga",
      "ActionToolbar",
      "main",
      "ActionToolbarSplit",
      true,
      "OnAction",
      function(self, host, source, ...)
        host:Send("GedRpcBindToGlobal", "SelectedWindow", "w1")
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "SelectedWindow"
      end,
      "__class",
      "GedBreadcrumbPanel",
      "Id",
      "idWindowPath",
      "Margins",
      box(0, 0, 0, 1),
      "Dock",
      "top",
      "Background",
      RGBA(232, 232, 232, 255),
      "Title",
      "",
      "DisplayWarnings",
      false,
      "FormatFunc",
      "GedGetXWindowPath",
      "TreePanelId",
      "idWindows"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedTreePanel",
      "Id",
      "idWindows",
      "Title",
      "XWindow Hierarchy",
      "DisplayWarnings",
      false,
      "ActionsClass",
      "PropertyObject",
      "Delete",
      "GedOpTreeDeleteItem",
      "Format",
      "<TreeView>",
      "SelectionBind",
      "SelectedWindow",
      "OnSelectionChanged",
      function(self, selection)
        self:Send("GedRpcFlashWindow", "SelectedWindow")
      end,
      "OnCtrlClick",
      function(self, selection)
        self:Send("GedRpcXWindowInspector", "SelectedWindow")
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return "root"
        end,
        "__class",
        "GedTextPanel",
        "Margins",
        box(0, 2, 0, 0),
        "Dock",
        "bottom",
        "Title",
        "",
        "DisplayWarnings",
        false,
        "FormatFunc",
        "GedThreadsPausedStatus"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XTextButton",
          "Id",
          "idPauseResume",
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
          RGBA(188, 137, 16, 255),
          "Background",
          RGBA(255, 255, 255, 0),
          "FocusedBorderColor",
          RGBA(188, 137, 16, 255),
          "OnPress",
          function(self, gamepad)
            local app = GetParentOfKind(self, "GedApp")
            app:Send("GedTogglePauseLuaThreads")
          end,
          "RolloverBackground",
          RGBA(255, 255, 255, 0),
          "RolloverBorderColor",
          RGBA(220, 165, 18, 255),
          "PressedBackground",
          RGBA(255, 255, 255, 0),
          "PressedBorderColor",
          RGBA(188, 137, 16, 255),
          "TextStyle",
          "GedHighlight",
          "Text",
          "Pause/resume threads"
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "OnContextUpdate(self, context, ...)",
          "func",
          function(self, context, ...)
            local text = self:GetTextToDisplay()
            self.idPauseResume:SetText(text:find("PAUSED") and "Resume threads" or "Pause threads")
            GedTextPanel.OnContextUpdate(self, context, ...)
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Dock",
        "bottom",
        "MinHeight",
        1,
        "MaxHeight",
        1,
        "Background",
        RGBA(128, 128, 128, 255)
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XPanelSizer"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "SelectedWindow"
      end,
      "__class",
      "GedPropPanel",
      "Id",
      "idProps",
      "Title",
      "Properties",
      "DisplayWarnings",
      false,
      "ActionsClass",
      "PropertyObject",
      "Copy",
      "GedOpPropertyCopy",
      "Paste",
      "GedOpPropertyPaste"
    })
  })
})
