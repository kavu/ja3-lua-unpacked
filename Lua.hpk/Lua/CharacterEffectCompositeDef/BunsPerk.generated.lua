UndefineClass("BunsPerk")
DefineClass.BunsPerk = {
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
          if cth_id == self.id and IsKindOf(data.target, "Unit") and IsValidTarget(data.target) then
            for _, unit in ipairs(data.target.hit_this_turn) do
              if unit ~= attacker and band(unit.team.ally_mask, attacker.team.team_mask) ~= 0 then
                data.mod_add = self:ResolveValue("CtHBonus")
                data.display_name = T({
                  776394275735,
                  "Perk: <name>",
                  name = self.DisplayName
                })
                return
              end
            end
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
        if cth_id == self.id and IsKindOf(data.target, "Unit") and IsValidTarget(data.target) then
          for _, unit in ipairs(data.target.hit_this_turn) do
            if unit ~= attacker and band(unit.team.ally_mask, attacker.team.team_mask) ~= 0 then
              data.mod_add = self:ResolveValue("CtHBonus")
              data.display_name = T({
                776394275735,
                "Perk: <name>",
                name = self.DisplayName
              })
              return
            end
          end
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(772183671804, "Anything You Can Do..."),
  Description = T(864899354526, "Gains <em>Accuracy</em> bonus against targets hit by an <em>ally</em> this turn."),
  Icon = "UI/Icons/Perks/BunsPerk",
  Tier = "Personal"
}
