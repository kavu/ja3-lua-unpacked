UndefineClass("Inspired")
DefineClass.Inspired = {
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
          if g_Teams[g_CurrentTeam] == obj.team then
            obj:SetEffectValue("InspiredEffectApplied", true)
            obj:GainAP(self:ResolveValue("bonus") * const.Scale.AP)
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        if g_Teams[g_CurrentTeam] == obj.team then
          obj:SetEffectValue("InspiredEffectApplied", true)
          obj:GainAP(self:ResolveValue("bonus") * const.Scale.AP)
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
          obj:SetEffectValue("InspiredEffectApplied", nil)
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        obj:SetEffectValue("InspiredEffectApplied", nil)
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
          if not unit:GetEffectValue("InspiredEffectApplied") then
            unit:GainAP(self:ResolveValue("bonus") * const.Scale.AP)
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
        if not unit:GetEffectValue("InspiredEffectApplied") then
          unit:GainAP(self:ResolveValue("bonus") * const.Scale.AP)
        end
      end,
      param_bindings = false
    })
  },
  Conditions = {
    PlaceObj("CheckExpression", {
      Expression = function(self, obj)
        return g_Combat and IsKindOf(obj, "Unit")
      end,
      param_bindings = false
    })
  },
  DisplayName = T(122953001800, "Inspired"),
  Description = T(853696490891, "Gain <em><bonus> AP</em>."),
  AddEffectText = T(811015193839, "<em><DisplayName></em> is inspired"),
  type = "Buff",
  lifetime = "Until End of Turn",
  Icon = "UI/Hud/Status effects/inspired",
  RemoveOnEndCombat = true,
  Shown = true,
  HasFloatingText = true
}
