PlaceObj("XTemplate", {
  __is_kind_of = "XListItem",
  group = "ModManager",
  id = "ModManagerInstalledMod",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XListItem",
    "BorderColor",
    RGBA(0, 0, 0, 255),
    "Background",
    RGBA(255, 255, 255, 255),
    "RolloverDrawOnTop",
    true,
    "RolloverOnFocus",
    true,
    "HandleMouse",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      XListItem.OnContextUpdate(self, context, ...)
      self.idModTitle:SetText("Title: " .. (context.DisplayName or ""))
      self.idAuthor:SetText("Author: " .. (context.Author or ""))
      self.idModVersion:SetText(T({
        10484,
        "v.<version>",
        version = Untranslated(context.ModVersion)
      }))
      local obj = GetDialog(self).context
      local mod_id = context.ModID
      local corrupted, warning, warning_id = context.Corrupted, context.Warning, context.Warning_id
      if corrupted == nil then
        local mod_def = obj.mod_defs[mod_id]
        if mod_def then
          corrupted, warning, warning_id = ModsUIGetModCorruptedStatus(mod_def)
          context.Corrupted, context.Warning, context.Warning_id = corrupted, warning, warning_id
        end
      end
      local installed = obj.installed[mod_id]
      self.idListSpinner:SetVisible(not installed)
      self.idEnabledDisabledWindow:SetVisible(installed)
      self.idWarning:SetText(warning or "")
      self.idWarning:SetVisible((warning or "") ~= "")
      local enabled = obj.enabled[mod_id]
      if not corrupted then
        if rawget(self.idEnabled, "idEnabled") then
          self.idEnabled:SetVisible(true)
          self.idEnabled:SetCheck(enabled)
          self.idEnabled.idEnabled:SetVisible(enabled)
          self.idEnabled.idDisabled:SetVisible(not enabled)
          local button = GetDialog(self):ResolveId("idAllToggleEnabled")
          if button then
            button:Update()
          end
        elseif rawget(self, "idEnabledTick") then
          self.idEnabledTick:SetVisible(enabled)
          self.idEnabled:SetVisible(enabled)
          self.idDisabled:SetVisible(not enabled)
        end
      end
      if context.Thumbnail then
        self.idImage:SetImage(context.Thumbnail)
      end
    end
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        self:ResolveId("idModTitle"):SetRollover(rollover)
        XContextWindow.OnSetRollover(self, rollover)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetSelected(self, selected)",
      "func",
      function(self, selected)
        XListItem.SetSelected(self, selected)
        self:SetFocus(selected)
        if selected then
          local changed = ModsUISetSelectedMod(self.context.ModID)
          if changed then
            local dlg = GetDialog(self)
            dlg:UpdateActionViews(dlg)
          end
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        if button == "L" then
          ModsUISetDialogMode(GetDialog(self), "details", self.context)
          return "break"
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XListItem.Open(self, ...)
        local context = self.context
        self.idSource:SetText("Source: " .. context.Source)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "BorderWidth",
      1
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idImage",
        "IdNode",
        false,
        "Dock",
        "left",
        "HAlign",
        "left",
        "VAlign",
        "center",
        "MinWidth",
        200,
        "MaxWidth",
        200,
        "ImageFit",
        "largest"
      }, {
        PlaceObj("XTemplateWindow", {
          "Id",
          "idListSpinner",
          "Dock",
          "box"
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "dark overlay",
            "FoldWhenHidden",
            true,
            "Background",
            RGBA(0, 0, 0, 190)
          }),
          PlaceObj("XTemplateTemplate", {
            "__template",
            "ModManagerLoadingAnim",
            "FoldWhenHidden",
            true
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(20, 0, 0, 0),
        "VAlign",
        "center",
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idSource"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idModTitle",
          "HandleMouse",
          false
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XLabel",
          "Id",
          "idAuthor",
          "FoldWhenHidden",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XLabel",
          "Id",
          "idWarning",
          "Visible",
          false,
          "Translate",
          true
        })
      }),
      PlaceObj("XTemplateWindow", {
        "HAlign",
        "center",
        "VAlign",
        "bottom"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XLabel",
          "Id",
          "idModVersion",
          "FoldWhenHidden",
          true,
          "Translate",
          true
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idEnabledDisabledWindow",
        "Margins",
        box(0, 0, 15, 0),
        "Dock",
        "right",
        "VAlign",
        "center",
        "LayoutMethod",
        "HList",
        "LayoutHSpacing",
        20
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XCheckButton",
          "Id",
          "idEnabled",
          "HAlign",
          "center",
          "VAlign",
          "center",
          "Visible",
          false,
          "FoldWhenHidden",
          true,
          "OnPress",
          function(self, gamepad)
            ModsUIToggleEnabled(self.context, self)
          end
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "OnChange(self, check)",
            "func",
            function(self, check)
              self.idEnabled:SetVisible(check)
              self.idDisabled:SetVisible(not check)
            end
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XLabel",
            "Id",
            "idEnabled",
            "Dock",
            "left",
            "VAlign",
            "center",
            "Visible",
            false,
            "FoldWhenHidden",
            true,
            "Translate",
            true,
            "Text",
            T(432182749504, "Enabled")
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XLabel",
            "Id",
            "idDisabled",
            "Dock",
            "left",
            "VAlign",
            "center",
            "Visible",
            false,
            "FoldWhenHidden",
            true,
            "Translate",
            true,
            "Text",
            T(953706379202, "Disabled")
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__condition",
          function(parent, context)
            return context.Source ~= "local" and context.Source ~= "steam"
          end,
          "__class",
          "XTextButton",
          "Id",
          "idRemove",
          "Padding",
          box(-5, 2, 10, 2),
          "HAlign",
          "center",
          "VAlign",
          "center",
          "Background",
          RGBA(0, 0, 0, 0),
          "FocusedBackground",
          RGBA(0, 0, 0, 0),
          "OnPress",
          function(self, gamepad)
            ModsUIUninstallMod(self.context)
          end,
          "RolloverBackground",
          RGBA(0, 0, 0, 0),
          "PressedBackground",
          RGBA(0, 0, 0, 0)
        })
      })
    })
  })
})
