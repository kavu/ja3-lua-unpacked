UndefineClass("CancelShot")
DefineClass.CancelShot = {
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
          if IsKindOf(obj, "Unit") then
            obj:InterruptPreparedAttack()
            obj:ActivatePerk("MeleeTraining")
            obj:RemoveStatusEffect("BandageInCombat")
            obj:RemoveStatusEffect("CancelShot")
            obj:UpdateMeleeTrainingVisual()
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        if IsKindOf(obj, "Unit") then
          obj:InterruptPreparedAttack()
          obj:ActivatePerk("MeleeTraining")
          obj:RemoveStatusEffect("BandageInCombat")
          obj:RemoveStatusEffect("CancelShot")
          obj:UpdateMeleeTrainingVisual()
        end
      end,
      param_bindings = false
    })
  }
}
