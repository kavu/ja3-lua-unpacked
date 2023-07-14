UndefineClass("Smoked")
DefineClass.Smoked = {
  __parents = {
    "StatusEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "StatusEffect",
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
            obj:SetEffectValue("smoked_start_time", GameTime())
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
          obj:SetEffectValue("smoked_start_time", GameTime())
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
            obj:SetEffectValue("Smoked_start_time")
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
          obj:SetEffectValue("Smoked_start_time")
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
          if not unit:IsDead() then
            EnvEffectSmokeTick(unit, nil, "start turn")
            if unit:IsMerc() then
              PlayVoiceResponse(unit, "GasAreaSelection")
            else
              PlayVoiceResponse(unit, "AIGasAreaSelection")
            end
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
          EnvEffectSmokeTick(unit, nil, "start turn")
          if unit:IsMerc() then
            PlayVoiceResponse(unit, "GasAreaSelection")
          else
            PlayVoiceResponse(unit, "AIGasAreaSelection")
          end
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
            EnvEffectSmokeTick(unit, nil, "end turn")
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
          EnvEffectSmokeTick(unit, nil, "end turn")
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(191169991129, "In Smoke")
}
