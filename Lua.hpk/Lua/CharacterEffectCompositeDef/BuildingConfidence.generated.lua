UndefineClass("BuildingConfidence")
DefineClass.BuildingConfidence = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "OnAttack",
      Handler = function(self, attacker, action, target, results, attack_args)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "OnAttack")
        if not reaction_idx then
          return
        end
        local exec = function(self, attacker, action, target, results, attack_args)
          attacker:SetEffectValue("attackedThisCombat", true)
        end
        local id = GetCharacterEffectId(self)
        if id then
          if IsKindOf(attacker, "StatusEffectObject") and attacker:HasStatusEffect(id) then
            exec(self, attacker, action, target, results, attack_args)
          end
        else
          exec(self, attacker, action, target, results, attack_args)
        end
      end,
      HandlerCode = function(self, attacker, action, target, results, attack_args)
        attacker:SetEffectValue("attackedThisCombat", true)
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "CombatEnd",
      Handler = function(self, test_combat, combat, anyEnemies)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "CombatEnd")
        if not reaction_idx then
          return
        end
        local exec = function(self, test_combat, combat, anyEnemies)
          local unit = g_Units.MD
          if unit then
            unit:SetEffectValue("attackedThisCombat", false)
          end
        end
        local id = GetCharacterEffectId(self)
        if id then
          local objs = {}
          for session_id, data in pairs(gv_UnitData) do
            local obj = g_Units[session_id] or data
            if obj:HasStatusEffect(id) then
              objs[session_id] = obj
            end
          end
          for _, obj in sorted_pairs(objs) do
            exec(self, test_combat, combat, anyEnemies)
          end
        else
          exec(self, test_combat, combat, anyEnemies)
        end
      end,
      HandlerCode = function(self, test_combat, combat, anyEnemies)
        local unit = g_Units.MD
        if unit then
          unit:SetEffectValue("attackedThisCombat", false)
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
          if g_Combat and g_Combat.current_turn >= self:ResolveValue("turnToProc") and unit:GetEffectValue("attackedThisCombat") and not unit:HasStatusEffect("ConfidenceBuilt") then
            local chance = self:ResolveValue("chanceToProc")
            local roll = InteractionRand(100, "BuildingConfidence")
            if chance > roll then
              unit:AddStatusEffect("Inspired")
              unit.team:ChangeMorale(1, self.DisplayName)
              unit:AddStatusEffect("ConfidenceBuilt")
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
        if g_Combat and g_Combat.current_turn >= self:ResolveValue("turnToProc") and unit:GetEffectValue("attackedThisCombat") and not unit:HasStatusEffect("ConfidenceBuilt") then
          local chance = self:ResolveValue("chanceToProc")
          local roll = InteractionRand(100, "BuildingConfidence")
          if chance > roll then
            unit:AddStatusEffect("Inspired")
            unit.team:ChangeMorale(1, self.DisplayName)
            unit:AddStatusEffect("ConfidenceBuilt")
          end
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(110292118081, "Find My Feet"),
  Description = T(969057307540, "Can become <GameTerm('Inspired')> and increase the team's <GameTerm('Morale')> during combat."),
  Icon = "UI/Icons/Perks/BuildingConfidence",
  Tier = "Personal"
}
