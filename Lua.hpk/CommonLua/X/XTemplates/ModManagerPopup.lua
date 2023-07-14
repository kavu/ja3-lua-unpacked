PlaceObj("XTemplate", {
  group = "ModManager",
  id = "ModManagerPopup",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XPopup",
    "Id",
    "idPopUp",
    "BorderWidth",
    0,
    "MinWidth",
    225,
    "BorderColor",
    RGBA(128, 128, 128, 0),
    "Background",
    RGBA(25, 28, 29, 230),
    "FocusedBackground",
    RGBA(240, 240, 240, 0),
    "AnchorType",
    "center-bottom"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        local content = self:ResolveId("idContent")
        content:SetChildrenHandleMouse(false)
        content:SetHandleMouse(true)
        function content.OnMouseButtonDown(this, pos, button)
          if button == "L" then
            ModsUIToggleSortPC(this:ResolveId("idContentWrapper"))
            local dlg = GetDialog(this)
            local obj = dlg.context
            ObjModified(obj)
            return "break"
          end
        end
        XPopup.Open(self, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete",
      "func",
      function(self, ...)
        local content = self:ResolveId("idContent")
        content:SetChildrenHandleMouse(true)
        content:SetHandleMouse(false)
        content.OnMouseButtonDown = nil
        XPopup.OnDelete(self, ...)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XList",
      "Dock",
      "box"
    }, {
      PlaceObj("XTemplateForEach", {
        "array",
        function(parent, context)
          return GetModsUISortItems(GetDialogMode(parent))
        end,
        "run_after",
        function(child, context, item, i, n, last)
          local dlg = GetDialog(child)
          local mode = dlg.Mode
          child:SetText(item.name)
          if mode == "browse" then
            child:SetCheck(context.set_sort == item.id)
          else
            child:SetCheck(context.set_installed_sort == item.id)
          end
          function child.OnChange(this, check)
            local obj = dlg.context
            if mode == "browse" then
              obj:SetSortMethod(item.id)
            else
              obj:SetInstalledSortMethod(item.id)
            end
            ObjModified(obj)
            if not GetUIStyleGamepad() then
              local btn = dlg:ResolveId("idSortButton")
              if btn then
                btn:SetText(btn:GetText())
              end
              ModsUIToggleSortPC(dlg.idContentWrapper)
            else
              ModsUIClosePopup(dlg)
            end
          end
        end
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XCheckButton",
          "Translate",
          true
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "SetSelected(self, selected)",
            "func",
            function(self, selected)
              self:SetFocus(selected)
            end
          })
        })
      })
    })
  })
})
