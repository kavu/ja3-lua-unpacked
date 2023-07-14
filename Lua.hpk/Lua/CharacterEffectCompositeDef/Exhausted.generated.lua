UndefineClass("Exhausted")
DefineClass.Exhausted = {
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
          obj:AddStatusEffectImmunity("FreeMove", id)
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        obj:AddStatusEffectImmunity("FreeMove", id)
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
          obj:RemoveStatusEffectImmunity("FreeMove", id)
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        obj:RemoveStatusEffectImmunity("FreeMove", id)
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
          unit:ConsumeAP(-self:ResolveValue("ap_loss") * const.Scale.AP)
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
        unit:ConsumeAP(-self:ResolveValue("ap_loss") * const.Scale.AP)
      end,
      param_bindings = false
    })
  },
  DisplayName = T(707410221892, "Exhausted"),
  Description = T(787484805512, "Penalty of <em><ap_loss> is applied to your maximum AP</em>. Cannot gain <em>Free Move</em>. Recover by being idle for <duration> hours in Sat View."),
  AddEffectText = T(264384902433, "<em><DisplayName></em> is exhausted"),
  RemoveEffectText = T(377164938786, "<em><DisplayName></em> is no longer exhausted"),
  type = "Debuff",
  Icon = "UI/Hud/Status effects/exhausted",
  Shown = true,
  ShownSatelliteView = true,
  HasFloatingText = true
}
