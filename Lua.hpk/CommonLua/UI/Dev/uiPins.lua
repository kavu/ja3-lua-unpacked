local max_o = 100
local oname = function(n)
  return string.format("o%d", n)
end
DefineClass.DebugPinsButton = {
  __parents = {
    "XTextButton"
  },
  IdNode = true,
  ChildrenHandleMouse = true,
  Padding = box(2, 2, 2, 2),
  BorderWidth = 2,
  BorderColor = const.clrBlack,
  RolloverBorderColor = const.clrBlack,
  Translate = false,
  selected = false
}
function DebugPinsButton:Init(parent, context)
  if not self.AltPress then
    local pin_btn = XTextButton:new({
      Id = "idPinBtn",
      UseXTextControl = true,
      Dock = "left",
      MinWidth = 24,
      MinHeight = 24,
      Translate = false,
      Text = "+",
      BorderWidth = 1,
      BorderColor = const.clrBlack,
      RolloverBorderColor = const.clrBlack
    }, self, self.context)
    function pin_btn:OnPress(gamepad)
      local dlg = GetDialog(self)
      dlg:TogglePinned(self.context)
    end
    function pin_btn:OnContextUpdate(context, update)
      local main_btn = self.parent
      self:SetText(main_btn:IsPinned(context) and "-" or "+")
    end
    local pin_label = pin_btn:ResolveId("idLabel")
    pin_label:SetHAlign("stretch")
    pin_label:SetVAlign("stretch")
    pin_label:SetTextHAlign("center")
    pin_label:SetTextVAlign("center")
    pin_label:SetDock("box")
    function pin_btn:SetText(...)
      XTextButton.SetText(self, ...)
      pin_label:SetDock("box")
    end
  end
  local o_label = XLabel:new({
    Id = "idOLabel",
    HAlign = "right",
    VAlign = "bottom",
    ScaleModifier = point(500, 500),
    Translate = false
  }, self, self.context)
  function o_label:OnContextUpdate(context, update)
    local main_btn = self.parent
    local idx = main_btn:GetPinIndex(context)
    if idx then
      self:SetVisible(true)
      self:SetText(oname(idx))
    else
      self:SetVisible(false)
    end
  end
  local dlg = GetDialog(self)
  local name = dlg:GetDisplayName(self.context)
  local n = 0
  for i, btn in ipairs(self.parent) do
    if btn == self then
      break
    end
    if btn.context.class == self.context.class then
      n = n + 1
    end
  end
  if 0 < n then
    name = string.format("%s %d", name, n + 1)
  end
  self:SetText(name)
end
function DebugPinsButton:OnPress(gamepad)
  SelectObj(self.context)
end
function DebugPinsButton:OnMouseButtonDoubleClick(button)
  ViewObject(self.context)
  return "break"
end
function DebugPinsButton:OnContextUpdate(context, update)
  if not IsValid(context) or update ~= "open" and not self.selected and not self:IsPinned() then
    self:Close()
  end
end
function DebugPinsButton:HasOLabel()
  return self:ResolveId("idOLabel"):GetVisible()
end
function DebugPinsButton:GetPinIndex()
  local dlg = GetDialog(self)
  return dlg:GetPinIndex(self.context)
end
function DebugPinsButton:IsPinned()
  return not not self:GetPinIndex()
end
function DebugPinsButton:SetSelected(selected)
  self.selected = selected
  if not selected and not self:IsPinned() then
    self:Close()
  else
    self:SetHighlighted(selected)
  end
end
function DebugPinsButton:SetHighlighted(highlighted)
  local color = highlighted and RGB(120, 120, 255) or const.clrBlack
  self:SetBorderColor(color)
  self:SetRolloverBorderColor(color)
end
DefineClass.DebugPinsDialog = {
  __parents = {"XDialog"},
  place = "bottom",
  my_pins = false,
  o_thread = false
}
function DebugPinsDialog:Init(parent, context)
  self.my_pins = {}
  local collapse_button = XToggleButton:new({
    Id = "idCollapseBtn",
    Translate = false,
    Text = "[-]",
    ToggledBackground = const.clrWhite,
    ToggledBorderColor = const.clrBlack,
    HAlign = "center",
    VAlign = "center"
  }, self)
  function collapse_button:OnChange(collapsed)
    self:SetText(collapsed and "[+]" or "[-]")
    local container = GetDialog(self):ResolveId("idContainer")
    if container then
      container:SetVisible(not collapsed)
    end
  end
  local container = XWindow:new({
    Id = "idContainer",
    LayoutMethod = "HList",
    FoldWhenHidden = true,
    Visible = false
  }, self)
  self.o_thread = self:CreateThread("o_thread", self.OThreadProc, self)
  if config.DbgPinsCollapsed then
    collapse_button:SetToggled(true)
  end
  self.place = config.DbgPinsPlace or self.place or "bottom"
  local place_params
  if self.place == "left" then
    place_params = {
      "left",
      "center",
      90,
      0,
      0,
      0,
      "VList"
    }
  elseif self.place == "right" then
    place_params = {
      "right",
      "center",
      0,
      0,
      90,
      0,
      "VList"
    }
  elseif self.place == "top" then
    place_params = {
      "center",
      "top",
      0,
      90,
      0,
      0,
      "HList"
    }
  elseif self.place == "bottom" then
    place_params = {
      "center",
      "bottom",
      0,
      0,
      0,
      90,
      "HList"
    }
  end
  self:SetHAlign(place_params[1])
  self:SetVAlign(place_params[2])
  self:SetMargins(box(place_params[3], place_params[4], place_params[5], place_params[6]))
  self:SetLayoutMethod(place_params[7])
  container:SetLayoutMethod(place_params[7])
end
function DebugPinsDialog:OnDelete(result, ...)
  for idx in pairs(self.my_pins) do
    local varname = oname(idx)
    rawset(_G, varname, nil)
  end
end
function DebugPinsDialog:GetDisplayName(obj)
  if IsKindOf(obj, "Human") then
    return _InternalTranslate(obj.FirstName)
  else
    return obj.class
  end
end
function DebugPinsDialog:GetPinIndex(obj)
  return OPinsGetIndex(obj)
end
function DebugPinsDialog:GetNextPinIndex()
  return OPinsGetNextIndex()
end
function DebugPinsDialog:SetPinned(obj, pinned)
  local idx = OPinsSet(obj, pinned)
  if pinned then
    self.my_pins[idx] = true
  else
    self.my_pins[idx] = nil
  end
end
function DebugPinsDialog:TogglePinned(obj)
  local idx = self:GetPinIndex(obj)
  local is_pinned = not not idx
  self:SetPinned(obj, not is_pinned)
end
function DebugPinsDialog:AddButton(obj)
  local btn = self:FindButton(obj)
  if not btn then
    local container = self:ResolveId("idContainer")
    btn = DebugPinsButton:new(nil, container or self, obj)
    btn:Open()
  end
  return btn
end
function DebugPinsDialog:RemoveButton(obj)
  local btn = self:FindButton(obj)
  if btn then
    btn:Close()
  end
end
function DebugPinsDialog:FindButton(obj)
  local container = self:ResolveId("idContainer") or self
  for i, btn in ipairs(container) do
    if btn.context == obj then
      return btn
    end
  end
end
function DebugPinsDialog:OnSelectionAdded(obj)
  local btn = self:FindButton(obj)
  btn = btn or self:AddButton(obj)
  btn:SetSelected(true)
end
function DebugPinsDialog:OnSelectionRemoved(obj)
  local btn = self:FindButton(obj)
  if btn then
    btn:SetSelected(false)
  end
end
function DebugPinsDialog:OThreadProc()
  while self.window_state ~= "destroying" do
    local container = self:ResolveId("idContainer") or self
    for i, btn in ipairs(container) do
      if btn:HasOLabel() then
        ObjModified(btn.context)
      end
    end
    for idx = 1, max_o do
      local obj = rawget(_G, oname(idx))
      if IsValid(obj) then
        self:AddButton(obj)
        ObjModified(obj)
      end
    end
    Sleep(1000)
  end
end
function OPinsGetIndex(obj)
  for idx = 1, max_o do
    local value = rawget(_G, oname(idx))
    if value == obj then
      return idx
    end
  end
end
function OPinsGetNextIndex()
  for idx = 1, max_o do
    local value = rawget(_G, oname(idx))
    if value == nil then
      return idx
    end
  end
end
function OPinsSet(obj, pinned)
  local idx = OPinsGetIndex(obj)
  if pinned then
    if not idx then
      idx = OPinsGetNextIndex()
      rawset(_G, oname(idx), obj)
      ObjModified(obj)
    end
  elseif idx then
    rawset(_G, oname(idx), nil)
    ObjModified(obj)
  end
  return idx
end
function OPinsClear()
  for idx = 1, max_o do
    rawset(_G, oname(idx), nil)
  end
end
function OnMsg.LoadGame(metadata, version)
  OPinsClear()
end
function OnMsg.NewGame()
  OPinsClear()
end
function OnMsg.SelectionAdded(obj)
  local dlg = GetDialog("DebugPinsDialog")
  if not dlg then
    return
  end
  dlg:OnSelectionAdded(obj)
end
function OnMsg.SelectionRemoved(obj)
  local dlg = GetDialog("DebugPinsDialog")
  if not dlg then
    return
  end
  dlg:OnSelectionRemoved(obj)
end
function OnMsg.InGameInterfaceCreated()
  if config.DbgPinsEnabled then
    OpenDialog("DebugPinsDialog", GetInGameInterface())
  end
end
