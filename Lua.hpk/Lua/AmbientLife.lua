function _ENV:AmbientLife_Random(max)
  return InteractionRand(max, "AmbientLife")
end
MapVar("g_Visitables", {})
MapVar("g_VisitRepulsors", {})
MapVar("g_RebuildRepulsors", false)
DefineClass.AmbientLifeRepulsor = {
  __parents = {"GridMarker"},
  properties = {
    {
      category = "Marker",
      id = "Reachable",
      no_edit = true,
      default = false
    }
  },
  apply_pass = false,
  recalc_area_on_pass_rebuild = false
}
function AmbientLifeRepulsor:Init()
  table.insert(g_VisitRepulsors, self)
end
function AmbientLifeRepulsor:Done()
  table.remove_entry(g_VisitRepulsors, self)
  if self.apply_pass then
    g_RebuildRepulsors = true
  end
end
function AmbientLifeRepulsor:GetEditorTypeText()
  return Untranslated("[AL Repulsor]")
end
function IsInAmbientLifeRepulsionZone(pos)
  for _, repulsor in ipairs(g_VisitRepulsors) do
    if repulsor.apply_pass and repulsor:IsMarkerEnabled() and pos:InBox2D(repulsor:GetAreaBox()) then
      return true
    end
  end
end
function AmbientLifeRepulsor:RecalcAreaPositions()
  local prev_area_positions = self:GetAreaPositions()
  GridMarker.RecalcAreaPositions(self)
  if not table.iequal(self:GetAreaPositions(), prev_area_positions) then
    if self.apply_pass then
      g_RebuildRepulsors = true
    end
    DelayedCall(0, UpdateRepulsorsPass)
  end
end
function FilterPackedPositionsRepulsionZone(positions)
  return table.ifilter(positions, function(_, pos)
    return not IsInAmbientLifeRepulsionZone(point(point_unpack(pos)))
  end)
end
function UpdateRepulsorsPass()
  for _, marker in ipairs(g_VisitRepulsors) do
    local apply_pass = marker:GetAreaPositions() and marker:IsMarkerEnabled() or false
    if marker.apply_pass ~= apply_pass then
      marker.apply_pass = apply_pass
      g_RebuildRepulsors = true
    end
  end
  if g_RebuildRepulsors then
    g_RebuildRepulsors = false
    NetUpdateHash("UpdateRepulsorsPass:UpdatePassType")
    UpdatePassType()
  end
end
MapGameTimeRepeat("AmbientLifeRepulsor", 1000, UpdateRepulsorsPass)
DefineClass.AmbientLifeMarker = {
  __parents = {
    "EditorMarker",
    "AppearanceObject",
    "GameDynamicDataObject",
    "EditorTextObject",
    "EditorSelectedObject",
    "EditorCallbackObject"
  },
  properties = {
    {
      category = "Ambient Life",
      id = "Teleport",
      name = "Teleport",
      editor = "bool",
      default = true,
      help = "If true the unit teleports to the spot, otherwise it walks to there"
    },
    {
      category = "Ambient Life",
      id = "AllowAL",
      name = "Allow AL",
      editor = "bool",
      default = true,
      help = "If false normal AL units(from Ambient Zones) can't use this spot. However if the marker manages to steal perpetual unit this flag is ignored!"
    },
    {
      category = "Ambient Life",
      id = "VisitEnter",
      name = "Entering Visit",
      editor = "combo",
      default = "",
      items = function(obj)
        return obj:GetStatesTextTable()
      end
    },
    {
      category = "Ambient Life",
      id = "VisitIdle",
      name = "During Visit",
      editor = "dropdownlist",
      default = "idle",
      items = function(obj)
        return obj:GetStatesTextTable()
      end
    },
    {
      category = "Ambient Life",
      id = "VisitVariation",
      name = "During Visit Variation",
      editor = "bool",
      default = false
    },
    {
      category = "Ambient Life",
      id = "VisitExit",
      name = "Exiting Visit",
      editor = "combo",
      default = "",
      items = function(obj)
        return obj:GetStatesTextTable()
      end
    },
    {
      category = "Ambient Life",
      id = "VisitMinDuration",
      name = "Visit Min Duration",
      editor = "number",
      default = false,
      scale = "sec",
      help = "Spends at least that much at the marker by looping the VisitIdle animation. Can be greater if animations are longer."
    },
    {
      category = "Ambient Life",
      id = "VisitAlternateChance",
      name = "Visit Alternate Chance",
      editor = "number",
      default = 0,
      min = 0,
      max = 100,
      slider = true
    },
    {
      category = "Ambient Life",
      id = "VisitAlternate",
      name = "During Visit Alternate",
      editor = "dropdownlist",
      default = "idle",
      items = function(obj)
        return obj:GetStatesTextTable()
      end,
      no_edit = function(self)
        return self.VisitAlternateChance == 0
      end
    },
    {
      category = "Ambient Life",
      id = "VisitAlternateVariation",
      name = "During Visit Alternate Variation",
      editor = "bool",
      default = false,
      no_edit = function(self)
        return self.VisitAlternateChance == 0
      end
    },
    {
      category = "Ambient Life",
      id = "EmotionChance",
      name = "Chance for Emotion",
      editor = "number",
      default = 0,
      min = 0,
      max = 100,
      slider = true,
      no_edit = function(self)
        return self.VisitAlternateChance == 0
      end
    },
    {
      category = "Ambient Life",
      id = "EmotionAnimation",
      name = "Emotion",
      editor = "combo",
      default = "civ_Ambient_Angry",
      items = function(obj)
        return {
          "civ_Ambient_Angry",
          "civ_Ambient_Cheering",
          "civ_Ambient_SadCrying"
        }
      end,
      no_edit = function(self)
        return self.EmotionChance == 0
      end
    },
    {
      category = "Ambient Life",
      id = "EmotionVariation",
      default = false,
      name = "During Visit Alternate Variation",
      editor = "bool",
      no_edit = function(self)
        return self.EmotionChance == 0
      end
    },
    {
      category = "Ambient Life",
      id = "Conditions",
      name = "Conditions",
      editor = "nested_list",
      base_class = "Condition",
      default = false,
      help = "Conditions to check periodically"
    },
    {
      category = "Ambient Life",
      id = "GameStatesFilter",
      name = "States Required for Activation",
      editor = "set",
      three_state = true,
      default = set_neg("Conflict", "DustStorm", "FireStorm", "RainHeavy"),
      items = function()
        return GetGameStateFilter()
      end,
      help = "Map states requirements for the AL marker to be active."
    },
    {
      category = "Ambient Life",
      id = "ToolEntity",
      name = "Tool Entity",
      editor = "dropdownlist",
      items = function()
        return GetAllEntitiesComboItems()
      end,
      default = "",
      help = "Tool to be attached during the visit"
    },
    {
      category = "Ambient Life",
      id = "ToolAutoAttachMode",
      name = "Tool Auto Attach Mode",
      editor = "dropdownlist",
      items = function(obj)
        return GetEntityAutoAttachModes(nil, obj.ToolEntity) or {}
      end,
      default = false
    },
    {
      category = "Ambient Life",
      id = "ToolSpot",
      name = "Tool Spot",
      editor = "combo",
      items = {
        "Weaponr",
        "Weaponl",
        "Wristr",
        "Wristl",
        "Origin"
      },
      default = "Weaponr",
      help = "Where the tool should be attached to"
    },
    {
      category = "Ambient Life",
      id = "ToolAttachOffset",
      name = "Tool Attach Offset",
      editor = "point",
      default = false,
      help = "An offset from the specified spot to attach the tool to."
    },
    {
      category = "Ambient Life",
      id = "ToolColors",
      name = "Tool Colors",
      editor = "nested_obj",
      base_class = "ColorizationPropSet",
      inclusive = true,
      default = false
    },
    {
      category = "Ambient Life",
      id = "Weapon",
      name = "Weapon",
      editor = "preset_id",
      default = "",
      preset_class = "InventoryItemCompositeDef",
      preset_filter = function(preset, obj)
        return preset.group and preset.group:starts_with("Firearm")
      end
    },
    {
      category = "Ambient Life",
      id = "ChanceSpawn",
      name = "Chance of Spawning",
      editor = "number",
      default = 0,
      min = 0,
      max = 100,
      slider = true
    },
    {
      category = "Ambient Life",
      id = "Groups",
      name = "Groups",
      editor = "string_list",
      default = false,
      items = function()
        local items = table.keys2(Groups or empty_table, "sorted")
        table.insert(items, 1, "Closest AmbientZoneMarker")
        return items
      end
    },
    {
      category = "Ambient Life",
      id = "Ephemeral",
      name = "Ephemeral",
      editor = "bool",
      default = true,
      no_edit = function(self)
        return self.ChanceSpawn == 0
      end,
      help = "When the time to re-spawm the AL on the map perpetual units are kicked out if this flag is set and new ones are tried to be stolen. Otherwise the units are kept there"
    },
    {
      category = "Ambient Life",
      id = "AttractGender",
      name = "Attract Gender",
      editor = "dropdownlist",
      default = "Both",
      items = {
        "Both",
        "Male",
        "Female"
      }
    },
    {
      category = "Ambient Life",
      id = "IgnoreGroupsMatch",
      name = "Ignore Groups Match",
      editor = "bool",
      default = false,
      help = "If checked matching AL_ prefix group match between the unit and marker is skipped"
    },
    {
      category = "Ambient Life",
      id = "VisitSupportCollection",
      name = "Visit Support Set",
      editor = "objects",
      base_class = "Object",
      default = false,
      help = "At least ONE Object in the set must be intact for the marker to be visitable"
    },
    {
      category = "Ambient Life Editor",
      id = "IgnoreVisitSupportVME",
      name = "Ignore Visit support VME",
      editor = "bool",
      default = false,
      help = "If you are sure the support collection can't be destroyed and is properly position you can turn off the VME for this class"
    },
    {
      category = "Ambient Life Editor",
      id = "EditorMarkerVisitAnim",
      name = "Editor Marker Visit Anim",
      editor = "dropdownlist",
      default = false,
      items = function(obj)
        return obj:GetStatesTextTable()
      end
    },
    {
      category = "Ambient Life Editor",
      id = "VisitPose",
      name = "Visit Pose",
      editor = "number",
      default = 0,
      slider = true,
      min = 0,
      max = function(obj)
        return GetAnimDuration(obj:GetEntity(), obj.EditorMarkerVisitAnim or obj.VisitIdle) - 1
      end,
      help = "This is just for edit/debug purposed only for easier distinguishing which VisitIdle animation will be played at the marker"
    },
    {
      category = "Ambient Life Editor",
      id = "ViewPerpetual",
      editor = "buttons",
      default = false,
      no_edit = function(self)
        return not self.perpetual_unit
      end,
      buttons = {
        {
          name = "View Perpetual Unit",
          func = function(self)
            ViewObject(self.perpetual_unit)
          end
        },
        {
          name = "Select Perpetual Unit",
          func = function(self)
            editor.ClearSel()
            editor.AddObjToSel(self.perpetual_unit)
          end
        }
      }
    },
    {
      id = "StateCategory"
    },
    {id = "StateText"},
    {id = "animWeight"},
    {
      id = "animBlendTime"
    },
    {id = "anim2"},
    {
      id = "anim2BlendTime"
    }
  },
  editor_text_offset = point(0, 0, 250 * guic),
  editor_text_style = "AmbientLifeMarker",
  tool_attached = false,
  perpetual_unit = false,
  steal_activated = false,
  destlock = false,
  Random = AmbientLife_Random,
  VisitSupportCollectionVME = false
}
function AmbientLifeMarker:Init()
  if self.Weapon ~= "" and self.ToolEntity ~= "" then
    StoreErrorSource(self, "AmbientLifeMarker can't specify both Tool and Weapon to attach!")
  end
  local appearance = self.Appearance ~= "" and self.Appearance or "Legion_Jose"
  self:ApplyAppearance(appearance)
  self:SetAnimPose(self.EditorMarkerVisitAnim or self.VisitIdle, self.VisitPose)
end
function AmbientLifeMarker:GetGroupsText()
  if not self.Groups then
    return ""
  end
  return table.concat(self.Groups, ",")
end
function AmbientLifeMarker:GetEditorText()
  local text = T({
    Untranslated("<style GedName><class></style> <GroupsText>"),
    self
  })
  if self.Teleport then
    text = text .. Untranslated([[

	Teleport]])
  end
  if self.VisitSupportCollection then
    local count = #self.VisitSupportCollection
    if count == 1 then
      text = text .. Untranslated([[

	1 CombatObject in Visit Support Collection]])
    else
      text = text .. T({
        Untranslated([[

	<count> CombatObjects in Visit Support Collection]]),
        count = count
      })
    end
  end
  return text
end
function AmbientLifeMarker:GetVisitable()
  local visitable, idx = table.find_value(g_Visitables, 1, self)
  return visitable, idx
end
function AmbientLifeMarker:EditorCallbackPlace()
  table.insert(g_Visitables, self:GenerateVisitable())
end
function AmbientLifeMarker:EditorCallbackDelete()
  local visitable, idx = self:GetVisitable()
  table.remove(g_Visitables, idx)
  if visitable.reserved then
    local unit = HandleToObject[visitable.reserved]
    if IsValid(unit) and not unit:IsDead() then
      unit:SetCommand(false)
    end
  end
end
AmbientLifeMarker.EditorCallbackMove = AmbientLifeMarker.RebuildVisitable
AmbientLifeMarker.EditorCallbackRotate = AmbientLifeMarker.RebuildVisitable
AmbientLifeMarker.EditorCallbackScale = AmbientLifeMarker.RebuildVisitable
function AmbientLifeMarker:OnEditorSetProperty(prop_id, old_value, ged)
  if prop_id == "VisitPose" or prop_id == "VisitIdle" or prop_id == "EditorMarkerVisitAnim" then
    self:SetAnimPose(self.EditorMarkerVisitAnim or self.VisitIdle, self.VisitPose)
  elseif prop_id == "ChanceSpawn" then
    if self.ChanceSpawn == 100 then
      self:SetProperty("AllowAL", false)
    end
  elseif prop_id == "VisitAlternateChance" then
    if self.VisitAlternateChance == 0 then
      local prop_meta = self:GetPropertyMetadata("VisitAlternate")
      self:SetProperty("VisitAlternate", prop_meta.default)
    end
  elseif prop_id == "EmotionChance" then
    if self.EmotionChance == 0 then
      local prop_meta = self:GetPropertyMetadata("EmotionAnimation")
      self:SetProperty("EmotionAnimation", prop_meta.default)
    end
  else
    AppearanceObject.OnEditorSetProperty(self, prop_id)
  end
end
function AmbientLifeMarker:EditorEnter()
  EditorMarker.EditorEnter(self)
  self:SetAnimPose(self.EditorMarkerVisitAnim or self.VisitIdle, self.VisitPose)
end
function AmbientLifeMarker:EditorSelect(selected)
  if selected then
    self.anim_speed = 1000
    self:ValidateVisitSupportCollection()
    if self.VisitSupportCollection then
      editor.AddToSel(self.VisitSupportCollection, "dont_notify")
    end
  elseif IsValid(self) then
    self:SetAnimPose(self.EditorMarkerVisitAnim or self.VisitIdle, self.VisitPose)
  end
end
function AmbientLifeMarker:SpawnTool(unit, tool_orient_time)
  if not unit:HasSpot(self.ToolSpot) then
    return
  end
  local spot = unit:GetSpotBeginIndex(self.ToolSpot)
  local attach_angle = 0
  if 0 < (tool_orient_time or 0) then
    if IsValid(self.tool_attached) then
      local spot_pos, spot_angle, spot_axis = unit:GetSpotLoc(unit:GetState(), unit:GetAnimPhase(1) + tool_orient_time, spot)
      if 0 > self.tool_attached:AngleToObject(unit) then
        attach_angle = 10800
      end
      self.tool_attached:SetAxis(spot_axis, tool_orient_time)
      self.tool_attached:SetAngle(spot_angle + attach_angle, tool_orient_time)
    end
    Sleep(tool_orient_time)
  end
  if not IsValid(self.tool_attached) then
    self.tool_attached = false
    if self.ToolEntity == "" and self.Weapon == "" then
      return
    end
    if self.ToolEntity ~= "" then
      self.tool_attached = PlaceObject(self.ToolEntity)
      if self.ToolColors then
        self.tool_attached:SetColorization(self.ToolColors)
      end
      if self.ToolAutoAttachMode then
        self.tool_attached:SetAutoAttachMode(self.ToolAutoAttachMode)
      end
    else
      local weapon_item = PlaceInventoryItem(self.Weapon)
      if weapon_item then
        self.tool_attached = weapon_item:CreateVisualObj()
      end
    end
  end
  self.tool_attached:SetApplyToGrids(false)
  unit:Attach(self.tool_attached, spot)
  self.tool_attached:SetAttachAngle(attach_angle)
  if self.ToolAttachOffset then
    self.tool_attached:SetAttachOffset(self.ToolAttachOffset)
  end
end
function AmbientLifeMarker:DespawnTool()
  if not IsValid(self.tool_attached) then
    return
  end
  self.tool_attached:Detach()
  self.tool_attached:SetApplyToGrids(true)
  if self:IsKindOf("AL_Carry") then
    self.tool_attached:SetPos(self:GetPos())
    self.tool_attached:SetAxisAngle(axis_z, 0)
    self.tool_attached:SetObjectMarking(-1)
    self.tool_attached:ClearHierarchyGameFlags(const.gofObjectMarking)
  else
    DoneObject(self.tool_attached)
    self.tool_attached = false
  end
end
function AmbientLifeMarker:GenerateVisitable()
  return {self}
end
function AmbientLifeMarker:MatchConditionsAndGameStates()
  return EvalConditionList(self.Conditions) and MatchGameState(self.GameStatesFilter)
end
function AmbientLifeMarker:CanVisit(unit, for_perpetual, dont_check_dist)
  if not self:IsVisitSupportCollectionAlive() then
    return false
  end
  if self.AttractGender ~= "Both" and unit.gender ~= self.AttractGender then
    return false
  end
  local x, y, z = self:GetPosXYZ()
  if IsOccupiedExploration(unit, x, y, z) and not g_Combat then
    for i, u in ipairs(g_Units or empty_table) do
      if u ~= unit then
        local uX, uY, uZ = u:GetPosXYZ()
        if x == uX and y == uY and z == uZ then
          return false
        end
      end
    end
  end
  for_perpetual = for_perpetual or self.perpetual_unit == unit
  if for_perpetual or self.AllowAL or not self.AllowAL and not unit:IsAmbientUnit() then
    if not self:MatchConditionsAndGameStates() then
      return false
    end
    local check_ignore_dist = not dont_check_dist and (not unit.zone or unit.zone.MinRoamDist >= 0)
    if not for_perpetual and check_ignore_dist and self:GetDist2D(unit) < const.AmbientLife.VisitIgnoreRange then
      return false
    end
    if not unit.visit_test and not self.IgnoreGroupsMatch and not unit:GroupsMatch(self) then
      return false
    end
    return IsValidAnim(unit, self.VisitIdle) and 0 < unit:GetAnimDuration(self.VisitIdle)
  end
end
function AmbientLifeMarker:GotoEnterSpot(unit, dest)
  local distance = 0
  if self:IsKindOf("AL_Carry") then
    local phase = unit:GetAnimMoment(self.VisitEnter, "hit")
    if 0 < (phase or 0) then
      distance = unit:GetVisualDist2D(unit:GetSpotLocPosXYZ(self.VisitEnter, phase, unit:GetSpotBeginIndex(self.ToolSpot)))
    end
  end
  if unit.teleport_allowed_once then
    unit.teleport_allowed_once = false
    unit:SetPos(RotateRadius(distance, self:GetAngle(), dest))
    unit:SetAngle(self:GetAngle())
    self:SpawnTool(unit)
  else
    local remove_pfflags = unit:GetPathFlags(const.pfmVoxelAligned | const.pfmDestlock | const.pfmDestlockSmart)
    unit:ChangePathFlags(0, remove_pfflags)
    unit:PushDestructor(function(self)
      if IsValid(self) then
        self:ChangePathFlags(remove_pfflags)
      end
    end)
    local finished
    if distance == 0 then
      finished = unit:GotoSlab(dest)
    else
      finished = unit:GotoSlab(dest, distance)
    end
    unit:PopAndCallDestructor()
    if not finished then
      return
    end
  end
  return unit.visit_test or self:MatchConditionsAndGameStates()
end
function AmbientLifeMarker:ApplyVisitEnterStepVectorAngle(unit, dest, lookat, angle)
  if (self.VisitEnter or "") == "" then
    return
  end
  angle = angle or lookat and CalcOrientation(unit, lookat) or self:GetAngle()
  unit:SetPos(dest + unit:GetStepVector(self.VisitEnter, angle))
  unit:SetAngle(angle + unit:GetStepAngle(self.VisitEnter))
end
function AmbientLifeMarker:Enter(unit, dest, lookat)
  local angle = lookat and CalcOrientation(unit, lookat) or self:GetAngle()
  if (self.VisitEnter or "") == "" then
    unit:SetPos(dest)
    if not IsKindOf(self, "AL_Roam") or not self.DontReorient then
      local adiff = AngleDiff(unit:GetVisualAngle(), angle)
      if abs(adiff) > 300 then
        unit:AnimatedRotation(angle)
      end
    end
    return
  end
  if unit.perpetual_marker and unit.teleport_allowed_once then
    unit.teleport_allowed_once = false
    self:ApplyVisitEnterStepVectorAngle(unit, dest, lookat, angle)
    return
  end
  self.destlock = PlaceObject("Destlock")
  self.destlock:SetPos(self:IsKindOf("AL_Carry") and self.CarryDestination or dest)
  pf.SetDestlockRadius(self.destlock, unit:GetDestlockRadius())
  unit:SetState(self.VisitEnter)
  PlayFX(string.format("Anim:%s", self:GetStateText()), "start", unit)
  if self:IsKindOf("AL_Carry") then
    local time = unit:TimeToMoment(1, "hit") or 0
    unit:SetAngle(angle, Min(200, time))
    local tool_orient_time = Min(200, time)
    Sleep(time - tool_orient_time)
    self:SpawnTool(unit, tool_orient_time)
    Sleep(unit:TimeToAnimEnd())
    return
  end
  self:SpawnTool(unit)
  unit:AnimatedRotation(angle)
  unit:SetState(self.VisitEnter)
  unit:SetTargetDummyFromPos()
  local step_angle = unit:GetStepAngle()
  local duration = unit:TimeToAnimEnd()
  unit:SetPos(dest + unit:GetStepVector(self.VisitEnter, angle), duration)
  local steps = 2
  for i = 1, steps do
    local t = duration * i / steps - duration * (i - 1) / steps
    local a = angle + step_angle * i / steps
    unit:SetAngle(a, t)
    Sleep(t)
  end
end
function AmbientLifeMarker:OnVisitAnimEnded(unit)
end
function AmbientLifeMarker:StartVisit(unit, visit_duration)
  local randomize_phase = unit.perpetual_marker and "randomize phase"
  repeat
    local start_time = GameTime()
    self:SetVisitAnimation(unit, randomize_phase)
    randomize_phase = false
    self:SpawnTool(unit)
    Sleep(unit:TimeToAnimEnd())
    self:OnVisitAnimEnded(unit)
    visit_duration = visit_duration + GameTime() - start_time
    local visit_finished = not self.VisitMinDuration or visit_duration >= self.VisitMinDuration
  until not self.perpetual_unit and visit_finished or not self:CanVisit(unit, nil, "don't check dist")
end
function AmbientLifeMarker:ExitVisit(unit)
  if IsValid(unit) then
    unit:SetCommandParamValue(unit.command, "move_style", nil)
    if (self.VisitExit or "") ~= "" and IsValidAnim(unit, self.VisitExit) then
      unit:SetState(self.VisitExit)
      local combat_anim_speed = 2000
      if unit.command == "EnterCombat" then
        unit:SetAnimSpeed(1, combat_anim_speed)
      end
      local time = unit:TimeToAnimEnd(1)
      unit:SetPos(unit:GetPos() + unit:GetStepVector(), time)
      unit:SetAngle(unit:GetAngle() + unit:GetStepAngle(), time)
      local wait_time = IsMerc(unit) and (unit:TimeToMoment(1, "end") or Max(0, time - 300)) or time
      if unit.command == "EnterCombat" then
        Sleep(wait_time)
      elseif (WaitMsg("CombatStarting", wait_time) or unit.command == "EnterCombat") and IsValid(unit) then
        unit:SetAnimSpeed(1, combat_anim_speed)
        time = unit:TimeToAnimEnd(1)
        wait_time = IsMerc(unit) and (unit:TimeToMoment(1, "end") or Max(0, time - 300)) or time
        unit:SetPos(unit:GetPos(), time)
        unit:SetAngle(unit:GetAngle(), time)
        Sleep(wait_time)
      end
      if self.tool_attached then
        self:DespawnTool()
      end
      if time > wait_time then
        Sleep(unit:TimeToAnimEnd())
      end
    end
  end
  if self.tool_attached then
    self:DespawnTool()
  end
  if self.destlock then
    if IsValid(unit) and (GameState.Combat or GameState.Conflict) and not self:IsKindOf("AL_Carry") then
      unit:SetPos(self.destlock:GetPos())
    end
    DoneObject(self.destlock)
    self.destlock = false
  end
end
function AmbientLifeMarker:Visit(unit, dest, lookat, already_in_perpetual)
  dest = dest or self:GetPos()
  unit.visit_reached = false
  unit:ReserveVisitable(self:GetVisitable())
  local start_time = GameTime()
  unit:PushDestructor(function()
    self.perpetual_unit = false
    unit:FreeVisitable()
  end)
  unit:SetCommandParamValue("Visit", "move_style", nil)
  if not already_in_perpetual and not self:GotoEnterSpot(unit, dest) then
    if start_time == GameTime() then
      unit:IdleRoutine_StandStill(3000)
    end
    unit:PopAndCallDestructor()
    return
  end
  if not self:CanVisit(unit, nil, "don't check dist") then
    unit:PopAndCallDestructor()
    return
  end
  unit:PopDestructor()
  local is_carry_marker = self:IsKindOf("AL_Carry")
  unit:PushDestructor(function()
    unit:SetTargetDummy(false)
    self.perpetual_unit = false
    PlayFX(string.format("Anim:%s", self:GetStateText()), "end", unit)
    if IsValid(unit) and not unit:IsDead() then
      self:ExitVisit(unit)
    end
    unit:FreeVisitable()
    if is_carry_marker then
      unit:SetCommandParamValue("Visit", "move_style", nil)
    end
  end)
  start_time = GameTime()
  unit.visit_reached = not is_carry_marker
  if already_in_perpetual then
    self:ApplyVisitEnterStepVectorAngle(unit, dest, lookat, not IsKindOf(self, "AL_SitChair") and self:GetAngle() or nil)
  else
    self:Enter(unit, dest, lookat)
  end
  if not self:CanVisit(unit, nil, "don't check dist") then
    unit:PopAndCallDestructor()
    return
  end
  if is_carry_marker then
    local move_style = GetAnimationStyle(unit, self.MoveStyle) or GetAnimationStyle(unit, "Walk_Carry")
    if move_style then
      unit:SetCommandParamValue(unit.command, "move_style", move_style.Name)
    end
  elseif not already_in_perpetual then
    self:StartVisit(unit, GameTime() - start_time)
  end
  if unit.perpetual_marker then
    if is_carry_marker then
      unit:GotoSlab(self.CarryDestination)
      unit.perpetual_marker = false
      self.perpetual_unit = false
    else
      while unit.perpetual_marker == self and self:CanVisit(unit) do
        self:SetVisitAnimation(unit)
        Sleep(unit:TimeToAnimEnd())
        self:OnVisitAnimEnded(unit)
      end
    end
  elseif is_carry_marker then
    unit:GotoSlab(self.CarryDestination)
  end
  if start_time == GameTime() then
    unit:IdleRoutine_StandStill(3000)
  end
  unit:PopAndCallDestructor()
end
function AmbientLifeMarker:IsLucky(chance)
  return 0 < chance and chance > self:Random(100)
end
function AmbientLifeMarker:GetBaseAnimVariation()
  local original = not self:IsLucky(self.VisitAlternateChance)
  local emotion = not original and self:IsLucky(self.EmotionChance)
  local base_anim = original and self.VisitIdle or emotion and self.EmotionAnimation or self.VisitAlternate
  local variation = original and self.VisitVariation or emotion and self.EmotionVariation or self.VisitAlternateVariation
  return base_anim, variation
end
function AmbientLifeMarker:SetVisitAnimation(unit, randomize_phase)
  local base_anim, variation = self:GetBaseAnimVariation()
  local anim, phase
  if variation then
    anim, phase = unit:GetNearbyUniqueRandomAnim(base_anim)
    if not randomize_phase then
      phase = 0
    end
  else
    anim, phase = base_anim, 0
  end
  local same_anim = unit:GetStateText() == anim
  local crossfade = IsKindOf(self, "AL_Roam") and -1 or 0
  unit:SetState(anim, 0, crossfade)
  if same_anim and 0 < unit:GetAnimMomentsCount(anim, "start") then
    unit:OnAnimMoment("start", anim)
  end
  if 0 < phase then
    unit:SetAnimPhase(1, phase)
  end
  unit:SetTargetDummyFromPos()
end
function AmbientLifeMarker:CanSpawn()
  return self:IsPerpetual() and self:MatchConditionsAndGameStates()
end
function AmbientLifeMarker:GetClosestClassFromGroup(classes, group)
  local objects = Groups[group]
  local closest, closest_dist
  for _, obj in ipairs(objects) do
    if IsKindOfClasses(obj, classes) then
      local is_zone = IsKindOf(obj, "AmbientZoneMarker")
      if not (not (not is_zone and not obj.perpetual_marker and not obj:IsDead() and not obj:IsDefeatedVillain() and self:CanVisit(obj, "for perpetual")) or IsSetpieceActor(obj)) or is_zone and obj:CanSpawn() then
        if not closest then
          closest, closest_dist = obj, obj:GetDist(self)
        else
          local dist = obj:GetDist(self)
          if closest_dist > dist then
            closest, closest_dist = obj, dist
          end
        end
      end
    end
  end
  return closest
end
local filter_can_spawn_zone = function(zone)
  return zone:CanSpawn()
end
function AmbientLifeMarker:GetSpawnedUnit()
  local group
  for _, grp in ipairs(self.Groups) do
    if not grp:starts_with("AL_") then
      group = grp
      break
    end
  end
  local zone
  if group == "Closest AmbientZoneMarker" then
    local pos = self:GetPos()
    local x, y = terrain.GetMapSize()
    local radius = y < x and x or y
    zone = MapFindNearest(pos, pos, radius, "AmbientZoneMarker", filter_can_spawn_zone)
    if not zone then
      StoreErrorSource(self, "Can't find AmbientZoneMarker around which can spawn to steal from")
    end
  else
    local obj = self:GetClosestClassFromGroup({
      "Unit",
      "AmbientZoneMarker"
    }, group or self.Groups[1])
    if IsKindOf(obj, "Unit") then
      return obj
    end
    zone = obj
  end
  return zone and zone:GetUnitForMarker(self)
end
function AmbientLifeMarker:StealSpawnedUnit()
  if self.perpetual_unit then
    return
  end
  self.steal_activated = true
  self.perpetual_unit = self:GetSpawnedUnit() or false
  if not self.perpetual_unit then
    return
  end
  self.perpetual_unit.teleport_allowed_once = self.Teleport
  self.perpetual_unit.perpetual_marker = self
  local visitable = self:GetVisitable()
  local old_visitable = self.perpetual_unit:GetVisitable()
  if old_visitable == visitable then
    return
  end
  if old_visitable then
    self.perpetual_unit:FreeVisitable(old_visitable)
  end
  if visitable.reserved then
    local unit = HandleToObject[visitable.reserved]
    if unit then
      unit:FreeVisitable(visitable)
      unit:SetBehavior()
      unit:SetCommand(false)
    end
  end
  self.perpetual_unit:ReserveVisitable(visitable)
  if g_Combat then
    self.perpetual_unit:SetBehavior("Visit", visitable)
  else
    self.perpetual_unit:SetCommand("Visit", visitable)
  end
end
function AmbientLifeMarker:Spawn()
  if self.Ephemeral and self.perpetual_unit then
    self.perpetual_unit:SetBehavior()
    self.perpetual_unit:SetCommand(false)
    self.perpetual_unit = false
  end
  self:StealSpawnedUnit()
end
function AmbientLifeMarker:Despawn()
  if self.perpetual_unit then
    if IsValid(self.perpetual_unit) and not IsBeingDestructed(self.perpetual_unit) then
      self.perpetual_unit:FreeVisitable()
      self.perpetual_unit:SetBehavior()
      self.perpetual_unit:SetCommand("Idle")
    end
    self.perpetual_unit.perpetual_marker = false
    self.perpetual_unit = false
  end
end
function AmbientLifeMarker:GetDynamicData(data)
  data.perpetual_unit = self.perpetual_unit and self.perpetual_unit.handle or nil
  data.steal_activated = self.steal_activated or nil
  data.tool_attached = self.tool_attached and true or nil
end
function AmbientLifeMarker:SetDynamicData(data)
  self.perpetual_unit = data.perpetual_unit and HandleToObject[data.perpetual_unit] or false
  self.steal_activated = data.steal_activated or false
  self.tool_attached = data.tool_attached or false
end
function AmbientLifeMarker:IsPerpetual()
  return self.Groups and self.ChanceSpawn > 0
end
function AmbientLifeMarker:IsToolDestroyed()
  if self.ToolEntity == "" then
    return
  end
  local tool = self.tool_attached
  return IsValid(tool) and IsKindOf(tool, "CombatObject") and tool:IsDead()
end
function AmbientLifeMarker:EditorGetText()
  local sup_col_dead
  if not self:IsVisitSupportCollectionAlive("all") then
    sup_col_dead = string.format("All associated combat object(s) are destroyed!")
  end
  if not self:IsVisitSupportCollectionAlive() then
    sup_col_dead = string.format("Some associated combat object(s) are destroyed!")
  end
  local cond_text
  local context = {}
  for i, condition in ipairs(self.Conditions) do
    if not condition:Evaluate(self, context) then
      cond_text = string.format("%s: false", TDevModeGetEnglishText(condition:GetEditorView()))
    end
  end
  local avoid_text = IsInAmbientLifeRepulsionZone(self:GetPos()) and "In Repulsion Zone"
  if sup_col_dead or cond_text or avoid_text then
    local pre_conditions = {}
    if sup_col_dead then
      table.insert(pre_conditions, sup_col_dead)
    end
    if cond_text then
      table.insert(pre_conditions, cond_text)
    end
    if avoid_text then
      table.insert(pre_conditions, avoid_text)
    end
    return table.concat(pre_conditions, "\n")
  end
  local perpetual = self:IsPerpetual() and string.format("(Perpetual: %d%%)", self.ChanceSpawn) or ""
  local text = string.format("AL %s Visit%s", self.AllowAL and "CAN" or "CAN'T", perpetual)
  local game_states = MatchGameState(self.GameStatesFilter)
  local conditions = EvalConditionList(self.Conditions)
  if not game_states or not conditions then
    if not game_states then
      local mismatch_states = {
        "Mismatch States:"
      }
      for state, active in pairs(self.GameStatesFilter) do
        local game_state_active = not not GameState[state]
        if active ~= game_state_active then
          table.insert(mismatch_states, state)
        end
      end
      text = string.format([[
%s
%s]], text, table.concat(mismatch_states, " "))
    end
    if not conditions then
      local mismatch_conditions = {
        "Mismatch Conditions:"
      }
      for _, condition in ipairs(self.Conditions) do
        local ok, result = procall(condition.__eval, condition)
        if not ok then
          table.insert(mismatch_conditions, condition:GetEditorView())
        end
        if condition.Negate then
          result = not result
        end
        if not result then
          table.insert(mismatch_conditions, "NOT " .. condition:GetEditorView())
        end
      end
      text = string.format([[
%s
%s]], text, table.concat(mismatch_conditions, " "))
    end
  elseif self:IsPerpetual() then
    local action_text = self.perpetual_unit and "Stolen from:" or "No Free Units to Steal From:"
    local unit = self:GetSpawnedUnit()
    text = string.format([[
%s
%s %s[%s](for %s anim)]], text, action_text, self.Groups[1], unit and unit.class or "???", self.VisitIdle)
  end
  return text
end
function AmbientLifeMarker:EditorGetTextColor()
  local pos = self:GetPos()
  local pre_conditions_ok = self:IsVisitSupportCollectionAlive() and not IsInAmbientLifeRepulsionZone(pos)
  if pre_conditions_ok then
    local context = {}
    for i, condition in ipairs(self.Conditions) do
      if not condition:Evaluate(self, context) then
        pre_conditions_ok = false
        break
      end
    end
  end
  local perpetual_ok = self:IsPerpetual() == not not self.perpetual_unit
  local match = self:MatchConditionsAndGameStates()
  return pre_conditions_ok and self.AllowAL and match and perpetual_ok and const.clrGreen or const.clrRed
end
function AmbientLifeMarker:GetRootColIndex()
  local root_collection = self:GetRootCollection()
  return root_collection and root_collection.Index or 0
end
function AmbientLifeMarker:GetCollectionLeader()
  local col_idx = self:GetRootColIndex()
  if col_idx == 0 then
    return self
  end
  local leader = self
  MapForEach("map", "collection", col_idx, true, "AmbientLifeMarker", function(marker)
    leader = marker.handle < leader.handle and marker or leader
  end)
  return leader
end
function AmbientLifeMarker:IsCollectionLeader()
  return self:GetCollectionLeader() == self
end
function AmbientLifeMarker:SpawnCollection()
  if self:Random(100) >= self.ChanceSpawn then
    return
  end
  self:Spawn()
  local col_idx = self:GetRootColIndex()
  if col_idx == 0 then
    return
  end
  local markers = MapGet("map", "collection", col_idx, true, "AmbientLifeMarker", function(marker)
    return marker ~= self
  end)
  for _, marker in ipairs(markers) do
    marker.steal_activated = self.steal_activated
    if marker.ChanceSpawn ~= self.ChanceSpawn then
      StoreErrorSource(self, "AL markers in collection should have the same ChanceSpawn!")
    end
  end
  if not self.perpetual_unit then
    return
  end
  for _, marker in ipairs(markers) do
    marker:Spawn()
  end
end
function AmbientLifeMarker:CreateVisitSupportCollection()
  self.VisitSupportCollection = {}
  for _, obj in ipairs(editor.GetSel() or empty_table) do
    if IsKindOf(obj, "Object") and IsValid(obj) and not IsKindOf(obj, "AmbientLifeMarker") then
      table.insert(self.VisitSupportCollection, obj)
    end
  end
end
function AmbientLifeMarker:RemoveVisitSupportCollection()
  if self.VisitSupportCollection then
    editor.RemoveFromSel(self.VisitSupportCollection)
    self.VisitSupportCollection = false
  end
end
function AmbientLifeMarker:ValidateVisitSupportCollection()
  if not self.VisitSupportCollection then
    return
  end
  for i = #self.VisitSupportCollection, 1, -1 do
    local obj = self.VisitSupportCollection[i]
    if not IsValid(obj) or IsKindOf(obj, "AmbientLifeMarker") then
      table.remove(self.VisitSupportCollection, i)
    end
  end
  if #self.VisitSupportCollection == 0 then
    self.VisitSupportCollection = false
  end
end
function AmbientLifeMarker:IsVisitSupportCollectionAlive(bAll)
  self:ValidateVisitSupportCollection()
  if not self.VisitSupportCollection then
    return true
  end
  for _, obj in ipairs(self.VisitSupportCollection) do
    local is_dead = IsKindOf(obj, "CombatObject") and obj:IsDead()
    if bAll and not is_dead then
      return true
    end
    if not bAll and is_dead then
      return false
    end
  end
  return not bAll
end
function AmbientLifeMarker:IsInVisitSupportCollection(obj)
  if self.VisitSupportCollection then
    return not not table.find(self.VisitSupportCollection, obj)
  end
end
function AmbientLifeMarker:VME_CheckImpassable(pt)
  pt = pt or self:GetPos()
  if not self:IsPerpetual() and not GetPassSlab(pt) and not self.Teleport then
    StoreErrorSource(self, "AmbientLifeMarker Goto position is on impassable!")
  end
end
function AmbientLifeMarker:VME_CheckWalkableZ(pt)
  pt = pt or self:GetPos()
  local z = pt:z()
  if z and not self:IsPerpetual() and not self.Teleport and z < GetWalkableZ(pt) then
    StoreErrorSource(self, "AmbientLifeMarker Goto position is below walkable Z!")
  end
end
function AmbientLifeMarker:VME_CheckProperties()
  if self.ChanceSpawn > 0 and (not (self.Groups and next(self.Groups) and self.Groups[1]) or self.Groups[1] == "") then
    StoreErrorSource(self, "AmbientLifeMarker is perpetual but property 'Groups' to steal from is not specified!")
  end
  local entity_name = self:GetProperty("ToolEntity")
  local entity = g_Classes[entity_name]
  if entity and not IsKindOf(entity, "ComponentCustomData") then
    StoreWarningSource(self, string.format("AmbientLifeMarker has an attachable entity %s which does not inherit ComponentCustomData. Add ComponentCustomData as its parent class in the ArtSpecEditor.", entity_name))
  end
end
function AmbientLifeMarker:VME_Checks(pt)
  self:VME_CheckImpassable(pt)
  self:VME_CheckWalkableZ(pt)
  self:VME_CheckProperties()
  if self.VisitSupportCollectionVME and not self.IgnoreVisitSupportVME and #(self.VisitSupportCollection or empty_table) == 0 then
    StoreErrorSource(self, "This marker needs non-empty Visit Support Set!")
  end
end
function AmbientLifeMarker:GetError()
  if self:IsPerpetual() then
    self:GetSpawnedUnit()
  end
  local collection_error
  local col_idx = self:GetRootColIndex()
  if col_idx ~= 0 then
    MapForEach("map", "collection", col_idx, true, "AmbientLifeMarker", function(other)
      if self.ChanceSpawn ~= other.ChanceSpawn then
        collection_error = "AL markers in the same collection should have the same ChanceSpawn!"
        return "break"
      end
    end)
  end
  if collection_error then
    return collection_error
  end
end
OnMsg.ValidateMap = ValidateGameObjectProperties("AmbientLifeMarker")
local GetClosestVisitable = function(pos, ignore_reserved)
  local closest_visitable, closest_dist
  for _, visitable in ipairs(g_Visitables) do
    if ignore_reserved or not visitable.reserved then
      local dist = visitable[1]:GetDist(pos)
      if not closest_visitable or closest_dist > dist then
        closest_visitable, closest_dist = visitable, dist
      end
    end
  end
  if not closest_visitable then
    StoreErrorSource(pos, "DbgTestClosestALMarker: No visitable around! Try RebuildVisitables() from the console.")
  end
  return closest_visitable
end
function AmbientLifeMarker:DbgTest(unit_pos, closest_visitable)
  closest_visitable = closest_visitable or GetClosestVisitable(self:GetPos(), "ignore reserved")
  if not unit_pos then
    local radius = 10 * guim
    for try = 1, 100 do
      local dist = radius / 2 + self:Random(radius / 2)
      unit_pos = GetPassSlab(self:GetPos() + Rotate(point(dist, 0), self:Random(21600)))
      if unit_pos then
        break
      end
    end
    if not unit_pos then
      local cx, cy = self:GetPos():xy()
      for y = cy - radius, cy + radius, const.SlabSizeY do
        for x = cx - radius, cx + radius, const.SlabSizeX do
          unit_pos = GetPassSlab(point(x, y))
          if unit_pos then
            break
          end
        end
        if unit_pos then
          break
        end
      end
    end
    if not unit_pos then
      StoreErrorSource(self, "Can't find passable point around to test!")
      return
    end
  end
  NetSyncEvents.CheatEnable("FullVisibility", true)
  local unit_defs = Presets.UnitDataCompositeDef.Civilians
  if self.AttractGender ~= "Both" then
    unit_defs = table.ifilter(unit_defs, function(_, unit_def)
      return unit_def.gender == self.AttractGender
    end)
  end
  local unit_def = table.rand(unit_defs)
  local session_id = GenerateUniqueUnitDataId("AmbientLifeMarker:DbgTest", gv_CurrentSectorId or "A1", unit_def.id)
  local unit = SpawnUnit(unit_def.id, session_id, unit_pos)
  unit.visit_test = true
  CheckUniqueSessionId(unit)
  unit:SetSide("neutral")
  local visitor = HandleToObject[closest_visitable.reserved]
  if visitor then
    visitor:SetCommand(false)
  end
  closest_visitable.reserved = unit.handle
  unit:SetCommand("Visit", closest_visitable)
end
function OnMsg.ValidateMap()
  MapForEach("map", "AmbientLifeMarker", function(marker)
    marker:ValidateVisitSupportCollection()
    marker:VME_Checks()
  end)
  MapForEach("map", "AmbientZoneMarker", function(zone)
    zone:VME_Checks()
  end)
  RebuildVisitables()
  for _, visitable in ipairs(g_Visitables) do
    local marker = visitable[1]
    marker:VME_Checks(visitable[2])
  end
end
DefineClass.ChairSittable = {
  __parents = {"Object"}
}
function RebuildVisitables(bbox)
  if not bbox then
    local sizex, sizey = terrain.GetMapSize()
    bbox = box(0, 0, 0, sizex, sizey, 100000)
  end
  local used = {}
  for _, visitable in ipairs(g_Visitables) do
    local marker = visitable[1]
    used[marker.handle] = true
  end
  MapForEach(bbox, "AmbientLifeMarker", function(marker)
    local visitable = marker:GenerateVisitable()
    local marker = visitable[1]
    if not used[marker.handle] then
      table.insert(g_Visitables, visitable)
      used[marker.handle] = true
    end
  end)
end
function GetRandomVisitableForMarker(unit, marker, filter, ...)
  if not (IsValid(marker) and g_Visitables) or #g_Visitables == 0 then
    return
  end
  local area = marker:GetAreaBox()
  local selected_visitable
  local total = 0
  for _, visitable in random_ipairs(g_Visitables, "AmbientLife") do
    local visit_marker = visitable[1]
    if not visitable.reserved and visit_marker:CanVisit(unit) then
      local pt = visitable[2] or visit_marker:GetPos()
      if not unit.zone or unit.zone:CheckZTolerance(pt) then
        visit_marker:VME_CheckImpassable(pt)
        if pt:InBox2D(area) and not IsInAmbientLifeRepulsionZone(pt) and (not filter or filter(visitable, ...)) then
          total = total + 1
          if not selected_visitable then
            local has_path, closest_pos = pf.HasPosPath(unit, pt, nil, 0, 0, unit, 0, nil, const.pfmDestlock)
            if has_path and closest_pos == pt then
              selected_visitable = visitable
            end
          end
        end
      end
    end
  end
  return selected_visitable, total
end
function OnMsg.PostNewMapLoaded()
  if not Platform.developer then
    RebuildVisitables()
  end
end
local RebuildVisitablesResetUnitVisits = function(obj, bbox)
  RebuildVisitables(bbox)
  for _, unit in ipairs(g_Units) do
    if unit.behavior == "Visit" then
      local visitable = unit.behavior_params[1]
      local marker = visitable[1]
      if marker:IsInVisitSupportCollection(obj) and not marker:IsVisitSupportCollectionAlive() then
        unit:ResetAmbientLife()
      end
    end
  end
end
OnMsg.CombatObjectDied = RebuildVisitablesResetUnitVisits
DefineClass.AmbientSpawnDef = {
  __parents = {
    "PropertyObject"
  },
  properties = {
    {
      id = "UnitDef",
      name = "Unit Definition",
      editor = "preset_id",
      default = false,
      preset_class = "UnitDataCompositeDef"
    },
    {
      id = "Appearance",
      name = "Appearance",
      help = "Force the spawned unit to use this appearance instead of randomly choosing from its own list of appearances",
      editor = "preset_id",
      default = false,
      preset_class = "AppearancePreset"
    },
    {
      id = "Name",
      name = "Name",
      help = "Name for the spawned unit that will replace the one from template.",
      editor = "text",
      default = false,
      translate = true,
      lines = 1,
      max_lines = 1
    },
    {
      id = "Ephemeral",
      name = "Ephemeral",
      editor = "bool",
      default = true,
      help = "Permanent or Ephemeral"
    },
    {
      id = "CountMin",
      name = "Count Min",
      editor = "number",
      default = 5
    },
    {
      id = "CountMax",
      name = "Count Max",
      editor = "number",
      default = 20
    }
  },
  EditorView = Untranslated("<UnitDef> : <CountMin>-<CountMax>")
}
function AmbientSpawnDef:GenSessionId()
  return GenerateUniqueUnitDataId("AmbientSpawnDef", gv_CurrentSectorId or "A1", self.UnitDef)
end
DefineClass.AmbientZoneMarker = {
  __parents = {
    "GridMarker",
    "GameDynamicDataObject",
    "EditorTextObject",
    "EditorMarker"
  },
  properties = {
    {
      category = "Ambient Zone",
      id = "ConflictIgnore",
      name = "Conflict Ignore",
      editor = "bool",
      default = false,
      help = "Set this so units during conflict won't run, get reduced and won't repopulate the map when over"
    },
    {
      category = "Ambient Zone",
      id = "AreaWidth",
      name = "Area Width",
      editor = "number",
      default = 20,
      help = "Defining a voxel-aligned rectangle with North-South and East-West axis"
    },
    {
      category = "Ambient Zone",
      id = "AreaHeight",
      name = "Area Height",
      editor = "number",
      default = 20,
      help = "Defining a voxel-aligned rectangle with North-South and East-West axis"
    },
    {
      category = "Ambient Zone",
      id = "AreaLevelZ",
      name = "Area Level Z",
      editor = "number",
      default = 0,
      help = "+/- that Z level of floors"
    },
    {
      category = "Ambient Zone",
      id = "MinRoamDist",
      name = "Minimum Roaming Distance",
      editor = "number",
      default = 4 * const.SlabSizeX,
      scale = const.SlabSizeX,
      help = "Does not pick roaming markers closer than this. If negative const.AmbientLife.VisitIgnoreRange will not be checked!"
    },
    {
      category = "Ambient Zone",
      id = "SpawnDefs",
      name = "Spawn Definitions",
      editor = "nested_list",
      base_class = "AmbientSpawnDef",
      default = false
    },
    {
      category = "Ambient Zone",
      id = "SpecificBanters",
      name = "SpecificBanters",
      help = "SpecificBanters to play when interacted with.",
      editor = "preset_id_list",
      default = {},
      preset_class = "BanterDef",
      item_default = ""
    },
    {
      category = "Ambient Zone",
      id = "BanterGroups",
      name = "BanterGroups",
      help = "Banters to play when interacted with.",
      editor = "string_list",
      default = false,
      items = PresetGroupsCombo("BanterDef")
    },
    {
      category = "Ambient Zone",
      id = "ApproachBanters",
      name = "Approach Banters",
      help = "Approach Banters to play when interacted with.",
      editor = "dropdownlist",
      default = false,
      items = PresetGroupsCombo("BanterDef")
    },
    {
      category = "Ambient Zone",
      id = "EnabledConditions",
      name = "Enabled Conditions",
      default = false,
      editor = "nested_list",
      base_class = "Condition",
      help = "Conditions that enable or disable the marker"
    },
    {
      category = "Grid Marker",
      id = "Type",
      name = "Type",
      editor = "string",
      default = "AmbientZone",
      read_only = true
    }
  },
  editor_text_offset = point(0, 0, 250 * guic),
  editor_text_style = "AmbientLifeMarker",
  units = false,
  persist_units = true,
  Random = AmbientLife_Random
}
function AmbientZoneMarker:GetDynamicData(data)
  if not self.persist_units or not self.units then
    return
  end
  data.units = {}
  for idx, units in ipairs(self.units) do
    local data_units = {}
    for k, unit in ipairs(units) do
      data_units[k] = unit.handle
    end
    data.units[idx] = data_units
  end
end
function AmbientZoneMarker:SetDynamicData(data)
  if not self.persist_units or not data.units then
    return
  end
  self.units = {}
  for idx, units in ipairs(data.units) do
    local real_units = {}
    for _, unit_handle in ipairs(units) do
      if unit_handle then
        local unit = HandleToObject[unit_handle]
        if unit and IsKindOfClasses(unit, "Unit") then
          table.insert(real_units, unit)
        end
      end
    end
    self.units[idx] = real_units
  end
end
function AmbientZoneMarker:GetAreaPositions(ignore_occupied)
  return self:GetAreaPositionsOutsideRepulsors(ignore_occupied)
end
function AmbientZoneMarker:CanSpawn()
  return self:IsMarkerEnabled()
end
function AmbientZoneMarker:GetSpawnDefinitions()
  local spawn_defs = {}
  for idx, def in ipairs(self.SpawnDefs) do
    local count = def.CountMin + self:Random(def.CountMax - def.CountMin + 1)
    if GameState.Conflict or GameState.ConflictScripted then
      count = MulDivTrunc(count, const.AmbientLife.ConflictReduction, 100)
    end
    table.insert(spawn_defs, {
      def_idx = idx,
      zone = self,
      count = count,
      unit_def = def
    })
  end
  return spawn_defs
end
function AmbientZoneMarker:GetUnitForMarker(marker)
  local units = {}
  for _, def_units in ipairs(self.units) do
    for _, unit in ipairs(def_units) do
      local not_defeated = not unit:IsDead() and (IsKindOf(unit, "AmbientLifeAnimal") or not unit:IsDefeatedVillain())
      if not_defeated and not unit.perpetual_marker and marker:CanVisit(unit, "for perpetual") then
        table.insert(units, unit)
      end
    end
  end
  return 0 < #units and units[1 + self:Random(#units)]
end
function AmbientZoneMarker:InitUnit(unit)
  unit:SetSide("neutral")
  unit.routine = "Ambient"
  unit.routine_spawner = self
  unit.approach_banters = table.keys2(Presets.BanterDef[self.ApproachBanters] or empty_table, "sorted")
  unit.approach_banters_distance = 8
  unit.approach_banters_cooldown_id = self.Groups and next(self.Groups) and self.Groups[1]
  for _, gr in ipairs(self.Groups) do
    table.insert_unique(unit.Groups, gr)
  end
  unit.conflict_ignore = self.ConflictIgnore
end
function AmbientZoneMarker:PlaceSpawnDef(unit_def, pos)
  local unit = SpawnUnit(unit_def.UnitDef, unit_def:GenSessionId(), pos)
  unit.ephemeral = unit_def.Ephemeral
  CheckUniqueSessionId(unit)
  unit.zone = self
  self:InitUnit(unit)
  if unit_def.Name and unit_def.Name ~= "" then
    unit.Name = unit_def.Name
  end
  if unit_def.Appearance then
    unit:ApplyAppearance(unit_def.Appearance)
  end
  if (GameState.Conflict or GameState.ConflictScripted) and unit:CanCower() then
    unit:TeleportToCower()
  end
  unit.fx_actor_class = "AmbientUnit"
  return unit
end
function OnMsg.GetCustomFXInheritActorRules(rules)
  rules[#rules + 1] = "AmbientUnit"
  rules[#rules + 1] = "Unit"
end
function AmbientZoneMarker:FilterZTolerance(positions, unpack)
  if not self.AreaLevelZ then
    return positions
  end
  local pos = self:GetPos()
  local level_z = pos:IsValidZ() and pos:z() or terrain.GetHeight(pos)
  local z_tolerance = self.AreaLevelZ * const.SlabSizeZ
  local unpacked = table.imap(positions, function(packed_pos)
    return point(point_unpack(packed_pos))
  end)
  return table.ifilter(unpack and unpacked or positions, function(idx)
    local pos = unpacked[idx]
    local z = pos:z() or terrain.GetHeight(pos)
    return abs(level_z - z) <= z_tolerance
  end)
end
function AmbientZoneMarker:CheckZTolerance(check_pos)
  if not self.AreaLevelZ then
    return true
  end
  local pos = self:GetPos()
  local level_z = pos:IsValidZ() and pos:z() or terrain.GetHeight(pos)
  local z_tolerance = self.AreaLevelZ * const.SlabSizeZ
  local check_z = check_pos:IsValidZ() and check_pos:z() or terrain.GetHeight(check_pos)
  return z_tolerance >= abs(level_z - check_z)
end
function AmbientZoneMarker:Spawn(refill)
  NetUpdateHash("AmbientZoneMarker:Spawn", self.handle)
  local spawn_defs = self:GetSpawnDefinitions()
  self.units = self.units or {}
  local to_enter_map = {}
  for _, def in ipairs(spawn_defs) do
    self.units[def.def_idx] = self.units[def.def_idx] or {}
    local spawned = self.units[def.def_idx]
    for idx = #spawned, 1, -1 do
      local unit = spawned[idx]
      if not IsValid(unit) or unit:IsDead() then
        table.remove(spawned, idx)
      end
    end
    while #spawned > def.count do
      local idx = 1 + self:Random(#spawned)
      local unit = spawned[idx]
      table.remove(spawned, idx)
      unit:Despawn()
    end
    if #spawned < def.count then
      local area_positions = self:GetAreaPositions()
      local available_positions = self:FilterZTolerance(area_positions)
      local positions_required = Min(def.count - #spawned, #available_positions)
      local positions = self:GetRandomPositions(positions_required, nil, available_positions, nil, "avoid close pos")
      for _, pos in ipairs(positions) do
        if pos ~= InvalidPos() then
          local spawn_pos = (not refill or self:IsKindOf("AmbientZone_Animal")) and pos
          local unit = self:PlaceSpawnDef(def.unit_def, spawn_pos)
          table.insert(spawned, unit)
          if not spawn_pos then
            table.insert(to_enter_map, {unit = unit, pos = pos})
          end
        end
      end
    end
  end
  if 0 < #to_enter_map then
    table.shuffle(to_enter_map, self:Random(#to_enter_map))
    local refill = 100 - const.AmbientLife.ConflictReduction
    local wave1 = #to_enter_map * const.AmbientLife.ConflictAftermathRepopulateWave1 / refill
    local wave2 = #to_enter_map * const.AmbientLife.ConflictAftermathRepopulateWave2 / refill
    local wave_interval = const.AmbientLife.ConflictAftermathWavesInterval
    local wave_duration = const.AmbientLife.ConflictAftermathRepopulateWaveDuration
    local wait_time = wave_interval + self:Random(wave_duration)
    local wave = 1
    for idx, entry in ipairs(to_enter_map) do
      if idx > wave1 and wave < 2 then
        wait_time = wait_time + wave_duration + wave_interval
        wave = 2
      elseif idx > wave1 + wave2 and wave < 3 then
        wait_time = wait_time + wave_duration + wave_interval
        wave = 3
      end
      local unit_wait_time = wait_time + self:Random(wave_duration)
      entry.unit:SetCommand("EnterMap", self, entry.pos, unit_wait_time)
    end
  end
end
function AmbientZoneMarker:Despawn()
  for idx, units_def in ipairs(self.units) do
    for _, unit in ipairs(units_def) do
      if IsValid(unit) then
        unit:Despawn()
      end
    end
  end
  self.units = false
end
function AmbientZoneMarker:RegisterUnits(units)
  if self.units and 0 < #units then
    table.insert(self.units, units)
  end
end
function AmbientZoneMarker:GetExitZones(pos)
  local markers, markers_reachable = 0, {}
  local pfclass = CalcPFClass("player1")
  MapForEachMarker("ExitZoneInteractable", nil, function(marker)
    markers = markers + 1
    local check_pos = GetPassSlab(marker) or marker:GetPos()
    local has_path, closest_pos = pf.HasPosPath(pos, check_pos, pfclass)
    if has_path and closest_pos == check_pos then
      table.insert(markers_reachable, marker)
    end
  end)
  return markers, markers_reachable
end
function AmbientZoneMarker:GetEntranceMarker(unit)
  local obj = unit and (IsVisitingUnit(unit) and unit.last_visit or unit:IsValidPos() and unit) or self
  local pos = GetPassSlab(obj) or obj:GetPos()
  local markers, markers_reachable = self:GetExitZones(pos)
  if #markers_reachable == 0 then
    local visitable = unit and unit.behavior == "Visit" and unit.behavior_params and unit.behavior_params[1]
    local AL_marker = visitable and visitable[1]
    local suppress_VMEs = AL_marker and IsKindOf(AL_marker, "AmbientLifeMarker") and AL_marker.Teleport
    if not suppress_VMEs then
      local info = markers == 0 and "(No ExitZoneInteractable Markers)" or ""
      StoreErrorSource(self, string.format("AL zone unreachable by any ExitZoneInteractable marker%s", info))
      if unit then
        StoreErrorSource(unit, string.format("Unit can't reach AL zone from ExitZoneInteractable marker(%s)", info, GetMapName()))
      else
        StoreErrorSource(self, string.format("Test Dummy Unit can't reach AL zone from ExitZoneInteractable marker(%s)", info, GetMapName()))
      end
    end
  end
  local closest = ChooseClosestObject(markers_reachable, pos)
  return closest
end
function AmbientZoneMarker:ReduceUnits(reduction_percents, exit_map)
  local units = {}
  for idx, units_def in ipairs(self.units) do
    for _, unit in ipairs(units_def) do
      if IsValid(unit) and not unit:IsDead() then
        table.insert(units, {unit = unit, idx = idx})
      end
    end
  end
  local count = reduction_percents * #units / 100
  for i = #units, 1, -1 do
    local entry = units[i]
    local unit = entry.unit
    local valid = IsValid(unit)
    if not valid or unit.command == "EnterMap" or not unit:IsValidPos() then
      if valid then
        unit:Despawn()
      end
      table.remove(units, i)
      table.remove_entry(self.units[entry.idx], unit)
    end
  end
  while count < #units do
    local k = 1 + InteractionRand(#units, "AmbientLifeReduction")
    local entry = units[k]
    local unit = entry.unit
    table.remove(units, k)
    table.remove_entry(self.units[entry.idx], unit)
    if exit_map then
      if unit.command ~= "Die" then
        local marker = self:GetEntranceMarker(unit)
        if marker then
          unit:SetCommand("ExitMap", marker)
          unit:SetCommandParamValue("ExitMap", "move_anim", "Run")
        else
          unit:Despawn()
        end
      end
    elseif unit.command ~= "Die" and unit.command ~= "ExitMap" then
      unit:Despawn()
    end
  end
end
function AmbientZoneMarker:GetRoamMarkers(unit)
  local roam_markers = {}
  local area = self:GetAreaBox()
  for _, visitable in ipairs(g_Visitables) do
    local marker = visitable[1]
    if IsKindOf(marker, "AL_Roam") and not visitable.reserved and (not unit or marker:CanVisit(unit)) then
      local pt = visitable[2] or marker:GetPos()
      if pt:InBox2D(area) and not IsInAmbientLifeRepulsionZone(pt) then
        table.insert(roam_markers, visitable)
      end
    end
  end
  return roam_markers
end
function AmbientZoneMarker:EditorGetText()
  local count = #(self:GetRoamMarkers() or empty_table)
  if 0 < count then
    return string.format("Roam Markers: %d", count)
  end
end
function AmbientZoneMarker:EditorGetTextColor()
  return const.clrGreen
end
function AmbientZoneMarker:UpdateText(marker_type_item)
end
function AmbientZoneMarker:RecreateText()
  EditorTextObject.EditorTextUpdate(self, "recreate")
end
function AmbientZoneMarker:EditorCallbackMove()
  GridMarker.EditorCallbackMove(self)
  self:RecreateText()
end
function AmbientZoneMarker:EditorCallbackRotate()
  GridMarker.EditorCallbackRotate(self)
  self:RecreateText()
end
function AmbientZoneMarker:VME_CheckAreaPositionsExits(positions)
  for _, packed_pos in ipairs(positions) do
    local pos = point(point_unpack(packed_pos))
    local markers, markers_reachable = self:GetExitZones(pos)
    if markers == 0 then
      StoreErrorSource(pos, string.format("No ExitZoneInteractable markers to reach map exit from on Combat start!(%s)", GetMapName()), self)
      return
    end
    if #markers_reachable == 0 then
      StoreErrorSource(pos, string.format("No reachable ExitZoneInteractable markers from Area point on Combat start!(%s)", GetMapName()), self)
    end
  end
end
function AmbientZoneMarker:VME_Checks(check_unreachables)
  self:GetEntranceMarker()
  local positions = self:GetAreaPositions()
  if #positions == 0 then
    StoreErrorSource(self, "AmbientZoneMarker without valid area positions. Check Width and Height!")
  elseif check_unreachables then
    self:VME_CheckAreaPositionsExits(positions)
  end
end
OnMsg.ValidateMap = ValidateGameObjectProperties("AmbientZoneMarker")
DefineClass.PropertyHelper_AppearanceObjectAbsolutePos = {
  __parents = {
    "PropertyHelper_AbsolutePos",
    "AppearanceObject"
  }
}
function PropertyHelper_AppearanceObjectAbsolutePos:GameInit()
  self:SetAnimPose(self.parent:GetAnim(), self.parent.VisitPose)
  self:Face(self.parent)
  self.parent:Face(self)
end
function PropertyHelper_AppearanceObjectAbsolutePos:EditorCallback(action_id)
  PropertyHelper_AbsolutePos.EditorCallback(self, action_id)
  self:Face(self.parent)
  self.parent:Face(self)
end
local GatherUnits = function()
  local neutral, neutral_dead, military_dead = {}, {}, {}
  for _, unit in ipairs(g_Units) do
    if not unit.team or unit.team.side == "neutral" then
      local behavior = g_Combat and unit.combat_behavior or unit.behavior
      if not unit.conflict_ignore then
        local dead = unit:IsDead() or unit.command == "Die"
        table.insert(dead and neutral_dead or neutral, unit)
      end
    elseif unit:IsDead() or unit.command == "Die" then
      table.insert(military_dead, unit)
    end
  end
  return neutral, neutral_dead, military_dead
end
function MakeCowards(command_required)
  local neutral = GatherUnits()
  NetUpdateHash("MakeCowards", #neutral)
  for _, unit in ipairs(neutral) do
    if unit.command == command_required or unit.command ~= "Cower" and unit.command ~= "ExitMap" then
      if unit:IsVisiting() then
        local marker = unit.behavior_params[1]
        if marker and IsKindOf(marker[1], "AmbientLifeMarker") then
          unit.visit_command = unit.behavior
          unit.visit_marker = marker
        end
      end
      if unit:IsValidPos() then
        if unit:CanCower() then
          unit:SetCommand("Cower", "find cower spot")
          unit:SetCommandParamValue("Cower", "move_anim", "Run")
        end
        unit:UpdateMoveAnim()
      end
    end
  end
end
function OnMsg.GroupChangeSide(group, toSide, units)
  if toSide ~= "enemy1" and toSide ~= "enemy2" then
    return
  end
  for i, u in ipairs(units) do
    if u.combat_behavior == "Cower" then
      u:SetCombatBehavior()
      u:SetCommand("Idle")
    end
  end
end
function OnMsg.UnitSideChanged(unit, newTeam)
  local newSide = newTeam and newTeam.side
  if not newSide or newSide ~= "enemy1" and newSide ~= "enemy2" then
    return
  end
  if unit.combat_behavior == "Cower" then
    unit:SetCombatBehavior()
    unit:SetCommand("Idle")
  end
end
function CalmDownCowards()
  for _, unit in ipairs(g_Units) do
    if unit.command == "Cower" then
      if unit.visit_command then
        local command, marker = unit.visit_command, unit.visit_marker
        unit.visit_command, unit.visit_marker = false, false
        if marker and IsValid(marker[1]) then
          marker.reserved = unit.handle
          unit:SetCommand(command, marker)
          return
        end
      end
      unit:SetCommand("Idle")
    end
  end
end
MapVar("g_AmbientLifeSpawn", false)
function AmbientLifeToggle()
  Msg("AmbientLifeDespawn")
  g_AmbientLifeSpawn = not g_AmbientLifeSpawn
  if g_AmbientLifeSpawn then
    Msg("AmbientLifeSpawn")
  else
    Msg("AmbientLifeDespawn")
  end
end
function AmbientLifePerpetualMarkersSteal()
  local spawn_markers = {}
  MapForEach("map", "AmbientLifeMarker", function(marker)
    if not marker.perpetual_unit then
      marker.steal_activated = false
      if marker:IsCollectionLeader() and marker:CanSpawn() then
        table.insert(spawn_markers, marker)
      end
    end
  end)
  table.shuffle(spawn_markers, InteractionRand(nil, "AmbientLifeSpawn"))
  for _, marker in ipairs(spawn_markers) do
    marker:SpawnCollection()
  end
end
function OnMsg.AmbientLifeSpawn()
  FireNetSyncEventOnHostOnce("AmbientLifeSpawn")
end
function NetSyncEvents.AmbientLifeSpawn()
  MapForEach("map", "AmbientLifeMarker", function(marker)
    if marker.perpetual_unit and not marker:CanSpawn() then
      marker.steal_activated = false
      marker.perpetual_unit.perpetual_marker = false
      marker.perpetual_unit = false
    end
  end)
  SuppressTeamUpdate = true
  MapForEach("map", "AmbientZoneMarker", function(zone)
    if zone:CanSpawn() then
      zone:Spawn()
    end
  end)
  SuppressTeamUpdate = false
  Msg("TeamsUpdated")
  AmbientLifePerpetualMarkersSteal()
  Msg("AmbientLifeSpawned")
end
function OnMsg.AmbientLifeDespawn()
  FireNetSyncEventOnHostOnce("AmbientLifeDespawn")
end
function NetSyncEvents.AmbientLifeDespawn()
  MapForEach("map", "AmbientLifeMarker", function(marker)
    marker:Despawn()
  end)
  MapForEach("map", "AmbientZoneMarker", function(zone)
    zone:Despawn()
  end)
  Msg("AmbientLifeDespawned")
end
MapVar("s_SpawnALForbidden", false)
function OnMsg.NewGameSessionStart()
  s_SpawnALForbidden = true
end
function OnMsg.InitSessionCampaignObjects()
  s_SpawnALForbidden = false
end
local interestingStates = {
  RainHeavy = true,
  RainLight = true,
  Conflict = true,
  ConflictScripted = true,
  Combat = true
}
function OnMsg.GameStateChanged(changed)
  if netInGame and IsChangingMap() then
    return
  end
  for k, v in sorted_pairs(changed) do
    if interestingStates[k] then
      FireNetSyncEventOnHostOnce("AmbientLifeOnGameStateChanged", changed)
      return
    end
  end
end
function KickOutUnits()
  MapForEach("map", "AmbientZoneMarker", function(zone)
    if not zone.ConflictIgnore then
      zone:ReduceUnits(const.AmbientLife.ConflictReduction, "exit map")
    end
  end)
  MakeCowards()
end
function NetSyncEvents.AmbientLifeOnGameStateChanged(changed)
  local didWork = false
  SuppressTeamUpdate = true
  if changed.RainHeavy or changed.RainLight then
    for _, unit in ipairs(g_Units) do
      unit:ResetMoveStyle()
    end
    didWork = true
  end
  if not ChangingMap and GetMapName() ~= "" then
    if changed.Conflict or changed.ConflictScripted then
      if not g_Combat and not g_StartingCombat then
        KickOutUnits()
        didWork = true
      end
    elseif (changed.Conflict == false or changed.ConflictScripted == false) and not s_SpawnALForbidden and not GameState.Conflict and not GameState.ConflictScripted then
      CalmDownCowards()
      MapForEach("map", "AmbientZoneMarker", function(zone)
        if zone:CanSpawn() and not zone.ConflictIgnore and not zone:IsKindOf("AmbientZone_Animal") then
          zone:Spawn("refill")
        end
      end)
      didWork = true
    end
    if changed.Combat and not GameState.Conflict and not GameState.ConflictScripted then
      local neutral = GatherUnits()
      for _, unit in ipairs(neutral) do
        local cmd = unit.command
        if cmd == "EnterMap" or not unit:IsValidPos() then
          unit:Despawn()
        elseif cmd ~= "Idle" and not unit:IsDead() and not unit:IsDefeatedVillain() then
          unit:SetCommand("Idle")
        end
      end
      didWork = true
    end
  end
  SuppressTeamUpdate = false
  if didWork then
    Msg("TeamsUpdated")
  end
end
function OnMsg.UnitAwarenessChanged(unit)
  if g_Combat then
    CreateGameTimeThread(MakeCowards, "Idle")
  end
end
function AmbientLifeVisibilityDistanceCheck()
  for _, unit in ipairs(g_Units) do
    if unit.command == "Cower" and GameTime() > (unit.cower_cooldown or 0) then
      local visibility = g_Visibility[unit]
      for _, threat in ipairs(visibility) do
        if threat.team and threat.team.side ~= "neutral" and unit:GetDist2D(threat) < const.AmbientLife.CowerRunDist then
          unit.cower_from, unit.cower_angle = threat:GetVisualPos(), threat:GetAngle()
          Msg(unit)
          break
        end
      end
    end
  end
end
OnMsg.ExplorationComputedVisibility = AmbientLifeVisibilityDistanceCheck
local tff = table.findfirst
function OnMsg.EnterSector(_, load_game)
  local marker_units = {}
  local no_marker_kicks = {}
  for _, unit in ipairs(g_Units) do
    local visitable = unit.behavior == "Visit" and unit.behavior_params[1]
    if visitable then
      local marker = visitable[1]
      if marker then
        marker_units[marker] = marker_units[marker] or {}
        table.insert(marker_units[marker], unit)
      else
        unit:SetBehavior()
        unit:SetCommand(false)
        table.insert(no_marker_kicks, unit)
      end
    end
  end
  local kicked = {}
  for marker, units in pairs(marker_units) do
    local unit = units[1]
    local marker = unit.behavior == "Visit" and unit.behavior_params[1] and unit.behavior_params[1][1]
    if 1 < #units then
      do
        local idx = tff(units, function(_, u)
          return marker:CanVisit(u, "for perpetual")
        end) or 1
        unit = units[idx]
        table.remove(units, idx)
        local visitable = marker:GetVisitable()
        for _, u in ipairs(units) do
          if IsValid(u) and not u:IsDead() then
            u:FreeVisitable(visitable)
            u:SetBehavior()
            u:SetCommand(false)
            table.insert(kicked, u)
          end
        end
        unit:ReserveVisitable(visitable)
      end
    end
  end
end
function OnMsg.SetpieceEnded(setpiece)
  local neutral = GatherUnits()
  for _, unit in ipairs(neutral) do
    if unit.command == "ExitMap" then
      unit:Despawn()
    elseif unit.command == "Cower" then
      unit:TeleportToCower()
    end
  end
end
function SavegameSectorDataFixups.AmbientLifeVisitables()
  local used = {}
  local duplicates = 0
  for i = #g_Visitables, 1, -1 do
    local visitable = g_Visitables[i]
    local marker = visitable[1]
    if used[marker] then
      table.remove(g_Visitables, i)
      duplicates = duplicates + 1
    else
      used[marker] = true
    end
  end
end
function GetALMarkersGroups()
  local marker_groups = {}
  for id, group in sorted_pairs(Groups) do
    for _, o in ipairs(group) do
      if IsKindOf(o, "AmbientLifeMarker") then
        marker_groups[#marker_groups + 1] = id
        break
      end
    end
  end
  return marker_groups
end
function IsVisitingUnit(unit, AL_class)
  return IsKindOf(unit, "Unit") and unit.behavior == "Visit" and (not AL_class or IsKindOf(unit.last_visit, AL_class))
end
function IsSittingUnit(unit)
  return IsVisitingUnit(unit, "AL_SitChair")
end
function IsWallLeaningUnit(unit)
  return IsVisitingUnit(unit, "AL_WallLean")
end
function GetALMarkerGroups()
  local groups = {}
  MapForEach("map", "AmbientLifeMarker", function(marker)
    if not IsKindOf(marker, "AmbientLifeMarker") then
      return
    end
    for _, group in ipairs(marker.Groups) do
      if not groups[group] then
        groups[group] = true
        table.insert(groups, group)
      end
    end
  end)
  return groups
end
function DbgTestClosestALMarker()
  local pos = GetPassSlab(GetTerrainCursor())
  if not pos then
    StoreErrorSource(GetTerrainCursor(), "DbgTestClosestALMarker: Mouse cursor should be on passable!")
  end
  local closest_visitable = GetClosestVisitable(pos)
  if closest_visitable then
    closest_visitable[1]:DbgTest(pos, closest_visitable)
  else
    print("No AL marker found nearby")
  end
end
local RegAppearanceEntities = function(preset, entities)
  local appearance = FindPreset("AppearancePreset", preset)
  if appearance then
    AppearanceMarkEntities(appearance, entities)
  end
end
function OnMsg.GatherMapEntities(entities, objs)
  for _, obj in ipairs(objs) do
    if IsKindOfClasses(obj, "UnitMarker", "DummyUnit", "CheeringDummy") then
      RegAppearanceEntities(obj.Appearance, entities)
    elseif IsKindOf(obj, "AmbientZoneMarker") then
      for _, def in ipairs(obj.SpawnDefs) do
        if def.Appearance then
          RegAppearanceEntities(obj.Appearance, entities)
        else
          for _, group in ipairs(Presets.UnitDataCompositeDef) do
            local unit_def = table.find_value(group, "id", def.UnitDef)
            if unit_def then
              local list = unit_def.AppearancesList or empty_table
              for _, ap_weight in ipairs(list) do
                RegAppearanceEntities(ap_weight.Preset, entities)
              end
              break
            end
          end
        end
      end
    elseif IsKindOf(obj, "AmbientLifeMarker") then
      entities[obj.ToolEntity] = true
      if obj.Weapon and obj.Weapon ~= "" then
        local preset = FindPreset("InventoryItemCompositeDef", obj.Weapon)
        GatherWeaponPresetEntities(preset, entities)
      end
    end
  end
end
