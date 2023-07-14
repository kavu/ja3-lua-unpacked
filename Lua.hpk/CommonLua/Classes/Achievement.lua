ach_print = CreatePrint({})
function CanUnlockAchievement(achievement)
  return false, "not implemented"
end
function AsyncAchievementUnlock(achievement)
  Msg("AchievementUnlocked", achievement)
end
function SynchronizeAchievements()
end
PlatformCanUnlockAchievement = return_true
CheatPlatformUnlockAllAchievements = empty_func
CheatPlatformResetAllAchievements = empty_func
function GetAchievementFlags(achievement)
  return AccountStorage.achievements.unlocked[achievement], AchievementPresets[achievement].secret
end
function GetUnlockedAchievementsCount()
  local unlocked, total = 0, 0
  ForEachPreset(Achievement, function(achievement)
    if not achievement:IsCurrentlyUsed() then
      return
    end
    unlocked = unlocked + (AccountStorage.achievements.unlocked[achievement.id] and 1 or 0)
    total = total + 1
  end)
  return unlocked, total
end
function _CheckAchievementProgress(achievement, dont_unlock_in_provider)
  local progress = AccountStorage.achievements.progress[achievement] or 0
  local target = AchievementPresets[achievement].target
  if target and progress >= target then
    AchievementUnlock(achievement, dont_unlock_in_provider)
  end
end
local EngineCanUnlockAchievement = function(achievement)
  if Platform.demo then
    return false, "not available in demo"
  end
  if GameState.Tutorial then
    return false, "in tutorial"
  end
  if AccountStorage.achievements.unlocked[achievement] then
    return false, "already unlocked"
  end
  if not AchievementPresets[achievement] then
    return false, "dlc not present"
  end
  return PlatformCanUnlockAchievement(achievement)
end
local CanModifyAchievementProgress = function(achievement)
  local success, reason = EngineCanUnlockAchievement(achievement)
  if not success then
    ach_print("cannot modify achievement progress, forbidden by engine check ", achievement, reason)
    return false
  end
  local success, reason = CanUnlockAchievement(achievement)
  if not success then
    ach_print("cannot modify achievement progress, forbidden by title-specific check ", achievement, reason)
    return false
  end
  return true
end
function AddAchievementProgress(achievement, progress, max_delay_save)
  if not CanModifyAchievementProgress(achievement) then
    return
  end
  local ach = AchievementPresets[achievement]
  local current = AccountStorage.achievements.progress[achievement] or 0
  local save_storage = not ach.save_interval or (current + progress) / ach.save_interval > current / ach.save_interval
  local total = current + progress
  local target = ach.target or 0
  if total >= target then
    total = target
    save_storage = false
  end
  AccountStorage.achievements.progress[achievement] = total
  if save_storage then
    SaveAccountStorage(max_delay_save)
  end
  Msg("AchievementProgress", achievement)
  _CheckAchievementProgress(achievement)
  return true
end
function ClearAchievementProgress(achievement, max_delay_save)
  if not CanModifyAchievementProgress(achievement) then
    return
  end
  AccountStorage.achievements.progress[achievement] = 0
  SaveAccountStorage(max_delay_save)
  Msg("AchievementProgress", achievement)
  return true
end
function AchievementUnlock(achievement, dont_unlock_in_provider)
  if not CanModifyAchievementProgress(achievement) then
    return
  end
  AccountStorage.achievements.unlocked[achievement] = true
  if not dont_unlock_in_provider then
    AsyncAchievementUnlock(achievement)
  end
  SaveAccountStorage(5000)
  return true
end
if Platform.developer then
  function AchievementUnlockAll()
    CreateRealTimeThread(function()
      for id, achievement_data in sorted_pairs(AchievementPresets) do
        AchievementUnlock(id)
        Sleep(100)
      end
    end)
  end
end
