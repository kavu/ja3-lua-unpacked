UndefineClass("ShockAndAwe")
DefineClass.ShockAndAwe = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReactionEffects", {
      Effects = {
        PlaceObj("ConditionalEffect", {
          "Effects",
          {
            PlaceObj("ExecuteCode", {
              Code = function(self, obj)
                if IsKindOf(obj, "Unit") then
                  obj.team.morale = Max(1, obj.team.morale)
                end
              end,
              FuncCode = [[
if IsKindOf(obj, "Unit") then
	obj.team.morale = Max(1, obj.team.morale)
end]],
              SaveAsText = false,
              param_bindings = false
            })
          }
        })
      },
      Event = "EnterSector",
      Handler = function(self, game_start, load_game)
        CE_ExecReactionEffects(self, "EnterSector")
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
          if not (IsKindOf(attacker, "Unit") and attacker.team) or attacker.team.morale <= 0 then
            return
          end
          local damageBonus = self:ResolveValue("highMoraledmgBuff")
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
        if not (IsKindOf(attacker, "Unit") and attacker.team) or attacker.team.morale <= 0 then
          return
        end
        local damageBonus = self:ResolveValue("highMoraledmgBuff")
        mod_data.base_damage = MulDivRound(mod_data.base_damage, 100 + damageBonus, 100)
        mod_data.breakdown[#mod_data.breakdown + 1] = {
          name = self.DisplayName,
          value = damageBonus
        }
      end,
      param_bindings = false
    })
  },
  DisplayName = T(366436791486, "Shock and Awe"),
  Description = T(610150756892, [[
<em>High</em> <GameTerm('Morale')> when starting combat.

Deal <em><percent(highMoraledmgBuff)></em> extra <em>Damage</em> when <GameTerm('Morale')> is <em>High</em> or <em>Very High</em>.]]),
  Icon = "UI/Icons/Perks/ShockAndAwe",
  Tier = "Gold",
  Stat = "Wisdom",
  StatValue = 90
}
