UndefineClass("YouSeeIgor")
DefineClass.YouSeeIgor = {
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
          if HasPerk(attacker, self.id) then
            local ap = self:ResolveValue("APRestore") * #killedUnits * const.Scale.AP
            attacker:GainAP(ap)
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
        if HasPerk(attacker, self.id) then
          local ap = self:ResolveValue("APRestore") * #killedUnits * const.Scale.AP
          attacker:GainAP(ap)
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(532826806041, "You see, Igor..."),
  Description = T(364645895305, "Regain <em><APRestore> AP</em> after each <em>kill</em>."),
  Icon = "UI/Icons/Perks/YouSeeIgor",
  Tier = "Personal"
}
