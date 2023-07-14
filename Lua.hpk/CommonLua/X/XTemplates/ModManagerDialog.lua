PlaceObj("XTemplate", {
  group = "ModManager",
  id = "ModManagerDialog",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return ModsUIObjectCreateAndLoad()
    end,
    "__class",
    "XDialog",
    "Id",
    "idModsUIDialog",
    "Background",
    RGBA(255, 255, 255, 255),
    "HandleMouse",
    true,
    "InitialMode",
    "installed",
    "InternalModes",
    "browse, installed, details"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "UpdateActionViews(self, win)",
      "func",
      function(self, win)
        XDialog.UpdateActionViews(self, win)
        self:InvalidateMeasure()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XDialog.Open(self, ...)
        if not IsUserCreatedContentAllowed() then
          self:SetMode("installed")
        end
        ModsUIDialogStart()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete",
      "func",
      function(self, ...)
        ModsUIClosePopup(self)
        XDialog.OnDelete(self, ...)
        g_ModsUIContextObj = false
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if not self.context.popup_shown and self.Mode ~= "details" and IsUserCreatedContentAllowed() then
          if shortcut == "LeftTrigger" then
            self:ResolveId("idBrowse"):Press()
            return "break"
          elseif shortcut == "RightTrigger" then
            self:ResolveId("idInstalled"):Press()
            return "break"
          end
        end
        return XDialog.OnShortcut(self, shortcut, source, ...)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContentTemplate"
    }, {
      PlaceObj("XTemplateGroup", {
        "__condition",
        function(parent, context)
          return GetUIStyleGamepad()
        end
      }, {
        PlaceObj("XTemplateMode", nil, {
          PlaceObj("XTemplateAction", {
            "ActionId",
            "select",
            "ActionName",
            T(764001006052, "Select"),
            "ActionToolbar",
            "ActionBarLeft",
            "ActionGamepad",
            "ButtonA",
            "ActionState",
            function(self, host)
              return not ModsUIIsPopupShown(host) or "hidden"
            end
          })
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "search",
          "ActionName",
          T(459090792822, "Search"),
          "ActionToolbar",
          "ActionBarLeft",
          "ActionShortcut",
          "Enter",
          "ActionGamepad",
          "ButtonY",
          "ActionState",
          function(self, host)
            local popup = ModsUIIsPopupShown(host)
            return popup ~= "search" and "hidden"
          end,
          "OnAction",
          function(self, host, source, ...)
            local context = host.context
            if host.Mode == "browse" then
              if context.query ~= context.temp_query then
                context.query = context.temp_query
                context:GetMods()
              end
            elseif context.installed_query ~= context.temp_query then
              context.installed_query = context.temp_query
              context:GetInstalledMods()
            end
            ModsUIClosePopup(host)
          end
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "popupcancel",
          "ActionName",
          T(494914306689, "Cancel"),
          "ActionToolbar",
          "ActionBarRight",
          "ActionShortcut",
          "Escape",
          "ActionGamepad",
          "ButtonB",
          "ActionState",
          function(self, host)
            local popup = ModsUIIsPopupShown(host)
            return (not popup or popup == "login") and "hidden"
          end,
          "OnAction",
          function(self, host, source, ...)
            ModsUIClosePopup(host)
          end
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "popupsortsave",
          "ActionName",
          T(638926077884, "Apply"),
          "ActionToolbar",
          "ActionBarLeft",
          "ActionGamepad",
          "ButtonA",
          "ActionState",
          function(self, host)
            local popup = ModsUIIsPopupShown(host)
            return popup ~= "sort" and "hidden"
          end,
          "OnAction",
          function(self, host, source, ...)
            ModsUIClosePopup(host)
          end
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "popupfiltersave",
          "ActionName",
          T(638926077884, "Apply"),
          "ActionToolbar",
          "ActionBarLeft",
          "ActionGamepad",
          "ButtonY",
          "ActionState",
          function(self, host)
            local popup = ModsUIIsPopupShown(host)
            return popup ~= "filter" and "hidden"
          end,
          "OnAction",
          function(self, host, source, ...)
            if host.Mode == "installed" then
              ModsUISetInstalledTags()
              ModsUIClosePopup(host)
              host.context:GetInstalledMods()
            else
              ModsUISetTags()
              ModsUIClosePopup(host)
              host.context:GetMods()
            end
          end
        }),
        PlaceObj("XTemplateAction", {
          "ActionId",
          "popupfilterclear",
          "ActionName",
          T(761178986756, "Clear Filters"),
          "ActionToolbar",
          "ActionBarLeft",
          "ActionGamepad",
          "ButtonX",
          "ActionState",
          function(self, host)
            local popup = ModsUIIsPopupShown(host)
            return popup ~= "filter" and "hidden"
          end,
          "OnAction",
          function(self, host, source, ...)
            ModsUIClearFilter(GetDialog(host):GetMode())
          end
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContentTemplate",
      "IdNode",
      false,
      "OnContextUpdate",
      function(self, context, ...)
        local list = self:ResolveId("idList")
        if list then
          local mode = GetDialogMode(self)
          local obj = ResolvePropObj(context)
          if mode == "browse" and obj.last_browse_y then
            obj.last_browse_y = list.OffsetY
            obj.last_browse_item = list.focused_item
          elseif mode == "installed" and obj.last_installed_y then
            obj.last_installed_y = list.OffsetY
            obj.last_installed_item = list.focused_item
          end
        end
        XContentTemplate.OnContextUpdate(self, context, ...)
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "Id",
        "idBottomBar",
        "Dock",
        "bottom"
      }),
      PlaceObj("XTemplateMode", {"mode", "browse"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "ModManagerMainContent"
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "installed"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "ModManagerMainContent"
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "details"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "ModManagerModDetails"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__parent",
        function(parent, context)
          return parent:ResolveId("idBottomBar")
        end,
        "__class",
        "XToolBar",
        "HAlign",
        "left",
        "Toolbar",
        "bottommenu"
      }),
      PlaceObj("XTemplateWindow", {
        "__parent",
        function(parent, context)
          return parent:ResolveId("idBottomBar")
        end,
        "__class",
        "XToolBar",
        "HAlign",
        "right",
        "Toolbar",
        "bottommenu_right"
      })
    })
  })
})
