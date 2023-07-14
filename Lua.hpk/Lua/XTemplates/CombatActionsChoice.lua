PlaceObj("XTemplate", {
  __is_kind_of = "XPopup",
  group = "Zulu",
  id = "CombatActionsChoice",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XPopupSnapToWidth",
    "Margins",
    box(0, 0, 0, 5),
    "BorderWidth",
    2,
    "BorderColor",
    RGBA(52, 55, 61, 230),
    "Background",
    RGBA(32, 35, 47, 230),
    "FocusedBorderColor",
    RGBA(52, 55, 61, 230),
    "FocusedBackground",
    RGBA(32, 35, 47, 230),
    "DisabledBorderColor",
    RGBA(52, 55, 61, 230),
    "DisabledBackground",
    RGBA(32, 35, 47, 230)
  }, {
    PlaceObj("XTemplateWindow", nil, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XList",
        "Id",
        "idChoiceActionsContainer",
        "IdNode",
        false,
        "BorderWidth",
        0,
        "Padding",
        box(10, 5, 10, 0),
        "VAlign",
        "center",
        "LayoutMethod",
        "HList",
        "LayoutHSpacing",
        2,
        "Clip",
        false,
        "BorderColor",
        RGBA(177, 22, 14, 0),
        "Background",
        RGBA(177, 22, 14, 0),
        "FocusedBackground",
        RGBA(0, 0, 0, 0)
      }, {
        PlaceObj("XTemplateForEach", {
          "__context",
          function(parent, context, item, i, n)
            return item.uiCtx
          end,
          "run_after",
          function(child, context, item, i, n, last)
            local image
            if rawget(item.target, "icon") then
              image = item.target.icon
              child.idImage:SetColumns(item.target.iconColumns or 1)
            elseif item.icon then
              image = item.icon
            else
              image = item.action.Icon
            end
            child.idImage:SetImage(image)
            local state = item.action:GetUIState({
              item.unit
            }, {
              target = item.target
            })
            if state ~= "enabled" or not IsKindOf(item.target, "PropertyObject") and item.target.disabled then
              child:SetEnabled(false)
            end
            local old_OnSetRollover = child.OnSetRollover
            function child:OnSetRollover(rollover, ...)
              old_OnSetRollover(self, rollover, ...)
              if not IsValid(item.target) then
                return
              end
              if IsKindOf(item.target, "Interactable") then
                item.target:HighlightIntensely(rollover, "actionsChoice")
              else
                item.target:SetColorModifier(rollover and const.clrGreen or const.clrWhite)
              end
            end
            function child.OnPress()
              ExecuteCombatChoice(item)
              local node = child:ResolveId("node")
              if node then
                node:Close()
              end
            end
            if context then
              child:SetRolloverTemplate(item.rolloverTemplate)
              child:SetRolloverTitle(rawget(item.target, "rolloverTitle") or context:GetRolloverTitle())
              child:SetRolloverText(rawget(item.target, "text") or context:GetRollover())
            else
              child:SetRolloverText(item.text)
            end
            if item.action and item.action.id == "ChangeStance" then
              local stanceAction = item.uiCtx.action
              local stance = stanceAction.id:gsub("Stance", "")
              local unit = item.unit
              if not unit:HasStatusEffect("Hidden") and unit:CanStealth(stance) then
                child.idOverlay:SetImage("UI/Hud/Status effects/hidden")
                child.idOverlay:SetVisible(true)
              end
            end
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "HUDButton",
            "RolloverTemplate",
            "SmallRolloverGeneric",
            "RolloverAnchor",
            "center-top",
            "RolloverAnchorId",
            "idChoiceActionsContainer",
            "MinHeight",
            55,
            "MaxHeight",
            55
          }, {
            PlaceObj("XTemplateCode", {
              "run",
              function(self, parent, context)
                parent.idText:SetVisible(false)
                parent.idText:SetFoldWhenHidden(true)
              end
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionCloseChoiceMenu",
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "ButtonB",
      "ActionState",
      function(self, host)
        local choiceUI = host.combatActionsPopup
        return choiceUI and choiceUI.window_state ~= "destroying" and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        local choiceUI = host.combatActionsPopup
        if choiceUI and choiceUI.window_state ~= "destroying" then
          choiceUI:Close()
          return "break"
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionCloseChoiceMenuTwo",
      "ActionGamepad",
      "RightTrigger",
      "ActionState",
      function(self, host)
        local choiceUI = host.combatActionsPopup
        return choiceUI and choiceUI.window_state ~= "destroying" and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        local choiceUI = host.combatActionsPopup
        if choiceUI and choiceUI.window_state ~= "destroying" then
          choiceUI:Close()
          return "break"
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnCaptureLost(self)",
      "func",
      function(self)
        if self.window_state ~= "open" then
          return
        end
        self:Close()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        if self:MouseInWindow(pos) then
          return
        end
        if self.window_state ~= "open" then
          return
        end
        self:Close()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self)",
      "func",
      function(self)
        local igi = GetInGameInterfaceModeDlg()
        local bar = igi:ResolveId("idBottomBar")
        if bar then
          local time = ApplyCombatBarHidingAnimation(bar, true) or 0
          self:SetVisible(false)
          self:CreateThread("show-after", function()
            Sleep(time)
            self:SetVisible(true)
          end)
        end
        XPopupSnapToWidth.Open(self)
      end
    })
  })
})
