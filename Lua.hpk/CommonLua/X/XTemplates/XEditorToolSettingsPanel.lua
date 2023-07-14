PlaceObj("XTemplate", {
  group = "Editor",
  id = "XEditorToolSettingsPanel",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__class",
    "GedApp",
    "HAlign",
    "right",
    "VAlign",
    "top",
    "MinWidth",
    350,
    "Visible",
    false,
    "HasTitle",
    false,
    "AppId",
    "XEditorToolSettingsPanel",
    "InitialWidth",
    350
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "ApplySavedSettings(self, ...)",
      "func",
      function(self, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self, ...)",
      "func",
      function(self, ...)
        if self.in_game then
          self:SetParent(GetDevUIViewport())
          self:SetScaleModifier(point(1250, 1250))
          self:SetMargins(box(5, 5, 5, 20))
          self:SetMaxWidth(self.MinWidth)
        end
        self:SetVisibleInstant(true)
        GedApp.Open(self, ...)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "root"
      end,
      "__class",
      "GedPropPanel",
      "Id",
      "idPropPanel",
      "Title",
      "<ToolTitle>",
      "EnableSearch",
      false,
      "DisplayWarnings",
      false,
      "EnableUndo",
      false,
      "EnableCollapseDefault",
      false,
      "EnableShowInternalNames",
      false,
      "EnableCollapseCategories",
      false,
      "HideFirstCategory",
      true
    }, {
      PlaceObj("XTemplateTemplate", {
        "__parent",
        function(parent, context)
          return parent.idTitleContainer
        end,
        "__template",
        "GedToolbarToggleButtonSmall",
        "RolloverText",
        T(292312175244, "Move tool settings in/out of game."),
        "Id",
        "idToggleDisplayInGame",
        "OnPress",
        function(self, gamepad)
          XToggleButton.OnPress(self, gamepad)
          local prop_panel = GetParentOfKind(self, "GedPropPanel")
          prop_panel:Op("GedSetProperty", prop_panel.context, "DisplayInGame", not prop_panel.connection.app.in_game)
        end,
        "Icon",
        "CommonAssets/UI/Ged/explorer.tga"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idDescription",
        "Dock",
        "bottom",
        "FoldWhenHidden",
        true,
        "HideOnEmpty",
        true,
        "TextHAlign",
        "center"
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idSeparator",
        "Margins",
        box(10, 0, 10, 0),
        "Dock",
        "bottom",
        "MinHeight",
        1,
        "FoldWhenHidden",
        true,
        "Background",
        RGBA(128, 128, 128, 255)
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "BindViews(self)",
        "func",
        function(self)
          GedPropPanel.BindViews(self)
          self:BindView("description", "GedXEditorSettingsDescription")
        end
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "OnContextUpdate(self, context, view)",
        "func",
        function(self, context, view)
          GedPropPanel.OnContextUpdate(self, context, view)
          if view == "description" then
            local text = self:Obj(self.context .. "|description")
            self.idDescription:SetText(text)
            self.idSeparator:SetVisible(text ~= "")
          end
        end
      }),
      PlaceObj("XTemplateFunc", {
        "comment",
        "re-translate shortcuts from Filter field",
        "name",
        "RebuildControls(self)",
        "func",
        function(self)
          GedPropPanel.RebuildControls(self)
          local filter_edit = self:LocateEditorById("Filter")
          local class_list = self:LocateEditorById("ObjectClass")
          if filter_edit then
            filter_edit = filter_edit.idEdit
            function filter_edit:OnShortcut(shortcut, source, ...)
              if shortcut == "Ctrl-Z" or shortcut == "Ctrl-Y" then
                return
              end
              if shortcut ~= "Ctrl-Home" and shortcut ~= "Ctrl-End" and XEdit.OnShortcut(self, shortcut, source, ...) then
                return "break"
              end
              if shortcut ~= "Ctrl-D" and class_list and class_list.idList:OnShortcut(shortcut, source, ...) == "break" then
                return "break"
              end
              local tool_dialog = GetDialog("XEditor") and GetDialog("XEditor").mode_dialog
              return tool_dialog and tool_dialog:OnShortcut(shortcut, source, ...)
            end
            filter_edit.vkPass = table.copy(filter_edit.vkPass)
            table.iappend(filter_edit.vkPass, {
              const.vkSpace,
              const.vkMinus,
              const.vkPlus,
              const.vkOpensq,
              const.vkClosesq,
              const.vkSemicolon,
              const.vkTilde,
              const.vkQuote,
              const.vkComma,
              const.vkDot,
              const.vkSlash,
              const.vkBackslash
            })
          end
        end
      })
    })
  })
})
