UndefineClass("VengefulTemperament")
DefineClass.VengefulTemperament = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "OnAttack",
      Handler = function(self, attacker, action, target, results, attack_args)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "OnAttack")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, action, target, results, attack_args)
          if target and IsKindOf(target, "Unit") and target:HasStatusEffect("VengeanceTarget") then
            attacker:AddStatusEffect("Inspired")
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
        if target and IsKindOf(target, "Unit") and target:HasStatusEffect("VengeanceTarget") then
          attacker:AddStatusEffect("Inspired")
        end
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "OnAttacked",
      Handler = function(self, attacker, action, target, results, attack_args)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "OnAttacked")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, action, target, results, attack_args)
          if not results.miss and not IsMerc(attacker) then
            for _, unit in ipairs(g_Units) do
              unit:RemoveStatusEffect("VengeanceTarget")
            end
            attacker:AddStatusEffect("VengeanceTarget")
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
        if not results.miss and not IsMerc(attacker) then
          for _, unit in ipairs(g_Units) do
            unit:RemoveStatusEffect("VengeanceTarget")
          end
          attacker:AddStatusEffect("VengeanceTarget")
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(562100828460, "Hard Feelings"),
  Description = T(391944412961, "The last enemy to attack Meltdown is marked by <GameTerm('Vengeance')><AdditionalTerm('Inspired')>."),
  Icon = "UI/Icons/Perks/VengefulTemperament",
  Tier = "Personal"
}
