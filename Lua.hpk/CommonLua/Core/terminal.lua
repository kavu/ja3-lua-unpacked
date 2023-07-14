if not rawget(_G, "terminal") then
  terminal = {}
end
local terminal = terminal
if not terminal.targets then
  terminal.targets = {}
  terminal.activate_time = RealTime()
end
function terminal.AddTarget(target)
  table.insert_unique(terminal.targets, target)
  terminal.SortTargets()
end
function terminal.RemoveTarget(target)
  table.remove_entry(terminal.targets, target)
end
function terminal.SortTargets()
  table.sortby_field_descending(terminal.targets, "terminal_target_priority")
end
function terminal.MouseEvent(event, pt, button, time, last_pos_event)
  if event == "OnMousePos" and not last_pos_event then
    return
  end
  for _, target in ipairs(terminal.targets) do
    local result = target:MouseEvent(event, pt, button, time)
    if result == "break" then
      return "break"
    end
  end
  if event == "OnMouseWheelBack" or event == "OnMouseWheelForward" then
    local button = event == "OnMouseWheelBack" and "WheelBack" or "WheelFwd"
    local shortcut = MouseShortcut(button)
    if shortcut then
      return terminal.Shortcut(shortcut, "mouse")
    end
  end
  if event == "OnMouseButtonDown" or event == "OnMouseButtonDoubleClick" then
    local shortcut = MouseShortcut(button)
    if shortcut then
      return terminal.Shortcut(shortcut, "mouse")
    end
  end
  if event == "OnMouseButtonUp" then
    local shortcut = MouseShortcut(button)
    if shortcut then
      return terminal.Shortcut("-" .. shortcut, "mouse")
    end
  end
end
function terminal.IsShortcutPressed(shortcut)
  local sc_list = GetShortcuts(shortcut)
  for i = 1, 3 do
    if (sc_list[i] or "") ~= "" then
      local sc = SplitShortcut(sc_list[i])
      local all_pressed = true
      for j = 1, #sc do
        if i < 3 then
          local vk = VKStrNamesInverse[sc[j]] or MouseVKStrNamesInverse[sc[j]]
          if vk and not terminal.IsKeyPressed(vk) then
            all_pressed = false
            break
          end
        elseif Platform.pc then
          local pressed = false
          for k = 0, XInput.MaxControllers() - 1 do
            if XInput.IsCtrlButtonPressed(k, sc[j]) then
              pressed = true
              break
            end
          end
          if not pressed then
            all_pressed = false
            break
          end
        elseif not XInput.IsCtrlButtonPressed(ActiveController, sc[j]) then
          all_pressed = false
          break
        end
      end
      if all_pressed then
        return true
      end
    end
  end
  return false
end
function terminal.Shortcut(shortcut, source, ...)
  for _, target in ipairs(terminal.targets) do
    if target:OnShortcut(shortcut, source, ...) == "break" then
      return "break"
    end
  end
end
function terminal.SysEvent(event, ...)
  for _, target in ipairs(terminal.targets) do
    local result = target:SysEvent(event, ...)
    if result == "break" then
      return "break"
    end
  end
end
function terminal.TouchEvent(event, ...)
  for _, target in ipairs(terminal.targets) do
    local result = target:TouchEvent(event, ...)
    if result == "break" then
      return "break"
    end
  end
end
local KeyboardEventDispatch = function(event, ...)
  for _, target in ipairs(terminal.targets) do
    if target:KeyboardEvent(event, ...) == "break" then
      return "break"
    end
  end
  if event == "OnKbdKeyDown" then
    local virtual_key, repeated = ...
    local shortcut = KbdShortcut(virtual_key)
    if shortcut then
      return terminal.Shortcut(shortcut, "keyboard", nil, repeated)
    end
  end
  if event == "OnKbdKeyUp" then
    local virtual_key = (...)
    local shortcut = KbdShortcut(virtual_key)
    if shortcut then
      return terminal.Shortcut("-" .. shortcut, "keyboard")
    end
  end
end
function terminal.KeyboardEvent(event, char, ...)
  if event == "OnKbdKeyDown" or event == "OnKbdKeyUp" then
    return KeyboardEventDispatch(event, ...)
  else
    return KeyboardEventDispatch(event, char, ...)
  end
end
function terminal.FileEvent(event, filename)
  for _, target in ipairs(terminal.targets) do
    local result = target:FileEvent(event, filename)
    if result == "break" then
      return "break"
    end
  end
end
RepeatableXButtons = {
  DPadLeft = true,
  DPadRight = true,
  DPadUp = true,
  DPadDown = true,
  LeftThumbUp = true,
  LeftThumbUpRight = true,
  LeftThumbRight = true,
  LeftThumbDownRight = true,
  LeftThumbDown = true,
  LeftThumbDownLeft = true,
  LeftThumbLeft = true,
  LeftThumbUpLeft = true,
  RightThumbUp = true,
  RightThumbUpRight = true,
  RightThumbRight = true,
  RightThumbDownRight = true,
  RightThumbDown = true,
  RightThumbDownRight = true,
  RightThumbRight = true,
  RightThumbUpRight = true,
  LeftShoulder = true,
  RightShoulder = true
}
function terminal.XEvent(event, ...)
  for _, target in ipairs(terminal.targets) do
    if target:XEvent(event, ...) == "break" then
      return "break"
    end
  end
  if event == "OnXButtonDown" then
    local button, controller_id = ...
    local shortcut = XInputShortcut(button, controller_id)
    if shortcut then
      if terminal.Shortcut("+" .. shortcut, "gamepad", controller_id) == "break" then
        return "break"
      end
      return terminal.Shortcut(shortcut, "gamepad", controller_id)
    end
  end
  if event == "OnXButtonUp" then
    local button, controller_id = ...
    local shortcut = XInputShortcut(button, controller_id)
    if shortcut then
      return terminal.Shortcut("-" .. shortcut, "gamepad", controller_id)
    end
  end
  if event == "OnXButtonRepeat" then
    local button, controller_id = ...
    if RepeatableXButtons[button] then
      local shortcut = XInputShortcut(button, controller_id)
      if shortcut then
        return terminal.Shortcut(shortcut, "gamepad", controller_id, true)
      end
    end
  end
end
DefineClass.TerminalTarget = {
  __parents = {
    "PropertyObject"
  },
  terminal_target_priority = 0
}
function TerminalTarget:MouseEvent(event, ...)
  return self[event](self, ...)
end
function TerminalTarget:KeyboardEvent(event, ...)
  return self[event](self, ...)
end
function TerminalTarget:SysEvent(event, ...)
  return self[event](self, ...)
end
function TerminalTarget:TouchEvent(event, ...)
  return self[event](self, ...)
end
function TerminalTarget:XEvent(event, ...)
  return self[event](self, ...)
end
function TerminalTarget:OnShortcut(shortcut, source, controller_id, repeated, ...)
end
function TerminalTarget:FileEvent(event, ...)
  return self[event](self, ...)
end
function TerminalTarget:OnMouseButtonDoubleClick(pt, button)
  return self:OnMouseButtonDown(pt, button)
end
function TerminalTarget:OnXButtonRepeat(button, controller_id)
  if RepeatableXButtons[button] then
    local up_result = self:OnXButtonUp(button, controller_id)
    local down_result = self:OnXButtonDown(button, controller_id)
    if up_result == "break" or down_result == "break" then
      return "break"
    end
  end
end
local stub = function()
end
TerminalTarget.OnMouseMove = stub
TerminalTarget.OnMousePos = stub
TerminalTarget.OnMouseButtonDown = stub
TerminalTarget.OnMouseButtonUp = stub
TerminalTarget.OnMouseWheelForward = stub
TerminalTarget.OnMouseWheelBack = stub
TerminalTarget.OnMouseOutside = stub
TerminalTarget.OnMouseInside = stub
TerminalTarget.OnKbdChar = stub
TerminalTarget.OnKbdKeyDown = stub
TerminalTarget.OnKbdKeyUp = stub
TerminalTarget.OnKbdIMEStartComposition = stub
TerminalTarget.OnKbdIMEEndComposition = stub
TerminalTarget.OnKbdIMEUpdateComposition = stub
TerminalTarget.OnSystemSize = stub
TerminalTarget.OnSystemVirtualKeyboard = stub
TerminalTarget.OnSystemActivate = stub
TerminalTarget.OnSystemInactivate = stub
TerminalTarget.OnSystemMinimize = stub
TerminalTarget.OnXNewPacket = stub
TerminalTarget.OnXButtonUp = stub
TerminalTarget.OnXButtonDown = stub
TerminalTarget.OnTouchBegan = stub
TerminalTarget.OnTouchMoved = stub
TerminalTarget.OnTouchStationary = stub
TerminalTarget.OnTouchEnded = stub
TerminalTarget.OnTouchCancelled = stub
TerminalTarget.OnFileDrop = stub
DefineClass.FilterEventsTarget = {
  __parents = {
    "TerminalTarget"
  },
  terminal_target_priority = 10000000,
  allow_events = false
}
function FilterEventsTarget:MouseEvent(event, ...)
  return self.allow_events.mouse and "continue" or "break"
end
function FilterEventsTarget:KeyboardEvent(event, ...)
  return self.allow_events.keyboard and "continue" or "break"
end
function FilterEventsTarget:SysEvent(event, ...)
end
function FilterEventsTarget:XEvent(event, button, nCtrlId, ...)
  return self.allow_events["gamepad" .. (nCtrlId or "X")] and "continue" or "break"
end
function FilterTerminalEventSources(allow_events, priority)
  for _, target in ipairs(terminal.targets) do
    if IsKindOf(target, "FilterEventsTarget") then
      terminal.RemoveTarget(target)
      break
    end
  end
  if allow_events then
    FilterEventsTarget:new({allow_events = allow_events, terminal_target_priority = priority})
  end
end
function OnDeviceReset()
end
function OnMsg.SystemInactivate()
  if config.DontMuteWhenInactive or IsSoundEditorOpened() or IsModEditorOpened() then
    return
  end
  SetMute(true)
end
function OnMsg.SystemActivate()
  terminal.activate_time = RealTime()
  SetMute(false)
end
if FirstLoad then
  g_KeyboardConnected = not Platform.console
end
function ConsoleUpdatePreciseSelection()
  if not Platform.xbox and not Platform.switch then
    hr.EnablePreciseSelection = g_KeyboardConnected and 1 or 0
  end
end
if Platform.console then
  function OnMsg.KeyboardConnected()
    g_KeyboardConnected = true
  end
  function OnMsg.KeyboardDisconnected()
    g_KeyboardConnected = false
  end
  function OnMsg.MouseConnected()
    g_MouseConnected = true
    ConsoleUpdatePreciseSelection()
    UnforceHideMouseCursor("MouseDisconnected")
  end
  function OnMsg.MouseDisconnected()
    g_MouseConnected = false
    ConsoleUpdatePreciseSelection()
    ForceHideMouseCursor("MouseDisconnected")
  end
  function OnMsg.Autorun()
    if terminal.IsMouseEnabled() then
      Msg("MouseConnected")
    else
      Msg("MouseDisconnected")
    end
  end
  if Platform.xbox then
    if FirstLoad then
      KeyboardMouseSupportThread = false
    end
    DeleteThread(KeyboardMouseSupportThread)
    KeyboardMouseSupportThread = CreateRealTimeThread(function()
      while true do
        Sleep(5000)
        local mouse = terminal.IsMouseEnabled()
        local keyboard = terminal.IsKeyboardEnabled()
        if mouse ~= g_MouseConnected then
          Msg(mouse and "MouseConnected" or "MouseDisconnected")
        end
        if keyboard ~= g_KeyboardConnected then
          Msg(keyboard and "KeyboardConnected" or "KeyboardDisconnected")
        end
      end
    end)
  end
end
