UndefineClass("TakeAim")
DefineClass.TakeAim = {
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
          if cth_id == "SameTarget" then
            data.meta_text[#data.meta_text + 1] = T({
              776394275735,
              "Perk: <name>",
              name = self.DisplayName
            })
            data.mod_add = data.mod_add + self:ResolveValue("chanceToHitBonus")
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
        if cth_id == "SameTarget" then
          data.meta_text[#data.meta_text + 1] = T({
            776394275735,
            "Perk: <name>",
            name = self.DisplayName
          })
          data.mod_add = data.mod_add + self:ResolveValue("chanceToHitBonus")
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(600261683968, "Recoil Management"),
  Description = T(419896395078, "<em>Subsequent attacks</em> against the <em>same target</em> get an even higher <em>Accuracy</em> bonus."),
  Icon = "UI/Icons/Perks/TakeAim",
  Tier = "Bronze",
  Stat = "Strength",
  StatValue = 70
}
