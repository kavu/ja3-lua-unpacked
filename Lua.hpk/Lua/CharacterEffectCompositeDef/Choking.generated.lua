UndefineClass("Choking")
DefineClass.Choking = {
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
            obj:SetEffectValue("choking_start_time", GameTime())
            ObjModified(obj)
            if obj:IsMerc() then
              PlayVoiceResponse(obj, "GasAreaSelection")
            else
              PlayVoiceResponse(obj, "AIGasAreaSelection")
            end
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        if IsKindOf(obj, "Unit") then
          obj:SetEffectValue("choking_start_time", GameTime())
          ObjModified(obj)
          if obj:IsMerc() then
            PlayVoiceResponse(obj, "GasAreaSelection")
          else
            PlayVoiceResponse(obj, "AIGasAreaSelection")
          end
        end
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "StatusEffectRemoved",
      Handler = function(self, obj, id, stacks, reason)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "StatusEffectRemoved")
        if not reaction_idx then
          return
        end
        local exec = function(self, obj, id, stacks, reason)
          if IsKindOf(obj, "Unit") then
            obj:SetEffectValue("choking_start_time")
            ObjModified(obj)
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        if IsKindOf(obj, "Unit") then
          obj:SetEffectValue("choking_start_time")
          ObjModified(obj)
        end
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "UnitBeginTurn",
      Handler = function(self, unit)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "UnitBeginTurn")
        if not reaction_idx then
          return
        end
        local exec = function(self, unit)
          if unit:IsMerc() then
            PlayVoiceResponse(unit, "GasAreaSelection")
          else
            PlayVoiceResponse(unit, "AIGasAreaSelection")
          end
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
        if unit:IsMerc() then
          PlayVoiceResponse(unit, "GasAreaSelection")
        else
          PlayVoiceResponse(unit, "AIGasAreaSelection")
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
          if not unit:IsDead() then
            EnvEffectToxicGasTick(unit, nil, "end turn")
          end
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
        if not unit:IsDead() then
          EnvEffectToxicGasTick(unit, nil, "end turn")
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(720153419307, "Choking"),
  Description = T(120652127957, "This character will <em>take <damage> damage</em> at the end of their turn. The character also <em>loses Energy</em>."),
  AddEffectText = T(478064574365, "<em><DisplayName></em> is choking"),
  type = "Debuff",
  Icon = "UI/Hud/Status effects/choking",
  RemoveOnEndCombat = true,
  RemoveOnSatViewTravel = true,
  RemoveOnCampaignTimeAdvance = true,
  Shown = true,
  HasFloatingText = true
}
