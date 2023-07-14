UndefineClass("Stabilized")
DefineClass.Stabilized = {
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
          CombatLog("important", T({
            952103166685,
            "<em><LogName></em> has been <em>stabilized</em>",
            obj
          }))
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        CombatLog("important", T({
          952103166685,
          "<em><LogName></em> has been <em>stabilized</em>",
          obj
        }))
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
          obj:SetEffectValue("stabilized")
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        obj:SetEffectValue("stabilized")
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
          unit:SetEffectValue("stabilized", true)
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
        unit:SetEffectValue("stabilized", true)
      end,
      param_bindings = false
    })
  },
  Conditions = {
    PlaceObj("CombatIsActive", {param_bindings = false})
  },
  DisplayName = T(119269521610, "Stabilized"),
  Description = T(800294038945, "The character is no longer <em>Downed</em> but cannot act until next turn."),
  Icon = "UI/Hud/Status effects/stabilized",
  Shown = true,
  HideOnBadge = true
}
