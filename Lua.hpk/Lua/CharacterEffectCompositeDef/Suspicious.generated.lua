UndefineClass("Suspicious")
DefineClass.Suspicious = {
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
          obj:RemoveStatusEffect("Unaware")
          if IsKindOf(obj, "Unit") and obj.command == "Idle" then
            obj:SetCommand("Idle")
            Msg("UnitAwarenessChanged", obj)
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        obj:RemoveStatusEffect("Unaware")
        if IsKindOf(obj, "Unit") and obj.command == "Idle" then
          obj:SetCommand("Idle")
          Msg("UnitAwarenessChanged", obj)
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
          obj.suspicion = false
          if IsKindOf(obj, "Unit") then
            if g_Combat then
              g_Combat.end_combat_pending = false
            end
            Msg("UnitAwarenessChanged", obj)
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        obj.suspicion = false
        if IsKindOf(obj, "Unit") then
          if g_Combat then
            g_Combat.end_combat_pending = false
          end
          Msg("UnitAwarenessChanged", obj)
        end
      end,
      param_bindings = false
    }),
    PlaceObj("MsgReactionEffects", {
      Effects = {
        PlaceObj("ConditionalEffect", {
          "Effects",
          {
            PlaceObj("ExecuteCode", {
              Code = function(self, obj)
                local effect = obj:GetStatusEffect("Suspicious")
                local expiration = effect:ResolveValue("expiration_campaign_mins")
                if Game.CampaignTime >= effect.CampaignTimeAdded + expiration * const.Scale.min then
                  obj:AddStatusEffect("Unaware")
                end
              end,
              FuncCode = [[
local effect = obj:GetStatusEffect("Suspicious")
local expiration = effect:ResolveValue("expiration_campaign_mins")
if Game.CampaignTime >= effect.CampaignTimeAdded + expiration * const.Scale.min then
	obj:AddStatusEffect("Unaware")
end]],
              SaveAsText = false,
              param_bindings = false
            })
          }
        })
      },
      Event = "SatelliteTick",
      Handler = function(self)
        CE_ExecReactionEffects(self, "SatelliteTick")
      end,
      param_bindings = false
    })
  },
  DisplayName = T(438888144738, "Suspicious"),
  Description = T(917041996408, "This character is actively seeking enemies and has better resistance against <em>Stealth Kills</em>."),
  Icon = "UI/Hud/Status effects/suspicious",
  Shown = true
}
