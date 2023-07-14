MapTypesCombo = {
  "game",
  "system",
  "satellite"
}
function GetCurrentCampaignPreset()
  if Game and Game.Campaign then
    return CampaignPresets[Game.Campaign]
  end
  return CampaignPresets[DefaultCampaign]
end
function LoadCampaignInitialMap(campaign)
  campaign = campaign or GetCurrentCampaignPreset()
  local sector = table.find_value(campaign.Sectors, "Id", campaign.InitialSector)
  if sector and sector.Map and sector.Map ~= GetMapName() then
    ChangeMap(sector.Map)
  end
end
function CreateSatelliteSectors()
  local campaign = GetCurrentCampaignPreset()
  if not campaign then
    return
  end
  local sectors = {}
  for col = 1, campaign.sector_columns do
    for row = 1, campaign.sector_rows do
      local sector = PlaceObject("SatelliteSector")
      sector:SetId(sector_pack(row, col))
      sectors[#sectors + 1] = sector
    end
  end
  return sectors
end
function GetSatelliteSectors(bCreate)
  local campaign = GetCurrentCampaignPreset()
  if not campaign then
    return
  end
  local sectors = campaign.Sectors or {}
  if not next(sectors) and bCreate then
    sectors = CreateSatelliteSectors() or {}
    table.sort(sectors, function(a, b)
      return a.Id < b.Id
    end)
  end
  campaign.Sectors = sectors
  return sectors
end
function GetCampaignSectorsCombo(default, filter)
  local campaign = GetCurrentCampaignPreset()
  if not campaign then
    return
  end
  local items = default and {
    {value = default, text = default}
  } or {}
  for _, sector in ipairs(campaign.Sectors or empty_table) do
    if not filter or filter(sector) then
      local id = sector.Id
      items[#items + 1] = {
        value = id,
        text = sector.name
      }
    end
  end
  return items
end
function GetGuardpostCampaignSectorsCombo(default)
  return GetCampaignSectorsCombo(default, function(s)
    return s.Guardpost
  end)
end
function TFormat.ActionName_ActivitiesCount(context)
  if context then
    return T(520902754959, "Operations")
  end
  local squad, sector_id = GetSatelliteContextMenuValidSquad()
  local operationsInSector = GetOperationsInSector(sector_id)
  local available = table.count(operationsInSector, "enabled", true)
  return T({
    989240901383,
    "Operations[<count>]",
    count = available
  })
end
function TFormat.ActionName_OperationsList(context)
  local operationsInSector = GetOperationsInSector(context.Id)
  local names = {}
  for _, operation in ipairs(operationsInSector) do
    if operation.enabled then
      names[#names + 1] = operation.operation.display_name
    end
  end
  if 0 < #names then
    table.insert(names, 1, Untranslated("\n"))
  end
  return table.concat(names, "\n")
end
function GetSatelliteViewInterface()
  return g_SatelliteUI
end
local openiningSatView
function OpenSatelliteView(campaign, context, loading_screen, wait)
  if g_FirstNetStart then
    return
  end
  if openiningSatView then
    return
  end
  openiningSatView = true
  if netInGame and not netGameInfo.started then
    _OpenSatelliteView(campaign, context, loading_screen)
  elseif GetMap() == "" or not mapdata.GameLogic then
    if not netInGame or NetIsHost() then
      NetEchoEvent("OpenSatelliteViewAsync", campaign, context, loading_screen)
    end
  else
    FireNetSyncEventOnHost("OpenSatelliteView", campaign, context, loading_screen)
  end
  if wait then
    WaitMsg("OpenSatelliteView", 1000)
  end
end
function NetEvents.OpenSatelliteViewAsync(...)
  CreateGameTimeThread(_OpenSatelliteView, ...)
end
function NetSyncEvents.OpenSatelliteView(...)
  CreateGameTimeThread(_OpenSatelliteView, ...)
end
function NetSyncEvents.OpenPDASatellite(context)
  CreateGameTimeThread(function()
    local dlg = GetDialog("PDADialogSatellite")
    if not dlg then
      OpenDialog("PDADialogSatellite", GetInGameInterface(), context)
    end
  end)
end
local thread
function _OpenSatelliteView(campaign, context, loading_screen)
  if g_Combat and g_Combat:ShouldEndCombat() then
    g_Combat:EndCombatCheck()
    while g_Combat do
      WaitMsg("CombatEnd", 20)
    end
  end
  if not CanYield() or IsRealTimeThread() then
    CreateGameTimeThread(SkipNonBlockingSetpieces)
  else
    SkipNonBlockingSetpieces()
  end
  thread = CreateRealTimeThread(function()
    sprocall(function()
      if not HasGameSession() then
        NewGameSession()
      end
      Msg("PreOpenSatelliteView")
      if context then
        CloseSatelliteView(true)
      end
      local load_map = GetMap() == "" or not mapdata.GameLogic
      loading_screen = loading_screen or load_map
      if loading_screen then
        LoadingScreenOpen("idSatelliteView", "satellite")
      end
      if load_map then
        LoadCampaignInitialMap(campaign)
        if not AnyPlayerSquads() then
          local campaign = campaign or CampaignPresets[Game.Campaign]
          campaign:FirstRunInterface()
        end
      end
      ShowInGameInterface(true)
      FireNetSyncEventOnHost("OpenPDASatellite", context)
      if not gv_SatelliteView or not GetDialog("PDADialogSatellite") then
        WaitMsg("InitSatelliteView")
      end
      local dlg = GetDialog("PDADialog")
      if dlg then
        dlg:SetVisible(true)
      end
      if loading_screen then
        LoadingScreenClose("idSatelliteView", "satellite")
      end
    end)
    openiningSatView = nil
  end)
end
function CloseSatelliteView(force)
  if not gv_SatelliteView then
    return
  end
  FireNetSyncEventOnHost("CloseSatelliteView", force)
end
function NetSyncEvents.CloseSatelliteView(force)
  local pda = GetDialog("PDADialogSatellite")
  if not pda then
    return
  end
  pda:Close(force)
end
function CanCloseSatelliteView()
  local squads = GetSectorSquadsFromSide(gv_CurrentSectorId, "player1")
  if 0 < #squads then
    local anyNonTravelling = false
    for i, squad in ipairs(squads) do
      local travelling = IsSquadTravelling(squad) and not gv_Sectors[squad.CurrentSector].conflict
      if not travelling then
        anyNonTravelling = true
      end
    end
    if not anyNonTravelling then
      squads = false
    end
  else
    squads = false
  end
  return gv_SatelliteView and squads and not ForceReloadSectorMap
end
GameVar("gv_SatelliteOpenTime", 0)
GameVar("gv_SatelliteOpenWeather", false)
function OnMsg.StartSatelliteGameplay()
  gv_SatelliteOpenTime = Game.CampaignTime
  gv_SatelliteOpenWeather = GetCurrentSectorWeather() or false
end
function OnMsg.SatelliteTick()
  if ForceReloadSectorMap then
    return
  end
  if Game.CampaignTime - gv_SatelliteOpenTime >= const.Satellite.ReloadMapAfterSatelliteTime or gv_SatelliteOpenWeather ~= GetCurrentSectorWeather() or CalculateTimeOfDay(Game.CampaignTime) ~= CalculateTimeOfDay(gv_SatelliteOpenTime) then
    ForceReloadSectorMap = true
  end
end
if FirstLoad then
  g_SatelliteThread = false
  PrevSectorOnMouse = false
  g_Cabinet = false
  g_CitySectors = false
  time_thread_waiting_resume = false
end
total_pause_delta = 0
function OnMsg.CampaignSpeedChanged()
  if IsValidThread(g_SatelliteThread) and time_thread_waiting_resume then
    Wakeup(g_SatelliteThread)
    time_thread_waiting_resume = false
  end
end
local div = 1000
local ticks_batch = 5
dbgCampaignFactor = false
function SatelliteTimeThread()
  local ShouldRun = function()
    return not IsCampaignPaused() and not GameState.entering_sector
  end
  local time_func = RealTime
  while true do
    local campaign_time = Game.CampaignTime
    local sleep_accum = 0
    local dt_accum = 0
    local rt_ts = time_func()
    local dbgStart = time_func()
    local dbgTikcsFired = 0
    while ShouldRun() do
      local campaignFactor = dbgCampaignFactor or Game.CampaignTimeFactor
      local sleepPerTick = MulDivRound(div, div, campaignFactor)
      local dt_so_far = (time_func() - rt_ts + dt_accum / div) * div
      local tToSleep = sleepPerTick * ticks_batch + sleep_accum - dt_so_far
      if 0 < tToSleep then
        Sleep(tToSleep / div)
        sleep_accum = tToSleep % div
        if not ShouldRun() then
          break
        end
      end
      local now = time_func()
      local dt = now - rt_ts + dt_accum / div
      rt_ts = now
      local ticks = dt * div / sleepPerTick
      dt_accum = dt_accum % div + dt * div - ticks * sleepPerTick
      if 0 < ticks then
        dbgTikcsFired = dbgTikcsFired + ticks
        local next_t = campaign_time + const.Scale.min * ticks
        NetSyncEvent("SatelliteCampaignTimeAdvance", next_t, campaign_time, ticks)
        campaign_time = next_t
      end
      local dbgElapsed = time_func() - dbgStart
      while 0 < #SyncEventsQueue do
        WaitMsg("SyncEventsProcessed", 50)
      end
    end
    time_thread_waiting_resume = true
    WaitWakeup()
  end
end
function OnMsg.StartSatelliteGameplay()
  DeleteThread(g_SatelliteThread)
  if netInGame and not NetIsHost() then
    return
  end
  g_SatelliteThread = CreateMapRealTimeThread(SatelliteTimeThread)
end
local ticks_in_day = 1440 * const.Scale.min / const.Satellite.SectorsTick
local lFireCampaignTimeSyncMessages = function(time, old_time)
  local tick = time / const.Satellite.Tick
  if tick ~= old_time / const.Satellite.Tick then
    Msg("SatelliteTick", tick)
  end
  local sectors_tick = time / const.Satellite.SectorsTick
  if sectors_tick ~= old_time / const.Satellite.SectorsTick then
    Msg("SectorsTick", sectors_tick % ticks_in_day, ticks_in_day)
  end
  if time % const.Scale.h <= 0 then
    Msg("NewHour")
  end
  if time % const.Scale.day < const.Scale.min then
    Msg("NewDay")
  end
end
function GetCampHumanTime()
  return Game.CampaignTime % const.Scale.day / const.Scale.h, ":", Game.CampaignTime % const.Scale.day % const.Scale.h / const.Scale.min
end
local thread = false
function NetSyncEvents.SatelliteCampaignTimeAdvance(time, old_time, step)
  if IsCampaignPaused() then
    return
  end
  DeleteThread(thread)
  thread = CreateMapRealTimeThread(function()
    local lastGameTime = GameTime()
    WaitAllOtherThreads()
    while Game.CampaignTime < time and not IsCampaignPaused() do
      local ot = Game.CampaignTime
      Game.CampaignTime = Game.CampaignTime + const.Scale.min
      hr.UILLuaTime = Game.CampaignTime
      Game.DailyIncome = GetDailyIncome()
      lFireCampaignTimeSyncMessages(Game.CampaignTime, ot)
      ObjModified(Game)
      Msg("CampaignTimeAdvanced", Game.CampaignTime, ot)
      WaitAllOtherThreads()
      local gameTimeNow = GameTime()
      if lastGameTime ~= gameTimeNow then
      end
      lastGameTime = gameTimeNow
    end
  end)
end
function OnMsg.OpenSatelliteView()
  hr.UILLuaTime = Game.CampaignTime
end
function GetAmountPerTick(amount, tick, ticks)
  return amount * (tick + 1) / ticks - amount * tick / ticks
end
function MineEnable(sector_id, enabled)
  gv_Sectors[sector_id].mine_enabled = enabled
end
function GetSectorDepletionTime(sector)
  local baseVal = sector.DepletionTime
  local percentAccum = 100
  for i, m in ipairs(sector.depletion_mods) do
    percentAccum = percentAccum + (m - 100)
  end
  return MulDivRound(baseVal, percentAccum, 100)
end
function GetSectorDailyIncome(sector)
  local baseVal = sector.DailyIncome
  local baseValDiffPerc = PercentModifyByDifficulty(GameDifficulties[Game.game_difficulty]:ResolveValue("sectorDailyIncomeBonus"))
  baseVal = MulDivRound(baseVal, baseValDiffPerc, 100)
  local percentAccum = 100
  for i, m in ipairs(sector.income_mods) do
    percentAccum = percentAccum + (m - 100)
  end
  return MulDivRound(baseVal, percentAccum, 100)
end
function GetMineIncome(sector_id, showEvenIfUnowned)
  local sector = gv_Sectors[sector_id]
  if not sector.Mine or sector.mine_depleted or not sector.mine_enabled then
    return
  end
  local city_loyalty = GetCityLoyalty(sector.City) or 100
  if sector.Side ~= "player1" then
    if showEvenIfUnowned then
      city_loyalty = 50
    else
      return
    end
  end
  local sectorDepletionTime = GetSectorDepletionTime(sector)
  local perc = 100
  if sector.Depletion and sector.mine_work_days and sectorDepletionTime < sector.mine_work_days then
    perc = Max(0, (sectorDepletionTime + const.Satellite.MineDepletingDays - sector.mine_work_days) * 10)
  end
  local income = GetSectorDailyIncome(sector)
  income = perc * income / 100
  return income * (50 + city_loyalty / 2) / 100
end
function OnMsg.SectorsTick(tick, ticks_per_day)
  for id, sector in sorted_pairs(gv_Sectors) do
    local income = GetMineIncome(id)
    if income then
      income = GetAmountPerTick(income, tick, ticks_per_day)
      AddMoney(income, "income", "noCombatLog")
      if tick + 1 == ticks_per_day then
        sector.mine_work_days = (sector.mine_work_days or 0) + 1
        local sectorDepletionTime = GetSectorDepletionTime(sector)
        if sector.Depletion and sector.mine_work_days >= sectorDepletionTime + const.Satellite.MineDepletingDays then
          sector.mine_depleted = true
          CombatLog("important", T({
            268514931670,
            "<SectorName(sector)> is depleted.",
            sector = sector
          }))
          if g_SatelliteUI then
            g_SatelliteUI:UpdateSectorVisuals(id)
          end
        end
      end
    end
    ExecuteSectorEvents("SE_OnTick", id)
  end
end
function CityModifyLoyalty(city_id, add, msg_reason)
  local city = gv_Cities[city_id]
  if not city or add == 0 then
    return
  end
  city.Loyalty = Clamp(city.Loyalty + add, 0, 100)
  Msg("LoyaltyChanged", city_id, add)
  local msg = false
  if 0 < add then
    msg = T({
      562269812751,
      "Gained <em><num> Loyalty</em> with <em><city></em> ",
      city = city.DisplayName,
      num = add
    })
  else
    msg = T({
      837740133104,
      "Lost <em><num> Loyalty</em> with <em><city></em> ",
      city = city.DisplayName,
      num = abs(add)
    })
  end
  if msg_reason and msg_reason ~= "" then
    CombatLog("important", T({
      833235545397,
      "<msg>(<reason>)",
      msg = msg,
      reason = msg_reason
    }))
  else
    CombatLog("short", msg)
  end
  ObjModified(city)
  return 0 < add and "gain" or "loss"
end
function NetSyncEvents.CheatCityModifyLoyalty(city_id, add, msg_reason)
  CityModifyLoyalty(city_id, add, msg_reason)
end
function GetCityLoyalty(city_id)
  local city = gv_Cities and gv_Cities[city_id]
  if not city then
    return 100
  end
  return city.Loyalty
end
function TFormat.GetCityLoyalty(context_obj, city_id)
  return GetCityLoyalty(city_id)
end
function GetPlayerCityCount(countSectors)
  local cityCount = 0
  if countSectors then
    for cityName, sectorCount in pairs(gv_PlayerCityCounts and gv_PlayerCityCounts.cities) do
      cityCount = cityCount + sectorCount
    end
  else
    cityCount = gv_PlayerCityCounts and gv_PlayerCityCounts.count or 0
  end
  return cityCount
end
function GetSectorMilitiaCount(sector_id)
  local squad_id = gv_Sectors[sector_id] and gv_Sectors[sector_id].militia_squad_id
  return squad_id and gv_Squads[squad_id] and #(gv_Squads[squad_id].units or "") or 0
end
function CreateMilitiaUnitData(class, sector, militia_squad)
  local session_id = GenerateUniqueUnitDataId("Militia", sector.Id, class)
  local unit_data = CreateUnitData(class, session_id, InteractionRand(nil, "Satellite"))
  unit_data.militia = true
  unit_data.Squad = militia_squad.UniqueId
  militia_squad.units = militia_squad.units or {}
  table.insert(militia_squad.units, session_id)
end
function DeleteMilitiaUnitData(id, militia_squad)
  gv_UnitData[id] = nil
  if g_Units[id] then
    DoneObject(g_Units[id])
    g_Units[id] = nil
  end
  table.remove_entry(militia_squad.units, id)
end
MilitiaUpgradePath = {
  "MilitiaRookie",
  "MilitiaVeteran",
  "MilitiaElite"
}
MilitiaIcons = {
  false,
  "UI/PDA/MercPortrait/T_ClassIcon_Veteran_Small",
  "UI/PDA/MercPortrait/T_ClassIcon_Elite_Small"
}
function GetLeastExpMilitia(units)
  local leastExperienced = false
  local leastExperiencedIdx = false
  for _, u in ipairs(units) do
    local ud = gv_UnitData[u]
    local class = ud.class
    local idx = table.find(MilitiaUpgradePath, class)
    if not leastExperiencedIdx or leastExperiencedIdx > idx then
      leastExperienced = ud
      leastExperiencedIdx = idx
    end
  end
  return leastExperienced
end
function SpawnMilitia(trainAmount, sector, bFromOperation)
  local militia_squad_id = sector.militia_squad_id or CreateNewSatelliteSquad({
    Side = "ally",
    CurrentSector = sector.Id,
    militia = true,
    Name = T(121560205347, "MILITIA")
  })
  sector.militia_squad_id = militia_squad_id
  local militia_squad = gv_Squads[militia_squad_id]
  local count = {MilitiaRookie = 0, MilitiaVeteran = 0}
  for i, unit_id in ipairs(militia_squad and militia_squad.units) do
    local class = gv_UnitData[unit_id].class
    if class == "MilitiaRookie" then
      count.MilitiaRookie = count.MilitiaRookie + 1
    end
    if class == "MilitiaVeteran" then
      count.MilitiaVeteran = count.MilitiaVeteran + 1
    end
  end
  local count_trained = 0
  for i = 1, trainAmount do
    local squadUnits = militia_squad.units or empty_table
    local leastExpMember = GetLeastExpMilitia(militia_squad.units)
    if #squadUnits < sector.MaxMilitia then
      CreateMilitiaUnitData(MilitiaUpgradePath[1], sector, militia_squad)
      count_trained = count_trained + 1
    elseif leastExpMember then
      if bFromOperation and count.MilitiaRookie <= 0 then
        break
      end
      local leastExperiencedTemplate = bFromOperation and "MilitiaRookie" or leastExpMember.class
      local leastExpIdx = table.find(MilitiaUpgradePath, leastExperiencedTemplate)
      leastExpIdx = leastExpIdx or 0
      leastExpIdx = leastExpIdx + 1
      local upgradedClass = MilitiaUpgradePath[leastExpIdx]
      if not (not (leastExpIdx > #MilitiaUpgradePath) and upgradedClass) then
        break
      end
      DeleteMilitiaUnitData(leastExpMember.session_id, militia_squad)
      CreateMilitiaUnitData(upgradedClass, sector, militia_squad)
      count_trained = count_trained + 1
      count.MilitiaRookie = count.MilitiaRookie - 1
      count.MilitiaVeteran = count.MilitiaVeteran + 1
    end
  end
  return militia_squad, count_trained
end
if FirstLoad then
  g_MilitiaTrainingCompleteCounter = 0
  g_MilitiaTrainingCompletePopups = {}
end
function OnMsg.EnterSector()
  g_MilitiaTrainingCompleteCounter = 0
end
function CompleteCurrentMilitiaTraining(sector, mercs)
  NetUpdateHash("CompleteCurrentMilitiaTraining")
  local eventId = g_MilitiaTrainingCompleteCounter
  g_MilitiaTrainingCompleteCounter = g_MilitiaTrainingCompleteCounter + 1
  local start_time = Game.CampaignTime
  CreateMapRealTimeThread(function()
    local militia_squad, count_trained = SpawnMilitia(const.Satellite.MilitiaUnitsPerTraining, sector, "operation")
    sector.militia_training = false
    local militia_types = {
      MilitiaRookie = 0,
      MilitiaElite = 0,
      MilitiaVeteran = 0
    }
    for _, unit_id in ipairs(militia_squad.units) do
      local unit = gv_UnitData[unit_id]
      militia_types[unit.class] = militia_types[unit.class] + 1
    end
    local popupHost = GetDialog("PDADialogSatellite")
    popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")
    if militia_types.MilitiaVeteran >= sector.MaxMilitia - militia_types.MilitiaElite then
      local dlg = CreateMessageBox(popupHost, T(295710973806, "Militia Training"), T({
        522643975325,
        "Militia training is finished - trained <militia_trained> defenders.<newline><GameColorD>(<sectorName>)</GameColorD>",
        sectorName = GetSectorName(sector),
        militia_trained = count_trained
      }) .. [[


]] .. T(306458255966, "Militia can\226\128\153t be trained further. Victories in combat can advance militia soldiers to Elite levels."))
      dlg:Wait()
    else
      local cost, costTexts, names, errors = GetOperationCosts(mercs, "MilitiaTraining", "Trainer", "refund")
      local buyAgainText = T(460261217340, "Do you want to train militia again?")
      local costText = table.concat(costTexts, ", ")
      local dlg = CreateQuestionBox(popupHost, T(295710973806, "Militia Training"), T({
        522643975325,
        "Militia training is finished - trained <militia_trained> defenders.<newline><GameColorD>(<sectorName>)</GameColorD>",
        sectorName = GetSectorName(sector),
        militia_trained = count_trained
      }), T(689884995409, "Yes"), T(782927325160, "No"), {
        sector = sector,
        mercs = mercs,
        textLower = buyAgainText,
        costText = costText
      }, function()
        return not next(errors) and militia_types.MilitiaVeteran < sector.MaxMilitia - militia_types.MilitiaElite and "enabled" or "disabled"
      end, nil, "ZuluChoiceDialog_MilitiaTraining")
      g_MilitiaTrainingCompletePopups[eventId] = dlg
      NetSyncEvent("ProcessMilitiaTrainingPopupResults", dlg:Wait(), eventId, sector.Id, UnitDataToSessionIds(mercs), cost, start_time)
      g_MilitiaTrainingCompletePopups[eventId] = nil
    end
  end)
end
function UnitDataToSessionIds(arr)
  local ret = {}
  for i, m in ipairs(arr) do
    ret[i] = m.session_id
  end
  return ret
end
function SessionIdsArrToUnitData(arr)
  local unit_data = gv_UnitData
  local ret = {}
  for i, id in ipairs(arr) do
    ret[i] = unit_data[id]
  end
  return ret
end
function NetSyncEvents.ProcessMilitiaTrainingPopupResults(result, event_id, sector_id, mercs, cost, start_time)
  if result == "ok" then
    local sector = gv_Sectors[sector_id]
    if sector.started_operations.MilitiaTraining ~= start_time then
      for i, session_id in ipairs(mercs) do
        NetSyncEvents.MercSetOperation(session_id, "MilitiaTraining", "Trainer", i == 1 and cost, i, false)
      end
      NetSyncEvents.LogOperationStart("MilitiaTraining", sector.Id)
      NetSyncEvents.StartOperation(sector.Id, "MilitiaTraining", start_time, sector.training_stat)
    end
  end
  if g_MilitiaTrainingCompletePopups[event_id] then
    g_MilitiaTrainingCompletePopups[event_id]:Close()
    g_MilitiaTrainingCompletePopups[event_id] = nil
  end
end
function SavegameSessionDataFixups.MilitiaChangeData(data, metadata, lua_revision)
  if lua_revision < 283940 then
    local l_gv_unit_data = GetGameVarFromSession(data, "gv_UnitData")
    for k, unit in pairs(l_gv_unit_data) do
      if unit.class == "MilitiaVeteran" then
        unit.class = "MilitiaElite"
        unit.Name = T(486398616031, "Militia Elite")
      elseif unit.class == "MilitiaRegular" then
        unit.class = "MilitiaVeteran"
        unit.Name = T(237861181220, "Militia Veteran")
      end
    end
  end
end
function SavegameSectorDataFixups.MilitiaChangeData(sector_data, lua_revision)
  if lua_revision < 283940 then
    local dynamic_data = sector_data.dynamic_data
    if dynamic_data and 0 < #dynamic_data then
      for _, ddata_table in ipairs(dynamic_data) do
        local ddata = ddata_table[2]
        if rawget(ddata, "class") then
          if ddata.class == "MilitiaVeteran" then
            ddata.class = "MilitiaElite"
          elseif ddata.class == "MilitiaRegular" then
            ddata.class = "MilitiaVeteran"
          end
        end
      end
    end
  end
end
function SavegameSessionDataFixups.ArrivalSquads(data, meta)
  if meta and meta.lua_revision > 289560 then
    return
  end
  local arrivingSquadName = _InternalTranslate(T(546629671844, "ARRIVING"))
  for id, squad in pairs(data.gvars.gv_Squads) do
    if IsT(squad.Name) and _InternalTranslate(squad.Name) == arrivingSquadName then
      squad.arrival_squad = true
    end
  end
end
function SavegameSessionDataFixups.EnforceSquadNameTranslations(data, meta)
  local TryToMatchSquadName = function(squad_name)
    local result
    ForEachPreset("SquadName", function(preset, ...)
      if preset.group == "Player_Arriving" or preset.group == "Player" then
        return
      end
      if squad_name == TDevModeGetEnglishText(preset.Name, false, "no_assert") then
        result = preset.Name
        return
      end
    end)
    return result
  end
  local playerCounter = 1
  for i, v in pairs(data.gvars.gv_Squads) do
    if v.Side == "player1" or v.Side == "player2" then
      if v.arrival_squad then
        v.Name = Presets.SquadName.Default.Arriving.Name
      else
        v.Name = Presets.SquadName.Player[playerCounter].Name
        playerCounter = playerCounter + 1
      end
    elseif type(v.Name) == "string" then
      v.Name = TryToMatchSquadName(v.Name) or Presets.SquadName.Default.Squad.Name
    else
      if v.militia then
      else
      end
    end
  end
end
function SavegameSessionDataFixups.FixMercCreatedVariable(data, meta)
  if not data.gvars.g_ImpTest or not data.gvars.g_ImpTest.final then
    return
  end
  if data.gvars.g_ImpTest.final.created then
    return
  end
  local merc_id = data.gvars.g_ImpTest.final.merc_template.id
  for _, squad in pairs(data.gvars.gv_Squads) do
    if squad.Side == "player1" or squad.Side == "player2" then
      for _, unit_id in pairs(squad.units) do
        if unit_id == merc_id then
          data.gvars.g_ImpTest.final.created = true
          return
        end
      end
    end
  end
end
function SavegameSessionDataFixups.testoo(data, meta)
  if meta and meta.lua_revision > 302378 then
    return
  end
  local arrivingSquadName = _InternalTranslate(T(546629671844, "ARRIVING"))
  for id, squad in pairs(data.gvars.gv_Squads) do
    if IsT(squad.Name) and _InternalTranslate(squad.Name) == arrivingSquadName then
      squad.Name = arrivingSquadName
    end
  end
end
function OnMsg.EnterSector()
  for i, u in ipairs(g_Units) do
    if u.militia then
      local class = u.unitdatadef_id
      local banterTag = false
      if class == "MilitiaRookie" then
        banterTag = "Rookie"
      elseif class == "MilitiaElite" then
        banterTag = "Elite"
      elseif class == "MilitiaVeteran" then
        banterTag = "Veteran"
      else
        banterTag = ""
      end
      local list = {}
      for i, b in ipairs(Presets.BanterDef.Banters_Militia) do
        if string.match(b.id, banterTag) then
          list[#list + 1] = b.id
        end
      end
      u.banters = list
      if banterTag == "" or #list == 0 then
      end
    end
  end
end
function SetSideStanding(side_id, add_standing)
  local side = gv_Sides[side_id]
  if side.StickyStanding then
    return
  end
  side.Standing = side.Standing + add_standing
end
function SetSideStickyStanding(side_id, sticky)
  gv_Sides[side_id].StickyStanding = sticky
end
function GetSectorPOITypes()
  return {
    "all",
    "Mine",
    "Guardpost",
    "Port"
  }
end
GameVar("gv_PlayerSectorCounts", {
  all = 0,
  Mine = 0,
  Guardpost = 0,
  Port = 0
})
GameVar("gv_PlayerCityCounts", function()
  return {
    count = 0,
    cities = {}
  }
end)
function SatelliteSectorSetSide(sector_id, side, force)
  local sector = gv_Sectors[sector_id]
  if not force and sector.StickySide or sector.Side == side then
    return
  end
  local old_side = sector.Side
  sector.Side = side
  local sector_buildings = {}
  for _, poi in ipairs(POIDescriptions) do
    if sector[poi.id] then
      sector_buildings[#sector_buildings + 1] = poi.display_name
    end
  end
  local sector_building_text
  if sector_buildings and 0 < #sector_buildings then
    sector_building_text = table.concat(sector_buildings, ", ")
  end
  if side == "player1" then
    if sector.City ~= "none" then
      if sector_building_text then
        CombatLog("important", T({
          156954263652,
          "Established control over <em><SectorName(sector)> (<sector_building>)</em> in <em><SettlementName></em>",
          sector = sector,
          SettlementName = gv_Cities[sector.City].DisplayName,
          sector_building = sector_building_text
        }))
      else
        CombatLog("important", T({
          695564592147,
          "Established control over <em><SectorName(sector)></em> in <em><SettlementName></em>",
          sector = sector,
          SettlementName = gv_Cities[sector.City].DisplayName
        }))
      end
    elseif sector_building_text then
      CombatLog("important", T({
        927281946743,
        "Established control over <em><SectorName(sector)> (<sector_building>)</em>",
        sector = sector,
        sector_building = sector_building_text
      }))
    else
      CombatLog("important", T({
        656688610359,
        "Established control over <em><SectorName(sector)></em>",
        sector = sector
      }))
    end
    gv_LastSectorTakenByPlayer = sector_id
  elseif old_side == "player1" and side ~= "neutral" and side ~= "ally" then
    if sector.City ~= "none" then
      if sector_building_text then
        CombatLog("important", T({
          258379206579,
          "Lost control of <em><SectorName(sector)> (<sector_building>)</em> in <em><SettlementName></em>",
          sector = sector,
          SettlementName = gv_Cities[sector.City].DisplayName,
          sector_building = sector_building_text
        }))
      else
        CombatLog("important", T({
          418999371512,
          "Lost control of <em><SectorName(sector)></em> in <em><SettlementName></em>",
          sector = sector,
          SettlementName = gv_Cities[sector.City].DisplayName
        }))
      end
    elseif sector_building_text then
      CombatLog("important", T({
        440720361823,
        "Lost control of <em><SectorName(sector)> (<sector_building>)</em>",
        sector = sector,
        sector_building = sector_building_text
      }))
    else
      CombatLog("important", T({
        371968542080,
        "Lost control of <em><SectorName(sector)></em>",
        sector = sector
      }))
    end
  end
  ExecuteSectorEvents("SE_OnSideChange", sector_id)
  if side == "player1" or side == "player2" then
    if old_side ~= "player1" and old_side ~= "player2" then
      gv_PlayerSectorCounts.all = gv_PlayerSectorCounts.all + 1
      for _, poi in ipairs(GetSectorPOITypes()) do
        if sector[poi] then
          gv_PlayerSectorCounts[poi] = (gv_PlayerSectorCounts[poi] or 0) + 1
        end
      end
      local sector_city = sector.City
      if sector_city and sector_city ~= "none" then
        gv_PlayerCityCounts.cities[sector_city] = (gv_PlayerCityCounts.cities[sector_city] or 0) + 1
        gv_PlayerCityCounts.count = table.count(gv_PlayerCityCounts.cities)
      end
    end
    ExecuteSectorEvents("SE_PlayerControl", sector_id)
  elseif old_side == "player1" or old_side == "player2" then
    gv_PlayerSectorCounts.all = gv_PlayerSectorCounts.all - 1
    for _, poi in ipairs(GetSectorPOITypes()) do
      if sector[poi] then
        gv_PlayerSectorCounts[poi] = gv_PlayerSectorCounts[poi] - 1
      end
    end
    local sector_city = sector.City
    if sector_city and sector_city ~= "none" then
      gv_PlayerCityCounts.cities[sector_city] = gv_PlayerCityCounts.cities[sector_city] - 1
      if gv_PlayerCityCounts.cities[sector_city] == 0 then
        gv_PlayerCityCounts.cities[sector_city] = nil
        gv_PlayerCityCounts.count = table.count(gv_PlayerCityCounts.cities)
      end
    end
  end
  if old_side ~= "player1" and side == "player1" then
    sector.last_own_campaign_time = Game.CampaignTime
  end
  ObjModified(sector)
  Msg("SectorSideChanged", sector_id, old_side, side)
  return true
end
function SavegameSessionDataFixups.PlayerSectorCounts(data)
  if not data.gvars.gv_PlayerSectorCounts then
    local counts = {all = 0}
    local city_counts = {
      count = 0,
      cities = {}
    }
    local pois = GetSectorPOITypes()
    for _, sector in pairs(data.gvars.gv_Sectors) do
      if sector.Side == "player1" or sector.Side == "player2" then
        counts.all = counts.all + 1
        for _, poi in ipairs(pois) do
          if sector[poi] then
            counts[poi] = (counts[poi] or 0) + 1
          end
        end
        if sector.City and sector.City ~= "none" then
          city_counts.cities[sector.City] = (city_counts.cities[sector.City] or 0) + 1
        end
      end
    end
    data.gvars.gv_PlayerSectorCounts = counts
    city_counts.count = table.count(city_counts.cities)
    data.gvars.gv_PlayerCityCounts = city_counts
  end
end
function SavegameSessionDataFixups.WaterTravelLeftover(data)
  local l_gv_squads = GetGameVarFromSession(data, "gv_Squads")
  local l_gv_sectors = GetGameVarFromSession(data, "gv_Sectors")
  for k, squad in pairs(l_gv_squads) do
    local sectorId = squad.CurrentSector
    local isWater = l_gv_sectors[sectorId]
    isWater = isWater and isWater.Passability == "Water"
    if squad.water_route and not isWater then
      squad.water_route = false
    end
  end
end
function SavegameSessionDataFixups.ReplaceSectorsWithIDs(data)
  local quests = GetGameVarFromSession(data, "gv_Quests")
  for merc_id, merc_data in pairs(quests.MercStateTracker) do
    if type(merc_data) == "table" then
      for _, entry in ipairs(merc_data.EmploymentHistory or empty_table) do
        if entry.context and type(entry.context.sector) == "table" then
          entry.context.sector = entry.context.sector.Id
        end
      end
    end
  end
end
function SectorSetStickySide(sector_id, sticky)
  gv_Sectors[sector_id].StickySide = sticky
end
function OnMsg.PreLoadNetGame()
  CloseSatelliteView(true)
  CloseDialog("ModifyWeaponDlg", true)
end
function OnMsg.ChangeMap()
  CloseSatelliteView(true)
  CloseDialog("ModifyWeaponDlg", true)
end
function OnMsg.NewGameSessionStart()
  CloseSatelliteView(true)
end
if Platform.developer then
  local ShowSectorMapVMEs = function()
    local map = GetMapName()
    local map_sectors = {}
    local entrance_marker_err_sector_ids = {}
    local entrance_marker_dirs = {}
    local neighbors_with_map = {}
    for c_id, c in pairs(CampaignPresets) do
      for s_id, s in pairs(c.Sectors or empty_table) do
        if s.Map == map and not s.GroundSector then
          map_sectors[c_id] = map_sectors[c_id] or {}
          table.insert(map_sectors[c_id], s)
          neighbors_with_map[s] = {}
          for _, dir in ipairs(const.WorldDirections) do
            local n_id = GetNeighborSector(s.Id, dir, c)
            local idx = table.find(c.Sectors, "Id", n_id)
            local n = c.Sectors[idx]
            if n and n.Map then
              neighbors_with_map[s][dir] = true
            end
          end
        end
      end
    end
    if next(map_sectors) then
      for c_id, sectors in pairs(map_sectors) do
        for _, sector in ipairs(sectors) do
          if mapdata.ScriptingStatus == "Ready" then
            local intel_marker = MapGetFirst("map", "IntelMarker")
            if not intel_marker and sector.Intel then
              StoreErrorSource(point30, "No intel markers on a sector with intel - " .. sector.Id)
            end
            if intel_marker and not sector.Intel then
              StoreErrorSource(intel_marker, "Intel marker(s) on a sector without intel - " .. sector.Id)
            end
          end
          local def_markers = MapGetMarkers("DefenderPriority", false, function(m)
            return m.ArchetypesTriState
          end)
          if def_markers then
            for _, def_marker in ipairs(def_markers) do
              local errorMsg = def_marker:GetError()
              if errorMsg then
                StoreErrorSource(def_marker, errorMsg)
              end
            end
          end
        end
      end
    end
  end
  OnMsg.PostSaveMap = ShowSectorMapVMEs
  OnMsg.NewMapLoaded = ShowSectorMapVMEs
end
function SpawnSquadUnits(session_ids, positions, marker_angle, defender_marker, entrance_marker)
  for i, session_id in ipairs(session_ids) do
    local unit_data = gv_UnitData[session_id]
    unit_data.already_spawned_on_map = true
    local angle = type(marker_angle) == "table" and marker_angle[i] or marker_angle
    local groups, routine, routine_area, name
    local marker = IsValid(defender_marker) and defender_marker or type(defender_marker) == "table" and defender_marker[i]
    if IsEnemySquad(unit_data.Squad) then
      groups = {"EnemySquad"}
      if marker and marker.Groups then
        table.iappend(groups, marker.Groups)
      end
    end
    if IsGridMarkerWithDefenderRole(marker) then
      routine = marker.Routine
      routine_area = marker.RoutineArea
      name = marker.Name
    end
    if positions[i] then
      local class = unit_data.class
      local unit = SpawnUnit(class, session_id, positions[i], angle, groups, nil, entrance_marker)
      if routine ~= nil then
        unit.routine = routine
      end
      if routine_area ~= nil then
        unit.routine_area = routine_area
      end
      if name and name ~= "" then
        unit.Name = name
      end
      unit.routine_spawner = marker
    end
  end
end
local InsertMarkerInfo = function(markers_info, marker_type, key, session_id)
  markers_info[marker_type][key] = markers_info[marker_type][key] or {}
  table.insert(markers_info[marker_type][key], session_id)
end
function FillMarkerInfoExplore(markers_info, squads_to_spawn)
  for squad_id, session_ids in sorted_pairs(squads_to_spawn) do
    local squad = gv_Squads[squad_id]
    for _, session_id in ipairs(session_ids) do
      local unit_data = gv_UnitData[session_id]
      if squad.Side == "ally" and squad.militia then
        InsertMarkerInfo(markers_info, "defend_priority", squad_id, session_id)
      elseif not unit_data.arrival_dir then
        InsertMarkerInfo(markers_info, "defend", squad_id, session_id)
      else
        InsertMarkerInfo(markers_info, "entrance", unit_data.arrival_dir, session_id)
      end
    end
  end
end
function SpawnOnDefenderPriorityMarkerPositions(session_ids)
  if #session_ids <= 0 then
    return session_ids
  end
  local def_markers = MapGetMarkers("DefenderPriority", false, function(m)
    if not m:IsMarkerEnabled() then
      return false
    end
    local passSlab = SnapToPassSlab(m)
    if not passSlab or IsOccupiedExploration(nil, passSlab:xyz()) then
      return false
    end
    return true
  end)
  local remaining_sids = table.copy(session_ids)
  local unitToMarker = {}
  local occupied_priority_markers = {}
  for _, marker in ipairs(def_markers) do
    if marker.UnitDef then
      for _, sid in ipairs(remaining_sids) do
        local unitData = gv_UnitData[sid]
        if unitData.class == marker.UnitDef then
          unitToMarker[sid] = marker
          occupied_priority_markers[marker] = true
          table.remove_value(remaining_sids, sid)
          break
        end
      end
    end
  end
  local roleToMarker = {}
  local enemyRoles = Presets.EnemyRole.Default
  for i, rolePreset in ipairs(enemyRoles) do
    local role = rolePreset.id
    local thisRoleMarkers = {}
    for _, def_marker in ipairs(def_markers) do
      local overwriteBeastOnMarker = false
      local shouldSpawn = false
      if def_marker.Archetypes and next(def_marker.Archetypes) then
        shouldSpawn = not not table.find(def_marker.Archetypes, role)
        overwriteBeastOnMarker = shouldSpawn
      elseif def_marker.ArchetypesTriState then
        local onlyDisabledOthers = def_marker.ArchetypesTriState[role] == nil and table.values(def_marker.ArchetypesTriState)[1] == false
        local enabledMe = def_marker.ArchetypesTriState[role]
        shouldSpawn = onlyDisabledOthers or enabledMe
        overwriteBeastOnMarker = enabledMe
      end
      if role == "Beast" and not overwriteBeastOnMarker then
        local floor = GetFloorOfPos(def_marker:GetPos())
        if 1 <= floor then
          shouldSpawn = false
        end
      end
      if shouldSpawn then
        table.insert(thisRoleMarkers, def_marker)
      end
    end
    roleToMarker[role] = thisRoleMarkers
  end
  for sIdx, sid in ipairs(remaining_sids) do
    local ud = gv_UnitData[sid]
    local unitRole = ud.role
    if unitRole then
      local markers = roleToMarker[unitRole]
      if #markers ~= 0 then
        for i, m in ipairs(markers) do
          if not occupied_priority_markers[m] then
            unitToMarker[sid] = m
            occupied_priority_markers[m] = true
            remaining_sids[sIdx] = nil
            break
          end
        end
      end
    end
  end
  table.compact(remaining_sids)
  for _, marker in ipairs(def_markers) do
    for _, sid in ipairs(remaining_sids) do
      if not occupied_priority_markers[marker] then
        unitToMarker[sid] = marker
        occupied_priority_markers[marker] = true
        table.remove_value(remaining_sids, sid)
        break
      end
    end
  end
  local result_sids, spawn_positions, spawn_angles, spawn_markers = {}, {}, {}, {}
  for _, sid in ipairs(session_ids) do
    local marker = unitToMarker[sid]
    if marker then
      result_sids[#result_sids + 1] = sid
      spawn_positions[#spawn_positions + 1] = SnapToPassSlab(marker)
      spawn_angles[#spawn_angles + 1] = marker:GetAngle()
      spawn_markers[#spawn_markers + 1] = marker
    end
  end
  SpawnSquadUnits(result_sids, spawn_positions, spawn_angles, spawn_markers)
  return remaining_sids
end
function FillDefenderMarkerPositions(count, spawn_positions, spawn_angles, spawn_markers)
  if count <= 0 then
    return
  end
  local markers = MapGetMarkers("Defender", false, function(m)
    return m:IsMarkerEnabled()
  end)
  if not markers or #markers == 0 then
    StoreErrorSource(false, "No enabled Defender markers found on map")
    markers = MapGetMarkers("Entrance")
  end
  local _, positions, _, meta = GetRandomSpreadSpawnMarkerPositions(markers, count)
  for i, pos in ipairs(positions) do
    local positionMeta = meta[i]
    spawn_positions[#spawn_positions + 1] = pos
    spawn_angles[#spawn_angles + 1] = positionMeta[2]
    spawn_markers[#spawn_markers + 1] = positionMeta[3]
  end
end
MapVar("g_GroupedSquadUnits", {})
local cardinalToAngle = {
  North = 0,
  East = 90,
  South = 180,
  West = 270
}
DefineClass.AutoGeneratedEntranceMarker = {
  __parents = {
    "GameDynamicSpawnObject",
    "SyncObject",
    "GridMarker"
  },
  exit_zone_interactable = false,
  underground = false
}
function AutoGeneratedEntranceMarker:SetDynamicData(data)
  if data.exit_zone_handle then
    local handle = data.exit_zone_handle
    local exitZone = HandleToObject[handle]
    if IsKindOf(exitZone, "ExitZoneInteractable") then
      local underground = data.underground
      if underground then
        GenerateUndergroundMarker(exitZone, self)
      else
        GenerateEntranceMarker(exitZone, self)
      end
    end
  end
end
function AutoGeneratedEntranceMarker:GetDynamicData(data)
  if self.exit_zone_interactable then
    data.exit_zone_handle = self.exit_zone_interactable:GetHandle()
    data.underground = self.underground
  end
end
function GenerateUndergroundMarker(exitZoneInteractable, placedMarker)
  local direction = exitZoneInteractable.Groups[1]
  local markersInThisDirection = MapGetMarkers("Entrance", direction, function(marker)
    return marker ~= placedMarker
  end)
  if 0 < #markersInThisDirection then
    return
  end
  local fakeMarker = placedMarker or PlaceObject("AutoGeneratedEntranceMarker")
  fakeMarker:ClearGameFlags(const.gofPermanent)
  fakeMarker:SetType("Entrance")
  fakeMarker:SetGroups(exitZoneInteractable.Groups)
  fakeMarker:SetPos(SnapToVoxel(exitZoneInteractable:GetPos()))
  fakeMarker:SetAngle(exitZoneInteractable:GetAngle() - 5400)
  fakeMarker:SetAreaWidth(5)
  fakeMarker:SetAreaHeight(5)
  fakeMarker.GroundVisuals = true
  function fakeMarker.IsMarkerEnabled()
    return exitZoneInteractable:IsMarkerEnabled()
  end
  fakeMarker.underground = true
  fakeMarker.exit_zone_interactable = exitZoneInteractable
  table.insert(g_InteractableAreaMarkers, fakeMarker)
end
local lDeployAlongMapSize = 5
function GenerateEntranceMarker(exitZoneInteractable, placedMarker)
  local direction = exitZoneInteractable.Groups[1]
  local entranceMarkerPos = exitZoneInteractable:GetPos()
  local markersInThisDirection = MapGetMarkers("Entrance", direction, function(marker)
    return marker ~= placedMarker
  end)
  if 0 < #markersInThisDirection then
    return
  end
  local fakeMarker = placedMarker or PlaceObject("AutoGeneratedEntranceMarker")
  fakeMarker:ClearGameFlags(const.gofPermanent)
  fakeMarker:SetType("Entrance")
  fakeMarker:SetGroups({direction})
  fakeMarker.GroundVisuals = true
  fakeMarker.underground = false
  fakeMarker.exit_zone_interactable = exitZoneInteractable
  table.insert(g_InteractableAreaMarkers, fakeMarker)
  local mapDir = mapdata.MapOrientation - cardinalToAngle[direction]
  local mapCenter = point(terrain.GetMapSize()) / 2
  local bam = GetBorderAreaMarker()
  local mapDirectionSide = (GetMapPositionAlongOrientation(mapDir) - mapCenter + bam:GetPos()):SetInvalidZ()
  local borderBox = GetBorderAreaLimits()
  local bamCenter = borderBox:Center()
  mapDirectionSide = ClampPoint(mapDirectionSide, borderBox)
  local sizex, sizey = borderBox:sizexyz()
  if direction == "East" or direction == "West" then
    local offset = sign(entranceMarkerPos:x() - mapDirectionSide:x()) * const.SlabSizeX * lDeployAlongMapSize / 2
    mapDirectionSide = point(mapDirectionSide:x() + offset, mapDirectionSide:y())
    mapDirectionSide = SnapToVoxel(mapDirectionSide)
    if not GetPassSlab(mapDirectionSide) then
      mapDirectionSide = entranceMarkerPos
    end
    fakeMarker:SetPos(mapDirectionSide)
    fakeMarker:SetAreaWidth(lDeployAlongMapSize)
    local offsetFromCenter = abs(entranceMarkerPos:y() - bamCenter:y())
    sizey = sizey + offsetFromCenter * 2
    sizey = DivCeil(sizey, const.SlabSizeY)
    if sizey % 2 == 0 then
      sizey = sizey + 1
    end
    fakeMarker:SetAreaHeight(sizey)
    mapDir = (mapDir - 90) % 360
    fakeMarker:SetAngle(mapDir * 60)
  elseif direction == "North" or direction == "South" then
    local offset = sign(entranceMarkerPos:y() - mapDirectionSide:y()) * const.SlabSizeY * lDeployAlongMapSize / 2
    mapDirectionSide = point(mapDirectionSide:x(), mapDirectionSide:y() + offset)
    mapDirectionSide = SnapToVoxel(mapDirectionSide)
    if not GetPassSlab(mapDirectionSide) then
      mapDirectionSide = entranceMarkerPos
    end
    fakeMarker:SetPos(mapDirectionSide)
    fakeMarker:SetAreaHeight(lDeployAlongMapSize)
    local offsetFromCenter = abs(entranceMarkerPos:x() - bamCenter:x())
    sizex = sizex + offsetFromCenter * 2
    sizex = DivCeil(sizex, const.SlabSizeX)
    if sizex % 2 == 0 then
      sizex = sizex + 1
    end
    fakeMarker:SetAreaWidth(sizex)
    mapDir = (mapDir + 90) % 360
    fakeMarker:SetAngle(mapDir * 60)
  end
end
function SpawnSquads(squad_ids, spawn_mode, spawn_markers, force_test_map, remove_dead)
  g_GroupedSquadUnits = {}
  local squads_to_spawn = {}
  local map_combat_units = MapGet("map", "Unit") or empty_table
  for i = #map_combat_units, 1, -1 do
    local obj = map_combat_units[i]
    local session_id = obj.session_id
    local delete_obj
    if not obj.spawner or obj.Squad then
      local squad_units = table.find(squad_ids, obj.Squad) and gv_Squads[obj.Squad] and gv_Squads[obj.Squad].units or empty_table
      local missing = (remove_dead or not obj:IsDead()) and not table.find(squad_units, session_id)
      local should_respawn = gv_UnitData[session_id] and not gv_UnitData[session_id].already_spawned_on_map
      delete_obj = missing or should_respawn
    elseif remove_dead and obj.spawner and obj:IsDead() and not obj:IsPersistentDead() and obj:HasPassedTimeAfterDeath(const.Satellite.RemoveDeadBodiesAfter) then
      delete_obj = true
    end
    if delete_obj then
      if obj:IsDead() then
        local sector = gv_Sectors[gv_CurrentSectorId]
        local diedHere = next(sector.dead_units) and table.find(sector.dead_units, session_id)
        if diedHere then
          table.remove_value(sector.dead_units, obj.session_id)
          obj:DropAllItemsInAContainer()
        end
        obj:Despawn()
      else
        DoneObject(obj)
      end
      table.remove(map_combat_units, i)
    end
  end
  for _, squad_id in ipairs(squad_ids) do
    local squad = gv_Squads[squad_id]
    for _, session_id in ipairs(squad.units) do
      if not table.find_value(map_combat_units, "session_id", session_id) and not gv_UnitData[session_id].retreat_to_sector then
        squads_to_spawn[squad_id] = squads_to_spawn[squad_id] or {}
        table.insert(squads_to_spawn[squad_id], session_id)
      end
    end
  end
  if spawn_mode then
    local markers_info = {
      defend_priority = {},
      defend = {},
      entrance = {}
    }
    local sorted_group_on_markers = {}
    if spawn_mode == "explore" then
      FillMarkerInfoExplore(markers_info, squads_to_spawn)
    else
      for squad_id, session_ids in sorted_pairs(squads_to_spawn) do
        local squad = gv_Squads[squad_id]
        if spawn_markers and spawn_markers[squad_id] then
          local marker_type, marker_group = table.unpack(spawn_markers[squad_id])
          local markers = MapGetMarkers(marker_type, marker_group, function(m)
            return m:IsMarkerEnabled()
          end)
          local _, positions, marker_angle = GetRandomSpawnMarkerPositions(markers, #session_ids)
          SpawnSquadUnits(session_ids, positions, marker_angle)
        elseif (squad.Side == "enemy1" or squad.Side == "enemy2") and spawn_mode == "defend" then
          local markers = GetAvailableEntranceMarkers(gv_UnitData[session_ids[1]].arrival_dir)
          local idx = 0
          while idx < #session_ids do
            local marker = table.interaction_rand(markers, "SpawnEnemies")
            local count = Min(InteractionRandRange(2, 4), #session_ids - idx)
            if idx + count == #session_ids - 1 then
              count = count + 1
            end
            local group_on_marker = {marker}
            table.insert(sorted_group_on_markers, group_on_marker)
            for i = idx + 1, idx + count do
              InsertMarkerInfo(markers_info, "entrance", #sorted_group_on_markers, session_ids[i])
              idx = idx + 1
            end
          end
        else
          for _, session_id in ipairs(session_ids) do
            local unit_data = gv_UnitData[session_id]
            if force_test_map then
              unit_data.arrival_dir = "North"
            end
            if spawn_mode == "defend" and (squad.Side == "player1" or squad.Side == "ally") and squad.militia or spawn_mode == "attack" and squad.Side ~= "player1" then
              InsertMarkerInfo(markers_info, "defend_priority", squad_id, session_id)
            elseif spawn_mode == "defend" and squad.Side == "player1" then
              InsertMarkerInfo(markers_info, "defend", squad_id, session_id)
            else
              InsertMarkerInfo(markers_info, "entrance", unit_data.arrival_dir, session_id)
            end
          end
        end
      end
    end
    local occupied_priority_markers = {}
    for squad_id, session_ids in sorted_pairs(markers_info.defend_priority) do
      local spawn_positions, spawn_angles, spawn_markers = {}, {}, {}
      local remaining = SpawnOnDefenderPriorityMarkerPositions(session_ids)
      if 0 < #remaining then
        local squadUnits = markers_info.defend[squad_id]
        if not squadUnits then
          markers_info.defend[squad_id] = remaining
        else
          local list = markers_info.defend[squad_id]
          for i, session_id in ipairs(remaining) do
            list[#list + 1] = session_id
          end
        end
      end
    end
    local allSquadsFlattened = {}
    for squad_id, session_ids in sorted_pairs(markers_info.defend) do
      table.iappend(allSquadsFlattened, session_ids)
    end
    do
      local spawn_positions, spawn_angles, spawn_markers = {}, {}, {}
      FillDefenderMarkerPositions(#allSquadsFlattened, spawn_positions, spawn_angles, spawn_markers)
      SpawnSquadUnits(allSquadsFlattened, spawn_positions, spawn_angles, spawn_markers)
    end
    local positions_per_marker = {}
    for key, session_ids in sorted_pairs(markers_info.entrance) do
      local markers, marker, positions, marker_angle
      if type(key) == "string" then
        markers = MapGetMarkers("Entrance", key, function(marker)
          return SnapToPassSlab(marker)
        end)
        if not markers or #markers == 0 then
          StoreErrorSource(session_ids, string.format("No enabled Entrance markers found on map '%s' with key '%s' - trying random entrance marker instead!", GetMapName(), key))
          markers = MapGetMarkers("Entrance")
          if not markers or #markers == 0 then
            StoreErrorSource(session_ids, string.format("No enabled Entrance markers found on map '%s'!", GetMapName()))
            return
          end
        end
        NetUpdateHash("GetRandomSpawnMarkerPositions1", #session_ids, table.unpack(markers))
        marker, positions, marker_angle = GetRandomSpawnMarkerPositions(markers, #session_ids, "around_center")
        NetUpdateHash("GetRandomSpawnMarkerPositions2", table.unpack(positions))
      else
        if type(key) == "number" or type(key) == "boolean" then
          if not key then
            markers = MapGetMarkers("Entrance")
          else
            markers = sorted_group_on_markers[key]
          end
          if not markers or #markers == 0 then
            StoreErrorSource(session_ids, string.format("No enabled Entrance markers found on map '%s'!", GetMapName()))
            markers = MapGetMarkers("Entrance")
          end
          marker, positions, marker_angle = GetRandomPositionsFromSpawnMarkersMaxDistApart(markers, #session_ids, positions_per_marker)
          g_GroupedSquadUnits[#g_GroupedSquadUnits + 1] = session_ids
        else
        end
      end
      SpawnSquadUnits(session_ids, positions, marker_angle, nil, marker)
    end
  elseif spawn_markers then
    for squad_id, session_ids in sorted_pairs(squads_to_spawn) do
      local marker_type, marker_group = table.unpack(spawn_markers[squad_id] or empty_table)
      local markers = MapGetMarkers(marker_type, marker_group, function(m)
        return m:IsMarkerEnabled()
      end)
      local _, positions, marker_angle = GetRandomSpawnMarkerPositions(markers, #session_ids)
      SpawnSquadUnits(session_ids, positions, marker_angle)
    end
  end
end
MapVar("g_GoingAboveground", false)
local shouldSpawnSquad = function(squad, sector, ignore_travel)
  return squad.CurrentSector == sector.Id and (not IsSquadTravelling(squad) or ignore_travel) and not squad.arrival_squad
end
LoadSectorThread = false
local enterSectorThread = false
local doneEnterSector = false
function EnterSector(sector_id, spawn_mode, spawn_markers, save_sector, force_test_map, game_start)
  if IsValidThread(enterSectorThread) then
    return
  end
  enterSectorThread = CurrentThread()
  doneEnterSector = false
  NetGossip("EnterSector", sector_id, spawn_mode, GetCurrentPlaytime(), game_start)
  if netInGame and GetMapName() ~= "" and not GetGamePause() and not IsGameReplayRunning() then
    FireNetSyncEventOnHost("EnteringSectorSync")
    local state = {entering_sector = true}
    local timeout = 5000
    local start_ts = GetPreciseTicks()
    while not MatchGameState(state) and timeout > GetPreciseTicks() - start_ts do
      WaitMsg("GameStateChanged", timeout)
    end
  end
  ChangeGameState({entering_sector = true})
  local sat_view_loading_screen = GameState.loading_savegame and gv_SatelliteView
  local id = sat_view_loading_screen and "idSatelliteView" or "idEnterSector"
  SectorLoadingScreenOpen(id, "enter sector", not sat_view_loading_screen and sector_id)
  while IsAutosaveScheduled() do
    Sleep(1)
  end
  local sector = gv_Sectors[sector_id]
  local ambient_timeouted
  if sector and not GameState.loading_savegame then
    ambient_timeouted = sector.last_enter_campaign_time and Game.CampaignTime - sector.last_enter_campaign_time > const.AmbientLife.SatelliteTimeout
    sector.last_enter_campaign_time = Game.CampaignTime
    if sector.conflict then
      sector.conflict.waiting = false
      SetCampaignSpeed(0, "SatelliteConflict")
    end
    CheckSectorRadioStations(sector)
  end
  SkipAnySetpieces()
  ChangeGameState("setpiece_playing", false)
  NetSyncEventFence("init_buffer")
  NetGameSend("rfnClearHash")
  NetStartBufferEvents()
  if not GameState.loading_savegame then
    local units = table.copy(g_Units)
    for i, u in ipairs(units) do
      if u.ephemeral then
        u:Despawn()
      elseif not IsMerc(u) then
        u:FastForwardCommand()
      end
    end
  end
  if save_sector then
    GatherSectorDynamicData()
  end
  NetSyncEvents.CloseSatelliteView(true)
  OnSatViewClosed()
  gv_CurrentSectorId = sector_id
  g_GoingAboveground = false
  for _, squad in ipairs(g_SquadsArray) do
    if shouldSpawnSquad(squad, sector) and IsSectorUnderground(squad.PreviousSector) then
      g_GoingAboveground = true
      break
    end
  end
  if Platform.developer then
    local postMapLoaded = false
    CreateRealTimeThread(function()
      WaitMsg("PostNewMapLoaded")
      postMapLoaded = true
    end)
    local genSyncHandleOld = GenerateSyncHandle
    function GenerateSyncHandle(...)
      if postMapLoaded then
        GenerateSyncHandle = genSyncHandleOld
      else
      end
      return genSyncHandleOld(...)
    end
  end
  spawn_mode = force_test_map and "attack" or spawn_mode
  local load_game = not spawn_mode and not spawn_markers
  ChangeGameState({loading_savegame = true})
  ChangeMap(force_test_map or sector.Map or "__CombatTest")
  ChangeGameState({loading_savegame = false, entered_sector = true})
  ApplyDynamicData()
  for _, direction in sorted_pairs(const.WorldDirections) do
    local exitZoneInt = MapGetMarkers("ExitZoneInteractable", direction)
    exitZoneInt = exitZoneInt and exitZoneInt[1]
    local neighbour = exitZoneInt and GetNeighborSector(sector_id, direction)
    local validDirection = neighbour and not SectorTravelBlocked(neighbour, sector_id, false, "land_water_river")
    if force_test_map or validDirection then
      GenerateEntranceMarker(exitZoneInt)
    end
  end
  local underground = MapGetMarkers("ExitZoneInteractable", false, ExitZoneInteractable.IsUndergroundExit)
  for i, exitZoneInt in ipairs(underground) do
    GenerateUndergroundMarker(exitZoneInt)
  end
  if not load_game then
    local udHere = GetPlayerMercsInSector()
    for i, uId in ipairs(udHere) do
      local ud = gv_UnitData[uId]
      if ud and ud.retreat_to_sector then
        CancelUnitRetreat(ud)
      end
    end
  end
  if not load_game then
    gv_Deployment = false
  end
  local deployment = not force_test_map and not SkipDeployment(spawn_mode)
  if deployment then
    SetDeploymentMode(spawn_mode or gv_Deployment)
  end
  if not load_game then
    local squad_ids = {}
    if force_test_map then
      table.insert(squad_ids, 1)
    else
      for _, squad in ipairs(g_SquadsArray) do
        if shouldSpawnSquad(squad, sector) then
          table.insert(squad_ids, squad.UniqueId)
        end
      end
    end
    if #squad_ids == 0 and IsSectorUnderground(sector_id) then
      for _, squad in ipairs(g_SquadsArray) do
        if shouldSpawnSquad(squad, sector, "ignore travel") then
          table.insert(squad_ids, squad.UniqueId)
        end
      end
    end
    SpawnSquads(squad_ids, spawn_mode, spawn_markers, force_test_map, "remove_dead")
  end
  SetupTeamsFromMap()
  UpdateSpawnersLocal()
  Msg("EnterSector", game_start, load_game)
  if not load_game or ambient_timeouted then
    Msg("AmbientLifeSpawn")
  end
  if not load_game and gv_CurrentSectorId and gv_Sectors[gv_CurrentSectorId] and gv_Sectors[gv_CurrentSectorId].Map == GetMapName() then
    ExecuteSectorEvents("SE_OnEnterMap", gv_CurrentSectorId, "wait")
  end
  if netInGame then
    if load_game then
      local rez = NetWaitGameStart()
      if rez == "timeout" then
        if NetIsHost() then
          NetEvent("RemoveClient", 2, "timeout")
        else
          NetLeaveGame("timeout")
        end
      end
      AdvanceToGameTimeLimit = GameTime()
    end
    Resume("net")
  end
  SectorLoadingScreenClose(id, "enter sector", not sat_view_loading_screen and sector_id)
  NetStopBufferEvents()
  if not load_game and gv_CurrentSectorId and gv_Sectors[gv_CurrentSectorId] and gv_Sectors[gv_CurrentSectorId].Map == GetMapName() then
    ExecuteSectorEvents("SE_OnEnterMapVisual", gv_CurrentSectorId, true)
    CreateOnEnterMapVisualMsg()
  end
  NetSyncEventFence()
  enterSectorThread = false
  SetupDeployOrExploreUI(load_game)
  if not load_game and (not deployment or gv_DeploymentStarted) then
    RequestAutosave({
      autosave_id = "sectorEnter",
      save_state = "SectorEnter",
      display_name = T({
        841930548612,
        "<u(Id)>_SectorEnter",
        gv_Sectors[gv_CurrentSectorId]
      }),
      mode = "delayed"
    })
  end
  NetSyncEvent("DoneEnterSector", netUniqueId)
end
function NetSyncEvents.EnteringSectorSync()
  ChangeGameState({entering_sector = true})
end
function NetSyncEvents.DoneEnterSector(id)
  doneEnterSector = doneEnterSector or {}
  if id then
    doneEnterSector[id] = true
  end
  if not netInGame or table.count(doneEnterSector) >= table.count(netGamePlayers) then
    ChangeGameState({entering_sector = false})
  end
end
function OnMsg.NetPlayerLeft(player, reason)
  if GameState.entering_sector and doneEnterSector and not doneEnterSector[player.id] then
    NetSyncEvents.DoneEnterSector()
  end
end
function LoadSector(sector_id, spawn_mode)
  if IsValidThread(enterSectorThread) then
    return
  end
  local multiplayer = IsCoOpGame()
  if multiplayer then
    Pause("net")
  end
  LoadSectorThread = CreateRealTimeThread(function(multiplayer, sector_id, spawn_mode)
    if multiplayer then
    end
    LocalLoadSector(sector_id, spawn_mode, nil, "saveSector")
  end, multiplayer, sector_id, spawn_mode)
end
function LocalLoadSector(sector_id, spawn_mode, spawn_markers, save_sector, force_test_map, game_start)
  if not EnterFirstSector(sector_id) then
    EnterSector(sector_id, spawn_mode, spawn_markers, save_sector, force_test_map, game_start)
  end
end
function EnterFirstSector(sector_id, force)
  local campaignPreset = GetCurrentCampaignPreset()
  local init_sector = campaignPreset.InitialSector
  local thisIsFirstSector = force
  if not thisIsFirstSector and sector_id == init_sector then
    thisIsFirstSector = not GameState.entered_sector
    if not thisIsFirstSector then
      local conflictHere = gv_Sectors[sector_id]
      conflictHere = conflictHere and conflictHere.conflict
      thisIsFirstSector = conflictHere and conflictHere.initial_sector
    end
  end
  if thisIsFirstSector then
    local conflict = gv_Sectors[sector_id]
    conflict = conflict and conflict.conflict
    if conflict then
      conflict.initial_sector = true
    end
    local spawn_markers = {}
    local markers = {"Defender", "GameIntro"}
    for i, s in ipairs(GetPlayerMercSquads()) do
      if s.CurrentSector == sector_id then
        spawn_markers[s.UniqueId] = markers
      end
    end
    EnterSector(init_sector, nil, spawn_markers, true, nil, "game_start")
    return true
  end
end
function OnMsg.StartSatelliteGameplay()
  if not GameState.entered_sector then
    local initialSector = GetCurrentCampaignPreset().InitialSector
    if IsConflictMode(initialSector) then
      OpenSatelliteConflictDlg(gv_Sectors[initialSector])
    end
  end
end
function OnMsg.ChangeMap()
  ChangeGameState({entered_sector = false})
end
function OnMsg.NewGameSessionStart()
  ChangeGameState({entered_sector = false})
end
function OnMsg.DoneGame()
  ChangeGameState({entered_sector = false, entering_sector = false})
  DeleteThread(enterSectorThread)
  DeleteThread(doneEnterSector)
  DeleteThread(LoadSectorThread)
end
function IsSectorUnderground(id)
  return gv_Sectors[id] and not not gv_Sectors[id].GroundSector
end
DefineConstInt("Satellite", "CoOpCountdownSeconds", 3, false, "The length of the countdown to enter satellite view in co-op.")
local lCloseSatelliteCountdowns = function()
  for d, _ in pairs(g_OpenMessageBoxes) do
    if d and d.window_state == "open" and d.context.obj == "satellite-countdown" then
      d:Close()
    end
  end
end
function NetSyncEvents.StartSatelliteCountdown(mode, mode_param)
  if not CanYield() then
    CreateRealTimeThread(NetSyncEvents.StartSatelliteCountdown, mode, mode_param)
    return
  end
  lCloseSatelliteCountdowns()
  local dialog = CreateMessageBox(terminal.desktop, "", "", T(739643427177, "Cancel"), "satellite-countdown")
  local reason = "satellite-countdown"
  Pause(reason)
  PauseCampaignTime(reason)
  function dialog.OnDelete()
    Resume(reason)
    ResumeCampaignTime(reason)
  end
  local countdown_seconds = const.Satellite.CoOpCountdownSeconds
  dialog:CreateThread("countdown", function()
    local idText = dialog.idMain.idText
    local currentCountdown = countdown_seconds
    for i = 1, countdown_seconds do
      if idText.window_state == "open" then
        if mode == "open" then
          idText:SetText(T({
            766863202626,
            "<center>Entering Sat View in <u(currentCountdown)>",
            currentCountdown = currentCountdown
          }))
        elseif GameState.entered_sector then
          idText:SetText(T({
            628266992810,
            "<center>Closing Sat View in <u(currentCountdown)>",
            currentCountdown = currentCountdown
          }))
        else
          idText:SetText(T({
            552141784654,
            "<center>Starting game in <u(currentCountdown)>",
            currentCountdown = currentCountdown
          }))
        end
      else
        break
      end
      Sleep(1000)
      currentCountdown = currentCountdown - 1
      ObjModified(currentCountdown)
      if currentCountdown <= 1 then
        CancelDrag()
        CloseDialog("SatelliteConflict")
        CloseDialog("CoopMercsManagement")
        CloseDialogForReal("ModifyWeaponDlg", true)
        CloseDialog("FullscreenGameDialogs")
      end
    end
    dialog:Close()
    if mode == "open" then
      OpenSatelliteView()
    elseif mode == "close" and mode_param then
      UIEnterSectorInternal(table.unpack(mode_param))
    elseif mode == "close" then
      CloseDialog("PDADialogSatellite")
    else
      local pda = GetDialog("PDADialogSatellite")
      if pda then
        pda:SetMode(mode, mode_param, "skip_can_close")
      end
    end
  end)
  local res = dialog:Wait()
  if res == "ok" then
    NetSyncEvent("CancelSatelliteCountdown", mode, netUniqueId)
  end
end
function NetSyncEvents.CancelSatelliteCountdown(mode, player_id)
  lCloseSatelliteCountdowns()
  if mode == "open" then
    if player_id == netUniqueId then
      CombatLog("debug", T(Untranslated("Cancelled the transition to Sat View.")))
    else
      CombatLog("debug", T(Untranslated("<OtherPlayerName()> cancelled the transition to Sat View.")))
    end
  elseif player_id == netUniqueId then
    CombatLog("debug", T(Untranslated("Cancelled the transition from Sat View.")))
  else
    CombatLog("debug", T(Untranslated("<OtherPlayerName()> cancelled the transition from Sat View.")))
  end
end
function GetCitySectors(city)
  if not g_CitySectors then
    g_CitySectors = {}
    for id, sector in pairs(gv_Sectors) do
      local c = sector.City
      if c and c ~= "none" then
        g_CitySectors[c] = g_CitySectors[c] or {}
        table.insert(g_CitySectors[c], id)
      end
    end
  end
  return g_CitySectors[city]
end
if false then
  function GameTests.SatelliteView()
    CreateRealTimeThread(function()
      QuickStartCampaign()
      gv_Sectors[gv_CurrentSectorId].ForceConflict = true
      ResolveConflict()
      Game.CampaignTimeFactor = 20
      Game.Campaign = DefaultCampaign
      OpenSatelliteView()
    end)
    WaitMsg("InitSatelliteView")
    CreateNewSatelliteSquad({
      Side = "player1",
      CurrentSector = "H11",
      Name = SquadName:GetNewSquadName("player1")
    }, {
      "Caesar",
      "Cass",
      "Cliff"
    }, 7)
    for _, s in ipairs(g_SquadsArray) do
      local route = GenerateRouteDijkstra(s.CurrentSector, "H10", s.route, s.units, nil, nil, squad.Side)
      if route then
        SetSatelliteSquadRoute(s, {route})
      end
    end
    Sleep(const.Scale.h / 4)
    TestSaveLoadGame()
    for _, s in ipairs(g_SquadsArray) do
      local route = GenerateRouteDijkstra(s.CurrentSector, "J15", s.route, s.units, nil, nil, squad.Side)
      if route then
        SetSatelliteSquadRoute(s, {route})
      end
    end
    Sleep(const.Scale.h / 4)
    CloseSatelliteView(true)
    CloseDialog("InGameInterface")
    DoneGame()
  end
end
function OnMsg.NewDay()
  CreateMapRealTimeThread(function()
    RequestAutosave({
      autosave_id = "newDay",
      save_state = "NewDay",
      display_name = T({
        829706997018,
        "Day_<day>_<month()>",
        day = TFormat.day()
      }),
      mode = "delayed"
    })
  end)
  local mercs = CountPlayerMercsInSquads(false, "include_imp")
  CombatLog("important", T({
    102190343056,
    "The date is <day()> <month()> - You have <mercs_amount> Merc(s) and <money(money_value)>",
    mercs_amount = mercs,
    money_value = Game.Money
  }))
  ObjModified("day_display")
end
function OnMsg.LoadSessionData()
  if gv_SatelliteView and not IsCampaignPaused() then
    PauseCampaignTime("UI")
  end
end
function SectorPanelShowAlliedSection(sector)
  if not IsSectorRevealed(sector) then
    return false
  end
  local al, en = GetSquadsInSector(sector.Id, false, false)
  local anyAllies = next(al)
  local militiaSector = sector.Militia and (sector.Side == "player1" or sector.Side == "player2" or sector.Side == "ally")
  return anyAllies or militiaSector
end
function SectorPanelShowEnemySection(sector)
  if not IsSectorRevealed(sector) then
    return false
  end
  local al, en = GetSquadsInSector(sector.Id, false, true)
  return next(en)
end
