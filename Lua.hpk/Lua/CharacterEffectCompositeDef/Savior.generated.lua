UndefineClass("Savior")
DefineClass.Savior = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "OnBandage",
      Handler = function(self, healer, target, healAmount)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "OnBandage")
        if not reaction_idx then
          return
        end
        local exec = function(self, healer, target, healAmount)
          if healer ~= target then
            healer:AddStatusEffect("FreeMove")
          end
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(healer, "StatusEffectObject") and healer:HasStatusEffect(id) then
            exec(self, healer, target, healAmount)
          end
        else
          exec(self, healer, target, healAmount)
        end
      end,
      HandlerCode = function(self, healer, target, healAmount)
        if healer ~= target then
          healer:AddStatusEffect("FreeMove")
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(322598238789, "Savior"),
  Description = T(665496332016, [[
Restore <em><percent(bandageBonus)></em> more <em>HP</em> when using <em>Bandage</em>.

Gain <GameTerm('FreeMove')> when using <em>Bandage</em> on an ally.
]]),
  Icon = "UI/Icons/Perks/Savior",
  Tier = "Bronze",
  Stat = "Wisdom",
  StatValue = 70
}
