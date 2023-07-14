PlaceObj("XTemplate", {
  group = "GedApps",
  id = "GedGridMarkerEditor",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "MinWidth",
    700,
    "Title",
    "Grid Marker Editor",
    "AppId",
    "GedGridMarkerEditor"
  }, {
    PlaceObj("XTemplateWindow", {
      "MinWidth",
      300,
      "LayoutMethod",
      "VPanel"
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "filter",
        "__context",
        function(parent, context)
          return "MarkersFilter"
        end,
        "__class",
        "GedPropPanel",
        "Id",
        "idMarkersFilter",
        "Dock",
        "bottom",
        "Title",
        "Filter",
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
        "markers list",
        "__context",
        function(parent, context)
          return "root"
        end,
        "__class",
        "GedListPanel",
        "Id",
        "idGridMarkers",
        "Title",
        "Grid Markers",
        "ActionsClass",
        "Object",
        "Delete",
        "GedOpListDeleteItem",
        "Cut",
        "GedOpObjectCut",
        "Copy",
        "GedOpObjectCopy",
        "Paste",
        "GedOpObjectPaste",
        "Duplicate",
        "GedOpObjectDuplicate",
        "Format",
        "<EditorText>",
        "FilterName",
        "MarkersFilter",
        "FilterClass",
        "GridMarkerFilter",
        "SelectionBind",
        "SelectedObjects",
        "MultipleSelection",
        true
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XPanelSizer"
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "marker properties",
      "__context",
      function(parent, context)
        return "SelectedObjects"
      end,
      "__class",
      "GedPropPanel",
      "MinWidth",
      300,
      "Title",
      "Properties",
      "ActionsClass",
      "PropertyObject",
      "Copy",
      "GedOpPropertyCopy",
      "Paste",
      "GedOpPropertyPaste"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Save",
      "ActionName",
      T(658264891173, "Save"),
      "ActionIcon",
      "CommonAssets/UI/Ged/save.tga",
      "ActionToolbar",
      "main",
      "ActionShortcut",
      "Ctrl-S",
      "OnAction",
      function(self, host, source, ...)
        host:Op("EnterEditorSaveMap", "root")
      end
    }),
    PlaceObj("XTemplateForEach", {
      "array",
      function(parent, context)
        return {
          "GridMarker",
          "UnitMarker",
          "ContainerMarker",
          "CustomInteractable",
          "WaypointMarker",
          "AmbientLifeMarker"
        }
      end,
      "unique",
      true,
      "run_after",
      function(child, context, item, i, n, last)
        child:SetRolloverText("Place " .. item .. " marker\n" .. (context and context.rollovers[item] or ""))
        child.ActionId = item
        child.ActionIcon = context.icons[item] or "CommonAssets/UI/Icons/radar.tga"
        function child.OnAction(this, host, source)
          host:Op("GedOpPlaceGridMarker", "SelectedObjects", item)
        end
      end
    }, {
      PlaceObj("XTemplateAction", {
        "RolloverTemplate",
        "GedToolbarRollover",
        "ActionTranslate",
        false,
        "ActionName",
        "Place Marker",
        "ActionToolbar",
        "main"
      })
    })
  })
})
