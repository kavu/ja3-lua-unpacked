UndefineClass("KnockDown")
DefineClass.KnockDown = {
  __parents = {
    "CharacterEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "CharacterEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "StatusEffectAdded",
      Handler = function(self, obj, id, stacks)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "StatusEffectAdded")
        if not reaction_idx then
          return
        end
        local exec = function(self, obj, id, stacks)
          if not IsKindOf(obj, "Unit") then
            return
          end
          if CurrentThread() == obj.command_thread then
            obj:KnockDown()
          else
            obj:SetCommand("KnockDown")
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        if not IsKindOf(obj, "Unit") then
          return
        end
        if CurrentThread() == obj.command_thread then
          obj:KnockDown()
        else
          obj:SetCommand("KnockDown")
        end
      end,
      param_bindings = false
    })
  },
  lifetime = "Until End of Turn",
  RemoveOnEndCombat = true
}
