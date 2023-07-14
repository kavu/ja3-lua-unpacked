UndefineClass("TheGrim")
DefineClass.TheGrim = {
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
          if action.id == self.id and IsKindOf(target, "Unit") and table.find(results.killed_units or empty_table, target) then
            local units = {}
            for _, unit in ipairs(g_Units) do
              if unit.session_id ~= target.session_id and unit.team:IsAllySide(target.team) and DivRound(unit:GetDist(target), const.SlabSizeX) <= self:ResolveValue("fearAoE") then
                table.insert_unique(units, unit)
                unit:AddStatusEffect("Panicked")
                unit.ActionPoints = unit:GetMaxActionPoints()
              end
            end
          end
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
        if action.id == self.id and IsKindOf(target, "Unit") and table.find(results.killed_units or empty_table, target) then
          local units = {}
          for _, unit in ipairs(g_Units) do
            if unit.session_id ~= target.session_id and unit.team:IsAllySide(target.team) and DivRound(unit:GetDist(target), const.SlabSizeX) <= self:ResolveValue("fearAoE") then
              table.insert_unique(units, unit)
              unit:AddStatusEffect("Panicked")
              unit.ActionPoints = unit:GetMaxActionPoints()
            end
          end
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(976473584324, "Grim Fate"),
  Description = T(760291244490, [[
<em>Ranged attack</em> that automatically causes a <GameTerm('Crit')>.

When the attack kills an enemy, other nearby enemies will <GameTerm('Panic')>.

Can't be used with Shotguns.]]),
  Icon = "UI/Icons/Perks/TheGrim",
  Tier = "Personal"
}
