UndefineClass("CageFighting")
DefineClass.CageFighting = {
  __parents = {
    "CharacterEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "CharacterEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "PreUnitDamaged",
      Handler = function(self, attacker, target, data)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "PreUnitDamaged")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, target, data)
          if target:HasStatusEffect("CageFightingToTheDeath") then
            return
          end
          local dmg = data.dmg
          local hpTotal = Max(0, target.HitPoints - dmg)
          local maxHp = target:GetInitialMaxHitPoints()
          local hpLoseAt = MulDivRound(maxHp, CageFightingLostAtPercent, 100)
          if hpTotal < hpLoseAt then
            dmg = target.HitPoints - hpLoseAt
            Msg("CageFightingLose", target)
            data.dmg = dmg
          end
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(target, "StatusEffectObject") and target:HasStatusEffect(id) then
            exec(self, attacker, target, data)
          end
        else
          exec(self, attacker, target, data)
        end
      end,
      HandlerCode = function(self, attacker, target, data)
        if target:HasStatusEffect("CageFightingToTheDeath") then
          return
        end
        local dmg = data.dmg
        local hpTotal = Max(0, target.HitPoints - dmg)
        local maxHp = target:GetInitialMaxHitPoints()
        local hpLoseAt = MulDivRound(maxHp, CageFightingLostAtPercent, 100)
        if hpTotal < hpLoseAt then
          dmg = target.HitPoints - hpLoseAt
          Msg("CageFightingLose", target)
          data.dmg = dmg
        end
      end,
      param_bindings = false
    })
  }
}
