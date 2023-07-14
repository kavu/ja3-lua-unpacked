UndefineClass("SingularPurposeBuff")
DefineClass.SingularPurposeBuff = {
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
          if results.miss then
            attacker:RemoveStatusEffect(self.id)
          end
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
        if results.miss then
          attacker:RemoveStatusEffect(self.id)
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(272692156562, "Total Concentration"),
  Description = T(118108207182, "<em>Damage increased</em> until the character <em>misses</em> a shot."),
  Icon = "UI/Hud/Status effects/concentrate",
  RemoveOnEndCombat = true,
  Shown = true
}
