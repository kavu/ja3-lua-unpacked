UndefineClass("Blinded")
DefineClass.Blinded = {
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
            obj:SetEffectValue("blinded_start_time", GameTime())
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
          obj:SetEffectValue("blinded_start_time", GameTime())
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
            obj:SetEffectValue("blinded_start_time")
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
          obj:SetEffectValue("blinded_start_time")
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
            EnvEffectTearGasTick(unit, nil, "start turn")
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
          EnvEffectTearGasTick(unit, nil, "start turn")
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
            EnvEffectTearGasTick(unit, nil, "end turn")
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
          EnvEffectTearGasTick(unit, nil, "end turn")
        end
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "GatherCTHModifications",
      Handler = function(self, attacker, cth_id, data)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "GatherCTHModifications")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, cth_id, data)
          if cth_id == self.id then
            data.mod_add = data.mod_add + self:ResolveValue("cth_effect")
          end
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(attacker, "StatusEffectObject") and attacker:HasStatusEffect(id) then
            exec(self, attacker, cth_id, data)
          end
        else
          exec(self, attacker, cth_id, data)
        end
      end,
      HandlerCode = function(self, attacker, cth_id, data)
        if cth_id == self.id then
          data.mod_add = data.mod_add + self:ResolveValue("cth_effect")
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(629298563884, "Blinded"),
  Description = T(595664130748, "Reduced <em>Sight range</em> and <em>Accuracy</em>. Can cause <em>Panic</em>."),
  AddEffectText = T(880622931884, "<em><DisplayName></em> is blinded"),
  type = "Debuff",
  Icon = "UI/Hud/Status effects/blinded",
  RemoveOnSatViewTravel = true,
  RemoveOnCampaignTimeAdvance = true,
  Shown = true,
  HasFloatingText = true
}
