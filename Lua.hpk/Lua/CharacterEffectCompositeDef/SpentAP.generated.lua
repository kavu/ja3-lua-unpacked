UndefineClass("SpentAP")
DefineClass.SpentAP = {
  __parents = {
    "CharacterEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "CharacterEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "StatusEffectRemoved",
      Handler = function(self, obj, id, stacks, reason)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "StatusEffectRemoved")
        if not reaction_idx then
          return
        end
        local exec = function(self, obj, id, stacks, reason)
          obj:SetEffectValue("spent_ap", nil)
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        obj:SetEffectValue("spent_ap", nil)
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
          local ap = unit:GetEffectValue("spent_ap") or 0
          if 0 < ap then
            if unit:HasStatusEffect("FreeMoveOnCombatStart") then
              unit:RemoveStatusEffect("FreeMoveOnCombatStart")
            else
              unit:RemoveStatusEffect("FreeMove")
            end
            unit:RemoveStatusEffect("Focused")
            unit:ConsumeAP(ap)
            unit:RemoveStatusEffect("SpentAP")
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
        local ap = unit:GetEffectValue("spent_ap") or 0
        if 0 < ap then
          if unit:HasStatusEffect("FreeMoveOnCombatStart") then
            unit:RemoveStatusEffect("FreeMoveOnCombatStart")
          else
            unit:RemoveStatusEffect("FreeMove")
          end
          unit:RemoveStatusEffect("Focused")
          unit:ConsumeAP(ap)
          unit:RemoveStatusEffect("SpentAP")
        end
      end,
      param_bindings = false
    })
  },
  Conditions = {
    PlaceObj("CheckExpression", {
      Expression = function(self, obj)
        return IsKindOf(obj, "Unit")
      end,
      param_bindings = false
    })
  },
  RemoveOnEndCombat = true
}
