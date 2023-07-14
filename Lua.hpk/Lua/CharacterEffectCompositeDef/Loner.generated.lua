UndefineClass("Loner")
DefineClass.Loner = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "CombatStart",
      Handler = function(self, dynamic_data)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "CombatStart")
        if not reaction_idx then
          return
        end
        local exec = function(self, dynamic_data)
          for _, unit in ipairs(g_Units) do
            if HasPerk(unit, self.id) then
              local proc = true
              for _, other in ipairs(unit.team.units) do
                if unit ~= other and DivRound(unit:GetDist(other), const.SlabSizeX) <= self:ResolveValue("loner_radius") then
                  proc = false
                  break
                end
              end
              if proc then
                unit:AddStatusEffect("Inspired")
                PlayVoiceResponse(unit, "Loner")
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
            exec(self, dynamic_data)
          end
        else
          exec(self, dynamic_data)
        end
      end,
      HandlerCode = function(self, dynamic_data)
        for _, unit in ipairs(g_Units) do
          if HasPerk(unit, self.id) then
            local proc = true
            for _, other in ipairs(unit.team.units) do
              if unit ~= other and DivRound(unit:GetDist(other), const.SlabSizeX) <= self:ResolveValue("loner_radius") then
                proc = false
                break
              end
            end
            if proc then
              unit:AddStatusEffect("Inspired")
              PlayVoiceResponse(unit, "Loner")
            end
          end
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(487342591563, "Loner"),
  Description = T(124325843871, "Become <GameTerm('Inspired')> when there are no teammates <em>in your vicinity</em> at turn start."),
  Icon = "UI/Icons/Perks/Loner",
  Tier = "Quirk"
}
