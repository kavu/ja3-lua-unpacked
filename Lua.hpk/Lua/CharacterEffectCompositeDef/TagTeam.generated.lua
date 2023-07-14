UndefineClass("TagTeam")
DefineClass.TagTeam = {
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
          if cth_id == self.id and IsKindOf(data.target, "Unit") and data.target:IsThreatened() then
            data.mod_add = data.mod_add + self:ResolveValue("accuracyBonus")
            data.display_name = T({
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
        if cth_id == self.id and IsKindOf(data.target, "Unit") and data.target:IsThreatened() then
          data.mod_add = data.mod_add + self:ResolveValue("accuracyBonus")
          data.display_name = T({
            776394275735,
            "Perk: <name>",
            name = self.DisplayName
          })
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(786595073425, "Tag Team"),
  Description = T(804189996555, "Bonus <em>Accuracy</em> against enemies within the <GameTerm('Overwatch')> area of an ally."),
  Icon = "UI/Icons/Perks/TagTeam",
  Tier = "Personal"
}
