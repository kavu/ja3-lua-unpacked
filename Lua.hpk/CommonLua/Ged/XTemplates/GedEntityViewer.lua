PlaceObj("XTemplate", {
  group = "GedApps",
  id = "GedEntityViewer",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Title",
    "Entity Viewer",
    "AppId",
    "GedEntityViewer"
  }, {
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedListPanel",
      "Id",
      "idMeshes",
      "Title",
      "Meshes",
      "SelectionBind",
      "SelectedMesh,SelectedObject"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XPanelSizer"
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "SelectedMesh"
      end,
      "__class",
      "GedTreePanel",
      "Id",
      "idMeshItems",
      "Title",
      "Tree",
      "ActionContext",
      "ObjectPanelActions",
      "Format",
      "<itemtext>",
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
      "Properties"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "PlayAnim",
      "ActionName",
      T(681862459100, "Play State Animation"),
      "ActionIcon",
      "CommonAssets/UI/Ged/play.tga",
      "ActionToolbar",
      "main",
      "ActionShortcut",
      "Ctrl-P",
      "OnAction",
      function(self, host, source, ...)
        host:InvokeMethod("root", "PlayAnim")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "AttachDetachAtSpot",
      "ActionName",
      T(102690592778, "Attach/Detach Object at selected Spot"),
      "ActionIcon",
      "CommonAssets/UI/Ged/usb.tga",
      "ActionToolbar",
      "main",
      "ActionShortcut",
      "Ctrl-A",
      "OnAction",
      function(self, host, source, ...)
        host:InvokeMethod("root", "AttachDetachAtSpot")
      end
    })
  })
})
