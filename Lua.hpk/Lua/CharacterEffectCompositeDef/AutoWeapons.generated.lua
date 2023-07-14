UndefineClass("AutoWeapons")
DefineClass.AutoWeapons = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "GatherCTHModifications",
      Handler = function(self, attacker, cth_id, data)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "GatherCTHModifications")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, cth_id, data)
          if cth_id == "Autofire" then
            data.meta_text[#data.meta_text + 1] = T({
              776394275735,
              "Perk: <name>",
              name = self.DisplayName
            })
            data.mod_mul = AutoWeapons:ResolveValue("automatics_penalty_reduction")
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
        if cth_id == "Autofire" then
          data.meta_text[#data.meta_text + 1] = T({
            776394275735,
            "Perk: <name>",
            name = self.DisplayName
          })
          data.mod_mul = AutoWeapons:ResolveValue("automatics_penalty_reduction")
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(971350457853, "Auto Weapons"),
  Description = T(938747433410, "Reduced <em>Accuracy</em> penalty when using <em>Burst Fire</em> or <em>Full Auto</em>."),
  Icon = "UI/Icons/Perks/AutoWeapons",
  Tier = "Specialization"
}
