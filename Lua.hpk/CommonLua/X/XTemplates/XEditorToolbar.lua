PlaceObj("XTemplate", {
  __is_kind_of = "XDarkModeAwareDialog",
  group = "Editor",
  id = "XEditorToolbar",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDarkModeAwareDialog",
    "ZOrder",
    -1,
    "Dock",
    "left",
    "MaxWidth",
    90,
    "ScaleModifier",
    point(800, 800),
    "FoldWhenHidden",
    true,
    "HandleMouse",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XToolBar",
      "Id",
      "idToolbar",
      "MinWidth",
      90,
      "MaxWidth",
      90,
      "LayoutMethod",
      "VList",
      "Background",
      RGBA(64, 64, 66, 255),
      "Toolbar",
      "XEditorToolbar",
      "Show",
      "icon",
      "ButtonTemplate",
      "GedToolbarButton",
      "ToggleButtonTemplate",
      "XEditorToolbarToggleButton",
      "ToolbarSectionTemplate",
      "XEditorToolbarSection"
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "GetActionsHost(self)",
        "func",
        function(self)
          return XShortcutsTarget
        end
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self, ...)",
      "func",
      function(self, ...)
        XDarkModeAwareDialog.Open(self, ...)
        self:SetOutsideScale(point(1000, 1000))
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContentTemplate",
      "Dock",
      "bottom",
      "LayoutMethod",
      "VList"
    }, {
      PlaceObj("XTemplateWindow", {
        "Id",
        "Filters",
        "IdNode",
        true,
        "LayoutMethod",
        "VList",
        "UniformColumnWidth",
        true,
        "BorderColor",
        RGBA(41, 41, 41, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "Id",
          "idSection",
          "BorderWidth",
          1,
          "Padding",
          box(2, 1, 2, 1),
          "BorderColor",
          RGBA(41, 41, 41, 255),
          "Background",
          RGBA(41, 41, 41, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XLabel",
            "Id",
            "idSectionName",
            "HAlign",
            "center",
            "VAlign",
            "center",
            "BorderColor",
            RGBA(41, 41, 41, 255),
            "TextStyle",
            "XEditorToolbarDark",
            "Text",
            "Filters"
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XStateButton",
          "RolloverTemplate",
          "XEditorToolbarRollover",
          "RolloverText",
          T(536216527294, "All"),
          "BorderWidth",
          1,
          "BorderColor",
          RGBA(128, 128, 128, 255),
          "OnContextUpdate",
          function(self, context, ...)
          end,
          "FocusedBorderColor",
          RGBA(128, 128, 128, 255),
          "DisabledBorderColor",
          RGBA(128, 128, 128, 255),
          "OnPress",
          function(self, gamepad)
            local row = self.IconRow + 1
            if row > self.IconRows then
              row = 1
            end
            local categories = {}
            local toggle_back_visibility = LocalStorage.FilteredCategories.All == "invisible"
            if not toggle_back_visibility then
              for cat, filter in pairs(self.context.filter_buttons) do
                if filter == "invisible" then
                  categories[cat] = true
                end
              end
            end
            XEditorFilters:ToggleFilter(categories, toggle_back_visibility)
            if LocalStorage.FilteredCategories.HideTop == "invisible" then
              XEditorFilters:UpdateVisibility("HideTop", "invisible")
            end
            self:SetIconRow(row)
            self:OnRowChange(row)
          end,
          "AltPress",
          true,
          "OnAltPress",
          function(self, gamepad)
            if self.action and self.action.OnAltAction then
              local host = GetActionsHost(self, true)
              if host then
                self.action:OnAltAction(host, self)
              end
            end
            local categories = {}
            for cat, filter in pairs(self.context.filter_buttons) do
              if filter == "invisible" and not LocalStorage.LockedCategories[cat] then
                LocalStorage.FilteredCategories.All = "invisible"
                break
              end
            end
            XEditorFilters:ToggleFilter(categories, true)
            if LocalStorage.FilteredCategories.HideTop == "invisible" then
              XEditorFilters:UpdateVisibility("HideTop", "invisible")
            end
          end,
          "RolloverBorderColor",
          RGBA(128, 128, 128, 255),
          "PressedBorderColor",
          RGBA(128, 128, 128, 255),
          "IconRows",
          1,
          "TextStyle",
          "GedDefaultWhite",
          "Text",
          "All"
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "CalcBackground(self)",
            "func",
            function(self)
              local category = self:GetRolloverText()[2]
              local filter = XEditorFilters:GetFilter(category)
              if filter == "visible" then
                self.Background = RGB(0, 96, 0)
                self.RolloverBackground = RGB(0, 128, 0)
                self.PressedBackground = RGB(0, 196, 0)
              elseif filter == "invisible" then
                self.Background = RGB(96, 0, 0)
                self.RolloverBackground = RGB(128, 0, 0)
                self.PressedBackground = RGB(196, 0, 0)
              elseif filter == "unselectable" then
                self.Background = RGB(96, 96, 96)
                self.RolloverBackground = RGB(128, 128, 128)
                self.PressedBackground = RGB(196, 196, 196)
              end
              self.BorderColor = RGBA(128, 128, 128, 255)
              self.RolloverBorderColor = RGBA(128, 128, 128, 255)
              self.PressedBorderColor = RGBA(128, 128, 128, 255)
              self:SetIcon("")
              if not self.enabled then
                return self.DisabledBackground
              end
              if self.state == "pressed-in" or self.state == "pressed-out" then
                return self.PressedBackground
              end
              if self.state == "mouse-in" then
                return self.RolloverBackground
              end
              return self:IsFocused() and self.FocusedBackground or self.Background
            end
          })
        }),
        PlaceObj("XTemplateForEach", {
          "array",
          function(parent, context)
            return XEditorFilters.GetCategories()
          end,
          "condition",
          function(parent, context, item, i)
            return context.filter_buttons[item] and item ~= "All"
          end,
          "run_after",
          function(child, context, item, i, n, last)
            local text = item
            if 8 < #text then
              text = string.sub(text, 1, 6) .. "..."
            end
            child:SetText(text)
            child:SetRolloverText(item)
            child.ChildrenHandleMouse = true
            child[1].HandleMouse = true
            child[1]:SetImageColor(RGB(255, 255, 255))
            child[1]:SetTransparency(LocalStorage.LockedCategories[item] and 0 or 192)
            child[1].OnMouseButtonDown = function(self)
              local category = self.parent:GetRolloverText()
              LocalStorage.LockedCategories[category] = not LocalStorage.LockedCategories[category]
              self:SetTransparency(LocalStorage.LockedCategories[category] and 0 or 192)
            end
            child[1].Dock = "right"
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XStateButton",
            "RolloverTemplate",
            "XEditorToolbarRollover",
            "BorderWidth",
            1,
            "BorderColor",
            RGBA(128, 128, 128, 255),
            "OnContextUpdate",
            function(self, context, ...)
            end,
            "FocusedBorderColor",
            RGBA(128, 128, 128, 255),
            "DisabledBorderColor",
            RGBA(128, 128, 128, 255),
            "OnPress",
            function(self, gamepad)
              local row = self.IconRow + 1
              if row > self.IconRows then
                row = 1
              end
              local category = self:GetRolloverText()
              if terminal.IsKeyPressed(const.vkControl) then
                for cat, filter in pairs(self.context.filter_buttons) do
                  if cat == category then
                    XEditorFilters:UpdateVisibility(cat, "visible")
                  elseif filter == "visible" then
                    XEditorFilters:UpdateVisibility(cat, "unselectable")
                  end
                end
              else
                XEditorFilters:ToggleFilter(category, false)
              end
              if LocalStorage.FilteredCategories.HideTop == "invisible" then
                XEditorFilters:UpdateVisibility("HideTop", "invisible")
              end
              self:SetIconRow(row)
              self:OnRowChange(row)
            end,
            "AltPress",
            true,
            "OnAltPress",
            function(self, gamepad)
              if self.action and self.action.OnAltAction then
                local host = GetActionsHost(self, true)
                if host then
                  self.action:OnAltAction(host, self)
                end
              end
              local category = self:GetRolloverText()
              if terminal.IsKeyPressed(const.vkControl) then
                local categories = {
                  [category] = true
                }
                XEditorFilters:UpdateVisibility(category, "visible")
                XEditorFilters:UpdateVisibility(categories, "invisible")
              else
                XEditorFilters:ToggleFilter(category, true)
                if LocalStorage.FilteredCategories.HideTop == "invisible" then
                  XEditorFilters:UpdateVisibility("HideTop", "invisible")
                end
              end
            end,
            "RolloverBorderColor",
            RGBA(128, 128, 128, 255),
            "PressedBorderColor",
            RGBA(128, 128, 128, 255),
            "Icon",
            "CommonAssets/UI/Icons/lock login padlock password safe secure_white",
            "IconRows",
            1,
            "TextStyle",
            "GedDefaultWhite"
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "CalcBackground(self)",
              "func",
              function(self)
                local category = self:GetRolloverText()
                local filter = XEditorFilters:GetFilter(category)
                if filter == "visible" then
                  self.Background = RGB(0, 96, 0)
                  self.RolloverBackground = RGB(0, 128, 0)
                  self.PressedBackground = RGB(0, 196, 0)
                elseif filter == "invisible" then
                  self.Background = RGB(96, 0, 0)
                  self.RolloverBackground = RGB(128, 0, 0)
                  self.PressedBackground = RGB(196, 0, 0)
                elseif filter == "unselectable" then
                  self.Background = RGB(96, 96, 96)
                  self.RolloverBackground = RGB(128, 128, 128)
                  self.PressedBackground = RGB(196, 196, 196)
                end
                self.BorderColor = RGBA(128, 128, 128, 255)
                self.RolloverBorderColor = RGBA(128, 128, 128, 255)
                self.PressedBorderColor = RGBA(128, 128, 128, 255)
                if not self.enabled then
                  return self.DisabledBackground
                end
                if self.state == "pressed-in" or self.state == "pressed-out" then
                  return self.PressedBackground
                end
                if self.state == "mouse-in" then
                  return self.RolloverBackground
                end
                return self:IsFocused() and self.FocusedBackground or self.Background
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnMouseLeft(self, ...)",
              "func",
              function(self, ...)
                XEditorFilters:HighlightObjects(self:GetRolloverText(), false)
                XControl.OnMouseLeft(self, ...)
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnMouseEnter(self, ...)",
              "func",
              function(self, ...)
                XEditorFilters:HighlightObjects(self:GetRolloverText(), true)
                XControl.OnMouseEnter(self, ...)
              end
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XTextButton",
          "BorderWidth",
          1,
          "BorderColor",
          RGBA(128, 128, 128, 255),
          "FocusedBorderColor",
          RGBA(128, 128, 128, 255),
          "DisabledBorderColor",
          RGBA(128, 128, 128, 255),
          "OnPress",
          function(self, gamepad)
            local categories = {}
            local allCategories = XEditorFilters:GetCategories()
            for _, category in ipairs(allCategories) do
              if not table.find(table.keys(self.context.filter_buttons), category) then
                table.insert(categories, category)
              end
            end
            CreateRealTimeThread(function()
              local categories = WaitListMultipleChoice(nil, categories, "Choose category / categories:")
              XEditorFilters:Add(categories)
            end)
          end,
          "RolloverBorderColor",
          RGBA(128, 128, 128, 255),
          "PressedBorderColor",
          RGBA(128, 128, 128, 255),
          "Text",
          "Add"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XTextButton",
          "BorderWidth",
          1,
          "BorderColor",
          RGBA(128, 128, 128, 255),
          "FocusedBorderColor",
          RGBA(128, 128, 128, 255),
          "DisabledBorderColor",
          RGBA(128, 128, 128, 255),
          "OnPress",
          function(self, gamepad)
            local categories = {}
            local allCategories = XEditorFilters:GetCategories()
            for _, category in ipairs(allCategories) do
              if table.find(table.keys(self.context.filter_buttons), category) and category ~= "All" then
                table.insert(categories, category)
              end
            end
            CreateRealTimeThread(function()
              local categories = WaitListMultipleChoice(nil, categories, "Choose category / categories:")
              XEditorFilters:Remove(categories)
            end)
          end,
          "RolloverBorderColor",
          RGBA(128, 128, 128, 255),
          "PressedBorderColor",
          RGBA(128, 128, 128, 255),
          "Text",
          "Remove"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return const.SlabSizeX
        end,
        "Id",
        "Rooms",
        "IdNode",
        true,
        "LayoutMethod",
        "VList",
        "UniformColumnWidth",
        true,
        "BorderColor",
        RGBA(41, 41, 41, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "Id",
          "idSection",
          "BorderWidth",
          1,
          "Padding",
          box(2, 1, 2, 1),
          "BorderColor",
          RGBA(41, 41, 41, 255),
          "Background",
          RGBA(41, 41, 41, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XLabel",
            "Id",
            "idSectionName",
            "HAlign",
            "center",
            "VAlign",
            "center",
            "BorderColor",
            RGBA(41, 41, 41, 255),
            "TextStyle",
            "XEditorToolbarDark",
            "Text",
            "Rooms"
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XToggleButton",
          "RolloverTemplate",
          "XEditorToolbarRollover",
          "RolloverText",
          T(144816122915, "Roofs"),
          "BorderWidth",
          1,
          "BorderColor",
          RGBA(128, 128, 128, 255),
          "Background",
          RGBA(0, 96, 0, 255),
          "OnContextUpdate",
          function(self, context, ...)
          end,
          "FocusedBorderColor",
          RGBA(128, 128, 128, 255),
          "DisabledBorderColor",
          RGBA(128, 128, 128, 255),
          "OnPress",
          function(self, gamepad)
            self:SetToggled(not self.Toggled)
            self.context.roof_visuals_enabled = not self.context.roof_visuals_enabled
            LocalStorage.FilteredCategories.Roofs = self.context.roof_visuals_enabled
            XEditorFilters:UpdateHiddenRoofsAndFloors()
          end,
          "AltPress",
          true,
          "OnAltPress",
          function(self, gamepad)
            if self.action and self.action.OnAltAction then
              local host = GetActionsHost(self, true)
              if host then
                self.action:OnAltAction(host, self)
              end
            end
            self.context.roof_visuals_enabled = not self.context.roof_visuals_enabled
            LocalStorage.FilteredCategories.Roofs = self.context.roof_visuals_enabled
            XEditorFilters:UpdateHiddenRoofsAndFloors()
          end,
          "RolloverBorderColor",
          RGBA(128, 128, 128, 255),
          "PressedBorderColor",
          RGBA(128, 128, 128, 255),
          "TextStyle",
          "GedDefaultWhite",
          "Text",
          "Roofs",
          "ToggledBackground",
          RGBA(96, 0, 0, 255),
          "ToggledBorderColor",
          RGBA(128, 128, 128, 255)
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "OnSetRollover(self, rollover)"
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "CalcBackground(self)",
            "func",
            function(self)
              local filter = LocalStorage.FilteredCategories.Roofs
              if filter then
                self.Background = RGB(0, 96, 0)
                self.RolloverBackground = RGB(0, 128, 0)
                self.PressedBackground = RGB(0, 196, 0)
              else
                self.Background = RGB(96, 0, 0)
                self.RolloverBackground = RGB(128, 0, 0)
                self.PressedBackground = RGB(196, 0, 0)
              end
              self.BorderColor = RGBA(128, 128, 128, 255)
              self.RolloverBorderColor = RGBA(128, 128, 128, 255)
              self.PressedBorderColor = RGBA(128, 128, 128, 255)
              self:SetIcon("")
              if not self.enabled then
                return self.DisabledBackground
              end
              if self.state == "pressed-in" or self.state == "pressed-out" then
                return self.PressedBackground
              end
              if self.state == "mouse-in" then
                return self.RolloverBackground
              end
              return self:IsFocused() and self.FocusedBackground or self.Background
            end
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XLabel",
          "Background",
          RGBA(64, 64, 64, 255),
          "Text",
          "Hide floor"
        }),
        PlaceObj("XTemplateWindow", nil, {
          PlaceObj("XTemplateFunc", {
            "name",
            "Open(self, ...)",
            "func",
            function(self, ...)
              local edit = CreateNumberEditor(self, "idEdit", function(multiplier)
                local floor = XEditorFilters:SetHideFloorFilter(multiplier)
                self:ResolveId("idEdit"):SetText(tostring(floor))
              end, function(multiplier)
                local floor = XEditorFilters:SetHideFloorFilter(-multiplier)
                self:ResolveId("idEdit"):SetText(tostring(floor))
              end)
              local floors = 0
              MapForEach("map", "Room", function(o)
                if o.floor > floors then
                  floors = o.floor
                end
              end)
              self[1]:SetBackground(RGBA(64, 64, 64, 255))
              local text = tostring(LocalStorage.FilteredCategories.HideFloor)
              edit:SetText(text)
              edit.AutoSelectAll = true
              function edit.OnTextChanged(edit)
                local value = tonumber(edit:GetText()) or 0
                LocalStorage.FilteredCategories.HideFloor = Clamp(value, 0, floors + 1)
                edit:SetText(tostring(LocalStorage.FilteredCategories.HideFloor))
                XEditorFilters:UpdateHiddenRoofsAndFloors()
                edit:SelectAll()
              end
              function edit:OnShortcut(shortcut, source, ...)
                if shortcut == "Escape" then
                  terminal.desktop:RemoveKeyboardFocus(self, true)
                else
                  XEdit.OnShortcut(self, shortcut, source, ...)
                end
              end
              return XWindow.Open(self, ...)
            end
          })
        })
      })
    })
  })
})
