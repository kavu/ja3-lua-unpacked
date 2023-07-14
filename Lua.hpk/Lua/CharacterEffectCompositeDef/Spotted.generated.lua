UndefineClass("Spotted")
DefineClass.Spotted = {
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
          if IsKindOf(obj, "Unit") then
            for _, team in ipairs(g_Teams) do
              local key = "Spotted-" .. team.side
              if obj:GetEffectValue(key) then
                obj:SetEffectValue(key, nil)
                team:OnEnemySighted(obj)
                obj:RevealTo(team)
              end
            end
            obj:UpdateHidden()
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        if IsKindOf(obj, "Unit") then
          for _, team in ipairs(g_Teams) do
            local key = "Spotted-" .. team.side
            if obj:GetEffectValue(key) then
              obj:SetEffectValue(key, nil)
              team:OnEnemySighted(obj)
              obj:RevealTo(team)
            end
          end
          obj:UpdateHidden()
        end
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "UnitEndTurn",
      Handler = function(self, unit)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "UnitEndTurn")
        if not reaction_idx then
          return
        end
        local exec = function(self, unit)
          unit:RemoveStatusEffect("Spotted")
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(unit, "StatusEffectObject") and unit:HasStatusEffect(id) then
            exec(self, unit)
          end
        else
          exec(self, unit)
        end
      end,
      HandlerCode = function(self, unit)
        unit:RemoveStatusEffect("Spotted")
      end,
      param_bindings = false
    })
  },
  DisplayName = T(808653194642, "Spotted"),
  Description = T(496089616387, "Spotted"),
  AddEffectText = T(886139698291, "Spotted")
}
