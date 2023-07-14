UndefineClass("Downed")
DefineClass.Downed = {
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
          CombatLog("important", T({
            238931952182,
            "<em><LogName></em> is <em>downed</em>",
            obj
          }))
          obj.downing_action_start_time = CombatActions_LastStartedAction and CombatActions_LastStartedAction.start_time
          CreateGameTimeThread(obj.SetCommandIfNotDead, obj, "Downed")
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        CombatLog("important", T({
          238931952182,
          "<em><LogName></em> is <em>downed</em>",
          obj
        }))
        obj.downing_action_start_time = CombatActions_LastStartedAction and CombatActions_LastStartedAction.start_time
        CreateGameTimeThread(obj.SetCommandIfNotDead, obj, "Downed")
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
          unit:AddStatusEffect("BleedingOut")
          unit:RemoveStatusEffect("Downed")
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
        unit:AddStatusEffect("BleedingOut")
        unit:RemoveStatusEffect("Downed")
      end,
      param_bindings = false
    })
  },
  Conditions = {
    PlaceObj("CombatIsActive", {param_bindings = false})
  },
  DisplayName = T(398729743970, "Downed"),
  Description = T(848972500465, "This character is in <em>Critical condition</em> and will bleed out unless treated with the <em>Bandage</em> action. The character remains alive if a successful check against Health is made next turn."),
  Icon = "UI/Hud/Status effects/bleedingout",
  Shown = true
}
