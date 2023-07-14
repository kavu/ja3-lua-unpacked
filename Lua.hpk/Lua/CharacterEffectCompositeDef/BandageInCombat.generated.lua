UndefineClass("BandageInCombat")
DefineClass.BandageInCombat = {
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
          local target = IsKindOf(obj, "Unit") and obj:GetBandageTarget()
          if target then
            target:RemoveStatusEffect("Downed")
            target:RemoveStatusEffect("BleedingOut")
          end
          obj:RemoveStatusEffect("FreeMove")
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        local target = IsKindOf(obj, "Unit") and obj:GetBandageTarget()
        if target then
          target:RemoveStatusEffect("Downed")
          target:RemoveStatusEffect("BleedingOut")
        end
        obj:RemoveStatusEffect("FreeMove")
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
          local target = IsKindOf(obj, "Unit") and obj:GetBandageTarget()
          if not g_Combat then
            return
          end
          if target and target:IsDowned() and not target:HasStatusEffect("Unconscious") then
            target:RemoveStatusEffect("Stabilized")
            target:AddStatusEffect("BleedingOut")
            target:RemoveStatusEffect("BeingBandaged")
          end
          if CurrentThread() == obj.command_thread then
            obj:QueueCommand("EndCombatBandage")
          else
            obj:SetCommand("EndCombatBandage")
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        local target = IsKindOf(obj, "Unit") and obj:GetBandageTarget()
        if not g_Combat then
          return
        end
        if target and target:IsDowned() and not target:HasStatusEffect("Unconscious") then
          target:RemoveStatusEffect("Stabilized")
          target:AddStatusEffect("BleedingOut")
          target:RemoveStatusEffect("BeingBandaged")
        end
        if CurrentThread() == obj.command_thread then
          obj:QueueCommand("EndCombatBandage")
        else
          obj:SetCommand("EndCombatBandage")
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
          local target = unit:GetBandageTarget()
          local medicine = unit:GetBandageMedicine()
          if not (target and medicine) or target.command == "Die" or target:IsDead() or target.HitPoints >= target.MaxHitPoints then
            unit:RemoveStatusEffect("BandageInCombat")
            return
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
        local target = unit:GetBandageTarget()
        local medicine = unit:GetBandageMedicine()
        if not (target and medicine) or target.command == "Die" or target:IsDead() or target.HitPoints >= target.MaxHitPoints then
          unit:RemoveStatusEffect("BandageInCombat")
          return
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
          local target = unit:GetBandageTarget()
          local medicine = unit:GetBandageMedicine()
          if not IsValid(target) or target.command == "Die" or target:IsDead() or target.HitPoints >= target.MaxHitPoints then
            unit:RemoveStatusEffect(self.id)
            return
          end
          if target:IsDowned() then
            if target:GetEffectValue("stabilized") or RollSkillCheck(unit, "Medical") then
              target:SetCommand("DownedRally", unit, medicine)
            else
              target:AddStatusEffect("Stabilized")
            end
          else
            target:GetBandaged(medicine, unit)
            if target.HitPoints >= target.MaxHitPoints then
              target:RemoveStatusEffect("BeingBandaged")
              unit:RemoveStatusEffect(self.id)
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
        local target = unit:GetBandageTarget()
        local medicine = unit:GetBandageMedicine()
        if not IsValid(target) or target.command == "Die" or target:IsDead() or target.HitPoints >= target.MaxHitPoints then
          unit:RemoveStatusEffect(self.id)
          return
        end
        if target:IsDowned() then
          if target:GetEffectValue("stabilized") or RollSkillCheck(unit, "Medical") then
            target:SetCommand("DownedRally", unit, medicine)
          else
            target:AddStatusEffect("Stabilized")
          end
        else
          target:GetBandaged(medicine, unit)
          if target.HitPoints >= target.MaxHitPoints then
            target:RemoveStatusEffect("BeingBandaged")
            unit:RemoveStatusEffect(self.id)
          end
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(725524260335, "Treating"),
  Description = T(829769124050, "Bandaging an ally. No more actions available this turn. Effectiveness of the action depends on Medical skill."),
  Icon = "UI/Hud/Status effects/treating",
  RemoveOnSatViewTravel = true,
  Shown = true
}
