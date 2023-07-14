UndefineClass("GruntyPerk")
DefineClass.GruntyPerk = {
  __parents = {"Perk"},
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "Perk",
  msg_reactions = {
    PlaceObj("MsgReaction", {
      Event = "CombatStarting",
      Handler = function(self, dynamic_data)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "CombatStarting")
        if not reaction_idx then
          return
        end
        local exec = function(self, dynamic_data)
          if not dynamic_data then
            local unit = g_Units.Grunty
            if unit then
              local enemy = unit:GetClosestEnemy()
              if enemy then
                local weapon = unit:GetActiveWeapons()
                if IsKindOf(weapon, "Firearm") and not IsKindOf(weapon, "HeavyWeapon") then
                  local action = unit:GetDefaultAttackAction("ranged")
                  local args = {target = enemy, gruntyPerk = true}
                  LockCameraMovement("grunty perk")
                  StartCombatAction(action.id, unit, 0, args)
                end
              end
            end
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
            exec(self, dynamic_data)
          end
        else
          exec(self, dynamic_data)
        end
      end,
      HandlerCode = function(self, dynamic_data)
        if not dynamic_data then
          local unit = g_Units.Grunty
          if unit then
            local enemy = unit:GetClosestEnemy()
            if enemy then
              local weapon = unit:GetActiveWeapons()
              if IsKindOf(weapon, "Firearm") and not IsKindOf(weapon, "HeavyWeapon") then
                local action = unit:GetDefaultAttackAction("ranged")
                local args = {target = enemy, gruntyPerk = true}
                LockCameraMovement("grunty perk")
                StartCombatAction(action.id, unit, 0, args)
              end
            end
          end
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(562334332352, "\195\156berraschung"),
  Description = T(742416202176, [[
<em>Attacks</em> the <em>closest</em> enemy with a firearm when <em>combat starts</em>, if possible.

Can't be used with Heavy Weapons.]]),
  Icon = "UI/Icons/Perks/GruntyPerk",
  Tier = "Personal"
}
