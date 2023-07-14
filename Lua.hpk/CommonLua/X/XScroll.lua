DefineClass.XScroll = {
  __parents = {
    "XPropControl"
  },
  properties = {
    {
      category = "Scroll",
      id = "Min",
      editor = "number",
      default = 0
    },
    {
      category = "Scroll",
      id = "Max",
      editor = "number",
      default = 100
    },
    {
      category = "Scroll",
      id = "Scroll",
      editor = "number",
      default = 0,
      dont_save = true
    },
    {
      category = "Scroll",
      id = "PageSize",
      editor = "number",
      default = 1
    },
    {
      category = "Scroll",
      id = "StepSize",
      editor = "number",
      default = 1
    },
    {
      category = "Scroll",
      id = "FullPageAtEnd",
      editor = "bool",
      default = false
    },
    {
      category = "Scroll",
      id = "SnapToItems",
      editor = "bool",
      default = false
    },
    {
      category = "Scroll",
      id = "AutoHide",
      editor = "bool",
      default = false
    },
    {
      category = "Scroll",
      id = "Horizontal",
      name = "Horizontal",
      editor = "bool",
      default = false
    },
    {
      category = "Scroll",
      id = "ThrottleTime",
      name = "Throttle time",
      editor = "number",
      default = 0,
      help = "Use -1 to update the value once per frame"
    },
    {
      category = "Scroll",
      id = "ModifyObj",
      name = "Call ObjModified",
      editor = "bool",
      default = false
    }
  },
  FoldWhenHidden = true,
  set_prop_thread = false
}
function XScroll:SetScrollRange(min, max)
  max = Max(max, min)
  if self.Min == min and self.Max == max then
    return
  end
  self.Min = min
  self.Max = max
  self:SetScroll(self.Scroll)
end
function XScroll:SetStepSize(step)
  self.StepSize = Max(1, step)
end
function XScroll:ScrollIntoView()
end
function XScroll:ShouldShow()
  if not self.AutoHide then
    return true
  end
  local target = self:ResolveId(self.Target)
  if not target then
    return
  end
  if self.Horizontal then
    return target.scroll_range_x - target.content_box:sizex() > 0
  end
  return 0 < target.scroll_range_y - target.content_box:sizey()
end
function XScroll:SnapScrollPosition(current)
  current = current + (self.Min - current) % self.StepSize
  local scroll_end = self.Max - (self.FullPageAtEnd and self.PageSize or 0)
  local target = self.SnapToItems and self:ResolveId(self.Target)
  if target and (target.UniformRowHeight or target.UniformColumnWidth) then
    local h_spacing, v_spacing = ScaleXY(target.scale, target.LayoutHSpacing, target.LayoutVSpacing)
    scroll_end = scroll_end + (self.Horizontal and h_spacing or v_spacing or 0)
  end
  return Clamp(current, self.Min, scroll_end)
end
function XScroll:DoSetScroll(current)
  if self.Scroll ~= current then
    self.Scroll = current
    self:Invalidate()
    return true
  end
end
function XScroll:SetScroll(current)
  if self.AutoHide then
    self:SetVisible(self:ShouldShow())
  end
  return self:DoSetScroll(self:SnapScrollPosition(current))
end
function XScroll:SetPageSize(page_size)
  page_size = page_size - page_size % self.StepSize
  local new_size = Max(page_size, 1)
  if self.PageSize == new_size then
    return
  end
  self.PageSize = new_size
  self:SetScroll(self.Scroll)
end
function XScroll:ScrollTo(current)
  if self:SetScroll(current) then
    local target = self:ResolveId(self.Target)
    if target then
      target:OnScrollTo(self.Scroll, self)
    end
    if self.BindTo ~= "" then
      local obj = ResolvePropObj(self.context)
      if self.ThrottleTime == 0 then
        SetProperty(obj, self.BindTo, self.Scroll)
        if self.ModifyObj then
          ObjModified(obj)
        end
      elseif not IsValidThread(self.set_prop_thread) then
        self.set_prop_thread = CreateRealTimeThread(function(self)
          repeat
            local value = self.Scroll
            SetProperty(obj, self.BindTo, self.Scroll)
            if self.ModifyObj then
              ObjModified(obj)
            end
            if self.ThrottleTime == -1 then
              WaitNextFrame()
            else
              Sleep(self.ThrottleTime)
            end
          until value == self.Scroll
          self.set_prop_thread = false
        end, self)
      end
    end
    return true
  end
end
local eval = prop_eval
function XScroll:OnPropUpdate(context, prop_meta, value)
  if prop_meta then
    self:SetStepSize(eval(prop_meta.step, context, prop_meta) or self.StepSize)
    self:SetScrollRange(eval(prop_meta.min, context, prop_meta) or self.Min, eval(prop_meta.max, context, prop_meta) or self.Max)
  end
  if type(value) == "number" then
    self:ScrollTo(value)
  end
end
DefineClass.XScrollControl = {
  __parents = {"XScroll"},
  properties = {
    {
      category = "Scroll",
      id = "MinThumbSize",
      editor = "number",
      default = 15
    }
  },
  current_pos = false,
  current_offset = false,
  ChildrenHandleMouse = false,
  touch = false
}
function XScrollControl:StartScroll(pt)
  if not self.enabled then
    return false
  end
  local pos = self.Horizontal and pt:x() - self.content_box:minx() or pt:y() - self.content_box:miny()
  local min, max = self:GetThumbRange()
  self.current_pos = min
  self.current_offset = pos - self.current_pos
  if self.current_offset < 0 or self.current_offset > max - min then
    self.current_offset = (max - min) / 2
  end
  return true
end
function XScrollControl:OnMouseButtonDown(pt, button)
  if button == "L" then
    if self:StartScroll(pt) then
      if not self.touch then
        self.desktop:SetMouseCapture(self)
      end
      self:OnMousePos(pt)
    end
    return "break"
  end
end
function XScrollControl:OnMousePos(pt)
  if not self.current_pos then
    return
  end
  local pos, size
  if self.Horizontal then
    pos = pt:x() - self.content_box:minx() - self.current_offset
    size = Max(1, self.content_box:sizex() - self:GetThumbSize())
  else
    pos = pt:y() - self.content_box:miny() - self.current_offset
    size = Max(1, self.content_box:sizey() - self:GetThumbSize())
  end
  pos = Clamp(pos, 0, size)
  self.current_pos = pos
  self:ScrollTo(self.Min + pos * Max(1, self.Max - self.Min - (self.FullPageAtEnd and self.PageSize or 0) + 1) / size)
  return "break"
end
function XScrollControl:OnMouseButtonUp(pt, button)
  if button == "L" then
    self:OnMousePos(pt)
    self.desktop:SetMouseCapture()
    return "break"
  end
end
function XScrollControl:OnCaptureLost()
  self.current_pos = false
  self.current_offset = false
end
function XScrollControl:OnTouchBegan(id, pt, touch)
  self.touch = true
  terminal.desktop:SetKeyboardFocus(false)
  self:OnMouseButtonDown(pt, "L")
  return "capture"
end
function XScrollControl:OnTouchMoved(id, pt, touch)
  return self:OnMousePos(pt)
end
function XScrollControl:OnTouchEnded()
  self.touch = false
  return "break"
end
function XScrollControl:OnTouchCancelled()
  self.touch = false
  return "break"
end
function XScrollControl:GetThumbSize()
  local area = self.Horizontal and self.content_box:sizex() or self.content_box:sizey()
  local page_size = area * self.PageSize / Max(1, self.Max - self.Min)
  return Clamp(page_size, self.MinThumbSize, area)
end
function XScrollControl:GetThumbRange()
  local thumb_size = self:GetThumbSize()
  local area = self.Horizontal and self.content_box:sizex() or self.content_box:sizey()
  local pos = self.current_pos or (area - thumb_size) * (self.Scroll - self.Min) / Max(1, self.Max - self.Min - (self.FullPageAtEnd and self.PageSize or 0))
  return pos, pos + thumb_size
end
DefineClass.XScrollBar = {
  __parents = {
    "XScrollControl"
  },
  properties = {
    {
      category = "Visual",
      id = "ScrollColor",
      name = "Scroll",
      editor = "color",
      default = RGBA(169, 169, 169, 255)
    },
    {
      category = "Visual",
      id = "DisabledScrollColor",
      name = "Disabled scroll",
      editor = "color",
      default = RGBA(169, 169, 169, 96)
    }
  },
  FullPageAtEnd = true,
  Background = RGB(240, 240, 240),
  DisabledBackground = RGB(240, 240, 240)
}
function XScrollBar:DrawContent()
  local content_box = self.content_box
  if self.Horizontal then
    local x1, x2 = self:GetThumbRange()
    content_box = box(content_box:minx() + x1, content_box:miny(), content_box:minx() + x2, content_box:maxy())
  else
    local y1, y2 = self:GetThumbRange()
    content_box = box(content_box:minx(), content_box:miny() + y1, content_box:maxx(), content_box:miny() + y2)
  end
  UIL.DrawBorderRect(FitBoxInBox(content_box, self.content_box), 0, 0, 0, self.enabled and self.ScrollColor or self.DisabledScrollColor)
end
DefineClass.XScrollThumb = {
  __parents = {
    "XScrollControl"
  },
  properties = {
    {
      category = "Scroll",
      id = "FixedSizeThumb",
      name = "Fixed size thumb",
      editor = "bool",
      default = true
    }
  }
}
function XScrollThumb:DoSetScroll(scroll)
  if XScrollControl.DoSetScroll(self, scroll) then
    self:MoveThumb()
    return true
  end
  self:MoveThumb()
end
function XScrollThumb:Layout(x, y, width, height)
  XScrollControl.Layout(self, x, y, width, height)
  self:MoveThumb()
end
function XScrollThumb:GetThumbSize()
  if self.FixedSizeThumb then
    return self.Horizontal and self.idThumb.measure_width or self.idThumb.measure_height
  else
    return XScrollControl.GetThumbSize(self)
  end
end
function XScrollThumb:MoveThumb()
  if not self:HasMember("idThumb") then
    return
  end
  local x1, y1, x2, y2 = self.content_box:xyxy()
  local min, max = self:GetThumbRange()
  self.idThumb:SetDock("ignore")
  if self.Horizontal then
    self.idThumb:SetLayoutSpace(x1 + min, y1, max - min, y2 - y1)
  else
    self.idThumb:SetLayoutSpace(x1, y1 + min, x2 - x1, max - min)
  end
end
DefineClass.XSleekScroll = {
  __parents = {
    "XScrollThumb"
  },
  FullPageAtEnd = true,
  FixedSizeThumb = false,
  Background = RGB(240, 240, 240),
  ThumbScale = point(500, 500)
}
function XSleekScroll:Init()
  XFrame:new({
    Id = "idThumb",
    Dock = "ignore",
    Image = "CommonAssets/UI/round-frame-20.tga",
    ImageScale = self.ThumbScale,
    FrameBox = box(9, 9, 9, 9),
    Background = RGBA(169, 169, 169, 255),
    DisabledBackground = RGBA(169, 169, 169, 96)
  }, self)
  self:SetHorizontal(self.Horizontal)
end
function XSleekScroll:SetHorizontal(horizontal)
  self.Horizontal = horizontal
  self.MinWidth = horizontal and 0 or 7
  self.MaxWidth = horizontal and 1000000 or 7
  self.MinHeight = horizontal and 7 or 0
  self.MaxHeight = horizontal and 7 or 1000000
  self:InvalidateMeasure()
  self:InvalidateLayout()
end
DefineClass.XScrollArea = {
  __parents = {"XControl"},
  properties = {
    {
      category = "Scroll",
      id = "OffsetX",
      editor = "number",
      default = 0,
      dont_save = true
    },
    {
      category = "Scroll",
      id = "OffsetY",
      editor = "number",
      default = 0,
      dont_save = true
    },
    {
      category = "Scroll",
      id = "MinHSize",
      name = "Min horizontal size",
      editor = "bool",
      default = true
    },
    {
      category = "Scroll",
      id = "MinVSize",
      name = "Min vertical size",
      editor = "bool",
      default = true
    },
    {
      category = "Scroll",
      id = "HScroll",
      editor = "text",
      default = ""
    },
    {
      category = "Scroll",
      id = "VScroll",
      editor = "text",
      default = ""
    },
    {
      category = "Scroll",
      id = "MouseWheelStep",
      editor = "number",
      default = 80
    },
    {
      category = "Visual",
      id = "ShowPartialItems",
      editor = "bool",
      default = true
    },
    {
      category = "Visual",
      id = "ScrollInterpolationTime",
      editor = "number",
      min = 0,
      max = 500,
      slider = true,
      default = 0
    },
    {
      category = "Visual",
      id = "ScrollInterpolationEasing",
      editor = "choice",
      default = GetEasingIndex("Cubic in"),
      items = function(self)
        return GetEasingCombo()
      end
    },
    {
      category = "General",
      id = "MouseScroll",
      Name = "Scroll with mouse",
      editor = "bool",
      default = true
    }
  },
  Clip = "parent & self",
  scroll_range_x = 0,
  scroll_range_y = 0,
  pending_scroll_into_view = false,
  pending_scroll_allow_interpolation = false,
  PendingOffsetX = 0,
  PendingOffsetY = 0
}
function XScrollArea:Clear(keep_children)
  if not keep_children then
    self:DeleteChildren()
  end
  self:ScrollTo(0, 0)
  self.pending_scroll_into_view = false
end
function XScrollArea:ScrollTo(x, y, force, allow_interpolation)
  x = x or self.PendingOffsetX
  y = y or self.PendingOffsetY
  if self.PendingOffsetX ~= x then
    local scroll = self:ResolveId(self.HScroll)
    if scroll then
      x = scroll:SnapScrollPosition(x)
      scroll:SetScroll(x)
    end
  end
  if self.PendingOffsetY ~= y then
    local scroll = self:ResolveId(self.VScroll)
    if scroll then
      y = scroll:SnapScrollPosition(y)
      scroll:DoSetScroll(y)
    end
  end
  local ret = false
  if self.PendingOffsetX ~= x or self.PendingOffsetY ~= y then
    self.PendingOffsetX = x
    self.PendingOffsetY = y
    self:Invalidate()
    ret = true
  end
  self.pending_scroll_allow_interpolation = allow_interpolation
  if force then
    self:DoScroll(self.PendingOffsetX, self.PendingOffsetY)
  end
  return ret
end
function XScrollArea:DoScroll(x, y)
  local dx = self.OffsetX - x
  local dy = self.OffsetY - y
  if dx ~= 0 or dy ~= 0 then
    self.OffsetX = x
    self.OffsetY = y
    for _, win in ipairs(self) do
      if not win.Dock then
        local win_box = win.box
        win:SetBox(win_box:minx() + dx, win_box:miny() + dy, win_box:sizex(), win_box:sizey())
      end
    end
    if 0 < self.ScrollInterpolationTime and self.pending_scroll_allow_interpolation then
      self:AddInterpolation({
        id = "smooth_scroll",
        type = const.intRect,
        duration = self.ScrollInterpolationTime,
        easing = self.ScrollInterpolationEasing,
        originalRect = self.box,
        targetRect = self:GetInterpolatedBox("smooth_scroll", self.box - point(dx, dy)),
        interpolate_clip = const.interpolateClipOff,
        flags = const.intfInverse
      })
      self.pending_scroll_allow_interpolation = false
    end
    self:RecalcVisibility()
    if Platform.desktop then
      local pt = terminal.GetMousePos()
      if self:MouseInWindow(pt) then
        self.desktop:RequestUpdateMouseTarget()
      end
    end
  end
end
local irInside = const.irInside
local irIntersect = const.irIntersect
function XScrollArea:RecalcVisibility()
  local content = self.content_box
  local partial = self.ShowPartialItems
  for _, win in ipairs(self) do
    if not win.Dock then
      local intersect = content:Intersect2D(win.box)
      win:SetOutsideParent(intersect ~= irInside and (intersect ~= irIntersect or not partial))
    end
  end
end
function XScrollArea:OnScrollTo(pos, scroll)
  if scroll == self:ResolveId(self.VScroll) then
    self:ScrollTo(self.PendingOffsetX, pos)
  elseif scroll == self:ResolveId(self.HScroll) then
    self:ScrollTo(pos, self.PendingOffsetY)
  end
end
function XScrollArea:Measure(preferred_width, preferred_height)
  local measure_width = self:ResolveId(self.HScroll) and 1000000 or preferred_width
  local measure_height = self:ResolveId(self.VScroll) and 1000000 or preferred_height
  local width, height = XControl.Measure(self, measure_width, measure_height)
  self.scroll_range_x = width
  self.scroll_range_y = height
  if self.MinHSize then
    preferred_width = Min(preferred_width, width)
  end
  if self.MinVSize then
    preferred_height = Min(preferred_height, height)
  end
  return preferred_width, preferred_height
end
local lAnyNonDockedWindows = function(self)
  for i, w in ipairs(self) do
    if not w.Dock then
      return true
    end
  end
end
function XScrollArea:Layout(x, y, width, height)
  local c_width, c_height = self.content_box:sizexyz()
  local offset_x, offset_y = self.PendingOffsetX, self.PendingOffsetY
  offset_x = Clamp(offset_x, 0, Max(0, self.scroll_range_x - c_width))
  offset_y = Clamp(offset_y, 0, Max(0, self.scroll_range_y - c_height))
  self:ScrollTo(offset_x, offset_y)
  width = self:ResolveId(self.HScroll) and Max(self.scroll_range_x, width) or width
  height = self:ResolveId(self.VScroll) and Max(self.scroll_range_y, height) or height
  if lAnyNonDockedWindows(self) then
    XWindowLayoutFuncs[self.LayoutMethod](self, x - self.OffsetX, y - self.OffsetY, width, height)
  end
  local h_step, v_step
  if self.LayoutMethod == "VList" and self.UniformRowHeight then
    local h_spacing, v_spacing = ScaleXY(self.scale, self.LayoutHSpacing, self.LayoutVSpacing)
    for _, win in ipairs(self) do
      if not win.Dock then
        v_step = Max(v_step, win.measure_height + v_spacing)
      end
    end
  end
  if self.LayoutMethod == "HList" and self.UniformColumnWidth then
    local h_spacing, v_spacing = ScaleXY(self.scale, self.LayoutHSpacing, self.LayoutVSpacing)
    for _, win in ipairs(self) do
      if not win.Dock then
        h_step = Max(h_step, win.measure_width + h_spacing)
      end
    end
  end
  local scroll = self:ResolveId(self.HScroll)
  self.MouseWheelStep = v_step or self.MouseWheelStep
  if scroll then
    scroll:SetStepSize(h_step or 1)
    scroll:SetScrollRange(0, self.scroll_range_x)
    scroll:SetPageSize(self.content_box:sizex())
  end
  local scroll = self:ResolveId(self.VScroll)
  if scroll then
    scroll:SetStepSize(v_step or 1)
    scroll:SetScrollRange(0, self.scroll_range_y)
    scroll:SetPageSize(self.content_box:sizey())
  end
end
function XScrollArea:UpdateLayout()
  XControl.UpdateLayout(self)
  if self.pending_scroll_into_view then
    local content_box = self.content_box
    for _, child_or_box in ipairs(self.pending_scroll_into_view) do
      if IsBox(child_or_box) then
        child_or_box = Offset(child_or_box, content_box:minx() - self.OffsetX, content_box:miny() - self.OffsetY)
      end
      self:ScrollIntoView(child_or_box)
    end
    self.pending_scroll_into_view = false
  end
  self.layout_update = false
  if self.PendingOffsetX == self.OffsetX and self.PendingOffsetY == self.OffsetY then
    self:RecalcVisibility()
    XControl.UpdateLayout(self)
  end
end
function XScrollArea:ScrollIntoView(child_or_box, boxOnTop)
  if not child_or_box or not IsBox(child_or_box) and child_or_box.window_state == "destroying" then
    return
  end
  local content_box = self.content_box
  if self.layout_update then
    self.pending_scroll_into_view = self.pending_scroll_into_view or {}
    if IsBox(child_or_box) then
      child_or_box = Offset(child_or_box, self.OffsetX - content_box:minx(), self.OffsetY - content_box:miny())
    end
    table.insert(self.pending_scroll_into_view, child_or_box)
    return
  end
  local child_box = IsBox(child_or_box) and child_or_box or child_or_box.box
  local HScroll = self:ResolveId(self.HScroll)
  if HScroll then
    HScroll:ScrollIntoView(child_box:minx() - content_box:minx() + self.OffsetX)
  end
  local VScroll = self:ResolveId(self.VScroll)
  if VScroll then
    VScroll:ScrollIntoView(child_box:miny() - content_box:miny() + self.OffsetY)
  end
  local offset_x, offset_y = self.PendingOffsetX, self.PendingOffsetY
  child_box = Offset(child_box, self.OffsetX - offset_x, self.OffsetY - offset_y)
  if child_box:minx() < content_box:minx() then
    offset_x = offset_x - content_box:minx() + child_box:minx()
  elseif child_box:maxx() > content_box:maxx() then
    offset_x = offset_x - content_box:maxx() + child_box:maxx()
  end
  if child_box:miny() < content_box:miny() then
    offset_y = offset_y - content_box:miny() + child_box:miny()
  elseif child_box:maxy() > content_box:maxy() then
    local childOffset
    if boxOnTop then
      childOffset = Min(child_box:miny() + content_box:sizey(), content_box:miny() + self.scroll_range_y - offset_y)
    else
      childOffset = child_box:maxy()
    end
    offset_y = offset_y - content_box:maxy() + childOffset
  end
  self:ScrollTo(offset_x, offset_y, false, "allow_interpolation")
end
function XScrollArea:ScrollUp()
  local horizontal = (self.HScroll or "") ~= ""
  local vertical = (self.VScroll or "") ~= ""
  local x, y = self.PendingOffsetX, self.PendingOffsetY
  if vertical or not horizontal then
    local max = Max(0, self.scroll_range_y - self.content_box:sizey())
    y = Clamp(y - self.MouseWheelStep, 0, max)
  else
    local max = Max(0, self.scroll_range_x - self.content_box:sizex())
    x = Clamp(x - self.MouseWheelStep, 0, max)
  end
  return self:ScrollTo(x, y, false, "allow_interpolation")
end
function XScrollArea:ScrollDown()
  local horizontal = (self.HScroll or "") ~= ""
  local vertical = (self.VScroll or "") ~= ""
  local x, y = self.PendingOffsetX, self.PendingOffsetY
  if vertical or not horizontal then
    local max = Max(0, self.scroll_range_y - self.content_box:sizey())
    y = Clamp(y + self.MouseWheelStep, 0, max)
  else
    local max = Max(0, self.scroll_range_x - self.content_box:sizex())
    x = Clamp(x + self.MouseWheelStep, 0, max)
  end
  return self:ScrollTo(x, y, false, "allow_interpolation")
end
function XScrollArea:ScrollLeft()
  local horizontal = (self.HScroll or "") ~= ""
  local vertical = (self.VScroll or "") ~= ""
  local x, y = self.PendingOffsetX, self.PendingOffsetY
  if not vertical or horizontal then
    local max = Max(0, self.scroll_range_x - self.content_box:sizex())
    x = Clamp(x - self.MouseWheelStep, 0, max)
  else
    local max = Max(0, self.scroll_range_y - self.content_box:sizey())
    y = Clamp(y - self.MouseWheelStep, 0, max)
  end
  return self:ScrollTo(x, y, false, "allow_interpolation")
end
function XScrollArea:ScrollRight()
  local horizontal = (self.HScroll or "") ~= ""
  local vertical = (self.VScroll or "") ~= ""
  local x, y = self.PendingOffsetX, self.PendingOffsetY
  if not vertical or horizontal then
    local max = Max(0, self.scroll_range_x - self.content_box:sizex())
    x = Clamp(x + self.MouseWheelStep, 0, max)
  else
    local max = Max(0, self.scroll_range_y - self.content_box:sizey())
    y = Clamp(y + self.MouseWheelStep, 0, max)
  end
  return self:ScrollTo(x, y, false, "allow_interpolation")
end
function XScrollArea:OnMouseWheelForward()
  if not self.MouseScroll then
    return
  end
  if self:ScrollUp() or not GetParentOfKind(self.parent, "XScrollArea") then
    return "break"
  end
end
function XScrollArea:OnMouseWheelBack()
  if not self.MouseScroll then
    return
  end
  if self:ScrollDown() or not GetParentOfKind(self.parent, "XScrollArea") then
    return "break"
  end
end
function XScrollArea:OnTouchBegan(id, pos, touch)
  terminal.desktop:SetKeyboardFocus(false)
  touch.start_pos = pos
  touch.start_time = RealTime()
  return "capture"
end
function XScrollArea:OnTouchMoved(id, pos, touch)
  if touch.capture == self then
    local horizontal = (self.HScroll or "") ~= ""
    local vertical = (self.VScroll or "") ~= ""
    local last_pos = touch.last_pos or touch.start_pos
    local diff = pos - last_pos
    local x, y = self.PendingOffsetX, self.PendingOffsetY
    if vertical then
      local max = Max(0, self.scroll_range_y - self.content_box:sizey())
      y = Clamp(y - diff:y(), 0, max)
    end
    if horizontal then
      local max = Max(0, self.scroll_range_x - self.content_box:sizex())
      x = Clamp(x - diff:x(), 0, max)
    end
    touch.last_pos = pos
    if self:ScrollTo(x, y) or not GetParentOfKind(self.parent, "XScrollArea") then
      return "break"
    end
  end
end
local empty_func = function()
end
function XScrollArea:DrawWindow(clip_box)
  if self.PendingOffsetX ~= self.OffsetX or self.PendingOffsetY ~= self.OffsetY then
    self.Invalidate = empty_func
    self:DoScroll(self.PendingOffsetX, self.PendingOffsetY)
    self:UpdateMeasure(self.parent.content_box:size():xy())
    XControl.UpdateLayout(self)
    self.Invalidate = nil
  end
  XControl.DrawWindow(self, clip_box)
end
DefineClass.XFitContent = {
  __parents = {"XControl"},
  properties = {
    {
      category = "Visual",
      id = "Fit",
      name = "Fit",
      editor = "choice",
      default = "none",
      items = {
        "none",
        "width",
        "height",
        "smallest",
        "largest",
        "both"
      }
    }
  }
}
local one = point(1000, 1000)
function XFitContent:UpdateMeasure(max_width, max_height)
  if not self.measure_update then
    return
  end
  local fit = self.Fit
  if fit == "none" then
    XControl.UpdateMeasure(self, max_width, max_height)
    return
  end
  for _, child in ipairs(self) do
    child:SetOutsideScale(one)
  end
  self.scale = one
  XControl.UpdateMeasure(self, 1000000, 1000000)
  local content_width, content_height = ScaleXY(self.parent.scale, self.measure_width, self.measure_height)
  if content_width == 0 or content_height == 0 then
    XControl.UpdateMeasure(self, max_width, max_height)
    return
  end
  if fit == "smallest" or fit == "largest" then
    local space_is_wider = max_width * content_height >= max_height * content_width
    fit = space_is_wider == (fit == "largest") and "width" or "height"
  end
  local scale_x = max_width * 1000 / content_width
  local scale_y = max_height * 1000 / content_height
  if fit == "width" then
    scale_y = scale_x
  elseif fit == "height" then
    scale_x = scale_y
  end
  self:SetScaleModifier(point(scale_x, scale_y))
  XControl.UpdateMeasure(self, max_width, max_height)
end
