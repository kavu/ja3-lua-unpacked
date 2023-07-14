UndefineClass("WeGotThis")
DefineClass.WeGotThis = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "OnKill",
      Handler = function(self, attacker, killedUnits)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "OnKill")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, killedUnits)
          if HasPerk(attacker, self.id) and attacker:CanActivatePerk(self.id) then
            local squad = gv_Squads[attacker.Squad]
            local tempHp = self:ResolveValue("tempHp")
            for _, id in ipairs(squad.units) do
              local unit = g_Units[id]
              unit:ApplyTempHitPoints(tempHp)
            end
            attacker:ActivatePerk(self.id)
          end
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(attacker, "StatusEffectObject") and attacker:HasStatusEffect(id) then
            exec(self, attacker, killedUnits)
          end
        else
          exec(self, attacker, killedUnits)
        end
      end,
      HandlerCode = function(self, attacker, killedUnits)
        if HasPerk(attacker, self.id) and attacker:CanActivatePerk(self.id) then
          local squad = gv_Squads[attacker.Squad]
          local tempHp = self:ResolveValue("tempHp")
          for _, id in ipairs(squad.units) do
            local unit = g_Units[id]
            unit:ApplyTempHitPoints(tempHp)
          end
          attacker:ActivatePerk(self.id)
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(287973663349, "Tango Down"),
  Description = T(446391581459, [[
<em>Once per turn</em>.
Grants <em><tempHp></em> <GameTerm('Grit')> to everyone in the squad after Gus kills an enemy.]]),
  Icon = "UI/Icons/Perks/WeGotThis",
  Tier = "Personal"
}
