DefineClass.ActionCameraDef = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "EyeZOffset",
      help = "Z offset of camera eye from attacker Groin spot",
      editor = "number",
      default = 1200,
      scale = "cm"
    },
    {
      id = "EyeBackOffset",
      help = "Offset behind the back of the attacker, vector <target, attacker>",
      editor = "number",
      default = 3000,
      scale = "m"
    },
    {
      id = "EyeAttackerOffset",
      help = "Distance between camera eye and attacker, perpendicular to attacker-target vector",
      editor = "number",
      default = 800,
      scale = "cm"
    },
    {
      id = "AttackerTargetDistParam",
      help = "Parameter used to determine offsets LookAtTargetOffset and LookAtZOffset",
      editor = "number",
      default = 20000,
      scale = "m"
    },
    {
      id = "LookAtTargetOffset",
      help = "Distance between camera LookAt and target for <AttackerTargetDistParam> attacker-target distance, perpendicular to attacker-target vector",
      editor = "number",
      default = 4200,
      scale = "cm"
    },
    {
      id = "LookAtZOffset",
      help = "Z offset of camera lookat from target Groin spot",
      editor = "number",
      default = -1000,
      scale = "cm"
    },
    {
      id = "FovX",
      help = "Horizontal field of view angle in action camera mode",
      editor = "number",
      default = 2400,
      scale = "deg"
    },
    {
      id = "FloatSphereRadius",
      help = "The camera eye \"floats\" between random points from the sphere surface",
      editor = "number",
      default = 50,
      scale = "cm"
    },
    {
      id = "FloatInterpolationTime",
      help = "Time for moving camera between two points from the float sphere surface",
      editor = "number",
      default = 1200
    },
    {
      id = "FloatEasing",
      help = "Float interpolation uses this easing",
      editor = "combo",
      default = 7,
      items = function(self)
        return const.EasingCombo
      end
    },
    {
      id = "HidingMode",
      name = "Object Hiding Mode",
      help = "CMT is the system that hides tree tops, walls etc.",
      editor = "combo",
      default = "NoCMT",
      items = function(self)
        return ActionCameraHidingModeCombo
      end
    },
    {
      id = "btn_test",
      editor = "buttons",
      default = false,
      dont_save = true,
      read_only = true,
      buttons = {
        {
          name = "Test",
          func = "ExecTestActionCamera"
        }
      }
    },
    {
      category = "Stances",
      id = "Standing",
      editor = "bool",
      default = true
    },
    {
      id = "NoRotate",
      name = "NoRotate",
      editor = "bool",
      default = false
    },
    {
      category = "Stances",
      id = "Crouch",
      name = "Crouched",
      editor = "bool",
      default = true
    },
    {
      category = "Stances",
      id = "Prone",
      editor = "bool",
      default = true
    },
    {
      category = "Stances",
      id = "CoverLow",
      name = "Low Cover",
      editor = "bool",
      default = true
    },
    {
      category = "Stances",
      id = "CoverHigh",
      name = "High Cover",
      editor = "bool",
      default = true
    },
    {
      id = "SetPieceOnly",
      name = "Setpiece only",
      help = "Can only be used in setpieces, never chosen in gameplay",
      editor = "bool",
      default = false
    },
    {
      category = "DOF Settings",
      id = "DOFStrengthNear",
      name = "Strength Near",
      editor = "number",
      default = 0,
      slider = true,
      min = 0,
      max = 1000
    },
    {
      category = "DOF Settings",
      id = "DOFStrengthFar",
      name = "Strength Far",
      editor = "number",
      default = 0,
      slider = true,
      min = 0,
      max = 1000
    },
    {
      category = "DOF Settings",
      id = "DOFNear",
      name = "Scaling Near Dist",
      help = "in promiles, 0 = camera, 1000 = attacker(dist to camera), 2000 = enemy(dist to camera + attacker dist)",
      editor = "number",
      default = 800,
      slider = true,
      min = 0,
      max = 2500
    },
    {
      category = "DOF Settings",
      id = "DOFFar",
      name = "Scaling Far Dist",
      help = "in promiles, 0 = camera, 1000 = attacker(dist to camera), 2000 = enemy(dist to camera+attacker dist)",
      editor = "number",
      default = 2000,
      slider = true,
      min = 0,
      max = 2500
    },
    {
      category = "DOF Settings",
      id = "DOFNearSpread",
      name = "Spread Near",
      help = "%",
      editor = "number",
      default = 150,
      scale = 1000,
      slider = true,
      min = 0,
      max = 2000
    },
    {
      category = "DOF Settings",
      id = "DOFFarSpread",
      name = "Spread Far",
      help = "%",
      editor = "number",
      default = 150,
      scale = 1000,
      slider = true,
      min = 0,
      max = 2000
    }
  },
  HasGroups = false,
  EditorMenubarName = "Action Camera Editor",
  EditorIcon = "CommonAssets/UI/Icons/video",
  EditorMenubar = "Combat"
}
function ActionCameraDef:OnEditorSetProperty(prop_id, old_value, ged)
  local props = {
    "DOFStrengthNear",
    "DOFStrengthFar",
    "DOFNear",
    "DOFFar"
  }
  if table.find(props, prop_id) then
    self:SetDOFParams(0)
  end
end
function ActionCameraDef:SetDOFParams(time, attacker, target, camera_pos)
  attacker = attacker or MapGetFirst("map", "ActionCameraTestDummy_Player")
  target = target or MapGetFirst("map", "ActionCameraTestDummy_Enemy")
  if not attacker or not target then
    CreateMessageBox(nil, T(634182240966, "Error"), T(626828916856, "ActionCameraTestDummy_Player or ActionCameraTestDummy_Target do not exist on the map"))
    return
  end
  if not IsPoint(attacker) then
    local headSpotIdx = attacker:GetSpotBeginIndex("Head")
    attacker = headSpotIdx and headSpotIdx ~= -1 and attacker:GetSpotLoc(headSpotIdx) or attacker:GetVisualPos()
  end
  if not IsPoint(target) then
    local headSpotIdx = target:GetSpotBeginIndex("Head")
    target = headSpotIdx and headSpotIdx ~= -1 and target:GetSpotLoc(headSpotIdx) or target:GetVisualPos()
  end
  camera_pos = camera_pos or camera.GetPos()
  hr.EnablePostProcDOF = 1
  local CalcGUIM_Distance = function(value_0_2000)
    local attacker_distance = (attacker - camera_pos):Len()
    local target_distance = (target - camera_pos):Len() + 1000
    if value_0_2000 <= 1000 then
      return MulDivRound(value_0_2000, attacker_distance, 1000)
    else
      local attacker_to_target = abs(target_distance - attacker_distance)
      return attacker_distance + MulDivRound(value_0_2000 - 1000, attacker_to_target, 1000)
    end
  end
  local near_distance = CalcGUIM_Distance(self.DOFNear)
  local far_distance = CalcGUIM_Distance(self.DOFFar)
  local defocus_near = MulDivRound(near_distance, self.DOFNearSpread, 1000)
  local defocus_far = MulDivRound(far_distance, self.DOFFarSpread, 1000)
  SetDOFParams(self.DOFStrengthNear, near_distance - defocus_near, near_distance, self.DOFStrengthFar, far_distance, far_distance + defocus_far, 0)
end
DefineClass.AnimationStyle = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "Animations",
      id = "Unit",
      editor = "combo",
      default = false,
      items = function(self)
        return GetAnimationStyleUnits()
      end
    },
    {
      category = "Animations",
      id = "VariationGroup",
      editor = "text",
      default = false
    },
    {
      category = "Animations",
      id = "Name",
      editor = "text",
      default = false
    },
    {
      category = "Conditions",
      id = "GameStates",
      editor = "set",
      default = false,
      three_state = true,
      items = function(self)
        return GetGameStateFilter()
      end
    },
    {
      category = "Conditions",
      id = "Weight",
      editor = "number",
      default = 100,
      min = 0,
      max = 1000000
    },
    {
      category = "Conditions",
      id = "CanPlay",
      editor = "func",
      default = function(self, unit)
        return true
      end,
      params = "self, unit"
    },
    {
      id = "EditorView",
      editor = "text",
      default = T(951373618311, "<Name> <color 45 138 138>(Weight: <Weight>)"),
      no_edit = true,
      translate = true
    },
    {
      category = "Preset",
      id = "Id",
      editor = "text",
      default = false,
      read_only = true
    },
    {
      category = "Preset",
      id = "Group",
      editor = "text",
      default = false,
      read_only = true
    }
  },
  GlobalMap = "AnimationStyles"
}
function AnimationStyle:GetRandomAnimId(id, unit)
  local animations = self[id]
  local count = animations and #animations or 0
  local total_weight = 0 < count and animations[count].total_weight or 0
  if total_weight == 0 then
    return
  end
  local idx
  if 1 < count then
    local roll = unit:Random(total_weight)
    idx = GetRandomItemByWeight(animations, roll, "total_weight")
  end
  return animations[idx or 1].Animation
end
function AnimationStyle:GetMainAnimId(id)
  local best_weight, best_anim = 0
  for _, anim in ipairs(self[id]) do
    if best_weight < anim.Weight then
      best_anim = anim.Animation
    end
  end
  return best_anim
end
function AnimationStyle:GenerateTotalWeight(id)
  local total_weight = 0
  for _, data in ipairs(self[id]) do
    if data.Animation then
      total_weight = total_weight + data.Weight
    end
    data.total_weight = total_weight
  end
end
function AnimationStyle:AnimationsCombo()
  local entity = GetAnimationStyleUnitEntity(self.Unit)
  if not entity then
    return
  end
  local states = GetStates(entity)
  for i = #states, 1, -1 do
    local state = states[i]
    if string.starts_with(state, "_") or IsErrorState(entity, GetStateIdx(state)) then
      table.remove(states, i)
    end
  end
  table.sort(states)
  return states
end
function AnimationStyle:SetUnit(value)
  self.Unit = value
  self:GenerateUniqueStyleId()
end
function AnimationStyle:SetVariationGroup(value)
  self.VariationGroup = value
  self:GenerateUniqueStyleId()
end
function AnimationStyle:SetName(value)
  self.Name = value
  self:GenerateUniqueStyleId()
end
function AnimationStyle:GenerateUniqueStyleId()
  if self.group ~= "AmbientLifeMarker - WIP - DON'T USE" then
    self:SetGroup(string.format("%s: %s", self.Unit, self.VariationGroup))
  end
  local name = string.format("%s: %s", self.Unit, self.Name)
  self.id = self:GenerateUniquePresetId(name)
  if self.id ~= name then
    self.Name = string.sub(self.id, #self.Unit + 2)
  end
end
function GetAnimationStyleCombo(set, class)
  local items = {}
  local insert = table.insert_unique
  for k, variations in ipairs(Presets.AnimationStyle) do
    for i, style in ipairs(variations) do
      if (not set or style.Unit == set) and (not class or style.class == class) then
        insert(items, style.Name)
      end
    end
  end
  table.sort(items)
  table.insert(items, 1, "")
  return items
end
function GetAnimationStyle(unit, name)
  if name and name ~= "" then
    local set = unit:GetAnimationStyleUnit()
    local id = set and string.format("%s: %s", set, name)
    return AnimationStyles[id]
  end
end
function GetRandomAnimationStyle(unit, variation_group)
  local set = unit:GetAnimationStyleUnit()
  local groupname = string.format("%s: %s", set, variation_group)
  local list = Presets.AnimationStyle[groupname]
  local total_weight = 0
  for i, entry in ipairs(list) do
    if entry:CanPlay(unit) and MatchGameState(entry.GameStates) then
      total_weight = total_weight + entry.Weight
    end
  end
  if total_weight == 0 then
    return
  end
  local style = list[1]
  if 1 < #list then
    local roll = unit:Random(total_weight)
    for i, entry in ipairs(list) do
      if entry:CanPlay(unit) and MatchGameState(entry.GameStates) then
        roll = roll - entry.Weight
        if roll < 0 then
          style = entry
          break
        end
      end
    end
  end
  return style
end
DefineClass.AnimationStyleAnim = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Animation",
      editor = "combo",
      default = false,
      items = function(self)
        local obj = GetParentTableOfKind(self, "AnimationStyle")
        if not obj then
          return
        end
        return obj:AnimationsCombo()
      end
    },
    {
      id = "Weight",
      editor = "number",
      default = 100,
      min = 0,
      max = 1000000
    },
    {
      id = "total_weight",
      help = "Hidden value. It allows binary search to speed up random choice.",
      editor = "number",
      default = false,
      no_edit = true
    }
  }
}
DefineClass.BanterDef = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "Id",
      editor = "text",
      default = false
    },
    {
      id = "banterDebug",
      name = "Debug",
      editor = "buttons",
      default = false,
      buttons = {
        {
          name = "Why Is This Banter Not Playing?",
          func = "DebugSpecificBanter"
        }
      }
    },
    {
      id = "loggable",
      name = "Log",
      help = "Whether to log banter lines.",
      editor = "bool",
      default = true
    },
    {
      id = "FilePerGroup",
      name = "FilePerGroup",
      editor = "bool",
      default = false,
      default = "BantersDef"
    },
    {
      id = "SingleFile",
      name = "SingleFile",
      editor = "bool",
      default = false
    },
    {
      id = "isRadio",
      name = "Radio",
      editor = "bool",
      default = false
    },
    {
      id = "Once",
      name = "OncePerCampaign",
      editor = "bool",
      default = false
    },
    {
      id = "banterGroup",
      name = "Interrupt Association Id",
      help = "Banter's of the same interrupt id will interrupt each other. Banters interrupt actors playing other banters by default.",
      editor = "text",
      default = false
    },
    {
      id = "cooldown",
      name = "Cooldown",
      help = "Banter cooldown - if the banter is on cooldown it won't play",
      editor = "number",
      default = false
    },
    {
      id = "disabledInConflict",
      name = "Do not play during conflict",
      help = "Disable banter while in conflict. NotNow VR plays if no other is available.",
      editor = "bool",
      default = false
    },
    {
      id = "KillOnAnyActorAware",
      name = "Kill On Combat Start",
      help = "Kill if any actor becomes aware",
      editor = "bool",
      default = false
    },
    {
      id = "FX",
      name = "FX",
      editor = "combo",
      default = false,
      items = function(self)
        return BanterFXCombo
      end
    },
    {
      id = "conditions",
      name = "Conditions",
      help = "The banter is only playable if all conditions are met.",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    },
    {
      id = "Lines",
      editor = "nested_list",
      default = false,
      base_class = "BanterLine",
      inclusive = true
    },
    {
      id = "OnEditorSetProperty",
      editor = "func",
      default = function(self)
        if self.group == "MercBanters" and not self.cooldown then
          self.cooldown = 2629746000
        end
      end,
      no_edit = true
    }
  },
  GlobalMap = "Banters",
  GedEditor = "BanterEditor",
  EditorMenubarName = "Banters",
  EditorIcon = "CommonAssets/UI/Icons/chat comment review text",
  EditorMenubar = "Scripting",
  EditorMenubarSortKey = "3000"
}
function BanterDef:OnPreSave()
  for i, l in ipairs(self.Lines) do
    if l.MultipleTexts and l.Text and l.Text ~= "" then
      l.Text = false
    end
    if l.MultipleTexts and l.Character then
      l.Character = "any"
    end
  end
end
DefineClass.Caliber = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "ImpactForce",
      help = "impact force modifier",
      editor = "number",
      default = 0
    }
  }
}
DefineClass.CampaignPreset = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "Satellite Settings",
      id = "sectors_offset",
      name = "Sectors Offset",
      editor = "point",
      default = point(0, 0, 0)
    },
    {
      category = "Satellite Settings",
      id = "sector_size",
      name = "Sector Size",
      editor = "point",
      default = point(0, 0)
    },
    {
      category = "Satellite Settings",
      id = "map_size",
      name = "Map Size",
      editor = "point",
      default = point(0, 0)
    },
    {
      category = "Satellite Settings",
      id = "map_file",
      name = "Map File",
      editor = "text",
      default = false
    },
    {
      category = "Preset",
      id = "DisplayName",
      name = "Display Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "sector_columns",
      name = "Sector Columns",
      editor = "number",
      default = false,
      min = 0
    },
    {
      id = "sector_rows",
      name = "Sector Rows",
      editor = "number",
      default = false,
      min = 0
    },
    {
      id = "map_editor_btn",
      name = "Map Editor",
      editor = "buttons",
      default = false,
      buttons = {
        {
          name = "Edit Map",
          func = "OpenGedSatelliteSectorEditor"
        }
      }
    },
    {
      id = "InitialSector",
      name = "Initial Sector",
      help = "The sector in which the campaign starts",
      editor = "text",
      default = false
    },
    {
      id = "Cities",
      editor = "nested_list",
      default = false,
      base_class = "CampaignCity",
      inclusive = true
    },
    {
      id = "Sides",
      editor = "nested_list",
      default = false,
      base_class = "CampaignSide",
      inclusive = true
    },
    {
      id = "Sectors",
      editor = "nested_list",
      default = false,
      no_edit = true,
      base_class = "SatelliteSector",
      inclusive = true
    },
    {
      id = "EffectsOnStart",
      name = "Effects On Start Campaign",
      help = "Effects that are executed when the campaign is started.",
      editor = "nested_list",
      default = false,
      base_class = "Effect",
      inclusive = true
    },
    {
      id = "Initialize",
      help = "Called once when the campaign starts for the first time.",
      editor = "func",
      default = function(self)
      end
    },
    {
      id = "FirstRunInterface",
      help = "Called after initialize, setups the initial interface.",
      editor = "func",
      default = function(self, interfaceType)
      end,
      params = "self, interfaceType"
    },
    {
      id = "starting_year",
      name = "Starting date, year",
      editor = "number",
      default = 2001
    },
    {
      id = "starting_month",
      name = "Starting date, month, 1-12",
      editor = "number",
      default = 4
    },
    {
      id = "starting_day",
      name = "Starting date, day, 1-31",
      editor = "number",
      default = 1
    },
    {
      id = "starting_hour",
      name = "Starting date, hour, 0-23",
      help = "Enter local time and it will be converted to GMT; if you want the campaign to start at 06:00 and you're in GMT+02 (Sofia winter), enter 8",
      editor = "number",
      default = 8
    },
    {
      id = "starting_timestamp",
      name = "Starting Time",
      editor = "number",
      default = 0,
      read_only = true
    },
    {
      id = "DisclaimerOnStart",
      editor = "text",
      default = false,
      translate = true,
      lines = 2
    }
  },
  GlobalMap = "CampaignPresets",
  EditorMenubarName = "Campaign",
  EditorIcon = "CommonAssets/UI/Icons/chart map paper sheet travel.png",
  EditorMenubar = "Scripting",
  EnableReloading = false
}
function CampaignPreset:OnEditorSetProperty(prop_id, old_value, ged)
  if ged and prop_id:starts_with("starting") then
    self.starting_timestamp = os.time({
      year = self.starting_year,
      month = self.starting_month,
      day = self.starting_day,
      hour = self.starting_hour
    })
  end
end
function CampaignPreset:OnStartCampaign(...)
  ExecuteEffectList(self.EffectsOnStart, self)
  self:Initialize(...)
  self:FirstRunInterface(...)
  Game.CampaignStarted = true
  Msg("CampaignStarted")
end
DefineClass.ChanceToHitModifier = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "display_name",
      name = "Display Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "RequireTarget",
      name = "Require Target",
      editor = "bool",
      default = false
    },
    {
      id = "RequireActionType",
      name = "Require Action Type",
      editor = "choice",
      default = "Any Attack",
      items = function(self)
        return CombatActionAttacksCombo
      end
    },
    {
      id = "CalcValue",
      editor = "func",
      default = function(self, attacker, target, body_part_def, action, weapon1, weapon2, lof, aim, opportunity_attack, attacker_pos, target_pos)
      end,
      params = "self, attacker, target, body_part_def, action, weapon1, weapon2, lof, aim, opportunity_attack, attacker_pos, target_pos"
    }
  },
  HasParameters = true,
  EditorIcon = "CommonAssets/UI/Icons/bullseye focus goal target.png",
  EditorMenubar = "Combat"
}
DefineClass.CombatAction = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "DisplayName",
      name = "DisplayName",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "DisplayNameShort",
      name = "DisplayNameShort",
      help = "Shortened display name. Used for firing modes and such.",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "Description",
      name = "Description",
      editor = "text",
      default = false,
      translate = true,
      lines = 1,
      max_lines = 5
    },
    {
      id = "basicAttack",
      name = "Basic Attack",
      editor = "bool",
      default = false
    },
    {
      id = "CostBasedOnWeapon",
      name = "Cost based on weapon",
      editor = "bool",
      default = false
    },
    {
      id = "ActionPoints",
      editor = "number",
      default = 0,
      no_edit = function(self)
        return self.CostBasedOnWeapon
      end,
      scale = "AP"
    },
    {
      id = "ActionPointDelta",
      editor = "number",
      default = 0,
      no_edit = function(self)
        return not self.CostBasedOnWeapon
      end,
      scale = "AP"
    },
    {
      id = "SimultaneousPlay",
      name = "Can play simultaneously with other units",
      editor = "bool",
      default = false
    },
    {
      id = "LocalChoiceAction",
      name = "Can play in the co-op unit move",
      help = "Used for interactions that opens local dialog (looting). Such actions do not wait the other units order to finish first",
      editor = "bool",
      default = false
    },
    {
      id = "DisableAimAnim",
      name = "No Aim Animation",
      help = "If checked the unit wont play aim animations",
      editor = "bool",
      default = false
    },
    {
      id = "InterruptInExploration",
      name = "Interrupt Action in Exploration",
      editor = "bool",
      default = false
    },
    {
      id = "IsTargetableAttack",
      name = "Is Targetable Attack",
      help = "Melee and AOE attacks marked with this will allow the user to choose a body part to attack. Single target attacks marked with this allow for aiming *and* choosing body parts (otherwise the crosshair will open, but the only option will be the default body part)",
      editor = "bool",
      default = false
    },
    {
      id = "IsAimableAttack",
      name = "Is Aimable Attack",
      help = "Whether the attack can be aimed. Only works if the attack also triggers the crosshair (is a single attack or AOE attack set as Targetable)",
      editor = "bool",
      default = true
    },
    {
      id = "StealthAttack",
      name = "Stealth Attack",
      help = "Whether the attack can be executed as a Stealth Attack. Stealth Attacks have a chance to kill non-Lieutenant enemies instantly and have increased Critical Chance against Lieutenants.",
      editor = "bool",
      default = false
    },
    {
      id = "MoveStep",
      name = "Move Before Targeting",
      help = "Whether the attack has an incorporated optional move step before targeting, allowing the player to try out different positions before attacking.",
      editor = "bool",
      default = false
    },
    {
      id = "UseFreeMove",
      name = "Use Free Move",
      help = "Whether the action uses AP provided by the Free Move status",
      editor = "bool",
      default = false
    },
    {
      id = "AlwaysHits",
      name = "Always Hits",
      help = "Whether the attack always hits (skips CtH)",
      editor = "bool",
      default = false
    },
    {
      id = "DontShowWith",
      name = "Dont Show With in Badge",
      help = "Whether to show \"With\" text in interactables when multiple units are to perform this action.",
      editor = "bool",
      default = false
    },
    {
      id = "RequireState",
      name = "Require State",
      help = "What gamestate this action requires to be displayed to the player.",
      editor = "choice",
      default = "combat",
      items = function(self)
        return {
          "any",
          "combat",
          "exploration"
        }
      end
    },
    {
      id = "MultiSelectBehavior",
      name = "Multi-Select Behavior",
      help = "What happens when multiple units are selected in exploration mode and the action is executed.",
      editor = "choice",
      default = "all",
      items = function(self)
        return {
          "all",
          "hidden",
          "nearest",
          "first"
        }
      end
    },
    {
      id = "RequireTargets",
      name = "Require Targets",
      help = "If the action can only be used if a valid target is present.",
      editor = "bool",
      default = false
    },
    {
      id = "RequireWeapon",
      name = "Require Weapon",
      help = "If the action requires a weapon to be displayed to the player.",
      editor = "bool",
      default = false
    },
    {
      id = "ActionCamera",
      editor = "bool",
      default = false
    },
    {
      id = "InteractionLoadingBar",
      editor = "bool",
      default = false
    },
    {
      id = "Icon",
      editor = "ui_image",
      default = "UI/Icons/Hud/placeholder.dds"
    },
    {
      id = "IconFiringMode",
      editor = "ui_image",
      default = "UI/Hud/fire_mode_button"
    },
    {
      id = "ShowIn",
      editor = "choice",
      default = "CombatActions",
      items = function(self)
        return {
          false,
          "CombatActions",
          "Stances",
          "Special",
          "SignatureAbilities"
        }
      end
    },
    {
      id = "ActionType",
      name = "Action Type",
      editor = "choice",
      default = "Other",
      items = function(self)
        return {
          "Melee Attack",
          "Ranged Attack",
          "Other",
          "Passive",
          "Toggle"
        }
      end
    },
    {
      id = "AimType",
      name = "Aim Type",
      editor = "choice",
      default = "none",
      items = function(self)
        return {
          "none",
          "line",
          "cone",
          "mobile",
          "melee",
          "melee-charge",
          "parabola aoe",
          "line aoe",
          "allies-attack"
        }
      end
    },
    {
      category = "Keybindings",
      id = "ConfigurableKeybind",
      editor = "bool",
      default = true
    },
    {
      category = "Keybindings",
      id = "ActionShortcut",
      editor = "text",
      default = false
    },
    {
      category = "Keybindings",
      id = "ActionShortcutDev",
      editor = "text",
      default = false
    },
    {
      category = "Keybindings",
      id = "KeybindingFromAction",
      editor = "text",
      default = false
    },
    {
      id = "FiringModeMember",
      name = "Member of Firing Mode",
      editor = "preset_id",
      default = false,
      preset_class = "CombatAction",
      preset_group = "FiringModeMetaAction"
    },
    {
      category = "Keybindings",
      id = "ActionShortcut2",
      editor = "text",
      default = false
    },
    {
      category = "Keybindings",
      id = "ActionGamepad",
      editor = "text",
      default = false
    },
    {
      category = "Keybindings",
      id = "KeybindingSortId",
      editor = "text",
      default = "2500"
    },
    {
      id = "GetUIState",
      help = "Returns if the CombatAction is available for execution. Possible values: \"enabled\", \"disabled\", \"hidden\".",
      editor = "func",
      default = function(self, units, args)
        local unit = units[1]
        local cost = self:GetAPCost(unit, args)
        if cost < 0 then
          return "hidden"
        end
        if not unit:UIHasAP(cost, self.id, args) then
          return "disabled", AttackDisableReasons.NoAP
        end
        return "enabled"
      end,
      params = "self, units, args"
    },
    {
      id = "GetVisibility",
      editor = "func",
      default = function(self, units, target)
        local real_action = self:ResolveAction(units)
        if not real_action then
          return "hidden"
        end
        self = real_action
        if self.RequireState == "combat" and not g_Combat then
          return "hidden"
        end
        if self.RequireState == "exploration" and g_Combat then
          return "hidden"
        end
        if 1 < #units and self.MultiSelectBehavior == "hidden" then
          return "hidden"
        end
        if not units[1] or self.RequireWeapon and not self:GetAttackWeapons(units[1]) then
          return "hidden"
        end
        local state, reason = self:GetUIState(units, {target = target})
        if (state == "enabled" or state ~= "hidden" and not reason) and self.RequireTargets and not IsValid(target) and not IsPoint(target) and not self:GetAnyTarget(units) then
          return "disabled", AttackDisableReasons.NoTarget
        end
        return state, reason
      end,
      no_edit = true,
      params = "self, units, target"
    },
    {
      id = "GetTargets",
      help = "Generates an array of possible targets.",
      editor = "func",
      default = function(self, units)
        return CombatActionGetAttackableEnemies(self, units and units[1])
      end,
      params = "self, units"
    },
    {
      id = "GetAnyTarget",
      editor = "func",
      default = function(self, units)
        return CombatActionGetOneAttackableEnemy(self, units and units[1])
      end,
      params = "self, units"
    },
    {
      id = "EvalTarget",
      help = "Highest evaluated target will be chosen automatically (on actions that use it).",
      editor = "func",
      default = function(self, units, target, args)
        if not units or not units[1] then
          return 0
        end
        local unitList = g_unitOrder[units[1]]
        if not unitList then
          return 0
        end
        local orderIdx = unitList[target]
        if orderIdx then
          return -orderIdx
        end
        return 0
      end,
      params = "self, units, target, args"
    },
    {
      id = "GetDefaultTarget",
      help = "Gets the default target for this action",
      editor = "func",
      default = function(self, unit)
        local best_eval, best_target
        local units = {unit}
        local targets = self:GetTargets(units)
        local distance_to_best = 0
        for _, target in ipairs(targets or empty_table) do
          local eval = self:EvalTarget(units, target)
          if not best_eval or best_eval < eval then
            distance_to_best = IsKindOf(target, "Unit") and unit:GetDist(target:GetPos()) or 0
            best_target, best_eval = target, eval
          elseif eval == best_eval then
            local distance_to_this = IsKindOf(target, "Unit") and unit:GetDist(target:GetPos()) or 0
            if distance_to_best > distance_to_this then
              distance_to_best = distance_to_this
              best_target = target
            end
          end
        end
        return best_target, best_eval
      end,
      params = "self, unit"
    },
    {
      id = "UIBegin",
      help = [[
Called when this action is selected from the UI; intended use is to switch to a custom targeting mode

Optionally can provide a target.]],
      editor = "func",
      default = function(self, units, args)
        MultiTargetExecute(self.MultiSelectBehavior, units, function(unit)
          self:Execute({unit}, args)
        end, args and args.target)
      end,
      params = "self, units, args"
    },
    {
      id = "Execute",
      help = "Order an action. Run will be called in the first possible moment.",
      editor = "func",
      default = function(self, units, args)
        local unit = units[1]
        local ap = self:GetAPCost(unit, args)
        NetStartCombatAction(self.id, unit, ap, args)
      end,
      params = "self, units, args"
    },
    {
      id = "Run",
      help = "Performs the ordered action in Execute",
      editor = "func",
      default = function(self, unit, ap, ...)
      end,
      params = "self, unit, ap, ..."
    },
    {
      id = "GetAPCost",
      editor = "func",
      default = function(self, unit, args)
        if self.CostBasedOnWeapon then
          local weapon = self:GetAttackWeapons(unit, args)
          return weapon and unit:GetAttackAPCost(self, weapon, nil, args and args.aim or 0, self.ActionPointDelta) or -1
        end
        return self.ActionPoints
      end,
      params = "self, unit, args"
    },
    {
      id = "GetMinAimRange",
      editor = "func",
      default = function(self, unit, weapon)
        return false
      end,
      params = "self, unit, weapon"
    },
    {
      id = "GetActionResults",
      editor = "func",
      default = function(self, unit, args)
        return {}
      end,
      params = "self, unit, args"
    },
    {
      id = "GetActionDamage",
      help = "Currently only used for display purposes, but that could change.",
      editor = "func",
      default = function(self, unit, target, args)
        return 0
      end,
      params = "self, unit, target, args"
    },
    {
      id = "GetMaxAimRange",
      editor = "func",
      default = function(self, unit, weapon)
        return false
      end,
      params = "self, unit, weapon"
    },
    {
      id = "GetAttackWeapons",
      editor = "func",
      default = function(self, unit, args)
        return args and args.weapon or unit:GetActiveWeapons()
      end,
      params = "self, unit, args"
    },
    {
      id = "GetActionDescription",
      editor = "func",
      default = function(self, units)
        local description = self.Description
        if (description or "") == "" then
          description = self:GetActionDisplayName()
        end
        return description
      end,
      params = "self, units"
    },
    {
      id = "GetActionDisplayName",
      editor = "func",
      default = function(self, units)
        local name = self.DisplayName
        if (name or "") == "" then
          name = Untranslated(self.id)
        end
        return name
      end,
      params = "self, units"
    },
    {
      id = "GetActionIcon",
      editor = "func",
      default = function(self, units)
        return self.Icon
      end,
      params = "self, units"
    },
    {
      id = "ResolveAction",
      editor = "func",
      default = function(self, context)
        return self
      end,
      params = "self, context"
    },
    {
      id = "GetAimParams",
      editor = "func",
      default = function(self, unit, weapon)
        if self.AimType == "cone" then
          return weapon:GetAreaAttackParams(self.id, unit)
        elseif self.AimType == "mobile" then
          local shots = self:ResolveValue("mobile_num_shots") or 1
          local move_ap = self:ResolveValue("mobile_move_ap")
          return {
            num_shots = shots,
            move_ap = move_ap * const.Scale.AP
          }
        elseif self.AimType == "parabola aoe" or self.AimType == "line aoe" then
          return weapon.AreaOfEffect
        end
        return 0
      end,
      params = "self, unit, weapon"
    },
    {
      id = "IsToggledOn",
      editor = "func",
      default = function(self, unit)
        return false
      end,
      no_edit = function(self)
        return self.ActionType ~= "Toggle"
      end,
      params = "self, unit"
    }
  },
  HasSortKey = true,
  HasParameters = true,
  GlobalMap = "CombatActions",
  EditorMenubarName = "Combat Actions",
  EditorIcon = "CommonAssets/UI/Icons/focus goal marketing target.png",
  EditorMenubar = "Combat",
  EditorMenubarSortKey = "-9"
}
function CombatAction:GetError()
  if not self.DisplayName then
    return "CombatActions must have a DisplayName"
  end
end
function CombatActionAttacksCombo()
  local items = {
    "Any Attack",
    "Any Melee Attack",
    "Any Ranged Attack"
  }
  ForEachPreset("CombatAction", function(item)
    if item.ActionType ~= "Other" then
      items[#items + 1] = item.id
    end
  end)
  return items
end
function GetConfigurableKeybindCombatActions()
  local ids = table.keys2(CombatActions)
  return table.ifilter(ids, function(idx, id)
    return CombatActions[id].ConfigurableKeybind or CombatActions[id].ActionShortcut
  end)
end
DefineClass.CombatStance = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "display_name",
      name = "Display Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "idle_anim",
      name = "Stance Anim",
      editor = "text",
      default = false
    },
    {
      id = "move_anim",
      name = "Movement Anim",
      editor = "text",
      default = false
    },
    {
      id = "Noise",
      help = "Range (in tiles) in which the unit alerts unaware enemies when moving in this stance",
      editor = "number",
      default = 3,
      min = 0,
      max = 100
    }
  },
  EditorIcon = "CommonAssets/UI/Icons/human male man people person.png",
  EditorMenubar = "Combat"
}
DefineClass.ConflictDescription = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "description",
      name = "Description",
      help = "Will fallback to default if missing.",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "title",
      name = "Title",
      help = "Will fallback to default if missing.",
      editor = "text",
      default = false,
      translate = true
    }
  },
  GlobalMap = "ConflictDescriptionDefs",
  EditorMenubarName = "Satellite Conflict Descriptions",
  EditorIcon = "CommonAssets/UI/Icons/info large outline",
  EditorMenubar = "Scripting"
}
DefineClass.ContainerNames = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "DisplayName",
      name = "Display Name",
      editor = "text",
      default = false,
      translate = true
    }
  }
}
DefineClass.Conversation = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "Preset",
      id = "Id",
      editor = "combo",
      default = false,
      validate = function(self, value)
        return ValidateIdentifier(self, value)
      end,
      items = function(self)
        return GetConversationCharactersCombo
      end
    },
    {
      id = "DefaultActor",
      name = "Default actor",
      help = "The default non-player unit talking in this conversation.",
      editor = "preset_id",
      default = false,
      preset_class = "UnitDataCompositeDef"
    },
    {
      id = "AssignToGroup",
      name = "Assign to group",
      help = "Assign the conversation to units from this group.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetUnitGroups()
      end
    },
    {
      id = "DefaultActorPortraitOverride",
      name = "Override Default Actor Portrait",
      editor = "ui_image",
      default = false
    },
    {
      id = "Conditions",
      name = "Conditions",
      help = "Assign the conversation only if these are true.",
      editor = "nested_list",
      default = false,
      base_class = "Condition",
      inclusive = true
    },
    {
      id = "Enabled",
      help = "To disable conversation for test purposes.",
      editor = "bool",
      default = true
    },
    {
      id = "disabledInConflict",
      name = "Do not play during conflict",
      help = "Disable conversation while in conflict. NotNow VR plays instead.",
      editor = "bool",
      default = false
    },
    {
      id = "StartOnMsg",
      name = "Start OnMsg",
      help = "Starts when any of these messages is invoked.",
      editor = "string_list",
      default = {},
      item_default = "",
      items = false,
      arbitrary_value = true
    },
    {
      id = "IncludeInVoiceScripts",
      name = "Include in voice recording scripts",
      editor = "bool",
      default = true
    }
  },
  HasParameters = true,
  SingleFile = false,
  GlobalMap = "Conversations",
  ContainerClass = "ConversationPhrase",
  GedEditor = "ConversationEditor",
  EditorMenubarName = "Conversations",
  EditorIcon = "CommonAssets/UI/Icons/baloon chat conversation texting.png",
  EditorMenubar = "Scripting",
  EditorMenubarSortKey = "3010",
  FilterClass = "ConversationEditorFilter",
  SubItemFilterClass = "ConversationEditorPhraseFilter",
  EditorCustomActions = {
    {Name = "Test"},
    {
      FuncName = "TestConversation",
      Icon = "CommonAssets/UI/Ged/play",
      Menubar = "Test",
      Name = "Test conversation",
      Shortcut = "Ctrl-T",
      Toolbar = "main"
    }
  },
  EditorView = Untranslated("<id><color 0 128 0><opt(u(Comment),' ','')><color 128 128 128><opt(u(save_in),' - ','')>")
}
function Conversation:OnEditorNew(parent, ged, is_paste, duplicate_id)
  if is_paste then
    if duplicate_id then
      for _, condition in ipairs(self.Conditions or empty_table) do
        if rawget(condition, "Conversation") == duplicate_id then
          condition.Conversation = self.Id
        end
      end
      self:ForEachSubObject("ConversationPhrase", function(obj, parents)
        for _, condition in ipairs(obj.Conditions or empty_table) do
          if rawget(condition, "Conversation") == duplicate_id then
            condition.Conversation = self.id
          end
        end
        for _, effect in ipairs(obj.Effects or empty_table) do
          if rawget(effect, "Conversation") == duplicate_id then
            effect.Conversation = self.id
          end
        end
      end)
    end
    return
  end
  self[1] = ConversationPhrase:new({
    id = "Greeting",
    Keyword = "Greeting",
    KeywordT = T(774381032385, "Greeting")
  })
  self[2] = ConversationPhrase:new({
    id = "Goodbye",
    Keyword = "Goodbye",
    KeywordT = T(557225474228, "Goodbye")
  })
  self[1]:OnAfterEditorNew()
  self[2]:OnAfterEditorNew()
end
function Conversation:OnEditorSetProperty(prop_id, old_value, ged)
  if prop_id == "DefaultActor" then
    self:ForEachSubObject("ConversationLine", function(obj, parents)
      if obj.Character == old_value or obj.Character == self.id then
        obj.Character = self.DefaultActor
      end
    end)
  end
  if prop_id == "Id" then
    CreateRealTimeThread(function()
      local msg = [[
This will update the references to this conversation from within itself,
but external references will NOT be updated!]]
      if ged:WaitQuestion("Rename", msg, "Yes", "No") ~= "ok" then
        self:SetId(old_value)
        ObjModified(self)
        return
      end
      self:ForEachSubObject(function(obj)
        for _, prop in ipairs(obj:GetProperties()) do
          if prop.editor == "preset_id" and prop.preset_class == "Conversation" and obj:GetProperty(prop.id) == old_value then
            obj:SetProperty(prop.id, self.id)
          end
        end
      end)
      ObjModified(self)
    end)
  end
end
function Conversation:OnPreSave(user_requested)
  self:ForEachSubObject("ConversationLine", function(obj, parents)
    if self.DefaultActor and (obj.Character == "<default>" or obj.Character == self.id) then
      obj.Character = self.DefaultActor
    end
  end)
  RebuildGroupToConversation()
end
function Conversation:GetError()
  if not self.DefaultActor then
    return "Please specify the default actor."
  end
  local has_end_phrase
  self:ForEachSubObject("ConversationPhrase", function(phrase)
    if phrase.GoTo == "<end conversation>" then
      has_end_phrase = true
    end
  end)
  if not has_end_phrase then
    return "Conversation doesn't have any phrase with <end conversation> GoTo property."
  end
  local missing = {}
  self:ForEachSubObject("ConversationLine", function(obj, parents, key, missing)
    local unit_def = UnitDataDefs[obj.Character]
    if obj.Character and unit_def and not unit_def.BigPortrait then
      table.insert_unique(missing, obj.Character)
    end
  end, missing)
  if next(missing) then
    return "Missing BigPortrait property for: " .. table.concat(missing, ",")
  end
end
function Conversation:GetSaveData(file_path, presets, ...)
  for idx, preset in ipairs(presets) do
    self:CreatePresetDiffFile(preset, string.gsub(file_path, ".lua", ".diff.txt"))
  end
  return Preset.GetSaveData(self, file_path, presets, ...)
end
function Conversation:CreatePresetDiffFile(preset, diff_path)
  local diffText = {}
  for _, conv in ipairs(preset) do
    diffText[#diffText + 1] = conv:GetReadableText(0)
  end
  SaveSVNFile(diff_path, table.concat(diffText, "\n"))
end
DefineClass.ConversationInterjection = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Lines",
      editor = "nested_list",
      default = false,
      base_class = "ConversationLine"
    },
    {
      id = "Conditions",
      help = "All conditions must be true for the phrase to be available.",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    },
    {
      id = "Effects",
      help = "Effects that are executed after the phrase is displayed.",
      editor = "nested_list",
      default = false,
      base_class = "Effect"
    },
    {
      id = "AlwaysInterject",
      help = "Allows the interjection to be played again, even if the player has already heard it.",
      editor = "bool",
      default = false
    }
  },
  StoreAsTable = true
}
function ConversationInterjection:GetEditorView()
  local actors = {}
  for _, line in ipairs(self.Lines or empty_table) do
    if line.Character ~= "<default>" then
      table.insert_unique(actors, line.Character)
    end
  end
  return "<color 160 64 160>" .. table.concat(actors, " & ") .. "</color>"
end
function ConversationInterjection:GetReadableText(indentation_level)
  local diffText = {}
  for _, line in ipairs(self.Lines) do
    diffText[#diffText + 1] = line:GetReadableText(indentation_level + 1)
  end
  return table.concat(diffText, "\n")
end
DefineClass.ConversationInterjectionList = {
  __parents = {
    "ConversationLineBase"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "MaxPlayed",
      name = "Max played",
      editor = "number",
      default = 1
    },
    {
      id = "Interjections",
      editor = "nested_list",
      default = false,
      base_class = "ConversationInterjection",
      inclusive = true,
      auto_expand = true
    }
  },
  StoreAsTable = true,
  EditorView = Untranslated("")
}
function ConversationInterjectionList:GetEditorView()
  local list = {
    "Interjections"
  }
  if self.MaxPlayed > 1 then
    list[#list + 1] = string.format("(max %d)", self.MaxPlayed)
  end
  for _, item in ipairs(self.Interjections or empty_table) do
    list[#list + 1] = "[" .. item:GetEditorView() .. "]"
  end
  return table.concat(list, " ")
end
function ConversationInterjectionList:OnAfterEditorNew(root, ged, is_paste)
  if not is_paste then
    self.Interjections = {
      ConversationInterjection:new()
    }
  end
end
function ConversationInterjectionList:GetReadableText(indentation_level)
  local diffText = {}
  for _, i in ipairs(self.Interjections) do
    diffText[#diffText + 1] = i:GetReadableText(indentation_level)
  end
  return table.concat(diffText, "\n")
end
DefineClass.ConversationKeyword = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  GlobalMap = "ConversationKeywords",
  GedEditor = ""
}
DefineClass.ConversationLine = {
  __parents = {
    "ConversationLineBase"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Character",
      help = "The character that says this line.",
      editor = "choice",
      default = "<default>",
      items = function(self)
        return GetConversationCharactersCombo
      end
    },
    {
      id = "Annotation",
      help = "Extra context for voice actors, e.g. \"angry\", \"sad\", etc.",
      editor = "combo",
      default = false,
      items = function(self)
        return PresetsPropCombo("Conversation", "Annotation", "", "recursive")
      end
    },
    {
      id = "SoundBefore",
      name = "Sound before",
      help = "Play sound before line and line voice over",
      editor = "browse",
      default = false,
      folder = "Sounds/ConversationEffects/"
    },
    {
      id = "SoundAfter",
      name = "Sound after",
      help = "Play sound after line and line voice over",
      editor = "browse",
      default = false,
      folder = "Sounds/ConversationEffects/"
    },
    {
      id = "SoundType",
      name = "Sound Type",
      editor = "preset_id",
      default = "ConversationsSFX",
      preset_class = "SoundTypePreset",
      preset_group = "VoiceoverConversations"
    },
    {
      id = "Text",
      editor = "text",
      default = false,
      context = ConversationLineContext("Character", "Annotation"),
      translate = true,
      lines = 1,
      max_lines = 7
    },
    {
      id = "AlwaysInterject",
      help = "Allows the interjection to be played again, even if the player has already heard it.",
      editor = "bool",
      default = false
    }
  },
  StoreAsTable = true,
  EditorView = Untranslated("<if(not_eq(Character,'<default>'))><Character>:</if> \"<Text>\"")
}
function ConversationLine:GetReadableText(indentation_level)
  return self.Text and string.format("%s%s: %s", string.rep("\t", indentation_level), self.Character, TDevModeGetEnglishText(self.Text, nil, false)) or ""
end
DefineClass.ConversationLineBase = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef"
}
DefineClass.ConversationPhrase = {
  __parents = {
    "PropertyObject",
    "Container"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "General",
      id = "id",
      name = "Id",
      editor = "text",
      default = false,
      read_only = true,
      buttons = {
        {
          name = "Copy Id",
          func = "CopyFullIdToClipboard"
        },
        {name = "Change", func = "ChangeId"}
      }
    },
    {
      category = "General",
      id = "Keyword",
      editor = "combo",
      default = "",
      buttons = {
        {
          name = "Add to combo",
          func = "AddKeywordToCombo"
        }
      },
      items = function(self)
        return PresetsCombo("ConversationKeyword")
      end
    },
    {
      category = "General",
      id = "KeywordT",
      editor = "text",
      default = false,
      no_edit = true,
      translate = true
    },
    {
      category = "General",
      id = "Tag",
      help = "Tags are used to automatically aggregate several keywords in a sub-menu (named after the Tag) if there are too many keywords. Keywords with tags are by default aligned left.",
      editor = "combo",
      default = "",
      items = function(self)
        return PresetsPropCombo("Conversation", "Tag", "", "recursive")
      end
    },
    {
      category = "General",
      id = "TagT",
      editor = "text",
      default = false,
      no_edit = true,
      translate = true
    },
    {
      category = "General",
      id = "Align",
      editor = "choice",
      default = "left",
      items = function(self)
        return {"left", "right"}
      end
    },
    {
      category = "General",
      id = "StoryBranchIcon",
      editor = "preset_id",
      default = "conversation_chat",
      preset_class = "ConversationStoryBranchIcons"
    },
    {
      category = "General",
      id = "Comment",
      editor = "text",
      default = false,
      lines = 1
    },
    {
      category = "Activation",
      id = "Enabled",
      help = "Is this keyword initially enabled.",
      editor = "bool",
      default = true
    },
    {
      category = "Activation",
      id = "AutoRemove",
      name = "Auto remove",
      help = "Is this phrase auto-removed once it is displayed to the player.",
      editor = "bool",
      default = false
    },
    {
      category = "Activation",
      id = "VariantPhrase",
      name = "Variant phrase",
      help = "A random phrase from the active variant phrases is picked. Variant phrases have lower priority than non-variant phrases that have not yet been seen, so they can be activated only after all the non-variant phrases have been seen by the player.",
      editor = "bool",
      default = false
    },
    {
      category = "Activation",
      id = "ShowDisabled",
      name = "Show disabled",
      help = "Displays the phrase dimmed if the conditions are not met, and there are no other enabled phrases with the same Keyword.",
      editor = "bool",
      default = false
    },
    {
      category = "Activation",
      id = "ShowPhraseRollover",
      name = "Show Phrase Rollover",
      help = "Shows phrase rollover - autogenerated or overwritten if available. If false is set no rollover is displaed even if there is atogenerated.",
      editor = "bool",
      default = true
    },
    {
      category = "Activation",
      id = "PhraseRolloverText",
      name = "Phrase rollover text",
      help = "Show that text when rollover the phrase. That text will override the automatically generated one from conditions.",
      editor = "text",
      default = false,
      translate = true,
      lines = 2,
      max_lines = 4
    },
    {
      category = "Activation",
      id = "PhraseRolloverTextAuto",
      name = "Phrase rollover text autogenerated",
      help = "Show that text when the phrase is rollovered. That text is auto-generated from conditions via GetUIText.",
      editor = "text",
      default = false,
      dont_save = true,
      read_only = true,
      lines = 2,
      max_lines = 4
    },
    {
      category = "Activation",
      id = "PhraseConditionRolloverText",
      name = "Current phrase rollover text for executed phrase",
      help = "Show that text when the phrase is displayed. That text will override the automatically generated one from conditions.",
      editor = "text",
      default = false,
      translate = true,
      lines = 2,
      max_lines = 4
    },
    {
      category = "Activation",
      id = "PhraseConditionRolloverTextAuto",
      name = "Current Phrase Rollover Text Autogenerated",
      help = "Show that text when the phrase is displayed. That text is auto-generated from conditions via GetConditionPhraseTopRolloverText.",
      editor = "text",
      default = false,
      dont_save = true,
      read_only = true,
      lines = 2,
      max_lines = 4
    },
    {
      category = "Activation",
      id = "Conditions",
      help = "All conditions must be true for the phrase to be available.",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    },
    {
      category = "Activation",
      id = "NoBackOption",
      name = "No Back option",
      help = "Do not add a 'Back' option to the list of child phrases.",
      editor = "bool",
      default = false,
      no_edit = function(obj)
        return #obj == 0
      end
    },
    {
      category = "Execution",
      id = "Lines",
      help = "The list of conversation lines to display when this phrase is activated.",
      editor = "nested_list",
      default = false,
      base_class = "ConversationLineBase"
    },
    {
      category = "Execution",
      id = "Effects",
      help = "Effects that are executed after the phrase is displayed.",
      editor = "nested_list",
      default = false,
      base_class = "Effect"
    },
    {
      category = "Execution",
      id = "CompleteQuests",
      name = "Complete quests",
      help = "Sets quests status to 'completed'",
      editor = "preset_id_list",
      default = {},
      preset_class = "QuestsDef",
      item_default = ""
    },
    {
      category = "Execution",
      id = "GiveQuests",
      name = "Give quests",
      help = "Sets quests status to 'given'",
      editor = "preset_id_list",
      default = {},
      preset_class = "QuestsDef",
      item_default = ""
    },
    {
      category = "Execution",
      id = "GoTo",
      name = "Go to",
      help = "Next phrase tree to jump to after this one - by default stay in the same tree.",
      editor = "choice",
      default = "",
      items = function(self)
        return GetPhraseIdsCombo(GetParentTableOfKindNoCheck(self, "Conversation"), "skip_greetings", {
          "",
          "<back>",
          "<root>",
          "<end conversation>"
        })
      end
    },
    {
      category = "Execution",
      id = "PlayGoToPhrase",
      name = "Play \"Go to\" phrase",
      help = "If set, plays all lines from the phrase jumped to with the \"Go to\" property and executes its Effects.",
      editor = "bool",
      default = false
    }
  },
  StoreAsTable = true,
  ContainerClass = "ConversationPhrase",
  ComboFormat = Untranslated("<Keyword>"),
  ContainerClass = "ConversationPhrase"
}
function ConversationPhrase:GetFullId(root)
  return ComposePhraseId(root:FindSubObjectParentList(self), self, 2)
end
function ConversationPhrase:CopyFullIdToClipboard(root, prop_id, ged)
  local full_id = self:GetFullId(root)
  CopyToClipboard(full_id)
  ged:ShowMessage("Phrase ID Copied to Clipboard", full_id)
end
function ConversationPhrase:ChangeId(root, prop_id, ged)
  local old_id = self.id
  local new_id = ged:WaitUserInput("Enter new Id", self.id)
  if not new_id then
    return
  end
  local id_changes = {}
  self:ForEachSubObject("ConversationPhrase", function(phrase)
    local old_full_id = phrase:GetFullId(root)
    self.id = new_id
    id_changes[old_full_id] = phrase:GetFullId(root)
    self.id = old_id
  end)
  self.id = new_id
  local count = 0
  ForEachPhraseReferenceInPresets(root, function(parents, obj, phrase_id_prop)
    local new_id = id_changes[obj[phrase_id_prop]]
    if new_id then
      obj[phrase_id_prop] = new_id
      count = count + 1
    end
  end)
  ged:ShowMessage("Information", string.format("A total of %d references to this phrase (or children phrases) were updated to use the new ids.", count))
  ObjModified(self)
end
function ConversationPhrase:AddKeywordToCombo()
  if self.Keyword ~= "" and not table.find(Presets.ConversationKeyword.Default, "id", self.Keyword) then
    local keyword = ConversationKeyword:new()
    keyword:SetGroup("Default")
    keyword:SetId(self.Keyword)
    ConversationKeyword:SaveAll("force")
  end
end
function ConversationPhrase:GetEditorView()
  local texts = {}
  texts[#texts + 1] = Untranslated("<color 100 100 200><if(Enabled)>+</if><Keyword></color>")
  local condition = self.Conditions and self.Conditions[1]
  local txt = condition and _InternalTranslate(condition:GetEditorView(), condition) or ""
  if txt and txt ~= "" then
    txt = utf8.len(txt) <= 30 and txt or utf8.sub(txt, 1, 30) .. "..."
    texts[#texts + 1] = Untranslated(" <color 150 150 100>[" .. txt .. "]</color> ")
  end
  local txt
  local interjections, line_interjections = {}, {}
  local default_actor = GetParentTableOfKind(self, "Conversation").DefaultActor
  for _, line in ipairs(self.Lines) do
    if line:IsKindOf("ConversationLine") then
      txt = txt or line and line.Text
      if line.Character ~= "<default>" and line.Character ~= default_actor then
        table.insert(line_interjections, string.format("[%s]", line.Character))
      end
    elseif line:IsKindOf("ConversationInterjectionList") then
      table.insert(interjections, "\t\t" .. line:GetEditorView())
    end
  end
  if next(line_interjections) then
    table.insert(interjections, 1, "\t\tLine interjections: " .. table.concat(line_interjections, " "))
  end
  if txt and txt ~= "" then
    txt = TDevModeGetEnglishText(txt)
    txt = utf8.len(txt) <= 50 and txt or utf8.sub(txt, 1, 50) .. "..."
    texts[#texts + 1] = Untranslated(" " .. string.format("<literal %s>%s", #txt, txt) .. " ")
  end
  local comment = self.Comment
  if #(comment or "") > 0 then
    comment = comment:match([[
^([^
]*)]])
    comment = utf8.len(comment) <= 20 and comment or utf8.sub(comment, 1, 20) .. "..."
    texts[#texts + 1] = Untranslated("<color 0 128 0>-- " .. comment .. "</color>")
  end
  local phrase_text = table.concat(texts, "")
  if self.Effects or self.Conditions or next(interjections) then
    local text_lines = {phrase_text}
    if next(interjections) then
      text_lines[#text_lines + 1] = Untranslated("<color 160 64 160>" .. table.concat(interjections, "\n") .. "</color>")
    end
    GetEditorConditionsAndEffectsText(text_lines, self)
    GetEditorStringListPropText(text_lines, self, "CompleteQuests")
    GetEditorStringListPropText(text_lines, self, "GiveQuests")
    phrase_text = table.concat(text_lines, "\n")
  end
  if self.GoTo ~= "" and self.Keyword ~= "Goodbye" then
    local command = self.GoTo:starts_with("<end") and "" or "Go to "
    phrase_text = phrase_text .. Untranslated(string.format([[

		<color 191 124 28>%s%s</color>]], command, self.GoTo))
  end
  return phrase_text
end
function ConversationPhrase:GenerateId(conversation)
  local id = self.Keyword:gsub("[^%w_+-]", "")
  local parent_list = conversation:FindSubObjectParentList(self)
  local parent = parent_list[#parent_list]
  local orig_id, idx = id, 1
  while table.find(parent, "id", id) or id == "" do
    idx = idx + 1
    id = orig_id .. tostring(idx)
  end
  self.id = id
end
function ConversationPhrase:OnAfterEditorNew(root, ged, is_paste)
  if is_paste then
    self:GenerateId(root)
    self.KeywordT = g_ConversationTs[self.Keyword] or T(RandomLocId(), self.Keyword)
  else
    self.Lines = {
      ConversationLine:new()
    }
  end
end
function ConversationPhrase:OnEditorSetProperty(prop_id, old_value, ged)
  local conversation = ged:ResolveObj("SelectedPreset")
  if prop_id == "Keyword" and self.Keyword ~= "" then
    if not self.id then
      self:GenerateId(conversation)
    end
    self.KeywordT = g_ConversationTs[self.Keyword] or T(RandomLocId(), self.Keyword)
  elseif prop_id == "Tag" then
    self.Align = self.Tag == "" and "right" or "left"
    self.TagT = self.Tag == "" and "" or g_ConversationTs[self.Tag] or T(RandomLocId(), self.Tag)
  end
end
function ConversationPhrase:GetError()
  if self.VariantPhrase and self.ShowDisabled then
    return "Variant phrases can't have the 'Show disabled' property"
  end
end
function ConversationPhrase:GetPhraseRolloverTextAuto(game)
  local rollover_texts = {}
  for _, cond in ipairs(self.Conditions or empty_table) do
    local text = cond:HasMember("GetUIText") and not cond:GetError() and cond:GetUIText(self, false, game)
    if text and text ~= "" then
      table.insert(rollover_texts, 1, text)
    end
  end
  for _, eff in ipairs(self.Effects or empty_table) do
    local text = eff:HasMember("GetUIText") and not eff:GetError() and eff:GetUIText(self, false, game)
    if text and text ~= "" then
      table.insert(rollover_texts, 1, text)
    end
  end
  if next(rollover_texts) then
    if game then
      return table.concat(rollover_texts, "\n")
    else
      return _InternalTranslate(table.concat(rollover_texts, "\n"))
    end
  else
    return ""
  end
end
function ConversationPhrase:GetPhraseConditionRolloverTextAuto(game)
  local rollover_texts = {}
  for _, cond in ipairs(self.Conditions or empty_table) do
    local text = cond:HasMember("GetPhraseTopRolloverText") and not cond:GetError() and cond:GetPhraseTopRolloverText(self, false, game)
    if text and text ~= "" then
      table.insert(rollover_texts, 1, text)
    end
  end
  for _, eff in ipairs(self.Effects or empty_table) do
    local text = eff:HasMember("GetPhraseTopRolloverText") and not eff:GetError() and eff:GetPhraseTopRolloverText(self, false, game)
    if text and text ~= "" then
      table.insert(rollover_texts, 1, text)
    end
  end
  if next(rollover_texts) then
    if game then
      return table.concat(rollover_texts, "\n")
    else
      return _InternalTranslate(table.concat(rollover_texts, "\n"))
    end
  else
    return ""
  end
end
function ConversationPhrase:__fromluacode(table, arr)
  local obj = PropertyObject.__fromluacode(self, table, arr)
  if g_ConversationTs[obj.Keyword] then
    obj.KeywordT = g_ConversationTs[obj.Keyword]
  end
  if g_ConversationTs[obj.Tag] then
    obj.TagT = g_ConversationTs[obj.Tag]
  end
  if obj.Keyword ~= "" then
    g_ConversationTs[obj.Keyword] = obj.KeywordT
  end
  if obj.Tag ~= "" then
    g_ConversationTs[obj.Tag] = obj.TagT
  end
  return obj
end
function ConversationPhrase:GetReadableText(indentation_level)
  local diffText = {}
  diffText[#diffText + 1] = string.format("%s[Keyword: %s]", string.rep("\t", indentation_level), TDevModeGetEnglishText(self.KeywordT))
  if self.Lines then
    for _, line in ipairs(self.Lines) do
      diffText[#diffText + 1] = line:GetReadableText(indentation_level + 1)
    end
  end
  for _, phrase in ipairs(self) do
    diffText[#diffText + 1] = phrase:GetReadableText(indentation_level + 1)
  end
  return table.concat(diffText, "\n")
end
if FirstLoad then
  g_ConversationTs = {}
end
DefineClass.ConversationStoryBranchIcons = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "Preset",
      id = "icon",
      editor = "ui_image",
      default = false,
      image_preview_size = 20
    }
  },
  GlobalMap = "StoryBranchIcons"
}
DefineClass.CraftOperationsRecipeDef = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "Ingredients",
      name = "Ingredients",
      editor = "nested_list",
      default = false,
      base_class = "RecipeIngredient"
    },
    {
      id = "ResultItem",
      name = "Result Item",
      editor = "nested_obj",
      default = false,
      base_class = "RecipeIngredient"
    },
    {
      id = "CraftTime",
      name = "Craft Time",
      help = "The time in hours needed to craft the item from a crafter with skill 50",
      editor = "number",
      default = false,
      slider = true,
      min = 0,
      max = 360000
    },
    {
      category = "Conditions",
      id = "RequiredCrafter",
      name = "RequiredCrafter",
      help = "Required Crafter",
      editor = "preset_id",
      default = false,
      preset_class = "UnitDataCompositeDef",
      preset_filter = function(preset, obj)
        return IsMerc(gv_UnitData[preset.id])
      end
    },
    {
      category = "Conditions",
      id = "QuestConditions",
      editor = "nested_list",
      default = false,
      base_class = "QuestConditionBase"
    },
    {
      category = "General",
      id = "btnAddItem",
      editor = "buttons",
      default = false,
      buttons = {
        {
          name = "Add Ingredients To Current Unit",
          func = "UIPlaceIngredientsInInventory"
        }
      },
      template = true
    }
  },
  HasSortKey = true,
  HasParameters = true,
  GlobalMap = "CraftOperationsRecipes",
  EditorMenubarName = "Craft Operations Recipes Editor",
  EditorShortcut = "",
  EditorIcon = "CommonAssets/UI/Icons/auction court hammer judge justice law.png",
  EditorMenubar = "Scripting",
  EditorMenubarSortKey = "4061"
}
DefineClass.EliteEnemyName = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "name",
      name = "Name",
      editor = "text",
      default = false,
      translate = true
    }
  },
  GlobalMap = "EliteEnemyNames"
}
DefineClass.Email = {
  __parents = {
    "MsgReactionsPreset"
  },
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "Email",
      id = "title",
      name = "Title",
      editor = "text",
      default = false,
      translate = true
    },
    {
      category = "Email",
      id = "sender",
      name = "Sender",
      editor = "text",
      default = false,
      translate = true
    },
    {
      category = "Email",
      id = "body",
      name = "Body",
      editor = "text",
      default = false,
      translate = true,
      lines = 4,
      max_lines = 20
    },
    {
      category = "Email",
      id = "label",
      name = "Label",
      editor = "combo",
      default = false,
      items = function(self)
        return PresetGroupCombo("EmailLabel", "Default")
      end
    },
    {
      category = "Email",
      id = "attachments",
      name = "Attachments",
      editor = "nested_list",
      default = false,
      base_class = "EmailAttachment"
    },
    {
      category = "Reactions",
      id = "sendConditions",
      name = "Send Conditions",
      help = "If these conditions exist they will be evaluated periodically for one time emails.",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    },
    {
      category = "Reactions",
      id = "repeatable",
      name = "Repeatable",
      editor = "bool",
      default = false
    },
    {
      category = "Reactions",
      id = "delayAfterCombat",
      name = "Delay After Combat",
      help = "When an email should be send during combat. It is instead send after the combat ends.",
      editor = "bool",
      default = true
    }
  },
  GlobalMap = "Emails",
  EditorMenubarName = "Emails",
  EditorIcon = "CommonAssets/UI/Icons/email envelope mail message.png",
  EditorMenubar = "Scripting",
  EditorMenubarSortKey = "4000"
}
DefineClass.EmailLabel = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "name",
      name = "Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "hiddenWhenEmpty",
      name = "Hidden when empty",
      help = "Hides the label if there are no received emails marked with it",
      editor = "bool",
      default = false
    }
  },
  GlobalMap = "EmailLabels"
}
DefineClass.EmploymentHistoryLine = {
  __parents = {
    "MsgReactionsPreset"
  },
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "Preset",
      id = "help",
      help = [[
Caution:
1. Renaming Ids or deleting presets will invalidate the related history logs from older saves.
2. Do NOT add Translations to the save(inside AddEmploymentHistoryLog) or else when switching langauages those words/phrases won't be translated.
	 Instead add ids and other indicative vars to the context and then use them in the GetText function.]],
      editor = "help",
      default = false
    },
    {
      id = "text",
      name = "Text",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "GetText",
      name = "GetText",
      editor = "func",
      default = function(self, context)
        return T({
          self.text,
          context
        })
      end,
      params = "self, context"
    }
  },
  GlobalMap = "EmploymentHistoryLines",
  EditorMenubarName = "Employment History Line",
  EditorMenubar = "Scripting",
  EditorMenubarSortKey = "5010"
}
DefineClass.EnemyRole = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "DisplayName",
      name = "DisplayName",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "Icon",
      name = "Icon",
      editor = "ui_image",
      default = false
    },
    {
      id = "BadgeIcon",
      name = "BadgeIcon",
      editor = "ui_image",
      default = false
    }
  }
}
DefineClass.EnemySquads = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "displayName",
      name = "Squad Display Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "SquadPowerRange",
      name = "Squad Power Range",
      help = "Shows min squad power: lowestPowerUnits * lowestAmountSpawned. And max squad power: highestPowerUnits * higestAmountSpawned",
      editor = "text",
      default = false,
      dont_save = true,
      read_only = true
    },
    {
      id = "Units",
      editor = "nested_list",
      default = false,
      base_class = "EnemySquadUnit",
      auto_expand = true
    },
    {
      category = "Bombard",
      id = "Bombard",
      editor = "bool",
      default = false
    },
    {
      category = "Diamond Briefcase",
      id = "DiamondBriefcase",
      name = "Has Diamond Shipment",
      editor = "bool",
      default = false
    },
    {
      category = "Diamond Briefcase",
      id = "DiamondBriefcaseCarrier",
      name = "Carrier",
      help = "Valid carries are unit defs with only a single unit to be spawned from them. The chance to spawn should be set to 100%",
      editor = "choice",
      default = false,
      items = function(self)
        return self:GetValidCarriers()
      end
    },
    {
      category = "Bombard",
      id = "BombardOrdnance",
      name = "Ordnance",
      editor = "preset_id",
      default = false,
      no_edit = function(self)
        return not self.Bombard
      end,
      preset_class = "InventoryItemCompositeDef",
      preset_filter = function(preset, obj)
        return preset.object_class == "Ordnance"
      end
    },
    {
      category = "Bombard",
      id = "BombardShots",
      name = "Num Shells",
      editor = "number",
      default = 1,
      no_edit = function(self)
        return not self.Bombard
      end,
      min = 1
    },
    {
      category = "Bombard",
      id = "BombardAreaRadius",
      name = "Area Radius",
      help = "in tiles",
      editor = "number",
      default = 3,
      no_edit = function(self)
        return not self.Bombard
      end,
      min = 1,
      max = 99
    },
    {
      category = "Bombard",
      id = "BombardLaunchOffset",
      name = "Launch Offset",
      help = "defines the direction of the fall together with Launch Angle; if left as 0 the shells will fall directly down",
      editor = "number",
      default = 5000,
      no_edit = function(self)
        return not self.Bombard
      end,
      scale = "m"
    },
    {
      category = "Bombard",
      id = "BombardLaunchAngle",
      name = "Launch Angle",
      help = "defines the direction of the fall together with Launch Offset",
      editor = "number",
      default = 1200,
      no_edit = function(self)
        return not self.Bombard
      end,
      scale = "deg"
    },
    {
      category = "Patrol",
      id = "patrolling",
      name = "Patrolling",
      help = "The squad will be set to travel between the specified waypoints when spawned.",
      editor = "bool",
      default = false
    },
    {
      category = "Patrol",
      id = "waypoints",
      name = "Waypoints",
      editor = "string_list",
      default = {},
      no_edit = function(self)
        return not self.patrolling
      end,
      item_default = "",
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      category = "AutoResolveTest",
      id = "playerSquadAutoTest",
      name = "Player Squad",
      help = "Leave as false to use current squad.",
      editor = "combo",
      default = false,
      items = function(self)
        return EnemySquadsComboItems()
      end
    },
    {
      category = "AutoResolveTest",
      id = "buttonTestInAutoResolve",
      editor = "buttons",
      default = false,
      buttons = {
        {
          name = "Test in AutoResolve",
          func = "TestInAutoResolve"
        }
      },
      template = true
    }
  },
  GlobalMap = "EnemySquadDefs",
  EditorIcon = "CommonAssets/UI/Icons/group",
  EditorMenubar = "Scripting",
  EditorMenubarSortKey = "4010",
  EditorPreview = Untranslated("<Preview>")
}
function EnemySquads:GetError()
  if #(self.Units or "") == 0 then
    return "Add units in squad"
  end
end
function EnemySquads:GetValidCarriers()
  local arr = {
    {}
  }
  for i, u in ipairs(self.Units) do
    if u.UnitCountMax == 1 and u.UnitCountMin == 1 then
      local name = u:GetEditorView()
      local item = {name = name, value = i}
      arr[#arr + 1] = item
    end
  end
  return arr
end
function EnemySquads:GetPreview()
  local texts = {}
  for _, squad_unit_def in ipairs(self.Units) do
    texts[#texts + 1] = squad_unit_def:GetEditorView()
  end
  return table.concat(texts, ", ")
end
function EnemySquads:GetSquadPowerRange()
  local minSquadPower = 0
  local maxSquadPower = 0
  for _, unitGroups in ipairs(self.Units) do
    local lowestPower, highestPower
    local minCount = unitGroups.UnitCountMin
    local maxCount = unitGroups.UnitCountMax
    for _, unitData in ipairs(unitGroups.weightedList) do
      local unitPreset = UnitDataDefs[unitData.unitType]
      if unitPreset then
        local power = GetPowerOfUnit(unitPreset, "noMods")
        if not lowestPower or lowestPower > power then
          lowestPower = power
        end
        if not highestPower or highestPower < power then
          highestPower = power
        end
      end
    end
    minSquadPower = minSquadPower + lowestPower * minCount
    maxSquadPower = maxSquadPower + highestPower * maxCount
  end
  return tostring(minSquadPower) .. " - " .. tostring(maxSquadPower)
end
function EnemySquads:TestInAutoResolve(root, prop_id, ged)
  if not gv_SatelliteView then
    print("Must be in sat view")
    return
  end
  RevealAllSectors()
  local dlg = GetSatelliteDialog()
  local selected_squad = dlg.selected_squad
  if not self.playerSquadAutoTest then
    NetEchoEvent("CheatSatelliteTeleportSquad", selected_squad.UniqueId, "B1")
  end
  local sector = gv_Sectors.A1
  sector.Side = "player1"
  local allySquads, enemySquads = GetSquadsInSector(sector.Id, nil, "includeMilitia")
  for _, squad in ipairs(enemySquads) do
    RemoveSquad(squad)
  end
  for _, squad in ipairs(allySquads) do
    RemoveSquad(squad)
  end
  GenerateEnemySquad(self.id, sector.Id, "Effect", nil, "enemy1")
  if self.playerSquadAutoTest then
    local isMilitia = EnemySquadDefs[self.playerSquadAutoTest] and EnemySquadDefs[self.playerSquadAutoTest].group == "MilitiaAutoresolveTest"
    GenerateEnemySquad(self.playerSquadAutoTest, sector.Id, "Effect", nil, isMilitia and "ally" or "player1", isMilitia)
  else
    NetEchoEvent("CheatSatelliteTeleportSquad", selected_squad.UniqueId, sector.Id)
  end
end
DefineClass.EntityVariation = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "Entities",
      editor = "string_list",
      default = {},
      item_default = "",
      items = function(self)
        return table.keys(EntityData)
      end
    }
  }
}
DefineClass.GameTerm = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "Description",
      editor = "text",
      default = false,
      translate = true
    }
  }
}
DefineClass.GuardpostObjective = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "Sector",
      name = "Sector",
      help = "The sector on which badges should be placed. (optional)",
      editor = "combo",
      default = false,
      items = function(self)
        return GetGuardpostCampaignSectorsCombo()
      end
    },
    {
      id = "Description",
      name = "Description",
      editor = "text",
      default = false,
      translate = true,
      max_lines = 2
    },
    {
      id = "DescriptionCompleted",
      name = "DescriptionCompleted",
      editor = "text",
      default = false,
      translate = true,
      max_lines = 2
    },
    {
      id = "DescriptionFailed",
      name = "DescriptionFailed",
      editor = "text",
      default = false,
      translate = true,
      max_lines = 2
    },
    {
      id = "OnComplete",
      name = "OnComplete",
      editor = "nested_list",
      default = false,
      base_class = "Effect"
    },
    {
      id = "OnRegenerate",
      name = "OnRegenerate",
      editor = "nested_list",
      default = false,
      base_class = "Effect"
    }
  },
  GlobalMap = "GuardpostObjectives",
  EditorMenubarName = "Guardpost Objectives",
  EditorMenubar = "Scripting",
  EditorMenubarSortKey = "4040"
}
DefineClass.HistoryOccurence = {
  __parents = {
    "MsgReactionsPreset"
  },
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "text",
      name = "Text",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "repeatable",
      name = "Repeatable",
      editor = "bool",
      default = false
    },
    {
      id = "GetText",
      name = "GetText",
      editor = "func",
      default = function(self, context)
        return T({
          self.text,
          context
        })
      end,
      params = "self, context"
    },
    {
      id = "conditions",
      name = "Conditions",
      editor = "nested_list",
      default = false,
      no_edit = function(self)
        return self.repeatable
      end,
      base_class = "Condition"
    },
    {
      id = "sector",
      name = "Sector",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    }
  },
  GlobalMap = "HistoryOccurences",
  EditorMenubarName = "History Occurence",
  EditorMenubar = "Scripting",
  EditorMenubarSortKey = "5000"
}
DefineClass.IMPErrorNetClientTexts = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "text",
      editor = "text",
      default = false,
      translate = true
    }
  }
}
DefineClass.IMPErrorPswdTexts = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "text",
      editor = "text",
      default = false,
      translate = true
    }
  }
}
DefineClass.IdleStyle = {
  __parents = {
    "AnimationStyle"
  },
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "Animations",
      id = "Animations",
      editor = "nested_list",
      default = false,
      base_class = "AnimationStyleAnim",
      format = "<Animation> <color 45 138 138>(Weight: <Weight>)"
    },
    {
      category = "Animations",
      id = "Start",
      editor = "combo",
      default = false,
      items = function(self)
        return self:AnimationsCombo()
      end
    },
    {
      category = "Animations",
      id = "Stop",
      editor = "combo",
      default = false,
      items = function(self)
        return self:AnimationsCombo()
      end
    }
  },
  PresetClass = "AnimationStyle"
}
function IdleStyle:GetRandomAnim(unit)
  return self:GetRandomAnimId("Animations", unit)
end
function IdleStyle:GetMainAnim()
  return self:GetMainAnimId("Animations")
end
function IdleStyle:OnPreSave()
  self:GenerateTotalWeight("Animations")
end
function IdleStyle:HasAnimation(anim)
  return table.find(self.Animations, "Animation", anim) and true or false
end
function GetIdleStyleCombo(set)
  return GetAnimationStyleCombo(set, "IdleStyle")
end
DefineClass.ImpAnswer = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "answer",
      name = "Text",
      editor = "text",
      default = false,
      translate = true,
      lines = 1,
      max_lines = 5
    },
    {
      id = "is_default",
      name = "Default answer",
      editor = "bool",
      default = false
    },
    {
      id = "stats_changes",
      name = "Stat changes",
      editor = "nested_list",
      default = false,
      base_class = "ImpStatChange"
    },
    {
      id = "perk_changes",
      name = "Perk changes",
      editor = "nested_list",
      default = false,
      base_class = "ImpPerkChange"
    }
  }
}
function ImpAnswer:GetEditorView()
  local texts = {}
  local txt = _InternalTranslate(self.answer or "")
  if txt and txt ~= "" then
    txt = utf8.len(txt) <= 30 and txt or utf8.sub(txt, 1, 30) .. "..."
    texts[#texts + 1] = Untranslated(" <color 150 150 100>[" .. txt .. "]</color> ")
  end
  for _, stat in ipairs(self.stats_changes) do
    texts[#texts + 1] = stat:GetEditorView()
  end
  for _, perk in ipairs(self.perks_changes) do
    texts[#texts + 1] = perk:GetEditorView()
  end
  return table.concat(texts, " ")
end
DefineClass.ImpPerkChange = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "perk",
      name = "Perk",
      editor = "preset_id",
      default = false,
      template = true,
      preset_class = "CharacterEffectCompositeDef",
      preset_filter = function(preset, obj)
        return preset.object_class and IsKindOf(g_Classes[preset.object_class], "Perk")
      end
    },
    {
      id = "change",
      name = "Value change",
      editor = "number",
      default = 0
    }
  }
}
function ImpPerkChange:GetEditorView()
  return T({
    202072264314,
    "<perk>:<change>",
    self
  })
end
DefineClass.ImpQuestionDef = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "question",
      name = "Question",
      editor = "text",
      default = false,
      translate = true,
      lines = 1,
      max_lines = 10
    },
    {
      id = "answers",
      name = "Answers",
      editor = "nested_list",
      default = false,
      base_class = "ImpAnswer"
    }
  },
  HasSortKey = true,
  GlobalMap = "ImpQuestions",
  EditorMenubarName = "IMP Questions Editor",
  EditorIcon = "CommonAssets/UI/Icons/conversation discussion language.png",
  EditorMenubar = "Characters"
}
DefineClass.ImpStatChange = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "stat",
      name = "Stat",
      editor = "combo",
      default = false,
      items = function(self)
        return GetUnitStatsComboTranslated()
      end
    },
    {
      id = "change",
      name = "Value change",
      editor = "number",
      default = 0
    }
  }
}
function ImpStatChange:GetEditorView()
  return T({
    818103125130,
    "<stat>:<change>",
    self
  })
end
DefineClass.IntelPointOfInterestDef = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "Text",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "Icon",
      editor = "ui_image",
      default = false
    }
  },
  GlobalMap = "IntelPOIPresets"
}
DefineClass.LaddersMaterials = {
  __parents = {
    "SlabMaterials"
  },
  __generated_by_class = "ClassAsGroupPresetDef",
  group = "LaddersMaterials"
}
DefineClass.LightmodelSelectionRule = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "region",
      name = "Region",
      editor = "choice",
      default = "any",
      items = function(self)
        return PresetsCombo("GameStateDef", "region", "any")
      end
    },
    {
      id = "weather",
      name = "Weather",
      editor = "choice",
      default = "any",
      items = function(self)
        return PresetsCombo("GameStateDef", "weather", "any")
      end
    },
    {
      id = "tod",
      name = "Time of Day",
      editor = "choice",
      default = "any",
      items = function(self)
        return PresetsCombo("GameStateDef", "time of day", "any")
      end
    },
    {
      id = "lightmodel",
      name = "Lightmodel",
      editor = "preset_id",
      default = "ArtPreview",
      preset_class = "LightmodelPreset"
    },
    {
      id = "priority",
      name = "Priority",
      editor = "number",
      default = 100,
      step = 100,
      slider = true,
      min = 100,
      max = 500
    }
  },
  GlobalMap = "LightmodelSelectionRules",
  EditorMenubarName = "Lightmodel Selection Rules"
}
function LightmodelSelectionRule:GetEditorView()
  local tag = function(value, preset_table)
    if value == "any" then
      return "any"
    end
    local rgb = table.concat({
      GetRGB(preset_table[value].Color)
    }, " ")
    return "<color " .. rgb .. ">" .. value .. "</color>"
  end
  return tag(self.region, GameStateDefs) .. " - " .. tag(self.weather, GameStateDefs) .. " - " .. tag(self.tod, GameStateDefs) .. (self.priority > 100 and string.format(" (priority: %s)", self.priority) or "") .. "<tab 300>" .. self.lightmodel
end
function LightmodelSelectionRule:SortPresets()
  local presets = Presets[self.PresetClass or self.class] or empty_table
  local cmp = function(a, b)
    if a == "any" and b == "any" then
      return false
    end
    if a == "any" then
      return true
    end
    if b == "any" then
      return false
    end
    return tostring(a) < tostring(b)
  end
  for _, group in ipairs(presets) do
    table.sort(group, function(a, b)
      if a.priority == b.priority then
        if a.region == b.region then
          if a.weather == b.weather then
            return cmp(a.tod, b.tod)
          end
          return cmp(a.weather, b.weather)
        end
        return cmp(a.region, b.region)
      end
      return cmp(a.priority, b.priority)
    end)
  end
  ObjModified(presets)
end
function LightmodelSelectionRule:OnEditorSelect(selected, ged)
  local RebuildAttaches = function()
    SuspendPassEdits("rebuild autoattaches")
    MapForEach("map", "AutoAttachObject", function(o)
      o:SetAutoAttachMode(o.auto_attach_mode)
    end)
    ResumePassEdits("rebuild autoattaches")
  end
  if selected then
    local state_descr = {}
    if self.tod ~= "any" then
      state_descr[self.tod] = true
    end
    if self.weather ~= "any" then
      state_descr[self.weather] = true
    end
    if self.region ~= "any" then
      state_descr[self.region] = true
    end
    local _, old_values = ChangeGameStateExclusive(state_descr)
    if not LightmodelSelectionRuleGameState then
      LightmodelSelectionRuleGameState = old_values
    end
    gv_ForceWeatherTodRegion = {
      tod = self.tod,
      weather = self.weather,
      region = self.region
    }
    if LightmodelSelectionRuleThread then
      DeleteThread(LightmodelSelectionRuleThread)
    end
    LightmodelSelectionRuleThread = CreateRealTimeThread(function()
      Sleep(300)
      SetLightmodelOverride(false, self.lightmodel)
      RebuildAttaches()
      LightmodelSelectionRuleThread = false
    end)
  else
    if LightmodelSelectionRuleGameState then
      ChangeGameState(LightmodelSelectionRuleGameState)
      LightmodelSelectionRuleGameState = false
      gv_ForceWeatherTodRegion = false
    end
    if LightmodelSelectionRuleThread then
      DeleteThread(LightmodelSelectionRuleThread)
    end
    LightmodelSelectionRuleThread = CreateRealTimeThread(function()
      Sleep(300)
      SetLightmodelOverride(false, false)
      RebuildAttaches()
      LightmodelSelectionRuleThread = false
    end)
  end
end
function SelectLightmodel(region, weather, tod)
  local best_match, best_match_quality = false, 0
  for id, rule in pairs(LightmodelSelectionRules) do
    local match_quality = 0
    if rule.region == region then
      match_quality = match_quality + 100
    elseif rule.region == "any" then
      match_quality = match_quality + 10
    else
      match_quality = match_quality - 100
    end
    if rule.weather == weather then
      match_quality = match_quality + 90
    elseif rule.weather == "any" then
      match_quality = match_quality + 9
    else
      match_quality = match_quality - 100
    end
    if rule.tod == tod then
      match_quality = match_quality + 80
    elseif rule.tod == "any" then
      match_quality = match_quality + 8
    else
      match_quality = match_quality - 100
    end
    match_quality = match_quality * rule.priority / 100
    if best_match_quality < match_quality then
      best_match, best_match_quality = id, match_quality
    end
  end
  return LightmodelSelectionRules[best_match].lightmodel
end
if FirstLoad then
  LightmodelSelectionRuleGameState = false
  LightmodelSelectionRuleThread = false
end
function ChangeGameStateExclusive(state_descr)
  local state_types = {}
  for state_name, set in pairs(state_descr) do
    local map_state = GameStateDefs[state_name]
    if not map_state then
      return
    end
    if state_types[map_state.group] then
    end
    state_types[map_state.group] = true
  end
  for id, state in pairs(GameStateDefs) do
    if state_types[state.group] and not state_descr[id] then
      state_descr[id] = false
    end
  end
  local old_values = {}
  for id in pairs(GameStateDefs) do
    old_values[id] = GameState[id]
  end
  return ChangeGameState(state_descr), old_values
end
DefineClass.LoadingScreenHint = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "text",
      editor = "text",
      default = false,
      translate = true,
      lines = 4
    }
  },
  HasSortKey = true,
  GlobalMap = "LoadingScreenHints",
  EditorMenubarName = "Loading Screen Hints",
  EditorIcon = "CommonAssets/UI/Icons/friends group presentation.png",
  EditorMenubar = "Scripting"
}
DefineClass.LootEntryInventoryItem = {
  __parents = {
    "LootDefEntry"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Loot",
      id = "item",
      name = "Item",
      editor = "choice",
      default = "",
      items = function(self)
        return InventoryItemCombo
      end
    },
    {
      category = "Loot",
      id = "stack_min",
      name = "Stack (Min)",
      editor = "number",
      default = 0,
      min = 0,
      max = 1000000
    },
    {
      category = "Loot",
      id = "stack_max",
      name = "Stack (Max)",
      editor = "number",
      default = 0,
      min = 0,
      max = 1000000
    },
    {
      category = "Loot",
      id = "Condition",
      name = "Condition",
      help = "Item's condition in percents",
      editor = "number",
      default = 100,
      slider = true,
      min = 1,
      max = 100
    },
    {
      category = "Loot",
      id = "RandomizeCondition",
      name = "Randomize Condition",
      help = "Randomize  item condition within +/- 30",
      editor = "bool",
      default = false
    },
    {
      category = "Loot",
      id = "Double",
      name = "Double",
      help = "Double or halve the item depending on difficulty and chances (25% on easy to double, 50% on hard to halve)",
      editor = "bool",
      default = false
    },
    {
      category = "Conditions",
      id = "generate_chance",
      name = "Generate Chance",
      help = "Generate chance is used instead of creating new loot def entry with this item and empty table.",
      editor = "number",
      default = 100,
      min = 0,
      max = 100
    },
    {
      id = "guaranteed",
      name = "Guaranteed Drop",
      editor = "bool",
      default = false
    },
    {
      id = "drop_chance_mod",
      name = "Drop Chance Modifier",
      editor = "number",
      default = 100,
      min = 0
    },
    {
      id = "BaseDropChance",
      name = "Base Drop Chance",
      editor = "number",
      default = 0,
      dont_save = true,
      read_only = true
    },
    {
      id = "DropChance",
      editor = "number",
      default = 0,
      read_only = true
    }
  },
  EntryView = Untranslated("<color 75 105 198><item><stack_suffix>")
}
function LootEntryInventoryItem:Setitem(value)
  self.item = value
  if #(value or "") > 0 and InventoryItemDefs[value].object_class == "QuestItem" then
    self.guaranteed = true
  end
end
function LootEntryInventoryItem:GenerateLoot(looter, looted, seed, items)
  if self.generate_chance <= 0 then
    return
  elseif self.generate_chance < 100 then
    local rand
    rand, seed = BraidRandom(seed, 100)
    if rand >= self.generate_chance then
      return
    end
  end
  local amount
  local min, max = self:GetStackSize()
  if max <= min then
    amount = max
  else
    amount, seed = BraidRandom(seed, max - min + 1)
    amount = min + amount
  end
  if self.Double then
    local roll
    roll, seed = BraidRandom(seed, 100)
    local value = GameDifficulties[Game.game_difficulty]:ResolveValue("chanceToHalveDoubleLoot") or 0
    if roll < value then
      amount = amount / 2
    end
  end
  local chance = self:GetDropChance()
  local maxPossibleWeaponCondPenalty = Game and GameDifficulties[Game.game_difficulty]:ResolveValue("maxPossibleWeaponCondPenalty") or 0
  local lootConditionRandomization = const.Weapons.LootConditionRandomization
  while 0 < amount do
    local item = PlaceInventoryItem(self.item)
    item.drop_chance = chance
    item.guaranteed_drop = self.guaranteed
    if IsKindOf(item, "InventoryStack") then
      item.Amount = Min(amount, item.MaxStacks)
      amount = amount - item.Amount
    else
      amount = amount - 1
      local condition = self.Condition
      if self.RandomizeCondition then
        local rnd
        rnd, seed = BraidRandom(seed, 2 * lootConditionRandomization)
        local diffRnd = 0
        diffRnd, seed = -BraidRandom(seed, maxPossibleWeaponCondPenalty)
        condition = Clamp(condition - lootConditionRandomization + rnd + diffRnd, 1, 100)
      end
      item.Condition = condition
      NetUpdateHash("ItemGenerated", item.class, item.Condition)
    end
    items[#items + 1] = item
  end
end
function LootEntryInventoryItem:ListChances(items, env, chance)
  local item
  local min, max = self:GetStackSize()
  if 1 < min or 1 < max then
    item = string.format("Item: %s (%d-%d)", self.item, Max(1, self.stack_min), Max(self.stack_min, self.stack_max))
  else
    item = string.format("Item: %s", self.item)
  end
  items[item] = (items[item] or 0.0) + chance
end
function LootEntryInventoryItem:GetBaseDropChance()
  local template = InventoryItemDefs[self.item]
  local class = template and g_Classes[template.object_class]
  return class and class.base_drop_chance or 0
end
function LootEntryInventoryItem:GetDropChance()
  if self.guaranteed then
    return 100
  end
  local base = self:GetBaseDropChance()
  return MulDivRound(base, self.drop_chance_mod, 100)
end
function LootEntryInventoryItem:Getstack_suffix()
  local min, max = self:GetStackSize()
  if 1 < min or 1 < max then
    return T({
      819375042261,
      "(<min>-<max>)",
      min = min,
      max = max
    })
  end
  return ""
end
function LootEntryInventoryItem:GetStackSize()
  local min = Max(1, self.stack_min)
  local max = Max(min, self.stack_max)
  return min, max
end
DefineClass.LootEntryUpgradedWeapon = {
  __parents = {
    "LootDefEntry"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Loot",
      id = "weapon",
      name = "Weapon",
      editor = "preset_id",
      default = false,
      preset_class = "InventoryItemCompositeDef",
      preset_filter = function(preset, obj)
        return preset.group and preset.group:starts_with("Firearm")
      end
    },
    {
      category = "Loot",
      id = "Condition",
      name = "Condition",
      help = "Item's condition in percents",
      editor = "number",
      default = 100,
      slider = true,
      min = 1,
      max = 100
    },
    {
      category = "Loot",
      id = "RandomizeCondition",
      name = "Randomize Condition",
      help = "Randomize  item condition within +/- 30",
      editor = "bool",
      default = false
    },
    {
      category = "Loot",
      id = "upgrades",
      name = "Upgrades",
      editor = "preset_id_list",
      default = {},
      preset_class = "WeaponComponent",
      item_default = ""
    },
    {
      id = "guaranteed",
      name = "Guaranteed Drop",
      editor = "bool",
      default = false
    },
    {
      id = "drop_chance_mod",
      name = "Drop Chance Modifier",
      editor = "number",
      default = 100,
      min = 0
    },
    {
      id = "BaseDropChance",
      name = "Base Drop Chance",
      editor = "number",
      default = 0,
      dont_save = true,
      read_only = true
    },
    {
      id = "DropChance",
      editor = "number",
      default = 0,
      read_only = true
    }
  },
  EntryView = Untranslated("Upgraded <weapon>")
}
function LootEntryUpgradedWeapon:ListChances(items, env, chance)
  local item = "Weapon " .. (self.weapon or "")
  for i, upgrade in ipairs(self.upgrades) do
    item = string.format("%s%s%s", item, i == 1 and " with upgrades " or ", ", upgrade)
  end
  items[item] = (items[item] or 0.0) + chance
end
function LootEntryUpgradedWeapon:GenerateLoot(looter, looted, seed, items)
  local weapon_items, upgrades = {}, {}
  local weapon = self.weapon
  if not weapon then
    return
  end
  local item = PlaceInventoryItem(self.weapon)
  local condition = self.Condition
  if self.RandomizeCondition then
    local rnd
    rnd, seed = BraidRandom(seed, 2 * const.Weapons.LootConditionRandomization)
    condition = Clamp(condition - const.Weapons.LootConditionRandomization + rnd, 1, 100)
    local diffRnd = 0
    diffRnd, seed = -BraidRandom(seed, GameDifficulties[Game.game_difficulty]:ResolveValue("maxPossibleWeaponCondPenalty") or 0)
    condition = Clamp(condition + diffRnd, 1, 100)
  end
  item.Condition = condition
  NetUpdateHash("ItemGenerated", item.class, item.Condition)
  item.drop_chance = self:GetDropChance()
  item.guaranteed_drop = self.guaranteed
  for _, id in ipairs(self.upgrades) do
    item:SetWeaponComponent(false, id)
  end
  table.insert(items, item)
end
function LootEntryUpgradedWeapon:GetBaseDropChance()
  local template = InventoryItemDefs[self.weapon]
  local class = template and g_Classes[template.object_class]
  return class and class.base_drop_chance or 0
end
function LootEntryUpgradedWeapon:GetDropChance()
  if self.guaranteed then
    return 100
  end
  local base = self:GetBaseDropChance()
  return MulDivRound(base, self.drop_chance_mod, 100)
end
function LootEntryUpgradedWeapon:GetError()
  local compatible
  for _, slot in ipairs(g_Classes[self.weapon].ComponentSlots) do
    for _, component in ipairs(slot.AvailableComponents) do
      compatible = compatible or {}
      compatible[component] = slot
    end
  end
  local slots, errors
  for _, component in ipairs(self.upgrades) do
    if not WeaponComponents[component] then
      errors = errors or {}
      errors[#errors + 1] = "Invalid component: " .. component
    end
    local slot = compatible[component]
    if not slot then
      errors = errors or {}
      errors[#errors + 1] = "Incompatible component: " .. component
    else
      slots = slots or {}
      if slots[slot] then
        errors = errors or {}
        errors[#errors + 1] = "More than one upgrade for slot " .. slot
      end
      slots[slot] = component
    end
  end
  if next(errors) then
    return table.concat(errors, "\n")
  end
end
DefineClass.LootEntryWeaponComponent = {
  __parents = {
    "LootDefEntry"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Loot",
      id = "item",
      name = "Item",
      editor = "choice",
      default = "",
      items = function(self)
        return PresetGroupCombo("WeaponComponent", "Default")
      end
    }
  },
  EntryView = Untranslated("<color 75 105 198><item>")
}
function LootEntryWeaponComponent:GenerateLoot(looter, looted, seed, items)
  items[#items + 1] = self.item
end
function LootEntryWeaponComponent:ListChances(items, env, chance)
  local item = string.format("Item: %s", self.item)
  items[item] = (items[item] or 0.0) + chance
end
DefineClass.MercHireStatus = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "RolloverText",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "icon",
      editor = "ui_image",
      default = false
    }
  }
}
DefineClass.MercNationalities = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "DisplayName",
      name = "Display Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "Icon",
      name = "Icon",
      editor = "ui_image",
      default = false
    }
  }
}
DefineClass.MercSpecializations = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "icon",
      editor = "ui_image",
      default = false
    },
    {
      id = "name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "rolloverText",
      editor = "text",
      default = false,
      translate = true
    }
  }
}
DefineClass.MercStat = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "ShortenedName",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "Icon",
      editor = "ui_image",
      default = false
    }
  }
}
DefineClass.MercTiers = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "name",
      editor = "text",
      default = false,
      translate = true
    }
  }
}
DefineClass.MercTrackedStat = {
  __parents = {
    "MsgReactionsPreset"
  },
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "name",
      name = "Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "description",
      name = "Description",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "hide",
      name = "Hide",
      help = "Don't show in AIM Evaluation Page.",
      editor = "bool",
      default = false
    },
    {
      category = "Reactions",
      id = "DisplayValue",
      name = "Display Value",
      editor = "func",
      default = function(self, merc)
        local value = GetTrackedStat(merc, self.id)
        return value and T({
          227251647374,
          "<value>",
          value = value
        }) or T(555613400236, "-")
      end,
      params = "self, merc"
    }
  },
  HasSortKey = true,
  GlobalMap = "MercTrackedStats",
  EditorMenubarName = "Merc Tracked Stats",
  EditorMenubar = "Scripting"
}
DefineClass.MoraleEffect = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "Weight",
      editor = "number",
      default = 100,
      min = 1
    },
    {
      id = "Cooldown",
      help = "in turns",
      editor = "number",
      default = -1
    },
    {
      id = "GlobalCooldown",
      help = "in turns",
      editor = "number",
      default = -1
    },
    {
      id = "Activation",
      editor = "choice",
      default = "positive",
      items = function(self)
        return {"positive", "negative"}
      end
    },
    {
      id = "AppliedTo",
      editor = "choice",
      default = "ally",
      items = function(self)
        return {
          "ally",
          "teammate",
          "enemy",
          "custom"
        }
      end
    },
    {
      id = "GetTargetUnit",
      editor = "func",
      default = function(self, team)
      end,
      no_edit = function(self)
        return self.AppliedTo ~= "custom"
      end,
      params = "self, team"
    },
    {
      id = "Activate",
      editor = "func",
      default = function(self, unit)
      end,
      params = "self, unit"
    }
  },
  GlobalMap = "MoraleEffects",
  EditorMenubar = "Combat"
}
DefineClass.MoveStyle = {
  __parents = {
    "AnimationStyle"
  },
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "Animations",
      id = "Move",
      editor = "nested_list",
      default = false,
      base_class = "AnimationStyleAnim",
      format = "<Animation> <color 45 138 138>(Weight: <Weight>)"
    },
    {
      category = "Animations",
      id = "Idle",
      editor = "nested_list",
      default = false,
      base_class = "AnimationStyleAnim",
      format = "<Animation> <color 45 138 138>(Weight: <Weight>)"
    },
    {
      category = "Animations",
      id = "MoveStart",
      editor = "combo",
      default = false,
      items = function(self)
        return self:AnimationsCombo()
      end
    },
    {
      category = "Animations",
      id = "MoveStart_Left",
      editor = "combo",
      default = false,
      items = function(self)
        return self:AnimationsCombo()
      end
    },
    {
      category = "Animations",
      id = "MoveStart_Right",
      editor = "combo",
      default = false,
      items = function(self)
        return self:AnimationsCombo()
      end
    },
    {
      category = "Animations",
      id = "MoveStop_FootLeft",
      editor = "combo",
      default = false,
      items = function(self)
        return self:AnimationsCombo()
      end
    },
    {
      category = "Animations",
      id = "MoveStop_FootRight",
      editor = "combo",
      default = false,
      items = function(self)
        return self:AnimationsCombo()
      end
    },
    {
      category = "Animations",
      id = "TurnOnSpot_Left",
      editor = "combo",
      default = false,
      items = function(self)
        return self:AnimationsCombo()
      end
    },
    {
      category = "Animations",
      id = "TurnOnSpot_Right",
      editor = "combo",
      default = false,
      items = function(self)
        return self:AnimationsCombo()
      end
    },
    {
      id = "StepFX",
      editor = "combo",
      default = "",
      items = function(self)
        return {
          "",
          "StepWalk",
          "StepRun"
        }
      end
    }
  },
  PresetClass = "AnimationStyle"
}
function MoveStyle:GetRandomMoveAnim(unit)
  return self:GetRandomAnimId("Move", unit)
end
function MoveStyle:GetMainMoveAnim()
  return self:GetMainAnimId("Move")
end
function MoveStyle:HasMoveAnim(anim)
  return table.find(self.Move, "Animation", anim) and true or false
end
function MoveStyle:OnPreSave()
  self:GenerateTotalWeight("Move")
end
function GetMoveStyleCombo(set)
  return GetAnimationStyleCombo(set, "MoveStyle")
end
DefineClass.MultiplayerGameType = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "Name",
      editor = "text",
      default = false,
      translate = true
    }
  },
  GlobalMap = "MultiplayerGameTypes"
}
DefineClass.PlayerColor = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "color",
      editor = "color",
      default = 4278190080
    }
  },
  GlobalMap = "PlayerColors"
}
DefineClass.PopupNotification = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "Title",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "Image",
      editor = "ui_image",
      default = false,
      image_preview_size = 100
    },
    {
      id = "Text",
      editor = "text",
      default = false,
      translate = true,
      wordwrap = true,
      lines = 5
    },
    {
      id = "GamepadText",
      editor = "text",
      default = false,
      translate = true,
      wordwrap = true,
      lines = 5
    },
    {
      id = "Actor",
      editor = "combo",
      default = "narrator",
      items = function(self)
        return VoiceActors
      end
    },
    {
      id = "OnceOnly",
      help = "The popup will be shown only once no matter how many times it is called for in effects",
      editor = "bool",
      default = false
    },
    {
      id = "btn_test",
      help = "Shows the pop-up in game",
      editor = "buttons",
      default = false,
      buttons = {
        {name = "Test", func = "Test"}
      }
    },
    {
      id = "Test",
      editor = "func",
      default = function(self)
        ShowPopupNotification(self.id)
      end,
      no_edit = true
    },
    {
      id = "Quest",
      help = "For which quest we store how many times the popup has been shown",
      editor = "preset_id",
      default = false,
      preset_class = "QuestsDef"
    },
    {
      id = "QuestVariable",
      help = "In which quest variable we store how many times the popup has been shown",
      editor = "combo",
      default = "",
      items = function(self)
        return GetQuestsVarsCombo(self.Quest, "Num")
      end
    }
  },
  GlobalMap = "PopupNotifications",
  EditorIcon = "CommonAssets/UI/Icons/blog news newspaper page",
  EditorMenubar = "Scripting",
  EditorMenubarSortKey = "4020"
}
DefineClass.QuestBadgePlacement = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "StoreAsTable",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "BadgeUnit",
      name = "Badge on Unit",
      help = "The unit/group to place the badge on, if it exists on the current map.",
      editor = "combo",
      default = false,
      items = function(self)
        return GridMarkerGroupsCombo()
      end
    },
    {
      id = "BadgePreset",
      name = "Badge Preset",
      editor = "combo",
      default = "DefaultQuestBadge",
      items = function(self)
        return PresetsCombo("BadgePresetDef")()
      end
    },
    {
      id = "Sector",
      name = "Sector",
      help = "The sector on which badges should be placed. (optional)",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "PlaceOnAllOfGroup",
      help = "By default the badge is only placed on the first match.",
      editor = "bool",
      default = false
    }
  }
}
function QuestBadgePlacement:GetEditorView()
  return (self.Sector and Untranslated("Sector: <u(Sector)>", self) or Untranslated("")) .. (self.BadgeUnit and Untranslated(" Unit: <u(BadgeUnit)>", self) or Untranslated(""))
end
DefineClass.QuestNote = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Text",
      editor = "text",
      default = "",
      translate = true,
      lines = 3,
      max_lines = 8
    },
    {
      id = "StoreAsTable",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "Idx",
      editor = "number",
      default = 1,
      read_only = true
    },
    {
      id = "Scouting",
      help = "If set to true then this note can be uncovered by the scouting operation.",
      editor = "bool",
      default = false
    },
    {
      id = "ShowWhenCompleted",
      help = "(NO EFFECT AT THE MOMENT)If set to true the note will become visible, once completed.",
      editor = "bool",
      default = false
    },
    {
      id = "AddInHistory",
      help = "Adds the note in the History when completed.",
      editor = "bool",
      default = false
    },
    {
      category = "Conditionals",
      id = "ShowConditions",
      name = "Show Condition",
      editor = "nested_list",
      default = false,
      base_class = "Condition",
      inclusive = true
    },
    {
      category = "Conditionals",
      id = "HideConditions",
      name = "Hide Condition",
      editor = "nested_list",
      default = false,
      base_class = "Condition",
      inclusive = true
    },
    {
      category = "Conditionals",
      id = "CompletionConditions",
      name = "Completion Condition",
      editor = "nested_list",
      default = false,
      base_class = "Condition",
      inclusive = true
    },
    {
      id = "Badges",
      name = "Badges",
      editor = "nested_list",
      default = false,
      base_class = "QuestBadgePlacement",
      inclusive = true
    }
  }
}
function QuestNote:GetEditorView()
  return Untranslated("(<Idx>)") .. Untranslated(_InternalTranslate(self.Text))
end
function QuestNote:GetWarning()
  if not self.Scouting and not next(self.ShowConditions) and not self.ShowWhenCompleted then
    return "Note without 'scouting' and  'show conditions'."
  end
  if not next(self.HideConditions) and not next(self.CompletionConditions) then
    return "Note without 'hide' and  'complete' conditions."
  end
end
function QuestNote:OnEditorNew(parent, ged, is_paste)
  local maxidx = parent.LastNoteIdx or 0
  self.Idx = maxidx + 1
  parent.LastNoteIdx = self.Idx
end
DefineClass.QuestVarBool = {
  __parents = {
    "QuestVarDeclaration"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Name",
      editor = "text",
      default = false
    },
    {
      id = "Value",
      editor = "bool",
      default = false
    },
    {
      id = "StoreAsTable",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    }
  }
}
function QuestVarBool:GetEditorView()
  return Untranslated("bool <Name> = ") .. Untranslated(tostring(self.Value))
end
DefineClass.QuestVarDeclaration = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "StoreAsTable",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    }
  }
}
function QuestVarDeclaration:GetEditorView()
end
function QuestVarDeclaration:GetError()
  local quest_def = GetParentTableOfKind(self, "QuestsDef")
  local id = quest_def.id
  local variables = quest_def.Variables
  local found_self_name = 0
  for idx, var in ipairs(variables) do
    if var.Name and var.Name == self.Name then
      found_self_name = found_self_name + 1
    end
  end
  if 1 < found_self_name then
    return "Duplicated  variable name.Place choose another!"
  end
end
function QuestVarDeclaration:GetWarning()
  if not LocalStorage.QuestEditorFilter or not LocalStorage.QuestEditorFilter.CheckVars then
    return
  end
  if self.Name == "Completed" or self.Name == "Given" or self.Name == "Failed" or self.Name == "NotStarted" then
    return
  end
  local quest_def = GetParentTableOfKind(self, "QuestsDef")
  local id = quest_def.id
  local res = QuestGatherGameDepending({}, id, self.Name)
  if not res then
    return "Variable not used (checked: conversation, maps, quests, sector events)"
  end
end
function QuestVarDeclaration:OnEditorSetProperty(prop_id, old_value, ged)
  local quest_def = GetParentTableOfKind(self, "QuestsDef")
  local id = quest_def.id
  local quest = QuestGetState(id)
  if rawget(quest, self.Name) == nil then
    SetQuestVar(quest, self.Name, self.Value)
    ObjModified(quest)
  end
end
DefineClass.QuestVarNum = {
  __parents = {
    "QuestVarDeclaration"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Name",
      editor = "text",
      default = false
    },
    {
      id = "Value",
      name = "Value, min",
      editor = "number",
      default = 0
    },
    {
      id = "RandomRangeMax",
      name = "Value, max (optional)",
      help = "If set the starting value will be random number between \"Value, min\" and this number. Both values are inclusive. Leave blank to set value to exactly \"Value, min\".",
      editor = "number",
      default = false
    },
    {
      id = "StoreAsTable",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    }
  }
}
function QuestVarNum:GetEditorView()
  return Untranslated("int <Name> = ") .. Untranslated(tostring(self.Value))
end
function QuestVarNum:GetError()
  if self.RandomRangeMax and self.RandomRangeMax <= self.Value then
    return "Value max must be greater than min"
  end
end
DefineClass.QuestVarTCEState = {
  __parents = {
    "QuestVarDeclaration"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Name",
      editor = "text",
      default = false
    },
    {
      id = "StoreAsTable",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "Value",
      name = "Value",
      editor = "choice",
      default = false,
      no_edit = true,
      items = function(self)
        return {
          true,
          false,
          "done"
        }
      end
    }
  }
}
function QuestVarTCEState:GetEditorView()
  return string.format("TCE %s = %s", self.Name, tostring(self.Value))
end
function QuestVarTCEState:GetWarning()
  if not self.Name then
    return
  end
  local quest_def = GetParentTableOfKind(self, "QuestsDef")
  local tces = quest_def.TCEs
  local used_tce = false
  for _, tce in ipairs(tces) do
    if tce.ParamId == self.Name then
      used_tce = true
      break
    end
  end
  if not used_tce then
    return "TCE var is declared but not used (" .. self.Name .. ")"
  end
end
DefineClass.QuestVarText = {
  __parents = {
    "QuestVarDeclaration"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Name",
      editor = "text",
      default = false
    },
    {
      id = "Value",
      editor = "text",
      default = ""
    },
    {
      id = "StoreAsTable",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    }
  }
}
function QuestVarText:GetEditorView()
  return Untranslated("str <Name> = <Value>")
end
DefineClass.QuestsDef = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "Preset",
      id = "Chapter",
      editor = "combo",
      default = "Landing",
      sort_order = -1,
      items = function(self)
        return PresetsPropCombo("QuestsDef", "Chapter", "Landing")
      end
    },
    {
      category = "Preset",
      id = "QuestGroup",
      editor = "combo",
      default = false,
      items = function(self)
        return QuestGroups
      end
    },
    {
      category = "Preset",
      id = "Variables",
      editor = "nested_list",
      default = false,
      base_class = "QuestVarDeclaration"
    },
    {
      category = "Preset",
      id = "NoteDefs",
      name = "NoteDefs",
      editor = "nested_list",
      default = false,
      no_edit = function(self)
        return self.Hidden
      end,
      base_class = "QuestNote",
      inclusive = true,
      no_descendants = true
    },
    {
      category = "General",
      id = "DevNotes",
      name = "Developer Notes",
      editor = "text",
      default = false,
      wordwrap = true,
      lines = 5
    },
    {
      category = "General",
      id = "DisplayName",
      name = "Display Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      category = "General",
      id = "Image",
      name = "Image",
      editor = "ui_image",
      default = "UI/PDA/Quest/tasks_img_01",
      no_edit = function(self)
        return not self.Main
      end,
      image_preview_size = 200
    },
    {
      category = "General",
      id = "Hidden",
      name = "Hidden",
      help = "If true the quest is never shown in the quest log.",
      editor = "bool",
      default = false
    },
    {
      category = "General",
      id = "Main",
      name = "Main",
      help = "Whether this quest is part of the main quest line.",
      editor = "bool",
      default = false
    },
    {
      id = "Author",
      editor = "preset_id",
      default = false,
      preset_class = "HGMember"
    },
    {
      category = "Status",
      id = "LineVisibleOnGive",
      name = "Line visible on 'given'",
      help = "Showing which log line is automatically set to visible when the quest enters \"given\"",
      editor = "choice",
      default = 0,
      items = function(self)
        return GetQuestNoteLinesCombo(self.id)
      end
    },
    {
      category = "Status",
      id = "EffectOnChangeVarValue",
      name = "Effect On rise bool var",
      editor = "nested_list",
      default = false,
      base_class = "QuestEffectOnStatus",
      inclusive = true,
      format = "<Prop>"
    },
    {
      category = "Triggered Conditional Event",
      id = "TCEs",
      name = "Triggered Conditional Event",
      editor = "nested_list",
      default = false,
      base_class = "TriggeredConditionalEvent",
      inclusive = true
    },
    {
      category = "Triggered Conditional Event",
      id = "KillTCEsConditions",
      name = "Kill TCEs Conditions",
      editor = "nested_list",
      default = false,
      base_class = "Condition",
      inclusive = true
    }
  },
  SingleFile = false,
  GlobalMap = "Quests",
  GedEditor = "QuestsEditor",
  EditorMenubarName = "Quests Editor",
  EditorShortcut = "Ctrl-Alt-Q",
  EditorIcon = "CommonAssets/UI/Icons/magnifier microbes research.png",
  EditorMenubar = "Scripting",
  EditorMenubarSortKey = "3020",
  FilterClass = "QuestEditorFilter"
}
function QuestsDef:OnChangeVarValue(var_id, prev_val, new_val)
  local rise_flag = not prev_val and new_val
  if rise_flag then
    if var_id == "Given" and self.LineVisibleOnGive > 0 then
      local quest = QuestGetState(self.id or "")
      local note_idx = quest.LineVisibleOnGive
      if table.find(quest.NoteDefs or empty_table, "Idx", note_idx) then
        quest.note_lines[note_idx] = GetQuestNoteCampaignTimestamp(quest.note_lines)
      end
      ObjModified(gv_Quests)
    end
    for _, status_effect in ipairs(self.EffectOnChangeVarValue or empty_table) do
      if status_effect.Prop == var_id then
        ExecuteEffectList(status_effect.Effects, QuestGetState(self.id), var_id)
      end
    end
  end
end
function QuestsDef:GetEditorView()
  local quest = gv_Quests and QuestGetState(self.id)
  local texts = {
    Untranslated(self.id)
  }
  if GedQuestRefData then
    local data = GedQuestRefData[self.id]
    if data then
      texts = {
        Untranslated("<color 212 180 64>"),
        Untranslated(self.id),
        Untranslated("</color>")
      }
      if data.from then
        table.insert(texts, Untranslated("<color 0 128 0><literal 1><</color>"))
      end
      if data.to then
        table.insert(texts, Untranslated("<color 196 64 64><literal 1>></color>"))
      end
    end
  end
  local color
  local status = "not_started"
  local given = QuestIsBoolVar(quest, "Given", true)
  local completed = QuestIsBoolVar(quest, "Completed", true)
  local failed = QuestIsBoolVar(quest, "Failed", true)
  if given and not completed and not failed then
    color = RGB(75, 105, 198)
    status = "given"
  end
  if completed and not failed then
    color = RGB(0, 128, 0)
    status = "completed"
  end
  if failed then
    color = RGB(250, 10, 10)
    status = "failed"
  end
  local clr = color and string.format("<color %d %d %d>", GetRGB(color)) or ""
  local uclr = color and "</color>" or ""
  texts[#texts + 1] = Untranslated(clr .. " (" .. status .. ")" .. uclr)
  if self.NoteDefs and 0 < #self.NoteDefs then
    if self.Hidden then
      texts[#texts + 1] = Untranslated("<color 255 0 0> (Notes: " .. #self.NoteDefs .. " " .. " (hidden))</color> ")
    else
      texts[#texts + 1] = Untranslated(" (Notes: " .. #self.NoteDefs .. ")")
    end
  end
  if self.Comment ~= "" then
    texts[#texts + 1] = Untranslated("<color 0 128 0> -- " .. self.Comment)
  end
  return table.concat(texts, "")
end
function QuestsDef:GetError()
  local used = {}
  if self.TCEs then
    for _, tce in ipairs(self.TCEs) do
      if not tce.ParamId then
        return "Add unique Variable to store triggered conditions/effects state in"
      end
      if used[tce.ParamId] then
        return "Variable " .. tce.ParamId .. " is already used choose another one"
      end
      used[tce.ParamId] = true
    end
  end
  if self.PlaceBadge and not self.BadgeUnit then
    return "Place Badge is true, but no target unit provided"
  end
  local duplicateIdx = {}
  local idxSet = {}
  for i, n in ipairs(self.NoteDefs) do
    if idxSet[n.Idx] then
      duplicateIdx[#duplicateIdx + 1] = n.Idx
    end
    idxSet[n.Idx] = true
  end
  if 0 < #duplicateIdx then
    return "Duplicate note ids (merge conflict?) Indices: " .. table.concat(duplicateIdx, ", ")
  end
end
function QuestsDef:OnEditorNew(parent, ged, is_paste, old_id)
  if not is_paste then
    self.KillTCEsConditions = {
      QuestKillTCEsOnCompleted:new({})
    }
    self.Variables = {
      QuestVarBool:new({Name = "Completed"}),
      QuestVarBool:new({Name = "Given"}),
      QuestVarBool:new({Name = "Failed"}),
      QuestVarBool:new({Name = "NotStarted", Value = true})
    }
  else
    self:ChangeQuestId(old_id, self.id)
  end
end
function QuestsDef:OnEditorSetProperty(prop_id, old_value, ged)
  if prop_id == "Id" then
    self:ChangeQuestId(old_value, self.id)
  end
end
function QuestsDef:ChangeQuestId(old_id, new_id)
  self:ForEachSubObject("PropertyObject", function(obj)
    if obj:GetProperty("QuestId") == old_id then
      obj:SetProperty("QuestId", new_id)
    end
  end)
end
function OnMsg.DataLoaded()
  PopulateParentTableCache(Presets.QuestsDef)
end
DefineClass.RecipeDef = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "Ingredients",
      name = "Ingredients",
      editor = "nested_list",
      default = false,
      base_class = "RecipeIngredient"
    },
    {
      id = "ResultItems",
      name = "Result Items",
      editor = "nested_list",
      default = false,
      base_class = "RecipeIngredient"
    },
    {
      id = "Difficulty",
      editor = "number",
      default = 45
    },
    {
      id = "MechanicalRoll",
      name = "Mechanical Roll",
      editor = "bool",
      default = false
    },
    {
      id = "ExplosivesRoll",
      name = "Explosives Roll",
      editor = "bool",
      default = false
    },
    {
      id = "RevertCondition",
      name = "Revert Condition",
      editor = "choice",
      default = "none",
      items = function(self)
        return {
          "none",
          "attacks",
          "damage"
        }
      end
    },
    {
      id = "RevertConditionValue",
      name = "Revert Condition Value",
      editor = "number",
      default = 5,
      no_edit = function(obj)
        return obj.RevertCondition == "none"
      end
    },
    {
      category = "General",
      id = "btnAddItem",
      editor = "buttons",
      default = false,
      buttons = {
        {
          name = "Add Ingredients To Current Unit",
          func = "UIPlaceIngredientsInInventory"
        }
      },
      template = true
    }
  },
  HasParameters = true,
  GlobalMap = "Recipes",
  EditorMenubarName = "Recipes Editor",
  EditorIcon = "CommonAssets/UI/Icons/appliance electrical juicer kitchen mixer.png",
  EditorMenubar = "Scripting",
  EditorMenubarSortKey = "4060"
}
DefineClass.RecipeIngredient = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "item",
      name = "Item ID",
      editor = "preset_id",
      default = false,
      template = true,
      preset_class = "InventoryItemCompositeDef"
    },
    {
      id = "amount",
      name = "Amount",
      editor = "number",
      default = 1
    }
  }
}
function RecipeIngredient:GetEditorView()
  return T({
    422241156445,
    "<item> : <amount>",
    self
  })
end
DefineClass.RuleAutoPlaceSoundSources = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "Placement",
      id = "DeleteOld",
      name = "Delete Old Markers",
      help = "Requires EmitterType to be select so it knows which markers to delete",
      editor = "bool",
      default = true
    },
    {
      category = "Placement",
      id = "EmitterType",
      name = "Emitter Type",
      help = "Type of the emitter to place",
      editor = "combo",
      default = "",
      items = function(self)
        return EmitterTypeCombo
      end
    },
    {
      category = "Placement",
      id = "ClassPatterns",
      name = "Class Patterns",
      editor = "nested_list",
      default = false,
      base_class = "ClassPattern"
    },
    {
      category = "Placement",
      id = "MinDist",
      name = "Minimum Distance",
      help = "The minimum distance to keep among placed sound sources which are of the same EmitteryType or listed in EmittersAway or from objects of class OriginAwayClass",
      editor = "number",
      default = 10000,
      scale = "m"
    },
    {
      category = "Placement",
      id = "EmittersAway",
      name = "Emitters Away",
      help = "Types of the emitters to keep away from(using MinDist), e.g. Animals will not be placed close to Animals",
      editor = "nested_list",
      default = false,
      base_class = "EmitterTypeClass"
    },
    {
      category = "Placement",
      id = "OriginAwayClass",
      name = "Origin Away from  Class",
      help = "Type of objects to keep away from(using MinDist)",
      editor = "text",
      default = false
    },
    {
      category = "Placement",
      id = "BeachPoints",
      name = "Beach Points",
      help = "In addition to class patterns below matches beach points too(using MinDist as grid tile step)",
      editor = "bool",
      default = false,
      no_edit = function(self)
        return self.OnWater
      end
    },
    {
      category = "Placement",
      id = "BeachPointsWaterStep",
      name = "Beach Points Water Step",
      help = "Step used to check for water around point - if a point is on ground and at least one of its 4 neighbours is water it is considered as a Beach Point",
      editor = "number",
      default = 10000,
      no_edit = function(self)
        return not self.BeachPoints
      end,
      scale = "m"
    },
    {
      category = "Placement",
      id = "BorderRelation",
      editor = "combo",
      default = "any",
      items = function(self)
        return {
          "any",
          "Inside Border Area",
          "Outside Border Area"
        }
      end
    },
    {
      category = "Placement",
      id = "BorderTolerance",
      name = "Border Tolerance",
      help = "Border area extension/shrinkage",
      editor = "number",
      default = 0,
      no_edit = function(self)
        return self.BorderRelation == "any"
      end,
      scale = "voxelSizeX"
    },
    {
      category = "Requirements",
      id = "OnWater",
      name = "On Water",
      help = "requires the sample position to be on water",
      editor = "bool",
      default = false,
      no_edit = function(self)
        return self.BeachPoints or self.OnLand
      end
    },
    {
      category = "Requirements",
      id = "OnLand",
      name = "On Land",
      help = "requires the sample position to be on land",
      editor = "bool",
      default = false,
      no_edit = function(self)
        return self.BeachPoints or self.OnWater
      end
    },
    {
      category = "Requirements",
      id = "WaterNearBy",
      name = "Water Near By",
      help = "Water around required in this distance, 0 if not required",
      editor = "number",
      default = 0,
      no_edit = function(self)
        return self.OnWater
      end,
      scale = "m"
    },
    {
      category = "Requirements",
      id = "LandNearBy",
      name = "Land Near By",
      help = "Land around required in this distance, 0 if not required",
      editor = "number",
      default = 0,
      no_edit = function(self)
        return self.BeachPoints or self.OnLand
      end,
      scale = "m"
    },
    {
      category = "Requirements",
      id = "Regions",
      help = "Works only on maps from specific regions",
      editor = "string_list",
      default = {},
      item_default = "",
      items = function(self)
        return PresetsCombo("GameStateDef", "region")
      end
    },
    {
      category = "Requirements",
      id = "Terrain",
      editor = "texture_picker",
      default = false,
      items = function(self)
        return GetTerrainTexturesItems
      end,
      multiple = true,
      thumb_width = 128,
      thumb_height = 128,
      base_color_map = true
    },
    {
      category = "Requirements",
      id = "ClassCountAround",
      name = "Class Count Around",
      editor = "nested_list",
      default = false,
      base_class = "ClassCountAround"
    },
    {
      category = "Requirements",
      id = "Filter",
      help = "returns true whether this object should emit a sound source",
      editor = "func",
      default = function(self, obj)
        return true
      end,
      params = "self, obj"
    },
    {
      category = "Emmiters",
      id = "SoundSamples",
      name = "Sound Banks",
      help = "How many sound samples to choose randomly(by weight) from sound candidates",
      editor = "number",
      default = 3
    },
    {
      category = "Emmiters",
      id = "SoundCandidates",
      name = "Sound Bank Candidates",
      help = "Sound candidates each with its own weight used by randomization",
      editor = "nested_list",
      default = false,
      base_class = "AutoPlacedSoundSourceWeight"
    }
  },
  EditorMenubarName = "AutoRuledEmitters Editor",
  EditorMenubar = "Editors.Audio",
  EditorCustomActions = {
    {
      FuncName = "RunSingleRule",
      Icon = "CommonAssets/UI/Ged/play",
      Menubar = "Process",
      Name = "Run Singe Rule",
      Toolbar = "main"
    }
  }
}
function RuleAutoPlaceSoundSources:OnEditorSetProperty(prop_id, old_value, ged)
  if prop_id == "EmitterType" then
    self.EmittersAway = self.EmittersAway or {}
    if self.EmitterType ~= "" and not table.find_value(self.EmittersAway, "EmitterType", self.EmitterType) then
      table.insert(self.EmittersAway, PlaceObj("EmitterTypeClass", {
        "EmitterType",
        self.EmitterType
      }))
    end
    table.remove_value(self.EmittersAway, "EmitterType", old_value)
    if #self.EmittersAway == 0 then
      self.EmittersAway = false
    end
  end
end
function RuleAutoPlaceSoundSources:GetPlacePos(rand, spot_pos, spot_radius)
  local rand_pos = point(rand(spot_radius), 0, 0)
  rand_pos = RotateAxis(rand_pos, point(4096, 0, 0), rand(21600))
  rand_pos = RotateAxis(rand_pos, point(0, 4096, 0), rand(21600))
  rand_pos = RotateAxis(rand_pos, point(0, 0, 4096), rand(21600))
  local pos = spot_pos + rand_pos
  local x, y, z = pos:xyz()
  local w, h = terrain.GetMapSize()
  x = Clamp(x, 0, w - 1)
  y = Clamp(y, 0, h - 1)
  local terrain_z = terrain.GetHeight(pos)
  z = z < terrain_z and terrain_z or z
  return point(x, y, z)
end
function RuleAutoPlaceSoundSources:MatchBorderRelation(pos)
  if self.BorderRelation == "any" then
    return true
  end
  local border_area = GetBorderAreaLimits():grow(self.BorderTolerance)
  local pos_inside = pos:InBox2D(border_area)
  if self.BorderRelation == "Inside Border Area" then
    return pos_inside
  else
    return not pos_inside
  end
end
function RuleAutoPlaceSoundSources:GetError()
  local text, delim = "", ""
  if #(self.ClassPatterns or empty_table) == 0 and not self.BeachPoints then
    text = "Either 'Class Patterns'  must be non-empty or 'Beach Points' must be checked"
    delim = "\n"
  end
  if #(self.SoundCandidates or empty_table) == 0 and 0 < self.SoundSamples then
    text = string.format("%s%sNo 'Sound Samples' specified but spawning %d of them is required!", text, delim, self.SoundSamples)
    delim = "\n"
  end
  for idx, sample in ipairs(self.SoundCandidates or empty_table) do
    if not sample.Sound or sample.Sound == "" then
      text = string.format("%s%sNo Sound Bank specified for sound candidate %d.", text, delim, idx)
      delim = "\n"
    end
  end
  local class = self.OriginAwayClass
  if class and class ~= "" then
    local classes = ExpandRuleClasses(class)
    if #classes == 0 then
      text = string.format("%s%sNo classes expanded for OriginAwayClass='%s'!", text, delim, class)
      delim = "\n"
    end
  end
  if self.DeleteOld and self.id == "" then
    text = string.format("%s%sDeleteOld requires id set!", text, delim)
    delim = "\n"
  end
  return text ~= "" and text
end
DefineClass.SatelliteShortcutPreset = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "start_sector",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "end_sector",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "shortcut_direction_entrance_sector",
      help = "The sector which denotes the direction in which the start sector is being entered from",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "shortcut_direction_exit_sector",
      help = "The sector which denotes the direction in which the exit sector is being entered from",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "one_way",
      name = "One way",
      editor = "bool",
      default = false
    },
    {
      id = "GetEditorView",
      editor = "func",
      default = function(self)
        return self.id .. " (" .. tostring(self.start_sector) .. " - " .. tostring(self.end_sector) .. ")"
      end,
      no_edit = true
    },
    {
      id = "GetPath",
      help = "The points to draw the shortcut curve",
      editor = "func",
      default = function(self)
        return empty_table
      end
    },
    {
      id = "GetShortcutVisibilitySectors",
      editor = "func",
      default = function(self)
        return self.VisibilitySectors
      end,
      no_edit = true
    },
    {
      id = "GetTravelTime",
      editor = "func",
      default = function(self)
        return self.TravelTimeInSectors * const.Satellite.RiverTravelTime
      end,
      no_edit = true
    },
    {
      id = "VisibilitySectors",
      help = "Sectors which are visible while travelling on the shortcut",
      editor = "string_list",
      default = {},
      item_default = "",
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "TravelTimeInSectors",
      help = "How many sectors this shortcut is long. This is multiplied by const.Satellite.RiverTravelTime",
      editor = "number",
      default = false
    },
    {
      id = "water_shortcut",
      editor = "bool",
      default = false
    }
  }
}
DefineClass.SatelliteTimelineEventDef = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "Title",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "Text",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "Hint",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "GetIcon",
      name = "GetIcon",
      editor = "func",
      default = function(self, eventCtx)
      end,
      params = "self,eventCtx"
    },
    {
      id = "GetTextContext",
      name = "GetTextContext",
      editor = "func",
      default = function(self, eventCtx)
      end,
      params = "self,eventCtx"
    },
    {
      id = "GetDescriptionText",
      name = "GetDescriptionText",
      editor = "func",
      default = function(self, eventCtx)
        return self.Text
      end,
      params = "self,eventCtx"
    },
    {
      id = "GetMapLocation",
      name = "GetMapLocation",
      editor = "func",
      default = function(self, eventCtx)
      end,
      params = "self,eventCtx"
    },
    {
      id = "GetAssociatedMercs",
      name = "GetAssociatedMercs",
      editor = "func",
      default = function(self, eventCtx)
      end,
      params = "self,eventCtx"
    },
    {
      id = "OnClick",
      name = "OnClick",
      editor = "func",
      default = function(self, eventCtx)
      end,
      params = "self,eventCtx"
    }
  },
  GlobalMap = "SatelliteTimelineEvents"
}
DefineClass.SatelliteWarning = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "Title",
      editor = "text",
      default = T(998836062590, "Warning"),
      translate = true
    },
    {
      id = "Body",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "OkText",
      editor = "text",
      default = T(357769680740, "OK"),
      translate = true
    }
  },
  GlobalMap = "SatelliteWarnings"
}
DefineClass.SectorTerrain = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "TravelMod",
      name = "Travel Modifier",
      help = "Modifies travel times through this sector",
      editor = "number",
      default = 100,
      scale = "%",
      slider = true,
      min = 0,
      max = 500
    },
    {
      id = "DisplayName",
      editor = "text",
      default = false,
      template = true,
      translate = true
    }
  },
  GlobalMap = "SectorTerrainTypes"
}
DefineClass.SkinDecalData = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Decal",
      id = "DecEntity",
      name = "Decal Entity",
      editor = "choice",
      default = "",
      items = function(self)
        return ClassDescendantsCombo("SkinDecal")
      end
    },
    {
      category = "Decal",
      id = "DecType",
      editor = "preset_id",
      default = "",
      preset_class = "SkinDecalType"
    },
    {
      category = "Placement",
      id = "Spot",
      name = "Attach Spot",
      editor = "choice",
      default = "",
      no_validate = true,
      items = function(self)
        return EntitySpotsCombo
      end
    },
    {
      category = "Placement",
      id = "DecOffsetX",
      name = "Offset X (red axis)",
      editor = "number",
      default = 0,
      scale = "cm",
      slider = true,
      min = -5000,
      max = 5000
    },
    {
      category = "Placement",
      id = "DecOffsetY",
      name = "Offset Y (green axis)",
      editor = "number",
      default = 0,
      scale = "cm",
      slider = true,
      min = -5000,
      max = 5000
    },
    {
      category = "Placement",
      id = "DecOffsetZ",
      name = "Offset Z (blue axis)",
      editor = "number",
      default = 0,
      scale = "cm",
      slider = true,
      min = -5000,
      max = 5000
    },
    {
      category = "Placement",
      id = "InvertFacing",
      name = "Invert Facing (along red axis)",
      editor = "bool",
      default = false
    },
    {
      category = "Placement",
      id = "DecAttachAxis",
      name = "Rotation Axis",
      editor = "choice",
      default = "+X",
      items = function(self)
        return table.keys(SkinDecalAttachAxis, "sorted")
      end
    },
    {
      category = "Placement",
      id = "DecAttachAngleRange",
      name = "Rotation Range",
      editor = "range",
      default = range(0, 360),
      slider = true,
      min = 0,
      max = 360
    },
    {
      category = "Placement",
      id = "DecScale",
      name = "Scale",
      editor = "number",
      default = 100,
      slider = true,
      min = 1,
      max = 500
    },
    {
      category = "Placement",
      id = "ClrMod",
      name = "Color Modifier",
      editor = "color",
      default = 4284769380
    }
  }
}
DefineClass.SkinDecalMetadata = {
  __parents = {
    "Preset",
    "SkinDecalData"
  },
  __generated_by_class = "PresetDef",
  EditorMenubarName = "Skin decal presets",
  EditorMenubar = "Editors.Art"
}
DefineClass.SkinDecalType = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "ClearedByWater",
      name = "Cleared By Water",
      editor = "bool",
      default = true
    },
    {
      id = "DefaultEntity",
      name = "Default Entity",
      editor = "choice",
      default = "",
      items = function(self)
        return ClassDescendantsCombo("Decal")
      end
    },
    {
      id = "DefaultScale",
      name = "Default Scale",
      editor = "number",
      default = 100,
      scale = "%",
      min = 1,
      max = 1000
    }
  },
  GlobalMap = "SkinDecalTypes"
}
function SkinDecalType:GetError()
  if not IsValidEntity(self.DefaultEntity) then
    return "Invalid entity"
  end
end
DefineClass.StanceToStanceAP = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "start_stance",
      name = "Starting Stance",
      editor = "choice",
      default = false,
      items = function(self)
        return PresetGroupCombo("CombatStance", "Default")
      end
    },
    {
      id = "end_stance",
      name = "End Stance",
      editor = "choice",
      default = false,
      items = function(self)
        return PresetGroupCombo("CombatStance", "Default")
      end
    },
    {
      id = "ap_cost",
      name = "AP Cost",
      editor = "number",
      default = 0,
      scale = "AP"
    }
  }
}
DefineClass.StatGainingPrerequisite = {
  __parents = {
    "MsgReactionsPreset"
  },
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "StatGaining",
      id = "parameters",
      name = "Parameters",
      editor = "nested_list",
      default = false,
      base_class = "PresetParam"
    },
    {
      category = "StatGaining",
      id = "relatedStat",
      name = "Related Stat",
      editor = "combo",
      default = false,
      items = function(self)
        return UnitPropertiesStats:GetProperties()
      end
    },
    {
      category = "StatGaining",
      id = "failChance",
      name = "Fail Chance",
      help = "Chance to fail on top of all other checks.",
      editor = "number",
      default = 0,
      scale = "%",
      min = 0,
      max = 100
    },
    {
      category = "StatGaining",
      id = "oncePerMapVisit",
      name = "Once Per Map Visit",
      editor = "bool",
      default = false
    }
  },
  GlobalMap = "StatGainingPrerequisites",
  EditorMenubarName = "Stat Gaining Prerequisites",
  EditorMenubar = "Scripting"
}
function StatGainingPrerequisite:ResolveValue(key)
  local value = self:GetProperty(key)
  if value then
    return value
  end
  if self.parameters then
    local found = table.find_value(self.parameters, "Name", key)
    if found then
      return found.Value
    end
  end
end
DefineClass.TacticalNotification = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "text",
      name = "Text",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "secondaryText",
      name = "SecondaryText",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "removalGroup",
      name = "Group",
      editor = "text",
      default = false
    },
    {
      id = "duration",
      name = "Duration",
      editor = "number",
      default = 1500
    },
    {
      id = "style",
      name = "Style",
      editor = "combo",
      default = "red",
      items = function(self)
        return {
          "red",
          "yellow",
          "blue"
        }
      end
    },
    {
      id = "combatLog",
      name = "Log in Combat Log",
      editor = "bool",
      default = false
    },
    {
      id = "combatLogType",
      editor = "combo",
      default = "short",
      no_edit = function(self)
        return not self.combatLog
      end,
      items = function(self)
        return {
          "short",
          "important",
          "debug"
        }
      end
    }
  }
}
DefineClass.TargetBodyPart = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "display_name",
      name = "Display Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "description",
      name = "Description",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "display_name_caps",
      name = "Display Name Caps",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "damage_mod",
      name = "Damage Modifier",
      editor = "number",
      default = 0,
      scale = "%"
    },
    {
      id = "tohit_mod",
      name = "Chance To Hit Modifier",
      editor = "number",
      default = 0,
      scale = "%"
    },
    {
      id = "applied_effect",
      name = "Applied Effect",
      editor = "combo",
      default = "",
      items = function(self)
        return PresetGroupCombo("CharacterEffectCompositeDef", "Default")
      end
    },
    {
      id = "default",
      name = "Default target",
      editor = "bool",
      default = false
    },
    {
      id = "Icon",
      editor = "ui_image",
      default = false
    },
    {
      id = "armorPart",
      name = "ArmorPart",
      help = "The inventory slot which serves as armor for this body part.",
      editor = "text",
      default = false
    }
  }
}
function TargetBodyPart:GetError()
  local duplicated_default
  if self.default then
    ForEachPresetInGroup("TargetBodyPart", "Default", function(preset)
      if preset.id ~= self.id and preset.default then
        duplicated_default = true
      end
    end)
  end
  if duplicated_default then
    return "More than one body part is set as default target"
  end
end
DefineClass.TestCombat = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "show_in_cheats",
      name = "Show in Cheats",
      help = "Can be tested from main menu cheats",
      editor = "bool",
      default = false
    },
    {
      id = "SortKey",
      name = "SortKey",
      help = "The lower the number, the earlier it occurs in the list",
      editor = "number",
      default = 0
    },
    {
      id = "skip_deployment",
      name = "Skip Deployment",
      help = "Directly in combat mode",
      editor = "bool",
      default = false
    },
    {
      id = "sector_id",
      name = "Sector Id",
      help = "Sector id",
      editor = "combo",
      default = "A1",
      no_edit = function(self)
        return self.map
      end,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "map",
      name = "Map",
      help = "Use this property if you want to test combat in a test map (which is not defined as a sector map)",
      editor = "combo",
      default = false,
      items = function(self)
        return ListMaps()
      end
    },
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
    },
    {
      id = "real_gameplay",
      name = "Real Gameplay",
      help = "Attack or defend the sector, using real gameplay spawning logic (Entrance and Defender markers)",
      editor = "bool",
      default = true
    },
    {
      id = "DisplayText",
      name = "DisplayText",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "Alt_Shortcut",
      help = "Alt + [shortcut] will quickstart this test",
      editor = "number",
      default = false,
      min = 1,
      max = 5
    },
    {
      id = "reveal_intel",
      name = "Reveal Intel",
      editor = "bool",
      default = true
    },
    {
      id = "squads",
      editor = "nested_list",
      default = false,
      base_class = "TestCombatSquad",
      inclusive = true
    },
    {
      id = "player_role",
      name = "Player Role",
      help = "The player attacks or defends the sector",
      editor = "combo",
      default = "attack",
      no_edit = function(self)
        return not self.real_gameplay
      end,
      items = function(self)
        return {"attack", "defend"}
      end
    },
    {
      id = "attacker_dir",
      name = "Attacker Dir",
      help = "Direction from which the attacker (player or enemy - determined by Player Role prop) enters the sector",
      editor = "combo",
      default = "North",
      no_edit = function(self)
        return not self.real_gameplay
      end,
      items = function(self)
        return const.WorldDirections
      end
    },
    {
      id = "trigger_enemy_spawners",
      name = "Trigger Enemy Spawners",
      help = "Spawn all units from there spawner markers, ignoring their conditions",
      editor = "string_list",
      default = {},
      item_default = "",
      items = function(self)
        return TriggerEnemySpawnersCombo(self:GetCombatMap())
      end
    },
    {
      id = "disable_enemy_spawners",
      name = "Disable Enemy Spawners",
      help = "Do not spawn units from these markers",
      editor = "string_list",
      default = {},
      item_default = "",
      items = function(self)
        return TriggerEnemySpawnersCombo(self:GetCombatMap())
      end
    },
    {
      id = "OnMapLoaded",
      help = [[
Use this to customize conditions in the test combat. 
Called in a real time thread OnMsg("PostNewMapLoaded")]],
      editor = "func",
      default = function(self)
      end
    },
    {
      id = "OnCombatStart",
      help = [[
Use this to customize conditions in the test combat. 
Called in a real time thread OnMsg("CombatStart")]],
      editor = "func",
      default = function(self)
      end
    },
    {
      id = "combatTask",
      name = "Combat Task",
      help = "Preselect a Combat Task for the combat.",
      editor = "preset_id",
      default = false,
      preset_class = "CombatTask"
    },
    {
      id = "enter_sector_btn",
      editor = "buttons",
      default = false,
      dont_save = true,
      read_only = true,
      buttons = {
        {
          name = "Test",
          func = "TestCombatTest"
        }
      }
    }
  },
  HasSortKey = true,
  EditorIcon = "CommonAssets/UI/Icons/outline starburst.png",
  EditorMenubar = "Combat",
  EditorMenubarSortKey = "-10",
  FilterClass = "TestCombatFilter"
}
function TestCombat:GetError()
  local err = self:VerifyPlayerSquad()
  if err then
    return err
  end
  local map = GetMapName()
  local combat_map = self:GetCombatMap()
  if not combat_map or map ~= combat_map or GameState.loading then
    return
  end
  if self.real_gameplay then
    if not next(MapGetMarkers("ExitZoneInteractable", self.attacker_dir)) then
      return string.format("No %s Entrance markers on the map", self.attacker_dir)
    end
    if not next(MapGetMarkers("Defender", false, function(m)
      return m:IsMarkerEnabled()
    end)) and not next(MapGetMarkers("DefenderPriority", false, function(m)
      return m:IsMarkerEnabled()
    end)) then
      return "No Enabled Defender markers on the map"
    end
  end
  for _, squad in ipairs(self.squads) do
    if squad.spawn_location == "On Marker" and not next(MapGetMarkers(squad.spawn_marker_type, squad.spawn_marker_group)) then
      return string.format("No %s %s markers on the map", squad.spawn_marker_type, squad.spawn_marker_group)
    end
  end
end
function TestCombat:VerifyPlayerSquad()
  local player_squads = 0
  for _, squad in ipairs(self.squads) do
    if squad.squad_type ~= "NPC" then
      player_squads = player_squads + 1
    end
  end
  if player_squads == 0 then
    return "No Player squad defined"
  elseif 1 < player_squads then
    return "More than one Player squad defined"
  end
end
function TestCombat:GetCombatMap()
  local sector = table.find_value(CampaignPresets[DefaultCampaign].Sectors, "Id", self.sector_id)
  local map = self.map or sector and sector.Map
  return map
end
function TestCombat:GetEditorView()
  return self.id .. " <color 0 128 0>" .. (self.map or self.sector_id)
end
DefineClass.TestCombatSquad = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "squad_type",
      editor = "choice",
      default = "CurrentPlayerSquad",
      items = function(self)
        return {
          "CurrentPlayerSquad",
          "Custom",
          "NPC"
        }
      end
    },
    {
      id = "Mercs",
      name = "Mercs",
      help = "List of your team to deploy",
      editor = "preset_id_list",
      default = {},
      no_edit = function(self)
        return self.squad_type ~= "Custom"
      end,
      preset_class = "UnitDataCompositeDef",
      preset_filter = function(preset, obj)
        if IsMerc(preset) then
          return true
        end
      end,
      item_default = ""
    },
    {
      id = "npc_squad_id",
      editor = "preset_id",
      default = false,
      no_edit = function(self)
        return self.squad_type ~= "NPC"
      end,
      preset_class = "EnemySquads",
      preset_filter = function(preset, obj)
        if preset.group ~= "Test Encounters" then
          return obj
        end
      end
    },
    {
      id = "side",
      editor = "choice",
      default = "player1",
      read_only = function(self)
        return self.squad_type ~= "NPC"
      end,
      items = function(self)
        return table.map(GetCurrentCampaignPreset().Sides, "Id")
      end
    },
    {
      id = "spawn_location",
      editor = "choice",
      default = "Standard",
      items = function(self)
        return {"Standard", "On Marker"}
      end
    },
    {
      id = "tier",
      name = "Tier",
      help = "Level up, give more perks and more expensive weapons for higher tiers.",
      editor = "choice",
      default = 1,
      items = function(self)
        return {
          1,
          2,
          3
        }
      end
    },
    {
      id = "spawn_marker_type",
      name = "Marker Type",
      help = "For enemies: Defender marker type and no marker group places enemies using defender priority logic",
      editor = "combo",
      default = "Defender",
      no_edit = function(self)
        return self.spawn_location == "Standard"
      end,
      items = function(self)
        return GetGridMarkerTypesCombo()
      end
    },
    {
      id = "spawn_marker_group",
      name = "Marker Group",
      help = "Where to spawn squad",
      editor = "combo",
      default = false,
      no_edit = function(self)
        return self.spawn_location == "Standard"
      end,
      items = function(self)
        return GridMarkerGroupsCombo()
      end
    }
  }
}
function TestCombatSquad:SetProperty(id, value)
  local prev = self[id]
  PropertyObject.SetProperty(self, id, value)
  if id == "squad_type" then
    if value == "NPC" then
      if prev ~= "NPC" then
        self:SetProperty("side", "enemy1")
      end
    else
      self:SetProperty("side", "player1")
    end
  end
end
function TestCombatSquad:GetEditorView()
  if self.squad_type == "CurrentPlayerSquad" then
    return "Current Player Squad"
  elseif self.squad_type == "Custom" then
    return "Custom Player Squad"
  end
  local def = EnemySquadDefs[self.npc_squad_id]
  return string.format([[
[%s] %s
%s]], self.side, tostring(self.npc_squad_id), def and def:GetPreview() or "")
end
DefineClass.TriggeredConditionalEvent = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "QuestId",
      name = "QuestId",
      editor = "preset_id",
      default = false,
      read_only = true,
      no_edit = true
    },
    {
      id = "ParamId",
      name = "Param id",
      help = "The name of the param in the quest table which will be used to store the state of the TriggeredConditionalEvent",
      editor = "choice",
      default = false,
      items = function(self)
        return GetQuestsVarsCombo(self.QuestId, "TCEState")
      end
    },
    {
      id = "Trigger",
      name = "Trigger",
      editor = "choice",
      default = "activation",
      items = function(self)
        return {
          "always",
          "activation",
          "deactivation",
          "change"
        }
      end
    },
    {
      id = "Once",
      name = "Once",
      editor = "bool",
      default = false
    },
    {
      id = "Conditions",
      name = "Conditions",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    },
    {
      id = "SequentialEffects",
      name = "Execute Effects Sequentially",
      help = "Whether effects should wait for each other when executing in order.",
      editor = "bool",
      default = true
    },
    {
      id = "Effects",
      name = "Effects",
      editor = "nested_list",
      default = false,
      base_class = "Effect"
    },
    {
      id = "StoreAsTable",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    }
  },
  EditorView = Untranslated("<u(ParamId)>")
}
function TriggeredConditionalEvent:Update()
  if not self.Effects then
    return
  end
  local quest = QuestGetState(self.QuestId)
  if not quest then
    return
  end
  local state = quest[self.ParamId]
  if self.Once and state == "done" then
    return
  end
  local evaluation = EvalConditionList(self.Conditions)
  local done, exec
  local trigger = self.Trigger
  if trigger == "always" and evaluation then
    exec = true
  end
  if (trigger == "activation" or trigger == "change") and state == false and evaluation then
    exec = true
  end
  if (trigger == "deactivation" or trigger == "change") and not evaluation and state == true then
    exec = true
  end
  if exec then
    if self.Once then
      rawset(quest, self.ParamId, "done")
      done = true
    end
    if self.SequentialEffects then
      ExecuteSequentialEffects(self.Effects, "QuestAndState", self.QuestId, self.ParamId)
    else
      ExecuteEffectList(self.Effects, quest, state)
    end
  end
  if not done then
    rawset(quest, self.ParamId, evaluation)
  end
end
function TriggeredConditionalEvent:GetError()
  if not self.ParamId then
    return "Add unique Variable to store triggered conditions/effects state in"
  end
  if not self.Effects then
    return "Add at least one effect to execute"
  end
  for _, eff in ipairs(self.Effects) do
    if next(eff.RequiredObjClasses) then
      if table.find(eff.RequiredObjClasses, "Unit") then
        return "Can't use effects that require a unit (" .. eff.class .. ")"
      end
      return "Can't use effects that require an object (" .. eff.class .. ")"
    end
  end
end
function TriggeredConditionalEvent:OnEditorNew(parent, ged, is_paste)
  local quest_def = ged:ResolveObj("SelectedPreset")
  self.QuestId = quest_def.id
end
DefineClass.TutorialHint = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "PopupId",
      help = "Popup notification preset id.",
      editor = "preset_id",
      default = false,
      preset_class = "PopupNotification"
    },
    {
      category = "Popup Preview",
      id = "PopupTitle",
      editor = "text",
      default = false,
      dont_save = true,
      read_only = true,
      translate = true
    },
    {
      category = "Popup Preview",
      id = "PopupText",
      editor = "text",
      default = false,
      dont_save = true,
      read_only = true,
      translate = true,
      wordwrap = true,
      lines = 5
    },
    {
      id = "TutorialPopupTitle",
      editor = "text",
      default = T(767566189526, "Tutorial"),
      no_edit = function(self)
        return self.group ~= "TutorialPopups"
      end,
      translate = true
    },
    {
      id = "Text",
      editor = "text",
      default = "",
      translate = true,
      lines = 3,
      max_lines = 8
    },
    {
      id = "GamepadText",
      editor = "text",
      default = false,
      translate = true,
      lines = 3,
      max_lines = 8
    },
    {
      id = "StoreAsTable",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "StaticPopup",
      help = "Static popups show in the left corner under snype.",
      editor = "bool",
      default = false
    },
    {
      category = "Conditionals",
      id = "ShowConditions",
      name = "Show Condition",
      editor = "nested_list",
      default = false,
      base_class = "Condition",
      inclusive = true
    },
    {
      category = "Conditionals",
      id = "HideConditions",
      name = "Hide Condition",
      editor = "nested_list",
      default = false,
      base_class = "Condition",
      inclusive = true
    },
    {
      category = "Conditionals",
      id = "CompletionConditions",
      name = "Completion Condition",
      editor = "nested_list",
      default = false,
      base_class = "Condition",
      inclusive = true
    }
  },
  HasSortKey = true,
  GlobalMap = "TutorialHints",
  EditorMenubarName = "Tutorial Hints Editor",
  EditorIcon = "CommonAssets/UI/Icons/alert attention danger error warning.png",
  EditorMenubar = "Scripting",
  EditorMenubarSortKey = "4030"
}
function TutorialHint:GetWarning()
end
function TutorialHint:GetPopupTitle(id)
  local id = self.PopupId
  local preset = PopupNotifications[id]
  return preset and preset.Title
end
function TutorialHint:GetPopupText(id)
  local id = self.PopupId
  local preset = PopupNotifications[id]
  return preset and preset.Text
end
DefineClass.UnitBodyPartCollider = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "id",
      editor = "choice",
      default = false,
      items = function(self)
        return {
          "Head",
          "Arms",
          "Torso",
          "Groin",
          "Legs"
        }
      end
    },
    {
      id = "TargetSpots",
      editor = "string_list",
      default = {},
      no_validate = true,
      item_default = "",
      items = function(self)
        return {
          "Head",
          "Neck",
          "Torso",
          "Groin",
          "Shoulderl",
          "Shoulderr",
          "Elbowl",
          "Elbowr",
          "Wristl",
          "Wristr",
          "Pelvisl",
          "Pelvisr",
          "Kneel",
          "Kneer",
          "Ribsupperl",
          "Ribsupperr",
          "Ribslowerl",
          "Ribslowerr",
          "Tail"
        }
      end
    },
    {
      id = "Colliders",
      editor = "nested_list",
      default = false,
      base_class = "UnitColliderBase",
      format = "<Text>"
    }
  }
}
DefineClass.UnitCollider = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "BodyParts",
      editor = "nested_list",
      default = false,
      base_class = "UnitBodyPartCollider",
      format = "<id>"
    }
  },
  HasSortKey = true,
  HasParameters = true,
  GlobalMap = "UnitColliders"
}
DefineClass.UnitColliderBase = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "TargetSpot",
      help = "Associate every collider with a target spot",
      editor = "combo",
      default = "",
      no_validate = true,
      items = function(self)
        return {
          "Head",
          "Neck",
          "Torso",
          "Groin",
          "Shoulderl",
          "Shoulderr",
          "Elbowl",
          "Elbowr",
          "Wristl",
          "Wristr",
          "Pelvisl",
          "Pelvisr",
          "Kneel",
          "Kneer",
          "Ribsupperl",
          "Ribsupperr",
          "Ribslowerl",
          "Ribslowerr",
          "Tail"
        }
      end
    },
    {
      id = "Type",
      editor = "text",
      default = false,
      read_only = true
    }
  }
}
function UnitColliderBase:Text()
  return ""
end
DefineClass.UnitColliderCapsule = {
  __parents = {
    "UnitColliderBase"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Spot1",
      help = "Capsule segment point 1",
      editor = "combo",
      default = "",
      no_validate = true,
      items = function(self)
        return {
          "Head",
          "Neck",
          "Torso",
          "Groin",
          "Shoulderl",
          "Shoulderr",
          "Elbowl",
          "Elbowr",
          "Wristl",
          "Wristr",
          "Pelvisl",
          "Pelvisr",
          "Kneel",
          "Kneer",
          "Ribsupperl",
          "Ribsupperr",
          "Ribslowerl",
          "Ribslowerr",
          "Tail"
        }
      end
    },
    {
      id = "Spot2",
      help = "Capsule segment point 2",
      editor = "combo",
      default = "",
      no_validate = true,
      items = function(self)
        return {
          "Head",
          "Neck",
          "Torso",
          "Groin",
          "Shoulderl",
          "Shoulderr",
          "Elbowl",
          "Elbowr",
          "Wristl",
          "Wristr",
          "Pelvisl",
          "Pelvisr",
          "Kneel",
          "Kneer",
          "Ribsupperl",
          "Ribsupperr",
          "Ribslowerl",
          "Ribslowerr",
          "Tail"
        }
      end
    },
    {
      id = "Radius",
      help = "Capsule radius",
      editor = "number",
      default = 0,
      scale = "cm"
    },
    {
      id = "Type",
      editor = "text",
      default = "Capsule",
      read_only = true
    }
  }
}
function UnitColliderCapsule:Text()
  return string.format("Capsule, Spot1=%s, Spot2=%s, Radius=%d, TargetSpot=%s", self.Spot1, self.Spot2, self.Radius, self.TargetSpot)
end
DefineClass.UnitColliderSphere = {
  __parents = {
    "UnitColliderBase"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Spot",
      help = "Sphere center",
      editor = "combo",
      default = "",
      no_validate = true,
      items = function(self)
        return {
          "Head",
          "Neck",
          "Torso",
          "Groin",
          "Shoulderl",
          "Shoulderr",
          "Elbowl",
          "Elbowr",
          "Wristl",
          "Wristr",
          "Pelvisl",
          "Pelvisr",
          "Kneel",
          "Kneer",
          "Ribsupperl",
          "Ribsupperr",
          "Ribslowerl",
          "Ribslowerr",
          "Tail"
        }
      end
    },
    {
      id = "Radius",
      help = "Sphere radius",
      editor = "number",
      default = 0,
      scale = "cm"
    },
    {
      id = "Type",
      editor = "text",
      default = "Sphere",
      read_only = true
    }
  }
}
function UnitColliderSphere:Text()
  return string.format("Sphere, Spot=%s, Radius=%d, TargetSpot=%s", self.Spot, self.Radius, self.TargetSpot)
end
DefineClass.WeaponComponent = {
  __parents = {
    "WeaponComponentSharedClass"
  },
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "DisplayName",
      editor = "text",
      default = false,
      translate = true
    },
    {
      category = "General",
      id = "Icon",
      editor = "ui_image",
      default = "",
      template = true,
      image_preview_size = 400
    },
    {
      id = "Slot",
      editor = "combo",
      default = false,
      items = function(self)
        return PresetGroupCombo("WeaponUpgradeSlot", "Default")
      end
    },
    {
      id = "Visuals",
      editor = "nested_list",
      default = false,
      base_class = "WeaponComponentVisual",
      inclusive = true
    },
    {
      id = "EnableWeapon",
      editor = "combo",
      default = false,
      items = function(self)
        return InventoryItemCombo
      end
    },
    {
      id = "ModificationEffects",
      editor = "preset_id_list",
      default = {},
      preset_class = "WeaponComponentEffect",
      item_default = ""
    },
    {
      category = "Costs",
      id = "Cost",
      name = "Cost (Parts)",
      help = "The cost of the upgrade in parts",
      editor = "number",
      default = 0,
      template = true
    },
    {
      category = "Costs",
      id = "AdditionalCosts",
      editor = "nested_list",
      default = false,
      template = true,
      base_class = "WeaponComponentCost"
    },
    {
      category = "Costs",
      id = "ModificationDifficulty",
      editor = "combo",
      default = 46,
      items = function(self)
        return const.WeaponModDifficultyPresets
      end
    },
    {
      category = "Can Be Attached To",
      id = "CanBeAttachedTo",
      name = "Can Be Attached To",
      editor = "buttons",
      default = false,
      dont_save = true,
      read_only = true,
      template = true,
      buttons = function(obj)
        return WeaponComponentExtraButtons(obj)
      end
    },
    {
      category = "Misc",
      id = "BlockSlots",
      name = "Block Slots",
      editor = "string_list",
      default = {},
      item_default = "",
      items = function(self)
        return PresetGroupCombo("WeaponUpgradeSlot", "Default")
      end
    },
    {
      category = "Misc",
      id = "ModifyRightHandGrip",
      name = "Modify the right hand grip",
      editor = "bool",
      default = false
    }
  },
  HasParameters = true,
  GlobalMap = "WeaponComponents",
  EditorIcon = "CommonAssets/UI/Icons/cog outline.png",
  EditorMenubar = "Combat",
  FilterClass = "WeaponComponentFilter",
  GetWarning = false
}
DefineModItemPreset("WeaponComponent", {
  EditorName = "Weapon Component",
  EditorSubmenu = "Item"
})
function WeaponComponent:GetWarning()
  local myParams = self.Parameters or empty_table
  for i, effId in ipairs(self.ModificationEffects) do
    local effect = WeaponComponentEffects[effId]
    if effect and effect.RequiredParams then
      local requiredParams = effect.RequiredParams
      for i, param in ipairs(requiredParams) do
        if not table.find(myParams, "Name", param) then
          return "Missing param " .. param .. " for effect " .. effId
        end
      end
    end
  end
end
DefineClass.WeaponComponentBlockPair = {
  __parents = {
    "WeaponComponentSharedClass"
  },
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "Weapon",
      editor = "preset_id",
      default = false,
      preset_class = "InventoryItemCompositeDef",
      preset_filter = function(preset, obj)
        local classdef = g_Classes[preset.object_class]
        return IsKindOf(classdef, "Firearm")
      end
    },
    {
      id = "ComponentBlockOne",
      editor = "preset_id",
      default = false,
      preset_class = "WeaponComponent"
    },
    {
      id = "ComponentBlockTwo",
      editor = "preset_id",
      default = false,
      preset_class = "WeaponComponent"
    }
  },
  GlobalMap = "WeaponComponentBlockPairs",
  EditorIcon = "CommonAssets/UI/Icons/cog outline.png",
  EditorMenubar = "Combat"
}
DefineClass.WeaponComponentEffect = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "Display Data",
      id = "Description",
      editor = "text",
      default = false,
      translate = true,
      lines = 1,
      max_lines = 5
    },
    {
      category = "Params",
      id = "RequiredParams",
      editor = "string_list",
      default = {},
      item_default = "",
      items = false,
      arbitrary_value = true
    },
    {
      category = "Stat Modifier",
      id = "StatToModify",
      name = "StatToModify",
      editor = "combo",
      default = false,
      items = function(self)
        return ClassModifiablePropsNonTranslatableCombo(g_Classes.Firearm)
      end
    },
    {
      category = "Stat Modifier",
      id = "ModificationType",
      editor = "combo",
      default = "Add",
      items = function(self)
        return {
          "Add",
          "Multiply",
          "Subtract"
        }
      end
    },
    {
      category = "Stat Modifier",
      id = "CaliberChange",
      editor = "combo",
      default = false,
      items = function(self)
        return PresetGroupCombo("Caliber", "Default")
      end
    },
    {
      category = "Stat Modifier",
      id = "Scale",
      editor = "combo",
      default = false,
      items = function(self)
        return table.keys(const.Scale)
      end
    },
    {
      category = "Used In",
      id = "UsedIn",
      name = "Used In",
      editor = "buttons",
      default = false,
      dont_save = true,
      read_only = true,
      template = true,
      buttons = function(obj)
        return WeaponComponentEffectUsedIn(obj)
      end
    }
  },
  HasSortKey = true,
  HasParameters = true,
  GlobalMap = "WeaponComponentEffects",
  EditorIcon = "CommonAssets/UI/Icons/cog outline.png",
  EditorMenubar = "Combat"
}
DefineClass.WeaponComponentSharedClass = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  PresetClass = "WeaponComponentSharedClass",
  EditorMenubarName = "WeaponComponent Editor"
}
DefineClass.WeaponComponentSlot = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "SlotType",
      editor = "combo",
      default = false,
      items = function(self)
        return PresetGroupCombo("WeaponUpgradeSlot", "Default")
      end
    },
    {
      id = "Modifiable",
      editor = "bool",
      default = true
    },
    {
      id = "CanBeEmpty",
      editor = "bool",
      default = false
    },
    {
      id = "AvailableComponents",
      editor = "string_list",
      default = {},
      item_default = "",
      items = function(self)
        return WeaponSlotComponentComboItems
      end
    },
    {
      id = "DefaultComponent",
      editor = "combo",
      default = "",
      items = function(self)
        return WeaponSlotDefaultComponentComboItems
      end
    }
  }
}
function WeaponComponentSlot:GetEditorView()
  local mod_text = self.Modifiable and "" or "(non-modifiable)"
  local text = self.SlotType and Presets.WeaponUpgradeSlot.Default[self.SlotType].DisplayName or "Component"
  return Untranslated(text) .. " " .. Untranslated(mod_text)
end
DefineClass.WeaponComponentVisual = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Entity",
      editor = "combo",
      default = false,
      items = function(self)
        return GetWeaponComponentEntities
      end
    },
    {
      id = "Slot",
      editor = "combo",
      default = false,
      items = function(self)
        return PresetGroupCombo("WeaponUpgradeSlot", "Default")
      end
    },
    {
      id = "ApplyTo",
      editor = "preset_id",
      default = false,
      preset_class = "InventoryItemCompositeDef",
      preset_filter = function(preset, obj)
        local classdef = g_Classes[preset.object_class]
        return IsKindOf(classdef, "Firearm")
      end
    },
    {
      id = "OverrideHolsterSlot",
      editor = "combo",
      default = "",
      items = function(self)
        return {
          "",
          "Shoulder",
          "Leg"
        }
      end
    },
    {
      id = "ModifyRightHandGrip",
      editor = "bool",
      default = false,
      template = true
    },
    {
      id = "Icon",
      name = "Custom Icon",
      help = "icon used for this particular component; leave empty to uae component default",
      editor = "ui_image",
      default = "",
      template = true,
      image_preview_size = 400
    }
  },
  StoreAsTable = true
}
function WeaponComponentVisual:GetError()
  if not self.Slot then
    return "No slot"
  end
  if not self.Entity then
    return "No entity"
  end
end
function WeaponComponentVisual:GetEditorView()
  return string.format("%s component (%s)", self.Slot or "unspecified", self:IsGeneric() and "any weapon" or self.ApplyTo)
end
function WeaponComponentVisual:Match(id)
  return self:IsGeneric() or self.ApplyTo == id
end
function WeaponComponentVisual:IsGeneric()
  return (self.ApplyTo or "") == ""
end
DefineClass.WeaponPropertyDef = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "bind_to",
      name = "Property",
      help = "The name of the property to bind to.",
      editor = "text",
      default = false
    },
    {
      id = "display_name",
      name = "Display Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "short_display_name",
      name = "Short Display Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "description",
      name = "Description",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "max_progress",
      name = "Max Progress Bar Value",
      help = "The max value of the bar",
      editor = "number",
      default = 100
    },
    {
      id = "reverse_bar",
      name = "Reverse Bar",
      editor = "bool",
      default = false
    },
    {
      id = "show_in_inventory",
      name = "Show in inventory rollover",
      editor = "bool",
      default = false
    },
    {
      id = "DisplayForContext",
      editor = "func",
      default = function(self, context)
        return context:IsWeapon()
      end,
      params = "self, context"
    },
    {
      id = "GetProp",
      editor = "func",
      default = function(self, item, unit_id)
        return item:GetProperty(self.bind_to)
      end,
      params = "self, item, unit_id"
    },
    {
      id = "Getbase_Prop",
      editor = "func",
      default = function(self, item, unit_id)
        return item:GetProperty("base_" .. self.bind_to)
      end,
      params = "self, item,  unit_id"
    }
  }
}
DefineClass.WeaponType = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "Description",
      editor = "text",
      default = false,
      translate = true,
      lines = 2,
      max_lines = 100
    },
    {
      id = "Icon",
      editor = "ui_image",
      default = "UI/Icons/Weapons/M16A2",
      image_preview_size = 100
    }
  }
}
DefineClass.WeaponUpgradeSlot = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "DisplayName",
      editor = "text",
      default = false,
      translate = true
    }
  }
}
DefineModItemPreset("WeaponUpgradeSlot", {EditorName = "Weapon Mod", EditorSubmenu = "Item"})
