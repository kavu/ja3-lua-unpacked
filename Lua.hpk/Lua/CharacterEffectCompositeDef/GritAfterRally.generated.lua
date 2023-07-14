UndefineClass("GritAfterRally")
DefineClass.GritAfterRally = {
  __parents = {
    "CharacterEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "CharacterEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "OnDownedRally",
      Handler = function(self, healer, target)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "OnDownedRally")
        if not reaction_idx then
          return
        end
        local exec = function(self, healer, target)
          local effect = target:GetStatusEffect(self.id)
          if effect and effect.stacks > 0 then
            target:ApplyTempHitPoints(effect.stacks)
            target:RemoveStatusEffect(self.id, "all")
          end
        end
        local id = GetCharacterEffectId(self)
        if id then
          local objs = {}
          for session_id, data in pairs(gv_UnitData) do
            local obj = g_Units[session_id] or data
            if obj:HasStatusEffect(id) then
              objs[session_id] = obj
            end
          end
          for _, obj in sorted_pairs(objs) do
            exec(self, healer, target)
          end
        else
          exec(self, healer, target)
        end
      end,
      HandlerCode = function(self, healer, target)
        local effect = target:GetStatusEffect(self.id)
        if effect and effect.stacks > 0 then
          target:ApplyTempHitPoints(effect.stacks)
          target:RemoveStatusEffect(self.id, "all")
        end
      end,
      param_bindings = false
    })
  },
  lifetime = "Until End of Turn",
  max_stacks = 100,
  RemoveOnEndCombat = true,
  RemoveOnSatViewTravel = true,
  RemoveOnCampaignTimeAdvance = true
}
