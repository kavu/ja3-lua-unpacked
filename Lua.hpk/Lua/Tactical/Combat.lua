function IsHotSeatGame()
  return Game and Game.game_type == "HotSeat"
end
function IsCompetitiveGame()
  return Game and Game.game_type == "Competitive"
end
function IsCoOpGame()
  return netInGame and not IsHotSeatGame() and not IsCompetitiveGame() and #netGamePlayers == 2
end
function NetPlayerSide(id)
  return netInGame and not NetIsHost(id) and IsCompetitiveGame() and "player2" or "player1"
end
function NetPlayerControlMask(id)
  if IsCoOpGame() or IsCompetitiveGame() then
    return NetIsHost(id) and -3 or 2
  end
  return -1
end
function IsNetPlayerTurn(id)
  local active_side = (g_Teams[g_CurrentTeam] or empty_table).side
  if active_side ~= "player1" and active_side ~= "player2" then
    return false
  end
  if netInGame and #netGamePlayers == 2 and IsCompetitiveGame() then
    local player_side = NetIsHost(id) and "player1" or "player2"
    if player_side ~= active_side then
      return false
    end
  end
  return true
end
function IsControlledByLocalPlayer(side, player_control)
  if side ~= "player1" and side ~= "player2" then
    return false
  end
  local mask = NetPlayerControlMask()
  if mask & player_control == 0 then
    return false
  end
  if IsHotSeatGame() then
    local active_side = g_Teams and (g_Teams[g_CurrentTeam] or empty_table).side
    return side == active_side
  end
  return true
end
if FirstLoad then
  g_Combat = false
  g_DefaultShotBodyPart = false
  g_CombatPath = false
  g_ShouldRebuildVisField = false
  g_LastAttackStealth = false
  g_LastAttackKill = false
end
function OnMsg.DoneMap()
  DoneObject(g_Combat)
  g_Combat = false
  g_CombatPath = false
  g_LastAttackStealth = false
  g_LastAttackKill = false
end
function OnMsg.DataLoaded()
  ForEachPresetInGroup("TargetBodyPart", "Default", function(def)
    if def.default then
      g_DefaultShotBodyPart = def.id
    end
  end)
end
function IsInCombat(pending)
  return g_Combat and not g_Combat.end_combat and (not pending or not g_Combat.end_combat_pending or not g_Combat:ShouldEndCombat())
end
function GetRandomTerrainVoxelPosAroundCenter(unit, center, radius)
  local cx, cy = center:xyz()
  local x = unit:Random(radius * 2) - radius
  local y = unit:Random(radius * 2) - radius
  local z = 0
  x, y, z = SnapToVoxel(cx + x, cy + y, z)
  return point(x, y)
end
function IsValidTarget(target)
  return IsValid(target) and (not IsKindOf(target, "Unit") or not target:IsDefeatedVillain() and not target:IsDead()) and target:IsValidPos()
end
function OnMsg.QuestParamChanged(id, var_id, prev_val, new_val)
  local quest = gv_Quests[id]
  if quest.Hidden then
    return
  end
  if not new_val or new_val == prev_val then
    return
  end
end
function OnMsg.CombatStart()
  ShowTacticalNotification("combatStart")
end
local CheckWeaponsAmmo = function(team_idx)
  local team = g_Teams[team_idx]
  team = GetFilteredCurrentTeam(team)
  local units = team.units
  if not units or not next(units) then
    return
  end
  for _, unit in ipairs(units) do
    if IsMerc(unit) and not unit.infinite_ammo then
      unit:ForEachItem("Firearm", function(item, slot, l, t)
        if item.ammo and item.MagazineSize >= 5 then
          local amount = item.ammo.Amount
          if amount < item.MagazineSize / 4 then
            item.low_ammo_checked = true
          end
        end
      end)
    end
  end
end
function OnMsg.TurnStart(g_CurrentTeam)
  if IsNetPlayerTurn() then
    ShowTacticalNotification("playerTurnStart")
    CheckWeaponsAmmo(g_CurrentTeam)
    UnlockCameraMovement(nil, "unlock_all")
    for _, unit in ipairs(g_ShowTargetBadge) do
      if unit.ui_badge then
        unit.ui_badge:SetActive(false)
      end
    end
    g_ShowTargetBadge = {}
    for i, t in ipairs(g_Teams) do
      if t.control == "UI" and NetPlayerSide(t.side) and t:HasAliveUnits() and g_Combat:AreEnemiesAware(g_CurrentTeam) then
        g_Combat:SelectBestUnit(t)
      end
    end
  end
end
MapVar("gv_CombatStartFromConversation", false)
MapVar("g_StartingCombat", false)
DefineClass.Combat = {
  __parents = {"InitDone"},
  combat_id = false,
  combat_started = false,
  player_end_turn = false,
  ai_end_turn = false,
  player_end_turn_local_effects = false,
  active_unit = false,
  active_unit_shown = false,
  starting_unit = false,
  units_repositioned = false,
  unit_reposition_shown = false,
  start_reposition_ended = false,
  camera_use = false,
  cinematic_kills_this_turn = false,
  thread = false,
  end_combat = false,
  end_combat_pending = false,
  enemies_engaged = false,
  retreat_enemies = false,
  time_of_day = "day",
  turns_no_visibility = 0,
  current_turn = 1,
  start_of_turn = false,
  team_playing = false,
  test_combat = false,
  queued_bombards = false,
  emplacement_assignment = false,
  visibility_update_hash = false,
  enemy_badges = false,
  enter_combat_anim_variants = false,
  enter_combat_anim_variants_time = false,
  skip_first_autosave = false,
  waiting_relations_update = false,
  autosave_enabled = false,
  log_ai_side = false,
  lastStandingVR = false,
  berserkVRsPerRole = false,
  stealth_attack_start = false,
  last_attack_kill = false,
  combat_time = false,
  hp_loss = false,
  hp_healed = false,
  turn_dist_travelled = false,
  out_of_ammo = false
}
function Combat:Init()
  self.combat_id = random_encode64(64)
  self.player_end_turn = {}
  self.units_repositioned = {}
  self.queued_bombards = {}
  self.emplacement_assignment = {}
  self.berserkVRsPerRole = {}
  self.combat_time = GetCurrentPlaytime()
  self.hp_loss = {}
  self.hp_healed = {}
  self.turn_dist_travelled = {}
  self.out_of_ammo = {}
end
function Combat:Done()
  if IsValidThread(self.thread) then
    DeleteThread(self.thread)
  end
  self.thread = nil
  self.emplacement_assignment = nil
  self.lastStandingVR = false
  self.berserkVRsPerRole = nil
end
function WaitUnitsInIdle(check_pending, callback)
  while true do
    local done = true
    for _, unit in ipairs(g_Units) do
      if not unit:IsDead() and unit:IsValidPos() and not unit:IsIdleCommand(check_pending) and (g_Combat or unit:IsAware(check_pending)) then
        done = false
        break
      end
    end
    if done then
      break
    end
    if callback then
      callback()
    end
    WaitMsg("Idle", 10)
  end
end
function WaitUnitsInIdleOrBehavior()
  while true do
    local done = true
    for _, unit in ipairs(g_Units) do
      if not unit:IsDead() and not unit:IsAmbientUnit() and not unit:IsIdleCommand() and (not unit.command or unit.command ~= unit.behavior) then
        done = false
        break
      end
    end
    if done then
      break
    end
    WaitMsg("Idle", 10)
  end
end
function Combat:Start(dynamic_data)
  NetUpdateHash("Combat:Start")
  g_CurrentTeam = g_CurrentTeam or 1
  self.current_turn = self.current_turn or 1
  SuspendVisibiltyUpdates("EnterCombat")
  Msg("CombatStarting", dynamic_data)
  CombatLog("debug", "Combat starting")
  if dynamic_data then
    for _, unit in ipairs(g_Units) do
      unit:UpdateMeleeTrainingVisual()
    end
    self.waiting_relations_update = true
    InvalidateDiplomacy()
  else
    for i, unit in ipairs(g_Units) do
      unit:ClearCommandQueue()
      if not unit:IsDead() and (not unit:IsDefeatedVillain() or unit.command ~= "VillainDefeat") then
        local overwatch = g_Overwatch[unit]
        local interruptable_cmd = unit.command ~= "Cower" and unit.command ~= "EnterMap"
        if interruptable_cmd and (not (overwatch and overwatch.permanent) or unit.command ~= "PreparedAttackIdle") then
          unit:InterruptCommand("EnterCombat")
        end
      end
    end
    WaitUnitsInIdle()
  end
  InvalidateVisibility()
  ResumeVisibiltyUpdates("EnterCombat")
  if not self.waiting_relations_update then
    self.autosave_enabled = self:ShouldEndCombat()
  end
  self.thread = CreateGameTimeThread(self.MainLoop, self, dynamic_data)
  if not gv_Sectors then
    return
  end
  gv_ActiveCombat = gv_CurrentSectorId
  g_StartingCombat = false
  Msg("CombatStart", dynamic_data, self)
  PlayFX("ConflictInitiated")
  LockCamera("CombatStarting")
  self:UpdateVisibility()
  UnlockCamera("CombatStarting")
end
function Combat:ShouldEndCombat(killed_units)
  killed_units = killed_units or empty_table
  local player_team
  for _, team in ipairs(g_Teams) do
    if team.side == "player1" or team.side == "player2" then
      local alive
      for _, unit in ipairs(team.units) do
        if not unit:IsDead() and not table.find(killed_units, unit) then
          alive = true
          break
        end
      end
      if alive then
        player_team = team
        break
      end
    end
  end
  if not player_team then
    return true
  end
  for _, team in ipairs(g_Teams) do
    if team:IsEnemySide(player_team) then
      for _, unit in ipairs(team.units) do
        if not unit:IsDead() and unit:IsAware("pending") and not table.find(killed_units, unit) then
          return false
        end
      end
    end
  end
  return true
end
function Combat:EndCombatCheck(force)
  if not force and HasAnyCombatActionInProgress() then
    return
  end
  if not self.end_combat and self:ShouldEndCombat() then
    self.end_combat = true
    self:CheckEndTurn()
  end
end
function Combat:CheckPendingEnd(killed_units)
  if self:ShouldEndCombat(killed_units) then
    self.end_combat_pending = true
  end
end
function Combat:SelectBestUnit(team, noFitCheck)
  local applyCameraSnap = true
  local allyClosest, bestRatio, highestEnemyCount, firstLocalControlled
  if self.starting_unit and self.starting_unit.team == team and self.starting_unit:IsLocalPlayerControlled() then
    allyClosest = self.starting_unit
    applyCameraSnap = false
  else
    for i, u in ipairs(team.units) do
      firstLocalControlled = firstLocalControlled or u:IsLocalPlayerControlled() and u or false
      if u:CanBeControlled() and not u:IsDowned() and u:IsLocalPlayerControlled() then
        local enemies = u:GetVisibleEnemies()
        local enemyCount = #enemies
        local closesnessRatio = 0
        for ii, e in ipairs(enemies) do
          closesnessRatio = closesnessRatio + u:GetDist(e)
        end
        if not allyClosest or highestEnemyCount < enemyCount then
          highestEnemyCount = enemyCount
          bestRatio = closesnessRatio
          allyClosest = u
        elseif enemyCount == highestEnemyCount and closesnessRatio < bestRatio or bestRatio == 0 then
          bestRatio = closesnessRatio
          allyClosest = u
        end
      end
    end
  end
  allyClosest = allyClosest or firstLocalControlled or team.units[1]
  SelectObj(allyClosest)
  AdjustCombatCamera("reset", nil, allyClosest, nil, nil, noFitCheck)
end
function OnMsg.SetpieceDialogClosed()
  NetSyncEvent("SetpieceDialogClosed")
end
function NetSyncEvents.SetpieceDialogClosed()
  Msg("SyncSetpieceDialogClosed")
end
local CombatAreEnemiesOutnumbered = function(unit)
  local targetPos = unit:GetVisualPos()
  local team = unit.team
  local counts = {friends = 0, enemies = 0}
  MapForEach(targetPos, const.SlabSizeX * 20, "Unit", function(u)
    if not IsValid(u) or u == unit or u:IsDead() then
      return false
    end
    local tm = u.team
    if team:IsEnemySide(tm) then
      counts.enemies = counts.enemies + 1
    else
      counts.friends = counts.friends + 1
    end
  end, counts)
  return counts.enemies - counts.friends >= 1
end
function CombatCollectOutnumbered(team_id, except)
  local units = {}
  local team = g_Teams[team_id]
  for _, unit in ipairs(team.units) do
    if (not except or not table.find(except, unit.session_id)) and IsMerc(unit) and CombatAreEnemiesOutnumbered(unit) then
      units[#units + 1] = unit.session_id
    end
  end
  return units
end
function Combat:MainLoop(dynamic_data)
  WaitSyncLoadingDone()
  local resume_saved_combat = not not dynamic_data
  local eot_marker_team = 1
  for i, team in ipairs(g_Teams) do
    if team.side == "player1" or team.side == "player2" then
      eot_marker_team = i
      break
    end
  end
  UpdateSurrounded()
  self.combat_started = true
  Msg("CombatStartedForReal", dynamic_data, self)
  local first_turn = true
  local outnumbered_units = {}
  while true do
    if IsSetpiecePlaying() then
      WaitMsg("SyncSetpieceDialogClosed")
    end
    local team = g_Teams[g_CurrentTeam]
    local enemies_alive, nonempty_player_teams
    for _, t in ipairs(g_Teams) do
      if (t.side == "player1" or t.side == "player2") and t:HasAliveUnits() then
        nonempty_player_teams = true
      end
      if t ~= team then
        local alive
        for _, unit in ipairs(t.units) do
          alive = alive or not unit:IsDead()
        end
        if alive and team:IsEnemySide(t) then
          enemies_alive = true
        end
      end
    end
    if not nonempty_player_teams then
      self:End()
      break
    end
    self:UpdateVisibility()
    self:ApplyVisibility()
    if self:ShouldEndDueToNoVisibility() then
      self:End()
      break
    end
    DeadUnitsPulse()
    WaitUnitsInIdle("pending", AlertPendingUnits)
    self.start_of_turn = true
    self.enemies_engaged = self.enemies_engaged or not self:ShouldEndCombat()
    for _, unit in ipairs(team.units) do
      if not unit:IsDead() then
        unit:BeginTurn(not resume_saved_combat)
        ObjModified(unit)
      end
    end
    NetUpdateHash("Combat_MainLoop_BeginTurn_End")
    self.start_of_turn = false
    WaitUnitsInIdle("pending", AlertPendingUnits)
    NetUpdateHash("Combat_MainLoop_WaitUnitsIdle_End")
    self.start_of_turn = true
    if not first_turn and not enemies_alive and (team.side == "player1" or team.side == "player2") then
      self:End()
      break
    end
    NetUpdateHash("Combat_MainLoop_ExecMoraleActions_Start")
    ExecMoraleActions()
    NetUpdateHash("Combat_MainLoop_ExecMoraleActions_End")
    while ActionCameraPlaying do
      WaitMsg("ActionCameraRemoved", 100)
    end
    NetUpdateHash("Combat_MainLoop_ActionCameraWait_End")
    if not resume_saved_combat then
      ActivateBombardZones(g_Teams[g_CurrentTeam].side)
      if self.current_turn ~= 1 then
        UpdateTimedExplosives(Traps_CombatTurnToTime, g_Teams[g_CurrentTeam].side)
      end
      TriggerTimedExplosives()
    end
    NetUpdateHash("Combat_MainLoop_BombardZones_End")
    self.start_of_turn = false
    self.cinematic_kills_this_turn = {}
    self.team_playing = g_CurrentTeam
    if IsNetPlayerTurn() then
      if IsCompetitiveGame() then
        ShowTurnNotification()
      end
      if not resume_saved_combat then
        PlayFX("PlayerCombatTurnStart", "start")
      end
      if (not resume_saved_combat or #Selection == 0) and self:AreEnemiesAware(g_CurrentTeam) then
        self:SelectBestUnit(team, "noFitCheck")
      end
      NetUpdateHash("Combat_MainLoop_SelectUnit_End")
      resume_saved_combat = false
      ObjModified(self)
      if self.skip_first_autosave then
        self.skip_first_autosave = false
      else
        if not self:ShouldEndCombat() then
          self.start_reposition_ended = self.start_reposition_ended or self:AreEnemiesAware(g_CurrentTeam)
          while not self.start_reposition_ended or IsRepositionPhase() do
            WaitMsg("RepositionEnd", 100)
          end
          NetUpdateHash("Combat_MainLoop_Reposition_End")
        end
        if self.autosave_enabled and self.current_turn and 1 < self.current_turn then
          RequestAutosave({
            autosave_id = "combat",
            save_state = "Turn",
            display_name = T({
              600965840557,
              "<u(Id)>_Turn<turn>",
              gv_Sectors[gv_CurrentSectorId],
              turn = self.current_turn
            }),
            turn_phase = self.current_turn,
            mode = "delayed"
          })
        end
        NetUpdateHash("Combat_MainLoop_Autosave_End")
      end
      Msg("TurnStart", g_CurrentTeam)
      ObjModified(SelectedObj)
      ObjModified("combat_bar")
    else
      Msg("TurnStart", g_CurrentTeam)
      if not self.lastStandingVR and (team.side == "enemy1" or team.side == "enemy2") then
        local lastStanding = IsLastUnitInTeam(team.units)
        if lastStanding then
          PlayVoiceResponseGroup(lastStanding, "AIStartingTurnLastEnemy")
          self.lastStandingVR = true
        end
      end
      if team.control == "AI" then
        SelectObj()
        NetUpdateHash("Combat_MainLoop_AITurn_Start")
        if team.side == "neutral" then
          if GameState.skip_civilian_run then
            RunProjectorTurnAndWait()
            self:AITurn(team)
          else
            LockCameraMovement("CivilianTurn")
            self:NeutralTurn(team)
          end
        else
          self:AITurn(team)
        end
        NetUpdateHash("Combat_MainLoop_AITurn_End")
        UnlockCameraMovement("CivilianTurn")
        self.ai_end_turn = true
        ObjModified(self)
      else
        SelectObj()
        ObjModified(self)
        if 1 < #netGamePlayers then
          ShowTurnNotification()
        end
      end
    end
    if self.end_combat and not self:ShouldEndCombat() then
      self.end_combat = false
    end
    self:WaitEndTurn()
    WaitAllCombatActionsEnd()
    NetUpdateHash("Combat_MainLoop_CombatActionsEnd")
    if IsNetPlayerTurn() then
      WaitUIEndTurn()
    end
    NetUpdateHash("Combat_MainLoop_WaitUIEndTurn")
    local shouldSave = self.autosave_enabled and not self:ShouldEndCombat() and Platform.developer and not IsGameReplayRecording() and not IsGameReplayRunning()
    if shouldSave and IsNetPlayerTurn() and self:IsLocalPlayerEndTurn() then
      RequestAutosave({
        autosave_id = "combat",
        save_state = "TurnEnd",
        display_name = T({
          111401651980,
          "<u(Id)>_Turn<turn>End",
          gv_Sectors[gv_CurrentSectorId],
          turn = self.current_turn
        }),
        turn_phase = self.current_turn,
        mode = "immediate"
      })
    end
    if shouldSave then
      NetSyncEventFence()
    end
    NetUpdateHash("Combat_MainLoop_Autosave_End", shouldSave)
    self.player_end_turn = {}
    self.player_end_turn_local_effects = false
    self.ai_end_turn = false
    first_turn = false
    for _, unit in ipairs(team.units) do
      if not unit:IsDead() then
        unit:OnEndTurn()
      end
    end
    NetUpdateHash("Combat_MainLoop_TurnEnded")
    Msg("TurnEnded", g_CurrentTeam, self.current_turn)
    if IsNetPlayerTurn() then
      if not self:AreEnemiesAware(g_CurrentTeam) then
        self:End()
        break
      end
      PlayFX("PlayerCombatTurnEnd", "start")
    elseif self.end_combat and not self:ShouldEndCombat() then
      self.end_combat = false
    end
    if self.starting_unit and self.starting_unit.team == g_Teams[g_CurrentTeam] then
      self.starting_unit = nil
    end
    local player_turn = IsNetPlayerTurn()
    local last_team = g_CurrentTeam
    for i = 1, #g_Teams do
      g_CurrentTeam = g_CurrentTeam % #g_Teams + 1
      if not self:IsEndTurnReady() or self:IsAutomatedTurn() then
        break
      end
      if g_Teams[g_CurrentTeam].side == "neutral" then
        RunProjectorTurnAndWait()
        UpdateTimedExplosives(Traps_CombatTurnToTime, "neutral")
      end
    end
    if g_CurrentTeam == last_team and self:ShouldEndCombat() then
      self:End()
      break
    end
    if g_Teams[g_CurrentTeam]:IsEnemySide(g_Teams[last_team]) then
      if player_turn then
        outnumbered_units = CombatCollectOutnumbered(last_team)
      else
        local new_outnumbered_units = CombatCollectOutnumbered(last_team, outnumbered_units)
        local voice_unit = table.rand(new_outnumbered_units)
        if voice_unit then
          PlayVoiceResponse(voice_unit, "Outnumbered")
        end
      end
    end
    if g_CurrentTeam == eot_marker_team then
      self.current_turn = self.current_turn + 1
      Msg("NewCombatTurn", self.current_turn)
      CombatLog("debug", T({
        Untranslated("Combat turn <num> begins"),
        num = self.current_turn
      }))
    end
    for _, unit in ipairs(team.units) do
      ObjModified(unit)
    end
    ObjModified(self)
  end
end
function Combat:CheckEnableAutosave(trigger_save)
  if self.autosave_enabled or self:ShouldEndCombat() then
    return
  end
  self.autosave_enabled = true
  if trigger_save and IsNetPlayerTurn() then
    CreateMapRealTimeThread(function()
      WaitUnitsInIdle()
      while g_Combat and not g_Combat.start_reposition_ended do
        WaitMsg("CombatStartRepositionDone", 1)
      end
      RequestAutosave({
        autosave_id = "combatStart",
        save_state = "CombatStart",
        display_name = T({
          640196537172,
          "<u(Id)>_CombatStart",
          gv_Sectors[gv_CurrentSectorId]
        }),
        mode = "delayed"
      })
    end)
  end
end
function OnMsg.CombatStartRepositionDone()
  if g_Combat then
    g_Combat:CheckEnableAutosave(true)
  end
end
function OnMsg.UnitRelationsUpdated()
  if g_Combat then
    g_Combat:CheckEnableAutosave(not g_Combat.waiting_relations_update)
    g_Combat.waiting_relations_update = false
  end
end
function Combat:HasTeamTurnStarted(team)
  team = team or g_Teams[g_CurrentTeam]
  return team == g_Teams[g_CurrentTeam] and g_CurrentTeam == self.team_playing
end
function Combat:AreEnemiesAware(team_idx)
  local team = g_Teams[team_idx]
  if IsCompetitiveGame() then
    for _, t in ipairs(g_Teams) do
      if t ~= team and (team.side == "player1" or team.side == "player2") and t:HasAliveUnits() then
        return true
      end
    end
  else
    for _, t in ipairs(g_Teams) do
      if t ~= team and t:IsEnemySide(team) and t:HasAliveUnits("aware") then
        return true
      end
    end
  end
end
function Combat:IsAutomatedTurn(team)
  team = team or g_Teams[g_CurrentTeam]
  if team.control ~= "UI" then
    return false
  end
  local automated = false
  for _, unit in ipairs(team.units) do
    if not unit:IsIncapacitated() and not unit:HasStatusEffect("Panicked") and not unit:HasStatusEffect("Berserk") then
      return false
    end
    automated = true
  end
  return automated
end
function Combat:IsEndTurnReady(fnCheckUnit)
  local mask = 0
  local team = g_Teams[g_CurrentTeam]
  if team and (team.side == "player1" or team.side == "player2") then
    fnCheckUnit = fnCheckUnit or Unit.IsDisabled
    for i = 1, Max(1, #netGamePlayers) do
      if self.player_end_turn[i] then
        mask = mask | NetPlayerControlMask(i)
      end
    end
  elseif self.ai_end_turn then
    mask = -1
  end
  for _, unit in ipairs(team and team.units) do
    if (not fnCheckUnit or not fnCheckUnit(unit)) and (team.control ~= "AI" or unit:IsAware("pending")) then
      if HasCombatActionInProgress(unit) then
        return false
      end
      if not unit:IsControlledBy(mask) and not self.end_combat then
        return false
      end
    end
  end
  for _, bombard in ipairs(self.queued_bombards) do
    if g_Teams[bombard.team] == team and (bombard.activation_turn or self.current_turn) <= self.current_turn then
      return false
    end
  end
  if team.side == "neutral" and MapHasProjectors then
    return ProjectorsCombatTurnExecuted == self.current_turn
  end
  return true
end
function Combat:CheckEndTurn()
  if self:IsEndTurnReady() then
    Msg("EndTurnReady")
  end
end
function Combat:UncontrollableUnitsCheck()
  local team = g_Teams[g_CurrentTeam]
  if self.end_combat or team.control ~= "UI" then
    return
  end
  local uncontrollable = true
  for _, unit in ipairs(team.units) do
    if (not IsCompetitiveGame() or unit:IsLocalPlayerControlled()) and uncontrollable then
      uncontrollable = unit:IsDisabled()
    end
  end
  if uncontrollable then
    Msg("EndTurnReady")
  end
  return uncontrollable
end
function Combat:WaitEndTurn()
  if self:IsEndTurnReady(Unit.IsDisabled) or self:UncontrollableUnitsCheck() or g_Teams[g_CurrentTeam].control == "AI" then
    return
  end
  WaitMsg("EndTurnReady")
end
function Combat:IsLocalPlayerEndTurn()
  return self.player_end_turn_local_effects or self.player_end_turn[netUniqueId]
end
function GetUnitEquippedMedicine(unit)
  local item
  local res = unit:ForEachItem("Medkit", function(itm, slot)
    if itm.Condition > 0 then
      item = itm
      return "break"
    end
  end, item)
  if res == "break" and item then
    return item
  end
  local res = unit:ForEachItem("FirstAidKit", function(itm, slot)
    if itm.Condition > 0 then
      item = itm
      return "break"
    end
  end, item)
  return item
end
function CountAnyEnemies(skipAnimals)
  local anyEnemies = 0
  local ui_team_idx = table.find(g_Teams, "side", "player1")
  local ui_team = g_Teams[ui_team_idx]
  for idx, team in ipairs(g_Teams) do
    if idx ~= ui_team_idx and 0 < #team.units and SideIsEnemy(ui_team.side, team.side) then
      for i, u in ipairs(team.units) do
        if not u:IsDead() and (not skipAnimals or u.species == "Human") then
          anyEnemies = anyEnemies + 1
        end
      end
    end
  end
  return anyEnemies
end
function Combat:End()
  if g_Combat ~= self then
    return
  end
  if IsValidThread(self.thread) and self.thread ~= CurrentThread() then
    DeleteThread(self.thread)
    self.thread = nil
  end
  self.combat_time = self.combat_time and GetCurrentPlaytime() - (self.combat_time or GetCurrentPlaytime())
  NetUpdateHash("Combat_End")
  g_Combat = false
  gv_ActiveCombat = false
  gv_CombatStartFromConversation = false
  g_LastAttackStealth = false
  g_LastAttackKill = false
  local context = {suppress_camera_init = true}
  context.time_of_day = self.time_of_day
  local anyEnemies = CountAnyEnemies() > 0
  local ui_team_idx = table.find(g_Teams, "side", "player1")
  g_CurrentTeam = ui_team_idx
  SetInGameInterfaceMode("IModeExploration", context)
  AdjustCombatCamera("reset")
  Msg("CombatEnd", self, anyEnemies)
  Msg("PostCombatEnd", self, anyEnemies)
  CombatLog("debug", "Combat ended")
  NetUpdateHash("CombatEnd")
  HideTacticalNotification("allyTurnPhase")
  HideTacticalNotification("enemyTurnPhase")
  HideTacticalNotification("turn")
  if anyEnemies then
    ShowTacticalNotification("hostilesPresent")
  elseif gv_CurrentSectorId and gv_Sectors and not gv_Sectors[gv_CurrentSectorId].conflict then
    ShowTacticalNotification("conflictResolved")
    PlayFX("NoEnemiesLeft", "start")
  else
    ShowTacticalNotification("noEnemyContact")
    PlayFX("NoEnemiesLeft", "start")
  end
  CreateGameTimeThread(DoneObject, self)
  local playerSquadsHere = GetSquadsInSector(gv_CurrentSectorId, false, false, true)
  local alive_player_units
  local all_alive_retreated = 0 < #playerSquadsHere
  for i, s in ipairs(playerSquadsHere) do
    for _, uId in ipairs(s.units) do
      local unit = g_Units[uId]
      local ud = gv_UnitData[uId]
      if unit and not alive_player_units then
        alive_player_units = not unit:IsDead()
      end
      if (not unit or not unit:IsDead()) and ud and not ud.retreat_to_sector then
        all_alive_retreated = false
      end
    end
  end
  if alive_player_units and self.autosave_enabled then
    CreateMapRealTimeThread(function(self)
      WaitUnitsInIdleOrBehavior()
      RequestAutosave({
        autosave_id = "combatEnd",
        save_state = "CombatEnd",
        display_name = T({
          299876017054,
          "<u(Id)>_CombatEnd",
          gv_Sectors[gv_CurrentSectorId]
        }),
        mode = "delayed"
      })
    end, self)
  end
  if not alive_player_units and all_alive_retreated and gv_LastRetreatedUnit and gv_LastRetreatedEntrance then
    local ud = gv_UnitData[gv_LastRetreatedUnit]
    local squad = ud and gv_Squads[ud.Squad]
    if squad.CurrentSector ~= gv_CurrentSectorId then
      return
    end
    local sectorId = gv_LastRetreatedEntrance[1]
    local entrance = gv_LastRetreatedEntrance[2]
    LeaveSectorExploration(sectorId, squad.units, entrance, true)
  end
end
function Combat:IsVisibleByPoVTeam(unit)
  return g_Visibility and HasVisibilityTo(GetPoVTeam(), unit)
end
local IsSafeLocation = function(loc, combatant_locs, fear)
  local x, y, z
  if IsValid(loc) then
    x, y, z = loc:GetGridCoords()
  else
    x, y, z = point_unpack(loc)
  end
  for _, cloc in ipairs(combatant_locs) do
    local cx, cy, cz = point_unpack(cloc)
    if IsCloser(x, y, z, cx, cy, cz, fear) then
      return false
    end
  end
  return true
end
function Combat:NeutralTurn(team)
  local destlocks = {}
  local fear = const.Combat.NeutralUnitFearRadius
  local combatant_locs = {}
  for _, unit in ipairs(g_Units) do
    if unit.team.side ~= "neutral" then
      local x, y, z = unit:GetGridCoords()
      combatant_locs[#combatant_locs + 1] = point_pack(x, y, z)
    end
  end
  local moving = {}
  for _, unit in ipairs(team.units) do
    if not unit:IsDead() and unit.species == "Human" and not unit:IsDefeatedVillain() and not IsSafeLocation(unit, combatant_locs, fear) and not unit.neutral_ai_dont_move then
      ShowTacticalNotification("civilianTurn", true)
      unit.ActionPoints = const.Combat.NeutralUnitRelocateAP
      local cpath = CombatPath:new()
      cpath:RebuildPaths(unit)
      local safe_voxels = {}
      for voxel in sorted_pairs(cpath.paths_ap) do
        local vx, vy, vz = point_unpack(voxel)
        local gx, gy, gz = WorldToVoxel(vx, vy, vz)
        if not destlocks[voxel] and IsSafeLocation(point_pack(gx, gy, gz), combatant_locs, fear) then
          safe_voxels[#safe_voxels + 1] = voxel
        end
      end
      if 0 < #safe_voxels then
        local idx = 1 + InteractionRand(#safe_voxels, "NeutralRelocation", unit)
        local voxel = safe_voxels[idx]
        destlocks[voxel] = true
        local tx, ty, tz = point_unpack(voxel)
        local path = cpath:GetCombatPathFromPos(point(tx, ty, tz))
        local goto_ap = cpath.paths_ap[voxel] or 0
        if path and AIStartCombatAction("Move", unit, goto_ap, {
          goto_pos = point(point_unpack(path[1]))
        }) then
          moving[#moving + 1] = unit
        end
      end
    end
  end
  RunProjectorTurnAndWait()
  if 0 < #moving then
    for _, unit in ipairs(moving) do
      WaitCombatActionsEnd(unit)
    end
  else
    Sleep(100)
  end
end
function SetFixedCamera(unit)
  if ActionCameraPlaying then
    WaitMsg("ActionCameraRemoved", 3000)
  end
  if not cameraTac.GetForceMaxZoom() then
    cameraTac.SetForceMaxZoom(true)
    Sleep(hr.CameraTacOverviewTime * 10)
  end
  SnapCameraToObj(unit)
  cameraTac.SetFixedLookat(true)
end
function RemoveFixedCamera()
  if ActionCameraPlaying then
    WaitMsg("ActionCameraRemoved", 3000)
  end
  if cameraTac.GetForceMaxZoom() then
    cameraTac.SetForceMaxZoom(false)
    Sleep(hr.CameraTacOverviewTime * 10)
  end
  cameraTac.SetFixedLookat(false)
end
function Combat:AITurn(team)
  if g_ShouldRebuildVisField then
    RebuildMapVisField()
  end
  CreateAIExecutionController()
  local bombard_squads = {}
  for _, unit in ipairs(team.units) do
    local squad = gv_Squads[unit.Squad]
    local id = squad and squad.enemy_squad_def or false
    local squad_def = EnemySquadDefs[id]
    if squad_def and squad_def.Bombard and not table.find(bombard_squads, id) then
      bombard_squads[#bombard_squads + 1] = id
      bombard_squads[id] = unit.team
    end
    if squad_def and squad_def.Bombard then
      self:QueueBombard(string.format("squad: %s", id), unit.team, squad_def.BombardAreaRadius, squad_def.BombardOrdnance, squad_def.BombardShots, squad_def.BombardLaunchOffset, squad_def.BombardLaunchAngle)
    end
  end
  local start_ai_turn_gametime = GameTime()
  AIAssignToEmplacements(team)
  if self.log_ai_side == team.side then
    g_AIExecutionController.enable_logging = true
  end
  local units = table.ifilter(team.units, function(idx, unit)
    return not unit:HasStatusEffect("Panicked") and not unit:HasStatusEffect("Berserk")
  end)
  for _, unit in ipairs(team.units) do
    unit.ai_context = nil
  end
  g_AIExecutionController:Execute(team.units)
  local bombed_units = {}
  local queued = self.queued_bombards
  self.queued_bombards = {}
  for _, bombard in ipairs(queued) do
    if g_Teams[bombard.team] == team then
      local ordnance = g_Classes[bombard.ordnance]
      local radius = (bombard.radius + (ordnance and ordnance.AreaOfEffect or 0)) * const.SlabSizeX
      local target_unit = self:PickBombardTarget(team, bombed_units, radius)
      if target_unit then
        local zone = PlaceObject("BombardZone")
        zone:Setup(target_unit:GetPos(), bombard.radius, team.side, bombard.ordnance, bombard.shots)
        zone.bombard_offset = bombard.launchOffset
        zone.bombard_dir = bombard.launchAngle
      end
    else
      local idx = #self.queued_bombards + 1
      self.queued_bombards[bombard.id] = idx
      self.queued_bombards[idx] = bombard
    end
  end
  Sleep(Max(0, start_ai_turn_gametime + 1200 - GameTime()))
  RemoveFixedCamera()
  DoneObject(g_AIExecutionController)
end
function Combat:QueueBombard(id, team, radius, ordnance, shots, launchOffset, launchAngle)
  if self.queued_bombards[id] then
    return
  end
  if type(team) ~= "number" then
    team = table.find(g_Teams, team)
  end
  if not team then
    return
  end
  local idx = #self.queued_bombards + 1
  local activation_turn = self.current_turn + (team == g_CurrentTeam and 1 or 0)
  self.queued_bombards[id] = idx
  self.queued_bombards[idx] = {
    team = team,
    radius = radius,
    ordnance = ordnance,
    shots = shots,
    launchOffset = launchOffset,
    launchAngle = launchAngle,
    id = id,
    activation_turn = activation_turn
  }
end
function Combat:PickBombardTarget(team, targeted_units, bombard_radius)
  local vis_enemies = table.ifilter(g_Visibility[team] or empty_table, function(idx, unit)
    return team:IsEnemySide(unit.team)
  end)
  if #vis_enemies == 0 then
    return
  end
  local scores = {}
  local best_score = 0
  for _, unit in ipairs(vis_enemies) do
    local score = targeted_units[unit] and 0 or 100
    for _, ally in ipairs(team.units) do
      if bombard_radius < ally:GetDist(unit) then
        score = score + 1
      end
    end
    scores[unit] = score
    best_score = Max(best_score, score)
  end
  local best = table.ifilter(vis_enemies, function(idx, unit)
    return scores[unit] == best_score
  end)
  local tbl = 0 < #best and best or vis_enemies
  local target = table.interaction_rand(tbl, "Bombard")
  targeted_units[target] = true
  return target
end
function Combat:OnUnitDamaged(unit, attacker)
  if not self.active_unit_shown and attacker and attacker == self:GetActiveUnit() and self:IsVisibleByPoVTeam(unit) then
    self.active_unit_shown = true
  end
  local emp = unit and self:GetEmplacementAssignment(unit)
  if emp and emp.appeal then
    emp.appeal[unit.team.side] = nil
  end
end
function Combat:GetNextUnitIdx(team, currentUnit)
  local units = team.units
  local idx = table.find(units, currentUnit) or 0
  local n = #units
  for i = 1, n do
    local j = i + idx
    if n < j then
      j = j - n
    end
    local u = units[j]
    if u:CanBeControlled() then
      return j
    end
  end
end
function Combat:GetPrevUnitIdx(team, currentUnit)
  local units = team.units
  local idx = table.find(units, currentUnit) or 0
  local n = #units
  for i = 1, n do
    local j = idx - i
    if j < 1 then
      j = n
    end
    local u = units[j]
    if u:CanBeControlled() then
      return j
    end
  end
end
function Combat:ChangeSelectedUnit(direction, team, force)
  local unit = SelectedObj
  if not force and (not IsKindOf(unit, "Unit") or not unit:CanBeControlled()) then
    return
  end
  team = team or unit and unit.team or g_Teams and g_Teams[g_CurrentTeam]
  if team ~= g_Teams[g_CurrentTeam] then
    return
  end
  if not IsNetPlayerTurn() then
    return
  end
  local igi = GetInGameInterfaceModeDlg()
  if not IsKindOf(igi, "IModeCombatMovement") and igi.window_state ~= "destroying" then
    SetInGameInterfaceMode("IModeCombatMovement")
  end
  local fTeam = GetFilteredCurrentTeam(team)
  local nextUnitIdx = direction == "next" and self:GetNextUnitIdx(fTeam, unit) or self:GetPrevUnitIdx(fTeam, unit)
  local newUnit = nextUnitIdx and fTeam.units[nextUnitIdx]
  local squadChanged = false
  if not newUnit then
    nextUnitIdx = direction == "next" and self:GetNextUnitIdx(team, unit) or self:GetPrevUnitIdx(team, unit)
    newUnit = nextUnitIdx and team.units[nextUnitIdx]
    squadChanged = true
  end
  if newUnit then
    SelectObj(newUnit)
    SnapCameraToObj(newUnit)
    if squadChanged then
      ResetCurrentSquad(team)
    end
    return
  end
end
function Combat:NextUnit(team, force)
  return self:ChangeSelectedUnit("next", team, force)
end
function Combat:PrevUnit(team, force)
  return self:ChangeSelectedUnit("prev", team, force)
end
function OnMsg.CombatActionEnd(unit)
  if not g_Combat then
    return
  end
  if g_Combat.active_unit == unit then
    g_Combat:SetActiveUnit(false)
  end
end
function Combat:SetActiveUnit(unit)
  if self.active_unit == unit then
    return
  end
  self.active_unit = unit
  self.active_unit_shown = false
end
function Combat:GetActiveUnit()
  return self.active_unit
end
function GetRandomMapMerc(squad_id, seed)
  local units = {}
  for _, unit in ipairs(g_Units) do
    if unit:IsMerc() and not unit:IsDead() and unit.team and (unit.team.side == "player1" or unit.team.side == "player2") and (not squad_id or unit.Squad == squad_id) then
      units[#units + 1] = unit
    end
  end
  if not next(units) then
    return
  end
  local rand = 1 + BraidRandom(seed, #units)
  return units[rand]
end
function Combat:AssignEmplacement(emplacement, unit)
  local assignment = self.emplacement_assignment[emplacement]
  if assignment then
    self.emplacement_assignment[assignment] = nil
  end
  self.emplacement_assignment[emplacement] = unit
  if unit then
    self.emplacement_assignment[unit] = emplacement
  end
end
function Combat:GetEmplacementAssignment(obj)
  return self.emplacement_assignment[obj]
end
DefineClass.CombatTeam = {
  __parents = {"InitDone"},
  units = false,
  control = false,
  team_color = RGB(100, 100, 100),
  spawn_marker_group = "",
  side = "neutral",
  team_mask = 0,
  ally_mask = 0,
  enemy_mask = 0,
  player_team = false,
  player_ally = false,
  player_enemy = false,
  neutral = false,
  tactical_situations_vr = false,
  morale = 0,
  seen_units = false
}
function CombatTeam:Init()
  self.units = self.units or {}
  self.seen_units = self.seen_units or {}
  self.tactical_situations_vr = self.tactical_situations_vr or {}
end
function CombatTeam:OnEnemySighted(unit)
  Msg("EnemySighted", self, unit)
end
function CombatTeam:OnEnemyLost(unit)
end
function CombatTeam:IsEnemySide(other)
  return band(self.enemy_mask, other.team_mask) ~= 0
end
function CombatTeam:IsAllySide(other)
  return band(self.ally_mask, other.team_mask) ~= 0
end
function CombatTeam:HasAliveUnits(aware)
  for _, unit in ipairs(self.units) do
    if not unit:IsDead() then
      local enemies = GetAllEnemyUnits(unit)
      local alive_enemies = 0
      for _, enemy in ipairs(enemies) do
        if not enemy:IsDead() then
          alive_enemies = alive_enemies + 1
        end
      end
      if not aware or unit:IsAware("pending") and 0 < alive_enemies then
        return true
      end
    end
  end
end
function CombatTeam:IsDefeated()
  local defeated = true
  for _, unit in ipairs(self.units) do
    defeated = defeated and not unit:CanContinueCombat()
  end
  return defeated
end
function CombatTeam:GetDynamicData(team_data)
  if #(self.units or "") > 0 then
    local unit_handles = {}
    for i, unit in ipairs(self.units) do
      unit_handles[i] = unit:GetHandle()
    end
    team_data.units = unit_handles
  end
  if 0 < #self.seen_units then
    team_data.seen_units = table.copy(self.seen_units)
  end
  team_data.control = self.control
  team_data.side = self.side
  team_data.team_color = self.team_color
  team_data.spawn_marker_group = self.spawn_marker_group ~= "" and self.spawn_marker_group or nil
  team_data.morale = self.morale
  team_data.tactical_situations_vr = table.copy(self.tactical_situations_vr, "deep")
  local revealed = g_RevealedUnits[self]
  if revealed and 0 < #revealed then
    team_data.revealed_units = {}
    for i, unit in ipairs(revealed) do
      team_data.revealed_units[i] = unit:GetHandle()
    end
  end
end
function CombatTeam:SetDynamicData(team_data)
  self.control = team_data.control
  self.side = team_data.side or self.control and "player1" or "enemy1"
  self.team_color = team_data.team_color
  self.spawn_marker_group = team_data.spawn_marker_group
  self.morale = team_data.morale
  self.tactical_situations_vr = table.copy(self.tactical_situations_vr or {}, "deep")
  self.units = {}
  for _, handle in ipairs(team_data.units) do
    local obj = HandleToObject[handle]
    if obj then
      table.insert(self.units, obj)
      obj:SetTeam(self)
    end
  end
  self.seen_units = team_data.seen_units or {}
  if team_data.revealed_units then
    g_RevealedUnits[self] = g_RevealedUnits[self] or {}
  end
  for _, handle in ipairs(team_data.revealed_units) do
    local obj = HandleToObject[handle]
    if IsKindOf(obj, "Unit") then
      table.insert_unique(g_RevealedUnits[self], obj)
    end
  end
end
function CombatTeam:IsPlayerControlled()
  return self.side == "player1" or self.side == "player2"
end
function GetCombatPath(unit, stance, ap, end_stance)
  local x, y, z = GetPassSlabXYZ(unit)
  stance = stance or unit.stance
  if g_CombatPath and unit == g_CombatPath.unit and stance == g_CombatPath.stance and x and g_CombatPath.start_pos == unit:GetPos() and g_CombatPath.ap == unit.ActionPoints and g_CombatPath.move_modifier == unit:GetMoveModifier(stance) and not ap then
    return g_CombatPath
  end
  local combatPath = GetCombatPathKeepStanceAware(unit, end_stance or stance, ap or nil)
  if not ap and unit == SelectedObj then
    g_CombatPath = combatPath
  end
  return combatPath
end
function CombatPathReset(unit, reason)
  if g_CombatPath and (not unit or g_CombatPath.unit == unit) then
    g_CombatPath = false
  end
  Msg("CombatPathReset")
end
function OnMsg.UnitStanceChanged(unit)
  CombatPathReset(unit)
end
function OnMsg.UnitDied()
  CombatPathReset(SelectedObj)
end
function OnMsg.UnitMovementDone()
  CombatPathReset(SelectedObj)
end
function OnMsg.OnPassabilityChanged()
  CombatPathReset()
end
function OnMsg.SelectedObjChange()
  if g_Combat then
    ObjModified(g_Combat)
  end
end
function OnMsg.OccupiedChange()
  CombatPathReset()
  if g_Combat then
    ObjModified(g_Combat)
  end
end
function OnMsg.UnitAPChanged(unit, reason)
  CombatPathReset(unit, reason)
  if g_Combat then
    ObjModified(g_Combat)
  end
end
function OnMsg.NetPlayerLeft(player, reason)
  if not g_Combat then
    return
  end
  g_Combat.player_end_turn = {}
  g_Combat.player_end_turn_local_effects = false
end
function OnMsg.NetGameLeft()
  if not g_Combat then
    return
  end
  g_Combat.player_end_turn = {}
  g_Combat.player_end_turn_local_effects = false
end
function NetSyncLocalEffects.EndTurn()
  if not g_Combat then
    return
  end
  g_Combat.player_end_turn_local_effects = true
  g_Combat:EndCombatCheck()
end
function NetSyncRevertLocalEffects.EndTurn(player_id)
  if not g_Combat then
    return
  end
  g_Combat.player_end_turn_local_effects = false
end
function NetSyncEvents.EndTurn(player_id)
  local localPlayer = player_id == netUniqueId
  local shownUI = not localPlayer or g_Teams and g_CurrentTeam and g_Teams[g_CurrentTeam].control == "UI" and not g_AIExecutionController
  if not (g_Combat and shownUI) or IsSetpiecePlaying() then
    return
  end
  if g_Combat.player_end_turn[player_id] then
    g_Combat.player_end_turn[player_id] = false
    if localPlayer then
      ObjModified(SelectedObj)
    end
    return
  end
  if localPlayer and not g_Combat.player_end_turn[player_id] then
    PlayFX("EndTurn", "start")
  end
  g_Combat.player_end_turn[player_id] = true
  g_Combat:CheckEndTurn()
  if localPlayer then
    ObjModified(SelectedObj)
  end
end
function Combat:GetDynamicData(dynamic_data)
  local combat_data = dynamic_data
  combat_data.combat_id = self.combat_id
  combat_data.combat_time = self.combat_time
  combat_data.stealth_attack_start = self.stealth_attack_start
  combat_data.last_attack_kill = self.last_attack_kill
  local unit_handles = {}
  for i, unit in ipairs(g_Units) do
    local handle = unit:GetHandle()
    unit_handles[i] = handle
  end
  combat_data.units = unit_handles
  combat_data.teams = {}
  for i, team in ipairs(g_Teams) do
    local team_data = {}
    team:GetDynamicData(team_data)
    combat_data.teams[i] = team_data
  end
  combat_data.time_of_day = self.time_of_day
  combat_data.turns_no_visibility = self.turns_no_visibility ~= 0 and self.turns_no_visibility or nil
  combat_data.current_team = g_CurrentTeam
  combat_data.current_turn = self.current_turn
  combat_data.enemies_engaged = self.enemies_engaged or nil
  combat_data.units_repositioned = table.copy(self.units_repositioned)
  combat_data.unit_reposition_shown = self.unit_reposition_shown
  combat_data.start_reposition_ended = self.start_reposition_ended
  combat_data.retreat_enemies = self.retreat_enemies or nil
  combat_data.queued_bombards = table.copy(self.queued_bombards, "deep")
  combat_data.autosave_enabled = self.autosave_enabled or nil
  combat_data.lastStandingVR = self.lastStandingVR
  combat_data.starting_unit = IsValid(self.starting_unit) and self.starting_unit:GetHandle() or nil
  combat_data.emplacement_assignment = {}
  for key, value in pairs(self.emplacement_assignment) do
    combat_data.emplacement_assignment[key.handle] = value.handle
  end
  combat_data.hp_loss = self.hp_loss and table.copy(self.hp_loss)
  combat_data.hp_healed = self.hp_healed and table.copy(self.hp_healed)
  combat_data.turn_dist_travelled = self.turn_dist_travelled
  combat_data.out_of_ammo = self.out_of_ammo and table.copy(self.out_of_ammo)
end
function Combat:SetDynamicData(combat_data)
  self.combat_id = combat_data.combat_id
  self.combat_time = combat_data.combat_time
  self.stealth_attack_start = combat_data.stealth_attack_start
  self.last_attack_kill = combat_data.last_attack_kill or combat_data.stealth_attack_start_kill
  g_CurrentTeam = g_CurrentTeam or combat_data.current_team or false
  self.time_of_day = combat_data.time_of_day
  self.turns_no_visibility = combat_data.turns_no_visibility
  self.current_turn = combat_data.current_turn
  self.enemies_engaged = combat_data.enemies_engaged
  self.units_repositioned = table.copy(combat_data.units_repositioned or empty_table)
  self.unit_reposition_shown = combat_data.unit_reposition_shown
  self.start_reposition_ended = combat_data.start_reposition_ended
  self.retreat_enemies = combat_data.retreat_enemies or false
  self.queued_bombards = table.copy(combat_data.queued_bombards or {}, "deep")
  self.autosave_enabled = combat_data.autosave_enabled
  self.lastStandingVR = combat_data.lastStandingVR
  self.starting_unit = combat_data.starting_unit and HandleToObject[combat_data.starting_unit]
  self.emplacement_assignment = {}
  for key, value in pairs(combat_data.emplacement_assignment) do
    local ok = HandleToObject[key]
    local ov = HandleToObject[value]
    self.emplacement_assignment[ok] = ov
  end
  if combat_data.units and next(combat_data.units) then
    local unit_handles = {}
    g_Units = {}
    for _, handle in ipairs(combat_data.units) do
      local obj = HandleToObject[handle]
      if obj then
        AddToGlobalUnits(obj)
      end
    end
  end
  g_Teams = {}
  for i, team_data in ipairs(combat_data.teams) do
    local team = CombatTeam:new()
    team:SetDynamicData(team_data)
    g_Teams[i] = team
  end
  local neutralTeam = table.find_value(g_Teams, "side", "neutral")
  for _, unit in ipairs(g_Units) do
    if not unit.team then
      unit:SetTeam(neutralTeam)
    end
  end
  self.hp_loss = combat_data.hp_loss and table.copy(combat_data.hp_loss) or false
  self.hp_healed = combat_data.hp_healed and table.copy(combat_data.hp_healed) or false
  self.turn_dist_travelled = combat_data.turn_dist_travelled
  self.out_of_ammo = combat_data.out_of_ammo and table.copy(combat_data.out_of_ammo) or false
end
function Combat:SetRepositioned(unit, state)
  self.units_repositioned[unit.handle] = state
end
function Combat:IsRepositioned(unit)
  return self.units_repositioned[unit.handle] or false
end
function OnMsg.LoadDynamicData(dynamic_data)
  if gv_ActiveCombat and gv_CurrentSectorId == gv_ActiveCombat then
    g_Combat = Combat:new()
    g_Combat.skip_first_autosave = true
    if dynamic_data.g_Combat then
      g_Combat:SetDynamicData(dynamic_data.g_Combat)
    end
    CreateGameTimeThread(function(dynamic_data)
      g_Combat:Start(dynamic_data.g_Combat)
      ShowInGameInterface(true, false, {
        Mode = "IModeCombatMovement"
      })
    end, dynamic_data)
  end
end
function OnMsg.SaveDynamicData(dynamic_data)
  if not g_Combat then
    return
  end
  dynamic_data.g_Combat = {}
  g_Combat:GetDynamicData(dynamic_data.g_Combat)
end
function OnMsg.NewGameSessionStart()
  if g_Combat then
    g_Combat:delete()
    g_Combat = false
  end
end
function OnMsg.CombatStart()
  if not g_UnitCombatBadgesEnabled then
    return
  end
  local enemy_badges = {}
  for _, t in ipairs(g_Teams) do
    if t.side == "enemy1" or t.side == "enemy2" then
      for _, unit in ipairs(t.units) do
        if not unit:IsDead() then
          enemy_badges[unit] = CreateBadgeFromPreset("EnemyBadge", unit, unit)
        end
      end
    end
  end
  g_Combat.enemy_badges = enemy_badges
end
function OnMsg.CombatEnd(combat)
  if not combat.enemy_badges then
    return
  end
  for _, b in pairs(combat.enemy_badges) do
    b:Done()
  end
  combat.enemy_badges = false
  SyncStartExploration()
end
function OnMsg.CombatStart()
  ObjModified("CombatChanged")
end
function OnMsg.CombatEnd()
  ObjModified("CombatChanged")
end
function NetSyncEvents.KillAllEnemies()
  if not g_Combat then
    return
  end
  g_AccumulatedTeamXP = {}
  for _, team in ipairs(g_Teams) do
    if team.side == "enemy1" or team.side == "enemy2" or team.side == "enemyNeutral" then
      for _, unit in ipairs(team.units) do
        if not unit:IsDead() then
          unit:TakeDirectDamage(10000)
          QuestAddAttackedGroups(unit.Groups, unit:IsDead())
        end
        RewardTeamExperience(unit, GetCampaignPlayerTeam())
      end
    end
  end
  LogAccumulatedTeamXP("debug")
  CombatActions_RunningState = {}
end
function NetSyncEvents.DefeatAllVillains()
  if not g_Combat then
    return
  end
  for _, team in ipairs(g_Teams) do
    if team.side == "enemy1" or team.side == "enemy2" then
      for _, unit in ipairs(team.units) do
        if unit.villain and unit.behavior ~= "Dead" and unit.command ~= "Die" then
          unit:SetCommand("Die")
        end
      end
    end
  end
end
if FirstLoad then
  PredictedDamageUnits = {}
end
MapVar("s_PredictedExposedUnits", {})
MapVar("s_PredictedTrapExplosions", {})
MapVar("s_PredictedHighlightedObjs", {})
MapVar("s_PredictedAOEObjs", {})
MapVar("s_PredictionNoLofTargets", {})
local lClearPredictedExplosions = function(list)
  for i, m in ipairs(list) do
    DoneObject(m)
  end
end
local lClearPredictedAOE = function(list)
  for _, obj in ipairs(list) do
    if IsValid(obj) then
      if IsKindOf(obj, "Unit") then
        obj:SetHighlightReason("area target", false)
      elseif not IsKindOf(obj, "DamagePredictable") then
        SetInteractionHighlightRecursive(obj, false, true)
      else
        obj:SetObjectMarking(-1)
      end
    end
  end
end
function ApplyDamagePrediction(attacker, action, args, actionResult)
  local target = args and args.target
  local target_spot_group = args and args.target_spot_group
  local targetIsUnit = IsKindOf(target, "Unit")
  local targetIsTrap = IsKindOf(target, "Trap")
  local targetIsPoint = IsPoint(target)
  if not target or not targetIsUnit and not targetIsPoint and not targetIsTrap then
    return
  end
  local trapExplosions = s_PredictedTrapExplosions
  s_PredictedTrapExplosions = false
  local aoeObjs = s_PredictedAOEObjs
  s_PredictedAOEObjs = false
  ClearDamagePrediction()
  s_PredictedHighlightedObjs = s_PredictedHighlightedObjs or {}
  s_PredictedTrapExplosions = s_PredictedTrapExplosions or {}
  s_PredictedAOEObjs = s_PredictedAOEObjs or {}
  if not targetIsPoint and target:IsDead() then
    lClearPredictedExplosions(trapExplosions)
    return
  end
  local weapon1, weapon2 = attacker and action:GetAttackWeapons(attacker)
  local ignore_cover = IsKindOf(weapon1, "Firearm") and weapon1.IgnoreCoverReduction > 0 or IsKindOf(weapon2, "Firearm") and weapon2.IgnoreCoverReduction > 0
  local aimType = action.AimType
  local attackerPosition
  if IsPoint(target) and aimType ~= "cone" then
    attackerPosition = target
  elseif args and args.step_pos then
    attackerPosition = args.step_pos
  else
    attackerPosition = attacker:GetPos()
  end
  if not ignore_cover and targetIsUnit then
    ignore_cover = not target:IsAware()
  end
  actionResult = actionResult or action:GetActionResults(attacker, args) or empty_table
  local attackResultHits = table.icopy(actionResult)
  table.iappend(attackResultHits, actionResult.area_hits)
  table.iappend(s_PredictionNoLofTargets, actionResult.no_lof_targets or empty_table)
  for _, obj in ipairs(s_PredictionNoLofTargets) do
    if IsKindOf(obj, "Unit") then
      ObjModified(obj)
      if obj.ui_badge then
        obj.ui_badge:SetActive(true, "dmg")
      end
    end
  end
  if #attackResultHits == 0 then
    lClearPredictedAOE(aoeObjs)
    lClearPredictedExplosions(trapExplosions)
    return
  end
  local stealthKill = 0 < (actionResult.stealth_kill_chance or 0) and actionResult.stealth_kill_chance
  local hideConditional = false
  if actionResult and actionResult.chance_to_hit then
    hideConditional = CthVisible() and actionResult.chance_to_hit == 0
  end
  local results = {}
  if not targetIsPoint then
    results[target] = {
      total_damage = 0,
      direct_hit_damage = 0,
      stray_hit_damage = 0,
      obstructed = false,
      death = false
    }
  end
  local lApplyResultsToPrediction = function(hits, action)
    for i, hit in ipairs(hits) do
      local obj = hit.obj
      if (not IsKindOf(obj, "CombatObject") or not obj:IsDead()) and IsKindOfClasses(obj, "CombatObject", "Destroyable") then
        if not IsKindOf(obj, "DamagePredictable") and false then
          if ShouldDestroyObject(obj) then
            SetInteractionHighlightRecursive(obj, true, true)
            s_PredictedHighlightedObjs[#s_PredictedHighlightedObjs + 1] = obj
          end
        else
          if hit.aoe or IsOverwatchAction(action.id) then
            if not table.find(aoeObjs, obj) then
              if IsKindOf(obj, "Unit") then
                obj:SetHighlightReason("area target", true)
              elseif not IsKindOf(obj, "DamagePredictable") then
                if ShouldDestroyObject(obj) then
                  SetInteractionHighlightRecursive(obj, true, true)
                end
              else
                obj:SetObjectMarking(3)
              end
            end
            s_PredictedAOEObjs[#s_PredictedAOEObjs + 1] = obj
          end
          if IsKindOf(obj, "DamagePredictable") then
            if IsKindOf(obj, "Trap") then
              if not obj:HitWillDamage(hit) then
                goto lbl_231
              end
              SetInteractionHighlightRecursive(obj, true, true)
              s_PredictedHighlightedObjs[#s_PredictedHighlightedObjs + 1] = obj
            end
            local unit_dmg = results[obj] or {
              total_damage = 0,
              direct_hit_damage = 0,
              stray_hit_damage = 0,
              obstructed = false,
              death = false
            }
            results[obj] = unit_dmg
            unit_dmg.total_damage = unit_dmg.total_damage + hit.damage
            if hit.stray then
              unit_dmg.stray_hit_damage = unit_dmg.stray_hit_damage + hit.damage
            elseif not hit.aoe then
              unit_dmg.direct_hit_damage = unit_dmg.direct_hit_damage + hit.damage
            end
            if hit.stuck then
              unit_dmg.obstructed = true
            end
            if IsKindOf(obj, "Unit") then
              if not obj:HasStatusEffect("Exposed") and hit.effects.Exposed and not s_PredictedExposedUnits[obj] then
                s_PredictedExposedUnits[obj] = true
                s_PredictedExposedUnits[#s_PredictedExposedUnits + 1] = obj
              end
              if not ignore_cover then
                local cover, any, coverage = obj:GetCoverPercentage(attackerPosition)
                if cover then
                  local value = 50
                  local exposedValue = 100
                  local coverEffectResult = InterpolateCoverEffect(coverage, value, exposedValue)
                  if coverEffectResult ~= exposedValue then
                    results[obj].cover = true
                  end
                end
              end
              if not hit.ignore_armor and hit.armor then
                local armor, armorIcon, iconPath = obj:IsArmored(target_spot_group)
                if armor then
                  results[obj].armor = iconPath .. (hit.armor_pen and hit.armor_pen[armor] and "ignored_" or "") .. armorIcon
                end
              end
            end
          end
        end
      end
      ::lbl_231::
    end
    for obj, data in pairs(results) do
      local predictionIcon = false
      if data.obstructed then
        predictionIcon = "ObstructedIcon"
      elseif data.cover then
        predictionIcon = (s_PredictedExposedUnits[obj] or obj:HasStatusEffect("Exposed")) and "CoverExposeIcon" or "CoverIcon"
      elseif data.armor then
        predictionIcon = data.armor
      else
        predictionIcon = "InRange"
      end
      obj.SmallPotentialDamageIcon = predictionIcon
      local death = false
      obj.PotentialDamage = data.total_damage - data.direct_hit_damage - data.stray_hit_damage
      if not hideConditional or obj ~= target then
        if args.multishot then
          local shot_damage = data.direct_hit_damage / Max(1, args.num_shots or 1)
          obj.PotentialDamageConditional = shot_damage
          obj.PotentialSecondaryConditional = data.direct_hit_damage - shot_damage
          death = data.total_damage - obj.PotentialSecondaryConditional >= obj:GetTotalHitPoints()
        else
          obj.PotentialDamageConditional = data.direct_hit_damage
          obj.PotentialSecondaryConditional = data.stray_hit_damage
          death = data.total_damage - data.stray_hit_damage >= obj:GetTotalHitPoints()
        end
      end
      data.death = death
      obj.StealthKillChance = stealthKill or -1
      obj.LargePotentialDamageIcon = stealthKill and "PotentialDeathIcon"
      table.insert_unique(PredictedDamageUnits, obj)
      ObjModified(obj)
      if obj.ui_badge then
        obj.ui_badge:SetActive(true, "dmg")
      end
    end
  end
  lApplyResultsToPrediction(attackResultHits, action)
  local traps = {}
  for target, data in pairs(results) do
    if data.death and IsKindOf(target, "Trap") and target.discovered_trap and target.visible then
      traps[#traps + 1] = target
    end
  end
  local newExplosionMeshes = traps and {}
  for i, t in ipairs(traps) do
    local aoeParams = t:GetAreaAttackParams(nil, attacker)
    local explosion_pos = t:GetPos()
    if not explosion_pos:IsValidZ() then
      explosion_pos = explosion_pos:SetTerrainZ()
    end
    local range = aoeParams.max_range * const.SlabSizeX
    local step_positions, step_objs, los_values = GetAOETiles(explosion_pos, aoeParams.stance, range)
    local existingMeshIdx = table.find(trapExplosions, "source", t)
    local explosionMesh = CreateAOETilesCircle(step_positions, step_objs, existingMeshIdx and trapExplosions[existingMeshIdx], explosion_pos, range, los_values, "ExplodingBarrelRange_Tiles")
    explosionMesh:SetColorFromTextStyle("GrenadeRange")
    explosionMesh.source = t
    newExplosionMeshes[#newExplosionMeshes + 1] = explosionMesh
    if existingMeshIdx then
      table.remove(trapExplosions, existingMeshIdx)
    end
  end
  local aoeObjectsLeftover = table.subtraction(aoeObjs or empty_table, s_PredictedAOEObjs)
  lClearPredictedAOE(aoeObjectsLeftover)
  s_PredictedTrapExplosions = newExplosionMeshes
  lClearPredictedExplosions(trapExplosions)
end
function ClearDamagePrediction()
  for i, u in ipairs(PredictedDamageUnits) do
    if IsValid(u) then
      u.SmallPotentialDamageIcon = false
      u.LargePotentialDamageIcon = false
      u.PotentialDamage = 0
      u.PotentialDamageConditional = 0
      u.PotentialSecondaryConditional = 0
      u.StealthKillChance = -1
      ObjModified(u)
      if u.ui_badge then
        u.ui_badge:SetActive(false, "dmg")
      end
    end
  end
  for _, obj in ipairs(s_PredictedHighlightedObjs) do
    SetInteractionHighlightRecursive(obj, false, true)
  end
  if s_PredictedHighlightedObjs then
    table.iclear(s_PredictedHighlightedObjs)
  end
  lClearPredictedAOE(s_PredictedAOEObjs)
  lClearPredictedExplosions(s_PredictedTrapExplosions)
  s_PredictedTrapExplosions = false
  table.clear(PredictedDamageUnits)
  table.clear(s_PredictedExposedUnits)
  table.clear(s_PredictedAOEObjs)
  table.clear(s_PredictionNoLofTargets)
end
function RebuildMapVisField()
  local sizex, sizey = terrain.GetMapSize()
  local bbox = box(0, 0, 0, sizex, sizey, MapSlabsBBox_MaxZ)
  RebuildVisField(bbox)
  g_ShouldRebuildVisField = false
end
function OnMsg.PostNewMapLoaded()
  RebuildMapVisField()
end
function OnMsg.CombatObjectDied()
  g_ShouldRebuildVisField = true
end
function OnMsg.CanSaveGameQuery(query, request)
  if g_Combat then
    local currentTeam = g_Teams[g_CurrentTeam]
    if currentTeam and currentTeam.side ~= "player1" then
      query.current_team_side = currentTeam.side or "not player1"
    end
    if g_AIExecutionController then
      query.ai_turn = true
    end
    if IsGameRuleActive("Ironman") and (not request or request.autosave_id ~= "combatStart") then
      query.ironman = true
    end
    for _, unit in ipairs(g_Units) do
      if not unit:IsIdleCommand() then
        query.unit_actions = true
      end
    end
  end
end
function OnMsg.OnHeal(patient, hp, medkit, healer)
  if g_Combat and g_Combat.hp_healed and IsKindOf(patient, "Unit") then
    g_Combat.hp_healed[patient.session_id] = (g_Combat.hp_healed[patient.session_id] or 0) + hp
  end
end
function OnMsg.TurnStart()
  if g_Combat then
    g_Combat.turn_dist_travelled = {}
  end
end
local update_unit_pos_dist = function(unit)
  if g_Combat and g_Combat.turn_dist_travelled then
    local pos = unit:GetPos()
    local entry = g_Combat.turn_dist_travelled[unit.session_id]
    if not entry then
      g_Combat.turn_dist_travelled[unit.session_id] = {last_pos = pos, total_dist = 0}
    else
      entry.total_dist = (entry.total_dist or 0) + pos:Dist(entry.last_pos)
      entry.last_pos = pos
    end
  end
end
OnMsg.CombatActionStart = update_unit_pos_dist
OnMsg.CombatActionEnd = update_unit_pos_dist
if Platform.developer then
  function wait_interface_mode(mode, step)
    while GetInGameInterfaceMode() ~= mode do
      Sleep(step or 10)
    end
  end
  local wait_not_interface_mode = function(mode, step)
    while GetInGameInterfaceMode() == mode do
      Sleep(step or 10)
    end
  end
  local wait_game_time = function(ms, step)
    local t = GameTime()
    while GameTime() < t + ms do
      Sleep(step or 10)
    end
  end
  local timeout = 5000
  local select_and_wait_control = function(unit)
    while not g_Combat:HasTeamTurnStarted(unit.team) do
      wait_game_time(50, 10)
    end
    local ts = GetPreciseTicks()
    while not unit:CanBeControlled() and GetPreciseTicks() - ts < timeout do
      Sleep(100)
    end
    if not unit:CanBeControlled() then
      return
    end
    SelectObj(unit)
    wait_game_time(50, 10)
    wait_interface_mode("IModeCombatMovement")
    repeat
      if SelectedObj ~= unit then
        SelectObj(unit)
      end
      wait_game_time(50, 10)
    until unit:CanBeControlled() and SelectedObj == unit
  end
  local click_world_pos = function(pos, dlg, button)
    local screen_center = terminal.desktop.box:Center()
    ViewPos(pos)
    Sleep(100)
    SetMouseDeltaMode(true)
    terminal.SetMousePos(screen_center)
    Sleep(100)
    if button then
      dlg:OnMouseButtonDown(screen_center, button)
    else
      dlg:OnMousePos(screen_center)
    end
    SetMouseDeltaMode(false)
  end
  if FirstLoad then
    GameTestMapLoadRandom = false
  end
  local coreInitMapLoadRandom = InitMapLoadRandom
  function InitMapLoadRandom()
    return GameTestMapLoadRandom or coreInitMapLoadRandom()
  end
  function GameTests.Combat()
    ClearItemIdData()
    local test_combat_id = "Default"
    GameTestMapLoadRandom = xxhash("GameTestMapLoadRandomSeed")
    MapLoadRandom = InitMapLoadRandom()
    ResetInteractionRand(0)
    local expected_sequence = {}
    for i = 1, 10 do
      expected_sequence[i] = InteractionRand(100, "GameTest")
    end
    NewGameSession()
    CreateNewSatelliteSquad({
      Side = "player1",
      CurrentSector = "H2",
      Name = "GAMETEST"
    }, {
      "Buns",
      "Wolf",
      "Ivan",
      "Tex"
    }, 14, 1234567)
    local combat_test_in_progress = true
    CreateRealTimeThread(function()
      while combat_test_in_progress do
        if GetDialog("PopupNotification") then
          Dialogs.PopupNotification:Close()
        end
        Sleep(10)
      end
    end)
    TestCombatEnterSector(Presets.TestCombat.GameTest[test_combat_id], "__TestCombatOutlook")
    SetTimeFactor(10000)
    if IsEditorActive() then
      EditorDeactivate()
      Sleep(10)
    end
    for i = 1, 10 do
      local value = InteractionRand(100, "GameTest")
    end
    while GetInGameInterfaceMode() ~= "IModeDeployment" and GetInGameInterfaceMode() ~= "IModeExploration" do
      Sleep(20)
    end
    GameTestMapLoadRandom = false
    if GetInGameInterfaceMode() == "IModeDeployment" then
      Dialogs.IModeDeployment:StartExploration()
      while GetInGameInterfaceMode() == "IModeDeployment" do
        Sleep(10)
      end
    end
    if GetInGameInterfaceMode() == "IModeExploration" then
      for _, team in ipairs(g_Teams) do
        if team.player_enemy and 0 < #team.units then
          PushUnitAlert("script", team.units, "aware")
        end
      end
      AlertPendingUnits()
      wait_interface_mode("IModeCombatMovement")
    end
    WaitUnitsInIdle()
    while g_Combat.camera_use or IsSetpiecePlaying() do
      Sleep(100)
    end
    local total_hp = 0
    for _, unit in ipairs(g_Units) do
      total_hp = total_hp + unit.HitPoints
    end
    TriggerUnitAlert("discovered", g_Units.Buns)
    while not g_Combat.start_reposition_ended do
      WaitMsg("CombatStartRepositionDone", 100)
    end
    if g_Units.Buns.ActionPoints >= g_Units.Buns:GetMaxActionPoints() then
      select_and_wait_control(g_Units.Buns)
      while not Dialogs.IModeCombatAttack do
        local btn = Dialogs.IModeCombatMovement:ResolveId("SingleShot")
        if not (btn and btn.enabled) then
          break
        end
        btn:Press()
        wait_interface_mode("IModeCombatAttack")
        Sleep(500)
      end
      local weapon = g_Units.Buns:GetActiveWeapons()
      for i = 1, weapon.MaxAimActions do
        Dialogs.IModeCombatAttack.crosshair:ToggleAim()
      end
      Dialogs.IModeCombatAttack.crosshair.idButtonTorso:Press()
      wait_game_time(50, 20)
      WaitUnitsInIdle()
      SetInGameInterfaceMode("IModeCombatMovement")
      wait_interface_mode("IModeCombatMovement")
    end
    if g_Units.Tex.ActionPoints >= g_Units.Tex:GetMaxActionPoints() then
      select_and_wait_control(g_Units.Tex)
      while not Dialogs.IModeCombatMovingAttack do
        local btn = Dialogs.IModeCombatMovement:ResolveId("MobileShot")
        if not btn.enabled then
          break
        end
        btn:Press()
        wait_interface_mode("IModeCombatMovingAttack")
        Sleep(500)
      end
      click_world_pos(point(186600, 124200), Dialogs.IModeCombatMovingAttack, "L")
      wait_game_time(50, 20)
      WaitUnitsInIdle()
      SetInGameInterfaceMode("IModeCombatMovement")
      wait_interface_mode("IModeCombatMovement")
    end
    if g_Units.Wolf.ActionPoints >= g_Units.Wolf:GetMaxActionPoints() then
      select_and_wait_control(g_Units.Wolf)
      while not Dialogs.IModeCombatAreaAim do
        local btn = Dialogs.IModeCombatMovement:ResolveId("AttackShotgun")
        if not btn.enabled then
          break
        end
        btn:Press()
        wait_interface_mode("IModeCombatAreaAim")
        Sleep(100)
      end
      click_world_pos(point(178873, 119115, 12543), Dialogs.IModeCombatAreaAim, "L")
      wait_game_time(50, 20)
      WaitUnitsInIdle()
      SetInGameInterfaceMode("IModeCombatMovement")
      wait_interface_mode("IModeCombatMovement")
    end
    if g_Units.Ivan.ActionPoints >= g_Units.Ivan:GetMaxActionPoints() then
      select_and_wait_control(g_Units.Ivan)
      while not Dialogs.IModeCombatAreaAim do
        local btn = Dialogs.IModeCombatMovement:ResolveId("Overwatch")
        if not btn.enabled then
          break
        end
        btn:Press()
        wait_interface_mode("IModeCombatAreaAim")
        Sleep(100)
      end
      click_world_pos(point(198060, 126387, 11685), Dialogs.IModeCombatAreaAim, "L")
      wait_game_time(50, 20)
      WaitUnitsInIdle()
      SetInGameInterfaceMode("IModeCombatMovement")
      wait_interface_mode("IModeCombatMovement")
    end
    do
      local team = g_CurrentTeam
      while not Dialogs.IModeCombatMovement do
        SetInGameInterfaceMode("IModeCombatMovement")
        Sleep(100)
      end
      while g_CurrentTeam == team do
        Dialogs.IModeCombatMovement:ResolveId("idTurn"):Press()
        WaitMsg("TurnEnded", 200)
      end
      local gt = GameTime()
      while g_CurrentTeam ~= team do
        WaitMsg("TurnEnded", 20)
      end
      WaitUnitsInIdle()
      wait_interface_mode("IModeCombatMovement")
    end
    local end_total_hp = 0
    for _, unit in ipairs(g_Units) do
      total_hp = total_hp + unit.HitPoints
    end
    combat_test_in_progress = false
  end
  function TestOtherInteractions(unit)
    OpenInventory(unit)
    local weapon = unit:GetItemInSlot("Handheld A")
    OpenDialog("ModifyWeaponDlg", nil, {
      weapon = weapon,
      slot = unit:GetItemPackedPos(weapon),
      owner = unit
    })
    Sleep(2000)
    CloseDialog("ModifyWeaponDlg")
    while GetDialog("ModifyWeaponDlg") do
      Sleep(16)
    end
    CloseDialog("FullscreenGameDialogs")
  end
end
