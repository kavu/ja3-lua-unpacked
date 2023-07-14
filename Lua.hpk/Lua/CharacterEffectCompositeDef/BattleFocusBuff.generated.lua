UndefineClass("BattleFocusBuff")
DefineClass.BattleFocusBuff = {
  __parents = {
    "StatusEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "StatusEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "UnitBeginTurn",
      Handler = function(self, unit)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "UnitBeginTurn")
        if not reaction_idx then
          return
        end
        local exec = function(self, unit)
          local ap = CharacterEffectDefs.BattleFocus:ResolveValue("battleFocusAP") * const.Scale.AP
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
        local ap = CharacterEffectDefs.BattleFocus:ResolveValue("battleFocusAP") * const.Scale.AP
        unit:GainAP(ap)
      end,
      param_bindings = false
    })
  },
  DisplayName = T(314094810941, "Battle Focus"),
  Description = T(841305471051, "Maximum AP increased until the end of this battle."),
  Icon = "UI/Hud/Status effects/well_rested",
  RemoveOnEndCombat = true,
  Shown = true
}
