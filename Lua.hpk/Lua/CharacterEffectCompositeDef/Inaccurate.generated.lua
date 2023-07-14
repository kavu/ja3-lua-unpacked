UndefineClass("Inaccurate")
DefineClass.Inaccurate = {
  __parents = {
    "StatusEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "StatusEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "GatherCTHModifications",
      Handler = function(self, attacker, cth_id, data)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "GatherCTHModifications")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, cth_id, data)
          if cth_id == self.id then
            data.mod_add = self:ResolveValue("accuracy_modifier")
          end
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(attacker, "StatusEffectObject") and attacker:HasStatusEffect(id) then
            exec(self, attacker, cth_id, data)
          end
        else
          exec(self, attacker, cth_id, data)
        end
      end,
      HandlerCode = function(self, attacker, cth_id, data)
        if cth_id == self.id then
          data.mod_add = self:ResolveValue("accuracy_modifier")
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(260481671641, "Inaccurate"),
  Description = T(100051142843, "Significant <em>Accuracy penalty</em> to all attacks."),
  type = "Debuff",
  lifetime = "Until End of Turn",
  Icon = "UI/Hud/Status effects/arms_pain",
  RemoveOnEndCombat = true,
  Shown = true,
  HasFloatingText = true
}
