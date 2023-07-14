PlaceObj("XTemplate", {
  group = "GedApps",
  id = "SoundEditor",
  save_in = "Ged",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "PresetEditor",
    "Title",
    "Sound Bank Editor"
  }, {
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "stats"
      end,
      "__parent",
      function(parent, context)
        return parent.idProps
      end,
      "__class",
      "GedPropPanel",
      "Id",
      "SoundPresetInfo",
      "Dock",
      "bottom",
      "Title",
      "Stats",
      "EnableSearch",
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
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Play",
      "ActionSortKey",
      "2",
      "ActionName",
      T(438032542247, "Play"),
      "ActionIcon",
      "CommonAssets/UI/Ged/play.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Send("GedPlaySoundPreset")
      end,
      "ActionContexts",
      {
        "PresetsChildAction",
        "PresetsPanelAction",
        "ContentPanelAction"
      }
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "NewSample",
      "ActionSortKey",
      "2",
      "ActionName",
      T(871289136594, "New Sample"),
      "ActionIcon",
      "CommonAssets/UI/Ged/steam.tga",
      "ActionToolbar",
      "main",
      "OnActionParam",
      "Sample",
      "OnAction",
      function(self, host, source, ...)
        local panel = host.idPresetContent
        host:Op("GedOpListNewItem", panel.context, panel:GetSelection(), self.OnActionParam)
      end,
      "ActionContexts",
      {
        "ContentPanelAction"
      }
    }),
    PlaceObj("XTemplateFunc", {
      "comment",
      "Enable double clicking",
      "name",
      "Open",
      "func",
      function(self, ...)
        GedApp.Open(self, ...)
        function self.idPresets.idContainer.OnDoubleClickedItem(tree, selection)
          self:Send("GedPlaySoundPreset")
          return "break"
        end
        function self.idPresetContent.idContainer.OnDoubleClickedItem(tree, selection)
          self:Send("GedPlaySoundPreset")
          return "break"
        end
      end
    }),
    PlaceObj("XTemplateCode", {
      "comment",
      "Rename panels",
      "run",
      function(self, parent, context)
        parent.idPresets:SetTitle("Sound Bank")
        parent.idPresetContent:SetTitle("Sound Sample")
      end
    }),
    PlaceObj("XTemplateCode", {
      "comment",
      "Disable auto items",
      "run",
      function(self, parent, context)
        function RebuildSubItemsActions(...)
          return
        end
      end
    })
  })
})
