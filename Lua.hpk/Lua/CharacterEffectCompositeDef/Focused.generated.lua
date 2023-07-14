UndefineClass("Focused")
DefineClass.Focused = {
  __parents = {
    "CharacterEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "CharacterEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "UnitEndTurn",
      Handler = function(self, unit)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "UnitEndTurn")
        if not reaction_idx then
          return
        end
        local exec = function(self, unit)
          local grit = self:ResolveValue("gritGain")
          unit:ApplyTempHitPoints(grit)
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
        local grit = self:ResolveValue("gritGain")
        unit:ApplyTempHitPoints(grit)
      end,
      param_bindings = false
    })
  },
  DisplayName = T(559363279892, "Focused"),
  Description = T(961434944074, "Deal more damage and gain <em>Grit</em> at the end of the turn. This effect is lost when the character moves, changes weapons or reloads."),
  type = "Buff",
  lifetime = "Until End of Turn",
  Icon = "UI/Hud/Status effects/focused",
  RemoveOnEndCombat = true,
  Shown = true
}
