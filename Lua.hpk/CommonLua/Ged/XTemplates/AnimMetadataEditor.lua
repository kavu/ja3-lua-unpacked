PlaceObj("XTemplate", {
  group = "Common",
  id = "AnimMetadataEditor",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "MinWidth",
    800,
    "MinHeight",
    600,
    "Title",
    "Anim Metadata Editor",
    "AppId",
    "AnimMetadataEditor",
    "InitialWidth",
    800,
    "InitialHeight",
    600
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ThreeQuarters",
      "ActionName",
      T(894575298305, "3/4 Camera"),
      "ActionIcon",
      "CommonAssets/UI/Ged/center.tga",
      "ActionToolbar",
      "main",
      "ActionShortcut",
      "Ctrl-1",
      "OnAction",
      function(self, host, source, ...)
        local panel = host:GetLastFocusedPanel()
        host:Op("GedOpCharacterCamThreeQuarters", "root", panel and panel.context)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ClosestCamera",
      "ActionName",
      T(359840842466, "Closest Camera"),
      "ActionIcon",
      "CommonAssets/UI/Ged/camera.tga",
      "ActionToolbar",
      "main",
      "ActionToolbarSplit",
      true,
      "ActionShortcut",
      "Ctrl-2",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpCharacterCamClosest", "root")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Play",
      "ActionName",
      T(559840604851, "Play"),
      "ActionIcon",
      "CommonAssets/UI/Ged/play.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        local panel = host:GetLastFocusedPanel()
        host:Op("GedOpAnimMetadataEditorPlay", "root", panel and panel.context)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Pause",
      "ActionName",
      T(935415793424, "Pause"),
      "ActionIcon",
      "CommonAssets/UI/Ged/pause.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        local panel = host:GetLastFocusedPanel()
        host:Op("GedOpAnimMetadataEditorStop", "root", panel and panel.context)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Loop",
      "ActionName",
      T(767188814770, "Loop"),
      "ActionIcon",
      "CommonAssets/UI/Ged/undo.tga",
      "ActionToolbar",
      "main",
      "ActionToolbarSplit",
      true,
      "OnAction",
      function(self, host, source, ...)
        local panel = host:GetLastFocusedPanel()
        host:Op("GedOpAnimMetadataEditorToggleLoop", "root", panel and panel.context)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Save",
      "ActionName",
      T(841740040948, "Save"),
      "ActionIcon",
      "CommonAssets/UI/Ged/save.tga",
      "ActionToolbar",
      "main",
      "ActionShortcut",
      "Ctrl-S",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpSaveAnimMetadata", "root")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "AppearanceEditor",
      "ActionName",
      T(406804987029, "Appearance Editor"),
      "ActionIcon",
      "CommonAssets/UI/Ged/character.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpOpenAppearanceEditor", "root")
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedPropPanel",
      "Id",
      "idEntity",
      "MinWidth",
      300,
      "LayoutMethod",
      "HPanel",
      "Title",
      "Animation Viewer",
      "EnableUndo",
      false,
      "EnableCollapseDefault",
      false,
      "EnableShowInternalNames",
      false,
      "EnableCollapseCategories",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XPanelSizer"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "Animations"
      end,
      "__class",
      "GedTreePanel",
      "Id",
      "idAnimations",
      "Title",
      "AnimMetadata Presets",
      "TitleFormatFunc",
      "GedFormatPresets",
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
      "SelectionBind",
      "AnimationMetadata",
      "MultipleSelection",
      true,
      "RootActionContext",
      "PresetsPanelAction",
      "ChildActionContext",
      "PresetsChildAction"
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "see Preset:GetPresetStatusText",
        "__context",
        function(parent, context)
          return "AnimationMetadata"
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
            return "AnimationMetadata"
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
    PlaceObj("XTemplateWindow", {
      "__class",
      "XPanelSizer"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "AnimationMetadata"
      end,
      "__class",
      "GedPropPanel",
      "Id",
      "idAnimMetadata",
      "MinWidth",
      300,
      "LayoutMethod",
      "HPanel",
      "Title",
      "Properties",
      "ActionsClass",
      "PropertyObject"
    })
  })
})
