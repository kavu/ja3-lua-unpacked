UndefineClass("Panicked")
DefineClass.Panicked = {
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
          obj:RemoveStatusEffect("Berserk")
          if IsKindOf(obj, "Unit") then
            obj:InterruptPreparedAttack()
            if g_Teams[g_CurrentTeam] == obj.team then
              ScheduleMoraleActions()
            end
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        obj:RemoveStatusEffect("Berserk")
        if IsKindOf(obj, "Unit") then
          obj:InterruptPreparedAttack()
          if g_Teams[g_CurrentTeam] == obj.team then
            ScheduleMoraleActions()
          end
        end
      end,
      param_bindings = false
    })
  },
  Conditions = {
    PlaceObj("CombatIsActive", {param_bindings = false})
  },
  DisplayName = T(179133370621, "Panicked"),
  Description = T(583680307590, "Uncontrollable. Runs away from the enemies."),
  AddEffectText = T(629484886928, "<em><DisplayName></em> panicked"),
  RemoveEffectText = T(633681873712, "<em><DisplayName></em> calmed down from the Panic"),
  lifetime = "Until End of Next Turn",
  Icon = "UI/Hud/Status effects/panic",
  RemoveOnEndCombat = true,
  Shown = true,
  HasFloatingText = true
}
