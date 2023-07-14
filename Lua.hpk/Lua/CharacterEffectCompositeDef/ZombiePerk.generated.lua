UndefineClass("ZombiePerk")
DefineClass.ZombiePerk = {
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
          obj:AddStatusEffectImmunity("Suppressed", id)
          obj:AddStatusEffectImmunity("Bleeding", id)
          obj:AddStatusEffectImmunity("Inaccurate", id)
          obj:AddStatusEffectImmunity("Flanked", id)
          obj:AddStatusEffectImmunity("SuppressionChangeStance", id)
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        obj:AddStatusEffectImmunity("Suppressed", id)
        obj:AddStatusEffectImmunity("Bleeding", id)
        obj:AddStatusEffectImmunity("Inaccurate", id)
        obj:AddStatusEffectImmunity("Flanked", id)
        obj:AddStatusEffectImmunity("SuppressionChangeStance", id)
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "StatusEffectRemoved",
      Handler = function(self, obj, id, stacks, reason)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "StatusEffectRemoved")
        if not reaction_idx then
          return
        end
        local exec = function(self, obj, id, stacks, reason)
          obj:RemoveStatusEffectImmunity("Suppressed", id)
          obj:RemoveStatusEffectImmunity("Bleeding", id)
          obj:RemoveStatusEffectImmunity("Inaccurate", id)
          obj:RemoveStatusEffectImmunity("Flanked", id)
          obj:RemoveStatusEffectImmunity("SuppressionChangeStance", id)
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        obj:RemoveStatusEffectImmunity("Suppressed", id)
        obj:RemoveStatusEffectImmunity("Bleeding", id)
        obj:RemoveStatusEffectImmunity("Inaccurate", id)
        obj:RemoveStatusEffectImmunity("Flanked", id)
        obj:RemoveStatusEffectImmunity("SuppressionChangeStance", id)
      end,
      param_bindings = false
    })
  },
  DisplayName = T(725879214066, "Infected"),
  Description = T(141568768521, "Immune to Suppressed, Bleeding, Inaccurate, and Flanked."),
  Icon = "UI/Hud/Status effects/stabilized",
  Shown = true
}
