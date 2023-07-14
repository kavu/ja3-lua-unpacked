MapVar("SelectedObj", false)
MapVar("Selection", {})
local find = table.find
local remove = table.remove
local IsValid = IsValid
local SelectionChange = function()
  ObjModified(Selection)
  Msg("SelectionChange")
end
local __selobj = function(obj, prev)
  obj = IsValid(obj) and obj or false
  prev = prev or SelectedObj
  if prev ~= obj then
    SelectedObj = obj
    SetDebugObj(obj)
    Msg("SelectedObjChange", obj, prev)
    if SelectedObj == obj then
      if prev then
        PlayFX("SelectObj", "end", prev)
      end
      if obj then
        PlayFX("SelectObj", "start", obj)
      end
    end
  end
end
local __add = function(obj)
  if not IsValid(obj) or find(Selection, obj) then
    return
  end
  Selection[#Selection + 1] = obj
  PlayFX("Select", "start", obj)
  Msg("SelectionAdded", obj)
  DelayedCall(0, SelectionChange)
end
local __remove = function(obj, idx)
  idx = idx or find(Selection, obj)
  if not idx then
    return
  end
  remove(Selection, idx)
  PlayFX("Select", "end", obj)
  Msg("SelectionRemoved", obj)
  DelayedCall(0, SelectionChange)
end
function SelectionAdd(obj)
  if IsValid(obj) then
    __add(obj)
  elseif type(obj) == "table" then
    for i = 1, #obj do
      __add(obj[i])
    end
  end
  SelectionValidate(SelectedObj)
end
function SelectionRemove(obj)
  __remove(obj)
  if type(obj) == "table" then
    for i = 1, #obj do
      __remove(obj[i])
    end
  end
  SelectionValidate(SelectedObj)
end
function IsInSelection(obj)
  return obj == SelectedObj or find(Selection, obj)
end
function SelectionSet(list, obj)
  list = list or {}
  if type(list) ~= "table" then
    return
  end
  for i = 1, #list do
    __add(list[i])
  end
  for i = #Selection, 1, -1 do
    local obj = Selection[i]
    if not find(list, obj) then
      __remove(obj, i)
    end
  end
  SelectionValidate(obj or SelectedObj)
end
function SelectionValidate(obj)
  if not Selection then
    return
  end
  local Selection = Selection
  for i = #Selection, 1, -1 do
    if not IsValid(Selection[i]) then
      __remove(Selection[i], i)
    end
  end
  SelectionSubSel(obj or SelectedObj)
end
function SelectionSubSel(obj)
  obj = IsValid(obj) and find(Selection, obj) and obj or false
  __selobj(obj or #Selection == 1 and Selection[1])
end
function SelectObj(obj)
  obj = IsValid(obj) and obj or false
  for i = #Selection, 1, -1 do
    local o = Selection[i]
    if o ~= obj then
      __remove(o, i)
    end
  end
  local prev = SelectedObj
  __add(obj)
  __selobj(obj, prev)
end
function ViewAndSelectObject(obj)
  SelectObj(obj)
  ViewObject(obj)
end
function SelectionPropagate(obj)
  local topmost = GetTopmostSelectionNode(obj)
  local prev = topmost
  while IsValid(topmost) do
    topmost = topmost:SelectionPropagate() or topmost
    if prev == topmost then
      break
    end
    prev = topmost
  end
  return prev
end
AutoResolveMethods.SelectionPropagate = "or"
local sel_tbl = {}
local sel_idx = 0
function SelectFromTerrainPoint(pt)
  Msg("SelectFromTerrainPoint", pt, sel_tbl)
  if 0 < #sel_tbl then
    sel_idx = (sel_idx + 1) % #sel_tbl
    local obj = sel_tbl[sel_idx + 1]
    sel_tbl = {}
    return obj
  end
end
function SelectionMouseObj()
  local solid, transparent = GetPreciseCursorObj()
  local obj = transparent or solid or SelectFromTerrainPoint(GetTerrainCursor()) or GetTerrainCursorObjSel()
  return SelectionPropagate(obj)
end
function SelectionGamepadObj(gamepad_pos)
  local gamepad_pos = gamepad_pos or UIL.GetScreenSize() / 2
  local obj = GetTerrainCursorObjSel(gamepad_pos)
  if obj then
    return SelectionPropagate(obj)
  end
  if config.GamepadSearchRadius then
    local xpos = GetTerrainCursorXY(gamepad_pos)
    if not xpos or xpos == InvalidPos() or not terrain.IsPointInBounds(xpos) then
      return
    end
    local obj = MapFindNearest(xpos, xpos, config.GamepadSearchRadius, "CObject", const.efSelectable)
    if obj then
      return SelectionPropagate(obj)
    end
  end
end
function GetSelectionClass(obj)
  if not obj then
    return
  end
  if IsKindOf(obj, "PropertyObject") and obj:HasMember("SelectionClass") then
    return obj.SelectionClass
  else
  end
end
function GatherObjectsOnScreen(obj, selection_class)
  obj = obj or SelectedObj
  if not IsValid(obj) then
    return
  end
  selection_class = selection_class or GetSelectionClass(obj)
  if not selection_class then
    return
  end
  local result = GatherObjectsInScreenRect(point20, point(GetResolution()), selection_class)
  if not find(result, obj) then
    table.insert(result, obj)
  end
  return result
end
function ScreenRectToTerrainPoints(start_pt, end_pt)
  local start_x, start_y = start_pt:xy()
  local end_x, end_y = end_pt:xy()
  local ss_left = Min(start_x, end_x)
  local ss_right = Max(start_x, end_x)
  local ss_top = Min(start_y, end_y)
  local ss_bottom = Max(start_y, end_y)
  local top_left = GetTerrainCursorXY(ss_left, ss_top)
  local top_right = GetTerrainCursorXY(ss_right, ss_top)
  local bottom_left = GetTerrainCursorXY(ss_right, ss_bottom)
  local bottom_right = GetTerrainCursorXY(ss_left, ss_bottom)
  return top_left, top_right, bottom_left, bottom_right
end
function GatherObjectsInScreenRect(start_pos, end_pos, selection_class, max_step, enum_flags, filter_func)
  enum_flags = enum_flags or const.efSelectable
  local rect = Extend(empty_box, ScreenRectToTerrainPoints(start_pos, end_pos)):grow(max_step or 0)
  local screen_rect = boxdiag(start_pos, end_pos)
  local filter = function(obj)
    local _, pos = GameToScreen(obj)
    if not screen_rect:Point2DInside(pos) then
      return false
    end
    if not filter_func then
      return true
    end
    return filter_func(obj)
  end
  return MapGet(rect, selection_class or "Object", enum_flags, filter) or {}
end
function GatherObjectsInRect(top_left, top_right, bottom_left, bottom_right, selection_class, enum_flags, filter_func)
  enum_flags = enum_flags or const.efSelectable
  local left = Min(top_left:x(), top_right:x(), bottom_left:x(), bottom_right:x())
  local right = Max(top_left:x(), top_right:x(), bottom_left:x(), bottom_right:x())
  local top = Min(top_left:y(), top_right:y(), bottom_left:y(), bottom_right:y())
  local bottom = Max(top_left:y(), top_right:y(), bottom_left:y(), bottom_right:y())
  local max_step = 12 * guim
  top = top - max_step
  left = left - max_step
  bottom = bottom + max_step
  right = right + max_step
  local rect = box(left, top, right, bottom)
  local IsInsideTrapeze = function(pt)
    return IsInsideTriangle(pt, top_left, bottom_right, bottom_left) or IsInsideTriangle(pt, top_left, bottom_right, top_right)
  end
  local filter = function(obj)
    local pos = obj:GetVisualPos()
    if pos:z() ~= terrain.GetHeight(pos:x(), pos:y()) then
      local _, p = GameToScreen(pos)
      pos = GetTerrainCursorXY(p)
    end
    if not IsInsideTrapeze(pos) then
      return false
    end
    if filter_func then
      return filter_func(obj)
    end
    return true
  end
  return MapGet(rect, selection_class or "Object", enum_flags, filter) or {}
end
function OnMsg.GatherFXActions(list)
  list[#list + 1] = "Select"
  list[#list + 1] = "SelectObj"
end
