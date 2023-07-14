UndefineClass("Hardened")
DefineClass.Hardened = {
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
          local ap = Min(self:ResolveValue("maxReservedAP"), unit:GetUIScaledAP())
          if 0 < ap then
            unit:ApplyTempHitPoints(ap * self:ResolveValue("tempHPperAP"))
            unit:AddStatusEffect("ReservedAP")
            unit:SetEffectValue("reserved_ap", ap * const.Scale.AP)
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
        local ap = Min(self:ResolveValue("maxReservedAP"), unit:GetUIScaledAP())
        if 0 < ap then
          unit:ApplyTempHitPoints(ap * self:ResolveValue("tempHPperAP"))
          unit:AddStatusEffect("ReservedAP")
          unit:SetEffectValue("reserved_ap", ap * const.Scale.AP)
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(248237546282, "Calm Under Fire"),
  Description = T(890208228589, [[
At the end of your turn, <em>transfer</em> up to <em><maxReservedAP> unused AP</em> to the next turn.

Gain <em><tempHPperAP></em> <GameTerm('Grit')> per <em>AP</em> transferred.]]),
  Icon = "UI/Icons/Perks/RifleDrills",
  Tier = "Gold",
  Stat = "Health",
  StatValue = 90
}
