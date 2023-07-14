UndefineClass("VengeanceTarget")
DefineClass.VengeanceTarget = {
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
          for _, unit in ipairs(g_Units) do
            if unit.session_id ~= obj.session_id then
              unit:RemoveStatusEffect(self.id)
            end
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        for _, unit in ipairs(g_Units) do
          if unit.session_id ~= obj.session_id then
            unit:RemoveStatusEffect(self.id)
          end
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(394089630130, "Vengeance Target"),
  Description = T(788233999313, "Meltdown will become <em>Inspired</em> when attacking this enemy."),
  Icon = "UI/Hud/Status effects/vengeance_target",
  dontRemoveOnDeath = true,
  Shown = true
}
