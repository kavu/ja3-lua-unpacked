local lUpdateSquadCurrentSector = function(squad, old_sector, new_sector, from_map)
  if old_sector == new_sector then
    return
  end
  local dir = gv_DeploymentDir
  gv_DeploymentDir = false
  if not dir and old_sector then
    if IsSectorUnderground(old_sector) then
      dir = "Underground"
    else
      local old_y, old_x = sector_unpack(old_sector)
      local new_y, new_x = sector_unpack(new_sector)
      if old_x < new_x then
        dir = "West"
      elseif old_x > new_x then
        dir = "East"
      elseif old_y < new_y then
        dir = "North"
      elseif old_y > new_y then
        dir = "South"
      end
    end
  end
  if not dir and new_sector and IsSectorUnderground(new_sector) then
    dir = "Underground"
  end
  for _, session_id in ipairs(squad.units) do
    local merc = gv_UnitData[session_id]
    merc.arrival_dir = dir or "North"
    merc.already_spawned_on_map = false
    merc.retreat_to_sector = false
  end
  if #GetSectorSquadsFromSide(gv_CurrentSectorId, "player1") == 0 then
    ForceReloadSectorMap = true
    ObjModified(Game)
    Msg("AllSquadsLeftSector")
  end
end
function GetSectorSquadsToSpawnInTactical(sector_id)
  return GetSquadsInSector(sector_id, "exclude_travelling", "include_militia", "exclude_arriving")
end
function LocalCheckUnitsMapPresence()
  if not gv_Squads then
    return
  end
  local update_map, respawn_squads
  for i, squad in ipairs(g_SquadsArray) do
    local squadSector = squad.CurrentSector
    local squadPresent = squadSector == gv_CurrentSectorId and not IsSquadTravelling(squad)
    for _, session_id in ipairs(squad.units) do
      local unit = g_Units[session_id]
      local ud = gv_UnitData[session_id]
      if not squadPresent and unit then
        DoneObject(unit)
        update_map = true
      elseif squadPresent and (not unit or not ud.already_spawned_on_map) then
        respawn_squads = true
        update_map = true
      end
    end
  end
  if respawn_squads then
    local conflict = GetSectorConflict()
    local player, enemy = GetSectorSquadsToSpawnInTactical(gv_CurrentSectorId)
    local squads = player
    table.iappend(squads, enemy)
    SpawnSquads(table.map(squads, "UniqueId"), conflict and conflict.spawn_mode or "explore")
  end
  for i = #g_Units, 1, -1 do
    local unit = g_Units[i]
    if not (not unit:IsMerc() or unit.Squad) or not unit.session_id then
      DoneObject(unit)
      update_map = true
    end
  end
  if update_map then
    SetupTeamsFromMap()
    EnsureCurrentSquad()
  end
  ForceUpdateCommonUnitControlUI()
end
function NetSyncEvents.CheckUnitsMapPresence()
  LocalCheckUnitsMapPresence()
end
function NetSyncEvents.CheatSatelliteTeleportSquad(squad_id, sector_id)
  local squad = gv_Squads[squad_id]
  if sector_id == squad.CurrentSector then
    return
  end
  local sector = gv_Sectors[sector_id]
  local squadWnd = g_SatelliteUI.squad_to_wnd[squad_id]
  if not squadWnd then
    return
  end
  local prev_sector_id = GetSquadPrevSector(squadWnd:GetVisualPos(), sector_id, sector.XMapPosition)
  local curr_sector = gv_Sectors[squad.CurrentSector]
  if curr_sector.conflict then
    ResolveConflict(curr_sector)
  end
  SectorOperation_CancelByGame(squad.units, false, true)
  if IsTravelBlocked(sector_id, prev_sector_id) then
    ForEachSectorCardinal(sector_id, function(s)
      if not IsTravelBlocked(sector_id, s) then
        prev_sector_id = s
        return "break"
      end
    end)
  end
  SetSatelliteSquadCurrentSector(squad, sector_id, nil, "teleport", prev_sector_id)
  if not gv_Sectors[sector_id].reveal_allowed then
    print("You teleported to an unrevealed sector. Use the 'Reveal All Sectors' cheat or you won't see your squad.")
  end
  squad.Retreat = false
  squad:CancelTravel()
  ObjModified("gv_SatelliteView")
  ObjModified(gv_Squads)
end
function SquadReachedDest(squad)
  return not squad.route or #squad.route == 1 and squad.route[1][1] == squad.CurrentSector
end
function NetSyncEvents.SatelliteStartShortcutMovement(squad_id, startTime, startSector)
  SatelliteStartShortcutMovement(squad_id, startTime, startSector)
end
function SatelliteStartShortcutMovement(squad_id, startTime, startSector)
  local squad = gv_Squads[squad_id]
  squad.traversing_shortcut_start = startTime
  squad.traversing_shortcut_start_sId = startSector
  RecalcRevealedSectors()
  Msg("SquadStartTraversingShortcut", squad)
end
function NetSyncEvents.SatelliteReachSector(squad_id, sector_id, ...)
  local squad = gv_Squads[squad_id]
  SetSatelliteSquadCurrentSector(squad, sector_id, ...)
end
function SetSatelliteSquadSide(unique_id, side)
  local squad = unique_id and gv_Squads[unique_id]
  if squad then
    squad.Side = side
    RemoveSquadsFromLists(squad)
    AddSquadToLists(squad)
  end
  ObjModified(squad)
end
function IsWaterSector(sector)
  if type(sector) == "string" then
    sector = gv_Sectors[sector]
  end
  return sector and sector.Passability == "Water"
end
function SetSatelliteSquadCurrentSector(squad, sector_id, update_pos, teleport, prev_sector_id)
  RemoveSquadFromSectorList(squad, squad.CurrentSector)
  AddSquadToSectorList(squad, sector_id)
  prev_sector_id = prev_sector_id or squad.CurrentSector
  squad.arrive_in_sector = false
  squad.PreviousSector = prev_sector_id
  squad.CurrentSector = sector_id
  local prev_sector = gv_Sectors[prev_sector_id]
  local sector = gv_Sectors[sector_id]
  if teleport then
    squad.returning_water_travel = false
    squad.water_route = false
    SetSquadWaterTravel(squad, false)
    squad.route = false
    squad.uninterruptable_travel = false
  else
    local previousSectorIsWater = IsWaterSector(prev_sector)
    local currentSectorIsWater = IsWaterSector(sector)
    if not previousSectorIsWater and prev_sector_id then
      squad.PreviousLandSector = prev_sector_id
    end
    if not squad.returning_water_travel then
      if not previousSectorIsWater and currentSectorIsWater then
        squad.water_route = {prev_sector_id}
      end
      if previousSectorIsWater then
        if not currentSectorIsWater then
          squad.water_route = false
        elseif squad.water_route then
          table.insert(squad.water_route, prev_sector_id)
        end
      end
    end
    if not currentSectorIsWater and (not prev_sector or previousSectorIsWater) then
      squad.returning_water_travel = false
      squad.water_route = false
    end
  end
  Msg("SquadSectorChanged", squad)
  lUpdateSquadCurrentSector(squad, prev_sector_id, sector_id)
  if update_pos then
    squad.XVisualPos = sector.XMapPosition
  end
  local wasShortcut = false
  if squad.traversing_shortcut_start then
    wasShortcut = true
  end
  if teleport then
    squad.traversing_shortcut_start_sId = false
    squad.traversing_shortcut_start = false
    SatelliteReachSectorCenter(squad.UniqueId, sector_id, prev_sector_id)
    Msg("SquadTeleported", squad)
  else
    CheckAndEnterConflict(sector, squad, wasShortcut and squad.CurrentSector or prev_sector_id)
  end
  if wasShortcut then
    squad.traversing_shortcut_start = false
    squad.traversing_shortcut_start_sId = false
    squad.traversing_shortcut_water = false
  end
  if not g_SatelliteUI then
    return
  end
  if squad.Side ~= "player1" or gv_Sectors[sector_id .. "_Underground"] or gv_Sectors[prev_sector_id .. "_Underground"] then
    g_SatelliteUI:UpdateSectorVisuals(prev_sector_id)
    g_SatelliteUI:UpdateSectorVisuals(sector_id)
  end
  if wasShortcut then
    RecalcRevealedSectors()
    local squad_id = squad.UniqueId
    local squadWnd = g_SatelliteUI.squad_to_wnd[squad_id]
    if squadWnd then
      local endSector = gv_Sectors[sector_id]
      local endSectorPos = endSector.XMapPosition
      squadWnd:SetPos(endSectorPos:x(), endSectorPos:y())
    end
  end
  ObjModified(gv_Squads)
  ObjModified(squad)
  ObjModified(gv_Sectors[sector_id])
end
function SatelliteReachSectorCenter(squad_id, sector_id, prev_sector_id, dontUpdateRoute, dontCheckConflict, reason)
  NetUpdateHash("SatelliteReachSectorCenter", squad_id, sector_id, prev_sector_id, dontUpdateRoute, dontCheckConflict)
  local squad = gv_Squads[squad_id]
  local route = squad.route
  local player_squad = squad.Side == "player1" or squad.Side == "player2"
  local vrUnit, returningLandTravel = false, false
  if route and route[1] and not dontUpdateRoute then
    local thisSection = route[1]
    returningLandTravel = thisSection.returning_land_travel
    table.remove(thisSection, 1)
    if thisSection.shortcuts then
      local shortcutsCorrected = {}
      for i, _ in pairs(thisSection.shortcuts) do
        local newIndex = i - 1
        if 1 <= newIndex then
          shortcutsCorrected[i - 1] = true
        end
      end
      thisSection.shortcuts = shortcutsCorrected
    end
    if not gv_Squads[squad_id] then
      return
    end
    if route[1] and #route[1] == 0 then
      table.remove(route, 1)
      local reached = #route == 0
      if reached and player_squad then
        squad.uninterruptable_travel = false
        squad.Retreat = false
        CombatLog("important", T({
          801526980739,
          "<SquadName> has reached <sector>",
          SquadName = Untranslated(squad.Name),
          sector = Untranslated(squad.CurrentSector)
        }))
        ObjModified("gv_SatelliteView")
        Msg("PlayerSquadReachedDestination", squad_id)
        if GetAccountStorageOptionValue("AutoPauseDestReached") then
          _SetCampaignSpeed(0, "UI")
        end
      end
      if reached then
        squad.route = false
        Msg("SquadFinishedTraveling", squad)
        if route.despawn_at_last_sector then
          squad.despawn_on_next_tick = true
        end
      end
    end
  elseif route and route.center_old_movement then
    local visualPos = GetSquadVisualPos(squad)
    route.center_old_movement = false
  end
  local nextSector = route and route[1]
  nextSector = nextSector and nextSector[1][1]
  local nextSectorIsWater = nextSector and gv_Sectors[nextSector].Passability == "Water"
  local currentSectorIsWater = gv_Sectors[sector_id].Passability == "Water"
  SetSquadWaterTravel(squad, nextSectorIsWater or currentSectorIsWater)
  if player_squad then
    ExecuteSectorEvents("SE_OnSquadReachSectorCenter", sector_id)
  end
  NetUpdateHash("SatelliteReachSectorCenter_FireMessage", squad_id, sector_id)
  Msg("ReachSectorCenter", squad_id, sector_id, prev_sector_id)
  if player_squad then
    if squad.joining_squad then
      if UpdateJoiningSquad(squad) then
        Msg("SquadStoppedTravelling", squad)
        return
      end
    else
      for i = #g_PlayerSquads, 1, -1 do
        local s = g_PlayerSquads[i]
        if s.joining_squad == squad.UniqueId and s.CurrentSector == squad.CurrentSector then
          UpdateJoiningSquad(s)
        end
      end
    end
  end
  if dontCheckConflict then
    return
  end
  local sector = gv_Sectors[sector_id]
  if IsEnemySquad(squad_id) and (sector.Side == "enemy1" or sector.Side == "enemy2") then
    return
  end
  local conflictSide = CheckAndEnterConflict(sector, squad, prev_sector_id)
  if sector.ForceConflict and player_squad and not squad.Retreat and not sector.conflict then
    EnterConflict(sector, prev_sector_id, conflictSide)
  end
  vrUnit = player_squad and (squad.units[AsyncRand(#squad.units) + 1] or squad.units[1])
  if vrUnit and not sector.conflict and not returningLandTravel and (not reason or reason ~= "squad_split") then
    local unit = vrUnit
    if sector.InterestingSector and not sector.player_visited then
      PlayVoiceResponse(unit, "InterestingSector")
    elseif not route or #route == 0 then
      PlayVoiceResponse(unit, "SectorArrived")
    end
  end
  if player_squad then
    gv_Sectors[sector_id].player_visited = true
  end
  local sideChanged = false
  if not sector.conflict and not squad.militia and not squad.Retreat then
    sideChanged = SatelliteSectorSetSide(sector_id, squad.Side)
  end
  if player_squad or sector.Guardpost then
    RecalcRevealedSectors()
  elseif sideChanged and g_SatelliteUI then
    g_SatelliteUI:UpdateSectorVisuals(sector_id)
  end
  if SquadCantMove(squad) then
    CreateGameTimeThread(function()
      Msg("SquadStoppedTravelling", squad)
    end)
  end
end
function GetSameTerrainTypeTravelWithBreakdown(start, route, squad)
  if not start or not route then
    return 0, {}
  end
  local units = squad.units
  local side = squad.Side
  local previous = start
  local time = 0
  local b = {}
  for i, w in ipairs(route) do
    for ii, s in ipairs(w) do
      if previous then
        local nextTravel, _, _, breakdown = GetSectorTravelTime(previous, s, route, units, nil, nil, side)
        b = breakdown
        if nextTravel then
          time = time + Max(nextTravel, lMinVisualTravelTime * 2)
        end
      end
      previous = s
    end
  end
  return time, b
end
function GetTotalRouteTravelTime(start, route, squad)
  local totalTime = GetSameTerrainTypeTravelWithBreakdown(start, route, squad)
  return totalTime
end
function RouteEndsInWater(route)
  if 0 < #route and 0 < #route[#route] then
    local last_path = route[#route]
    local last_sector = last_path[#last_path]
    return gv_Sectors[last_sector].Passability == "Water"
  end
end
function RouteOverBlockedSector(route)
  if not route then
    return false
  end
  for i, wp in ipairs(route) do
    for _, sectorId in ipairs(wp) do
      local sector = gv_Sectors[sectorId]
      if sector.Passability == "Blocked" then
        return sectorId
      end
    end
  end
  return false
end
function GetRouteTotalPrice(route, squad)
  local price = 0
  local pricePerSector = 0
  local cannotPayPast = false
  local prevSectorId = squad and squad.CurrentSector
  for i, r in ipairs(route) do
    for j, sector_id in ipairs(r or empty_table) do
      local prevSector = gv_Sectors[prevSectorId]
      local sector = gv_Sectors[sector_id]
      if prevSector and prevSector.Passability == "Land and Water" and prevSector.Port and not prevSector.PortLocked and sector.Passability == "Water" then
        pricePerSector = prevSector:GetTravelPrice(squad)
      end
      if sector.Passability == "Water" and pricePerSector then
        price = price + pricePerSector
      else
        pricePerSector = 0
      end
      if not cannotPayPast and not CanPay(price) then
        cannotPayPast = sector_id
      end
      prevSectorId = sector_id
    end
  end
  return price, cannotPayPast
end
function IsRouteForbidden(route, squad)
  if not route then
    return true
  end
  local routePrice, cannotPayPast = GetRouteTotalPrice(route, squad)
  local firstErrorSectorId = false
  local canPlaceWaypoint = false
  local errors = {}
  if Platform.demo then
    local allowedSectors = {
      I1 = true,
      I2 = true,
      I3 = true,
      H2 = true,
      H3 = true,
      H4 = true
    }
    for i, wp in ipairs(route) do
      for _, sectorId in ipairs(wp) do
        if not allowedSectors[sectorId] then
          firstErrorSectorId = sectorId
          errors[#errors + 1] = T(697751324120, "Not available in Demo")
          break
        end
      end
    end
  end
  if squad and squad.CurrentSector and gv_Sectors[squad.CurrentSector].conflict then
    errors[#errors + 1] = T(735827574209, "Squads in conflict can't receive travel orders.")
    firstErrorSectorId = firstErrorSectorId or squad.CurrentSector
  end
  if route.no_boat then
    errors[#errors + 1] = T(866576847121, "You do not have access to a port in order to cross water sectors.")
    firstErrorSectorId = firstErrorSectorId or route.no_boat
  elseif not CanPay(routePrice) then
    errors[#errors + 1] = T(968093564193, "Not enough money to pay for boat travel.")
    firstErrorSectorId = firstErrorSectorId or cannotPayPast
  elseif RouteEndsInWater(route) then
    errors[#errors + 1] = T(368683270532, "The route ends in a water sector.")
    firstErrorSectorId = firstErrorSectorId or route[#route] and route[#route][#route[#route]]
    canPlaceWaypoint = true
  else
    local sectorId = RouteOverBlockedSector(route)
    if sectorId then
      errors[#errors + 1] = T(399282935830, "The route ends on an impassable sector.")
      firstErrorSectorId = firstErrorSectorId or sectorId
    end
  end
  return 0 < #errors, errors, firstErrorSectorId, canPlaceWaypoint
end
function GetSquadBusyAvailable(squad_id)
  local busy, available = {}, {}
  for _, merc_id in ipairs(gv_Squads[squad_id].units or empty_table) do
    local operation = gv_UnitData[merc_id].Operation
    if operation ~= "Idle" and operation ~= "Traveling" then
      busy[#busy + 1] = {merc_id = merc_id, operation = operation}
    else
      available[#available + 1] = merc_id
    end
  end
  return busy, available
end
function GetSplitMoveChoice(busy, available)
  local names = {}
  for _, data in ipairs(busy) do
    names[#names + 1] = gv_UnitData[data.merc_id].Nick
  end
  local singleMerc = #busy + #available == 1
  local anyAvailable = 0 < #available
  local text
  if singleMerc then
    text = T({
      19660331151,
      "<em><list></em> is busy, do you want to move them anyway?",
      list = names[1]
    })
  elseif 1 < #busy and #available == 0 then
    text = T({
      153471084276,
      "<em><list></em> are busy, do you want to move them anyway?",
      list = ConcatListWithAnd(names)
    })
  elseif 1 < #busy then
    text = T({
      301515941137,
      "<em><list></em> are busy, do you want to split the squad?",
      list = ConcatListWithAnd(names)
    })
  else
    text = T({
      733472305625,
      "<em><list></em> is busy, do you want to split the squad?",
      list = names[1]
    })
  end
  local res = WaitPopupChoice(GetInGameInterface(), {
    translate = true,
    text = text,
    choice1 = T(681120834266, "Force Move"),
    choice1_gamepad_shortcut = "ButtonX",
    choice2 = not singleMerc and anyAvailable and T(743829766820, "Split Squad"),
    choice2_gamepad_shortcut = "ButtonY",
    choice3 = T(395359253564, "Cancel Move"),
    choice3_gamepad_shortcut = "ButtonB"
  })
  if res == 2 then
    return "split"
  elseif res == 1 then
    return "force"
  else
    return "cancel"
  end
end
function FixTreatWoundsOperations(busy)
  for i, data in ipairs(busy) do
    local operation = data.operation
    local sector_operation = SectorOperations[operation]
    local merc = gv_UnitData[data.merc_id]
    local refund_amount
    local prof_id = merc.OperationProfession
    if merc.OperationProfessions and merc.OperationProfessions.Doctor and merc.OperationProfessions.Patient then
      refund_amount = sector_operation:GetOperationCost(merc, "Patient")
      for _, cst in ipairs(sector_operation:GetOperationCost(merc, "Doctor")) do
        table.insert(refund_amount, cst)
      end
    else
      refund_amount = sector_operation:GetOperationCost(merc, prof_id)
    end
    NetSyncEvent("RestoreOperationCostAndSetOperation", data.merc_id, refund_amount, "Idle", prof_id, false, false, "check_completed")
  end
end
function TryAssignSatelliteSquadRoute(squad_id, route)
  local busy, available = GetSquadBusyAvailable(squad_id)
  local res
  if next(busy) then
    res = GetSplitMoveChoice(busy, available)
    if res == "split" then
      NetSyncEvent("SplitMercsAndAssignRoute", table.map(busy, "merc_id"), squad_id, route, "keepJoiningSquad")
    elseif res == "force" then
      FixTreatWoundsOperations(busy)
      NetSyncEvent("AssignSatelliteSquadRoute", squad_id, route, "keepJoiningSquad")
    end
  else
    NetSyncEvent("AssignSatelliteSquadRoute", squad_id, route, "keepJoiningSquad")
  end
  return res == "cancel" and "cancel"
end
function NetSyncEvents.SquadCancelTravel(squad_id, keepJoiningSquad, force)
  local self = gv_Squads[squad_id]
  if not self then
    return
  end
  if not force and (SquadTravelCancelled(self) or not IsSquadTravelling(self, "skip_satellite_tick")) then
    return
  end
  local route = false
  if IsTraversingShortcut(self) then
    route = {}
    route[1] = {
      self.route[1][1],
      shortcuts = {true}
    }
  elseif self.water_route and self.water_route[1] ~= self.CurrentSector then
    route = {}
    route[1] = table.reverse(self.water_route)
    self.returning_water_travel = true
  elseif not IsSquadInSectorVisually(self, self.CurrentSector) then
    route = {}
    route[1] = {
      self.CurrentSector,
      returning_land_travel = true
    }
  end
  local visualPos = g_SatelliteUI and g_SatelliteUI.squad_to_wnd[self.UniqueId] and g_SatelliteUI.squad_to_wnd[self.UniqueId]:GetVisualPos()
  NetSyncEvents.AssignSatelliteSquadRoute(self.UniqueId, route, keepJoiningSquad, visualPos, true)
end
function NetSyncEvents.AssignSatelliteSquadRoute(squad_id, route, keepJoiningSquad, pos, cancel)
  NetUpdateHash("AssignSatelliteSquadRoute", squad_id, Game and Game.CampaignTime)
  local squad = gv_Squads[squad_id]
  if cancel then
    for _, unit_id in ipairs(squad.units) do
      local unit_data = gv_UnitData[unit_id]
      if unit_data.Operation == "Traveling" then
        unit_data:SetCurrentOperation("Idle")
      end
    end
  end
  SetSatelliteSquadRoute(squad, route, keepJoiningSquad, nil, pos)
end
function SplitSquad(squad, merc_ids)
  if #squad.units == 1 or #merc_ids == 0 then
    return squad.UniqueId
  end
  if not squad.CurrentSector then
    return
  end
  local name = SquadName:GetNewSquadName(squad.Side)
  local squad_id = CreateNewSatelliteSquad({
    Side = squad.Side,
    CurrentSector = squad.CurrentSector,
    PreviousSector = squad.PreviousSector,
    PreviousLandSector = squad.PreviousLandSector,
    VisualPos = squad.VisualPos,
    Name = name
  }, merc_ids, nil, nil, nil, "squad_split")
  return squad_id
end
function NetSyncEvents.SplitSquad(squad_id, merc_ids)
  local squad = gv_Squads[squad_id]
  local new_squad_id = SplitSquad(squad, merc_ids)
  Msg("SyncSplitSquad", new_squad_id, squad_id)
end
function NetSyncEvents.SplitMercsAndAssignRoute(busy_merc_ids, old_squad_id, route, keepJoiningSquad)
  local old_squad = gv_Squads[old_squad_id]
  SplitSquad(old_squad, busy_merc_ids)
  SetSatelliteSquadRoute(old_squad, route, keepJoiningSquad)
end
function SetSatelliteSquadRoute(squad, route, keepJoiningSquad, from, squadPos)
  if g_TestCombat and not squad then
    return
  end
  NetUpdateHash("SetSatelliteRoute", squad.UniqueId, route, keepJoiningSquad, from, squadPos)
  local wasTravelling = IsSquadTravelling(squad)
  if squad.CurrentSector and gv_Sectors[squad.CurrentSector].GroundSector then
    local from_map = from == "from_map"
    SetSatelliteSquadCurrentSector(squad, gv_Sectors[squad.CurrentSector].GroundSector, from_map)
    SatelliteReachSectorCenter(squad.UniqueId, squad.CurrentSector, squad.PreviousSector)
  end
  if not route or route[1] then
  end
  if squad.Retreat then
    squad.Retreat = false
  end
  if not keepJoiningSquad and squad.joining_squad then
    TurnJoiningSquadIntoNormal(squad)
  end
  squad.route = route
  if squadPos and g_SatelliteUI and g_SatelliteUI.squad_to_wnd[squad.UniqueId] then
    g_SatelliteUI.squad_to_wnd[squad.UniqueId]:SetPos(squadPos:xy())
  end
  if squad.route then
    SectorOperation_CancelByGame(squad.units)
  else
    SetSatelliteSquadCurrentSector(squad, squad.CurrentSector, "update_pos", "teleport")
    Msg("SquadStoppedTravelling", squad)
    return
  end
  local curSector = gv_Sectors[squad.CurrentSector]
  if not wasTravelling and not squad.Retreat and not curSector.conflict then
    squad.consider_visually_moved = true
    CheckAndEnterConflict(curSector, squad, squad.PreviousSector)
    squad.consider_visually_moved = false
  end
  local first = route and route[1]
  first = first and first[1]
  SetSquadWaterTravel(squad, gv_Sectors[first].Passability == "Water")
  local player_squad = IsPlayer1Squad(squad)
  if player_squad and not SquadCantMove(squad) then
    DbgTravelTimerPrint("player squad start traveling")
    SetSquadTravellingActivity(squad)
  end
  ObjModified(curSector)
  Msg("SquadStartedTravelling", squad)
end
function SetSquadTravellingActivity(squad)
  local manualSync = not gv_SatelliteView
  SectorOperation_CancelByGame(squad.units, false, true)
  for _, unit_id in ipairs(squad.units) do
    local mapUnit = manualSync and g_Units[unit_id]
    if mapUnit then
      mapUnit:SyncWithSession("map")
    end
    local unit_data = gv_UnitData[unit_id]
    local prev_operation = unit_data.Operation
    unit_data:SetCurrentOperation("Traveling")
    if unit_data.TravelTimerStart == 0 then
      unit_data.TravelTimerStart = Game.CampaignTime
      unit_data.RestTimer = 0
      DbgTravelTimerPrint(unit_id, "start travel", "travel: ", unit_data.TravelTime / const.Scale.h or 0)
    end
    if mapUnit then
      mapUnit:SyncWithSession("session")
    end
  end
end
function SetSatelliteSquadSecretRoute(squad, dest, time)
  SetSatelliteSquadRoute(squad, false)
  squad.arrive_in_sector = {time = time, sector_id = dest}
  squad.CurrentSector = false
end
function SendSatelliteSquadOnRoute(squad, dest, params)
  local route = GenerateRouteDijkstra(squad.CurrentSector, dest, squad.route, squad.units, nil, nil, squad.Side)
  if not route then
    return
  end
  route = {route}
  SetSatelliteSquadRoute(squad, route)
end
function GetSquadVisualPos(squad)
  local visPos = false
  if g_SatelliteUI and g_SatelliteUI.squad_to_wnd[squad.UniqueId] then
    local wnd = g_SatelliteUI.squad_to_wnd[squad.UniqueId]
    if wnd.box == empty_box then
      visPos = squad.XVisualPos
    else
      visPos = wnd:GetVisualPos()
    end
  else
    visPos = squad.XVisualPos
  end
  return visPos
end
function IsSquadInSectorVisually(squad, sectorId)
  local visPos = GetSquadVisualPos(squad)
  sectorId = sectorId or squad.CurrentSector
  local sector = gv_Sectors[sectorId]
  if not sector.XMapPosition then
    visPos = false
  end
  if squad.CurrentSector ~= sectorId then
    return false
  end
  if squad.consider_visually_moved then
    return false
  end
  if not visPos or visPos == sector.XMapPosition then
    return true
  end
  return false
end
function IsSquadTravelling(squad, regardlessSatelliteTickPassed)
  if not squad then
    return false
  end
  if squad.arrival_squad then
    return true
  end
  if squad.Retreat then
    return true
  end
  local squadSectorId = squad.CurrentSector
  local squadSector = gv_Sectors[squadSectorId]
  if squadSector.conflict and IsSquadInSectorVisually(squad, squadSectorId) then
    return false
  end
  return squad.route and squad.route[1] and squad.route[1] and (squad.route.satellite_tick_passed or regardlessSatelliteTickPassed) and not squad.wait_in_sector
end
function AreSquadsInTheSameSectorVisually(squad1, squad2, undergroundInsensitive)
  local sector1 = squad1.CurrentSector
  local sector2 = squad2.CurrentSector
  local visuallyThere1 = IsSquadInSectorVisually(squad1, sector1)
  local visuallyThere2 = IsSquadInSectorVisually(squad2, sector2)
  if undergroundInsensitive then
    sector1 = gv_Sectors[sector1].GroundSector or sector1
    sector2 = gv_Sectors[sector2].GroundSector or sector2
  end
  if sector1 ~= sector2 then
    return false
  end
  return visuallyThere1 and visuallyThere2
end
function IsSquadInConflict(squad)
  local squadSectorId = squad.CurrentSector
  local squadSector = gv_Sectors[squadSectorId]
  return squadSector.conflict and not IsSquadTravelling(squad) and not IsTraversingShortcut(squad)
end
function IsSquadHasRoute(squad)
  return squad and squad.route and squad.route[1]
end
function IsSquadInDestinationSector(squad)
  return squad and squad.route and #squad.route == 1 and #squad.route[1] == 1 and squad.route[1][1] == squad.CurrentSector
end
function UninterruptableSquadTravel(squads_sectors_list, src_sector_id, dest_sector_id)
  local squads = {}
  for _, sector_id in ipairs(squads_sectors_list) do
    for i, squad in ipairs(g_SquadsArray) do
      if squad.CurrentSector == sector_id and (squad.Side == "player1" or squad.Side == "player2") and not squad.arrival_squad then
        squads[#squads + 1] = squad
      end
    end
  end
  for i, squad in ipairs(squads) do
    local squadSector = squad.CurrentSector
    if src_sector_id and src_sector_id ~= squadSector then
      SetSatelliteSquadCurrentSector(squad, src_sector_id, true, "teleport")
      if gv_Sectors[squadSector].conflict then
        ResolveConflict(gv_Sectors[squadSector], true)
      end
    end
    if src_sector_id == dest_sector_id then
      return
    end
    squad.uninterruptable_travel = true
    local route = GenerateRouteDijkstra(squad.CurrentSector, dest_sector_id, false, squad.units, nil, nil, squad.Side)
    if route then
      SetSatelliteSquadRoute(squad, {route})
    end
  end
end
function LocalPlayerHasAuthorityOverSquad(squad)
  if squad.uninterruptable_travel then
    return false
  end
  local count = 0
  local units = squad.units
  for i, session_id in ipairs(units) do
    local merc = gv_UnitData[session_id]
    if merc and merc:IsLocalPlayerControlled() then
      count = count + 1
    end
  end
  local unitCount = #units
  return count > unitCount / 2 or unitCount % 2 == 0 and count == unitCount / 2 and NetIsHost()
end
function GetSquadFinalDestination(startSector, route)
  if not route then
    return startSector, true
  end
  local routeDestination = false
  local isCurrent = true
  if route then
    local finalPoint = route[#route]
    if finalPoint then
      routeDestination = finalPoint[#finalPoint]
      isCurrent = routeDestination == startSector
    else
      routeDestination = startSector
      isCurrent = true
    end
  end
  return routeDestination, isCurrent
end
function GetSectorSquadsFromSide(sector_id, side1, side2)
  if not sector_id then
    return empty_table
  end
  local sector = gv_Sectors[sector_id]
  local squads = {}
  for i, squad in ipairs(sector.all_squads) do
    if not squad.militia and not squad.arrival_squad and (not side1 or squad.Side == side1 or squad.Side == side2) then
      squads[#squads + 1] = squad
    end
  end
  return squads
end
function GetSectorSquads(sector_id)
  local sector = gv_Sectors[sector_id]
  local squads = {}
  for i, squad in ipairs(sector.all_squads) do
    if not squad.arrival_squad then
      squads[#squads + 1] = squad
    end
  end
  return squads
end
function GetPlayerSectorUnits(sector_id, getUnits)
  local squads = GetSectorSquadsFromSide(sector_id, "player1", "player2")
  local units = {}
  for _, squad in ipairs(squads) do
    for _, unit_id in ipairs(squad.units) do
      local unit = getUnits and g_Units[unit_id] or gv_UnitData[unit_id]
      units[#units + 1] = unit
    end
  end
  return units
end
function FilterMercs(mercs, filter_func)
  local filtered = {}
  for _, merc in ipairs(mercs) do
    if filter_func(merc) then
      filtered[#filtered + 1] = merc
    end
  end
  return filtered
end
function GetBestStatMerc(mercs, stat)
  local best_stat = 0
  local best_merc
  for _, merc in ipairs(mercs) do
    if not merc:IsTravelling() and best_stat < merc[stat] then
      best_stat = merc[stat]
      best_merc = merc
    end
  end
  return best_merc
end
function GetUnitsByIds(unitIds, getUnitData)
  local units = {}
  for _, id in ipairs(unitIds) do
    units[#units + 1] = getUnitData and gv_UnitData[id] or g_Units[id]
  end
  return units
end
function GetUnitsFromSquads(squads, getUnitData)
  local units = {}
  for _, squad in ipairs(squads) do
    table.iappend(units, GetUnitsByIds(squad.units, getUnitData))
  end
  return units
end
function HasRoad(from_sector_id, to_sector_id)
  return GetDirectionProperty(from_sector_id, to_sector_id, "Roads")
end
function IsTravelBlocked(from_sector_id, to_sector_id)
  return GetDirectionProperty(from_sector_id, to_sector_id, "BlockTravel") or gv_Sectors[to_sector_id].Passability == "Blocked"
end
function GetDirectionProperty(from_sector_id, to_sector_id, prop_id)
  local from_sector = gv_Sectors[from_sector_id]
  for _, dir in ipairs(const.WorldDirections) do
    if GetNeighborSector(from_sector_id, dir) == to_sector_id then
      return from_sector[prop_id] and from_sector[prop_id][dir]
    end
  end
end
local opposite_directions = {
  North = "South",
  South = "North",
  East = "West",
  West = "East"
}
function SectorTravelBlocked(from_sector_id, to_sector_id, route, pass_mode, squad_curr_sector, dir)
  local from_sector = gv_Sectors[from_sector_id]
  local to_sector = gv_Sectors[to_sector_id]
  if IsTravelBlocked(from_sector_id, to_sector_id) or pass_mode == "land_only" and to_sector.Passability == "Water" then
    return true
  end
  if pass_mode ~= "land_water_river" and GetDirectionProperty(from_sector_id, to_sector_id, "BlockTravelRiver") then
    return true
  end
  if to_sector.Passability == "Water" then
    if pass_mode == "land_water_boatless" then
      return false
    elseif (pass_mode == "land_water" or pass_mode == "land_water_river") and (from_sector.Passability == "Land" or from_sector.Passability == "Land and Water") then
      if from_sector.Port and not from_sector.PortLocked and from_sector.Side == "player1" and IsBoatAvailable() then
        return false
      else
        return not from_sector.BridgeCrossing or not from_sector.BridgeCrossing[dir] or not to_sector.BridgeCrossing or not to_sector.BridgeCrossing[opposite_directions[dir]]
      end
    end
  end
end
function GetSectorTravelTime(from_sector_id, to_sector_id, route, units, pass_mode, squad_curr_sector, side, dir)
  local shortcut
  if to_sector_id and not AreAdjacentSectors(from_sector_id, to_sector_id) then
    shortcut = GetShortcutByStartEnd(from_sector_id, to_sector_id)
  end
  if not shortcut and to_sector_id and SectorTravelBlocked(from_sector_id, to_sector_id, route, pass_mode, squad_curr_sector, dir) then
    return false
  end
  if route and route.diamond_briefcase then
    local time = const.Satellite.SectorTravelTimeDiamonds
    time = DivCeil(time, const.Scale.min) * const.Scale.min
    return time * 2, time, time, {}
  end
  local from_sector = gv_Sectors[from_sector_id]
  local to_sector = to_sector_id and gv_Sectors[to_sector_id]
  if to_sector then
    local same_city = from_sector.City == to_sector.City and from_sector.City ~= "none"
    if same_city or from_sector.GroundSector == to_sector_id or to_sector.GroundSector == from_sector_id then
      return 0
    end
    if (side == "enemy1" or side == "diamonds") and to_sector.ImpassableForEnemies then
      return false
    end
    if side == "diamonds" and to_sector.ImpassableForDiamonds then
      return false
    end
  end
  local breakdown = {}
  local terrain_type1 = gv_Sectors[from_sector_id].TerrainType
  local terrain_type2 = to_sector_id and gv_Sectors[to_sector_id].TerrainType
  if gv_Sectors[from_sector_id] and gv_Sectors[from_sector_id].Passability == "Water" then
    terrain_type1 = "Water"
  end
  if gv_Sectors[to_sector_id] and gv_Sectors[to_sector_id].Passability == "Water" then
    terrain_type2 = "Water"
  end
  local travel_time_modifier1 = SectorTerrainTypes[terrain_type1] and SectorTerrainTypes[terrain_type1].TravelMod or 100
  local travel_time_modifier2 = to_sector_id and SectorTerrainTypes[terrain_type2] and SectorTerrainTypes[terrain_type2].TravelMod or travel_time_modifier1
  local hasRoad = false
  if to_sector_id and HasRoad(from_sector_id, to_sector_id) then
    travel_time_modifier1 = const.Satellite.RoadTravelTimeMod
    travel_time_modifier2 = const.Satellite.RoadTravelTimeMod
    hasRoad = true
  end
  local mod = travel_time_modifier2
  if mod ~= 0 and terrain_type1 ~= "Water" and terrain_type2 ~= "Water" and not shortcut then
    if hasRoad then
      breakdown[#breakdown + 1] = {
        Text = T(414143808849, "<em>(Road)</em>"),
        Value = 100 - mod,
        Category = "sector-special"
      }
    end
    local difficultyText = false
    if mod == 100 then
      difficultyText = T(714191851131, "Normal")
    elseif mod <= 25 then
      difficultyText = T(367857875968, "Very Easy")
    elseif mod <= 75 then
      difficultyText = T(825299951074, "Easy")
    elseif 150 <= mod then
      difficultyText = T(625725601692, "Very Hard")
    elseif 120 <= mod then
      difficultyText = T(835764015096, "Hard")
    end
    breakdown[#breakdown + 1] = {
      Text = T(379323289276, "Terrain"),
      Value = difficultyText,
      ValueType = "text",
      Category = "sector"
    }
  end
  local speed_change = 0
  local is_player = side and (side == "player1" or side == "player2")
  local max_leadership, max_leadership_merc = 0, false
  for i, u in ipairs(units or empty_table) do
    local unit_data = gv_UnitData[u]
    if is_player and max_leadership < unit_data.Leadership then
      max_leadership = unit_data.Leadership
      max_leadership_merc = unit_data.session_id
    end
  end
  local squadModifier = is_player and 100 - (const.Satellite.SectorTravelTimeBase - max_leadership) or 0
  breakdown[#breakdown + 1] = {
    Text = T(703764048855, "Squad Speed"),
    Value = squadModifier,
    Category = "squad",
    rollover = T({
      898857286023,
      "The squad speed is defined by the merc with the highest Leadership in the squad.<newline><mercName><right><stat>",
      mercName = max_leadership_merc and UnitDataDefs[max_leadership_merc] and UnitDataDefs[max_leadership_merc].Nick or Untranslated("???"),
      stat = max_leadership
    })
  }
  local sector_travel_time = side and side ~= "player1" and side ~= "player2" and const.Satellite.SectorTravelTimeEnemy or const.Satellite.SectorTravelTime
  if squadModifier ~= 0 then
    sector_travel_time = sector_travel_time - sector_travel_time * squadModifier / 100
  end
  local travel_time_1 = sector_travel_time * travel_time_modifier1 / 100
  local travel_time_2 = sector_travel_time * travel_time_modifier2 / 100
  if to_sector_id == from_sector_id and 0 < #(units or "") then
    local ud = gv_UnitData[units[1]]
    local squad = ud and ud.Squad
    squad = squad and gv_Squads[squad]
    if squad then
      local squadPos = GetSquadVisualPos(squad)
      local retreatSector = from_sector.XMapPosition
      local from = GetSquadPrevSector(squadPos, from_sector_id, retreatSector)
      from = from and gv_Sectors[from].XMapPosition
      local diff = retreatSector - from
      local passed = squadPos - from
      local passedDDiff = Dot(passed, diff)
      local percentPassed = passedDDiff ~= 0 and MulDivRound(passedDDiff, 1000, Dot(diff, diff)) or 0
      travel_time_1 = MulDivRound(travel_time_1, percentPassed, 1000)
      travel_time_2 = 0
    end
  elseif shortcut then
    travel_time_1 = shortcut:GetTravelTime()
    travel_time_2 = 0
  elseif IsRiverSector(from_sector_id) and IsRiverSector(to_sector_id, "two_way") then
    travel_time_1 = const.Satellite.RiverTravelTime + 1
    travel_time_2 = 0
  end
  local waterTravel = const.Satellite.SectorTravelTimeWater
  if terrain_type1 == "Water" or terrain_type2 == "Water" then
    travel_time_1 = waterTravel / 2
    travel_time_2 = waterTravel / 2
  end
  travel_time_1 = DivCeil(travel_time_1, const.Scale.min) * const.Scale.min
  travel_time_2 = DivCeil(travel_time_2, const.Scale.min) * const.Scale.min
  return travel_time_1 + travel_time_2, travel_time_1, travel_time_2, breakdown
end
function NetSyncEvents.SetArrivingMercSector(merc_id, sector_id)
  LocalSetArrivingMercSector(merc_id, sector_id)
end
function LocalSetArrivingMercSector(merc_id, sector_id, days)
  local merc = gv_UnitData[merc_id]
  local prevArrivingSquad = merc.Squad
  local unitArriveTime = GetOperationTimeLeft(merc, "Arriving")
  local newMercSector = sector_id or GetCurrentCampaignPreset().InitialSector
  local squadToAddIn
  for i, s in ipairs(GetPlayerMercSquads()) do
    if s.Side == "player1" and s.CurrentSector == newMercSector and s.arrival_squad then
      local willArriveWithThisSquad = true
      for i, u in ipairs(s.units) do
        local ud = gv_UnitData[u]
        local left = GetOperationTimeLeft(ud, "Arriving")
        if left ~= unitArriveTime then
          willArriveWithThisSquad = false
          break
        end
      end
      if #s.units >= const.Satellite.MercSquadMaxPeople then
        willArriveWithThisSquad = false
      end
      if willArriveWithThisSquad then
        squadToAddIn = s
        break
      end
    end
  end
  local squad_id = squadToAddIn and squadToAddIn.UniqueId
  if prevArrivingSquad and squadToAddIn and squadToAddIn.UniqueId == prevArrivingSquad then
    return
  end
  if squadToAddIn then
    AddUnitsToSquad(squadToAddIn, {merc_id}, days, days and InteractionRand(nil, "Satellite"))
  else
    squad_id = CreateNewSatelliteSquad({
      Side = "player1",
      CurrentSector = newMercSector,
      Name = Presets.SquadName.Default.Arriving.Name,
      arrival_squad = true
    }, {merc_id}, days)
  end
  if merc.Operation == "Arriving" then
    Msg("OperationChanged", merc, "Arriving", "Arriving")
  end
end
if FirstLoad then
  FilterUserTextsThread = false
end
function OnMsg.LoadGame()
  DeleteThread(FilterUserTextsThread)
end
function OnMsg.NewGame()
  DeleteThread(FilterUserTextsThread)
end
LoadingUnitName = T({977270273792, "Loading"})
function LocalHireMerc(merc_id, price, days)
  local alreadyHired = gv_UnitData[merc_id] and gv_UnitData[merc_id].Squad
  local unitData = gv_UnitData[merc_id]
  if IsUserText(unitData.Nick) then
    local loading = _InternalTranslate(LoadingUnitName)
    SetCustomFilteredUserTexts({
      unitData.Nick,
      unitData.Name
    }, {loading, loading})
  end
  FilterUserTextsThread = CreateRealTimeThread(function()
    if IsUserText(unitData.Nick) then
      local errors = AsyncFilterUserTexts({
        unitData.Nick,
        unitData.Name
      })
      if errors then
        for _, err in ipairs(errors) do
          SetCustomFilteredUserText(err.user_text)
        end
      end
      Msg("TranslationChanged")
    end
    local timeFormatted = days and FormatCampaignTime(days * const.Scale.day, "in_days") or ""
    if alreadyHired then
      local newTotal = FormatCampaignTime(unitData.HiredUntil + days * const.Scale.day - Game.CampaignTime, "in_days")
      CombatLog("short", T({
        595935156980,
        "<MercName> contract extended by <duration> (<newTotal>)",
        duration = timeFormatted,
        MercName = unitData.Name,
        newTotal = newTotal
      }))
    elseif days then
      CombatLog("short", T({
        537438751389,
        "Hired <MercName> for <duration> (<money(price)>)",
        duration = timeFormatted,
        MercName = unitData.Nick or unitData.Name,
        price = price
      }))
    else
      CombatLog("short", T({
        157053856815,
        "Hired <MercName> (<money(price)>)",
        MercName = unitData.Nick or unitData.Name,
        price = price
      }))
    end
    FilterUserTextsThread = false
  end)
  AddMoney(-price, "salary", "noCombatLog")
  SetMercStateFlag(merc_id, "LastHirePayment", price)
  local currentDailySalary = price and days and DivRound(price, days) or 0
  SetMercStateFlag(merc_id, "CurrentDailySalary", currentDailySalary)
  if alreadyHired then
    days = days or 0
    unitData.HiredUntil = unitData.HiredUntil or Game.CampaignTime
    unitData.HiredUntil = unitData.HiredUntil + days * const.Scale.day
    if g_Units[merc_id] then
      g_Units[merc_id].HiredUntil = unitData.HiredUntil
    end
    Msg("MercContractExtended", unitData)
  else
    LocalSetArrivingMercSector(merc_id, false, days)
    NetSyncEvents.MercSetOperation(merc_id, "Arriving")
    if unitData.HiredUntil then
      local arrivalTime = SectorOperations.Arriving:ProgressCompleteThreshold(unitData)
      unitData.HiredUntil = unitData.HiredUntil + arrivalTime
      Msg("UnitUpdateTimelineContractEvent", merc_id)
    end
    if not g_CurrentSquad then
      g_CurrentSquad = unitData.Squad
    end
  end
  ObjModified(unitData)
  ObjModified("coop button")
  ObjModified("MercHired")
  Msg("MercHired", merc_id, price, days, alreadyHired)
end
function GetMercArrivalTime()
  if InitialConflictNotStarted() then
    return const.Satellite.MercArrivalTime / 2
  end
  return const.Satellite.MercArrivalTime
end
function TFormat.MercArrivalTimeHours()
  return GetMercArrivalTime() / const.Scale.h
end
local lArrivalDelayed = false
local lArrivedMercsQueue = false
local lArrivalFxDelayed = function(merc, sectorId)
  if IsValidThread(lArrivalDelayed) then
    lArrivedMercsQueue[#lArrivedMercsQueue + 1] = merc
    return
  end
  lArrivedMercsQueue = {merc}
  lArrivalDelayed = CreateMapRealTimeThread(function()
    WaitAllOtherThreads()
    local perSector = {}
    for i, m in ipairs(lArrivedMercsQueue) do
      local squad = gv_Squads[m.Squad]
      local sector = squad and squad.CurrentSector
      if not perSector[sector] then
        perSector[sector] = {m}
      else
        table.insert(perSector[sector], m)
      end
    end
    for sectorId, mercs in sorted_pairs(perSector) do
      local spawnedSectorName = GetSectorName(gv_Sectors[sectorId])
      local mercName = false
      local mercVr = false
      if #mercs == 1 then
        local merc = mercs[1]
        mercName = merc.Nick
        mercVr = merc
      else
        local nicks = {}
        for i, merc in ipairs(mercs) do
          nicks[#nicks + 1] = merc.Nick
        end
        mercName = ConcatListWithAnd(nicks)
        mercVr = table.rand(mercs)
      end
      CombatLog("important", T({
        540838596254,
        "<MercNick> arrived in <sectorName>",
        {MercNick = mercName, sectorName = spawnedSectorName}
      }))
      PlayVoiceResponse(mercVr, "SectorArrived")
    end
  end)
end
function HiredMercArrived(merc, days)
  local merc_id = merc.session_id
  local arrivalSquad = merc.Squad
  arrivalSquad = arrivalSquad and gv_Squads[arrivalSquad]
  local newMercSector = arrivalSquad and arrivalSquad.CurrentSector
  newMercSector = newMercSector or GetCurrentCampaignPreset().InitialSector
  local squadToAddIn
  for i, s in ipairs(GetPlayerMercSquads()) do
    if not s.arrival_squad and s.CurrentSector == newMercSector and not IsSquadTravelling(s) and #s.units < const.Satellite.MercSquadMaxPeople then
      squadToAddIn = s
      break
    end
  end
  if squadToAddIn then
    if days then
      AddUnitsToSquad(squadToAddIn, {merc_id}, days, InteractionRand(nil, "Satellite"))
    else
      AddUnitToSquad(squadToAddIn.UniqueId, merc_id)
    end
  else
    CreateNewSatelliteSquad({
      Side = "player1",
      CurrentSector = newMercSector,
      Name = SquadName:GetNewSquadName("player1"),
      image = arrivalSquad and arrivalSquad.image
    }, {merc_id}, days)
  end
  if not days then
    lArrivalFxDelayed(merc)
  end
  merc:SetCurrentOperation("Idle")
  ObjModified(arrivalSquad)
end
function NetSyncEvents.HireMerc(merc_id, price, days, player_id)
  local alreadyHired = gv_UnitData[merc_id] and gv_UnitData[merc_id].Squad
  LocalHireMerc(merc_id, price, days)
  if player_id and not alreadyHired then
    local ud = gv_UnitData[merc_id]
    ud.ControlledBy = player_id
  end
end
function CreateImpMercData(impTest, sync)
  if sync then
    g_ImpTest = impTest
  end
  local merc_id = impTest.final.merc_template.id
  local unitData = gv_UnitData[merc_id]
  local uni_template = UnitDataDefs[unitData.class]
  if not impTest.final.nick then
    impTest.final.nick = CreateUserText(_InternalTranslate(uni_template.Nick), "name")
  end
  if not impTest.final.name then
    impTest.final.name = CreateUserText(_InternalTranslate(uni_template.Name), "name")
  end
  if impTest.final.nick == "" then
    impTest.final.nick = CreateUserText("", "name")
  end
  if impTest.final.name == "" then
    impTest.final.name = CreateUserText("", "name")
  end
  unitData.Nick = impTest.final.nick
  unitData.Name = impTest.final.name
  local stat_specialization_map = {
    Marksmanship = "Marksmen",
    Leadership = "Leader",
    Medical = "Doctor",
    Explosives = "ExplosiveExpert",
    Mechanical = "Mechanic"
  }
  local max_stat
  local specialization = "AllRounder"
  for _, stat_data in ipairs(impTest.final.stats) do
    unitData:SetBase(stat_data.stat, stat_data.value)
    local spec = stat_specialization_map[stat_data.stat]
    if spec and (not max_stat and stat_data.value > 80 or max_stat and max_stat < stat_data.value) then
      max_stat = stat_data.value
      specialization = spec
    end
  end
  unitData.Specialization = specialization
  unitData:InitDerivedProperties()
  if sync then
    unitData:RemoveAllCharacterEffects()
    if impTest.final.perks.personal and impTest.final.perks.personal.perk then
      unitData:AddStatusEffect(impTest.final.perks.personal.perk)
    end
    if impTest.final.perks.tactical then
      for i, perk_data in ipairs(impTest.final.perks.tactical) do
        if perk_data.perk then
          unitData:AddStatusEffect(perk_data.perk)
        end
      end
    end
  end
  return unitData
end
function NetSyncEvents.HireIMPMerc(impTest, merc_id, price, days)
  local unitData = CreateImpMercData(impTest, "sync")
  CombatLog("debug", "Imp Test final - " .. DbgImpPrintResult(impTest.final, "flat"))
  LocalHireMerc(merc_id, price, days)
end
function NetSyncEvents.ReleaseMerc(merc_id)
  local unit = g_Units[merc_id]
  if not gv_SatelliteView and unit then
    unit:SyncWithSession("map")
    unit:Despawn()
  end
  local unit_data = gv_UnitData[merc_id]
  local squadId = unit_data.Squad
  SectorOperation_CancelByGame({unit_data}, false, true)
  PlayVoiceResponse(unit_data, "ContractExpired")
  local squad = gv_Squads[squadId]
  local sectorId = squad.CurrentSector
  local stash = GetSectorInventoryVirtual(sectorId)
  unit_data:ForEachItemInSlot("Inventory", function(item)
    local args = {
      item = item,
      src_container = unit_data,
      src_slot = "Inventory",
      dest_container = stash,
      dest_slot = "Inventory",
      sync_call = true
    }
    NetUpdateHash("NetSyncEvents.ReleaseMerc_moving_items_params", item.class, item.id, sectorId)
    NetUpdateHash("NetSyncEvents.ReleaseMerc_moving_items_results", MoveItem(args))
  end)
  DoneObject(stash)
  RemoveUnitFromSquad(unit_data, "despawn")
  unit_data.Squad = false
  unit_data.HiredUntil = false
  unit_data.HireStatus = "Available"
  Msg("MercHireStatusChanged", unit_data, "Hired", "Available")
  Msg("MercReleased", unit_data, squadId)
  NetSyncEvent("CheckUnitsMapPresence")
  DelayedCall(0, ObjModified, gv_Squads)
  if not gv_SatelliteView and unit then
    ObjModified("hud_squads")
    EnsureCurrentSquad()
  end
end
function AddUnitsToSquad(squad, unit_ids, days, seed)
  if not squad.units then
    squad.units = {}
  end
  local hire = squad.Side == "player1"
  for _, unit_id in ipairs(unit_ids or empty_table) do
    local unit_data = gv_UnitData[unit_id]
    unit_data = unit_data or CreateUnitData(unit_id, false, seed)
    AddUnitToSquad(squad.UniqueId, unit_id, false, 1 < #unit_ids)
    if hire then
      if unit_data.HireStatus ~= "Hired" then
        unit_data.HireStatus = "Hired"
        Msg("MercHireStatusChanged", unit_data, "Available", "Hired")
      end
      if days then
        unit_data.HiredUntil = Game.CampaignTime + days * const.Scale.day
      end
    end
  end
  ObjModified(gv_Squads)
  ObjModified(squad)
end
function GetRandomSquadLogo()
  local logos = g_SquadLogos
  local filteredLogos = {}
  for i, logo in ipairs(logos) do
    local used = false
    for _, squad in ipairs(g_PlayerSquads) do
      if squad.image == logo then
        used = true
        break
      end
    end
    if not used then
      filteredLogos[#filteredLogos + 1] = logo
    end
  end
  if 0 < #filteredLogos then
    return filteredLogos[InteractionRand(#filteredLogos, "SquadLogo") + 1]
  else
    return logos[InteractionRand(#logos, "SquadLogo") + 1]
  end
end
function CreateNewSatelliteSquad(predef_props, unit_ids, days, seed, enemy_squad_def, reason)
  NetUpdateHash("CreateNewSatelliteSquad", hashParamTable(unit_ids), days, seed)
  local squad = SatelliteSquad:new(predef_props)
  local id = gv_NextSquadUniqueId
  if not squad.image then
    local is_player = squad.Side == "player1" or squad.Side == "player2"
    if is_player then
      squad.image = GetRandomSquadLogo()
    elseif squad.militia then
      squad.image = "UI/Icons/SateliteView/militia"
    else
      squad.image = "UI/Icons/SateliteView/enemy_squad"
    end
  end
  squad.UniqueId = id
  squad.enemy_squad_def = enemy_squad_def
  gv_Squads[id] = squad
  AddSquadToLists(squad)
  gv_NextSquadUniqueId = id + 1
  local current_sector = squad.CurrentSector
  local previous_sector = squad.PreviousSector
  AddUnitsToSquad(squad, unit_ids, days, seed or InteractionRand(nil, "Satellite"))
  if current_sector and not squad.arrival_squad and not predef_props.XVisualPos then
    SatelliteReachSectorCenter(id, current_sector, previous_sector, nil, nil, reason)
  end
  Msg("SquadSpawned", id, current_sector)
  return id
end
function AddUnitToSquad(squad_id, unit_id, position, multiple)
  NetUpdateHash("AddUnitToSquad", squad_id, unit_id, position, multiple)
  local squad = gv_Squads[squad_id]
  local unit_data = gv_UnitData[unit_id]
  if not unit_data then
    return
  end
  local prev_squad_id = unit_data.Squad
  if prev_squad_id then
    OnChangeUnitSquad(unit_data, prev_squad_id, squad_id)
  end
  RemoveUnitFromSquad(unit_data, "move")
  if position and position <= #squad.units then
    table.insert(squad.units, position, unit_id)
  else
    table.insert(squad.units, unit_id)
  end
  unit_data.Squad = squad.UniqueId
  if g_Units[unit_data.session_id] then
    g_Units[unit_data.session_id].Squad = squad.UniqueId
  end
  if not multiple then
    ObjModified(gv_Squads)
    ObjModified(squad)
  end
  if squad.Side == "player1" then
    if unit_data.HireStatus ~= "Hired" then
      unit_data.HireStatus = "Hired"
      if g_Units[unit_data.session_id] then
        g_Units[unit_data.session_id].HireStatus = "Hired"
      end
      Msg("MercHireStatusChanged", unit_data, "Available", "Hired")
    end
    Msg("UnitJoinedPlayerSquad", squad_id, unit_id)
  end
end
function OnMsg.MercHireStatusChanged(unitData, old, new)
  local unit = g_Units[unitData.session_data]
  if unit then
    unit.HireStatus = new
  end
end
function RemoveUnitFromSquad(unit_data, reason)
  local squad_id = unit_data.Squad
  local squad = gv_Squads[squad_id]
  unit_data.OldSquad = squad_id
  unit_data.Squad = false
  if g_Units[unit_data.session_id] then
    local unit = g_Units[unit_data.session_id]
    unit.OldSquad = squad_id
    if reason == "despawn" then
      unit.session_id = false
    end
    if not (unit:IsDead() and unit:IsMerc() and squad) or not (#squad.units > 1) then
      unit.Squad = false
    else
      unit_data.Squad = squad_id
    end
  end
  if not squad then
    return
  end
  table.remove_value(squad.units, unit_data.session_id)
  if not next(squad.units) then
    Msg("PreSquadDespawned", squad_id, squad.CurrentSector, reason)
    if squad.militia then
      local sector = gv_Sectors[squad.CurrentSector]
      if sector then
        sector.militia_squad_id = false
      end
    end
    RemoveSquadsFromLists(gv_Squads[squad_id])
    gv_Squads[squad_id] = nil
    Msg("SquadDespawned", squad_id, squad.CurrentSector, squad.Side)
  end
  ObjModified(squad)
end
function RemoveSquad(squad)
  local units = squad.units or empty_table
  for i = #units, 1, -1 do
    RemoveUnitFromSquad(gv_UnitData[units[i]])
  end
end
function CheckSquadJoiningFarAway(unit_data, squadFrom, squadTo)
  local oldSquad = squadFrom
  local squad = squadTo
  local destination = GetSquadFinalDestination(squad.CurrentSector, squad.route)
  if squadFrom.CurrentSector == destination and not IsTraversingShortcut(squadFrom) and not IsTraversingShortcut(squadTo) then
    NetSyncEvent("JoinFarAwaySquad", unit_data.session_id, squad.UniqueId, oldSquad.UniqueId)
    return "break"
  end
  if WaitQuestion(terminal.desktop, T(824112417429, "Warning"), T({
    984693643526,
    "<squadName> is in sector <SectorId(sector)>. Do you want to send <mercNick> to sector <SectorId(sector)>?",
    squadName = Untranslated(squad.Name),
    sector = destination,
    mercNick = unit_data.Nick
  }), T(689884995409, "Yes"), T(782927325160, "No")) == "ok" then
    local route = false
    if IsTraversingShortcut(oldSquad) then
      local shortcutDestination = GetSquadFinalDestination(oldSquad, oldSquad.route)
      local currentShortcutRoute = {
        oldSquad.route[1][1],
        shortcuts = {1}
      }
      if destination == shortcutDestination then
        route = {currentShortcutRoute}
      else
        route = GenerateRouteDijkstra(shortcutDestination, destination, false, empty_table, nil, nil, squad.Side)
        route = {currentShortcutRoute, route}
      end
    else
      route = GenerateRouteDijkstra(oldSquad.CurrentSector, destination, false, empty_table, nil, nil, squad.Side)
      route = {route}
    end
    if unit_data:HasStatusEffect("Exhausted") then
      ShowExhaustedUnitsQuestion(oldSquad, {unit_data})
    elseif route then
      NetSyncEvent("JoinFarAwaySquad", unit_data.session_id, squad.UniqueId, oldSquad.UniqueId, route)
    else
      WaitMessage(terminal.desktop, T(824112417429, "Warning"), T({
        345921875430,
        "Couldn't find route to <SectorId(destination)>.",
        destination = destination
      }), T(325411474155, "OK"))
    end
    return "break"
  else
    return "break"
  end
end
function TrySwapMercs(unit_data1, unit_data2)
  local squad1 = unit_data1.Squad
  local squad1Obj = gv_Squads[squad1]
  local squad2 = unit_data2.Squad
  local squad2Obj = gv_Squads[squad2]
  local position1 = table.find(squad1Obj.units, unit_data1.session_id)
  local position2 = table.find(squad2Obj.units, unit_data2.session_id)
  if squad1 == squad2 then
    if unit_data1 == unit_data2 then
      return
    end
    NetSyncEvent("AssignUnitToSquad", squad2, unit_data1.session_id, position2, nil, true)
    NetSyncEvent("AssignUnitToSquad", squad1, unit_data2.session_id, position1)
    return
  end
  if #squad1Obj.units == 1 and #squad2Obj.units == 1 then
    return
  end
  if #squad1Obj.units == 1 then
    squad1Obj, squad2Obj = squad2Obj, squad1Obj
    squad1, squad2 = squad2, squad1
    position1, position2 = position2, position1
    unit_data1, unit_data2 = unit_data2, unit_data1
  end
  CreateRealTimeThread(function()
    local sector1 = gv_Sectors[squad1Obj.CurrentSector]
    local sector2 = gv_Sectors[squad2Obj.CurrentSector]
    if not (sector1 and sector2) or squad1Obj.arrival_squad or squad2Obj.arrival_squad then
      WaitMessage(terminal.desktop, T(824112417429, "Warning"), T(974403355605, "You can't reassign newly hired mercs who have not arrived in Grand Chien yet."), T(325411474155, "OK"))
      return
    end
    if sector1 ~= sector2 then
      local resp1 = CheckSquadJoiningFarAway(unit_data1, squad1Obj, squad2Obj)
      local resp2 = CheckSquadJoiningFarAway(unit_data2, squad2Obj, squad1Obj)
      if resp1 == "break" or resp2 == "break" then
        return
      end
    end
    NetSyncEvent("AssignUnitToSquad", squad2, unit_data1.session_id, position2)
    NetSyncEvent("AssignUnitToSquad", squad1, unit_data2.session_id, position1)
  end)
end
function TryAssignUnitToSquad(unit_data, squad_id, position)
  local newSquad = not squad_id or squad_id < 0
  local squad = gv_Squads[squad_id]
  if squad_id == unit_data.Squad and not position then
    return
  end
  if not unit_data or not newSquad and not gv_Squads[squad_id] then
    return
  end
  CreateRealTimeThread(function()
    local oldSquad = gv_Squads[unit_data.Squad]
    local oldSector = oldSquad and oldSquad.CurrentSector
    if not newSquad then
      local unitCount, unitCountWithJoining = GetSquadUnitCountWithJoining(squad_id)
      if unitCount >= const.Satellite.MercSquadMaxPeople then
        return
      end
      if unitCountWithJoining >= const.Satellite.MercSquadMaxPeople then
        WaitMessage(terminal.desktop, T(824112417429, "Warning"), T(764068678037, "That squad will be full when units traveling towards it join."), T(325411474155, "OK"))
        return
      end
    end
    if not newSquad and oldSquad and oldSquad.joining_squad == squad.UniqueId then
      return
    end
    if oldSquad and (not oldSquad.CurrentSector or oldSquad.arrival_squad) then
      WaitMessage(terminal.desktop, T(824112417429, "Warning"), T(974403355605, "You can't reassign newly hired mercs who have not arrived in Grand Chien yet."), T(325411474155, "OK"))
      return
    end
    if squad and (not squad.CurrentSector or squad.arrival_squad) then
      WaitMessage(terminal.desktop, T(824112417429, "Warning"), T(902906854574, "You can't reassign mercs to squads arriving in Grand Chien."), T(325411474155, "OK"))
      return
    end
    if not newSquad and oldSquad then
      local oldSquadSectorGround = oldSquad.CurrentSector
      oldSquadSectorGround = gv_Sectors[oldSquadSectorGround].GroundSector or oldSquadSectorGround
      local newSquadSectorGround = squad.CurrentSector
      newSquadSectorGround = gv_Sectors[newSquadSectorGround].GroundSector or newSquadSectorGround
      local squadTravelling = IsSquadTravelling(squad) or squad.Retreat
      local oldSquadTravelling = IsSquadTravelling(oldSquad) or oldSquad.Retreat
      if (newSquadSectorGround ~= oldSquadSectorGround or IsTraversingShortcut(oldSquad) or oldSquadTravelling or IsTraversingShortcut(squad) or squadTravelling) and CheckSquadJoiningFarAway(unit_data, oldSquad, squad) == "break" then
        return
      end
    end
    NetSyncEvent("AssignUnitToSquad", squad and squad.UniqueId, unit_data.session_id, position, newSquad)
    if oldSquad then
      ObjModified(oldSquad)
    end
    ObjModified(newSquad)
  end)
end
function NetSyncEvents.SetSquadLogo(squad_id, image)
  local s = gv_Squads[squad_id]
  s.image = image
  ObjModified(s)
end
function NetSyncEvents.AssignUnitToSquad(squad_id, unit_id, position, create_new_squad, swap)
  local unit_data = gv_Squads and gv_UnitData[unit_id]
  if not unit_data then
    return
  end
  if create_new_squad then
    local squadCreationProps = {
      Side = "player1",
      Name = SquadName:GetNewSquadName("player1")
    }
    local oldSquad = gv_Squads[unit_data.Squad]
    if oldSquad then
      squadCreationProps.CurrentSector = oldSquad.CurrentSector
      squadCreationProps.PreviousSector = oldSquad.PreviousSector
      squadCreationProps.PreviousLandSector = oldSquad.PreviousLandSector
      squadCreationProps.XVisualPos = GetSquadVisualPos(oldSquad)
    end
    squad_id = CreateNewSatelliteSquad(squadCreationProps, {unit_id})
    local newSquad = gv_Squads[squad_id]
    if oldSquad.route and IsSquadTravelling(oldSquad, oldSquad.Retreat and "tick-regardless") then
      local oldRoute = oldSquad.route
      local newRoute = {}
      newRoute.satellite_tick_passed = oldRoute.satellite_tick_passed
      if oldSquad.water_travel then
        newRoute = table.copy(oldSquad.route, "deep")
        newRoute.water_route_assignment_route = true
      else
        local nextSector = oldRoute[1][1]
        newRoute[1] = {nextSector}
        if nextSector == newSquad.CurrentSector then
          newRoute[1].returning_land_travel = true
        end
      end
      if IsTraversingShortcut(oldSquad, oldSquad.Retreat and "tick-regardless") then
        newRoute[1].shortcuts = {1}
        newSquad.traversing_shortcut_start = oldSquad.traversing_shortcut_start
        newSquad.traversing_shortcut_start_sId = oldSquad.traversing_shortcut_start_sId
        newSquad.traversing_shortcut_water = oldSquad.traversing_shortcut_water
      end
      SetSatelliteSquadRoute(newSquad, newRoute)
      newSquad.Retreat = oldSquad.Retreat
      if oldSquad.water_travel then
        newSquad.water_travel_cost = oldSquad.water_travel_cost
        newSquad.water_travel_rest_timer = oldSquad.water_travel_rest_timer
        newSquad.water_route = table.find(oldSquad.water_route, "deep")
        newRoute.water_route_assignment_route = false
      end
    end
    if unit_data.retreat_to_sector and not newSquad.Retreat then
      local instant = RetreatMoveWholeSquad(newSquad.UniqueId, unit_data.retreat_to_sector, newSquad.CurrentSector)
      if not instant then
        newSquad.Retreat = true
      end
    end
  else
    AddUnitToSquad(squad_id, unit_id, position, swap)
  end
  Msg("UnitAssignedToSquad", squad_id, unit_id, create_new_squad)
  ObjModified("hud_squads")
end
function ReconstructJoiningSquadNames()
  for _, squad in pairs(gv_Squads) do
    if squad.joining_squad then
      squad.Name = GenerateJoiningSquadName(gv_UnitData[squad.units[1]].Nick, gv_Squads[squad.joining_squad] and gv_Squads[squad.joining_squad].Name or SquadName:GetNewSquadName("player1"))
      squad.ShortName = GenerateJoiningSquadName_Short(gv_UnitData[squad.units[1]].Nick, gv_Squads[squad.joining_squad] and gv_Squads[squad.joining_squad].Name or SquadName:GetNewSquadName("player1"))
    end
  end
end
function OnMsg.PreLoadSessionData()
  ReconstructJoiningSquadNames()
end
function OnMsg.GatherSessionData()
  for _, squad in pairs(gv_Squads) do
    if squad.joining_squad then
      squad.Name = ""
    end
  end
end
function OnMsg.GatherSessionDataEnd()
  ReconstructJoiningSquadNames()
end
function GenerateJoiningSquadName(unit_nick, squad_name)
  return T({
    590091407961,
    "<u(Name)> -> <u(OtherName)>",
    Name = unit_nick,
    OtherName = squad_name
  })
end
function GenerateJoiningSquadName_Short(unit_nick, squad_name)
  return T({
    246115235863,
    "-> <u(OtherName)>",
    OtherName = SquadName:GetShortNameFromName(squad_name)
  })
end
function NetSyncEvents.JoinFarAwaySquad(unit_id, joining_squad_id, old_squad_id, route)
  local oldSquad = gv_Squads[old_squad_id]
  local visPos = GetSquadVisualPos(oldSquad)
  local squad_id = CreateNewSatelliteSquad({
    Side = "player1",
    CurrentSector = oldSquad.CurrentSector,
    PreviousSector = oldSquad.PreviousSector,
    PreviousLandSector = oldSquad.PreviousLandSector,
    Name = GenerateJoiningSquadName(gv_UnitData[unit_id].Nick, gv_Squads[joining_squad_id].Name),
    ShortName = GenerateJoiningSquadName_Short(gv_UnitData[unit_id].Nick, gv_Squads[joining_squad_id].Name),
    XVisualPos = visPos
  }, {unit_id})
  local squad = gv_Squads[squad_id]
  squad.joining_squad = joining_squad_id
  local oldSquadWasTravelling = IsSquadTravelling(oldSquad)
  if oldSquad.Retreat then
    route = table.copy(oldSquad.route, "deep")
    squad.Retreat = true
    SetSatelliteSquadRoute(squad, route, "keep-join")
    squad.Retreat = true
  elseif route then
    route.satellite_tick_passed = oldSquadWasTravelling
    SetSatelliteSquadRoute(squad, route, "keep-join")
  elseif oldSquadWasTravelling then
    NetSyncEvents.SquadCancelTravel(squad_id, "keep-join", "force")
    if squad.route then
      squad.route.satellite_tick_passed = true
    end
  end
  if IsTraversingShortcut(oldSquad) then
    squad.traversing_shortcut_start = oldSquad.traversing_shortcut_start
    squad.traversing_shortcut_start_sId = oldSquad.traversing_shortcut_start_sId
    squad.traversing_shortcut_water = oldSquad.traversing_shortcut_water
  end
end
MapVar("gameOverState", 0)
local lInternalCheckGameOver = function()
  if GameState.no_gameover then
    return
  end
  if gameOverState ~= 0 then
    return
  end
  local playerTeam = GetCampaignPlayerTeam()
  if not playerTeam:IsDefeated() then
    return
  end
  gameOverState = 1
  WaitUnitsInIdleOrBehavior()
  for i, unit in ipairs(playerTeam.units) do
    if unit.behavior ~= "Dead" and unit.command ~= "Die" then
      unit:SetCommand("Die")
    end
  end
  for i, unit in ipairs(playerTeam.units) do
    while unit.command == "Die" do
      WaitMsg("UnitDied", 1000)
    end
  end
  WaitUnitsInIdleOrBehavior()
  if g_Combat then
    g_Combat:End()
  end
  if not AnyPlayerSquads() then
    if Game.Money < 5000 then
      ShowPopupNotification("GameOverNoMoney")
    else
      ShowPopupNotification("IncapacitatedNoMercs")
    end
  else
    ShowPopupNotification("IncapacitatedWithMercs")
  end
  WaitAllPopupNotifications()
  if not next(gv_Squads) then
    gameOverState = 3
    OpenPreGameMainMenu("")
    return
  end
  FireNetSyncEventOnHost("CheckGameOverAfterPopups")
end
local lInternalCheckGameOverAfterPopups = function()
  if not gv_SatelliteView and gv_CurrentSectorId and GameState.entered_sector then
    local squadsHere = GetSquadsInSector(gv_CurrentSectorId, true, false, true)
    if not squadsHere or #squadsHere == 0 then
      gameOverState = 3
      local currentSector = gv_Sectors[gv_CurrentSectorId]
      if currentSector and currentSector.conflict then
        currentSector.conflict_backup = table.copy(currentSector.conflict)
        ResolveConflict(currentSector, "noVoice", false, "retreat")
      end
      for i, u in ipairs(g_Units) do
        u:AddStatusEffect("Unaware")
      end
      local playerSquads = GetPlayerMercSquads() or empty_table
      if #playerSquads == 0 then
        PauseCampaignTime("NoMercs")
      end
      OpenSatelliteView()
      return
    end
  end
end
function NetSyncEvents.CheckGameOverAfterPopups()
  CreateGameTimeThread(lInternalCheckGameOverAfterPopups)
end
function NetSyncEvents.CheckGameOver()
  if gameOverState ~= 0 then
    return
  end
  CreateGameTimeThread(lInternalCheckGameOver)
end
function CheckGameOver()
  FireNetSyncEventOnHost("CheckGameOver")
end
function OnMsg.MercHired()
  ResumeCampaignTime("NoMercs")
end
function OnMsg.ZuluGameLoaded()
  if gv_SatelliteView then
    return
  end
  gameOverState = 0
  CheckGameOver()
end
function OnMsg.UnitDieStart(unit)
  if unit.session_id and gv_UnitData[unit.session_id] then
    local unitData = gv_UnitData[unit.session_id]
    Msg("MercHireStatusChanged", unitData, unitData.HireStatus, "Dead")
    unitData.HireStatus = "Dead"
    unitData.HiredUntil = Game.CampaignTime
    unitData.HitPoints = 0
    NetUpdateHash("UD_UnitDied", unit.session_id)
    RemoveUnitFromSquad(unitData)
    local unit = g_Units[unit.session_id]
    if unit then
      unit.HireStatus = "Dead"
      unit.HiredUntil = Game.CampaignTime
    end
    ObjModified(Selection)
    if unit and (unit.team.side == "player1" or unit.team.side == "player2") then
      CheckGameOver()
    end
  end
end
function HealUnitData(data, hp)
  data.HitPoints = hp or data.MaxHitPoints
  ObjModified(data)
end
function ReviveUnitData(data, hp)
  HealUnitData(data, hp)
  data:CreateStartingEquipment(data.randomization_seed)
end
function ReviveUnit(u, hp)
  u:ReviveOnHealth(hp)
  u:FlushCombatCache()
  u:UpdateOutfit()
  u:InitMercWeaponsAndActions()
end
function NetSyncEvents.HealMerc(merc_id)
  local unit_data = gv_UnitData[merc_id]
  if unit_data then
    HealUnitData(unit_data)
  end
  if IsValid(g_Units[merc_id]) then
    g_Units[merc_id]:ReviveOnHealth()
  end
end
local GetMinUnvisitedPathSizeSector = function(unvisited, sector_path_size)
  local min = max_int
  local min_sector
  for sector, _ in sorted_pairs(unvisited) do
    if min > sector_path_size[sector] then
      min = sector_path_size[sector]
      min_sector = sector
    end
  end
  if min == max_int then
    return false
  end
  return min_sector
end
function CheckIfPathTaken(curr, neigh, route, squad_curr_sector)
  local prevSect = squad_curr_sector
  for __, w in ipairs(route) do
    for ___, s in ipairs(w) do
      if prevSect == neigh and s == curr then
        return true
      end
      prevSect = s
    end
  end
  return false
end
function GenerateRouteDijkstra(start_sector, end_sector, fullRoute, units, pass_mode, squad_curr_sector, side, noShortcuts)
  if gv_Sectors and gv_Sectors[start_sector] and gv_Sectors[start_sector].GroundSector then
    start_sector = gv_Sectors[start_sector].GroundSector
  end
  if gv_Sectors and gv_Sectors[end_sector] and gv_Sectors[end_sector].GroundSector then
    end_sector = gv_Sectors[end_sector].GroundSector
  end
  if start_sector == end_sector then
    return false
  end
  pass_mode = pass_mode or (side == "enemy1" or side == "diamonds") and "land_water_boatless" or "land_water"
  if GetSectorDistance(start_sector, end_sector) == 1 then
    local dir = GetSectorDirection(start_sector, end_sector)
    local time = GetSectorTravelTime(start_sector, end_sector, fullRoute, units, pass_mode, squad_curr_sector, side, dir)
    if time then
      return {end_sector}
    end
  end
  local unvisited_sectors = {}
  local sector_path_size = {}
  local prev, prevIsShortcut = {}, false
  for sector_id, _ in pairs(gv_Sectors) do
    if sector_id == start_sector then
      sector_path_size[sector_id] = 0
    else
      sector_path_size[sector_id] = max_int
    end
    unvisited_sectors[sector_id] = true
  end
  local curr = start_sector
  while true do
    for _, dir in ipairs(const.WorldDirections) do
      local neigh = GetNeighborSector(curr, dir)
      if unvisited_sectors[neigh] then
        local time = GetSectorTravelTime(curr, neigh, fullRoute, units, pass_mode, squad_curr_sector, side, dir)
        if time then
          local time_value = time + sector_path_size[curr]
          if time_value < sector_path_size[neigh] then
            sector_path_size[neigh] = time_value
            prev[neigh] = curr
          end
        end
      end
    end
    local shortcuts = noShortcuts and empty_table or GetShortcutsAtSector(curr, pass_mode == "retreat")
    for i, shortcut in ipairs(shortcuts) do
      local exit = shortcut.start_sector == curr and shortcut.end_sector or shortcut.start_sector
      if unvisited_sectors[exit] then
        local time = GetSectorTravelTime(curr, exit, fullRoute, units, pass_mode, squad_curr_sector, side)
        if time then
          local time_value = time + sector_path_size[curr]
          if time_value < sector_path_size[exit] then
            sector_path_size[exit] = time_value
            prev[exit] = curr
            prevIsShortcut = prevIsShortcut or {}
            if not prevIsShortcut[curr] then
              prevIsShortcut[curr] = {}
            end
            prevIsShortcut[curr][exit] = true
          end
        end
      end
    end
    unvisited_sectors[curr] = nil
    curr = GetMinUnvisitedPathSizeSector(unvisited_sectors, sector_path_size)
    if not curr then
      return false
    end
    if curr == end_sector then
      local s = curr
      local route_rev = {}
      local water_sectors = 0
      while s ~= start_sector do
        table.insert(route_rev, s)
        s = prev[s]
      end
      local reversedRoute = table.reverse(route_rev)
      local prevS = start_sector
      for i, s in ipairs(reversedRoute) do
        if prevIsShortcut and prevIsShortcut[prevS] and prevIsShortcut[prevS][s] then
          if not reversedRoute.shortcuts then
            reversedRoute.shortcuts = {}
          end
          reversedRoute.shortcuts[i] = true
          if Platform.developer then
            local shortcutStart = prevS
            local shortcutEnd = s
          end
        end
        prevS = s
      end
      return reversedRoute, sector_path_size[end_sector]
    end
  end
end
function OnMsg.SatelliteTick()
  local removeSquads = false
  SatelliteTickPerSectorActivityCalled = {}
  for _, squad in ipairs(g_SquadsArray) do
    if squad.route and not squad.route.satellite_tick_passed and not SquadCantMove(squad) then
      squad.route.satellite_tick_passed = true
      Msg("SquadTravellingTickPassed", squad)
    end
    local player_squad = IsPlayer1Squad(squad)
    if player_squad or not IsSquadTravelling(squad) then
      SatelliteUnitsTick(squad)
      ObjModified(gv_Sectors[squad.CurrentSector])
    end
    if squad.wait_in_sector and squad.wait_in_sector <= Game.CampaignTime then
      SatelliteSquadWaitInSector(squad, false)
    end
    if squad.despawn_on_next_tick and not IsSquadInConflict(squad) and not IsSquadTravelling(squad) then
      removeSquads = removeSquads or {}
      removeSquads[#removeSquads + 1] = squad
    end
  end
  if removeSquads then
    for i, squad in ipairs(removeSquads) do
      RemoveSquad(squad)
    end
  end
end
function TurnJoiningSquadIntoNormal(squad)
  squad.route = false
  squad.joining_squad = false
  squad.Name = SquadName:GetNewSquadName("player1")
  squad.ShortName = false
  ObjModified(squad)
end
function UpdateJoiningSquad(squad, canSetRoute)
  local squadId = squad.UniqueId
  if not gv_Squads[squadId] then
    return
  end
  local joinSquad = gv_Squads[squad.joining_squad]
  if not joinSquad then
    TurnJoiningSquadIntoNormal(squad)
  elseif AreSquadsInTheSameSectorVisually(joinSquad, squad, "undergroundInsensitive") then
    squad.route = false
    local newSquad = joinSquad
    local unitId = squad.units[1]
    local unit_data = gv_UnitData[unitId]
    local bag = GetSquadBag(squad.UniqueId)
    if bag and next(bag) then
      AddItemsToSquadBag(newSquad.UniqueId, bag)
    end
    RemoveUnitFromSquad(unit_data)
    table.insert(newSquad.units, unit_data.session_id)
    unit_data.Squad = newSquad.UniqueId
    ObjModified(newSquad)
    InventoryUIResetSquadBag()
    return true
  elseif canSetRoute then
    if squad.Retreat then
      return
    end
    local route = GenerateRouteDijkstra(squad.CurrentSector, GetSquadFinalDestination(joinSquad.CurrentSector, joinSquad.route), squad.route, squad.units, nil, nil, squad.Side)
    if route then
      SetSatelliteSquadRoute(squad, {route}, true)
    else
      NetSyncEvents.SquadCancelTravel(squadId, not SquadCantMove(squad))
    end
  else
    CreateRealTimeThread(UpdateJoiningSquad, squad, "canSetRoute")
  end
end
function IsPlayer1Squad(squad)
  return not squad.militia and squad.Side == "player1"
end
const.DbgTravelTimer = false
function DbgTravelTimerPrint(...)
  if const.DbgTravelTimer then
    print(...)
  end
end
function OnMsg.ReachSectorCenter(squad_id, sector_id, prev_sector_id)
  local squad = gv_Squads[squad_id]
  local player_squad = IsPlayer1Squad(squad)
  if not player_squad then
    return
  end
  local travelling = IsSquadTravelling(squad) and not IsSquadInDestinationSector(squad)
  local waterTravel = IsSquadWaterTravelling(squad)
  for idx, id in ipairs(squad.units) do
    local unit_data = gv_UnitData[id]
    if travelling and idx == 1 then
      PlayVoiceResponse(table.rand(squad.units), "Travelling")
    end
    if unit_data.TravelTimerStart > 0 then
      local hp = unit_data.HitPoints
      local additional = 0
      local const_hp = const.Satellite.UnitTirednessTravelTimeHP
      if hp > const_hp then
        local persent = 100 - hp
        additional = MulDivRound(const.Satellite.UnitTirednessTravelTime, persent, 100)
      elseif hp < const_hp then
        local persent = Min(const_hp - hp, 50)
        additional = -MulDivRound(const.Satellite.UnitTirednessTravelTime, persent, 100)
      end
      NetUpdateHash("Tiredness", id, unit_data.TravelTimerStart, hp, additional, unit_data.Tiredness, waterTravel)
      if not waterTravel and unit_data.TravelTime >= const.Satellite.UnitTirednessTravelTime + additional then
        if unit_data.Tiredness < 2 then
          unit_data:ChangeTired(1)
        end
        DbgTravelTimerPrint("change tired: ", unit_data.session_id, unit_data.Tiredness)
        unit_data.TravelTime = 0
        unit_data.TravelTimerStart = Game.CampaignTime
      end
    end
    if not travelling then
      DbgTravelTimerPrint("stop travel: ", unit_data.session_id, unit_data.Operation, unit_data.TravelTime / const.Scale.h)
      unit_data.TravelTimerStart = 0
      if unit_data.Operation == "Idle" or unit_data.Operation == "Traveling" or unit_data.Operation == "Arriving" then
        unit_data:SetCurrentOperation("Idle")
        if unit_data.RestTimer == 0 then
          DbgTravelTimerPrint("start rest: ", unit_data.session_id, unit_data.Operation)
          unit_data.RestTimer = Game.CampaignTime
        end
      end
    end
  end
end
function OnMsg.OpenSatelliteView()
  local squads = GetPlayerMercSquads()
  for _, squad in ipairs(squads) do
    local mercs = squad.units
    for _, merc_id in ipairs(mercs) do
      local merc = gv_UnitData[merc_id]
      if not merc.Operation or merc.Operation == "Idle" then
        NetSyncEvents.MercSetOperation(merc_id, "Idle")
      end
    end
  end
end
function SatelliteUnitRestTimeRemaining(ud, nextStepOnly)
  if ud.Tiredness == 0 then
    return false
  end
  if 0 >= ud.RestTimer then
    return false
  end
  local steps = nextStepOnly and 1 or ud.Tiredness
  return const.Satellite.UnitTirednessRestTime * steps - (Game.CampaignTime - ud.RestTimer)
end
if FirstLoad then
  SatelliteTickPerSectorActivityCalled = {}
end
function SatelliteUnitsTick(squad)
  local player_squad = IsPlayer1Squad(squad)
  local waterTravel = IsSquadWaterTravelling(squad)
  local squadUnits = table.copy(squad.units)
  local sector = gv_Sectors[squad.CurrentSector]
  local sector_id = sector.Id
  for _, id in ipairs(squadUnits) do
    local unit_data = gv_UnitData[id]
    local operation_id = unit_data.Operation
    local is_operation_started = operation_id == "Idle" or operation_id == "Traveling" or operation_id == "Arriving" or sector and sector.started_operations and sector.started_operations[operation_id]
    if not squad.Sleep then
      SatelliteTickPerSectorActivityCalled[sector_id] = SatelliteTickPerSectorActivityCalled[sector_id] or {}
      if not SatelliteTickPerSectorActivityCalled[sector_id][operation_id] then
        SatelliteTickPerSectorActivityCalled[sector_id][operation_id] = true
        local sector = gv_Sectors[squad.CurrentSector]
        if is_operation_started then
          SectorOperations[operation_id]:SectorMercsTick(unit_data)
          is_operation_started = operation_id == "Idle" or operation_id == "Traveling" or operation_id == "Arriving" or sector and sector.started_operations and sector.started_operations[operation_id]
        else
          RecalcOperationETAs(sector, operation_id, "stopped")
        end
      end
      if (player_squad or squad.villain) and is_operation_started and unit_data.Operation == operation_id then
        SectorOperations[operation_id]:Tick(unit_data)
        local excludingActivity = operation_id ~= "Idle" and operation_id ~= "Traveling" and operation_id ~= "Arriving" and operation_id ~= "RAndR"
        local excludingProf = unit_data.OperationProfession ~= "Student" and unit_data.OperationProfession ~= "Patient"
        if excludingActivity and excludingProf and is_operation_started and (not (squad.vrForActivity and squad.vrForActivity[operation_id]) or not squad.vrForActivity[operation_id].isPlayed) then
          local remainingTimeH = (GetOperationTimerETA(unit_data) or 0) / const.Scale.h
          local activityTimeH = (unit_data.OperationInitialETA or 0) / const.Scale.h
          local passedTimeH = activityTimeH - remainingTimeH
          if 0 < remainingTimeH and passedTimeH >= const.Satellite.BusySatViewHours then
            squad.vrForActivity = squad.vrForActivity or {}
            squad.vrForActivity[operation_id] = squad.vrForActivity[operation_id] or {}
            table.insert_unique(squad.vrForActivity[operation_id], id)
          end
        end
      end
    end
    if 0 < unit_data.TravelTimerStart then
      if not waterTravel then
        unit_data.TravelTime = unit_data.TravelTime + (Game.CampaignTime - unit_data.TravelTimerStart)
      end
      DbgTravelTimerPrint("update travel: ", unit_data.session_id, unit_data.TravelTime / const.Scale.h)
      unit_data.TravelTimerStart = Game.CampaignTime
    end
    if player_squad and 0 >= (SatelliteUnitRestTimeRemaining(unit_data, "next_step_only") or 1) then
      unit_data:SetTired(Max(unit_data.Tiredness - 1, 0))
      unit_data.RestTimer = Game.CampaignTime
      unit_data.TravelTimerStart = 0
      unit_data.TravelTime = 0
      DbgTravelTimerPrint(id, "rest", "travel:", unit_data.TravelTime / const.Scale.h, " rest ", (Game.CampaignTime - unit_data.RestTimer) / const.Scale.h)
    end
    NetUpdateHash("SatelliteUnitsTick", unit_data.session_id, unit_data.RestTimer, unit_data.Tiredness, unit_data.TravelTimerStart, unit_data.TravelTime)
    unit_data:Tick()
  end
  for operation_id, units in pairs(squad.vrForActivity) do
    local is_operation_started = sector and sector.started_operations and sector.started_operations[operation_id]
    if is_operation_started and not squad.vrForActivity[operation_id].isPlayed then
      local randUnit = table.rand(units)
      PlayVoiceResponse(randUnit, "BusySatView")
      squad.vrForActivity[operation_id].isPlayed = true
    end
  end
  for _, id in ipairs(squad.units) do
    ObjModified(gv_UnitData[id])
  end
  if squad.arrive_in_sector and squad.arrive_in_sector.time <= Game.CampaignTime then
    local sector_id = squad.arrive_in_sector.sector_id
    SetSatelliteSquadCurrentSector(squad, sector_id, nil, "teleport")
  end
end
function GetSectorIntelIds(sector_id)
  local campaign = GetCurrentCampaignPreset()
  local sector = table.find_value(campaign.Sectors, "Id", sector_id)
  return sector and table.values(sector.Intel or empty_table, "sorted", "Id") or empty_table
end
function GetSessionIntelObj(sector_id, item_id)
  local sector = gv_Sectors[sector_id]
  return sector and sector.intel[item_id], sector
end
function DiscoverIntelForSector(sector_id, suppressNotification)
  DiscoverIntelForSectors({sector_id}, suppressNotification)
end
function DiscoverIntelForSectors(sector_ids, suppressNotification)
  NetUpdateHash("DiscoverIntelForSectors", suppressNotification, table.unpack(sector_ids))
  local discoveredFor = {}
  local alreadyKnown = false
  for i, s in ipairs(sector_ids) do
    local sector = gv_Sectors[s]
    if sector and sector.Intel then
      if not suppressNotification then
        if sector.intel_discovered then
          alreadyKnown = true
        end
        discoveredFor[#discoveredFor + 1] = s
      end
      sector.intel_discovered = true
      NetUpdateHash("DiscoverIntelForSectors2", s)
      ObjModified(sector)
      Msg("IntelDiscovered", s)
    end
  end
  if #discoveredFor == 0 then
    return
  end
  if #discoveredFor == 1 then
    local sector = gv_Sectors[discoveredFor[1]]
    local text = T({
      Presets.TacticalNotification.Default.intelFound.text,
      sector
    })
    if alreadyKnown then
      text = text .. T(504828030360, " (already known)")
    end
    CombatLog("important", text)
  else
    CombatLog("important", T({
      Presets.TacticalNotification.Default.intelFoundMultiple.text,
      sectors = discoveredFor
    }))
  end
end
function GetSectorsAvailableForIntel(radius)
  local sectorIds = {}
  for _, sector in sorted_pairs(gv_Sectors) do
    if sector.Intel and not sector.intel_discovered and (not (radius and gv_CurrentSectorId) or radius >= GetSectorDistance(gv_CurrentSectorId, sector.Id)) then
      sectorIds[#sectorIds + 1] = sector.Id
    end
  end
  return sectorIds
end
function DiscoverIntelForRandomSector(radius, suppressNotification)
  local sectorIds = GetSectorsAvailableForIntel(radius)
  if #sectorIds == 0 then
    return
  end
  local sectorId = table.rand(sectorIds, InteractionRand(nil, "Satellite"))
  NetUpdateHash("DiscoverIntelForRandomSector", gv_CurrentSectorId, sectorId, table.unpack(sectorIds))
  DiscoverIntelForSector(sectorId, suppressNotification)
  return sectorId
end
function GetSectorDistance(sectorId1, sectorId2)
  local x1, y1 = sector_unpack(sectorId1)
  local x2, y2 = sector_unpack(sectorId2)
  return abs(x1 - x2) + abs(y1 - y2)
end
function GetSectorDirection(sectorId1, sectorId2)
  local y1, x1 = sector_unpack(sectorId1)
  local y2, x2 = sector_unpack(sectorId2)
  if y1 == y2 then
    return x1 > x2 and "West" or "East"
  end
  return y1 > y2 and "North" or "South"
end
function GetNeighborSector(sector_id, dir, campaign)
  local neigh_id
  local row, col = sector_unpack(sector_id)
  local campaign = campaign or GetCurrentCampaignPreset()
  if dir == "North" then
    if row == 1 then
      return false
    end
    neigh_id = sector_pack(row - 1, col)
  elseif dir == "South" then
    local start_row = "A"
    if row == campaign.sector_rows then
      return false
    end
    neigh_id = sector_pack(row + 1, col)
  elseif dir == "East" then
    if col == campaign.sector_columns then
      return false
    end
    neigh_id = sector_pack(row, col + 1)
  elseif dir == "West" then
    if col == 1 then
      return false
    end
    neigh_id = sector_pack(row, col - 1)
  end
  return neigh_id
end
function GetNeighborSectors(sector_id)
  local sectors = {}
  local row, col = sector_unpack(sector_id)
  local campaign = GetCurrentCampaignPreset()
  if row ~= 1 then
    table.insert(sectors, sector_pack(row - 1, col))
  end
  if row ~= campaign.sector_rows then
    table.insert(sectors, sector_pack(row + 1, col))
  end
  if col ~= campaign.sector_columns then
    table.insert(sectors, sector_pack(row, col + 1))
  end
  if col ~= 1 then
    table.insert(sectors, sector_pack(row, col - 1))
  end
  return sectors
end
local UpdateNeighborSector = function(sector, neigh_sector, dir, prop_id)
  if not neigh_sector then
    return
  end
  if not neigh_sector[prop_id] then
    neigh_sector:SetProperty(prop_id, set())
  end
  if sector[prop_id] and sector[prop_id][dir] then
    local prop_set = neigh_sector:GetProperty(prop_id)
    prop_set[opposite_directions[dir]] = true
    neigh_sector:SetProperty(prop_id, prop_set)
  else
    local prop_set = neigh_sector:GetProperty(prop_id)
    prop_set[opposite_directions[dir]] = false
    neigh_sector:SetProperty(prop_id, prop_set)
  end
end
function UpdateNeighborSectorDirectionsProp(sector, dir, prop_id)
  local neigh_id = GetNeighborSector(sector.Id, dir)
  local campaign_neigh_sector = table.find_value(CampaignPresets.HotDiamonds.Sectors, "Id", neigh_id)
  UpdateNeighborSector(sector, campaign_neigh_sector, dir, prop_id)
  UpdateNeighborSector(sector, gv_Sectors[neigh_id], dir, prop_id)
end
function SatelliteSectorSetDirectionsProp(sector, prop_id)
  for _, dir in ipairs(const.WorldDirections) do
    UpdateNeighborSectorDirectionsProp(sector, dir, prop_id)
  end
end
function SquadIsInCombat(squad_id)
  if not g_Combat then
    return false
  end
  local squad = gv_Squads[squad_id]
  local sector_id = squad.CurrentSector
  if gv_ActiveCombat ~= sector_id then
    return false
  end
  return not IsSquadTravelling(squad)
end
function TFormat.SquadLocation(context)
  if not context then
    return ""
  end
  local routeDestination, isCurrent = GetSquadFinalDestination(context.CurrentSector, context.route)
  if not isCurrent and routeDestination then
    return T({
      712350743869,
      "<CurrentSector> > <routeDestination>",
      CurrentSector = Untranslated(context.CurrentSector),
      routeDestination = Untranslated(routeDestination)
    })
  else
    return Untranslated(context.CurrentSector)
  end
end
function TFormat.SquadMemberCount(context)
  if not context then
    return 0
  end
  if context.UniqueId == -1 then
    return #context.units
  end
  local squad = gv_Squads[context.UniqueId]
  return Untranslated(squad and tostring(#squad.units) or "0")
end
function TFormat.GetSquadPower(context)
  if not context then
    return 0
  end
  local power = GetSquadPower(context)
  return Untranslated(power)
end
function GetSquadTiredUnits(squad, tired)
  local exhausted
  for _, u in ipairs(squad.units) do
    local ud = gv_UnitData[u]
    if ud:HasStatusEffect(tired) then
      exhausted = exhausted or {}
      table.insert(exhausted, ud)
    end
  end
  return exhausted
end
function SatellitePopupQuestion(...)
  PauseCampaignTime(GetUICampaignPauseReason("Popup"))
  local res
  if WaitQuestion(...) == "ok" then
    res = true
  end
  ResumeCampaignTime(GetUICampaignPauseReason("Popup"))
  return res
end
function SatellitePopupMessage(...)
  PauseCampaignTime(GetUICampaignPauseReason("Popup"))
  local res
  if WaitMessage(...) == "ok" then
    res = true
  end
  ResumeCampaignTime(GetUICampaignPauseReason("Popup"))
  return res
end
function ShowExhaustedUnitsQuestion(squad, exhausted)
  exhausted = GetSquadTiredUnits(squad, "Exhausted") or exhausted
  if not exhausted or #exhausted == 0 then
    return
  end
  local nicks = table.map(exhausted, "Nick")
  local exhausted_units_listed = table.concat(nicks, ", ")
  if exhausted and #exhausted < #squad.units then
    local destination = next(squad.route) and GetSquadFinalDestination(squad.CurrentSector, squad.route) or false
    local result = SatellitePopupQuestion(terminal.desktop, T(824112417429, "Warning"), T({
      246005211663,
      [[
Some mercs assigned to <em><squadName></em> are <em>exhausted</em> and can't travel anymore. The squad will stop to rest in <em><SectorName(sector_id)></em>. <newline><newline>You can split the squad and order non-exhausted mercs to carry on to <destination_sector_id>.

Exhausted mercs: <nicknames>]],
      squadName = Untranslated(squad.Name),
      nicknames = exhausted_units_listed,
      sector_id = gv_Sectors[squad.CurrentSector],
      destination_sector_id = destination and gv_Sectors[destination].display_name or T(164957197964, "destination sector")
    }), T(167389155310, "Split squad"), T(849471603425, "Stop Travel"))
    return result and table.map(exhausted, "session_id") or false
  else
    local result = SatellitePopupMessage(terminal.desktop, T(824112417429, "Warning"), T({
      122112968253,
      [[
Some mercs assigned to <squadName> are exhausted and can't travel anymore. The squad will stop to rest in <sector_id>.

Exhausted mercs: <nicknames>]],
      squadName = Untranslated(squad.Name),
      nicknames = exhausted_units_listed,
      sector_id = gv_Sectors[squad.CurrentSector].display_name
    }), T(849471603425, "Stop Travel"))
    return false
  end
end
function HasTiredMember(squad, tired)
  for _, u in ipairs(squad.units) do
    local ud = gv_UnitData[u]
    if ud:HasStatusEffect(tired) then
      return true
    end
  end
end
function GetSquadExhaustedUnitIds(squad)
  local exhausted
  for _, u in ipairs(squad.units) do
    local ud = gv_UnitData[u]
    if ud:HasStatusEffect("Exhausted") then
      exhausted = exhausted or {}
      table.insert(exhausted, u)
    end
  end
  return exhausted
end
function GetCurrentSectorPlayerSquads()
  return GetSectorSquadsFromSide(gv_CurrentSectorId, "player1", "player2")
end
function GetSquadsWithIds(squad_ids)
  local squads = {}
  for _, id in ipairs(squad_ids or empty_table) do
    table.insert(squads, gv_Squads[id])
  end
  return squads
end
function SatelliteSquadWaitInSector(squad, time)
  local had = not not squad.wait_in_sector
  local willHave = not not time
  squad.wait_in_sector = time or false
  if had ~= willHave then
    Msg("SquadWaitInSectorChanged", squad)
  end
end
function SetSquadWaterTravel(squad, val)
  local oldVal = squad.water_travel
  squad.water_travel = val
  if val == oldVal or squad.Side ~= "player1" then
    return
  end
  if val then
    squad.water_travel_rest_timer = Game.CampaignTime
  elseif 0 < (squad.water_travel_rest_timer or 0) then
    local timePassed = Game.CampaignTime - squad.water_travel_rest_timer
    for i, u in ipairs(squad.units) do
      local ud = gv_UnitData[u]
      if timePassed >= const.Satellite.UnitTirednessRestTime then
        ud:SetTired(Max(ud.Tiredness - 1, 0))
      end
    end
    squad.water_travel_rest_timer = 0
  end
end
