UndefineClass("WellRested")
DefineClass.WellRested = {
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
          unit:GainAP(self:ResolveValue("ap_gain") * const.Scale.AP)
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
        unit:GainAP(self:ResolveValue("ap_gain") * const.Scale.AP)
      end,
      param_bindings = false
    })
  },
  DisplayName = T(789783285719, "Well Rested"),
  Description = T(418252801270, "Maximum <em>AP increased by <ap_gain></em>."),
  AddEffectText = T(353089370853, "<em><DisplayName></em> is well rested"),
  RemoveEffectText = T(945859256424, "<em><DisplayName></em> is no longer well rested"),
  type = "Buff",
  Icon = "UI/Hud/Status effects/well_rested",
  Shown = true,
  ShownSatelliteView = true,
  HasFloatingText = true
}
