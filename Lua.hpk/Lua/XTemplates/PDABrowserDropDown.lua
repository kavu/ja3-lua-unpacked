PlaceObj("XTemplate", {
  __is_kind_of = "XPopup",
  group = "Zulu Satellite UI",
  id = "PDABrowserDropDown",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XPopup",
    "MinWidth",
    160,
    "Background",
    RGBA(52, 55, 61, 255),
    "MouseCursor",
    "UI/Cursors/Pda_Cursor.tga",
    "AnchorType",
    "drop"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextWindow"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XList",
        "Id",
        "idParent",
        "IdNode",
        false,
        "Padding",
        box(5, 0, 5, 0),
        "LayoutHSpacing",
        5,
        "BorderColor",
        RGBA(0, 0, 0, 0),
        "Background",
        RGBA(0, 0, 0, 0),
        "FocusedBorderColor",
        RGBA(0, 0, 0, 0),
        "FocusedBackground",
        RGBA(0, 0, 0, 0),
        "DisabledBorderColor",
        RGBA(0, 0, 0, 0),
        "MouseScroll",
        false
      }, {
        PlaceObj("XTemplateForEach", {
          "array",
          function(parent, context)
            return PDABrowserHistoryState
          end,
          "map",
          function(parent, context, array, i)
            return array and array[i]
          end,
          "run_after",
          function(child, context, item, i, n, last)
            if item.mode == "banner_page" then
              child:SetText(PDABrowserSites[item.mode_param].bookmark)
            else
              child:SetText(table.find_value(PDABrowserTabData, "id", item.mode).DisplayName)
            end
            local popup = child:ResolveId("node")
            local dlg = GetDialog(child)
            child.selected = dlg.Mode == item.id
            function child:OnPress()
              dlg:SetMode(item.mode, item.mode_param)
              popup:Close()
            end
          end
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "SatelliteViewMapContextMenuAction"
          })
        })
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnCaptureLost(self)",
      "func",
      function(self)
        if self.window_state ~= "open" then
          return
        end
        self:Close()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        if self:MouseInWindow(pos) then
          return
        end
        if self.window_state ~= "open" then
          return
        end
        self:Close()
      end
    })
  })
})
