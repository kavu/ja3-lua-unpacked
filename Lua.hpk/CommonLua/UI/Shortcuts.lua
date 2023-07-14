if FirstLoad then
  MouseButtonImagesInText = {}
  MouseButtonNames = {
    MouseL = T(344793107847, "Left Mouse Button"),
    MouseR = T(620781110653, "Right Mouse Button"),
    MouseM = T(814937893055, "Middle Mouse Button"),
    MouseX1 = T(404129049676, "Mouse Button 4"),
    MouseX2 = T(640322216255, "Mouse Button 5"),
    MouseWheelFwd = T(286518835802, "Mouse Wheel Forward"),
    MouseWheelBack = T(889465032724, "Mouse Wheel Back")
  }
  ForbiddenShortcutKeys = {
    Lwin = true,
    Rwin = true,
    Menu = true,
    MouseL = true,
    MouseR = true,
    MouseM = true,
    Enter = true
  }
  NonBindableKeys = {}
end
function GatherNonBindableKeys()
  local nonBindableKeys = {}
  for _, action in ipairs(XShortcutsTarget:GetActions()) do
    if action.ActionMode ~= "Editor" and not action.ActionBindable then
      table.insert(nonBindableKeys, action)
    end
  end
  return nonBindableKeys
end
function TFormat.GamepadShortcutName(context_obj, shortcut)
  if not shortcut or shortcut == "" then
    return T(879415238341, "<negative>Unassigned</negative>")
  end
  local buttons = SplitShortcut(shortcut)
  for i, button in ipairs(buttons) do
    buttons[i] = const.TagLookupTable[button] or GetPlatformSpecificImageTag(button) or "?"
  end
  return Untranslated(table.concat(buttons))
end
function TFormat.ShortcutName(context_obj, action_id, source)
  local shortcuts = GetShortcuts(action_id)
  if GetUIStyleGamepad() and (not source or source == "gamepad") then
    return TFormat.GamepadShortcutName(context_obj, shortcuts and shortcuts[3])
  elseif shortcuts and shortcuts[1] and shortcuts[1] ~= "" then
    local keys = SplitShortcut(shortcuts[1])
    local last_key = keys[#keys]
    if MouseButtonImagesInText[last_key] then
      local text = string.sub(shortcuts[1], 1, -last_key:len() - 1)
      text = text .. "<image " .. MouseButtonImagesInText[last_key] .. ">"
      return T({text})
    else
      local text = ShortcutKeysToText(keys)
      return T({
        629765447024,
        "<name>",
        name = text
      })
    end
  else
    return T(879415238341, "<negative>Unassigned</negative>")
  end
end
function ShortcutKeysToText(keys)
  local texts = {}
  for k, v in ipairs(keys) do
    texts[k] = MouseButtonNames[v] or KeyNames[VKStrNamesInverse[v]]
  end
  return table.concat(texts, "-")
end
function KeybindingName(shortcut)
  if (shortcut or "") == "" then
    return ""
  end
  local keys = SplitShortcut(shortcut)
  local last_key = keys[#keys]
  if MouseButtonImagesInText[last_key] then
    local text = string.sub(shortcut, 1, -last_key:len() - 1)
    text = text .. "<image " .. MouseButtonImagesInText[last_key] .. " 1800>"
    return T({text})
  else
    local text = ShortcutKeysToText(keys)
    return T({
      629765447024,
      "<name>",
      name = text
    })
  end
end
function RebindKeys(idx, prop_ctrl)
  CreateRealTimeThread(function(idx, prop_ctrl)
    local obj = ResolvePropObj(prop_ctrl.context)
    local prop_meta = prop_ctrl.prop_meta
    local prop_id = prop_meta.id
    local prop_name = prop_meta.name
    local dlg = CreateMessageBox(terminal.desktop, T(""), T({
      529975158495,
      [[
Press a key to assign to <action>...
Press Esc to cancel.]],
      action = prop_name
    }))
    dlg:PreventClose()
    local shortcut, keys, last_key
    repeat
      shortcut = WaitShortcut()
      if shortcut then
        keys = SplitShortcut(shortcut)
        last_key = keys[#keys]
        if shortcut ~= "Escape" then
          Msg("OptionsChanged")
        end
      end
    until shortcut and not ForbiddenShortcutKeys[last_key] and (not prop_meta.single_key or last_key ~= "Ctrl" and last_key ~= "Shift")
    if prop_meta.single_key then
      shortcut = last_key
      keys = {last_key}
    end
    shortcut = last_key ~= "Escape" and shortcut
    if MouseButtonNames[last_key] and not prop_meta.mouse_bindable then
      local parent = dlg.parent
      dlg:Close()
      CreateMessageBox(parent, T(207596731516, "Conflicting controls"), T({
        301773001578,
        "<key> cannot be used for <action>.",
        key = MouseButtonNames[last_key] or T({last_key}),
        action = prop_name
      }), T(325411474155, "OK"))
      return
    end
    local nonRebindableAction = table.find_value(NonBindableKeys, "ActionShortcut", last_key)
    if shortcut and nonRebindableAction and EnabledInModes(nonRebindableAction.ActionMode, prop_meta.mode) then
      local parent = dlg.parent
      dlg:Close()
      CreateMessageBox(parent, T(207596731516, "Conflicting controls"), T({
        163533339775,
        "<newKey> is already used by a non rebindable action <nonRebindableKey>",
        newKey = KeybindingName(last_key) or T({last_key}),
        nonRebindableKey = nonRebindableAction.ActionTranslate and nonRebindableAction.ActionName or ""
      }), T(325411474155, "OK"))
      return
    end
    if shortcut then
      for _, ctrl in ipairs(prop_ctrl.parent) do
        local ctrl_meta = ctrl.prop_meta
        if ctrl_meta then
          local bindings = obj[ctrl_meta.id]
          if bindings and EnabledInModes(ctrl_meta.mode, prop_meta.mode) then
            for i = 1, #bindings do
              if ctrl_meta.id ~= prop_id and bindings[i] == shortcut then
                local old_action = ctrl_meta.name
                local new_action = prop_name
                if dlg.window_state == "open" then
                  dlg:Close()
                end
                local res = WaitQuestion(terminal.desktop, T(207596731516, "Conflicting controls"), T({
                  905663676426,
                  "Do you want to rebind <key> from <old_action> to <new_action>?",
                  key = ShortcutKeysToText(keys),
                  old_action = old_action,
                  new_action = new_action
                }), T(689884995409, "Yes"), T(782927325160, "No"))
                if res == "ok" then
                  bindings = table.copy(bindings)
                  bindings[1] = i ~= 1 and bindings[1] or bindings[2] or ""
                  bindings[2] = ""
                  obj:SetProperty(ctrl_meta.id, bindings)
                  ctrl.value = bindings
                  ctrl:OnPropUpdate(ctrl.context, ctrl_meta, bindings)
                  break
                else
                  return
                end
              end
            end
          end
        end
      end
      local bindings = obj[prop_meta.id]
      bindings = bindings and table.copy(bindings) or {}
      idx = bindings[1] and idx or 1
      bindings[idx] = shortcut
      if 1 < #bindings and bindings[1] == bindings[2] then
        bindings[2] = ""
      end
      obj:SetProperty(prop_meta.id, bindings)
      prop_ctrl.value = bindings
      prop_ctrl:OnPropUpdate(prop_ctrl.context, prop_meta, bindings)
    end
    if dlg and dlg.window_state ~= "destroying" then
      dlg:Close()
    end
  end, idx, prop_ctrl)
end
ShouldAttachSelectionShortcutWork = return_true
ShouldBlackPlanesShortcutWork = return_true
