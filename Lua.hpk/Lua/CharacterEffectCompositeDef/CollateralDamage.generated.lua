UndefineClass("CollateralDamage")
DefineClass.CollateralDamage = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "GatherDamageModifications",
      Handler = function(self, attacker, target, attack_args, hit_descr, mod_data)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "GatherDamageModifications")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, target, attack_args, hit_descr, mod_data)
          if not IsKindOf(target, "CombatObject") or not IsKindOfClasses(mod_data.weapon, "HeavyWeapon", "MachineGun") then
            return
          end
          if IsKindOf(target, "Unit") then
            if GetCoversAt(target:GetPos()) then
              local damageBonus = self:ResolveValue("enemyDamageMod")
              mod_data.base_damage = MulDivRound(mod_data.base_damage, 100 + damageBonus, 100)
              mod_data.breakdown[#mod_data.breakdown + 1] = {
                name = self.DisplayName,
                value = damageBonus
              }
            end
          else
            local damageBonus = self:ResolveValue("objectDamageMod")
            mod_data.base_damage = MulDivRound(mod_data.base_damage, 100 + damageBonus, 100)
            mod_data.breakdown[#mod_data.breakdown + 1] = {
              name = self.DisplayName,
              value = damageBonus
            }
          end
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
        if not IsKindOf(target, "CombatObject") or not IsKindOfClasses(mod_data.weapon, "HeavyWeapon", "MachineGun") then
          return
        end
        if IsKindOf(target, "Unit") then
          if GetCoversAt(target:GetPos()) then
            local damageBonus = self:ResolveValue("enemyDamageMod")
            mod_data.base_damage = MulDivRound(mod_data.base_damage, 100 + damageBonus, 100)
            mod_data.breakdown[#mod_data.breakdown + 1] = {
              name = self.DisplayName,
              value = damageBonus
            }
          end
        else
          local damageBonus = self:ResolveValue("objectDamageMod")
          mod_data.base_damage = MulDivRound(mod_data.base_damage, 100 + damageBonus, 100)
          mod_data.breakdown[#mod_data.breakdown + 1] = {
            name = self.DisplayName,
            value = damageBonus
          }
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(462837297109, "Collateral Damage"),
  Description = T(247186377267, [[
Deal <em><percent(enemyDamageMod)></em> extra <em>Damage</em> to enemies behind cover with <em>Heavy</em> <em>Weapons</em> and <em>Machine Guns</em>.

Deal <em><percent(objectDamageMod)> Damage</em> to objects with <em>Heavy</em> <em>Weapons</em> and <em>Machine Guns</em>.]]),
  Icon = "UI/Icons/Perks/CollateralDamage",
  Tier = "Gold",
  Stat = "Strength",
  StatValue = 90
}
