UndefineClass("ManningEmplacement")
DefineClass.ManningEmplacement = {
  __parents = {
    "CharacterEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "CharacterEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "StatusEffectRemoved",
      Handler = function(self, obj, id, stacks, reason)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "StatusEffectRemoved")
        if not reaction_idx then
          return
        end
        local exec = function(self, obj, id, stacks, reason)
          local emplacementHandle = obj:GetEffectValue("hmg_emplacement")
          local emplacementObj = HandleToObject[emplacementHandle]
          if emplacementObj then
            emplacementObj.manned_by = false
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        local emplacementHandle = obj:GetEffectValue("hmg_emplacement")
        local emplacementObj = HandleToObject[emplacementHandle]
        if emplacementObj then
          emplacementObj.manned_by = false
        end
      end,
      param_bindings = false
    })
  }
}
