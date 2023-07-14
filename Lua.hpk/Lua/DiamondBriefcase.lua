local lMaxStaticSquads = 3
local lMinDynamicSquadRouteLength = 10
local lMaxDynamicSquads = 2
local lDynamicSquadDayCooldown = 6
local lDynamicSquadDayChanceToSpawn = 3
DynamicSquadSpawnChanceOnScout = 20
function InitDiamondBriefcaseSquads(guaranteed_spawn)
  local viableSectors = {}
  for id, sector in sorted_pairs(gv_Sectors) do
    if sector.Guardpost and (not guaranteed_spawn or not table.find(guaranteed_spawn, id)) then
      viableSectors[#viableSectors + 1] = id
    end
  end
  local spawned = 0
  local spawnOn = {}
  for i = 0, lMaxStaticSquads do
    if #viableSectors == 0 then
      break
    end
    local random = BraidRandom(xxhash(Game.id, i), 1, #viableSectors)
    local randomId = table.remove(viableSectors, random)
    spawnOn[#spawnOn + 1] = randomId
  end
  for i, sector in ipairs(guaranteed_spawn) do
    spawnOn[#spawnOn + 1] = sector
  end
  local squadDef = EnemySquadDefs.DiamondBriefcase
  local squadDefCarrier = squadDef.DiamondBriefcaseCarrier
  for i, sectorId in ipairs(spawnOn) do
    local _, enemySquads = GetSquadsInSector(sectorId)
    if enemySquads and 0 < #enemySquads then
      for i, sq in ipairs(enemySquads) do
        if sq.diamond_briefcase then
          goto lbl_167
        end
      end
    end
    local bestUnit = false
    for i, sq in ipairs(enemySquads) do
      local units = sq.units
      for i, u in ipairs(units) do
        local ud = gv_UnitData[u]
        local template = UnitDataDefs[ud.class]
        if not ud.villain and not template.ImportantNPC then
          bestUnit = ud
          break
        end
      end
      if bestUnit then
        break
      end
    end
    if not bestUnit then
      local unitIds, unitNames, unitSources, unitAppearance = GenerateRandEnemySquadUnits(squadDef.id)
      local units = GenerateUnitsFromTemplates(sectorId, unitIds, "StaticDB", unitNames, unitAppearance)
      local squad_id = CreateNewSatelliteSquad({
        Side = "enemy1",
        CurrentSector = sectorId,
        Name = squadDef.displayName and _InternalTranslate(squadDef.displayName) or SquadName:GetNewSquadName("enemy1", units),
        diamond_briefcase = true,
        enemy_squad_def = squadDef.id
      }, units)
      for i, s in ipairs(unitSources) do
        if s == squadDefCarrier then
          bestUnit = units[i]
          break
        end
      end
      bestUnit = gv_UnitData[bestUnit]
    end
    local dbItem = PlaceInventoryItem("DiamondBriefcase")
    dbItem.drop_chance = 100
    bestUnit:AddItem("Inventory", dbItem)
    ::lbl_167::
  end
end
GameVar("DynamicDBSquadAccumChance", 0)
GameVar("DynamicDBSquadLastSpawnTime", 0)
function OnMsg.NewDay()
  if gv_SatelliteAttacksHalted then
    return
  end
  DynamicDBSquadAccumChance = DynamicDBSquadAccumChance or 0
  DynamicDBSquadLastSpawnTime = DynamicDBSquadLastSpawnTime or 0
  if DynamicDBSquadLastSpawnTime - Game.CampaignTime > const.Scale.day * lDynamicSquadDayCooldown then
    return
  end
  local currentDynamicSquadsOnMap = 0
  for i, sq in ipairs(g_SquadsArray) do
    if sq.diamond_briefcase_dynamic then
      currentDynamicSquadsOnMap = currentDynamicSquadsOnMap + 1
    end
  end
  if currentDynamicSquadsOnMap >= lMaxDynamicSquads then
    return
  end
  DynamicDBSquadAccumChance = DynamicDBSquadAccumChance + lDynamicSquadDayChanceToSpawn
  if DynamicDBSquadAccumChance > InteractionRand(100, "DiamondBriefcase") then
    SpawnDynamicDBSquad()
    DynamicDBSquadLastSpawnTime = Game.CampaignTime
    DynamicDBSquadAccumChance = 0
  end
end
function SpawnDynamicDBSquad(overrideSourceDest, srcOrDstSectorFilter)
  local routes = DBRoutesCache
  local campaign = GetCurrentCampaignPreset()
  if not routes or not routes[campaign.id] then
    return
  end
  routes = routes[campaign.id]
  local weights = {}
  if overrideSourceDest then
    local src = overrideSourceDest[1]
    local dst = overrideSourceDest[2]
    if src and dst then
      local route = GenerateRouteDijkstra(src, dst, false, empty_table, nil, nil, "diamonds")
      if route then
        route.source = src
        route.dest = dst
        weights[#weights + 1] = {100, route}
        routes = empty_table
      else
        return
      end
    end
  end
  for i, route in ipairs(routes) do
    if not srcOrDstSectorFilter or route.source == srcOrDstSectorFilter or route.dest == srcOrDstSectorFilter then
      local srcSector = gv_Sectors[route.source]
      local dstSector = gv_Sectors[route.dest]
      if srcSector.reveal_allowed and srcSector.Side == "enemy1" and dstSector.reveal_allowed and dstSector.Side == "enemy1" and not srcSector.no_ddb and not dstSector.no_ddb then
        local weightPerSector = MulDivRound(1, 1000, #route)
        local weight = 0
        for i, sId in ipairs(route) do
          local prevSector = route[i - 1]
          local nextSector = route[i + 1]
          local sector = gv_Sectors[sId]
          if sector.Side ~= "player1" then
            weight = weight + weightPerSector
            ForEachSectorAround(sId, 1, function(sectorAroundId)
              if sId ~= sectorAroundId and sectorAroundId ~= prevSector and sectorAroundId ~= nextSector then
                local sectorAround = gv_Sectors[sectorAroundId]
                if sectorAround.Side == "player1" then
                  weight = weight + weightPerSector * 4
                  return "break"
                end
              end
            end)
          end
        end
        weight = weight + #route * 2
        weights[#weights + 1] = {weight, route}
      end
    end
  end
  if #weights == 0 then
    return
  end
  local randomRoute = GetWeightedRandom(weights, xxhash(Game.id, Game.CampaignTime, gv_NextSquadUniqueId))
  local sectorId = randomRoute.source
  local squadDef = EnemySquadDefs.DiamondBriefcase
  local squadDefCarrier = squadDef.DiamondBriefcaseCarrier
  local unitIds, unitNames, unitSources, unitAppearance = GenerateRandEnemySquadUnits(squadDef.id)
  local units = GenerateUnitsFromTemplates(sectorId, unitIds, "StaticDB", unitNames, unitAppearance)
  local carrier = false
  for i, s in ipairs(unitSources) do
    if s == squadDefCarrier then
      carrier = units[i]
    end
  end
  carrier = gv_UnitData[carrier]
  local dbItem = PlaceInventoryItem("DiamondBriefcase")
  dbItem.drop_chance = 100
  dbItem.extra_tag = "dynamic-db"
  carrier:AddItem("Inventory", dbItem)
  local squad_id = CreateNewSatelliteSquad({
    Side = "enemy1",
    CurrentSector = sectorId,
    Name = _InternalTranslate(T(556556625230, "Diamond Shipment")),
    diamond_briefcase = true,
    diamond_briefcase_dynamic = true,
    always_visible = true,
    enemy_squad_def = squadDef.id,
    image = "UI/Icons/SateliteView/enemy_squad_diamonds"
  }, units)
  local squad = gv_Squads[squad_id]
  randomRoute = table.copy(randomRoute)
  randomRoute = {randomRoute}
  randomRoute.despawn_at_last_sector = true
  randomRoute.diamond_briefcase = true
  SetSatelliteSquadRoute(squad, randomRoute)
end
function GenerateDynamicDBPathCache()
  PauseInfiniteLoopDetection("DBPathfinding")
  local routeCache = {}
  local sources = {}
  local destinations = {}
  local campaign = GetCurrentCampaignPreset()
  local cols = campaign.sector_columns
  local rows = campaign.sector_rows
  for id, sector in sorted_pairs(gv_Sectors) do
    if not IsSectorUnderground(id) then
      if sector.DBSourceSector and not sources[id] then
        sources[#sources + 1] = id
        sources[id] = "src"
      end
      local row, col = sector_unpack(id)
      local isEdgeSector = row == rows or cols == col or row == 1 or col == 1
      if (sector.DBDestinationSector or isEdgeSector) and not destinations[id] then
        destinations[#destinations + 1] = id
        destinations[id] = isEdgeSector and "edge" or "dest"
      end
    end
  end
  if #sources == 0 or #destinations == 0 then
    return
  end
  local dedupe = {}
  for i, source in ipairs(sources) do
    for i, dest in ipairs(destinations) do
      if source ~= dest then
        local r = GenerateRouteDijkstra(source, dest, false, empty_table, "land_only", nil, "diamonds", "no-shortcuts")
        if not r then
          r = GenerateRouteDijkstra(source, dest, false, empty_table, "land_water_boatless", nil, "diamonds", "no-shortcuts")
          if not r then
            goto lbl_175
          end
        end
        if destinations[dest] == "edge" then
          local edgeSectorsToRemove = 0
          for i = #r, 1, -1 do
            local sectorId = r[i]
            local row, col = sector_unpack(sectorId)
            local isEdgeSector = row == rows or cols == col or row == 1 or col == 1
            if isEdgeSector then
              edgeSectorsToRemove = edgeSectorsToRemove + 1
            else
              break
            end
          end
          if 1 < edgeSectorsToRemove then
            local routeLength = #r
            for i = 0, edgeSectorsToRemove - 2 do
              r[routeLength - i] = nil
            end
            dest = r[#r]
          end
        end
        if not dedupe[source .. " " .. dest] then
          local startSector = source
          local firstSectorInRoute = r[1]
          local sX, sY = sector_unpack(startSector)
          local fX, fY = sector_unpack(firstSectorInRoute)
          if #r >= lMinDynamicSquadRouteLength then
            r.source = source
            r.dest = dest
            dedupe[source .. " " .. dest] = true
            routeCache[#routeCache + 1] = r
          end
        end
      end
      ::lbl_175::
    end
  end
  local data = {}
  data[campaign.id] = routeCache
  local code = TableToLuaCode(data)
  code = [[
if FirstLoad then 
DBRoutesCache = ]] .. code .. [[

end]]
  SaveSVNFile("svnProject/Lua/ExtrasGen/DiamondPaths.generated.lua", code)
  ResumeInfiniteLoopDetection("DBPathfinding")
end
function GetStaticDiamondBriefcaseSquadOnSector(sectorId)
  local _, enemySquads = GetSquadsInSector(sectorId)
  if enemySquads and 0 < #enemySquads then
    for i, sq in ipairs(enemySquads) do
      if sq.diamond_briefcase and not sq.diamond_briefcase_dynamic then
        return sq
      end
    end
  end
  return false
end
local lCheckDiamondBadge = function()
  local sector = gv_Sectors[gv_CurrentSectorId]
  if not sector then
    return
  end
  local hasIntel = sector.intel_discovered
  for i, u in ipairs(g_Units) do
    local hasBriefcase = not not u:HasItem("DiamondBriefcase")
    hasBriefcase = hasBriefcase and (u.team.side == "enemy1" or u.team.side == "enemy2" or u:IsDead())
    local showBriefcase = hasIntel or u:IsDead()
    if hasBriefcase and hasIntel then
      local ud = GameState.entering_sector and gv_UnitData[u.session_id]
      local statusEffectObj = ud or u
      statusEffectObj:AddStatusEffect("DiamondCarrier")
    end
    local needsBadge = hasBriefcase and showBriefcase
    local diamondBadge = TargetHasBadgeOfPreset("DiamondBadge", u)
    local hasBadge = not not diamondBadge
    if needsBadge ~= hasBadge then
      if needsBadge then
        CreateBadgeFromPreset("DiamondBadge", {
          target = u,
          spot = u:GetInteractableBadgeSpot() or "Origin"
        }, u)
      else
        diamondBadge:Done()
      end
    end
  end
end
OnMsg.EnterSector = lCheckDiamondBadge
OnMsg.CombatEnd = lCheckDiamondBadge
function OnMsg.InventoryChange(u)
  if not IsKindOf(u, "Unit") and not TargetHasBadgeOfPreset("DiamondBadge", u) then
    return
  end
  lCheckDiamondBadge()
end
function OnMsg.IntelDiscovered(sectorId)
  if sectorId ~= gv_CurrentSectorId then
    return
  end
  lCheckDiamondBadge()
end
