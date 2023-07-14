UndefineClass("StationedMachineGun")
DefineClass.StationedMachineGun = {
  __parents = {
    "CharacterEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "CharacterEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "EnterSector",
      Handler = function(self, game_start, load_game)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "EnterSector")
        if not reaction_idx then
          return
        end
        local exec = function(self, game_start, load_game)
          if not load_game then
            for _, unit in ipairs(g_Units) do
              if unit:HasStatusEffect("StationedMachineGun") then
                unit:InterruptPreparedAttack()
                unit:RemoveStatusEffect("StationedMachineGun")
              end
            end
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
            exec(self, game_start, load_game)
          end
        else
          exec(self, game_start, load_game)
        end
      end,
      HandlerCode = function(self, game_start, load_game)
        if not load_game then
          for _, unit in ipairs(g_Units) do
            if unit:HasStatusEffect("StationedMachineGun") then
              unit:InterruptPreparedAttack()
              unit:RemoveStatusEffect("StationedMachineGun")
            end
          end
        end
      end,
      param_bindings = false
    })
  }
}
