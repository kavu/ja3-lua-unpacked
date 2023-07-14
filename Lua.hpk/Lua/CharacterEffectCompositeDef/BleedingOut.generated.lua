UndefineClass("BleedingOut")
DefineClass.BleedingOut = {
  __parents = {
    "CharacterEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "CharacterEffect",
  msg_reactions = {
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
          if not RollSkillCheck(unit, "Health", nil, unit.downed_check_penalty) then
            CombatLog("important", T({
              290150299208,
              "<em><LogName></em> has <em>bled out</em>",
              unit
            }))
            unit:TakeDirectDamage(unit:GetTotalHitPoints())
          else
            unit.downed_check_penalty = unit.downed_check_penalty + self:ResolveValue("add_penalty")
            CombatLog("short", T({
              333799512710,
              "<em><LogName></em> is <em>bleeding</em>",
              unit
            }))
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
        if not IsInCombat() then
          return
        end
        if not RollSkillCheck(unit, "Health", nil, unit.downed_check_penalty) then
          CombatLog("important", T({
            290150299208,
            "<em><LogName></em> has <em>bled out</em>",
            unit
          }))
          unit:TakeDirectDamage(unit:GetTotalHitPoints())
        else
          unit.downed_check_penalty = unit.downed_check_penalty + self:ResolveValue("add_penalty")
          CombatLog("short", T({
            333799512710,
            "<em><LogName></em> is <em>bleeding</em>",
            unit
          }))
        end
      end,
      param_bindings = false
    })
  },
  Conditions = {
    PlaceObj("CombatIsActive", {param_bindings = false})
  },
  DisplayName = T(833314215129, "Downed"),
  Description = T(588355193847, "This character is in <em>Critical condition</em> and will bleed out unless treated with the <em>Bandage</em> action. The character remains alive if a successful check against Health is made next turn."),
  Icon = "UI/Hud/Status effects/bleedingout",
  Shown = true
}
