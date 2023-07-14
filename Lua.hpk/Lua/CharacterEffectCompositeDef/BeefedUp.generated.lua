UndefineClass("BeefedUp")
DefineClass.BeefedUp = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "StatusEffectAdded",
      Handler = function(self, obj, id, stacks)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "StatusEffectAdded")
        if not reaction_idx then
          return
        end
        local exec = function(self, obj, id, stacks)
          if IsKindOf(obj, "UnitProperties") then
            RecalcMaxHitPoints(obj)
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        if IsKindOf(obj, "UnitProperties") then
          RecalcMaxHitPoints(obj)
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
          if IsKindOf(obj, "UnitProperties") then
            RecalcMaxHitPoints(obj)
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        if IsKindOf(obj, "UnitProperties") then
          RecalcMaxHitPoints(obj)
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(877823816296, "Beefed Up"),
  Description = T(885436226092, "Max <em>HP</em> increased by <em><percent(bonus_health)></em>."),
  Icon = "UI/Icons/Perks/Fitness",
  Tier = "Bronze",
  Stat = "Health",
  StatValue = 70
}
