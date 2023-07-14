PlaceObj("XTemplate", {
  group = "GedApps",
  id = "GedAutoAttachEditor",
  save_in = "Ged",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "PresetEditor"
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "NewInheritRule",
      "ActionSortKey",
      "2",
      "ActionName",
      T(209925725660, "New inherit rule"),
      "ActionIcon",
      "CommonAssets/UI/Ged/create_reference_images",
      "ActionMenubar",
      "main",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        local panel = host.idPresetContent
        host:Op("GedOpTreeNewItemInContainer", "SelectedPreset", panel:GetSelection(), "AutoAttachRuleInherit")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "NewRule",
      "ActionSortKey",
      "2",
      "ActionName",
      T(482590603919, "New rule"),
      "ActionIcon",
      "CommonAssets/UI/Ged/new",
      "ActionMenubar",
      "main",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        local panel = host.idPresetContent
        host:Op("GedOpTreeNewItemInContainer", "SelectedPreset", panel:GetSelection(), "AutoAttachRule")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "View",
      "ActionSortKey",
      "2",
      "ActionName",
      T(856192592411, "View Demo Object"),
      "ActionIcon",
      "CommonAssets/UI/Ged/view.tga",
      "ActionMenubar",
      "main",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:InvokeMethod("SelectedPreset", "ViewDemoObject")
      end,
      "ActionContexts",
      {
        "PresetsChildAction"
      }
    }),
    PlaceObj("XTemplateCode", {
      "comment",
      "Hide presets panel if lock_preset is true",
      "run",
      function(self, parent, context)
        if context.lock_preset then
          parent.idPresets:SetVisible(false)
          parent.idPresets:SetDock("ignore")
        end
      end
    }),
    PlaceObj("XTemplateCode", {
      "comment",
      "Disable ops in left panel & on middle panel root items",
      "run",
      function(self, parent, context)
        parent.idPresets.Cut = ""
        parent.idPresets.Copy = ""
        parent.idPresets.Paste = ""
        parent.idPresets.Duplicate = ""
        parent.idPresets.Delete = ""
        parent.idPresetContent.EnableForRootLevelItems = false
        function parent.idPresetContent.ItemClass()
          return "AutoAttachRuleBase"
        end
      end
    })
  })
})
