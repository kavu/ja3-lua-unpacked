UndefineClass("SidneyPerkBuff")
DefineClass.SidneyPerkBuff = {
  __parents = {
    "CharacterEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "CharacterEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "AttackMiss",
      Handler = function(self, attacker, target)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "AttackMiss")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, target)
          attacker:RemoveStatusEffect(self.id)
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(attacker, "StatusEffectObject") and attacker:HasStatusEffect(id) then
            exec(self, attacker, target)
          end
        else
          exec(self, attacker, target)
        end
      end,
      HandlerCode = function(self, attacker, target)
        attacker:RemoveStatusEffect(self.id)
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "DamageTaken",
      Handler = function(self, attacker, target, dmg, hit_descr)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "DamageTaken")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, target, dmg, hit_descr)
          target:RemoveStatusEffect(self.id)
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(target, "StatusEffectObject") and target:HasStatusEffect(id) then
            exec(self, attacker, target, dmg, hit_descr)
          end
        else
          exec(self, attacker, target, dmg, hit_descr)
        end
      end,
      HandlerCode = function(self, attacker, target, dmg, hit_descr)
        target:RemoveStatusEffect(self.id)
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "UnitBeginTurn",
      Handler = function(self, unit)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "UnitBeginTurn")
        if not reaction_idx then
          return
        end
        local exec = function(self, unit)
          local ap = CharacterEffectDefs.SidneyPerk:ResolveValue("APBuff") * const.Scale.AP
          unit:GainAP(ap)
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(unit, "StatusEffectObject") and unit:HasStatusEffect(id) then
            exec(self, unit)
          end
        else
          exec(self, unit)
        end
      end,
      HandlerCode = function(self, unit)
        local ap = CharacterEffectDefs.SidneyPerk:ResolveValue("APBuff") * const.Scale.AP
        unit:GainAP(ap)
      end,
      param_bindings = false
    })
  },
  DisplayName = T(117305609925, "Smug"),
  Description = T(476004933629, [[
<em>Increased maximum AP</em>.

The effect is lost after taking <em>Damage</em> or <em>missing</em> with an attack.]]),
  Icon = "UI/Hud/Status effects/sidney_perk_buff",
  RemoveOnEndCombat = true,
  Shown = true,
  HasFloatingText = true
}
