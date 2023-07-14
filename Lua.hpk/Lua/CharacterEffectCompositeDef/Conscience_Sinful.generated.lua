UndefineClass("Conscience_Sinful")
DefineClass.Conscience_Sinful = {
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
            effect:SetParameter("guilty_start_time", Game.CampaignTime)
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
          effect:SetParameter("guilty_start_time", Game.CampaignTime)
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
            obj:SetEffectValue("guilty_start_time", false)
            local stats = UnitPropertiesStats:GetProperties()
            for i, stat in ipairs(stats) do
              obj:RemoveModifier("guilty_" .. stat.id, stat.id)
            end
          end
        end
        local _id = GetCharacterEffectId(self)
        if _id == id then
          exec(self, obj, id, stacks, reason)
        end
      end,
      HandlerCode = function(self, obj, id, stacks, reason)
        if IsKindOf(obj, "Unit") then
          obj:SetEffectValue("guilty_start_time", false)
          local stats = UnitPropertiesStats:GetProperties()
          for i, stat in ipairs(stats) do
            obj:RemoveModifier("guilty_" .. stat.id, stat.id)
          end
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
                local effect = obj:GetStatusEffect("Conscience_Sinful")
                local duration = effect:ResolveValue("days")
                local startTime = effect:ResolveValue("guilty_start_time") or 0
                local dayStarted = GetTimeAsTable(startTime)
                dayStarted = dayStarted and dayStarted.day
                local dayNow = GetTimeAsTable(Game.CampaignTime)
                dayNow = dayNow and dayNow.day
                if duration <= dayNow - dayStarted then
                  obj:RemoveStatusEffect("Conscience_Sinful")
                end
              end,
              FuncCode = [[
local effect = obj:GetStatusEffect("Conscience_Sinful")
local duration = effect:ResolveValue("days")
local startTime = effect:ResolveValue("guilty_start_time") or 0

local dayStarted = GetTimeAsTable(startTime)
dayStarted = dayStarted and dayStarted.day

local dayNow = GetTimeAsTable(Game.CampaignTime)
dayNow = dayNow and dayNow.day

-- Intentionally check if days have passed calendar, and not time wise.
if dayNow - dayStarted >= duration then
	obj:RemoveStatusEffect("Conscience_Sinful")
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
  DisplayName = T(634244208298, "Remorseful"),
  Description = T(518452710606, "Morale decreased by 2 for a day."),
  AddEffectText = T(949084683649, "<em><DisplayName></em> is full of remorse and lost Morale"),
  type = "Debuff",
  Icon = "UI/Hud/Status effects/encumbered",
  HasFloatingText = true
}
