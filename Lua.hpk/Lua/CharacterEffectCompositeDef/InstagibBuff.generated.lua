UndefineClass("InstagibBuff")
DefineClass.InstagibBuff = {
  __parents = {
    "StatusEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "StatusEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "OnAttack",
      Handler = function(self, attacker, action, target, results, attack_args)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "OnAttack")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, action, target, results, attack_args)
          attacker:RemoveStatusEffect(self.id)
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(attacker, "StatusEffectObject") and attacker:HasStatusEffect(id) then
            exec(self, attacker, action, target, results, attack_args)
          end
        else
          exec(self, attacker, action, target, results, attack_args)
        end
      end,
      HandlerCode = function(self, attacker, action, target, results, attack_args)
        attacker:RemoveStatusEffect(self.id)
      end,
      param_bindings = false
    })
  },
  DisplayName = T(340473104221, "Sharpshooting"),
  Description = T(155527419493, "Next attack deals <em>extra Damage</em> and has an <em>Aiming bonus</em>."),
  Icon = "UI/Hud/Status effects/suppressive_barrage",
  RemoveOnEndCombat = true,
  Shown = true
}
