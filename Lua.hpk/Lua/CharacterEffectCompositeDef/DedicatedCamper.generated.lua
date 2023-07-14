UndefineClass("DedicatedCamper")
DefineClass.DedicatedCamper = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "UnitBeginTurn",
      Handler = function(self, unit)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "UnitBeginTurn")
        if not reaction_idx then
          return
        end
        local exec = function(self, unit)
          unit:AddStatusEffect("Focused")
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
        unit:AddStatusEffect("Focused")
      end,
      param_bindings = false
    })
  },
  DisplayName = T(768808311402, "Smarter, Not Harder"),
  Description = T(153311106914, "Gains <GameTerm('Focused')> each turn. <AdditionalTerm('Grit')>"),
  Icon = "UI/Icons/Perks/DedicatedCamper",
  Tier = "Personal"
}
