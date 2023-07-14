GameVar("gv_Timeline", function()
  return {}
end)
if FirstLoad then
  g_SatTimelineUI = false
end
function OnMsg.NewGame()
  gv_Timeline = {}
end
local lTimelineMaxTime = 7
local lDefaultTimeScale, lTimeScaleDownscaleEventCount = 7, 5
local lSegmentWidth, lSegmentHeight = 70, 45
local lBottomLineHeight, lBottomLineColorDay, lBottomLineColorNight = 6, RGB(106, 96, 68), RGB(68, 96, 106)
local lSegmentSpacing = 0
local lMapWidth = (lTimelineMaxTime + 1) * lSegmentWidth
local lTimescales = {
  1,
  4,
  7
}
local lTimescaleDownThreshold = 5
local lEventFrequencyDedupe = const.Scale.h * 3
local lInteractionExtendAbove = 40
local lEphemeralEvents = {
  ["travelling-temp"] = true,
  ["activity-temp"] = true
}
DefineClass.SatelliteTimeline = {
  __parents = {"XMap"},
  translation_modId = 2,
  scale_modId = 3,
  MinWidth = 495,
  MaxWidth = 495,
  MinHeight = 45,
  MaxHeight = 45,
  map_size = point(lMapWidth, 45),
  HAlign = "center",
  VAlign = "center",
  day_sections = false,
  map_rect = false,
  bottom_line_rects = false,
  bottom_line_rect_color = false,
  bottom_line_icons = false,
  lock_on_rect = false,
  time_scale_days = lDefaultTimeScale,
  time_scale = 1000,
  max_zoom = 10000,
  icons_created = false,
  future_event = false,
  rollover_icon = false,
  preview = false,
  paused_color = false
}
function SatelliteTimeline:Init()
  local day_sections = {}
  local pen = 0
  for i = 1, lTimelineMaxTime + 1 do
    local t = XTemplateSpawn("SatelliteTimelineLabelContainer", self)
    t.PosX = pen
    t:SetWidth(lSegmentWidth)
    t:SetHeight(45)
    day_sections[#day_sections + 1] = {
      box = sizebox(pen, 0, lSegmentWidth, lSegmentHeight),
      color = 0,
      text = t
    }
    pen = pen + lSegmentWidth
  end
  self.day_sections = day_sections
  self.map_rect = sizebox(0, 0, self.map_size)
  self.bottom_line_rects = {}
  self.bottom_line_rect_color = {}
  self.bottom_line_icons = {}
end
function SatelliteTimeline:Open()
  local futureEventIcon = self:ResolveId("node")
  futureEventIcon = futureEventIcon and futureEventIcon.idTimelineFutureEvent
  futureEventIcon = futureEventIcon or XTemplateSpawn("SatelliteTimelineIconBase", self.parent)
  futureEventIcon:SetAsEvent(false)
  self.future_event = futureEventIcon
  XMap.Open(self)
  self:RefreshEvents()
  g_SatTimelineUI = self
end
function SatelliteTimeline:OnDelete()
  g_SatTimelineUI = false
end
local lGetTimeOrigin = function(raw)
  local startTime = GetCurrentCampaignPreset()
  startTime = startTime and startTime.starting_timestamp or 0
  startTime = startTime / const.Scale.day * const.Scale.day
  return startTime
end
function SatelliteTimeline:GetTimeWiseCurrentX(scale)
  local currentTime = Game and Game.CampaignTime or 0
  local startTime = lGetTimeOrigin()
  local segmentSize = MulDivRound(lSegmentWidth, scale or 1000, 1000)
  local currentDayX = MulDivRound(currentTime - startTime, lSegmentWidth, const.Scale.day)
  return self.box:minx() - MulDivRound(currentDayX, scale, 1000)
end
function SatelliteTimeline:SetTimescale(daysToShow, noInterp)
  local timeScale = MulDivRound(1000, lDefaultTimeScale, daysToShow)
  self.time_scale = timeScale - timeScale % 100
  local calculatedScale = MulDivRound(self.parent.scale:x(), self.time_scale, 1000)
  self:SetMapZoom(calculatedScale, noInterp and 0 or 200)
  self.time_scale_days = daysToShow
  self:SyncToTime("skip_scroll")
  self:Invalidate()
end
function SatelliteTimeline:SyncToTime(skip_scroll)
  if not gv_SatelliteView then
    return
  end
  if not self.current_scale then
    return
  end
  local currentTime = Game and Game.CampaignTime or 0
  local startTime = lGetTimeOrigin()
  local currentX = self:GetTimeWiseCurrentX(self.current_scale)
  if not skip_scroll then
    self:SetMapScroll(currentX, 0, 0)
  end
  local dayStart = startTime / const.Scale.day
  local dayCurrent = currentTime / const.Scale.day
  local dayCurrentTimestamp = dayCurrent * const.Scale.day
  local firstSegmentX = lSegmentWidth * (dayCurrent - dayStart)
  local pen = firstSegmentX
  local lineSectionSize = lSegmentWidth
  for i, s in ipairs(self.day_sections) do
    s.box = sizebox(pen, 0, lSegmentWidth, lSegmentHeight)
    s.color = GetColorWithAlpha(GameColors.D, (dayCurrent + i) % 2 ~= 0 and 50 or 0)
    if s.text.PosX ~= pen then
      s.text.PosX = pen
      s.text:InvalidateLayout()
    end
    local text
    if self.time_scale_days <= 4 then
      text = T({
        143462819539,
        "<month(t)> <day(t)>",
        t = dayCurrentTimestamp + (i - 1) * const.Scale.day
      })
    else
      text = T({
        398256878817,
        "<day(t)>",
        t = dayCurrentTimestamp + (i - 1) * const.Scale.day
      })
    end
    s.text:SetText(text)
    local separatorSize = MulDivRound(2, 1000, self.current_scale)
    s.separatorOne = sizebox(pen - separatorSize / 2, lSegmentHeight - 10, separatorSize, lSegmentHeight + 1)
    pen = pen + lSegmentWidth
  end
  self.map_rect = box(firstSegmentX, 0, pen, self.map_size:y())
  local firstSegment = self.day_sections[1]
  local lastSegment = self.day_sections[#self.day_sections]
  table.clear(self.bottom_line_rects)
  self.bottom_line_rect_color[1] = RGB(106, 96, 68)
  self.bottom_line_rects[1] = box(firstSegment.box:minx(), lSegmentHeight - lBottomLineHeight, lastSegment.box:maxx(), lSegmentHeight + 1)
  currentTime = currentTime + const.Satellite.Tick
  local firstEvent = gv_Timeline[1]
  if firstEvent and currentTime > firstEvent.due then
    self:RefreshEvents()
  end
  local firstSegment = self.day_sections[1]
  local lockTime = g_SatTimelineUI and g_SatTimelineUI.preview
  if lockTime then
    local x = MulDivRound(lockTime - startTime, lSegmentWidth, const.Scale.day)
    local relativeX = x
    self.lock_on_rect = box(firstSegment.box:minx(), lSegmentHeight - lBottomLineHeight, relativeX, lSegmentHeight + 1)
  else
    self.lock_on_rect = false
  end
end
function SatelliteTimeline:RefreshEvents()
  if not self.icons_created then
    self.icons_created = {}
  end
  local nowTime = Game.CampaignTime + const.Satellite.Tick
  local timeScaleToCount, timeScaleToActualTime = {}, {}
  for i, area in ipairs(lTimescales) do
    timeScaleToCount[area] = 0
    timeScaleToActualTime[area] = nowTime + area * const.Scale.day
  end
  local eventIdx, lastEventTime = 1, false
  local eventsCombined = false
  local expiredEvents, anyEphemeralEvents = false, false
  local eventsPastScale = {}
  local ephemeralEventInScale = false
  for i, event in ipairs(gv_Timeline) do
    local ephemeral = lEphemeralEvents[event.id]
    local eventDue = event.due
    if not ephemeral and nowTime >= eventDue then
      expiredEvents = true
    else
      anyEphemeralEvents = anyEphemeralEvents or ephemeral
      if self.icons_created[eventIdx - 1] then
        local lastEventIcon = self.icons_created[eventIdx - 1]
        ephemeral = ephemeral or lEphemeralEvents[lastEventIcon.event.id]
      end
      local eventWasCombined = false
      if lastEventTime and abs(eventDue - lastEventTime) < lEventFrequencyDedupe and not ephemeral then
        eventsCombined = eventsCombined or {}
        eventsCombined[#eventsCombined + 1] = event
        lastEventTime = eventDue
        eventWasCombined = true
      end
      for timeArea, actualTime in pairs(timeScaleToActualTime) do
        if actualTime >= eventDue then
          if not ephemeralEventInScale and ephemeral then
            ephemeralEventInScale = timeArea
          end
          if not eventWasCombined then
            timeScaleToCount[timeArea] = timeScaleToCount[timeArea] + 1
          end
        else
          if not eventsPastScale[timeArea] then
            eventsPastScale[timeArea] = {}
          end
          local pastScaleArr = eventsPastScale[timeArea]
          pastScaleArr[#pastScaleArr + 1] = event
        end
      end
      if not eventWasCombined then
        if eventsCombined then
          local lastEventIcon = self.icons_created[eventIdx - 1]
          lastEventIcon:SetCombinedEvents(eventsCombined)
        end
        local icon = false
        if self.icons_created[eventIdx] then
          icon = self.icons_created[eventIdx]
        else
          icon = XTemplateSpawn("SatelliteTimelineIcon", self)
          icon:Open()
          self.icons_created[eventIdx] = icon
        end
        icon:SetAsEvent(event, eventsCombined)
        eventIdx = eventIdx + 1
        lastEventTime = eventDue
        eventsCombined = false
      end
    end
  end
  if eventsCombined then
    local lastEventIcon = self.icons_created[eventIdx - 1]
    lastEventIcon:SetCombinedEvents(eventsCombined)
    eventsCombined = false
  end
  if expiredEvents then
    local hireEventPassed = false
    local nonEphemeralEventPassed = false
    for i, ev in ipairs(gv_Timeline) do
      if nowTime > ev.due then
        hireEventPassed = hireEventPassed or ev.typ == "hire"
        nonEphemeralEventPassed = nonEphemeralEventPassed or not lEphemeralEvents[ev.id]
        gv_Timeline[i] = nil
      end
    end
    table.compact(gv_Timeline)
    if hireEventPassed then
      PlayFX("TimelineEventContractExpire", "start")
    elseif nonEphemeralEventPassed then
      PlayFX("TimelineEventPassed", "start")
    end
  end
  for i, icon in ipairs(self.icons_created) do
    local event = icon.event
    if anyEphemeralEvents then
      local ephemeral = lEphemeralEvents[event.id]
      icon:SetTransparency(ephemeral and 0 or 200)
    elseif icon.Transparency ~= 0 then
      icon:SetTransparency(0)
    end
  end
  for i = eventIdx, #self.icons_created do
    self.icons_created[i]:SetAsEvent(false)
  end
  local bestArea = 7
  for i = 1, #lTimescales do
    local area = lTimescales[i]
    local count = timeScaleToCount[area]
    if count >= lTimeScaleDownscaleEventCount then
      local previousArea = lTimescales[i - 1] or lTimescales[1]
      local previousCount = timeScaleToCount[previousArea]
      if 2 < previousCount then
        bestArea = previousArea
      end
      break
    end
  end
  if ephemeralEventInScale and ephemeralEventInScale > bestArea then
    bestArea = ephemeralEventInScale
  end
  if bestArea ~= self.time_scale_days then
    self:SetTimescale(bestArea)
  end
  local eventsPastArea = eventsPastScale[bestArea]
  self.future_event:SetAsEvent(eventsPastArea and eventsPastArea[1])
  if eventsPastArea and 1 < #eventsPastArea then
    self.future_event:SetCombinedEvents(eventsPastArea, "future")
  end
  self.future_event.icon:SetImage("UI/Icons/SateliteView/icon_timeline")
  self.future_event.inner_icon:SetVisible(true)
  self.future_event.inner_icon:SetImage("UI/Icons/SateliteView/future_events")
end
function OnMsg.StartSatelliteGameplay()
  if g_SatTimelineUI and g_SatTimelineUI.window_state == "open" then
    g_SatTimelineUI:SyncToTime()
  end
end
function OnMsg.SatelliteTick()
  if g_SatTimelineUI and g_SatTimelineUI.window_state == "open" then
    g_SatTimelineUI:SyncToTime()
  end
end
function SatelliteTimeline:OnLayoutComplete()
  if self.last_box ~= self.box then
    self:SetTimescale(self.time_scale_days, true)
    self.last_box = self.box
  else
    for _, win in ipairs(self) do
      if win.UpdateZoom then
        win:UpdateZoom(self.last_scale, self.current_scale, 0)
      end
    end
  end
end
function SatelliteTimeline:SetMapScroll(transX, transY, time)
  local scale = UIL.GetParam(self.scale_modId, "end")
  local win_box = self.box
  transY = win_box:miny()
  UIL.SetParam(self.translation_modId, transX, transY, time or 100)
end
function SatelliteTimeline:SetMapZoom(scale, time, origin_pos)
  local current_scale = UIL.GetParam(self.scale_modId)
  scale = Clamp(scale, 1, self.max_zoom)
  time = 0
  local currentX = self:GetTimeWiseCurrentX(scale)
  CreateRealTimeThread(function()
    WaitNextFrame()
    UIL.SetParam(self.scale_modId, scale, self.scale:y(), time)
    if not origin_pos then
      self:SetMapScroll(currentX, 0, time)
    end
  end)
  self.last_scale = current_scale
  self.current_scale = scale
  for _, win in ipairs(self) do
    if win.UpdateZoom then
      win:UpdateZoom(current_scale, scale, time)
    end
  end
end
function SatelliteTimeline:DrawContent()
  UIL.DrawSolidRect(self.map_rect, GameColors.A)
  for i, section in ipairs(self.day_sections) do
    UIL.DrawSolidRect(section.box, section.color)
  end
  if self.bottom_line_rects then
    for i, rect in ipairs(self.bottom_line_rects) do
      local color = self.bottom_line_rect_color[i] or 0
      UIL.DrawSolidRect(rect, color)
    end
  end
  if self.paused_color then
    UIL.DrawSolidRect(self.map_rect, self.paused_color)
  end
  if self.lock_on_rect then
    UIL.DrawSolidRect(self.lock_on_rect, GameColors.L)
  end
  for i, section in ipairs(self.day_sections) do
    if section.separatorOne then
      UIL.DrawSolidRect(section.separatorOne, GameColors.D)
    end
    if section.separatorTwo then
      UIL.DrawSolidRect(section.separatorTwo, GameColors.D)
    end
  end
end
function SatelliteTimeline:OnMouseButtonDown(pt, button)
end
function SatelliteTimeline:ScrollStop()
end
function SatelliteTimeline:OnMouseButtonUp(pt, button)
end
function SatelliteTimeline:OnMousePos(pt)
end
function SatelliteTimeline:OnMouseWheelForward(pos)
end
function SatelliteTimeline:OnMouseWheelBack(pos)
end
local lTimelineAddedEventFXPlay = function()
  PlayFX("TimelineEventAdded", "start")
end
function AddTimelineEvent(id, due, typ, context)
  local existingIdx = table.find(gv_Timeline, "id", id)
  if existingIdx then
    local event = gv_Timeline[existingIdx]
    if event and gv_Timeline.lock_on == event.due then
      gv_Timeline.lock_on = due
    end
    table.remove(gv_Timeline, existingIdx)
  end
  gv_Timeline[#gv_Timeline + 1] = {
    id = id,
    due = due,
    typ = typ,
    context = context
  }
  table.sortby_field(gv_Timeline, "due")
  if not lEphemeralEvents[id] then
    DelayedCall(50, lTimelineAddedEventFXPlay)
  end
  if g_SatTimelineUI and g_SatTimelineUI.window_state == "open" then
    g_SatTimelineUI:RefreshEvents()
  end
end
function RemoveTimelineEvent(id)
  local existingIdx = table.find(gv_Timeline, "id", id)
  if existingIdx then
    local event = gv_Timeline[existingIdx]
    if event then
      if gv_Timeline.lock_on == event.due then
        gv_Timeline.lock_on = false
      end
      if g_SatTimelineUI and g_SatTimelineUI.rollover_icon and g_SatTimelineUI.rollover_icon.event == event then
        g_SatTimelineUI.rollover_icon:OnSetRollover(false)
      end
    end
    table.remove(gv_Timeline, existingIdx)
  end
  if g_SatTimelineUI and g_SatTimelineUI.window_state == "open" then
    g_SatTimelineUI:RefreshEvents()
  end
end
function OnMsg.NewDay()
  if g_SatTimelineUI and g_SatTimelineUI.window_state == "open" then
    g_SatTimelineUI:RefreshEvents()
  end
end
local lUpdateUnitContract = function(merc_id)
  local ud = gv_UnitData[merc_id]
  if ud and ud.HiredUntil then
    AddTimelineEvent("merc-contract-" .. merc_id, ud.HiredUntil, "hire", merc_id)
  end
end
OnMsg.MercHired = lUpdateUnitContract
function OnMsg.UnitAssignedToSquad(_, merc_id)
  lUpdateUnitContract(merc_id)
end
function OnMsg.UnitJoinedPlayerSquad(_, merc_id)
  lUpdateUnitContract(merc_id)
end
function OnMsg.UnitUpdateTimelineContractEvent(merc_id)
  lUpdateUnitContract(merc_id)
end
function OnMsg.MercHireStatusChanged(unitData, old, new)
  local merc_id = unitData.session_id
  if new ~= "Hired" then
    RemoveTimelineEvent("merc-contract-" .. merc_id)
    RemoveTimelineEvent("unit-activity-" .. merc_id)
    RemoveTimelineEvent("sector-activity-idle-" .. merc_id)
  end
end
function GetOperationEventId(ud, operation)
  if not ud then
    return
  end
  local sector = ud:GetSector()
  if not sector then
    return
  end
  local sectorId = sector and sector.Id
  local eventId = false
  local is_personal_event = true
  if operation == "Idle" then
    eventId = "sector-activity-idle-" .. ud.session_id
  elseif operation == "Arriving" then
    eventId = "unit-activity-" .. ud.session_id
  elseif operation == "RAndR" then
    eventId = "sector-activity-randr-" .. ud.session_id
  else
    eventId = "sector-activity-" .. sectorId .. "-" .. operation
    is_personal_event = false
  end
  return eventId, is_personal_event
end
function OnMsg.OperationTimeUpdated(ud, operation)
  local sector = ud:GetSector()
  if not sector then
    return
  end
  local sectorId = sector and sector.Id
  local eventId, is_personal_event = GetOperationEventId(ud, operation)
  RemoveTimelineEvent(eventId)
  local is_operation_started = operation == "Idle" or operation == "Traveling" or operation == "Arriving" or sector and sector.started_operations and sector.started_operations[operation]
  if not is_operation_started then
    return
  end
  local timeLeft = GetOperationTimeLeft(ud, operation, {
    all = not is_personal_event
  })
  if timeLeft <= 0 or operation == "Traveling" then
    return
  end
  local ctx = {
    operationId = operation,
    sectorId = sectorId,
    uId = ud.session_id
  }
  AddTimelineEvent(eventId, Game.CampaignTime + timeLeft, "operation", ctx)
end
local lOperationChangedUpdateEvent = function(ud, previousOperation, _, interrupted)
  local squad = gv_Squads[ud.Squad]
  if not squad then
    return
  end
  local operation = ud.Operation
  if operation == "Arriving" then
    local timeLeft = GetOperationTimeLeft(ud, operation)
    timeLeft = timeLeft and Game.CampaignTime + timeLeft
    if not timeLeft then
      return
    end
    local sessionId = ud.session_id
    local sectorId = squad.CurrentSector
    local id = "unit-activity-" .. sessionId
    local ctx = {
      operationId = operation,
      sectorId = sectorId,
      uId = sessionId
    }
    AddTimelineEvent(id, timeLeft, "operation", ctx)
  else
    local previousOperationId = previousOperation and previousOperation.id
    local sectorId = squad.CurrentSector
    local previousTimelineId = false
    if previousOperationId == "Idle" then
      previousTimelineId = "sector-activity-idle-" .. ud.session_id
      RemoveTimelineEvent(previousTimelineId)
    elseif previousOperationId == "RAndR" then
      previousTimelineId = "sector-activity-randr-" .. ud.session_id
      RemoveTimelineEvent(previousTimelineId)
    elseif previousOperationId ~= "Traveling" and previousOperationId ~= "Arriving" then
      previousTimelineId = "sector-activity-" .. sectorId .. "-" .. previousOperationId
      local mercs = GetOperationProfessionals(sectorId, previousOperationId)
      if next(mercs) then
        local previousTimeLeft = GetOperationTimeLeft(mercs[1], previousOperationId, {prediction = true, all = true})
        if previousTimeLeft <= 0 or interrupted then
          RemoveTimelineEvent(previousTimelineId)
        else
          local ctx = {operationId = previousOperationId, sectorId = sectorId}
          AddTimelineEvent(previousTimelineId, Game.CampaignTime + previousTimeLeft, "operation", ctx)
        end
        RecalcOperationETAs(gv_Sectors[sectorId], previousOperationId)
      end
    end
    local operation = ud.Operation
    local id, is_personal = GetOperationEventId(ud, operation)
    local timeLeft = GetOperationTimeLeft(ud, operation, {
      all = not is_personal
    })
    if timeLeft <= 0 or operation == "Traveling" then
      RemoveTimelineEvent(id)
      return
    end
    timeLeft = timeLeft and Game.CampaignTime + timeLeft
    if timeLeft then
      local ctx = {
        operationId = operation,
        sectorId = sectorId,
        uId = ud.session_id
      }
      AddTimelineEvent(id, timeLeft, "operation", ctx)
    end
  end
end
OnMsg.OperationChanged = lOperationChangedUpdateEvent
function OnMsg.UnitTiredAdded(unit)
  local ud = gv_UnitData[unit.session_id]
  if ud.Operation == "Idle" then
    lOperationChangedUpdateEvent(ud, SectorOperations.Idle)
  end
end
function OnMsg.OperationChanged(ud, prevOperation, operation)
  if not GetAccountStorageOptionValue("PauseSquadMovement") and gv_SatelliteView and operation.id == "Traveling" then
    ResumeCampaignTime("UI")
  end
end
function OnMsg.TempOperationStarted(operationId)
  if not GetAccountStorageOptionValue("PauseOperationStart") and gv_SatelliteView and operationId ~= "Idle" then
    ResumeCampaignTime("UI")
  end
end
function OnMsg.OperationCompleted(operation, mercs, sector)
  if GetAccountStorageOptionValue("PauseActivityDone") then
    PauseCampaignTime("UI")
  end
  PlayFX("OperationCompleted", "start")
end
function OnMsg.ConflictStart(sector_id)
  if GetAccountStorageOptionValue("AutoPauseConflict") then
    PauseCampaignTime("UI")
  end
end
function OnMsg.UnitTiredRemoved(unit)
  if gv_SatelliteView then
    if GetAccountStorageOptionValue("PauseActivityDone") then
      CombatLog("important", T({
        869182514521,
        "<em><DisplayName></em> is no longer tired",
        DisplayName = unit.Nick
      }))
      PauseCampaignTime("UI")
    else
      CombatLog("short", T({
        869182514521,
        "<em><DisplayName></em> is no longer tired",
        DisplayName = unit.Nick
      }))
    end
  end
end
function OnMsg.MercContractExpired()
  if GetAccountStorageOptionValue("PauseActivityDone") then
    PauseCampaignTime("UI")
  end
end
local lSquadTravelEventUpdate = function(squad)
  if squad.Side ~= "player1" and not squad.diamond_briefcase_dynamic then
    return
  end
  local timeTaken = GetTotalRouteTravelTime(squad.CurrentSector, squad.route, squad)
  if timeTaken and timeTaken ~= 0 then
    local waitTime = squad.wait_in_sector
    if waitTime then
      waitTime = waitTime - Game.CampaignTime
      timeTaken = timeTaken + waitTime
    end
    AddTimelineEvent("travelling-" .. squad.UniqueId, Game.CampaignTime + timeTaken, squad.diamond_briefcase and "diamond-travel" or "travel", squad.UniqueId)
    for _, unit in ipairs(squad.units) do
      local unit_data = gv_UnitData[unit]
      if unit_data.Operation == "Traveling" then
        unit_data.OperationInitialETA = unit_data.OperationInitialETA + (waitTime or 0)
      end
    end
  end
end
OnMsg.SquadStartedTravelling = lSquadTravelEventUpdate
OnMsg.SquadWaitInSectorChanged = lSquadTravelEventUpdate
function OnMsg.SquadStoppedTravelling(squad)
  RemoveTimelineEvent("travelling-" .. squad.UniqueId)
end
function OnMsg.SquadFinishedTraveling(squad)
  RemoveTimelineEvent("travelling-" .. squad.UniqueId)
end
function OnMsg.SquadDespawned(squad_id)
  RemoveTimelineEvent("travelling-" .. squad_id)
  RemoveTimelineEvent("squad-attack-" .. squad_id)
end
function OnMsg.SquadTeleported(squad)
  RemoveTimelineEvent("travelling-" .. squad.UniqueId)
end
local lSquadTravelConflictUpdate = function(sector_id)
  local squads = GetSquadsInSector(sector_id)
  for i, s in ipairs(squads) do
    if IsSquadTravelling(s, "skip_tick") then
      lSquadTravelEventUpdate(s)
    else
      RemoveTimelineEvent("travelling-" .. s.UniqueId)
    end
  end
end
OnMsg.ConflictStart = lSquadTravelConflictUpdate
function OnMsg.TravelModeChanged(newMode)
  if not newMode then
    RemoveTimelineEvent("travelling-temp")
  end
end
function OnMsg.NewDay()
  for id, sector in sorted_pairs(gv_Sectors) do
    if sector.Mine and sector.mine_work_days then
      local daysMineWorked = sector.mine_work_days
      local daysStartDepleting = GetSectorDepletionTime(sector)
      if daysStartDepleting - daysMineWorked == 1 then
        local depletionDays = const.Satellite.MineDepletingDays
        local timeLeftDays = daysStartDepleting + depletionDays - sector.mine_work_days
        AddTimelineEvent("mine_deplete_" .. id, Game.CampaignTime + timeLeftDays * const.Scale.day, "mine_deplete", id)
        Msg("MineDepleteStart", id)
        local popupHost = GetDialog("PDADialog")
        popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")
        local text = T({
          407092530644,
          "Mine in <em><SectorName(sector)></em> is running dry and profits have started to decrease. They will continue to fall in the coming days and will eventually drop to 0.",
          sector = sector
        })
        CreateMessageBox(popupHost, T(228475661057, "Attention"), text, T(413525748743, "Ok"))
        NetSyncEvent("SetCampaignSpeed", 0, "UI")
      end
    end
  end
end
function OnMsg.SectorSideChanged(sector_id)
  local sector = gv_Sectors[sector_id]
  if sector.Mine and sector.mine_work_days then
    if sector.Side == "player1" then
      local daysMineWorked = sector.mine_work_days
      local daysStartDepleting = GetSectorDepletionTime(sector)
      if daysMineWorked > daysStartDepleting then
        local depletionDays = const.Satellite.MineDepletingDays
        local timeLeftDays = daysStartDepleting + depletionDays - sector.mine_work_days
        if 0 < timeLeftDays then
          AddTimelineEvent("mine_deplete_" .. sector_id, Game.CampaignTime + timeLeftDays * const.Scale.day, "mine_deplete", sector_id)
        end
      end
    else
      RemoveTimelineEvent("mine_deplete_" .. sector_id)
    end
  end
end
local lGuardpostTravelEventUpdate = function(squad)
  if not squad.guardpost then
    return
  end
  local timeTaken = GetTotalRouteTravelTime(squad.CurrentSector, squad.route, squad)
  if timeTaken and timeTaken ~= 0 then
    local waitTime = squad.wait_in_sector
    if waitTime then
      waitTime = waitTime - Game.CampaignTime
      timeTaken = timeTaken + waitTime
    end
    AddTimelineEvent("travelling-" .. squad.UniqueId, Game.CampaignTime + timeTaken, "guardpost-travel", squad.UniqueId)
    for _, unit in ipairs(squad.units) do
      local unit_data = gv_UnitData[unit]
      if unit_data.Operation == "Traveling" then
        unit_data.OperationInitialETA = unit_data.OperationInitialETA + (waitTime or 0)
      end
    end
  end
end
OnMsg.SquadStartedTravelling = lGuardpostTravelEventUpdate
OnMsg.SquadWaitInSectorChanged = lGuardpostTravelEventUpdate
function SatelliteTimeline:SetBox(x, y, width, height)
  XMap.SetBox(self, x, y, width, height)
  local _, scaledExtension = ScaleXY(self.scale, 0, lInteractionExtendAbove)
  local parent = self
  while parent do
    local b = parent.box
    parent.interaction_box = box(b:minx(), b:miny() - scaledExtension, b:maxx(), b:maxy())
    if parent.Id == "idTimelineContainer" then
      break
    end
    parent = parent.parent
  end
end
DefineClass.XMapWindowTimeline = {
  __parents = {"XMapWindow"}
}
function XMapWindowTimeline:UpdateZoom(prevZoom, newZoom, time)
  if self.ScaleWithMap then
    self:RemoveModifier("reverse-zoom")
    return
  end
  self:AddInterpolation({
    id = "reverse-zoom",
    type = const.intRect,
    interpolate_clip = false,
    OnLayoutComplete = function(modifier, window)
      local bb = window.box
      modifier.originalRect = sizebox(self.PosX, self.PosY, newZoom, self.parent.scale:y())
      modifier.targetRect = sizebox(self.PosX, self.PosY, 1000, 1000)
    end,
    duration = 0
  })
end
DefineClass.TimelineDayNightIcon = {
  __parents = {
    "XMapObject",
    "XMapWindowTimeline"
  },
  image = false,
  ScaleWithMap = false,
  HandleMouse = false,
  HAlign = "center",
  VAlign = "top",
  ZOrder = 0
}
function TimelineDayNightIcon:Init()
  local icon = XTemplateSpawn("XImage", self)
  icon.Clip = false
  icon.UseClipBox = false
  self.image = icon
  self:SetWidth(15)
  self:SetHeight(15)
end
DefineClass.SatelliteTimelineIconBase = {
  __parents = {
    "XContextWindow",
    "XWindowWithRolloverFX"
  },
  event = false,
  otherEvents = false,
  icon = false,
  selFrame = false,
  inner_icon = false,
  ellipsis = false,
  eyeCon = false,
  rolloverData = false,
  Shape = "InRhombus",
  RolloverTemplate = "TimelineRollover",
  RolloverText = Untranslated("placeholder"),
  RolloverAnchor = "center-top",
  RolloverBackground = RGBA(255, 255, 255, 0),
  PressedBackground = RGBA(255, 255, 255, 0),
  RolloverOffset = box(0, 0, 0, 23),
  MultipleEventsText = T(128199945253, "Multiple Events <style HeaderButton>(<count>)</style>")
}
function SatelliteTimelineIconBase:Init()
  local selFrame = XTemplateSpawn("XImage", self)
  selFrame.Clip = false
  selFrame.UseClipBox = false
  selFrame.ImageFit = "scale-down"
  selFrame.Margins = box(-1, -2, 0, 0)
  selFrame.VAlign = "top"
  selFrame.HAlign = "center"
  selFrame.MinHeight = 44
  selFrame.MaxHeight = 44
  selFrame.Visible = false
  selFrame:SetImage("UI/Icons/SateliteView/timeline_selection")
  self.selFrame = selFrame
  local icon = XTemplateSpawn("XImage", self)
  icon.Clip = false
  icon.UseClipBox = false
  icon.ImageFit = "scale-down"
  icon.Margins = box(0, 0, 0, 0)
  icon.VAlign = "top"
  icon.MinHeight = 40
  icon.MaxHeight = 40
  icon.HandleMouse = true
  function icon.OnMouseButtonDown(s, pt, button)
    local event = self.event
    local eventData = SatelliteTimelineEvents[event.typ]
    if not event or not eventData then
      return
    end
    if button == "L" then
      local mapLoc = eventData:GetMapLocation(event.context)
      if mapLoc then
        g_SatelliteUI:CenterScrollOn(mapLoc:x(), mapLoc:y(), 300)
      end
      local sector = gv_Sectors[event.context]
      if sector then
        SectorWindowBlink(sector)
      end
    elseif button == "R" then
      local _, onClickFunc = eventData:OnClick(self.event)
      if onClickFunc then
        onClickFunc()
      end
    end
    return "break"
  end
  icon.MouseCursor = "UI/Cursors/Pda_Hand.tga"
  self.icon = icon
  local iicon = XTemplateSpawn("XImage", icon)
  iicon.Clip = false
  iicon.UseClipBox = false
  iicon.ImageFit = "scale-down"
  iicon.Margins = box(0, 0, 0, 0)
  iicon.VAlign = "center"
  iicon.HAlign = "center"
  self.inner_icon = iicon
  local eyeCon = XTemplateSpawn("XImage", self)
  eyeCon.Clip = false
  eyeCon.UseClipBox = false
  eyeCon.ImageFit = "scale-down"
  eyeCon.Margins = box(0, -38, 0, 0)
  eyeCon.VAlign = "top"
  eyeCon.HAlign = "center"
  eyeCon.MinHeight = 30
  eyeCon.MaxHeight = 30
  eyeCon.DrawOnTop = true
  eyeCon.HandleMouse = true
  eyeCon:SetImage("UI/Hud/enemy_view")
  function eyeCon.SetTransparency(s, val)
    XImage.SetTransparency(s, val)
    local mod = s:FindModifier("_transparency")
    if mod then
      mod.interpolate_clip = false
    end
  end
  eyeCon:SetTransparency(125)
  function eyeCon.OnSetRollover(s, rollover)
    s:SetTransparency(rollover and 0 or 125)
  end
  function eyeCon.OnMouseButtonDown(s, button)
    local event = self.event
    if event and SatelliteTimelineEvents[event.typ] then
      local eventData = SatelliteTimelineEvents[event.typ]
      local mapLoc = eventData:GetMapLocation(event.context)
      if mapLoc then
        g_SatelliteUI:CenterScrollOn(mapLoc:x(), mapLoc:y(), 300)
      end
    end
    return "break"
  end
  eyeCon.MouseCursor = "UI/Cursors/Pda_Hand.tga"
  eyeCon:SetVisible(false)
  self.eyeCon = eyeCon
end
function SatelliteTimelineIconBase:SetAsEvent(event, isCombined)
  self:SetVisible(not not event)
  if not event then
    return
  end
  self.selFrame:SetVisible(false)
  if event == self.event and isCombined == not not self.otherEvents then
    return
  end
  self.event = event
  self.otherEvents = false
  local origin = lGetTimeOrigin()
  local dueTime = event.due
  if self.map then
    self:SetPos(MulDivRound(dueTime - origin, lSegmentWidth, const.Scale.day), 0)
  end
  local innerIcon = false
  local typ = event.typ
  local eventData = SatelliteTimelineEvents[typ]
  if eventData then
    local ctx = event.context
    local icon, innerIcon = eventData:GetIcon(ctx)
    self.icon:SetImage(icon or "UI/Icons/SateliteView/icon_timeline")
    self.inner_icon:SetVisible(innerIcon)
    self.inner_icon:SetImage(innerIcon)
    local textCtx = eventData:GetTextContext(ctx)
    self.RolloverTitle = T({
      eventData.Title,
      textCtx
    })
    self.RolloverHint = eventData.Hint
    local mercs = type(ctx) == "table" and ctx.mercs or eventData:GetAssociatedMercs(ctx)
    if type(mercs) == "string" then
      mercs = {mercs}
    end
    self.rolloverData = {
      {
        typ = typ,
        texts = {
          T({
            eventData:GetDescriptionText(event.context),
            textCtx
          })
        },
        mercs = mercs
      }
    }
  else
    self.icon:SetImage("UI/Icons/SateliteView/icon_timeline")
    self.inner_icon:SetVisible(false)
    self.RolloverTitle = false
    self.RolloverHint = false
    self.rolloverData = {
      {
        typ = "",
        texts = {
          Untranslated("Event type \"" .. typ .. "\" has no data definition")
        }
      }
    }
  end
end
function SatelliteTimelineIconBase:SetCombinedEvents(otherEvents, futureEvent)
  if not table.find(otherEvents, self.event) then
    table.insert(otherEvents, 1, self.event)
  end
  self.otherEvents = otherEvents
  local eventGrouping = {}
  for i, ev in ipairs(otherEvents) do
    local evTyp = ev.typ
    local evData = evTyp and SatelliteTimelineEvents[evTyp]
    if evData then
      local groupEvTyp = evTyp
      if evTyp == "operation" then
        groupEvTyp = groupEvTyp .. ev.context.operationId
      end
      local currentGroup = table.find_value(eventGrouping, "groupTyp", groupEvTyp)
      local ctx = ev.context
      local associatedMercs = type(ctx) == "table" and ctx.mercs or evData:GetAssociatedMercs(ctx)
      local ungroup = false
      if associatedMercs and associatedMercs.leftSide and associatedMercs.rightSide then
        ungroup = true
      end
      local texts = currentGroup and currentGroup.texts
      local mercs = currentGroup and currentGroup.mercs
      if not currentGroup or ungroup then
        texts = {}
        mercs = {}
        currentGroup = {
          typ = evTyp,
          texts = texts,
          mercs = mercs,
          groupTyp = groupEvTyp
        }
        eventGrouping[#eventGrouping + 1] = currentGroup
      end
      local textCtx = evData:GetTextContext(ctx)
      texts[#texts + 1] = "- " .. T({
        evData:GetDescriptionText(ctx),
        textCtx
      })
      if futureEvent then
        local dueTime = ev.due
        local timeLeft = dueTime - Game.CampaignTime
        local text = texts[#texts]
        texts[#texts] = text .. T({
          832020243764,
          " (<timeLeft>)",
          timeLeft = FormatCampaignTime(timeLeft, "all")
        })
      end
      if associatedMercs then
        if type(associatedMercs) == "string" then
          mercs[#mercs + 1] = associatedMercs
        elseif associatedMercs.leftSide and associatedMercs.rightSide then
          currentGroup.mercs = associatedMercs
        else
          table.iappend(mercs, associatedMercs)
        end
      end
    end
  end
  self.rolloverData = eventGrouping
  if futureEvent then
    eventGrouping.futureEvent = true
  end
  self.RolloverHint = false
  self.RolloverText = Untranslated("placeholder")
  local allSameType = #eventGrouping == 1
  local firstEventData = allSameType and SatelliteTimelineEvents[eventGrouping[1].typ]
  if allSameType and firstEventData then
    local eventContext = otherEvents[1].context
    local textCtx = firstEventData:GetTextContext(eventContext)
    self.RolloverTitle = T({
      847931418802,
      "<Title> <style HeaderButton>(<count>)</style>",
      Title = T({
        firstEventData.Title,
        textCtx
      }),
      count = #otherEvents
    })
    local icon, innerIcon = firstEventData:GetIcon(eventContext)
    self.icon:SetImage(icon or "UI/Icons/SateliteView/icon_timeline")
    self.inner_icon:SetVisible(innerIcon)
    self.inner_icon:SetImage(innerIcon)
    return
  end
  self.RolloverTitle = T({
    self.MultipleEventsText,
    count = #otherEvents
  })
  self.icon:SetImage("UI/Icons/SateliteView/icon_timeline")
  self.inner_icon:SetImage("UI/Icons/SateliteView/multiple_events")
  self.inner_icon:SetVisible(true)
end
function SatelliteTimelineIconBase:CreateRolloverWindow(gamepad, context, pos)
  context = {
    event = self.event,
    otherEvents = self.otherEvents,
    rolloverData = self.rolloverData
  }
  return XContextWindow.CreateRolloverWindow(self, gamepad, context, pos)
end
DefineClass.SatelliteTimelineIcon = {
  __parents = {
    "SatelliteTimelineIconBase",
    "XMapWindowTimeline",
    "XMapRolloverable",
    "XMapObject"
  },
  ScaleWithMap = false,
  HAlign = "center",
  VAlign = "top",
  bottom_line_points = false,
  custom_clip = false,
  HandleMouse = true,
  ChildrenHandleMouse = true,
  RolloverOffset = box(0, 0, 0, 26)
}
function SatelliteTimelineIcon:Init()
  self:SetWidth(45)
  self:SetHeight(45)
  self:AddInterpolation({
    id = "PushUp",
    type = const.intRect,
    duration = 0,
    originalRect = sizebox(0, 3, 1000, 1000),
    targetRect = sizebox(0, 0, 1000, 1000),
    interpolate_clip = false
  })
end
function SatelliteTimelineIcon:SetBox(x, y, width, height)
  XMapWindowTimeline.SetBox(self, x, y, width, height)
  local mapInteractionBox = self.map.interaction_box
  self.custom_clip = mapInteractionBox
  local a = point(x + width / 2, y + height - 5)
  local b = point(x + width / 2, y + height)
  self.bottom_line_points = {a, b}
end
function SatelliteTimelineIcon:DrawWindow()
  if not self.custom_clip then
    return
  end
  UIL.PushClipRect(self.custom_clip)
  XMapWindowTimeline.DrawWindow(self, self.custom_clip)
  UIL.PopClipRect()
end
function SatelliteTimelineIcon:OnSetRollover(rollover)
  SatelliteTimelineIconBase.OnSetRollover(self, rollover)
  SetCampaignSpeed(rollover and 0, GetUICampaignPauseReason("Timeline"))
  local event = self.event
  if not event then
    return
  end
  g_SatTimelineUI.preview = rollover and event.due or false
  g_SatTimelineUI.rollover_icon = rollover and self or false
  local timelineUI = self.map
  timelineUI:SyncToTime()
  timelineUI:Invalidate()
  self.selFrame:SetVisible(g_SatTimelineUI.preview == event.due)
  if event.typ == "guardpost" then
    local sector = gv_Sectors[event.context]
    SectorRolloverShowGuardpostRoute(rollover and sector)
  end
end
function SatelliteTimelineIcon:CreateRolloverWindow(gamepad, context, pos)
  context = {
    event = self.event,
    otherEvents = self.otherEvents,
    rolloverData = self.rolloverData
  }
  return XMapRolloverable.CreateRolloverWindow(self, gamepad, context, pos)
end
function SatelliteTimelineIcon:SetupMapSafeArea(wnd)
  function wnd.GetAnchor()
    return self:ResolveRolloverAnchor(wnd.context)
  end
end
function SatelliteTimelineIcon:DrawContent()
  if self.bottom_line_points then
    UIL.DrawLineAntialised(6, self.bottom_line_points[1], self.bottom_line_points[2], GameColors.F)
  end
end
DefineClass.SatelliteTimelineLabel = {
  __parents = {"XLabel"},
  TextStyle = "PDATimelineLabel",
  HAlign = "left",
  VAlign = "bottom",
  Translate = true,
  Clip = false,
  UseClipBox = false,
  Margins = box(2, 0, 0, lBottomLineHeight)
}
DefineClass.SatelliteTimelineLabelContainer = {
  __parents = {
    "XMapWindowTimeline"
  },
  label = false,
  ScaleWithMap = false,
  HAlign = "left",
  VAlign = "top"
}
function SatelliteTimelineLabelContainer:Init()
  self.label = XTemplateSpawn("SatelliteTimelineLabel", self)
end
function SatelliteTimelineLabelContainer:SetText(text)
  self.label:SetText(text)
end
