PlaceObj("XTemplate", {
  Comment = "(new one)",
  __is_kind_of = "XContextWindow",
  group = "Zulu",
  id = "CombatActionBar",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return "Children updated manually"
    end,
    "__class",
    "XContextWindow",
    "Id",
    "idActionButtonsBar",
    "VAlign",
    "bottom",
    "LayoutMethod",
    "HList",
    "HandleMouse",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "combat_bar"
      end,
      "__class",
      "XContentTemplate",
      "IdNode",
      false,
      "LayoutMethod",
      "HList"
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "RespawnContent(self, ...)",
        "func",
        function(self, ...)
          if UIRebuildSpam then
            DbgUIRebuild("combat actions")
          end
          XContentTemplate.RespawnContent(self, ...)
        end
      }),
      PlaceObj("XTemplateTemplate", {
        "__context",
        function(parent, context)
          return Selection
        end,
        "__condition",
        function(parent, context)
          return context and 0 < #context
        end,
        "__template",
        "CombatActionsToActions"
      }),
      PlaceObj("XTemplateTemplate", {
        "comment",
        "hide/reveal",
        "__context",
        function(parent, context)
          return "combat_bar"
        end,
        "__template",
        "GenericHUDButtonFrame",
        "Id",
        "idHideButtonFrame",
        "Margins",
        box(0, 0, 10, 0),
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local action = CombatActions.Hide
          local state = action:GetUIState(Selection)
          if state == "hidden" then
            action = CombatActions.Reveal
            state = "enabled"
          end
          local context = SubContext(Selection, {
            action = action,
            iAction = action,
            RolloverTitle = action:GetActionDisplayName(Selection),
            RolloverText = action:GetActionDescription(Selection)
          })
          self.idHideButton:SetContext(context)
        end
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "HUDButton",
          "RolloverTemplate",
          "CombatActionRollover",
          "RolloverAnchor",
          "custom",
          "RolloverOffset",
          box(0, 0, 0, 22),
          "Id",
          "idHideButton",
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            local action = self.context.action
            if not action then
              return
            end
            local state = action:GetUIState(Selection)
            local text = ""
            if GetUIStyleGamepad() then
              local buttonXIsStealth = DetermineUnitCombatActionButtonX()
              buttonXIsStealth = buttonXIsStealth == CombatActions.Hide or buttonXIsStealth == CombatActions.Reveal
              if self.selected then
                local tag = GetPlatformSpecificImageTag("ButtonA", 650)
                tag = Untranslated(tag)
                text = tag
              elseif buttonXIsStealth then
                local tag = GetPlatformSpecificImageTag("ButtonX", 650)
                tag = Untranslated(tag)
                text = tag
              end
              self:SetText(text)
            else
              text = GetShortcutButtonT("toggleHide")
              self:SetText(T({
                775518317251,
                "[<name>]",
                name = text
              }))
            end
            if state == "enabled" then
              self:SetColumns(2)
              self:SetImage(action:GetActionIcon(Selection))
            else
              self:SetColumns(1)
              self:SetImage("UI/Icons/Hud/stealth_disabled.tga")
            end
            self:SetEnabled(state == "enabled")
            self:SetRolloverText(action:GetActionDescription(Selection))
            UpdateTakeCoverAction()
          end,
          "OnPress",
          function(self, gamepad)
            local igiM = GetInGameInterfaceModeDlg()
            if IsKindOf(igiM, "IModeCommonUnitControl") then
              igiM:ToggleHide()
            end
          end
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "GetRolloverText(self)"
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "SetFocused(self, focus)",
            "func",
            function(self, focus)
              self:SetFocus(focus)
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "OnSetFocus(self)",
            "func",
            function(self)
              self:SetSelected(true)
              self:OnContextUpdate()
              XWindow.OnSetFocus(self)
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "OnKillFocus(self)",
            "func",
            function(self)
              self:SetSelected(false)
              self:OnContextUpdate()
              local dlg = GetDialog(self)
              dlg:ActionBarUnfocusCheck()
              XWindow.OnKillFocus(self)
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "IsSelectable(self)",
            "func",
            function(self)
              return true
            end
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "controller observer",
            "__context",
            function(parent, context)
              return "GamepadUIStyleChanged"
            end,
            "__class",
            "XContextWindow",
            "Id",
            "idControllerSelection",
            "IdNode",
            true,
            "HAlign",
            "center",
            "VAlign",
            "bottom",
            "UseClipBox",
            false,
            "Visible",
            false,
            "OnContextUpdate",
            function(self, context, ...)
              local node = self:ResolveId("node")
              local frame = node:ResolveId("node")
              frame:OnContextUpdate(frame.context)
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "OnShortcut(self, shortcut, source, ...)",
            "func",
            function(self, shortcut, source, ...)
              if shortcut == "DPadRight" then
                local node = self:ResolveId("node"):ResolveId("node")
                local mainBar = node.idCombatActionsContainer
                mainBar:SetFocus()
                SelectFirstSelectableItemInList(mainBar, "right")
                return "break"
              elseif shortcut == "DPadLeft" then
                GamepadFocusStanceList()
                return "break"
              elseif shortcut == "ButtonB" then
                local igi = GetInGameInterfaceModeDlg()
                igi:SetFocus()
                return "break"
              elseif shortcut == "-ButtonA" then
                self:OnPress()
                return "break"
              elseif shortcut == "+ButtonA" then
                return "break"
              end
            end
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idBarHolder",
        "VAlign",
        "bottom",
        "BackgroundRectGlowSize",
        1,
        "BackgroundRectGlowColor",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return Selection
          end,
          "__condition",
          function(parent, context)
            return context and 0 < #context
          end,
          "__class",
          "XList",
          "Id",
          "idCombatActionsContainer",
          "IdNode",
          false,
          "BorderWidth",
          2,
          "Padding",
          box(10, 0, 10, 0),
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          2,
          "BorderColor",
          RGBA(52, 55, 61, 230),
          "Background",
          RGBA(32, 35, 47, 215),
          "FocusedBorderColor",
          RGBA(52, 55, 61, 230),
          "FocusedBackground",
          RGBA(32, 35, 47, 215),
          "DisabledBorderColor",
          RGBA(52, 55, 61, 230),
          "DisabledBackground",
          RGBA(32, 35, 47, 215),
          "LeftThumbScroll",
          false
        }, {
          PlaceObj("XTemplateForEachAction", {
            "menubar",
            "CombatActions",
            "__context",
            function(parent, context, action, n)
              return SubContext(Selection, {
                action = CombatActions[action.ActionId],
                iAction = action
              })
            end
          }, {
            PlaceObj("XTemplateTemplate", {
              "__template",
              "CombatActionBarButton"
            })
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "Open(self)",
            "func",
            function(self)
              XContextWindow.Open(self)
              self:ShowSelected()
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "OnKillFocus(self)",
            "func",
            function(self)
              local dlg = GetDialog(self)
              dlg:ActionBarUnfocusCheck()
              XWindow.OnKillFocus(self)
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "ShowSelected(self)",
            "func",
            function(self)
              local dlg = GetDialog(self)
              if IsKindOf(dlg, "IModeCombatAttackBase") and dlg.action then
                local actionId = dlg.action.id
                local wnd = table.find_value(self, "Id", actionId)
                if wnd then
                  wnd:SetCurrentAction(true)
                end
              end
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "OnShortcut(self, shortcut, source, ...)",
            "func",
            function(self, shortcut, source, ...)
              local nextOne = false
              if shortcut == "Left" then
                nextOne = self:NextSelectableItem(self.focused_item, -1, -1)
                if not nextOne then
                  local node = self:ResolveId("node")
                  local stealthBar = node.idHideButtonFrame
                  stealthBar = stealthBar and stealthBar.idHideButton
                  if stealthBar then
                    stealthBar:SetFocus()
                    return "break"
                  end
                end
              elseif shortcut == "Right" then
                nextOne = self:NextSelectableItem(self.focused_item, 1, 1)
                if not nextOne then
                  local node = self:ResolveId("node")
                  local signature = node.idSignatureAbilitiesContainer
                  if not signature then
                    return "break"
                  end
                  local firstItem = signature and signature[1]
                  if firstItem then
                    signature:SetFocus()
                    SelectFirstSelectableItemInList(signature, "right")
                    return "break"
                  end
                end
              elseif shortcut == "ButtonB" then
                local igi = GetInGameInterfaceModeDlg()
                igi:SetFocus()
                return "break"
              end
              return XList.OnShortcut(self, shortcut, source, ...)
            end
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 0, 0, -2),
          "Dock",
          "top",
          "MinHeight",
          7,
          "MaxHeight",
          7,
          "Background",
          RGBA(52, 55, 61, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(0, 1, 2, 0),
            "HAlign",
            "right",
            "VAlign",
            "top",
            "MinWidth",
            6,
            "MinHeight",
            6,
            "MaxWidth",
            6,
            "MaxHeight",
            6,
            "Background",
            RGBA(69, 73, 81, 255)
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "gamepad hint right",
          "__context",
          function(parent, context)
            return "GamepadUIStyleChanged"
          end,
          "__class",
          "XText",
          "Id",
          "idGamepadHintRight",
          "HAlign",
          "left",
          "VAlign",
          "bottom",
          "Clip",
          false,
          "UseClipBox",
          false,
          "Visible",
          false,
          "FoldWhenHidden",
          true,
          "TextStyle",
          "GamepadHint",
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            local focus = terminal.desktop.keyboard_focus
            local igi = GetDialog(self)
            local bar = igi and igi:ResolveId("idBottomBar")
            local focused = bar and focus and focus:IsWithin(bar)
            if igi.action then
              focused = true
            end
            self:SetText(self.Text)
            self:SetVisible(GetUIStyleGamepad() and not focused)
          end,
          "Translate",
          true,
          "Text",
          T(553990865157, "<ShortcutName('GamepadActionBarFocusRight')>")
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "UICombatBarShown observer",
            "__context",
            function(parent, context)
              return "UICombatBarShown"
            end,
            "__class",
            "XContextWindow",
            "OnContextUpdate",
            function(self, context, ...)
              self.parent:OnContextUpdate()
            end
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "focus observer"
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "Open(self)",
              "func",
              function(self)
                XWindow.Open(self)
                self:CreateThread("focus-observer", function()
                  while self.window_state ~= "destroying" do
                    self.parent:OnContextUpdate()
                    Sleep(100)
                  end
                end)
              end
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "gamepad hint left",
          "__context",
          function(parent, context)
            return "GamepadUIStyleChanged"
          end,
          "__class",
          "XText",
          "Id",
          "idGamepadHintLeft",
          "HAlign",
          "right",
          "VAlign",
          "bottom",
          "Clip",
          false,
          "UseClipBox",
          false,
          "Visible",
          false,
          "FoldWhenHidden",
          true,
          "TextStyle",
          "GamepadHint",
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            local focus = terminal.desktop.keyboard_focus
            local igi = GetDialog(self)
            local bar = igi and igi:ResolveId("idBottomBar")
            local focused = bar and focus and focus:IsWithin(bar)
            if igi.action then
              focused = true
            end
            self:SetText(self.Text)
            self:SetVisible(GetUIStyleGamepad() and not focused)
          end,
          "Translate",
          true,
          "Text",
          T(840526854200, "<ShortcutName('GamepadActionBarFocusLeft')>")
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "UICombatBarShown observer",
            "__context",
            function(parent, context)
              return "UICombatBarShown"
            end,
            "__class",
            "XContextWindow",
            "OnContextUpdate",
            function(self, context, ...)
              self.parent:OnContextUpdate()
            end
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "focus observer"
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "Open(self)",
              "func",
              function(self)
                XWindow.Open(self)
                self:CreateThread("focus-observer", function()
                  while self.window_state ~= "destroying" do
                    self.parent:OnContextUpdate()
                    Sleep(100)
                  end
                end)
              end
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return Selection and #Selection > 0 and Selection[1]:HasSignatures()
        end,
        "Id",
        "idSignatureBarHolder",
        "Margins",
        box(10, 0, 0, 0),
        "VAlign",
        "bottom",
        "BackgroundRectGlowSize",
        1,
        "BackgroundRectGlowColor",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return Selection
          end,
          "__condition",
          function(parent, context)
            return context and 0 < #context
          end,
          "__class",
          "XList",
          "Id",
          "idSignatureAbilitiesContainer",
          "IdNode",
          false,
          "BorderWidth",
          2,
          "Padding",
          box(0, 0, 0, 0),
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          2,
          "BorderColor",
          RGBA(52, 55, 61, 190),
          "Background",
          RGBA(255, 255, 255, 0),
          "FocusedBorderColor",
          RGBA(52, 55, 61, 230),
          "FocusedBackground",
          RGBA(32, 35, 47, 215),
          "DisabledBorderColor",
          RGBA(52, 55, 61, 230),
          "DisabledBackground",
          RGBA(32, 35, 47, 215),
          "LeftThumbScroll",
          false
        }, {
          PlaceObj("XTemplateForEachAction", {
            "menubar",
            "SignatureAbilities",
            "__context",
            function(parent, context, action, n)
              return SubContext(Selection, {
                action = CombatActions[action.ActionId],
                iAction = action
              })
            end
          }, {
            PlaceObj("XTemplateTemplate", {
              "__template",
              "CombatActionBarButton",
              "RolloverAnchorId",
              "idSignatureBarHolder",
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                local action = CombatActions[self.Id]
                local passiveBackground = RGBA(52, 55, 61, 230)
                local activeBackground = RGBA(32, 35, 47, 215)
                local unit = context[1]
                if action and action.ActionType == "Passive" then
                  self:SetBackground(passiveBackground)
                  self:SetRolloverBackground(passiveBackground)
                  self:SetPressedBackground(passiveBackground)
                  self:SetDisabledBackground(passiveBackground)
                  self:SetMouseCursor("UI/Cursors/Cursor")
                  self:SetColumnsUse("aaaaa")
                  self.NormalBackground = passiveBackground
                elseif action and action.ActionType == "Toggle" then
                  if action:IsToggledOn(unit) then
                    local toggledBackground = const.PDAUIColors.titleColor
                    self:SetBackground(toggledBackground)
                    self:SetRolloverBackground(toggledBackground)
                    self:SetPressedBackground(toggledBackground)
                    self:SetDisabledBackground(toggledBackground)
                    self.NormalBackground = toggledBackground
                  else
                    self:SetBackground(activeBackground)
                    self:SetRolloverBackground(activeBackground)
                    self:SetPressedBackground(activeBackground)
                    self:SetDisabledBackground(activeBackground)
                    self.NormalBackground = activeBackground
                  end
                else
                  self:SetBackground(activeBackground)
                  self:SetRolloverBackground(activeBackground)
                  self:SetPressedBackground(activeBackground)
                  self:SetDisabledBackground(activeBackground)
                  self.NormalBackground = activeBackground
                end
              end
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "SetCurrentAction(self, selected)",
                "func",
                function(self, selected)
                  local titleColor = const.PDAUIColors.titleColor
                  local selBorderColor = const.PDAUIColors.selBorderColor
                  local noClr = const.PDAUIColors.noClr
                  local selectedColored = const.HUDUIColors.selectedColored
                  local defaultColor = const.HUDUIColors.defaultColor
                  self.current_action = true
                  self:SetBackground(selected and titleColor or noClr)
                  self:SetRolloverBackground(selected and titleColor or noClr)
                  self:SetBorderColor(selected and selBorderColor or noClr)
                  self:SetRolloverBorderColor(selected and selBorderColor or noClr)
                  self.idText:SetTextStyle(selected and "HUDButtonKeybindActive" or "HUDButtonKeybind")
                  if not selected and self.NormalBackground then
                    self:SetBackground(self.NormalBackground)
                  end
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "OnSetRollover(self, rollover)",
                "func",
                function(self, rollover)
                  local action = CombatActions[self.Id]
                  if action and action.ActionType == "Passive" then
                    self.idText:SetTextStyle(rollover and "HUDButtonKeybindActive" or "HUDButtonKeybind")
                  end
                  HUDButton.OnSetRollover(self, rollover)
                end
              })
            })
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "Open(self)",
            "func",
            function(self)
              XContextWindow.Open(self)
              self:ShowSelected()
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "ShowSelected(self)",
            "func",
            function(self)
              local dlg = GetDialog(self)
              if IsKindOf(dlg, "IModeCombatAttackBase") and dlg.action then
                local actionId = dlg.action.id
                local wnd = table.find_value(self, "Id", actionId)
                if wnd then
                  wnd:SetCurrentAction(true)
                end
              end
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "OnKillFocus(self)",
            "func",
            function(self)
              local dlg = GetDialog(self)
              dlg:ActionBarUnfocusCheck()
              XWindow.OnKillFocus(self)
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "OnShortcut(self, shortcut, source, ...)",
            "func",
            function(self, shortcut, source, ...)
              local nextOne = false
              if shortcut == "Left" then
                nextOne = self:NextSelectableItem(self.focused_item, -1, -1)
                if not nextOne then
                  local node = self:ResolveId("node")
                  local mainBar = node.idCombatActionsContainer
                  self:SetSelection(false)
                  mainBar:SetFocus()
                  SelectFirstSelectableItemInList(mainBar, "left")
                  return "break"
                end
              elseif shortcut == "ButtonB" then
                local igi = GetInGameInterfaceModeDlg()
                igi:SetFocus()
                return "break"
              end
              return XList.OnShortcut(self, shortcut, source, ...)
            end
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 0, 0, -2),
          "Dock",
          "top",
          "MinHeight",
          7,
          "MaxHeight",
          7,
          "Background",
          RGBA(52, 55, 61, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(0, 1, 2, 0),
            "HAlign",
            "right",
            "VAlign",
            "top",
            "MinWidth",
            6,
            "MinHeight",
            6,
            "MaxWidth",
            6,
            "MaxHeight",
            6,
            "Background",
            RGBA(69, 73, 81, 255)
          })
        })
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        return "break"
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonUp(self, pos, button)",
      "func",
      function(self, pos, button)
        return "break"
      end
    })
  })
})
