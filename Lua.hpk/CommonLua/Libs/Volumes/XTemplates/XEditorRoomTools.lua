PlaceObj("XTemplate", {
  __is_kind_of = "XDarkModeAwareDialog",
  group = "Editor",
  id = "XEditorRoomTools",
  save_in = "Libs/Volumes",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDarkModeAwareDialog",
    "Dock",
    "right",
    "FoldWhenHidden",
    true,
    "Background",
    RGBA(64, 64, 66, 255),
    "HandleMouse",
    true,
    "FocusOnOpen",
    ""
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XScrollArea",
      "Id",
      "idScrollArea",
      "IdNode",
      false,
      "LayoutMethod",
      "VList",
      "VScroll",
      "idScroll"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XToolBar",
        "MaxWidth",
        213,
        "LayoutMethod",
        "VList",
        "Background",
        RGBA(64, 64, 66, 255),
        "Toolbar",
        "EditorRoomWallSelection",
        "Show",
        "text",
        "ButtonTemplate",
        "XEditorRoomToolsButton",
        "ToggleButtonTemplate",
        "XEditorRoomToolsCheckbox",
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
        "__class",
        "XToolBar",
        "Id",
        "idToolbar",
        "LayoutMethod",
        "VList",
        "Background",
        RGBA(64, 64, 66, 255),
        "Toolbar",
        "EditorRoomTools",
        "Show",
        "text",
        "ButtonTemplate",
        "XEditorRoomToolsButton",
        "ToggleButtonTemplate",
        "XEditorRoomToolsCheckbox",
        "ToolbarSectionTemplate",
        "XEditorRoomToolsSection"
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
        "__class",
        "XSleekScroll",
        "Id",
        "idScroll",
        "Dock",
        "right",
        "MinWidth",
        5,
        "Target",
        "idScrollArea",
        "AutoHide",
        true
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Dock",
      "bottom",
      "Text",
      [[
Hold Ctrl for preview
Right-click to edit programs]],
      "TextHAlign",
      "center"
    }),
    PlaceObj("XTemplateFunc", {
      "comment",
      "highlight related actions, right-click disabled actions",
      "name",
      "Open",
      "func",
      function(self, ...)
        self:CreateThread("Rollover", function()
          local old_related = {}
          local old_hovered_with_ctrl, just_executed, selection_after_execute
          while true do
            Sleep(100)
            local buttons = GetChildrenOfKind(self, "XTextButton")
            for _, button in ipairs(buttons) do
              function button:Press(alt, force, gamepad)
                if alt then
                  self:OnAltPress(gamepad)
                elseif not alt and self.enabled and old_hovered_with_ctrl == self.action then
                  just_executed = self.action
                  old_hovered_with_ctrl = nil
                  editor.ClearSel()
                  editor.AddToSel(selection_after_execute)
                else
                  XButton.Press(self, alt, force, gamepad)
                end
              end
            end
            for _, win in ipairs(old_related) do
              win:SetTextStyle(GetDarkModeSetting() and "GedDefaultDarkMode" or "GedDefault")
            end
            local new_hovered_with_ctrl
            local win = self:GetMouseTarget(terminal.GetMousePos())
            if win and rawget(win, "action") and rawget(win.action, "GetRelatedActions") then
              local related = win.action:GetRelatedActions(XShortcutsTarget) or empty_table
              related = table.map(related, function(action)
                return table.find_value(buttons, "action", action)
              end)
              for _, win in ipairs(related) do
                win:SetTextStyle("GedHighlight")
              end
              old_related = related
              if terminal.IsKeyPressed(const.vkControl) and win.enabled and win.action ~= just_executed then
                new_hovered_with_ctrl = win.action
              end
            end
            if new_hovered_with_ctrl ~= old_hovered_with_ctrl then
              if old_hovered_with_ctrl then
                local sel = editor.GetSel()
                if selection_after_execute then
                  editor.ClearSel()
                  editor.AddToSel(selection_after_execute)
                  selection_after_execute = nil
                end
                XEditorUndo:UndoRedo("undo")
                editor.ClearSel()
                editor.AddToSel(sel)
              end
              if new_hovered_with_ctrl then
                local sel = editor.GetSel()
                GenExtras(new_hovered_with_ctrl.ActionId)
                selection_after_execute = editor.GetSel()
                editor.ClearSel()
                editor.AddToSel(sel)
              end
              old_hovered_with_ctrl = new_hovered_with_ctrl
            end
          end
        end)
        XDarkModeAwareDialog.Open(self, ...)
      end
    })
  })
})
