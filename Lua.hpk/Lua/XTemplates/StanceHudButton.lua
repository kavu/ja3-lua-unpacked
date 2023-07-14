PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu",
  id = "StanceHudButton",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextWindow",
    "Id",
    "idStanceButton",
    "IdNode",
    true,
    "LayoutMethod",
    "VList",
    "FoldWhenHidden",
    true,
    "BackgroundRectGlowSize",
    1,
    "BackgroundRectGlowColor",
    RGBA(32, 35, 47, 255),
    "HandleMouse",
    true,
    "ContextUpdateOnOpen",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      local units = self.context
      if #(units or "") == 0 then
        return
      end
      if units[1]:IsStanceChangeLocked() then
        self:SetVisible(false)
      else
        self:SetVisible(true)
      end
      local upShortcuts = GetShortcuts("ChangeStanceUp") or empty_table
      local downShortcuts = GetShortcuts("ChangeStanceDown") or empty_table
      local shortcuts = {
        upShortcuts[1],
        downShortcuts[1]
      }
      local actionImageSet
      for i, button in ipairs(self.idStanceButtons) do
        local action = button.context.action
        local thisIsCurrent
        for _, unit in ipairs(units) do
          thisIsCurrent = thisIsCurrent or action:GetAPCost(unit) == -1
        end
        local enabled = thisIsCurrent or action:GetUIState(units) == "enabled"
        local color = enabled and RGB(52, 55, 60) or RGB(70, 70, 70)
        button.idInner:SetBackground(thisIsCurrent and RGB(195, 189, 172) or color)
        button:SetBorderColor(color)
        button:SetEnabled(enabled)
        button.selected = thisIsCurrent
        if thisIsCurrent and not actionImageSet then
          self.idStanceIcon:SetImage(action:GetActionIcon(units))
          actionImageSet = true
        end
      end
      if GetUIStyleGamepad() then
        local up = GetPlatformSpecificImageTag("DPadUp", 650)
        local down = GetPlatformSpecificImageTag("DPadDown", 650)
        self.idStanceIcon:SetText(T({
          568035005601,
          "<up>-<down>",
          up = up,
          down = down
        }))
        return
      end
      local firstNum, lastNum = false, false
      local allF = true
      for i, shortcut in ipairs(shortcuts) do
        local isF = shortcut and string.sub(shortcut, 1, 1) == "F"
        allF = allF and isF
        if isF and i == 1 then
          firstNum = string.sub(shortcut, 2)
        end
        if isF and i == #shortcuts then
          lastNum = string.sub(shortcut, 2)
        end
      end
      if firstNum and lastNum then
        local n = tonumber(firstNum)
        local n2 = tonumber(lastNum)
        if n and n2 and n2 - n ~= #shortcuts - 2 then
          allF = false
        end
      end
      if allF then
        self.idStanceIcon:SetText(T({
          726076428124,
          "[F<first>-<last>]",
          first = Untranslated(firstNum),
          last = Untranslated(lastNum)
        }))
      else
        shortcuts = table.map(shortcuts, function(s)
          return s and s or ""
        end)
        local concat = "[" .. table.concat(shortcuts, "-") .. "]"
        self.idStanceIcon:SetText(Untranslated(concat))
      end
    end
  }, {
    PlaceObj("XTemplateWindow", {
      "BorderWidth",
      2,
      "LayoutMethod",
      "HList",
      "BorderColor",
      RGBA(52, 55, 61, 230),
      "Background",
      RGBA(32, 35, 47, 215)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "HUDButton",
        "Id",
        "idStanceIcon",
        "Transparency",
        75,
        "HandleMouse",
        false,
        "Columns",
        1
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(0, 0, -2, 0),
        "Background",
        RGBA(52, 55, 60, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XList",
          "Id",
          "idStanceButtons",
          "IdNode",
          false,
          "Margins",
          box(0, 0, 0, -2),
          "VAlign",
          "center",
          "Clip",
          false,
          "BorderColor",
          RGBA(0, 0, 0, 0),
          "Background",
          RGBA(34, 35, 39, 255),
          "BackgroundRectGlowColor",
          RGBA(0, 0, 0, 0),
          "FocusedBorderColor",
          RGBA(0, 0, 0, 0),
          "FocusedBackground",
          RGBA(34, 35, 39, 255),
          "DisabledBorderColor",
          RGBA(0, 0, 0, 0),
          "LeftThumbScroll",
          false,
          "GamepadInitialSelection",
          false
        }, {
          PlaceObj("XTemplateTemplate", {
            "__context",
            function(parent, context)
              return {
                action = CombatActions.StanceStanding
              }
            end,
            "__template",
            "SmallStanceHudButton"
          }),
          PlaceObj("XTemplateTemplate", {
            "__context",
            function(parent, context)
              return {
                action = CombatActions.StanceCrouch
              }
            end,
            "__template",
            "SmallStanceHudButton",
            "Margins",
            box(0, -2, 0, 0)
          }),
          PlaceObj("XTemplateTemplate", {
            "__context",
            function(parent, context)
              return {
                action = CombatActions.StanceProne
              }
            end,
            "__template",
            "SmallStanceHudButton",
            "Margins",
            box(0, -2, 0, 0)
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "OnKillFocus(self)",
            "func",
            function(self)
              self:SetSelection(false)
              local igi = GetInGameInterfaceModeDlg()
              igi:ActionBarUnfocusCheck()
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "OnShortcut(self, shortcut, source, ...)",
            "func",
            function(self, shortcut, source, ...)
              if shortcut == "-ButtonA" then
                local selectedButton = self:GetSelection()
                selectedButton = selectedButton and selectedButton[1]
                selectedButton = selectedButton and self[selectedButton]
                if not selectedButton then
                  return false
                end
                selectedButton:OnPress()
              elseif shortcut == "ButtonB" then
                local igi = GetInGameInterfaceModeDlg()
                igi:SetFocus()
                return "break"
              elseif shortcut == "DPadLeft" then
                return "break"
              elseif shortcut == "DPadRight" then
                local node = GetDialog(self)
                local stealthBar = node.idHideButtonFrame
                stealthBar = stealthBar and stealthBar.idHideButton
                if stealthBar then
                  stealthBar:SetFocus()
                  return "break"
                end
              end
              return XList.OnShortcut(self, shortcut, source, ...)
            end
          })
        })
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
      "controller observer",
      "__context",
      function(parent, context)
        return "GamepadUIStyleChanged"
      end,
      "__class",
      "XContextWindow",
      "UseClipBox",
      false,
      "Visible",
      false,
      "FoldWhenHidden",
      true,
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        self.parent:OnContextUpdate(self.parent.context)
      end
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
