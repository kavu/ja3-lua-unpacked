UndefineClass("InnerInfo")
DefineClass.InnerInfo = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "OnEnterMapVisual",
      Handler = function(self)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "OnEnterMapVisual")
        if not reaction_idx then
          return
        end
        local exec = function(self)
          CreateGameTimeThread(function()
            local livewire = g_Units.Livewire
            local sector = gv_Sectors[gv_CurrentSectorId]
            local playVr
            if livewire and livewire.HireStatus == "Hired" and sector.intel_discovered then
              while GetInGameInterfaceMode() == "IModeDeployment" do
                Sleep(20)
              end
              for _, unit in ipairs(g_Units) do
                if unit:IsOnEnemySide(livewire) then
                  unit:RevealTo(livewire.team)
                  unit.innerInfoRevealed = true
                  playVr = true
                  break
                end
              end
              if playVr then
                Sleep(2000)
                PlayVoiceResponse(livewire, "PersonalPerkSubtitled")
              end
            end
          end)
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
        CreateGameTimeThread(function()
          local livewire = g_Units.Livewire
          local sector = gv_Sectors[gv_CurrentSectorId]
          local playVr
          if livewire and livewire.HireStatus == "Hired" and sector.intel_discovered then
            while GetInGameInterfaceMode() == "IModeDeployment" do
              Sleep(20)
            end
            for _, unit in ipairs(g_Units) do
              if unit:IsOnEnemySide(livewire) then
                unit:RevealTo(livewire.team)
                unit.innerInfoRevealed = true
                playVr = true
                break
              end
            end
            if playVr then
              Sleep(2000)
              PlayVoiceResponse(livewire, "PersonalPerkSubtitled")
            end
          end
        end)
      end,
      param_bindings = false
    })
  },
  DisplayName = T(380316218017, "Inside Dope"),
  Description = T(222768539188, "<em>Reveals</em> all <em>Enemies</em> if you have <em>Intel</em> for the Sector."),
  Icon = "UI/Icons/Perks/InnerInfo",
  Tier = "Personal"
}
