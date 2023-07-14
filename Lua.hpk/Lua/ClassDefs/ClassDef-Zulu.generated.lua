DefineClass.AnimParams = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "UseWeapons",
      name = "Use Weapons",
      help = "Use weapon animations while executing this behavior.",
      editor = "bool",
      default = false
    },
    {
      id = "Running",
      help = "Controls the use of running or walking animations while executing this behavior.",
      editor = "bool",
      default = false
    },
    {
      id = "IdleStance",
      name = "Idle Stance",
      help = "What to do with the idle stance",
      editor = "combo",
      default = "do not change",
      items = function(self)
        return GetIdleAnimStances(self.UseWeapons)
      end
    },
    {
      id = "IdleAction",
      name = "Idle Action",
      help = "What to do with the idle action",
      editor = "combo",
      default = "do not change",
      items = function(self)
        return GetIdleAnimStanceActions(self.UseWeapons, self.IdleStance)
      end
    },
    {
      id = "RestoreDefault",
      name = "Restore Default",
      help = "Restore to default behavior",
      editor = "bool",
      default = false
    }
  }
}
function AnimParams:GetAnimParams()
  if self.RestoreDefault then
    return {}
  else
    return {
      move_anim = not self.Running and "Walk" or "Run",
      weapon_anim_prefix = not self.UseWeapons and "civ_" or nil,
      idle_stance = self.IdleStance and self.IdleStance ~= "do not change" and self.IdleStance or nil,
      idle_action = self.IdleAction and self.IdleAction ~= "do not change" and self.IdleAction or nil
    }
  end
end
function AnimParams:OnEditorSetProperty(prop_id, old_value, ged)
  if prop_id == "IdleStance" then
    local actions = GetIdleAnimStanceActions(self.UseWeapons, self.IdleStance)
    if not table.find(actions, self.IdleAction) then
      self:SetProperty("IdleAction", actions[1])
    end
  end
end
DefineClass.BanterLine = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Annotation",
      name = "Annotation",
      help = "Extra context for voice actors, e.g. \"angry\", \"sad\", etc.",
      editor = "text",
      default = false
    },
    {
      id = "MultipleTexts",
      editor = "bool",
      default = false
    },
    {
      id = "Character",
      name = "Character",
      editor = "combo",
      default = "any",
      no_edit = function(self)
        return self.MultipleTexts
      end,
      items = function(self)
        return GetTargetUnitCombo()
      end
    },
    {
      id = "AnimationStyle",
      name = "Animation Style",
      editor = "choice",
      default = false,
      items = function(self)
        return GetIdleStyleCombo(g_Classes[self.Character] and g_Classes[self.Character].gender)
      end
    },
    {
      id = "Text",
      editor = "text",
      default = false,
      no_edit = function(self)
        return self.MultipleTexts
      end,
      translate = true,
      wordwrap = true,
      lines = 4,
      max_lines = 6,
      context = BanterLineContext()
    },
    {
      id = "AnyOfTheseCount",
      name = "Play Any Of List Count",
      editor = "number",
      default = 1,
      no_edit = function(self)
        return not self.MultipleTexts
      end
    },
    {
      id = "AnyOfThese",
      name = "Play Any Of List",
      editor = "nested_list",
      default = false,
      no_edit = function(self)
        return not self.MultipleTexts
      end,
      base_class = "BanterLineThin"
    },
    {
      id = "Voiced",
      help = "Whether the banter is voiced.",
      editor = "bool",
      default = true
    },
    {
      id = "useSnype",
      name = "Use Snype",
      help = "The banter will appear as a UI element on Snype rather than above the character's model.",
      editor = "bool",
      default = false
    },
    {
      id = "asVR",
      name = "As VR",
      help = "The banter will appear as a subtitled VR.",
      editor = "bool",
      default = false
    },
    {
      id = "Optional",
      name = "Optional",
      help = "Optional lines don't report missing actors and include actors around the source regardless of whether were passed in.",
      editor = "bool",
      default = false,
      no_edit = function(self)
        return self.MultipleTexts
      end
    },
    {
      id = "FloatUp",
      name = "FloatUp",
      help = "Float up like floating text, rather than staying in place like banter text.",
      editor = "bool",
      default = false
    },
    {
      id = "playOnce",
      name = "Once Per Actor",
      help = "This line will be played only once per unit. If optional this line will be skipped. In banters with no other lines, or if the other lines are disabled, the whole banter will be skipped by the PlayBanterEffect.",
      editor = "bool",
      default = false
    },
    {
      id = "btnTestLine",
      editor = "buttons",
      default = false,
      buttons = {
        {
          name = "Test Line",
          func = "EditorTestBanterLine"
        }
      },
      template = true
    }
  }
}
function BanterLine:GetPropertyMetadata(prop)
  local prop_meta = PropertyObject.GetPropertyMetadata(self, prop)
  if prop == "Text" and not self.Voiced then
    prop_meta = SubContext(prop_meta, {context = false})
  end
  return prop_meta
end
function BanterLine:GetWarning()
  if not self.Text and not self.AnyOfThese then
    return "Banter line without text!"
  end
  if self.Voiced then
    if self.MultipleTexts then
      for _, line in ipairs(self.AnyOfThese) do
        if g_AnyUnitGroups[line.Character] then
          return string.format("Banters for '%s' character can't be voiced", line.Character)
        end
      end
    elseif g_AnyUnitGroups[self.Character] then
      return string.format("Banters for '%s' character can't be voiced", self.Character)
    end
  end
  if self.Character == "current unit" then
    return "Current unit is not supported as a banter actor"
  end
  if not self.MultipleTexts and next(self.AnyOfThese) then
    return "Hidden lines in property Play Any Of These won't be played - check MultipleTexts to see (and delete) them"
  end
end
function BanterLine:GetEditorView()
  if self.MultipleTexts then
    local toPlay = self.AnyOfTheseCount
    local total = #(self.AnyOfThese or empty_table)
    local chars = {}
    for i, line in ipairs(self.AnyOfThese) do
      chars[#chars + 1] = Untranslated(line.Character)
    end
    chars = table.concat(chars, ", ")
    return T({
      595004298903,
      "Play <toPlay> of <total> lines. <chars>",
      toPlay = toPlay,
      total = total,
      chars = chars
    })
  end
  if not self.Text then
    return Untranslated("No Text")
  end
  local text = _InternalTranslate(self.Text)
  local long = 50 < #text
  text = text:gsub("%\n", "")
  text = utf8.sub(text, 1, 50)
  if long then
    text = text .. "..."
  end
  return T({
    965627915065,
    "<u(Character)>: <u(Text)>",
    Character = self.Character,
    Text = text
  })
end
DefineClass.BanterLineThin = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Character",
      name = "Character",
      editor = "combo",
      default = "any",
      no_edit = function(self)
        return self.IsInterjection
      end,
      items = function(self)
        return GetTargetUnitCombo()
      end
    },
    {
      id = "Text",
      editor = "text",
      default = false,
      no_edit = function(self)
        return self.IsInterjection
      end,
      translate = true,
      wordwrap = true,
      lines = 4,
      max_lines = 6,
      context = BanterLineThinContext()
    }
  }
}
function BanterLineThin:GetWarning()
  if not self.Text then
    return "Banter line without text!"
  end
end
function BanterLineThin:GetEditorView()
  if not self.Text then
    return Untranslated("No Text")
  end
  local text = _InternalTranslate(self.Text)
  local long = 50 < #text
  text = text:gsub("%\n", "")
  text = utf8.sub(text, 1, 50)
  if long then
    text = text .. "..."
  end
  return T({
    965627915065,
    "<u(Character)>: <u(Text)>",
    Character = self.Character,
    Text = text
  })
end
DefineClass.Butterflies = {
  __parents = {
    "DecorStateFXObjectNoSound"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "DecorStateFXObject",
      id = "ActivationRequiredStates",
      name = "States Required for Activation",
      editor = "set",
      default = set({
        Night = false,
        RainHeavy = false,
        RainLight = false
      }),
      three_state = true,
      items = function(self)
        return GetGameStateFilter()
      end,
      buttons = {
        {
          name = "Check Game States",
          func = "PropertyDefGameStatefSetCheck"
        }
      }
    }
  },
  Preset = "Butterflies_Blue",
  particles_pattern = "Butterflies",
  place_category = "Effects",
  place_name = "DecorFX_Butterflies"
}
DefineClass.CharacterEffectProperties = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Conditions",
      id = "Conditions",
      help = "Conditions specifying whether or not the effect can be applied to a given unit at the moment.",
      editor = "nested_list",
      default = false,
      template = true,
      base_class = "Condition",
      inclusive = true
    },
    {
      category = "Modifiers",
      id = "Modifiers",
      help = "Numerical modifiers applied by the Status Effect to the affected Unit.",
      editor = "nested_list",
      default = false,
      template = true,
      base_class = "UnitModifier"
    },
    {
      id = "DisplayName",
      editor = "text",
      default = false,
      template = true,
      translate = true
    },
    {
      id = "Description",
      editor = "text",
      default = false,
      template = true,
      translate = true,
      wordwrap = true,
      lines = 4,
      max_lines = 10
    },
    {
      id = "GetDescription",
      editor = "func",
      default = function(self)
        return self.Description
      end,
      template = true
    },
    {
      id = "AddEffectText",
      help = "The merc object will be passed as context, use proper tags",
      editor = "text",
      default = false,
      template = true,
      translate = true
    },
    {
      id = "RemoveEffectText",
      help = "The merc object will be passed as context, use proper tags",
      editor = "text",
      default = false,
      template = true,
      translate = true
    },
    {
      category = "Effect",
      id = "type",
      name = "Type",
      help = [[
"System" effects are not either Positive or Negative for the sake of other features interacting with only Positive or Negative effects.
"Buff" - something Positive
"Debuff" - something Negative]],
      editor = "combo",
      default = "System",
      template = true,
      items = function(self)
        return {
          "System",
          "Buff",
          "Debuff",
          "AttackBased"
        }
      end
    },
    {
      category = "Effect",
      id = "lifetime",
      name = "Lifetime",
      editor = "choice",
      default = "Indefinite",
      template = true,
      items = function(self)
        return {
          "Indefinite",
          "Until End of Turn",
          "Until End of Next Turn"
        }
      end
    },
    {
      category = "Effect",
      id = "CampaignTimeAdded",
      editor = "number",
      default = 0,
      read_only = true,
      no_edit = true,
      template = true
    },
    {
      id = "Icon",
      editor = "ui_image",
      default = false,
      template = true
    },
    {
      category = "Effect",
      id = "max_stacks",
      editor = "number",
      default = 1,
      template = true,
      min = 1
    },
    {
      category = "Effect",
      id = "stacks",
      editor = "number",
      default = 1,
      read_only = true,
      no_edit = true,
      template = true,
      min = 1
    },
    {
      category = "Effect",
      id = "RemoveOnEndCombat",
      name = "Auto-remove on combat end",
      editor = "bool",
      default = false,
      template = true
    },
    {
      category = "Effect",
      id = "RemoveOnSatViewTravel",
      name = "Auto-remove on Satellite View Travel",
      editor = "bool",
      default = false,
      template = true
    },
    {
      category = "Effect",
      id = "RemoveOnCampaignTimeAdvance",
      name = "Auto-remove on Campaign Time Advance",
      help = "For map only effects",
      editor = "bool",
      default = false,
      template = true
    },
    {
      category = "Effect",
      id = "dontRemoveOnDeath",
      name = "Don't Remove On Death",
      editor = "bool",
      default = false,
      template = true
    },
    {
      id = "InstParameters",
      editor = "nested_list",
      default = false,
      base_class = "PresetParam"
    },
    {
      id = "HasParameters",
      editor = "bool",
      default = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "Shown",
      help = "Whether the status effect is shown in the UI or it is for internal use only.",
      editor = "bool",
      default = false,
      template = true
    },
    {
      id = "ShownSatelliteView",
      help = "Whether the status effect is shown in the satellite view UI",
      editor = "bool",
      default = false,
      template = true
    },
    {
      id = "HideOnBadge",
      name = "HideOnBadge",
      help = "Whether the status effect is hidden on the combat badge, beneath the healthbar.",
      editor = "bool",
      default = false,
      template = true
    },
    {
      id = "HasFloatingText",
      help = "Whether the status effects shows floating text when it is added or removed.",
      editor = "bool",
      default = false,
      template = true
    }
  }
}
function CharacterEffectProperties:SetParameter(name, value)
  self.InstParameters = self.InstParameters or {}
  for _, item in ipairs(self.InstParameters) do
    if item.Name == name then
      item.Value = value
      return
    end
  end
  table.insert(self.InstParameters, {Name = name, Value = value})
end
function CharacterEffectProperties:ClonePropertyValue(value, prop_meta)
  if prop_meta.id == "InstParameters" then
    local new_value = table.copy(value, "deep")
    return new_value
  end
  return PropertyObject.ClonePropertyValue(self, value, prop_meta)
end
DefineClass.ConditionalLoot = {
  __parents = {
    "ConditionalSpawn"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Spawn Object",
      id = "ItemId",
      name = "Inventory Item Id",
      editor = "preset_id",
      default = false,
      preset_class = "InventoryItemCompositeDef"
    },
    {
      category = "Spawn Object",
      id = "LootTableId",
      name = "Loot Table Id",
      editor = "preset_id",
      default = false,
      preset_class = "LootDef"
    }
  }
}
function ConditionalLoot:SpawnObjects(container)
  if not rawget(self, "objects") then
    rawset(self, "objects", false)
  end
  if self.objects then
    return
  end
  self.objects = {}
  if self.ItemId and self.ItemId ~= "" then
    table.insert(self.objects, PlaceInventoryItem(self.ItemId))
  end
  if self.LootTableId then
    local loot_tbl = LootDefs[self.LootTableId]
    if loot_tbl then
      local is_external_seed = loot_tbl.loot == "cycle" or loot_tbl.loot == "each then last"
      local init_seed = is_external_seed and GetQuestVar(container.QuestId, container.QuestSeedVariable)
      local seed = loot_tbl:GenerateLootSeed(init_seed)
      if is_external_seed then
        local quest = QuestGetState(container.QuestId or "")
        SetQuestVar(quest, container.QuestSeedVariable, seed)
      end
      loot_tbl:GenerateLoot(self, {}, seed, self.objects)
    end
  end
  if IsKindOf(container, "ItemContainer") then
    for _, o in ipairs(self.objects) do
      if not container:GetItemPos(o) then
        container:AddItem("Inventory", o)
      end
    end
  end
end
function ConditionalLoot:DespawnObjects(container)
  if not rawget(self, "objects") then
    rawset(self, "objects", false)
  end
  if not self.objects or not next(self.objects) then
    return
  end
  local is_container = IsKindOf(container, "ItemContainer")
  for i, obj in ipairs(self.objects) do
    if is_container then
      container:RemoveItem("Inventory", obj)
    end
    DoneObject(obj)
  end
  table.clear(self.objects)
end
function ConditionalLoot:GetError()
  if self.LootTableId and not LootDefs[self.LootTableId] then
    return "Invalid LootTableId " .. self.LootTableId
  end
end
DefineClass.ConditionalSpawn = {
  __parents = {"InitDone"},
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Spawn Object",
      id = "Spawn_Conditions",
      name = "Spawn Conditions",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    },
    {
      category = "Spawn Object",
      id = "Despawn_Conditions",
      name = "Despawn Conditions",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    }
  },
  objects = false,
  last_spawned_objects = false
}
function ConditionalSpawn:GetSpawnDespawnConditions(marker, spawn_once)
  local bSpawnCond = true
  local bDespawnCond = self.Despawn_Conditions and next(self.Despawn_Conditions)
  for _, cond in ipairs(self.Spawn_Conditions or empty_table) do
    bSpawnCond = cond:Evaluate(self) and bSpawnCond
    if not bSpawnCond then
      break
    end
  end
  for _, cond in ipairs(self.Despawn_Conditions or empty_table) do
    bDespawnCond = cond:Evaluate(self) and bDespawnCond
    if not bDespawnCond then
      break
    end
  end
  return bSpawnCond, bDespawnCond
end
function ConditionalSpawn:Update(marker, spawn_once)
  if ForceDisableSpawnEnemy(self) then
    return
  end
  local bSpawnCond, bDespawnCond = self:GetSpawnDespawnConditions()
  if IgnoreSpawnEnemyConditions(self) then
    self.Side = "enemy1"
  end
  if not rawget(self, "objects") then
    rawset(self, "objects", false)
  end
  if bSpawnCond and not bDespawnCond and (not self.objects or not next(self.objects)) and (not spawn_once or not rawget(self, "last_spawned_objects")) then
    self:SpawnObjects(marker)
    self.last_spawned_objects = true
  end
  if bDespawnCond and self.objects then
    self:DespawnObjects(marker)
  end
end
function ConditionalSpawn:SpawnObjects()
end
function ConditionalSpawn:DespawnObjects()
end
DefineClass.ConditionalSpawnMarker = {
  __parents = {
    "GridMarker",
    "ConditionalSpawn"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "EditorRolloverText",
      name = "EditorRolloverText",
      editor = "text",
      default = "Sets objects in collection visible.",
      dont_save = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "EditorIcon",
      name = "EditorIcon",
      editor = "text",
      default = "CommonAssets/UI/Icons/school",
      dont_save = true,
      read_only = true,
      no_edit = true
    }
  }
}
function ConditionalSpawnMarker:Init()
  self.editor_text_offset = point(0, 0, 5 * guim / 2 + 300)
end
function ConditionalSpawnMarker:SpawnObjects()
end
function ConditionalSpawnMarker:DespawnObjects()
end
function ConditionalSpawnMarker:EditorGetText()
  return self.class
end
function ConditionalSpawnMarker:EditorEnter()
  GridMarker.EditorEnter(self)
end
function ConditionalSpawnMarker:EditorExit()
  GridMarker.EditorExit(self)
end
function ConditionalSpawnMarker:GetExtraEditorText(texts)
  for _, condition in ipairs(self.Spawn_Conditions or empty_table) do
    texts[#texts + 1] = "\t\t " .. Untranslated("spawn: ") .. T({
      condition:GetEditorView(),
      condition
    })
  end
  for _, condition in ipairs(self.Despawn_Conditions or empty_table) do
    texts[#texts + 1] = "\t\t " .. Untranslated("despawn: ") .. T({
      condition:GetEditorView(),
      condition
    })
  end
end
function ConditionalSpawnMarker:GetDynamicData(data)
  data.last_spawned_objects = self.last_spawned_objects or nil
  data.objects = self.objects and true or nil
end
function ConditionalSpawnMarker:SetDynamicData(data)
  self.last_spawned_objects = data.last_spawned_objects or false
end
DefineClass.ContainerMarker = {
  __parents = {
    "ShowHideCollectionMarker",
    "ItemContainer"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Spawn Object",
      id = "ItemSpawners",
      name = "ItemSpawners",
      editor = "nested_list",
      default = false,
      base_class = "ConditionalLoot",
      inclusive = true
    },
    {
      category = "Spawn Object",
      id = "HideIfEmpty",
      name = "HideIfEmpty",
      help = "If the holder is empty the marker becomes uninteractable.",
      editor = "bool",
      default = true
    },
    {
      category = "Spawn Object",
      id = "DespawnIfEmpty",
      name = "DespawnIfEmpty",
      help = "If the holder is empty the marker objects despawn.",
      editor = "bool",
      default = false
    },
    {
      id = "AreaHeight",
      name = "Area Height",
      editor = "number",
      default = 0,
      read_only = true,
      no_edit = true
    },
    {
      id = "AreaWidth",
      name = "Area Width",
      editor = "number",
      default = 0,
      read_only = true,
      no_edit = true
    },
    {
      id = "Type",
      name = "Type",
      editor = "text",
      default = "InventoryItemSpawn",
      read_only = true,
      no_edit = true
    },
    {
      id = "entity",
      name = "entity",
      editor = "text",
      default = "WayPoint",
      read_only = true,
      no_edit = true
    },
    {
      category = "Spawn Object",
      id = "DisplayName",
      name = "Container Display Name",
      editor = "text",
      default = T(499385555106, "Bag"),
      no_edit = true,
      translate = true
    },
    {
      category = "Spawn Object",
      id = "Name",
      name = "Display Name",
      editor = "combo",
      default = "Bag",
      items = function(self)
        return GetContainerNamesCombo()
      end
    },
    {
      category = "Spawn Object",
      id = "QuestId",
      name = "QuestId",
      help = "Quest to check.",
      editor = "preset_id",
      default = false,
      preset_class = "QuestsDef",
      preset_filter = function(preset, obj)
        return QuestHasVariable(preset, "QuestVarNum")
      end
    },
    {
      category = "Spawn Object",
      id = "QuestSeedVariable",
      name = "QuestSeedVariable",
      help = "Quest variable to check.",
      editor = "choice",
      default = false,
      items = function(self)
        return GetQuestsVarsCombo(self.QuestId, "Num")
      end
    },
    {
      id = "EditorRolloverText",
      name = "EditorRolloverText",
      editor = "text",
      default = "Spawn/despawn Inventory items using id or loot table",
      dont_save = true,
      read_only = true,
      no_edit = true
    }
  },
  reserved_handles = 1
}
function ContainerMarker:Init()
end
function ContainerMarker:Update()
  if self.DespawnIfEmpty and not self:GetItemInSlot("Inventory") and self.objects then
    self:DespawnObjects()
  end
  local spawn_once = self.Trigger == "once"
  ShowHideCollectionMarker.Update(self)
  for _, spawner in ipairs(self.ItemSpawners) do
    spawner:Update(self, spawn_once)
  end
end
function ContainerMarker:GetInteractionCombatAction(unit)
  if self.HideIfEmpty and not self:GetItemInSlot("Inventory") then
    return false
  elseif self.Type == "IntelInventoryItemSpawn" and gv_CurrentSectorId and not gv_Sectors[gv_CurrentSectorId].intel_discovered then
    return false
  end
  if self:IsEmpty("Inventory") then
    local anyVisible
    local efVisible = const.efVisible
    for i, o in ipairs(self.objects) do
      if o:GetEnumFlags(efVisible) ~= 0 then
        anyVisible = true
        break
      end
    end
    if not anyVisible then
      return false
    end
  end
  return ItemContainer.GetInteractionCombatAction(self, unit)
end
function ContainerMarker:GetDynamicData(data)
  for idx, spawner in ipairs(self.ItemSpawners) do
    data.spawners = data.spawners or {}
    data.spawners[idx] = data.spawners[idx] or {}
    if rawget(spawner, "last_spawned_objects") then
      data.spawners[idx].last_spawned_objects = spawner.last_spawned_objects
    end
  end
end
function ContainerMarker:SetDynamicData(data)
  if data.spawners then
    for idx, spawner in ipairs(self.ItemSpawners) do
      spawner.last_spawned_objects = data.spawners[idx] and data.spawners[idx].last_spawned_objects
    end
  end
end
function ContainerMarker:EndInteraction(unit)
  ItemContainer.EndInteraction(self, unit)
  self:Update()
end
function ContainerMarker:OnEditorSetProperty(prop_id, old_value, ged)
  if prop_id == "Name" then
    local preset = Presets.ContainerNames.Default[self.Name]
    if preset then
      self.DisplayName = preset.DisplayName
    else
      self.DisplayName = T(RandomLocId(), self.Name)
    end
  end
end
function ContainerMarker:CheckDiscovered(unit)
  if not self:IsMarkerEnabled() then
    return
  end
  if not self:GetInteractionCombatAction(unit) then
    return
  end
  return BoobyTrappable.CheckDiscovered(self, unit)
end
DefineClass.DamagePredictable = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "PotentialDamage",
      name = "Potential Damage",
      help = "used to indicate predicted damage done by attacks",
      editor = "number",
      default = 0,
      dont_save = true,
      read_only = true,
      no_edit = true,
      min = 0
    },
    {
      id = "PotentialDamageConditional",
      name = "Potential Damage Conditional",
      help = "used to indicate predicted damage done by attacks",
      editor = "number",
      default = 0,
      dont_save = true,
      read_only = true,
      no_edit = true,
      min = 0
    },
    {
      id = "PotentialSecondaryConditional",
      name = "Potential Secondary Conditional",
      help = "used to indicate secondary conditional damage doen by attacks",
      editor = "number",
      default = 0,
      dont_save = true,
      read_only = true,
      no_edit = true,
      min = 0
    },
    {
      id = "StealthKillChance",
      name = "Stealth Kill Chance",
      help = "used to indicate chance a unit is instant killed from stealth",
      editor = "number",
      default = -1,
      dont_save = true,
      read_only = true,
      no_edit = true,
      min = -1
    },
    {
      id = "SmallPotentialDamageIcon",
      name = "SmallPotentialDamageIcon",
      help = "used to indicate meta-data about the PotentialDamage",
      editor = "text",
      default = false,
      dont_save = true,
      read_only = true,
      no_edit = true,
      translate = true
    },
    {
      id = "LargePotentialDamageIcon",
      name = "LargePotentialDamageIcon",
      editor = "text",
      default = false,
      dont_save = true,
      read_only = true,
      no_edit = true,
      translate = true
    }
  }
}
DefineClass.DebrisList = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "debris_list",
      editor = "nested_list",
      default = false,
      base_class = "DebrisWeight"
    }
  }
}
DefineClass.EmailAttachment = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "picture",
      name = "Picture",
      editor = "ui_image",
      default = false
    },
    {
      id = "name",
      name = "Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "size",
      name = "Size",
      editor = "text",
      default = T(476205954303, "82kb"),
      translate = true
    },
    {
      id = "resolution",
      name = "Resolution",
      editor = "text",
      default = T(485105911401, "800x420x24bpp"),
      translate = true
    },
    {
      id = "scale",
      name = "Scale",
      editor = "text",
      default = T(215258410442, "100%"),
      translate = true
    }
  }
}
DefineClass.FallingDust = {
  __parents = {
    "DecorStateFXObjectNoSound"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "DecorStateFXObject",
      id = "ActivationRequiredStates",
      name = "States Required for Activation",
      editor = "set",
      default = set({RainHeavy = false, RainLight = false}),
      three_state = true,
      items = function(self)
        return GetGameStateFilter()
      end
    }
  },
  Preset = "Falling_Dust",
  particles_pattern = "Falling_Dust",
  place_category = "Effects",
  place_name = "DecorFX_Falling_Dust"
}
DefineClass.Fire_1x1 = {
  __parents = {
    "DecorStateFXObjectNoSound"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "DecorStateFXObject",
      id = "ActivationRequiredStates",
      name = "States Required for Activation",
      editor = "set",
      default = set({
        Night = true,
        RainHeavy = false,
        RainLight = false
      }),
      three_state = true,
      items = function(self)
        return GetGameStateFilter()
      end
    }
  },
  Preset = "Molotov_Fire_1x1_Smoldering",
  particles_pattern = "Molotov_Fire_1x1_Smoldering",
  place_category = "Effects",
  place_name = "DecorFX_Fire_1x1"
}
DefineClass.Fire_1x2 = {
  __parents = {
    "DecorStateFXObjectNoSound"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "DecorStateFXObject",
      id = "ActivationRequiredStates",
      name = "States Required for Activation",
      editor = "set",
      default = set({
        Night = true,
        RainHeavy = false,
        RainLight = false
      }),
      three_state = true,
      items = function(self)
        return GetGameStateFilter()
      end
    }
  },
  Preset = "Env_Fire1x2",
  particles_pattern = "Env_Fire1x2",
  place_category = "Effects",
  place_name = "DecorFX_Fire_1x2"
}
DefineClass.Flies = {
  __parents = {
    "DecorStateFXObjectWithSound"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "DecorStateFXObject",
      id = "ActivationRequiredStates",
      name = "States Required for Activation",
      editor = "set",
      default = set({
        Day = true,
        RainHeavy = false,
        RainLight = false
      }),
      three_state = true,
      items = function(self)
        return GetGameStateFilter()
      end,
      buttons = {
        {
          name = "Check Game States",
          func = "PropertyDefGameStatefSetCheck"
        }
      }
    }
  },
  Preset = "Swarm_Flies",
  particles_pattern = "Swarm_Flies",
  sounds_pattern = "flies",
  place_category = "Effects",
  place_name = "DecorFX_Flies"
}
function Flies:CheckUnderground()
end
DefineClass.Flies_Big = {
  __parents = {
    "DecorStateFXObjectWithSound"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "DecorStateFXObject",
      id = "ActivationRequiredStates",
      name = "States Required for Activation",
      editor = "set",
      default = set({
        Day = true,
        RainHeavy = false,
        RainLight = false
      }),
      three_state = true,
      items = function(self)
        return GetGameStateFilter()
      end
    }
  },
  Preset = "Env_Flies_Big",
  particles_pattern = "Env_Flies_Big",
  place_category = "Effects",
  place_name = "DecorFX_Flies_Big"
}
function Flies_Big:CheckUnderground()
end
DefineClass.FlyingCattilSeeds = {
  __parents = {
    "DecorStateFXObjectNoSound"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "DecorStateFXObject",
      id = "ActivationRequiredStates",
      name = "States Required for Activation",
      editor = "set",
      default = set({
        Fog = false,
        RainHeavy = false,
        RainLight = false
      }),
      three_state = true,
      items = function(self)
        return GetGameStateFilter()
      end
    }
  },
  Preset = "Env_FlyingCattailSeeds",
  particles_pattern = "Env_FlyingCattailSeeds",
  place_category = "Effects",
  place_name = "DecorFX_FlyingCattailSeeds"
}
DefineClass.FlyingConfetti = {
  __parents = {
    "DecorStateFXObjectNoSound"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "DecorStateFXObject",
      id = "ActivationRequiredStates",
      name = "States Required for Activation",
      editor = "set",
      default = set({RainHeavy = false, RainLight = false}),
      three_state = true,
      items = function(self)
        return GetGameStateFilter()
      end
    }
  },
  Preset = "Env_FlyingConfetti",
  particles_pattern = "Env_FlyingConfetti",
  place_category = "Effects",
  place_name = "DecorFX_FlyingConfetti"
}
DefineClass.FlyingDust = {
  __parents = {
    "DecorStateFXObjectNoSound"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "DecorStateFXObject",
      id = "ActivationRequiredStates",
      name = "States Required for Activation",
      editor = "set",
      default = set("DustStorm"),
      three_state = true,
      items = function(self)
        return GetGameStateFilter()
      end
    }
  },
  Preset = "Env_FlyingDust",
  particles_pattern = "Env_FlyingDust",
  place_category = "Effects",
  place_name = "DecorFX_FlyingDust"
}
DefineClass.FlyingDustRoad = {
  __parents = {
    "DecorStateFXObjectNoSound"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "DecorStateFXObject",
      id = "ActivationRequiredStates",
      name = "States Required for Activation",
      editor = "set",
      default = set(),
      three_state = true,
      items = function(self)
        return GetGameStateFilter()
      end
    }
  },
  Preset = "Road_dust",
  particles_pattern = "Road_dust",
  place_category = "Effects",
  place_name = "DecorFX_DustRoad"
}
DefineClass.FlyingEmbers = {
  __parents = {
    "DecorStateFXObjectNoSound"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "DecorStateFXObject",
      id = "ActivationRequiredStates",
      name = "States Required for Activation",
      editor = "set",
      default = set({RainHeavy = false, RainLight = false}),
      three_state = true,
      items = function(self)
        return GetGameStateFilter()
      end
    }
  },
  Preset = "Env_FlyingEmbers",
  particles_pattern = "Env_FlyingEmbers",
  place_category = "Effects",
  place_name = "DecorFX_FlyingEmbers"
}
DefineClass.FlyingGrass = {
  __parents = {
    "DecorStateFXObjectNoSound"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "DecorStateFXObject",
      id = "ActivationRequiredStates",
      name = "States Required for Activation",
      editor = "set",
      default = set({RainHeavy = false, RainLight = false}),
      three_state = true,
      items = function(self)
        return GetGameStateFilter()
      end
    }
  },
  Preset = "Env_FlyingGrass",
  particles_pattern = "Env_FlyingGrass",
  place_category = "Effects",
  place_name = "DecorFX_FlyingGrass"
}
DefineClass.FlyingGrass_Tropical = {
  __parents = {
    "DecorStateFXObjectNoSound"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "DecorStateFXObject",
      id = "ActivationRequiredStates",
      name = "States Required for Activation",
      editor = "set",
      default = set({RainHeavy = false, RainLight = false}),
      three_state = true,
      items = function(self)
        return GetGameStateFilter()
      end
    }
  },
  Preset = "Env_FlyingGrass_Tropical",
  particles_pattern = "Env_FlyingGrass_Tropical",
  place_category = "Effects",
  place_name = "DecorFX_FlyingGrassTropical"
}
DefineClass.FlyingMoney = {
  __parents = {
    "DecorStateFXObjectNoSound"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "DecorStateFXObject",
      id = "ActivationRequiredStates",
      name = "States Required for Activation",
      editor = "set",
      default = set({RainHeavy = false, RainLight = false}),
      three_state = true,
      items = function(self)
        return GetGameStateFilter()
      end
    }
  },
  Preset = "Env_FlyingMoney",
  particles_pattern = "Env_FlyingMoney",
  place_category = "Effects",
  place_name = "DecorFX_FlyingMoney"
}
DefineClass.FlyingPetals = {
  __parents = {
    "DecorStateFXObjectNoSound"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "DecorStateFXObject",
      id = "ActivationRequiredStates",
      name = "States Required for Activation",
      editor = "set",
      default = set({RainHeavy = false, RainLight = false}),
      three_state = true,
      items = function(self)
        return GetGameStateFilter()
      end
    }
  },
  Preset = "Env_FlyingPetals",
  particles_pattern = "Env_FlyingPetals",
  place_category = "Effects",
  place_name = "DecorFX_FlyingPetals"
}
DefineClass.GameSettings = {
  __parents = {
    "CommonGameSettings"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Campaign",
      name = "Campaign",
      editor = "preset_id",
      default = "HotDiamonds",
      preset_class = "CampaignPreset"
    },
    {
      id = "playthrough_name",
      name = "Playthrough Name",
      editor = "text",
      default = false,
      translate = true,
      lines = 1,
      max_lines = 1
    },
    {
      id = "playthrough_time",
      name = "Playthrough time",
      editor = "number",
      default = 0,
      min = 0
    },
    {
      id = "isDev",
      name = "IsDev",
      help = "Used to flag new playthroughs as developer ones",
      editor = "bool",
      default = false
    }
  }
}
DefineClass.GridMarkerType = {
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
      id = "Color",
      editor = "color",
      default = 4278190080
    },
    {
      id = "Entity",
      editor = "combo",
      default = false,
      items = function(self)
        return table.keys2(GetAllEntities(), true)
      end
    },
    {
      id = "Scale",
      editor = "number",
      default = 100,
      min = 1,
      max = 2047
    },
    {
      id = "AreaWidth",
      editor = "number",
      default = 1
    },
    {
      id = "AreaHeight",
      editor = "number",
      default = 1
    },
    {
      id = "MarkerGroup",
      name = "Default Group",
      help = "Add markers to this group by default",
      editor = "text",
      default = false
    },
    {
      id = "AreaThickness",
      name = "AreaThickness",
      editor = "number",
      default = 240,
      min = 1,
      max = 1000
    },
    {
      id = "DefenderRole",
      name = "Defender Role",
      help = "Is marker used for placing defender units",
      editor = "bool",
      default = false
    }
  }
}
DefineClass.MercChatBranch = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Lines",
      name = "Lines",
      editor = "nested_list",
      default = false,
      sort_order = 100,
      base_class = "ChatMessage"
    },
    {
      id = "Conditions",
      name = "Conditions",
      editor = "nested_list",
      default = false,
      sort_order = 99,
      base_class = "Condition"
    },
    {
      id = "GetEditorView",
      name = "GetEditorView",
      editor = "func",
      default = function(self)
        local firstLine = self.Lines and self.Lines[1] and self.Lines[1].Text or ""
        local firstCond = self.Conditions and self.Conditions[1]
        firstCond = firstCond and _InternalTranslate(firstCond:GetEditorView(), firstCond) or ""
        return Untranslated(firstCond) .. " - " .. firstLine
      end,
      no_edit = true
    },
    {
      id = "chanceToRoll",
      name = "chanceToRoll",
      editor = "number",
      default = 50
    }
  }
}
DefineClass.MercChatHaggle = {
  __parents = {
    "MercChatBranch"
  },
  __generated_by_class = "ClassDef"
}
function MercChatHaggle:RollRandom(mercId)
  local dayHash = xxhash(mercId, Game.CampaignTime / const.Scale.day / 3, Game.id)
  local roll = 1 + BraidRandom(dayHash, 100)
  if const.DbgHiring then
    print("Haggle rolled " .. roll .. " / " .. self.chanceToRoll)
  end
  local successRollHaggle = roll < self.chanceToRoll
  if const.DbgHiring then
    if successRollHaggle then
      CombatLog("debug", "haggle ocurred " .. roll .. " / " .. self.chanceToRoll)
    else
      CombatLog("debug", "no haggle " .. roll .. " / " .. self.chanceToRoll)
    end
  end
  return successRollHaggle
end
DefineClass.MercChatMitigation = {
  __parents = {
    "MercChatBranch"
  },
  __generated_by_class = "ClassDef"
}
DefineClass.MercChatRefusal = {
  __parents = {
    "MercChatBranch"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Type",
      name = "Type",
      editor = "choice",
      default = "normal",
      items = function(self)
        return {
          "normal",
          "duration",
          "rehire"
        }
      end
    },
    {
      id = "Duration",
      name = "Duration",
      editor = "choice",
      default = "short",
      no_edit = function(self)
        return self.Type ~= "duration"
      end,
      items = function(self)
        return {"short", "long"}
      end
    }
  }
}
function MercChatRefusal:CustomBranchCondition(obj, ctx)
  if self.Type ~= "duration" then
    return true
  end
  local duration = ctx.ContractDuration or 0
  if self.Duration == "short" then
    return duration < 7
  elseif self.Duration == "long" then
    return 7 <= duration
  end
  return true
end
DefineClass.MishapProperties = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Mishap",
      id = "MinMishapChance",
      help = "Mishap chance at 100 Explosives attribute",
      editor = "number",
      default = -8,
      template = true,
      scale = "%",
      modifiable = true
    },
    {
      category = "Mishap",
      id = "MaxMishapChance",
      help = "Mishap chance at 0 Explosives attribute",
      editor = "number",
      default = 12,
      template = true,
      scale = "%",
      modifiable = true
    },
    {
      category = "Mishap",
      id = "MinMishapRange",
      help = "Minimum range (in tiles) for the random target offest when a Mishap happens",
      editor = "number",
      default = 2,
      template = true,
      modifiable = true
    },
    {
      category = "Mishap",
      id = "MaxMishapRange",
      help = "Maximum range (in tiles) for the random target offest when a Mishap happens",
      editor = "number",
      default = 4,
      template = true,
      modifiable = true
    }
  }
}
function MishapProperties:GetMishapChance(unit, async)
  local chance = self.MinMishapChance + MulDivRound(Max(0, 100 - unit.Explosives), Max(0, self.MaxMishapChance - self.MinMishapChance), 100)
  local item = IsKindOf(self, "FirearmBase") and self.parent_weapon or self
  local percent = 100
  if IsKindOf(item, "InventoryItem") then
    percent = item:GetConditionPercent()
    chance = Max(chance, 100 - percent)
  end
  if GameState.RainHeavy and IsKindOf(item, "GrenadeProperties") then
    chance = Clamp(MulDivRound(chance, const.EnvEffects.RainMishapMultiplier, 100), const.EnvEffects.RainMishapMinChance, const.EnvEffects.RainMishapMaxChance)
  end
  if not async then
    NetUpdateHash("GetMishapChance", unit, chance, unit.Explosives, percent, GameState.RainHeavy, self.MinMishapChance, self.MaxMishapChance)
  end
  return Max(0, chance)
end
function MishapProperties:GetMishapDeviationVector(unit)
  local deviation = unit:RandRange(self.MinMishapRange * const.SlabSizeX, self.MaxMishapRange * const.SlabSizeX)
  return Rotate(point(deviation, 0, 0), unit:Random(21600))
end
DefineClass.Mist = {
  __parents = {
    "DecorStateFXObjectNoSound"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "DecorStateFXObject",
      id = "ActivationRequiredStates",
      name = "States Required for Activation",
      editor = "set",
      default = set({RainHeavy = false}),
      three_state = true,
      items = function(self)
        return GetGameStateFilter()
      end
    },
    {
      id = "entity_scale",
      name = "Entity Scale",
      editor = "number",
      default = 10
    }
  },
  Preset = "Ground_Mist",
  particles_pattern = "Mist",
  place_category = "Effects"
}
DefineClass.MultiplayerGameFilters = {
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
  GlobalMap = "MultiplayerGameFiltersList"
}
DefineClass.PerkProperties = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Perk",
      id = "Tier",
      editor = "combo",
      default = "System",
      template = true,
      items = function(self)
        return {
          "Bronze",
          "Silver",
          "Gold",
          "Personal",
          "Quirk",
          "Personality",
          "Specialization",
          "System"
        }
      end
    },
    {
      category = "Perk",
      id = "Stat",
      name = "Related Stat",
      editor = "combo",
      default = false,
      no_edit = function(self)
        return self.Tier ~= "Bronze" and self.Tier ~= "Silver" and self.Tier ~= "Gold"
      end,
      template = true,
      items = function(self)
        return {
          "Health",
          "Agility",
          "Dexterity",
          "Strength",
          "Leadership",
          "Wisdom",
          "Marksmanship",
          "Mechanical",
          "Explosives",
          "Medical"
        }
      end
    },
    {
      category = "Perk",
      id = "StatValue",
      name = "Stat Requirement",
      editor = "number",
      default = 30,
      no_edit = function(self)
        return self.Tier ~= "Bronze" and self.Tier ~= "Silver" and self.Tier ~= "Gold"
      end,
      template = true,
      slider = true,
      min = 0,
      max = 100
    },
    {
      category = "Perk",
      id = "StartingPerkOf",
      name = "Starting Perk Of",
      editor = "buttons",
      default = false,
      dont_save = true,
      read_only = true,
      template = true,
      buttons = function(obj)
        return PersonalPerkStartingOfButtons(obj)
      end
    },
    {
      id = "Icon",
      editor = "ui_image",
      default = false,
      template = true
    }
  }
}
function PerkProperties:IsLevelUp()
  return self.Tier == "Bronze" or self.Tier == "Silver" or self.Tier == "Gold"
end
DefineClass.RadioPlaylistTrack = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "Track",
      name = "Track",
      editor = "browse",
      default = "Music",
      folder = "Music",
      filter = "WAV files|*.wav",
      force_extension = ""
    },
    {
      id = "Frequency",
      name = "Weight",
      editor = "number",
      default = 100
    },
    {
      id = "EmptyTrack",
      name = "Empty Track",
      editor = "bool",
      default = false
    },
    {
      id = "Duration",
      name = "Duration",
      editor = "number",
      default = 5000,
      no_edit = function(self)
        return not self.EmptyTrack
      end,
      scale = "sec"
    }
  }
}
function RadioPlaylistTrack:GetError()
  if not self.EmptyTrack then
    local path = string.format("%s.wav", self.Track)
    if not io.exists(path) then
      return string.format("Missing '%s'", path)
    end
  end
end
function RadioPlaylistTrack:GetEditorView()
  if self.EmptyTrack then
    return Untranslated("Empty Track (<u(Frequency)>) for <FormatScale(Duration, 'sec')>")
  else
    return Untranslated("<u(Track)> (<u(Frequency)>)")
  end
end
DefineClass.ShowHideCollectionMarker = {
  __parents = {
    "ConditionalSpawnMarker",
    "SaveMapCheckMarker"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "EditorRolloverText",
      name = "EditorRolloverText",
      editor = "text",
      default = "Sets objects in collection visible.",
      dont_save = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "EditorIcon",
      name = "EditorIcon",
      editor = "text",
      default = "CommonAssets/UI/Icons/school",
      dont_save = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "CollectionRange",
      name = "Collection Range",
      help = "The range in which to gather objects from the collection, warns with VME if further than that",
      editor = "number",
      default = 10000,
      scale = "m"
    },
    {
      category = "Spawn Object",
      id = "sync_obj",
      name = "SyncObject",
      editor = "bool",
      default = false
    }
  },
  restore_enumflags = false
}
function ShowHideCollectionMarker:GameInit()
  if not IsEditorActive() and not self.objects then
    self:HideObjects()
  end
end
function ShowHideCollectionMarker:GetObjects()
  local root_collection = self:GetRootCollection()
  local collection_idx = root_collection and root_collection.Index or 0
  if collection_idx and collection_idx ~= 0 then
    return MapGet(self, self.CollectionRange, "collection", collection_idx, true, function(o)
      return not IsKindOf(o, "EditorMarker")
    end)
  end
end
function ShowHideCollectionMarker:HideObjects()
  local objects = self.objects or self:GetObjects()
  local enumflags = self.restore_enumflags
  local efCollision = const.efCollision
  for i, o in ipairs(objects) do
    if IsValid(o) and o:GetVisible() then
      o:SetVisible(false)
      if o:GetCollision() then
        o:SetCollision(false)
        enumflags = enumflags or {}
        enumflags[o] = efCollision
      end
    end
  end
  if enumflags then
    self.restore_enumflags = enumflags
  end
end
function ShowHideCollectionMarker:ShowObjects()
  local objects = self.objects or self:GetObjects()
  local enumflags = self.restore_enumflags
  self.restore_enumflags = nil
  local efCollision = const.efCollision
  for i, o in ipairs(objects) do
    if IsValid(o) then
      o:SetVisible(true)
      if enumflags then
        local flags = enumflags[o]
        if flags and flags & efCollision ~= 0 then
          o:SetCollision(true)
        end
      end
    end
  end
end
function ShowHideCollectionMarker:SpawnObjects()
  if self.objects then
    return
  elseif self.Trigger == "once" and self.last_spawned_objects then
    return
  end
  self.objects = self:GetObjects() or empty_table
  self:ShowObjects()
  local game_flags = self.sync_obj and const.gofSyncObject
  for i, o in ipairs(self.objects) do
    o.spawner = self
    if game_flags then
      o:SetGameFlags(game_flags)
    end
  end
  self.last_spawned_objects = true
end
function ShowHideCollectionMarker:DespawnObjects()
  if not self.objects then
    return
  end
  for _, o in ipairs(self.objects) do
    o.spawner = nil
  end
  if not IsEditorActive() then
    self:HideObjects()
  end
  self.objects = nil
end
function ShowHideCollectionMarker:EditorEnter()
  GridMarker.EditorEnter(self)
  self:ShowObjects()
end
function ShowHideCollectionMarker:EditorExit()
  GridMarker.EditorExit(self)
  if not self.objects then
    self:HideObjects()
  end
  self:Update()
end
function ShowHideCollectionMarker:GetDynamicData(data)
  data.objects = self.objects and true or nil
end
function ShowHideCollectionMarker:SetDynamicData(data)
  if data.objects then
    self.objects = self:GetObjects() or empty_table
    self:ShowObjects()
    for i, o in ipairs(self.objects) do
      o.spawner = self
      if self.sync_obj then
        o:SetGameFlags(const.gofSyncObject)
      end
    end
  end
end
function ShowHideCollectionMarker:GetError()
  if not Platform.developer then
    return
  end
  local collection_idx = self:GetCollectionIndex()
  if collection_idx and collection_idx ~= 0 then
    local outside_objects = MapGet("map", "collection", collection_idx, true, function(o, self)
      return not IsCloser2D(self, o, self.CollectionRange)
    end, self)
    if outside_objects then
      return string.format("'%s' too far from its '%s'(must be within %d", outside_objects[1]:GetEntity(), self.class, self.CollectionRange)
    end
    local nonEssentialObjects = MapGet("map", "collection", collection_idx, true, function(o, self)
      return o:GetDetailClass() ~= "Essential"
    end, self)
    if nonEssentialObjects then
      return "Objects in ShowHideCollectionMarker need to be marked as detail level: 'Essential'"
    end
  end
end
DefineClass.SunRays = {
  __parents = {
    "DecorStateFXObjectNoSound"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "DecorStateFXObject",
      id = "ActivationRequiredStates",
      name = "States Required for Activation",
      editor = "set",
      default = set({Night = false}),
      three_state = true,
      items = function(self)
        return GetGameStateFilter()
      end
    }
  },
  Preset = "Env_SunRays",
  particles_pattern = "env_SunRays",
  place_category = "Effects",
  place_name = "DecorFX_SunRays"
}
DefineClass.UnitDataSpawnData = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "UnitDataDefId",
      name = "UnitDataCompositeDef Id",
      help = "Choose mercenary, enemy, or NPC from the Unit editor to spawn",
      editor = "preset_id",
      default = false,
      preset_class = "UnitDataCompositeDef"
    },
    {
      id = "SpawnWeight",
      name = "Spawn Weight",
      help = "Spawn a unit from one of several unit templates using a weighted average.",
      editor = "number",
      default = 100,
      min = 0
    },
    {
      id = "ForcedAppearance",
      name = "Forced Appearance",
      help = "Force this template to use this appearance instead of randomly choosing from its own list of appearances",
      editor = "preset_id",
      default = false,
      preset_class = "AppearancePreset"
    },
    {
      id = "Name",
      name = "Name Override",
      help = "Name for the spawned unit that will replace the one from template.",
      editor = "text",
      default = false,
      template = true,
      translate = true,
      lines = 1,
      max_lines = 1
    }
  }
}
function UnitDataSpawnData:GetEditorView()
  return Untranslated("<UnitDataDefId> <Name> (weight: <SpawnWeight>) ")
end
function UnitDataSpawnData:OnEditorSetProperty(prop_id, old_value, ged)
  local set_appearance = function(obj)
    local first = obj:GetAppearenceTemplateId()
    local appearance = ChooseUnitAppearance(first)
    obj:ApplyAppearance(appearance)
    obj.Appearance = appearance
  end
  if prop_id == "UnitDataDefId" then
    local parent = ged.selected_object
    if parent:IsKindOf("GedMultiSelectAdapter") then
      for _, obj in ipairs(parent.__objects) do
        set_appearance(obj)
      end
    else
      set_appearance(parent)
    end
  end
end
DefineClass.UnitMarker = {
  __parents = {
    "ShowHideCollectionMarker",
    "AppearanceObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "AreaHeight",
      name = "Area Height",
      editor = "number",
      default = 1
    },
    {
      id = "AreaWidth",
      name = "Area Width",
      editor = "number",
      default = 1
    },
    {
      category = "Spawn Object",
      id = "Appearance",
      name = "Appearance",
      editor = "text",
      default = false,
      no_edit = true
    },
    {
      id = "anim",
      name = "Animation",
      editor = "choice",
      default = "idle",
      no_edit = true,
      no_validate = true,
      items = function(self)
        return ValidAnimationsCombo
      end
    },
    {
      category = "Animation",
      id = "use_weapons",
      name = "Use weapons",
      help = "Use weapon animations in idle state.",
      editor = "bool",
      default = true
    },
    {
      category = "Spawn Object",
      id = "Suspicious",
      help = "Set spawned units to Suspicious state",
      editor = "bool",
      default = false
    },
    {
      id = "Type",
      name = "Type",
      editor = "text",
      default = "UnitMarker",
      read_only = true,
      no_edit = true
    },
    {
      id = "Entity",
      name = "Entity",
      editor = "text",
      default = "WayPoint",
      dont_save = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "EditorIcon",
      name = "EditorIcon",
      editor = "text",
      default = "CommonAssets/UI/Icons/user",
      dont_save = true,
      read_only = true,
      no_edit = true
    },
    {
      category = "Banters",
      id = "SpecificBanters",
      name = "SpecificBanters",
      help = "Specific Banters to play when interacted with.",
      editor = "preset_id_list",
      default = {},
      preset_class = "BanterDef",
      item_default = ""
    },
    {
      category = "Banters",
      id = "BanterGroups",
      name = "Banters from group",
      help = "Add groups of banters at once",
      editor = "string_list",
      default = {},
      item_default = "",
      items = function(self)
        return PresetGroupsCombo("BanterDef")
      end,
      arbitrary_value = true
    },
    {
      category = "Banters",
      id = "BantersSequential",
      name = "Play all banters one after another",
      help = "By default on unit interaction one of the banters from the list is played. If this is checked then all the banters will be played in succession.",
      editor = "bool",
      default = false
    },
    {
      category = "Banters",
      id = "ApproachedBanters",
      name = "ApproachedBanters",
      help = "Banters to play when the unit is approached within a specified range.",
      editor = "preset_id_list",
      default = {},
      preset_class = "BanterDef",
      item_default = ""
    },
    {
      category = "Banters",
      id = "ApproachBanterGroup",
      name = "Approach Banters from group",
      help = "Add a group of approach banters at once",
      editor = "combo",
      default = false,
      items = function(self)
        return PresetGroupsCombo("BanterDef")
      end
    },
    {
      category = "Banters",
      id = "ApproachRadius",
      name = "ApproachRadius",
      help = "How close a player controled unit has to be to trigger the approached banters.",
      editor = "number",
      default = 8
    },
    {
      category = "Interaction",
      id = "InteractionName",
      name = "Interaction Name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      category = "Interaction",
      id = "InteractionConditions",
      name = "Interaction Enable Conditions",
      help = "The interaction effects and overwrites will apply if these pass as true.",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    },
    {
      category = "Interaction",
      id = "ExecuteInteractionEffectsSequentially",
      name = "Execute Sequentially",
      editor = "bool",
      default = false
    },
    {
      category = "Interaction",
      id = "InteractionEffects",
      name = "Interaction Effects",
      editor = "nested_list",
      default = false,
      base_class = "Effect"
    },
    {
      category = "Interaction",
      id = "InteractionVisuals",
      name = "InteractionVisuals",
      editor = "choice",
      default = false,
      items = function(self)
        return AllInteractableIcons()
      end
    },
    {
      category = "Spawn Object",
      id = "Side",
      editor = "choice",
      default = "neutral",
      items = function(self)
        return table.map(GetCurrentCampaignPreset().Sides, "Id")
      end
    },
    {
      id = "kill_on_spawn",
      editor = "bool",
      default = false,
      dont_save = true,
      no_edit = true
    },
    {
      category = "Spawn Object",
      id = "Persistent",
      help = "triggering the spawn multiple times will result in the same units, preserving any changes in their data; this is ignored if the template to be spawned has a non-empty \"Persistent Session Id\" (works as if it is enabled)",
      editor = "bool",
      default = false
    },
    {
      category = "Spawn Object",
      id = "ConflictIgnore",
      name = "Conflict Ignore",
      help = "The units from this marker are ignoring conflicts and don't use the Cower command.",
      editor = "bool",
      default = false
    },
    {
      category = "Spawn Object",
      id = "SessionId",
      name = "Session ID",
      editor = "text",
      default = false,
      no_edit = function(self)
        return not self.Persistent
      end
    },
    {
      category = "Spawn Object",
      id = "UnitDataSpawnDefs",
      name = "UnitData Spawn Templates",
      help = "Choose mercenary, enemy, or NPC from the Unit editor to spawn, using weighted random.",
      editor = "nested_list",
      default = false,
      base_class = "UnitDataSpawnData",
      inclusive = true
    },
    {
      category = "Animation",
      id = "idle_stance",
      name = "Idle stance",
      editor = "combo",
      default = "do not change",
      items = function(self)
        return GetIdleAnimStances(self.use_weapons)
      end
    },
    {
      category = "Animation",
      id = "idle_action",
      name = "Idle Action",
      editor = "combo",
      default = "do not change",
      items = function(self)
        return GetIdleAnimStanceActions(self.use_weapons, self.idle_stance)
      end
    },
    {
      id = "EditorRolloverText",
      name = "EditorRolloverText",
      editor = "text",
      default = "Spawn/despawn Unit from specified TemplateIds when spawn/despawn conditions are met",
      dont_save = true,
      read_only = true,
      no_edit = true
    },
    {
      id = "Routine",
      editor = "combo",
      default = "StandStill",
      items = function(self)
        return UnitRoutines
      end
    },
    {
      id = "RoutineArea",
      editor = "combo",
      default = "self",
      items = function(self)
        local g = table.copy(GridMarkerGroupsCombo())
        g[1 + #g] = "self"
        return g
      end
    },
    {
      category = "Spawn Object",
      id = "status_effects",
      name = "Status Effects",
      editor = "preset_id_list",
      default = {},
      preset_class = "CharacterEffectCompositeDef",
      item_default = ""
    }
  },
  unit_template_idx = false
}
function UnitMarker:Init()
  self.parts = {}
  self.attached_parts = {
    "Head",
    "Pants",
    "Shirt",
    "Armor",
    "Hat"
  }
  self.attach_spot = {Hat = "Head"}
  local first = self:GetAppearenceTemplateId()
  local appearance = self.Appearance or ChooseUnitAppearance(first, self.handle)
  self:ApplyAppearance(appearance)
  self.Appearance = appearance
end
function UnitMarker:SpawnObjects()
  if not self.UnitDataSpawnDefs or #self.UnitDataSpawnDefs < 1 then
    return
  end
  if self.objects then
    return
  end
  if self.Trigger == "once" and self.last_spawned_objects then
    return
  end
  local pts = GetReachablePositionsFromPos(self:GetPos(), 1)
  local session_id, template_idx = self:GenerateUnitIds()
  if pts and 0 < #pts then
    local idx = template_idx
    local unit_template_id = self.UnitDataSpawnDefs[idx].UnitDataDefId
    local name = self.UnitDataSpawnDefs[idx].Name
    local pos = pts[1]
    local unit_data = gv_UnitData and gv_UnitData[session_id]
    if not unit_data or not unit_data:IsDead() then
      if unit_data and unit_data.class ~= unit_template_id then
        unit_data:delete()
        gv_UnitData[session_id] = false
      end
      pos:SetInvalidZ()
      local unit = SpawnUnit(unit_template_id, session_id, pos, self:GetAngle(), self.Groups, self)
      unit.sequential_banter = self.BantersSequential
      local approach_banters = {}
      table.iappend(approach_banters, self.ApproachedBanters)
      table.iappend(approach_banters, table.keys2(Presets.BanterDef[self.ApproachBanterGroup] or {}, "sorted"))
      unit.approach_banters = approach_banters
      unit.approach_banters_distance = self.ApproachRadius
      if name and name ~= "" then
        unit.Name = name
      end
      self.objects = {unit}
      ShowHideCollectionMarker.SpawnObjects(self)
      unit:SetSide(self.Side)
      unit.routine = self.Routine
      unit.routine_area = self.RoutineArea
      unit.routine_spawner = self
      unit.conflict_ignore = self.ConflictIgnore
      if self.Side == "neutral" and GameState.Conflict and unit:CanCower() then
        unit:TeleportToCower()
      end
      if self.kill_on_spawn then
        unit:SetCommand("Die")
      end
    end
  end
  if self.Persistent then
    self.unit_template_idx = template_idx
  end
  self.last_spawned_objects = true
  return self.objects
end
function UnitMarker:DespawnObjects()
  if not self.objects or not next(self.objects) then
    return
  end
  for i = #self.objects, 1, -1 do
    local obj = self.objects[i]
    if IsValid(obj) and IsKindOf(obj, "Unit") and obj:IsNPC() and (not obj:IsDead() or obj.PersistentSessionId) then
      obj.spawner = false
      DoneObject(obj)
      table.remove(self.objects, i)
    end
  end
  ShowHideCollectionMarker.DespawnObjects(self)
  self.objects = false
end
function UnitMarker:GenerateUnitIds()
  local unit_template_idx, session_id
  if not self.Persistent or not self.unit_template_idx then
    local accum_weight = 0
    for i = 1, #self.UnitDataSpawnDefs do
      accum_weight = accum_weight + self.UnitDataSpawnDefs[i].SpawnWeight
    end
    local target_weight
    target_weight = InteractionRand(accum_weight, "spawn_objects", self)
    local sum_weight = 0
    for i = 1, #self.UnitDataSpawnDefs - 1 do
      sum_weight = sum_weight + self.UnitDataSpawnDefs[i].SpawnWeight
      if target_weight < sum_weight then
        unit_template_idx = i
        break
      end
    end
    unit_template_idx = unit_template_idx or #self.UnitDataSpawnDefs
  else
    unit_template_idx = self.unit_template_idx
  end
  local template = self.UnitDataSpawnDefs[unit_template_idx].UnitDataDefId
  template = template and UnitDataDefs[template]
  if template and (template.PersistentSessionId or "") ~= "" then
    session_id = template.PersistentSessionId
  elseif self.Persistent then
    session_id = self.SessionId
  else
    session_id = GenerateUniqueUnitDataId("SpawnerUnit", gv_CurrentSectorId, unit_template_idx)
  end
  return session_id, unit_template_idx
end
function UnitMarker:GetDynamicData(data)
  data.last_spawned_objects = self.last_spawned_objects or nil
  if self.objects then
    data.objects = {}
    for _, obj in ipairs(self.objects) do
      table.insert(data.objects, obj:GetHandle())
    end
  end
  data.unit_template_idx = self.unit_template_idx or nil
end
function UnitMarker:SetDynamicData(data)
  if data.objects then
    self.objects = {}
    for _, handle in ipairs(data.objects) do
      local obj = HandleToObject[handle]
      if obj then
        table.insert(self.objects, obj)
      end
    end
  end
  self.last_spawned_objects = data.last_spawned_objects or false
  self.unit_template_idx = data.unit_template_idx
end
function UnitMarker:EditorEnter()
  ShowHideCollectionMarker.EditorEnter(self)
  local first = self:GetAppearenceTemplateId()
  local appearance = self.Appearance or ChooseUnitAppearance(first, self.handle)
  self:ApplyAppearance(appearance)
  self.Appearance = appearance
end
function UnitMarker:EditorGetText()
  return self:GetAppearenceTemplateId() or self.class
end
function UnitMarker:GetExtraEditorText(texts)
  texts[#texts + 1] = "\t\t " .. T({
    747690717505,
    "<Side>:",
    self
  })
  for _, temp_obj in ipairs(self.UnitDataSpawnDefs or empty_table) do
    texts[#texts + 1] = "\t\t\t " .. T({
      925017903706,
      "<UnitDataDefId> <Name> (<SpawnWeight>)",
      temp_obj,
      Name = temp_obj.Name
    })
  end
  ShowHideCollectionMarker.GetExtraEditorText(self, texts)
end
function UnitMarker:GetAppearenceTemplateId()
  local first = self.UnitDataSpawnDefs and self.UnitDataSpawnDefs[1]
  return first and first.UnitDataDefId
end
function UnitMarker:GetError()
  if self.Persistent and (self.SessionId or "") == "" then
    return "Persistent units must have a valid Session ID"
  end
  local errors = {}
  local spawn_defs = self.UnitDataSpawnDefs
  for _, spawn_def in ipairs(spawn_defs or empty_table) do
    local unitdatadef_id = spawn_def.UnitDataDefId
    local unit_def = unitdatadef_id and UnitDataDefs[unitdatadef_id]
    if not unit_def then
      table.insert(errors, string.format("Invalid UnitDataDefId '%s'", unitdatadef_id or ""))
    else
      local species = unit_def and unit_def.species or "Human"
      if species == "Human" then
        local prefix = not self.use_weapons and "civ" or "ar"
        local stance = self.idle_stance ~= g_StanceActionDefault and self.idle_stance or ".*"
        local action = self.idle_action ~= g_StanceActionDefault and self.idle_action or ".*"
        local anim_regex = string.format("%s_%s_%s", prefix, stance, action)
        local anims = ValidAnimationsCombo(self)
        local anim_match = false
        for _, a in ipairs(anims) do
          if string.match(a, anim_regex) then
            anim_match = true
            break
          end
        end
        if not anim_match then
          table.insert(errors, string.format("These values don't match a valid animation: [%s] Use Weapons - %s; Idle stance - %s; Idle animation action - %s", next(anims) and anims[1] or "no anims present", self.use_weapons and "Yes" or "No", self.idle_stance or "default", self.idle_action or "default"))
        end
      end
    end
  end
  return next(errors) and table.concat(errors, "\n")
end
function UnitMarker:OnEditorSetProperty(prop_id, old_value, ged)
  if prop_id == "idle_stance" then
    local actions = GetIdleAnimStanceActions(self.use_weapons, self.idle_stance)
    if not table.find(actions, self.idle_action) then
      self:SetProperty("idle_action", actions[1])
    end
  end
end
DefineClass.UnitProperties = {
  __parents = {
    "UnitPropertiesStats",
    "ZuluModifiable",
    "DamagePredictable"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Appearance",
      id = "Headshot",
      name = "Headshot",
      help = "Set a blown out head",
      editor = "bool",
      default = false,
      template = true
    },
    {
      id = "CurrentSide",
      editor = "text",
      default = false
    },
    {
      id = "lastFiringMode",
      name = "LastFiringMode",
      editor = "text",
      default = false
    },
    {
      category = "Appearance",
      id = "Portrait",
      editor = "ui_image",
      default = "UI/MercsPortraits/placeholder_portrait",
      template = true,
      image_preview_size = 100
    },
    {
      category = "Appearance",
      id = "BigPortrait",
      editor = "ui_image",
      default = "UI/Mercs/placeholder_character",
      template = true,
      image_preview_size = 100
    },
    {
      category = "General",
      id = "Name",
      name = "Full name",
      help = "The full name of the merc. When the full name is needed this entire string is used and the nickname is ignored.",
      editor = "text",
      default = false,
      template = true,
      translate = true,
      lines = 1,
      max_lines = 1
    },
    {
      category = "General",
      id = "Nick",
      name = "Nickname",
      help = "The nickname or short name of the merc",
      editor = "text",
      default = false,
      template = true,
      no_edit = function(self)
        return not IsMerc(self) and self.id ~= "Dummy"
      end,
      translate = true,
      lines = 1,
      max_lines = 1
    },
    {
      category = "Stats",
      id = "Randomization",
      name = "Randomization",
      help = "When true any instance of this unit randomizes the stats of the unit by +/- 10 points",
      editor = "bool",
      default = false,
      template = true,
      no_edit = function(self)
        return IsMerc(self)
      end
    },
    {
      category = "General",
      id = "AllCapsNick",
      name = "AllCapsNickname",
      help = "The nickname or short name of the merc with all caps letters (needed by some UI)",
      editor = "text",
      default = false,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      translate = true,
      lines = 1,
      max_lines = 1
    },
    {
      category = "General",
      id = "elite",
      name = "Elite",
      help = "Give the unit a unique random name.",
      editor = "bool",
      default = false,
      template = true,
      no_edit = function(self)
        return IsMerc(self)
      end
    },
    {
      category = "General",
      id = "eliteCategory",
      name = "Elite Category",
      help = "From which group of names to select. If nothing is selected it will pick from any of the groups.",
      editor = "combo",
      default = false,
      template = true,
      no_edit = function(self)
        return IsMerc(self)
      end,
      items = function(self)
        return PresetGroupsCombo("EliteEnemyName")
      end
    },
    {
      category = "General",
      id = "Affiliation",
      editor = "combo",
      default = "AIM",
      template = true,
      items = function(self)
        return Affiliations
      end
    },
    {
      category = "Hiring",
      id = "HireStatus",
      name = "Initial Hire Status",
      editor = "combo",
      default = "Available",
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      items = function(self)
        return PresetGroupCombo("MercHireStatus", "Default")
      end
    },
    {
      category = "Hiring",
      id = "Bio",
      name = "Bio",
      help = "Biography of the merc",
      editor = "text",
      default = false,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      translate = true,
      lines = 4,
      max_lines = 10
    },
    {
      category = "Hiring",
      id = "Nationality",
      name = "Nationality",
      help = "Is shown next to the bio in the hire UI",
      editor = "preset_id",
      default = false,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      preset_class = "MercNationalities"
    },
    {
      category = "Hiring",
      id = "Title",
      name = "Title",
      help = "Is shown next to the bio in the hire UI",
      editor = "text",
      default = false,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      translate = true
    },
    {
      category = "Hiring",
      id = "Email",
      name = "Email",
      help = "Is shown in the AIM chat.",
      editor = "text",
      default = false,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      translate = true
    },
    {
      category = "Hiring",
      id = "snype_nick",
      name = "snype Nick",
      help = "Is shown in the AIM chat.",
      editor = "text",
      default = false,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      translate = true
    },
    {
      category = "Hiring - Conditions",
      id = "Refusals",
      name = "Refusals",
      editor = "nested_list",
      default = false,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      base_class = "MercChatRefusal"
    },
    {
      category = "Hiring - Conditions",
      id = "Haggles",
      name = "Haggles",
      editor = "nested_list",
      default = false,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      base_class = "MercChatHaggle"
    },
    {
      category = "Hiring - Conditions",
      id = "HaggleRehire",
      name = "Rehire Haggles",
      editor = "nested_list",
      default = false,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      base_class = "MercChatHaggle"
    },
    {
      category = "Hiring - Conditions",
      id = "Mitigations",
      name = "Mitigations",
      editor = "nested_list",
      default = false,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      base_class = "MercChatMitigation"
    },
    {
      category = "Hiring - Conditions",
      id = "ExtraPartingWords",
      name = "Parting Words",
      help = "If any conditional passing remark passes it is played instead of the default one.",
      editor = "nested_list",
      default = false,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      base_class = "MercChatBranch",
      inclusive = true,
      no_descendants = true
    },
    {
      category = "Hiring - Lines",
      id = "Offline",
      name = "Offline",
      editor = "nested_list",
      default = false,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      base_class = "ChatMessage"
    },
    {
      category = "Hiring - Lines",
      id = "GreetingAndOffer",
      name = "Greetings And Offer",
      editor = "nested_list",
      default = false,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      base_class = "ChatMessage"
    },
    {
      category = "Hiring - Lines",
      id = "ConversationRestart",
      name = "Conversation Restart",
      editor = "nested_list",
      default = false,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      base_class = "ChatMessage"
    },
    {
      category = "Hiring - Lines",
      id = "IdleLine",
      name = "Idle",
      editor = "nested_list",
      default = false,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      base_class = "ChatMessage"
    },
    {
      category = "Hiring - Lines",
      id = "PartingWords",
      name = "PartingWords",
      editor = "nested_list",
      default = false,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      base_class = "ChatMessage"
    },
    {
      category = "Hiring - Lines",
      id = "RehireIntro",
      name = "RehireIntro",
      editor = "nested_list",
      default = false,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      base_class = "ChatMessage"
    },
    {
      category = "Hiring - Lines",
      id = "RehireOutro",
      name = "RehireOutro",
      editor = "nested_list",
      default = false,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      base_class = "ChatMessage"
    },
    {
      category = "Hiring - Parameters",
      id = "MedicalDeposit",
      name = "Medical Deposit",
      editor = "choice",
      default = "small",
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      items = function(self)
        return {
          "small",
          "none",
          "large",
          "extreme"
        }
      end
    },
    {
      category = "Hiring - Parameters",
      id = "DurationDiscount",
      name = "Duration Discount",
      editor = "choice",
      default = "normal",
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      items = function(self)
        return {
          "normal",
          "none",
          "long only"
        }
      end
    },
    {
      category = "Hiring - Parameters",
      id = "Haggling",
      name = "Haggling",
      editor = "choice",
      default = "normal",
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      items = function(self)
        return {
          "normal",
          "low",
          "high"
        }
      end
    },
    {
      category = "Hiring - Parameters",
      id = "StartingSalary",
      help = "The salary at the starting level (whichever it is).",
      editor = "number",
      default = 1000,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      min = 0,
      max = 20000
    },
    {
      category = "Hiring - Parameters",
      id = "SalaryIncrease",
      help = "The percentange of salary increase per level.",
      editor = "number",
      default = 250,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      scale = 1000,
      min = 0,
      max = 10000
    },
    {
      category = "Hiring - Parameters",
      id = "SalaryLv1",
      name = "(To Be Deleted) Salary Lv 1",
      help = "The amount of money it costs to hire this merc for 1 day at level 1",
      editor = "number",
      default = 1000,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      min = 0,
      max = 20000
    },
    {
      category = "Hiring - Parameters",
      id = "SalaryMaxLv",
      name = "(To Be Deleted) Max Lv Daily Salary",
      help = "The amount of money it costs to hire this merc for 1 day at max level",
      editor = "number",
      default = 10000,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      min = 0,
      max = 20000
    },
    {
      category = "Hiring - Parameters",
      id = "SalaryPreview",
      name = "Salary Level 10",
      editor = "number",
      default = 0,
      dont_save = true,
      read_only = true,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end
    },
    {
      category = "Hiring",
      id = "LegacyNotes",
      name = "Legacy Notes",
      help = "Any info about the merc from previous titles.",
      editor = "text",
      default = false,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      lines = 4
    },
    {
      category = "XP",
      id = "StartingLevel",
      name = "Starting Level",
      help = "The level at which this merc starts in a new game",
      editor = "number",
      default = 1,
      template = true,
      slider = true,
      min = 1,
      max = 10
    },
    {
      category = "General",
      id = "immortal",
      name = "Immortal",
      editor = "bool",
      default = false,
      template = true,
      no_edit = function(self)
        return IsMerc(self)
      end
    },
    {
      category = "General",
      id = "ImportantNPC",
      name = "ImportantNPC",
      help = "Units with this flag have a green badge above them.",
      editor = "bool",
      default = false,
      template = true,
      no_edit = function(self)
        return IsMerc(self)
      end
    },
    {
      category = "General",
      id = "reincarnate",
      name = "Reincarnate",
      editor = "bool",
      default = false,
      template = true,
      no_edit = function(self)
        return IsMerc(self)
      end
    },
    {
      category = "General",
      id = "dummy",
      name = "Dummy",
      editor = "bool",
      default = false,
      template = true,
      no_edit = function(self)
        return IsMerc(self)
      end
    },
    {
      category = "General",
      id = "militia",
      name = "Militia Unit",
      editor = "bool",
      default = false,
      no_edit = true,
      template = true,
      no_edit = function(self)
        return IsMerc(self)
      end
    },
    {
      category = "General",
      id = "villain",
      name = "Recurring Villain",
      editor = "bool",
      default = false,
      template = true,
      no_edit = function(self)
        return IsMerc(self)
      end
    },
    {
      category = "General",
      id = "neutral_retaliate",
      name = "Retaliate",
      help = "if enabled and the unit is Neutral, they will become hostile when damaged",
      editor = "bool",
      default = false,
      template = true,
      no_edit = function(self)
        return IsMerc(self)
      end
    },
    {
      category = "General",
      id = "max_dead_slot_tiles",
      name = "max_dead_slot_tiles",
      help = "Max tiles in InventoryDead slot. It's caclulated on death, when a unit drops its loot.",
      editor = "number",
      default = 24,
      no_edit = true,
      template = true,
      min = 1,
      max = 24
    },
    {
      id = "VillainHealWoundProgress",
      help = "Used only for villains",
      editor = "number",
      default = 0,
      no_edit = true
    },
    {
      category = "AI",
      id = "AIKeywords",
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
      category = "AI",
      id = "archetype",
      name = "Archetype",
      editor = "preset_id",
      default = "Soldier",
      template = true,
      no_edit = function(self)
        return IsMerc(self)
      end,
      preset_class = "AIArchetype"
    },
    {
      category = "AI",
      id = "script_archetype",
      name = "Archetype",
      editor = "preset_id",
      default = "",
      no_edit = true,
      no_validate = true,
      template = true,
      preset_class = "AIArchetype"
    },
    {
      category = "AI",
      id = "role",
      name = "Enemy Role",
      editor = "preset_id",
      default = "Default",
      template = true,
      no_edit = function(self)
        return IsMerc(self)
      end,
      preset_class = "EnemyRole"
    },
    {
      category = "AI",
      id = "CanManEmplacements",
      name = "Can Man Emplacements",
      editor = "bool",
      default = true,
      template = true,
      no_edit = function(self)
        return IsMerc(self)
      end
    },
    {
      category = "AI",
      id = "current_archetype",
      name = "Archetype",
      editor = "preset_id",
      default = false,
      read_only = true,
      no_edit = true,
      template = true,
      no_edit = function(self)
        return IsMerc(self)
      end,
      preset_class = "AIArchetype"
    },
    {
      category = "AI",
      id = "RepositionArchetype",
      name = "Reposition Archetype",
      help = "if not specified the unit will use it's normal archetype for Reposition action",
      editor = "preset_id",
      default = false,
      template = true,
      no_edit = function(self)
        return IsMerc(self)
      end,
      preset_class = "AIArchetype"
    },
    {
      category = "AI",
      id = "AlwaysUseOpeningAttack",
      name = "Always Use Opening Attack",
      editor = "bool",
      default = false,
      template = true,
      no_edit = function(self)
        return IsMerc(self)
      end
    },
    {
      category = "AI",
      id = "OpeningAttackType",
      name = "Opening Attack Type",
      editor = "choice",
      default = "Default",
      template = true,
      no_edit = function(self)
        return IsMerc(self)
      end,
      items = function(self)
        return {
          "Default",
          "Overwatch",
          "PinDown"
        }
      end
    },
    {
      category = "AI",
      id = "PinnedDownChance",
      name = "PinnedDown Chance",
      help = "chance to use PinnedDown archetype when the unit is pinned down by enemy/enemies",
      editor = "number",
      default = 50,
      template = true,
      no_edit = function(self)
        return IsMerc(self)
      end,
      min = 0
    },
    {
      category = "AI",
      id = "MaxAttacks",
      help = "max attacks to perform per turn",
      editor = "number",
      default = 3,
      template = true,
      no_edit = function(self)
        return IsMerc(self)
      end,
      min = 1
    },
    {
      category = "AI",
      id = "PickCustomArchetype",
      help = "implement custom archetype selection logic for this unit; standard retreat/reposition logic overrides this choice",
      editor = "func",
      default = function(self, proto_context)
      end,
      template = true,
      no_edit = function(self)
        return IsMerc(self)
      end,
      params = "self, proto_context"
    },
    {
      category = "Equipment",
      id = "CustomEquipGear",
      help = "implement custom logic for equipping starting gear for this unit; standard gearing logic is applied after this",
      editor = "func",
      default = function(self, items)
      end,
      template = true,
      params = "self, items"
    },
    {
      category = "Villain",
      id = "Lives",
      editor = "number",
      default = 3,
      template = true,
      no_edit = function(self)
        return not self.villain
      end,
      min = 1,
      max = 5
    },
    {
      category = "XP",
      id = "Experience",
      editor = "number",
      default = false,
      no_edit = true,
      template = true
    },
    {
      category = "XP",
      id = "RewardExperience",
      name = "XP override",
      help = "The amount of XP the unit will reward its enemies when defeated. If left unset the XPRewardTable table is used.",
      editor = "number",
      default = false,
      template = true
    },
    {
      category = "XP",
      id = "statGainingPoints",
      editor = "number",
      default = 0,
      no_edit = true,
      template = true,
      min = 0
    },
    {
      category = "XP",
      id = "UnitPower",
      help = "Unit power used in autoresolve: base unitLevel if non merc * basePower const",
      editor = "number",
      default = 0,
      dont_save = true,
      read_only = true,
      template = true,
      min = 0
    },
    {
      category = "XP",
      id = "unitPowerModifier",
      name = "Unit Power Modifier",
      help = "How effective(%) is the unit power in autoresolve.",
      editor = "number",
      default = 100,
      template = true,
      min = 0
    },
    {
      category = "Villain",
      id = "DefeatBehavior",
      name = "Defeat Behavior",
      editor = "choice",
      default = "Dead",
      template = true,
      no_edit = function(self)
        return not self.villain
      end,
      items = function(self)
        return {"Dead", "Defeated"}
      end
    },
    {
      category = "Villain",
      id = "RetreatBehavior",
      name = "Retreat Behavior",
      editor = "choice",
      default = "Full Retreat",
      template = true,
      no_edit = function(self)
        return not self.villain
      end,
      items = function(self)
        return {
          "None",
          "Individual",
          "Full Retreat"
        }
      end
    },
    {
      category = "Derived Stats",
      id = "ActionPoints",
      name = "Action Points",
      help = "This parameters determines how much actions a merc can do in a single round",
      editor = "number",
      default = false,
      no_edit = true,
      scale = "AP"
    },
    {
      category = "Derived Stats",
      id = "MaxActionPoints",
      name = "Max Action Points",
      help = "This parameters determines how much actions a merc can do in a single round",
      editor = "number",
      default = false,
      dont_save = true,
      read_only = true,
      no_edit = true,
      template = true,
      scale = "AP"
    },
    {
      category = "Derived Stats",
      id = "Tiredness",
      editor = "number",
      default = 0,
      read_only = true,
      no_edit = true,
      template = true,
      min = -1,
      max = 3
    },
    {
      category = "Derived Stats",
      id = "RestTimer",
      editor = "number",
      default = 0,
      read_only = true,
      no_edit = true,
      template = true,
      min = 0
    },
    {
      category = "Derived Stats",
      id = "TravelTimerStart",
      editor = "number",
      default = 0,
      read_only = true,
      no_edit = true,
      template = true,
      min = 0
    },
    {
      category = "Derived Stats",
      id = "TravelTime",
      editor = "number",
      default = 0,
      read_only = true,
      no_edit = true,
      template = true,
      min = 0
    },
    {
      category = "Derived Stats",
      id = "HitPoints",
      name = "Hit Points",
      editor = "number",
      default = -1,
      no_edit = true,
      min = -1,
      max = 100
    },
    {
      category = "Derived Stats",
      id = "MaxHitPoints",
      name = "Max Hit Points",
      editor = "number",
      default = 0,
      read_only = true,
      no_edit = true,
      template = true
    },
    {
      category = "Likes And Dislikes",
      id = "Likes",
      editor = "string_list",
      default = {},
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      item_default = "",
      items = function(self)
        return MercPresetCombo()
      end
    },
    {
      category = "Likes And Dislikes",
      id = "LearnToLike",
      editor = "string_list",
      default = {},
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      item_default = "",
      items = function(self)
        return MercPresetCombo()
      end
    },
    {
      category = "Likes And Dislikes",
      id = "Dislikes",
      editor = "string_list",
      default = {},
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      item_default = "",
      items = function(self)
        return MercPresetCombo()
      end
    },
    {
      category = "Likes And Dislikes",
      id = "LearnToDislike",
      editor = "string_list",
      default = {},
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      item_default = "",
      items = function(self)
        return MercPresetCombo()
      end
    },
    {
      category = "Likes And Dislikes",
      id = "LikedBy",
      editor = "string_list",
      default = {},
      dont_save = true,
      read_only = true,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      item_default = "",
      items = function(self)
        return MercPresetCombo()
      end
    },
    {
      category = "Likes And Dislikes",
      id = "DislikedBy",
      editor = "string_list",
      default = {},
      dont_save = true,
      read_only = true,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      item_default = "",
      items = function(self)
        return MercPresetCombo()
      end
    },
    {
      category = "Perks",
      id = "StartingPerks",
      name = "Starting Perks",
      editor = "preset_id_list",
      default = {},
      template = true,
      editor_preview = true,
      preset_class = "CharacterEffectCompositeDef",
      preset_filter = function(preset, obj)
        return preset.object_class == "Perk"
      end,
      item_default = ""
    },
    {
      id = "Operation",
      name = "Operation",
      editor = "text",
      default = "Idle",
      no_edit = true,
      template = true
    },
    {
      id = "OperationProfession",
      editor = "text",
      default = "Idle",
      no_edit = true,
      template = true
    },
    {
      id = "OperationProfessions",
      name = "OperationProfessions",
      editor = "prop_table",
      default = false
    },
    {
      id = "OperationInitialETA",
      editor = "number",
      default = false,
      no_edit = true,
      template = true
    },
    {
      id = "HiredUntil",
      editor = "number",
      default = false,
      no_edit = true,
      no_edit = function(self)
        return not IsMerc(self)
      end
    },
    {
      id = "Squad",
      editor = "number",
      default = false,
      no_edit = true
    },
    {
      id = "OldSquad",
      editor = "number",
      default = 0,
      no_edit = true
    },
    {
      id = "heal_wound_progress",
      editor = "number",
      default = 0,
      no_edit = true
    },
    {
      id = "wounds_being_treated",
      editor = "number",
      default = 0,
      no_edit = true
    },
    {
      id = "arriving_progress",
      editor = "number",
      default = 0,
      no_edit = true
    },
    {
      id = "traveling_progress",
      help = "Travelling activity progress",
      editor = "number",
      default = 0,
      no_edit = true
    },
    {
      id = "randr_activity_progress",
      editor = "number",
      default = 0,
      no_edit = true,
      min = 0
    },
    {
      id = "arrival_dir",
      editor = "text",
      default = false,
      no_edit = true
    },
    {
      id = "gather_intel_progress",
      help = "Intel item is discovered when progress is 1000",
      editor = "number",
      default = 0,
      no_edit = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      min = 0
    },
    {
      id = "gather_intel_item_id",
      editor = "text",
      default = false,
      no_edit = true,
      no_edit = function(self)
        return not IsMerc(self)
      end
    },
    {
      id = "gather_intel_sector_id",
      editor = "text",
      default = false,
      no_edit = true,
      no_edit = function(self)
        return not IsMerc(self)
      end
    },
    {
      id = "stat_learning",
      editor = "prop_table",
      default = false
    },
    {
      id = "training_activity_progress",
      editor = "prop_table",
      default = false
    },
    {
      id = "already_spawned_on_map",
      editor = "bool",
      default = false,
      no_edit = true
    },
    {
      id = "stains",
      editor = "nested_list",
      default = false,
      no_edit = true,
      base_class = "UnitStain",
      inclusive = true
    },
    {
      id = "retreat_to_sector",
      editor = "text",
      default = false,
      no_edit = true
    },
    {
      category = "Appearance",
      id = "AppearancesList",
      name = "Appearances List",
      editor = "nested_list",
      default = false,
      template = true,
      base_class = "AppearanceWeight",
      inclusive = true,
      auto_expand = true
    },
    {
      category = "Appearance",
      id = "ForcedAppearance",
      editor = "text",
      default = false,
      no_edit = true
    },
    {
      category = "Spawn",
      id = "SpawnAppearancesButton",
      editor = "buttons",
      default = false,
      buttons = {
        {
          name = "Spawn All NPCs",
          func = "SpawnAll"
        }
      }
    },
    {
      category = "Spawn",
      id = "SpawnButton",
      editor = "buttons",
      default = false,
      buttons = {
        {
          name = "Spawn Random",
          func = "Spawn"
        }
      }
    },
    {
      category = "Spawn",
      id = "Spawn",
      editor = "func",
      default = function(self, pos)
        local weighted_list = GetAppearancesListTotalWeight(self)
        local slot = AsyncRand(weighted_list.total_weight)
        local appearance = GetWeightedAppearance(weighted_list, slot)
        local spawn_pos = GetTerrainCursorXY(UIL.GetScreenSize() / 2)
        local obj = AppearanceObjectAME:new()
        obj:ApplyAppearance(appearance)
        obj:SetPos(spawn_pos)
        obj:SetGameFlags(const.gofRealTimeAnim)
      end,
      read_only = true,
      no_edit = true,
      params = "self, pos"
    },
    {
      category = "Spawn",
      id = "SpawnAll",
      editor = "func",
      default = function(self)
        local characters = {}
        local widths = {}
        local total_width = 0
        for i, descr in ipairs(self.AppearancesList) do
          characters[i] = AppearanceObjectAME:new()
          characters[i]:ApplyAppearance(descr.Preset)
          local width = characters[i]:GetSize():sizex()
          widths[i] = width
          total_width = total_width + width + guim
        end
        local right = camera.GetRight()
        local lookat = camera.GetEye()
        local spawn_pos = GetTerrainCursorXY(UIL.GetScreenSize() / 2)
        spawn_pos = spawn_pos - SetLen(right, total_width / 2)
        for i, character in ipairs(characters) do
          character:SetPos(spawn_pos)
          character:Face(lookat)
          character:SetGameFlags(const.gofRealTimeAnim)
          spawn_pos = spawn_pos + SetLen(right, widths[i] + guim)
        end
      end,
      read_only = true,
      no_edit = true
    },
    {
      id = "GetLogName",
      editor = "func",
      default = function(self)
        return self:GetDisplayName()
      end,
      read_only = true,
      no_edit = true
    },
    {
      id = "GetLevel",
      editor = "func",
      default = function(self, baseLevel)
        local curXp = self:GetProperty("Experience")
        local addLevel = 0
        if not IsMerc(self) and Game and not baseLevel then
          addLevel = GameDifficulties[Game.game_difficulty]:ResolveValue("unitBonusLevel") or 0
        end
        if not curXp then
          return self:GetProperty("StartingLevel") + addLevel
        end
        for i, xp in ipairs(XPTable) do
          if xp > curXp then
            return i - 1 + addLevel
          end
        end
        return #XPTable + addLevel
      end,
      read_only = true,
      no_edit = true,
      params = "self, baseLevel"
    },
    {
      category = "Equipment",
      id = "Equipment",
      editor = "preset_id_list",
      default = {},
      template = true,
      editor_preview = true,
      preset_class = "LootDef",
      item_default = ""
    },
    {
      id = "Group",
      editor = "text",
      default = false,
      no_edit = true,
      translate = true
    },
    {
      category = "General",
      id = "AdditionalGroups",
      name = "Additional Groups",
      editor = "nested_list",
      default = false,
      template = true,
      base_class = "AdditionalGroup"
    },
    {
      id = "additional_groups",
      editor = "string_list",
      default = {},
      item_default = "",
      items = false,
      arbitrary_value = true
    },
    {
      id = "ControlledBy",
      editor = "number",
      default = 1,
      read_only = true,
      no_edit = true
    },
    {
      category = "Hiring - Parameters",
      id = "Tier",
      name = "Tier",
      editor = "combo",
      default = "Rookie",
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      items = function(self)
        return PresetGroupCombo("MercTiers", "Default")
      end
    },
    {
      category = "Hiring - Parameters",
      id = "Specialization",
      name = "Specialization",
      editor = "combo",
      default = "None",
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end,
      items = function(self)
        return PresetGroupCombo("MercSpecializations", "Default")
      end
    },
    {
      category = "Voice",
      id = "pollyvoice",
      name = "Polly Voice",
      editor = "choice",
      default = "Brian",
      template = true,
      items = function(self)
        return g_LocPollyActors
      end
    },
    {
      category = "Appearance",
      id = "species",
      name = "Species",
      editor = "choice",
      default = "Human",
      template = true,
      items = function(self)
        return {
          "Human",
          "Crocodile",
          "Hyena",
          "Lion",
          "Hen"
        }
      end
    },
    {
      category = "Appearance",
      id = "body_type",
      name = "Body Type",
      editor = "choice",
      default = "Human",
      template = true,
      items = function(self)
        return {
          "Human",
          "Small animal",
          "Large animal"
        }
      end
    },
    {
      category = "Appearance",
      id = "gender",
      name = "Gender",
      editor = "choice",
      default = "N/A",
      template = true,
      items = function(self)
        return {
          "N/A",
          "Male",
          "Female"
        }
      end
    },
    {
      category = "Appearance",
      id = "infected",
      name = "Infected",
      editor = "bool",
      default = false,
      template = true
    },
    {
      category = "Appearance",
      id = "blocked_spots",
      name = "Blocked Spots",
      editor = "set",
      default = false,
      template = true,
      items = function(self)
        return {"Weaponrs", "Weaponls"}
      end
    },
    {
      category = "General",
      id = "PersistentSessionId",
      name = "Persistent Session Id",
      help = "optional, all units spawned from this template will use the specified session id",
      editor = "text",
      default = false,
      template = true
    },
    {
      category = "Voice",
      id = "VoiceResponseId",
      name = "Voice Response Id",
      help = "The VoiceResponse preset used be this unit; same as the unit Id by default",
      editor = "preset_id",
      default = false,
      template = true,
      preset_class = "VoiceResponse"
    },
    {
      category = "Voice",
      id = "FallbackMissingVR",
      name = "FallbackMissingVR",
      help = "If no vr is found for this unit. Use this fallback unit for the vr. Applies only for Humans.",
      editor = "preset_id",
      default = "VillagerMale",
      template = true,
      preset_class = "UnitDataCompositeDef"
    },
    {
      category = "Appearance",
      id = "RoamAnimationSet",
      name = "Roam Animation Set",
      help = "The VoiceResponse preset used be this unit; same as the unit Id by default",
      editor = "preset_id",
      default = "Roam_Default",
      template = true,
      preset_class = "AnimationSet",
      preset_group = "AmbientLife"
    },
    {
      category = "General",
      id = "session_id",
      editor = "text",
      default = false,
      no_edit = true,
      translate = true
    },
    {
      id = "combat_damage_taken",
      help = "persistable damage taken, used for determining when to add Wounded status",
      editor = "number",
      default = 0,
      no_edit = true
    },
    {
      id = "time_of_death",
      help = "time of death (satellite time)",
      editor = "number",
      default = false,
      no_edit = true
    },
    {
      id = "randomization_seed",
      editor = "number",
      default = 0,
      no_edit = true
    },
    {
      category = "Hiring - Parameters",
      id = "DaysUntilOnline",
      name = "Days Until Online",
      help = "If the merc is set as offline at the beginning of the campaign through the randomess roll, it will automatically go online this amount of days after campaign start.",
      editor = "number",
      default = 5,
      template = true,
      no_edit = function(self)
        return not IsMerc(self)
      end
    },
    {
      id = "AccumulateDamageTaken",
      editor = "func",
      default = function(self, amount)
        local Wounded = CharacterEffectDefs.Wounded
        local wounded_add = Wounded:ResolveValue("HpLossToAddStack")
        self.combat_damage_taken = Min(self.combat_damage_taken, wounded_add)
        self.combat_damage_taken = self.combat_damage_taken + amount
        local threshold = MulDivRound(self:GetInitialMaxHitPoints(), Wounded:ResolveValue("WoundsImmunityThreshold"), 100)
        local stacks = 0
        while threshold > self.HitPoints and wounded_add <= self.combat_damage_taken do
          stacks = stacks + 1
          self.combat_damage_taken = self.combat_damage_taken - wounded_add
        end
        if 0 < stacks then
          self:AddWounds(stacks)
        end
      end,
      read_only = true,
      no_edit = true,
      params = "self, amount"
    },
    {
      id = "perkPoints",
      name = "Perk Points",
      help = "Avaliable points to spend on unlocking perks.",
      editor = "number",
      default = 0
    }
  }
}
function UnitProperties:SelectArchetype(proto_context)
  local archetype
  local func = empty_func
  if IsKindOf(self, "Unit") then
    local emplacement = g_Combat and g_Combat:GetEmplacementAssignment(self)
    if self.retreating then
      archetype = "Deserter"
    elseif self:HasStatusEffect("Panicked") then
      archetype = "Panicked"
    elseif self:HasStatusEffect("Berserk") then
      archetype = "Berserk"
    elseif emplacement then
      archetype = "EmplacementGunner"
      proto_context.target_interactable = emplacement
    elseif self.command == "Reposition" and self.RepositionArchetype then
      archetype = self.RepositionArchetype
    end
    local can_scout = not archetype
    can_scout = can_scout and (not g_Encounter or g_Encounter:CanScout())
    can_scout = can_scout and self.script_archetype ~= "GuardArea"
    if can_scout then
      local enemies = self:GetVisibleEnemies()
      if #enemies == 0 then
        self.last_known_enemy_pos = self.last_known_enemy_pos or AIPickScoutLocation(self)
        if self.last_known_enemy_pos then
          archetype = "Scout_LastLocation"
        end
      end
    end
    if not archetype then
      for _, descr in pairs(g_Pindown) do
        if descr.target == self then
          if self:Random(100) < self.PinnedDownChance then
            archetype = "PinnedDown"
          end
          break
        end
      end
    end
    local template = UnitDataDefs[self.unitdatadef_id]
    func = template and template.PickCustomArchetype or self.PickCustomArchetype
  end
  self.current_archetype = archetype or func(self, proto_context) or self.archetype or "Assault"
end
function UnitProperties:EquipStartingGear(items)
  local func = empty_func
  if IsKindOf(self, "UnitData") then
    local template = UnitDataDefs[self.class]
    func = template and template.CustomEquipGear or self.CustomEquipGear
  end
  func(self, items)
  if not self:GetItemInSlot("Handheld A", "BaseWeapon") then
    local has_weapon = self:TryEquip(items, "Handheld A", "Firearm")
    has_weapon = has_weapon or self:TryEquip(items, "Handheld A", "MeleeWeapon")
    has_weapon = has_weapon or self:TryEquip(items, "Handheld A", "HeavyWeapon")
  end
  local equipped = {}
  for i, item in ipairs(items) do
    if item.locked and not item:IsWeapon() and not IsKindOf(item, "Armor") and self:CanAddItem("Inventory", item) then
      self:AddItem("Inventory", item)
      equipped[i] = true
    end
  end
  for i, item in ipairs(items) do
    if not equipped[i] then
      local slot
      if IsKindOf(item, "QuickSlotItem") then
        if self:CanAddItem("Handheld A", item) then
          slot = "Handheld A"
        elseif self:CanAddItem("Handheld B", item) then
          slot = "Handheld B"
        end
      elseif IsKindOf(item, "Armor") and not self:GetItemInSlot(item.Slot) then
        slot = item.Slot
      end
      if slot and self:CanAddItem(slot, item) then
        self:AddItem(slot, item)
        equipped[i] = true
      end
    end
  end
  for _, slot in ipairs({"Handheld A", "Handheld B"}) do
    self:ForEachItemInSlot(slot, "Firearm", function(weapon)
      if not weapon.ammo or weapon.ammo.Amount <= 0 then
        local ammo = GetAmmosWithCaliber(weapon.Caliber, "sort")[1]
        if ammo then
          local tempAmmo = PlaceInventoryItem(ammo.id)
          tempAmmo.Amount = tempAmmo.MaxStacks
          weapon:Reload(tempAmmo, "suspend_fx")
          DoneObject(tempAmmo)
        end
      end
    end)
  end
  for i, item in ipairs(items) do
    if not equipped[i] then
      local pos, reason = self:AddItem("Inventory", item)
      if not pos then
        print("Couldn't add starting item '", item.class, "' to unit", self.class, "because", reason, "max slots", self:GetMaxTilesInSlot("Inventory"))
      end
    end
  end
end
function UnitProperties:TryEquip(items, slot, class)
  local idx
  for i, item in ipairs(items) do
    local match = class ~= "Firearm" or not IsKindOfClasses(item, "HeavyWeapon", "FlareGun")
    match = match and IsKindOf(item, class)
    if match and self:CanAddItem(slot, item) then
      idx = i
      break
    end
  end
  if idx then
    self:AddItem(slot, items[idx])
    table.remove(items, idx)
  end
  return not not idx
end
function UnitProperties:TryLoadAmmo(slot, weapon_class, ammo_id)
  local found
  local ammo = g_Classes[ammo_id]
  if not ammo then
    StoreErrorSource(self, string.format("Unit %s trying to load invalid ammo type '%s'", self.unitdatadef_id or self.class, ammo_id))
    return
  end
  self:ForEachItemInSlot(slot, weapon_class, function(weapon)
    if weapon.Caliber ~= ammo.Caliber then
      StoreErrorSource(self, string.format("Unit %s trying to load incompatible ammo type '%s' in their '%s'", self.unitdatadef_id or self.class, ammo_id, weapon.class))
      return
    end
    local tempAmmo = PlaceInventoryItem(ammo_id)
    tempAmmo.Amount = tempAmmo.MaxStacks
    weapon:Reload(tempAmmo, "suspend_fx")
    DoneObject(tempAmmo)
  end)
end
function UnitProperties:GetMaxActionPoints()
  local level = self:GetLevel()
  return (3 + self:GetProperty("Agility") / 10 + level / 3) * const.Scale.AP
end
function UnitProperties:SetTired(value)
  value = Clamp(value or 0, -1, 3)
  if self.Tiredness == value then
    return
  end
  self:RemoveStatusEffect("WellRested")
  self:RemoveStatusEffect("Tired")
  self:RemoveStatusEffect("Exhausted")
  self:RemoveStatusEffect("Unconscious")
  local oldValue = self.Tiredness or 0
  self.Tiredness = value
  if value == 3 then
    self.HitPoints = Max(1, self.HitPoints)
  elseif value ~= 0 and UnitTirednessEffect[value] then
    self:AddStatusEffect(UnitTirednessEffect[value])
  end
  if oldValue <= 0 and 0 <= value then
    Msg("UnitTiredAdded", self)
  elseif 0 < oldValue and value <= 0 then
    Msg("UnitTiredRemoved", self)
  end
end
function UnitProperties:ChangeTired(delta)
  self:SetTired(self.Tiredness + delta)
end
function UnitProperties:GetInitialMaxHitPoints()
  local mod = self:GetProperty("villain") and const.Combat.LieutenantHpMod or 100
  local maxhp = MulDivRound(self:GetProperty("Health"), mod, 100)
  if HasPerk(self, "BeefedUp") then
    maxhp = MulDivRound(maxhp, 100 + CharacterEffectDefs.BeefedUp:ResolveValue("bonus_health"), 100)
  end
  return maxhp
end
function UnitProperties:GetModifiedMaxHitPoints()
  local maxhp = self:GetInitialMaxHitPoints()
  local positive_mods_only = maxhp
  local idx = self:HasStatusEffect("Wounded")
  local effect = idx and self.StatusEffects[idx]
  if effect then
    local value = effect:ResolveValue("MaxHpReductionPerStack") or 0
    local maxreduce = effect:ResolveValue("MinMaxHp") or 0
    local min = MulDivRound(maxhp, maxreduce, 100)
    maxhp = Max(min, maxhp - effect.stacks * value)
  end
  return maxhp, positive_mods_only
end
function UnitProperties:GetInventoryMaxSlots()
  return IsMerc(self) and Max(4, (self.Strength - 30) / 5) or self.max_dead_slot_tiles or 20
end
function UnitProperties:IsDead()
  return self.HitPoints <= 0
end
function UnitProperties:GetHealthAsText()
  local max, max_positive = self:GetModifiedMaxHitPoints()
  if self:UIObscured() or self:UIConcealed() then
    return HpToText.Hidden
  elseif self.HitPoints >= 90 then
    return HpToText.Excellent
  elseif self.HitPoints >= 75 then
    return HpToText.Strong
  elseif self.HitPoints >= 60 then
    return HpToText.Healthy
  elseif self.HitPoints >= 45 and self.HitPoints ~= max_positive then
    return HpToText.Poor
  elseif self.HitPoints >= 25 and self.HitPoints ~= max_positive then
    return HpToText.Wounded
  elseif self.HitPoints >= 10 and self.HitPoints ~= max_positive then
    return HpToText.Critical
  elseif self.HitPoints > 0 and self.HitPoints ~= max_positive then
    return HpToText.Dying
  elseif self.HitPoints == 0 then
    return HpToText.Dead
  else
    return HpToText.Uninjured
  end
end
function UnitProperties:GetLikedBy()
  local id = IsKindOf(self, "UnitDataCompositeDef") and self.id or self.unitdatadef_id
  local res = {}
  for k, v in pairs(UnitDataDefs) do
    if table.find(v:GetProperty("Likes"), id) then
      res[#res + 1] = v.id
    end
  end
  return res
end
function UnitProperties:GetDislikedBy()
  local id = IsKindOf(self, "UnitDataCompositeDef") and self.id or self.unitdatadef_id
  local res = {}
  for k, v in pairs(UnitDataDefs) do
    if table.find(v:GetProperty("Dislikes"), id) then
      res[#res + 1] = v.id
    end
  end
  return res
end
function UnitProperties:GetUnitPower()
  return GetPowerOfUnit(self, "noMods")
end
function UnitProperties:GetStartingPerks()
  return self.StartingPerks
end
function UnitProperties:GetDisplayName()
  return self.Nick ~= "" and self.Nick or self.Name
end
function UnitProperties:AddWounds(wounds)
  wounds = AdjustWoundsToHP(self, wounds or 1)
  if 0 < wounds then
    self:AddStatusEffect("Wounded", wounds)
  end
end
function UnitProperties:GetBaseCrit(weapon)
  if not self then
    return weapon.CritChance + weapon.CritChanceScaled
  end
  return weapon.CritChance + MulDivRound(weapon.CritChanceScaled, self:GetLevel(), 10)
end
function UnitProperties:Getbase_BaseCrit(weapon)
  if not self then
    return weapon.base_CritChance + weapon.base_CritChanceScaled
  end
  return weapon.base_CritChance + MulDivRound(weapon.base_CritChanceScaled, self:GetLevel(), 10)
end
function UnitProperties:GetPersonalMorale()
  local teamMorale = self.team and self.team.morale or 0
  local personalMorale = 0
  local isDisliking = false
  for _, dislikedMerc in ipairs(self.Dislikes) do
    local dislikedIndex = table.find(self.team.units, "session_id", dislikedMerc)
    if dislikedIndex and not self.team.units[dislikedIndex]:IsDead() then
      personalMorale = personalMorale - 1
      isDisliking = true
      break
    end
  end
  if not isDisliking then
    for _, likedMerc in ipairs(self.Likes) do
      local likedIndex = table.find(self.team.units, "session_id", likedMerc)
      if likedIndex and not self.team.units[likedIndex]:IsDead() then
        personalMorale = personalMorale + 1
        break
      end
    end
  end
  local isWounded = false
  local idx = self:HasStatusEffect("Wounded")
  if idx and self.StatusEffects[idx].stacks >= 3 then
    isWounded = true
  end
  if self.HitPoints < MulDivRound(self.MaxHitPoints, 50, 100) or isWounded then
    if HasPerk(self, "Psycho") then
      personalMorale = personalMorale + 1
    else
      personalMorale = personalMorale - 1
    end
  end
  for _, likedMerc in ipairs(self.Likes) do
    local ud = gv_UnitData[likedMerc]
    if ud and ud.HireStatus == "Dead" then
      local deathDay = ud.HiredUntil
      if deathDay + 7 * const.Scale.day > Game.CampaignTime then
        personalMorale = personalMorale - 1
        break
      end
    end
  end
  if self:HasStatusEffect("ZoophobiaChecked") then
    personalMorale = personalMorale - 1
  end
  if self:HasStatusEffect("ClaustrophobiaChecked") then
    personalMorale = personalMorale - 1
  end
  if self:HasStatusEffect("FriendlyFire") then
    personalMorale = personalMorale - 1
  end
  if self:HasStatusEffect("Conscience_Guilty") then
    personalMorale = personalMorale - 1
  end
  if self:HasStatusEffect("Conscience_Sinful") then
    personalMorale = personalMorale - 2
  end
  if self:HasStatusEffect("Conscience_Proud") then
    personalMorale = personalMorale + 1
  end
  if self:HasStatusEffect("Conscience_Righteous") then
    personalMorale = personalMorale + 2
  end
  return Clamp(personalMorale + teamMorale, -3, 3)
end
function UnitProperties:HasPassedTimeAfterDeath(givenTime)
  if self.time_of_death then
    local deathTimeH = self.time_of_death / const.Scale.h
    local currentTimeH = Game.CampaignTime / const.Scale.h
    if currentTimeH >= deathTimeH + givenTime then
      return true
    end
  end
  return false
end
function UnitProperties:GetToughness()
  local toughness = self:GetLevel() * 1000
  local stats = UnitPropertiesStats:GetProperties()
  for _, stat in ipairs(stats) do
    toughness = toughness + self[stat.id]
  end
  return toughness
end
table.insert(UnitProperties.properties, {
  id = "signature_recharge",
  editor = "prop_table",
  default = false,
  no_edit = true
})
DefineClass.UnitPropertiesStats = {
  __parents = {
    "PropertyObject",
    "Modifiable"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      category = "Stats",
      id = "Health",
      name = T(561192724204, "Health"),
      help = T(755618869033, "Represents both the physical well-being of a merc and the amount of damage they can take before becoming downed."),
      editor = "number",
      default = 60,
      template = true,
      slider = true,
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Stats",
      id = "Agility",
      name = T(427915460935, "Agility"),
      help = T(313570226997, "Measures how well a merc reacts physically to a new situation. Affects the total amount of AP, free movement at start of turn, and how stealthy the merc is."),
      editor = "number",
      default = 60,
      template = true,
      slider = true,
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Stats",
      id = "Dexterity",
      name = T(460461870476, "Dexterity"),
      help = T(485643076124, "Measures a merc's ability to perform delicate or precise movements correctly. Affects bonus from aiming and Stealth Kill chance."),
      editor = "number",
      default = 60,
      template = true,
      slider = true,
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Stats",
      id = "Strength",
      name = T(736846833602, "Strength"),
      help = T(790754099931, "Represents muscle and brawn. It's particularly important in Melee combat, affects throwing range and the size of the personal inventory of the character."),
      editor = "number",
      default = 60,
      template = true,
      slider = true,
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Stats",
      id = "Wisdom",
      name = T(140562214443, "Wisdom"),
      help = T(731447408225, "Affects a merc's ability to learn from experience and training. Affects wilderness survival and the chance to notice hidden items and enemies."),
      editor = "number",
      default = 60,
      template = true,
      slider = true,
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Stats",
      id = "Leadership",
      name = T(693671613488, "Leadership"),
      help = T(396825125419, "Measures charm, respect and presence. Affects the rate for training militia and other mercs. Affects the chance for getting positive and negative Morale events."),
      editor = "number",
      default = 60,
      template = true,
      slider = true,
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Stats",
      id = "Marksmanship",
      name = T(616386794188, "Marksmanship"),
      help = T(403638137917, "Reflects a merc's ability to shoot accurately at any given target with a firearm."),
      editor = "number",
      default = 60,
      template = true,
      slider = true,
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Stats",
      id = "Mechanical",
      name = T(302186486914, "Mechanical"),
      help = T(338853681186, "Rates a merc's ability to repair damaged, worn-out or broken items and equipment. Important for lockpicking, machine handling and hacking electronic devices. Used for detecting and disarming non-explosive traps."),
      editor = "number",
      default = 60,
      template = true,
      slider = true,
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Stats",
      id = "Explosives",
      name = T(205333258567, "Explosives"),
      help = T(767865457232, "Determines a merc's ability to use grenades and other explosives and affects damage and mishap chance when using thrown items. Used for detecting and disarming explosive traps."),
      editor = "number",
      default = 60,
      template = true,
      slider = true,
      min = 0,
      max = 100,
      modifiable = true
    },
    {
      category = "Stats",
      id = "Medical",
      name = T(295773259174, "Medical"),
      help = T(249121777425, "Represents a merc's medical knowledge and ability to heal the wounded."),
      editor = "number",
      default = 60,
      template = true,
      slider = true,
      min = 0,
      max = 100,
      modifiable = true
    }
  }
}
function UnitPropertiesStats:GetAttributes()
  local result = self:GetProperties()
  result = table.ifilter(result, function(k, v)
    return v.id == "Health" or v.id == "Agility" or v.id == "Dexterity" or v.id == "Strength" or v.id == "Wisdom"
  end)
  return result
end
function UnitPropertiesStats:GetSkills()
  local result = self:GetProperties()
  result = table.ifilter(result, function(k, v)
    return v.id == "Marksmanship" or v.id == "Mechanical" or v.id == "Explosives" or v.id == "Medical" or v.id == "Leadership"
  end)
  return result
end
DefineClass.UnitTarget = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "TargetUnit",
      name = "Target Unit",
      help = "Target unit for match",
      editor = "combo",
      default = false,
      items = function(self)
        return GetTargetUnitCombo()
      end
    },
    {
      id = "DisableContextModification",
      help = "Disables modification of the current context units. Use this option when you don't want to affect the context of following conditions/effects.",
      editor = "bool",
      default = false
    }
  }
}
function UnitTarget:Match(target, unit, context)
  if target == "any" then
    return true
  elseif IsKindOf(unit, "Unit") and target == "any merc" then
    return unit:IsMerc()
  elseif IsKindOf(unit, "UnitData") and target == "any merc" then
    return IsMerc(UnitDataDefs[unit.class])
  elseif target == "player mercs on map" then
    return IsKindOf(unit, "Unit") and unit.team and unit.team.side == "player1"
  elseif target == "current unit" then
    return table.find(context and context.target_units or empty_table, unit)
  else
    if IsKindOf(unit, "Unit") then
      local groups = GetUnitGroups()
      if table.find(groups) and unit:IsInGroup(target) then
        return true
      end
    end
    if IsKindOf(unit, "CheeringDummy") then
      local groups = unit.Groups
      if table.find(groups, target) then
        return true
      end
    end
    if UnitDataDefs[target] and IsKindOfClasses(unit, "Unit", "UnitData") then
      return target == unit.unitdatadef_id or target == unit.class
    end
  end
  return false
end
function UnitTarget:MatchMapUnits(obj, context)
  local triggered
  local new_units = {}
  local units = false
  if self.TargetUnit == "player mercs on map" then
    local team = GetCampaignPlayerTeam()
    if team then
      units = team.units
    end
  end
  if context and not units then
    if self.TargetUnit == "current unit" then
      units = context.target_units
    elseif context.is_sector_unit then
      if not obj then
        return false
      end
      units = {obj}
    end
  end
  for _, unit in ipairs(units or g_Units) do
    if self:Match(self.TargetUnit, unit, context) and self:UnitCheck(unit, obj, context) then
      if not self.Negate then
        table.insert_unique(new_units, unit)
      end
      triggered = true
    elseif self.Negate then
      table.insert_unique(new_units, unit)
    end
  end
  if not self.DisableContextModification and type(context) == "table" then
    context.target_units = new_units
  end
  return triggered
end
function UnitTarget:UnitCheck(unit, obj, context)
  return true
end
DefineClass.UnitTypeListWithWeights = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "unitType",
      name = "Unit Type",
      help = "Type of the unit",
      editor = "preset_id",
      default = "",
      preset_class = "UnitDataCompositeDef",
      extra_item = "empty"
    },
    {
      id = "spawnWeight",
      name = "Spawn Weight",
      help = "The weight to assign for the given unit that determines the chance of choosing it",
      editor = "number",
      default = 100,
      min = 1,
      max = 100
    },
    {
      id = "conditions",
      name = "Conditions",
      help = "The unit is only added to the weight pool if the conditions pass.",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    },
    {
      id = "visualOverride",
      name = "Override Visuals",
      editor = "combo",
      default = false,
      items = function(self)
        return PresetsCombo("UnitDataCompositeDef")
      end
    },
    {
      id = "nameOverride",
      name = "Override Name",
      editor = "text",
      default = false,
      translate = true
    }
  }
}
function UnitTypeListWithWeights:GetEditorView()
  return tostring(self.unitType)
end
DefineClass.WeaponColor = {
  __parents = {"ListPreset"},
  __generated_by_class = "PresetDef",
  properties = {
    {
      id = "name",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "Slot",
      editor = "text",
      default = T(898895049831, "Color"),
      no_edit = true,
      translate = true
    },
    {
      id = "Description",
      editor = "text",
      default = false,
      translate = true
    },
    {
      id = "color",
      editor = "color",
      default = 4294967295
    },
    {
      id = "Roughness",
      name = "Roughness",
      editor = "range",
      default = false,
      min = -128,
      max = 127
    },
    {
      id = "Metallic",
      name = "Metallic",
      editor = "range",
      default = false,
      min = -256,
      max = 254
    },
    {
      id = "Cost",
      name = "Cost (Parts)",
      help = "The cost of the upgrade in parts",
      editor = "number",
      default = 0
    }
  }
}
