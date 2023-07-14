PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "Zulu",
  id = "InventoryActionBar",
  PlaceObj("XTemplateWindow", {
    "Id",
    "idActionBar",
    "IdNode",
    true,
    "Dock",
    "bottom",
    "HAlign",
    "right",
    "ChildrenHandleMouse",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XToolBarList",
      "Id",
      "idToolBar",
      "Margins",
      box(10, 0, 0, 0),
      "HAlign",
      "center",
      "VAlign",
      "center",
      "LayoutHSpacing",
      5,
      "Background",
      RGBA(255, 255, 255, 0),
      "Toolbar",
      "ActionBar",
      "Show",
      "text",
      "ButtonTemplate",
      "InventoryActionBarButton"
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "Open",
        "func",
        function(self, ...)
          XToolBarList.Open(self, ...)
          function self.list:OnShortcut(shortcut, source, ...)
            local key = string.gsub(shortcut, "[-+]*", "")
            if source == "gamepad" and IsMouseViaGamepadActive() and (key == "LeftThumbLeft" or key == "LeftThumbDownLeft" or key == "LeftThumbUpLeft" or key == "LeftThumbRight" or key == "LeftThumbDownRight" or key == "LeftThumbUpRight") then
              return "break"
            end
            return XList.OnShortcut(self, shortcut, source, ...)
          end
        end
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetFocus(self, ...)",
      "func",
      function(self, ...)
        return self.idToolBar:SetFocus(...)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "gamepad shortcut observer",
      "__context",
      function(parent, context)
        return "GamepadUIStyleChanged"
      end,
      "__class",
      "XContextWindow",
      "OnContextUpdate",
      function(self, context, ...)
        local node = self:ResolveId("node")
        local toolBar = node.idToolBar
        local host = GetActionsHost(self, true)
        toolBar:RebuildActions(host)
      end
    })
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "ToolbarName",
    "editor",
    "text",
    "default",
    "ActionBar",
    "translate",
    false,
    "Set",
    function(self, value)
      self.idToolBar.Toolbar = value
    end,
    "Get",
    function(self)
      return self.idToolBar.Toolbar
    end,
    "name",
    T(565666410132, "Toolbar Name")
  })
})
