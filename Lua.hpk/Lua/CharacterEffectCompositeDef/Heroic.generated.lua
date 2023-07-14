UndefineClass("Heroic")
DefineClass.Heroic = {
  __parents = {
    "CharacterEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "CharacterEffect",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "GatherCTHModifications",
      Handler = function(self, attacker, cth_id, data)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "GatherCTHModifications")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, cth_id, data)
          if cth_id == self.id then
            data.mod_add = data.mod_add + self:ResolveValue("bonus_cth")
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
          data.mod_add = data.mod_add + self:ResolveValue("bonus_cth")
        end
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "StatusEffectAdded",
      Handler = function(self, obj, id, stacks)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "StatusEffectAdded")
        if not reaction_idx then
          return
        end
        local exec = function(self, obj, id, stacks)
          if IsKindOf(obj, "Unit") then
            local name = UnitsDisplayAlias({obj})
            local notification = obj.team.player_team and "allyMoraleEffect" or "enemyMoraleEffect"
            ShowTacticalNotification(notification, false, T({
              233709615153,
              "<name> is inspired to fight against all odds",
              name = name
            }))
            obj:GainAP(self:ResolveValue("ap_gain") * const.Scale.AP)
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        if IsKindOf(obj, "Unit") then
          local name = UnitsDisplayAlias({obj})
          local notification = obj.team.player_team and "allyMoraleEffect" or "enemyMoraleEffect"
          ShowTacticalNotification(notification, false, T({
            233709615153,
            "<name> is inspired to fight against all odds",
            name = name
          }))
          obj:GainAP(self:ResolveValue("ap_gain") * const.Scale.AP)
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
          unit:GainAP(self:ResolveValue("ap_gain") * const.Scale.AP)
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
        unit:GainAP(self:ResolveValue("ap_gain") * const.Scale.AP)
      end,
      param_bindings = false
    })
  },
  Conditions = {
    PlaceObj("CombatIsActive", {param_bindings = false})
  },
  DisplayName = T(625410806949, "Heroic"),
  Description = T(433739687794, "Inspired to fight against all odds. Gains Action Points and Accuracy."),
  lifetime = "Until End of Next Turn",
  Icon = "UI/Hud/Status effects/hero",
  RemoveOnEndCombat = true,
  Shown = true,
  HasFloatingText = true
}
