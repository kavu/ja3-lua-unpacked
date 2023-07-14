PlaceObj("XTemplate", {
  group = "GedApps",
  id = "GedRoomEditor",
  save_in = "Libs/Volumes",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Title",
    "Room Editor",
    "AppId",
    "GedRoomEditor",
    "CommonActionsInMenubar",
    false,
    "CommonActionsInToolbar",
    false
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "New",
      "ActionName",
      T(285113360304, "New"),
      "ActionIcon",
      "CommonAssets/UI/Ged/new.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpNewVolume", "SelectedObject")
      end,
      "ActionContexts",
      {
        "RoomPanelGeneral"
      }
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "ViewObject",
      "ActionSortKey",
      "2",
      "ActionName",
      T(683738805190, "View Object"),
      "ActionIcon",
      "CommonAssets/UI/Ged/view.tga",
      "ActionToolbar",
      "main",
      "ActionToolbarSplit",
      true,
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpViewRoom", "SelectedObject")
      end,
      "ActionContexts",
      {
        "RoomPanelOther"
      }
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedListPanel",
      "Id",
      "idRooms",
      "Margins",
      box(0, 0, 2, 0),
      "Dock",
      "left",
      "Title",
      "Rooms",
      "ActionsClass",
      "Object",
      "Delete",
      "GedOpListDeleteItem",
      "Format",
      "<EditorView>",
      "SelectionBind",
      "SelectedObject"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "SelectedObject"
      end,
      "__class",
      "GedPropPanel",
      "Title",
      "Properties",
      "ActionsClass",
      "PropertyObject",
      "Copy",
      "GedOpPropertyCopy",
      "Paste",
      "GedOpPropertyPaste"
    })
  })
})
