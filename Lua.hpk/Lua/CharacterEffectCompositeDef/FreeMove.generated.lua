UndefineClass("FreeMove")
DefineClass.FreeMove = {
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
          local cur_free_ap = obj.free_move_ap
          local free_ap = Max(0, MulDivRound(obj.Agility - 40, const.Scale.AP, 10))
          if HasPerk(obj, "MinFreeMove") then
            free_ap = Max(free_ap, CharacterEffectDefs.MinFreeMove:ResolveValue("minFreeMove") * const.Scale.AP)
          end
          if HasPerk(obj, "SteadyBreathing") then
            local proc = true
            local armourItems = obj:GetEquipedArmour()
            for _, item in ipairs(armourItems) do
              if item.PenetrationClass > 2 then
                proc = false
              end
            end
            if proc then
              free_ap = free_ap + CharacterEffectDefs.SteadyBreathing:ResolveValue("freeMoveBonusAp") * const.Scale.AP
            end
          end
          if HasPerk(obj, "RelentlessAdvance") and obj:IsUsingCover() then
            free_ap = free_ap * CharacterEffectDefs.RelentlessAdvance:ResolveValue("free_move_mult")
          end
          local diffFreeMoveChangePerc = PercentModifyByDifficulty(GameDifficulties[Game.game_difficulty]:ResolveValue("freeMoveBonus"))
          if obj.team and obj.team.player_enemy then
            free_ap = MulDivRound(free_ap, diffFreeMoveChangePerc, 100)
          end
          local prev_ap = obj.ActionPoints
          obj:GainAP(free_ap - cur_free_ap)
          if prev_ap < obj.ActionPoints then
            obj.free_move_ap = free_ap
            Msg("UnitAPChanged", obj)
            ObjModified(obj)
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        local cur_free_ap = obj.free_move_ap
        local free_ap = Max(0, MulDivRound(obj.Agility - 40, const.Scale.AP, 10))
        if HasPerk(obj, "MinFreeMove") then
          free_ap = Max(free_ap, CharacterEffectDefs.MinFreeMove:ResolveValue("minFreeMove") * const.Scale.AP)
        end
        if HasPerk(obj, "SteadyBreathing") then
          local proc = true
          local armourItems = obj:GetEquipedArmour()
          for _, item in ipairs(armourItems) do
            if item.PenetrationClass > 2 then
              proc = false
            end
          end
          if proc then
            free_ap = free_ap + CharacterEffectDefs.SteadyBreathing:ResolveValue("freeMoveBonusAp") * const.Scale.AP
          end
        end
        if HasPerk(obj, "RelentlessAdvance") and obj:IsUsingCover() then
          free_ap = free_ap * CharacterEffectDefs.RelentlessAdvance:ResolveValue("free_move_mult")
        end
        local diffFreeMoveChangePerc = PercentModifyByDifficulty(GameDifficulties[Game.game_difficulty]:ResolveValue("freeMoveBonus"))
        if obj.team and obj.team.player_enemy then
          free_ap = MulDivRound(free_ap, diffFreeMoveChangePerc, 100)
        end
        local prev_ap = obj.ActionPoints
        obj:GainAP(free_ap - cur_free_ap)
        if prev_ap < obj.ActionPoints then
          obj.free_move_ap = free_ap
          Msg("UnitAPChanged", obj)
          ObjModified(obj)
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
          if IsKindOf(obj, "Unit") then
            obj:ConsumeAP(obj.free_move_ap)
            obj.free_move_ap = 0
            Msg("UnitAPChanged", obj, self.class)
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        if IsKindOf(obj, "Unit") then
          obj:ConsumeAP(obj.free_move_ap)
          obj.free_move_ap = 0
          Msg("UnitAPChanged", obj, self.class)
        end
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReaction", {
      Event = "CombatActionEnd",
      Handler = function(self, unit)
        local reaction_idx = table.find(self.msg_reactions or empty_table, "Event", "CombatActionEnd")
        if not reaction_idx then
          return
        end
        local exec = function(self, unit)
          if unit.free_move_ap <= 0 then
            unit:RemoveStatusEffect("FreeMove")
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
        if unit.free_move_ap <= 0 then
          unit:RemoveStatusEffect("FreeMove")
        end
      end,
      param_bindings = false
    })
  },
  Conditions = {
    PlaceObj("CheckExpression", {
      Expression = function(self, obj)
        return g_Combat and obj.Tiredness <= 0
      end,
      param_bindings = false
    })
  },
  DisplayName = T(574672731472, "Free Move"),
  Description = T(824694494336, "Move without spending AP. Removed after attacking or after moving the allowed distance (based on <agility>)."),
  type = "Buff",
  Icon = "UI/Hud/Status effects/mobility",
  RemoveOnEndCombat = true,
  Shown = true
}
