PlaceObj("XTemplate", {
  __is_kind_of = "XListItem",
  group = "ModManager",
  id = "ModManagerBrowseListItem",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XListItem",
    "Padding",
    box(3, 3, 3, 3),
    "HAlign",
    "left",
    "VAlign",
    "center",
    "BorderColor",
    RGBA(0, 0, 0, 255),
    "Background",
    RGBA(255, 255, 255, 255),
    "RolloverOnFocus",
    true,
    "HandleMouse",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      XListItem.OnContextUpdate(self, context, ...)
      self.idModTitle:SetText(context.DisplayName or "")
      self.idAuthor:SetText(context.Author or "")
      local mod_id = context.BackendID
      local uninstalling = g_UninstallingMods[mod_id]
      self.idListSpinner:SetVisible(not context.InfoRetrieved or g_DownloadingMods[mod_id] or uninstalling)
      local obj = GetDialog(self).context
      if context.InfoRetrieved then
        if context.Thumbnail then
          self.idImage:SetImage(context.Thumbnail)
        end
        if obj.installed_retrieved then
          local enabled = obj.enabled[mod_id]
          local installed = obj.installed[mod_id] and not g_DownloadingMods[mod_id]
          if installed then
            local corrupted, warning, warning_id = context.Corrupted, context.Warning, context.Warning_id
            if corrupted == nil then
              local mod_def = obj.mod_defs[mod_id]
              if mod_def then
                corrupted, warning, warning_id = ModsUIGetModCorruptedStatus(mod_def)
                context.Corrupted, context.Warning, context.Warning_id = corrupted, warning, warning_id
              end
            end
            self.idWarning:SetText(warning or "")
            self.idWarning:SetVisible((warning or "") ~= "")
            if not corrupted then
              self.idEnabled:SetCheck(enabled)
              self.idEnabled:SetVisible(not uninstalling)
              self.idEnabled.idEnabled:SetVisible(enabled)
              self.idEnabled.idDisabled:SetVisible(not enabled)
            end
          end
          if rawget(self, "idInstall") then
            self.idInstall:SetVisible(not installed and not g_DownloadingMods[mod_id])
            self.idRemove:SetVisible(installed and not uninstalling)
          end
        end
        if self.selected and self:IsFocused() and obj.selected_mod_id ~= mod_id then
          self:SetSelected(true)
        end
        local current_rating_win = self:ResolveId("idCurrentRating")
        if context.Rating and current_rating_win then
          for i = 1, context.Rating do
            current_rating_win[i]:SetImage("UI/Mods/rate-orange.tga")
          end
          current_rating_win:SetVisible(true)
          local ratings_total = self:ResolveId("idRatingsTotal")
          ratings_total:SetText("(" .. context.RatingsCount .. ")")
          ratings_total:SetVisible(true)
        end
        local size = self:ResolveId("idFileSize")
        if size then
          local context = self.context
          size:SetVisible(context.FileSize)
          if context.FileSize then
            size:SetText(T(10487, "<FormatSize(FileSize, 2)>"))
          end
        end
      elseif obj.counted then
        ModsUILoadModInfo(context.ModPosition)
      end
    end
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "SetSelected(self, selected)",
      "func",
      function(self, selected)
        XListItem.SetSelected(self, selected)
        if selected then
          local changed = ModsUISetSelectedMod(self.context.ModID)
          if changed and GetUIStyleGamepad() then
            local dlg = GetDialog(self)
            dlg:UpdateActionViews(dlg)
          end
          if not self:IsFocused() then
            self:SetFocus()
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
    PlaceObj("XTemplateWindow", nil, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "mod image",
        "__class",
        "XImage",
        "Id",
        "idImage",
        "Dock",
        "box",
        "ImageFit",
        "largest"
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idListSpinner",
        "Dock",
        "box",
        "FoldWhenHidden",
        true
      }, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "ModManagerLoadingAnim",
          "Dock",
          "box",
          "HAlign",
          "center",
          "VAlign",
          "center"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "VAlign",
        "top",
        "MinHeight",
        47,
        "LayoutMethod",
        "HList",
        "LayoutHSpacing",
        5
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idWarning",
          "VAlign",
          "center",
          "Visible",
          false,
          "FoldWhenHidden",
          true,
          "HandleMouse",
          false,
          "Translate",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XTextButton",
          "Id",
          "idInstall",
          "Dock",
          "right",
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
            if not g_ModsBackendObj:IsLoggedIn() then
              local host = GetDialog(self)
              ModsUIOpenLoginPopup(host.idContentWrapper)
            else
              ModsUIInstallMod(self.context)
              self:SetVisible(false)
              self:ResolveId("idDarkOverlay"):SetVisible(true)
            end
          end
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XCheckButton",
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
          "OnPress",
          function(self, gamepad)
            ModsUIToggleEnabled(self.context, self)
          end,
          "Check",
          true
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
            "HAlign",
            "center",
            "VAlign",
            "center",
            "Visible",
            false,
            "FoldWhenHidden",
            true,
            "Translate",
            true,
            "Text",
            T(390494073411, "Enabled")
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XLabel",
            "Id",
            "idDisabled",
            "HAlign",
            "center",
            "VAlign",
            "center",
            "Visible",
            false,
            "FoldWhenHidden",
            true,
            "Translate",
            true,
            "Text",
            T(362027600090, "Disabled")
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XTextButton",
          "Id",
          "idRemove",
          "Dock",
          "right",
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
            ModsUIUninstallMod(self.context)
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(20, 0, 0, 20),
        "VAlign",
        "bottom",
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idModTitle",
          "VAlign",
          "bottom",
          "HandleMouse",
          false,
          "TextStyle",
          "GedTitle"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XLabel",
          "Id",
          "idAuthor",
          "VAlign",
          "bottom"
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "current rating",
          "VAlign",
          "bottom",
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          10
        }, {
          PlaceObj("XTemplateWindow", {
            "Id",
            "idCurrentRating",
            "VAlign",
            "center",
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            4,
            "Visible",
            false,
            "FoldWhenHidden",
            true
          }, {
            PlaceObj("XTemplateForEach", {
              "array",
              function(parent, context)
                return nil, 1, 5
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Image",
                "CommonAssets/UI/Icons/outline star",
                "ImageScale",
                point(230, 230)
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XLabel",
            "Id",
            "idRatingsTotal",
            "VAlign",
            "center",
            "Visible",
            false,
            "FoldWhenHidden",
            true
          })
        })
      })
    })
  })
})
