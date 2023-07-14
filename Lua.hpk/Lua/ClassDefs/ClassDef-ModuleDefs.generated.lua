DefineClass.CombatTask = {
  __parents = {
    "ModulePreset",
    "TODOPreset",
    "MsgReactionsPreset"
  },
  __generated_by_class = "ZuluModuleDef",
  properties = {
    {
      category = "Display",
      id = "name",
      name = "Name",
      editor = "text",
      default = T(635036510295, "Combat Task"),
      translate = true
    },
    {
      category = "Display",
      id = "description",
      name = "Description",
      editor = "text",
      default = false,
      translate = true
    },
    {
      category = "Rewards",
      id = "xpReward",
      name = "XP Reward",
      editor = "number",
      default = 300
    },
    {
      category = "Rewards",
      id = "statGainRolls",
      name = "Related Stats",
      help = "Trigger rolls for Stat Gaining for the selected Stats on Task completion.",
      editor = "string_list",
      default = {},
      item_default = "Wisdom",
      items = function(self)
        return GetUnitStatsCombo()
      end
    },
    {
      category = "CombatTask",
      id = "selectionConditions",
      name = "Selection Conditions",
      help = "Explicitly specified",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    },
    {
      category = "CombatTask",
      id = "favouredConditions",
      name = "Favoured Conditions",
      help = "Explicitly specified",
      editor = "nested_list",
      default = false,
      base_class = "Condition"
    },
    {
      category = "CombatTask",
      id = "requiredProgress",
      name = "Required Progress",
      help = "Amount of things you need to do.",
      editor = "number",
      default = 1
    },
    {
      category = "CombatTask",
      id = "hideProgress",
      name = "Hide Progress",
      editor = "bool",
      default = false
    },
    {
      category = "CombatTask",
      id = "holdUntilEnd",
      name = "Hold until Conflict* End",
      help = "End is when all non animal enemies have died.",
      editor = "bool",
      default = false
    },
    {
      category = "CombatTask",
      id = "reverseProgress",
      name = "Reverse Progress",
      help = "If enabled currentProgress must not reach the requiredProgress instead.",
      editor = "bool",
      default = false
    },
    {
      category = "CombatTask",
      id = "cooldown",
      name = "Cooldown",
      help = "How much to wait (in SatView time) to be able to select the task again.",
      editor = "number",
      default = 432000,
      scale = "day",
      min = 0,
      max = 8640000
    },
    {
      category = "CombatTask",
      id = "competition",
      name = "Competition",
      help = "Puts the merc in a race against one of his Liked/Disliked",
      editor = "bool",
      default = false
    },
    {
      category = "CombatTask",
      id = "buttonGiveCombatTask",
      editor = "buttons",
      default = false,
      buttons = {
        {
          name = "Give Combat Task",
          func = "GiveCombatTaskEditor"
        }
      },
      template = true
    }
  },
  GlobalMap = "CombatTaskDefs",
  EditorMenubarName = "Combat Tasks",
  EditorMenubar = "Combat",
  currentProgress = 0,
  state = "inProgress",
  additionalData = false,
  unitId = "",
  otherUnitId = ""
}
function CombatTask:GiveCombatTaskEditor(root, prop_id, ged)
  if gv_SatelliteView then
    return
  end
  if not IsKindOf(SelectedObj, "Unit") then
    return
  end
  GiveCombatTask(self, SelectedObj.session_id)
end
function CombatTask:CanBeSelected(unit)
  if self.competition then
    local hasOpponent = false
    local units = GetCurrentMapUnits()
    for _, u in ipairs(units) do
      if table.find(unit.Likes, u.session_id) or table.find(unit.Dislikes, u.session_id) then
        hasOpponent = true
        break
      end
    end
    if not hasOpponent then
      return false
    end
  end
  if not self.selectionConditions or #self.selectionConditions <= 0 then
    return true
  end
  return EvalConditionList(self.selectionConditions, self, {
    target_units = {unit},
    no_log = true
  })
end
function CombatTask:IsFavoured(unit)
  for _, stat in ipairs(self.statGainRolls) do
    if 70 <= unit[stat] then
      return true
    end
  end
  if self.favouredConditions and #self.favouredConditions > 0 then
    return EvalConditionList(self.favouredConditions, self, {
      target_units = {unit},
      no_log = true
    })
  end
  return false
end
function CombatTask:OnAdd(owner, ...)
  if not self.unitId or self.unitId == "" then
    self.unitId = owner.session_id
    if self.competition then
      local unit = g_Units[self.unitId]
      local ids = {}
      local units = GetCurrentMapUnits()
      for _, u in ipairs(units) do
        if table.find(unit.Likes, u.session_id) or table.find(unit.Dislikes, u.session_id) then
          ids[#ids + 1] = u.session_id
        end
      end
      self.otherUnitId = ids[InteractionRand(#ids, "CombatTask") + 1]
    end
  end
end
function CombatTask:Finish()
  ObjModified(self)
  local unit = g_Units[self.unitId]
  Msg("CombatTaskFinished", self.id, unit, self.state == "completed")
  CombatTaskUIAnimations[self] = {}
  CombatTaskUIAnimations[self].startTime = GetPreciseTicks()
  CombatTaskUIAnimations[self].thread = CreateRealTimeThread(function()
    if g_Teams[g_CurrentTeam].control ~= "UI" then
      WaitMsg("TurnEnded")
    end
    local igi = GetInGameInterfaceModeDlg()
    if IsKindOf(igi, "IModeCommonUnitControl") then
      local combatTasks = igi:ResolveId("idCombatTasks")
      for _, taskUI in ipairs(combatTasks) do
        if taskUI.context == self then
          taskUI:Animate()
          Sleep(taskUI.animPulseDuration + taskUI.animHideDuration)
          break
        end
      end
    end
    if unit then
      unit:RemoveCombatTask(self)
    end
    RefreshCombatTasks()
  end)
end
function CombatTask:Complete()
  if self.state ~= "inProgress" then
    return
  end
  local unit = g_Units[self.unitId]
  if unit then
    RewardTeamExperience({
      RewardExperience = self.xpReward
    }, {
      units = {unit}
    })
    for _, stat in ipairs(self.statGainRolls) do
      RollForStatGaining(unit, stat)
    end
    PlayVoiceResponse(unit, "CombatTaskCompleted")
  end
  self.state = "completed"
  self:Finish()
end
function CombatTask:Fail()
  if self.state ~= "inProgress" then
    return
  end
  local unit = g_Units[self.unitId]
  if unit then
    PlayVoiceResponse(unit, "CombatTaskFailed")
  end
  self.state = "failed"
  self:Finish()
end
function CombatTask:Update(progress, otherProgress)
  if self.state ~= "inProgress" then
    return
  end
  if self.competition then
    self.currentProgress = self.currentProgress + (progress or 0)
    self.requiredProgress = self.requiredProgress + (otherProgress or 0)
  else
    self.currentProgress = Clamp(self.currentProgress + progress, 0, self.requiredProgress)
  end
  if self.currentProgress >= self.requiredProgress and not self.holdUntilEnd then
    if self.reverseProgress then
      self:Fail()
    else
      self:Complete()
    end
  end
  ObjModified(self)
end
function CombatTask:ShouldSave()
  return self.state == "inProgress"
end
function CombatTask:GetDynamicData(data)
  data.currentProgress = self.currentProgress
  data.state = self.state
  data.additionalData = self.additionalData
  data.unitId = self.unitId
  data.otherUnitId = self.otherUnitId
end
function CombatTask:SetDynamicData(data)
  self.currentProgress = data.currentProgress
  self.state = data.state
  self.additionalData = data.additionalData
  self.unitId = data.unitId
  self.otherUnitId = data.otherUnitId
end
DefineClass.CombatTaskOwner = {
  __parents = {"Modifiable"},
  combatTasks = false,
  can_remove_combatTasks = true
}
local find = table.find
local find_value = table.find_value
local remove_value = table.remove_value
local type = type
function CombatTaskOwner:AddCombatTask(combattask, ...)
  if type(combattask) == "string" then
    combattask = CombatTaskDefs[combattask]
  end
  if combattask and combattask.__index == combattask then
    combattask = setmetatable({}, combattask)
  end
  combattask = combattask:CanAdd(self, ...)
  if type(combattask) ~= "table" then
    return
  end
  local combatTasks = self.combatTasks
  if not combatTasks then
    combatTasks = {}
    self.combatTasks = combatTasks
  end
  combatTasks[#combatTasks + 1] = combattask
  PostMsg("CombatTaskAdded", self, combattask)
  return combattask:OnAdd(self, ...)
end
function CombatTaskOwner:RemoveCombatTask(combattask, ...)
  if type(combattask) == "string" then
    combattask = CombatTaskDefs[combattask]
  end
  local combatTasks = self.combatTasks
  local n = remove_value(combatTasks, combattask)
  if not n then
    return
  end
  PostMsg("CombatTaskRemoved", self, combattask)
  return combattask:OnRemove(self, ...)
end
function CombatTaskOwner:ForEachCombatTask(func, ...)
  local can_remove = self.can_remove_combatTasks
  self.can_remove_combatTasks = false
  local res
  for _, combattask in ipairs(self.combatTasks) do
    res = func(combattask, ...)
    if res then
      break
    end
  end
  if can_remove then
    self.can_remove_combatTasks = nil
  end
  return res
end
function CombatTaskOwner:FirstCombatTaskById(id)
  return find_value(self.combatTasks, "id", id or false)
end
function CombatTaskOwner:FirstCombatTaskByGroup(group)
  return find_value(self.combatTasks, "group", group or false)
end
function CombatTaskOwner:GetDynamicData(data)
  for i, combattask in ipairs(self.combatTasks) do
    if combattask.ShouldSave == nil or combattask:ShouldSave() then
      data.combatTasks = data.combatTasks or {}
      data.combatTasks[#data.combatTasks + 1] = data.combatTasks[#data.combatTasks + 1] or {}
      data.combatTasks[#data.combatTasks].id = combattask.id
      if type(combattask.GetDynamicData) == "function" then
        combattask:GetDynamicData(data.combatTasks[#data.combatTasks])
      end
    end
  end
end
function CombatTaskOwner:SetDynamicData(data)
  for i, combattask in ipairs(data.combatTasks) do
    local obj = CombatTaskDefs[combattask.id]:new()
    if type(obj.SetDynamicData) == "function" then
      obj:SetDynamicData(combattask)
    end
    self:AddCombatTask(obj)
  end
end
