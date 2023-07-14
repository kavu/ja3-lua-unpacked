DefineClass.AND = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Conditions",
      name = "Conditions",
      help = "Conditions to evaluate.",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    }
  },
  Documentation = "Evaluates nested conditions in order, evaluating to true if all of them evaluates to true."
}
function AND:__eval(obj, context)
  local conditions = self.Conditions
  if not conditions then
    return true
  end
  local res = true
  for _, cond in ipairs(conditions) do
    if not cond:Evaluate(obj, context) then
      return false
    end
  end
  return res
end
function AND:GetEditorView()
  local conditions = self.Conditions
  if not conditions then
    return Untranslated(" AND ")
  end
  local txt = {}
  for _, cond in ipairs(conditions) do
    txt[#txt + 1] = Untranslated("( " .. _InternalTranslate(cond:GetEditorView(), cond) .. " )")
  end
  return table.concat(txt, Untranslated(" AND "))
end
function AND:GetUIText(context, template, game)
  local texts = {}
  for _, cond in ipairs(self.Conditions) do
    local text = cond:HasMember("GetUIText") and cond:GetUIText(context, template, game)
    if text and text ~= "" then
      texts[#texts + 1] = text
    end
  end
  local count = #texts
  if count < 1 then
    return
  end
  if count == 1 then
    return texts[1]
  end
  return table.concat(texts, "\n")
end
function AND:GetPhraseTopRolloverText(negative, template, game)
  local texts = {}
  for _, cond in ipairs(self.Conditions) do
    local text = cond:HasMember("GetPhraseTopRolloverText") and cond:GetPhraseTopRolloverText(negative, template, game)
    if text and text ~= "" then
      texts[#texts + 1] = text
    end
  end
  local count = #texts
  if count < 1 then
    return
  end
  if count == 1 then
    return texts[1]
  end
  return table.concat(texts, "\n")
end
function AND:GetPhraseFX()
  for _, cond in ipairs(self.Conditions) do
    local fx = cond:HasMember("GetPhraseFX") and cond:GetPhraseFX()
    if fx then
      return fx
    end
  end
end
DefineClass.BanterHasPlayed = {
  __parents = {
    "Condition",
    "BanterFunctionObjectBase"
  },
  __generated_by_class = "ConditionDef",
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
      id = "WaitOver",
      name = "And Over",
      help = "If any of the specified banters are still playing, they will be considered unplayed.",
      editor = "bool",
      default = false
    },
    {
      id = "Negate",
      editor = "bool",
      default = false
    }
  },
  Documentation = "Check if a banter has played, ever"
}
function BanterHasPlayed:GetEditorView()
  if not self.Negate then
    return Untranslated("If any of banter(s) played: ") .. Untranslated(table.concat(self.Banters, ", "))
  else
    return Untranslated("None of banter(s) have played: ") .. Untranslated(table.concat(self.Banters, ", "))
  end
end
function BanterHasPlayed:__eval(obj, context)
  local hasPlayed = false
  for i, banter in ipairs(self.Banters) do
    if not not g_BanterCooldowns[banter] then
      hasPlayed = banter
      break
    end
  end
  if self.WaitOver and hasPlayed then
    for i, bantPlaying in ipairs(g_ActiveBanters) do
      if bantPlaying.preset.id == hasPlayed then
        hasPlayed = false
        break
      end
    end
  end
  return hasPlayed
end
DefineClass.BanterIsPlaying = {
  __parents = {
    "Condition",
    "BanterFunctionObjectBase"
  },
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Banters",
      name = "Banters",
      help = "List of banters to check.",
      editor = "preset_id_list",
      default = {},
      preset_class = "BanterDef",
      item_default = ""
    },
    {
      id = "Negate",
      editor = "bool",
      default = false
    }
  },
  Documentation = "Check if a banter is currently playing. Useful for repeatable effects. For one time effects use BanterHasPlayed."
}
function BanterIsPlaying:GetEditorView()
  if not self.Negate then
    return Untranslated("If any of banter(s) are currently playing: ") .. Untranslated(table.concat(self.Banters, ", "))
  else
    return Untranslated("None of banter(s) are currently playing: ") .. Untranslated(table.concat(self.Banters, ", "))
  end
end
function BanterIsPlaying:__eval(obj, context)
  local isPlaying = false
  for _, bantPlaying in ipairs(g_ActiveBanters) do
    local idx = table.find(self.Banters, bantPlaying.preset.id)
    if idx then
      isPlaying = true
      break
    end
  end
  return isPlaying
end
DefineClass.CheckIsPersistentUnitDead = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "per_ses_id",
      name = "per_ses_id",
      editor = "combo",
      default = false,
      items = function(self)
        return GetPersistentSessionIds()
      end
    },
    {
      id = "Negate",
      name = "Negate",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("Is unit with persistent id <u(per_ses_id)> dead"),
  Documentation = "Checks if a unit with a given persistent id is dead",
  EditorViewNeg = Untranslated("Unit with persistent id <u(per_ses_id)> is NOT dead")
}
function CheckIsPersistentUnitDead:__eval(obj, context)
  local unitList = g_PersistentUnitData and g_PersistentUnitData[self.per_ses_id]
  if not unitList then
    return false
  end
  for i, u in ipairs(unitList) do
    if u:IsDead() then
      return true
    end
  end
  return false
end
DefineClass.CheckSatelliteTimeRange = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "StartPoint",
      editor = "combo",
      default = "FromCampaignStart",
      items = function(self)
        return {
          "FromCampaignStart",
          "WithinDay"
        }
      end
    },
    {
      id = "TimeMinH",
      name = "Min Time",
      help = "in hours",
      editor = "number",
      default = 0
    },
    {
      id = "TimeMaxH",
      name = "Max Time",
      help = "in hours",
      editor = "number",
      default = 1,
      min = 1
    }
  },
  EditorView = Untranslated("Checks if current satellite time is between two values [<u(TimeMinH)> , <u(TimeMaxH)>) expressed in hours <u(StartPoint)>."),
  Documentation = "Checks if the game time matches an interval."
}
function CheckSatelliteTimeRange:__eval(obj, context)
  if not Game.CampaignTimeStart then
    return false
  end
  local min, max = self.TimeMinH, self.TimeMaxH
  local onStartPassedHours = GetTimeAsTable(Game.CampaignTimeStart).hour
  local passedHoursFromStart = (Game.CampaignTime - Game.CampaignTimeStart) / const.Scale.h
  local passedHours = onStartPassedHours + passedHoursFromStart
  if self.StartPoint == "FromCampaignStart" then
    return min <= passedHours and max > passedHours
  elseif self.StartPoint == "WithinDay" then
    local passedHoursPerDay = passedHours % 24
    return min <= passedHoursPerDay and max > passedHoursPerDay
  end
end
function CheckSatelliteTimeRange:GetError()
  if not self.TimeMinH and not self.TimeMaxH then
    return "No time restriction specified"
  end
  if not self.StartPoint then
    return "No Start Point specified"
  end
end
DefineClass.CityHasLoyalty = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "City",
      help = "Check loyalty of the specified city.",
      editor = "choice",
      default = false,
      items = function(self)
        return table.map(GetCurrentCampaignPreset().Cities, "Id")
      end
    },
    {
      id = "Condition",
      help = "The comparison to perform.",
      editor = "choice",
      default = false,
      items = function(self)
        return {
          ">=",
          "<=",
          ">",
          "<",
          "==",
          "~="
        }
      end
    },
    {
      id = "Amount",
      help = "Compare loyalty to this value.",
      editor = "number",
      default = false
    }
  },
  EditorView = Untranslated("if city <u(City)> loyalty is <u(Condition)><Amount>"),
  Documentation = "Checks the loyalty of a specific city"
}
function CityHasLoyalty:__eval(obj, context)
  local loyalty = GetCityLoyalty(self.City)
  return self:CompareOp(loyalty, context)
end
function CityHasLoyalty:GetError()
  if not self.Condition then
    return "Missing Condition"
  elseif not self.Amount then
    return "Missing Amount"
  elseif not self.City then
    return "Missing City"
  end
end
function CityHasLoyalty:GetUIText(context, template, game)
  local cityname = ""
  cityname = gv_Cities and self.City and gv_Cities[self.City] and gv_Cities[self.City].DisplayName or not game and Untranslated("[CityName]") or ""
  if self.Condition == "<" or self.Condition == "<=" then
    return T({
      834231644194,
      "Low Loyalty with <em><city_name></em>",
      city_name = cityname or ""
    })
  elseif self.Condition == ">" or self.Condition == ">=" or self.Condition == "==" then
    return T({
      595954628454,
      "High Loyalty with <em><city_name></em>",
      city_name = cityname or ""
    })
  end
end
DefineClass.CiviliansKilled = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      id = "Condition",
      name = "condition",
      help = "Select the relation to the specified value.",
      editor = "combo",
      default = ">=",
      items = function(self)
        return {
          ">=",
          "<=",
          ">",
          "<",
          "==",
          "~="
        }
      end
    },
    {
      id = "Amount",
      name = "Amount",
      help = "Set the value to check against.",
      editor = "number",
      default = 0,
      min = 0
    }
  },
  EditorView = Untranslated("If the player has killed <u(Condition)> <u(Amount)> civilians."),
  EditorViewNeg = Untranslated("If the player has NOT killed <u(Condition)> <u(Amount)> civilians."),
  Documentation = "Checks the amount of civilians the player has killed."
}
function CiviliansKilled:__eval(obj, context)
  return self:CompareOp(gv_CiviliansKilled, context)
end
function CiviliansKilled:GetError()
  if not self.Amount then
    return "Specify the param amount"
  end
end
DefineClass.CombatIsActive = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("if combat in progress"),
  EditorViewNeg = Untranslated("if no combat in progress"),
  Documentation = "Checks for an active combat (turn-based mode)."
}
function CombatIsActive:__eval(obj, context)
  return g_Combat
end
DefineClass.CombatTurn = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Condition",
      name = "Condition",
      editor = "choice",
      default = "==",
      items = function(self)
        return {
          ">=",
          "<=",
          ">",
          "<",
          "==",
          "~="
        }
      end
    },
    {
      id = "Amount",
      editor = "number",
      default = 0
    }
  },
  EditorView = Untranslated("Combat Turn <Condition> <Amount>"),
  Documentation = "Checks the current turn in combat"
}
function CombatTurn:__eval(obj, context)
  if not g_Combat then
    return false
  end
  return self:CompareOp(g_Combat.current_turn, context)
end
DefineClass.EmailIsRead = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      editor = "bool",
      default = false
    },
    {
      id = "emailId",
      name = "Email Id",
      editor = "preset_id",
      default = false,
      preset_class = "Email"
    }
  },
  EditorView = Untranslated("If <u(emailId)> email is read."),
  EditorViewNeg = Untranslated("If <u(emailId)> email is NOT read."),
  Documentation = "Check if an Email is read.",
  EditorNestedObjCategory = ""
}
function EmailIsRead:__eval(obj, context)
  local emailReceived = gv_ReceivedEmails[self.emailId]
  return emailReceived and GetReceivedEmail(self.emailId).read
end
function EmailIsRead:GetError()
  if not self.emailId then
    return "Specify an Email"
  end
end
DefineClass.EnemySquadInSector = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
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
  EditorView = Untranslated("An enemy squad is in <u(sector_id)> sector"),
  EditorViewNeg = Untranslated("No enemy squad is in <u(sector_id)> sector"),
  Documentation = "Checks if any type of enemy squad is in control of a given sector (meaning enemy control - no conflict and there's an enemy squad in that sector)",
  EditorNestedObjCategory = "Sectors"
}
function EnemySquadInSector:__eval(obj, context)
  local sector_id = self.sector_id
  return gv_Sectors[sector_id] and not gv_Sectors[sector_id].conflict and #GetSectorSquadsFromSide(sector_id, "enemy1", "enemy2") > 0
end
DefineClass.EvalForEachUnitInSector = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Sector",
      help = "Game sector to test.",
      editor = "combo",
      default = "A1",
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    },
    {
      id = "Negate",
      editor = "bool",
      default = false
    },
    {
      id = "CheckFor",
      name = "Valid for units",
      help = "Conditions are true for 'all' or 'any' of mercs in that sector.",
      editor = "combo",
      default = "any",
      items = function(self)
        return {"all", "any"}
      end
    },
    {
      id = "Conditions",
      name = "Conditions",
      help = "Conditions to evaluate.",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    }
  },
  Documentation = "For each unit in each squad in the given secetor evaluates  nested conditions in order( evaluating to true if all of them evaluates to true).Target unit conditions must be with TargetUnit = \"current unit\"",
  EditorView = Untranslated("if for <u(CheckFor)> units from sector '<u(Sector)>' all conditions are true."),
  EditorViewNeg = Untranslated("if for <u(CheckFor)> units from sector '<u(Sector)>' at least one condition is false."),
  EditorNestedObjCategory = "Sectors"
}
function EvalForEachUnitInSector:__eval(obj, context)
  local conditions = self.Conditions
  if not conditions then
    return true
  end
  context = context or {}
  context.is_sector_unit = true
  local squads = GetSquadsInSector(self.Sector)
  for i, squad in ipairs(squads) do
    for j, unit_id in ipairs(squad.units or empty_table) do
      local res = true
      local unit = gv_UnitData[unit_id]
      context.target_units = {unit}
      for _, cond in ipairs(conditions) do
        res = res and cond:Evaluate(unit, context)
        if not res then
          break
        end
      end
      if not res and self.CheckFor == "all" then
        context.is_sector_unit = false
        return false
      end
      if res and self.CheckFor == "any" then
        context.is_sector_unit = false
        return true
      end
    end
  end
  context.is_sector_unit = false
  return self.CheckFor == "all"
end
DefineClass.GroupIsDead = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      id = "Group",
      name = "Group",
      editor = "combo",
      default = "false",
      items = function(self)
        return GetUnitGroups()
      end
    },
    {
      id = "Mode",
      editor = "choice",
      default = "all",
      items = function(self)
        return {"all", "any"}
      end
    }
  },
  EditorView = Untranslated("If <u(Mode)> from <u(Group)> are dead."),
  EditorViewNeg = Untranslated("if not <u(Mode)> from <u(Group)> are dead"),
  Documentation = "Checks if there are dead units from the group on the map",
  EditorNestedObjCategory = "Units"
}
function GroupIsDead:__eval(obj, context)
  local deadGroups = DeadGroupsInSectors[gv_CurrentSectorId]
  local gameVarResult = deadGroups and deadGroups[self.Group]
  if gameVarResult then
    if self.Mode == "any" then
      return gameVarResult == "any" or gameVarResult == "all"
    elseif self.Mode == "all" then
      return gameVarResult == "all"
    end
  end
  local mapVarResult
  local dead, alive = 0, 0
  for _, obj in ipairs(Groups[self.Group]) do
    if IsKindOf(obj, "Unit") then
      if obj:IsDead() then
        dead = dead + 1
      else
        alive = alive + 1
      end
    end
  end
  if 0 < dead then
    if 0 < alive then
      mapVarResult = "any"
    else
      mapVarResult = "all"
    end
  end
  if mapVarResult then
    if self.Mode == "any" then
      return mapVarResult == "any" or mapVarResult == "all"
    elseif self.Mode == "all" then
      return mapVarResult == "all"
    end
  end
  return false
end
DefineClass.GuardpostObjectiveDone = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "GuardpostObjective",
      name = "GuardpostObjective",
      editor = "preset_id",
      default = false,
      preset_class = "GuardpostObjective"
    },
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("If guardpost objective <u(GuardpostObjective)> is completed"),
  EditorViewNeg = Untranslated("If guardpost objective <u(GuardpostObjective)> is NOT completed"),
  Documentation = "Checks if a guardpost objective has been completed.",
  EditorNestedObjCategory = "Sectors"
}
function GuardpostObjectiveDone:__eval(obj, context)
  return IsGuardpostObjectiveDone(self.GuardpostObjective)
end
DefineClass.InteractingMercHasItem = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
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
    }
  },
  EditorView = Untranslated("If the merc interacting with this has an item of class <u(ItemId)>"),
  EditorViewNeg = Untranslated("If the merc interacting with this doesn't have an item of class <u(ItemId)>"),
  Documentation = "If the merc interacting with an interactable has an item of a specific class"
}
function InteractingMercHasItem:__eval(obj, context)
  local unit = context and context.target_units
  unit = unit and unit[1]
  if not unit then
    return false
  end
  local has = false
  if self.Equipped then
    has = unit:GetItemInSlot("Handheld A", self.ItemId) or unit:GetItemInSlot("Handheld B", self.ItemId)
  else
    has = unit:GetItemInSlot("Inventory", self.ItemId)
  end
  return has
end
function InteractingMercHasItem:GetError()
  if not self.ItemId then
    return "Set Item!"
  end
end
DefineClass.IsDayOfTheWeek = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "WDay",
      name = "Day of the Week",
      editor = "number",
      default = 1,
      min = 1,
      max = 7
    },
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("Current day is <day_name_number(WDay)>"),
  EditorViewNeg = Untranslated("Current day is not <day_name_number(WDay)>"),
  Documentation = "Used to check which day of the week the current day is (1 - Monday etc)",
  EditorNestedObjCategory = "Sectors"
}
function IsDayOfTheWeek:__eval(obj, context)
  local actualDay
  if self.WDay and self.WDay == 7 then
    actualDay = 1
  elseif self.WDay then
    actualDay = self.WDay + 1
  end
  return GetTimeAsTable(Game.CampaignTime).wday == actualDay
end
DefineClass.IsSectorOperationStarted = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      id = "sector_id",
      name = "Sector Id",
      help = "Sector id",
      editor = "combo",
      default = "current",
      items = function(self)
        return table.iappend({
          {text = "current", value = "current"}
        }, GetCampaignSectorsCombo())
      end
    },
    {
      id = "operation",
      name = "Operation",
      help = "Operation to check",
      editor = "combo",
      default = false,
      items = function(self)
        return table.keys(SectorOperations)
      end
    }
  },
  EditorView = Untranslated("if <u(sector_id)> sector has Operation <u(operation)> in progress"),
  EditorViewNeg = Untranslated("if <u(sector_id)> sector does not have Operation <u(operation)> in progress"),
  Documentation = "Checks if the specified operation is being perfomed by a merc in the sector",
  EditorNestedObjCategory = "Sectors"
}
function IsSectorOperationStarted:__eval(obj, context)
  local sector_id = self.sector_id == "current" and gv_CurrentSectorId or self.sector_id
  local mercs = GetPlayerSectorUnits(sector_id)
  for _, merc in ipairs(mercs) do
    if merc.Operation == self.operation then
      return true
    end
  end
  return false
end
function IsSectorOperationStarted:GetError()
  if not self.operation then
    return "Specify operation!"
  end
end
DefineClass.IsTimeOfDay = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "TimeOfDay",
      editor = "combo",
      default = "Day",
      items = function(self)
        return {
          "Day",
          "Night",
          "Sunrise",
          "Sunset"
        }
      end
    },
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("Time of day is <u(TimeOfDay)>"),
  EditorViewNeg = Untranslated("Time of day is not <u(TimeOfDay)>"),
  Documentation = "Used to check the time of day.",
  EditorNestedObjCategory = "Sectors"
}
function IsTimeOfDay:__eval(obj, context)
  local timeOfDay = CalculateTimeOfDay(Game.CampaignTime)
  return timeOfDay == self.TimeOfDay
end
DefineClass.ItemIsFound = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      id = "Sector",
      name = "Sector Id",
      help = "Sector id",
      editor = "combo",
      default = "current",
      items = function(self)
        return table.iappend({
          {text = "current", value = "current"},
          {
            text = "all sectors",
            value = "all_sectors"
          }
        }, GetCampaignSectorsCombo())
      end
    },
    {
      id = "ItemId",
      name = "Item",
      help = "Item id that is looked for.",
      editor = "preset_id",
      default = false,
      preset_class = "InventoryItemCompositeDef"
    },
    {
      id = "Amount",
      name = "Amount",
      help = "Amount of that item.",
      editor = "number",
      default = 1,
      min = 1
    }
  },
  EditorView = Untranslated("if any merc or opened container in <u(Sector)> sector  has <u(ItemId)>(<Amount>) "),
  EditorViewNeg = Untranslated("if any merc or opened container in <u(Sector)> sector haven't <u(ItemId)>(<Amount>) "),
  Documentation = "if the item is in any merc or opened container in that sector"
}
function ItemIsFound:__eval(obj, context)
  local sector_id = self.Sector
  if self.Sector == "current" then
    sector_id = gv_CurrentSectorId
  end
  local squads = self.Sector == "all_sectors" and GetPlayerMercSquads() or GetSquadsInSector(sector_id)
  local amount = {count = 0}
  local squads = GetSquadsInSector(sector_id)
  for i, squad in ipairs(squads) do
    for j, unit_id in ipairs(squad.units or empty_table) do
      local unit = gv_UnitData[unit_id]
      unit:ForEachItemDef(self.ItemId, function(item, slot, amount, self_Amount)
        amount.count = amount.count + (IsKindOf(item, "InventoryStack") and item.Amount or 1)
        if self_Amount <= amount.count then
          return "break"
        end
      end, amount, self.Amount)
      if amount.count >= self.Amount then
        return true
      end
    end
  end
  return SectorContainersHasItem(sector_id, self.ItemId, amount.count)
end
function ItemIsFound:GetError()
  if not self.ItemId then
    return "Set Item!"
  end
end
DefineClass.ItemIsInMerc = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      id = "Sector",
      name = "Sector Id",
      help = "Sector id.",
      editor = "combo",
      default = "current",
      items = function(self)
        return table.iappend({
          {text = "current", value = "current"},
          {
            text = "all sectors",
            value = "all_sectors"
          }
        }, GetCampaignSectorsCombo())
      end
    },
    {
      id = "ItemId",
      name = "Item",
      help = "Item id that is looked for.",
      editor = "preset_id",
      default = false,
      preset_class = "InventoryItemCompositeDef"
    },
    {
      id = "Amount",
      name = "Amount",
      help = "Amount of that item.",
      editor = "number",
      default = 1,
      min = 1
    }
  },
  EditorView = Untranslated("if any merc in <u(Sector)> sector  has <u(ItemId)>(<Amount>) "),
  EditorViewNeg = Untranslated("if any merc  in <u(Sector)> sector haven't <u(ItemId)>(<Amount>) "),
  Documentation = "if the item is in any merc in that sector"
}
function ItemIsInMerc:__eval(obj, context)
  local sector_id = self.Sector
  if self.Sector == "current" then
    sector_id = gv_CurrentSectorId
  end
  local squads = self.Sector == "all_sectors" and GetPlayerMercSquads() or GetSquadsInSector(sector_id)
  local amount = {count = 0}
  for i, squad in ipairs(squads) do
    for j, unit_id in ipairs(squad.units or empty_table) do
      local unit = gv_UnitData[unit_id]
      unit:ForEachItemDef(self.ItemId, function(item, slot, amount, self_Amount)
        amount.count = amount.count + (IsKindOf(item, "InventoryStack") and item.Amount or 1)
        if self_Amount <= amount.count then
          return "break"
        end
      end, amount, self.Amount)
      if amount.count >= self.Amount then
        return true
      end
    end
  end
end
function ItemIsInMerc:GetError()
  if not self.ItemId then
    return "Set Item!"
  end
end
DefineClass.MercChatConditionCombatParticipate = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Days",
      name = "Days",
      editor = "number",
      default = 14,
      no_edit = true
    },
    {
      id = "PresetValue",
      name = "PresetValue",
      editor = "choice",
      default = "<=3",
      items = function(self)
        return {
          {name = "low (<=3)", value = "<=3"},
          {
            name = "high (>=10)",
            value = ">=10"
          }
        }
      end
    }
  },
  RequiredObjClasses = {
    "MercChatBranch",
    "UnitData"
  },
  EditorView = Untranslated("If merc fought in <u(PresetValue)> conflicts in the past <Days> days."),
  Documentation = "Checks if the merc participated in a conflict in the last X days.",
  EditorNestedObjCategory = "Merc Chat"
}
function MercChatConditionCombatParticipate:__eval(obj, context)
  local mercId = obj.session_id
  local conflicts = GetMercConflictsParticipatedWithinLastDays(mercId, self.Days, "unique")
  if self.PresetValue == "<=3" then
    return conflicts <= 3
  elseif self.PresetValue == "=>10" then
    return 10 <= conflicts
  end
end
DefineClass.MercChatConditionDeathToll = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Days",
      name = "Days",
      editor = "number",
      default = 14,
      no_edit = true
    },
    {
      id = "PresetValue",
      name = "PresetValue",
      editor = "choice",
      default = "0",
      items = function(self)
        return {
          {name = "good (0)", value = "0"},
          {
            name = "moderate (1)",
            value = "1"
          },
          {name = "high (2+)", value = "2+"}
        }
      end
    }
  },
  RequiredObjClasses = {
    "MercChatBranch"
  },
  EditorView = Untranslated("If <u(PresetValue)> dead mercs in last <Days> days."),
  Documentation = "",
  EditorNestedObjCategory = "Merc Chat"
}
function MercChatConditionDeathToll:__eval(obj, context)
  local timeNow = Game and Game.CampaignTime or 0
  local deadMercs = 0
  local lastDaysInMs = self.Days * const.Scale.day
  for i, mId in ipairs(Mercenaries) do
    local ud = gv_UnitData and gv_UnitData[mId]
    if ud and ud.HireStatus == "Dead" then
      local deathTime = ud.HiredUntil
      if lastDaysInMs > timeNow - deathTime then
        deadMercs = deadMercs + 1
      end
    end
  end
  local deadMercsCond = self.PresetValue
  if deadMercsCond == "2+" then
    return 2 <= deadMercs
  else
    deadMercsCond = tonumber(deadMercsCond) or 0
    return deadMercs == deadMercsCond
  end
end
DefineClass.MercChatConditionLateRenew = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  RequiredObjClasses = {
    "MercChatBranch",
    "UnitData"
  },
  EditorView = Untranslated("If player is trying to renew contract when less than a day is left."),
  Documentation = "",
  EditorNestedObjCategory = "Merc Chat"
}
function MercChatConditionLateRenew:__eval(obj, context)
  if obj.HireStatus ~= "Hired" then
    return false
  end
  local contractLeft = obj.HiredUntil - Game.CampaignTime
  return contractLeft < const.Scale.day
end
DefineClass.MercChatConditionMoney = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "PresetValue",
      name = "PresetValue",
      editor = "choice",
      default = "<=10",
      items = function(self)
        return {
          {
            name = "low (<=10k)",
            value = "<=10"
          },
          {
            name = "high (>=50k)",
            value = ">=50"
          }
        }
      end
    }
  },
  RequiredObjClasses = {
    "MercChatBranch",
    "UnitData"
  },
  EditorView = Untranslated("If player has <u(PresetValue)> money."),
  Documentation = "",
  EditorNestedObjCategory = "Merc Chat"
}
function MercChatConditionMoney:__eval(obj, context)
  local money = Game.Money
  if self.PresetValue == "<=10" then
    return money <= 10000
  elseif self.PresetValue == ">=50" then
    return 50000 <= money
  end
end
DefineClass.MercChatConditionRehire = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "PresetValue",
      name = "PresetValue",
      editor = "choice",
      default = "0",
      items = function(self)
        return {
          {name = "none", value = "0"},
          {name = "low (1-2)", value = "1-2"},
          {name = "high (5+)", value = "5+"}
        }
      end
    }
  },
  RequiredObjClasses = {
    "MercChatBranch",
    "UnitData"
  },
  EditorView = Untranslated("If player has <u(PresetValue)> contracts/extensions with the merc."),
  Documentation = "",
  EditorNestedObjCategory = "Merc Chat"
}
function MercChatConditionRehire:__eval(obj, context)
  local mercId = obj.session_id
  local contracts = GetMercStateFlag(mercId, "HireCount") or 0
  if self.PresetValue == "0" and contracts == 0 then
    return true
  end
  if self.PresetValue == "1-2" and 1 <= contracts and contracts <= 2 then
    return true
  end
  if self.PresetValue == "5+" and 5 <= contracts then
    return true
  end
  return false
end
DefineClass.MercChatConditionWhim = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Days",
      name = "Days",
      editor = "number",
      default = 1,
      no_edit = true
    },
    {
      id = "PresetValue",
      name = "PresetValue",
      editor = "choice",
      default = 20,
      items = function(self)
        return {
          {
            name = "normal (20%)",
            value = 20
          },
          {name = "low (10%)", value = 10},
          {name = "high (50%)", value = 50}
        }
      end
    }
  },
  RequiredObjClasses = {
    "MercChatBranch",
    "UnitData"
  },
  EditorView = Untranslated("If <u(PresetValue)>% chance. Rerolled once every <Days> days per merc."),
  Documentation = "",
  EditorNestedObjCategory = "Merc Chat"
}
function MercChatConditionWhim:__eval(obj, context)
  local mercId = obj.session_id
  local dayHash = xxhash(mercId, Game.CampaignTime / const.Scale.day / self.Days, Game.id)
  local roll = 1 + BraidRandom(dayHash, 100)
  CombatLog("debug", "MercChatWhim rolled " .. roll)
  return roll < self.PresetValue
end
DefineClass.MercIsLikedDisliked = {
  __parents = {"Condition", "UnitTarget"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      id = "Relation",
      name = "Relation",
      help = "Choose to search in Likes or Dislikes",
      editor = "combo",
      default = "Likes",
      items = function(self)
        return {"Likes", "Dislikes"}
      end
    },
    {
      id = "Object",
      name = "Object",
      editor = "combo",
      default = false,
      items = function(self)
        return MercPresetCombo()
      end
    }
  },
  Documentation = "Checks if a specific merc has another one in his Likes/Dislikes tables."
}
function MercIsLikedDisliked:__eval(obj, context)
  local subject = self.TargetUnit
  local relation = self.Relation
  local object = self.Object
  if relation == "Likes" then
    if table.find(gv_UnitData[subject].Likes, object) then
      return true
    end
  elseif relation == "Dislikes" and table.find(gv_UnitData[subject].Dislikes, object) then
    return true
  end
  return false
end
function MercIsLikedDisliked:GetEditorView()
  if self.Negate then
    return T({
      Untranslated("if '<u(TargetUnit)>' NOT '<u(relation)>' '<u(Object)>'."),
      Object = self.Object,
      relation = self.Relation
    })
  else
    return T({
      Untranslated("if '<u(TargetUnit)>'  '<u(relation)>' '<u(Object)>'."),
      Object = self.Object,
      relation = self.Relation
    })
  end
end
function MercIsLikedDisliked:GetError()
  if not self.TargetUnit then
    return "Specify the object"
  end
  if not self.Object then
    return "Specify the subject"
  end
  if not self.Relation then
    return "Specify the relation"
  end
end
DefineClass.OR = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Conditions",
      name = "Conditions",
      help = "Conditions to evaluate.",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    }
  },
  Documentation = "Evaluates nested conditions in order, evaluating to true if one of them evaluates to true."
}
function OR:__eval(obj, context)
  local conditions = self.Conditions
  if not conditions then
    return true
  end
  for _, cond in ipairs(conditions) do
    if cond:Evaluate(obj, context) then
      return true
    end
  end
  return false
end
function OR:GetEditorView()
  local conditions = self.Conditions
  if not conditions then
    return Untranslated(" OR ")
  end
  local txt = {}
  for _, cond in ipairs(conditions) do
    txt[#txt + 1] = Untranslated("( " .. _InternalTranslate(cond:GetEditorView(), cond) .. " )")
  end
  return table.concat(txt, Untranslated(" OR "))
end
function OR:GetUIText(context, template, game)
  local texts = {}
  for _, cond in ipairs(self.Conditions) do
    local text = cond:HasMember("GetUIText") and cond:GetUIText(context, template, game)
    if text and text ~= "" then
      texts[#texts + 1] = text
    end
  end
  local count = #texts
  if count < 1 then
    return
  end
  if count == 1 then
    return texts[1]
  end
  return table.concat(texts, "\n")
end
function OR:GetPhraseTopRolloverText(negative, template, game)
  local texts = {}
  for _, cond in ipairs(self.Conditions) do
    local text = cond:HasMember("GetPhraseTopRolloverText") and cond:GetPhraseTopRolloverText(negative, template, game)
    if text and text ~= "" then
      texts[#texts + 1] = text
    end
  end
  local count = #texts
  if count < 1 then
    return
  end
  if count == 1 then
    return texts[1]
  end
  return texts[AsyncRand(count) + 1]
end
function OR:GetPhraseFX()
  for _, cond in ipairs(self.Conditions) do
    local fx = cond:HasMember("GetPhraseFX") and cond:GetPhraseFX()
    if fx then
      return fx
    end
  end
end
DefineClass.PlayerControlCities = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      category = "General",
      id = "Condition",
      name = "condition",
      help = "Select the relation to player cities count.",
      editor = "combo",
      default = ">",
      items = function(self)
        return {
          ">=",
          "<=",
          ">",
          "<",
          "==",
          "~="
        }
      end
    },
    {
      category = "General",
      id = "Amount",
      name = "Amount",
      help = "Set the value to check against.",
      editor = "number",
      default = 0,
      min = 0
    },
    {
      category = "General",
      id = "CitySectors",
      help = "Count number of sectors that belong to any city rather than unique cities.",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("Player cities <u(Condition)> <Amount>"),
  Documentation = "Checks player cities count",
  EditorNestedObjCategory = "Sectors"
}
function PlayerControlCities:__eval(obj, context)
  local cityCount = GetPlayerCityCount(self.CitySectors)
  return self:CompareOp(cityCount)
end
DefineClass.PlayerControlSectors = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "POIs",
      name = "Required POIs",
      help = "Only sectors which contain the POIs specified will be counted; choose 'all' to count all sectors.",
      editor = "choice",
      default = "all",
      items = function(self)
        return GetSectorPOITypes()
      end
    },
    {
      category = "General",
      id = "Condition",
      name = "condition",
      help = "Select the relation to matching sectors count.",
      editor = "combo",
      default = ">",
      items = function(self)
        return {
          ">=",
          "<=",
          ">",
          "<",
          "==",
          "~="
        }
      end
    },
    {
      category = "General",
      id = "Amount",
      name = "Amount",
      help = "Set the value to check against.",
      editor = "number",
      default = 0,
      min = 0
    }
  },
  Documentation = "Checks player sectors matching the specified POIs count",
  EditorNestedObjCategory = "Sectors"
}
function PlayerControlSectors:GetEditorView()
  if self.POIs == "all" then
    return Untranslated("Player sectors <u(Condition)> <Amount>")
  else
    return Untranslated(string.format("Player sectors with %s =<u(Condition)> <Amount>", self.POIs))
  end
end
function PlayerControlSectors:__eval(obj, context)
  return self:CompareOp(gv_PlayerSectorCounts[self.POIs] or 0)
end
DefineClass.PlayerHasALowHealthMerc = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      category = "General",
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("Player has a merc that is not in full health"),
  EditorViewNeg = Untranslated("All player mercs are at full health"),
  Documentation = "Checks if the player has at least one merc that is not on full health"
}
function PlayerHasALowHealthMerc:__eval(obj, context)
  if gv_SatelliteView then
    for _, squad in ipairs(g_SquadsArray) do
      if squad.Side == "player1" then
        for i, u in ipairs(squad.units or empty_table) do
          if gv_UnitData[u] and gv_UnitData[u].HitPoints < gv_UnitData[u].MaxHitPoints then
            return true
          end
        end
      end
    end
  else
    for _, u in ipairs(g_Units) do
      local squad = u:GetSatelliteSquad()
      if squad and squad.Side == "player1" and u.HitPoints < u.MaxHitPoints then
        return true
      end
    end
  end
  return false
end
DefineClass.PlayerHasAWoundedMerc = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      category = "General",
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("Player has a merc with at least 1 stack of \"Wounded\" character effect"),
  EditorViewNeg = Untranslated("All player mercs are not wounded"),
  Documentation = "Checks if the player has at least one wounded merc"
}
function PlayerHasAWoundedMerc:__eval(obj, context)
  if gv_SatelliteView then
    for _, squad in ipairs(g_SquadsArray) do
      if squad.Side == "player1" then
        for i, u in ipairs(squad.units or empty_table) do
          local unit = gv_UnitData[u]
          local idx = unit:HasStatusEffect("Wounded")
          if idx and unit.StatusEffects[idx].stacks > 0 then
            return true
          end
        end
      end
    end
  else
    for _, unit in ipairs(g_Units) do
      local squad = unit:GetSatelliteSquad()
      if squad and squad.Side == "player1" then
        local idx = unit:HasStatusEffect("Wounded")
        if idx and unit.StatusEffects[idx].stacks > 0 then
          return true
        end
      end
    end
  end
  return false
end
DefineClass.PlayerHasMoney = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      category = "General",
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      category = "General",
      id = "Condition",
      name = "condition",
      help = "Select the relation to the specified value.",
      editor = "combo",
      default = ">=",
      items = function(self)
        return {
          ">=",
          "<=",
          ">",
          "<",
          "==",
          "~="
        }
      end
    },
    {
      category = "General",
      id = "Amount",
      name = "Amount",
      help = "Set the value to check against.",
      editor = "number",
      default = 0,
      min = 0
    }
  },
  EditorView = Untranslated("if player's money <u(Condition)> <money(Amount)>"),
  EditorViewNeg = Untranslated("if player's money are not <u(Condition)> <money(Amount)>"),
  Documentation = "Checks the amount of money that the player has."
}
function PlayerHasMoney:__eval(obj, context)
  return self:CompareOp(Game.Money, context)
end
function PlayerHasMoney:GetUIText(context)
end
function PlayerHasMoney:GetError()
  if not self.Amount then
    return "Specify the param amount"
  end
end
DefineClass.PlayerIsInSectors = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition",
      editor = "bool",
      default = false
    },
    {
      id = "Sectors",
      name = "Sectors",
      help = "Check if the game play is in that sector.",
      editor = "string_list",
      default = {"A1"},
      item_default = "A1",
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    }
  },
  Documentation = "Checks if the game play is in any of sectors."
}
function PlayerIsInSectors:__eval(obj, context)
  return not gv_SatelliteView and gv_CurrentSectorId and table.find(self.Sectors, gv_CurrentSectorId)
end
function PlayerIsInSectors:GetEditorView()
  if self.Negate then
    return T({
      672591083408,
      "if NOT in any of sectors {<u(text)>}",
      text = table.concat(self.Sectors, ", ")
    })
  else
    return T({
      484570727486,
      "if in any of sectors {<u(text)>}",
      text = table.concat(self.Sectors, ", ")
    })
  end
end
DefineClass.PlayerIsInSectorsOfTier = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "UpTo",
      editor = "bool",
      default = true
    },
    {
      id = "MapTier",
      name = "MapTier",
      editor = "number",
      default = 0,
      scale = 10,
      step = 5,
      min = 0,
      max = 50
    }
  },
  Documentation = "Checks if in tactical view on a sector of a specific tier."
}
function PlayerIsInSectorsOfTier:__eval(obj, context)
  if gv_SatelliteView then
    return false
  end
  local sector = gv_Sectors[gv_CurrentSectorId]
  if not sector then
    return false
  end
  local sectorTier = sector.MapTier
  if self.UpTo then
    return sectorTier <= self.MapTier
  end
  return sectorTier == self.MapTier
end
function PlayerIsInSectorsOfTier:GetEditorView()
  if self.UpTo then
    return T({
      Untranslated("if in sector of tier <FormatScale(MapTier, 10)> or lower"),
      self
    })
  else
    return T({
      Untranslated("If in sector of tier <FormatScale(MapTier, 10)>"),
      self
    })
  end
end
DefineClass.PlayerIsPlayerTurn = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      category = "General",
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("if player's turn in combat"),
  EditorViewNeg = Untranslated("if not player's turn in combat"),
  Documentation = "Checks  it is the player's turn in combat"
}
function PlayerIsPlayerTurn:__eval(obj, context)
  return g_Combat and g_Combat.start_reposition_ended and IsNetPlayerTurn()
end
DefineClass.PlayerSquadPresentInSectors = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition",
      editor = "bool",
      default = false
    },
    {
      id = "Sector",
      name = "Sector",
      editor = "combo",
      default = "I1",
      items = function(self)
        return GetCampaignSectorsCombo()
      end
    }
  },
  Documentation = "Checks if the player has a squad in the specified sector"
}
function PlayerSquadPresentInSectors:__eval(obj, context)
  for _, squad in pairs(gv_Squads) do
    if (squad.Side == "player1" or squad.Side == "player2") and squad.CurrentSector == self.Sector then
      return true
    end
  end
end
function PlayerSquadPresentInSectors:GetEditorView()
  if self.Negate then
    return T({
      736317896521,
      "if player has NO squad in sector {<u(text)>}",
      text = self.Sector
    })
  else
    return T({
      572189738813,
      "if player has a squad in sector {<u(text)>}",
      text = self.Sector
    })
  end
end
DefineClass.QuestConditionBase = {
  __parents = {
    "Condition",
    "QuestFunctionObjectBase"
  },
  __generated_by_class = "ClassDef",
  EditorNestedObjCategory = "Quests"
}
function QuestConditionBase:OnAfterEditorNew(obj, socket, paste)
  if not paste then
    local quest_def = GetParentTableOfKindNoCheck(self, "QuestsDef")
    if quest_def then
      self.QuestId = quest_def.id
    end
  end
end
DefineClass.QuestHasTimerPassed = {
  __parents = {
    "QuestConditionBase"
  },
  __generated_by_class = "ConditionDef",
  properties = {
    {
      category = "General",
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      category = "General",
      id = "QuestId",
      name = "Quest id",
      help = "Quest to check.",
      editor = "preset_id",
      default = false,
      preset_class = "QuestsDef",
      preset_filter = function(preset, obj)
        return QuestHasVariable(preset, "QuestVarNum")
      end
    },
    {
      category = "General",
      id = "TimerVariable",
      help = "Quest variable to check.",
      editor = "choice",
      default = false,
      items = function(self)
        return GetQuestsVarsCombo(self.QuestId, "Num")
      end
    }
  },
  EditorViewNeg = Untranslated("if <u(TimerVariable)>:<u(QuestId)> has not passed."),
  EditorView = Untranslated("if <u(TimerVariable)>:<u(QuestId)> has passed."),
  Documentation = "Tests whether a timer set by QuestSetVariableTimer has passed."
}
function QuestHasTimerPassed:__eval(obj, context)
  if #(self.QuestId or "") == 0 or not self.TimerVariable then
    return false
  end
  local quest = QuestGetState(self.QuestId or "")
  local timerVal = rawget(quest, self.TimerVariable)
  if not timerVal or timerVal == 0 then
    return false
  end
  return timerVal < Game.CampaignTime
end
function QuestHasTimerPassed:GetError()
  if not self.QuestId or self.QuestId == "" then
    return "Specify the quest!"
  end
  if not self.TimerVariable then
    return "Specify the variable which holds the timer! Can be set via QuestSetVariableTimer"
  end
end
DefineClass.QuestIsTCEState = {
  __parents = {
    "QuestConditionBase"
  },
  __generated_by_class = "ConditionDef",
  properties = {
    {
      category = "General",
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      category = "General",
      id = "QuestId",
      name = "Quest id",
      help = "Quest to check.",
      editor = "preset_id",
      default = false,
      preset_class = "QuestsDef"
    },
    {
      category = "General",
      id = "Prop",
      name = "Quest Variable",
      help = "Quest TCE to check",
      editor = "choice",
      default = false,
      items = function(self)
        return GetQuestsVarsCombo(self.QuestId, "TCEState")
      end
    },
    {
      category = "General",
      id = "Value",
      name = "Value",
      help = "Possible TCEState values to check for.",
      editor = "choice",
      default = false,
      items = function(self)
        return {
          true,
          false,
          "done"
        }
      end
    }
  },
  Documentation = "Test value of TCEState quest variable"
}
function QuestIsTCEState:__eval(obj, context)
  if not self.QuestId or self.QuestId == "" or not self.Prop then
    return false
  end
  local quest = QuestGetState(self.QuestId or "")
  local val = rawget(quest, self.Prop)
  return val == self.Value
end
function QuestIsTCEState:GetError()
  if not self.QuestId or self.QuestId == "" then
    return "Specify the quest!"
  end
  if not self.Prop then
    return "Specify the TCE state variable to check!"
  end
end
function QuestIsTCEState:GetEditorView()
  local value = self.Value
  if not (value ~= true or self.Negate) or value == false and self.Negate then
    return Untranslated("if <u(Prop)> (<u(QuestId)>)")
  elseif not (value ~= false or self.Negate) or value == true and self.Negate then
    return Untranslated("if not <u(Prop)> (<u(QuestId)>)")
  end
  if self.Negate then
    return Untranslated("if <u(Prop)> ~= done (<u(QuestId)>)")
  else
    return Untranslated("if <u(Prop)> == done (<u(QuestId)>)")
  end
end
DefineClass.QuestIsVariableBool = {
  __parents = {
    "QuestConditionBase"
  },
  __generated_by_class = "ConditionDef",
  properties = {
    {
      category = "General",
      id = "QuestId",
      name = "Quest id",
      help = "Quest to check.",
      editor = "preset_id",
      default = false,
      preset_class = "QuestsDef",
      preset_filter = function(preset, obj)
        return QuestHasVariable(preset, "QuestVarBool")
      end
    },
    {
      category = "General",
      id = "Condition",
      help = "The \"and\" value checks whether all variables have the specified value; \"or\" checks whether any of them has it.",
      editor = "choice",
      default = "and",
      items = function(self)
        return {"and", "or"}
      end
    },
    {
      category = "General",
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
  Documentation = "Test value of bool quest variable"
}
function QuestIsVariableBool:__eval(obj, context)
  if not (self.QuestId and self.QuestId ~= "" and self.Vars) or not next(self.Vars) then
    return false
  end
  local quest = QuestGetState(self.QuestId or "")
  local first_var = next(self.Vars)
  if next(self.Vars, first_var) == nil then
    local value = rawget(quest, first_var)
    if self.Vars[first_var] then
      return not not value
    else
      return not value
    end
  end
  if self.Condition == "and" then
    for var, condition in pairs(self.Vars) do
      local val = rawget(quest, var)
      if condition == true then
        if not val then
          return false
        end
      elseif val then
        return false
      end
    end
    return true
  else
    for var, condition in pairs(self.Vars) do
      local val = rawget(quest, var)
      if condition == true then
        if val then
          return true
        end
      elseif not val then
        return true
      end
    end
    return false
  end
end
function QuestIsVariableBool:GetError()
  if not self.QuestId or self.QuestId == "" then
    return "Specify the quest!"
  end
  if not self.Vars or not next(self.Vars) then
    return "Specify the vars to check!"
  end
  if self.Negate then
    return "Use per-var negation via the Vars property instead of Negate!"
  end
end
function QuestIsVariableBool:GetEditorView()
  if not self.Vars or not next(self.Vars) then
    return Untranslated("(no vars selected to check)")
  end
  local vars = {}
  for var, condition in sorted_pairs(self.Vars) do
    vars[#vars + 1] = condition and var or "not " .. var
  end
  vars = table.concat(vars, " " .. self.Condition .. " ")
  if self.Negate then
    return Untranslated("if not (" .. vars .. ") (<u(QuestId)>)")
  else
    return Untranslated("if " .. vars .. " (<u(QuestId)>)")
  end
end
function QuestIsVariableBool:OnEditorSetProperty(prop_id, old_value, ged)
  if prop_id == "QuestId" then
    self.Vars = nil
  end
end
DefineClass.QuestIsVariableNum = {
  __parents = {
    "QuestConditionBase"
  },
  __generated_by_class = "ConditionDef",
  properties = {
    {
      category = "General",
      id = "QuestId",
      name = "Quest id",
      help = "Quest to check.",
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
      help = "Quest variable to check.",
      editor = "choice",
      default = false,
      items = function(self)
        return GetQuestsVarsCombo(self.QuestId, "Num")
      end
    },
    {
      category = "General",
      id = "Condition",
      name = "condition",
      help = "Select the relation to the specified value.",
      editor = "combo",
      default = ">=",
      items = function(self)
        return {
          ">=",
          "<=",
          ">",
          "<",
          "==",
          "~="
        }
      end
    },
    {
      category = "General",
      id = "AgainstVar",
      name = "Against variable",
      help = "Check to compare with another quest variable.",
      editor = "bool",
      default = false
    },
    {
      category = "General",
      id = "QuestId2",
      name = "Quest id",
      help = "Quest with variable to compare against.",
      editor = "preset_id",
      default = false,
      no_edit = function(self)
        return not self.AgainstVar
      end,
      preset_class = "QuestsDef"
    },
    {
      category = "General",
      id = "Prop2",
      name = "Quest Variable",
      help = "Quest variable to compare against.",
      editor = "choice",
      default = false,
      no_edit = function(self)
        return not self.AgainstVar
      end,
      items = function(self)
        return GetQuestsVarsCombo(self.QuestId2, "Num")
      end
    },
    {
      category = "General",
      id = "Amount",
      name = "Amount",
      help = "Value to check against.",
      editor = "number",
      default = 0,
      no_edit = function(self)
        return self.AgainstVar
      end
    }
  },
  Documentation = "Tests the value of a numeric quest variable"
}
function QuestIsVariableNum:__eval(obj, context)
  if not self.QuestId or self.QuestId == "" or not self.Prop then
    return false
  end
  local quest = QuestGetState(self.QuestId or "")
  local val = rawget(quest, self.Prop)
  local amount = self.Amount
  if self.AgainstVar then
    local quest2 = QuestGetState(self.QuestId2 or "")
    amount = rawget(quest, self.Prop2)
  end
  return val and self:CompareOp(val, context, amount)
end
function QuestIsVariableNum:GetEditorView()
  if not self.AgainstVar then
    return Untranslated("if <u(Prop)> <u(Condition)> <Amount>  (<u(QuestId)>)")
  end
  return Untranslated("if <u(Prop)>(<u(QuestId)>) <u(Condition)> <u(Prop2)>(<u(QuestId2)>) ")
end
function QuestIsVariableNum:GetError()
  if not self.QuestId or self.QuestId == "" then
    return "Specify the quest!"
  end
  if not self.Prop then
    return "Specify the param to check!"
  end
  if not self.Amount then
    return "Specify the param amount"
  end
end
DefineClass.QuestIsVariableText = {
  __parents = {
    "QuestConditionBase"
  },
  __generated_by_class = "ConditionDef",
  properties = {
    {
      category = "General",
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      category = "General",
      id = "QuestId",
      name = "Quest id",
      help = "Quest to check",
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
      help = "Quest variable to check.",
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
      help = "Value to check for.",
      editor = "text",
      default = ""
    }
  },
  EditorView = Untranslated("if <u(Prop)> == '<u(Text)>' (<u(QuestId)>)"),
  EditorViewNeg = Untranslated("if <u(Prop)> ~= '<u(Text)>' (<u(QuestId)>)"),
  Documentation = "Test value of text quest variable"
}
function QuestIsVariableText:__eval(obj, context)
  if not self.QuestId or self.QuestId == "" or not self.Prop then
    return false
  end
  local quest = QuestGetState(self.QuestId or "")
  local val = rawget(quest, self.Prop)
  return val and val == self.Text
end
function QuestIsVariableText:GetError()
  if not self.QuestId or self.QuestId == "" then
    return "Specify the quest!"
  end
  if not self.Prop then
    return "Specify the param to check!"
  end
end
DefineClass.QuestKillTCEsOnCompleted = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  Documentation = "Kill TCEs check is on quest completed."
}
function QuestKillTCEsOnCompleted:__eval(obj, context)
  local quest_def = GetParentTableOfKind(self, "QuestsDef")
  if not quest_def then
    return false
  end
  local quest = QuestGetState(quest_def.id or "")
  return QuestIsBoolVar(quest, "Completed", true)
end
function QuestKillTCEsOnCompleted:GetEditorView()
  return Untranslated("if the quest is  \"completed\"")
end
DefineClass.SatelliteGameplayRunning = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      category = "General",
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("Is satellite gameplay running"),
  EditorViewNeg = Untranslated("Is satellite gameplay not running"),
  Documentation = "Checks if the player is in satellite view and there is no conflict"
}
function SatelliteGameplayRunning:__eval(obj, context)
  return gv_SatelliteView and not IsConflictMode()
end
DefineClass.SectorCheckCity = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
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
    },
    {
      id = "city",
      name = "City",
      help = "Specify city.",
      editor = "combo",
      default = "ErnieVillage",
      items = function(self)
        return table.map(GetCurrentCampaignPreset().Cities, "Id")
      end
    }
  },
  EditorView = Untranslated("if <u(sector_id)> sector is a part of city <u(city)>"),
  EditorViewNeg = Untranslated("if <u(sector_id)> sector is not a part of city <u(city)>"),
  Documentation = "Checks if the current sector is a part of the specified city",
  EditorNestedObjCategory = "Sectors"
}
function SectorCheckCity:__eval(obj, context)
  local sector_id = self.sector_id == "current" and gv_CurrentSectorId or self.sector_id
  return gv_Sectors[sector_id] and gv_Sectors[sector_id].City == self.city
end
DefineClass.SectorCheckOwner = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
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
    },
    {
      id = "owner",
      name = "Owner",
      help = "Specify owner.",
      editor = "combo",
      default = "any player",
      items = function(self)
        return table.iappend({"any player", "any enemy"}, table.map(GetCurrentCampaignPreset().Sides, "Id"))
      end
    }
  },
  EditorView = Untranslated("if <u(sector_id)> sector is controlled by <u(owner)>"),
  EditorViewNeg = Untranslated("if <u(sector_id)> sector is not controlled by <u(owner)>"),
  Documentation = "Checks if the current sector is controlled by defined owner",
  EditorNestedObjCategory = "Sectors"
}
function SectorCheckOwner:__eval(obj, context)
  local sector_id = self.sector_id == "current" and gv_CurrentSectorId or self.sector_id
  if not gv_Sectors[sector_id] or not GetCurrentCampaignPreset() then
    return
  end
  local sector_side = gv_Sectors[sector_id].Side
  if self.owner == "any player" then
    for _, side in ipairs(GetCurrentCampaignPreset().Sides) do
      if side.Player and side.Id == sector_side then
        return true
      end
    end
  elseif self.owner == "any enemy" then
    for _, side in ipairs(GetCurrentCampaignPreset().Sides) do
      if side.Enemy and side.Id == sector_side then
        return true
      end
    end
  end
  return sector_side == self.owner
end
DefineClass.SectorHasDepletedMine = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
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
  EditorView = Untranslated("if <u(sector_id)> sector has a depleted mine"),
  EditorViewNeg = Untranslated("if <u(sector_id)> sector does not have a depleted mine"),
  Documentation = "Checks if the specified sector has a depleted mine",
  EditorNestedObjCategory = "Sectors"
}
function SectorHasDepletedMine:__eval(obj, context)
  local sector_id = self.sector_id == "current" and gv_CurrentSectorId or self.sector_id
  local sector = gv_Sectors[sector_id]
  return sector and sector.Mine and sector.mine_depleted
end
DefineClass.SectorHasHospital = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
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
  EditorView = Untranslated("if <u(sector_id)> sector has a hospital"),
  EditorViewNeg = Untranslated("if <u(sector_id)> sector does not have a hospital"),
  Documentation = "Checks if the specified sector has a hospital",
  EditorNestedObjCategory = "Sectors"
}
function SectorHasHospital:__eval(obj, context)
  local sector_id = self.sector_id == "current" and gv_CurrentSectorId or self.sector_id
  return gv_Sectors[sector_id] and gv_Sectors[sector_id].Hospital
end
DefineClass.SectorHasIntel = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
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
  EditorView = Untranslated("if <u(sector_id)> sector's intel is discovered"),
  EditorViewNeg = Untranslated("if <u(sector_id)> sector's intel isn't discovered"),
  Documentation = "Checks if the current or specified sector has its intel discovered.",
  EditorNestedObjCategory = "Sectors"
}
function SectorHasIntel:__eval(obj, context)
  local sector_id = self.sector_id == "current" and gv_CurrentSectorId or self.sector_id
  return gv_Sectors[sector_id] and gv_Sectors[sector_id].intel_discovered
end
DefineClass.SectorInWarningState = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
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
  EditorView = Untranslated("If <u(sector_id)> sector is currently in a warning state."),
  EditorViewNeg = Untranslated("If <u(sector_id)> sector is NOT currently in a warning state."),
  Documentation = "Checks if the current or specified sector is currently in a warning state.",
  EditorNestedObjCategory = "Sectors"
}
function SectorInWarningState:__eval(obj, context)
  local sector_id = self.sector_id == "current" and gv_CurrentSectorId or self.sector_id
  return gv_Sectors[sector_id] and gv_Sectors[sector_id].inWarningState
end
DefineClass.SectorIsInConflict = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      id = "sector_id",
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
  EditorView = Untranslated("if conflict in <u(sector_id)> sector"),
  EditorViewNeg = Untranslated("if no conflict in <u(sector_id)> sector"),
  Documentation = "Checks if the current sector is currently in conflict",
  EditorNestedObjCategory = "Sectors"
}
function SectorIsInConflict:__eval(obj, context)
  local sector_id = self.sector_id == "current" and gv_CurrentSectorId or self.sector_id
  return gv_Sectors[sector_id] and gv_Sectors[sector_id].conflict
end
DefineClass.SectorMilitiaMax = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
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
    },
    {
      id = "Negate",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("are militia units in <u(sector_id)> of max count and upgrade"),
  EditorViewNeg = Untranslated("are militia units in <u(sector_id)> not of max count and upgrade"),
  Documentation = "Checks if militia units in <u(sector_id)> are of max count and upgrade",
  EditorNestedObjCategory = "Sectors"
}
function SectorMilitiaMax:__eval(obj, context)
  local sector_id = self.sector_id == "current" and gv_CurrentSectorId or self.sector_id
  local sector = gv_Sectors[sector_id]
  local militia_squad_id = sector.militia_squad_id
  if not militia_squad_id then
    return false
  end
  local militia_squad = gv_Squads[militia_squad_id]
  if #(militia_squad.units or "") < sector.MaxMilitia then
    return false
  end
  local ud = GetLeastExpMilitia(militia_squad.units)
  local least_exp_templ = ud and ud.class
  return ud and ud.class == MilitiaUpgradePath[#MilitiaUpgradePath]
end
DefineClass.SectorMilitiaNumber = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
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
    },
    {
      category = "General",
      id = "Condition",
      name = "condition",
      help = "Select the relation to the specified militia number.",
      editor = "combo",
      default = ">",
      items = function(self)
        return {
          ">=",
          "<=",
          ">",
          "<",
          "==",
          "~="
        }
      end
    },
    {
      category = "General",
      id = "Amount",
      name = "Amount",
      help = "Set the value to check against.",
      editor = "number",
      default = 0,
      min = 0
    }
  },
  EditorView = Untranslated("are militia units in <u(sector_id)> sector <u(Condition)> <Amount>"),
  Documentation = "Checks militia units count in sector",
  EditorNestedObjCategory = "Sectors"
}
function SectorMilitiaNumber:__eval(obj, context)
  local sector_id = self.sector_id == "current" and gv_CurrentSectorId or self.sector_id
  return self:CompareOp(GetSectorMilitiaCount(sector_id))
end
DefineClass.SectorWarningReceived = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
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
  EditorView = Untranslated("If <u(sector_id)> sector's warning state has been triggered."),
  EditorViewNeg = Untranslated("If <u(sector_id)> sector's warning state has NOT been triggered."),
  Documentation = "Checks if the current or specified sector has had its warning state triggered.",
  EditorNestedObjCategory = "Sectors"
}
function SectorWarningReceived:__eval(obj, context)
  local sector_id = self.sector_id == "current" and gv_CurrentSectorId or self.sector_id
  return gv_Sectors[sector_id] and gv_Sectors[sector_id].warningReceived
end
DefineClass.SetpieceIsTestMode = {
  __parents = {
    "Condition",
    "BanterFunctionObjectBase"
  },
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    }
  },
  Documentation = "Check if a set-piece is currently playing in test mode.",
  EditorView = Untranslated("If a set-piece playing in test mode"),
  EditorViewNeg = Untranslated("If a set-piece NOT playing in test mode"),
  EditorNestedObjCategory = "Interactions"
}
function SetpieceIsTestMode:__eval(obj, context)
  return IsSetpieceTestMode()
end
DefineClass.SquadDefeated = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "custom_squad_id",
      name = "Custom Squad Id",
      help = "Custom squad ID.",
      editor = "text",
      default = false
    }
  },
  EditorView = Untranslated("Check if <u(custom_squad_id)> squad is defeated"),
  Documentation = "Checks if specified squad is defeated",
  EditorNestedObjCategory = ""
}
function SquadDefeated:__eval(obj, context)
  local squad_id = gv_CustomQuestIdToSquadId[self.custom_squad_id]
  return squad_id and not gv_Squads[squad_id]
end
function SquadDefeated:GetError()
  if not self.custom_squad_id then
    return "Specify Custom Squad Id"
  end
end
DefineClass.UnitApproachedBy = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Unit",
      name = "Unit",
      help = "The approaching unit to check for.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetTargetUnitCombo()
      end
    }
  },
  EditorView = Untranslated("if approached by '<u(Unit)>'"),
  Documentation = "Checks if the unit which approached a unit which plays \"approaching banters\" is of a specified type.",
  EditorNestedObjCategory = "Units"
}
function UnitApproachedBy:__eval(obj, context)
  if not context or not context.approachingUnits then
    return false
  end
  for i, u in ipairs(context.approachingUnits) do
    if UnitTarget.Match(nil, self.Unit, u) then
      return true
    end
  end
end
function UnitApproachedBy:GetError()
  if not self.Unit then
    return "No unit selected"
  end
end
DefineClass.UnitCanGoToPos = {
  __parents = {"Condition", "UnitTarget"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      id = "PositionMarker",
      name = "Position Marker",
      editor = "combo",
      default = false,
      items = function(self)
        return GridMarkerGroupsCombo()
      end
    }
  },
  EditorView = Untranslated("if '<u(TargetUnit)>' can go to <u(PositionMarker)>"),
  EditorViewNeg = Untranslated("if '<u(TargetUnit)>' CANNOT go to <u(PositionMarker)>"),
  Documentation = "Checks if a unit can go to a marker postion.",
  EditorNestedObjCategory = "Units"
}
function UnitCanGoToPos:__eval(marker, context)
  return self:MatchMapUnits(marker, context)
end
function UnitCanGoToPos:UnitCheck(unit, marker, context)
  local markers = MapGetMarkers(false, self.PositionMarker)
  if not markers or #markers == 0 then
    return false
  end
  local pfclass = CalcPFClass(unit.CurrentSide, unit.stance, unit.body_type)
  local has_path, closest_pos = pf.HasPosPath(unit:GetPos(), markers, pfclass)
  if closest_pos then
    for i, marker in ipairs(markers) do
      local x, y, z = marker:GetPosXYZ()
      if closest_pos:Equal(x, y, z) then
        return true
      elseif closest_pos:Equal2D(x, y) then
        local z1 = z or terrain.GetHeight(x, y)
        local z2 = closest_pos:z() or terrain.GetHeight(closest_pos)
        if abs(z1 - z2) < const.SlabSizeZ then
          return true
        end
      end
    end
  end
  return false
end
DefineClass.UnitHasInteraction = {
  __parents = {"Condition", "UnitTarget"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      id = "CombatAction",
      name = "Interaction",
      help = "The specific interaction that has to occur.",
      editor = "preset_id",
      default = "any",
      preset_class = "CombatAction",
      preset_group = "Interactions",
      extra_item = "any"
    },
    {
      id = "Event",
      help = "Which part of the interaction to check for. If set to false, any will be matched",
      editor = "combo",
      default = false,
      items = function(self)
        return InteractionLogEvents
      end
    },
    {
      id = "Result",
      help = "The kind of interaction result you want to check for. If set to false, any will be matched",
      editor = "combo",
      default = false,
      items = function(self)
        return InteractionLogResults[self.CombatAction]
      end
    },
    {
      id = "Interactable",
      name = "Interactable",
      help = "The interactable which is interacted with.",
      editor = "object",
      default = false,
      base_class = "Interactable",
      format_func = function(gameobj)
        if gameobj and IsValid(gameobj) then
          local x, y = gameobj:GetPos():xy()
          local label = gameobj:HasMember("group") and gameobj.group or gameobj.class
          return string.format("%s xx:%d yy:%d", label, x, y)
        else
          return ""
        end
      end
    },
    {
      id = "Group",
      name = "Group",
      help = "Find all from group and check for interaction with any of them.",
      editor = "combo",
      default = "false",
      items = function(self)
        return GetUnitGroups()
      end
    }
  },
  StoreAsTable = false,
  Documentation = "Test if an interaction has happened",
  EditorView = Untranslated("if '<u(TargetUnit)>' interacted with '<Interactable.class>'"),
  EditorViewNeg = Untranslated("if <u(TargetUnit)> hasn't interacted with <Interactable.class>"),
  EditorNestedObjCategory = "Units"
}
function UnitHasInteraction:__eval(obj, context)
  local interactables = self:ResolveInteractable()
  for _, interactable in ipairs(interactables) do
    local obj = ResolveInteractableObject(interactable)
    if IsValid(obj) and obj.interaction_log then
      local int_log = obj.interaction_log
      for i, log in ipairs(int_log) do
        local log_unit = g_Units[log.unit_template_id]
        local unit_matches = self:MatchMapUnits(log_unit, context)
        if unit_matches then
          local anyCombatAction = self.CombatAction == "any"
          local anyEvent = not self.Event
          local anyResult = not self.Result
          if (anyCombatAction or self.CombatAction == log.action) and (anyEvent or self.Event == log.event) and (anyResult or self.Result == log.result) then
            if context then
              context.target_units = {log_unit}
            end
            return true
          end
        end
      end
    end
  end
  return false
end
function UnitHasInteraction:ResolveInteractable()
  local group = self.Group
  return group and Groups and Groups[group] or {
    self.Interactable
  } or empty_table
end
DefineClass.UnitHasPerk = {
  __parents = {"Condition", "UnitTarget"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      id = "HasPerk",
      name = "Has perk",
      help = "if the unit has the specified perk.",
      editor = "preset_id",
      default = false,
      preset_class = "CharacterEffectCompositeDef",
      preset_filter = function(preset, obj)
        return preset.object_class == "Perk"
      end
    }
  },
  EditorView = Untranslated("if '<u(TargetUnit)>' has perk <u(HasPerk)>"),
  EditorViewNeg = Untranslated("if  '<u(TargetUnit)>' has not perk <u(HasPerk)>"),
  Documentation = "Checks a given perk for a unit",
  EditorNestedObjCategory = "Units"
}
function UnitHasPerk:__eval(obj, context)
  if not self.HasPerk then
    return false
  end
  return self:MatchMapUnits(obj, context)
end
function UnitHasPerk:UnitCheck(unit, obj, context)
  return HasPerk(unit, self.HasPerk)
end
function UnitHasPerk:GetError()
  if not self.HasPerk then
    return "Please specify the perk"
  end
end
DefineClass.UnitHasStat = {
  __parents = {"Condition", "UnitTarget"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition",
      editor = "bool",
      default = false
    },
    {
      id = "Stat",
      name = "Unit Stat",
      help = "Unit Properties stat.",
      editor = "choice",
      default = false,
      items = function(self)
        return GetUnitStatsCombo()
      end
    },
    {
      id = "Condition",
      name = "condition",
      help = "Select the relation to the specified value.",
      editor = "combo",
      default = ">=",
      items = function(self)
        return {
          ">=",
          "<=",
          ">",
          "<",
          "==",
          "~="
        }
      end
    },
    {
      id = "Amount",
      name = "Amount",
      help = "Set the value to check against.",
      editor = "number",
      default = 0
    },
    {
      id = "SuccessText",
      name = "SuccessText",
      help = "Text to display in the log if the check succeeds.",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "FailText",
      name = "FailText",
      help = "Text to display in the log if the check fails.",
      editor = "text",
      default = false,
      translate = true
    }
  },
  EditorView = Untranslated("if '<u(TargetUnit)>': <u(Stat)><u(Condition)><Amount>"),
  EditorViewNeg = Untranslated("if not (<u(TargetUnit)>: <u(Stat)><u(Condition)><Amount>)"),
  Documentation = "Checks a given stat for a merc",
  EditorNestedObjCategory = "Units"
}
function UnitHasStat:__eval(obj, context)
  if not self.Stat then
    return false
  end
  return self:MatchMapUnits(obj, context)
end
function UnitHasStat:UnitCheck(unit, obj, context)
  if not self.Stat then
    return false
  end
  if unit:IsDead() then
    return false
  end
  local stat = unit[self.Stat]
  local result = self:CompareOp(stat, context)
  local textContext = SubContext(unit, {
    stat = stat,
    threshold = self.Amount
  })
  context = context or empty_table
  if result and self.SuccessText and not context.no_log then
    CombatLog("important", T({
      self.SuccessText,
      textContext
    }))
  end
  if not result and self.FailText and not context.no_log then
    CombatLog("important", T({
      self.FailText,
      textContext
    }))
  end
  if not context.no_log then
    CombatLog("debug", "Skill check of " .. self.Amount .. " " .. self.Stat .. " by " .. (unit.unitdatadef_id or unit.class) .. " " .. tostring(result) .. " (" .. stat .. ")")
  end
  return result
end
function UnitHasStat:GetError()
  if not self.Stat then
    return "Choose unit Stat to check!"
  end
end
DefineClass.UnitHasStatusEffect = {
  __parents = {"Condition", "UnitTarget"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      id = "Effect",
      editor = "preset_id",
      default = false,
      preset_class = "CharacterEffectCompositeDef",
      preset_filter = function(preset, obj)
        return preset.object_class ~= "Perk"
      end
    }
  },
  EditorView = Untranslated("if '<u(TargetUnit)>' has effect <u(Effect)>"),
  EditorViewNeg = Untranslated("if  '<u(TargetUnit)>' does not have effect <u(Effect)>"),
  Documentation = "Checks a given perk for a unit",
  EditorNestedObjCategory = "Units"
}
function UnitHasStatusEffect:__eval(obj, context)
  if not self.Effect then
    return false
  end
  return self:MatchMapUnits(obj, context)
end
function UnitHasStatusEffect:UnitCheck(unit, obj, context)
  return unit:HasStatusEffect(self.Effect)
end
function UnitHasStatusEffect:GetError()
  if not self.Effect then
    return "Please specify the effect"
  end
end
DefineClass.UnitHasWeaponKind = {
  __parents = {"Condition", "UnitTarget"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      id = "weaponKind",
      name = "Weapon Kind",
      editor = "choice",
      default = false,
      items = function(self)
        return {
          "Unarmed",
          "ThrowableKnife",
          "MeleeWeapon",
          "AssaultRifle",
          "SubmachineGun",
          "Pistol",
          "Revolver",
          "Shotgun",
          "SniperRifle",
          "MachineGun",
          "HeavyWeapon",
          "Grenade"
        }
      end
    }
  },
  EditorView = Untranslated("If '<u(TargetUnit)>' has a <u(weaponKind)> equiped."),
  EditorViewNeg = Untranslated("If '<u(TargetUnit)>' doesn't have a <u(weaponKind)>  equipped."),
  Documentation = "Checks if a unit has a specific Weapon Kind equipped.",
  EditorNestedObjCategory = "Units"
}
function UnitHasWeaponKind:__eval(obj, context)
  if not self.weaponKind then
    return false
  end
  return self:MatchMapUnits(obj, context)
end
function UnitHasWeaponKind:UnitCheck(unit, obj, context)
  local weapons, slots = unit:GetHandheldItems()
  if self.weaponKind == "Unarmed" then
    local emptyHandsA = true
    local emptyHandsB = true
    for _, slot in ipairs(slots) do
      if slot == "Handheld A" then
        emptyHandsA = false
      elseif slot == "Handheld B" then
        emptyHandsB = false
      end
    end
    return emptyHandsA or emptyHandsB
  end
  if self.weaponKind == "ThrowableKnife" then
    for _, weapon in ipairs(weapons) do
      if IsKindOf(weapon, "MeleeWeapon") and weapon.CanThrow then
        return true
      end
    end
    return false
  end
  for _, weapon in ipairs(weapons) do
    if IsKindOf(weapon, self.weaponKind) then
      return true
    end
  end
  return false
end
function UnitHasWeaponKind:GetError()
  if not self.weaponKind then
    return "Please specify Weapon Kind"
  end
end
DefineClass.UnitHealth = {
  __parents = {"Condition", "UnitTarget"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      id = "UnitHealth",
      name = "Unit Health",
      editor = "number",
      default = false
    }
  },
  EditorView = Untranslated("if '<u(TargetUnit)>' has HitPoints <= <UnitHealth>"),
  EditorViewNeg = Untranslated("if '<u(TargetUnit)>' has HitPoints > <UnitHealth>"),
  Documentation = "Checks if the there's a unit within a given group whose current health is below, equal to or above a given value.",
  EditorNestedObjCategory = "Units"
}
function UnitHealth:__eval(obj, context)
  return self:MatchMapUnits(obj, context)
end
function UnitHealth:UnitCheck(unit, obj, context)
  return unit.HitPoints <= self.UnitHealth
end
function UnitHealth:GetError()
  if not self.UnitHealth then
    return "Please specify unit health"
  end
end
DefineClass.UnitHireStatus = {
  __parents = {"Condition", "UnitTarget"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition",
      editor = "bool",
      default = false
    },
    {
      id = "Status",
      name = "Hire Status",
      help = "The hiring status of the merc.",
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
  EditorView = Untranslated("if '<u(TargetUnit)>' is of the <u(Status)> status."),
  EditorViewNeg = Untranslated("if '<u(TargetUnit)>' isn't of the <u(Status)> status."),
  Documentation = "If the unit matches the set hiring status. If the merc is offline, this returns false",
  EditorNestedObjCategory = "Units"
}
function UnitHireStatus:__eval(obj, context)
  if not self.Status then
    return false
  end
  if not self.TargetUnit then
    return false
  end
  local unit = UnitDataDefs[self.TargetUnit]
  local unitData = gv_UnitData[unit.id]
  local stat = unitData and unitData.HireStatus or "Available"
  if self.Status ~= "Hired" and not unitData.MessengerOnline then
    return false
  end
  return stat == self.Status
end
function UnitHireStatus:GetError()
  if not self.Status then
    return "Choose unit hiring status to check!"
  end
end
DefineClass.UnitIsAroundMarkerOfGroup = {
  __parents = {"Condition", "UnitTarget"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "MarkerGroup",
      name = "MarkerGroup",
      help = "Marker group to match",
      editor = "combo",
      default = false,
      items = function(self)
        return GridMarkerGroupsCombo()
      end
    },
    {
      id = "Negate",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("if '<u(TargetUnit)>' is inside a '<u(MarkerGroup)>' marker"),
  EditorViewNeg = Untranslated("if '<u(TargetUnit)>' is not inside a '<u(MarkerGroup)>' marker"),
  Documentation = "Check is a unit is inside the area of a marker from a specified group",
  EditorNestedObjCategory = "Units"
}
function UnitIsAroundMarkerOfGroup:__eval(obj, context)
  local units1 = {}
  MapForEach("map", "Unit", function(u)
    if self:Match(self.TargetUnit, u, context) then
      units1[#units1 + 1] = u
    end
  end)
  local markers = MapGetMarkers(false, self.MarkerGroup)
  for i, m in ipairs(markers) do
    for i, u in ipairs(units1) do
      local vx, vy, vz = WorldToVoxel(u)
      if m:IsVoxelInsideArea(vx, vy, vz) then
        if type(context) == "table" then
          context.target_units = {u}
        end
        return true
      end
    end
  end
end
function UnitIsAroundMarkerOfGroup:GetError()
  if not self.TargetUnit or not self.MarkerGroup then
    return "Specify the target unit and marker"
  end
end
DefineClass.UnitIsAroundOtherUnit = {
  __parents = {"Condition", "UnitTarget"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "SecondTargetUnit",
      name = "SecondTargetUnit",
      help = "Second unit or group for match.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetTargetUnitCombo()
      end
    },
    {
      id = "Distance",
      name = "Distance",
      help = "The distance between the two units in meters.",
      editor = "number",
      default = 20
    }
  },
  EditorView = Untranslated("if '<u(TargetUnit)>' is around '<u(SecondTargetUnit)>'"),
  Documentation = [[
Checks if a unit is around another unit.
The second unit can be someone particular or a group.]],
  EditorNestedObjCategory = "Units"
}
function UnitIsAroundOtherUnit:__eval(obj, context)
  local units1, units2 = {}, {}
  MapForEach("map", "Unit", function(x)
    if self:Match(self.TargetUnit, x, context) then
      units1[#units1 + 1] = x
    end
    if self:Match(self.SecondTargetUnit, x, context) then
      units2[#units2 + 1] = x
    end
  end)
  local dist = self.Distance * guim
  local units2_around_units1 = {}
  for _, u2 in ipairs(units2) do
    for _, u1 in ipairs(units1) do
      if IsCloser2D(u1, u2, dist) then
        units2_around_units1[u2] = true
        break
      end
    end
  end
  if not next(units2_around_units1) then
    return false
  end
  if type(context) == "table" then
    units2_around_units1 = table.keys2(units2_around_units1)
    table.sortby_field(units2_around_units1, "handle")
    context.target_units = units2_around_units1
  end
  return true
end
function UnitIsAroundOtherUnit:GetError()
  if not self.TargetUnit or not self.SecondTargetUnit then
    return "Specify the target units"
  end
end
DefineClass.UnitIsAware = {
  __parents = {"Condition", "UnitTarget"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      id = "Pending",
      help = "Also pass the check if the unit is currently waiting to become aware",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("if '<u(TargetUnit)>' is aware"),
  EditorViewNeg = Untranslated("if  '<u(TargetUnit)>' is not aware"),
  Documentation = "Checks unit for the Unaware status effect.",
  EditorNestedObjCategory = "Units"
}
function UnitIsAware:__eval(obj, context)
  return self:MatchMapUnits(obj or {}, context)
end
function UnitIsAware:UnitCheck(unit, obj, context)
  return unit:IsAware(self.Pending)
end
DefineClass.UnitIsCombatTurn = {
  __parents = {"Condition", "UnitTarget"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("if '<u(TargetUnit)>' is part of the currently active team in combat"),
  EditorViewNeg = Untranslated("if  '<u(TargetUnit)>' is not part of the currently active team in combat"),
  Documentation = "Checks if it's unit's turn in combat",
  EditorNestedObjCategory = "Units"
}
function UnitIsCombatTurn:__eval(obj, context)
  return self:MatchMapUnits(obj or {}, context)
end
function UnitIsCombatTurn:UnitCheck(unit, obj, context)
  return IsInCombat() and g_Teams[g_CurrentTeam] == obj.team
end
DefineClass.UnitIsInSector = {
  __parents = {"Condition", "UnitTarget"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      id = "Sector",
      name = "Sector",
      help = "The sector to check in.",
      editor = "combo",
      default = false,
      items = function(self)
        return GetCampaignSectorsCombo("current")
      end
    }
  },
  Documentation = "Checks if a specific merc is  in a specific sector. Does not work for NPC or units that are not in a squad.",
  EditorNestedObjCategory = "Units"
}
function UnitIsInSector:__eval(obj, context)
  local sector = self.Sector
  if sector == "current" then
    sector = gv_CurrentSectorId
  end
  local unit = self.TargetUnit
  local squads = GetUngroupedSquadsInSector(sector)
  for i, s in ipairs(squads) do
    for i, u in ipairs(s.units) do
      if self:Match(unit, gv_UnitData[u]) then
        return true
      end
    end
  end
  return false
end
function UnitIsInSector:GetEditorView()
  local sectors = GetCampaignSectorsCombo("current")
  local data = table.find_value(sectors, "value", self.Sector)
  local name = data.text
  if self.Negate then
    return T({
      451396610003,
      "if '<u(TargetUnit)>' is NOT on the map <u(name)>.",
      name = name
    })
  else
    return T({
      625324726787,
      "if '<u(TargetUnit)>' is on the map <u(name)>.",
      name = name
    })
  end
end
function UnitIsInSector:GetError()
  if not self.TargetUnit then
    return "Specify the target unit"
  end
  if not self.Sector then
    return "Specify a sector"
  end
end
DefineClass.UnitIsMerc = {
  __parents = {"Condition", "UnitTarget"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("if '<u(TargetUnit)>' is a merc"),
  EditorViewNeg = Untranslated("if  '<u(TargetUnit)>' is not a merc"),
  Documentation = "Checks if unit is a merc",
  EditorNestedObjCategory = "Units"
}
function UnitIsMerc:__eval(obj, context)
  return self:MatchMapUnits(obj or {}, context)
end
function UnitIsMerc:UnitCheck(unit, obj, context)
  return unit:IsMerc()
end
DefineClass.UnitIsNearbyArea = {
  __parents = {"Condition", "UnitTarget"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("if '<u(TargetUnit)>' is inside marker area"),
  EditorViewNeg = Untranslated("if <u(TargetUnit)> merc is outside marker area"),
  Documentation = [[
Checks if a merc is inside a marker area.
The merc can be someone particular or just any merc.]],
  EditorNestedObjCategory = "Units"
}
function UnitIsNearbyArea:__eval(marker, context)
  return self:MatchMapUnits(marker, context)
end
function UnitIsNearbyArea:UnitCheck(unit, marker, context)
  local obj = context and context.interactable or marker
  return obj and obj:IsInsideArea(unit) or false
end
function UnitIsNearbyArea:TestInGed(subject, ged, context)
  local selObj = selo()
  if selObj then
    local root_collection = selObj:GetRootCollection()
    local collection_idx = root_collection and root_collection.Index or 0
    local marker = MapGetFirst("map", "collection", collection_idx, true, "GridMarker")
    if marker then
      context = {interactable = marker}
    end
  end
  return FunctionObject.TestInGed(self, subject, ged, context)
end
DefineClass.UnitIsOnMap = {
  __parents = {"Condition", "UnitTarget"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("if '<u(TargetUnit)>' is on the map and alive."),
  EditorViewNeg = Untranslated("if '<u(TargetUnit)>' is not on the map."),
  Documentation = "Checks if a specific unit is on the map.",
  EditorNestedObjCategory = "Units"
}
function UnitIsOnMap:__eval(obj, context)
  return self:MatchMapUnits(obj, context)
end
function UnitIsOnMap:UnitCheck(unit, obj, context)
  local result = MapGetFirst("map", "Unit", function(u)
    return u.session_id == unit.session_id
  end)
  return result and not unit:IsDead()
end
function UnitIsOnMap:GetError()
  if not self.TargetUnit then
    return "Specify the target unit"
  end
end
DefineClass.UnitSquadHasItem = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      id = "ItemId",
      name = "Item",
      help = "Item id that is looked for.",
      editor = "preset_id",
      default = false,
      preset_class = "InventoryItemCompositeDef"
    },
    {
      id = "Amount",
      name = "Amount",
      help = "Amount of that item.",
      editor = "number",
      default = 1,
      min = 1
    }
  },
  EditorView = Untranslated("if merc(s) have <u(ItemId)>(<Amount>) "),
  EditorViewNeg = Untranslated("if merc(s) haven't <u(ItemId)>(<Amount>) "),
  Documentation = "if the item is in the inventory of any merc on the map",
  EditorNestedObjCategory = "Units"
}
function UnitSquadHasItem:__eval(obj, context)
  return HasItemInSquad("all_squads", self.ItemId, self.Amount)
end
function UnitSquadHasItem:GetError()
  if not self.ItemId then
    return "Set Item!"
  end
end
DefineClass.UnitSquadHasMerc = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      id = "Name",
      help = "Look for a merc with the specified name.",
      editor = "choice",
      default = false,
      items = function(self)
        return MercPresetCombo()
      end
    },
    {
      id = "HasPerk",
      name = "Has perk",
      help = "Look for a merc that has the specified perk.",
      editor = "preset_id",
      default = false,
      preset_class = "CharacterEffectCompositeDef",
      preset_filter = function(preset, obj)
        return preset.object_class == "Perk"
      end
    },
    {
      id = "HasStat",
      name = "Has stat",
      help = "Look for a merc with a value of this stat above a threshold.",
      editor = "choice",
      default = false,
      items = function(self)
        return GetUnitStatsCombo
      end
    },
    {
      id = "StatValue",
      name = "Stat value",
      help = "Look for a merc with at least this value of the stat in 'Has stat'.",
      editor = "number",
      default = false,
      no_edit = function(obj)
        return not obj.HasStat
      end,
      slider = true,
      min = 1,
      max = 100
    },
    {
      id = "BestUnitFound",
      name = "BestUnitFound",
      help = "Best unit found in eval to display in UI auto generated texts.",
      editor = "text",
      default = false,
      dont_save = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "MaxStatUnitFound",
      name = "MaxStatUnitFound",
      help = "The unit with the max stat found in eval to display in UI auto generated texts.",
      editor = "text",
      default = false,
      dont_save = true,
      read_only = true,
      no_edit = true
    }
  },
  EditorView = Untranslated("Find merc <opt(u(Name),u('named '),' ')><opt(u(HasPerk),u('with perk '),' ')><opt(StatValue, u('with min '), ' ')><opt(u(HasStat), '', ' ')> on the map."),
  EditorViewNeg = Untranslated("Find NO merc <opt(u(Name),u('named '),' ')><opt(u(HasPerk),u('with perk '),' ')><opt(StatValue, u('with min '), ' ')><opt(u(HasStat), '', ' ')> on the map."),
  Documentation = "Looks for a merc on the map according to name, perks, or a stat value. Succeeds if such a merc is found, storing it in the 'found_merc' field of the context table.",
  EditorNestedObjCategory = "",
  EditorNestedObjCategory = "Units"
}
function UnitSquadHasMerc:__eval(obj, context)
  local units = GetAllPlayerUnitsOnMapSessionId()
  local found, maxStatUnitFound, found_neg
  local negative = rawget(self, "Negate")
  for _, session_id in ipairs(units or empty_table) do
    local unit = gv_UnitData[session_id]
    local stat = self.HasStat and unit[self.HasStat]
    local check = (not self.Name or self.Name == session_id) and (not self.HasPerk or HasPerk(unit, self.HasPerk)) and (not self.HasStat or stat >= self.StatValue)
    if self.HasStat and (not maxStatUnitFound or stat >= maxStatUnitFound.stat) then
      maxStatUnitFound = {stat = stat, session_id = session_id}
    end
    if check and not negative then
      if self.HasStat then
        if not found or found and stat > found.stat then
          found = {stat = stat, session_id = session_id}
        end
        if found and stat >= found.stat and BraidRandom(xxhash(session_id, stat), #units) > #units / 2 then
          found = {stat = stat, session_id = session_id}
        end
      else
        found = {stat = stat, session_id = session_id}
      end
      if type(context) == "table" and not negative and not context.found_merc then
        context.found_merc = session_id
      end
    end
    if check and negative then
      found_neg = true
    end
    if not check and negative then
      if self.HasStat then
        if not found or found and stat < found.stat then
          found = {
            stat = stat,
            session_id = session_id,
            negative = true
          }
        end
        if found and stat <= found.stat and BraidRandom(xxhash(session_id, stat), #units) > #units / 2 then
          found = {
            stat = stat,
            session_id = session_id,
            negative = true
          }
        end
      else
        found = {
          stat = stat,
          session_id = session_id,
          negative = true
        }
      end
      if type(context) == "table" and negative and not context.found_merc then
        context.found_merc = session_id
      end
    end
  end
  self.BestUnitFound = found and found.session_id or "not found"
  self.MaxStatUnitFound = maxStatUnitFound and maxStatUnitFound.session_id or "not found"
  if negative then
    return found_neg
  end
  return found
end
function UnitSquadHasMerc:GetError()
  if not self.Name and not self.HasPerk and not self.HasStat then
    return "Please specify at least one of 'Name', 'Has perk' or 'Has stat'."
  end
  if self.HasStat and not self.StatValue then
    return "Please specify 'Stat value'."
  end
end
function UnitSquadHasMerc:GetUIText(context, template, game)
  local merc, merc_name
  if not self.BestUnitFound or self.BestUnitFound == "not found" then
  else
    merc = gv_UnitData and gv_UnitData[self.BestUnitFound]
    merc_name = merc and merc.Nick
  end
  if not game then
    merc_name = Untranslated("[MercName]")
  end
  if self.Name and merc_name then
    if template then
      return T({template, MercName = merc_name})
    elseif not rawget(self, "Negate") then
      return T({
        250357174120,
        "<MercName> has something to say",
        MercName = merc_name
      })
    end
  end
  if gv_UnitData and self.HasStat and merc_name then
    merc = gv_UnitData[self.MaxStatUnitFound]
    merc_name = merc and merc.Nick
    if not game then
      merc_name = Untranslated("[MercName]")
    end
    local prop_meta = table.find_value(UnitPropertiesStats:GetProperties(), "id", self.HasStat)
    local stat = const.TagLookupTable[string.lower(prop_meta.id)] or T({
      638710586683,
      "<em><name></em>",
      name = prop_meta.name
    })
    local stat_val = merc and merc[self.HasStat] or Untranslated("[MaxStatValue]")
    if template then
      return T({
        template,
        MercName = merc_name,
        Stat = stat,
        StatVal = stat_val
      })
    else
      return T({
        410073687100,
        "<Stat> check: <em><MercName></em> has the highest stat (<StatVal>)",
        MercName = merc_name,
        Stat = stat,
        StatVal = stat_val
      })
    end
  end
end
function UnitSquadHasMerc:GetPhraseTopRolloverText(negative, template, game)
  local merc_name, merc
  if not self.BestUnitFound or self.BestUnitFound == "not found" then
  else
    merc = gv_UnitData[self.BestUnitFound]
    merc_name = merc and merc.Nick
  end
  if not game then
    merc_name = Untranslated("[MercName]")
  end
  if self.HasStat then
    local prop_meta = table.find_value(UnitPropertiesStats:GetProperties(), "id", self.HasStat)
    local stat = const.TagLookupTable[string.lower(prop_meta.id)] or T({
      638710586683,
      "<em><name></em>",
      name = prop_meta.name
    })
    if (merc or editor) and not self.Negate then
      if template then
        return T({
          template,
          MercName = merc_name,
          Stat = stat
        })
      else
        return T({
          351828405210,
          "<Stat> check successful",
          MercName = merc_name,
          Stat = stat
        })
      end
    elseif (not merc or editor) and self.Negate then
      return T({
        786464738039,
        "<Stat> check failed",
        MercName = merc_name,
        Stat = stat
      })
    end
  end
  if self.HasPerk and merc_name and not self.Negate then
    local preset = CharacterEffectDefs[self.HasPerk]
    local perk = const.TagLookupTable[string.lower(self.HasPerk)] or T({
      638710586683,
      "<em><name></em>",
      name = preset.DisplayName
    })
    if template then
      return T({
        template,
        MercName = merc_name,
        Perk = perk
      })
    elseif self.HasPerk then
      return T({
        346878086135,
        "<Perk> perk activated (<em><MercName></em>)",
        MercName = merc_name,
        Perk = perk
      })
    end
  end
end
function UnitSquadHasMerc:GetPhraseFX()
  if self.HasStat then
    return "ConversationStatCheck"
  end
end
function UnitSquadHasMerc:OnEditorSetProperty(prop_id, old_value, ged)
  if prop_id == "HasStat" and not self.HasStat then
    self.StatValue = false
  end
end
DefineClass.UnitStatusEffect = {
  __parents = {"Condition", "UnitTarget"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      id = "HasStatusEffect",
      name = "HasStatusEffect",
      help = "if the unit has the specified status effect.",
      editor = "preset_id",
      default = false,
      preset_class = "CharacterEffectCompositeDef",
      preset_filter = function(preset, obj)
        return preset.object_class ~= "Perk"
      end
    },
    {
      id = "Stacks",
      editor = "number",
      default = 1,
      min = 1
    }
  },
  EditorView = Untranslated("if '<u(TargetUnit)>' has status effect <u(HasStatusEffect)> (<Stacks>)"),
  EditorViewNeg = Untranslated("if '<u(TargetUnit)>' does NOT have status effect <u(HasStatusEffect)> (<Stacks>)"),
  Documentation = "Checks a given status effect for a unit",
  EditorNestedObjCategory = "Units"
}
function UnitStatusEffect:__eval(obj, context)
  if not self.HasStatusEffect then
    return false
  end
  return self:MatchMapUnits(obj, context)
end
function UnitStatusEffect:UnitCheck(unit, obj, context)
  local eff = unit:GetStatusEffect(self.HasStatusEffect)
  return eff and eff.stacks >= self.Stacks
end
function UnitStatusEffect:GetError()
  if not self.HasStatusEffect then
    return "Please specify the status effect"
  end
end
DefineClass.UnitTiredness = {
  __parents = {"Condition", "UnitTarget"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      id = "TirednessLevel",
      editor = "choice",
      default = 0,
      items = function(self)
        return UnitTirednessComboItems
      end
    }
  },
  EditorView = Untranslated("if '<u(TargetUnit)>' tiredness level is higher than <tiredness(TirednessLevel)>"),
  EditorViewNeg = Untranslated("if '<u(TargetUnit)>' tiredness level is lower than <tiredness(TirednessLevel)>"),
  Documentation = "Checks if tiredness level for a unit is above/below the specified value. Units with Tiredness matching the condition value will fail the test.",
  EditorNestedObjCategory = "Units"
}
function UnitTiredness:__eval(obj, context)
  return self:MatchMapUnits(obj, context)
end
function UnitTiredness:UnitCheck(unit, obj, context)
  return unit.Tiredness > self.TirednessLevel
end
DefineClass.VillainIsDefeated = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      id = "Group",
      name = "Group",
      editor = "combo",
      default = "false",
      items = function(self)
        return GetUnitGroups()
      end
    }
  },
  EditorView = Untranslated("if '<u(Group)>' is defeated"),
  EditorViewNeg = Untranslated("if '<u(Group)>' is not defeated"),
  Documentation = "Check if selected villain is defeated",
  EditorNestedObjCategory = "Villains",
  Documentation = "Check if selected villain is defeated"
}
function VillainIsDefeated:__eval(obj, context)
  if not Groups or not Groups[self.Group] then
    return false
  end
  for _, obj in ipairs(Groups[self.Group]) do
    if IsKindOf(obj, "Unit") and obj:IsDefeatedVillain() then
      return true
    end
  end
  return false
end
DefineClass.WoundedMercs = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      category = "General",
      id = "Negate",
      name = "Negate Condition",
      help = "If true, checks for the opposite condition.",
      editor = "bool",
      default = false
    },
    {
      category = "General",
      id = "woundedMercs",
      name = "Wounded Mercs",
      help = "How many mercs should be wounded.",
      editor = "number",
      default = 1
    },
    {
      category = "General",
      id = "minWounds",
      name = "Minimum Wounds",
      help = "Minimum amount of wounds a merc should have in order to count.",
      editor = "number",
      default = 1
    }
  },
  EditorView = Untranslated("If there are at least <woundedMercs> wounded Mercs with <minWounds> or more wounds."),
  EditorViewNeg = Untranslated("If there are LESS than <woundedMercs> wounded Mercs with <minWounds> or more wounds."),
  Documentation = "Check if a set amount of mercs are wounded. And have a set amount of wounds."
}
function WoundedMercs:__eval(obj, context)
  local woundedMercs = 0
  if gv_SatelliteView then
    for _, squad in ipairs(g_SquadsArray) do
      if squad.Side == "player1" then
        for i, u in ipairs(squad.units or empty_table) do
          local unit = gv_UnitData[u]
          local effect = unit:GetStatusEffect("Wounded")
          if effect and effect.stacks >= self.minWounds then
            woundedMercs = woundedMercs + 1
          end
        end
      end
    end
  else
    for _, unit in ipairs(g_Units) do
      local squad = unit:GetSatelliteSquad()
      if squad and squad.Side == "player1" then
        local effect = unit:GetStatusEffect("Wounded")
        if effect and effect.stacks >= self.minWounds then
          woundedMercs = woundedMercs + 1
        end
      end
    end
  end
  return woundedMercs >= self.woundedMercs
end
