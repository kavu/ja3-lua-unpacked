if FirstLoad then
  s_AchievementReceivedSignals = {}
  s_AchievementUnlockedSignals = {}
  _AchievementsToUnlock = {}
  _UnlockThread = false
  g_SteamIdToAchievementName = {}
  g_AchievementNameToSteamId = {}
end
function OnMsg.DataLoaded()
  g_SteamIdToAchievementName = {}
  g_AchievementNameToSteamId = {}
  ForEachPreset(Achievement, function(achievement, group_list)
    local steam_id = achievement.steam_id ~= "" and achievement.steam_id or achievement.id
    g_SteamIdToAchievementName[steam_id] = achievement.id
    g_AchievementNameToSteamId[achievement.id] = steam_id
  end)
end
TransferUnlockedAchievementsFromSteam = true
function OnSteamAchievementsReceived()
  Msg(s_AchievementReceivedSignals)
end
function OnSteamAchievementUnlocked(unlock_status)
  if unlock_status == "success" then
    Msg(s_AchievementUnlockedSignals)
  end
end
local WaitGetAchievements = function()
  if IsSteamLoggedIn() and SteamQueryAchievements(table.values(table.map(AchievementPresets, "steam_id"))) then
    local ok, data
    if WaitMsg(s_AchievementReceivedSignals, 5000) then
      data = SteamGetAchievements()
      if data then
        return true, table.map(data, g_SteamIdToAchievementName)
      end
    end
  end
  return false
end
local GetSteamAchievementIds = function(achievements)
  local steam_achievements = {}
  for i, name in ipairs(achievements) do
    if AchievementPresets[name] then
      local steam_id = g_AchievementNameToSteamId[name]
      if not steam_id then
        print("Achievement", name, "doesn't have a Steam ID!")
      else
        table.insert(steam_achievements, steam_id)
      end
    end
  end
  return steam_achievements
end
local WaitAchievementUnlock = function(achievements)
  if not Platform.steam or not IsSteamLoggedIn() then
    return true
  end
  local steam_achievements = GetSteamAchievementIds(achievements)
  local steam_unlocked = SteamUnlockAchievements(steam_achievements) and WaitMsg(s_AchievementUnlockedSignals, 5000)
  if not steam_unlocked then
    Msg("SteamUnlockAchievementsFailed", steam_achievements)
  end
  return true
end
function AsyncAchievementUnlock(achievement)
  _AchievementsToUnlock[achievement] = true
  if not IsValidThread(_UnlockThread) then
    _UnlockThread = CreateRealTimeThread(function()
      local achievement = next(_AchievementsToUnlock)
      while achievement do
        if WaitAchievementUnlock({achievement}) then
          Msg("AchievementUnlocked", achievement)
        else
          AccountStorage.achievements.unlocked[achievement] = false
        end
        _AchievementsToUnlock[achievement] = nil
        achievement = next(_AchievementsToUnlock)
      end
    end)
  end
end
function SynchronizeAchievements()
  if not IsSteamLoggedIn() then
    return
  end
  for k, v in pairs(AccountStorage.achievements.progress) do
    _CheckAchievementProgress(k, "don't unlock in provider")
  end
  local account_storage_unlocked = AccountStorage.achievements.unlocked
  CreateRealTimeThread(function()
    if account_storage_unlocked ~= AccountStorage.achievements.unlocked then
      print("Synchronize achievements aborted!")
      return
    end
    WaitAchievementUnlock(table.keys(account_storage_unlocked))
    if not TransferUnlockedAchievementsFromSteam then
      return
    end
    if account_storage_unlocked ~= AccountStorage.achievements.unlocked then
      print("Synchronize achievements aborted!")
      return
    end
    local ok, steam_unlocked = WaitGetAchievements()
    if account_storage_unlocked ~= AccountStorage.achievements.unlocked then
      print("Synchronize achievements aborted!")
      return
    end
    if not ok then
      print("Synchronize achievements failed!")
      return
    end
    local save = false
    for i = 1, #steam_unlocked do
      local id = steam_unlocked[i]
      if not account_storage_unlocked[id] then
        save = true
      end
      account_storage_unlocked[id] = true
    end
    if save then
      SaveAccountStorage(5000)
    end
  end)
end
function CheatPlatformUnlockAllAchievements()
  if not Platform.steam or not IsSteamLoggedIn() then
  end
  local steam_achievements = GetSteamAchievementIds(table.keys(AchievementPresets, true))
  SteamUnlockAchievements(steam_achievements)
end
function CheatPlatformResetAllAchievements()
  if not Platform.steam or not IsSteamLoggedIn() then
  end
  local steam_achievements = GetSteamAchievementIds(table.keys(AchievementPresets, true))
  SteamResetAchievements(steam_achievements)
end
