if FirstLoad then
  g_ConflictSectors = false
end
function OnMsg.PreLoadSessionData()
  g_ConflictSectors = {}
  for id, sector in pairs(gv_Sectors) do
    if sector.conflict then
      g_ConflictSectors[#g_ConflictSectors + 1] = id
    end
  end
  table.sort(g_ConflictSectors)
end
function OnMsg.NewGame(game)
  g_ConflictSectors = {}
end
function IsConflictMode(sector_id)
  if sector_id then
    return not not table.find(g_ConflictSectors, sector_id), gv_Sectors[sector_id]
  else
    return #g_ConflictSectors > 0, gv_Sectors[g_ConflictSectors[1]]
  end
end
function AnyNonWaitingConflict()
  for i, sectorId in ipairs(g_ConflictSectors) do
    local sector = gv_Sectors[sectorId]
    if not sector.conflict.waiting then
      return sector
    end
  end
  return false
end
function GetConflictCustomDescr(sector)
  if not sector then
    return
  end
  local conflict = sector.conflict
  local preset = conflict and ConflictDescriptionDefs[conflict.descr_id or false]
  local custom = preset and preset.description
  if custom then
    return custom
  end
  if conflict and conflict.spawn_mode == "defend" then
    return T({
      129191214872,
      ConflictDescriptionDefs.DefaultDefend.description,
      sector
    })
  else
    return T({
      292704915698,
      ConflictDescriptionDefs.DefaultAttack.description,
      sector
    })
  end
end
function GetConflictCustomTitle(sector)
  if not sector then
    return
  end
  local conflict = sector.conflict
  local preset = conflict and ConflictDescriptionDefs[conflict.descr_id or false]
  local custom = preset and preset.title
  if custom then
    return custom
  end
  return T(829620197199, "ENEMY PRESENCE")
end
TFormat.SectorConflictCustomDescr = GetConflictCustomDescr
TFormat.GetConflictCustomTitle = GetConflictCustomTitle
function SatelliteRetreat(sector_id, sides_to_retreat)
  NetUpdateHash("SatelliteRetreat", sector_id)
  local sector = gv_Sectors[sector_id]
  if not sector.conflict then
    return
  end
  sides_to_retreat = sides_to_retreat or {"player1"}
  local previousSector = false
  local squadsToRetreat = {}
  for i, squad in ipairs(g_SquadsArray) do
    if not squad.militia and squad.CurrentSector == sector_id and IsSquadInConflict(squad) and table.find(sides_to_retreat, squad.Side) then
      squadsToRetreat[#squadsToRetreat + 1] = squad
      if squad.PreviousSector then
        previousSector = squad.PreviousSector
      end
    end
  end
  if previousSector then
    for i, squad in ipairs(squadsToRetreat) do
      if not squad.PreviousSector then
        squad.PreviousSector = previousSector
      end
    end
  end
  for i, squad in ipairs(squadsToRetreat) do
    local prev_sector_id = sector.conflict.player_attacking and sector.conflict.prev_sector_id or squad.PreviousSector
    if IsWaterSector(prev_sector_id) and squad.PreviousLandSector then
      prev_sector_id = squad.PreviousLandSector
    end
    if prev_sector_id then
      if IsSectorUnderground(sector_id) or IsSectorUnderground(prev_sector_id) then
        SetSatelliteSquadCurrentSector(squad, prev_sector_id)
      else
        do
          local badRetreat = false
          local otherSideSquads = (squad.Side == "enemy1" or squad.Side == "enemy2") and g_PlayerAndMilitiaSquads or g_EnemySquads
          for i, os in ipairs(otherSideSquads) do
            if os.CurrentSector == sector_id and os.route then
              local nextDest = os.route[1] and os.route[1][1]
              if nextDest == prev_sector_id then
                badRetreat = true
                break
              end
            end
          end
          local prevSector = gv_Sectors[prev_sector_id]
          local illegalRetreat = prevSector.Passability == "Water" or prevSector.Passability == "Blocked"
          badRetreat = badRetreat or illegalRetreat
          badRetreat = badRetreat or not not table.find(otherSideSquads, "CurrentSector", prev_sector_id)
          if badRetreat then
            local illegalRetreatFallback, foundSector = false, false
            ForEachSectorCardinal(sector_id, function(otherSecId)
              local considerThisSector = false
              local otherSec = gv_Sectors[otherSecId]
              if SideIsAlly(otherSec.Side, squad.Side) then
                considerThisSector = true
              elseif not table.find(otherSideSquads, "CurrentSector", otherSecId) then
                considerThisSector = true
              end
              local forbiddenRoute = IsRouteForbidden({
                {otherSecId}
              }, squad)
              if illegalRetreat and not illegalRetreatFallback and not forbiddenRoute then
                illegalRetreatFallback = otherSecId
              end
              if considerThisSector and not forbiddenRoute then
                foundSector = true
                prev_sector_id = otherSecId
                return "break"
              end
            end)
            if illegalRetreat and not foundSector and illegalRetreatFallback then
              prev_sector_id = illegalRetreatFallback
            end
          end
          local retreatRoute = GenerateRouteDijkstra(squad.CurrentSector, prev_sector_id, false, squad.units, "retreat", squad.CurrentSector, squad.side)
          retreatRoute = retreatRoute or {prev_sector_id}
          local keepJoining = false
          if squad.joining_squad then
            local squadToJoin = gv_Squads[squad.joining_squad]
            keepJoining = squadToJoin and squadToJoin.CurrentSector == prev_sector_id
          end
          SetSatelliteSquadRoute(squad, {retreatRoute}, keepJoining)
          squad.Retreat = true
        end
      end
    end
  end
  ResolveConflict(sector, "no voice", false, "retreat")
  ResumeCampaignTime("UI")
end
function NetSyncEvents.UISatelliteRetreat(sector_id, sides_to_retreat)
  SatelliteRetreat(sector_id, sides_to_retreat)
  local satCon = GetDialog("SatelliteConflict")
  if satCon then
    CloseDialog("SatelliteConflict")
  end
end
GameVar("ForceReloadSectorMap", false)
function EnterConflict(sector, prev_sector_id, spawn_mode, disable_travel, locked, descr_id, force, from_map)
  sector = sector or gv_Sectors[gv_CurrentSectorId]
  local sector_id = sector and sector.Id
  if not sector then
    return
  end
  local playerInvading = spawn_mode == "attack"
  if spawn_mode == "enemy_attack" then
    spawn_mode = "attack"
  end
  if IsConflictMode(sector_id) then
    if locked ~= nil then
      sector.conflict.locked = locked
    end
    if locked ~= nil then
      sector.conflict.descr_id = descr_id
    end
    if disable_travel ~= nil then
      sector.conflict.disable_travel = disable_travel
    end
    sector.conflict.prev_sector_id = prev_sector_id or sector.conflict.prev_sector_id
    if sector.conflict.waiting then
      sector.conflict.player_attacking = playerInvading
      sector.conflict.waiting = playerInvading or EnemyWantsToWait(sector_id)
      if sector.conflict.waiting then
        ResumeCampaignTime("SatelliteConflict")
      else
        PauseCampaignTime("SatelliteConflict")
      end
      if gv_SatelliteView then
        ObjModified(SelectedObj)
        ObjModified(Game)
        OpenSatelliteConflictDlg(sector)
        RequestAutosave({
          autosave_id = "satelliteConflict",
          save_state = "CombatStart",
          display_name = T({
            285747878633,
            "Satellite_Conflict_<u(sector)>",
            sector = sector.name
          }),
          mode = "delayed"
        })
      end
    end
    return
  end
  if force then
    sector.ForceConflict = true
  end
  table.insert(g_ConflictSectors, sector_id)
  table.sort(g_ConflictSectors)
  sector.conflict = {
    prev_sector_id = prev_sector_id or nil,
    spawn_mode = spawn_mode or nil,
    player_attacking = playerInvading,
    disable_travel = disable_travel or nil,
    locked = locked,
    descr_id = descr_id or sector.CustomConflictDescr or not playerInvading and "SectorAttacked",
    waiting = playerInvading or EnemyWantsToWait(sector_id),
    from_map = from_map
  }
  if InteractionSeeds then
    local prediction, player_power, enemy_power = GetAutoResolveOutcome(sector)
    sector.conflict.predicted_autoresolve = prediction
    sector.conflict.player_power = player_power
    sector.conflict.enemy_power = enemy_power
  end
  if sector.conflict_backup then
    local backupConflict = sector.conflict_backup
    local newConflict = sector.conflict
    newConflict.locked = backupConflict.locked
    newConflict.disable_travel = backupConflict.disable_travel
    newConflict.descr_id = backupConflict.descr_id
    newConflict.initial_sector = backupConflict.initial_sector
    sector.conflict_backup = false
  end
  Msg("ConflictStart", sector_id)
  local squads = GetSquadsInSectorCombined(sector_id, false, true)
  for i, squad in ipairs(squads) do
    SatelliteSquadWaitInSector(squad, false)
    if squad.route then
      squad.route.satellite_tick_passed = false
    end
    ObjModified(squad)
  end
  if gv_SatelliteView then
    OpenSatelliteConflictDlg(sector, "auto-open")
    RequestAutosave({
      autosave_id = "satelliteConflict",
      save_state = "CombatStart",
      display_name = T({
        285747878633,
        "Satellite_Conflict_<u(sector)>",
        sector = sector.name
      }),
      mode = "delayed"
    })
    if spawn_mode and sector_id == gv_CurrentSectorId then
      ForceReloadSectorMap = true
      ObjModified("gv_SatelliteView")
    end
    ObjModified(gv_Squads)
  end
  if not sector.conflict.waiting then
    PauseCampaignTime("SatelliteConflict")
  end
  UpdateEntranceAreasVisibility()
  ObjModified(SelectedObj)
  ObjModified(Game)
  ExecuteSectorEvents("SE_OnConflictStarted", sector_id)
end
function EnemyWantsToWait(sector)
  local enemySquadsEnroute = GetSquadsEnroute(sector, "enemy1")
  if #enemySquadsEnroute == 0 then
    return false
  end
  local waitTime = const.Satellite.EnemySquadWaitTime
  for i, s in ipairs(enemySquadsEnroute) do
    local estimatedTravelTime = GetTotalRouteTravelTime(s.CurrentSector, s.route, s)
    if waitTime > estimatedTravelTime then
      return true
    end
  end
  return false
end
function CanGoInMap(sector)
  sector = gv_Sectors[sector]
  if not sector.Map then
    return false
  end
  if not sector.conflict then
    return true
  end
  if not sector.conflict.waiting then
    return true
  end
  if sector.conflict.waiting then
    if sector.conflict.player_attacking then
      return true
    end
    return false, "enemy waiting"
  end
  return false
end
local lTravellingTowardsSectorCenter = function(sq, sector_id)
  return sq.route and sq.route[1] and #sq.route[1] > 0 and sq.route[1][1] == sector_id
end
function GetConflictSide(squad, sector_id)
  local player_squad = squad.Side == "player1" or squad.Side == "player2"
  local owningSide = gv_Sectors[sector_id].Side
  local sectorOwnedByPlayer = owningSide == "player1" or owningSide == "player2" or owningSide == "ally"
  if player_squad and not sectorOwnedByPlayer then
    return "attack"
  elseif not player_squad and not sectorOwnedByPlayer then
    return "enemy_attack"
  end
  return "defend"
end
local lGetSquadsForConflict = function(squad)
  local sector_id = squad.CurrentSector
  local sector = gv_Sectors[sector_id]
  local allySquads, enemySquads = GetSquadsInSector(sector_id, false, true, true)
  local enemiesForReal = {}
  for i, s in ipairs(enemySquads) do
    if s.Side == "enemy1" or s.Side == "enemy2" then
      enemiesForReal[#enemiesForReal + 1] = s
    end
  end
  enemySquads = enemiesForReal
  if 0 < #allySquads and 0 < #enemySquads then
    local travellingPlayer = false
    local travellingEnemy = false
    local nonTravellingPlayer = false
    local nonTravellingEnemy = false
    local nonRetreatingAlly = {}
    local nonRetreatingEnemy = {}
    for i, squad in ipairs(allySquads) do
      if (not squad.Retreat or SquadReachedDest(squad)) and not IsTraversingShortcut(squad) then
        nonRetreatingAlly[#nonRetreatingAlly + 1] = squad
      end
    end
    for i, squad in ipairs(enemySquads) do
      if (not squad.Retreat or SquadReachedDest(squad)) and not IsTraversingShortcut(squad) then
        nonRetreatingEnemy[#nonRetreatingEnemy + 1] = squad
      end
    end
    for i, squad in ipairs(nonRetreatingAlly) do
      local travelling = not IsSquadInSectorVisually(squad, sector_id)
      if travelling then
        travellingPlayer = true
      else
        nonTravellingPlayer = true
      end
    end
    for i, squad in ipairs(nonRetreatingEnemy) do
      local travelling = not IsSquadInSectorVisually(squad, sector_id)
      if travelling then
        travellingEnemy = true
      else
        nonTravellingEnemy = true
      end
    end
    local bothSidesTraveling = travellingEnemy and travellingPlayer
    local bothSidesInCenter = nonTravellingPlayer and nonTravellingEnemy
    local conflictWillHappen = bothSidesTraveling or bothSidesInCenter
    if sector.conflict and conflictWillHappen then
      conflictWillHappen = IsSquadInSectorVisually(squad, sector_id)
    end
    return conflictWillHappen, nonRetreatingAlly, nonRetreatingEnemy
  end
end
function CheckAndEnterConflict(sector, squad, prev_sector_id)
  local sector_id = sector.Id
  local conflictSide = GetConflictSide(squad, sector_id)
  if sector.Passability ~= "Water" then
    local conflictStart, playerSquads, enemySquads = lGetSquadsForConflict(squad)
    if conflictStart then
      for i = 1, #playerSquads + #enemySquads do
        local squad = i <= #playerSquads and playerSquads[i] or enemySquads[i - #playerSquads]
        if IsSquadTravelling(squad) then
          squad.route.satellite_tick_passed = false
          local movingToConflict = lTravellingTowardsSectorCenter(squad, sector_id)
          SatelliteReachSectorCenter(squad.UniqueId, sector_id, prev_sector_id, not movingToConflict, true)
        end
      end
      EnterConflict(sector, prev_sector_id, conflictSide)
    end
  end
  return conflictSide
end
function OnMsg.EnterSector(gameStart, gameLoaded)
  if gameLoaded then
    return
  end
  ForceReloadSectorMap = false
end
GameVar("SatQueuedResolveConflict", function()
  return {}
end)
function OnMsg.StartSatelliteGameplay()
  if not SatQueuedResolveConflict or #SatQueuedResolveConflict == 0 then
    return
  end
  for i, sId in ipairs(SatQueuedResolveConflict) do
    local sector = gv_Sectors[sId]
    if sector.conflict then
      AutoResolveConflict(sector)
    end
  end
  table.clear(SatQueuedResolveConflict)
end
function ResolveConflict(sector, bNoVoice, isAutoResolve, isRetreat)
  gv_ActiveCombat = false
  sector = sector or gv_Sectors[gv_CurrentSectorId]
  local mercSquads, enemySquads = GetSquadsInSector(sector.Id, "no_travel", false, "no_arriving", "no_retreat")
  local militiaLeft = GetMilitiaSquads(sector)
  if 0 < #militiaLeft and 0 < #enemySquads then
    if g_SatelliteUI then
      AutoResolveConflict(sector)
    elseif not table.find(SatQueuedResolveConflict, sector.Id) then
      SatQueuedResolveConflict[#SatQueuedResolveConflict + 1] = sector.Id
    end
    return
  end
  local playerAttacking = sector.conflict and sector.conflict.player_attacking
  local fromMap = sector.conflict and sector.conflict.from_map
  if sector then
    table.remove_value(g_ConflictSectors, sector.Id)
    sector.conflict = false
    if not g_Combat then
      ShowTacticalNotification("conflictResolved")
      PlayFX("NoEnemiesLeft", "start")
    end
  end
  if not AnyNonWaitingConflict() then
    ResumeCampaignTime("SatelliteConflict")
  end
  UpdateEntranceAreasVisibility()
  local squads = GetSquadsInSector(sector.Id)
  for i, squad in ipairs(squads) do
    ObjModified(squad)
  end
  ObjModified(SelectedObj)
  ObjModified("gv_SatelliteView")
  UpdateSectorControl(sector.Id)
  if (sector.Side == "player1" or sector.Side == "player2") and not gv_SatelliteView and #mercSquads == 0 then
    local playerUnitsOnMap = GetCurrentMapUnits("player")
    local enemyUnitsOnMap = GetCurrentMapUnits("enemy")
    if #playerUnitsOnMap == 0 and 0 < #enemyUnitsOnMap then
      local first = enemyUnitsOnMap[1]
      SatelliteSectorSetSide(sector.Id, "enemy1")
    end
  end
  local playerWon = not isRetreat and (sector.Side == "player1" or sector.Side == "player2")
  if playerWon then
    sector.CustomConflictDescr = false
    RollForMilitiaPromotion(sector)
  end
  Msg("ConflictEnd", sector, bNoVoice, playerAttacking, playerWon, isAutoResolve, isRetreat, fromMap)
end
function OnMsg.SquadDespawned(squad_id, sector_id)
  if gv_Sectors[sector_id].ForceConflict then
    return
  end
  UpdateSectorControl(sector_id)
end
function UpdateSectorControl(sector_id)
  if not sector_id then
    return
  end
  local allySquads, enemySquads = GetSquadsInSector(sector_id, "excludeTravel", "includeMilitia", "excludeArrive", "excludeRetreat")
  local playerHere = 0 < #allySquads
  local enemiesHere = false
  for _, squad in ipairs(enemySquads) do
    local all_dead = true
    for _, unit_id in ipairs(squad.units) do
      local unit = gv_SatelliteView and gv_UnitData[unit_id] or g_Units[unit_id]
      if unit and not unit:IsDead() then
        all_dead = false
        break
      end
    end
    enemiesHere = not all_dead and squad.Side
  end
  if enemiesHere and playerHere then
    return
  end
  if enemiesHere then
    SatelliteSectorSetSide(sector_id, enemiesHere)
  elseif playerHere then
    SatelliteSectorSetSide(sector_id, "player1")
  end
end
function NetEvents.ResolveConflict(sector, bNoVoice)
  ResolveConflict(gv_Sectors[sector], bNoVoice)
end
function GetSectorConflict(sector_id)
  local sector = gv_Sectors and gv_Sectors[sector_id or gv_CurrentSectorId]
  return sector and sector.conflict
end
local lCheckMapConflictResolved = function()
  local sector = gv_Sectors[gv_CurrentSectorId]
  local enemy_win = #GetCurrentMapUnits("player") == 0
  local enemy_units = GetCurrentMapUnits("enemy")
  local player_win = true
  for _, unit in ipairs(enemy_units) do
    player_win = player_win and not unit.Squad and not unit:IsAware()
  end
  if sector and sector.conflict and not sector.conflict.locked and (player_win or enemy_win) then
    sector.ForceConflict = false
    ResolveConflict()
  end
end
function OnMsg.CombatEnd(combat)
  if not combat.test_combat then
    lCheckMapConflictResolved()
  end
end
function OnMsg.UnitDied()
  if not g_Combat then
    lCheckMapConflictResolved()
  end
end
function OnMsg.VillainDefeated(unit)
  if not g_Combat then
    lCheckMapConflictResolved()
  end
end
function OnMsg.ExplorationTick()
  local sector = gv_Sectors[gv_CurrentSectorId]
  if not g_TestCombat and sector and sector.conflict and not sector.conflict.locked and not sector.ForceConflict then
    lCheckMapConflictResolved()
  end
end
local lTacticalModeCheckEnterConflict = function()
  if GameState.disable_tactical_conflict then
    return
  end
  if GameState.Conflict or not gv_ActiveCombat then
    return
  end
  for _, unit in ipairs(g_Units) do
    if unit:IsAware() then
      local unitSquad = unit.Squad
      unitSquad = unitSquad and gv_Squads[unitSquad]
      if (not unitSquad or not unitSquad.Retreat) and (not unitSquad or unitSquad.CurrentSector == gv_CurrentSectorId) then
        local enemies = GetAllEnemyUnits(unit)
        for _, enemy in ipairs(enemies) do
          if enemy:IsAware() then
            local enemySquad = enemy.Squad
            enemySquad = enemySquad and gv_Squads[enemySquad]
            if (not enemySquad or not enemySquad.Retreat) and (not enemySquad or enemySquad.CurrentSector == gv_CurrentSectorId) then
              local unitTeam = unit.team
              local enemyTeam = enemy.team
              if unitTeam and enemyTeam then
                local unitTeamSide, enemyTeamSide = unitTeam.side, enemyTeam.side
                local playerPresent = unitTeamSide == "player1" or unitTeamSide == "player2" or enemyTeamSide == "player1" or enemyTeamSide == "player2"
                local enemyPresent = unitTeamSide == "enemy1" or unitTeamSide == "enemy2" or enemyTeamSide == "enemy1" or enemyTeamSide == "enemy2"
                if playerPresent and enemyPresent then
                  EnterConflict(nil, nil, nil, nil, nil, nil, nil, "from_map")
                end
              end
            end
          end
        end
      end
    end
  end
end
OnMsg.CombatStart = lTacticalModeCheckEnterConflict
OnMsg.UnitAwarenessChanged = lTacticalModeCheckEnterConflict
function SatelliteConflictAppliedOnSector(sector)
  return gv_CurrentSectorId == (sector and sector.Id) and CanCloseSatelliteView()
end
GameVar("gv_AutoResolveUseOrdnance", false)
function GetPowerOfUnit(unit, noMods)
  if not unit then
    return 0
  end
  local power
  if IsMerc(unit) then
    power = const.AutoResolve.BaseMercPower * unit:GetLevel()
  elseif unit.Squad and gv_Squads[unit.Squad].militia or unit.militia then
    power = const.AutoResolve.BaseMilitiaPower * unit:GetLevel("baseLevel")
  else
    power = const.AutoResolve.BaseEnemyPower * unit:GetLevel("baseLevel")
  end
  power = MulDivRound(power, unit:GetProperty("unitPowerModifier"), 100)
  if noMods then
    return power
  end
  local modifier = 100
  local mod = MulDivRound(100, unit.HitPoints or unit.Health, unit:GetInitialMaxHitPoints()) - 100
  modifier = modifier + mod
  if IsMerc(unit) then
    if unit:HasStatusEffect("Tired") then
      modifier = modifier + const.AutoResolve.TiredMod
    end
    if unit:HasStatusEffect("Exhausted") then
      modifier = modifier + const.AutoResolve.ExhaustedMod
    end
    if unit:HasStatusEffect("WellRested") then
      modifier = modifier + const.AutoResolve.WellRestedMod
    end
    modifier = modifier + GetCombinedArmorPowerMod(unit)
    modifier = modifier + GetBestWeaponPowerMod(unit)
    if gv_AutoResolveUseOrdnance and CanUseOrdnancePower(unit) then
      modifier = modifier + const.AutoResolve.OrdnanceMod
    end
  end
  power = MulDivRound(power, modifier, 100)
  return power
end
function GetCombinedArmorPowerMod(unit)
  local mod = 0
  mod = mod + GetArmorPowerMod(unit:GetItemAtPos("Head", 1, 1))
  mod = mod + GetArmorPowerMod(unit:GetItemAtPos("Torso", 1, 1))
  mod = mod + GetArmorPowerMod(unit:GetItemAtPos("Legs", 1, 1))
  return mod
end
function GetArmorPowerMod(armor)
  if not armor then
    return 0
  end
  local maxMod = const.AutoResolve.MaxArmorMod
  local costCap = const.AutoResolve.MaxArmorModCost
  local mod = MulDivRound(maxMod, armor.Cost, costCap)
  mod = MulDivRound(mod, armor.Condition, 100)
  return mod
end
function GetBestWeaponPowerMod(unit)
  local items = unit:GetHandheldItems()
  local mods = {}
  for _, item in ipairs(items) do
    mods[#mods + 1] = GetWeaponPowerMod(unit, item)
  end
  table.sort(mods)
  return mods[#mods] or 0
end
function GetWeaponPowerMod(unit, weapon)
  if not weapon or not IsKindOfClasses(weapon, "Firearm", "MeleeWeapon") then
    return 0
  end
  if IsKindOf(weapon, "MeleeWeapon") and unit.Strength + Unit.Dexterity < const.AutoResolve.MeleeRequiredStats then
    return 0
  end
  if IsKindOf(weapon, "Firearm") and #unit:GetAvailableAmmos(weapon) < 1 then
    return 0
  end
  local maxMod = const.AutoResolve.MaxWeaponMod
  local costCap = const.AutoResolve.MaxWeaponModCost
  local mod = MulDivRound(maxMod, weapon.Cost, costCap)
  mod = MulDivRound(mod, weapon.Condition, 100)
  return mod
end
function CanUseOrdnancePower(unit)
  local items = unit:GetHandheldItems()
  for _, item in ipairs(items) do
    if IsKindOf(item, "Grenade") then
      return true
    elseif IsKindOf(item, "HeavyWeapon") and item.ammo and item.ammo.Amount > 0 then
      return true
    end
  end
  return false
end
function GetSideLeaderMod(units)
  local mod = 0
  local maxMod = const.AutoResolve.MaxLeaderMod
  local minLeadership = const.AutoResolve.MinLeadershipRequired
  local highestLeadership = 0
  for _, unit in ipairs(units) do
    if highestLeadership < unit.Leadership then
      highestLeadership = unit.Leadership
    end
  end
  local mod = Max(highestLeadership - minLeadership, 0)
  mod = MulDivRound(maxMod, mod, minLeadership)
  return mod
end
function GetSideMedicMod(units)
  local mod = 0
  local minMedical = const.AutoResolve.MinMedicalRequired
  local medics = 0
  for _, unit in ipairs(units) do
    if minMedical <= unit.Medical and GetUnitEquippedMedicine(unit) then
      medics = medics + 1
    end
  end
  if medics == 0 then
    mod = const.AutoResolve.NoMedicsMod
  elseif medics == 1 then
    mod = 0
  else
    mod = const.AutoResolve.EnoughMedicsMod
  end
  return mod
end
function GetSquadPower(squad)
  local power = 0
  if squad.units then
    for _, id in ipairs(squad.units) do
      local unit = gv_UnitData[id]
      power = power + GetPowerOfUnit(unit)
    end
  end
  return power
end
function GetMultipleSquadsPower(squads)
  local power = 0
  for _, squad in ipairs(squads) do
    power = power + GetSquadPower(squad)
  end
  return power
end
function GetSectorPowersInConflict(sector, playerSquads, enemySquads, disableRandomMod)
  if not playerSquads or not enemySquads then
    local playerSquads, enemySquads = GetSquadsInSector(sector.Id, "excludeTravelling", "includeMilitia", "excludeArriving")
  end
  local playerPower = GetMultipleSquadsPower(playerSquads)
  local enemyPower = GetMultipleSquadsPower(enemySquads)
  local playerUnits = GetUnitsFromSquads(playerSquads, "getUnitData")
  local enemyUnits = GetUnitsFromSquads(enemySquads, "getUnitData")
  local playerMod = 100
  local enemyMod = 100
  local militiaOnlyTeam = true
  for _, unit in ipairs(playerUnits) do
    if IsMerc(unit) then
      militiaOnlyTeam = false
      break
    end
  end
  if not militiaOnlyTeam then
    playerMod = playerMod + GetSideLeaderMod(playerUnits)
    playerMod = playerMod + GetSideMedicMod(playerUnits)
    if #playerUnits >= #enemyUnits * 2 then
      playerMod = playerMod + const.AutoResolve.NumericalAdvantageMod
    elseif #enemyUnits >= #playerUnits * 2 then
      playerMod = playerMod - const.AutoResolve.NumericalAdvantageMod
    end
  end
  if sector.conflict and not disableRandomMod then
    local attackerMod = const.AutoResolve.AttackerRandomMod
    attackerMod = InteractionRandRange(-attackerMod, attackerMod, "AutoResolve")
    if sector.conflict.spawn_mode == "attack" then
      playerMod = playerMod + attackerMod
    else
      enemyMod = enemyMod + attackerMod
    end
  end
  playerPower = MulDivRound(playerPower, playerMod, 100)
  enemyPower = MulDivRound(enemyPower, enemyMod, 100)
  if sector.conflict then
    local bonus = sector.AutoResolveDefenderBonus
    if sector.conflict.spawn_mode == "attack" then
      playerPower = playerPower + bonus
    else
      enemyPower = enemyPower + bonus
    end
  end
  return playerPower, enemyPower, playerMod
end
function GetAutoResolveOutcome(sector, disableRandomMod)
  local playerSquads, enemySquads = GetSquadsInSector(sector.Id, "excludeTravelling", "includeMilitia", "excludeArriving", "excludeRetreat")
  local playerPower, enemyPower, playerMod = GetSectorPowersInConflict(sector, playerSquads, enemySquads, disableRandomMod)
  if CheatEnabled("AutoResolve") then
    return "decisive_win", playerPower, enemyPower, playerMod
  end
  if playerPower > 2 * enemyPower then
    return "decisive_win", playerPower, enemyPower, playerMod
  elseif enemyPower <= playerPower then
    return "win", playerPower, enemyPower, playerMod
  elseif enemyPower > 2 * playerPower then
    return "crushing_defeat", playerPower, enemyPower, playerMod
  else
    return "defeat", playerPower, enemyPower, playerMod
  end
end
MapVar("g_AccumulatedTeamXP", false)
function LogAccumulatedTeamXP(actor)
  if g_AccumulatedTeamXP then
    local log_msg
    for _, unit in ipairs(table.keys(g_AccumulatedTeamXP, "sorted")) do
      log_msg = log_msg or {
        T(280141508210, "Gained XP:")
      }
      log_msg[#log_msg + 1] = T({
        547096297080,
        " <unit>(<em><gain></em>)",
        unit = unit,
        gain = g_AccumulatedTeamXP[unit]
      })
    end
    if next(log_msg) then
      CombatLog(actor, table.concat(log_msg))
    end
  end
  g_AccumulatedTeamXP = false
end
function CalculateAutoResolveUnitDamage(unit, outcome, side)
  local injuryChances = {
    decisive_win = {
      seriousInjury = const.AutoResolveDamage.DecisiveWinSeriousInjuryChance,
      injury = const.AutoResolveDamage.DecisiveWinInjuryChance
    },
    win = {
      seriousInjury = const.AutoResolveDamage.WinSeriousInjuryChance,
      injury = const.AutoResolveDamage.WinInjuryChance
    },
    defeat = {
      seriousInjury = const.AutoResolveDamage.DefeatSeriousInjuryChance,
      injury = const.AutoResolveDamage.DefeatInjuryChance
    },
    crushing_defeat = {
      seriousInjury = const.AutoResolveDamage.CrushingDefeatSeriousInjuryChance,
      injury = const.AutoResolveDamage.CrushingDefeatInjuryChance
    }
  }
  local militiaInjuryChanceMod = 0
  if side == "enemy" then
    local bonus = GameDifficulties[Game.game_difficulty]:ResolveValue("autoResolveInjuryChanceEnemyBonus") or 0
    injuryChances.decisive_win.injury = injuryChances.decisive_win.injury + bonus
    injuryChances.win.seriousInjury = injuryChances.win.seriousInjury + bonus
    injuryChances.win.injury = injuryChances.win.injury + bonus
    injuryChances.defeat.seriousInjury = injuryChances.defeat.seriousInjury + bonus
    injuryChances.crushing_defeat.seriousInjury = injuryChances.crushing_defeat.seriousInjury + bonus
  elseif side == "militia" then
    militiaInjuryChanceMod = const.AutoResolveDamage.MilitiaInjuryAdditiveMod
  end
  local percChangePerDiff = 100
  if side == "enemy" then
  elseif side == "player" then
  end
  local injuryDamage = MulDivRound(const.AutoResolveDamage.InjuryBaseDamage, percChangePerDiff, 100)
  local injuryRandomDamage = MulDivRound(const.AutoResolveDamage.InjuryRandomDamage, percChangePerDiff, 100)
  local seriousInjuryDamage = MulDivRound(const.AutoResolveDamage.SeriousInjuryBaseDamage, percChangePerDiff, 100)
  local seriousInjuryRandomDamage = MulDivRound(const.AutoResolveDamage.SeriousInjuryRandomDamage, percChangePerDiff, 100)
  local damage = 0
  local injury = false
  local injuryRoll = InteractionRand(100, "DamageOnAutoResolve") + 1
  if injuryRoll <= injuryChances[outcome].seriousInjury + militiaInjuryChanceMod then
    damage = seriousInjuryDamage + InteractionRand(seriousInjuryRandomDamage, "DamageOnAutoResolve") + InteractionRand(seriousInjuryRandomDamage, "DamageOnAutoResolve")
    injury = "seriousInjury"
  elseif injuryRoll <= injuryChances[outcome].injury + militiaInjuryChanceMod then
    damage = injuryDamage + InteractionRand(injuryRandomDamage, "DamageOnAutoResolve")
    injury = "injury"
  end
  return damage, injury
end
function AutoResolveUseMeds(playerSquads)
  local bestMedic = false
  local medkit = false
  for _, squad in ipairs(playerSquads) do
    for _, id in ipairs(squad.units) do
      local unit = gv_UnitData[id]
      local umedkit = GetUnitEquippedMedicine(unit)
      if umedkit and (not bestMedic or bestMedic.Medical < unit.Medical) then
        bestMedic = unit
        medkit = umedkit
      end
    end
  end
  if bestMedic then
    for _, squad in ipairs(playerSquads) do
      for _, id in ipairs(squad.units) do
        local unit = gv_UnitData[id]
        unit:GetBandaged(medkit, bestMedic)
      end
    end
  end
end
function AutoResolveUseAmmo(playerSquads, damageDone)
  local damageToUseAmmo = const.AutoResolveResources.DamageToAmmo
  local playerUnitsCount = CountUnitsInSquads(playerSquads)
  local baseAmmoUsagePerUnit = DivRound(damageDone, damageToUseAmmo * playerUnitsCount)
  local TakeItemAmount = function(item, amount, container, slot)
    local used = Min(item.Amount, amount)
    item.Amount = item.Amount - used
    if item.Amount <= 0 then
      if slot then
        container:RemoveItem(slot, item, "no_update")
      elseif container then
        table.remove_entry(container, item)
      end
      DoneObject(item)
    end
    return used
  end
  for _, squad in ipairs(playerSquads) do
    for _, id in ipairs(squad.units) do
      local unit = gv_UnitData[id]
      local ammoRandMult = InteractionRand(50, "AutoResolveAmmo")
      local ammoToUse = MulDivRound(baseAmmoUsagePerUnit, 100 + ammoRandMult, 100)
      local handeldItems, handeldItemsSlots = unit:GetHandheldItems()
      if gv_AutoResolveUseOrdnance then
        local allowedOrdnance = 1 + InteractionRand(const.AutoResolveResources.MaxOrdnanceUsed, "AutoResolveAmmo")
        local ordnanceToAmmoMult = 3
        for i, item in ipairs(handeldItems) do
          if ammoToUse <= 0 or allowedOrdnance <= 0 then
            break
          end
          if IsKindOf(item, "Grenade") then
            local used = TakeItemAmount(item, allowedOrdnance, unit, handeldItemsSlots[i])
            allowedOrdnance = allowedOrdnance - used
            ammoToUse = ammoToUse - used * ordnanceToAmmoMult
          elseif IsKindOf(item, "HeavyWeapon") then
            local degrade = -item:GetBaseDegradePerShot()
            local ammos, containers, slots = unit:GetAvailableAmmos(item)
            for j, ammo in ipairs(ammos) do
              local used = TakeItemAmount(ammo, allowedOrdnance, containers[j], slots[j])
              allowedOrdnance = allowedOrdnance - used
              ammoToUse = ammoToUse - used * ordnanceToAmmoMult
              unit:ItemModifyCondition(item, degrade * used)
            end
            if 0 < allowedOrdnance and 0 < ammoToUse and item.ammo then
              local used = TakeItemAmount(item.ammo, allowedOrdnance)
              allowedOrdnance = allowedOrdnance - used
              ammoToUse = ammoToUse - used * ordnanceToAmmoMult
              unit:ItemModifyCondition(item, degrade * used)
            end
          end
        end
      end
      for _, item in ipairs(handeldItems) do
        if ammoToUse <= 0 then
          break
        end
        if IsKindOf(item, "Firearm") then
          local degrade = -item:GetBaseDegradePerShot()
          local ammos, containers, slots = unit:GetAvailableAmmos(item)
          for j, ammo in ipairs(ammos) do
            local used = TakeItemAmount(ammo, ammoToUse, containers[j], slots[j])
            ammoToUse = ammoToUse - used
            unit:ItemModifyCondition(item, degrade * used)
          end
          if 0 < ammoToUse and item.ammo then
            local used = TakeItemAmount(item.ammo, ammoToUse)
            ammoToUse = ammoToUse - used
            unit:ItemModifyCondition(item, degrade * used)
          end
        end
      end
    end
  end
end
function AutoResolveArmorDegradation(unit, injury)
  if not unit or not injury then
    return
  end
  local armorPieces = {}
  armorPieces[#armorPieces + 1] = unit:GetItemAtPos("Head", 1, 1)
  armorPieces[#armorPieces + 1] = unit:GetItemAtPos("Torso", 1, 1)
  armorPieces[#armorPieces + 1] = unit:GetItemAtPos("Legs", 1, 1)
  local times = injury == "seriousInjury" and const.AutoResolveResources.ArmorDegradationTimesSeriousInjury or const.AutoResolveResources.ArmorDegradationTimesInjury
  for i = 1, times do
    if #armorPieces == 0 then
      return
    end
    local idx = InteractionRand(#armorPieces, "AutoResolveArmor") + 1
    local item = armorPieces[idx]
    unit:ItemModifyCondition(item, -item.Degradation)
    if 0 >= item.Condition then
      table.remove(armorPieces, idx)
    end
  end
end
function ApplyAutoResolveOutcome(sector, playerOutcome)
  local playerWins = IsOutcomeWin(playerOutcome)
  local enemyOutcome = GetOppositeOutcome(playerOutcome)
  local playerSquads, enemySquads = GetSquadsInSector(sector.Id, "excludeTravelling", false, "excludeArriving", "excludeRetreating")
  local items = {}
  local militiaSquads = GetMilitiaSquads(sector)
  local militiaUnitsCount = CountUnitsInSquads(militiaSquads)
  local militiaKilled = 0
  for i = #militiaSquads, 1, -1 do
    local squad = militiaSquads[i]
    for j = #squad.units, 1, -1 do
      local id = squad.units[j]
      local unit = gv_UnitData[id]
      local damage = 0
      if not playerWins then
        damage = unit.HitPoints
      else
        local deathRoll = InteractionRand(100, "AutoResolve")
        local deathChance = playerOutcome == "decisive_win" and const.AutoResolveDamage.NPCDeathChanceOnDecisiveWin or const.AutoResolveDamage.NPCDeathChanceOnWin
        if deathRoll < deathChance then
          damage = unit.HitPoints
        else
          damage = CalculateAutoResolveUnitDamage(unit, playerOutcome, "militia")
          local militiaDamageMultiplier = const.AutoResolveDamage.MilitiaDamageTakenMod
          damage = MulDivRound(damage, 100 + militiaDamageMultiplier, 100)
        end
      end
      unit.HitPoints = Max(unit.HitPoints - damage, 0)
      unit:AccumulateDamageTaken(damage)
      if playerWins and #playerSquads <= 0 and militiaKilled == militiaUnitsCount - 1 then
        unit.HitPoints = 1
      end
      if 0 >= unit.HitPoints then
        militiaKilled = militiaKilled + 1
        unit:Die()
        Unit.DropLoot(unit)
        if playerWins then
          unit:ForEachItem(function(item, slot_name, left, top, items)
            items[#items + 1] = item
            unit:RemoveItem(slot_name, item)
          end, items)
        end
      end
    end
  end
  g_AccumulatedTeamXP = {}
  local totalDamageToEnemy = 0
  for i = #enemySquads, 1, -1 do
    for j = #enemySquads[i].units, 1, -1 do
      local id = enemySquads[i].units[j]
      local unit = gv_UnitData[id]
      local damage = 0
      if playerWins then
        damage = unit.HitPoints
      else
        local deathRoll = InteractionRand(100, "AutoResolve")
        local deathChance = enemyOutcome == "decisive_win" and const.AutoResolveDamage.NPCDeathChanceOnDecisiveWin or const.AutoResolveDamage.NPCDeathChanceOnWin
        if deathRoll < deathChance then
          damage = unit.HitPoints
        else
          damage = CalculateAutoResolveUnitDamage(unit, enemyOutcome, "enemy")
        end
      end
      unit.HitPoints = Max(unit.HitPoints - damage, 0)
      if unit.villain then
        unit.HitPoints = 1
      end
      if 0 >= unit.HitPoints then
        unit:Die()
      end
      totalDamageToEnemy = totalDamageToEnemy + damage
      if playerWins then
        Unit.DropLoot(unit)
        unit:ForEachItem(function(item, slot_name, left, top, items)
          items[#items + 1] = item
          unit:RemoveItem(slot_name, item)
        end, items)
      end
    end
  end
  if 0 < #playerSquads then
    AutoResolveUseAmmo(playerSquads, totalDamageToEnemy)
  end
  local playerUnitsCount = CountUnitsInSquads(playerSquads)
  local mercsKilled = 0
  for i = #playerSquads, 1, -1 do
    local squad = playerSquads[i]
    for j = #squad.units, 1, -1 do
      local id = squad.units[j]
      local unit = gv_UnitData[id]
      local damage = 0
      local injury
      damage, injury = CalculateAutoResolveUnitDamage(unit, playerOutcome, "player")
      if injury then
        AutoResolveArmorDegradation(unit, injury)
      end
      if injury == "seriousInjury" and 1 > unit.Tiredness then
        unit:SetTired(unit.Tiredness + 1)
      end
      unit.HitPoints = Max(unit.HitPoints - damage, 0)
      unit:AccumulateDamageTaken(damage)
      if playerWins and mercsKilled == playerUnitsCount - 1 then
        unit.HitPoints = 1
      end
      if 0 >= unit.HitPoints then
        mercsKilled = mercsKilled + 1
        unit:Die()
      end
    end
  end
  if 0 < #items then
    SortItemsArray(items)
  end
  LogAccumulatedTeamXP("short")
  return items
end
function IsOutcomeWin(outcome)
  return outcome == "decisive_win" or outcome == "win"
end
function GetOppositeOutcome(outcome)
  if outcome == "decisive_win" then
    return "crushing_defeat"
  end
  if outcome == "win" then
    return "defeat"
  end
  if outcome == "defeat" then
    return "win"
  end
  if outcome == "crushing_defeat" then
    return "decisive_win"
  end
end
function NetEvents.CloseOtherGuysAutoResolveResultsUI()
  local dlg = GetDialog("SatelliteConflict")
  if dlg then
    dlg:Close()
  end
end
local RecalcNames = function(sector, oldAllySquads)
  for _, squad in ipairs(oldAllySquads) do
    local squadUnits = table.copy(squad.units)
    for id, unitId in ipairs(squadUnits) do
      if not gv_UnitData[unitId] then
        table.remove(squad.units, table.find(squad.units, unitId))
        squad.units.templateNames[unitId] = nil
      end
    end
  end
  local allySquads = GetGroupedSquads(sector.Id, true, true, false, "no_retreating")
  for i, s in ipairs(allySquads) do
    for i, u in ipairs(s.units) do
      local unitData = gv_UnitData[u]
      local squad, idx = table.find_value(oldAllySquads, "UniqueId", s.UniqueId)
      if squad and not squad.units.templateNames[u] then
        oldAllySquads[idx].units.templateNames[u] = unitData.class
        table.insert(squad.units, unitData.session_id)
      end
    end
  end
  return oldAllySquads
end
function AutoResolveConflict(sector)
  local player_outcome = GetAutoResolveOutcome(sector)
  local player_wins = IsOutcomeWin(player_outcome)
  local allySquads = GetGroupedSquads(sector.Id, "includeMilitia", "merge-joining", false, "no_retreating", "exclude_travelling")
  local enemySquads = GetGroupedSquads(sector.Id, false, false, "get_enemies", "no_retreating", "exclude_travelling")
  local templateNames = {}
  for i, s in ipairs(allySquads) do
    for i, u in ipairs(s.units) do
      local unitData = gv_UnitData[u]
      templateNames[u] = unitData.class
    end
    s.units.templateNames = templateNames
    s.ref = false
    templateNames = {}
  end
  for i, s in ipairs(enemySquads) do
    for i, u in ipairs(s.units) do
      templateNames[u] = gv_UnitData[u].class
    end
    s.units.templateNames = templateNames
    s.ref = false
    templateNames = {}
  end
  local loot = ApplyAutoResolveOutcome(sector, player_outcome)
  if sector.Id == gv_CurrentSectorId and not ForceReloadSectorMap then
    LocalCheckUnitsMapPresence()
    SyncUnitProperties("session")
  end
  local playerSquads = GetSquadsInSector(sector.Id, "excludeTravelling", false, "excludeArriving", "excludeRetreating")
  local first_alive_merc
  for _, squad in ipairs(playerSquads) do
    for _, id in ipairs(squad.units) do
      local unit = gv_UnitData[id]
      if unit.Squad and unit.HireStatus ~= "Dead" then
        first_alive_merc = unit
        break
      end
    end
    if first_alive_merc then
      break
    end
  end
  local playerPower, enemyPower, playerMod = GetSectorPowersInConflict(sector, allySquads, enemySquads, "disableRandomMod")
  allySquads.power = playerPower
  allySquads.playerMod = playerMod
  enemySquads.power = enemyPower
  local items = table.copy(loot)
  AddItemsToInventory(GetSectorInventory(sector.Id), items)
  PauseCampaignTime("SatelliteConflictOutcome")
  if player_wins then
    sector.ForceConflict = false
    ResolveConflict(sector, nil, "auto-resolve", nil)
  elseif first_alive_merc then
    SatelliteRetreat(sector.Id)
  else
    ResolveConflict(sector, "no voice", "auto-resolve", nil)
    ResumeCampaignTime("UI")
  end
  allySquads = RecalcNames(sector, allySquads)
  OpenSatelliteConflictDlg({
    player_outcome = player_outcome,
    allySquads = allySquads,
    enemySquads = enemySquads,
    sector = sector,
    loot = loot,
    first_alive_merc = first_alive_merc,
    autoResolve = true
  })
  ResumeCampaignTime("SatelliteConflictOutcome")
  ObjModified("sector_selection_changed")
  ObjModified("sector_selection_changed_actions")
  Msg("AutoResolvedConflict", sector.Id, player_outcome)
end
function NetSyncEvents.UIAutoResolveConflict(sector_id, ordenance)
  local sector = gv_Sectors[sector_id]
  if not sector.conflict then
    return
  end
  local old = gv_AutoResolveUseOrdnance
  gv_AutoResolveUseOrdnance = ordenance
  AutoResolveConflict(sector)
  gv_AutoResolveUseOrdnance = old
  local dlg = GetDialog("SatelliteConflict")
  if dlg then
    dlg:Close()
  end
end
function TFormat.AutoResolveOutcomeText(context_obj, status)
  if status == "decisive_win" then
    return T(907277131281, "DECISIVE WIN")
  elseif status == "win" then
    return T(561227589007, "VICTORY")
  elseif status == "defeat" then
    return T(979864159307, "DEFEAT")
  elseif status == "crushing_defeat" then
    return T(912438837574, "CRUSHING DEFEAT")
  end
end
function RollForMilitiaPromotion(sector)
  local squads = GetMilitiaSquads(sector)
  local promotedCount = 0
  for _, squad in ipairs(squads) do
    local unitIds = table.copy(squad.units)
    for _, id in ipairs(unitIds) do
      local unitData = gv_UnitData[id]
      local chance = 30
      local roll = InteractionRand(100, "MilitiaPromotion")
      if chance > roll then
        if unitData.class == "MilitiaRookie" then
          CreateMilitiaUnitData("MilitiaVeteran", sector, squad)
          DeleteMilitiaUnitData(unitData.session_id, squad)
          promotedCount = promotedCount + 1
        elseif unitData.class == "MilitiaVeteran" then
          CreateMilitiaUnitData("MilitiaElite", sector, squad)
          DeleteMilitiaUnitData(unitData.session_id, squad)
          promotedCount = promotedCount + 1
        end
      end
    end
  end
  if 0 < promotedCount then
    if 1 < promotedCount then
      CombatLog("important", T({
        293615811082,
        "<promotedCount> militia got promoted in <SectorName(sectorId)>",
        promotedCount = promotedCount,
        sectorId = sector.Id
      }))
    else
      CombatLog("important", T({
        488327770041,
        "A militia unit got promoted in <SectorName(sectorId)>",
        promotedCount = promotedCount,
        sectorId = sector.Id
      }))
    end
  end
end
function ModifySectorEnemySquads(sector_id, value, valueType, class)
  if value == 0 then
    return
  end
  valueType = valueType or "percent"
  local squads = {}
  local mercs, mercsPerSquad = {}, {}
  local enemySquads = GetSectorSquadsFromSide(sector_id, "enemy1", "enemy2")
  for i, squad in ipairs(enemySquads) do
    if not squad.villain and not squad.guardpost then
      for _, merc in ipairs(squad.units) do
        local unit = gv_UnitData[merc]
        if not (class or unit.villain or unit:HasItem("DiamondBriefcase")) or unit.class == class then
          mercs[#mercs + 1] = merc
          if not mercsPerSquad[squad] then
            mercsPerSquad[squad] = {}
          end
          mercsPerSquad[squad][#mercsPerSquad + 1] = merc
        end
      end
      if EnemySquadDefs[squad.enemy_squad_def] then
        squads[#squads + 1] = squad
      end
    end
  end
  if value < 0 then
    value = abs(value)
    local removeAll = valueType == "percent" and value == 100 or valueType == "count" and value == #mercs
    if removeAll then
      for _, merc in ipairs(mercs) do
        RemoveUnitFromSquad(gv_UnitData[merc], "despawn")
      end
    else
      local count = valueType == "count" and value or MulDivRound(value, #mercs, 100)
      count = Max(count, 1)
      for i = 1, Min(count, #mercs) do
        local merc, idx = table.interaction_rand(mercs, "SectorEnemySquads")
        table.remove(mercs, idx)
        RemoveUnitFromSquad(gv_UnitData[merc], "despawn")
      end
    end
  else
    for _, squad in ipairs(squads) do
      local count = valueType == "count" and value or MulDivRound(value, #mercsPerSquad[squad], 100)
      count = Max(count, 1)
      local units_to_create = {}
      if class then
        for i = 1, count do
          units_to_create[i] = class
        end
      else
        while 0 < count do
          local unit_template_ids = GenerateRandEnemySquadUnits(squad.enemy_squad_def)
          if #unit_template_ids == 0 then
            break
          end
          local all = #unit_template_ids
          for i = 1, all do
            local id, idx = table.interaction_rand(unit_template_ids, "SectorEnemySquads")
            units_to_create[#units_to_create + 1] = id
            table.remove(unit_template_ids, idx)
            count = count - 1
            if count == 0 then
              break
            end
          end
        end
      end
      local new_units = GenerateUnitsFromTemplates(squad.CurrentSector, units_to_create, "ModifyEffect")
      AddUnitsToSquad(squad, new_units)
    end
  end
  if not gv_SatelliteView and sector_id == gv_CurrentSectorId then
    LocalCheckUnitsMapPresence()
  end
end
DefineClass.SatelliteConflictUIMercsDisplay = {
  __parents = {
    "XContextWindow"
  },
  GridWidth = 2,
  LayoutMethod = "Vlist",
  LayoutVSpacing = 10,
  MinHeight = 330,
  MaxHeight = 450,
  properties = {
    {
      category = "MercDisplay",
      id = "headerText",
      name = "Header Name",
      editor = "text",
      default = "",
      translate = true
    },
    {
      category = "MercDisplay",
      id = "subheaderText",
      name = "Subheader",
      editor = "text",
      default = "",
      translate = true
    },
    {
      category = "MercDisplay",
      id = "showEnroute",
      name = "ShowEnroute",
      editor = "bool",
      default = ""
    },
    {
      category = "MercDisplay",
      id = "align",
      name = "Align",
      editor = "choice",
      items = {"left", "right"},
      default = "left"
    }
  }
}
function SatelliteConflictUIMercsDisplay:Open()
  self.idHeaderTitle:SetText(self.headerText)
  self.idSubHeaderText:SetText(self.subheaderText)
  XContextWindow.Open(self)
  if self.align == "right" then
    self.idHeader:SetHAlign("left")
    self.idHeaderTitle:SetHAlign("left")
    self.idHeaderLine:SetHAlign("left")
    self.idSubHeader:SetHAlign("left")
    local margins = self.idHeader.Margins
    self.idHeader:SetMargins(box(margins:maxx(), margins:miny(), margins:minx(), margins:maxy()))
    local paddings = self.idMercs.Padding
    self.idMercs:SetPadding(box(paddings:maxx(), paddings:miny(), paddings:minx(), paddings:maxy()))
    for i, s in ipairs(self.idMercs) do
      s:SetHAlign("left")
      if rawget(s, "idMercContainer") then
        s.idMercContainer:SetHAlign("left")
      end
      s:SetMargins(box(20, 0, 0, 0))
    end
  end
end
function SatelliteConflictUIMercsDisplay:GetMercUnitData(context)
  if context.UniqueId then
    return GetMercArrayUnitData(context.units) or {}
  else
    if not context.units or #context.units == 0 then
      return false
    end
    return table.imap(context.units, function(o)
      local propObj = ResolvePropObj(o) or o
      if IsKindOf(propObj, "UnitData") then
        return o
      end
      return SubContext(o.template, o)
    end)
  end
end
function SatelliteConflictUIMercsDisplay:SplitMercsIntoSquads(context)
  if not context.units then
    return {context}
  end
  local maxPeopleInSquad = const.Satellite.MercSquadMaxPeople
  local squadCount = maxPeopleInSquad < #context.units and MulDivRound(#context.units, 1000, maxPeopleInSquad * 1000) or 1
  local squads = {}
  for i = 0, squadCount - 1 do
    local units = {}
    local startIdx = maxPeopleInSquad * i + 1
    for m = startIdx, Min(startIdx + maxPeopleInSquad - 1, #context.units) do
      units[#units + 1] = context.units[m]
    end
    squads[i + 1] = {units = units}
  end
  return squads
end
GameVar("LostLoyaltyWithSectorsThisTick", false)
function OnMsg.SatelliteTick()
  LostLoyaltyWithSectorsThisTick = false
end
function GetLoyaltyCityNearby(sector, filter)
  if filter == "center_only" then
    local s = gv_Sectors[sector.Id]
    local city = s and s.City
    if city and city ~= "none" then
      return city
    else
      return
    end
  end
  local city = gv_Sectors[sector.Id].City
  if not filter and city and city ~= "none" then
    return city
  end
  city = nil
  ForEachSectorAround(sector.Id, 1, function(sector_id)
    if filter == "adjacent_only" and sector_id == sector.Id then
      return
    end
    local s = gv_Sectors[sector_id]
    if s and s.City and s.City ~= "none" then
      city = s.City
      return "break"
    end
  end)
  return city
end
function OnMsg.SectorSideChanged(sector_id, oldSide, newSide)
  if oldSide == "player1" and newSide == "enemy1" then
    if LostLoyaltyWithSectorsThisTick and LostLoyaltyWithSectorsThisTick[sector_id] then
      return
    end
    local sector = gv_Sectors[sector_id]
    if sector.conflict then
      return
    end
    local city = GetLoyaltyCityNearby(sector, "center_only")
    CityModifyLoyalty(city, const.Loyalty.CitySectorEnemyTakeOverLoyaltyLoss, T(171133072609, "City Lost"))
  end
end
function CivilianDeathPenalty()
  local penaltyAmount = const.Loyalty.CivilianDeathPenalty
  local penaltyCap = const.Loyalty.CivilianDeathPenaltyCityCap
  local currentSector = gv_Sectors[gv_CurrentSectorId]
  local cityId = currentSector and GetLoyaltyCityNearby(currentSector)
  local city = gv_Cities[cityId]
  if not city then
    return
  end
  if penaltyCap < city.currentCivilianDeathPenalty + penaltyAmount then
    penaltyAmount = penaltyCap - city.currentCivilianDeathPenalty
  end
  if city.Loyalty - penaltyAmount < 0 then
    penaltyAmount = city.Loyalty
  end
  local oldLoyalty = city.Loyalty
  CityModifyLoyalty(cityId, -penaltyAmount, T(938505306538, "Civilian death penalty"))
  if oldLoyalty > city.Loyalty then
    city.currentCivilianDeathPenalty = city.currentCivilianDeathPenalty + penaltyAmount
  end
end
function OnMsg.SectorSideChanged(sector_id, oldSide, newSide)
  if oldSide == "player1" and newSide == "enemy1" then
    local sector = gv_Sectors[sector_id]
    sector.conflictLoyaltyGained = false
  end
end
function OnMsg.ConflictEnd(sector, _, playerAttacked, playerWon, autoResolve, isRetreat, startedFromMap)
  local allySquads = GetGroupedSquads(sector.Id, true, true, false, "no_retreating", "non_travelling")
  if playerWon then
    if not (playerAttacked or startedFromMap) or not sector.conflictLoyaltyGained then
      local city = GetLoyaltyCityNearby(sector)
      local nonMilitiaSquad = false
      for i, sq in ipairs(allySquads) do
        if not sq.militia then
          nonMilitiaSquad = true
        end
      end
      if not nonMilitiaSquad then
        CityModifyLoyalty(city, const.Loyalty.ConflictMilitiaOnlyWinBonus, T(469271409848, "Enemies cleared by militia"))
        sector.conflictLoyaltyGained = true
      else
        CityModifyLoyalty(city, const.Loyalty.ConflictWinBonus, T(133483288436, "Enemies cleared"))
        sector.conflictLoyaltyGained = true
      end
      sector.autoresolve_disabled = false
    end
    for i, squad in ipairs(allySquads) do
      for i, uId in ipairs(squad.units) do
        local ud = gv_UnitData[uId]
        if ud and ud.retreat_to_sector then
          CancelUnitRetreat(ud)
        end
      end
    end
    LocalCheckUnitsMapPresence()
  elseif isRetreat then
    local city = GetLoyaltyCityNearby(sector)
    CityModifyLoyalty(city, const.Loyalty.ConflictRetreatPenalty, T(186425120178, "Retreat"))
    if not LostLoyaltyWithSectorsThisTick then
      LostLoyaltyWithSectorsThisTick = {}
    end
    LostLoyaltyWithSectorsThisTick[sector.Id] = true
  elseif not playerWon and (not allySquads or #allySquads == 0) then
    local city = GetLoyaltyCityNearby(sector, "adjacent_only")
    CityModifyLoyalty(city, const.Loyalty.ConflictDefeatedLoyaltyLoss, T(703208874704, "Defeat"))
  end
end
function OpenSatelliteConflictDlg(context, openedBy)
  CreateRealTimeThread(function()
    WaitPlayingSetpiece()
    local satCon = GetDialog("SatelliteConflict")
    if satCon then
      if satCon.context.Id == context.Id then
        print("double conflict", context.Id)
        satCon:Close()
      end
      WaitMsg(satCon)
    end
    local popupHost = GetDialog("PDADialogSatellite")
    popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")
    OpenDialog("SatelliteConflict", popupHost or GetInGameInterface(), context)
    if openedBy == "auto-open" then
      PlayFX("ConflictPanelOpen")
    else
      PlayFX("ConflictPanelOpenByPlayer")
    end
  end)
end
function OnMsg.UnitDieStart(unit, attacker)
  if unit:IsCivilian() and unit.Affiliation == "Civilian" and attacker then
    CivilianDeathPenalty()
  end
end
GameVar("gv_CiviliansKilled", 0)
function OnMsg.OnKill(attacker, killedUnits)
  if IsMerc(attacker) then
    for _, unit in ipairs(killedUnits) do
      if unit:IsCivilian() then
        gv_CiviliansKilled = gv_CiviliansKilled + 1
      end
    end
  end
end
function DespawnUnitData(sectorId, class, despawnUnitToo)
  local found = table.filter(gv_UnitData, function(i, o)
    local squad = o.Squad
    squad = squad and gv_Squads[squad]
    local sectorFilter = squad and squad.CurrentSector == sectorId
    if not squad then
      sectorFilter = g_Units[o.session_id] and gv_CurrentSectorId == sectorId
    end
    return o.class == class and sectorFilter
  end)
  local firstIdx = found and next(found)
  if not firstIdx then
    return
  end
  RemoveUnitFromSquad(found[firstIdx], despawnUnitToo and "despawn")
  if despawnUnitToo then
    LocalCheckUnitsMapPresence()
  end
end
function IsAutoResolveEnabled(sector)
  if not sector.Map then
    return true
  end
  local alliesInConflict = GetSquadsInSector(sector.Id, "excludeTravelling", "includeMilitia", "excludeArriving")
  if not alliesInConflict or #alliesInConflict == 0 then
    return false
  end
  local onlyMilitia = true
  for i, s in ipairs(alliesInConflict) do
    if not s.militia then
      onlyMilitia = false
      break
    end
  end
  if onlyMilitia then
    return true
  end
  local anyHavePreviousSector = false
  for i, squad in ipairs(alliesInConflict) do
    anyHavePreviousSector = not squad.militia and squad.PreviousSector
    if anyHavePreviousSector then
      break
    end
  end
  if not anyHavePreviousSector then
    return false
  end
  if sector.autoresolve_disabled then
    return false
  end
  return CanGoInMap(sector.Id) and not sector.ForceConflict
end
function OnMsg.ConflictEnd(sector)
  if sector.Side ~= "player1" then
    return
  end
  local militia_squad_id = sector.militia_squad_id
  local militia_squad = gv_Squads[militia_squad_id]
  if not militia_squad or #(militia_squad.units or "") == 0 then
    return
  end
  local quest = QuestGetState("05_TakeDownMajor")
  SetQuestVar(quest, "LegionBeatenByMilitia", true)
end
function GetSatelliteConflictWarnings(squads)
  local woundedCount, tiredCount = 0, 0
  for _, squad in ipairs(squads) do
    for _, id in ipairs(squad.units) do
      local unit = gv_UnitData[id]
      if unit.Tiredness >= 1 then
        tiredCount = tiredCount + 1
      end
      if unit.HitPoints < MulDivRound(unit:GetInitialMaxHitPoints(), 50, 100) then
        woundedCount = woundedCount + 1
      end
    end
  end
  return woundedCount, tiredCount
end
