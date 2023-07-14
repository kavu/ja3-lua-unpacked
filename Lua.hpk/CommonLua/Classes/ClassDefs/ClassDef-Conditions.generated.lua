DefineClass.CheckAND = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate",
      editor = "bool",
      default = false
    },
    {
      id = "Conditions",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    }
  },
  EditorView = Untranslated("AND"),
  EditorViewNeg = Untranslated("NOT AND"),
  Documentation = "Checks if all of the nested conditions are true."
}
function CheckAND:__eval(obj, ...)
  for _, cond in ipairs(self.Conditions) do
    if not cond:Evaluate(obj, ...) then
      return false
    end
  end
  return true
end
DefineClass.CheckCooldown = {
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
      id = "CooldownObj",
      name = "Cooldown object",
      editor = "combo",
      default = "Game",
      items = function(self)
        return {
          "obj",
          "context",
          "Player",
          "Game"
        }
      end
    },
    {
      id = "Cooldown",
      editor = "preset_id",
      default = "Disabled",
      preset_class = "CooldownDef"
    }
  },
  EditorView = Untranslated("<CooldownObj> cooldown <Cooldown> is not active"),
  EditorViewNeg = Untranslated("<CooldownObj> cooldown <Cooldown> is active"),
  Documentation = "Checks if a given cooldown is active",
  EditorNestedObjCategory = ""
}
function CheckCooldown:__eval(obj, context)
  local cooldown_obj = self.CooldownObj
  if cooldown_obj == "Player" then
    obj = ResolveEventPlayer(obj, context)
  elseif cooldown_obj == "Game" then
    obj = Game
  elseif cooldown_obj == "context" then
    obj = context
  end
  return not IsKindOf(obj, "CooldownObj") or not obj:GetCooldown(self.Cooldown)
end
function CheckCooldown:GetError()
  if not CooldownDefs[self.Cooldown] then
    return "No such cooldown"
  end
end
DefineClass.CheckDifficulty = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate",
      editor = "bool",
      default = false
    },
    {
      id = "Difficulty",
      name = "Difficulty",
      editor = "preset_id",
      default = "",
      preset_class = "GameDifficultyDef"
    }
  },
  EditorView = Untranslated("Difficulty <Difficulty>"),
  EditorViewNeg = Untranslated("Difficulty not <Difficulty>"),
  Documentation = "Checks game difficulty."
}
function CheckDifficulty:__eval(obj, context)
  return GetGameDifficulty() == self.Difficulty
end
DefineClass.CheckExpression = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "EditorViewComment",
      help = "Text that explains the expression and is shown in the editor view field.",
      editor = "text",
      default = "Check expression"
    },
    {
      id = "Params",
      editor = "text",
      default = "self, obj"
    },
    {
      id = "Expression",
      editor = "expression",
      default = function(self)
        return true
      end,
      params = function(self)
        return self.Params
      end
    }
  },
  Documentation = "Checks expression (function) result."
}
function CheckExpression:GetEditorView()
  return self.EditorViewComment and Untranslated(self.EditorViewComment) or Untranslated("Check expression")
end
function CheckExpression:__eval(...)
  local ok, result = procall(self.Expression, self, ...)
  return ok and result
end
DefineClass.CheckGameRule = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate",
      editor = "bool",
      default = false
    },
    {
      id = "Rule",
      name = "Rule",
      editor = "preset_id",
      default = false,
      preset_class = "GameRuleDef"
    }
  },
  EditorView = Untranslated("Game rule <Rule> is active"),
  EditorViewNeg = Untranslated("Game rule <Rule> is not active"),
  Documentation = "Checks if a game rule is active."
}
function CheckGameRule:__eval(obj, context)
  return IsGameRuleActive(self.Rule)
end
DefineClass.CheckGameState = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate",
      editor = "bool",
      default = false
    },
    {
      id = "GameState",
      name = "Game state",
      editor = "preset_id",
      default = false,
      preset_class = "GameStateDef"
    }
  },
  EditorView = Untranslated("Game state <u(GameState)> is active"),
  EditorViewNeg = Untranslated("Game state <u(GameState)> is not active"),
  Documentation = "Checks if a game state is active."
}
function CheckGameState:__eval(obj, context)
  return GameState[self.GameState]
end
function CheckGameState:GetError()
  if not GameStateDefs[self.GameState] then
    return "No such GameState"
  end
end
DefineClass.CheckMapRandom = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Chance",
      editor = "number",
      default = 10,
      scale = "%",
      min = 0,
      max = 100
    },
    {
      id = "Seed",
      help = "Seed should be different on each instance.",
      editor = "number",
      default = false,
      buttons = {
        {name = "Rand", func = "Rand"}
      }
    }
  },
  EditorView = Untranslated("Map chance <percent(Chance)>"),
  Documentation = "Checks a random chance which stays the same until the map changes."
}
function CheckMapRandom:__eval(obj, context)
  return abs(MapLoadRandom + self.Seed) % 100 < self.Chance
end
function CheckMapRandom:OnEditorNew(parent, ged, is_paste)
  self.Seed = AsyncRand()
end
function CheckMapRandom:Rand()
  self.Seed = AsyncRand()
  ObjModified(self)
end
DefineClass.CheckOR = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Negate",
      name = "Negate",
      editor = "bool",
      default = false
    },
    {
      id = "Conditions",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    }
  },
  EditorView = Untranslated("OR"),
  EditorViewNeg = Untranslated("NOT OR"),
  Documentation = "Checks if one of the nested conditions is true."
}
function CheckOR:__eval(obj, ...)
  for _, cond in ipairs(self.Conditions) do
    if cond:Evaluate(obj, ...) then
      return true
    end
  end
end
DefineClass.CheckPropValue = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "BaseClass",
      name = "Class",
      editor = "combo",
      default = false,
      items = function(self)
        return ClassDescendantsList("PropertyObject")
      end
    },
    {
      id = "NonMatching",
      name = "Non-matching objects",
      help = [[
When the object does not match the provided class. 
not IsKindOf(obj, Class)]],
      editor = "choice",
      default = "fail",
      items = function(self)
        return {"fail", "succeed"}
      end
    },
    {
      id = "PropId",
      name = "Prop",
      editor = "combo",
      default = false,
      items = function(self)
        return self:GetNumericProperties()
      end
    },
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
      name = "Amount",
      editor = "number",
      default = 0,
      scale = function(self)
        return self:GetAmountMeta("scale")
      end
    }
  },
  EditorView = Untranslated("<BaseClass>.<PropId> <Condition> <Amount>"),
  Documentation = "Checks the value of a property."
}
function CheckPropValue:__eval(obj, context)
  if not obj or not IsKindOf(obj, self.BaseClass) then
    return self.NonMatching ~= "fail"
  end
  local value = obj:GetProperty(self.PropId) or 0
  return self:CompareOp(value, context)
end
function CheckPropValue:GetError()
  local class = g_Classes[self.BaseClass]
  if not class then
    return "No such class"
  end
  local prop_meta = class:GetPropertyMetadata(self.PropId)
  if not prop_meta then
    return "No such property"
  end
end
function CheckPropValue:GetNumericProperties()
  local class = g_Classes[self.BaseClass]
  local properties = class and class:GetProperties() or empty_table
  local props = {}
  for i = #properties, 1, -1 do
    if properties[i].editor == "number" then
      props[#props + 1] = properties[i].id
    end
  end
  return props
end
function CheckPropValue:GetAmountMeta(meta, default)
  local class = g_Classes[self.BaseClass]
  local prop_meta = class and class:GetPropertyMetadata(self.PropId)
  if prop_meta then
    return prop_meta[meta]
  end
  return default
end
DefineClass.CheckRandom = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "Chance",
      editor = "number",
      default = 10,
      scale = "%",
      min = 0,
      max = 100
    }
  },
  EditorView = Untranslated("Chance <percent(Chance)>"),
  Documentation = "Checks a random chance."
}
function CheckRandom:__eval(obj, context)
  return InteractionRand(100, "CheckRandom") < self.Chance
end
DefineClass.CheckTime = {
  __parents = {"Condition"},
  __generated_by_class = "ConditionDef",
  properties = {
    {
      id = "TimeScale",
      name = "Time Scale",
      editor = "choice",
      default = "h",
      items = function(self)
        return GetTimeScalesCombo()
      end
    },
    {
      id = "TimeMin",
      name = "Min Time",
      editor = "number",
      default = false
    },
    {
      id = "TimeMax",
      name = "Max Time",
      editor = "number",
      default = false
    }
  },
  EditorView = Untranslated("Time<opt(TimeMin,' after ',TimeScale)><opt(TimeMax,' before ',TimeScale)>"),
  Documentation = "Checks if the game time matches an interval."
}
function CheckTime:__eval(obj, context)
  local scale = const.Scale[self.TimeScale] or 1
  local min, max = self.TimeMin, self.TimeMax
  local time = GameTime()
  return (not min or time >= min * scale) and (not max or time <= max * scale)
end
function CheckTime:GetError()
  if not self.TimeMin and not self.TimeMax then
    return "No time restriction specified"
  end
end
DefineClass.ScriptAND = {
  __parents = {
    "ScriptCondition"
  },
  __generated_by_class = "ScriptConditionDef",
  HasNegate = true,
  EditorView = Untranslated("AND"),
  EditorViewNeg = Untranslated("NOT AND"),
  EditorName = "AND",
  EditorSubmenu = "Conditions",
  Documentation = "Checks if all of the nested conditions are true.",
  CodeTemplate = "(self[and])",
  ContainerClass = "ScriptValue"
}
DefineClass.ScriptCheckCooldown = {
  __parents = {
    "ScriptCondition"
  },
  __generated_by_class = "ScriptConditionDef",
  properties = {
    {
      id = "CooldownObj",
      name = "Cooldown object",
      editor = "combo",
      default = "Game",
      items = function(self)
        return {
          "parameter",
          "Player",
          "Game"
        }
      end
    },
    {
      id = "Cooldown",
      editor = "preset_id",
      default = "Disabled",
      preset_class = "CooldownDef"
    }
  },
  HasNegate = true,
  EditorName = "Check cooldown",
  EditorSubmenu = "Conditions",
  Documentation = "Checks if a given cooldown is active.",
  CodeTemplate = "",
  Param1Name = "Object"
}
function ScriptCheckCooldown:GetEditorView()
  return string.format("%s%s cooldown %s is %sactive", self.CooldownObj == "Game" and "Game" or self.Param1, self.CooldownObj == "Player" and "'s player" or "", self.Cooldown or "false", self.Negate and "not " or "")
end
function ScriptCheckCooldown:GenerateCode(pstr, indent)
  if self.Negate then
    pstr:append("not ")
  end
  if self.CooldownObj == "Game" then
    pstr:appendf("Game:GetCooldown(\"%s\")", self.Cooldown)
  elseif self.CooldownObj == "Player" then
    pstr:appendf("ResolveEventPlayer(%s):GetCooldown(\"%s\")", self.Param1, self.Cooldown)
  else
    pstr:appendf("(IsKindOf(%s, \"CooldownObj\") and %s:GetCooldown(\"%s\"))", self.Param1, self.Param1, self.Cooldown)
  end
end
function ScriptCheckCooldown:GetError()
  if not CooldownDefs[self.Cooldown] then
    return "No such cooldown"
  end
end
DefineClass.ScriptCheckGameState = {
  __parents = {
    "ScriptCondition"
  },
  __generated_by_class = "ScriptConditionDef",
  properties = {
    {
      id = "GameState",
      name = "Game state",
      editor = "preset_id",
      default = false,
      preset_class = "GameStateDef"
    }
  },
  HasNegate = true,
  EditorView = Untranslated("Game state <u(GameState)> is active"),
  EditorViewNeg = Untranslated("Game state <u(GameState)> not active"),
  EditorName = "Check game state",
  EditorSubmenu = "Conditions",
  Documentation = "Checks if a game state is active.",
  CodeTemplate = "GameState[self.GameState]"
}
function ScriptCheckGameState:GetError()
  if not GameStateDefs[self.GameState] then
    return "No such GameState"
  end
end
DefineClass.ScriptCheckPropValue = {
  __parents = {
    "ScriptCondition"
  },
  __generated_by_class = "ScriptConditionDef",
  properties = {
    {
      id = "BaseClass",
      name = "Class",
      editor = "combo",
      default = false,
      items = function(self)
        return ClassDescendantsList("PropertyObject")
      end
    },
    {
      id = "PropId",
      name = "Prop",
      editor = "combo",
      default = false,
      items = function(self)
        return self:GetNumericProperties()
      end
    },
    {
      id = "NonMatchingValue",
      name = "Value for non-matching objects",
      help = "Value used when the object does not match the provided class: not IsKindOf(obj, Class)",
      editor = "number",
      default = 0,
      scale = function(self)
        return self:GetAmountMeta("scale")
      end
    },
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
      name = "Amount",
      editor = "number",
      default = 0,
      scale = function(self)
        return self:GetAmountMeta("scale")
      end
    }
  },
  EditorView = Untranslated("<Param1>: <BaseClass>.<PropId> <Condition> <Amount>"),
  EditorName = "Check a property value",
  EditorSubmenu = "Conditions",
  Documentation = "Checks the value of a numeric property.",
  CodeTemplate = "(IsKindOf($self.Param1, self.BaseClass) and $self.Param1:GetProperty(self.PropId) or self.NonMatchingValue) $self.Condition self.Amount",
  Param1Name = "Object"
}
function ScriptCheckPropValue:GetError()
  local class = g_Classes[self.BaseClass]
  if not class then
    return "No such class"
  end
  local prop_meta = class:GetPropertyMetadata(self.PropId)
  if not prop_meta then
    return "No such property"
  end
end
function ScriptCheckPropValue:GetNumericProperties()
  local class = g_Classes[self.BaseClass]
  local properties = class and class:GetProperties() or empty_table
  local props = {}
  for i = #properties, 1, -1 do
    if properties[i].editor == "number" then
      props[#props + 1] = properties[i].id
    end
  end
  return props
end
function ScriptCheckPropValue:GetAmountMeta(meta, default)
  local class = g_Classes[self.BaseClass]
  local prop_meta = class and class:GetPropertyMetadata(self.PropId)
  if prop_meta then
    return prop_meta[meta]
  end
  return default
end
DefineClass.ScriptCheckTime = {
  __parents = {
    "ScriptCondition"
  },
  __generated_by_class = "ScriptConditionDef",
  properties = {
    {
      id = "TimeScale",
      name = "Time Scale",
      editor = "choice",
      default = "h",
      items = function(self)
        return GetTimeScalesCombo()
      end
    },
    {
      id = "TimeMin",
      name = "Min Time",
      editor = "number",
      default = false
    },
    {
      id = "TimeMax",
      name = "Max Time",
      editor = "number",
      default = false
    }
  },
  EditorView = Untranslated("Time<opt(TimeMin,' after ',TimeScale)><opt(TimeMax,' before ',TimeScale)>"),
  EditorName = "Check time",
  EditorSubmenu = "Conditions",
  Documentation = "Checks if the game time matches an interval.",
  CodeTemplate = ""
}
function ScriptCheckTime:GenerateCode(pstr, indent)
  local scale = self.TimeScale
  if scale ~= "" then
    scale = scale == "sec" and "000" or string.format("*const.Scale[\"%s\"]", self.TimeScale)
  end
  local min, max = self.TimeMin, self.TimeMax
  if min and max then
    pstr:appendf("GameTime() >= %d%s and GameTime() <= %d%s", min, scale, max, scale)
  elseif min then
    pstr:appendf("GameTime() >= %d%s", min, scale)
  elseif max then
    pstr:appendf("GameTime() <= %d%s", max, scale)
  end
end
function ScriptCheckTime:GetError()
  if not self.TimeMin and not self.TimeMax then
    return "No time restriction specified."
  end
  if self.TimeMin and self.TimeMax and self.TimeMin > self.TimeMax then
    return "TimeMin is greater than TimeMax."
  end
end
DefineClass.ScriptOR = {
  __parents = {
    "ScriptCondition"
  },
  __generated_by_class = "ScriptConditionDef",
  HasNegate = true,
  EditorView = Untranslated("OR"),
  EditorViewNeg = Untranslated("NOT OR"),
  EditorName = "OR",
  EditorSubmenu = "Conditions",
  Documentation = "Checks if at least one of the nested conditions is true.",
  CodeTemplate = "(self[or])",
  ContainerClass = "ScriptValue"
}
