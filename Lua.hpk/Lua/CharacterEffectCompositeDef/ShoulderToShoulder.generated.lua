UndefineClass("ShoulderToShoulder")
DefineClass.ShoulderToShoulder = {
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
          local proc = false
          local obj = unit
          for _, unit in ipairs(g_Units) do
            if obj.session_id ~= unit.session_id and obj:IsAdjacentTo(unit) and obj.team:IsAllySide(unit.team) then
              unit:ApplyTempHitPoints(self:ResolveValue("tempHp"))
              proc = true
            end
          end
          if proc then
            obj:ApplyTempHitPoints(self:ResolveValue("tempHp"))
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
        local proc = false
        local obj = unit
        for _, unit in ipairs(g_Units) do
          if obj.session_id ~= unit.session_id and obj:IsAdjacentTo(unit) and obj.team:IsAllySide(unit.team) then
            unit:ApplyTempHitPoints(self:ResolveValue("tempHp"))
            proc = true
          end
        end
        if proc then
          obj:ApplyTempHitPoints(self:ResolveValue("tempHp"))
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(157949271296, "Shoulder to Shoulder"),
  Description = T(653169257176, "Ending a turn <em>adjacent</em> to an <em>ally</em> grants <em><tempHp></em> <GameTerm('Grit')> to both Scully and the ally."),
  Icon = "UI/Icons/Perks/ShoulderToShoulder",
  Tier = "Personal"
}
