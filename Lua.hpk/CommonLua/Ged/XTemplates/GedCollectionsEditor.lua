PlaceObj("XTemplate", {
  group = "GedApps",
  id = "GedCollectionsEditor",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Title",
    "Collections",
    "AppId",
    "GedCollectionsEditor",
    "CommonActionsInMenubar",
    false,
    "CommonActionsInToolbar",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedTreePanel",
      "Id",
      "idCollections",
      "Title",
      "Collections",
      "Format",
      "<EditorView>",
      "SelectionBind",
      "SelectedCollection",
      "OnDoubleClick",
      function(self, selection)
        self.parent:Send("GedCollectionEditorOp", "view")
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XPanelSizer"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "CollectionObjects"
      end,
      "__class",
      "GedTreePanel",
      "Id",
      "idObjects",
      "Title",
      "Objects",
      "ActionContext",
      "ObjectPanelActions",
      "Format",
      "<EditorView>",
      "SelectionBind",
      "SelectedObject",
      "MultipleSelection",
      true,
      "RootActionContext",
      "ObjectPanelChildActions"
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
      "idProperties",
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
      "New",
      "ActionName",
      T(795634046695, "New"),
      "ActionIcon",
      "CommonAssets/UI/Ged/new.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Send("GedCollectionEditorOp", "new")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Delete",
      "ActionName",
      T(464711044764, "Delete"),
      "ActionIcon",
      "CommonAssets/UI/Ged/delete.tga",
      "ActionToolbar",
      "main",
      "ActionShortcut",
      "Delete",
      "OnAction",
      function(self, host, source, ...)
        host:Send("GedCollectionEditorOp", "delete")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Lock",
      "ActionName",
      T(254324150154, "Lock"),
      "ActionIcon",
      "CommonAssets/UI/Ged/down.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Send("GedCollectionEditorOp", "lock")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Unlock",
      "ActionName",
      T(510925660723, "Unlock"),
      "ActionIcon",
      "CommonAssets/UI/Ged/up.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Send("GedCollectionEditorOp", "unlock")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Collect",
      "ActionName",
      T(942266051490, "Collect"),
      "ActionIcon",
      "CommonAssets/UI/Ged/collection.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Send("GedCollectionEditorOp", "collect")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Uncollect",
      "ActionName",
      T(268872113397, "Uncollect"),
      "ActionIcon",
      "CommonAssets/UI/Ged/usb.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Send("GedCollectionEditorOp", "uncollect")
      end
    })
  })
})
