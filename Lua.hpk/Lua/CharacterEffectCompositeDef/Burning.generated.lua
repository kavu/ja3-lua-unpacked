UndefineClass("Burning")
DefineClass.Burning = {
  __parents = {
    "CharacterEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "CharacterEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "StatusEffectAdded",
      Handler = function(self, obj, id, stacks)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "StatusEffectAdded")
        if not reaction_idx then
          return
        end
        local exec = function(self, obj, id, stacks)
          if IsKindOf(obj, "Unit") then
            PlayFX("UnitBurning", "start", obj)
            obj:SetEffectValue("burning_start_time", GameTime())
            obj:AddStain("Burning", GetRandomStainSpot())
            ObjModified(obj)
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        if IsKindOf(obj, "Unit") then
          PlayFX("UnitBurning", "start", obj)
          obj:SetEffectValue("burning_start_time", GameTime())
          obj:AddStain("Burning", GetRandomStainSpot())
          ObjModified(obj)
        end
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "StatusEffectRemoved",
      Handler = function(self, obj, id, stacks, reason)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "StatusEffectRemoved")
        if not reaction_idx then
          return
        end
        local exec = function(self, obj, id, stacks, reason)
          if IsKindOf(obj, "Unit") then
            PlayFX("UnitBurning", "end", obj)
            obj:SetEffectValue("burning_start_time")
            obj:ClearStains("Burning")
            ObjModified(obj)
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        if IsKindOf(obj, "Unit") then
          PlayFX("UnitBurning", "end", obj)
          obj:SetEffectValue("burning_start_time")
          obj:ClearStains("Burning")
          ObjModified(obj)
        end
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "UnitBeginTurn",
      Handler = function(self, unit)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "UnitBeginTurn")
        if not reaction_idx then
          return
        end
        local exec = function(self, unit)
          local chance = 50 - Max(0, unit.Health - 50) / 2 - MulDivRound(unit:GetLevel(), 25, 10)
          if chance > unit:Random(100) then
            unit:AddStatusEffect("Panicked")
          end
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(unit, "StatusEffectObject") and unit:HasStatusEffect(id) then
            exec(self, unit)
          end
        else
          exec(self, unit)
        end
      end,
      HandlerCode = function(self, unit)
        local chance = 50 - Max(0, unit.Health - 50) / 2 - MulDivRound(unit:GetLevel(), 25, 10)
        if chance > unit:Random(100) then
          unit:AddStatusEffect("Panicked")
        end
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "UnitEndTurn",
      Handler = function(self, unit)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "UnitEndTurn")
        if not reaction_idx then
          return
        end
        local exec = function(self, unit)
          if not unit:IsDead() then
            EnvEffectBurningTick(unit, nil, "end turn")
          end
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(unit, "StatusEffectObject") and unit:HasStatusEffect(id) then
            exec(self, unit)
          end
        else
          exec(self, unit)
        end
      end,
      HandlerCode = function(self, unit)
        if not unit:IsDead() then
          EnvEffectBurningTick(unit, nil, "end turn")
        end
      end,
      param_bindings = false
    })
  },
  Modifiers = {
    PlaceObj("UnitModifier", {
      mod_add = -15,
      param_bindings = false,
      target_prop = "Wisdom"
    })
  },
  DisplayName = T(178364189448, "Burning"),
  Description = T(661121942943, "This character may <em>Panic</em> and will <em>take <damage> damage</em> at the end of each turn until they exit the flaming area. <em>Bandage</em> can cure the effect immediately."),
  AddEffectText = T(251545639918, "<em><DisplayName></em> is on fire"),
  type = "Debuff",
  Icon = "UI/Hud/Status effects/burning",
  RemoveOnSatViewTravel = true,
  RemoveOnCampaignTimeAdvance = true,
  Shown = true,
  HasFloatingText = true
}
