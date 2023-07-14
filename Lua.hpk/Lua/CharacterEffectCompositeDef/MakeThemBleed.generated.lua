UndefineClass("MakeThemBleed")
DefineClass.MakeThemBleed = {
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
          local kills = #(results.killed_units or empty_table)
          if 0 < kills then
            attacker:AddToInventory("Trophy", kills)
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
        local kills = #(results.killed_units or empty_table)
        if 0 < kills then
          attacker:AddToInventory("Trophy", kills)
        end
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "GatherDamageModifications",
      Handler = function(self, attacker, target, attack_args, hit_descr, mod_data)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "GatherDamageModifications")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, target, attack_args, hit_descr, mod_data)
          if IsKindOf(target, "Unit") and (target.species ~= "Human" or attack_args.target_spot_group == "Groin") then
            mod_data.effects[#mod_data.effects + 1] = "Bleeding"
          end
          local enemiesInSight = GetTargetsToShowInPartyUI(attacker)
          local damagePerBleed = self:ResolveValue("damagePerBleed")
          local maxStacks = self:ResolveValue("maxStacks")
          local stacks = 0
          for _, unit in ipairs(enemiesInSight) do
            if unit:HasStatusEffect("Bleeding") then
              stacks = stacks + 1
            end
          end
          stacks = Min(stacks, maxStacks)
          local damageBonus = stacks * damagePerBleed
          mod_data.base_damage = MulDivRound(mod_data.base_damage, 100 + damageBonus, 100)
          mod_data.breakdown[#mod_data.breakdown + 1] = {
            name = self.DisplayName,
            value = damageBonus
          }
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(attacker, "StatusEffectObject") and attacker:HasStatusEffect(id) then
            exec(self, attacker, target, attack_args, hit_descr, mod_data)
          end
        else
          exec(self, attacker, target, attack_args, hit_descr, mod_data)
        end
      end,
      HandlerCode = function(self, attacker, target, attack_args, hit_descr, mod_data)
        if IsKindOf(target, "Unit") and (target.species ~= "Human" or attack_args.target_spot_group == "Groin") then
          mod_data.effects[#mod_data.effects + 1] = "Bleeding"
        end
        local enemiesInSight = GetTargetsToShowInPartyUI(attacker)
        local damagePerBleed = self:ResolveValue("damagePerBleed")
        local maxStacks = self:ResolveValue("maxStacks")
        local stacks = 0
        for _, unit in ipairs(enemiesInSight) do
          if unit:HasStatusEffect("Bleeding") then
            stacks = stacks + 1
          end
        end
        stacks = Min(stacks, maxStacks)
        local damageBonus = stacks * damagePerBleed
        mod_data.base_damage = MulDivRound(mod_data.base_damage, 100 + damageBonus, 100)
        mod_data.breakdown[#mod_data.breakdown + 1] = {
          name = self.DisplayName,
          value = damageBonus
        }
      end,
      param_bindings = false
    })
  },
  DisplayName = T(684856115226, "Make Them Bleed"),
  Description = T(303090649638, [[
<em>Bonus damage</em> for each <GameTerm('Bleeding')> enemy in sight.

<em>Groin attacks</em> and attacks against <em>animals</em> inflict <GameTerm('Bleeding')>.]]),
  Icon = "UI/Icons/Perks/MakeThemBleed",
  Tier = "Personal"
}
