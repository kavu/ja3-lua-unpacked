UndefineClass("StressManagement")
DefineClass.StressManagement = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "StatusEffectAdded",
      Handler = function(self, obj, id, stacks)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "StatusEffectAdded")
        if not reaction_idx then
          return
        end
        local exec = function(self, obj, id, stacks)
          if HasPerk(obj, self.id) and CharacterEffectDefs[id].type == "Debuff" and not obj:HasStatusEffect("StressManagementCounter") then
            obj:AddStatusEffect("Inspired")
            obj:AddStatusEffect("StressManagementCounter")
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        if HasPerk(obj, self.id) and CharacterEffectDefs[id].type == "Debuff" and not obj:HasStatusEffect("StressManagementCounter") then
          obj:AddStatusEffect("Inspired")
          obj:AddStatusEffect("StressManagementCounter")
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(578724057231, "Stress Management"),
  Description = T(957117254898, "Become <GameTerm('Inspired')> after suffering a <em>negative effect</em> for the <em>first time</em> in combat."),
  Icon = "UI/Icons/Perks/StressManagement",
  Tier = "Silver",
  Stat = "Wisdom",
  StatValue = 80
}
