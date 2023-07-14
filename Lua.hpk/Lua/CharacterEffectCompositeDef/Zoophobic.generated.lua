UndefineClass("Zoophobic")
DefineClass.Zoophobic = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "OnAttacked",
      Handler = function(self, attacker, action, target, results, attack_args)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "OnAttacked")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, action, target, results, attack_args)
          if attacker.species ~= "Human" and not results.miss and not target:HasStatusEffect("ZoophobiaChecked") then
            CombatLog("debug", T({
              Untranslated("<em>Zoophobic</em> proc on <unit>"),
              unit = target.Name
            }))
            target:AddStatusEffect("ZoophobiaChecked")
          end
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(target, "StatusEffectObject") and target:HasStatusEffect(id) then
            exec(self, attacker, action, target, results, attack_args)
          end
        else
          exec(self, attacker, action, target, results, attack_args)
        end
      end,
      HandlerCode = function(self, attacker, action, target, results, attack_args)
        if attacker.species ~= "Human" and not results.miss and not target:HasStatusEffect("ZoophobiaChecked") then
          CombatLog("debug", T({
            Untranslated("<em>Zoophobic</em> proc on <unit>"),
            unit = target.Name
          }))
          target:AddStatusEffect("ZoophobiaChecked")
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(619689762390, "Zoophobic"),
  Description = T(467565005573, "Loses <GameTerm('Morale')> when <em>Attacked</em> by an <em>animal</em>."),
  Icon = "UI/Icons/Perks/Zoophobic",
  Tier = "Quirk"
}
