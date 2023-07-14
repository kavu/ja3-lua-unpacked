DefineClass.XScrollOld = {
  __parents = {"XScroll"}
}
function XScrollOld:SetScrollRange(min, max)
  max = Max(max, min)
  if self.Min == min and self.Max == max then
    return
  end
  self.Min = min
  self.Max = max
  local target = self.SnapToItems and self:ResolveId(self.Target)
  if target then
    self:SetScroll(self.Horizontal and target.PendingOffsetX or target.PendingOffsetY)
  else
    self:SetScroll(self.Scroll)
  end
end
function XScrollOld:ShouldShow()
  if not self.AutoHide then
    return true
  end
  local target = self:ResolveId(self.Target)
  if not target then
    return
  end
  if self.Horizontal then
    return 0 < Max(0, target.scroll_range_x - target.content_box:sizex())
  end
  return 0 < Max(0, target.scroll_range_y - target.content_box:sizey())
end
function XScrollOld:SetScroll(current)
  current = current + (self.Min - current) % self.StepSize
  if self.AutoHide then
    self:SetVisible(self:ShouldShow())
  end
  local scroll_end = self.Max - (self.FullPageAtEnd and self.PageSize or 0)
  local target = self.SnapToItems and self:ResolveId(self.Target)
  if target then
    local horizontal = self.Horizontal
    if target.UniformRowHeight or target.UniformColumnWidth then
      local h_spacing, v_spacing = ScaleXY(target.scale, target.LayoutHSpacing, target.LayoutVSpacing)
      scroll_end = scroll_end + (horizontal and h_spacing or v_spacing or 0)
    end
    current = Clamp(current, self.Min, scroll_end)
    if 0 <= current then
      local x = horizontal and current or target.PendingOffsetX
      local y = not horizontal and current or target.PendingOffsetY
      target:ScrollTo(x, y)
    end
  else
    current = Clamp(current, self.Min, scroll_end)
  end
  if self.Scroll ~= current then
    self.Scroll = current
    self:Invalidate()
    return true
  end
end
function XScrollOld:SetPageSize(page_size)
  page_size = page_size - page_size % self.StepSize
  local new_size = Max(page_size, 1)
  if self.PageSize == new_size then
    return
  end
  self.PageSize = new_size
  local target = self.SnapToItems and self:ResolveId(self.Target)
  if target then
    self:SetScroll(self.Horizontal and target.PendingOffsetX or target.PendingOffsetY)
  else
    self:SetScroll(self.Scroll)
  end
end
DefineClass.XScrollAreaOld = {
  __parents = {
    "XScrollArea"
  }
}
function XScrollAreaOld:ScrollTo(x, y, force, allow_interpolation)
  x = x or self.PendingOffsetX
  y = y or self.PendingOffsetY
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
function XScrollAreaOld:DoScroll(x, y)
  local dx = self.OffsetX - x
  local dy = self.OffsetY - y
  if dx ~= 0 or dy ~= 0 then
    if self.OffsetX ~= x then
      local scroll = self:ResolveId(self.HScroll)
      if scroll then
        scroll:SetScroll(x)
      end
    end
    if self.OffsetY ~= y then
      local scroll = self:ResolveId(self.VScroll)
      if scroll then
        scroll:SetScroll(y)
      end
    end
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
DefineClass.XCreditsWindow = {
  __parents = {
    "XScrollAreaOld"
  },
  paused = false,
  time_step = 100,
  Clip = "self",
  Background = RGBA(0, 0, 0, 0),
  Margins = box(0, -400, 0, -200),
  ChildrenHandleMouse = false,
  VScroll = "idScrollCredits"
}
function XCreditsWindow:Init()
  XText:new({
    Id = "idCredits",
    HAlign = "center",
    ChildrenHandleMouse = false,
    TextStyle = "CreditsTitle",
    TextHAlign = "center"
  }, self)
  XScrollOld:new({
    Id = "idScrollCredits"
  }, self)
  self:SetTextData()
  self:SetFocus()
end
function XCreditsWindow:SetTextData()
  local texts = {}
  local lang = GetLanguage()
  local voice_lang = GetVoiceLanguage()
  for i = 1, #CreditContents do
    local section = CreditContents[i]
    if (not section.platform or Platform[section.platform]) and (not section.language or section.language == lang) and (not section.voice_language or section.voice_language == voice_lang) then
      if section.company_logo then
        texts[#texts + 1] = _InternalTranslate(section.company_logo)
        texts[#texts + 1] = [[








]]
      elseif section.company_name then
        texts[#texts + 1] = _InternalTranslate("<style PGMenuMainSubTitle>" .. section.company_name .. "</style>")
        texts[#texts + 1] = [[













]]
      end
      for _, text in ipairs(section) do
        local translated = _InternalTranslate(text)
        if translated and translated ~= "" and translated ~= "-" then
          texts[#texts + 1] = translated
          texts[#texts + 1] = [[













]]
        end
      end
      if section.footer then
        texts[#texts + 1] = _InternalTranslate(section.footer)
        texts[#texts + 1] = [[













]]
      end
      texts[#texts + 1] = [[








]]
    end
  end
  self.idCredits:SetText(table.concat(texts))
end
function XCreditsWindow:MoveThread()
  self:CreateThread("scroll", function()
    local text_ctrl = self.idCredits
    local height = text_ctrl.text_height
    local tStart = GetPreciseTicks()
    local screeny = UIL.GetScreenSize():y()
    local per_second = screeny * 60 / 1000
    self:ScrollTo(0, -screeny)
    local pos = -screeny
    local pos = -screeny
    while height > pos do
      if self.paused then
        while self.paused do
          Sleep(self.time_step)
          tStart = tStart + self.time_step
        end
        tStart = tStart - self.time_step
      end
      pos = -screeny + (GetPreciseTicks() - tStart) * per_second / 1000
      self:ScrollTo(0, pos)
      text_ctrl:AddInterpolation({
        id = "pos",
        type = const.intRect,
        duration = 2 * self.time_step,
        originalRect = text_ctrl.box,
        targetRect = Offset(text_ctrl.box, point(0, -per_second * 2 * self.time_step / 1000))
      })
      Sleep(self.time_step)
    end
    local dialog = GetDialog(self)
    if dialog then
      dialog:Close()
    end
  end)
end
function XCreditsWindow:OnMouseButtonUp(pt, button)
  if button == "L" then
    self.paused = not self.paused
    return "break"
  end
  if button == "R" then
    local dialog = GetDialog(self)
    if dialog then
      dialog:Close()
    end
    return "break"
  end
end
function XCreditsWindow:OnShortcut(shortcut, source, ...)
  if shortcut == "Space" or shortcut == "ButtonA" then
    self.paused = not self.paused
    return "break"
  end
end
const.TagLookupTable.crp = "<style CreditsPosition>"
const.TagLookupTable["/crp"] = "</style>"
const.TagLookupTable.crn = "<style CreditsNames>"
const.TagLookupTable["/crn"] = "</style>"
const.TagLookupTable.cmn = "<style CreditsMultiNames>"
const.TagLookupTable["/cmn"] = "</style>"
const.TagLookupTable.crt = "<style CreditsTitle>"
const.TagLookupTable["/crt"] = "</style>"
