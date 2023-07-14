UndefineClass("NailsPerk")
DefineClass.NailsPerk = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "OnKill",
      Handler = function(self, attacker, killedUnits)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "OnKill")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, killedUnits)
          if HasPerk(attacker, self.id) then
            attacker:AddStatusEffect("Bloodthirst")
          end
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(attacker, "StatusEffectObject") and attacker:HasStatusEffect(id) then
            exec(self, attacker, killedUnits)
          end
        else
          exec(self, attacker, killedUnits)
        end
      end,
      HandlerCode = function(self, attacker, killedUnits)
        if HasPerk(attacker, self.id) then
          attacker:AddStatusEffect("Bloodthirst")
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(399524807633, "Nailed It"),
  Description = T(365161980518, "Gains <GameTerm('Bloodthirst')> after<em> first kill</em> in combat."),
  Icon = "UI/Icons/Perks/NailsPerk",
  Tier = "Personal"
}
