GameVar("gv_CombatTaskCDs", {})
function GenerateCombatTasks(amount)
  amount = amount or 1
  for i = 1, amount do
    local unitTasks = GetAvailableCombatTasks()
    if #unitTasks <= 0 then
      print("No more eligible combat tasks.")
      return
    end
    local unitTaskCombo = unitTasks[InteractionRand(#unitTasks, "CombatTasks") + 1]
    local unitId = unitTaskCombo.unitId
    local taskId
    local favouredRoll = InteractionRand(100, "CombatTasks")
    if 0 < #unitTaskCombo.favoured and favouredRoll < const.CombatTask.FavouredChance then
      taskId = unitTaskCombo.favoured[InteractionRand(#unitTaskCombo.favoured, "CombatTasks") + 1]
    else
      taskId = unitTaskCombo.general[InteractionRand(#unitTaskCombo.general, "CombatTasks") + 1]
    end
    local taskDef = CombatTaskDefs[taskId]
    GiveCombatTask(taskDef, unitId)
  end
  RefreshCombatTasks()
  return true
end
function GetAvailableCombatTasks()
  local presets = PresetArray(CombatTask)
  local units = GetCurrentMapUnits()
  local result = {}
  for _, unit in ipairs(units) do
    if not gv_CombatTaskCDs[unit.session_id] or gv_CombatTaskCDs[unit.session_id] <= Game.CampaignTime then
      local availableTasks = {}
      for _, preset in ipairs(presets) do
        if (not gv_CombatTaskCDs[preset.id] or gv_CombatTaskCDs[preset.id] <= Game.CampaignTime) and preset:CanBeSelected(unit) then
          availableTasks[#availableTasks + 1] = preset.id
        end
      end
      if 0 < #availableTasks then
        result[#result + 1] = {}
        result[#result].unitId = unit.session_id
        result[#result].general = availableTasks
        local favouredTasks = {}
        for _, taskId in ipairs(availableTasks) do
          if CombatTaskDefs[taskId]:IsFavoured(unit) then
            favouredTasks[#favouredTasks + 1] = taskId
          end
        end
        result[#result].favoured = favouredTasks
      end
    end
  end
  return result
end
function GiveCombatTask(preset, unitId)
  local unit = g_Units[unitId]
  if not unit then
    return
  end
  CreateGameTimeThread(function()
    WaitLoadingScreenClose()
    Sleep(1000)
    PlayVoiceResponse(unit, "CombatTaskGiven")
  end)
  local cooldown = Game.CampaignTime + preset.cooldown
  gv_CombatTaskCDs[preset.id] = cooldown
  local mercCooldown = Game.CampaignTime + const.CombatTask.MercCooldown
  gv_CombatTaskCDs[unitId] = mercCooldown
  unit:AddCombatTask(preset.id)
  RefreshCombatTasks()
end
function GetCombatTasksInSector()
  if #g_Units <= 0 then
    return
  end
  local units = GetCurrentMapUnits()
  local tasks = {}
  for _, unit in ipairs(units) do
    for _, task in ipairs(unit.combatTasks) do
      tasks[#tasks + 1] = task
    end
  end
  return tasks
end
function FindActiveCombatTask(id)
  local units = GetCurrentMapUnits()
  for _, unit in ipairs(units) do
    local task = unit:FirstCombatTaskById(id)
    if task then
      return task
    end
  end
  return false
end
function RollForCombatTasks()
  local sector = gv_Sectors[gv_CurrentSectorId]
  if CountAnyEnemies("skipAnimals") < const.CombatTask.RequiredEnemies then
    return
  end
  if sector.combatTaskGenerate == "afterFirstConflict" and not sector.firstConflictWon then
    return
  end
  if sector.combatTaskGenerate ~= "always" then
    return
  end
  if gv_CombatTaskCDs[sector.Id] and Game.CampaignTime < gv_CombatTaskCDs[sector.Id] then
    return
  end
  local chance = const.CombatTask.ChanceToGive
  for i = 1, sector.combatTaskAmount do
    local roll = InteractionRand(100, "CombatTasks")
    if chance > roll then
      local success = GenerateCombatTasks(1)
      if success then
        local sectorCooldown = Game.CampaignTime + const.CombatTask.SectorCooldown
        gv_CombatTaskCDs[sector.Id] = sectorCooldown
      end
    end
  end
end
function NetSyncEvents.InitCombatTasks()
  if g_TestCombat and g_TestCombat.combatTask then
    local units = GetCurrentMapUnits()
    local unitId = units[InteractionRand(#units, "CombatTasks") + 1].session_id
    local preset = CombatTaskDefs[g_TestCombat.combatTask]
    GiveCombatTask(preset, unitId)
  else
    RollForCombatTasks()
  end
end
function OnMsg.EnterSector(game_start, load_game)
  if game_start or load_game or netInGame and not NetIsHost() then
    return
  end
  NetSyncEvent("InitCombatTasks")
end
function FinishCombatTasks()
  local tasks = GetCombatTasksInSector()
  for _, task in ipairs(tasks) do
    if task.state == "inProgress" then
      local completed = task.currentProgress >= task.requiredProgress and not task.reverseProgress or task.currentProgress < task.requiredProgress and task.reverseProgress
      if completed then
        task:Complete()
      else
        task:Fail()
      end
    end
  end
end
function OnMsg.UnitDieStart(unit)
  if CountAnyEnemies("skipAnimals") <= 0 and 0 < #GetCombatTasksInSector() then
    CreateGameTimeThread(function()
      WaitMsg("OnAttacked", 5000)
      FinishCombatTasks()
    end)
  end
end
function OnMsg.ConflictEnd(sector, bNoVoice, playerAttacking, playerWon, isAutoResolve, isRetreat, fromMap)
  if not sector.firstConflictWon and playerWon and IsPlayerSide(sector.Side) then
    sector.firstConflictWon = true
  end
end
function OnMsg.UnitDied(unit)
  if IsMerc(unit) then
    for _, task in ipairs(unit.combatTasks) do
      task:Fail()
    end
  end
end
function OnMsg.UnitRetreat(unit)
  if IsMerc(unit) then
    for _, task in ipairs(unit.combatTasks) do
      task:Fail()
    end
  end
end
MapVar("CombatTaskUIAnimations", {})
function RefreshCombatTasks()
  ObjModified("combat_tasks")
end
OnMsg.OpenSatelliteView = RefreshCombatTasks
OnMsg.CloseSatelliteView = RefreshCombatTasks
GameVar("gv_CombatTasksCompleted", 0)
GameVar("gv_RecentlyCompletedCombatTasks", {})
function OnMsg.CombatTaskFinished(taskId, unit, success)
  if success then
    gv_CombatTasksCompleted = gv_CombatTasksCompleted + 1
    gv_RecentlyCompletedCombatTasks[#gv_RecentlyCompletedCombatTasks + 1] = {
      taskId = taskId,
      unitId = unit.session_id
    }
    if gv_CombatTasksCompleted % const.CombatTask.CompletedForBonus == 0 then
      CombatTaskBonusReward()
      SendMercOfTheWeekEmail()
      gv_RecentlyCompletedCombatTasks = {}
    end
  end
end
function CombatTaskBonusReward()
  local bonus = const.CombatTask.BonusReward
  CombatLog("important", T(646683516115, "Combat task completion bonus received"))
  AddMoney(bonus, "deposit")
end
function SendMercOfTheWeekEmail()
  local emailGroup = Presets.Email.MercOfTheWeek
  local emailPreset = emailGroup[InteractionRand(#emailGroup, "CombatTasks") + 1]
  local combo = gv_RecentlyCompletedCombatTasks[InteractionRand(#gv_RecentlyCompletedCombatTasks, "CombatTasks") + 1]
  local context = {
    unitId = combo.unitId,
    taskId = combo.taskId,
    reward = const.CombatTask.BonusReward
  }
  ReceiveEmail(emailPreset.id, context)
end
