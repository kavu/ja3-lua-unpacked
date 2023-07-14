UndefineClass("KillingWind")
DefineClass.KillingWind = {
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
          local enemiesHit = 0
          if results and results.hit_objs then
            for _, obj in ipairs(results.hit_objs) do
              if IsKindOf(obj, "Unit") and obj:IsOnEnemySide(attacker) then
                enemiesHit = enemiesHit + 1
              end
            end
          end
          if 2 <= enemiesHit then
            local grit = self:ResolveValue("gritPerEnemyHit") * enemiesHit
            attacker:ApplyTempHitPoints(grit)
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
        local enemiesHit = 0
        if results and results.hit_objs then
          for _, obj in ipairs(results.hit_objs) do
            if IsKindOf(obj, "Unit") and obj:IsOnEnemySide(attacker) then
              enemiesHit = enemiesHit + 1
            end
          end
        end
        if 2 <= enemiesHit then
          local grit = self:ResolveValue("gritPerEnemyHit") * enemiesHit
          attacker:ApplyTempHitPoints(grit)
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(219730505411, "Heavy Duty"),
  Description = T(958058532892, [[
Gains <em><gritPerEnemyHit></em> <GameTerm('Grit')> per enemy when hitting multiple enemies at once.

Improves the effect of the <em>Ironclad</em> perk to full <GameTerm('FreeMove')> with cumbersome gear and after <GameTerm('PackingUp')> a <em>Machine Gun</em>.
]]),
  Icon = "UI/Icons/Perks/KillingWind",
  Tier = "Personal"
}
