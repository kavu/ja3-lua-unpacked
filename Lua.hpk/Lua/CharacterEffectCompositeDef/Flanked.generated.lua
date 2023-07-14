UndefineClass("Flanked")
DefineClass.Flanked = {
  __parents = {
    "StatusEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "StatusEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "StatusEffectAdded",
      Handler = function(self, obj, id, stacks)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "StatusEffectAdded")
        if not reaction_idx then
          return
        end
        local exec = function(self, obj, id, stacks)
          if not obj:IsMerc() and IsNetPlayerTurn() then
            PlayVoiceResponse(obj, "AIFlanked")
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        if not obj:IsMerc() and IsNetPlayerTurn() then
          PlayVoiceResponse(obj, "AIFlanked")
        end
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "GatherTargetDamageModifications",
      Handler = function(self, attacker, target, attack_args, hit_descr, mod_data)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "GatherTargetDamageModifications")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, target, attack_args, hit_descr, mod_data)
          local flankBonus = self:ResolveValue("bonus")
          mod_data.base_damage = MulDivRound(mod_data.base_damage, 100 + flankBonus, 100)
          mod_data.breakdown[#mod_data.breakdown + 1] = {
            name = self.DisplayName,
            value = flankBonus
          }
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(target, "StatusEffectObject") and target:HasStatusEffect(id) then
            exec(self, attacker, target, attack_args, hit_descr, mod_data)
          end
        else
          exec(self, attacker, target, attack_args, hit_descr, mod_data)
        end
      end,
      HandlerCode = function(self, attacker, target, attack_args, hit_descr, mod_data)
        local flankBonus = self:ResolveValue("bonus")
        mod_data.base_damage = MulDivRound(mod_data.base_damage, 100 + flankBonus, 100)
        mod_data.breakdown[#mod_data.breakdown + 1] = {
          name = self.DisplayName,
          value = flankBonus
        }
      end,
      param_bindings = false
    })
  },
  DisplayName = T(529722665638, "Flanked"),
  Description = T(938831848548, "Threatened from both sides. Attacks against this character have <em>+<percent(bonus)> increased damage</em>."),
  type = "Debuff",
  Icon = "UI/Hud/Status effects/flanked",
  RemoveOnEndCombat = true,
  Shown = true
}
