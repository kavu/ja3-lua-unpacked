UndefineClass("Unwell")
DefineClass.Unwell = {
  __parents = {
    "CharacterEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "CharacterEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "GatherCTHModifications",
      Handler = function(self, attacker, cth_id, data)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "GatherCTHModifications")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, cth_id, data)
          if cth_id == self.id and data.action.ActionType == "Ranged Attack" then
            data.mod_add = data.mod_add + self:ResolveValue("range_cth_mod")
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
        if cth_id == self.id and data.action.ActionType == "Ranged Attack" then
          data.mod_add = data.mod_add + self:ResolveValue("range_cth_mod")
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(728202676649, "Unwell"),
  Description = T(664298829629, "Lower <em>Accuracy</em> with <em>Ranged Attacks</em>\n"),
  Icon = "UI/Hud/Status effects/drunk",
  RemoveOnEndCombat = true,
  Shown = true,
  HasFloatingText = true
}
