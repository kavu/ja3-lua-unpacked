GameVar("gv_LogData", {})
if FirstLoad then
  LogData = {}
  LogShowDebug = false
  CombatLogAnchorBox = false
  CombatLogAnchoredBoxes = {}
end
function OnMsg.GatherSessionData()
  for i, item in ipairs(LogData) do
    gv_LogData[i] = {
      item[1],
      _InternalTranslate(item[2]),
      item[3]
    }
  end
end
function OnMsg.LoadSessionData()
  LogData = {}
  for i, item in ipairs(gv_LogData) do
    LogData[i] = {
      item[1],
      Untranslated(item[2]),
      item[3]
    }
  end
  local dlg = GetDialog("CombatLog")
  if dlg then
    dlg:UpdateText()
  end
end
function OnMsg.NewGameSessionStart()
  local dlg = GetDialog("CombatLog")
  if dlg then
    dlg:UpdateText()
  end
end
function OnMsg.EnterSector(game_start, load_game)
  if not game_start and not load_game then
    gv_LogData = {}
    LogData = {}
    local dlg = GetDialog("CombatLog")
    if dlg then
      dlg:UpdateText()
    end
  end
end
function InGameInterface:OnShortcut(shortcut, source, ...)
  local desktop = self.desktop
  if desktop:GetModalWindow() == desktop and self.mode_dialog and self.mode_dialog:GetVisible() and desktop.keyboard_focus and not desktop.keyboard_focus:IsWithin(self.mode_dialog) then
    return self.mode_dialog:OnShortcut(shortcut, source, ...)
  end
end
local lResolveCombatLogMessageActor = function(prevLine, name)
  if prevLine and prevLine[1] == name then
    return false
  end
  if name == "debug" then
    return Untranslated("Debug")
  elseif name == "helper" then
    return "helper"
  elseif name == "short" then
    return T(502734170556, "AIMBot")
  elseif UnitDataDefs[name] then
    return UnitDataDefs[name].Nick or UnitDataDefs[name].Name or Untranslated(name)
  elseif IsT(name) then
    return name
  else
    return Untranslated(name)
  end
end
DefineClass.CombatLogAnchorAnimationWindow = {
  __parents = {"XDialog"},
  properties = {
    {
      editor = "bool",
      id = "flip_vertically",
      default = true
    }
  },
  popup_time = 200,
  suppressesCombatLog = false
}
function CombatLogAnchorAnimationWindow:SuppressCombatLog()
  local dlg = GetDialog("CombatLog")
  if not dlg or dlg.window_state == "destroying" then
    return
  end
  dlg.idLogContainer:SetVisible(false)
  local fader = GetDialog("CombatLogMessageFader")
  if fader then
    fader:SetVisible(false)
  end
  self.suppressesCombatLog = true
end
function CombatLogAnchorAnimationWindow:OnDelete()
  if not self.suppressesCombatLog then
    return
  end
  local dlg = GetDialog("CombatLog")
  if not dlg then
    return
  end
  local fader = GetDialog("CombatLogMessageFader")
  if fader then
    fader:SetVisible(true)
  end
  dlg.idLogContainer:SetVisible(true)
end
function CombatLogAnchorAnimationWindow:Open()
  CombatLogAnchoredBoxes[self] = true
  self:SetVisible(not CombatLogAnchorBox)
  XDialog.Open(self)
end
function CombatLogAnchorAnimationWindow:Close()
  CombatLogAnchoredBoxes[self] = nil
  XDialog.Close(self)
end
function OnMsg.CombatLogVisibleChanged(state)
  if state == "start hiding" then
    PlayFX("CombatLogClose", "start")
  elseif state == "start showing" then
    PlayFX("CombatLogOpen", "start")
  end
end
function CombatLogAnchorAnimationWindow:AnimatedClose(hideInsteadOfClose, instant)
  self:DeleteThread("animation-open")
  if not self:IsVisible() then
    self.open = false
    return
  end
  if instant then
    Msg("CombatLogVisibleChanged", "start hiding")
    if hideInsteadOfClose then
      self:SetVisible(false)
      self.open = false
    else
      self:Close()
    end
    return
  end
  if self:GetThread("animation-close") then
    return
  end
  self:CreateThread("animation-close", function()
    self:AddInterpolation({
      id = "size",
      type = const.intRect,
      duration = self.popup_time,
      originalRect = self.box,
      targetRect = CombatLogAnchorBox
    })
    Msg("CombatLogVisibleChanged", "start hiding")
    Sleep(self.popup_time)
    if self.window_state ~= "open" then
      return
    end
    if hideInsteadOfClose then
      self:SetVisible(false)
      self.open = false
    else
      self:Close()
    end
  end)
end
function CombatLogAnchorAnimationWindow:AnimatedOpen()
  local combatLogFader = GetDialog("CombatLogMessageFader")
  if combatLogFader then
    combatLogFader:DeleteChildren()
  end
  self:DeleteThread("animation-close")
  if self:GetThread("animation-open") then
    return
  end
  self:CreateThread("animation-open", function()
    Sleep(1)
    if self.visible then
      return
    end
    self:SetBoxFromAnchor()
    self:SetVisible(true)
    self:AddInterpolation({
      id = "size",
      type = const.intRect,
      duration = self.popup_time,
      originalRect = self.box,
      targetRect = CombatLogAnchorBox,
      flags = const.intfInverse
    })
    local isCombatLog = IsKindOf(self, "CombatLogWindow")
    if isCombatLog then
      Msg("CombatLogVisibleChanged", "start showing")
    end
    Sleep(self.popup_time)
    if isCombatLog then
      Msg("CombatLogVisibleChanged", "visible")
    end
  end)
end
function CombatLogAnchorAnimationWindow:OnLayoutComplete()
  if not CombatLogAnchorBox or self:GetThread("animation-close") then
    return
  end
  self:AnimatedOpen()
end
function CombatLogAnchorAnimationWindow:SetBoxFromAnchor()
  local x, y, width, height = false, false, false, false
  width, height = self.measure_width, self.measure_height
  local heightLimitPoint = GetCombatLogHeightLimit()
  local _, marginY = ScaleXY(self.scale, 0, 5)
  heightLimitPoint = heightLimitPoint and heightLimitPoint - marginY
  if self.flip_vertically then
    if heightLimitPoint and heightLimitPoint <= CombatLogAnchorBox:miny() + height then
      x, y = CombatLogAnchorBox:minx(), CombatLogAnchorBox:miny() - height + CombatLogAnchorBox:sizey()
    else
      x, y = CombatLogAnchorBox:minx(), CombatLogAnchorBox:miny()
    end
  else
    local max = CombatLogAnchorBox:miny() + height
    if heightLimitPoint and heightLimitPoint <= max then
      local belowHeightPoint = max - heightLimitPoint
      x, y = CombatLogAnchorBox:minx(), CombatLogAnchorBox:miny() - belowHeightPoint
    else
      x, y = CombatLogAnchorBox:minx(), CombatLogAnchorBox:miny()
    end
  end
  if self.Dock == "ignore" then
    self:SetBox(x, y, width, height, true)
  elseif self.SetBoxFromAnchorInternal then
    self:SetBoxFromAnchorInternal(x, y)
  end
end
function OnMsg.CombatLogButtonChanged()
  if not GetDialog("CombatLog") then
    local dlg = OpenDialog("CombatLog")
    dlg:SetVisible(false)
  end
  for wnd, visible in pairs(CombatLogAnchoredBoxes) do
    if wnd and wnd.window_state ~= "destroying" then
      wnd:SetBoxFromAnchor()
    end
  end
  local log = GetDialog("CombatLog")
  log:SetBoxFromAnchor()
end
CombatLogDefaultZOrder = 2
table.insert(BlacklistedDialogClasses, "CombatLogMessageFader")
DefineClass.CombatLogMessageFader = {
  __parents = {"XDialog"},
  Dock = "ignore",
  ZOrder = CombatLogDefaultZOrder,
  LayoutMethod = "VList",
  FocusOnOpen = "",
  MinWidth = 500,
  MaxWidth = 500,
  MinHeight = 185,
  MaxHeight = 185,
  HandleMouse = false,
  ChildrenHandleMouse = false
}
function CombatLogMessageFader:UpdateLayout()
  if not self.layout_update then
    return
  end
  local heightLimitPoint = GetCombatLogHeightLimit()
  local x = CombatLogAnchorBox and CombatLogAnchorBox:minx() or 0
  local y = CombatLogAnchorBox and CombatLogAnchorBox:maxy() or 0
  local height = self.measure_height
  local yMax = y + height
  if heightLimitPoint and heightLimitPoint <= yMax then
    local diff = yMax - heightLimitPoint
    y = y - height
  end
  self:SetBox(x, y, self.measure_width, height)
  XDialog.UpdateLayout(self)
end
DefineClass.CombatLogText = {
  __parents = {"XText"},
  Translated = true,
  Padding = box(0, 0, 0, 0),
  TextStyle = "CombatLog",
  HAlign = "left",
  VAlign = "top"
}
DefineClass.CombatLogWindow = {
  __parents = {
    "CombatLogAnchorAnimationWindow"
  },
  Dock = "ignore",
  ZOrder = CombatLogDefaultZOrder,
  scroll_area = false,
  main_textbox = false,
  FocusOnOpen = "",
  open = false
}
function CombatLogWindow:Open(...)
  CombatLogAnchorAnimationWindow.Open(self, ...)
  self.scroll_area = self:ResolveId("idScrollArea")
  self:UpdateText()
  local satellite = GetDialog("PDADialogSatellite")
  if satellite and satellite.window_state ~= "destroying" then
    self:SetZOrder(1)
    local popupHost = satellite:ResolveId("idDisplayPopupHost")
    self:SetParent(popupHost)
  else
    self:SetZOrder(CombatLogDefaultZOrder)
    self:SetParent(GetInGameInterface())
  end
end
function CombatLogWindow:AnimatedOpen()
  if self.open then
    return
  end
  local satellite = GetDialog("PDADialogSatellite")
  if satellite and not self:IsWithin(satellite) and satellite.window_state ~= "destroying" then
    local popupHost = satellite:ResolveId("idDisplayPopupHost")
    self:SetZOrder(1)
    self:SetParent(popupHost)
  end
  CombatLogAnchorAnimationWindow.AnimatedOpen(self)
  self:ScrollToBottom()
  self.open = true
end
function CombatLogWindow:OnDelete()
  Msg("CombatLogVisibleChanged")
end
function CombatLogWindow:OnLayoutComplete(...)
  if self.visible then
    CombatLogAnchorAnimationWindow.OnLayoutComplete(self)
  end
end
function CombatLogWindow:ScrollToBottom()
  self:DeleteThread("delayed_scroll")
  self:CreateThread("delayed_scroll", function()
    if #self.scroll_area == 0 then
      return
    end
    local lastLine = self.scroll_area[#self.scroll_area]
    self.scroll_area:ScrollIntoView(lastLine)
  end)
end
function CombatLogWindow:OnScaleChanged()
  self:ScrollToBottom()
end
function GetCombatLogHeightLimit()
  local pda = GetDialog("PDADialogSatellite")
  if pda then
    return pda.idDisplay.box:maxy()
  end
  local igi = GetInGameInterfaceModeDlg()
  if not IsKindOf(igi, "IModeCommonUnitControl") then
    return
  end
  local bottomLeftUI = igi.idLeft
  if not bottomLeftUI then
    return
  end
  local limitPoint = bottomLeftUI.box:miny()
  local weaponUI = igi.idWeaponUI
  if weaponUI and weaponUI.idOtherSets then
    limitPoint = weaponUI.idOtherSets.box:miny()
  end
  return limitPoint
end
local FindLastFilterPassingLine = function()
  for i = #LogData - 1, 1, -1 do
    local item = LogData[i]
    if item[1] ~= "helper" and (item[1] ~= "debug" or LogShowDebug) then
      return item
    end
  end
end
local lSetupText = function(textWnd, item, name)
  textWnd:SetTranslate(true)
  if name then
    if name == "helper" then
      textWnd:SetText(T({
        997455386796,
        "<indent><text>",
        indent = "  ",
        text = item[2]
      }))
    else
      textWnd:SetText(T({
        632558295987,
        "<em><name></em>: <text>",
        name = name,
        text = item[2]
      }))
    end
  else
    textWnd:SetText(T({
      588344253198,
      "><text>",
      text = item[2]
    }))
  end
  if textWnd.window_state ~= "open" then
    textWnd:Open()
  end
end
function CombatLogWindow:LineAdded(item)
  if item[1] == "debug" and not LogShowDebug then
    return
  end
  local isAtBottom = self.scroll_area.scroll_range_y - self.scroll_area.content_box:sizey() - self.scroll_area.PendingOffsetY < self.scroll_area.MouseWheelStep
  local newLabel = XTemplateSpawn("CombatLogText", self.scroll_area)
  lSetupText(newLabel, item, lResolveCombatLogMessageActor(FindLastFilterPassingLine(), item[1]))
  if isAtBottom then
    self.scroll_area:ScrollIntoView(newLabel)
  end
end
function CombatLogWindow:UpdateText()
  local idScrollArea = self.scroll_area
  local spawnedLines = #idScrollArea
  local textLines = #LogData
  local count = 0
  local prevFilteredLine = false
  for i, item in ipairs(LogData) do
    local name = item[1]
    if name ~= "debug" or LogShowDebug then
      count = count + 1
      local labelWindow
      local nameResolved = lResolveCombatLogMessageActor(prevFilteredLine, name)
      if spawnedLines < count then
        labelWindow = XTemplateSpawn("CombatLogText", idScrollArea)
      else
        labelWindow = idScrollArea[count]
      end
      lSetupText(labelWindow, item, nameResolved)
      prevFilteredLine = item
    end
  end
  while count < #idScrollArea do
    idScrollArea[#idScrollArea]:delete()
  end
  if 0 < #idScrollArea then
    idScrollArea:ScrollIntoView(idScrollArea[#idScrollArea])
  end
end
function CombatLogWindow:OnMouseButtonDown(pt, ...)
  if not self:MouseInWindow(pt) then
    return
  end
  XDialog.OnMouseButtonDown(self, pt, ...)
  return "break"
end
function CombatLogWindow:OnMouseButtonUp(pt, ...)
  if not self:MouseInWindow(pt) then
    return
  end
  XDialog.OnMouseButtonUp(self, pt, ...)
  return "break"
end
function CombatLogWindow:OnMouseWheelForward(pt, ...)
  if not self:MouseInWindow(pt) then
    return
  end
  local scroll = self:ResolveId("idScrollArea")
  scroll:OnMouseWheelForward(pt, ...)
  return "break"
end
function CombatLogWindow:OnMouseWheelBack(pt, ...)
  if not self:MouseInWindow(pt) then
    return
  end
  local scroll = self:ResolveId("idScrollArea")
  scroll:OnMouseWheelBack(pt, ...)
  return "break"
end
function CombatLog(actor, msg, dontTHN)
  if CheatEnabled("CombatUIHidden") then
    return
  end
  if actor == "debug" and not IsT(msg) then
    msg = Untranslated(msg)
  end
  local important = actor == "important"
  if important then
    actor = "short"
  end
  local newLine = {
    actor,
    msg,
    Game and Game.CampaignTime or 0
  }
  LogData[#LogData + 1] = newLine
  local diag = GetDialog("CombatLog")
  if diag then
    diag:LineAdded(newLine)
  end
  ObjModified(LogData)
  if important and (not diag or not diag.open) then
    local nameResolved = lResolveCombatLogMessageActor(false, actor)
    local faderContainer = GetDialog("CombatLogMessageFader") or OpenDialog("CombatLogMessageFader")
    local labelWindow = XTemplateSpawn("CombatLogText", faderContainer)
    labelWindow:SetTextStyle("CombatLogFade")
    labelWindow:SetBackground(GetColorWithAlpha(GameColors.DarkB, 125))
    labelWindow:SetPadding(box(5, 5, 5, 5))
    labelWindow:SetMinWidth(faderContainer.MinWidth)
    labelWindow:SetMaxWidth(faderContainer.MaxWidth)
    labelWindow:SetVisible(false, true)
    labelWindow:CreateThread(function()
      WaitPlayerControl()
      RunWhenXWindowIsReady(labelWindow, function()
        labelWindow:AddInterpolation({
          id = "move",
          type = const.intRect,
          OnLayoutComplete = IntRectTopLeftRelative,
          targetRect = labelWindow:CalcZoomedBox(600),
          originalRect = labelWindow.box,
          duration = 200,
          autoremove = true,
          flags = const.intfInverse
        })
      end)
      labelWindow:SetVisible(true, true)
      Sleep(10000)
      labelWindow.FadeOutTime = 400
      labelWindow:SetVisible(false)
      Sleep(labelWindow.FadeOutTime)
      labelWindow:Close()
    end)
    lSetupText(labelWindow, newLine, nameResolved)
  end
end
function HideCombatLog(nonInstant)
  local combatLog = GetDialog("CombatLog")
  if combatLog then
    combatLog:AnimatedClose("hideInsteadOfClose", not nonInstant and "instant")
    local fader = GetDialog("CombatLogMessageFader")
    if fader then
      fader:DeleteChildren()
    end
  end
end
OnMsg.OpenPDA = HideCombatLog
OnMsg.CloseSatelliteView = HideCombatLog
OnMsg.ModifyWeaponDialogOpened = HideCombatLog
OnMsg.HideCombatLog = HideCombatLog
function GetCombatLogNameStyle(unitTemplate)
  local affil = unitTemplate and unitTemplate.Affiliation
  if affil == "AIM" then
    return "CombatLogNameMerc"
  elseif affil == "Legion" then
    return "CombatLogNameEnemy"
  end
  return "CombatLogButtonActive"
end
function OpenCombatLog()
  if CheatEnabled("CombatUIHidden") then
    return
  end
  local combatLog = GetDialog("CombatLog")
  if combatLog then
    combatLog:AnimatedOpen()
    return
  end
  OpenDialog("CombatLog")
end
