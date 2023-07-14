function GetSatelliteTravelQuestion(squad)
  if not g_SatelliteUI then
    return
  end
  squad = squad or g_SatelliteUI.selected_squad
  if not squad then
    return
  end
  local popupHost = GetParentOfKind(g_SatelliteUI, "PDAClass")
  popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")
  local questionBox = CreateQuestionBox(popupHost, T(131922143067, "Cancel Travel"), T({
    616508183961,
    "Are you sure you want to command <em><u(squadName)></em> to stop traveling?",
    squadName = squad.Name
  }), T(814633909510, "Confirm"), T(6879, "Cancel"))
  PauseCampaignTime("Popup")
  local resp = questionBox:Wait()
  ResumeCampaignTime("Popup")
  return resp
end
CancelTravelThread = false
function SatelliteCancelTravelSelectedSquad(squad)
  if IsValidThread(CancelTravelThread) and CancelTravelThread ~= CurrentThread() then
    return
  end
  if not CanYield() then
    CancelTravelThread = CreateRealTimeThread(SatelliteCancelTravelSelectedSquad, squad)
    return
  else
    CancelTravelThread = CurrentThread()
  end
  local satDiag = GetSatelliteDialog()
  if not satDiag then
    return
  end
  squad = squad or satDiag.selected_squad
  if not squad or CanCancelSatelliteSquadTravel(squad) ~= "enabled" then
    return
  end
  local resp = GetSatelliteTravelQuestion(squad)
  if resp ~= "ok" then
    return
  end
  if g_SatelliteUI and g_SatelliteUI.travel_mode then
    g_SatelliteUI:ExitTravelMode()
  end
  NetSyncEvent("SquadCancelTravel", squad.UniqueId)
end
function HasWaterTravel(route)
  for _, sector_id in ipairs(route) do
    if gv_Sectors[sector_id].Passability == "Water" then
      return true
    end
  end
  return false
end
function SatelliteCanTravelState(squad, sector_id)
  squad = squad or GetSatelliteContextMenuValidSquad()
  if not squad then
    return "hidden"
  end
  if type(squad) == "number" then
    squad = gv_Squads[squad]
  end
  if not squad.CurrentSector or squad.arrival_squad then
    return "disabled", T(539764240872, "Arriving squad can not travel")
  end
  if squad.CurrentSector == sector_id then
    return "disabled", T(496881909491, "Squad already on this sector.")
  end
  if squad.returning_water_travel then
    return "disabled"
  end
  return "enabled"
end
function SquadTravelCancelled(squad)
  if not squad then
    return false
  end
  if not squad.route or not squad.route[1] then
    return false
  end
  if squad.route[1].returning_land_travel then
    return true
  end
  if squad.returning_water_travel then
    return true
  end
  return false
end
function CanCancelSatelliteSquadTravel(squad)
  squad = squad or GetSatelliteContextMenuValidSquad()
  if not (squad and squad.route) or not squad.route[1] then
    return "hidden"
  end
  if squad.Retreat then
    return "disabled"
  end
  local travelCancelled = SquadTravelCancelled(squad)
  if travelCancelled then
    return "hidden"
  end
  if not IsSquadTravelling(squad, "tick_regardless") then
    return "hidden"
  end
  return "enabled"
end
function CabinetInTravelMode()
  return g_SatelliteUI and not not g_SatelliteUI.travel_mode
end
function GenerateSquadRoute(route, landRoute, toSectorId, squad)
  route = route or {}
  local removedWaypoint = false
  if route.displayedSectionEnd then
    removedWaypoint = table.remove(route, #route)
  end
  local lastWp = route[#route]
  if lastWp and toSectorId == lastWp[#lastWp] then
    route.displayedSectionEnd = false
    return route, landRoute
  end
  local origin = GetSquadFinalDestination(squad.CurrentSector, route)
  local routePf = GenerateRouteDijkstra(origin, toSectorId, route, squad.units, nil, squad.CurrentSector, squad.Side)
  if not routePf then
    routePf = GenerateRouteDijkstra(origin, toSectorId, route, squad.units, "all", squad.CurrentSector, squad.Side)
    if routePf then
      local firstWaterSector = table.findfirst(routePf, function(idx, sectorId)
        return gv_Sectors[sectorId].Passability == "Water"
      end)
      route.no_boat = routePf[firstWaterSector] or toSectorId
    end
  else
    route.no_boat = false
  end
  if not routePf then
    if removedWaypoint then
      route[#route + 1] = removedWaypoint
    end
    return false
  end
  if routePf then
    route[#route + 1] = routePf
    route.displayedSectionEnd = toSectorId
  end
  return route, landRoute
end
DefineClass.SquadRouteDecoration = {
  __parents = {"XMapObject", "XImage"},
  HAlign = "center",
  VAlign = "center",
  HandleMouse = false,
  Image = "UI/Icons/SateliteView/move_background",
  ImageFit = "stretch",
  UseClipBox = false,
  MinWidth = 64,
  MinHeight = 64,
  MaxWidth = 64,
  MaxHeight = 64,
  ZOrder = 1,
  sector = false,
  sector_two = false,
  mode = false,
  waypoint_idx = false
}
function SquadRouteDecoration:Open()
  local icon = XTemplateSpawn("XImage", self)
  icon:SetId("idIcon")
  icon:SetUseClipBox(false)
  icon:SetImage("UI/Icons/SateliteView/move_arrow")
  icon:SetDock("box")
  icon:SetMargins(box(5, 5, 5, 5))
  icon:SetImageFit("stretch")
  XImage.Open(self)
end
function SquadRouteDecoration:OnSetRollover(...)
  return XMapObject.OnSetRollover(self, ...)
end
function SquadRouteDecoration:OnMouseButtonDown(pt, button)
  if button == "L" and terminal.IsKeyPressed(const.vkShift) and self.mode == "waypoint" then
    local travelCtx = g_SatelliteUI.travel_mode
    local route = travelCtx.route
    local squad = g_SatelliteUI.travel_mode.squad
    local startSectorId, endSectorId, waypoints = squad.CurrentSector, route.displayedSectionEnd, {}
    for i, r in ipairs(route) do
      if i ~= self.waypoint_idx then
        waypoints[#waypoints + 1] = r[#r]
      end
    end
    local newRoute = {}
    local previousSector = startSectorId
    for i, w in ipairs(waypoints) do
      newRoute[#newRoute + 1] = GenerateRouteDijkstra(previousSector, w, newRoute, squad.units, nil, squad.CurrentSector, squad.Side)
      previousSector = w
    end
    newRoute.displayedSectionEnd = endSectorId
    g_SatelliteUI.travel_mode.route = newRoute
    g_SatelliteUI:TravelDestinationSelect(endSectorId)
  end
end
function SquadRouteDecoration:EnsureSquadIcon(squadMode)
  local shouldHaveSquadMode = not not squadMode
  local hasSquadMode = not not self.idSquadIcon
  if hasSquadMode ~= shouldHaveSquadMode then
    if shouldHaveSquadMode then
      local squadIcon = XTemplateSpawn("SatelliteIconCombined", self, SubContext(squadMode, {
        side = squadMode.Side,
        squad = squadMode.UniqueId,
        map = true
      }))
      squadIcon:SetUseClipBox(false)
      squadIcon:SetId("idSquadIcon")
      squadIcon:SetZOrder(-1)
      squadIcon:SetHAlign("center")
      squadIcon:SetVAlign("center")
      self.ScaleWithMap = false
      self.UpdateZoom = SquadWindow.UpdateZoom
      squadIcon.idBase:SetImageColor(RGBA(255, 255, 255, 190))
      squadIcon.idUpperIcon:SetImageColor(RGBA(255, 255, 255, 190))
      if self.window_state == "open" then
        squadIcon:Open()
      end
    else
      self.idSquadIcon:Close()
      self.ScaleWithMap = true
      self.UpdateZoom = XMapWindow.UpdateZoom
    end
  end
end
function SquadRouteDecoration:SetRouteEnd(sectorFromId, sectorToId, invalidRoute, squadMode)
  self:EnsureSquadIcon(squadMode)
  self.sector = sectorToId
  self.sector_two = false
  self.mode = "end"
  self.HandleMouse = false
  if invalidRoute then
    self.idIcon:SetImage("UI/Icons/SateliteView/move_disable")
    self.idIcon:SetFlipX(false)
    self.idIcon:SetFlipY(false)
  else
    local curY, curX = sector_unpack(sectorToId)
    local preY, preX
    if IsPoint(sectorFromId) then
      preX, preY = sectorFromId:xy()
    else
      preY, preX = sector_unpack(sectorFromId)
    end
    if curX > preX then
      self.idIcon:SetImage("UI/Icons/SateliteView/move_arrow")
      self.idIcon:SetFlipX(false)
    elseif curX < preX then
      self.idIcon:SetImage("UI/Icons/SateliteView/move_arrow")
      self.idIcon:SetFlipX(true)
    elseif curY > preY then
      self.idIcon:SetImage("UI/Icons/SateliteView/move_arrow_vertical")
      self.idIcon:SetFlipY(false)
    elseif curY < preY then
      self.idIcon:SetImage("UI/Icons/SateliteView/move_arrow_vertical")
      self.idIcon:SetFlipY(true)
    end
  end
  if squadMode then
    self:SetImage("")
    self.idIcon:SetImage("")
    self:SetWidth(9999)
    self:SetHeight(9999)
    self:SetZOrder(1)
  else
    self:SetImage("UI/Icons/SateliteView/move_background")
    self:SetWidth(64)
    self:SetHeight(64)
    self:SetZOrder(2)
  end
  self:InvalidateLayout()
  self:InvalidateMeasure()
  local sector = gv_Sectors[sectorToId]
  self.PosX, self.PosY = sector.XMapPosition:xy()
end
function SquadRouteDecoration:SetCorner(sectorId)
  self:EnsureSquadIcon(false)
  self:SetZOrder(1)
  self.sector = sectorId
  self.sector_two = false
  self.mode = "corner"
  self.HandleMouse = false
  self:SetImage("UI/Icons/SateliteView/move_background")
  self.idIcon:SetImage("")
  self:SetWidth(40)
  self:SetHeight(40)
  self:InvalidateLayout()
  self:InvalidateMeasure()
  local sector = gv_Sectors[sectorId]
  self.PosX, self.PosY = sector.XMapPosition:xy()
end
function SquadRouteDecoration:SetWaypoint(sectorId, waypointIdx)
  self:EnsureSquadIcon(false)
  self:SetZOrder(1)
  self.sector = sectorId
  self.sector_two = false
  self.mode = "waypoint"
  self.waypoint_idx = waypointIdx
  self.HandleMouse = true
  self:SetImage("UI/Icons/SateliteView/move_background")
  self.idIcon:SetImage("UI/Icons/SateliteView/move_dot")
  self:SetWidth(64)
  self:SetHeight(64)
  self:InvalidateLayout()
  self:InvalidateMeasure()
  local sector = gv_Sectors[sectorId]
  self.PosX, self.PosY = sector.XMapPosition:xy()
end
function SquadRouteDecoration:SetPort(position, routeColor, portData)
  self:EnsureSquadIcon(false)
  self:SetZOrder(1)
  local sectorId = portData.port_sector
  local disabled = gv_Sectors[sectorId].PortLocked
  local sectorOne = portData.sector_one
  local sectorTwo = portData.sector_two
  self.sector = sectorOne
  self.sector_two = sectorTwo
  self.mode = "port"
  self.waypoint_idx = false
  self.HandleMouse = true
  self.idIcon:SetImage("UI/Icons/SateliteView/port")
  self.idIcon.Angle = 0
  self.idIcon:SetFlipY(false)
  self:SetWidth(72)
  self:SetHeight(72)
  self:SetImageColor(white)
  self:SetDesaturation(disabled and 255 or 0)
  self:InvalidateLayout()
  self:InvalidateMeasure()
  if routeColor == GameColors.Player then
    self:SetImage("UI/Icons/SateliteView/icon_ally_2")
  elseif routeColor == GameColors.Enemy then
    self:SetImage("UI/Icons/SateliteView/icon_enemy_2")
  elseif routeColor == GameColors.Yellow then
    self:SetImage("UI/Icons/SateliteView/squad_path_2")
  end
  self.PosX, self.PosY = position:xy()
end
function SquadRouteDecoration:SetColor(color)
  self:SetImageColor(color)
  self:SetDesaturation(0)
end
function SquadRouteDecoration:DrawWindow(...)
  if self.measure_update then
    return
  end
  return XMapObject.DrawWindow(self, ...)
end
DefineClass.SquadRouteSegment = {
  __parents = {"XMapObject"},
  HAlign = "left",
  VAlign = "top",
  HandleMouse = false,
  ZOrder = 0,
  sectorFromId = false,
  sectorToId = false,
  direction = false,
  pointOne = false,
  pointTwo = false
}
function SquadRouteSegment:SetDisplayedSection(sectorFromId, sectorToId, squad)
  self.sectorFromId = sectorFromId
  self.sectorToId = sectorToId
  local uimap = self.map
  local curY, curX = sector_unpack(sectorToId)
  local preY, preX = sector_unpack(sectorFromId)
  if curX > preX then
    self.direction = "right"
  elseif curX < preX then
    self.direction = "left"
  elseif curY > preY then
    self.direction = "down"
  elseif curY < preY then
    self.direction = "up"
  else
    self.PosX, self.PosY = 0, 0
    self.direction = "none"
  end
  local _, __, ___, ____, startWidth, startHeight, startX, startY = self:GetInterpParams()
  self.PosX = startX
  self.PosY = startY
  self:SetSize(startWidth, startHeight)
end
function SquadRouteSegment:SetBox(...)
  XMapObject.SetBox(self, ...)
  self:RecalcLines()
end
function SquadRouteSegment:RecalcLines()
  local height = self.MaxHeight
  local width = self.MaxWidth
  local direction = self.direction
  if direction == "right" then
    self.pointOne = point(self.PosX, self.PosY + height / 2)
    self.pointTwo = point(self.PosX + width, self.PosY + height / 2)
  elseif direction == "left" then
    self.pointTwo = point(self.PosX, self.PosY + height / 2)
    self.pointOne = point(self.PosX + width, self.PosY + height / 2)
  elseif direction == "down" then
    self.pointOne = point(self.PosX + width / 2, self.PosY)
    self.pointTwo = point(self.PosX + width / 2, self.PosY + height)
  elseif direction == "up" then
    self.pointTwo = point(self.PosX + width / 2, self.PosY)
    self.pointOne = point(self.PosX + width / 2, self.PosY + height)
  end
end
function SquadRouteSegment:GetInterpParams()
  local interpWidth, interpHeight, interpOriginX, interpOriginY = 0, 0, "left", "top"
  local startWidth, startHeight = 0, 0
  local startX, startY = 0, 0
  local direction = self.direction
  local uimap = self.map
  if direction == "right" then
    local sectorWindow = uimap.sector_to_wnd[self.sectorFromId]
    if IsPoint(self.sectorFromId) then
      startX, startY = self.sectorFromId:xy()
      local endSectorWindow = uimap.sector_to_wnd[self.sectorToId]
      local endSectorX = endSectorWindow:GetSectorCenter()
      startWidth = endSectorX - startX
    else
      startX, startY = sectorWindow:GetSectorCenter()
      startWidth = uimap.sector_size:x()
    end
    startHeight = 10
    interpHeight = startHeight
    interpOriginX = "right"
    startY = startY - startHeight / 2
  elseif direction == "left" then
    local sectorWindow = uimap.sector_to_wnd[self.sectorToId]
    startX, startY = sectorWindow:GetSectorCenter()
    startWidth = uimap.sector_size:x()
    startHeight = 10
    interpHeight = startHeight
    interpOriginX = "left"
    startY = startY - startHeight / 2
  elseif direction == "down" then
    local sectorWindow = uimap.sector_to_wnd[self.sectorFromId]
    startX, startY = sectorWindow:GetSectorCenter()
    startWidth = 10
    startHeight = uimap.sector_size:y()
    interpWidth = startWidth
    interpOriginY = "bottom"
    startX = startX - startWidth / 2
  elseif direction == "up" then
    local sectorWindow = uimap.sector_to_wnd[self.sectorToId]
    startX, startY = sectorWindow:GetSectorCenter()
    startWidth = 10
    startHeight = uimap.sector_size:y()
    interpWidth = startWidth
    interpOriginY = "top"
    startX = startX - startWidth / 2
  end
  return interpWidth, interpHeight, interpOriginX, interpOriginY, startWidth, startHeight, startX, startY
end
function SquadRouteSegment:StartReducing(time, percentOfTotal)
  local interpWidth, interpHeight, interpOriginX, interpOriginY = self:GetInterpParams()
  if percentOfTotal ~= 1000 then
    interpWidth = Lerp(self.MaxWidth, interpWidth, percentOfTotal, 1000)
    interpHeight = Lerp(self.MaxHeight, interpHeight, percentOfTotal, 1000)
  end
  self:SetSize(interpWidth, interpHeight, time, interpOriginX, interpOriginY)
end
function SquadRouteSegment:FastForwardToSquadPos(squadPos, dont_move)
  local sectorTo = gv_Sectors[self.sectorToId]
  local sectorGoingToPos = sectorTo.XMapPosition
  local diffX, diffY = (sectorGoingToPos - squadPos):xy()
  diffX = abs(diffX)
  diffY = abs(diffY)
  local direction = self.direction
  if direction == "right" then
    if not dont_move then
      self.PosX = self.PosX + self.MaxWidth - diffX
    end
    self:SetWidth(diffX)
  elseif direction == "left" then
    self:SetWidth(diffX)
  elseif direction == "down" then
    if not dont_move then
      self.PosY = self.PosY + self.MaxHeight - diffY
    end
    self:SetHeight(diffY)
  elseif direction == "up" then
    self:SetHeight(diffY)
  end
  self:InvalidateMeasure()
  self:InvalidateLayout()
end
function SquadRouteSegment:ResumeReduction(squadPos, time, dont_move)
  self:FastForwardToSquadPos(squadPos, dont_move)
  local interpWidth, interpHeight, interpOriginX, interpOriginY, startWidth, startHeight = self:GetInterpParams()
  local x, y, timeLeft = self:GetContinueInterpolationParams(startWidth, startHeight, interpWidth, interpHeight, time, point(self.MaxWidth, self.MaxHeight))
  if x then
    self:SetSize(x, y, timeLeft, interpOriginX, interpOriginY)
  end
end
function SquadRouteSegment:DrawBackground()
  if not self.pointOne then
    return
  end
  UIL.DrawLineAntialised(12, self.pointOne, self.pointTwo, GameColors.D)
  UIL.DrawLineAntialised(10, self.pointOne, self.pointTwo, self.Background)
end
DefineClass.SquadRouteShortcutSegment = {
  __parents = {
    "SquadRouteSegment"
  },
  shortcut = false,
  progress = 0,
  reversed = false,
  squadWnd = false
}
function SquadRouteShortcutSegment:SetDisplayShortcut(shortcut, squadWnd, reversed, isCurrent)
  local progress = 0
  local squad = squadWnd.context
  if squad and squad.traversing_shortcut_start and isCurrent then
    local travelTime = shortcut:GetTravelTime()
    local arrivalTime = squad.traversing_shortcut_start + travelTime
    local timeLeft = arrivalTime - Game.CampaignTime
    local percent = MulDivRound(timeLeft, 1000, travelTime)
    if not reversed then
      percent = 1000 - percent
    end
    progress = percent
  else
    reversed = false
  end
  self.shortcut = shortcut
  self.progress = progress
  self.reversed = reversed
  self.squadWnd = squadWnd
end
function SquadRouteShortcutSegment:SetShortcutProgress(progress, reversed)
  self.progress = progress
  self.reversed = not not reversed
end
function SquadRouteShortcutSegment:DrawBackground()
  if not self.shortcut then
    return
  end
  local shortcutPreset = self.shortcut
  local path = shortcutPreset:GetPath()
  local resolution = 100
  local increment = 1000 / resolution
  local startVal = self.progress
  local endVal = 1000
  if self.reversed then
    startVal = 0
    endVal = self.progress
  end
  for i = startVal, endVal, increment do
    local pt1 = GetShortcutCurvePointAt(path, i)
    local pt2 = GetShortcutCurvePointAt(path, i + increment)
    UIL.DrawLineAntialised(12, pt1, pt2, GameColors.D)
  end
  for i = startVal, endVal, increment do
    local pt1 = GetShortcutCurvePointAt(path, i)
    local pt2 = GetShortcutCurvePointAt(path, i + increment)
    UIL.DrawLineAntialised(10, pt1, pt2, self.Background)
  end
end
function OnMsg.SquadStartedTravelling(squad)
  if not g_SatelliteUI or not squad then
    return
  end
  local squadWnd = g_SatelliteUI.squad_to_wnd[squad.UniqueId]
  SquadUIUpdateMovement(squadWnd)
end
function OnMsg.SquadStoppedTravelling(squad)
  if not g_SatelliteUI or not squad then
    return
  end
  local squadWnd = g_SatelliteUI.squad_to_wnd[squad.UniqueId]
  if not squadWnd then
    return
  end
  SquadUIUpdateMovement(squadWnd)
end
function NetSyncEvents.RestartMovementThread(squadId)
  local squad = gv_Squads[squadId]
  if not g_SatelliteUI or not squad then
    return
  end
  local squadWnd = g_SatelliteUI.squad_to_wnd[squad.UniqueId]
  SquadUIUpdateMovement(squadWnd)
end
function OnMsg.ConflictEnd()
  if not g_SatelliteUI then
    return
  end
  for _, squad in pairs(gv_Squads) do
    local squadWnd = g_SatelliteUI.squad_to_wnd[squad.UniqueId]
    if squadWnd then
      SquadUIUpdateMovement(squadWnd)
    end
  end
end
function IsSquadWaterTravelling(squad)
  return squad.water_route or squad.traversing_shortcut_water or squad.water_travel
end
local lUpdateSquadBoatIcon = function(squad)
  local squadWnd = g_SatelliteUI and g_SatelliteUI.squad_to_wnd[squad.UniqueId]
  if not squadWnd then
    return
  end
  squadWnd.idWaterTravel:SetVisible(IsSquadWaterTravelling(squad))
end
function OnMsg.SquadSectorChanged(squad)
  lUpdateSquadBoatIcon(squad)
end
function OnMsg.ReachSectorCenter(squadId)
  local squad = gv_Squads[squadId]
  lUpdateSquadBoatIcon(squad)
end
function OnMsg.SquadStartTraversingShortcut(squad)
  lUpdateSquadBoatIcon(squad)
end
function OnMsg.SquadStartedTravelling(squad)
  lUpdateSquadBoatIcon(squad)
end
function OnMsg.ReachSectorCenter(squadId)
  local squad = gv_Squads[squadId]
  if not squad then
    return
  end
  local squadWnd = g_SatelliteUI and g_SatelliteUI.squad_to_wnd[squad.UniqueId]
  if not squadWnd then
    if squad.CurrentSector and not squad.XVisualPos then
      squad.XVisualPos = gv_Sectors[squad.CurrentSector].XMapPosition
    end
    return
  end
  local sectorId = squad.CurrentSector
  local sectorPos = gv_Sectors[sectorId].XMapPosition
  if not IsSquadTravelling(squad) then
    squadWnd:SetPos(sectorPos:x(), sectorPos:y())
    squadWnd:SetAnim(false)
    if squadWnd:GetThread("sat-movement") ~= CurrentThread() then
      squadWnd:DeleteThread("sat-movement")
      rawset(squadWnd, "GetTravelPos", nil)
    end
  end
  squadWnd:DisplayRoute("main", sectorId, squad.route)
end
function OnMsg.SquadWaitInSectorChanged(squad)
  if squad.wait_in_sector then
    return
  end
  local squadWnd = g_SatelliteUI and g_SatelliteUI.squad_to_wnd[squad.UniqueId]
  if not squadWnd then
    return
  end
  SquadUIUpdateMovement(squadWnd)
end
local lMapObjectWaitForGotoPos = function(wnd, pos, time, route_line)
  if time == 0 then
    wnd:SetPos(pos:x(), pos:y())
    return
  end
  local targetTime = Game.CampaignTime + time
  local startTime = Game.CampaignTime
  local startPos = wnd:GetTravelPos()
  local travel = pos - startPos
  local currentThread = CurrentThread()
  local getPosFromTime = function()
    local elapsed = Min(Game.CampaignTime, targetTime) - startTime
    local ret = startPos + MulDivRound(travel, elapsed, time)
    if not IsValidThread(currentThread) then
      wnd:SetPos(ret:xy())
      rawset(wnd, "GetTravelPos", nil)
      return wnd:GetTravelPos()
    end
    return ret
  end
  rawset(wnd, "GetTravelPos", function(self)
    return getPosFromTime()
  end)
  wnd:SetPos(getPosFromTime():xy())
  wnd:SetPos(pos:x(), pos:y(), time)
  while true do
    WaitMsg("CampaignTimeAdvanced")
    if targetTime <= Game.CampaignTime then
      break
    end
  end
  wnd:SetPos(getPosFromTime():xy())
  rawset(wnd, "GetTravelPos", nil)
end
function SquadCantMove(squad)
  if squad.wait_in_sector then
    return true
  end
  if #squad.units == 0 then
    return true
  end
  if IsSquadInConflict(squad) and not squad.Retreat then
    return true
  end
  if HasTiredMember(squad, "Exhausted") and not squad.Retreat then
    return "tired"
  end
  return false
end
function ArrivingSquadTravelThread(squad)
  local sectorId = squad.CurrentSector
  local sY, sX = sector_unpack(sectorId)
  local sectorPos = gv_Sectors[sectorId].XMapPosition
  local leftMostSectorId = sector_pack(sY, 1)
  local leftMostSector = gv_Sectors[leftMostSectorId]
  local leftMostPos = leftMostSector.XMapPosition
  local lmX, lmY = leftMostPos:xy()
  lmX = lmX - 1000
  local destX, destY = sectorPos:xy()
  local totalTime = SectorOperations.Arriving:ProgressCompleteThreshold()
  local timeLeft = GetOperationTimeLeft(gv_UnitData[squad.units[1]], "Arriving")
  local percentPassed = MulDivRound(timeLeft, 1000, totalTime)
  local curPosX = Lerp(destX, lmX, timeLeft, totalTime)
  local curPosY = Lerp(destY, lmY, timeLeft, totalTime)
  local squadWnd = g_SatelliteUI.squad_to_wnd[squad.UniqueId]
  squadWnd:SetPos(curPosX, curPosY)
  squadWnd:SetPos(destX, destY, timeLeft)
  local routeSegment = XTemplateSpawn("SquadRouteSegment", g_SatelliteUI)
  if g_SatelliteUI.window_state == "open" then
    routeSegment:Open()
  end
  local routeEndDecoration = XTemplateSpawn("SquadRouteDecoration", g_SatelliteUI)
  if g_SatelliteUI.window_state == "open" then
    routeEndDecoration:Open()
  end
  routeEndDecoration:SetRouteEnd(point(0, sY), sectorId)
  routeEndDecoration:SetColor(GameColors.Player)
  if not squadWnd.routes_displayed then
    squadWnd.routes_displayed = {}
  end
  squadWnd.routes_displayed.main = {
    routeSegment,
    decorations = {routeEndDecoration}
  }
  routeSegment.direction = "right"
  routeSegment.sectorToId = sectorId
  routeSegment.sectorFromId = point(lmX, lmY)
  local _, __, ___, ____, startWidth, startHeight, startX, startY = routeSegment:GetInterpParams()
  routeSegment.PosX = startX
  routeSegment.PosY = startY
  routeSegment:SetSize(startWidth, startHeight)
  routeSegment:FastForwardToSquadPos(point(curPosX, curPosY))
  routeSegment:StartReducing(timeLeft, 1000)
  routeSegment:SetBackground(GameColors.Player)
end
function SquadUIUpdateMovement(squadWnd)
  local lateLayoutThread = squadWnd:GetThread("late-layout")
  if lateLayoutThread and CurrentThread() ~= lateLayoutThread then
    squadWnd:DeleteThread(lateLayoutThread)
  end
  squadWnd:DeleteThread("sat-movement")
  squadWnd:CreateThread("sat-movement", SquadUIMovementThread, squadWnd)
end
lMinVisualTravelTime = const.Scale.min * 20
if FirstLoad then
  g_WaitingMovementThreads = false
end
function OrderedWait_CampaignTimeAdvanced(squadId)
  if not g_WaitingMovementThreads then
    g_WaitingMovementThreads = {}
  end
  local handle = {}
  local thread = CurrentThread()
  g_WaitingMovementThreads[#g_WaitingMovementThreads + 1] = {
    thread = thread,
    sId = squadId,
    handle = handle
  }
  WaitMsg(handle)
end
function OnMsg.CampaignTimeAdvanced()
  if not g_WaitingMovementThreads then
    return
  end
  table.sortby_field(g_WaitingMovementThreads, "sId")
  for i, entry in ipairs(g_WaitingMovementThreads) do
    local handle = entry.handle
    local thread = entry.thread
    if IsValidThread(thread) then
      Msg(handle)
    end
  end
  g_WaitingMovementThreads = false
end
function SquadUIMovementThread(squadWnd)
  local squad = squadWnd.context
  local playerSquad = squad.Side == "player1" or squad.Side == "player2"
  local currentSectorId = squad.CurrentSector
  if not currentSectorId then
    squadWnd:SetVisible(false)
    return
  end
  local currentSector = gv_Sectors[currentSectorId]
  local visualPos = squadWnd:GetTravelPos()
  squadWnd.desktop:RequestLayout()
  Sleep(0)
  if squad.arrival_squad then
    ArrivingSquadTravelThread(squad)
    return
  end
  squadWnd:DisplayRoute("main", currentSectorId, squad.route)
  if not squad.route or #squad.route == 0 then
    return
  end
  squadWnd.desktop:RequestLayout()
  Sleep(0)
  while IsCampaignPaused() do
    WaitMsg("CampaignSpeedChanged", 100)
  end
  local cantMove = SquadCantMove(squad)
  if cantMove == "tired" and LocalPlayerHasAuthorityOverSquad(squad) then
    CreateRealTimeThread(function()
      local shouldTravel = AskForExhaustedUnits(squad)
      if shouldTravel then
        NetSyncEvent("RestartMovementThread", squad.UniqueId)
      else
        NetSyncEvent("SquadCancelTravel", squad.UniqueId)
      end
    end)
  end
  if cantMove then
    return
  end
  local routeLocalCopy = {}
  for _, route in ipairs(squad.route) do
    routeLocalCopy[#routeLocalCopy + 1] = table.copy(route)
  end
  local firstWaypoint = routeLocalCopy[1]
  local firstIsntShortcut = not firstWaypoint.shortcuts or not firstWaypoint.shortcuts[1]
  local routeDisplay = squadWnd.routes_displayed.main
  local firstSegment = routeDisplay[1]
  if firstSegment and firstIsntShortcut then
    firstSegment:FastForwardToSquadPos(visualPos)
  end
  OrderedWait_CampaignTimeAdvanced(squad.UniqueId)
  NetUpdateHash("SetSquadTravellingActivity", squad.UniqueId)
  SetSquadTravellingActivity(squad)
  if routeDisplay.extra_visual_segment then
    local currSectorPos = currentSector.XMapPosition
    local previousSectorId = GetSquadPrevSector(visualPos, currentSectorId, currSectorPos)
    local time = GetSectorTravelTime(previousSectorId, currentSectorId, routeLocalCopy, squad.units, nil, nil, squad.Side)
    local time_orig = time
    time = Max(time, lMinVisualTravelTime)
    local prevSecX, prevSecY = gv_Sectors[previousSectorId].XMapPosition:xy()
    local x, y, timeLeft = squadWnd:GetContinueInterpolationParams(prevSecX, prevSecY, currSectorPos:x(), currSectorPos:y(), time, visualPos)
    timeLeft = timeLeft and DivCeil(timeLeft, const.Scale.min) * const.Scale.min
    NetUpdateHash("SquadTravelResumeRoute", squad.UniqueId, visualPos, currSectorPos, time_orig, time, timeLeft, Game.CampaignTime)
    if routeDisplay and 0 < #routeDisplay then
      local firstSegment = routeDisplay[1]
      firstSegment:ResumeReduction(visualPos, time)
    end
    if timeLeft then
      lMapObjectWaitForGotoPos(squadWnd, point(x, y), timeLeft)
    else
      lMapObjectWaitForGotoPos(squadWnd, currSectorPos, 0)
    end
    local dontUpdateRoute = not routeDisplay.extra_in_route
    NetUpdateHash("SatelliteReachSectorCenter", Game.CampaignTime, squad.UniqueId)
    SatelliteReachSectorCenter(squad.UniqueId, currentSectorId, previousSectorId, dontUpdateRoute)
    if not dontUpdateRoute then
      routeLocalCopy = {}
      for _, route in ipairs(squad.route) do
        routeLocalCopy[#routeLocalCopy + 1] = table.copy(route)
      end
    end
    if SquadCantMove(squad) then
      return
    end
  end
  local pricePerSector = 0
  for i, section in ipairs(routeLocalCopy) do
    for j, sector in ipairs(section) do
      local prevSectorId = squad.CurrentSector
      local prevSector = gv_Sectors[prevSectorId]
      local prevSectorPos = prevSector.XMapPosition
      local nextSectorId = sector
      local nextSector = gv_Sectors[nextSectorId]
      local nextSectorPos = nextSector.XMapPosition
      if section.shortcuts and section.shortcuts[j] then
        local shortcut, reversedShortcut = GetShortcutByStartEnd(prevSectorId, nextSectorId)
        squad.traversing_shortcut_water = shortcut.water_shortcut
        routeDisplay = squadWnd.routes_displayed.main
        local shortcutSegment = routeDisplay.shortcuts[1]
        local travelTime = shortcut:GetTravelTime()
        local timeResolution = const.Satellite.RiverTravelTime / 4
        local waterPrevSector = reversedShortcut and shortcut.shortcut_direction_entrance_sector or shortcut.shortcut_direction_exit_sector
        if not squad.traversing_shortcut_start then
          NetUpdateHash("SatelliteStartShortcutMovement", Game.CampaignTime, squad.UniqueId)
          SatelliteStartShortcutMovement(squad.UniqueId, Game.CampaignTime, squad.CurrentSector)
        else
          local arrivalTime = squad.traversing_shortcut_start + travelTime
          local timeLeft = arrivalTime - Game.CampaignTime
          if timeLeft < 0 then
            print("shortcut resume messed up")
          else
            local percent = MulDivRound(timeLeft, 1000, travelTime)
            if not reversedShortcut then
              percent = 1000 - percent
            end
            shortcutSegment:SetShortcutProgress(percent, reversedShortcut)
          end
        end
        local arrivalTime = squad.traversing_shortcut_start + travelTime
        local path = shortcut:GetPath()
        while arrivalTime > Game.CampaignTime do
          local timeLeft = arrivalTime - Game.CampaignTime
          local interpolateTime = timeResolution
          local leftOverTime = timeLeft % interpolateTime
          if leftOverTime ~= 0 then
            interpolateTime = leftOverTime
          end
          local percent = MulDivRound(timeLeft, 1000, travelTime)
          if not reversedShortcut then
            percent = 1000 - percent
          end
          local pt1 = GetShortcutCurvePointAt(path, percent)
          local percentNext = MulDivRound(timeLeft - interpolateTime, 1000, travelTime)
          if not reversedShortcut then
            percentNext = 1000 - percentNext
          end
          local pt2 = GetShortcutCurvePointAt(path, percentNext)
          squadWnd:SetPos(pt1:x(), pt1:y(), false)
          squad.XVisualPos = pt1
          lMapObjectWaitForGotoPos(squadWnd, pt2, interpolateTime)
          shortcutSegment:SetShortcutProgress(percentNext, reversedShortcut)
        end
        if Game.CampaignTime - arrivalTime ~= 0 then
          print("shortcut ended early/late", Game.CampaignTime - arrivalTime)
        end
        NetUpdateHash("SatelliteReachSector", Game.CampaignTime, squad.UniqueId)
        SetSatelliteSquadCurrentSector(squad, nextSectorId, "update-pos", false, waterPrevSector)
      elseif 0 < (prevSectorPos - nextSectorPos):Len() / 2 then
        local _, time1, time2 = GetSectorTravelTime(prevSectorId, nextSectorId, squad.route, squad.units, nil, nil, squad.Side)
        time1 = Max(time1, lMinVisualTravelTime)
        time2 = Max(time2, lMinVisualTravelTime)
        local middle = (prevSectorPos + nextSectorPos) / 2
        local originalTime1 = time1
        local squadVisPos = squadWnd:GetTravelPos()
        local prevSecX, prevSecY = gv_Sectors[prevSectorId].XMapPosition:xy()
        if squadVisPos:x() ~= prevSecX or squadVisPos:y() ~= prevSecY then
          local midX, midY = middle:xy()
          local x, y, timeLeft = squadWnd:GetContinueInterpolationParams(prevSecX, prevSecY, midX, midY, time1, squadVisPos)
          timeLeft = timeLeft and DivCeil(timeLeft, const.Scale.min) * const.Scale.min
          time1 = timeLeft or lMinVisualTravelTime
        end
        routeDisplay = squadWnd.routes_displayed.main
        firstSegment = table.find_value(routeDisplay, "sectorFromId", prevSectorId)
        if firstSegment then
          firstSegment:StartReducing(originalTime1, 500)
        end
        lMapObjectWaitForGotoPos(squadWnd, middle, time1)
        local routeDecor = squadWnd.routes_displayed.main
        routeDecor = routeDecor and routeDecor.decorations
        local compact = false
        for i, dec in ipairs(routeDecor) do
          if dec.mode == "port" then
            local here = dec.sector == nextSectorId and dec.sector_two == prevSectorId or dec.sector_two == nextSectorId and dec.sector == prevSectorId
            if here then
              dec:Close()
              routeDecor[i] = nil
              compact = true
            end
          end
        end
        if compact then
          table.compact(routeDecor)
        end
        if squad.returning_water_travel then
          squad.water_travel_cost = nil
        else
          if prevSector.Passability == "Land and Water" and prevSector.Port and not prevSector.PortLocked and nextSector.Passability == "Water" then
            squad.water_travel_cost = prevSector:GetTravelPrice(squad)
          end
          if nextSector.Passability == "Water" then
            if squad.water_travel_cost and playerSquad then
              AddMoney(-squad.water_travel_cost, "expense")
            end
          else
            squad.water_travel_cost = nil
          end
        end
        NetUpdateHash("SatelliteReachSector", Game.CampaignTime, squad.UniqueId)
        SetSatelliteSquadCurrentSector(squad, nextSectorId)
        if squadWnd.window_state == "destroying" then
          return
        end
        routeDisplay = squadWnd.routes_displayed.main
        firstSegment = table.find_value(routeDisplay, "sectorFromId", prevSectorId)
        if firstSegment then
          firstSegment:StartReducing(time2, 1000)
        end
        lMapObjectWaitForGotoPos(squadWnd, nextSectorPos, time2)
      else
        while IsCampaignPaused() do
          WaitMsg("CampaignSpeedChanged", 100)
        end
      end
      NetUpdateHash("SatelliteReachSectorCenter", Game.CampaignTime, squad.UniqueId)
      SatelliteReachSectorCenter(squad.UniqueId, nextSectorId, prevSectorId)
      while IsCampaignPaused() do
        WaitMsg("CampaignSpeedChanged", 100)
      end
      ObjModified(nextSector)
      ObjModified(prevSector)
      if SquadCantMove(squad) then
        return
      end
      if not squad.route then
        if squadWnd.window_state ~= "destroying" then
          squadWnd:DisplayRoute("main")
        end
        return
      end
    end
  end
end
function GetSquadPrevSector(vis_pos, next_sector_id, next_sector_pos)
  local dir_vector = vis_pos - next_sector_pos
  local x, y = dir_vector:xy()
  local abs_x = abs(x)
  local abs_y = abs(y)
  local dir
  if 0 <= x and x >= abs_y then
    dir = "East"
  elseif x < 0 and abs_y <= -x then
    dir = "West"
  elseif 0 <= y and y >= abs_x then
    dir = "South"
  elseif y < 0 and abs_x <= -y then
    dir = "North"
  end
  return GetNeighborSector(next_sector_id, dir)
end
function GetRouteInfoBreakdown(squad, route)
  local breakdown = {}
  local forbidden, errs, invalidBecauseOf = IsRouteForbidden(route, squad)
  breakdown.valid = not forbidden
  local currentSector = squad.CurrentSector
  local prevSectorId = currentSector
  local startSector = gv_Sectors[prevSectorId]
  local startTerrainType = startSector and startSector.TerrainType
  if startSector and startSector.Passability == "Water" then
    startTerrainType = "Water"
  end
  local nextSectorId = route and route[1] and route[1][1]
  local nextSector = gv_Sectors[nextSectorId]
  if nextSector and nextSector.Passability == "Water" then
    startTerrainType = "Water"
  end
  local prevSectorTerrainType = startTerrainType
  local currentSection = {start = prevSectorId, terrain = startTerrainType}
  local currentSectionRoute = {}
  local waterTravelCost, waterTravelTiles = 0, 0
  for w = 1, #route do
    local lastWaypoint = w == #route and 1 or 0
    local waypoint = route[w]
    for i = 1, #waypoint + lastWaypoint do
      local sId = waypoint[i]
      local sector = gv_Sectors[sId]
      local terrainType = sector and sector.TerrainType
      if sector and sector.Passability == "Water" then
        terrainType = "Water"
      end
      if waypoint.shortcuts and waypoint.shortcuts[i] then
        terrainType = "Shortcut"
      end
      if prevSectorTerrainType == "Water" then
        prevSectorTerrainType = terrainType
        terrainType = "Water"
      else
        prevSectorTerrainType = terrainType
      end
      if prevSectorId == invalidBecauseOf then
        currentSection.invalid = true
      end
      if not sector or currentSection.terrain and currentSection.terrain ~= terrainType then
        currentSection.dest = prevSectorId
        local terrainSectionRoute = {}
        if #currentSectionRoute == 0 then
          terrainSectionRoute = {
            {sId}
          }
        else
          terrainSectionRoute = {currentSectionRoute}
        end
        local timeTaken, travelBreakdown = GetSameTerrainTypeTravelWithBreakdown(currentSection.start, terrainSectionRoute, squad)
        currentSection.travelTime = (currentSection.travelTime or 0) + timeTaken
        if 0 < waterTravelCost then
          if travelBreakdown then
            travelBreakdown[#travelBreakdown + 1] = {
              Text = T(423059607313, "Cost"),
              Value = waterTravelTiles * waterTravelCost,
              Category = "sector",
              ValueType = "money"
            }
          end
          waterTravelCost = 0
        end
        currentSection.travelTimeBreakdown = travelBreakdown
        breakdown[#breakdown + 1] = currentSection
        currentSection = {
          start = prevSectorId,
          terrain = terrainType,
          travelTime = 0
        }
        currentSectionRoute = {sId}
      else
        currentSectionRoute[#currentSectionRoute + 1] = sId
      end
      if sector then
        local prevSector = gv_Sectors[prevSectorId]
        if prevSector.Passability == "Land and Water" and prevSector.Port and not prevSector.PortLocked and sector.Passability == "Water" then
          waterTravelCost = prevSector:GetTravelPrice(squad)
          waterTravelTiles = 0
        end
        if sector.Passability == "Water" and 0 < waterTravelCost then
          waterTravelTiles = waterTravelTiles + 1
        end
      end
      prevSectorId = sId
    end
  end
  local total = {}
  local destLastWp = route[#route]
  local dest = destLastWp[#destLastWp]
  local timeTaken, travelBreakdown = GetSameTerrainTypeTravelWithBreakdown(squad.CurrentSector, route, squad)
  total.travelTime = timeTaken
  total.travelTimeBreakdown = travelBreakdown
  breakdown.total = total
  breakdown.errors = errs
  return breakdown
end
function GetHalfwaySectorPoint(idOne, idTwo)
  local s1 = gv_Sectors[idOne].XMapPosition
  local s2 = gv_Sectors[idTwo].XMapPosition
  local dist = s1:Dist(s2)
  if dist == 0 then
    return point20
  end
  local dir = s2 - s1
  return s1 + SetLen(dir, dist / 2)
end
function GetShortcutCurvePointAt(path, percentOfPath)
  local precision = 1000
  local pathLength = #path - 1
  local indexBetweenPoints = 1 + percentOfPath * pathLength / precision
  indexBetweenPoints = Min(indexBetweenPoints, pathLength)
  indexBetweenPoints = Max(indexBetweenPoints, 1)
  local p1 = path[indexBetweenPoints]
  local p2 = path[indexBetweenPoints + 1]
  local placeBetweenPoints
  if percentOfPath >= precision then
    placeBetweenPoints = precision
  else
    local percentBetween = percentOfPath * pathLength
    placeBetweenPoints = percentBetween % precision
  end
  local prevPoint = path[indexBetweenPoints - 1] or path[indexBetweenPoints]
  local nextPoint = path[indexBetweenPoints + 2] or path[indexBetweenPoints + 1]
  return CatmullRomSpline(prevPoint, p1, p2, nextPoint, placeBetweenPoints, precision), indexBetweenPoints
end
function GetShortcutByStartEnd(startSectorId, endSectorId)
  for i, shortcut in ipairs(Presets.SatelliteShortcutPreset.Default) do
    local rightWay = shortcut.start_sector == startSectorId and shortcut.end_sector == endSectorId
    local reverseWay = not shortcut.one_way and shortcut.start_sector == endSectorId and shortcut.end_sector == startSectorId
    if rightWay or reverseWay then
      return shortcut, reverseWay
    end
  end
  return false
end
function GetShortcutsAtSector(sectorId, force_twoway)
  local shortcuts = false
  for i, shortcut in ipairs(Presets.SatelliteShortcutPreset.Default) do
    local here = shortcut.start_sector == sectorId or shortcut.end_sector == sectorId and (not shortcut.one_way or force_twoway)
    if here then
      shortcuts = shortcuts or {}
      shortcuts[#shortcuts + 1] = shortcut
    end
  end
  return shortcuts
end
function IsTraversingShortcut(squad, regardlessSatelliteTickPassed)
  if regardlessSatelliteTickPassed then
    local route = squad.route
    return route and route[1] and route[1].shortcuts and route[1].shortcuts[1]
  end
  return not not squad.traversing_shortcut_start
end
function IsRiverSector(sectorId, force_two_way)
  return not not GetShortcutsAtSector(sectorId, force_two_way)
end
DefineConstInt("Satellite", "RiverTravelTime", 56, "min", "How many minutes it takes to travel one sector of river")
