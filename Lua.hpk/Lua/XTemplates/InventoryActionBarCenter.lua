PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "Zulu",
  id = "InventoryActionBarCenter",
  PlaceObj("XTemplateWindow", {
    "Id",
    "idActionBar",
    "IdNode",
    true,
    "Dock",
    "bottom",
    "HAlign",
    "center"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XToolBarList",
      "Id",
      "idToolBar",
      "VAlign",
      "center",
      "LayoutHSpacing",
      50,
      "Background",
      RGBA(255, 255, 255, 0),
      "Toolbar",
      "ActionBarCenter",
      "Show",
      "text",
      "ButtonTemplate",
      "InventoryActionBarButtonCenter"
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
    PlaceObj("XTemplateFunc", {
      "name",
      "OnUpdateActions",
      "func",
      function(self, ...)
        self.idToolBar:OnUpdateActions()
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
    T(700951320019, "Toolbar Name")
  })
})
