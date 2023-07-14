UndefineClass("Exposed")
DefineClass.Exposed = {
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
          obj:RemoveStatusEffect("Protected")
          Msg("UnitMovementDone", obj)
          if not IsMerc(obj) and obj:IsUsingCover() then
            PlayVoiceResponse(obj, "AILoseCover")
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        obj:RemoveStatusEffect("Protected")
        Msg("UnitMovementDone", obj)
        if not IsMerc(obj) and obj:IsUsingCover() then
          PlayVoiceResponse(obj, "AILoseCover")
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
          Msg("UnitMovementDone", obj)
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        Msg("UnitMovementDone", obj)
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
          unit:RemoveStatusEffect("Exposed")
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
        unit:RemoveStatusEffect("Exposed")
      end,
      param_bindings = false
    })
  },
  Conditions = {
    PlaceObj("UnitIsCombatTurn", {
      Negate = true,
      TargetUnit = "current unit",
      param_bindings = false
    })
  },
  DisplayName = T(369202486284, "Exposed"),
  Description = T(458027451938, "Lose all benefits from being in <em>Cover</em>."),
  AddEffectText = T(427045387526, "<em><DisplayName></em> is exposed out of cover"),
  type = "Debuff",
  Icon = "UI/Hud/Status effects/exposed",
  RemoveOnEndCombat = true,
  Shown = true,
  HasFloatingText = true
}
