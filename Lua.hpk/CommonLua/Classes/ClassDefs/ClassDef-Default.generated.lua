DefineClass.AnimComponentWeight = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "AnimComponent",
      editor = "preset_id",
      default = false,
      preset_class = "AnimComponent"
    },
    {
      id = "BlendAfterChannel",
      help = "If false, the component will execute on the channel animation, if true, it will execute after the channel has beel blended with all before it.",
      editor = "bool",
      default = false
    }
  }
}
DefineClass.AnimLimbData = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "fit_bone",
      help = "Bone name to be fit to target",
      editor = "text",
      default = false
    },
    {
      id = "joint_bone",
      editor = "text",
      default = false
    },
    {
      id = "joint_companion_bone",
      editor = "text",
      default = false
    },
    {
      id = "top_bone",
      editor = "text",
      default = false
    },
    {
      id = "top_companion_bone",
      editor = "text",
      default = false
    },
    {
      id = "fit_normal",
      help = "Local bone space normal direction to be fit to target",
      editor = "point",
      default = point(0, 1000, 0)
    },
    {
      id = "fit_offset",
      help = "Local bone space position offset to be fit to target",
      editor = "point",
      default = point(0, 0, 0)
    },
    {
      id = "joint_axis",
      help = "Local bone space joint axis direction",
      editor = "point",
      default = point(0, 0, 1000)
    }
  }
}
DefineClass.CommonGameSettings = {
  __parents = {"InitDone"},
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Modifiers",
      id = "game_difficulty",
      name = T(607013881337, "Game difficulty"),
      editor = "preset_id",
      default = false,
      preset_class = "GameDifficultyDef"
    },
    {
      category = "Modifiers",
      id = "seed_text",
      name = T(968127954818, "Seed"),
      help = T(657915341595, "Text used to generate seed. If empty a random (async) seed will be used."),
      editor = "text",
      default = ""
    },
    {
      category = "Modifiers",
      id = "game_rules",
      name = T(567633276594, "Game Rules"),
      editor = "prop_table",
      default = false
    },
    {
      category = "Modifiers",
      id = "forced_game_rules",
      name = T(957452987296, "Forced game rules"),
      help = T(745042998514, "If a rule is set to true, it is force enabled, false means force disabled."),
      editor = "prop_table",
      default = false,
      dont_save = true,
      no_edit = true
    }
  },
  StoreAsTable = true,
  id = false,
  save_id = false,
  loaded_from_id = false
}
function CommonGameSettings:Init()
  self.id = self.id or random_encode64(96)
  local difficulty = table.get(Presets, "GameDifficultyDef", 1) or empty_table
  difficulty = difficulty[(#difficulty + 1) / 2]
  self.game_difficulty = self.game_difficulty or difficulty and difficulty.id or nil
  self.game_rules = self.game_rules or {}
  self.forced_game_rules = self.forced_game_rules or {}
  ForEachPreset("GameRule", function(rule)
    if rule.init_as_active then
      self:AddGameRule(rule.id)
    end
  end)
end
function CommonGameSettings:ToggleListValue(prop_id, item_id)
  if prop_id == "game_rules" then
    self:ToggleGameRule(item_id)
    return
  end
  local value = self[prop_id]
  if value[item_id] then
    value[item_id] = nil
  else
    value[item_id] = true
  end
end
function CommonGameSettings:ToggleGameRule(rule_id)
  local value = self.game_rules[rule_id]
  if value then
    self:RemoveGameRule(rule_id)
  else
    self:AddGameRule(rule_id)
  end
end
function CommonGameSettings:AddGameRule(rule_id)
  if self:CanAddGameRule(rule_id) then
    self.game_rules[rule_id] = true
  end
end
function CommonGameSettings:RemoveGameRule(rule_id)
  if self:CanRemoveGameRule(rule_id) then
    self.game_rules[rule_id] = nil
  end
end
function CommonGameSettings:SetForceEnabledGameRule(rule_id, set)
  if set then
    self:AddGameRule(rule_id)
  else
    self:RemoveGameRule(rule_id)
  end
  self.forced_game_rules[rule_id] = set and true or nil
end
function CommonGameSettings:SetForceDisabledGameRule(rule_id, set)
  if set then
    self:RemoveGameRule(rule_id)
  end
  if set then
    self.forced_game_rules[rule_id] = false
  else
    self.forced_game_rules[rule_id] = nil
  end
end
function CommonGameSettings:CanAddGameRule(rule_id)
  if self.forced_game_rules[rule_id] == false then
    return
  end
  local rule = GameRuleDefs[rule_id]
  return not self:IsGameRuleActive(rule_id) and rule and rule:IsCompatible(self.game_rules)
end
function CommonGameSettings:CanRemoveGameRule(rule_id)
  return self.forced_game_rules[rule_id] == nil
end
function CommonGameSettings:IsGameRuleActive(rule_id)
  return self.game_rules[rule_id]
end
function CommonGameSettings:CopyCategoryTo(other, category)
  for _, prop in ipairs(self:GetProperties()) do
    if prop.category == category then
      local value = self:GetProperty(prop.id)
      value = type(value) == "table" and table.copy(value) or value
      other:SetProperty(prop.id, value)
    end
  end
end
function CommonGameSettings:Clone()
  local obj = CooldownObj.Clone(self)
  obj.id = self.id or nil
  obj.save_id = self.save_id or nil
  obj.loaded_from_id = self.loaded_from_id or nil
  return obj
end
DefineClass.Explanation = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Text",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "Id",
      editor = "text",
      default = false
    },
    {
      id = "ObjIsKindOf",
      name = "Object is of type",
      help = "The explanation is provided only if the parameter object inherits the specified class.",
      editor = "combo",
      default = "",
      items = function(self)
        return ClassDescendantsList("PropertyObject")
      end
    },
    {
      id = "Conditions",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    }
  },
  EditorView = Untranslated("Explanation: <Text>")
}
function GetFirstExplanation(list, obj, ...)
  local IsKindOf = IsKindOf
  local EvalConditionList = EvalConditionList
  for _, explanation in ipairs(list) do
    local kind_of = explanation.ObjIsKindOf or ""
    if (kind_of == "" or IsKindOf(obj, kind_of)) and EvalConditionList(explanation.Conditions, obj, ...) then
      return explanation.Text, explanation.Id
    end
  end
  return ""
end
