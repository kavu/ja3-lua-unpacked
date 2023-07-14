UndefineClass("Tired")
DefineClass.Tired = {
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
            obj:RemoveStatusEffect("FreeMove")
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        if IsKindOf(obj, "Unit") then
          obj:RemoveStatusEffect("FreeMove")
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
  DisplayName = T(299677471612, "Tired"),
  Description = T(689241800564, "Penalty of <em><ap_loss> is applied to your maximum AP</em>. Cannot gain <em>Free Move</em>. Recovers by being idle for <duration> hours in the Sat View."),
  AddEffectText = T(488444599414, "<em><DisplayName></em> is tired"),
  type = "Debuff",
  Icon = "UI/Hud/Status effects/tired",
  Shown = true,
  ShownSatelliteView = true,
  HasFloatingText = true
}
