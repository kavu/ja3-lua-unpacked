AppendClass.SetpiecePrg = {
  hidden_actors = false,
  properties = {
    {
      category = "Play Settings",
      id = "CameraMode",
      name = "Camera-object behavior",
      editor = "choice",
      default = "Default",
      help = "The object hiding behavior of the camera during the setpiece.",
      items = function(self)
        return {
          "Default",
          "Hide all",
          "Show all"
        }
      end
    },
    {
      category = "Play Settings",
      id = "StopMercMovement",
      name = "Stop merc movement",
      editor = "bool",
      default = true
    },
    {
      category = "Play Settings",
      id = "Visibility",
      editor = "dropdownlist",
      items = {"Full", "Player"},
      default = "Full"
    }
  }
}
AppendClass.XSetpieceDlg = {
  LeaveDialogsOpen = {
    "ZuluChoiceDialog"
  }
}
function CanBeSetpieceActor(idx, obj)
  return IsKindOf(obj, "Unit") or not IsKindOf(obj, "EditorObject")
end
local SetpieceUpdateVisibility = function(setpiece)
  g_SetpieceFullVisibility = setpiece and setpiece.Visibility == "Full" or false
  local pov_team = GetPoVTeam()
  local active_units = Selection
  if not active_units or #active_units == 0 then
    active_units = SelectedObj
  end
  for _, actor in ipairs(setpiece.hidden_actors or empty_table) do
    if IsValid(actor) then
      if IsKindOf(actor, "Unit") then
        actor:RemoveStatusEffect("SetpieceHidden")
      else
        actor:SetVisible(true)
      end
    end
  end
  setpiece.hidden_actors = false
  ApplyUnitVisibility(active_units, pov_team, g_Visibility)
end
function OnMsg.SetpieceActorRegistered(actor)
  if IsKindOf(actor, "Unit") then
    if actor.carry_flare then
      actor:RoamDropFlare()
    end
    if actor.command == "Visit" then
      actor:SetBehavior()
      actor:SetCommand(false)
    elseif not IsMerc(actor) then
      actor:SetCommand("SetpieceIdle")
    end
  end
end
local apply_camera_mode = function(CameraMode, HidesFloorsAbove)
  if CameraMode == "Default" then
    ShowAllTreeTops("auto")
    ShowAllCanopyTops("auto")
    ShowAllWalls("auto")
    ShowAllHideFromCameraCollections("auto")
  elseif CameraMode == "Hide all" then
    ShowAllTreeTops(false)
    ShowAllCanopyTops(false)
    ShowAllWalls(false)
    ShowAllHideFromCameraCollections(false)
  elseif CameraMode == "Show all" then
    ShowAllTreeTops(true)
    ShowAllCanopyTops(true)
    ShowAllWalls(true)
    ShowAllHideFromCameraCollections(true)
  elseif CameraMode == "HideAboveFloor" then
    HideFloorsAbove(HidesFloorsAbove or 100)
  end
end
function OnSetpieceStarted(setpiece)
  CloseDialog("ConversationDialog")
  Msg("WillStartSetpiece")
  SetpieceUpdateVisibility(setpiece)
  for _, u in ipairs(g_Units) do
    u:UpdateHighlightMarking()
  end
  if setpiece.StopMercMovement then
    CancelWaitingActions(-1)
    local nonInterruptable = {}
    local units = {}
    for _, unit in ipairs(g_Units) do
      if IsMerc(unit) then
        unit:InterruptCommand("SetpieceIdle", "reset anim")
        units[#units + 1] = unit
        if not unit:IsInterruptable() then
          nonInterruptable[unit] = true
        end
      end
    end
    local cycles = 0
    repeat
      for i = #units, 1, -1 do
        if units[i].command == "SetpieceIdle" then
          table.remove(units, i)
        end
      end
      if 0 < #units then
        for i, u in ipairs(units) do
          if nonInterruptable[u] then
            if u.traverse_tunnel then
              u:SetCommand("SetpieceIdle", "reset anim")
            else
              u:InterruptCommand("SetpieceIdle", "reset anim")
            end
          end
        end
        WaitMsg("Idle", 200)
      end
      cycles = cycles + 1
    until #units == 0 or 10 <= cycles
  end
  if setpiece.CameraMode ~= "Default" then
    apply_camera_mode(setpiece.CameraMode)
  end
  SuspendInteractableHighlights()
end
function OnSetpieceEnded(setpiece)
  SetpieceUpdateVisibility(setpiece)
  for _, unit in ipairs(g_Units) do
    if type(unit.command) == "string" and string.match(unit.command, "Setpiece") then
      unit:SetCommand("Idle")
      unit:UpdateOutfit()
    end
    unit:UpdateHighlightMarking()
  end
  apply_camera_mode("Default")
  ResumeInteractableHightlights()
end
local setpiece_skipped = not IsSetpiecePlaying()
local ShouldSyncSetpieceSkip = function()
  local playingReplay = IsGameReplayRunning()
  local recordingReplay = not not GameRecord
  return IsInMultiplayerGame() or playingReplay or recordingReplay
end
local InitSPClickSync = function()
  setpiece_skipped = false
  if ShouldSyncSetpieceSkip() then
    InitPlayersClickedSync("Setpiece", function()
      local dlg = GetDialog("XSetpieceDlg")
      if dlg then
        dlg.setpieceInstance:Skip()
        if rawget(dlg, "idSkipHint") then
          dlg.idSkipHint:SetVisible(false)
        end
      end
      setpiece_skipped = true
    end, function(player_id, data)
      local dlg = GetDialog("XSetpieceDlg")
      if dlg and rawget(dlg, "idSkipHint") then
        local cntrl = dlg.idSkipHint
        if data[netUniqueId] then
          cntrl:SetText(T(221873989540, "Waiting for the other player..."))
        else
          cntrl:SetText(T({
            255716179836,
            "<Count>/<Total> players skipped cutscene",
            Count = table.count(data, function(k, v)
              return v
            end),
            Total = table.count(netGamePlayers)
          }))
        end
        if not cntrl:GetVisible() then
          cntrl:SetVisible(true)
        end
      end
    end)
  end
end
function SkipSetpiece(setpieceInstance)
  if setpiece_skipped then
    return
  end
  if not ShouldSyncSetpieceSkip() then
    setpieceInstance:Skip()
    setpiece_skipped = true
  else
    LocalPlayerClickedReady("Setpiece")
  end
end
local old_start_setpiece = StartSetpiece
function NetSyncEvents.StartSetpiece(id, test_mode, seed, setpiece_id_hash, ...)
  local setpiece = Setpieces[id]
  local dlg = GetDialog("XSetpieceDlg")
  local setpiece_state
  if setpiece.TakePlayerControl and dlg then
    InitSPClickSync()
    dlg.setpieceInstance = old_start_setpiece(id, test_mode, seed, ...)
    setpiece_state = dlg.setpieceInstance
  else
    setpiece_state = old_start_setpiece(id, test_mode, seed, ...)
    if not g_NonBlockingSetpiecesPlaying then
      g_NonBlockingSetpiecesPlaying = {}
    end
    g_NonBlockingSetpiecesPlaying[#g_NonBlockingSetpiecesPlaying + 1] = setpiece_state
  end
  Msg(setpiece_id_hash, setpiece_state)
end
function StartSetpiece(id, test_mode, seed, ...)
  local setpiece_id_hash = xxhash(id, seed)
  FireNetSyncEventOnHost("StartSetpiece", id, test_mode, seed, setpiece_id_hash, ...)
  local _, setpiece_state = WaitMsg(setpiece_id_hash)
  return setpiece_state
end
UndefineClass("SetpieceSpawnMarker")
DefineClass.SetpieceSpawnMarker = {
  __parents = {
    "SetpieceSpawnMarkerBase",
    "UnitMarker"
  },
  properties = {
    {
      id = "EnabledConditions",
      editor = false
    },
    {
      id = "Name",
      editor = "text",
      default = ""
    },
    {id = "ID", editor = false},
    {id = "Comment", editor = false},
    {id = "Reachable", editor = false},
    {id = "Trigger", editor = false},
    {id = "Conditions", editor = false},
    {id = "Effects", editor = false},
    {
      id = "Spawn_Conditions",
      editor = false
    },
    {
      id = "Despawn_Conditions",
      editor = false
    },
    {id = "sync_obj", editor = false},
    {id = "Banters", editor = false},
    {
      id = "ConflictIgnore",
      editor = false
    },
    {
      category = "Spawn Object",
      id = "Groups",
      name = "Additional groups",
      editor = "string_list",
      items = function()
        return GridMarkerGroupsCombo()
      end,
      default = false,
      arbitrary_value = true
    }
  },
  DisplayName = "Spawn",
  ConflictIgnore = true
}
SetpieceSpawnMarker.EditorGetText = SetpieceMarker.EditorGetText
SetpieceSpawnMarker.EditorCallbackClone = SetpieceMarker.EditorCallbackClone
SetpieceSpawnMarker.EditorCallbackPlace = SetpieceMarker.EditorCallbackPlace
SetpieceSpawnMarker.EditorCallbackDelete = SetpieceMarker.EditorCallbackDelete
function OnMsg.ClassesPostprocess()
  SetpieceSpawnMarker.Update = empty_func
  SetpieceSpawnMarker.UpdateText = empty_func
  SetpieceSpawnMarker.SnapToVoxel = empty_func
  SetpieceSpawnMarker.SetAngle = SetpieceMarker.SetAngle
  SetpieceSpawnMarker.SetAxisAngle = SetpieceMarker.SetAxisAngle
  SetpieceSpawnMarker.EditorCallbackMove = SetpieceMarker.EditorCallbackMove
end
function SetpieceSpawnMarker:SpawnObjects()
  if not self.UnitDataSpawnDefs or #self.UnitDataSpawnDefs < 1 then
    StoreErrorSource(self, "No UnitDataSpawnDefs are specified in the spawn marker - no units were spawned!")
    return
  end
  local objs = UnitMarker.SpawnObjects(self)
  self.objects = false
  self.last_spawned_objects = false
  for _, obj in ipairs(objs) do
    if IsKindOf(obj, "Unit") then
      function obj:OnCommandStart()
        if self.command == "SetpieceIdle" then
          self.OnCommandStart = nil
        end
      end
    end
  end
  return objs
end
DefineClass.SetpieceAssignFromSquad = {
  __parents = {
    "PrgSetpieceAssignActor"
  },
  properties = {
    {
      id = "Squad",
      editor = "number",
      default = 1
    },
    {
      id = "Unit",
      editor = "number",
      default = 1
    }
  },
  EditorView = Untranslated("Actor(s) '<AssignTo>' += squad <Squad> unit <Unit>"),
  EditorName = "Actor(s) from squad"
}
function SetpieceAssignFromSquad.FindObjects(state, Marker, Squad, Unit)
  local squads = GetSquadsInSector(gv_CurrentSectorId)
  local squad = squads and squads[Squad]
  return squad and squad.units and Groups[squad.units[Unit]] or empty_table
end
DefineClass.SetpieceIfQuestVar = {
  __parents = {"PrgIf"},
  properties = {
    {
      id = "Repeat",
      editor = "bool",
      default = false,
      no_edit = true
    },
    {
      id = "Condition",
      editor = "expression",
      default = empty_func,
      no_edit = true
    },
    {
      id = "QuestId",
      name = "Quest id",
      editor = "preset_id",
      default = false,
      preset_class = "QuestsDef",
      preset_filter = function(preset, obj)
        return QuestHasVariable(preset, "QuestVarBool")
      end
    },
    {
      id = "Vars",
      name = "Vars to check",
      help = "Click on a variable to turn it green, click again to turn it red. The condition will check if all of the green are true AND all of the red are false.",
      editor = "set",
      default = false,
      three_state = true,
      items = function(self)
        return table.keys2(QuestGetVariables(self.QuestId), "sorted")
      end
    }
  },
  EditorName = "Condition by quest variable",
  EditorSubmenu = "Code flow",
  StatementTag = "Basics"
}
function SetpieceIfQuestVar:GetExprCode(for_preview)
  if not (self.QuestId and self.Vars) or not next(self.Vars) then
    return "true"
  end
  local t = {}
  for k, v in sorted_pairs(self.Vars) do
    if for_preview then
      table.insert(t, string.format("%s%s", v and "" or "not ", k))
    else
      table.insert(t, string.format("%sGetQuestVar(\"%s\", \"%s\")", v and "" or "not ", self.QuestId, k))
    end
  end
  return (for_preview and self.QuestId .. ": " or "") .. table.concat(t, " and ")
end
DefineClass.SetpieceDeath = {
  __parents = {
    "PrgSetpieceCommand"
  },
  properties = {
    {
      id = "Actors",
      name = "Actor(s)",
      editor = "choice",
      default = "",
      items = SetpieceActorsCombo,
      variable = true
    },
    {
      id = "Animation",
      editor = "choice",
      default = false,
      items = function()
        return UnitAnimationsCombo()
      end
    }
  },
  EditorName = "Death"
}
function SetpieceDeath:GetEditorView()
  local suffix = self.Animation and string.format(" with '%s' anim", self.Animation) or ""
  return self:GetWaitCompletionPrefix() .. self:GetCheckpointPrefix() .. string.format("Actor(s) '%s' die%s", self.Actors, suffix)
end
function SetpieceDeath.ExecThread(state, Actors, Animation)
  local dying = 0
  local message = CurrentThread()
  for _, actor in ipairs(Actors) do
    if IsValid(actor) then
      actor.HitPoints = 0
      PlayFX("Death", "start", actor)
      actor:SetCommand(function(self)
        self:PushDestructor(function(self)
          dying = dying - 1
          if dying <= 0 then
            Msg(message)
          end
        end)
        self:PlayDying(nil, nil, Animation)
        self:QueueCommand("Dead")
        self:SyncWithSession("map")
        Msg("UnitDieStart", self)
        Msg("UnitDiedOnSector", self, gv_CurrentSectorId)
        Msg("UnitDie", self)
      end)
      dying = dying + 1
    end
  end
  if 0 < dying then
    WaitMsg(message)
  end
  for _, actor in ipairs(Actors) do
    if IsValid(actor) then
      actor:DropLoot()
      actor:SyncWithSession("map")
    end
  end
end
function SetpieceDeath.Skip(state, Actors)
  for _, actor in ipairs(Actors) do
    actor.HitPoints = 0
    if actor.command ~= "Dead" then
      actor:SetCommand(false)
      if actor.behavior ~= "Death" then
        actor:PlayDying(true)
      end
      actor:SetCommand("Dead")
      actor:SyncWithSession("map")
      Msg("UnitDieStart", actor)
      Msg("UnitDie", actor)
    end
    actor:DropLoot()
    actor:SyncWithSession("map")
  end
end
function AnimStancesCombo()
  local items = {
    "CoverLow",
    "CoverHighLeft",
    "CoverHighRight"
  }
  ForEachPreset("CombatStance", function(obj)
    items[#items + 1] = obj.id
  end)
  return items
end
function AnimWeaponsCombo()
  local items = {
    "Current Weapon",
    "No Weapon"
  }
  ForEachPreset("InventoryItemCompositeDef", function(obj)
    local classdef = g_Classes[obj.object_class]
    if IsKindOf(classdef, "Firearm") then
      items[#items + 1] = obj.id
    end
  end)
  return items
end
function WaitSetpieceIdle(actors)
  repeat
    local non_idle
    for _, actor in ipairs(actors) do
      if IsValid(actor) and actor.command ~= "SetpieceIdle" then
        non_idle = true
        break
      end
    end
    if not non_idle then
      break
    end
    WaitMsg("OnSetpieceIdleStart")
  until false
end
DefineClass.SetpieceSetStance = {
  __parents = {
    "PrgSetpieceCommand"
  },
  properties = {
    {
      id = "Actors",
      name = "Actor(s)",
      editor = "choice",
      default = "",
      items = SetpieceActorsCombo,
      variable = true
    },
    {
      id = "Stance",
      name = "Stance",
      editor = "choice",
      default = "Standing",
      items = AnimStancesCombo
    },
    {
      id = "Weapon",
      name = "Weapon",
      editor = "choice",
      default = "Current Weapon",
      items = AnimWeaponsCombo
    },
    {
      id = "Transition",
      name = "Use transition anim",
      editor = "bool",
      default = true
    }
  },
  EditorName = "Set stance"
}
function SetpieceSetStance:GetEditorView()
  return self:GetWaitCompletionPrefix() .. self:GetCheckpointPrefix() .. string.format("Actor(s) '%s' in stance %s with %s", self.Actors == "" and "()" or self.Actors, self.Stance, self.Weapon)
end
function SetpieceSetStance.ExecThread(state, Actors, stance, weapon, transition)
  local duration = 0
  for i, actor in ipairs(Actors) do
    if actor.species == "Human" then
      actor:SetCommand("SetpieceIdle")
      local unitPos = actor:GetVisualPos()
      if unitPos:IsValidZ() then
        local terrainZ = terrain.GetHeight(unitPos)
        if unitPos:z() == terrainZ then
          unitPos = unitPos:SetInvalidZ()
        end
      end
      actor:SetPos(unitPos)
      actor:SetAngle(actor:GetVisualAngle())
      local prefix = SetpieceSetStance.SetupActorWeapon(actor, weapon)
      actor:SetCommandParamValue("SetpieceIdle", "weapon_anim_prefix", prefix)
      actor:SetCommandParamValue("SetpieceSetStance", "weapon_anim_prefix", prefix)
      local stance1 = actor.stance ~= "CoverLow" and actor.stance or "Crouch"
      local stance2 = stance ~= "CoverLow" and stance or "Crouch"
      if stance1 == stance2 then
        local base_idle = actor:GetIdleBaseAnim(stance1)
        if not IsAnimVariant(actor:GetStateText(), base_idle) then
          local anim = actor:GetNearbyUniqueRandomAnim(base_idle)
          actor:SetState(anim)
        end
      else
        local transition_anim = string.format("%s%s_To_%s", prefix, stance1, stance2)
        actor:SetState(transition_anim)
        duration = Max(duration, actor:TimeToAnimEnd())
      end
    end
  end
  state:SetSkipFn(SetpieceSetStance.SkipStanceOnly, CurrentThread())
  Sleep(duration)
  for i, actor in ipairs(Actors) do
    if actor.species ~= "Human" then
      actor:SetCommand("SetpieceSetStance", stance)
    end
  end
  WaitSetpieceIdle(Actors)
end
function SetpieceSetStance.Skip(state, Actors, stance, weapon)
  for i, actor in ipairs(Actors) do
    local prefix = SetpieceSetStance.SetupActorWeapon(actor, weapon)
    actor:SetCommandParamValue("SetpieceIdle", "weapon_anim_prefix", prefix)
    actor:SetCommandParamValue("SetpieceSetStance", "weapon_anim_prefix", prefix)
    actor:SetCommand("SetpieceSetStance", stance)
  end
end
function SetpieceSetStance.SkipStanceOnly(state, Actors, stance)
  for i, actor in ipairs(Actors) do
    actor:SetCommand("SetpieceSetStance", stance)
  end
end
function SetpieceSetStance.SetupActorWeapon(actor, set_weapon)
  local anim_prefix = "ar_"
  local weapon
  if set_weapon == "Current Weapon" then
    local item, item2 = actor:GetActiveWeapons()
    anim_prefix = GetWeaponAnimPrefix(item, item2)
    for _, item in ipairs({item, item2}) do
      local weapon = item and item:GetVisualObj()
      if weapon then
        weapon:SetHierarchyEnumFlags(const.efVisible)
      end
    end
  else
    actor:DestroyAttaches("WeaponVisual")
    if set_weapon == "No Weapon" then
      anim_prefix = "civ_"
    else
      local item = PlaceInventoryItem(set_weapon)
      actor:ClearSlot("SetpieceWeapon")
      actor:AddItem("SetpieceWeapon", item)
      anim_prefix = GetWeaponAnimPrefix(item)
    end
    actor:UpdateOutfit()
  end
  return anim_prefix
end
DefineClass.SetpieceGotoPosition = {
  __parents = {
    "PrgSetpieceCommand"
  },
  properties = {
    {
      id = "Actors",
      name = "Actor(s)",
      editor = "choice",
      default = "",
      items = SetpieceActorsCombo,
      variable = true
    },
    {
      id = "Marker",
      name = "Pos marker",
      editor = "choice",
      default = "",
      items = SetpieceMarkersCombo("SetpiecePosMarker"),
      buttons = SetpieceMarkerPropButtons("SetpiecePosMarker"),
      no_validate = SetpieceCheckMap
    },
    {
      id = "Orient",
      name = "End Move Orient",
      editor = "bool",
      default = true
    },
    {
      id = "UseRun",
      name = "Running",
      editor = "bool",
      default = true,
      help = "Considered when no move style is specified."
    },
    {
      id = "StraightLine",
      name = "Straight line",
      editor = "bool",
      default = false
    },
    {
      id = "Stance",
      name = "Stance",
      editor = "combo",
      default = "",
      items = {
        "",
        "Standing",
        "Crouch",
        "Prone"
      }
    },
    {
      id = "animated_rotation",
      name = "Animated Rotation",
      editor = "bool",
      default = false
    },
    {
      id = "RandomizePhase",
      name = "Randomize phase",
      editor = "bool",
      default = false,
      help = "When moving an actor group, randomizes the time each actor starts moving."
    },
    {
      id = "MoveStyle",
      name = "Move style",
      editor = "combo",
      default = "",
      items = function(self)
        return GetMoveStyleCombo()
      end
    }
  },
  EditorName = "Go to (for Zulu units)"
}
function SetpieceGotoPosition:GetEditorView()
  return self:GetWaitCompletionPrefix() .. self:GetCheckpointPrefix() .. string.format("Actor(s) '<color 70 140 140>%s</color>' go to '<color 140 140 70>%s</color>' ", self.Actors, self.Marker)
end
function SetpieceGotoPosition.ExecThread(state, Actors, Marker, Orient, UseRun, StraightLine, Stance, AnimatedRotation, RandomizePhase, MoveStyle)
  if not Actors or #Actors == 0 then
    return
  end
  local marker = SetpieceMarkerByName(Marker, "check")
  if not marker then
    return
  end
  local pts = marker:GetActorLocations(Actors)
  local angle = Orient and marker:GetAngle()
  for i, actor in ipairs(Actors) do
    actor:SetCommandParamValue("SetpieceGoto", "move_style", MoveStyle)
    actor:SetCommandParamValue("SetpieceGoto", "move_anim", UseRun and "Run" or "Walk")
    actor:SetCommand("SetpieceGoto", pts[i], angle, Stance, StraightLine, AnimatedRotation, RandomizePhase and state.rand(1250))
  end
  while true do
    WaitMsg("UnitMovementDone", 100)
    local movement_done = true
    for _, actor in ipairs(Actors) do
      movement_done = movement_done and actor.command ~= "SetpieceGoto"
    end
    if movement_done then
      break
    end
  end
end
function SetpieceGotoPosition.Skip(state, Actors, Marker, Orient, UseRun)
  local marker = SetpieceMarkerByName(Marker, "check")
  local valid_actors = table.ifilter(Actors, function(i, obj)
    return IsValid(obj)
  end)
  if not marker or #valid_actors == 0 then
    return
  end
  local pts = marker:GetActorLocations(valid_actors)
  for i, actor in ipairs(valid_actors) do
    actor:SetPos(pts[i])
    actor:SetCommand("SetpieceSetStance", actor.stance)
    if Orient then
      actor:SetAngle(marker:GetAngle())
    end
  end
end
DefineClass.SetpieceAnimationStyle = {
  __parents = {
    "PrgSetpieceCommand"
  },
  properties = {
    {
      id = "Actors",
      name = "Actor(s)",
      editor = "choice",
      default = "",
      items = SetpieceActorsCombo,
      variable = true
    },
    {
      id = "_desthelp",
      editor = "help",
      help = "Leave Destination empty to play the animation in place."
    },
    {
      id = "Marker",
      name = "Destination",
      editor = "choice",
      default = "",
      items = SetpieceMarkersCombo("SetpiecePosMarker"),
      buttons = SetpieceMarkerPropButtons("SetpiecePosMarker"),
      no_validate = SetpieceCheckMap
    },
    {
      id = "AnimationStyle",
      name = "Animation style",
      editor = "combo",
      default = "",
      items = function(self)
        return GetIdleStyleCombo()
      end
    },
    {
      id = "Orient",
      name = "Use orientation",
      editor = "bool",
      default = true
    },
    {
      id = "AnimSpeed",
      name = "Animation speed",
      editor = "number",
      default = 1000
    },
    {
      id = "Duration",
      name = "Duration (ms)",
      editor = "number",
      default = 0
    }
  },
  EditorName = "Play animation style"
}
if FirstLoad then
  SetpieceAnimationStyleThreads = setmetatable({}, weak_keys_meta)
end
function SetpieceAnimationStyle:GetEditorView()
  local marker_txt = self.Marker ~= "" and string.format(" to marker '<color 140 140 70>%s</color>'", self.Marker) or ""
  return self:GetWaitCompletionPrefix() .. self:GetCheckpointPrefix() .. string.format("Actor '<color 70 140 140>%s</color>' anim style'<color 140 70 140>%s</color>'%s", self.Actors == "" and "()" or self.Actors, self.AnimationStyle, marker_txt)
end
function SetpieceAnimationStyle.ExecThread(state, Actors, Marker, AnimationStyle, Orient, AnimSpeed, Duration)
  if not Actors or #Actors == 0 or AnimationStyle == "" then
    return
  end
  local marker = SetpieceMarkerByName(Marker)
  if marker then
    marker:SetActorsPosOrient(Actors, false, 0, Orient)
  end
  for i, actor in ipairs(Actors) do
    actor:SetAnimSpeedModifier(AnimSpeed)
    if 2 <= i then
      SetpieceAnimationStyleThreads[actor] = CreateGameTimeThread(actor.PlayIdleStyle, actor, AnimationStyle, Duration)
    end
  end
  Actors[1]:PlayIdleStyle(AnimationStyle, Duration)
  SetpieceAnimationStyle.Skip(state, Actors)
end
function SetpieceAnimationStyle.Skip(state, Actors)
  for _, actor in ipairs(Actors) do
    local thread = SetpieceAnimationStyleThreads[actor]
    if thread then
      DeleteThread(thread)
      SetpieceAnimationStyleThreads[actor] = nil
    end
    actor:SetAnimSpeedModifier(1000)
  end
end
if FirstLoad then
  SetpieceShootThreads = setmetatable({}, weak_keys_meta)
end
DefineClass.SetpieceShoot = {
  __parents = {
    "PrgSetpieceCommand"
  },
  properties = {
    {
      id = "Actors",
      name = "Actor(s)",
      editor = "choice",
      default = "",
      items = SetpieceActorsCombo,
      variable = true
    },
    {
      id = "TargetType",
      name = "Target type",
      editor = "choice",
      items = {"Unit", "Point"},
      default = "Unit"
    },
    {
      id = "TargetUnits",
      name = "Target unit",
      editor = "choice",
      default = "",
      items = SetpieceActorsCombo,
      variable = true,
      no_edit = function(self)
        return self.TargetType ~= "Unit"
      end
    },
    {
      id = "TargetBodyPart",
      name = "Target Body Part",
      editor = "choice",
      items = PresetGroupCombo("TargetBodyPart", "Default"),
      default = "Torso",
      no_edit = function(self)
        return self.TargetType ~= "Unit"
      end
    },
    {
      id = "TargetPos",
      name = "Target pos",
      editor = "choice",
      default = "",
      items = SetpieceMarkersCombo("SetpiecePosMarker"),
      buttons = SetpieceMarkerPropButtons("SetpiecePosMarker"),
      no_validate = SetpieceCheckMap,
      no_edit = function(self)
        return self.TargetType ~= "Point"
      end
    },
    {
      id = "NumShots",
      name = "Num Shots",
      editor = "number",
      min = 1,
      max = 100,
      default = 1
    },
    {
      id = "ShotInterval",
      name = "Shot Interval",
      editor = "number",
      scale = "sec",
      min = 0,
      default = 0,
      help = "extra time added before restarting the shoot animation when firing multiple shots"
    },
    {
      id = "InitialDelay",
      name = "Initial Delay",
      editor = "number",
      scale = "sec",
      min = 0,
      default = 0
    },
    {
      id = "AnimSpeed",
      name = "Anim Speed",
      editor = "number",
      scale = "%",
      min = 1,
      max = 1000,
      default = 100
    },
    {
      id = "TargetOffset",
      name = "Target Offset",
      editor = "number",
      scale = "m",
      min = 0,
      default = 0,
      no_edit = function(self)
        return self.TargetType ~= "Point"
      end
    },
    {
      id = "NumMisses",
      name = "Num Misses",
      editor = "number",
      min = 0,
      default = 0,
      max = function(self)
        return self.TargetType ~= "Point" and self.NumShots or 100
      end,
      no_edit = function(self)
        return self.TargetType == "Point"
      end,
      help = "how many of the shots should be missing the target"
    }
  },
  EditorName = "Shoot"
}
function SetpieceShoot:GetEditorView()
  local target
  if self.TargetType == "Unit" then
    target = self.TargetUnits == "" and "()" or self.TargetUnits
    return self:GetWaitCompletionPrefix() .. self:GetCheckpointPrefix() .. string.format("Actor(s) '%s' shoots %s in the %s", self.Actors, target, self.TargetBodyPart)
  end
  target = self.TargetPos
  return self:GetWaitCompletionPrefix() .. self:GetCheckpointPrefix() .. string.format("Actor(s) '%s' shoots %s", self.Actors, target)
end
function SetpieceShoot.ExecThread(state, Actors, TargetType, TargetUnits, TargetBodyPart, TargetPos, NumShots, ShotInterval, InitialDelay, AnimSpeed, TargetOffset, NumMisses)
  local target_pt, target_obj = SetpieceShoot.ResolveTargetPt(state, TargetType, TargetUnits, TargetBodyPart, TargetPos)
  for _, actor in ipairs(Actors) do
    actor:SetCommand("SetpieceAimAt", target_pt)
  end
  while true do
    local done = true
    for _, actor in ipairs(Actors) do
      done = done and actor.command == "SetpieceIdle"
    end
    if done then
      break
    end
    WaitMsg("SetpieceUnitAimed", 100)
  end
  local threads = SetpieceShootThreads
  for _, actor in ipairs(Actors) do
    threads[actor] = CreateGameTimeThread(function()
      local weapon = actor:GetActiveWeapons("Firearm") or actor:GetActiveWeapons("RocketLauncher")
      local zooka = IsKindOf(weapon, "RocketLauncher")
      if not weapon then
        StoreErrorSource(actor, string.format("SetpieceShoot trying to fire an unsupported weapon of class '%s' for actor '%s'", weapon and weapon.class or "(nil)", actor.unitdatadef_id or actor.class))
        return
      end
      local ordnance, target_points
      local is_missed = {}
      local attack_data, lof_data
      if IsValid(target_obj) then
        attack_data = actor:ResolveAttackParams("SingleShot", target_obj, {target = target_obj, target_spot_group = TargetBodyPart})
        lof_data = attack_data.lof and attack_data.lof[1]
        target_pt = lof_data and lof_data.target_pos or target_pt
      else
        attack_data = actor:ResolveAttackParams("SingleShot", target_pt)
        if not attack_data.anim then
          attack_data.anim = actor:GetAttackAnim("SingleShot", actor.stance)
        end
      end
      actor:SetPos(attack_data.step_pos)
      local visual_obj = weapon:GetVisualObj(actor)
      if zooka then
        ordnance = weapon.ammo
        if not ordnance then
          for name, class in sorted_pairs(ClassDescendants("Ordnance")) do
            if class.Caliber == weapon.Caliber then
              ordnance = class
            end
          end
        end
        if not ordnance then
          StoreErrorSource(actor, string.format("SetpieceShoot unable to find suitable ordnance to fire from weapon of class '%s' for actor '%s'", weapon.class, actor.unitdatadef_id or actor.class))
          return
        end
      elseif IsValid(target_obj) then
        local step_pos = attack_data.step_pos or actor:GetPos()
        local lof_pos1 = lof_data and lof_data.lof_pos1 or step_pos
        local num_misses = NumMisses or 0
        local num_hits = NumShots - num_misses
        local shot_attack_args = {
          target_spot_group = TargetBodyPart,
          stance = actor.stance,
          step_pos = step_pos
        }
        local lof_data = {lof_pos1 = lof_pos1, target_pos = target_pt}
        local hit_vectors, miss_vectors = Firearm:CalcShotVectors(actor, "SingleShot", target_obj, shot_attack_args, lof_data, 20 * guic, guim, guim, num_hits, num_misses)
        local lowest
        target_points = {}
        for _, hit in ipairs(hit_vectors) do
          table.insert(target_points, hit.target_pos)
          if not lowest or hit.target_pos:z() < lowest:z() then
            lowest = hit.target_pos
          end
        end
        for _, miss in ipairs(miss_vectors) do
          table.insert(target_points, miss.target_pos)
          is_missed[point_pack(miss.target_pos)] = true
          if not lowest or miss.target_pos:z() < lowest:z() then
            lowest = miss.target_pos
          end
        end
        while #target_points < NumShots do
          table.insert(target_points, target_pt)
          if not lowest or target_pt:z() < lowest:z() then
            lowest = target_pt
          end
        end
        table.sort(target_points, function(a, b)
          return lowest:Dist(a) < lowest:Dist(b)
        end)
      elseif TargetOffset and 0 < TargetOffset then
        local dir = (target_pt - actor:GetPos()):SetZ(0)
        if 0 < dir:Len2D2() then
          target_points = {}
          for i = 1, NumShots do
            local z = InteractionRand(TargetOffset, "Setpiece")
            local angle = InteractionRand(21600, "Setpiece")
            target_points[i] = target_pt + RotateAxis(point(0, 0, z), dir, angle)
          end
        end
      end
      Sleep(InitialDelay)
      if IsValid(actor) then
        actor:SetAnimSpeedModifier(AnimSpeed * 10)
      end
      for si = 1, NumShots do
        if not IsValid(actor) then
          break
        end
        local shot_target_pt = target_points and target_points[si] or target_pt
        actor:SetState(attack_data.anim, 0, 0)
        Sleep(actor:TimeToMoment(1, "hit") or 0)
        if visual_obj then
          local projectile_spawn_pos = GetWeaponSpotPos(visual_obj, "Muzzle")
          local action_dir = SetLen(shot_target_pt - projectile_spawn_pos, 4096)
          local fx_target = visual_obj.parts.Muzzle or visual_obj.parts.Barrel or visual_obj
          PlayFX("WeaponFire", "start", visual_obj, fx_target, projectile_spawn_pos, action_dir)
          if zooka then
            local dist = projectile_spawn_pos:Dist(shot_target_pt)
            local time = MulDivRound(dist, 1000, const.Combat.RocketVelocity)
            local trajectory = {
              {pos = projectile_spawn_pos, t = 0},
              {pos = shot_target_pt, t = time}
            }
            local attaches = visual_obj:GetAttaches("OrdnanceVisual")
            local projectile
            if attaches then
              projectile = attaches[1]
              projectile:Detach()
            else
              projectile = PlaceObject("OrdnanceVisual", {
                fx_actor_class = ordnance.class
              })
              local angle = CalcOrientation(projectile_spawn_pos, shot_target_pt)
              projectile:SetAngle(angle)
            end
            weapon:UpdateRocket()
            PlayFX("RocketFire", "start", projectile)
            local rotation_axis = RotateAxis(axis_x, axis_z, CalcOrientation(shot_target_pt, projectile_spawn_pos))
            CreateGameTimeThread(function()
              AnimateThrowTrajectory(projectile, trajectory, rotation_axis, 0)
              DoneObject(projectile)
            end)
          else
            local hit
            if is_missed[point_pack(shot_target_pt)] then
              hit = {
                distance = shot_target_pt:Dist(projectile_spawn_pos),
                pos = shot_target_pt,
                shot_dir = action_dir,
                setpiece = true
              }
            else
              hit = {
                obj = target_obj,
                distance = shot_target_pt:Dist(projectile_spawn_pos),
                pos = shot_target_pt,
                shot_dir = action_dir,
                spot_group = TargetBodyPart,
                setpiece = true
              }
            end
            CreateGameTimeThread(Firearm.ProjectileFly, Firearm, actor, projectile_spawn_pos, shot_target_pt, action_dir, const.Combat.BulletVelocity, {hit})
          end
        end
        Sleep(actor:TimeToAnimEnd())
        if si < NumShots and 0 < ShotInterval and not zooka then
          actor:RestoreAiming(shot_target_pt)
          Sleep(ShotInterval)
        end
      end
      if IsValid(actor) then
        actor:SetAnimSpeedModifier(1000)
      end
      threads[actor] = false
      Msg("SetpieceShootDone")
    end)
  end
  repeat
    local all_done = true
    for _, actor in ipairs(Actors) do
      local thread = threads[actor]
      if IsValidThread(thread) then
        WaitMsg("SetpieceShootDone", 100)
        all_done = false
        break
      end
    end
  until all_done
  for _, actor in ipairs(Actors) do
    if IsValid(actor) then
      actor:RestoreAiming(target_pt)
    end
  end
end
function SetpieceShoot.Skip(state, Actors, TargetType, TargetUnits, TargetBodyPart, TargetPos)
  local target_pt = SetpieceShoot.ResolveTargetPt(state, TargetType, TargetUnits, TargetBodyPart, TargetPos)
  for _, actor in ipairs(Actors) do
    local thread = SetpieceShootThreads[actor]
    if IsValidThread(thread) then
      DeleteThread(thread)
      SetpieceShootThreads[actor] = nil
    end
    actor:SetAnimSpeedModifier(1000)
    actor:SetCommand("SetpieceIdle")
    actor:RestoreAiming(target_pt)
  end
end
function SetpieceShoot.ResolveTargetPt(state, TargetType, TargetUnits, TargetBodyPart, TargetPos)
  local target_pt, target
  if TargetType == "Unit" then
    local n = #TargetUnits
    target = 0 < n and TargetUnits[1 + state.rand(n)]
    target_pt = target and target:GetStaticSpotPos(TargetBodyPart)
  else
    local marker = SetpieceMarkerByName(TargetPos, "check")
    target_pt = marker and marker:GetPos()
  end
  if target_pt and not target_pt:IsValidZ() then
    target_pt = target_pt:SetTerrainZ()
  end
  return target_pt, target
end
DefineClass.SetpiecePlayAwarenessAnim = {
  __parents = {
    "PrgSetpieceCommand"
  },
  properties = {
    {
      id = "Actors",
      name = "Actor(s)",
      editor = "choice",
      default = "",
      items = SetpieceActorsCombo,
      variable = true
    }
  },
  EditorName = "Play Become Aware"
}
function SetpiecePlayAwarenessAnim:GetEditorView()
  return self:GetWaitCompletionPrefix() .. self:GetCheckpointPrefix() .. string.format("Actor(s) '%s' become aware", self.Actors)
end
function SetpiecePlayAwarenessAnim.ExecThread(state, Actors)
  for _, actor in ipairs(Actors) do
    if IsValid(actor) then
      actor:SetCommand("PlayAwarenessAnim", "SetpieceIdle")
    end
  end
  WaitSetpieceIdle(Actors)
end
function SetpiecePlayAwarenessAnim.Skip(state, Actors)
  for _, actor in ipairs(Actors) do
    if IsValid(actor) then
      actor:SetCommand("SetpieceIdle")
    end
  end
end
DefineClass.SetpieceActionCamera = {
  __parents = {
    "PrgSetpieceCommand"
  },
  properties = {
    {
      id = "Actors",
      name = "Actor",
      editor = "choice",
      default = "",
      items = SetpieceActorsCombo,
      variable = true
    },
    {
      id = "Targets",
      name = "Target",
      editor = "choice",
      default = "",
      items = SetpieceActorsCombo,
      variable = true
    },
    {
      id = "Preset",
      name = "Action camera preset",
      editor = "preset_id",
      default = "Any",
      preset_class = "ActionCameraDef",
      extra_item = "Any"
    },
    {
      id = "Position",
      editor = "choice",
      default = "Any",
      items = {
        "Any",
        "Left",
        "Right"
      }
    },
    {
      id = "TransitionTime",
      name = "Transition (ms)",
      editor = "number",
      default = 500
    },
    {
      id = "Duration",
      name = "Duration (ms)",
      editor = "number",
      default = 2000
    },
    {
      id = "FadeOutTime",
      name = "Fade out time (ms)",
      editor = "number",
      default = 700
    },
    {
      id = "Float",
      name = "Float camera around",
      editor = "bool",
      default = false
    }
  },
  EditorName = "Action camera",
  EditorSubmenu = "Move camera"
}
function SetpieceActionCamera:GetEditorView()
  return self:GetWaitCompletionPrefix() .. self:GetCheckpointPrefix() .. string.format("Action camera from '%s' targeting '%s'", self.Actors, self.Targets)
end
function SetpieceActionCamera.CalcCamera(attacker, target, Preset, Position)
  local pos, lookat, preset
  if Preset ~= "Any" then
    local valid_cameras, all_cameras = {}, {}
    AddActionCameraForPreset(attacker, target, Presets.ActionCameraDef.Default[Preset], valid_cameras, all_cameras, Position)
    if #all_cameras < 1 then
      return CalcActionCamera(attacker, target, Position)
    end
    local cam = valid_cameras[1] or Position == "Any" and (#all_cameras[1][4] < #all_cameras[2][4] and all_cameras[1] or all_cameras[2]) or all_cameras[1]
    pos, lookat, preset = cam[1], cam[2], cam[3]
  else
    pos, lookat, preset = CalcActionCamera(attacker, target, Position)
  end
  return pos, lookat, preset
end
function SetpieceActionCamera.ExecThread(state, Actors, Targets, Preset, Position, TransitionTime, Duration, FadeOutTime, Float)
  local attacker, target = Targets[1], Actors[1]
  local pos, lookat, preset = SetpieceActionCamera.CalcCamera(attacker, target, Preset, Position)
  SetActionCameraDirect(attacker, target, pos, lookat, preset, not Float, MulDivRound(TransitionTime, 1000, GetTimeFactor()))
  Sleep(Max(Duration - FadeOutTime, 1))
  local dlg = GetDialog("XSetpieceDlg")
  if dlg then
    dlg:FadeOut(FadeOutTime)
  end
  RemoveActionCamera("force")
end
function SetpieceActionCamera.Skip(state, ...)
  RemoveActionCamera("force")
end
DefineClass.SetpieceActionCameraSingle = {
  __parents = {
    "PrgSetpieceCommand"
  },
  properties = {
    {
      id = "Actors",
      name = "Actor",
      editor = "choice",
      default = "",
      items = SetpieceActorsCombo,
      variable = true
    },
    {
      id = "TargetOffset",
      name = "Target Offset",
      editor = "number",
      default = 2 * guim,
      scale = "m",
      min = 10 * guic
    },
    {
      id = "TargetHeight",
      name = "Target Height",
      editor = "number",
      default = 0,
      scale = "m"
    },
    {
      id = "TargetAngleOffset",
      name = "Target Angle Offset",
      editor = "number",
      default = 0,
      scale = "deg"
    },
    {
      id = "Preset",
      name = "Action camera preset",
      editor = "preset_id",
      default = "Any",
      preset_class = "ActionCameraDef",
      extra_item = "Any"
    },
    {
      id = "Position",
      editor = "choice",
      default = "Any",
      items = {
        "Any",
        "Left",
        "Right"
      }
    },
    {
      id = "TransitionTime",
      name = "Transition (ms)",
      editor = "number",
      default = 500
    },
    {
      id = "Duration",
      name = "Duration (ms)",
      editor = "number",
      default = 2000
    },
    {
      id = "FadeOutTime",
      name = "Fade out time (ms)",
      editor = "number",
      default = 700
    },
    {
      id = "Float",
      name = "Float camera around",
      editor = "bool",
      default = false
    }
  },
  EditorName = "Action camera (single)",
  EditorSubmenu = "Move camera"
}
function SetpieceActionCameraSingle.CalcTarget(Actors, TargetOffset, TargetHeight, TargetAngleOffset)
  local attacker = Actors[1]
  if not IsValid(attacker) then
    return
  end
  local target = attacker:GetPos() + Rotate(point(TargetOffset, 0, 0), attacker:GetAngle() + TargetAngleOffset)
  target = target:SetTerrainZ(TargetHeight)
  return target
end
function SetpieceActionCameraSingle.ExecThread(state, Actors, TargetOffset, TargetHeight, TargetAngleOffset, Preset, Position, TransitionTime, Duration, FadeOutTime, Float)
  local target = SetpieceActionCameraSingle.CalcTarget(Actors, TargetOffset, TargetHeight, TargetAngleOffset)
  return SetpieceActionCamera.ExecThread(state, Actors, {target}, Preset, Position, TransitionTime, Duration, FadeOutTime, Float)
end
function SetpieceActionCameraSingle:GetEditorView()
  return self:GetWaitCompletionPrefix() .. self:GetCheckpointPrefix() .. string.format("Action camera (single) from '%s'", self.Actors)
end
function SetpieceActionCameraSingle.Skip(state, ...)
  RemoveActionCamera("force")
end
DefineClass.SetpieceTacCamera = {
  __parents = {
    "PrgSetpieceCommand"
  },
  properties = {
    {
      id = "Actors",
      name = "Actor",
      editor = "choice",
      default = "",
      items = SetpieceActorsCombo,
      variable = true
    },
    {
      id = "TransitionTime",
      name = "Transition TIme",
      editor = "number",
      min = 0,
      default = 500,
      scale = "sec"
    },
    {
      id = "FaceActor",
      name = "Face Actor",
      editor = "bool",
      default = false
    },
    {
      id = "Zoom",
      name = "Set Zoom Level",
      editor = "bool",
      default = false
    },
    {
      id = "ZoomLevel",
      name = "Zoom Level",
      editor = "number",
      slider = true,
      no_edit = function(self)
        return not self.Zoom
      end,
      min = hr.CameraTacMinZoom,
      max = hr.CameraTacMaxZoom,
      default = (hr.CameraTacMinZoom + hr.CameraTacMaxZoom) / 2
    },
    {
      id = "CustomFloor",
      name = "Set Floor",
      editor = "bool",
      default = false
    },
    {
      id = "Floor",
      editor = "number",
      default = hr.CameraTacMinFloor,
      min = hr.CameraTacMinFloor,
      max = hr.CameraTacMaxFloor,
      slider = true,
      no_edit = function(self)
        return not self.CustomFloor
      end
    }
  },
  EditorName = "Tactical camera",
  EditorSubmenu = "Move camera"
}
function SetpieceTacCamera.CameraFaceActor(obj)
  local angle = obj:GetAngle()
  local pos, look_at = cameraTac.GetPosLookAt()
  local dir = look_at - pos
  local len = dir:SetZ(0):Len()
  local new_lookat = pos + Rotate(point(len, 0, 0), angle - 10800):SetZ(dir:z())
  cameraTac.SetCamera(pos, new_lookat, 0, hr.CameraTacPosEasing)
end
function SetpieceTacCamera.ExecThread(state, Actors, TransitionTime, FaceActor, Zoom, ZoomLevel, CustomFloor, Floor)
  local actor = Actors[1]
  if FaceActor then
    SetpieceTacCamera.CameraFaceActor(actor)
  end
  if Zoom then
    cameraTac.SetZoom(ZoomLevel * 10)
  end
  TransitionTime = Max(0, TransitionTime)
  SnapCameraToObj(actor, "force", CustomFloor and Floor, TransitionTime)
  if 0 < TransitionTime then
    Sleep(TransitionTime)
  end
end
function SetpieceTacCamera:GetEditorView()
  return self:GetWaitCompletionPrefix() .. self:GetCheckpointPrefix() .. string.format("Move tac camera to '%s'", self.Actors)
end
function SetpieceTacCamera.Skip(state, Actors, TransitionTime, ...)
  return SetpieceTacCamera.Exec(state, Actors, 0, ...)
end
function OnMsg.CanSaveGameQuery(query)
  local dlg = GetDialog("XSetpieceDlg")
  if dlg then
    query.setpiece = dlg.setpiece
  end
end
function NetSyncEvents.CheatPlaySetpiece(setpiece)
  CreateRealTimeThread(function()
    setpiece:Test()
  end)
end
AppendClass.SetpieceCamera = {
  properties = {
    {
      category = "Camera & Movement Type",
      id = "CameraMode",
      name = "Camera-object behavior",
      editor = "choice",
      default = "Default",
      help = "The object hiding behavior of the camera.",
      items = function(self)
        return {
          "Default",
          "Hide all",
          "Show all",
          "HideAboveFloor"
        }
      end
    },
    {
      category = "Camera & Movement Type",
      id = "HidesFloorsAbove",
      name = "HidesFloorsAbove",
      editor = "number",
      default = 100
    }
  }
}
local old_SetpieceCamera_ExecThread = SetpieceCamera.ExecThread
function SetpieceCamera.ExecThread(state, CamType, Easing, Movement, Interpolation, Duration, PanOnly, Lightmodel, LookAt1, Pos1, LookAt2, Pos2, FovX, Zoom, CamProps, DOFStrengthNear, DOFStrengthFar, DOFNear, DOFFar, DOFNearSpread, DOFFarSpread, CameraMode, HidesFloorsAbove)
  CameraMode = CameraMode == "Default" and state.setpiece.CameraMode or CameraMode
  apply_camera_mode(CameraMode, HidesFloorsAbove)
  old_SetpieceCamera_ExecThread(state, CamType, Easing, Movement, Interpolation, Duration, PanOnly, Lightmodel, LookAt1, Pos1, LookAt2, Pos2, FovX, Zoom, CamProps, DOFStrengthNear, DOFStrengthFar, DOFNear, DOFFar, DOFNearSpread, DOFFarSpread, CameraMode, HidesFloorsAbove)
  apply_camera_mode(state.setpiece.CameraMode)
end
DefineClass.SetpieceTODWeather = {
  __parents = {"PrgExec"},
  properties = {
    {
      id = "TimeOfDay",
      name = "Time of Day",
      editor = "combo",
      default = "Day",
      items = function(self)
        return PresetsCombo("GameStateDef", "time of day", "Any")
      end
    },
    {
      id = "Weather",
      name = "Weather",
      editor = "combo",
      default = "Default",
      items = function(self)
        return PresetsCombo("GameStateDef", "weather", "Default")
      end
    }
  },
  StatementTag = "Setpiece",
  EditorName = "TOD Weather",
  EditorView = Untranslated("Sets <u(TimeOfDay)> <u(Weather)>")
}
function SetpieceTODWeather:Exec(TOD, Weather)
  gv_ForceWeatherTodRegion = {tod = TOD, weather = Weather}
  local lightmodel = mapdata:ChooseLightmodel()
  SetLightmodel(1, lightmodel)
end
DefineClass.SetStartCombatAnim = {
  __parents = {
    "PrgSetpieceCommand"
  },
  properties = {
    {
      id = "Actors",
      name = "Actor",
      editor = "choice",
      default = "",
      items = SetpieceActorsCombo,
      variable = true,
      help = "The Actor will be used as the position to spawn the anim object."
    },
    {
      id = "AnimObj",
      name = "Animation Object",
      editor = "text",
      default = "CinematicCamera",
      help = "Object to be spawned at the position of the Actor."
    },
    {
      id = "Anim",
      name = "Animation",
      editor = "text",
      default = false,
      help = "Animation to be played from the animation obect."
    },
    {
      id = "AnimDuration",
      name = "Animation Duration",
      editor = "number",
      default = false,
      help = "Desired Anim duration in ms. If left out - anim's default duration would be used."
    },
    {
      id = "StartCombatLogic",
      name = "StartCombatLogic",
      editor = "bool",
      default = false
    }
  },
  EditorName = "Unit - Camera Anim"
}
local AnimForAwareReasonTable = {
  alerted = "camera_Standing_CombatBegin",
  alerter = "camera_Standing_CombatBegin3",
  attacked = "camera_Standing_CombatBegin4",
  surprised = "camera_Standing_CombatBegin2"
}
function SetStartCombatAnim.ExecThread(state, Actors, AnimObj, Anim, AnimDuration, StartCombatLogic)
  for _, command in ipairs(state and state.root_state.commands) do
    if command.thread ~= CurrentThread() and command.class == "SetStartCombatAnim" then
      Wakeup(command.thread)
    end
  end
  local animObj = PlaceObj(AnimObj)
  animObj:SetOpacity(0)
  state.animObj = animObj
  local unit = table.rand(Actors, InteractionRand(1000000, "StartCombat"))
  state.unit = unit
  animObj:SetPos(unit:GetVisualPos())
  animObj:SetAngle(unit:GetAngle())
  local originalAngle = animObj:GetAngle()
  local anim
  if Anim and Anim ~= "" then
    anim = Anim
  else
    local aware_reason = unit.pending_awareness_role
    local anim_variation = AnimForAwareReasonTable[aware_reason]
    if anim_variation then
      anim = anim_variation
    else
      local randomAnim = InteractionRand(4, "CinematicCamera")
      if randomAnim == 0 then
        anim = "camera_Standing_CombatBegin"
      else
        anim = "camera_Standing_CombatBegin" .. randomAnim + 1
      end
    end
  end
  local cleanAnim, angle = CheckAnimVisibility(animObj, anim, 120, unit)
  if cleanAnim then
    animObj:SetAngle(angle)
  else
    anim = "camera_Standing_CombatBegin_Fallback"
  end
  SnapCameraToObj(unit, "force", GetFloorOfPos(SnapToPassSlab(unit)), 0, "none")
  local camera = {
    GetCamera()
  }
  state.camera = camera
  animObj:SetStateText(anim, 0, 0)
  cameraMax.SetAnimObj(animObj)
  cameraMax.Activate()
  local originalAnimDuration = animObj:GetAnimDuration(anim)
  if AnimDuration then
    local animSpeedMod = MulDivRound(originalAnimDuration, 1000, AnimDuration)
    animObj:SetAnimSpeedModifier(animSpeedMod)
  end
  local sleepTime = animObj:GetAnimDuration(anim)
  if 1 < sleepTime then
    Sleep(sleepTime)
  end
  if not StartCombatLogic and not AnimDuration then
    while not state.root_state:IsCompleted("TargetDead") do
      WaitMsg(state.root_state)
    end
  end
  cameraMax.Activate(false)
  if IsValid(animObj) then
    cameraMax.SetAnimObj(false)
    DoneObject(animObj)
  end
  cameraTac.Activate(true)
  SetCamera(unpack_params(camera))
  if StartCombatLogic then
    AdjustCombatCamera("set", "instant")
    LockCameraMovement("start_combat")
  end
  SnapCameraToObj(unit, "force", GetFloorOfPos(SnapToPassSlab(unit)), 0, "none")
end
function SetStartCombatAnim.Skip(state, Actors, AnimObj, Anim, AnimDuration, StartCombatLogic, ...)
  cameraMax.Activate(false)
  if state.animObj and IsValid(state.animObj) then
    cameraMax.SetAnimObj(false)
    DoneObject(state.animObj)
  end
  cameraTac.Activate(true)
  SetCamera(unpack_params(state.camera))
  if StartCombatLogic then
    AdjustCombatCamera("set", "instant")
    LockCameraMovement("start_combat")
  end
  SnapCameraToObj(state.unit, "force", GetFloorOfPos(SnapToPassSlab(state.unit)), 0, "none")
end
DefineClass.SetpieceHideGroup = {
  __parents = {
    "PrgSetpieceCommand"
  },
  properties = {
    {
      id = "Actors",
      name = "Actor(s)",
      editor = "choice",
      default = "",
      items = SetpieceActorsCombo,
      variable = true
    },
    {
      id = "EphemeralOnly",
      name = "Ephemeral Only",
      editor = "bool",
      default = false,
      help = "Hides only units marked as ephemeral"
    },
    {
      id = "ALOnly",
      name = "Ambient Life Only",
      editor = "bool",
      default = false,
      help = "Hides only AL units(spawned by AmbientZoneMarker)"
    }
  },
  EditorName = "Hide Group"
}
function SetpieceHideGroup:GetEditorView()
  return self:GetWaitCompletionPrefix() .. self:GetCheckpointPrefix() .. string.format("Hide Actor(s) '%s' die", self.Actors)
end
function SetpieceHideGroup.ExecThread(state, Actors, EphemeralOnly, ALOnly)
  if not next(Actors) then
    return
  end
  local unit_actor_present
  for _, actor in ipairs(Actors) do
    if IsValid(actor) then
      if IsKindOf(actor, "Unit") then
        if (not EphemeralOnly or actor.ephemeral) and (not ALOnly or actor:IsAmbientUnit()) then
          actor:AddStatusEffect("SetpieceHidden")
          state.setpiece.hidden_actors = state.setpiece.hidden_actors or {}
          table.insert(state.setpiece.hidden_actors, actor)
          unit_actor_present = true
        end
      else
        actor:SetVisible(false)
        state.setpiece.hidden_actors = state.setpiece.hidden_actors or {}
        table.insert(state.setpiece.hidden_actors, actor)
      end
    end
  end
  if unit_actor_present then
    ReapplyUnitVisibility()
  end
end
function CheckAnimVisibility(obj, anim, angleOffset, unit, debug)
  local animIdx = GetStateIdx(anim)
  local animDur = GetAnimDuration(obj:GetEntity(), anim)
  local cameraIdx = obj:GetSpotBeginIndex("Camera")
  local targetParts = {}
  targetParts[1] = unit:GetSpotLocPos(unit:GetSpotBeginIndex("Head"))
  local animPhases = {}
  animPhases[1] = 0
  animPhases[2] = MulDivRound(animDur, 17, 100)
  animPhases[3] = MulDivRound(animDur, 33, 100)
  animPhases[4] = MulDivRound(animDur, 50, 100)
  animPhases[5] = MulDivRound(animDur, 67, 100)
  animPhases[6] = MulDivRound(animDur, 84, 100)
  animPhases[7] = MulDivRound(animDur, 100, 100) - 1
  local clearSight = false
  local finalAngle = false
  local originAngle = obj:GetAngle()
  local cacheFirstAngle
  for testAngle = originAngle - angleOffset * 60, originAngle + angleOffset * 60, angleOffset * 60 do
    obj:SetAngle(testAngle)
    clearSight = true
    for phase, dur in ipairs(animPhases) do
      if not clearSight then
        break
      end
      local cameraSpot = obj:GetSpotLocPos(animIdx, dur, cameraIdx)
      for _, targetSpot in ipairs(targetParts) do
        if not clearSight then
          break
        end
        if debug then
          DbgAddVector(cameraSpot, targetSpot - cameraSpot, RGB(testAngle == originAngle and 255 or 0, testAngle == originAngle - angleOffset * 60 and 255 or 0, testAngle == originAngle + angleOffset * 60 and 255 or 0))
        end
        clearSight = IsSightClear(cameraSpot, targetSpot)
      end
    end
    if clearSight and testAngle ~= originAngle - angleOffset * 60 then
      finalAngle = testAngle
      break
    elseif clearSight and testAngle == originAngle - angleOffset * 60 then
      cacheFirstAngle = testAngle
    elseif cacheFirstAngle then
      finalAngle = cacheFirstAngle
      clearSight = true
      break
    end
  end
  obj:SetAngle(originAngle)
  return clearSight, finalAngle
end
function IsSightClear(cameraPos, targetPos)
  local obstacles = {
    min_dist = max_int
  }
  CalcSrcTarObstacles(cameraPos, targetPos, obstacles, nil, true)
  return obstacles and #obstacles == 0
end
function OnMsg.SetpieceStartExecution()
  CloseMenuDialogs()
end
MapVar("g_NonBlockingSetpiecesPlaying", function()
  return {}
end)
function OnMsg.SetpieceEndExecution(setpiece)
  if not g_NonBlockingSetpiecesPlaying then
    return
  end
  local stateIdx = table.find(g_NonBlockingSetpiecesPlaying, "setpiece", setpiece)
  table.remove(g_NonBlockingSetpiecesPlaying, stateIdx)
end
function SkipNonBlockingSetpieces()
  if not g_NonBlockingSetpiecesPlaying then
    return
  end
  for i, setpiece in ipairs(g_NonBlockingSetpiecesPlaying) do
    setpiece:Skip()
  end
  g_NonBlockingSetpiecesPlaying = {}
end
PrgPlayEffect.ForbiddenEffectClasses = {
  "PlaySetpiece",
  "UnitStartConversation"
}
function PrgPlayEffect.ExecThread(state, effects)
  Sleep(0)
  local stack = {}
  for idx, effect in ipairs(effects) do
    state[effects] = idx
    effect:ExecuteWait(stack)
  end
  state[effects] = #effects + 1
end
function PrgPlayEffect.Skip(state, effects)
  local current_idx = state[effects] or 1
  for i = current_idx, #effects do
    local e = effects[i]
    if e.__waitexec ~= Effect.__waitexec then
      e:__skip()
    else
      e:__exec()
    end
  end
end
function PrgPlayEffect:GetError()
  local results
  for _, e in ipairs(self.Effects) do
    local err
    if e:IsKindOfClasses(PrgPlayEffect.ForbiddenEffectClasses) then
      err = string.format("Effects of type %s can't be played from setpieces", e.class)
    elseif e.__waitexec ~= Effect.__waitexec and not e.__skip then
      err = string.format("Effect %s has __waitexec, but has no __skip method defined, so it can't be used in a setpiece", e.class)
    end
    if err then
      results = results or {}
      results[#results + 1] = err
    end
  end
  if results then
    return table.concat(results, "\n")
  end
end
