UndefineClass("Unaware")
DefineClass.Unaware = {
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
          obj:RemoveStatusEffect("Suspicious")
          obj:RemoveStatusEffect("Surprised")
          if IsKindOf(obj, "Unit") then
            Msg("UnitAwarenessChanged", obj)
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        obj:RemoveStatusEffect("Suspicious")
        obj:RemoveStatusEffect("Surprised")
        if IsKindOf(obj, "Unit") then
          Msg("UnitAwarenessChanged", obj)
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
          obj:RemoveStatusEffect("Distracted")
          if IsKindOf(obj, "Unit") then
            Msg("UnitAwarenessChanged", obj)
          end
          if g_Combat then
            g_Combat.end_combat_pending = false
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        obj:RemoveStatusEffect("Distracted")
        if IsKindOf(obj, "Unit") then
          Msg("UnitAwarenessChanged", obj)
        end
        if g_Combat then
          g_Combat.end_combat_pending = false
        end
      end,
      param_bindings = false
    })
  },
  Conditions = {
    PlaceObj("CheckExpression", {
      Expression = function(self, obj)
        return not obj.team or not obj.team.neutral
      end,
      param_bindings = false
    })
  },
  DisplayName = T(947052613991, "Unaware"),
  Description = T(306118386349, "This character is not aware there are enemies in the Sector but will be alerted by noise or visuals of enemies. Very susceptible to <em>Stealth Kill</em> attempts made by sneaking characters."),
  Icon = "UI/Hud/Status effects/unaware",
  Shown = true
}
