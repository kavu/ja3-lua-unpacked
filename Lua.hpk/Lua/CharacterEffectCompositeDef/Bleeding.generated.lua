UndefineClass("Bleeding")
DefineClass.Bleeding = {
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
          if g_Teams[g_CurrentTeam] == obj.team and not obj:HasStatusEffect("BeingBandaged") then
            obj:ConsumeAP(-self:ResolveValue("APLoss") * const.Scale.AP)
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        if g_Teams[g_CurrentTeam] == obj.team and not obj:HasStatusEffect("BeingBandaged") then
          obj:ConsumeAP(-self:ResolveValue("APLoss") * const.Scale.AP)
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
          if g_Combat and not obj:HasStatusEffect("BeingBandaged") then
            obj:ConsumeAP(self:ResolveValue("APLoss") * const.Scale.AP)
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        if g_Combat and not obj:HasStatusEffect("BeingBandaged") then
          obj:ConsumeAP(self:ResolveValue("APLoss") * const.Scale.AP)
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
          if not IsInCombat() then
            return
          end
          if unit:HasStatusEffect("BeingBandaged") then
            unit:RemoveStatusEffect("Bleeding")
            return
          end
          local value = self:ResolveValue("DamagePerTurn")
          local floating_text = T({
            193053798048,
            "<num> (bleeding)",
            num = value
          })
          local pov_team = GetPoVTeam()
          local has_visibility = HasVisibilityTo(pov_team, unit)
          local log_msg = T({
            729241506274,
            "<name> bleeds for <em><num> damage</em>",
            name = unit:GetLogName(),
            num = value
          })
          unit:TakeDirectDamage(value, has_visibility and floating_text or false, "short", log_msg)
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
        if not IsInCombat() then
          return
        end
        if unit:HasStatusEffect("BeingBandaged") then
          unit:RemoveStatusEffect("Bleeding")
          return
        end
        local value = self:ResolveValue("DamagePerTurn")
        local floating_text = T({
          193053798048,
          "<num> (bleeding)",
          num = value
        })
        local pov_team = GetPoVTeam()
        local has_visibility = HasVisibilityTo(pov_team, unit)
        local log_msg = T({
          729241506274,
          "<name> bleeds for <em><num> damage</em>",
          name = unit:GetLogName(),
          num = value
        })
        unit:TakeDirectDamage(value, has_visibility and floating_text or false, "short", log_msg)
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
            data.mod_add = data.mod_add + self:ResolveValue("cth_penalty")
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
          data.mod_add = data.mod_add + self:ResolveValue("cth_penalty")
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(779855732255, "Bleeding"),
  Description = T(303094247377, "This character will <em>take <DamagePerTurn> damage</em> each turn until they are <em>bandaged</em>. Maximum <em>AP decreased by <APLoss></em>."),
  AddEffectText = T(902710213609, "<em><DisplayName></em> is bleeding"),
  type = "Debuff",
  Icon = "UI/Hud/Status effects/bleeding",
  RemoveOnEndCombat = true,
  Shown = true,
  HasFloatingText = true
}
