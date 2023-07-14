PlaceObj("XTemplate", {
  group = "Zulu",
  id = "CombatActionsToActions",
  PlaceObj("XTemplateForEach", {
    "comment",
    "CombatActions -> XActions",
    "array",
    function(parent, context)
      return PresetMultipleGroupsCombo("CombatAction", {
        "UIActions",
        "Hidden",
        "Stances"
      }, false, "no_empty")()
    end,
    "condition",
    function(parent, context, item, i)
      return CombatActions[item].ShowIn
    end,
    "run_after",
    function(child, context, item, i, n, last)
      item = CombatActions[item]
      child.ActionId = item.id
      child.ActionName = item:GetActionDisplayName(context)
      local menubar = item.ShowIn
      child.FXPress = item.id
      child.FXPressDisabled = "IactDisabled"
      local slot_bindings = GetShortcuts("combatAction" .. item.id)
      local action = item:ResolveAction(context)
      if action and action.ShowIn == "SignatureAbilities" then
        menubar = action.ShowIn
      end
      child:SetActionMenubar(menubar)
      local action_bindings = action and GetShortcuts("combatAction" .. action.id)
      if action_bindings then
        for _, slot_action in ipairs(Presets.CombatAction.UIActions) do
          local bindings = GetShortcuts("combatAction" .. slot_action.id)
          for i = 1, 3 do
            for j = 1, 3 do
              if bindings and bindings[i] == action_bindings[j] then
                action_bindings[j] = ""
              end
            end
          end
        end
      end
      local shortcut, shortcut2, shortcut_gamepad = child.ActionShortcut, child.ActionShortcut2, child.ActionGamepad
      if slot_bindings then
        shortcut = slot_bindings[1]
        shortcut2 = slot_bindings[2]
        shortcut_gamepad = slot_bindings[3]
      end
      if action_bindings then
        if shortcut == "" and shortcut2 == "" then
          shortcut = action_bindings[1]
          shortcut2 = action_bindings[2]
        else
          local binding = action_bindings[1] ~= "" and action_bindings[1] or action_bindings[2]
          if binding ~= "" then
            if shortcut == "" then
              shortcut = binding
            else
              shortcut2 = binding
            end
          end
        end
        if shortcut_gamepad == "" then
          shortcut_gamepad = action_bindings[3]
        end
      end
      child:SetActionShortcut(shortcut)
      child:SetActionShortcut2(shortcut2)
      child:SetActionGamepad(shortcut_gamepad)
      StripDeveloperShortcuts(child)
    end
  }, {
    PlaceObj("XTemplateAction", {
      "ActionState",
      function(self, host)
        if #Selection == 0 then
          return "disabled"
        end
        local action = CombatActions[self.ActionId]
        if not action then
          return "hidden"
        end
        local selObj = Selection[1]
        local underlying = action:ResolveAction(selObj) or action
        if action.ShowIn == "CombatActions" or action.ShowIn == "SignatureAbilities" or underlying.group == "FiringModeMetaAction" then
          return selObj.ui_actions and selObj.ui_actions[underlying.id] or "hidden"
        end
        return true
      end,
      "OnAction",
      function(self, host, source, ...)
        local action = CombatActions[self.ActionId]
        if action and action:GetVisibility(Selection) == "enabled" then
          CombatActions[self.ActionId]:UIBegin(Selection)
        end
      end,
      "IgnoreRepeated",
      true
    })
  }),
  PlaceObj("XTemplateForEach", {
    "comment",
    "reload actions",
    "array",
    function(parent, context)
      return PresetGroupCombo("InventoryItemCompositeDef", "Ammo")()
    end,
    "run_after",
    function(child, context, item, i, n, last)
      child.ActionId = item
      child.ActionName = Untranslated(item)
    end
  }, {
    PlaceObj("XTemplateAction", {
      "ActionMenubar",
      "ReloadActions",
      "OnAction",
      function(self, host, source, ...)
        local cancelReload = source:ResolveId("idCancelReload")
        if cancelReload then
          cancelReload:Press()
        end
        CombatActions.Reload:Execute(ResolvePropObj(source.context), self.ActionId)
      end,
      "IgnoreRepeated",
      true
    })
  })
})
