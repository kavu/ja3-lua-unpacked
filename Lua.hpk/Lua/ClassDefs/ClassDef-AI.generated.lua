DefineClass.AIArchetype = {
  __parents = {"Preset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      category = "Execution",
      id = "Behaviors",
      editor = "nested_list",
      default = false,
      base_class = "AIBehavior"
    },
    {
      category = "Strategy",
      id = "PrefStance",
      name = "Stance Preference",
      help = "Stance to use in optimal positions",
      editor = "choice",
      default = "Standing",
      items = function(self)
        return PresetGroupCombo("CombatStance", "Default")
      end
    },
    {
      category = "Execution",
      id = "MoveStance",
      name = "Movement Stance",
      editor = "choice",
      default = "Standing",
      items = function(self)
        return PresetGroupCombo("CombatStance", "Default")
      end
    },
    {
      category = "Strategy",
      id = "OptLocSearchRadius",
      name = "Optimal Location Search Radius",
      help = "(in tiles)",
      editor = "number",
      default = 20,
      min = 1,
      max = 100
    },
    {
      category = "Strategy",
      id = "OptLocPolicies",
      name = "Optimal Location Policies",
      editor = "nested_list",
      default = false,
      base_class = "AIPositioningPolicy",
      class_filter = function(name, class, obj)
        return class.optimal_location
      end
    },
    {
      category = "Targeting",
      id = "TargetBaseScore",
      name = "Base Score Weight",
      help = "Score weight based on default attack/aiming logic and chance to hit target.",
      editor = "number",
      default = 100,
      scale = "%"
    },
    {
      category = "Targeting",
      id = "TargetScoreRandomization",
      editor = "number",
      default = 20,
      scale = "%",
      min = 0,
      max = 100
    },
    {
      category = "Targeting",
      id = "TargetingPolicies",
      name = "Additional Policies",
      help = "Additoinal targeting policies that modify target score (optional)",
      editor = "nested_list",
      default = false,
      base_class = "AITargetingPolicy"
    },
    {
      category = "Execution",
      id = "BaseAttackWeight",
      name = "Base Attack Weight",
      editor = "number",
      default = 100,
      min = 0
    },
    {
      category = "Execution",
      id = "BaseMovementWeight",
      name = "Base Movement Weight",
      editor = "number",
      default = 100,
      min = 0
    },
    {
      category = "Execution",
      id = "BaseAttackTargeting",
      help = "if any parts are set the unit will pick one of them randomly for each of its basic attacks; otherwise it will always use the default (torso) attacks",
      editor = "set",
      default = false,
      items = function(self)
        return table.keys2(Presets.TargetBodyPart.Default)
      end
    },
    {
      category = "Execution",
      id = "TargetChangePolicy",
      help = "Defines the way the unit handles a stituation where the intended attack target is no longer valid (e.g. dead or Downed). \"restart\" will force a complete reevaluation of the unit's turn, allowing them to perform additional movement if necessary, while \"recalc\" will only recalculate potential targets from the current position (default behavior).",
      editor = "choice",
      default = "recalc",
      items = function(self)
        return {"recalc", "restart"}
      end
    },
    {
      category = "Execution",
      id = "FallbackAction",
      name = "Fallback Action",
      help = "Defines the way the unit reacts when the AI didn't find anything to do in its turn. By default units will revert to their Unaware status. If this is set to something else, the unit will first attempt to do the chosen action and still revert to Unaware if it fails to do so.",
      editor = "choice",
      default = "revert",
      items = function(self)
        return {"revert", "overwatch"}
      end
    },
    {
      category = "Execution",
      id = "SignatureActions",
      name = "Signature Actions",
      editor = "nested_list",
      default = false,
      base_class = "AISignatureAction",
      class_filter = function(name, class, obj)
        return not class.hidden
      end
    }
  },
  GlobalMap = "Archetypes",
  EditorIcon = "CommonAssets/UI/Icons/calculator",
  EditorMenubar = "Combat"
}
DefineClass.AIBaseHealPolicy = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "MaxHp",
      name = "Max Hit Points",
      help = "Percentage of max HP under which allies are considered as targets for healing.",
      editor = "number",
      default = 70,
      scale = "%",
      min = 0,
      max = 100
    },
    {
      id = "BleedingWeight",
      name = "Bleeding Weight",
      help = "amount added to score if the target unit has Bleeding",
      editor = "number",
      default = 30,
      min = 0
    },
    {
      id = "HpWeight",
      name = "Missing Hp Weight",
      help = "missing hp percent converts to score at this rate",
      editor = "number",
      default = 100,
      scale = "%",
      min = 0
    },
    {
      id = "SelfHealMod",
      name = "Self Heal Modifier",
      help = "multiplies the result score when targeting the same unit",
      editor = "number",
      default = 50,
      scale = "%",
      min = 0
    },
    {
      id = "CanUseMod",
      name = "Can Use Mod",
      help = "modifier applied if the heal action can be used this turn",
      editor = "number",
      default = 100
    }
  }
}
DefineClass.AICChanceToHit = {
  __parents = {
    "AIConsideration"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Range",
      editor = "range",
      default = range(1, 100),
      min = 0,
      max = 100
    }
  },
  Name = T(706047359198, "Chance to hit is <percent(RangeText)>"),
  ComboFormat = T(774449858743, "Chance to hit")
}
function AICChanceToHit:Score(obj, context)
  return obj:CalcChanceToHit(context.target, self)
end
DefineClass.AICMyDistanceTo = {
  __parents = {
    "AIConsideration"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Target",
      editor = "combo",
      default = "target",
      items = function(self)
        return {"target"}
      end
    },
    {
      id = "Range",
      editor = "range",
      default = range(0, 0),
      min = 0,
      max = 1000000
    }
  },
  Name = Untranslated("My distance to <Target> is <RangeText>"),
  ComboFormat = Untranslated("My distance to ...")
}
function AICMyDistanceTo:Score(obj, context)
  local target = context.target
  if not target then
    return 0
  end
  local distance = obj:GetDist(target)
  local min = self.Range.from
  local max = self.Range.to
  if distance < min then
    return 0
  elseif distance >= max then
    return 100
  end
  return MulDiv(100, distance - min, max - min)
end
DefineClass.AICMyStatusEffect = {
  __parents = {
    "AIConsideration"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Effect",
      editor = "preset_id",
      default = false,
      preset_class = "CharacterEffectCompositeDef"
    },
    {
      id = "Status",
      editor = "choice",
      default = "on",
      items = function(self)
        return {"on", "off"}
      end
    }
  },
  Name = Untranslated("My status <Effect> is <Status>"),
  ComboFormat = Untranslated("My status effect")
}
function AICMyStatusEffect:Score(obj, context)
  return obj:HasStatusEffect(id) and 100 or 0
end
DefineClass.AIConsideration = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  Name = "",
  ComboFormat = T(470337975431, "<class>")
}
function AIConsideration:Score(obj, context)
  return 0
end
function AIConsideration:GetEditorView()
  return Untranslated("<Name>")
end
function AIConsideration:GetRangeText()
  return T({
    570065600041,
    "[<min> - <max>]",
    min = self.Range.from,
    max = self.Range.to
  })
end
DefineClass.AIPolicyAttackAP = {
  __parents = {
    "AIPositioningPolicy"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "end_of_turn",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    }
  }
}
function AIPolicyAttackAP:EvalDest(context, dest, grid_voxel)
  local unit = context.unit
  local ap = context.dest_ap[dest] or 0
  return ap > context.default_attack_cost and 100 or 0
end
DefineClass.AIPolicyDealDamage = {
  __parents = {
    "AIPositioningPolicy"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "end_of_turn",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "CheckLOS",
      editor = "bool",
      default = true
    }
  }
}
function AIPolicyDealDamage:GetEditorView()
  return string.format("Deal Damage (%s)", self.CheckLOS and "w/ LOS" or "w/o LOS")
end
function AIPolicyDealDamage:EvalDest(context, dest, grid_voxel)
  if self.CheckLOS and not g_AIDestEnemyLOSCache[dest] then
    return 0
  end
  return context.dest_target_score[dest] or 0
end
DefineClass.AIPolicyDistanceFromStart = {
  __parents = {
    "AIPositioningPolicy"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "end_of_turn",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "optimal_location",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "Away",
      editor = "bool",
      default = true
    },
    {
      id = "Distance",
      help = "in tiles",
      editor = "number",
      default = 5,
      min = 0
    }
  }
}
function AIPolicyDistanceFromStart:EvalDest(context, dest, grid_voxel)
  local upos = context.unit_stance_pos
  local threshold = self.Distance * const.SlabSizeX
  local dist = stance_pos_dist(dest, upos)
  if self.Away and threshold <= dist then
    return self.Weight
  elseif not self.Away and threshold >= dist then
    return self.Weight
  end
  return 0
end
function AIPolicyDistanceFromStart:GetEditorView()
  if self.Away then
    return string.format("Be %d tiles away from starting location", self.Distance)
  else
    return string.format("Be no more than %d tiles away from starting location", self.Distance)
  end
end
DefineClass.AIPolicyEvadeEnemies = {
  __parents = {
    "AIPositioningPolicy"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "RangeBase",
      name = "Preferred Range (Base)",
      editor = "combo",
      default = "Effective",
      items = function(self)
        return {"Weapon", "Absolute"}
      end
    },
    {
      id = "Range",
      name = "Minimum Range",
      help = "Percent of base preferred range",
      editor = "number",
      default = 80,
      min = 0,
      max = 1000
    },
    {
      id = "optimal_location",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "end_of_turn",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    }
  }
}
function AIPolicyEvadeEnemies:GetEditorView()
  if self.RangeBase == "Absolute" then
    return string.format("Keep enemies farther than %d tiles", self.Range)
  end
  return string.format("Keep enemies farther than %d%% of weapon range", self.RangeBase)
end
function AIPolicyEvadeEnemies:EvalDest(context, dest, grid_voxel)
  local x, y, z = point_unpack(grid_voxel)
  local base_range = self.RangeBase == "Effective" and context.EffectiveRange or context.ExtremeRange
  local range = MulDivRound(self.Range, base_range, 100)
  local enemy_in_range
  for _, enemy in ipairs(context.enemies) do
    enemy_in_range = enemy_in_range or AIRangeCheck(context, grid_voxel, enemy, context.enemy_grid_voxel[enemy], self.RangeBase, false, self.Range)
  end
  return enemy_in_range and 0 or 100
end
DefineClass.AIPolicyFlanking = {
  __parents = {
    "AIPositioningPolicy"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "end_of_turn",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "AllyPlannedPosition",
      help = "consider allies being on their destination positions instead of their current ones (when available)",
      editor = "bool",
      default = false
    },
    {
      id = "ReserveAttackAP",
      name = "Reserve Attack AP",
      help = "do not consider locations where the unit will be out of ap and couldn't attack",
      editor = "bool",
      default = false
    },
    {
      id = "optimal_location",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    }
  }
}
function AIPolicyFlanking:EvalDest(context, dest, grid_voxel)
  local unit = context.unit
  local ap = context.dest_ap[dest] or 0
  if self.ReserveAttackAP and ap < context.default_attack_cost then
    return 0
  end
  if not context.position_override then
    context.position_override = {}
    if self.AllyPlannedPosition then
      for _, ally in ipairs(unit.team.units) do
        local dest = ally.ai_context and ally.ai_context.ai_destination
        if dest then
          local x, y, z = stance_pos_unpack(dest)
          context.position_override[ally] = point(x, y, z)
        end
      end
    end
  end
  local x, y, z = stance_pos_unpack(dest)
  context.position_override[unit] = point(x, y, z)
  if not context.enemy_surrounded then
    context.enemy_surrounded = {}
    for _, enemy in ipairs(context.enemies) do
      if enemy:IsSurrounded() then
        context.enemy_surrounded[enemy] = true
      end
    end
  end
  local delta = 0
  for _, enemy in ipairs(context.enemies) do
    local new_surrounded = enemy:IsSurrounded(context.position_override)
    if new_surrounded and not context.enemy_surrounded[enemy] then
      delta = delta + 1
    elseif not new_surrounded and context.enemy_surrounded[enemy] then
      delta = delta - 1
    end
  end
  return delta * self.Weight
end
DefineClass.AIPolicyHealingRange = {
  __parents = {
    "AIPositioningPolicy",
    "AIBaseHealPolicy"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "optimal_location",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "end_of_turn",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    }
  }
}
function AIPolicyHealingRange:GetEditorView()
  return string.format("Be in range to heal allies under %d%% HP", self.MaxHp)
end
function AIPolicyHealingRange:EvalDest(context, dest, grid_voxel)
  local target, score = AISelectHealTarget(context, dest, grid_voxel, self)
  return score or 0
end
DefineClass.AIPolicyHighGround = {
  __parents = {
    "AIPositioningPolicy"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "optimal_location",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    }
  }
}
function AIPolicyHighGround:EvalDest(context, dest, grid_voxel)
  local ux, uy, uz = point_unpack(context.unit_grid_voxel)
  local x, y, z = point_unpack(grid_voxel)
  return self.Weight * (z - uz)
end
DefineClass.AIPolicyIndoorsOutdoors = {
  __parents = {
    "AIPositioningPolicy"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "end_of_turn",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "optimal_location",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "Indoors",
      editor = "bool",
      default = true
    }
  }
}
function AIPolicyIndoorsOutdoors:GetEditorView()
  return self.Indoors and "Be Indoors" or "Be Outdoors"
end
function AIPolicyIndoorsOutdoors:EvalDest(context, dest, grid_voxel)
  return AICheckIndoors(dest) == self.Indoors
end
DefineClass.AIPolicyLastEnemyPos = {
  __parents = {
    "AIPositioningPolicy"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "optimal_location",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "end_of_turn",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    }
  }
}
function AIPolicyLastEnemyPos:EvalDest(context, dest, grid_voxel)
  local last_pos = context.unit.last_known_enemy_pos
  if not last_pos then
    return 0
  end
  local dist = context.unit:GetDist(last_pos)
  local dx, dy, dz = stance_pos_unpack(dest)
  if dist == 0 then
    return last_pos:Dist(dx, dy, dz) == 0 and self.Weight or 0
  end
  return self.Weight - MulDivRound(last_pos:Dist(dx, dy, dz), self.Weight, dist)
end
DefineClass.AIPolicyLosToEnemy = {
  __parents = {
    "AIPositioningPolicy"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "optimal_location",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "end_of_turn",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "Invert",
      editor = "bool",
      default = false
    }
  }
}
function AIPolicyLosToEnemy:EvalDest(context, dest, grid_voxel)
  local los = g_AIDestEnemyLOSCache[dest]
  if self.Invert then
    return g_AIDestEnemyLOSCache[dest] and 0 or 100
  end
  return g_AIDestEnemyLOSCache[dest] and 100 or 0
end
function AIPolicyLosToEnemy:GetEditorView()
  if self.Invert then
    return "Do not have LOS to enemies"
  end
  return "Have LOS to enemies"
end
DefineClass.AIPolicyProximity = {
  __parents = {
    "AIPositioningPolicy"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "end_of_turn",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "AllyPlannedPosition",
      help = "consider allies being on their destination positions instead of their current ones (when available)",
      editor = "bool",
      default = false,
      no_edit = function(self)
        return self.TargetUnits ~= "allies"
      end
    },
    {
      id = "TargetUnits",
      name = "TargetUnits",
      editor = "choice",
      default = "enemies",
      items = function(self)
        return {"allies", "enemies"}
      end
    },
    {
      id = "TargetDist",
      name = "Target Distance",
      help = "which distance (in tiles) is used to score the target location",
      editor = "choice",
      default = "min",
      items = function(self)
        return {
          "min",
          "average",
          "total"
        }
      end
    },
    {
      id = "MinScore",
      help = "scores below this will result in zero evaluation for this location",
      editor = "number",
      default = 0,
      min = 0
    },
    {
      id = "optimal_location",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    }
  }
}
function AIPolicyProximity:EvalDest(context, dest, grid_voxel)
  local unit = context.unit
  local target_enemies = self.TargetUnits == "enemies"
  local units = target_enemies and context.enemies or context.allies
  local tdist = self.TargetDist
  local score = 0
  local num = 0
  local scale = const.SlabSizeX
  for _, other in ipairs(units) do
    if other ~= unit then
      local upos
      if target_enemies then
        upos = context.enemy_pack_pos_stance[other]
      else
        upos = context.ally_pack_pos_stance[other]
        upos = self.AllyPlannedPosition and other.ai_context and other.ai_context.ai_destination or upos
      end
      local dist = stance_pos_dist(dest, upos) / scale
      if tdist == "total" or tdist == "average" then
        score = score + dist
      elseif not score or dist < score then
        score = dist
      end
    end
  end
  if tdist == "average" and 0 < num then
    score = score / num
  end
  return score >= self.MinScore and score or 0
end
DefineClass.AIPolicyStimRange = {
  __parents = {
    "AIPositioningPolicy"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "optimal_location",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "end_of_turn",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "Rules",
      editor = "nested_list",
      default = false,
      base_class = "AIStimRule",
      inclusive = true
    },
    {
      id = "CanTargetSelf",
      editor = "bool",
      default = false
    }
  }
}
function AIPolicyStimRange:GetEditorView()
  return string.format("Be in range to heal allies under %d%% HP", self.MaxHp)
end
function AIPolicyStimRange:EvalDest(context, dest, grid_voxel)
  context.voxel_stim_score = context.voxel_stim_score or {}
  if context.voxel_stim_score[grid_voxel] then
    return context.voxel_stim_score[grid_voxel]
  end
  local x, y, z = stance_pos_unpack(dest)
  local ppos = point_pack(x, y, z)
  local score, target
  local unit = context.unit
  if self.CanTargetSelf then
    score = AIEvalStimTarget(unit, unit, self.Rules)
    target = 0 < score and unit
  end
  for _, ally in ipairs(context.allies) do
    if IsMeleeRangeTarget(unit, ppos, nil, ally) then
      local ally_score = AIEvalStimTarget(unit, ally, self.Rules)
      if score < ally_score then
        score, target = ally_score, ally
      elseif ally_score == score and unit:GetDist(target) > unit:GetDist(ally) then
        score, target = ally_score, ally
      end
    end
  end
  score = MulDivRound(score, self.Weight, 100)
  context.voxel_stim_score[grid_voxel] = score
  return score
end
DefineClass.AIPolicyTakeCover = {
  __parents = {
    "AIPositioningPolicy"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "end_of_turn",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "optimal_location",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "visibility_mode",
      name = "Visibility Mode",
      editor = "choice",
      default = "self",
      items = function(self)
        return {
          "self",
          "team",
          "all"
        }
      end
    }
  }
}
function AIPolicyTakeCover:EvalDest(context, dest, grid_voxel)
  local score = 0
  local tbl = context.enemies or empty_table
  for _, enemy in ipairs(tbl) do
    local visible = true
    if self.visibility_mode == "self" then
      visible = context.enemy_visible[enemy]
    elseif self.visibility_mode == "team" then
      visible = context.enemy_visible_by_team[enemy]
    end
    if visible then
      local cover = GetCoverFrom(dest, context.enemy_pack_pos_stance[enemy])
      score = score + self.CoverScores[cover]
    end
  end
  return score / Max(1, #tbl)
end
function AIPolicyTakeCover:GetEditorView()
  return "Seek Cover"
end
AIPolicyTakeCover.CoverScores = {
  [const.CoverPass] = 0,
  [const.CoverNone] = 0,
  [const.CoverLow] = 50,
  [const.CoverHigh] = 100
}
DefineClass.AIPolicyWeaponRange = {
  __parents = {
    "AIPositioningPolicy"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "EnvState",
      name = "Environmental State",
      editor = "set",
      default = false,
      three_state = true,
      items = function(self)
        return AIEnvStateCombo
      end
    },
    {
      id = "RangeBase",
      name = "Preferred Range (Base)",
      editor = "combo",
      default = "Weapon",
      items = function(self)
        return {
          "Melee",
          "Weapon",
          "Absolute"
        }
      end
    },
    {
      id = "RangeMin",
      name = "Preferred Range (Min)",
      help = "Percent of base preferred range",
      editor = "number",
      default = 80,
      no_edit = function(self)
        return self.RangeBase == "Melee"
      end,
      min = 0,
      max = 1000
    },
    {
      id = "RangeMax",
      name = "Preferred Range (Max)",
      help = "Percent of base preferred range",
      editor = "number",
      default = 120,
      no_edit = function(self)
        return self.RangeBase == "Melee"
      end,
      min = 0,
      max = 1000
    },
    {
      id = "DownedWeightModifier",
      name = "Downed Enemy Weight Modifier",
      editor = "number",
      default = 5,
      scale = "%",
      min = 0
    },
    {
      id = "optimal_location",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "end_of_turn",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    }
  }
}
function AIPolicyWeaponRange:GetEditorView()
  if self.RangeBase == "Melee" then
    return "Be in Melee range"
  elseif self.RangeBase == "Absolute" then
    return string.format("Be in %d to %d tiles range", self.RangeMin, self.RangeMax)
  end
  return string.format("Be in %d%% to %d%% of weapon range", self.RangeMin, self.RangeMax)
end
function AIPolicyWeaponRange:EvalDest(context, dest, grid_voxel)
  for state, value in pairs(self.EnvState) do
    if value ~= not not GameState[state] then
      return 0
    end
  end
  local enemy_grid_voxel = context.enemy_grid_voxel
  local range_type = self.RangeBase
  local range_min = self.RangeMin
  local range_max = self.RangeMax
  local weight = 0
  for _, enemy in ipairs(context.enemies) do
    if AIRangeCheck(context, grid_voxel, enemy, enemy_grid_voxel[enemy], range_type, range_min, range_max) then
      if enemy:IsIncapacitated() then
        weight = self.DownedWeightModifier
      else
        return 100
      end
    end
  end
  return weight
end
DefineClass.AIPositioningPolicy = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "optimal_location",
      editor = "bool",
      default = false,
      read_only = true,
      no_edit = true
    },
    {
      id = "end_of_turn",
      editor = "bool",
      default = false,
      read_only = true,
      no_edit = true
    },
    {
      id = "RequiredKeywords",
      editor = "string_list",
      default = {},
      template = true,
      item_default = "",
      items = function(self)
        return AIKeywordsCombo
      end,
      arbitrary_value = true
    },
    {
      id = "Weight",
      editor = "number",
      default = 100,
      scale = "%"
    },
    {
      id = "Required",
      editor = "bool",
      default = false
    }
  }
}
function AIPositioningPolicy:EvalDest(context, dest, grid_voxel)
end
function AIPositioningPolicy:GetEditorView()
  return self.class
end
function AIPositioningPolicy:MatchUnit(unit)
  for _, keyword in ipairs(self.RequiredKeywords) do
    if not table.find(unit.AIKeywords or empty_table, keyword) then
      return
    end
  end
  return true
end
DefineClass.AIRetreatPolicy = {
  __parents = {
    "AIPositioningPolicy"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "optimal_location",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "end_of_turn",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "Weight",
      editor = "number",
      default = 100,
      scale = "%"
    },
    {
      id = "Required",
      editor = "bool",
      default = true
    }
  }
}
function AIRetreatPolicy:EvalDest(context, dest, grid_voxel)
  local vx, vy = point_unpack(grid_voxel)
  local markers = context.entrance_markers or MapGetMarkers("Entrance")
  context.entrance_markers = markers
  local score = 0
  for _, marker in ipairs(markers) do
    context.entrance_marker_dir = context.entrance_marker_dir or {}
    local marker_dir = context.entrance_marker_dir[marker]
    if not marker_dir then
      marker_dir = marker:GetVisualPos() - context.unit:GetVisualPos()
      marker_dir = SetLen(marker_dir:SetZ(0), guim)
      context.entrance_marker_dir[marker] = marker_dir
    end
    if marker:IsVoxelInsideArea(vx, vy) then
      for _, enemy_dir in pairs(context.enemy_dir) do
        local dot = Dot2D(marker_dir, enemy_dir) / guim
        score = score + guim - dot
      end
    end
  end
  return score / Max(1, #(context.enemies or empty_table))
end
function AIRetreatPolicy:GetEditorView()
  return "Retreat"
end
DefineClass.AITargetingCancelShot = {
  __parents = {
    "AITargetingPolicy"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "BaseScore",
      name = "Base Score",
      help = "score for valid targets who are not threatening an ally",
      editor = "number",
      default = 100
    },
    {
      id = "AllyThreatenedScore",
      name = "Threatened Score",
      help = "score for valid targets who are threatening an ally",
      editor = "number",
      default = 100
    }
  }
}
function AITargetingCancelShot:GetEditorView()
  return "Use CancelShot"
end
function AITargetingCancelShot:EvalTarget(unit, target)
  if not target:HasPreparedAttack() and not target:CanActivatePerk("MeleeTraining") then
    return 0
  end
  local enemies = {target}
  for _, ally in ipairs(unit.team.units) do
    if ally:IsThreatened(enemies) then
      return self.AllyThreatenedScore
    end
  end
  return self.BaseScore
end
DefineClass.AITargetingEnemyHealth = {
  __parents = {
    "AITargetingPolicy"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Score",
      editor = "number",
      default = 100
    },
    {
      id = "Health",
      editor = "number",
      default = 100,
      scale = "%",
      min = 1,
      max = 100
    },
    {
      id = "AboveHealth",
      editor = "bool",
      default = false
    }
  }
}
function AITargetingEnemyHealth:GetEditorView()
  if self.AboveHealth then
    return string.format("Enemy health >= %d%%", self.Health)
  end
  return string.format("Enemy health <= %d%%", self.Health)
end
function AITargetingEnemyHealth:EvalTarget(unit, target)
  local health_perc = MulDivRound(target.HitPoints, 100, target.MaxHitPoints)
  if self.AboveHealth then
    return health_perc >= self.Health and self.Score or 0
  end
  return health_perc <= self.Health and self.Score or 0
end
DefineClass.AITargetingEnemyWeapon = {
  __parents = {
    "AITargetingPolicy"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Score",
      editor = "number",
      default = 100
    },
    {
      id = "EnemyWeapon",
      editor = "choice",
      default = "AssaultRifle",
      items = function(self)
        return AIEnemyWeaponsCombo()
      end
    }
  }
}
function AITargetingEnemyWeapon:GetEditorView()
  if self.EnemyWeapon == "Unarmed" then
    return "Unarmed enemies"
  end
  return string.format("Enemies armed with %s", self.EnemyWeapon)
end
function AITargetingEnemyWeapon:EvalTarget(unit, target)
  if self.EnemyWeapon == "Unarmed" then
    if not target:GetActiveWeapons() then
      return self.Score
    end
  elseif g_Classes[self.EnemyWeapon] then
    if target:GetActiveWeapons(self.EnemyWeapon) then
      return self.Score
    end
  else
    local _, _, list = target:GetActiveWeapons("Firearm")
    for _, item in ipairs(list) do
      if item.WeaponType == self.EnemyWeapon then
        return self.Score
      end
    end
  end
  return 0
end
DefineClass.AITargetingPolicy = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Weight",
      editor = "number",
      default = 100,
      scale = "%"
    }
  }
}
function AITargetingPolicy:GetEditorView()
  return self.class
end
function AITargetingPolicy:EvalTarget(unit, target)
end
