UndefineClass("Conscience_Righteous")
DefineClass.Conscience_Righteous = {
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
          if IsKindOf(obj, "Unit") then
            local effect = obj:GetStatusEffect(self.id)
            effect:SetParameter("proud_start_time", Game.CampaignTime)
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks)
        end
      end,
      HandlerCode = function(self, obj, id, stacks)
        if IsKindOf(obj, "Unit") then
          local effect = obj:GetStatusEffect(self.id)
          effect:SetParameter("proud_start_time", Game.CampaignTime)
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
            obj:SetEffectValue("proud_start_time", false)
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        if IsKindOf(obj, "Unit") then
          obj:SetEffectValue("proud_start_time", false)
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
                local effect = obj:GetStatusEffect("Conscience_Righteous")
                local duration = effect:ResolveValue("days")
                local startTime = effect:ResolveValue("proud_start_time") or 0
                local dayStarted = GetTimeAsTable(startTime)
                dayStarted = dayStarted and dayStarted.day
                local dayNow = GetTimeAsTable(Game.CampaignTime)
                dayNow = dayNow and dayNow.day
                if duration <= dayNow - dayStarted then
                  obj:RemoveStatusEffect("Conscience_Righteous")
                end
              end,
              FuncCode = [[
local effect = obj:GetStatusEffect("Conscience_Righteous")
local duration = effect:ResolveValue("days")
local startTime = effect:ResolveValue("proud_start_time") or 0

local dayStarted = GetTimeAsTable(startTime)
dayStarted = dayStarted and dayStarted.day

local dayNow = GetTimeAsTable(Game.CampaignTime)
dayNow = dayNow and dayNow.day

-- Intentionally check if days have passed calendar, and not time wise.
if dayNow - dayStarted >= duration then
	obj:RemoveStatusEffect("Conscience_Righteous")
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
  DisplayName = T(288530724490, "Righteous"),
  Description = T(186533285685, "Gained 2 Morale for a day."),
  AddEffectText = T(825628234125, "<em><DisplayName></em> is feeling righteous and gained Morale"),
  type = "Buff",
  Icon = "UI/Hud/Status effects/well_rested",
  HasFloatingText = true
}
