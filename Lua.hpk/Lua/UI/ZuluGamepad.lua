function OnMsg.XInputInited()
  local lock = GetUIStyleGamepad() and 0 or 1
  hr.XBoxLeftThumbLocked = lock
  hr.XBoxRightThumbLocked = lock
  hr.GamepadMouseSensitivity = 10
  hr.GamepadMouseAcceleration = 400
  hr.GamepadMouseAccelerationMax = 1000
  hr.GamepadMouseAccelerationExponent = 200
  hr.GamepadMouseSpeedUp = 200
  hr.GamepadMouseSpeedUpTime = 1500
  hr.GamepadMouseSpeedDownTime = 200
  hr.GamepadMouseSpeedUpThreshold = 90
end
function OnMsg.GamepadUIStyleChanged()
  SetDisableMouseViaGamepad(not GetUIStyleGamepad(), "UIStyle")
  ObjModified("GamepadUIStyleChanged")
end
if FirstLoad then
  ZuluMouseViaGamepadDisableReasons = false
  ZuluMouseViaGamepadEnableReasons = false
end
function OnMsg.NewGame()
  ZuluMouseViaGamepadDisableReasons = GetUIStyleGamepad() and {} or {"UIStyle"}
  ZuluMouseViaGamepadEnableReasons = {}
end
function OnMsg.DoneGame()
  ZuluMouseViaGamepadDisableReasons = false
  ZuluMouseViaGamepadEnableReasons = false
end
function SetDisableMouseViaGamepad(disable, reason)
  if not ZuluMouseViaGamepadDisableReasons then
    ZuluMouseViaGamepadDisableReasons = {}
  end
  local existingReasonIdx = table.find(ZuluMouseViaGamepadDisableReasons, reason)
  if existingReasonIdx and not disable then
    table.remove(ZuluMouseViaGamepadDisableReasons, existingReasonIdx)
  elseif not existingReasonIdx and disable then
    table.insert(ZuluMouseViaGamepadDisableReasons, reason)
  end
  local isEnabled = IsZuluMouseViaGamepadEnabled()
  ShowMouseViaGamepad(isEnabled)
end
function SetEnabledMouseViaGamepad(enable, reason)
  if not ZuluMouseViaGamepadEnableReasons then
    ZuluMouseViaGamepadEnableReasons = {}
  end
  local existingReasonIdx = table.find(ZuluMouseViaGamepadEnableReasons, reason)
  if not existingReasonIdx and enable then
    table.insert(ZuluMouseViaGamepadEnableReasons, reason)
  elseif existingReasonIdx and not enable then
    table.remove(ZuluMouseViaGamepadEnableReasons, existingReasonIdx)
  end
  local isEnabled = IsZuluMouseViaGamepadEnabled()
  ShowMouseViaGamepad(isEnabled)
end
function IsZuluMouseViaGamepadEnabled()
  if ZuluMouseViaGamepadDisableReasons and #ZuluMouseViaGamepadDisableReasons > 0 then
    return false
  end
  if not ZuluMouseViaGamepadEnableReasons or #ZuluMouseViaGamepadEnableReasons == 0 then
    return false
  end
  return true
end
DefineClass.ZuluMouseViaGamepad = {
  __parents = {
    "MouseViaGamepad"
  },
  LeftClickButton = "ButtonA",
  RightClickButton = "ButtonX",
  DoubleClickTime = 200
}
local IsRSScrollButton = function(button)
  return button == "RightThumbUp" or button == "RightThumbUpLeft" or button == "RightThumbUpRight" or button == "RightThumbDown" or button == "RightThumbDownLeft" or button == "RightThumbDownRight"
end
local GetRSScrollTarget = function(pt)
  local target = terminal.desktop.modal_window:GetMouseTarget(pt)
  local scroll = target and GetParentOfKind(target, "XScrollArea")
  return scroll
end
local ExecRSScrollFn = function(pt, fn, button, controller_id)
  if IsRSScrollButton(button) then
    local scroll = GetRSScrollTarget(pt)
    if scroll then
      scroll[fn](scroll, button, controller_id)
      return "break"
    end
    return true
  end
end
function ZuluMouseViaGamepad:OnXButtonDown(button, controller_id)
  if not self.enabled then
    return
  end
  local pt = GamepadMouseGetPos()
  local target = terminal.desktop:UpdateMouseTarget(pt)
  if IsKindOf(target, "XDragAndDropControl") and target.drag_win then
    target = target.drag_win
    if ExecRSScrollFn(pt, "OnXButtonDown", button, controller_id) then
      return "break"
    end
  end
  while target ~= terminal.desktop do
    local res = target:OnXButtonDown(button, controller_id)
    if res == "break" then
      return "break"
    end
    target = target.parent
  end
  return MouseViaGamepad.OnXButtonDown(self, button, controller_id)
end
function ZuluMouseViaGamepad:OnXButtonUp(button, controller_id)
  if not self.enabled then
    return
  end
  local pt = GamepadMouseGetPos()
  local target = terminal.desktop:UpdateMouseTarget(pt)
  if IsKindOf(target, "XDragAndDropControl") and target.drag_win then
    target = target.drag_win
    if ExecRSScrollFn(pt, "OnXButtonUp", button, controller_id) then
      return "break"
    end
  end
  while target and target ~= terminal.desktop do
    local res = target:OnXButtonUp(button, controller_id)
    if res == "break" then
      return "break"
    end
    target = target.parent
  end
  return MouseViaGamepad.OnXButtonUp(self, button, controller_id)
end
function ZuluMouseViaGamepad:OnXButtonRepeat(button, controller_id)
  if not self.enabled then
    return
  end
  local pt = GamepadMouseGetPos()
  local target = terminal.desktop:UpdateMouseTarget(pt)
  if IsKindOf(target, "XDragAndDropControl") and target.drag_win then
    target = target.drag_win
    if ExecRSScrollFn(pt, "OnXButtonRepeat", button, controller_id) then
      return "break"
    end
  end
  while target and target ~= terminal.desktop do
    local res = target:OnXButtonRepeat(button, controller_id)
    if res == "break" then
      return "break"
    end
    target = target.parent
  end
  return "continue"
end
function ZuluMouseViaGamepad:OnMousePos(pt)
  if not self.enabled then
    return
  end
  GamepadMouseSetPos(pt)
  return "continue"
end
MouseViaGamepadHideSkipReasons.GamepadActive = true
function ShowMouseViaGamepad(show)
  local mouse_win = GetMouseViaGamepadCtrl()
  if not mouse_win and show then
    mouse_win = ZuluMouseViaGamepad:new({}, terminal.desktop)
  end
  if mouse_win then
    if show then
      ForceHideMouseCursor("MouseViaGamepad")
      GamepadMouseSetPos(terminal.GetMousePos())
      mouse_win:SetCursorImage(GetMouseCursor())
      mouse_win:SetEnabled(true)
      if not IsValidThread(RolloverThread) then
        mouse_win:CreateThread("rollover-thread", MouseRollover)
        RolloverThread = mouse_win:GetThread("rollover-thread")
      end
    else
      DeleteMouseViaGamepad()
      UnforceHideMouseCursor("MouseViaGamepad")
      XDestroyRolloverWindow(true)
      terminal.desktop.last_mouse_pos = terminal.GetMousePos()
    end
    hr.GamepadMouseEnabled = show
  end
end
DefineClass.VirtualCursorManager = {
  __parents = {"XWindow"},
  properties = {
    {
      id = "Reason",
      editor = "text",
      default = "",
      help = "Reason for disable or enable of the virtual mouse."
    },
    {
      id = "ActionType",
      editor = "bool",
      default = true,
      help = "true: enable virtual mouse, false: disable virtual mouse"
    }
  }
}
function VirtualCursorManager:Open()
  XWindow.Open(self)
  if self.ActionType then
    SetEnabledMouseViaGamepad(true, self.Reason)
  else
    SetDisableMouseViaGamepad(true, self.Reason)
  end
end
function VirtualCursorManager:OnDelete()
  if self.ActionType then
    SetEnabledMouseViaGamepad(false, self.Reason)
  else
    SetDisableMouseViaGamepad(false, self.Reason)
  end
end
local lCommonSplashText = SplashText
function SplashText(...)
  local dlg = lCommonSplashText(...)
  SetDisableMouseViaGamepad(true, "splash")
  function dlg.OnDelete()
    SetDisableMouseViaGamepad(false, "splash")
  end
  return dlg
end
