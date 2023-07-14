UndefineClass("ClaustrophobiaChecked")
DefineClass.ClaustrophobiaChecked = {
  __parents = {
    "StatusEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "StatusEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "ChangeMap",
      Handler = function(self, map)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "ChangeMap")
        if not reaction_idx then
          return
        end
        local exec = function(self, map)
          for _, unit in ipairs(g_Units) do
            unit:RemoveStatusEffect(self.id)
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
            exec(self, map)
          end
        else
          exec(self, map)
        end
      end,
      HandlerCode = function(self, map)
        for _, unit in ipairs(g_Units) do
          unit:RemoveStatusEffect(self.id)
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(145876002652, "Claustrophobia Checked"),
  Description = ""
}
