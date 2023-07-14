UndefineClass("SixthSense")
DefineClass.SixthSense = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "UnitEndTurn",
      Handler = function(self, unit)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "UnitEndTurn")
        if not reaction_idx then
          return
        end
        local exec = function(self, unit)
          local cover_id
          if g_Combat and unit:IsAware() then
            cover_id = GetHighestCover(unit)
          end
          if not cover_id and g_Combat:AreEnemiesAware(g_CurrentTeam) then
            unit:ApplyTempHitPoints(self:ResolveValue("tempHitPoints"))
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
        local cover_id
        if g_Combat and unit:IsAware() then
          cover_id = GetHighestCover(unit)
        end
        if not cover_id and g_Combat:AreEnemiesAware(g_CurrentTeam) then
          unit:ApplyTempHitPoints(self:ResolveValue("tempHitPoints"))
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(647806713105, "Open Ground Tactics"),
  Description = T(551000242911, "+<tempHitPoints> Grit each time you end turn out of cover."),
  Icon = "UI/Icons/Perks/Inescapable"
}
