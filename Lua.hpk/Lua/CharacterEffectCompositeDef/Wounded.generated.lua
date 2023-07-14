UndefineClass("Wounded")
DefineClass.Wounded = {
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
          RecalcMaxHitPoints(obj)
          if not IsKindOf(obj, "Unit") then
            return
          end
          if not obj:HasStainType("Blood") then
            local spot = obj:GetEffectValue("wounded_stain_spot")
            if spot then
              obj:AddStain("Blood", spot)
            end
          end
          if not obj.wounded_this_turn and GameState.Heat and not RollSkillCheck(obj, "Health") then
            obj:ChangeTired(1)
          end
          local attackObj = obj.hit_this_turn and obj.hit_this_turn[#obj.hit_this_turn]
          local friendlyFire = attackObj and attackObj.team and obj.team and attackObj.team:IsAllySide(obj.team)
          local effect = obj:GetStatusEffect("Wounded")
          if effect.stacks >= 4 and obj:IsMerc() and not friendlyFire then
            PlayVoiceResponse(obj, "SeriouslyWounded")
          elseif not friendlyFire then
            PlayVoiceResponse(obj, "Wounded")
          end
          obj.wounded_this_turn = true
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        RecalcMaxHitPoints(obj)
        if not IsKindOf(obj, "Unit") then
          return
        end
        if not obj:HasStainType("Blood") then
          local spot = obj:GetEffectValue("wounded_stain_spot")
          if spot then
            obj:AddStain("Blood", spot)
          end
        end
        if not obj.wounded_this_turn and GameState.Heat and not RollSkillCheck(obj, "Health") then
          obj:ChangeTired(1)
        end
        local attackObj = obj.hit_this_turn and obj.hit_this_turn[#obj.hit_this_turn]
        local friendlyFire = attackObj and attackObj.team and obj.team and attackObj.team:IsAllySide(obj.team)
        local effect = obj:GetStatusEffect("Wounded")
        if effect.stacks >= 4 and obj:IsMerc() and not friendlyFire then
          PlayVoiceResponse(obj, "SeriouslyWounded")
        elseif not friendlyFire then
          PlayVoiceResponse(obj, "Wounded")
        end
        obj.wounded_this_turn = true
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
          RecalcMaxHitPoints(obj)
          if obj:IsKindOf("Unit") then
            obj:ClearStains("Blood")
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        RecalcMaxHitPoints(obj)
        if obj:IsKindOf("Unit") then
          obj:ClearStains("Blood")
        end
      end,
      param_bindings = false
    })
  },
  DisplayName = T(646181611891, "Wounded"),
  Description = T(625596846196, "Maximum <em>HP reduced by <MaxHpReductionPerStack></em> per wound. Cured by the <em>Treat Wounds</em> Operation in the Sat View"),
  type = "Debuff",
  Icon = "UI/Hud/Status effects/wounded",
  max_stacks = 999,
  Shown = true,
  ShownSatelliteView = true
}
