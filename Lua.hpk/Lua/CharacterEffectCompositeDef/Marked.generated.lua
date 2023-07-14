UndefineClass("Marked")
DefineClass.Marked = {
  __parents = {
    "StatusEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "StatusEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "DamageTaken",
      Handler = function(self, attacker, target, dmg, hit_descr)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "DamageTaken")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, target, dmg, hit_descr)
          if IsKindOf(attacker, "Unit") and hit_descr.critical then
            target:RemoveStatusEffect("Marked")
          end
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
        if IsKindOf(attacker, "Unit") and hit_descr.critical then
          target:RemoveStatusEffect("Marked")
        end
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
          unit:RemoveStatusEffect("Marked")
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
        unit:RemoveStatusEffect("Marked")
      end,
      param_bindings = false
    })
  },
  DisplayName = T(659013327758, "Marked"),
  Description = T(644417904774, "Next hit against this unit will <em>score a Crit</em> unless prevented by armor or a <em>Grazing hit</em>."),
  AddEffectText = T(228474922512, "<em><DisplayName></em> is marked"),
  RemoveEffectText = T(751783684507, "<em><DisplayName></em> is no longer marked"),
  type = "Debuff",
  lifetime = "Until End of Turn",
  Icon = "UI/Hud/Status effects/marked",
  RemoveOnEndCombat = true,
  Shown = true
}
