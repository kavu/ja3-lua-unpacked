UndefineClass("DeathFromAbove")
DefineClass.DeathFromAbove = {
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
          if cth_id == "GroundDifference" and data.base_chance > 0 and data.action.ActionType == "Ranged Attack" then
            data.mod_add = data.mod_add + self:ResolveValue("highground_cth_bonus")
            data.meta_text[#data.meta_text + 1] = T({
              776394275735,
              "Perk: <name>",
              name = self.DisplayName
            })
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
        if cth_id == "GroundDifference" and data.base_chance > 0 and data.action.ActionType == "Ranged Attack" then
          data.mod_add = data.mod_add + self:ResolveValue("highground_cth_bonus")
          data.meta_text[#data.meta_text + 1] = T({
            776394275735,
            "Perk: <name>",
            name = self.DisplayName
          })
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(733285334670, "Vantage Point"),
  Description = T(755928290476, [[
<em>Better Accuracy</em> when shooting from <em>high ground</em>.

<em>Cheaper AP</em> cost when climbing up and down <em>ladders</em>.]]),
  Icon = "UI/Icons/Perks/DeathFromAbove",
  Tier = "Silver",
  Stat = "Agility",
  StatValue = 80
}
