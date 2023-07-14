DefineClass.ChangeGameStateEffect = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "GameState",
      name = "Game state",
      editor = "preset_id",
      default = false,
      preset_class = "GameStateDef"
    },
    {
      id = "Value",
      name = "Value",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("<select(Value,'Clear','Set')> game state <GameState>"),
  Documentation = "Changes a game state"
}
function ChangeGameStateEffect:__exec(obj, context)
  ChangeGameState(self.GameState, self.Value)
end
function ChangeGameStateEffect:GetError()
  if not GameStateDefs[self.GameState] then
    return "No such GameState"
  end
end
DefineClass.ChangeLightmodel = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Lightmodel",
      name = "Light model",
      help = "Specify a light model, or leave as 'false' to restore the previous one.",
      editor = "preset_id",
      default = false,
      preset_class = "LightmodelPreset"
    }
  },
  EditorView = Untranslated("<if(Lightmodel)>Change light model to <Lightmodel>.</if><if(not(Lightmodel))>Restore last light model.</if>"),
  Documentation = "Changes the current light model, or restores the last one if Light model is 'false'."
}
function ChangeLightmodel:__exec(obj, context)
  SetLightmodelOverride(false, self.Lightmodel)
end
DefineClass.EffectsWithCondition = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Conditions",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    },
    {
      id = "Effects",
      editor = "nested_list",
      default = false,
      base_class = "Effect",
      all_descendants = true
    },
    {
      id = "EffectsElse",
      name = "Else",
      editor = "nested_list",
      default = false,
      base_class = "Effect",
      all_descendants = true
    }
  },
  EditorView = Untranslated("Effects with condition"),
  Documentation = "Executes different effects when a list of conditions is true or not."
}
function EffectsWithCondition:__exec(obj, ...)
  if EvalConditionList(self.Conditions, obj, ...) then
    ExecuteEffectList(self.Effects, obj, ...)
    return true
  else
    ExecuteEffectList(self.EffectsElse, obj, ...)
  end
end
DefineClass.ExecuteCode = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Params",
      editor = "text",
      default = "self, obj"
    },
    {
      id = "SaveAsText",
      editor = "bool",
      default = false
    },
    {
      id = "Code",
      editor = "func",
      default = function(self)
      end,
      params = function(self)
        return self.Params
      end,
      no_edit = function(self)
        return self.SaveAsText
      end
    },
    {
      id = "FuncCode",
      editor = "text",
      default = false,
      params = function(self)
        return self.Params
      end,
      no_edit = function(self)
        return not self.SaveAsText
      end,
      lines = 1
    }
  },
  EditorView = Untranslated("Execute Code"),
  Documentation = "Execute arbitrary code."
}
function ExecuteCode:__exec(...)
  if self.SaveAsText and self.FuncCode then
    local prop_meta = self:GetPropertyMetadata("FuncCode")
    local params = prop_meta.params(self, prop_meta) or "self"
    local func, err = CompileFunc("FuncCode", params, self.FuncCode)
    if not func then
      return false
    end
    return procall(func, self, ...)
  else
    return procall(self.Code, self, ...)
  end
end
function ExecuteCode:__toluacode(...)
  if not self.SaveAsText then
  end
  return Effect.__toluacode(self, ...)
end
function ExecuteCode:GetError()
  local code
  if self.SaveAsText then
    if self.FuncCode then
      code = string.split(self.FuncCode, "\n")
    end
  elseif self.Code then
    local _, _, body = GetFuncSource(self.Code)
    code = body
  end
  if not code then
    return
  end
  code = type(code) == "string" and {code} or code
  for _, line in ipairs(code) do
    if string.match(line, "T{") then
      return "FuncCode can't use T{}"
    end
    if string.match(line, "Translated%(") then
      return "FuncCode can't use Translated()"
    end
    if string.match(line, "Untranslated%(") then
      return "FuncCode can't use Untranslated()"
    end
  end
end
DefineClass.ModifyCooldownEffect = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
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
    },
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
      id = "Time",
      help = "If time is not provided the default time from the cooldown definition is used.",
      editor = "number",
      default = 0,
      scale = function(self)
        return self.TimeScale
      end
    },
    {
      id = "RandomTime",
      editor = "number",
      default = 0,
      scale = function(self)
        return self.TimeScale
      end
    }
  },
  EditorView = Untranslated("Add to <CooldownObj> cooldown <Cooldown>"),
  Documentation = "Adds time to an existing cooldown",
  EditorNestedObjCategory = ""
}
function ModifyCooldownEffect:__exec(obj, context)
  local cooldown_obj = self.CooldownObj
  if cooldown_obj == "Player" then
    obj = ResolveEventPlayer(obj, context)
  elseif cooldown_obj == "Game" then
    obj = Game
  elseif cooldown_obj == "context" then
    obj = context
  end
  if IsKindOf(obj, "CooldownObj") then
    local rand = self.RandomTime
    local time = self.Time + (0 < rand and InteractionRand(rand, self.Cooldown, obj) or 0)
    obj:ModifyCooldown(self.Cooldown, time)
  end
end
function ModifyCooldownEffect:GetError()
  if not CooldownDefs[self.Cooldown] then
    return "No such cooldown"
  end
end
DefineClass.PlayActionFX = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "ActionFX",
      name = "ActionFX",
      editor = "combo",
      default = "",
      items = function(self)
        return PresetsPropCombo("FXPreset", "Action", "")
      end
    },
    {
      id = "ActionMoment",
      name = "ActionMoment",
      editor = "combo",
      default = "start",
      items = function(self)
        return PresetsPropCombo("FXPreset", "Moment")
      end
    }
  },
  EditorView = Untranslated("PlayFX <FX>"),
  Documentation = "PlayFX"
}
function PlayActionFX:__exec(obj, context)
  if self.ActionFX ~= "" then
    PlayFX(self.ActionFX, self.ActionMoment, obj, context)
  end
end
DefineClass.RemoveGameNotificationEffect = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "NotificationId",
      editor = "text",
      default = false
    }
  },
  EditorView = Untranslated("Remove notification <NotificationId>"),
  Documentation = "Removes the specified notification if it is present"
}
function RemoveGameNotificationEffect:__exec(obj, context)
  RemoveGameNotification(self.NotificationId)
end
function RemoveGameNotificationEffect:GetError()
  if not self.NotificationId then
    return "No notification id set"
  end
end
DefineClass.ScriptStoryBitActivate = {
  __parents = {
    "ScriptSimpleStatement"
  },
  __generated_by_class = "ScriptEffectDef",
  properties = {
    {
      id = "StoryBitId",
      name = "Id",
      editor = "preset_id",
      default = false,
      preset_class = "StoryBit"
    },
    {
      id = "NoCooldown",
      help = "Don't activate any cooldowns for subsequent StoryBit activations",
      editor = "bool",
      default = false
    },
    {
      id = "ForcePopup",
      name = "Force Popup",
      help = "Specifying true skips the notification phase, and directly displays the popup",
      editor = "bool",
      default = true
    }
  },
  EditorView = Untranslated("Activate story bit <StoryBitId>"),
  EditorName = "Activate story bit",
  EditorSubmenu = "Effects",
  Documentation = "",
  CodeTemplate = "ForceActivateStoryBit(self.StoryBitId, $self.Param1, self.ForcePopup and \"immediate\", $self.Param2, self.NoCooldown)",
  Param1Name = "obj",
  Param2Name = "context"
}
function ScriptStoryBitActivate:GetError()
  local story_bit = StoryBits[self.StoryBitId]
  if not story_bit then
    return "Invalid StoryBit preset"
  end
end
DefineClass.SelectObjectEffect = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "SelectionIsEmpty",
      name = "Only if selection is empty",
      editor = "bool",
      default = false
    },
    {
      id = "ObjNonEmpty",
      name = "Only if obj is not empty",
      editor = "bool",
      default = false
    }
  },
  EditorView = Untranslated("Select object"),
  Documentation = "Select the object"
}
function SelectObjectEffect:__exec(obj, context)
  if self.SelectionIsEmpty and SelectedObj then
    return
  end
  if self.ObjNonEmpty and not obj then
    return
  end
  SelectObj(obj)
end
DefineClass.SetCooldownEffect = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
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
    },
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
      name = "Time min",
      help = "If time is not provided the default time from the cooldown definition is used.",
      editor = "number",
      default = false,
      scale = function(self)
        return self.TimeScale
      end
    },
    {
      id = "TimeMax",
      name = "Time max",
      help = "If time is not provided the default time from the cooldown definition is used.",
      editor = "number",
      default = false,
      scale = function(self)
        return self.TimeScale
      end,
      no_edit = function(self)
        return not self.TimeMin
      end
    }
  },
  EditorView = Untranslated("Set <CooldownObj> cooldown <Cooldown>"),
  Documentation = "Sets a cooldown",
  EditorNestedObjCategory = ""
}
function SetCooldownEffect:__exec(obj, context)
  local cooldown_obj = self.CooldownObj
  if cooldown_obj == "Player" then
    obj = ResolveEventPlayer(obj, context)
  elseif cooldown_obj == "Game" then
    obj = Game
  elseif cooldown_obj == "context" then
    obj = context
  end
  if IsKindOf(obj, "CooldownObj") then
    local min, max = self.TimeMin, self.TimeMax
    local time
    if min then
      time = min
      if max then
        time = InteractionRandRange(min, max, self.Cooldown, obj)
      end
    end
    obj:SetCooldown(self.Cooldown, time)
  end
end
function SetCooldownEffect:GetError()
  if not CooldownDefs[self.Cooldown] then
    return "No such cooldown"
  end
end
DefineClass.StoryBitActivate = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "Id",
      name = "Id",
      editor = "preset_id",
      default = false,
      preset_class = "StoryBit"
    },
    {
      id = "NoCooldown",
      help = "Don't activate any cooldowns for subsequent StoryBit activations",
      editor = "bool",
      default = false
    },
    {
      id = "ForcePopup",
      name = "Force Popup",
      help = "Specifying true skips the notification phase, and directly displays the popup",
      editor = "bool",
      default = true
    },
    {
      id = "StorybitSets",
      name = "Storybit sets",
      editor = "text",
      default = "<StorybitSets>",
      dont_save = true,
      read_only = true
    },
    {
      id = "OneTime",
      editor = "bool",
      default = false,
      dont_save = true,
      read_only = true
    }
  },
  EditorView = Untranslated("\"Activate StoryBit <Id>\""),
  Documentation = "Activates a StoryBit with the specified Id",
  NoIngameDescription = true,
  EditorNestedObjCategory = "Story Bits"
}
function StoryBitActivate:GetStorybitSets()
  local preset = StoryBits[self.Id]
  if not preset or not next(preset.Sets) then
    return "None"
  end
  local items = {}
  for set in sorted_pairs(preset.Sets) do
    items[#items + 1] = set
  end
  return table.concat(items, ", ")
end
function StoryBitActivate:GetOneTime()
  local preset = StoryBits[self.Id]
  return preset and preset.OneTime
end
function StoryBitActivate:__exec(obj, context)
  ForceActivateStoryBit(self.Id, obj, self.ForcePopup and "immediate", context, self.NoCooldown)
end
DefineClass.StoryBitActivateRandom = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "StoryBits",
      help = "A list of storybits with weight. One will be chosen and activated based on weight and met prerequisites.",
      editor = "nested_list",
      default = false,
      base_class = "StoryBitWithWeight",
      all_descendants = true
    }
  },
  Documentation = "Performs a weighted random on a list of story bits and activates the one that is picked (if any)",
  EditorNestedObjCategory = "Story Bits"
}
function StoryBitActivateRandom:GetEditorView(...)
  local items = {}
  for i, item in ipairs(self.StoryBits) do
    local id = item.StoryBitId or ""
    if item.Weight then
      id = id .. " (" .. item.Weight .. ")"
    end
    items[i] = id
  end
  local names_text = next(items) and table.concat(items, ", ") or "None"
  return Untranslated(string.format("Activate random event: %s", names_text))
end
function StoryBitActivateRandom:__exec(obj, context)
  TryActivateRandomStoryBit(self.StoryBits, obj, context)
end
function StoryBitActivateRandom:GetError()
  if not next(StoryBits) then
    return
  end
  if not next(self.StoryBits) then
    return "No StoryBits to pick from "
  else
    for i, item in ipairs(self.StoryBits) do
      local id = item.StoryBitId
      if id ~= "" and not StoryBits[id] then
        return string.format("No such storybit: %s", id)
      end
    end
  end
end
DefineClass.StoryBitEnableRandom = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  properties = {
    {
      id = "StoryBits",
      name = "Story Bits",
      help = "List of StoryBit ids to pick from",
      editor = "preset_id_list",
      default = {},
      preset_class = "StoryBit",
      item_default = ""
    },
    {
      id = "Weights",
      name = "Weights",
      help = "Weights for the entries in StoryBits (default 100)",
      editor = "number_list",
      default = {},
      item_default = 100,
      items = false
    }
  },
  Documentation = "Performs a weighted random on a list of story bits and enables the one that is picked (if any)",
  EditorNestedObjCategory = "Story Bits"
}
function StoryBitEnableRandom:GetEditorView(...)
  local items = {}
  local weights = self.Weights
  for i, id in ipairs(self.StoryBits) do
    local w = weights[i]
    if w then
      id = id .. " (" .. w .. ")"
    end
    items[i] = id
  end
  local names_text = next(items) and table.concat(items, ", ") or "None"
  return Untranslated(string.format("Enable random event: %s", names_text))
end
function StoryBitEnableRandom:__exec(obj, context)
  local items = {}
  local weights = self.Weights
  local states = g_StoryBitStates
  for i, id in ipairs(self.StoryBits) do
    local state = states[id]
    if not state then
      local def = StoryBits[id]
      if def and not def.Enabled then
        local weight = weights[i] or 100
        items[#items + 1] = {id, weight}
      end
    end
  end
  local item = table.weighted_rand(items, 2)
  if not item then
    return
  end
  local id = item[1]
  local storybit = StoryBits[id]
  StoryBitState:new({
    id = id,
    object = storybit.InheritsObject and context and context.object or nil,
    player = ResolveEventPlayer(obj, context),
    inherited_title = context and context:GetTitle() or nil,
    inherited_image = context and context:GetImage() or nil
  })
end
function StoryBitEnableRandom:GetError()
  if not next(StoryBits) then
    return
  end
  if not next(self.StoryBits) then
    return "No StoryBits to pick from "
  else
    for i, id in ipairs(self.StoryBits) do
      if id ~= "" and not StoryBits[id] then
        return string.format("No such storybit: %s", id)
      end
    end
  end
end
DefineClass.ViewObjectEffect = {
  __parents = {"Effect"},
  __generated_by_class = "EffectDef",
  EditorView = Untranslated("View object"),
  Documentation = "Move the camera to view the object"
}
function ViewObjectEffect:__exec(obj, context)
  ViewObject(obj)
end
