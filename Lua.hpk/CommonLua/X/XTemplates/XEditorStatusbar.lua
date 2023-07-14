PlaceObj("XTemplate", {
  __is_kind_of = "XDarkModeAwareDialog",
  group = "Editor",
  id = "XEditorStatusbar",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDarkModeAwareDialog",
    "ZOrder",
    -1,
    "Dock",
    "bottom",
    "MaxHeight",
    35,
    "FoldWhenHidden",
    true,
    "Background",
    RGBA(0, 0, 0, 255),
    "HandleMouse",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "BorderWidth",
      1,
      "Dock",
      "top",
      "MinHeight",
      1,
      "MaxHeight",
      1
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "undo queue",
      "__class",
      "XCombo",
      "Margins",
      box(5, 0, 0, 0),
      "Dock",
      "left",
      "VAlign",
      "center",
      "MinWidth",
      240,
      "MaxWidth",
      240,
      "FoldWhenHidden",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local open = self:IsPopupOpen()
        if open then
          self:CloseCombo()
        end
        self.Items = XEditorUndo:GetOpNames()
        self:SetValue(self.Items[XEditorUndo:GetCurrentOpNameIdx()] or self.Items[1])
        local opsDone = self.Items[1] ~= "No recent operations" or #self.Items > 1
        self:SetEnabled(opsDone)
        if open then
          self:OpenCombo("select")
        end
      end,
      "Items",
      function(self)
        return XEditorUndo:GetOpNames()
      end,
      "ArbitraryValue",
      false,
      "ListItemTemplate",
      "XComboXTextListItemLight",
      "OnValueChanged",
      function(self, value)
        XEditorUndo:RollToOpIndex(table.find(self.Items, value))
        self.Items = XEditorUndo:GetOpNames()
        self:SetValue(self.Items[XEditorUndo:GetCurrentOpNameIdx()])
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Margins",
      box(5, 0, 5, 0),
      "Dock",
      "left",
      "VAlign",
      "center",
      "Background",
      RGBA(0, 0, 0, 255),
      "OnContextUpdate",
      function(self, context, ...)
        local text = {}
        local sel = selo()
        if sel then
          local info = sel.class
          local editor_info = table.fget(sel, "EditorGetText", "(", ",", ":", ")")
          if editor_info and editor_info ~= info then
            info = info .. ": " .. editor_info
            local max_len = 70
            if max_len < #info then
              info = string.sub(info, 1, max_len)
            end
          end
          text[#text + 1] = info .. (1 < #editor.GetSel() and ", ..." or "")
        end
        if 1 < #editor.GetSel() then
          local col_num = editor.GetSelUniqueCollections()
          if col_num == 0 then
            text[#text + 1] = string.format("(%d objects)", #editor.GetSel())
          else
            text[#text + 1] = string.format("(%d objects, %d collections)", #editor.GetSel(), col_num)
          end
        end
        self.Text = table.concat(text, " ")
        self:SetText(self.Text)
        XContextControl.OnContextUpdate(self, context)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XTextButton",
      "Margins",
      box(5, 0, 5, 0),
      "BorderWidth",
      2,
      "Dock",
      "right",
      "VAlign",
      "center",
      "FocusedBorderColor",
      RGBA(128, 128, 128, 255),
      "DisabledBorderColor",
      RGBA(128, 128, 128, 255),
      "OnPress",
      function(self, gamepad)
        XEditorSettings:ToggleGedEditor()
      end,
      "RolloverBorderColor",
      RGBA(128, 128, 128, 255),
      "PressedBorderColor",
      RGBA(128, 128, 128, 255),
      "Text",
      "Settings"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XToolBar",
      "RolloverAnchor",
      "top",
      "Margins",
      box(3, 0, 3, 0),
      "Dock",
      "right",
      "Toolbar",
      "EditorStatusbar",
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
    PlaceObj("XTemplateWindow", {
      "Margins",
      box(0, 4, 0, 4),
      "BorderWidth",
      1,
      "Dock",
      "right",
      "MinWidth",
      2,
      "MaxWidth",
      2
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "groups",
      "__class",
      "XCheckButtonCombo",
      "Margins",
      box(4, 0, 4, 0),
      "Dock",
      "right",
      "VAlign",
      "center",
      "MinWidth",
      185,
      "MaxWidth",
      185,
      "FoldWhenHidden",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local groups = XEditorGroupsComboItems(editor.GetSel())
        local count, group = 0, false
        for _, item in ipairs(groups) do
          if item.value ~= false then
            count = count + 1
            group = item.id
          end
        end
        self:SetText(count == 0 and "No groups" or count == 1 and group or "Multiple groups")
        self:SetEditable(#editor.GetSel() > 0)
      end,
      "Editable",
      true,
      "Items",
      function(self)
        return XEditorGroupsComboItems(editor.GetSel())
      end,
      "OnCheckButtonChanged",
      function(self, id, value)
        for _, obj in ipairs(editor.GetSel()) do
          if value then
            obj:AddToGroup(id)
          else
            obj:RemoveFromGroup(id)
          end
        end
        self:OnContextUpdate()
      end,
      "OnTextChanged",
      function(self, value)
        if value == "No groups" or value == "Multiple groups" then
          return
        end
        if Groups[value] then
          local groups = {value}
          for _, obj in ipairs(editor.GetSel()) do
            obj:SetGroups(groups)
          end
          self:SetFocus(false)
          return
        end
        CreateRealTimeThread(function()
          if WaitQuestion(terminal.desktop, Untranslated("Warning"), Untranslated(string.format("No such group '%s'. Create a new group?", value)), Untranslated("Yes"), Untranslated("No")) == "ok" then
            local groups = {value}
            for _, obj in ipairs(editor.GetSel()) do
              obj:SetGroups(groups)
            end
            self:SetFocus(false)
          end
        end)
      end,
      "OnComboOpened",
      function(self, popup)
        for _, checkbox in ipairs(popup.idContainer) do
          XImage:new({
            Image = "CommonAssets/UI/Icons/eye outline.png",
            ImageFit = "scale-down",
            Dock = "right",
            MaxHeight = 24,
            HandleMouse = true,
            Background = 0,
            OnSetRollover = function(image, value)
              local color = GetDarkModeSetting() and RGB(102, 102, 102) or RGB(200, 200, 200)
              image:SetBackground(value and color or 0)
              XEditorShowObjects(Groups[checkbox.Id], value)
            end,
            OnMouseButtonDown = function(image, pt, button)
              if button == "L" then
                XEditorShowObjects(Groups[checkbox.Id], "select_permanently")
                self:CloseCombo()
              end
              return "break"
            end
          }, checkbox)
          checkbox:SetChildrenHandleMouse(true)
        end
      end
    }),
    PlaceObj("XTemplateWindow", {
      "Margins",
      box(0, 4, 0, 4),
      "BorderWidth",
      1,
      "Dock",
      "right",
      "MinWidth",
      2,
      "MaxWidth",
      2
    }),
    PlaceObj("XTemplateWindow", {
      "Dock",
      "right",
      "FoldWhenHidden",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "HAlign",
        "center",
        "VAlign",
        "center",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local dialog = GetDialog("XSelectObjectsTool") or GetDialog("XPlaceObjectTool")
          local class_name = dialog and dialog:GetHelperClass() or XSelectObjectsTool:GetHelperClass()
          self.parent:SetVisible(dialog)
          if class_name then
            local parent = self.parent
            parent[1]:SetVisible(not g_Classes[class_name].HasSnapSetting)
            parent[2]:SetVisible(g_Classes[class_name].HasSnapSetting)
          end
          self:SetText(self.Text)
          XContextControl.OnContextUpdate(self, context)
        end,
        "Text",
        "(tool does not support snapping)"
      }),
      PlaceObj("XTemplateWindow", {
        "LayoutMethod",
        "HList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XCombo",
          "Margins",
          box(5, 0, 0, 0),
          "VAlign",
          "center",
          "MinWidth",
          105,
          "MaxWidth",
          105,
          "OnContextUpdate",
          function(self, context, ...)
            self:SetValue(XEditorSettings:GetSnapMode())
          end,
          "Items",
          function(self)
            return XEditorSettings:GetSnapModes()
          end,
          "ArbitraryValue",
          false,
          "OnValueChanged",
          function(self, value)
            XEditorSettings:SetSnapMode(value)
            local parent = self.parent
            for i = 1, #parent do
              if parent[i] ~= self then
                parent[i]:SetEnabled(value == "Custom")
              end
            end
            if GetDialog("XSelectObjectsTool") or GetDialog("XPlaceObjectTool") then
              XEditorSettings:OnEditorSetProperty("SnapMode")
            end
            XEditorUpdateToolbars()
          end
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "OnShortcut(self, shortcut, source, ...)",
            "func",
            function(self, shortcut, source, ...)
              if shortcut == "Escape" then
                terminal.desktop:RemoveKeyboardFocus(self, true)
              else
                XCombo.OnShortcut(self, shortcut, source, ...)
              end
            end
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Margins",
          box(10, 0, 0, 0),
          "VAlign",
          "center",
          "Text",
          "XY:"
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "snapping XY edit",
          "__class",
          "XEdit",
          "VAlign",
          "center",
          "MinWidth",
          40,
          "MaxWidth",
          40,
          "OnContextUpdate",
          function(self, context, ...)
            LocalStorage.SnapXY = LocalStorage.SnapXY or 0
            local text = XEditorSettings:GetSnapMode() == "Custom" and tostring(1.0 * LocalStorage.SnapXY / guim) or tostring(1.0 * XEditorSettings:GetSnapXY() / guim)
            self:SetText(text)
          end,
          "OnTextChanged",
          function(self)
            local value = tonumber(self:GetText())
            value = value or 0
            value = floatfloor(value * guim)
            XEditorSettings:SetSnapXY(value)
            LocalStorage.SnapXY = XEditorSettings:GetSnapMode() == "Custom" and value or LocalStorage.SnapXY or 0
          end
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "OnShortcut(self, shortcut, source, ...)",
            "func",
            function(self, shortcut, source, ...)
              if shortcut == "Escape" then
                terminal.desktop:RemoveKeyboardFocus(self, true)
              else
                XEdit.OnShortcut(self, shortcut, source, ...)
              end
            end
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "VAlign",
          "center",
          "Text",
          "m"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Margins",
          box(6, 0, 0, 0),
          "VAlign",
          "center",
          "Text",
          "Z:"
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "snapping Z edit",
          "__class",
          "XEdit",
          "VAlign",
          "center",
          "MinWidth",
          40,
          "MaxWidth",
          40,
          "OnContextUpdate",
          function(self, context, ...)
            LocalStorage.SnapZ = LocalStorage.SnapZ or 0
            local text = XEditorSettings:GetSnapMode() == "Custom" and tostring(1.0 * LocalStorage.SnapZ / guim) or tostring(1.0 * XEditorSettings:GetSnapZ() / guim)
            self:SetText(text)
          end,
          "OnTextChanged",
          function(self)
            local value = tonumber(self:GetText())
            value = value or 0
            value = floatfloor(value * guim)
            XEditorSettings:SetSnapZ(value)
            LocalStorage.SnapZ = XEditorSettings:GetSnapMode() == "Custom" and value or LocalStorage.SnapZ or 0
          end
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "OnShortcut(self, shortcut, source, ...)",
            "func",
            function(self, shortcut, source, ...)
              if shortcut == "Escape" then
                terminal.desktop:RemoveKeyboardFocus(self, true)
              else
                XEdit.OnShortcut(self, shortcut, source, ...)
              end
            end
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "VAlign",
          "center",
          "Text",
          "m"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Margins",
          box(6, 0, 0, 0),
          "VAlign",
          "center",
          "Text",
          "A"
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "snapping angle edit",
          "__class",
          "XEdit",
          "VAlign",
          "center",
          "MinWidth",
          40,
          "MaxWidth",
          40,
          "OnContextUpdate",
          function(self, context, ...)
            LocalStorage.SnapAngle = LocalStorage.SnapAngle or 0
            local text = XEditorSettings:GetSnapMode() == "Custom" and tostring(1.0 * LocalStorage.SnapAngle / 60) or tostring(1.0 * XEditorSettings:GetSnapAngle() / 60)
            self:SetText(text)
          end,
          "OnTextChanged",
          function(self)
            local value = tonumber(self:GetText())
            value = value or 0
            value = floatfloor(value * 60)
            XEditorSettings:SetSnapAngle(value)
            LocalStorage.SnapAngle = XEditorSettings:GetSnapMode() == "Custom" and value or LocalStorage.SnapAngle or 0
          end
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "OnShortcut(self, shortcut, source, ...)",
            "func",
            function(self, shortcut, source, ...)
              if shortcut == "Escape" then
                terminal.desktop:RemoveKeyboardFocus(self, true)
              else
                XEdit.OnShortcut(self, shortcut, source, ...)
              end
            end
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "VAlign",
          "center",
          "Text",
          "\194\176"
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XCheckButton",
      "Margins",
      box(5, 0, 5, 0),
      "Dock",
      "right",
      "FoldWhenHidden",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local dialog = GetDialog("XSelectObjectsTool") or GetDialog("XPlaceObjectTool")
        local class_name = dialog and dialog:GetHelperClass() or XSelectObjectsTool:GetHelperClass()
        self:SetVisible(dialog)
        if class_name then
          self:SetEnabled(g_Classes[class_name].HasSnapSetting)
        end
        if self:GetEnabled() then
          local row = XEditorSettings:GetSnapEnabled() and 2 or 1
          self:SetIconRow(row)
          self:OnRowChange(row)
        end
        self:SetText(self.Text)
        XContextControl.OnContextUpdate(self, context)
      end,
      "OnPress",
      function(self, gamepad)
        XEditorSettings:SetSnapEnabled(not XEditorSettings:GetSnapEnabled())
        XEditorUpdateToolbars()
        local row = XEditorSettings:GetSnapEnabled() and 2 or 1
        self:SetIconRow(row)
        self:OnRowChange(row)
      end,
      "Text",
      "Snap"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XCheckButton",
      "Margins",
      box(5, 0, 5, 0),
      "Dock",
      "right",
      "FoldWhenHidden",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local dialog = GetDialog("XSelectObjectsTool") or GetDialog("XPlaceObjectTool")
        local class_name = dialog and dialog:GetHelperClass() or XSelectObjectsTool:GetHelperClass()
        self:SetVisible(dialog)
        if class_name then
          self:SetEnabled(g_Classes[class_name].HasLocalCSSetting)
        end
        if self:GetEnabled() then
          local row = GetLocalCS() and 2 or 1
          self:SetIconRow(row)
          self:OnRowChange(row)
        end
        self:SetText(self.Text)
        XContextControl.OnContextUpdate(self, context)
      end,
      "OnPress",
      function(self, gamepad)
        SetLocalCS(not GetLocalCS())
        XEditorUpdateToolbars()
        local row = GetLocalCS() and 2 or 1
        self:SetIconRow(row)
        self:OnRowChange(row)
      end,
      "Text",
      "Local CS"
    }),
    PlaceObj("XTemplateWindow", {
      "Margins",
      box(0, 4, 0, 4),
      "BorderWidth",
      1,
      "Dock",
      "right",
      "MinWidth",
      2,
      "MaxWidth",
      2
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XToolBar",
      "RolloverAnchor",
      "top",
      "Margins",
      box(3, 0, 3, 0),
      "Dock",
      "right",
      "Toolbar",
      "XEditorStatusbar",
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
    })
  })
})
