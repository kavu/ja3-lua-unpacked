UndefineClass("CounterfireCounter")
DefineClass.CounterfireCounter = {
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
          local effect = obj:GetStatusEffect("CounterfireCounter")
          if effect.stacks >= Counterfire:ResolveValue("hitsRequired") then
            obj:AddStatusEffect("Inspired")
            obj:RemoveStatusEffect(self.id, "all")
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        local effect = obj:GetStatusEffect("CounterfireCounter")
        if effect.stacks >= Counterfire:ResolveValue("hitsRequired") then
          obj:AddStatusEffect("Inspired")
          obj:RemoveStatusEffect(self.id, "all")
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
          unit:RemoveStatusEffect(self.id, "all")
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
        unit:RemoveStatusEffect(self.id, "all")
      end,
      param_bindings = false
    })
  },
  lifetime = "Until End of Turn",
  max_stacks = 99,
  RemoveOnEndCombat = true
}
