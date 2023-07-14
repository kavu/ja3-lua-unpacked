UndefineClass("Slowed")
DefineClass.Slowed = {
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
  DisplayName = T(801987474984, "Slowed"),
  Description = T(726867626791, "<em><percent(move_ap_modifier)></em> higher <em>Movement cost</em>."),
  AddEffectText = T(689905178968, "<em><DisplayName></em> is slowed"),
  type = "Debuff",
  lifetime = "Until End of Turn",
  Icon = "UI/Hud/Status effects/legs_pain",
  RemoveOnEndCombat = true,
  Shown = true,
  HasFloatingText = true
}
