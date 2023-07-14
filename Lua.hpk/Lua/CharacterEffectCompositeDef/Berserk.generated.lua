UndefineClass("Berserk")
DefineClass.Berserk = {
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
          obj:RemoveStatusEffect("Panicked")
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
        obj:RemoveStatusEffect("Panicked")
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
  DisplayName = T(420777563903, "Berserk"),
  Description = T(392582028996, "Uncontrollable. Recklessly attacks nearby enemies."),
  AddEffectText = T(473269787540, "<em><DisplayName></em> went Berserk"),
  RemoveEffectText = T(463610360293, "<em><DisplayName></em> is no longer Berserk"),
  lifetime = "Until End of Next Turn",
  Icon = "UI/Hud/Status effects/rage",
  RemoveOnEndCombat = true,
  Shown = true,
  HasFloatingText = true
}
