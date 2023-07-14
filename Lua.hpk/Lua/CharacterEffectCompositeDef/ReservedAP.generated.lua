UndefineClass("ReservedAP")
DefineClass.ReservedAP = {
  __parents = {
    "CharacterEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "CharacterEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "UnitBeginTurn",
      Handler = function(self, unit)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "UnitBeginTurn")
        if not reaction_idx then
          return
        end
        local exec = function(self, unit)
          local ap = unit:GetEffectValue("reserved_ap") or 0
          if 0 < ap then
            unit:GainAP(ap)
          end
          unit:RemoveStatusEffect("ReservedAP")
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
        local ap = unit:GetEffectValue("reserved_ap") or 0
        if 0 < ap then
          unit:GainAP(ap)
        end
        unit:RemoveStatusEffect("ReservedAP")
      end,
      param_bindings = false
    })
  }
}
