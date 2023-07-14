DefineClass.ApplyGuiltyOrRighteous = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "effectType",
      name = "effectType",
      help = "Whether the effect is possive or negative (proud or guilty)",
      editor = "combo",
      default = "positive",
      items = function(self)
        return {"positive", "negative"}
      end
    }
  },
  EditorView = Untranslated("Apply guilty or righteous effect on unit"),
  Documentation = "Apply guilty or righteous effect on unit"
}
function ApplyGuiltyOrRighteous:__exec(obj, context)
  ApplyGuiltyOrRighteousEffect(self.effectType)
end
function ApplyGuiltyOrRighteous:GetUIText(effect)
  if self.effectType == "positive" then
    return T(235589045798, "Some mercs may <em>approve</em> of this.")
  else
    return T(596690068964, "Some mercs may <em>regret</em> this.")
  end
end
function ApplyGuiltyOrRighteous:GetEditorView()
  local helperText = self.effectType == "positive" and "positive(righteous)" or "negative(guilty)"
  return Untranslated("Apply " .. helperText .. " effect on unit")
end
DefineClass.AssociateNPCWithSector = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Negate",
      name = "Remove NPC",
      help = "Reverse the effect, removing an NPC from the sector.",
      editor = "bool",
      default = false
    },
    {
      id = "Sector",
      name = "Associated Sector",
      help = "The sector to associate with.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "Name",
      name = "NPC Name",
      help = "The name of the NPC to associate.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetTargetUnitCombo()
      end
    }
  },
  EditorView = Untranslated("Associate NPC <Name> with sector <u(Sector)>"),
  Documentation = "Associate an NPC with a sector in the current campaign.",
  EditorViewNeg = Untranslated("Remove NPC <Name> from sector <u(Sector)>"),
  EditorNestedObjCategory = "Sector effects"
}
function AssociateNPCWithSector:__exec(obj, context)
  local sector = gv_Sectors[self.Sector]
  if not self.Negate then
    if not sector.NPCs then
      sector.NPCs = {}
    end
    sector.NPCs[#sector.NPCs + 1] = self.Name
    return
  elseif sector.NPCs then
    local idx = table.find(sector.NPCs, self.Name)
    if idx then
      table.remove(sector.NPCs, idx)
    end
  end
end
DefineClass.BanterSetUnitInteraction = {
  __parents = {
    "Effect",
    "UnitTarget",
    "BanterFunctionObjectBase"
  },
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Banters",
      name = "Banters",
      help = "List of banters to play.",
      editor = "preset_id_list",
      default = {},
      preset_class = "BanterDef",
      item_default = ""
    },
    {
      id = "Enabled",
      name = "Enabled",
      help = "Whether the banter is enabled.",
      editor = "bool",
      default = true
    }
  },
  EditorView = Untranslated("Set banters to play when interacting with unit."),
  Documentation = "Set banters to play when interacting with unit.",
  EditorNestedObjCategory = "Interactions"
}
function BanterSetUnitInteraction:GetError()
  if not self.Banters then
    return "No banters"
  end
  for i, banter_id in ipairs(self.Banters) do
    if not Banters[banter_id] then
      return "Invalid banter ID " .. banter_id
    end
  end
end
function BanterSetUnitInteraction:__exec(obj, context)
  context = type(context) == "table" and context or {}
  local triggered = self:MatchMapUnits(obj, context)
  if not triggered or not context.target_units then
    return
  end
  for i, unit in ipairs(context.target_units) do
    unit.banters = self.Enabled and table.copy(self.Banters)
  end
end
DefineClass.ChangeTiredness = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "delta",
      name = "Delta",
      editor = "number",
      default = 0
    }
  },
  RequiredObjClasses = {"Unit", "UnitData"},
  EditorView = Untranslated("Changes a unit's Energy"),
  Documentation = "Changes a unit's Energy",
  EditorNestedObjCategory = "Units"
}
function ChangeTiredness:__exec(obj, context)
  if IsKindOfClasses(obj, "Unit", "UnitData") and not obj:IsDead() then
    obj:ChangeTired(self.delta)
  end
end
DefineClass.CityGrantLoyalty = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "City",
      help = "Change loyalty of the specified city",
      editor = "choice",
      default = false,
      items = function(self)
        return table.map(GetCurrentCampaignPreset().Cities, "Id")
      end
    },
    {
      id = "Amount",
      help = "Amount of loyalty to change with.",
      editor = "number",
      default = 0
    },
    {
      id = "SpecialConversationMessage",
      name = "Special Conversation Message",
      help = "The message to display in the log when the effect is executed from a conversation phrase.",
      editor = "text",
      default = false,
      translate = true
    }
  },
  EditorView = Untranslated("Add <Amount> to city <u(City)> loyalty."),
  Documentation = "Grants a given value of loyalty to a given city. The loyalty can be negative."
}
function CityGrantLoyalty:GetError()
  if not self.City then
    return "Missing City"
  end
end
function CityGrantLoyalty:__exec(obj, context)
  local msgPrefix = false
  if IsKindOf(obj, "QuestsDef") and QuestIsBoolVar(obj, "Completed", true) then
    msgPrefix = T({
      858740141061,
      "Mission <DisplayName> completed",
      DisplayName = obj.DisplayName
    })
  else
    msgPrefix = self.SpecialConversationMessage or ""
  end
  CityModifyLoyalty(self.City, self.Amount, msgPrefix)
end
function CityGrantLoyalty:GetPhraseTopRolloverText(negative, template, game)
  local city = gv_Cities and gv_Cities[self.City]
  local city_name = city and city.DisplayName or Untranslated(self.City)
  if self.Amount > 0 then
    return T({
      571842717111,
      "Gained <em><Amount> Loyalty</em> with <em><City></em>",
      Amount = self.Amount,
      City = city_name
    })
  elseif self.Amount < 0 then
    return T({
      749649970601,
      "Lost <em><Amount> Loyalty</em> with <em><City></em>",
      Amount = -self.Amount,
      City = city_name
    })
  end
end
DefineClass.CompleteGuardpostObjective = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "GuardpostObjective",
      name = "GuardpostObjective",
      editor = "preset_id",
      default = false,
      preset_class = "GuardpostObjective"
    }
  },
  EditorView = Untranslated("Complete guardpost objective <u(GuardpostObjective)>"),
  Documentation = "Complete a guardpost objective, weakening the guardpost.",
  EditorNestedObjCategory = "Sectors"
}
function CompleteGuardpostObjective:__exec(obj, context)
  SetGuardpostObjectiveCompleted(self.GuardpostObjective)
end
DefineClass.ConversateWithUnit = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Group",
      name = "Group",
      help = "The group to affect. If left as default (empty) the interactable the effect is attached to will be affected.",
      editor = "combo",
      default = "",
      items = function(self)
        return GridMarkerGroupsCombo()
      end
    }
  },
  EditorView = Untranslated("Start a conversation with the unit of group"),
  Documentation = "Start a conversation with the unit of group",
  EditorNestedObjCategory = "Interactions"
}
function ConversateWithUnit:GetError()
  if not self.Group then
    return "No group"
  end
end
function ConversateWithUnit:__exec(obj, context)
  local interactable = false
  local allInGroup = Groups[self.Group]
  for i, obj in ipairs(allInGroup) do
    if IsKindOf(obj, "Interactable") then
      interactable = obj
      break
    end
  end
  if not interactable then
    return
  end
  local unitsOnMap = GetAllPlayerUnitsOnMap()
  local closestUnit = false
  local closestDistance = false
  for i, u in ipairs(unitsOnMap) do
    if CanInteractWith_SyncHelper(u, interactable) then
      local dist = IsValid(u) and u:GetDist(interactable)
      if not closestDistance or closestDistance > dist then
        closestDistance = dist
        closestUnit = u
      end
    end
  end
  if closestUnit then
    local conversation = FindEnabledConversation(interactable)
    if conversation then
      OpenConversationDialog(closestUnit, conversation, false, "interaction", interactable)
    end
  end
end
DefineClass.CustomCodeEffect = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "custom_code",
      name = "Custom Code",
      help = "Runs this code.",
      editor = "text",
      default = false
    }
  },
  EditorView = Untranslated("Execute custom code"),
  Documentation = "Executes custom code"
}
function CustomCodeEffect:__exec(obj, context)
  local custom_code_func, err = load(self.custom_code)
  if custom_code_func then
    procall(custom_code_func)
  else
    print(err)
  end
end
function CustomCodeEffect:GetError()
  if self.custom_code then
    local func, err = load(self.custom_code)
    if not func then
      return err
    end
  end
end
DefineClass.DisableInteractionMarkerEffect = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Group",
      name = "Group",
      help = "The group to affect. If left as default (empty) the interactable the effect is attached to will be affected.",
      editor = "combo",
      default = "",
      items = function(self)
        return GridMarkerGroupsCombo()
      end
    },
    {
      id = "Negate",
      name = "Negate",
      help = "Enable interaction markers instead.",
      editor = "bool",
      default = false
    }
  },
  Documentation = "Disable interaction markers of a specific group.",
  EditorNestedObjCategory = "Interactable"
}
function DisableInteractionMarkerEffect:__exec(obj, context)
  local groupName = self.Group
  if groupName == "" then
    if context and context.interactable and IsKindOf(context.interactable, "Interactable") then
      context.interactable.enabled = self.Negate
    else
      if IsKindOf(obj, "Interactable") then
        obj.enabled = self.Negate
      else
      end
    end
    return
  end
  MapForEach("map", "Interactable", function(m)
    if table.find(m.Groups, groupName) then
      m.enabled = self.Negate
    end
  end)
end
function DisableInteractionMarkerEffect:GetEditorView()
  if self.Group == "" then
    if self.Negate then
      return T(299761711576, "Enable attached interaction marker.")
    else
      return T(311484226676, "Disable attached interaction marker.")
    end
  end
  if self.Negate then
    return T({
      697268621451,
      "Enable interaction markers of group <u(Group)>",
      self
    })
  else
    return T({
      571476004863,
      "Disable interaction markers of group <u(Group)>",
      self
    })
  end
end
DefineClass.EndSectorWarningState = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  EditorView = Untranslated("End the current sector's Warning State"),
  Documentation = "End the Warning State for the current sector.",
  EditorNestedObjCategory = "Sector effects"
}
function EndSectorWarningState:__exec(obj, context)
  if gv_SatelliteView then
    return
  end
  EndWarningState()
end
DefineClass.ExecForEachUnitInSector = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Sector",
      help = "Sector id",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "Effects",
      name = "Effects",
      help = "Effects to execute.",
      editor = "nested_list",
      default = false,
      base_class = "Effect"
    }
  },
  Documentation = "Executes effects for all units in all squads in the given sector. Target unit effects must be with TargetUnit = \"current unit\"",
  EditorView = Untranslated("For each unit from sector '<u(Sector)>' execute all nested effects."),
  EditorNestedObjCategory = "Units"
}
function ExecForEachUnitInSector:__exec(obj, context)
  local effects = self.Effects
  if not effects then
    return true
  end
  context = context or {}
  context.is_sector_unit = true
  local squads = GetSquadsInSector(self.Sector)
  for i, squad in ipairs(squads) do
    for j, unit_id in ipairs(squad.units or empty_table) do
      local unit = gv_UnitData[unit_id]
      context.target_units = {unit}
      ExecuteEffectList(effects, unit, context)
    end
  end
  context.is_sector_unit = false
end
DefineClass.Explosion = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "LocationGroup",
      name = "Location Group",
      help = "Object group defining the location of the effect.",
      editor = "combo",
      default = false,
      items = function(self)
        return table.keys2(Groups)
      end
    },
    {
      id = "ExplosionType",
      help = "What kind of grenade/mine is the explosion caused by.",
      editor = "combo",
      default = "Landmine",
      items = function(self)
        return GrenadesComboItems({"Landmine"})
      end
    },
    {
      id = "Damage",
      help = "Damage to be done.",
      editor = "number",
      default = 30,
      min = 0,
      max = 200
    },
    {
      id = "AreaOfEffect",
      name = "Area of Effect",
      help = "the blast range (radius) in number of tiles.",
      editor = "number",
      default = 3,
      min = 0,
      max = 20
    },
    {
      id = "Noise",
      name = "Noise",
      help = "Range (in tiles) in which the explosion alerts unaware enemies.",
      editor = "number",
      default = 20,
      template = true,
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      id = "AppliedEffect",
      name = "Applied Effect",
      help = "What effect to be applied on the victim when the damage is dealt.",
      editor = "preset_id",
      default = false,
      preset_class = "CharacterEffectCompositeDef",
      preset_group = "Default"
    }
  },
  EditorView = T(892386429862, "Create an explosion"),
  Documentation = "Create an explosion"
}
function Explosion:GetError()
  if not self.LocationGroup then
    return "Set the Location Group"
  end
end
function Explosion:__exec(obj, context)
  local objs = Groups and self.LocationGroup and Groups[self.LocationGroup] or empty_table
  if #objs <= 0 then
    return
  end
  local pos = AveragePoint(objs)
  local weapon = PlaceObject(self.ExplosionType == "Landmine" and "Landmine" or "Grenade")
  weapon.AreaOfEffect = self.AreaOfEffect
  weapon.BaseDamage = self.Damage
  weapon.Noise = self.Noise
  weapon.AppliedEffect = self.AppliedEffect
  local proj = PlaceObject("FXGrenade")
  proj:SetPos(pos)
  proj.fx_actor_class = self.ExplosionType
  CreateGameTimeThread(function()
    ExplosionDamage(nil, weapon, pos, proj)
    DoneObject(proj)
    DoneObject(weapon)
  end)
end
DefineClass.FailGuardpostObjective = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "GuardpostObjective",
      name = "GuardpostObjective",
      editor = "preset_id",
      default = false,
      preset_class = "GuardpostObjective"
    }
  },
  EditorView = Untranslated("Fail guardpost objective <u(GuardpostObjective)>"),
  Documentation = "Fail a guardpost objective",
  EditorNestedObjCategory = "Sectors"
}
function FailGuardpostObjective:__exec(obj, context)
  SetGuardpostObjectiveFailed(self.GuardpostObjective)
end
DefineClass.ForceResetAmbientLife = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  EditorView = Untranslated("Forces Reset of Ambient Life Behavior(Alt-Shift-A cheat)"),
  Documentation = "Does the same thing as the Alt + Shift + A which resets the Ambient life"
}
function ForceResetAmbientLife:__exec(obj, context)
  Msg("AmbientLifeDespawn")
  Msg("WallVisibilityChanged")
  g_AmbientLifeSpawn = true
  Msg("AmbientLifeSpawn")
end
function ForceResetAmbientLife:__waitexec(obj, context)
  self:__exec(obj, context)
  WaitMsg("AmbientLifeSpawned")
end
function ForceResetAmbientLife:__skip(obj, context)
  self:__exec(obj, context)
end
DefineClass.GoBerserk = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  RequiredObjClasses = {"Unit"},
  EditorView = Untranslated("Go Berserk"),
  Documentation = "Go Berserk",
  EditorNestedObjCategory = "Units"
}
function GoBerserk:__exec(obj, context)
  if not IsKindOf(obj, "Unit") or not obj:IsDead() then
  end
end
DefineClass.GrantExperienceEffect = {
  __parents = {"UnitTarget", "Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Amount",
      name = "Amount",
      help = "Choose one of the predefined amounts",
      editor = "combo",
      default = "XPQuestReward_Small",
      items = function(self)
        return GetQuestRewardConstItems()
      end
    },
    {
      id = "logImportant",
      name = "Log as Important",
      help = "Whther to show the XP gain as important message in the combat log.",
      editor = "bool",
      default = false
    }
  },
  EditorView = T(785742586188, "Grant <u(Amount)> to unit <u(TargetUnit)>"),
  Documentation = "Grant experience to units. This is to be used when a map is loaded, for satellite view use GrantExperienceSector",
  EditorNestedObjCategory = "Units"
}
function GrantExperienceEffect:__exec(obj, context)
  context = context or {}
  local units = self:MatchMapUnits(obj, context)
  if units and context.target_units then
    local amount = self.Amount
    if type(amount) == "string" then
      if const[amount] then
        amount = const[amount]
      else
        amount = tonumber(amount)
      end
    end
    RewardTeamExperience({RewardExperience = amount}, {
      units = context.target_units
    }, self.logImportant)
  end
end
function GrantExperienceEffect:UnitCheck(unit, obj, context)
  return true
end
DefineClass.GrantExperienceSector = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Sector",
      name = "Sector",
      help = "Sector",
      editor = "combo",
      default = "current",
      items = function(self)
        return table.iappend({
          {text = "current", value = "current"}
        }, GetCampaignSectorsCombo())
      end
    },
    {
      id = "Amount",
      name = "Amount",
      help = "Choose one of the predefined amounts",
      editor = "combo",
      default = "XPQuestReward_Small",
      items = function(self)
        return GetQuestRewardConstItems()
      end
    },
    {
      id = "logImportant",
      name = "Log as Important",
      help = "Whther to show the XP gain as important message in the combat log.",
      editor = "bool",
      default = false
    }
  },
  EditorView = T(990833526031, "Grant <u(Amount)> to all player units on sector <u(Sector)>"),
  Documentation = "Grant experience to all player mercs on the specified sector.",
  EditorNestedObjCategory = "Units"
}
function GrantExperienceSector:__exec(obj, context)
  local sector_id
  local getUnits = false
  if self.Sector == "current" then
    sector_id = gv_CurrentSectorId
    getUnits = not gv_SatelliteView
  else
    sector_id = self.Sector
  end
  local units = GetPlayerSectorUnits(sector_id, getUnits)
  if units then
    local amount = self.Amount
    if type(amount) == "string" then
      if const[amount] then
        amount = const[amount]
      else
        amount = tonumber(amount)
      end
    end
    RewardTeamExperience({RewardExperience = amount}, {units = units, sector = sector_id}, self.logImportant)
  end
end
function GrantExperienceSector:GetError()
  local amount = self.Amount
  if type(amount) == "string" and not const[amount] and not tonumber(amount) then
    return "Invalid amount " .. tostring(amount) .. " - should be a number or a const"
  end
end
function GrantExperienceSector:UnitCheck(unit, obj, context)
  return true
end
function GrantExperienceSector:GetPhraseTopRolloverText(negative, template, game)
  local sector_id
  local getUnits = false
  if self.Sector == "current" then
    sector_id = gv_CurrentSectorId
    getUnits = not gv_SatelliteView
  else
    sector_id = self.Sector
  end
  local units = game and GetPlayerSectorUnits(sector_id, getUnits) or T(111137020067, "[Mercs]")
  local names = game and ConcatListWithAnd(table.map(units, function(o)
    return o.Nick
  end)) or units
  local amount = self.Amount
  if type(amount) == "string" then
    if const[amount] then
      amount = const[amount]
    else
      amount = tonumber(amount)
    end
  end
  if 0 < amount then
    return T({
      894599074999,
      "Gained XP: <unit> (<Amount>)",
      Amount = amount,
      unit = names
    })
  elseif amount < 0 then
    return T({
      955913519115,
      "Lost XP: <unit> (<Amount>)",
      Amount = amount,
      unit = names
    })
  end
end
DefineClass.GroupAddStatusEffect = {
  __parents = {"Effect", "UnitTarget"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Status",
      name = "Status",
      editor = "preset_id",
      default = false,
      preset_class = "CharacterEffectCompositeDef"
    }
  },
  EditorView = Untranslated("Add <u(Status)> effect to units in group <u(TargetUnit)>"),
  Documentation = "Add status effect to units in group",
  EditorNestedObjCategory = "Units"
}
function GroupAddStatusEffect:__exec(obj, context)
  context = type(context) == "table" and context or {}
  self:MatchMapUnits(obj, context)
  for _, unit in ipairs(context.target_units) do
    if IsKindOf(unit, "StatusEffectObject") then
      unit:AddStatusEffect(self.Status)
    end
  end
  if not next(context.target_units) then
    print("GroupAddStatusEffect couldn't find group", self.TargetUnit)
    return
  end
end
DefineClass.GroupAlert = {
  __parents = {"Effect", "UnitTarget"},
  __generated_by_class = "EffectDef",
  EditorView = Untranslated("Alert units from <u(TargetUnit)>"),
  Documentation = "Alert units from given group",
  EditorNestedObjCategory = "Units"
}
function GroupAlert:__exec(obj, context)
  context = type(context) == "table" and context or {}
  self:MatchMapUnits(obj, context)
  local units = {}
  for _, unit in ipairs(context.target_units) do
    if IsKindOf(unit, "Unit") then
      units[#units + 1] = unit
    end
  end
  if not next(units) then
    print("GroupAlert couldn't find group", self.TargetUnit)
    return
  end
  CreateGameTimeThread(function()
    gv_CombatStartFromConversation = true
    TriggerUnitAlert("script", units, "aware")
  end, units)
end
DefineClass.GroupAssignToArea = {
  __parents = {"Effect", "UnitTarget"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Mode",
      name = "Assign Mode",
      editor = "combo",
      default = "overwrite",
      items = function(self)
        return {
          "overwrite",
          "add",
          "clear"
        }
      end
    },
    {
      id = "IndividualAreas",
      editor = "string_list",
      default = {},
      no_edit = function(self)
        return self.Mode == "clear"
      end,
      no_validate = true,
      item_default = "",
      items = function(self)
        return GridMarkerFightAreaCombo("")
      end,
      max_items = 64
    }
  },
  EditorView = Untranslated("Assign units from <u(TargetUnit)> to tactical area(s)"),
  Documentation = "Assigns units from given group to tactical area(s)",
  EditorNestedObjCategory = "Units"
}
function GroupAssignToArea:__exec(obj, context)
  if not g_TacticalMap then
    return
  end
  context = type(context) == "table" and context or {}
  self:MatchMapUnits(obj, context)
  local reset = self.Mode == "overwrite"
  local area
  if self.Mode ~= "clear" and #(self.IndividualAreas or empty_table) > 0 then
    area = self.IndividualAreas
  end
  for _, unit in ipairs(context.target_units) do
    if IsKindOf(unit, "Unit") then
      g_TacticalMap:AssignUnit(unit, area, reset)
    end
  end
end
function GroupAssignToArea:GetEditorView()
  if self.Mode == "clear" or #(self.IndividualAreas or empty_table) == 0 then
    return Untranslated("Clear assignment for units from <u(TargetUnit)>")
  else
    local areas = ""
    for _, area in ipairs(self.IndividualAreas) do
      if #areas == 0 then
        areas = area
      else
        areas = areas .. ", " .. area
      end
    end
    if self.Mode == "add" then
      return Untranslated(string.format("Add areas to assignement for units from <u(TargetUnit)>: [%s]", areas))
    end
    return Untranslated(string.format("Assign units from <u(TargetUnit)> to areas [%s]", areas))
  end
  return self.EditorView
end
DefineClass.GroupChangeName = {
  __parents = {"Effect", "UnitTarget"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "ChangeName",
      name = "Change Name",
      help = "Name to be changed to",
      editor = "text",
      default = false,
      translate = true
    }
  },
  EditorView = Untranslated("Change the name for units from <u(TargetUnit)> to <u(ChangeName)>"),
  Documentation = "Change the name of units from given group",
  EditorNestedObjCategory = "Units"
}
function GroupChangeName:__exec(obj, context)
  context = type(context) == "table" and context or {}
  self:MatchMapUnits(obj, context)
  for _, unit in ipairs(context.target_units) do
    if IsKindOf(unit, "Unit") then
      unit.Name = self.ChangeName
      ObjModified(unit)
    end
  end
  if not next(context.target_units) then
    print(self.id, " couldn't find any units of: ", self.TargetUnit)
    return
  end
end
function GroupChangeName:GetError()
  if not self.ChangeName then
    return "Set Change Name"
  end
end
DefineClass.GroupChangeTiredness = {
  __parents = {"Effect", "UnitTarget"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Mode",
      editor = "choice",
      default = "Absolute",
      items = function(self)
        return {"Absolute", "Delta"}
      end
    },
    {
      id = "Level",
      editor = "choice",
      default = 0,
      no_edit = function(self)
        return self.Mode ~= "Absolute"
      end,
      items = function(self)
        return UnitTirednessComboItems
      end
    },
    {
      id = "Delta",
      editor = "number",
      default = 1,
      no_edit = function(self)
        return self.Mode == "Absolute"
      end
    }
  },
  EditorView = Untranslated("Change Energy for units from <u(TargetUnit)>"),
  Documentation = "Change Energy for units from given group",
  EditorNestedObjCategory = "Units"
}
function GroupChangeTiredness:__exec(obj, context)
  context = type(context) == "table" and context or {}
  self:MatchMapUnits(obj, context)
  for _, unit in ipairs(context.target_units) do
    if IsKindOf(unit, "Unit") then
      if self.Mode == "Absolute" then
        unit:SetTired(self.Level)
      else
        unit:ChangeTired(self.Delta)
      end
    end
  end
  if not next(context.target_units) then
    print("GroupChangeTiredness couldn't find any units of: ", self.TargetUnit)
    return
  end
end
function GroupChangeTiredness:GetError()
  if self.Mode == "Delta" and self.Delta == 0 then
    return "No effect"
  end
end
DefineClass.GroupRemoveStatusEffect = {
  __parents = {"Effect", "UnitTarget"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Status",
      name = "Status",
      editor = "preset_id",
      default = false,
      preset_class = "CharacterEffectCompositeDef"
    }
  },
  EditorView = Untranslated("Remove <u(Status)> effect from units in group <u(TargetUnit)>"),
  Documentation = "Remove status effect from units in group",
  EditorNestedObjCategory = "Units"
}
function GroupRemoveStatusEffect:__exec(obj, context)
  context = type(context) == "table" and context or {}
  self:MatchMapUnits(obj, context)
  for _, o in ipairs(context.target_units) do
    if IsKindOf(o, "StatusEffectObject") then
      o:RemoveStatusEffect(self.Status)
    end
  end
  if not next(context.target_units) then
    print("GroupRemoveStatusEffect couldn't find any units of: ", self.TargetUnit)
    return
  end
end
DefineClass.GroupSetAITargetModifier = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Group",
      name = "Group",
      help = "Unit group that will receive the modifier",
      editor = "combo",
      default = "false",
      items = function(self)
        return GetUnitGroups()
      end
    },
    {
      id = "Target",
      help = "Target unit group subject to the modifier",
      editor = "combo",
      default = "false",
      items = function(self)
        return GetUnitGroups()
      end
    },
    {
      id = "Modifier",
      help = "Modifier value, 100% means no modification (reset to default)",
      editor = "number",
      default = 100,
      scale = "%"
    }
  },
  EditorView = Untranslated("AI target modifier for <u(Group)> against <u(Target)> <Modifier>%"),
  Documentation = "Set AI Targeting modifier of a group of units against another group",
  EditorNestedObjCategory = "Units"
}
function GroupSetAITargetModifier:__exec(obj, context)
  if self.Modifier == 100 then
    if gv_AITargetModifiers[self.Group] then
      gv_AITargetModifiers[self.Group][self.Target] = nil
      if next(gv_AITargetModifiers[self.Group]) == nil then
        gv_AITargetModifiers[self.Group] = nil
      end
    end
  else
    gv_AITargetModifiers[self.Group] = gv_AITargetModifiers[self.Group] or {}
    gv_AITargetModifiers[self.Group][self.Target] = self.Modifier
  end
end
DefineClass.GroupSetArchetype = {
  __parents = {"Effect", "UnitTarget"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Archetype",
      editor = "choice",
      default = "<default>",
      items = function(self)
        return table.keys2(Archetypes, true, "<default>")
      end
    }
  },
  EditorView = Untranslated("Change archetype for units from <u(TargetUnit)>"),
  Documentation = "Change archetype for units from given group",
  EditorNestedObjCategory = "Units"
}
function GroupSetArchetype:__exec(obj, context)
  context = type(context) == "table" and context or {}
  self:MatchMapUnits(obj, context)
  local units = {}
  local archetype = self.Archetype
  if archetype == "<default>" then
    archetype = nil
  end
  for _, unit in ipairs(context.target_units) do
    if IsKindOf(unit, "Unit") then
      unit.script_archetype = archetype
    end
  end
end
DefineClass.GroupSetBehaviorAdvanceTo = {
  __parents = {
    "Effect",
    "AnimParams",
    "UnitTarget"
  },
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "MarkerId",
      help = "Marker description: can specify an id.",
      editor = "text",
      default = false
    },
    {
      id = "MarkerGroup",
      help = "Marker description: marker group.",
      editor = "combo",
      default = "",
      items = function(self)
        return GetBehaviorGroups
      end
    },
    {
      id = "MarkerType",
      help = "Marker description: markers type.",
      editor = "combo",
      default = "Position",
      items = function(self)
        return GetGridMarkerTypesCombo
      end
    },
    {
      id = "PropagateAnimParams",
      help = "AdvanceTo behavior passes the control to Roam behavior on finish and if this checked all the AnimParams here will be propagated to Roam",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("<u(TargetUnit)> Advance(s) to the marker"),
  Documentation = "Set units behavior to Advance towar a map marker.",
  EditorNestedObjCategory = "Units"
}
function GroupSetBehaviorAdvanceTo:__exec(obj, context)
  local markers = MapGetMarkers(self.MarkerType, self.MarkerGroup, function(o)
    return o:IsMarkerEnabled() and (self.MarkerId or "" == "" or o.ID == self.MarkerID)
  end)
  if #(markers or empty_table) == 0 then
    printf("SetBehaviorAdvanceTo didn't find any markers (type %s, group %s, id %s)", tostring(self.MarkerType), tostring(self.MarkerGroup), tostring(self.MarkerId))
    return
  end
  if g_Combat then
    return
  end
  context = type(context) == "table" and context or {}
  self:MatchMapUnits(obj, context)
  local params = self:GetAnimParams()
  params.PropagateAnimParams = self.PropagateAnimParams
  for _, o in ipairs(context.target_units) do
    if IsKindOf(o, "Unit") and not o:IsDead() then
      local marker = table.interaction_rand(markers, "GridMarker", o)
      o:SetCommandParams("AdvanceTo", params)
      o:SetCommand("AdvanceTo", marker:GetHandle())
    end
  end
end
DefineClass.GroupSetBehaviorExit = {
  __parents = {
    "Effect",
    "AnimParams",
    "UnitTarget"
  },
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "MarkerGroup",
      help = "Exit marker group.",
      editor = "combo",
      default = "",
      no_edit = function(self)
        return self.closest
      end,
      items = function(self)
        return GetBehaviorGroups
      end
    },
    {
      id = "closest",
      name = "Closest Available",
      editor = "bool",
      default = false
    },
    {
      id = "delay",
      name = "Delay",
      editor = "number",
      default = 0,
      scale = "sec",
      min = 0
    }
  },
  EditorView = Untranslated("<u(TargetUnit)> exit the map via <u(MarkerGroup)> marker"),
  Documentation = "Units exit the map using a specified marker",
  EditorNestedObjCategory = "Units"
}
function GroupSetBehaviorExit:__exec(obj, context)
  context = type(context) == "table" and context or {}
  self:MatchMapUnits(obj, context)
  local units = context.target_units
  for i = #units, 1, -1 do
    if not IsKindOf(units[i], "Unit") then
      table.remove(units, i)
    end
  end
  local marker_group = not self.closest and self.MarkerGroup or ""
  local markers = MapGetMarkers("Entrance", marker_group)
  if #(units or empty_table) == 0 or #markers == 0 then
    return
  end
  local marker
  if marker_group == "" then
    local ucenter = AveragePoint2D(units)
    marker = ChooseClosestObject(markers, ucenter)
  else
    marker = table.interaction_rand(markers, "GridMarker")
  end
  local start_time = self.delay + GameTime()
  if g_Combat then
    for _, unit in ipairs(units) do
      if not unit:IsDead() then
        unit:SetBehavior("ExitMap", {marker, start_time})
      end
    end
  else
    local params = self:GetAnimParams()
    for _, unit in ipairs(units) do
      if not unit:IsDead() then
        unit:SetCommandParams("ExitMap", params)
        unit:SetCommand("ExitMap", marker, start_time)
      end
    end
  end
end
function GroupSetBehaviorExit:GetEditorView()
  return Untranslated("Set behavior of <u(TargetUnit)> to ExitMap at <u(MarkerGroup)>")
end
DefineClass.GroupSetBehaviorIdle = {
  __parents = {
    "Effect",
    "AnimParams",
    "UnitTarget"
  },
  __generated_by_class = "EffectDef",
  EditorView = Untranslated("Set behavior of <u(TargetUnit)> to Idle"),
  Documentation = "Set units behavior to Idle",
  EditorNestedObjCategory = "Units"
}
function GroupSetBehaviorIdle:__exec(obj, context)
  context = type(context) == "table" and context or {}
  self:MatchMapUnits(obj, context)
  local params = self:GetAnimParams()
  for _, o in ipairs(context.target_units) do
    if IsKindOf(o, "Unit") and not o:IsDead() then
      o:SetBehavior()
      o:SetCommandParams("Idle", params)
      o:SetCommand("Idle")
    end
  end
end
DefineClass.GroupSetBehaviorPatrol = {
  __parents = {
    "Effect",
    "AnimParams",
    "UnitTarget"
  },
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "MarkerGroup",
      help = "Patrol markers group",
      editor = "combo",
      default = "",
      items = function(self)
        return GetBehaviorGroups
      end
    },
    {
      id = "Repeat",
      name = "Repeat Route",
      help = "Repeat route?",
      editor = "bool",
      default = false
    },
    {
      id = "Orient",
      name = "End Orient",
      help = "Use marker orientation on the end",
      editor = "bool",
      default = true
    }
  },
  EditorView = Untranslated("<u(TargetUnit)> patrol(s) between <u(MarkerGroup)> markers"),
  Documentation = "Set unit behavior to Patrol between markers",
  EditorNestedObjCategory = "Units"
}
function GroupSetBehaviorPatrol:__exec(obj, context)
  context = type(context) == "table" and context or {}
  self:MatchMapUnits(obj, context)
  local params = self:GetAnimParams()
  for _, o in ipairs(context.target_units) do
    if IsKindOf(o, "Unit") and not o:IsDead() then
      o:SetCommandParams("Patrol", params)
      local behaviorParams = {
        self.MarkerGroup,
        1,
        self.Repeat,
        self.Orient
      }
      if g_Combat then
        o:SetBehavior("Patrol", behaviorParams)
      elseif o.being_interacted_with then
        o:QueueCommand("Patrol", unpack_params(behaviorParams))
      else
        o:SetCommand("Patrol", unpack_params(behaviorParams))
      end
    end
  end
end
DefineClass.GroupSetBehaviorRoam = {
  __parents = {
    "Effect",
    "AnimParams",
    "UnitTarget"
  },
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "MarkerId",
      help = "Marker description: can specify an id.",
      editor = "text",
      default = false
    },
    {
      id = "MarkerGroup",
      help = "Marker description: marker group.",
      editor = "combo",
      default = "",
      items = function(self)
        return GetBehaviorGroups
      end
    },
    {
      id = "MarkerType",
      help = "Marker description: markers type.",
      editor = "combo",
      default = "Position",
      items = function(self)
        return GetGridMarkerTypesCombo
      end
    },
    {
      id = "Orient",
      name = "End Orient",
      help = "Use marker orientation on the end",
      editor = "bool",
      default = true
    }
  },
  EditorView = Untranslated("<u(TargetUnit)> roam(s) around marker"),
  Documentation = "Set units behavior to Roam around a map's marker.",
  EditorNestedObjCategory = "Units"
}
function GroupSetBehaviorRoam:__exec(obj, context)
  context = type(context) == "table" and context or {}
  self:MatchMapUnits(obj, context)
  local markers = MapGetMarkers(self.MarkerType, self.MarkerGroup, function(o)
    return o:IsMarkerEnabled() and (self.MarkerId or "" == "" or o.ID == self.MarkerID)
  end)
  if #(markers or empty_table) == 0 then
    printf("SetBehaviorRoam didn't find any markers (type %s, group %s, id %s)", tostring(self.MarkerType), tostring(self.MarkerGroup), tostring(self.MarkerId))
    return
  end
  local params = self:GetAnimParams()
  for _, o in ipairs(context.target_units) do
    if IsKindOf(o, "Unit") and not o:IsDead() then
      local marker = table.interaction_rand(markers, "GridMarker", o)
      o:SetCommandParams("Roam", params)
      if g_Combat then
        o:SetBehavior("Roam", {
          marker,
          self.Orient
        })
      elseif o.being_interacted_with then
        o:QueueCommand("Roam", marker, self.Orient)
      else
        o:SetCommand("Roam", marker, self.Orient)
      end
    end
  end
end
DefineClass.GroupSetImmortal = {
  __parents = {"Effect", "UnitTarget"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "setImmortal",
      name = "Set immortal to",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("Set the immortal property of units from <u(TargetUnit)> to <select(setImmortal, 'false', 'true')>"),
  Documentation = "Set the immortal property of units from a given group.",
  EditorNestedObjCategory = "Units"
}
function GroupSetImmortal:__exec(obj, context)
  context = type(context) == "table" and context or {}
  self:MatchMapUnits(obj, context)
  for _, unit in ipairs(context.target_units) do
    if IsKindOf(unit, "Unit") then
      unit.immortal = self.setImmortal
      ObjModified(unit)
    end
  end
  if not next(context.target_units) then
    print(self.id, " couldn't find any units of: ", self.TargetUnit)
    return
  end
end
DefineClass.GroupSetInfected = {
  __parents = {"Effect", "UnitTarget"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "setInfected",
      name = "Set infected to",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("Set the infected property of units from <u(TargetUnit)> to <select(setInfected, 'false', 'true')>"),
  Documentation = "Set the infected property of units from a given group. (Some animations change based on this property)",
  EditorNestedObjCategory = "Units"
}
function GroupSetInfected:__exec(obj, context)
  context = type(context) == "table" and context or {}
  self:MatchMapUnits(obj, context)
  for _, unit in ipairs(context.target_units) do
    if IsKindOf(unit, "Unit") then
      unit.infected = self.setInfected
      ObjModified(unit)
    end
  end
  if not next(context.target_units) then
    print(self.id, " couldn't find any units of: ", self.TargetUnit)
    return
  end
end
DefineClass.GroupSetRoutine = {
  __parents = {
    "Effect",
    "AnimParams",
    "UnitTarget"
  },
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Routine",
      help = "Set units of group to particular routine, or the one from their spawner.",
      editor = "combo",
      default = "spawner",
      items = function(self)
        local r = table.copy(UnitRoutines)
        r[#r + 1] = "spawner"
        return r
      end
    },
    {
      id = "RoutineArea",
      help = "Area to play the routine in, or use the one from the spawner.",
      editor = "combo",
      default = "spawner",
      items = function(self)
        local g = table.copy(GridMarkerGroupsCombo())
        g[1 + #g] = "spawner"
        return g
      end
    },
    {
      id = "PropagateAnimParams",
      help = "AdvanceTo behavior passes the control to Roam behavior on finish and if this checked all the AnimParams here will be propagated to Roam",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("Set routine of <u(TargetUnit)> to <u(Routine)>"),
  Documentation = "Set routine of units",
  EditorNestedObjCategory = "Units"
}
function GroupSetRoutine:__exec(obj, context)
  context = type(context) == "table" and context or {}
  self:MatchMapUnits(obj, context)
  local params = self:GetAnimParams()
  params.PropagateAnimParams = self.PropagateAnimParams
  for _, o in ipairs(context.target_units) do
    if IsKindOf(o, "Unit") then
      o.routine = self.Routine == "spawner" and o.routine_spawner.Routine or self.Routine
      o.routine_area = self.RoutineArea == "spawner" and "self" or self.RoutineArea
      o.behavior = false
      o:SetCommandParams("Idle", params)
      o:SetCommand("Idle")
    end
  end
end
DefineClass.GroupSetSide = {
  __parents = {"Effect", "UnitTarget"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Side",
      help = "The new side of group.",
      editor = "choice",
      default = false,
      items = function(self)
        return table.map(GetCurrentCampaignPreset().Sides, "Id")
      end
    },
    {
      id = "CreateSquad",
      help = "If set to false the units will not create a new squad. Keep in mind they will be ejected from their old squad so they will despawn on the next presence check.",
      editor = "bool",
      default = true
    }
  },
  EditorView = Untranslated("Change the side of <u(TargetUnit)> to <u(Side)>"),
  Documentation = "Change groups side",
  EditorNestedObjCategory = "Units"
}
function GroupSetSide:__exec(obj, context)
  context = type(context) == "table" and context or {}
  self:MatchMapUnits(obj, context)
  if not next(context.target_units) then
    print("GroupSetSide couldn't find group", self.TargetUnit)
    return
  end
  if self.CreateSquad then
    local squads = {}
    for _, o in ipairs(context.target_units) do
      if IsKindOf(o, "Unit") and o.Squad then
        table.insert_unique(squads, o.Squad)
        local memberArrayName = "members" .. o.Squad
        local memberArray = squads[memberArrayName]
        if not memberArray then
          memberArray = {}
          squads[memberArrayName] = memberArray
        end
        memberArray[#memberArray + 1] = o.session_id
      end
    end
    for i, s in ipairs(squads) do
      local squadObj = gv_Squads[s]
      local createNew = false
      if squadObj.Side ~= self.Side then
        local units = squadObj.units
        for _, u in ipairs(units) do
          local unit = g_Units[u]
          if not table.find(context.target_units, unit) then
            createNew = true
            break
          end
        end
      end
      if createNew then
        local unitsToChangeSide = squads["members" .. s]
        CreateNewSatelliteSquad({
          Side = self.Side,
          CurrentSector = squadObj.CurrentSector,
          Name = SquadName:GetNewSquadName(self.Side, unitsToChangeSide)
        }, unitsToChangeSide)
      else
        SetSatelliteSquadSide(s, self.Side)
      end
    end
  else
    for _, o in ipairs(context.target_units) do
      if IsKindOf(o, "Unit") then
        local ud = gv_UnitData[o.session_id]
        RemoveUnitFromSquad(ud, "script")
        if self.Side == "neutral" then
          function o.IsMerc()
            return false
          end
        end
      end
    end
  end
  for _, o in ipairs(context.target_units) do
    if IsKindOf(o, "Unit") then
      o:SetSide(self.Side)
    end
  end
  Msg("GroupChangeSide", self.TargetUnit, self.Side, context.target_units)
  CheckGameOver()
end
function GroupSetSide:__waitexec(obj, context)
  self:__exec(obj, context)
end
function GroupSetSide:GetError()
  if not self.Side then
    return "Set the new side!"
  end
end
DefineClass.GroupTeleport = {
  __parents = {
    "Effect",
    "AnimParams",
    "UnitTarget"
  },
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "MarkerGroup",
      help = "Marker group where the units should be teleported to.",
      editor = "combo",
      default = "",
      items = function(self)
        return GetBehaviorGroups
      end
    }
  },
  EditorView = Untranslated("<u(TargetUnit)> will be teleported to <u(MarkerGroup)> marker"),
  Documentation = "Units group teleports to a specified marker",
  EditorNestedObjCategory = "Units"
}
function GroupTeleport:__exec(obj, context)
  context = type(context) == "table" and context or {}
  self:MatchMapUnits(obj, context)
  local units = context.target_units
  for i = #units, 1, -1 do
    if not IsKindOf(units[i], "Unit") then
      table.remove(units, i)
    end
  end
  local markers = MapGetMarkers(nil, self.MarkerGroup)
  if #(units or empty_table) == 0 then
    return string.format("No units from group '%s' to teleport", self.TargetUnit)
  end
  if #markers == 0 then
    return string.format("No markets in '%s' to teleport group '%s' to", self.MarkerGroup, self.TargetUnit)
  end
  local unit_pos, units_left = {}
  for _, marker in ipairs(markers) do
    units_left = {}
    local dest = GetUnitsDestinations(units, marker)
    for idx, unit in ipairs(units) do
      if dest[idx] then
        table.insert(unit_pos, unit)
        unit_pos[unit] = point(point_unpack(dest[idx]))
      else
        table.insert(units_left, unit)
      end
    end
    if #units_left == 0 then
      break
    end
    units = units_left
  end
  if 0 < #units_left then
    for _, unit in ipairs(units_left) do
      StoreErrorSource(unit, string.format("No position found for group '%s' teleport to markers '%s'!", self.TargetUnit, self.MarkerGroup))
    end
  end
  for _, unit in ipairs(unit_pos) do
    NetSyncEvent("StartCombatAction", netUniqueId, "Teleport", unit, g_Combat and 0 or false, unit_pos[unit])
  end
  return string.format("%d unit(s) from '%s' teleported to '%s'", #units, self.TargetUnit, self.MarkerGroup)
end
function GroupTeleport:GetEditorView()
  return Untranslated("Teleport <u(Group)> to <u(MarkerGroup)>")
end
DefineClass.Heal = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  RequiredObjClasses = {"Unit", "UnitData"},
  EditorView = Untranslated("Restore unit's health"),
  Documentation = "Restores unit's health",
  EditorNestedObjCategory = "Units"
}
function Heal:__exec(obj, context)
  if IsKindOf(obj, "UnitData") then
    HealUnitData(obj)
  else
    obj:ReviveOnHealth()
  end
end
DefineClass.HealWounds = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  RequiredObjClasses = {"Unit"},
  EditorView = Untranslated("Heal unit's wounds"),
  Documentation = "Heals unit's wounds",
  EditorNestedObjCategory = "Units"
}
function HealWounds:__exec(obj, context)
  obj:RemoveStatusEffect("Wounded", "all")
end
DefineClass.HerbalMedicineEffect = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "berserkChance",
      name = "Berserk Chance",
      editor = "number",
      default = 15
    },
    {
      id = "apChance",
      name = "AP Chance",
      editor = "number",
      default = 15
    }
  },
  RequiredObjClasses = {"Unit", "UnitData"},
  EditorView = Untranslated("Grant AP or Go Berserk"),
  Documentation = "Grant AP or Go Berserk",
  EditorNestedObjCategory = "Units"
}
function HerbalMedicineEffect:__exec(obj, context)
  if IsKindOf(obj, "Unit") and not obj:IsDead() then
    local berserkRoll = InteractionRand(100, "HerbalMedicine")
    local apRoll = InteractionRand(100, "HerbalMedicine")
    if berserkRoll < self.berserkChance then
    end
    if apRoll < self.apChance then
    end
  end
end
DefineClass.HideQuestBadge = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Show",
      help = "Show the badge instead. (if it was hidden with this effect)",
      editor = "bool",
      default = false
    },
    {
      id = "Quest",
      name = "Quest",
      help = "Which quest to associate this badge with. If the effect is placed on a quest it will attempt to find it itself.",
      editor = "preset_id",
      default = false,
      preset_class = "QuestsDef"
    },
    {
      id = "BadgeIdx",
      name = "Badge Id",
      editor = "number",
      default = 1,
      sort_order = 9,
      min = 1
    },
    {
      id = "Preview",
      editor = "text",
      default = false,
      dont_save = true,
      read_only = true,
      sort_order = 10
    },
    {
      id = "LogLine",
      name = "Log Line",
      help = "Change the state of that line.",
      editor = "choice",
      default = false,
      items = function(self)
        return GetQuestNoteLinesCombo(self.Quest)
      end
    }
  },
  Documentation = "Hide a quest badge",
  EditorNestedObjCategory = "Units"
}
function HideQuestBadge:__exec(obj, context)
  local questState = self.Quest and gv_Quests[self.Quest] or IsKindOf(obj, "QuestsDef") and obj or false
  if not questState then
    return
  end
  local magicParam = badgeHideIdentifierNote
  local preset, index = self:GetLinePreset()
  if not preset then
    return
  end
  magicParam = magicParam .. tostring(index) .. "@" .. tostring(self.BadgeIdx)
  if self.Show then
    questState[magicParam] = nil
  else
    questState[magicParam] = true
  end
  UpdateQuestBadges(questState)
  if g_SatelliteUI then
    local badge = preset.Badges[self.BadgeIdx]
    if badge and badge.Sector then
      g_SatelliteUI:UpdateSectorVisuals(badge.Sector)
    end
  end
end
function HideQuestBadge:GetError()
  if not self.Quest or self.Quest == "" then
    return "Specify the quest!"
  end
  if not Quests[self.Quest] then
    return "Missing quest!"
  end
  if not self.LogLine then
    return "Specify the line!"
  end
  local preset = self:GetLinePreset()
  if not preset then
    return "Invalid line!"
  end
  if not preset.Badges or #preset.Badges == 0 then
    return "This line doesn't place badges."
  end
  if self.BadgeIdx > #preset.Badges then
    return "Badge id out of range"
  end
end
function HideQuestBadge:GetLinePreset()
  local line = self.LogLine
  local quest = Quests[self.Quest]
  if not quest or not line then
    return
  end
  local notePreset = table.find_value(quest.NoteDefs, "Idx", line)
  if not notePreset then
    return
  end
  return notePreset, line
end
function HideQuestBadge:GetEditorView()
  local actionWord = self.Show and "Show " or "Hide "
  actionWord = actionWord .. self.BadgeIdx .. " "
  if self.LogLine then
    local linePreset = self:GetLinePreset()
    if not linePreset then
      return Untranslated("Hide Badge: Missing quest!")
    end
    local text = linePreset and linePreset.Text or "log line not found"
    if linePreset.Badges then
      local badge = linePreset.Badges[self.BadgeIdx]
      self.Preview = "Badge on " .. (badge.BadgeUnit or "") .. " in " .. (badge.Sector or "")
      return Untranslated(actionWord .. "badge placed by <u(Quest)>: ") .. Untranslated(text)
    else
      self.Preview = "Invalid badge"
      return Untranslated("Invalid badge")
    end
  else
    self.Preview = ""
    return Untranslated(actionWord .. "badge placed by <u(Quest)>: invalid log line specified")
  end
end
DefineClass.InteractingMercReduceItemCondition = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "ItemId",
      editor = "combo",
      default = false,
      items = function(self)
        return ClassDescendantsCombo("InventoryItem")
      end
    },
    {
      id = "Equipped",
      editor = "bool",
      default = false
    },
    {
      id = "ReduceAmount",
      editor = "number",
      default = 1,
      min = 1
    }
  },
  Documentation = "Reduce the condition of an interaction merc's item",
  EditorView = Untranslated("Reduce the condition of interaction merc's <u(ItemId)> by <ReduceAmount>")
}
function InteractingMercReduceItemCondition:__exec(obj, context)
  local unit = context and context.target_units
  unit = unit and unit[1]
  if not unit then
    return
  end
  local item = false
  if self.Equipped then
    item = unit:GetItemInSlot("Handheld A", self.ItemId) or unit:GetItemInSlot("Handheld B", self.ItemId)
  else
    item = unit:GetItemInSlot("Inventory", self.ItemId)
  end
  if not item then
    return
  end
  unit:ItemModifyCondition(item, -self.ReduceAmount)
  CombatLog("short", T({
    597332256786,
    "<DisplayName> condition decreased by <dmg>.",
    DisplayName = item.DisplayName,
    dmg = self.ReduceAmount
  }))
end
function InteractingMercReduceItemCondition:GetError()
  if not self.ItemId then
    return "Set Item!"
  end
end
DefineClass.KillTimer = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Name",
      name = "Name",
      help = "Name of the timer.",
      editor = "text",
      default = false
    },
    {
      id = "StopTCE",
      name = "Stop TCE",
      help = "Wether to execute the effects after the timer or not.",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("Kill timer <Name>"),
  Documentation = "Kills the visual UI timer displayed in the upper center of the screen",
  EditorNestedObjCategory = "UI & Log"
}
function KillTimer:__exec(quest, context, TCE)
  local data = TimerGetData(self.Name)
  if data then
    data.time = 0
    data.StopTCE = self.StopTCE
    Msg("TimerFinished", data.id)
  end
end
function KillTimer:GetError()
  if not self.Name then
    return "KillTimer needs a name!"
  end
  if GetParentTableOfKindNoCheck(self, "TestHarness") then
    return
  end
end
DefineClass.LightsSetState = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "MarkerId",
      help = "Marker description: can specify an id.",
      editor = "text",
      default = false
    },
    {
      id = "MarkerGroup",
      help = "Marker description: marker group.",
      editor = "combo",
      default = "",
      items = function(self)
        return LightsMarkerGroups
      end
    },
    {
      id = "MarkerType",
      help = "Marker description: markers type.",
      editor = "combo",
      default = "Position",
      items = function(self)
        return GetGridMarkerTypesCombo
      end
    },
    {
      id = "TurnOn",
      editor = "bool",
      default = true
    },
    {
      id = "EssentialLights",
      editor = "bool",
      default = true
    },
    {
      id = "OptionalLights",
      editor = "bool",
      default = true
    },
    {
      id = "AttachedLights",
      editor = "bool",
      default = true
    }
  },
  Documentation = "Turns ON/OFF Lights inside marker's area",
  EditorNestedObjCategory = "Interactions"
}
function LightsSetState:GetEditorView()
  return string.format("Turns Lights %s in %s marker(s) area(s)", self.TurnOn and "ON" or "OFF", self.MarkerGroup)
end
function LightsSetState:__exec(obj, context)
  local markers = MapGetLightsMarkers(self.MarkerType, self.MarkerGroup, function(o)
    return o:IsMarkerEnabled() and (self.MarkerId or "" == "" or o.ID == self.MarkerID)
  end)
  if #(markers or empty_table) == 0 then
    printf("%s didn't find any markers (type %s, group %s, id %s)", self.class, tostring(self.MarkerType), tostring(self.MarkerGroup), tostring(self.MarkerId))
    return
  end
  local lights = GetLights(function(light)
    local detail = light:GetDetailClass()
    if not self.EssentialLights and detail == "Essential" then
      return false
    end
    if not self.OptionalLights and detail == "Optional" then
      return false
    end
    if not self.AttachedLights and light:GetParent() then
      return false
    end
    return true
  end)
  for _, marker in ipairs(markers) do
    marker.lights_off = not self.TurnOn
    for _, light in ipairs(lights) do
      if marker:IsInsideArea2D(light:GetPos()) then
        if marker.lights_off then
          marker:TurnLightOff(light)
        else
          marker:TurnLightOn(light)
        end
      end
    end
  end
  Msg("LightsStateUpdated")
end
DefineClass.LockpickableSetState = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Group",
      name = "Group",
      help = "The group in which the lockpick resides.",
      editor = "combo",
      default = false,
      items = function(self)
        return GridMarkerGroupsCombo()
      end
    },
    {
      id = "State",
      help = "The state to set the locking in.",
      editor = "choice",
      default = false,
      items = function(self)
        return {
          "unlocked",
          "locked",
          "change-difficulty"
        }
      end
    },
    {
      id = "NewDifficulty",
      name = "New Difficulty",
      help = "The difficulty to change to if the state is \"change-difficulty\".",
      editor = "choice",
      default = "None",
      items = function(self)
        return const.DifficultyPresetsNew
      end
    }
  },
  EditorView = Untranslated("Change the state of lockpickables in <u(Group)> to <u(State)>"),
  Documentation = "Change lockpickable (containers, doors) state."
}
function LockpickableSetState:__exec(obj, context)
  for _, o in ipairs(Groups[self.Group]) do
    if o:IsKindOf("Lockpickable") then
      if self.State == "change-difficulty" then
        o.lockpickDifficulty = self.NewDifficulty
      else
        o:SetLockpickState(self.State == "unlocked" and "closed" or self.State)
      end
    end
  end
end
function LockpickableSetState:GetError()
  if not self.State then
    return "Set the new state!"
  end
  if not self.Group then
    return "Set the group"
  end
end
DefineClass.LogMessageAdd = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "message",
      name = "Message",
      help = "The message to display.",
      editor = "text",
      default = false,
      translate = true
    }
  },
  EditorView = Untranslated("Log:<message>"),
  Documentation = "Add a short message in game log",
  EditorNestedObjCategory = "UI & Log"
}
function LogMessageAdd:__exec(obj, context)
  CombatLog("important", self.message)
end
function LogMessageAdd:GetError()
  if not self.message or self.message == "" then
    return "Add a message"
  end
end
DefineClass.ModifySatelliteAggro = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Halt",
      help = "Stop passive aggro increase",
      editor = "bool",
      default = false
    },
    {
      id = "AggroAmount",
      editor = "number",
      default = 0
    },
    {
      id = "HaltDays",
      editor = "number",
      default = false
    },
    {
      id = "AmountIsPercent",
      editor = "bool",
      default = true
    }
  },
  Documentation = "Modify Satellite aggro"
}
function ModifySatelliteAggro:GetEditorView()
  if self.Halt then
    if self.HaltDays then
      return Untranslated("Halt satellite aggro for " .. self.HaltDays .. " days.")
    end
    return Untranslated("Halt satellite aggro")
  elseif self.AggroAmount == 0 and not self.Halt then
    return Untranslated("Unhalt satellite aggro")
  elseif self.AmountIsPercent then
    return Untranslated("Add " .. self.AggroAmount / 100 .. "% satellite aggro")
  else
    return Untranslated("Add " .. self.AggroAmount .. " satellite aggro")
  end
end
function ModifySatelliteAggro:__exec(obj, context)
  gv_SatelliteAttacksHalted = self.Halt
  if gv_SatelliteAttacksHalted then
    gv_SatelliteAggro = 0
    gv_SatelliteAttacksHaltedFor = self.HaltDays
    return
  end
  ModifySatelliteAggression(self.AggroAmount, self.AmountIsPercent)
end
function ModifySatelliteAggro:GetError()
  if not self.AggroAmount then
    return "No amount specified"
  end
end
DefineClass.ModifyTrapSpawnersEffect = {
  __parents = {
    "Effect",
    "TrapSpawnProperties"
  },
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Group",
      name = "Spawner Group",
      help = "The spawner group to affect.",
      editor = "combo",
      default = "",
      items = function(self)
        return GridMarkerGroupsCombo()
      end
    },
    {
      category = "Spawner",
      id = "SpawnActive",
      name = "Override Spawner Status",
      help = "Override whether the spawner is active. If disabled any spawned traps will be despawned.",
      editor = "combo",
      default = "don't change",
      items = function(self)
        return {
          "don't change",
          "enable",
          "disable"
        }
      end
    }
  },
  EditorView = Untranslated("Change trap spawners of group <u(Group)>"),
  Documentation = "Change the properties of trap spawners in a specific group.",
  EditorNestedObjCategory = "Traps"
}
function ModifyTrapSpawnersEffect:__exec(obj, context)
  local props = self:GetPropertyList()
  for i, s in ipairs(Groups[self.Group]) do
    if s:IsKindOf("TrapSpawnMarker") then
      s:ApplyPropertyList(props)
    end
  end
  if self.SpawnActive ~= "dont change" then
    for i, s in ipairs(Groups[self.Group]) do
      if s:IsKindOf("TrapSpawnMarker") then
        s:SetActive(self.SpawnActive == "enable")
      end
    end
  end
end
DefineClass.MusicSetPlaylist = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Playlist",
      name = "Playlist",
      editor = "combo",
      default = false,
      items = function(self)
        return PresetsCombo("RadioStationPreset", "Default")
      end
    }
  },
  EditorView = Untranslated("Changes the current playlist"),
  Documentation = "Changes the current playlist"
}
function MusicSetPlaylist:__exec(obj, context)
  StartRadioStation(self.Playlist)
end
DefineClass.MusicSetSectorPlaylist = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "SectorID",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "MusicExploration",
      name = "Exploration Music",
      editor = "combo",
      default = false,
      items = function(self)
        return PresetsCombo("RadioStationPreset", "Default")
      end
    },
    {
      id = "MusicConflict",
      name = "Conflict Music",
      editor = "combo",
      default = false,
      items = function(self)
        return PresetsCombo("RadioStationPreset", "Default")
      end
    },
    {
      id = "MusicCombat",
      name = "Combat Music",
      editor = "combo",
      default = false,
      items = function(self)
        return PresetsCombo("RadioStationPreset", "Default")
      end
    }
  },
  EditorView = Untranslated("Changes the playlists of a sector"),
  Documentation = "Changes the playlists of a sector"
}
function MusicSetSectorPlaylist:__exec(obj, context)
  if GetSectorMusicOverride("MusicExploration") ~= self.MusicExploration then
    SetSectorMusicOverride(self.SectorID, "MusicExploration", self.MusicExploration)
  end
  if GetSectorMusicOverride("MusicConflict") ~= self.MusicConflict then
    SetSectorMusicOverride(self.SectorID, "MusicConflict", self.MusicConflict)
  end
  if GetSectorMusicOverride("MusicCombat") ~= self.MusicCombat then
    SetSectorMusicOverride(self.SectorID, "MusicCombat", self.MusicCombat)
  end
  ResetSectorStation()
end
DefineClass.MusicSetTrack = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Playlist",
      name = "Playlist",
      editor = "combo",
      default = false,
      items = function(self)
        return PresetsCombo("RadioStationPreset", "Default")
      end
    },
    {
      id = "Track",
      name = "Track",
      editor = "combo",
      default = false,
      items = function(self)
        return RadioPlaylistCombo(self.Playlist)
      end
    }
  },
  EditorView = Untranslated("Plays a track and then continues with the current playlist(radio station)"),
  Documentation = "Plays a track and then continues with the current playlist(radio station)"
}
function MusicSetTrack:__exec(obj, context)
  local _, playlist = RadioPlaylistCombo(self.Playlist)
  local track = table.find_value(playlist, "path", self.Track)
  MusicPlayTrack(track)
end
DefineClass.NeutralNPCDontMove = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "TargetUnit",
      name = "NPC Name",
      help = "The name of the NPC to associate.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetUnitGroups()
      end
    }
  },
  EditorView = Untranslated("Prevent neutral unit from moving in combat."),
  Documentation = "Prevents neutral unit from moving in combat.",
  EditorNestedObjCategory = "",
  EditorNestedObjCategory = "Units"
}
function NeutralNPCDontMove:__exec(obj, context)
  local units = Groups[self.TargetUnit] or empty_table
  for _, unit in ipairs(units) do
    unit.neutral_ai_dont_move = true
  end
end
function NeutralNPCDontMove:GetError()
  if not self.TargetUnit then
    return "Specify Target Unit"
  end
end
DefineClass.NpcUnitGiveItem = {
  __parents = {
    "Effect",
    "LootTableFunctionObjectBase"
  },
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "ItemId",
      name = "Item",
      editor = "preset_id",
      default = false,
      preset_class = "InventoryItemCompositeDef"
    },
    {
      id = "LootTableId",
      name = "LootTable",
      editor = "preset_id",
      default = false,
      preset_class = "LootDef"
    },
    {
      id = "DontDrop",
      editor = "bool",
      default = false
    },
    {
      id = "TargetUnit",
      name = "NPC Name",
      help = "The name of the NPC to associate.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetUnitGroups()
      end
    }
  },
  EditorView = Untranslated("Give <u(ItemId)>/<u(LootTableId)> to <u(TargetUnit)>"),
  Documentation = "Give an item to an npc, and have them equip items",
  EditorNestedObjCategory = "Units"
}
function NpcUnitGiveItem:__exec(obj, context)
  local units = empty_table
  local group = Groups[self.TargetUnit]
  if group then
    local unitClass = {}
    for i, obj in ipairs(group) do
      if IsKindOf(obj, "Unit") then
        unitClass[#unitClass + 1] = obj
      end
    end
    units = unitClass
  else
    units = context.target_units or units
  end
  if not units or not units[1] then
    return
  end
  local items = {}
  if self.ItemId and self.ItemId ~= "" then
    table.insert(items, PlaceInventoryItem(self.ItemId))
  end
  if self.LootTableId then
    local loot_tbl = LootDefs[self.LootTableId]
    if loot_tbl then
      loot_tbl:GenerateLoot(self, {}, InteractionRand(nil, "NpcGive"), items)
    end
  end
  local unit = units[1]
  for i, item in ipairs(items) do
    item.drop_chance = self.DontDrop and 0 or 100
    if unit:CanAddItem("Handheld A", item) then
      unit:AddItem("Handheld A", item)
    elseif unit:CanAddItem("Head", item) then
      unit:AddItem("Head", item)
    elseif unit:CanAddItem("Torso", item) then
      unit:AddItem("Torso", item)
    elseif unit:CanAddItem("Legs", item) then
      unit:AddItem("Legs", item)
    else
      unit:AddItem("Inventory", item)
    end
  end
  unit:UpdateOutfit()
end
function NpcUnitGiveItem:GetError()
  if not self.ItemId and not self.LootTableId then
    return "No items set"
  end
  if not self.TargetUnit then
    return "No target unit"
  end
end
DefineClass.NpcUnitTakeItem = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "ItemId",
      name = "Item",
      editor = "preset_id",
      default = false,
      preset_class = "InventoryItemCompositeDef"
    },
    {
      id = "TargetUnit",
      name = "NPC Name",
      help = "The name of the NPC to associate.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetUnitGroups()
      end
    }
  },
  EditorView = Untranslated("Take <u(ItemId)> from <u(TargetUnit)>"),
  Documentation = "Take an item from an NPC",
  EditorNestedObjCategory = "Units"
}
function NpcUnitTakeItem:__exec(obj, context)
  local units = empty_table
  local group = Groups[self.TargetUnit]
  if group then
    local unitClass = {}
    for i, obj in ipairs(group) do
      if IsKindOf(obj, "Unit") then
        unitClass[#unitClass + 1] = obj
      end
    end
    units = unitClass
  else
    units = context.target_units or units
  end
  if not units or not units[1] then
    return
  end
  local unit = units[1]
  local itemsToRemove = {}
  local itemsToRemoveSlots = {}
  unit:ForEachItem(false, function(item, slot)
    if item.class == self.ItemId then
      itemsToRemove[#itemsToRemove + 1] = item
      itemsToRemoveSlots[#itemsToRemoveSlots + 1] = slot
    end
  end)
  for i, item in ipairs(itemsToRemove) do
    unit:RemoveItem(itemsToRemoveSlots[i], item)
  end
  unit:UpdateOutfit()
end
function NpcUnitTakeItem:GetError()
  if not self.ItemId then
    return "No items set"
  end
  if not self.TargetUnit then
    return "No target unit"
  end
end
DefineClass.PhraseSetEnabled = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Conversation",
      help = "The conversation the phrase is in.",
      editor = "preset_id",
      default = false,
      preset_class = "Conversation"
    },
    {
      id = "PhraseId",
      help = "The Id of the phrase to enable/disable.",
      editor = "choice",
      default = false,
      items = function(self)
        return GetPhraseIdsCombo(self.Conversation)
      end
    },
    {
      id = "Enabled",
      help = "Enable or disable the phrase.",
      editor = "bool",
      default = true
    }
  },
  Documentation = "Enables or disables a particular conversation phrase.",
  EditorNestedObjCategory = "Interactions"
}
function PhraseSetEnabled:GetEditorView()
  local enable = self.Enabled and Untranslated("Enable phrase ") or Untranslated("Disable phrase ")
  return Untranslated("<u(Conversation)>: ") .. enable .. Untranslated("<u(PhraseId)>")
end
function PhraseSetEnabled:__exec(obj, context)
  SetPhraseEnabledState(self.Conversation .. "." .. self.PhraseId, self.Enabled)
end
function PhraseSetEnabled:OnAfterEditorNew(parent, ged, is_paste)
  local preset = ged:ResolveObj("SelectedPreset")
  if preset:IsKindOf("Conversation") then
    self.Conversation = preset.id
  end
end
DefineClass.PhraseSetSeen = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Conversation",
      help = "The conversation the phrase is in.",
      editor = "preset_id",
      default = false,
      preset_class = "Conversation"
    },
    {
      id = "PhraseId",
      help = "The Id of the phrase to enable/disable.",
      editor = "choice",
      default = false,
      items = function(self)
        return GetPhraseIdsCombo(self.Conversation)
      end
    },
    {
      id = "Seen",
      help = "Sets the phrase as not seen (highlighted) by default; check the box to set the phrase as seen (dimmed) instead.",
      editor = "bool",
      default = false
    }
  },
  Documentation = "Changes a conversation's phrase \"seen\" (dimmed) status.",
  EditorNestedObjCategory = "Interactions"
}
function PhraseSetSeen:GetEditorView()
  local seen = self.Seen and Untranslated("seen") or Untranslated("not seen")
  return Untranslated("<u(Conversation)>: Set phrase<u(PhraseId)> as ") .. seen
end
function PhraseSetSeen:__exec(obj, context)
  SetPhraseSeen(self.Conversation .. "." .. self.PhraseId, self.Seen)
end
function PhraseSetSeen:OnAfterEditorNew(parent, ged, is_paste)
  local preset = ged:ResolveObj("SelectedPreset")
  if preset:IsKindOf("Conversation") then
    self.Conversation = preset.id
  end
end
DefineClass.PlayBanterEffect = {
  __parents = {
    "Effect",
    "BanterFunctionObjectBase"
  },
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Banters",
      name = "Banters",
      help = "List of banters to play.",
      editor = "preset_id_list",
      default = {},
      preset_class = "BanterDef",
      item_default = ""
    },
    {
      id = "searchInMarker",
      name = "Include Marker Units",
      help = "The only valid actors for a banter are the units passed by the previous conditions. By setting this on units inside a GridMarker will also be included as valid actors.",
      editor = "bool",
      default = true
    },
    {
      id = "banterSequentialWaitFor",
      name = "Wait For",
      help = "The banter event to wait for (if executing sequentially).",
      editor = "choice",
      default = "BanterDone",
      items = function(self)
        return {
          "",
          "BanterStart",
          "BanterDone",
          "BanterLineStart",
          "BanterLineDone"
        }
      end
    },
    {
      id = "searchInMap",
      name = "Include Whole Map",
      help = "The only valid actors for a banter are the units passed by the previous conditions. By setting this on units from the whole map will be considered. Your banter might spawn on a unit off screen.",
      editor = "bool",
      default = false
    },
    {
      id = "FallbackToMerc",
      name = "Radio",
      help = "If enabled the banter will appear over the first merc on map if the banter actor is not present on the map.",
      editor = "bool",
      default = false
    },
    {
      id = "WaitSetpieceEnd",
      help = "if enabled the banter will wait for the setpiece to end",
      editor = "bool",
      default = false
    },
    {
      id = "anyFallback",
      name = "Use any unit as fallback for Radio.",
      help = "Use this if the Radio banter is not played.",
      editor = "bool",
      default = false
    },
    {
      id = "AnyActorOverrideGroup",
      name = "Any Actor Override Group",
      help = "Banter lines with actor \"any\" will be played by the first /object/ from the group.",
      editor = "text",
      default = false
    }
  },
  Documentation = "An effect to play a banter.",
  EditorNestedObjCategory = "Interactions"
}
function PlayBanterEffect:GetError()
  if not self.Banters then
    return "No banters"
  end
  for i, banter_id in ipairs(self.Banters) do
    if not Banters[banter_id] then
      return "Invalid banter ID " .. banter_id
    end
  end
end
function PlayBanterEffect:GetEditorView()
  return Untranslated("Play banter(s): ") .. Untranslated(table.concat(self.Banters, ", "))
end
function PlayBanterEffect:__exec(obj, context)
  local is_marker = IsKindOf(obj, "GridMarker")
  local context_is_table = context and type(context) == "table"
  local targetUnitsTable = context_is_table and rawget(context, "target_units")
  targetUnitsTable = targetUnitsTable and table.icopy(targetUnitsTable)
  local units = targetUnitsTable or is_marker and {obj} or {}
  if self.searchInMarker and is_marker then
    MapForEach("map", "Unit", function(u)
      if obj:IsInsideArea(u:GetPos()) then
        units[#units + 1] = u
      end
    end)
  elseif self.searchInMap then
    MapForEach("map", "Unit", function(u)
      units[#units + 1] = u
    end)
    MapForEach("map", "CheeringDummy", function(u)
      units[#units + 1] = u
    end)
  end
  if context_is_table and rawget(context, "interactable") then
    units = table.copy(units)
    table.insert(units, 1, context.interactable)
  end
  local fallback = false
  if self.FallbackToMerc then
    for _, unit in ipairs(g_Units) do
      if unit:IsPlayerAlly() and not unit:IsDead() then
        fallback = unit
        break
      end
    end
    if not fallback and self.anyFallback then
      for _, unit in ipairs(g_Units) do
        if not unit:IsDead() then
          fallback = unit
          break
        end
      end
    end
  end
  local banters, banterActors = FilterAvailableBanters(self.Banters, context, units, fallback)
  if not banters then
    CombatLog("debug", "No banters can be played with the selected actors")
    return
  end
  local idx = InteractionRand(#banters, "PlayBanterEffect") + 1
  local banterToPlay = banters[idx]
  local actorsToPlayWith = banterActors[idx]
  local anyActorOverride = self.AnyActorOverrideGroup
  if context_is_table and context and context.found_merc then
    anyActorOverride = context.found_merc
  end
  local banterObj = PlayBanter(banterToPlay, actorsToPlayWith, fallback, anyActorOverride, self.WaitSetpieceEnd)
  if banterObj then
    local playerPos = IsValid(obj) and obj:GetPos()
    if playerPos then
      banterObj:SetPos(playerPos)
    end
    local resumeData = {}
    resumeData.preset = banterObj.preset.id
    local banterUnits = {}
    for i, u in ipairs(banterObj.associated_units) do
      banterUnits[#banterUnits + 1] = u.handle
    end
    resumeData.units = banterUnits
    resumeData.fallbackUnit = banterObj.fallback_actor and banterObj.fallback_actor.handle
    resumeData.any_actor_override = banterObj.any_actor_override and banterObj.any_actor_override.handle
    resumeData.playerHandle = banterObj.handle
    if playerPos then
      resumeData.player_pos = playerPos
    end
    g_PlayingBanterEffects[self] = resumeData
  end
  return banterObj
end
function PlayBanterEffect:__skip(obj, context)
  for i, banterId in ipairs(self.Banters) do
    SkipBanterFromUI(banterId)
  end
end
function PlayBanterEffect:__waitexec(obj, context)
  local banterObj = self:__exec(obj, context)
  local event = self.banterSequentialWaitFor
  if banterObj and event ~= "" then
    local notTimedOut, preset_id
    while preset_id ~= banterObj.preset.id do
      notTimedOut, preset_id = WaitMsg(event)
    end
  end
end
function PlayBanterEffect:GetError()
  if #self.Banters == 0 then
    return "Add at least one banter"
  end
  if self.searchInMarker and self.searchInMap then
    return "Don't select both search in marker and search in map."
  end
end
function PlayBanterEffect:GetResumeData()
  local resumeData = g_PlayingBanterEffects[self]
  if resumeData and resumeData.playerHandle then
    local player = HandleToObject[resumeData.playerHandle]
    if IsValid(player) then
      resumeData.current_line = player.current_line and player.current_line + 1 or 1
      return "PlayBanterEffect", resumeData
    end
  end
end
DefineClass.PlayNotNowVR = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  EditorView = Untranslated("Unit plays \"NotNow\" VR"),
  Documentation = "Unit plays \"NotNow\" VR.",
  EditorNestedObjCategory = "Units"
}
function PlayNotNowVR:__exec(obj, context)
  PlayVoiceResponse(obj, "NotNow")
end
DefineClass.PlaySetpiece = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "setpiece",
      name = "Setpiece",
      help = "The id of the set piece preset to play.",
      editor = "preset_id",
      default = false,
      preset_class = "SetpiecePrg"
    }
  },
  EditorView = Untranslated("Play <setpiece> setpiece"),
  Documentation = "Play a Set-piece.",
  EditorNestedObjCategory = "",
  EditorNestedObjCategory = "Interactions"
}
function PlaySetpiece:__exec(obj, context)
  local triggerUnits = false
  if type(context) == "table" and rawget(context, "target_units") then
    triggerUnits = rawget(context, "target_units")
  elseif Groups[obj] then
    triggerUnits = Groups[obj]
  elseif gv_CurrentSectorId then
    triggerUnits = table.map(GetPlayerMercsInSector(gv_CurrentSectorId), function(o)
      return g_Units[o]
    end)
  end
  local foundMerc = false
  if type(context) == "table" and rawget(context, "found_merc") then
    foundMerc = rawget(context, "found_merc")
    foundMerc = g_Units[foundMerc]
  end
  local setpiece = Setpieces[self.setpiece]
  if setpiece.TakePlayerControl then
    local dlg = OpenDialog("XSetpieceDlg", false, {
      setpiece = self.setpiece,
      setpiece_seed = InteractionRand(nil, "Setpiece"),
      triggerUnits = triggerUnits,
      extra_params = foundMerc and {
        {foundMerc}
      }
    })
    if GameState.entering_sector then
      dlg:FadeOut(0)
    end
  else
    CreateGameTimeThread(function()
      StartSetpiece(self.setpiece, false, InteractionRand(nil, "Setpiece"), triggerUnits, foundMerc)
    end)
  end
end
function PlaySetpiece:__waitexec(obj, context)
  self:__exec(obj, context)
  local setpiece = Setpieces[self.setpiece]
  if setpiece.TakePlayerControl then
    WaitMsg("SetpieceEnded")
  else
    WaitMsg("SetpieceEndExecution")
  end
end
function PlaySetpiece:GetError()
  if not self.setpiece then
    return "No setpiece set."
  end
end
DefineClass.PlayUnitVoiceResponse = {
  __parents = {"UnitTarget", "Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "VoiceResponse",
      name = "Voice Response",
      help = "Voice response type to choose a phrase from; the phrases of the current unit will be used.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetVoiceResponseCombo(self, self.TargetUnit)
      end
    }
  },
  EditorView = Untranslated("<u(TargetUnit)> plays '<u(VoiceResponse)>'"),
  Documentation = "Target unit plays voice response",
  EditorNestedObjCategory = "Units"
}
function PlayUnitVoiceResponse:__exec(obj, context)
  if not self.VoiceResponse then
    return
  end
  context = context or {}
  local units = self:MatchMapUnits(obj, context)
  if units and context.target_units then
    local unit = context.target_units[AsyncRand(#context.target_units) + 1]
    if not unit or not self.VoiceResponse then
      return
    end
    PlayVoiceResponse(unit, self.VoiceResponse, true)
  end
end
function PlayUnitVoiceResponse:GetError()
  if not self.TargetUnit then
    return "Choose target unit"
  end
  if not self.VoiceResponse then
    return "Choose voice response id"
  end
end
function PlayUnitVoiceResponse:UnitCheck(unit, obj, context)
  return true
end
DefineClass.PlayerGrantMoney = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Amount",
      name = "Amount",
      help = "Amount of money to grant.",
      editor = "number",
      default = 0,
      min = 0
    }
  },
  EditorView = Untranslated("Grant <money(Amount)>"),
  Documentation = "Give money to player."
}
function PlayerGrantMoney:__exec(obj, context)
  AddMoney(self.Amount, "deposit")
end
function PlayerGrantMoney:GetPhraseTopRolloverText(negative, template, game)
  local amount = self.Amount
  if 0 < amount then
    return T({
      666348317447,
      "<money(Amount)> acquired",
      Amount = amount
    })
  elseif amount < 0 then
    return T({
      194741866993,
      "Paid <money(Amount)>",
      Amount = amount
    })
  end
end
function PlayerGrantMoney:GetPhraseFX()
  return "ConversationMoneyGained"
end
DefineClass.PlayerPayMoney = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Amount",
      name = "Amount",
      help = "Amount of money to pay.",
      editor = "number",
      default = 0,
      min = 0
    }
  },
  EditorView = Untranslated("Pay <money(Amount)>"),
  Documentation = "Take money from player."
}
function PlayerPayMoney:__exec(obj, context)
  AddMoney(-self.Amount, "expense")
end
function PlayerPayMoney:GetPhraseTopRolloverText(negative, template, game)
  local amount = self.Amount
  return T({
    194741866993,
    "Paid <money(Amount)>",
    Amount = amount
  })
end
function PlayerPayMoney:GetUIText(context)
  return T({
    982094780061,
    "Give <money(Amount)>",
    Amount = self.Amount
  })
end
DefineClass.QuestEffectBase = {
  __parents = {
    "Effect",
    "QuestFunctionObjectBase"
  },
  __generated_by_class = "ClassDef",
  EditorNestedObjCategory = "Quests"
}
function QuestEffectBase:OnAfterEditorNew(obj, socket, paste, old_id)
  if not paste then
    local quest_def = GetParentTableOfKindNoCheck(obj, "QuestsDef")
    if quest_def then
      self.QuestId = quest_def.id
    end
  end
end
DefineClass.QuestKillTCE = {
  __parents = {
    "QuestEffectBase"
  },
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "QuestId",
      name = "Quest id",
      help = "Quest to change.",
      editor = "preset_id",
      default = false,
      preset_class = "QuestsDef"
    },
    {
      id = "TCE",
      name = "TCE",
      help = "Quest TCE to kill",
      editor = "choice",
      default = false,
      items = function(self)
        return GetQuestsVarsCombo(self.QuestId, "TCEState")
      end
    }
  },
  EditorView = Untranslated("Kills '<u(TCE)>' TCE from '<u(QuestId)>' quest"),
  Documentation = "Kills specific TCE from a given quest"
}
function QuestKillTCE:__exec(obj, context)
  if not RunningSequentialEffects then
    return false
  end
  if not (self.QuestId and self.QuestId ~= "" and self.TCE) or self.TCE == "" then
    return false
  end
  for i = #RunningSequentialEffects, 1, -1 do
    local run_state = RunningSequentialEffects[i]
    if run_state[5] == self.QuestId and run_state[6] == self.TCE then
      DeleteThread(run_state[1])
      table.remove(RunningSequentialEffects, i)
      return
    end
  end
end
function QuestKillTCE:GetError()
  if not self.QuestId or self.QuestId == "" then
    return "Specify the quest!"
  end
end
DefineClass.QuestSetVariableBool = {
  __parents = {
    "QuestEffectBase"
  },
  __generated_by_class = "EffectDef",
  properties = {
    {
      category = "General",
      id = "QuestId",
      name = "Quest id",
      help = "Quest to change.",
      editor = "preset_id",
      default = false,
      preset_class = "QuestsDef",
      preset_filter = function(preset, obj)
        return QuestHasVariable(preset, "QuestVarBool")
      end
    },
    {
      category = "General",
      id = "Prop",
      name = "Quest Variable",
      help = "Quest variable to change.",
      editor = "choice",
      default = false,
      items = function(self)
        return GetQuestsVarsCombo(self.QuestId, "Bool")
      end
    },
    {
      category = "General",
      id = "Toggle",
      name = "Toggle Current Value",
      help = "Toggles the current flag value (changes it from 'true' to 'false' and vice versa).",
      editor = "bool",
      default = false
    },
    {
      category = "General",
      id = "Set",
      name = "Change to",
      help = "Value to set.",
      editor = "bool",
      default = true,
      no_edit = function(self)
        return self.Toggle
      end
    }
  },
  Documentation = "A way to change the quest's flag. If not 'Toggle'  then changes the flag to 'Set' value, else toggle the flag's value."
}
function QuestSetVariableBool:__exec(obj, context)
  local quest = QuestGetState(self.QuestId or "")
  if not quest then
    return
  end
  if self.Toggle then
    SetQuestVar(quest, self.Prop, not rawget(quest, self.Prop))
  else
    SetQuestVar(quest, self.Prop, self.Set)
  end
end
function QuestSetVariableBool:GetError()
  if not self.QuestId or self.QuestId == "" then
    return "Specify the quest!"
  end
  if not self.Prop then
    return "Specify the param to change!"
  end
end
function QuestSetVariableBool:GetEditorView()
  if self.Toggle then
    return Untranslated("Quest <u(QuestId)>: toggle <u(Prop)>")
  else
    return Untranslated("Quest <u(QuestId)>: <u(Prop)> = " .. tostring(self.Set))
  end
end
DefineClass.QuestSetVariableNum = {
  __parents = {
    "QuestEffectBase"
  },
  __generated_by_class = "EffectDef",
  properties = {
    {
      category = "General",
      id = "QuestId",
      name = "Quest id",
      help = "Quest to change.",
      editor = "preset_id",
      default = false,
      preset_class = "QuestsDef",
      preset_filter = function(preset, obj)
        return QuestHasVariable(preset, "QuestVarNum")
      end
    },
    {
      category = "General",
      id = "Prop",
      name = "Quest Variable",
      help = "Quest variable to change.",
      editor = "choice",
      default = false,
      items = function(self)
        return GetQuestsVarsCombo(self.QuestId, "Num")
      end
    },
    {
      category = "General",
      id = "Amount",
      name = "Amount",
      help = "Value to set.",
      editor = "number",
      default = 0
    },
    {
      category = "General",
      id = "RandomRangeMax",
      name = "Random Amount Max",
      help = "If set, the amount will be a random number between \"Amount\" and this number. Both values are inclusive.",
      editor = "number",
      default = false
    },
    {
      category = "General",
      id = "Percent",
      name = "Percent",
      help = "Percent change to current value, if operation is modify.",
      editor = "number",
      default = 100
    },
    {
      category = "General",
      id = "Operation",
      name = "Operation",
      help = "Modify the current value with amount/percent or set a new one.",
      editor = "combo",
      default = "modify",
      items = function(self)
        return {"set", "modify"}
      end
    }
  },
  Documentation = "Change a quest variable's value. Modifies the current value wiyh amount/percent or sets a new amount."
}
function QuestSetVariableNum:__exec(obj, context)
  local quest = QuestGetState(self.QuestId or "")
  if not quest then
    return
  end
  local prev_val = rawget(quest, self.Prop)
  local new_val
  local mod_amount = self.Amount
  if self.RandomRangeMax then
    mod_amount = mod_amount + InteractionRand(self.RandomRangeMax - mod_amount + 1, "QuestVariableNum")
  end
  if self.Operation == "set" then
    new_val = mod_amount
  elseif self.Operation == "modify" then
    new_val = (prev_val or 0) + mod_amount
    if self.Percent ~= 0 then
      new_val = MulDivRound(new_val, self.Percent, 100)
    end
  end
  SetQuestVar(quest, self.Prop, new_val)
end
function QuestSetVariableNum:GetError()
  if not self.QuestId or self.QuestId == "" then
    return "Specify the quest!"
  end
  if not self.Prop then
    return "Specify the param to change!"
  end
  if self.RandomRangeMax and self.RandomRangeMax < self.Amount then
    return "Max cannot be smaller than min (Amount)."
  end
  if self.Operation ~= "set" then
    local quest = QuestGetState(self.QuestId or "")
    local prev_val = rawget(quest, self.Prop)
    if not prev_val then
      return "This prop has not set any value and can not be changed"
    end
  end
end
function QuestSetVariableNum:GetEditorView()
  local printValue = "<Amount>"
  if self.RandomRangeMax then
    printValue = printValue .. "-<RandomRangeMax>"
  end
  if self.Operation == "set" then
    return Untranslated("Quest <u(QuestId)>:<u(Prop)> = " .. printValue)
  elseif self.Operation == "modify" then
    return Untranslated("Quest <u(QuestId)>:<u(Prop)> =  <Percent>% from (<u(Prop)> + " .. printValue .. ")")
  end
end
DefineClass.QuestSetVariableSpecialValue = {
  __parents = {
    "QuestEffectBase"
  },
  __generated_by_class = "EffectDef",
  properties = {
    {
      category = "General",
      id = "QuestId",
      name = "Quest id",
      help = "Quest to change.",
      editor = "preset_id",
      default = false,
      preset_class = "QuestsDef",
      preset_filter = function(preset, obj)
        return QuestHasVariable(preset, "QuestVarNum")
      end
    },
    {
      category = "General",
      id = "Prop",
      name = "Quest Variable",
      help = "Quest variable to change.",
      editor = "choice",
      default = false,
      no_validate = true,
      items = function(self)
        return GetQuestsVarsCombo(self.QuestId, "Num")
      end
    },
    {
      category = "General",
      id = "Special",
      name = "Special value type",
      help = "Value to set.",
      editor = "combo",
      default = "current campaign time",
      items = function(self)
        return {
          "current campaign time"
        }
      end
    }
  },
  Documentation = "Set a quest number variable to a special value, chosen from the Special property."
}
function QuestSetVariableSpecialValue:__exec(obj, context)
  local quest = QuestGetState(self.QuestId or "")
  if not quest then
    return
  end
  local new_val
  if self.Special == "current campaign time" then
    new_val = Game.CampaignTime
  end
  SetQuestVar(quest, self.Prop, new_val)
end
function QuestSetVariableSpecialValue:GetError()
  if not self.QuestId or self.QuestId == "" then
    return "Specify the quest!"
  end
end
function QuestSetVariableSpecialValue:GetEditorView()
  if self.Special == "current campaign time" then
    return Untranslated("Quest <u(QuestId)>:<u(Prop)> = current campaign time")
  end
end
DefineClass.QuestSetVariableText = {
  __parents = {
    "QuestEffectBase"
  },
  __generated_by_class = "EffectDef",
  properties = {
    {
      category = "General",
      id = "QuestId",
      name = "Quest id",
      help = "Quest to change.",
      editor = "preset_id",
      default = false,
      preset_class = "QuestsDef",
      preset_filter = function(preset, obj)
        return QuestHasVariable(preset, "QuestVarText")
      end
    },
    {
      category = "General",
      id = "Prop",
      name = "Quest Variable",
      help = "Quest variable to change",
      editor = "choice",
      default = false,
      items = function(self)
        return GetQuestsVarsCombo(self.QuestId, "Text")
      end
    },
    {
      category = "General",
      id = "Text",
      name = "Text",
      help = "Value to set.",
      editor = "text",
      default = "\"\""
    }
  },
  EditorView = Untranslated("Quest <u(QuestId)>:<u(Prop)> = '<u(Text)>'"),
  Documentation = "Change a quest's text variable."
}
function QuestSetVariableText:__exec(obj, context)
  local quest = QuestGetState(self.QuestId or "")
  if not quest then
    return
  end
  SetQuestVar(quest, self.Prop, self.Text)
end
function QuestSetVariableText:GetError()
  if not self.QuestId or self.QuestId == "" then
    return "Specify the quest!"
  end
  if not self.Prop then
    return "Specify the param to change!"
  end
end
DefineClass.QuestSetVariableTimer = {
  __parents = {
    "QuestEffectBase"
  },
  __generated_by_class = "EffectDef",
  properties = {
    {
      category = "General",
      id = "QuestId",
      name = "Quest id",
      help = "Quest to change.",
      editor = "preset_id",
      default = false,
      preset_class = "QuestsDef",
      preset_filter = function(preset, obj)
        return QuestHasVariable(preset, "QuestVarNum")
      end
    },
    {
      category = "General",
      id = "Prop",
      name = "Quest Variable",
      help = "Quest variable to change.",
      editor = "choice",
      default = false,
      items = function(self)
        return GetQuestsVarsCombo(self.QuestId, "Num")
      end
    },
    {
      category = "General",
      id = "TimeAmount",
      editor = "number",
      default = 0
    },
    {
      category = "General",
      id = "TimeAmountRangeMax",
      help = "If set the time amount will be randomed between TimeAmount and this value.",
      editor = "number",
      default = 0
    },
    {
      category = "General",
      id = "Timescale",
      editor = "choice",
      default = "h",
      items = function(self)
        return GetTimeScalesCombo()
      end
    }
  },
  Documentation = "Set a timer to a quest variable."
}
function QuestSetVariableTimer:__exec(obj, context)
  local quest = QuestGetState(self.QuestId or "")
  if not quest then
    return
  end
  local prev_val = rawget(quest, self.Prop)
  local timeAmount = self.TimeAmount
  if self.TimeAmountRangeMax ~= 0 then
    timeAmount = timeAmount + InteractionRand(self.TimeAmountRangeMax - timeAmount + 1, "QuestVariableTimer")
  end
  timeAmount = timeAmount * (const.Scale[self.Timescale] or const.Scale.h)
  local triggerTime = Game.CampaignTime + timeAmount
  SetQuestVar(quest, self.Prop, triggerTime)
end
function QuestSetVariableTimer:GetError()
  if not self.QuestId or self.QuestId == "" then
    return "Specify the quest!"
  end
  if not self.Prop then
    return "Specify the param to change!"
  end
  if (self.TimeAmountRangeMax or 0) ~= 0 and self.TimeAmountRangeMax < self.TimeAmount then
    return "Max cannot be smaller than min (TimeAmount)."
  end
end
function QuestSetVariableTimer:GetEditorView()
  local printValue = "<TimeAmount>"
  if (self.TimeAmountRangeMax or 0) ~= 0 then
    printValue = printValue .. "-<TimeAmountRangeMax>"
  end
  return Untranslated("Set quest timer in <u(QuestId)>:<u(Prop)> for after " .. printValue .. " " .. self.Timescale)
end
DefineClass.RadioStartConversation = {
  __parents = {
    "Effect",
    "ConversationFunctionObjectBase"
  },
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Conversation",
      name = "Conversation",
      help = "Conversation to start.",
      editor = "preset_id",
      default = false,
      preset_class = "Conversation"
    }
  },
  EditorView = Untranslated("Start radio conversation <u(Conversation)>."),
  Documentation = "Starts a specific radio conversation - no groups or conditions are checked.",
  EditorNestedObjCategory = "Interactions"
}
function RadioStartConversation:__exec(obj, context)
  StartConversationEffect(self.Conversation, "radio_conversation")
end
function RadioStartConversation:__waitexec(obj, context)
  StartConversationEffect(self.Conversation, "radio_conversation", "wait")
end
function RadioStartConversation:GetError()
  if not self.Conversation then
    return "Please specify conversation"
  end
end
function RadioStartConversation:GetResumeData(thread, stack, stack_index)
  return "RadioStartConversation", self.Conversation
end
DefineClass.RandomEffect = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Effects",
      name = "Effects",
      editor = "nested_list",
      default = false,
      base_class = "Effect"
    }
  },
  ReturnClass = "",
  EditorView = Untranslated("Play a random effect from a list."),
  Documentation = "Play a random effect from a list.",
  EditorNestedObjCategory = ""
}
function RandomEffect:__exec(obj, context)
  local num = #self.Effects
  local roll = InteractionRand(num, "RandomEffect") + 1
  local effect = self.Effects[roll]
  ExecuteEffectList({effect})
end
function RandomEffect:GetError()
  if not self.Effects or #self.Effects < 1 then
    return "Please specify some effects"
  end
end
DefineClass.RechargeCDs = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  RequiredObjClasses = {"Unit", "UnitData"},
  EditorView = Untranslated("Recharge a unit's CDs"),
  Documentation = "Recharge a unit's CDs",
  EditorNestedObjCategory = "Units"
}
function RechargeCDs:__exec(obj, context)
  if IsKindOfClasses(obj, "Unit", "UnitData") and not obj:IsDead() then
    obj:RechargeSignatures()
  end
end
DefineClass.RegenerateGuardpostObjective = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "GuardpostObjective",
      name = "GuardpostObjective",
      editor = "preset_id",
      default = false,
      preset_class = "GuardpostObjective"
    }
  },
  EditorView = Untranslated("Regenerate guardpost objective <u(GuardpostObjective)>"),
  Documentation = "Regenerate a completed guardpost objective.",
  EditorNestedObjCategory = "Sectors"
}
function RegenerateGuardpostObjective:__exec(obj, context)
  SetGuardpostObjectiveRegenerated(self.GuardpostObjective)
end
DefineClass.ReplaceMercEffect = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "ExistingMerc",
      name = "Existing Merc",
      help = "Existing merc to replace.",
      editor = "combo",
      default = false,
      items = function(self)
        return MercPresetCombo()
      end
    },
    {
      id = "NewMercDef",
      name = "New Merc Definition",
      help = "New merc definition to use for replacement.",
      editor = "combo",
      default = false,
      items = function(self)
        return MercPresetCombo()
      end
    }
  },
  EditorView = Untranslated("Replace <u(ExistingMerc)> with <u(NewMercDef)> keeping his progress."),
  Documentation = "Replace a merc with another definition while keeping his progress. Example use: switch Larry to Larry_Clean.",
  EditorNestedObjCategory = "Units"
}
function ReplaceMercEffect:__exec(obj, context)
  ReplaceMerc(self.ExistingMerc, self.NewMercDef, "keepInventory")
end
function ReplaceMercEffect:GetError()
  if not self.ExistingMerc then
    return "Choose an existing merc to replace"
  end
  if not self.NewMercDef then
    return "Choose a new merc definition to replace the existing one with"
  end
end
function ReplaceMercEffect:GetUIText(context, template, game)
  local merc = gv_UnitData and gv_UnitData[self.Merc]
  local name
  if not merc then
    name = game and "" or Untranslated("[MercName]")
  else
    name = merc.Nick or merc.Name
  end
  return T({
    246469241790,
    "Recruit merc (<em><name></em>)",
    name = name
  })
end
DefineClass.ResetAmbientLife = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Ephemeral",
      name = "Ephemeral Only",
      help = "All ambient life units or just ephemeral ones.",
      editor = "bool",
      default = true
    },
    {
      id = "KickPerpetualUnits",
      name = "Kick Perpetual Units",
      help = "If checked perpetual units will be reset too, otherwise they will stay in their markers.",
      editor = "bool",
      default = false
    },
    {
      id = "ForceImmediateKick",
      name = "Force Immediate Kick",
      help = "Forces immedite kick so the marker and the unit can be used right away - usually clearing the marker happens after playing exit animation. Anyway if UnitsStealForPerpetualMarkers effect is scheduled right after this one it can not work as expected since it will be called before the destructors and the units/marker will be still busy",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("Reset Ambient Life Behavior"),
  Documentation = "Forces all units in ambient life behavior to check the condition of the spot they are using and makes them leave if that condition is not met"
}
function ResetAmbientLife:__exec(obj, context)
  for _, unit in ipairs(g_Units) do
    if (not self.Ephemeral or unit.ephemeral) and unit:IsVisiting() then
      unit:ResetAmbientLife(self.KickPerpetualUnits, self.ForceImmediateKick)
    end
  end
end
DefineClass.RestoreHealth = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "amount",
      name = "Amount",
      editor = "number",
      default = 9999
    }
  },
  RequiredObjClasses = {"Unit", "UnitData"},
  EditorView = Untranslated("Restore unit's health"),
  Documentation = "Restores unit's health",
  EditorNestedObjCategory = "Units"
}
function RestoreHealth:__exec(obj, context)
  if IsKindOfClasses(obj, "Unit", "UnitData") and not obj:IsDead() then
    obj.HitPoints = Min(obj.MaxHitPoints, obj.HitPoints + self.amount)
  end
end
DefineClass.ScatterAmbientLife = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  EditorView = Untranslated("Scatter Ambient Life"),
  Documentation = "orders all of the ambient life units on the map (ones spawned from AmbientZones) to stop what they are doing on the spot and trigger the conflict logic."
}
function ScatterAmbientLife:__exec(obj, context)
  ChangeGameState({ConflictScripted = true})
end
DefineClass.SectorAddOperationProgress = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "sector_id",
      name = "Sector Id",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "operation",
      name = "Operation",
      help = "Operation to add progress to.",
      editor = "combo",
      default = false,
      items = function(self)
        return table.keys(SectorOperations)
      end
    },
    {
      id = "perc",
      name = "Add Perc",
      help = "Percent of the target progress that will be added.",
      editor = "number",
      default = 0,
      min = 0,
      max = 100
    }
  },
  Documentation = "Adds progress to a given operation in a given sector",
  EditorView = Untranslated("Adds <percent(perc)> progress to <u(operation)> in sector <u(sector_id)>"),
  EditorNestedObjCategory = "Sector effects"
}
function SectorAddOperationProgress:__exec(obj, context)
  SectorOperations[self.operation]:BoostProgress(self.perc, gv_Sectors[self.sector_id])
end
function SectorAddOperationProgress:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
end
DefineClass.SectorDisableAutoResolve = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "value",
      editor = "bool",
      default = true
    },
    {
      id = "sector_id",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    }
  },
  Documentation = "Enable/Disable auto-resolve on the sector"
}
function SectorDisableAutoResolve:__exec(obj, context)
  local sector = gv_Sectors[self.sector_id]
  if sector then
    sector.autoresolve_disabled = not self.value
  end
end
function SectorDisableAutoResolve:GetEditorView()
  if self.value then
    return Untranslated("Enable auto-resolve for sector <u(sector_id)>")
  else
    return Untranslated("Disable auto-resolve for sector <u(sector_id)>")
  end
end
function SectorDisableAutoResolve:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
end
DefineClass.SectorEnableAutoDeploy = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "deploy",
      help = "Enable/disable auto-deploy on enter.",
      editor = "bool",
      default = true
    },
    {
      id = "sector_id",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    }
  },
  Documentation = "Enable/Disable auto-deploy mode on sector enter"
}
function SectorEnableAutoDeploy:__exec(obj, context)
  local sector = gv_Sectors[self.sector_id]
  if sector then
    sector.enabled_auto_deploy = self.deploy
  end
end
function SectorEnableAutoDeploy:GetEditorView()
  if self.deploy then
    return Untranslated("Enable auto-deploy for sector <u(sector_id)>")
  else
    return Untranslated("Disable auto-deploy for sector <u(sector_id)>")
  end
end
function SectorEnableAutoDeploy:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
end
DefineClass.SectorEnableCustomOperation = {
  __parents = {
    "Effect",
    "LootTableFunctionObjectBase"
  },
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "sector_id",
      name = "Sector",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "operation",
      name = "Operation",
      help = "Custom operation.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCustomOperations()
      end
    },
    {
      category = "Execution",
      id = "EffectsOnSuccess",
      name = "On Success",
      help = "Effects that are executed after the operation is completed.",
      editor = "nested_list",
      default = false,
      base_class = "Effect"
    },
    {
      category = "Execution",
      id = "LootTableId",
      name = "Loot Table Id",
      help = "Loot table to generate items that will be granted after the operation is completed.",
      editor = "preset_id",
      default = false,
      preset_class = "LootDef"
    },
    {
      category = "Execution",
      id = "GrantItemApply",
      name = "GrantItemApply",
      help = "Loot table roll -  \"first\"(merc) - only once, \"all\"(mercs) for each merc",
      editor = "combo",
      default = "first",
      items = function(self)
        return {"first", "all"}
      end
    }
  },
  Documentation = "Enables custom operation in the sector",
  EditorView = Untranslated("Enables custom Operation <u(operation)> in sector <u(sector_id)>"),
  EditorNestedObjCategory = "Sector effects"
}
function SectorEnableCustomOperation:__exec(obj, context)
  local sector = gv_Sectors[self.sector_id]
  if not sector then
    return
  end
  sector.custom_operations = sector.custom_operations or {}
  sector.custom_operations[self.operation] = {
    status = "enabled",
    progress = 0,
    EffectsOnSuccess = self.EffectsOnSuccess,
    LootTableId = self.LootTableId
  }
  ObjModified(sector)
  ObjModified(gv_Squads)
end
function SectorEnableCustomOperation:GetError()
  if not self.sector_id then
    return "Specify sector!"
  elseif not self.operation then
    return "Specify custom operation!"
  end
end
function SectorEnableCustomOperation:GetPhraseTopRolloverText(negative, template, game)
  return T({
    588881082990,
    "Operation is available: <em><ActivityName></em>",
    ActivityName = SectorOperations[self.operation] and SectorOperations[self.operation].display_name or ""
  })
end
DefineClass.SectorEnableWarningState = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Enable",
      name = "Enable",
      help = "Enable",
      editor = "bool",
      default = true
    },
    {
      id = "sector_id",
      name = "Sector Id",
      help = "Sector id.",
      editor = "combo",
      default = "current",
      items = function(self)
        return table.iappend({
          {text = "current", value = "current"}
        }, GetCampaignSectorsCombo())
      end
    }
  },
  Documentation = "Enable/Disable the Warning State mechanic for sector. (does NOT trigger it)",
  EditorView = Untranslated("Change <u(sector_id)> sector's WarningStateEnabled to <Bool(Enable)>. (does NOT trigger it)"),
  EditorNestedObjCategory = "Sector effects"
}
function SectorEnableWarningState:__exec(obj, context)
  local sector_id = self.sector_id == "current" and gv_CurrentSectorId or self.sector_id
  local sector = gv_Sectors[sector_id]
  sector.warningStateEnabled = self.Enable
end
DefineClass.SectorEnterConflict = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "conflict_mode",
      help = "Force or resolve conflict in that sector.",
      editor = "bool",
      default = true
    },
    {
      id = "sector_id",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return table.iappend({
          {text = "current", value = "current"}
        }, GetCampaignSectorsCombo())
      end
    },
    {
      id = "disable_travel",
      help = "Disables all travel zones on the map.",
      editor = "bool",
      default = false
    },
    {
      id = "lock_conflict",
      help = "Killing all enemies on the map cannot resolve a locked conflict, only scripts can.",
      editor = "bool",
      default = false
    },
    {
      id = "descr_id",
      help = "This text is displayed when the \"Conflict\" text is rolled over and in the description of the conflict window. Define texts in the conflict descriptions editor.",
      editor = "combo",
      default = false,
      items = function(self)
        return PresetGroupCombo("ConflictDescription", "Default")
      end
    },
    {
      id = "spawn_mode",
      editor = "combo",
      default = false,
      items = function(self)
        return {
          "attack",
          "defend",
          "explore"
        }
      end
    }
  },
  Documentation = "Forces/Resolve conflict mode for the speciafied sector",
  EditorNestedObjCategory = "Sector effects"
}
function SectorEnterConflict:__exec(obj, context)
  local sector = self.sector_id == "current" and gv_Sectors[gv_CurrentSectorId] or gv_Sectors[self.sector_id]
  if self.conflict_mode then
    EnterConflict(sector, nil, self.spawn_mode, self.disable_travel, self.lock_conflict, self.descr_id, "force")
  else
    sector.ForceConflict = false
    ResolveConflict(sector, "no voice")
  end
end
function SectorEnterConflict:GetEditorView()
  if self.conflict_mode then
    return Untranslated("Force conflict mode for sector <u(sector_id)>")
  else
    return Untranslated("Remove forced conflict mode for sector <u(sector_id)>")
  end
end
function SectorEnterConflict:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
end
DefineClass.SectorGrantIntel = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "sector_id",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    }
  },
  Documentation = "Grants intel for the sector",
  EditorView = Untranslated("Grant intel for sector <u(sector_id)>"),
  EditorNestedObjCategory = "Sector effects"
}
function SectorGrantIntel:__exec(obj, context)
  DiscoverIntelForSector(self.sector_id)
end
function SectorGrantIntel:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
end
function SectorGrantIntel:GetPhraseTopRolloverText(negative, template, game)
  local campaign = CampaignPresets[Game and Game.Campaign or DefaultCampaign]
  local sector = gv_Sectors and gv_Sectors[self.sector_id] or table.find_value(campaign.Sectors, "Id", self.sector_id)
  if sector and sector.intel_discovered then
    return T({
      903574434021,
      "<em>Intel</em> is already available for <em><SectorName(sector)></em>",
      sector = sector
    })
  end
  return T({
    223883822777,
    "Gained <em>Intel</em> for <em><SectorName(sector)></em>",
    sector = sector
  })
end
DefineClass.SectorModifyEnemySquads = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "sector_id",
      name = "Sector",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "percent",
      name = "Percent",
      help = "Percent for enemy count modification.",
      editor = "number",
      default = 0
    },
    {
      id = "count",
      name = "Count",
      help = "Specific count for enemy count modification.",
      editor = "number",
      default = 0
    },
    {
      id = "UnitTemplate",
      name = "UnitTemplate",
      help = "Unit template that will be affected or all if false.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetEnemySquadsUnitTemplates("all")
      end
    }
  },
  Documentation = "The spawned enemy squads in that sector get their units or specified type of units decreased or increased by that specified percent. To remove all units from unittype, set pecent to -100",
  EditorNestedObjCategory = "Sector effects"
}
function SectorModifyEnemySquads:__exec(obj, context)
  local value, valueType = self.percent, "percent"
  local count = self.count
  if count and count ~= 0 then
    value = count
    valueType = "count"
  end
  ModifySectorEnemySquads(self.sector_id, value, valueType, self.UnitTemplate)
end
function SectorModifyEnemySquads:GetEditorView()
  local value, valueType = self.percent, "percent"
  local count = self.count
  if count and count ~= 0 then
    value = count
    valueType = "count"
  end
  local valString = valueType == "percent" and tostring(value) .. "%" or tostring(value)
  if 0 < value then
    if self.UnitTemplate then
      return Untranslated("Increases <u(UnitTemplate)> units in enemy squads force in <u(sector_id)> by " .. valString)
    else
      return Untranslated("Increases all enemies in <u(sector_id)> by " .. valString)
    end
  elseif self.UnitTemplate then
    return Untranslated("Decreases <u(UnitTemplate)> units in enemy squads force in <u(sector_id)> by " .. valString)
  else
    return Untranslated("Decreases all enemies in <u(sector_id)> by " .. valString)
  end
end
function SectorModifyEnemySquads:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
end
DefineClass.SectorModifyMineProperties = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "DepletionTime",
      name = "Depletion Income Modifier Percent",
      help = "% modifier for depletion time",
      editor = "number",
      default = false,
      min = 1,
      max = 500
    },
    {
      id = "DailyIncome",
      name = "Daily Income Modifier Percent",
      help = "% modifier for profit per day at 100% loyalty. For instance 200 would double, and 50 would halve",
      editor = "number",
      default = false,
      min = 0,
      max = 1000
    },
    {
      id = "sector_id",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    }
  },
  Documentation = "Modify diamond mine properties for a given sector",
  EditorNestedObjCategory = "Sector effects"
}
function SectorModifyMineProperties:__exec(obj, context)
  local sector = gv_Sectors[self.sector_id]
  if self.DepletionTime then
    if not sector.depletion_mods then
      sector.depletion_mods = {}
    end
    sector.depletion_mods[#sector.depletion_mods + 1] = self.DepletionTime
  end
  if self.DailyIncome then
    if not sector.income_mods then
      sector.income_mods = {}
    end
    sector.income_mods[#sector.income_mods + 1] = self.DailyIncome
  end
end
function SectorModifyMineProperties:GetEditorView()
  return Untranslated("Modify diamond mine related properties on <sector_id>")
end
function SectorModifyMineProperties:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
end
function SectorModifyMineProperties:GetPhraseTopRolloverText(negative, template, game)
  if self.DailyIncome and next(gv_Sectors) then
    local name = gv_Sectors[self.sector_id].display_name
    if self.DailyIncome > 100 then
      return T({
        830978589245,
        "<Name> diamond production increased by <(value -100)>%",
        value = self.DailyIncome,
        Name = name
      })
    end
    if self.DailyIncome < 100 then
      return T({
        340934605682,
        "<Name> diamond production decreased by <(100-value)>%",
        value = self.DailyIncome,
        Name = name
      })
    end
  end
end
DefineClass.SectorRemoveCustomOperation = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "sector_id",
      name = "Sector",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "operation",
      name = "Operation",
      help = "Remove custom operation.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCustomOperations()
      end
    }
  },
  Documentation = "Removes custom operation in the sector, sets operation mercs to Idle",
  EditorView = Untranslated("Removes custom Operation <u(operation)> in sector <u(sector_id)>"),
  EditorNestedObjCategory = "Sector effects"
}
function SectorRemoveCustomOperation:__exec(obj, context)
  local sector = gv_Sectors[self.sector_id]
  if not sector then
    return
  end
  local operation = self.operation
  if sector.custom_operations and sector.custom_operations[operation] then
    sector.custom_operations[operation] = nil
  end
  local mercs = GetPlayerSectorUnits(self.sector_id)
  SectorOperation_CancelByGame(mercs, operation, true)
  ObjModified(sector)
  ObjModified(gv_Squads)
end
function SectorRemoveCustomOperation:GetError()
  if not self.sector_id then
    return "Specify sector!"
  elseif not self.operation then
    return "Specify custom operation!"
  end
end
function SectorRemoveCustomOperation:GetPhraseTopRolloverText(negative, template, game)
  return T({
    565334741205,
    "<ActivityName> Operation is unavailable",
    ActivityName = SectorOperations[self.operation] and SectorOperations[self.operation].display_name or ""
  })
end
DefineClass.SectorReplaceEnemySquadList = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "sector_id",
      name = "Sector Id",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "EnemySquadsList",
      name = "Enemy Squads List",
      help = "A random squad from the list will be chosen on guardpost spawn time.",
      editor = "preset_id_list",
      default = {},
      preset_class = "EnemySquads",
      preset_filter = function(preset, obj)
        if preset.group ~= "Test Encounters" then
          return obj
        end
      end,
      item_default = ""
    },
    {
      id = "StrongEnemySquadsList",
      name = "Strong Enemy Squads List",
      editor = "preset_id_list",
      default = {},
      preset_class = "EnemySquads",
      preset_filter = function(preset, obj)
        if preset.group ~= "Test Encounters" then
          return obj
        end
      end,
      item_default = ""
    },
    {
      id = "ExtraDefenderSquads",
      name = "Extra Defender Squads",
      editor = "preset_id_list",
      default = {},
      preset_class = "EnemySquads",
      preset_filter = function(preset, obj)
        if preset.group ~= "Test Encounters" then
          return obj
        end
      end,
      item_default = ""
    }
  },
  EditorView = Untranslated("Overrides EnemySquadList in sector <u(sector_id)>"),
  Documentation = "Overrides EnemySquadList in a given sector",
  EditorNestedObjCategory = "Sector effects"
}
function SectorReplaceEnemySquadList:__exec(obj, context)
  local sector = gv_Sectors[self.sector_id]
  if not sector then
    return
  end
  if sector.EnemySquadsList and #sector.EnemySquadsList > 0 then
    sector.EnemySquadsList = table.copy(self.EnemySquadsList)
  end
  if sector.StrongEnemySquadsList and 0 < #sector.StrongEnemySquadsList then
    sector.StrongEnemySquadsList = table.copy(self.StrongEnemySquadsList)
  end
  if sector.ExtraDefenderSquads and 0 < #sector.ExtraDefenderSquads then
    sector.ExtraDefenderSquads = table.copy(self.ExtraDefenderSquads)
  end
end
function SectorReplaceEnemySquadList:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
end
DefineClass.SectorReplaceTargetSectors = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "sector_id",
      name = "Sector Id",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "TargetSectors",
      name = "Target Sectors",
      help = "Target sectors for spawned enemy squads.",
      editor = "string_list",
      default = {},
      item_default = "",
      items = function(self)
        return GetCampaignSectorsCombo("")
      end
    }
  },
  EditorView = Untranslated("Overrides TargetSectors in a given sector"),
  Documentation = "Overrides TargetSectors in a given sector",
  EditorNestedObjCategory = "Sector effects"
}
function SectorReplaceTargetSectors:__exec(obj, context)
  local sector = gv_Sectors[self.sector_id]
  if sector then
    sector.TargetSectors = table.copy(self.TargetSectors, "deep")
  end
end
function SectorReplaceTargetSectors:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
end
DefineClass.SectorSetAwarenessSequence = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "sector_id",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "awareness_sequence",
      name = "Awareness Sequence",
      editor = "choice",
      default = "Standard",
      items = function(self)
        return {
          "Standard",
          "Skip Setpiece",
          "Skip All"
        }
      end
    }
  },
  Documentation = "Enable/Disable auto-deploy mode on sector enter"
}
function SectorSetAwarenessSequence:__exec(obj, context)
  local sector = gv_Sectors[self.sector_id]
  if sector then
    sector.awareness_sequence = self.awareness_sequence
  end
end
function SectorSetAwarenessSequence:GetEditorView()
  return Untranslated(string.format("Set Awareness Sequence for for sector <u(sector_id)> to %s", self.awareness_sequence))
end
function SectorSetAwarenessSequence:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
end
DefineClass.SectorSetCustomConflictDesc = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "sector_id",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "descr_id",
      help = "This text is displayed when the \"Conflict\" text is rolled over and in the description of the conflict window. Define texts in the conflict descriptions editor.",
      editor = "combo",
      default = false,
      items = function(self)
        return PresetGroupCombo("ConflictDescription", "Default")
      end
    }
  },
  Documentation = "Set a custom conflict description for the given sector. Cleared when the conflict is resolved.",
  EditorNestedObjCategory = "Sector effects"
}
function SectorSetCustomConflictDesc:__exec(obj, context)
  local sector = gv_Sectors[self.sector_id]
  sector.CustomConflictDescr = self.descr_id
  if sector.conflict and not sector.conflict.descr_id then
    sector.conflict.descr_id = self.descr_id
  end
end
function SectorSetCustomConflictDesc:GetEditorView()
  return Untranslated("Set conflict description <u(descr_id)> for <u(sector_id)>")
end
function SectorSetCustomConflictDesc:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
  if not self.descr_id then
    return "Specify description preset!"
  end
end
DefineClass.SectorSetExplorePopup = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "sector_id",
      name = "Sector Id",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "explore_popup",
      name = "Explore Popup",
      help = "Choose explore Popup.",
      editor = "combo",
      default = "",
      items = function(self)
        return PresetGroupCombo("PopupNotification", "Sectors")
      end
    }
  },
  Documentation = "Change or remove (set to empty) explore pop-up for sector",
  EditorNestedObjCategory = "Sector effects"
}
function SectorSetExplorePopup:__exec(obj, context)
  gv_Sectors[self.sector_id].ExplorePopup = self.explore_popup
end
function SectorSetExplorePopup:GetEditorView()
  if self.explore_popup == "" then
    return Untranslated("Remove explore pop-up for sector <u(sector_id)>")
  else
    return Untranslated("Change explore pop-up for sector <u(sector_id)> to <u(explore_popup)>")
  end
end
function SectorSetExplorePopup:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
end
DefineClass.SectorSetForceConflict = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "sector_id",
      name = "Sector Id",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "force",
      name = "Force Conflict",
      help = "Force conflict value.",
      editor = "bool",
      default = false
    }
  },
  Documentation = "Enable/Disable 'force conflict' for the sector - entering sectors with force conflict set to true results in conflict mode with or without enemy presence in the sector",
  EditorNestedObjCategory = "Sector effects"
}
function SectorSetForceConflict:__exec(obj, context)
  gv_Sectors[self.sector_id].ForceConflict = self.force
end
function SectorSetForceConflict:GetEditorView()
  if self.force then
    return Untranslated("Enable sector <u(sector_id)> force conflict")
  else
    return Untranslated("Disable sector <u(sector_id)> force conflict")
  end
end
function SectorSetForceConflict:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
end
DefineClass.SectorSetHospital = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "enable",
      help = "Add/remove hospital in sector.",
      editor = "bool",
      default = true
    },
    {
      id = "sector_id",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    }
  },
  Documentation = "Enable/disable hospital in specified sector",
  EditorNestedObjCategory = "Sector effects"
}
function SectorSetHospital:__exec(obj, context)
  local sector = gv_Sectors[self.sector_id]
  sector.HospitalLocked = not self.enable
  sector.Hospital = true
  Msg("BuildingLockChanged", self.sector_id)
end
function SectorSetHospital:GetPhraseTopRolloverText(negative, template, game)
  return T({
    588881082990,
    "Operation is available: <em><ActivityName></em>",
    ActivityName = SectorOperations.HospitalTreatment and SectorOperations.HospitalTreatment.display_name or ""
  })
end
function SectorSetHospital:GetEditorView()
  if self.enable then
    return Untranslated("Enable hospital in sector <u(sector_id)>")
  else
    return Untranslated("Disable hospital in sector <u(sector_id)>")
  end
end
function SectorSetHospital:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
end
DefineClass.SectorSetMilitia = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "enable",
      help = "Set militia in sector.",
      editor = "bool",
      default = true
    },
    {
      id = "sector_id",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    }
  },
  Documentation = "Enable/disable militia in specified sector",
  EditorNestedObjCategory = "Sector effects"
}
function SectorSetMilitia:__exec(obj, context)
  gv_Sectors[self.sector_id].Militia = self.enable
end
function SectorSetMilitia:GetEditorView()
  if self.enable then
    return Untranslated("Enable militia in sector <u(sector_id)>")
  else
    return Untranslated("Disable militia in sector <u(sector_id)>")
  end
end
function SectorSetMilitia:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
end
DefineClass.SectorSetMineProperties = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Depletion",
      editor = "combo",
      default = "no-change",
      items = function(self)
        return {
          "no-change",
          "enabled",
          "disabled"
        }
      end
    },
    {
      id = "HasMine",
      editor = "combo",
      default = "no-change",
      items = function(self)
        return {
          "no-change",
          "enabled",
          "disabled"
        }
      end
    },
    {
      id = "DepletionTime",
      help = "In how many days the mine will deplete",
      editor = "number",
      default = false,
      min = 1,
      max = 500
    },
    {
      id = "DailyIncome",
      help = "Profit per day at 100% loyalty",
      editor = "number",
      default = false,
      min = 0
    },
    {
      id = "sector_id",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    }
  },
  Documentation = "Set diamond mine properties for a given sector.",
  EditorNestedObjCategory = "Sector effects"
}
function SectorSetMineProperties:__exec(obj, context)
  local sector = gv_Sectors[self.sector_id]
  if self.Depletion ~= "no-change" then
    sector.Depletion = self.Depletion == "enabled"
  end
  if self.HasMine ~= "no-change" then
    sector.Mine = self.HasMine == "enabled"
  end
  if self.DepletionTime then
    sector.DepletionTime = self.DepletionTime
  end
  if self.DailyIncome then
    sector.DailyIncome = self.DailyIncome
  end
end
function SectorSetMineProperties:GetEditorView()
  return Untranslated("Set diamond mine related properties on <sector_id>")
end
function SectorSetMineProperties:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
end
DefineClass.SectorSetPort = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "enable",
      help = "Add/remove port in sector.",
      editor = "bool",
      default = true
    },
    {
      id = "sector_id",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    }
  },
  Documentation = "Enable/disable port in specified sector",
  EditorNestedObjCategory = "Sector effects"
}
function SectorSetPort:__exec(obj, context)
  local sector = gv_Sectors[self.sector_id]
  sector.PortLocked = not self.enable
  sector.Port = true
  if sector.Side == "player1" or sector.Side == "player2" then
    gv_PlayerSectorCounts.Port = gv_PlayerSectorCounts.Port + 1
  end
  Msg("BuildingLockChanged", self.sector_id)
end
function SectorSetPort:GetEditorView()
  if self.enable then
    return Untranslated("Enable port in sector <u(sector_id)>")
  else
    return Untranslated("Disable port in sector <u(sector_id)>")
  end
end
function SectorSetPort:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
end
DefineClass.SectorSetRAndROperation = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "enable",
      help = "Set RAndR operation in sector.",
      editor = "bool",
      default = true
    },
    {
      id = "sector_id",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    }
  },
  Documentation = "Enable/disable RAndR operation in specified sector",
  EditorNestedObjCategory = "Sector effects"
}
function SectorSetRAndROperation:__exec(obj, context)
  gv_Sectors[self.sector_id].RAndRAllowed = self.enable
end
function SectorSetRAndROperation:GetEditorView()
  if self.enable then
    return Untranslated("Enable RAndR  in sector <u(sector_id)>")
  else
    return Untranslated("Disable RAndR in sector <u(sector_id)>")
  end
end
function SectorSetRAndROperation:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
end
DefineClass.SectorSetRepairShopOperation = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "enable",
      editor = "bool",
      default = true
    },
    {
      id = "sector_id",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    }
  },
  Documentation = "Enable/Disable Repair Shop operations in the specified sector.",
  EditorNestedObjCategory = "Sector effects"
}
function SectorSetRepairShopOperation:__exec(obj, context)
  gv_Sectors[self.sector_id].RepairShop = self.enable
end
function SectorSetRepairShopOperation:GetEditorView()
  if self.enable then
    return Untranslated("Enable Repair Shop operations in sector <u(sector_id)>")
  else
    return Untranslated("Disable Repair Shop operations in sector <u(sector_id)>")
  end
end
function SectorSetRepairShopOperation:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
end
DefineClass.SectorSetSide = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "sector_id",
      name = "Sector Id",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "side",
      name = "Side",
      help = "Choose side for sector.",
      editor = "combo",
      default = "player1",
      items = function(self)
        return table.map(GetCurrentCampaignPreset().Sides, "Id")
      end
    },
    {
      id = "enable_sticky",
      name = "Enable Sticky Side",
      help = "This will forcefully set sticky side to true.",
      editor = "bool",
      default = false
    },
    {
      id = "disable_sticky",
      name = "Disable Sticky Side",
      help = "This will forcefully set sticky side to false.",
      editor = "bool",
      default = false
    }
  },
  Documentation = "Change sector side and sticky side option (optional)",
  EditorNestedObjCategory = "Sector effects"
}
function SectorSetSide:__exec(obj, context)
  if self.enable_sticky then
    gv_Sectors[self.sector_id].StickySide = true
  elseif self.disable_sticky then
    gv_Sectors[self.sector_id].StickySide = false
  end
  SatelliteSectorSetSide(self.sector_id, self.side, "force")
end
function SectorSetSide:GetEditorView()
  if self.enable_sticky then
    return Untranslated("Set side <u(side)> and enable sticky side in sector <u(sector_id)>")
  elseif self.disable_sticky then
    return Untranslated("Set side <u(side)> and disable sticky side in sector <u(sector_id)>")
  else
    return Untranslated("Set side <u(side)> in sector <u(sector_id)>")
  end
end
function SectorSetSide:GetError()
  if not self.sector_id then
    return "Specify sector!"
  elseif self.enable_sticky and self.disable_sticky then
    return "You cannot both enable and disable sticky side, choose one"
  end
end
DefineClass.SectorSpawnSquad = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "sector_id",
      name = "Sector",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "squad_def_id",
      name = "Squad",
      help = "Pre-defined enemy squad.",
      editor = "combo",
      default = false,
      items = function(self)
        return EnemySquadsComboItems("exclude test squads")
      end
    },
    {
      id = "side",
      name = "Side",
      editor = "combo",
      default = "enemy1",
      items = function(self)
        return {
          "enemy1",
          "enemy2",
          "ally"
        }
      end
    }
  },
  Documentation = "Spawns a predefined squad on the sector",
  EditorView = Untranslated("Spawn a <u(squad_def_id)> squad in sector <u(sector_id)>"),
  EditorNestedObjCategory = "Sector effects"
}
function SectorSpawnSquad:__exec(obj, context)
  GenerateEnemySquad(self.squad_def_id, self.sector_id, "Effect", nil, self.side)
end
function SectorSpawnSquad:GetError()
  if not self.sector_id then
    return "Specify sector!"
  elseif not self.squad_def_id then
    return "Specify squad!"
  end
end
DefineClass.SectorSquadDespawn = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "sector_id",
      name = "Sector",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "Militia",
      name = "Remove militia",
      editor = "bool",
      default = true
    },
    {
      id = "Enemies",
      name = "Remove enemies",
      editor = "bool",
      default = true
    }
  },
  Documentation = "Removes all enemy and militia squads in that sector.",
  EditorView = Untranslated("Removes enemy squads and militia in <u(sector_id)>"),
  EditorNestedObjCategory = "Sector effects"
}
function SectorSquadDespawn:__exec(obj, context)
  local squads = GetSectorSquads(self.sector_id)
  for i = #squads, 1, -1 do
    local squad = squads[i]
    if self.Enemies and IsEnemySquad(squad.UniqueId) or self.Militia and squad.militia then
      RemoveSquad(squad)
    end
  end
  if not gv_SatelliteView and self.sector_id == gv_CurrentSectorId then
    LocalCheckUnitsMapPresence()
  end
end
function SectorSquadDespawn:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
end
DefineClass.SectorTrainMilitia = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "sector_id",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "Amount",
      editor = "number",
      default = false,
      default = const.Satellite.MilitiaUnitsPerTraining,
      min = 1,
      max = 8
    }
  },
  Documentation = "Grants intel for the sector",
  EditorView = Untranslated("Train <u(Amount)> militia on <u(sector_id)>"),
  EditorNestedObjCategory = "Sector effects"
}
function SectorTrainMilitia:__exec(obj, context)
  local sector = gv_Sectors[self.sector_id]
  local _, trained = SpawnMilitia(self.Amount, sector)
  if trained == 0 then
    return
  end
  local logText = T({
    769055535456,
    "<amount> militia dispatched to <SectorName(sector)>",
    amount = trained,
    sector = sector
  })
  CombatLog("important", logText)
end
function SectorTrainMilitia:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
end
function SectorTrainMilitia:GetPhraseTopRolloverText(negative, template, game)
  local campaign = CampaignPresets[Game and Game.Campaign or DefaultCampaign]
  local sector = gv_Sectors and gv_Sectors[self.sector_id] or table.find_value(campaign.Sectors, "Id", self.sector_id)
  return T({
    445122419956,
    "Sent <em>Militia</em> to <em><SectorName(sector)></em>",
    sector = sector
  })
end
DefineClass.SectorsGrantIntel = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "sector_id",
      help = "Sector id.",
      editor = "string_list",
      default = {},
      item_default = "",
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    }
  },
  Documentation = "Grants intel for an array of sectors",
  EditorView = Untranslated("Grant intel for sectors <list(sector_id, ', ')>"),
  EditorNestedObjCategory = "Sector effects"
}
function SectorsGrantIntel:__exec(obj, context)
  DiscoverIntelForSectors(self.sector_id)
end
function SectorsGrantIntel:GetError()
  if not self.sector_id then
    return "Specify sector!"
  end
end
function SectorsGrantIntel:GetPhraseTopRolloverText(negative, template, game)
  local campaign = CampaignPresets[Game and Game.Campaign or DefaultCampaign]
  local knew = {}
  local new = {}
  for i, s in ipairs(self.sector_id) do
    local sector = gv_Sectors and gv_Sectors[s] or table.find_value(campaign.Sectors, "Id", s)
    if sector then
      if sector.intel_discovered then
        knew[#knew + 1] = T({
          427357563595,
          "<em><SectorName></em>",
          SectorName = sector and sector.display_name or ""
        })
      else
        new[#new + 1] = T({
          165345603261,
          "<em><SectorName></em> (sector <SectorId(sId)>)",
          SectorName = sector and sector.display_name or "",
          sId = s
        })
      end
    end
  end
  local textCombined = false
  if 0 < #new then
    textCombined = T({
      309239191160,
      "Gained <em>Intel</em> for <sectors>.",
      sectors = table.concat(new, ", ")
    })
  end
  if 0 < #knew then
    local knewText = T({
      124400089767,
      "Intel for <sectors> is already available.",
      sectors = table.concat(knew, ", ")
    })
    if textCombined then
      textCombined = textCombined .. T(226690869750, "<newline>") .. knewText
    else
      textCombined = knewText
    end
  end
  return textCombined
end
DefineClass.SetBadgeEffect = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Remove",
      help = "Remove the badge instead.",
      editor = "bool",
      default = false
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
      help = "The badge preset to spawn.",
      editor = "preset_id",
      default = false,
      preset_class = "BadgePresetDef"
    },
    {
      id = "Quest",
      name = "Quest",
      help = "Which quest to associate this badge with. If the effect is placed on a quest it will attempt to find it itself.",
      editor = "preset_id",
      default = false,
      preset_class = "QuestsDef"
    }
  },
  EditorView = T(946118376279, "Place a badge of preset <u(BadgePreset)> on unit <u(BadgeUnit)>"),
  Documentation = "Place a badge on a unit.",
  EditorNestedObjCategory = "Units"
}
function SetBadgeEffect:__exec(obj, context)
  local quest = self.Quest and gv_Quests[self.Quest] or IsKindOf(obj, "QuestsDef") and obj or false
  if not quest then
    return
  end
  if not self.BadgeUnit then
    return
  end
  local prefix = ""
  if self.Remove then
    prefix = badgeRemoveIdentifier
  end
  quest[badgeParamIdentifier .. self.BadgeUnit] = prefix .. (self.BadgePreset or "")
  UpdateQuestBadges(quest)
end
DefineClass.SetBehaviorVisitAL = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "ActorGroup",
      name = "Actor Group",
      help = "Unit group that will exit the map.",
      editor = "combo",
      default = "",
      items = function(self)
        return GetUnitGroups()
      end
    },
    {
      id = "MarkerGroup",
      name = "Marker Group",
      help = "Exit marker group.",
      editor = "combo",
      default = "",
      no_edit = function(self)
        return self.closest
      end,
      items = function(self)
        return GetALMarkersGroups
      end
    },
    {
      id = "Kick",
      name = "Kick",
      editor = "bool",
      default = true
    }
  },
  EditorView = Untranslated("<u(ActorGroup)> visits <u(MarkerGroup)> marker"),
  Documentation = "Units vists specified Ambient Life marker",
  EditorNestedObjCategory = "Units"
}
function SetBehaviorVisitAL:__exec(obj, context)
  local group_actors = ValidateUnitGroupForEffectExec(self.ActorGroup, self, obj)
  local actors = table.ifilter(group_actors, function(_, actor)
    return IsKindOf(actor, "Unit") and not actor.perpetual_marker
  end)
  if #actors == 0 then
    return
  end
  local actor = actors[1]
  if not IsValid(actor) then
    return
  end
  local visitables = table.ifilter(g_Visitables, function(_, visitable)
    local marker_groups = visitable[1].Groups
    local from_group = not not table.find(marker_groups, self.MarkerGroup)
    return from_group
  end)
  if #visitables == 0 then
    return
  end
  local marker_visitable = visitables[1]
  if marker_visitable.reserved == actor.handle then
    return
  end
  local marker = marker_visitable[1]
  if marker_visitable.reserved then
    if not self.Kick then
      return
    end
    local unit = HandleToObject[marker_visitable.reserved]
    if IsValid(unit) then
      unit:FreeVisitable(marker_visitable)
      unit:SetCommand("Idle")
    end
  end
  actor:ReserveVisitable(marker_visitable)
  if marker:Random(100) < marker.ChanceSpawn then
    marker.perpetual_unit = actor
    actor.perpetual_marker = marker
  end
  if GameState and (GameState.entering_sector or GameState.setpiece_playing) and marker.Teleport then
    actor.teleport_allowed_once = true
  end
  actor:SetCommand("Visit", marker_visitable)
end
function SetBehaviorVisitAL:GetEditorView()
  return Untranslated("Sets <u(ActorGroup)> to visit <u(MarkerGroup)> marker")
end
DefineClass.SetDeploymentModeEffect = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "DeploymentMode",
      name = "Deployment Mode",
      help = "Sector id.",
      editor = "combo",
      default = "defend",
      items = function(self)
        return {"defend", "attack"}
      end
    },
    {
      id = "DeploymentDir",
      name = "Deployment Direction",
      help = "Deployment Direction during attack",
      editor = "combo",
      default = "North",
      no_edit = function(self)
        return self.DeploymentMode == "defend"
      end,
      items = function(self)
        return {
          "North",
          "East",
          "South",
          "West"
        }
      end
    }
  },
  Documentation = "Set Deployment Mode(and direction if attacking)r",
  EditorView = Untranslated("Set Deployment Mode")
}
function SetDeploymentModeEffect:__exec(obj, context)
  SetDeploymentMode(self.DeploymentMode)
  if self.DeploymentMode == "attack" then
    gv_DeploymentDir = self.DeploymentDir
  end
end
DefineClass.SetSectorAutoResolveDefenderBonus = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "autoResolveDefenderBonus",
      name = "Auto Resolve Defender Bonus",
      editor = "number",
      default = 0
    },
    {
      id = "sector_id",
      name = "Sector Id",
      help = "Sector id.",
      editor = "combo",
      default = "current",
      items = function(self)
        return table.iappend({
          {text = "current", value = "current"}
        }, GetCampaignSectorsCombo())
      end
    }
  },
  Documentation = "Set a sector's Auto Resolve Defender Bonus.",
  EditorView = Untranslated("Set <u(sector_id)> sector's Auto Resolve Defender Bonus to <u(autoResolveDefenderBonus)>"),
  EditorNestedObjCategory = "Sector effects"
}
function SetSectorAutoResolveDefenderBonus:__exec(obj, context)
  local sector_id = self.sector_id == "current" and gv_CurrentSectorId or self.sector_id
  local sector = gv_Sectors[sector_id]
  sector.AutoResolveDefenderBonus = self.autoResolveDefenderBonus
end
DefineClass.SetTimer = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Name",
      name = "Name",
      help = "Name of the timer.",
      editor = "text",
      default = false
    },
    {
      id = "Label",
      name = "Label",
      help = "The label to display on the timer.",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "Time",
      name = "Time",
      help = "Time (in secs) to wait.",
      editor = "number",
      default = 60000,
      scale = "sec"
    }
  },
  EditorView = Untranslated("Set timer <Name>"),
  Documentation = "The effect set a visual UI timer displayed in the upper center of the screen",
  EditorNestedObjCategory = "UI & Log"
}
function SetTimer:__exec(quest, context, TCE)
  if not GameState.Conflict and not GameState.ConflictScripted then
    StoreErrorSource("once", "SetTimer running in a sector without Conflict!")
  end
  TimerCreate(self.Name, self.Label, self.Time)
end
function SetTimer:__waitexec(quest, context, TCE)
  self:__exec(quest, context, TCE)
  return TimerWait(self.Name)
end
function SetTimer:__skip(quest, context, TCE)
  return self:__exec(quest, context, TCE)
end
function SetTimer:GetError()
  if not self.Name then
    return "SetTimer needs a name!"
  end
  if not self.Time then
    return "SetTimer needs time specified!"
  end
  if GetParentTableOfKindNoCheck(self, "TestHarness") then
    return
  end
  local container = GetParentTableOfKind(self, "TriggeredConditionalEvent")
  if not container then
    return "SetTimer can only be used in TCEs"
  end
  if not container.SequentialEffects then
    return "SetTimer can be used only in TCEs with Sequential Effects execution!"
  end
end
function SetTimer:GetResumeData(thread, stack, stack_index)
  return "TimerWait", self.Name
end
DefineClass.ShowGuardpostObjective = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "GuardpostObjective",
      name = "GuardpostObjective",
      editor = "preset_id",
      default = false,
      preset_class = "GuardpostObjective"
    }
  },
  EditorView = Untranslated("Make guardpost objective <u(GuardpostObjective)> visible."),
  Documentation = "Make a guardpost objective visible.",
  EditorNestedObjCategory = "Sectors"
}
function ShowGuardpostObjective:__exec(obj, context)
  SetGuardpostObjectiveSeen(self.GuardpostObjective)
end
DefineClass.ShowPopup = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "PopupId",
      help = "Popup notification preset id.",
      editor = "preset_id",
      default = false,
      preset_class = "PopupNotification"
    }
  },
  EditorView = Untranslated("Show popup notification <u(PopupId)>"),
  Documentation = "Displays popup notification",
  EditorNestedObjCategory = "UI & Log"
}
function ShowPopup:GetError()
  if not self.PopupId then
    return "No PopupId"
  end
end
function ShowPopup:__exec(obj, context)
  local id = self.PopupId
  local preset = PopupNotifications[id]
  if not preset then
    StoreErrorSource(Presets.PopupNotification[1][1], "Trying to show missing pop-up: " .. id)
    return
  end
  if preset.OnceOnly and gv_DisabledPopups[id] then
    return
  end
  ShowPopupNotification(id)
end
function ShowPopup:__waitexec(obj, context)
  self:__exec(obj, context)
  Msg("ClosePopup" .. self.PopupId)
end
function ShowPopup:__skip(quest, context, TCE)
  return self:__exec(quest, context, TCE)
end
function ShowPopup:GetResumeData(thread, stack, stack_index)
  return "ShowPopup", self.PopupId
end
DefineClass.SleepEffect = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Sleep",
      name = "Sleep",
      help = "Sleep time in ms.",
      editor = "number",
      default = 1000
    }
  },
  Documentation = "An effect to delay other effects' execution."
}
function SleepEffect:GetEditorView()
  return T(206265192932, "Delay: <u(Sleep)> ms")
end
function SleepEffect:__exec(obj, context)
  return
end
function SleepEffect:__waitexec(obj, context)
  Sleep(self.Sleep)
end
function SleepEffect:__skip(quest, context, TCE)
end
function SleepEffect:GetResumeData(thread, stack, stack_index)
  local remainig = GetThreadStatus(thread) - GameTime()
  return "Sleep", remainig
end
DefineClass.StartDeploymentInCurrentSector = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "WaitClicked",
      name = "Wait Clicked",
      help = "Waits for the button to be clicked before continuing to trigger next effects.",
      editor = "bool",
      default = false
    },
    {
      id = "EntranceZone",
      name = "EntranceZone",
      help = "Specific entrance zone",
      editor = "choice",
      default = "custom",
      items = function(self)
        return {
          "attacker",
          "defender",
          "custom"
        }
      end
    }
  },
  Documentation = "Enter deployment mode if it is valid for the currently loaded sector",
  EditorView = Untranslated("Enter deployment mode")
}
function StartDeploymentInCurrentSector:__exec(obj, context)
  if self.EntranceZone and self.EntranceZone ~= "custom" then
    SetDeploymentMode(self.EntranceZone)
  else
    gv_Deployment = "custom"
  end
  StartDeployment()
end
function StartDeploymentInCurrentSector:__waitexec(obj, context)
  self:__exec(obj, context)
  if self.WaitClicked then
    WaitMsg("DeploymentModeDone")
  end
end
function StartDeploymentInCurrentSector:__skip(quest, context, TCE)
  return self:__exec(quest, context, TCE)
end
function StartDeploymentInCurrentSector:GetResumeData(thread, stack, stack_index)
  return "StartDeploymentInCurrentSector", self.EntranceZone
end
DefineClass.TriggerGuardPostAttack = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "guardpost_sector_id",
      name = "Guardpost Sector",
      help = "Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "effect_target_sector_ids",
      name = "Target Sectors",
      help = "Attack one of these sectors.",
      editor = "string_list",
      default = {},
      item_default = "last captured",
      items = function(self)
        return GetCampaignSectorsCombo("last captured")
      end
    },
    {
      id = "time",
      name = "Time",
      help = "Time to pass before spawning the squad.",
      editor = "number",
      default = 43200,
      scale = "h"
    },
    {
      id = "custom_quest_id",
      name = "Custom Quest Id",
      help = "This could would be used in quests (ex. to check if the attack squad was defeated - with SquadDefeated condition).",
      editor = "text",
      default = false
    },
    {
      id = "reach_quest_id",
      name = "Reach Quest Id",
      help = "Quest to set variables to true when squad reaches it destination sector.",
      editor = "preset_id",
      default = false,
      preset_class = "QuestsDef"
    },
    {
      id = "reach_quest_var",
      name = "Var to check",
      help = "Variable in reach quest to set to true when squad reaches it destination sector",
      editor = "set",
      default = false,
      max_items_in_set = 1,
      items = function(self)
        return table.keys2(QuestGetVariables(self.reach_quest_id), "sorted")
      end
    }
  },
  Documentation = "Spawns enemy squad from guardpost after time.",
  EditorNestedObjCategory = "Sector effects"
}
function TriggerGuardPostAttack:GetEditorView()
  local targets = Untranslated(table.concat(self.effect_target_sector_ids, ", "))
  return T({
    926384305749,
    "Spawns enemy squad from guardpost on <u(guardpost_sector_id)> to (<targets>) after <CampaignTime(time)>",
    self,
    targets = targets
  })
end
function TriggerGuardPostAttack:__exec(obj, context)
  local gp = g_Guardposts[self.guardpost_sector_id]
  if not gp then
    StoreErrorSource(self, "TriggerGuardPostAttack - guardpost_sector_id should be sector with guardpost.")
  end
  if table.find(self.effect_target_sector_ids, "last captured") and not gv_LastSectorTakenByPlayer then
    return
  end
  if gp then
    gp:ForceSetNextSpawnTimeAndSector(self.time, self.effect_target_sector_ids, self.custom_quest_id, self.reach_quest_id, self.reach_quest_var)
  end
end
function TriggerGuardPostAttack:GetError()
  if not self.guardpost_sector_id then
    return "Specify Guardpost Sector"
  elseif not self.effect_target_sector_ids[1] or self.effect_target_sector_ids[1] == "" then
    return "Specify Target Sector!"
  end
  local sector = gv_Sectors and gv_Sectors[self.guardpost_sector_id]
  if sector and not sector.Guardpost then
    return "Sector should be a guardpost sector!"
  end
end
DefineClass.TriggerSectorWarningState = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  RequiredObjClasses = {"Unit"},
  EditorView = Untranslated("Trigger the current sector's Warning State"),
  Documentation = "Triggers the Warning State for the current sector.",
  EditorNestedObjCategory = "Sector effects"
}
function TriggerSectorWarningState:__exec(obj, context)
  if gv_SatelliteView then
    return
  end
  local sector = gv_Sectors[gv_CurrentSectorId]
  local alliedUnits = GetPlayerSectorUnits(gv_CurrentSectorId, "getUnits")
  local enemyUnits = GetAllEnemyUnits(alliedUnits[1])
  local triggeringUnit
  if IsKindOf(obj, "Unit") and table.find(alliedUnits, obj) then
    triggeringUnit = obj
  else
    triggeringUnit = alliedUnits[1]
  end
  EnterWarningState(enemyUnits, alliedUnits, triggeringUnit)
end
DefineClass.TriggerSquadAttack = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "source_sector_id",
      name = "Source Sector",
      help = "Source Sector id.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "effect_target_sector_ids",
      name = "Target Sectors",
      help = "Attack one of these sectors.",
      editor = "string_list",
      default = {},
      item_default = "last captured",
      items = function(self)
        return GetCampaignSectorsCombo("last captured")
      end
    },
    {
      id = "reach_quest_id",
      name = "Reach Quest Id",
      help = "Quest to set variables to true when squad reaches it destination sector.",
      editor = "preset_id",
      default = false,
      preset_class = "QuestsDef"
    },
    {
      id = "reach_quest_var",
      name = "Var to check",
      help = "Variable in reach quest to set to true when squad reaches it destination sector",
      editor = "set",
      default = false,
      max_items_in_set = 1,
      items = function(self)
        return table.keys2(QuestGetVariables(self.reach_quest_id), "sorted")
      end
    },
    {
      id = "custom_quest_id",
      name = "Custom Quest Id",
      help = "This could would be used in quests (ex. to check if the attack squad was defeated - with SquadDefeated condition).",
      editor = "text",
      default = false
    },
    {
      id = "EnemySquadsList",
      name = "Enemy Squads List",
      help = "A random squad from the list will be chosen on guardpost spawn time",
      editor = "preset_id_list",
      default = {},
      no_edit = function(self)
        return not self.Guardpost
      end,
      preset_class = "EnemySquads",
      preset_filter = function(preset, obj)
        if preset.group ~= "Test Encounters" then
          return obj
        end
      end,
      item_default = ""
    },
    {
      id = "Squad",
      name = "Squad",
      help = "Squad that will be spawned in the sector on campaign start",
      editor = "combo",
      default = false,
      items = function(self)
        return EnemySquadsComboItems("exclude test squads")
      end
    }
  },
  Documentation = "Spawns specific enemy squad  after time.",
  EditorNestedObjCategory = "Sector effects"
}
function TriggerSquadAttack:GetEditorView()
  local targets = Untranslated(table.concat(self.effect_target_sector_ids, ", "))
  return T({
    768343821287,
    "Spawns specific enemy squad to (<targets>)",
    self,
    targets = targets
  })
end
function TriggerSquadAttack:__exec(obj, context)
  if table.find(self.effect_target_sector_ids, "last captured") and not gv_LastSectorTakenByPlayer then
    return
  end
  local sector = gv_Sectors[self.source_sector_id]
  if not sector then
    return
  end
  local sector_ids = self.effect_target_sector_ids
  if gv_LastSectorTakenByPlayer then
    table.replace(sector_ids, "last captured", gv_LastSectorTakenByPlayer)
  end
  local target_sector_id = table.interaction_rand(sector_ids, "TriggerSquadAttack")
  local squad_id = GenerateEnemySquad(self.Squad, self.source_sector_id, "TriggerSquadAttack")
  if squad_id then
    gv_CustomQuestIdToSquadId[self.custom_quest_id or self.Squad] = squad_id
    local squad = gv_Squads[squad_id]
    squad.on_reach_quest = self.reach_quest_id
    squad.on_reach_var = self.reach_quest_var
    if target_sector_id ~= self.source_sector_id then
      SendSatelliteSquadOnRoute(squad, target_sector_id)
      local timeToReach = GetTotalRouteTravelTime(squad.CurrentSector, squad.route, squad)
      AddTimelineEvent("squad-attack-" .. squad.UniqueId, Game.CampaignTime + timeToReach, "squad-attack", squad.UniqueId)
    end
    return squad_id
  end
  StoreErrorSource(sector, string.format("Sector '%s' does not have enemy squad '%s'", self.source_sector_id, self.Squad))
end
function TriggerSquadAttack:GetError()
  if not self.Squad then
    return "Specify Squad"
  elseif not self.effect_target_sector_ids[1] or self.effect_target_sector_ids[1] == "" then
    return "Specify Target Sector!"
  end
end
DefineClass.UnitAddGrit = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "amount",
      name = "Amount",
      editor = "number",
      default = 30
    }
  },
  RequiredObjClasses = {"Unit", "UnitData"},
  EditorView = Untranslated("Add grit to the unit."),
  Documentation = "Add grit to the unit.",
  EditorNestedObjCategory = "Units"
}
function UnitAddGrit:__exec(obj, context)
  local unit = obj
  if IsKindOf(unit, "UnitData") then
    unit = g_Units[unit.session_id]
  end
  if IsKindOf(unit, "Unit") and not unit:IsDead() then
    unit:ApplyTempHitPoints(self.amount)
  end
end
DefineClass.UnitAddStatusEffect = {
  __parents = {"Effect", "UnitTarget"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Status",
      name = "Status",
      editor = "preset_id",
      default = false,
      preset_class = "CharacterEffectCompositeDef"
    }
  },
  RequiredObjClasses = {"Unit"},
  EditorView = Untranslated("Add <u(Status)> effect to the unit"),
  Documentation = "Add status effect to a unit"
}
function UnitAddStatusEffect:__exec(obj, context)
  if IsKindOf(obj, "Unit") and not obj:IsDead() then
    obj:AddStatusEffect(self.Status)
  end
  context = context or {}
  local units = self:MatchMapUnits(obj, context)
  if units and context.target_units then
    for _, unit in ipairs(context.target_units) do
      if self.Status == "Wounded" then
        obj:AddWounds(1)
      else
        obj:AddStatusEffect(self.Status)
      end
    end
  end
end
function UnitAddStatusEffect:UnitCheck(unit, obj, context)
  return IsKindOf(unit, "Unit") and not unit:IsDead()
end
function UnitAddStatusEffect:GetEditorView()
  return T(237536962390, "Add <u(Status)> to the unit")
end
DefineClass.UnitApplyAppearance = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "TargetUnit",
      name = "Target Unit",
      help = "Target unit for match.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetUnitGroups()
      end
    },
    {
      id = "Appearance",
      name = "Appearance",
      help = "Appearance to set.",
      editor = "preset_id",
      default = false,
      preset_class = "AppearancePreset"
    }
  },
  EditorView = Untranslated("<u(TargetUnit)> changes appearance to <Appearance>"),
  Documentation = "Changes the appearance of an unit",
  EditorNestedObjCategory = "Units"
}
function UnitApplyAppearance:__exec(obj, context)
  local units = Groups[self.TargetUnit] or empty_table
  if units[1] then
    units[1]:ApplyAppearance(self.Appearance)
  end
end
function UnitApplyAppearance:GetError()
  if not self.TargetUnit then
    return "Choose target unit to die"
  end
end
DefineClass.UnitDie = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "TargetGroup",
      name = "Target Group",
      help = "Target group for match.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetUnitGroups()
      end
    },
    {
      id = "skipAnim",
      name = "Skip Animation",
      editor = "bool",
      default = false
    },
    {
      id = "killImmortal",
      name = "Kill Immortal",
      help = "Makes units mortal and then kills them.",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("Units from group <u(TargetGroup)> die"),
  Documentation = "Kill units from specified group",
  EditorNestedObjCategory = "Units"
}
function UnitDie:__exec(obj, context)
  local group = Groups[self.TargetGroup] or empty_table
  for i, v in ipairs(group) do
    if IsKindOf(v, "Unit") then
      v.villain = false
      if self.killImmortal then
        v.immortal = false
      end
      v:SetCommand("Die", self.skipAnim)
    end
  end
end
function UnitDie:GetError()
  if not self.TargetGroup then
    return "Choose target unit to die"
  end
end
DefineClass.UnitEnvEffectTick = {
  __parents = {"UnitTarget", "Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "EffectType",
      editor = "choice",
      default = "Burning",
      items = function(self)
        return {
          "Burning",
          "ToxicGas",
          "TearGas",
          "Smoke",
          "Darkness"
        }
      end
    },
    {
      id = "CombatMoment",
      editor = "choice",
      default = "n/a",
      items = function(self)
        return {
          "start turn",
          "end turn",
          "n/a"
        }
      end
    }
  },
  EditorView = Untranslated("Trigger <u(EffectType)> tick for <u(TargetUnit)>"),
  Documentation = "Trigger environmental effect tick for target unit",
  EditorNestedObjCategory = "Units"
}
function UnitEnvEffectTick:__exec(obj, context)
  context = context or {}
  local units = self:MatchMapUnits(obj, context)
  if units and context.target_units then
    local moment = self.CombatMoment ~= "n/a" and self.CombatMoment or nil
    local func = EnvEffectBurningTick
    if self.EffectType == "ToxicGas" then
      func = EnvEffectToxicGasTick
    elseif self.EffectType == "TearGas" then
      func = EnvEffectTearGasTick
    elseif self.EffectType == "Smoke" then
      func = EnvEffectSmokeTick
    elseif self.EffectType == "Darkness" then
      func = EnvEffectDarknessTick
    end
    for _, unit in ipairs(context.target_units) do
      if IsValid(unit) and IsKindOf(unit, "Unit") and not unit:IsDead() then
        func(unit, nil, moment)
      end
    end
  end
end
function UnitEnvEffectTick:GetError()
  if not self.TargetUnit then
    return "Choose target unit"
  end
end
function UnitEnvEffectTick:UnitCheck(unit, obj, context)
  return true
end
DefineClass.UnitGrantAP = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "ap",
      name = "AP",
      help = "Action Points to Give",
      editor = "number",
      default = 8
    }
  },
  RequiredObjClasses = {"Unit"},
  EditorView = Untranslated("Grant <u(ap)> AP to the unit"),
  Documentation = "Modify unit's AP",
  EditorNestedObjCategory = "Units"
}
function UnitGrantAP:__exec(obj, context)
  if IsKindOf(obj, "Unit") and not obj:IsDead() then
    if self.ap > 0 then
      obj:GainAP(self.ap * const.Scale.AP)
    else
      obj:ConsumeAP(self.ap * const.Scale.AP)
    end
  end
end
DefineClass.UnitGrantItem = {
  __parents = {
    "Effect",
    "LootTableFunctionObjectBase"
  },
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "ItemId",
      name = "Item",
      help = "The id of the item that will be granted.",
      editor = "preset_id",
      default = false,
      preset_class = "InventoryItemCompositeDef"
    },
    {
      id = "Amount",
      name = "Amount",
      help = "How many items are granted.",
      editor = "number",
      default = 1,
      min = 1
    },
    {
      id = "LootTableId",
      name = "Loot Table Id",
      help = "Loot table to generate items that will be granted.",
      editor = "preset_id",
      default = false,
      preset_class = "LootDef"
    },
    {
      id = "GrantedItemsTextUI",
      editor = "text",
      default = false,
      dont_save = true,
      no_edit = true,
      translate = true
    },
    {
      id = "GrantedItemsEditorTextUI",
      editor = "text",
      default = false,
      dont_save = true,
      no_edit = true,
      translate = true
    },
    {
      id = "GeneratedItems",
      editor = "prop_table",
      default = false,
      dont_save = true,
      no_edit = true
    },
    {
      id = "actor",
      name = "Log Actor",
      help = "How to log the received items.",
      editor = "choice",
      default = "important",
      items = function(self)
        return {"short", "important"}
      end
    }
  },
  Documentation = "Give item to a merc or to any from its squad.",
  EditorNestedObjCategory = "Units"
}
function UnitGrantItem:GetEditorView()
  if self.ItemId and self.LootTableId then
    return Untranslated("<u(ItemId)>(<Amount>) and '<u(LootTableId)>' loot table items are given to the merc")
  end
  if self.ItemId then
    return Untranslated("<u(ItemId)>(<Amount>) given to the merc")
  end
  if self.LootTableId then
    return Untranslated("Loot table items '<u(LootTableId)>' given to the merc")
  end
  return ""
end
function UnitGrantItem:__exec(obj, context)
  local unit_id = type(obj) == "string" and obj or obj.session_id
  local squad = gv_UnitData[unit_id] and gv_UnitData[unit_id].Squad
  if not squad then
    local squads = GetSectorSquadsFromSide(gv_CurrentSectorId, "player1")
    squad = 0 < #squads and squads[1].UniqueId
  end
  if not squad and g_PlayerSquads and 0 < #g_PlayerSquads then
    squad = g_PlayerSquads[1].UniqueId
  end
  if not squad then
    return
  end
  local sector = gv_Squads[squad].CurrentSector
  local all_mercs = gv_Squads[squad].units
  if unit_id then
    all_mercs = table.copy(all_mercs)
    table.remove_entry(all_mercs, unit_id)
    table.insert(all_mercs, 1, unit_id)
  end
  unit_id = unit_id or all_mercs[1]
  local items = UnitGrantItem.GenerateItems(self, "game") or {}
  CombatLogActorOverride = self.actor
  AddItemsToSquadBag(squad, items)
  for idx, merc in ipairs(all_mercs) do
    if #items <= 0 then
      break
    end
    local unit = g_Units[merc] or gv_UnitData[merc]
    unit:AddItemsToInventory(items)
  end
  if 0 < #items then
    local unit = g_Units[unit_id]
    if unit then
      unit:DropItemsInContainer(items, function(unit, item, amount)
        CombatLog("important", T({
          740183432105,
          "  Inventory full. <amount><em><item></em> dropped by <name>",
          amount = 1 < amount and Untranslated(amount .. " x ") or "",
          item = 1 < amount and item.DisplayNamePlural or item.DisplayName,
          name = unit:GetDisplayName()
        }))
      end)
    else
      local stash = GetSectorInventory(sector)
      if stash then
        AddItemsToInventory(stash, items, true)
      end
    end
  end
  if self.ItemId then
    local amount = self.Amount
    local item
    if 0 < amount then
      amount = AddItemToSquadBag(squad, self.ItemId, amount)
    end
    for idx, merc in ipairs(all_mercs) do
      if amount <= 0 then
        break
      end
      local unit = g_Units[merc] or gv_UnitData[merc]
      amount = unit:AddToInventory(self.ItemId, amount)
    end
    if 0 < amount then
      local unit = g_Units[unit_id]
      if unit then
        unit:DropItemContainer(self.ItemId, amount, function(unit, item, amount)
          CombatLog("important", T({
            740183432105,
            "  Inventory full. <amount><em><item></em> dropped by <name>",
            amount = 1 < amount and Untranslated(amount .. " x ") or "",
            item = 1 < amount and item.DisplayNamePlural or item.DisplayName,
            name = unit:GetDisplayName()
          }))
        end)
      else
        local stash = GetSectorInventory(sector)
        if stash then
          local itm = PlaceInventoryItem(self.ItemId)
          AddItemsToInventory(stash, {itm}, true)
        end
      end
    end
  end
  self.GeneratedItems = false
  CombatLogActorOverride = false
end
function UnitGrantItem:GetError()
  if (not self.ItemId or self.ItemId == "") and not self.LootTableId then
    return "Set Item or loot table!"
  end
end
function UnitGrantItem:GetPhraseTopRolloverText(negative, template, game)
  local item = self.ItemId and InventoryItemDefs[self.ItemId]
  if item then
    local item_name = item.DisplayName
    local item_name_pl = item.DisplayNamePlural
    if self.ItemId == "Money" then
      return T({
        283114521154,
        "<em><money(Amount)></em> obtained",
        Amount = self.Amount
      })
    else
      return T({
        215465168779,
        "<Amount> x <em><item></em> obtained",
        Amount = self.Amount,
        item = self.Amount <= 1 and item_name or item_name_pl
      })
    end
  end
  self:GenerateItems(game)
  if game then
    if self.GrantedItemsTextUI and self.GrantedItemsTextUI ~= "" then
      return T({
        871249882862,
        "<items_list> obtained",
        items_list = self.GrantedItemsTextUI
      })
    end
  elseif self.GrantedItemsEditorTextUI and self.GrantedItemsEditorTextUI ~= "" then
    return T({
      871249882862,
      "<items_list> obtained",
      items_list = self.GrantedItemsEditorTextUI
    })
  end
end
function UnitGrantItem:GenerateItems(game)
  if game and self.GeneratedItems then
    return self.GeneratedItems
  end
  if not game and self.GrantedItemsEditorTextUI then
    return
  end
  local items = {}
  local loot_tbl = LootDefs[self.LootTableId]
  if loot_tbl then
    loot_tbl:GenerateLoot(self, {}, InteractionRand(nil, "Loot"), items)
  end
  if 0 < #items then
    if game then
      self.GeneratedItems = items
      self.GrantedItemsTextUI = GetItemsNamesText(items)
    else
      self.GrantedItemsEditorTextUI = GetItemsNamesText(items)
    end
  end
  return items
end
function UnitGrantItem:GetPhraseFX()
  return "ConversationItemGained"
end
DefineClass.UnitJoinAsMerc = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "TargetUnit",
      name = "Target Unit",
      help = "Target unit for match.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetUnitGroups()
      end
    },
    {
      id = "Merc",
      help = "The Merc to join the team.",
      editor = "combo",
      default = false,
      items = function(self)
        return MercPresetCombo()
      end
    }
  },
  RequiredObjClasses = {"Unit"},
  EditorView = Untranslated("Make <u(TargetUnit)> join team as <u(Merc)>"),
  Documentation = "Unit joins as a specified merc.",
  EditorNestedObjCategory = "Units"
}
function UnitJoinAsMerc:__exec(obj, context)
  local units = Groups[self.TargetUnit] or empty_table
  units = table.ifilter(units, function(_, u)
    return IsKindOf(u, "Unit")
  end)
  local unit_id = type(obj) == "string" and obj or obj.session_id
  local squad = gv_UnitData[unit_id] and gv_UnitData[unit_id].Squad
  squad = squad and gv_Squads[squad]
  if units[1] and squad and self.Merc then
    units[1]:JoinSquadAs(self.Merc, squad)
  end
end
function UnitJoinAsMerc:GetError()
  if not self.TargetUnit then
    return "Choose target unit to join"
  end
  if not self.Merc then
    return "Choose merc as which the unit joins"
  end
end
function UnitJoinAsMerc:GetUIText(context, template, game)
  local merc = gv_UnitData and gv_UnitData[self.Merc]
  local name
  if not merc then
    name = game and "" or Untranslated("[MercName]")
  else
    name = merc.Nick or merc.Name
  end
  return T({
    246469241790,
    "Recruit merc (<em><name></em>)",
    name = name
  })
end
DefineClass.UnitSetConflictIgnore = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "ConflictIgnore",
      name = "Conflict Ignore",
      help = "Whether to be afraid in conflicts or not.",
      editor = "bool",
      default = true
    },
    {
      id = "TargetUnit",
      name = "Target Unit",
      help = "Target unit for match.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetUnitGroups()
      end
    }
  },
  EditorView = Untranslated("Set <u(TargetUnit)> ConflictIgnore to <if(ConflictIgnore)>true</if><if(not(ConflictIgnore))>false</if>."),
  Documentation = "Sets units to be affraid(or not) during confict.",
  EditorNestedObjCategory = "Units"
}
function UnitSetConflictIgnore:__exec(obj, context)
  local objects = Groups[self.TargetUnit] or empty_table
  for _, obj in ipairs(objects) do
    if IsKindOf(obj, "Unit") then
      obj.conflict_ignore = self.ConflictIgnore
    end
  end
end
function UnitSetConflictIgnore:GetError()
  if not self.TargetUnit then
    return "Choose TargetUnit!"
  end
end
DefineClass.UnitSetHireStatus = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Status",
      name = "Hire Status",
      help = "The hiring status to set.",
      editor = "choice",
      default = "Available",
      items = function(self)
        return PresetGroupCombo("MercHireStatus", "Default")
      end
    },
    {
      id = "TargetUnit",
      name = "Target Unit",
      help = "Target unit for match.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetTargetUnitCombo()
      end
    }
  },
  EditorView = Untranslated("Set <u(TargetUnit)> to status <u(Status)>"),
  Documentation = "Sets the hiring status of the merc to a specified value.",
  EditorNestedObjCategory = "Units"
}
function UnitSetHireStatus:__exec(obj, context)
  if not self.Status then
    return false
  end
  local unit = UnitDataDefs[self.TargetUnit]
  local unitData = gv_UnitData[unit.id]
  if not unitData then
    return
  end
  unitData.HireStatus = self.Status
end
function UnitSetHireStatus:GetError()
  if not self.Status then
    return "Choose unit hiring status to set!"
  end
end
DefineClass.UnitSetOnline = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Online",
      name = "Online",
      help = "Whether to set it online or offline.",
      editor = "bool",
      default = true
    },
    {
      id = "TargetUnit",
      name = "Target Unit",
      help = "Target unit for match.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetTargetUnitCombo()
      end
    }
  },
  EditorView = Untranslated("Set <u(TargetUnit)> messenger availability to <u(Status)>"),
  Documentation = "Sets a merc's online/offline status in the PDA messenger. When offline mercs cannot be hired.",
  EditorNestedObjCategory = "Units"
}
function UnitSetOnline:__exec(obj, context)
  local unit = UnitDataDefs[self.TargetUnit]
  local unitData = gv_UnitData[unit.id]
  if not unitData then
    return
  end
  unitData:SetMessengerOnline(self.Online)
end
function UnitSetOnline:GetError()
  if not self.TargetUnit then
    return "Choose targetunit!"
  end
end
DefineClass.UnitSetStatusEffectImmunity = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Status",
      name = "Status",
      editor = "preset_id",
      default = false,
      preset_class = "CharacterEffectCompositeDef"
    },
    {
      id = "Immune",
      editor = "bool",
      default = false
    },
    {
      id = "Reason",
      help = "Text label used for keeping track of the different reasons a unit can have for being immune to the specific status effect. All reasons must be cleared in order for the unit to be able to receive the effect again.",
      editor = "text",
      default = "script"
    }
  },
  RequiredObjClasses = {"Unit"},
  ReturnClass = "",
  EditorView = Untranslated(""),
  Documentation = "Add or remove immunity to specified status effect to a target unit",
  EditorNestedObjCategory = ""
}
function UnitSetStatusEffectImmunity:GetEditorView()
  if self.Immune then
    return Untranslated("Make unit immune to <u(Status)>")
  end
  return Untranslated("Clear immunity to <u(Status)> from unit")
end
function UnitSetStatusEffectImmunity:__exec(obj, context)
  if self.Immune then
    obj:AddStatusEffectImmunity(self.Status, self.Reason)
  else
    obj:RemoveStatusEffectImmunity(self.Status, self.Reason)
  end
end
DefineClass.UnitStartConversation = {
  __parents = {
    "Effect",
    "ConversationFunctionObjectBase"
  },
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Conversation",
      name = "Conversation",
      help = "Conversation to start.",
      editor = "preset_id",
      default = false,
      preset_class = "Conversation"
    }
  },
  EditorView = Untranslated("Start conversation <u(Conversation)>."),
  Documentation = "Starts a specific conversation - no groups or conditions are checked.",
  EditorNestedObjCategory = "",
  EditorNestedObjCategory = "Interactions"
}
function UnitStartConversation:__exec(obj, context)
  StartConversationEffect(self.Conversation, context)
end
function UnitStartConversation:__waitexec(obj, context)
  StartConversationEffect(self.Conversation, context, "wait")
end
function UnitStartConversation:GetError()
  if not self.Conversation then
    return "Please specify conversation"
  end
end
function UnitStartConversation:new(...)
  local ret = Effect.new(self, ...)
  if rawget(ret, "Group") then
    ret.Conversation = ret.Group
    ret.Group = nil
  end
  return ret
end
function UnitStartConversation:GetResumeData(thread, stack, stack_index)
  return "UnitStartConversation", self.Conversation
end
DefineClass.UnitStatBoost = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Stat",
      name = "Stat",
      editor = "combo",
      default = false,
      items = function(self)
        return GetUnitStatsCombo()
      end
    },
    {
      id = "Amount",
      name = "Amount",
      help = "How much to boost the specified Stat.",
      editor = "number",
      default = false
    },
    {
      id = "source",
      name = "Source",
      help = "What kind of source is the thing that provides the stat boost.",
      editor = "combo",
      default = "Book",
      items = function(self)
        return {"Book", "Other"}
      end
    }
  },
  RequiredObjClasses = {"Unit"},
  EditorView = Untranslated("Boost unit's stat <Stat>"),
  Documentation = "Boosts unit's stat",
  EditorNestedObjCategory = "Units"
}
function UnitStatBoost:__exec(obj, context)
  if not obj.is_clone then
    local modId
    if self.source == "Book" then
      modId = string.format("StatBoostBook-%s-%s-%d", self.Stat, obj.session_id, GetPreciseTicks())
      GainStat(obj, self.Stat, self.Amount, modId, "Studying")
    else
      modId = string.format("StatBoost-%s-%s-%d", self.Stat, obj.session_id, GetPreciseTicks())
      GainStat(obj, self.Stat, self.Amount, modId)
    end
  end
end
function UnitStatBoost:GetError()
  if not self.Stat then
    return "Choose stat"
  elseif not self.Amount then
    return "Choose amount"
  end
end
DefineClass.UnitTakeDamage = {
  __parents = {"Effect", "UnitTarget"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Damage",
      editor = "number",
      default = 5,
      min = 0
    },
    {
      id = "FloatingText",
      help = "Will only be displayed if the target unit is visible for the player; <Damage> parameter will be provided for the text.",
      editor = "text",
      default = T(477545213542, "<Damage>"),
      translate = true
    },
    {
      id = "LogMessage",
      help = "<Damage> and <Name> parameters will be provided for the text.",
      editor = "text",
      default = T(879191059352, "<em><Name></em> takes <em><Damage></em> damage."),
      translate = true
    }
  },
  RequiredObjClasses = {"Unit"},
  EditorView = Untranslated("Deal <Damage> damage to the unit"),
  Documentation = "Deal damage to the unit"
}
function UnitTakeDamage:__exec(obj, context)
  context = context or {}
  local units = self:MatchMapUnits(obj, context)
  if units and context.target_units then
    local floating_text = T({
      self.FloatingText,
      Damage = self.Damage
    })
    local pov_team = GetPoVTeam()
    for _, unit in ipairs(context.target_units) do
      if not unit:IsDead() then
        local has_visibility = HasVisibilityTo(pov_team, obj)
        local log_msg = T({
          self.LogMessage,
          {
            Name = unit:GetLogName(),
            Damage = self.Damage
          }
        })
        unit:TakeDirectDamage(self.Damage, has_visibility and floating_text or false, "short", log_msg)
      end
    end
  end
end
function UnitTakeDamage:UnitCheck(unit, obj, context)
  return true
end
DefineClass.UnitTakeItem = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "ItemId",
      name = "Item",
      help = "The id of the item that will be taken.",
      editor = "preset_id",
      default = false,
      preset_class = "InventoryItemCompositeDef"
    },
    {
      id = "Amount",
      name = "Amount",
      help = "How many items to take.",
      editor = "number",
      default = 1,
      min = 1
    },
    {
      id = "AnySquad",
      name = "Any player squad",
      help = "if true: takes item from any player's squad. if false: takes item from current squad",
      editor = "bool",
      default = false
    },
    {
      id = "AddToLogVar",
      name = "Add to log",
      help = "Add message to log.",
      editor = "bool",
      default = true
    }
  },
  EditorView = Untranslated("Take <u(ItemId)>(<Amount>)  from merc(s) in squad."),
  Documentation = "Removes the first given item from the inventory of a merc in the squad.",
  EditorNestedObjCategory = "Units"
}
function UnitTakeItem:AddToLog(unit, item, amount)
  if self.AddToLogVar then
    local unit_name
    if type(unit) == "number" then
      unit_name = g_Classes.SquadBag.DisplayName
    else
      unit_name = unit:GetDisplayName()
    end
    CombatLog("short", T({
      795253111432,
      "<amount> x <em><item></em> taken from <name>",
      amount = 1 <= amount and amount or "",
      item = 1 < amount and item.DisplayNamePlural or item.DisplayName,
      name = unit_name
    }))
  end
end
function UnitTakeItem:__exec(obj, context)
  local unit_id = false
  if type(obj) == "string" then
    unit_id = obj
  elseif IsKindOf(obj, "Unit") then
    unit_id = obj.session_id
  end
  local all_mercs = false
  local squad = unit_id and gv_UnitData[unit_id] and gv_UnitData[unit_id].Squad
  if squad then
    if self.AnySquad then
      local side = gv_Squads[squad].Side
      all_mercs = {}
      for _, sqd in pairs(gv_Squads) do
        if sqd.Side == side then
          table.iappend(all_mercs, sqd.units)
        end
      end
    else
      all_mercs = table.copy(gv_Squads[squad].units)
    end
    table.remove_entry(all_mercs, unit_id)
    table.insert(all_mercs, 1, unit_id)
  else
    all_mercs = GetAllPlayerUnitsOnMapSessionId()
  end
  TakeItemFromMercs(all_mercs, self.ItemId, self.Amount, function(unit, item, unit_amount, effect)
    effect:AddToLog(unit, item, unit_amount)
  end, self)
  InventoryUIRespawn()
end
function UnitTakeItem:GetError()
  if not self.ItemId then
    return "Set Item!"
  end
end
function UnitTakeItem:GetUIText(context, template, game)
  local item_name = InventoryItemDefs[self.ItemId].DisplayName
  local item_name_pl = InventoryItemDefs[self.ItemId].DisplayNamePlural
  local unit_id = ConversationGetPlayerMerc()
  local has_item = HasItemInSquad(unit_id, self.ItemId, self.Amount)
  if self.ItemId == "Money" then
    return has_item and T({
      304179156341,
      "Give <em><money(Amount)></em>",
      Amount = self.Amount
    }) or T({
      231000532062,
      "<em><money(Amount)></em> required",
      Amount = self.Amount
    })
  end
  if template then
    return T({
      template,
      Amount = self.Amount,
      item = self.Amount <= 1 and item_name or item_name_pl
    })
  else
    return has_item and T({
      590581690149,
      "Give <em><Amount> <item></em>",
      Amount = self.Amount,
      item = self.Amount <= 1 and item_name or item_name_pl
    }) or T({
      635806839384,
      "<em><Amount> <item></em> required",
      Amount = self.Amount,
      item = self.Amount <= 1 and item_name or item_name_pl
    })
  end
end
function UnitTakeItem:GetPhraseTopRolloverText(negative, template, game)
  local item_name = InventoryItemDefs[self.ItemId].DisplayName
  local item_name_pl = InventoryItemDefs[self.ItemId].DisplayNamePlural
  if self.ItemId == "Money" then
    return T({
      792302629761,
      "Delivered <em><money(Amount)></em>",
      Amount = self.Amount
    })
  else
    return T({
      652398655206,
      "Delivered <Amount> x <em><item></em>",
      Amount = self.Amount,
      item = self.Amount <= 1 and item_name or item_name_pl
    })
  end
end
DefineClass.UnitsAddToAmbientLife = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Group",
      name = "Group",
      help = "Units Group to add to Ambient Life.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetUnitGroups()
      end
    }
  },
  EditorView = Untranslated("Add objects of group to Ambient Zone"),
  Documentation = "Add objects of group to Ambient Zone marker's responsibilities."
}
function UnitsAddToAmbientLife:GetError()
  if not self.Group then
    return "Choose Units Group!"
  end
end
function UnitsAddToAmbientLife:__exec(obj, context)
  local group_units = Groups[self.Group] or empty_table
  if #group_units == 0 then
    return
  end
  local zone
  MapForEach("map", "AmbientZoneMarker", function(marker)
    zone = marker
    return false
  end)
  if zone then
    zone:RegisterUnits(table.ifilter(group_units, function(i, u)
      return IsKindOf(u, "Unit")
    end))
  end
end
DefineClass.UnitsDespawnAmbientLife = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Ephemeral",
      name = "Ephemeral Only",
      help = "All ambient life units or just ephemeral ones.",
      editor = "bool",
      default = true
    }
  },
  EditorView = Untranslated("Despawn all Ambient Life Units"),
  Documentation = "Despawn all ambient units - abrupt, don't wait for exit animations."
}
function UnitsDespawnAmbientLife:__exec(obj, context)
  MapForEach("map", "AmbientZoneMarker", function(zone)
    for _, units in ipairs(zone.units) do
      for idx = #units, 1, -1 do
        local unit = units[idx]
        if not self.Ephemeral or unit.ephemeral then
          table.remove(units, idx)
          DoneObject(unit)
        end
      end
    end
  end)
end
DefineClass.UnitsKickAmbientLife = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "AL_Group",
      name = "AL Group",
      help = "Target unit for match.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetALMarkerGroups()
      end
    }
  },
  EditorView = Untranslated("Kicks Ambient Life <AL_Group> group from Their Markers"),
  Documentation = "Forces all units in ambient life behavior visiting specific group cancel their visit behavior",
  EditorNestedObjCategory = "Units"
}
function UnitsKickAmbientLife:__exec(obj, context)
  for _, unit in ipairs(g_Units) do
    if IsVisitingUnit(unit) and unit.last_visit:IsInGroup(self.AL_Group) then
      unit:SetBehavior()
      unit:SetCommand("Idle")
      unit.perpetual_marker = false
    end
  end
end
function UnitsKickAmbientLife:GetError()
  if not self.AL_Group then
    return "Choose group of AL markers to kick units from"
  end
end
function UnitsKickAmbientLife:GetUIText(context, template, game)
  local merc = gv_UnitData and gv_UnitData[self.Merc]
  local name
  if not merc then
    name = game and "" or Untranslated("[MercName]")
  else
    name = merc.Nick or merc.Name
  end
  return T({
    246469241790,
    "Recruit merc (<em><name></em>)",
    name = name
  })
end
DefineClass.UnitsKickFromPerpetualMarkers = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Ephemeral",
      name = "Ephemeral Only",
      help = "All ambient life units or just ephemeral ones.",
      editor = "bool",
      default = true
    }
  },
  EditorView = Untranslated("Kick Units from Perpetual Markers"),
  Documentation = "Kicks all Ambient Life units which are in perpetual markers"
}
function UnitsKickFromPerpetualMarkers:__exec(obj, context)
  for _, unit in ipairs(g_Units) do
    if (not self.Ephemeral or unit.ephemeral) and unit.perpetual_marker then
      unit:SetBehavior()
      unit:SetCommand("Idle")
      unit.perpetual_marker = false
    end
  end
end
DefineClass.UnitsStealForPerpetualMarkers = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  EditorView = Untranslated("Steal Units for Perpetual Markers"),
  Documentation = "Steal units for perpetual markers as if the Ambient Life is respawn"
}
function UnitsStealForPerpetualMarkers:__exec(obj, context)
  AmbientLifePerpetualMarkersSteal()
end
DefineClass.UpdateInteractablesHighlight = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  Documentation = "Disable interaction markers of a specific group.",
  EditorNestedObjCategory = "Interactable"
}
function UpdateInteractablesHighlight:__exec(obj, context)
  if CurrentMap == "" or IsChangingMap() then
    return
  end
  if not g_Units then
    return
  end
  local ui_units = {}
  for _, unit in ipairs(g_Units) do
    if IsValid(unit) and not unit:IsDead() and unit.team and unit.team.control == "UI" then
      table.insert(ui_units, unit)
    end
  end
  if #ui_units == 0 then
    return
  end
  MapForEach("map", "Interactable", function(interactable)
    if not IsValid(interactable) then
      return
    end
    for _, unit in ipairs(ui_units) do
      if not UICanInteractWith(unit, interactable) then
        interactable:HighlightIntensely(false, "unit-nearby")
      end
    end
    if not IsKindOf(interactable, "ContainerMarker") or not interactable:IsMarkerEnabled() then
      interactable:HighlightIntensely(false, "cursor")
      interactable:HighlightIntensely(false, "unit-nearby")
    end
  end)
end
function UpdateInteractablesHighlight:GetEditorView()
  return T(680362306074, "Forces update of all highlighted interactables")
end
DefineClass.WaitNpcIdle = {
  __parents = {"Effect", "UnitTarget"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "TargetUnit",
      name = "NPC Name",
      help = "The name of the NPC to associate.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetUnitGroups()
      end
    }
  },
  EditorView = Untranslated("Wait for the NPC to become idle"),
  Documentation = "Wait for the NPC to become idle (requires sequential execution)",
  EditorNestedObjCategory = "Units"
}
function WaitNpcIdle:__exec(obj, context)
end
function WaitNpcIdle:__waitexec(obj, context)
  local ctx = {}
  local units = self:MatchMapUnits(obj, ctx)
  local firstUnit = units and ctx.target_units
  firstUnit = firstUnit and firstUnit[1]
  if firstUnit then
    WaitIdle(firstUnit)
  end
end
function WaitNpcIdle:GetError()
  if not self.TargetUnit then
    return "No target unit"
  end
end
