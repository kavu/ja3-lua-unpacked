PlaceObj("XTemplate", {
  group = "GedApps",
  id = "GedInspector",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "Padding",
    box(5, 5, 5, 5),
    "MinWidth",
    400,
    "MinHeight",
    400,
    "MaxWidth",
    800,
    "MaxHeight",
    2000,
    "HandleMouse",
    true,
    "Title",
    "Inspector",
    "AppId",
    "GedInspector",
    "InitialWidth",
    600
  }, {
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Back",
      "ActionName",
      T(686909734572, "Go Back"),
      "ActionIcon",
      "CommonAssets/UI/Ged/left.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpInspectorNavGo", "root", "back")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Forward",
      "ActionName",
      T(546794937830, "Go Forward"),
      "ActionIcon",
      "CommonAssets/UI/Ged/right.tga",
      "ActionToolbar",
      "main",
      "ActionToolbarSplit",
      true,
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpInspectorNavGo", "root", "forward")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "PrevChild",
      "ActionName",
      T(627324741115, "Go to parent's previous child"),
      "ActionIcon",
      "CommonAssets/UI/Ged/minus-one.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpInspectorNavGo", "root", "prevchild")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "NextChild",
      "ActionName",
      T(724895571504, "Go to parent's next child"),
      "ActionIcon",
      "CommonAssets/UI/Ged/plus-one.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpInspectorNavGo", "root", "nextchild")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Parent",
      "ActionName",
      T(996587881617, "Go to parent table"),
      "ActionIcon",
      "CommonAssets/UI/Ged/up.tga",
      "ActionToolbar",
      "main",
      "ActionToolbarSplit",
      true,
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpInspectorNavGo", "root", "parent")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "SetO1",
      "ActionName",
      T(859278622382, "Store in 'o1'"),
      "ActionIcon",
      "CommonAssets/UI/Ged/o1.tga",
      "ActionToolbar",
      "main",
      "ActionToggle",
      true,
      "ActionToggled",
      function(self, host)
        return host.actions_toggled.SetO1
      end,
      "OnAction",
      function(self, host, source, ...)
        host.actions_toggled.SetO1 = not host.actions_toggled.SetO1
        host:Op("GedOpInspectorSetGlobal", "root", "o1", host.actions_toggled.SetO1)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "SetO2",
      "ActionName",
      T(361035811838, "Store in 'o2'"),
      "ActionIcon",
      "CommonAssets/UI/Ged/o2.tga",
      "ActionToolbar",
      "main",
      "ActionToggle",
      true,
      "ActionToggled",
      function(self, host)
        return host.actions_toggled.SetO2
      end,
      "OnAction",
      function(self, host, source, ...)
        host.actions_toggled.SetO2 = not host.actions_toggled.SetO2
        host:Op("GedOpInspectorSetGlobal", "root", "o2", host.actions_toggled.SetO2)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "SetO3",
      "ActionName",
      T(980812932469, "Store in 'o3'"),
      "ActionIcon",
      "CommonAssets/UI/Ged/o3.tga",
      "ActionToolbar",
      "main",
      "ActionToolbarSplit",
      true,
      "ActionToggle",
      true,
      "ActionToggled",
      function(self, host)
        return host.actions_toggled.SetO3
      end,
      "OnAction",
      function(self, host, source, ...)
        host.actions_toggled.SetO3 = not host.actions_toggled.SetO3
        host:Op("GedOpInspectorSetGlobal", "root", "o3", host.actions_toggled.SetO3)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "View",
      "ActionName",
      T(462853252033, "View"),
      "ActionIcon",
      "CommonAssets/UI/Ged/view.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Op("GedOpInspectorViewObject", "root")
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Refresh",
      "ActionName",
      T(158496240791, "Refresh"),
      "ActionIcon",
      "CommonAssets/UI/Ged/redo.tga",
      "ActionToolbar",
      "main",
      "OnAction",
      function(self, host, source, ...)
        host:Send("GedObjModified", "root")
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedObjectPanel",
      "Id",
      "idProps",
      "Title",
      "",
      "EnableSearch",
      true,
      "PersistentSearch",
      true
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XSizeControl"
    })
  })
})
