UndefineClass("Claustrophobic")
DefineClass.Claustrophobic = {
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
          if IsSectorUnderground(gv_CurrentSectorId) then
            for _, unit in ipairs(g_Units) do
              if HasPerk(unit, self.id) and not unit:HasStatusEffect("ClaustrophobicStatus") then
                CombatLog("debug", T({
                  Untranslated("<em>Claustrophobic</em> proc on <unit>"),
                  unit = unit.Name
                }))
                unit:AddStatusEffect("ClaustrophobiaChecked")
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
        if IsSectorUnderground(gv_CurrentSectorId) then
          for _, unit in ipairs(g_Units) do
            if HasPerk(unit, self.id) and not unit:HasStatusEffect("ClaustrophobicStatus") then
              CombatLog("debug", T({
                Untranslated("<em>Claustrophobic</em> proc on <unit>"),
                unit = unit.Name
              }))
              unit:AddStatusEffect("ClaustrophobiaChecked")
            end
          end
        end
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "OnEnterMapVisual",
      Handler = function(self)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "OnEnterMapVisual")
        if not reaction_idx then
          return
        end
        local exec = function(self)
          if IsSectorUnderground(gv_CurrentSectorId) then
            CreateGameTimeThread(function()
              while GetInGameInterfaceMode() == "IModeDeployment" do
                Sleep(20)
              end
              for _, unit in ipairs(g_Units) do
                if HasPerk(unit, self.id) and not unit:HasStatusEffect("ClaustrophobicStatus") then
                  PlayVoiceResponse(unit, "Claustrophobic")
                end
              end
            end)
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
            exec(self)
          end
        else
          exec(self)
        end
      end,
      HandlerCode = function(self)
        if IsSectorUnderground(gv_CurrentSectorId) then
          CreateGameTimeThread(function()
            while GetInGameInterfaceMode() == "IModeDeployment" do
              Sleep(20)
            end
            for _, unit in ipairs(g_Units) do
              if HasPerk(unit, self.id) and not unit:HasStatusEffect("ClaustrophobicStatus") then
                PlayVoiceResponse(unit, "Claustrophobic")
              end
            end
          end)
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(464805356385, "Claustrophobic"),
  Description = T(356135028604, "<GameTerm('Morale')> decrease when starting combat in <em>underground</em> Sectors."),
  Icon = "UI/Icons/Perks/Claustrophobic",
  Tier = "Quirk"
}
