UndefineClass("Unconscious")
DefineClass.Unconscious = {
  __parents = {
    "CharacterEffect"
  },
  __generated_by_class = "CharacterEffectCompositeDef",
  object_class = "CharacterEffect",
  msg_reactions = {
    PlaceObj("MsgReactionEffects", {
      Effects = {
        PlaceObj("ConditionalEffect", {
          "Effects",
          {
            PlaceObj("ExecuteCode", {
              Code = function(self, obj)
                if not IsKindOf(obj, "Unit") then
                  return
                end
                local recovery = obj:GetEffectValue("unconscious_recovery_exploration_time")
                if recovery and recovery <= GameTime() then
                  obj:SetTired(const.utExhausted)
                  obj:SetCommand("DownedRally")
                end
              end,
              FuncCode = [[
if not IsKindOf(obj, "Unit") then return end
local recovery = obj:GetEffectValue("unconscious_recovery_exploration_time") 
if recovery and GameTime() >= recovery then
	obj:SetTired(const.utExhausted)
	obj:SetCommand("DownedRally")
end]],
              SaveAsText = false,
              param_bindings = false
            })
          }
        })
      },
      Event = "ExplorationTick",
      Handler = function(self)
        CE_ExecReactionEffects(self, "ExplorationTick")
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
          local delay = self:ResolveValue("recovery_delay_turns")
          local recovery_turn = (g_Combat and g_Combat.current_turn or 1) + delay
          obj:SetEffectValue("unconscious_recovery_turn", recovery_turn)
          if not g_Combat then
            local delay = self:ResolveValue("recovery_delay_seconds") * 1000
            obj:SetEffectValue("unconscious_recovery_exploration_time", GameTime() + delay)
          end
          obj:AddStatusEffectImmunity("Surprised", id)
          CreateGameTimeThread(obj.SetCommandIfNotDead, obj, obj.command == "GetDowned" and "Downed" or "KnockDown")
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        local delay = self:ResolveValue("recovery_delay_turns")
        local recovery_turn = (g_Combat and g_Combat.current_turn or 1) + delay
        obj:SetEffectValue("unconscious_recovery_turn", recovery_turn)
        if not g_Combat then
          local delay = self:ResolveValue("recovery_delay_seconds") * 1000
          obj:SetEffectValue("unconscious_recovery_exploration_time", GameTime() + delay)
        end
        obj:AddStatusEffectImmunity("Surprised", id)
        CreateGameTimeThread(obj.SetCommandIfNotDead, obj, obj.command == "GetDowned" and "Downed" or "KnockDown")
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
          obj:SetEffectValue("unconscious_recovery_turn")
          obj:SetEffectValue("unconscious_recovery_exploration_time")
          obj:RemoveStatusEffectImmunity("Surprised", id)
          if obj.command == "Downed" then
            obj:SetCommand("DownedRally")
          else
            obj:SetTired(Min(obj.Tiredness, const.utExhausted))
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        obj:SetEffectValue("unconscious_recovery_turn")
        obj:SetEffectValue("unconscious_recovery_exploration_time")
        obj:RemoveStatusEffectImmunity("Surprised", id)
        if obj.command == "Downed" then
          obj:SetCommand("DownedRally")
        else
          obj:SetTired(Min(obj.Tiredness, const.utExhausted))
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
          local recovery_turn = unit:GetEffectValue("unconscious_recovery_turn") or -1
          local rally = unit:GetEffectValue("stabilized")
          if not rally and g_Combat and recovery_turn <= g_Combat.current_turn then
            rally = RollSkillCheck(unit, "Health", 50)
          end
          if rally and unit:IsDowned() then
            unit:SetCommand("DownedRally")
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
        local recovery_turn = unit:GetEffectValue("unconscious_recovery_turn") or -1
        local rally = unit:GetEffectValue("stabilized")
        if not rally and g_Combat and recovery_turn <= g_Combat.current_turn then
          rally = RollSkillCheck(unit, "Health", 50)
        end
        if rally and unit:IsDowned() then
          unit:SetCommand("DownedRally")
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(132204403941, "Unconscious"),
  Description = T(801008446056, "Unconscious and unable to take any action. "),
  AddEffectText = T(964785237678, "<em><DisplayName></em> is unconscious"),
  RemoveEffectText = T(208147554823, "<em><DisplayName></em> regained consciousness"),
  Icon = "UI/Hud/Status effects/unconscious",
  Shown = true,
  ShownSatelliteView = true,
  HasFloatingText = true
}
