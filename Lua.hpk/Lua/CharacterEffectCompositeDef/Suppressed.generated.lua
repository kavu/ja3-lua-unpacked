UndefineClass("Suppressed")
DefineClass.Suppressed = {
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
          if IsKindOf(obj, "Unit") then
            obj:ConsumeAP(-self:ResolveValue("ap_loss") * const.Scale.AP)
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        if IsKindOf(obj, "Unit") then
          obj:ConsumeAP(-self:ResolveValue("ap_loss") * const.Scale.AP)
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
          if IsKindOf(unit, "Unit") then
            unit:ConsumeAP(-self:ResolveValue("ap_loss") * const.Scale.AP)
          end
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
        if IsKindOf(unit, "Unit") then
          unit:ConsumeAP(-self:ResolveValue("ap_loss") * const.Scale.AP)
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(741267773678, "Suppressed"),
  Description = T(748124520136, "Penalty of <em><ap_loss> is applied to your maximum AP</em> for this turn. This character cannot <em>Flank</em> enemies."),
  AddEffectText = T(882347159665, "<em><DisplayName></em> is suppressed"),
  type = "Debuff",
  lifetime = "Until End of Turn",
  Icon = "UI/Hud/Status effects/suppressed",
  RemoveOnEndCombat = true,
  Shown = true,
  HasFloatingText = true
}
