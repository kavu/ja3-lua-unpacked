UndefineClass("Mobile")
DefineClass.Mobile = {
  __parents = {
    "StatusEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "StatusEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "StatusEffectAdded",
      Handler = function(self, obj, id, stacks)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "StatusEffectAdded")
        if not reaction_idx then
          return
        end
        local exec = function(self, obj, id, stacks)
          Msg("UnitAPChanged", obj)
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        Msg("UnitAPChanged", obj)
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
          Msg("UnitAPChanged", obj)
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        Msg("UnitAPChanged", obj)
      end,
      param_bindings = false
    })
  },
  DisplayName = T(756256221127, "Mobile"),
  Description = T(320614422830, "<em><percent(move_ap_modifier)></em> lower <em>Movement cost</em>"),
  type = "Buff",
  lifetime = "Until End of Next Turn",
  Icon = "UI/Hud/Status effects/mobility",
  RemoveOnEndCombat = true,
  Shown = true,
  HasFloatingText = true
}
