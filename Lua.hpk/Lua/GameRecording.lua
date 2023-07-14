function ReplayLoadGameSpecificSave(gameRecord)
  Pause("load-replay-save")
  LoadGameSessionData(gameRecord.start_save)
  Resume("load-replay-save")
end
config.GameReplay_EventsDuringPlaybackExpected = true
if FirstLoad then
  GameReplayCurrentRecordedTimeFactor = const.DefaultTimeFactor
  origSetTimeFactor = SetTimeFactor
end
local test_time = 50000
if FirstLoad then
  GameTesting = false
end
function OnMsg.GameTestsBegin(auto_test)
  GameTesting = true
end
function OnMsg.GameTestsEnd(auto_test)
  GameTesting = false
end
function OnMsg.Resume()
  if GameTesting then
    __SetTimeFactor(test_time)
  end
end
function OnMsg.GameReplayStart()
  GameRecord = false
  SetGameRecording(false)
end
function OnMsg.GameReplaySaved(path)
  print("Saved replay " .. path)
  GameRecord = false
  SetGameRecording(false)
end
local _netFuncsToOverride = {
  "NetSyncEvent",
  "NetEchoEvent"
}
local _netFuncToNetFuncArray = {
  NetSyncEvent = "NetSyncEvents",
  NetEchoEvent = "NetEvents"
}
local _defaultNetFunc = "NetSyncEvent"
_replayDesynced = false
function IsGameReplayRecording()
  return not not GameRecord
end
function StopGameRecord()
  if IsValidThread(GameReplayThread) then
    DeleteThread(GameReplayThread)
    GameReplayThread = false
    Resume("UI")
    Msg("GameReplayEnd")
    GameRecord = false
  end
end
function NetSyncEvents.ReplayEnded()
  GameTestsPrint("Replay done")
  if IsValidThread(GameReplayThread) then
    DeleteThread(GameReplayThread)
  end
  Msg("GameReplayEnd")
end
function ZuluStartScheduledReplay()
  if not GameReplayScheduled then
    return
  end
  local record = GameReplayScheduled
  GameReplayScheduled = false
  GameReplay = record
  GameReplay.next_hash = 1
  GameReplay.next_rand = 1
  _replayDesynced = false
  GameReplayThread = CreateGameTimeThread(function()
    if GameReplayThread ~= CurrentThread() and IsValidThread(GameReplayThread) then
      DeleteThread(GameReplayThread)
    end
    local total_time = Max((record[#record] or empty_table)[RECORD_GTIME] or 0, record.game_time or 0)
    Msg("GameReplayStart")
    GameTestsPrint("Replay start:", #record, "events", "|", string.format(total_time * 0.001), "sec", "|", "Lua rev", record.lua_rev or 0, "/", LuaRevision, "|", "assets rev", record.assets_rev or 0, "/", AssetsRevision)
    for i = 1, #record do
      local entry = record[i]
      local event, params = entry[RECORD_EVENT], entry[RECORD_PARAM]
      local gtime, rtime, etype = entry[RECORD_GTIME], entry[RECORD_RTIME], entry[RECORD_ETYPE]
      ScheduleSyncEvent(event, Serialize(UnserializeRecordParams(params)), gtime)
      if event == "FenceReceived" then
        WaitMsg("ReplayFenceCleared")
      end
      if i == #record then
        ScheduleSyncEvent("ReplayEnded", false, gtime)
      end
    end
    GameReplayThread = CreateGameTimeThread(function()
      WaitMsg("GameReplayEnd")
    end)
  end)
end
function OnMsg.CanSaveGameQuery(query)
  query.replay_running = IsGameReplayRunning() or nil
  query.replay_recording = IsGameReplayRecording() or nil
end
if FirstLoad then
  ContinueOnReplayDesync = not not Platform.trailer
end
local lReplayDesynced = function()
  _replayDesynced = true
  if ContinueOnReplayDesync then
    return
  end
  DeleteThread(GameReplayThread)
  Msg("GameReplayEnd", GameReplay)
end
function GetSetpieceTimeFactor()
  return IsGameReplayRunning() and GameReplayCurrentRecordedTimeFactor or GetTimeFactor()
end
function NetSyncEvents.RecordedTimeFactor(time_factor)
  GameReplayCurrentRecordedTimeFactor = time_factor
  if IsGameReplayRecording() then
    origSetTimeFactor(time_factor)
  end
end
function CreateRecordingSetTimeFactorOverload()
  function _G.SetTimeFactor(time_factor)
    if IsGameReplayRecording() then
      NetSyncEvent("RecordedTimeFactor", time_factor)
    else
      origSetTimeFactor(time_factor)
    end
  end
end
function RegisterGameRecordOverrides()
  for i, event_type in ipairs(_netFuncsToOverride) do
    CreateRecordedEvent(event_type)
  end
  CreateRecordingSetTimeFactorOverload()
  CreateRecordedMapLoadRandom()
  CreateRecordedGenerateHandle()
  if FirstLoad then
    local origNetUpdateNesh = NetUpdateHash
    local hashRecordingUpdate = function(...)
      local hash = origNetUpdateNesh(...)
      NetHashRecordingTracker(...)
      return hash
    end
    NetUpdateHash = hashRecordingUpdate
  end
  local origInteractionRand = InteractionRand
  local RecordedInteractionRand = function(...)
    local rand = origInteractionRand(...)
    InteractionRandRecordingTracker(rand, ...)
    return rand
  end
  InteractionRand = RecordedInteractionRand
end
function InteractionRandRecordingTracker(rolledRand, ...)
  local playingReplay = IsGameReplayRunning()
  local recordingReplay = IsGameReplayRecording()
  if not playingReplay and not recordingReplay then
    return
  end
  local paramsSerialized = Serialize({
    ...
  })
  local hash = xxhash(GameTime(), rolledRand, paramsSerialized)
  if playingReplay then
    local expectedHashIdx = GameReplay.next_rand
    local expectedHashData = GameReplay.rand_list[expectedHashIdx]
    local expectedHash = type(expectedHashData) == "table" and expectedHashData[1] or expectedHashData
    if not expectedHash and expectedHashIdx > #GameReplay.rand_list then
      return
    end
    if hash ~= expectedHash and not _replayDesynced then
      if expectedHashIdx == 1 and playingReplay and not recordingReplay and (GameState.loading_savegame or GameState.loading) then
        return
      end
      local params = {
        ...
      }
      GameTestsError("Replay desynced @", GameTime(), "Rand expected", expectedHash, "but got", hash, " expectedHashIdx", expectedHashIdx)
      print("incoming :", GameTime(), rolledRand, GetStack())
      print("expected :", expectedHashData[4], expectedHashData[3], expectedHashData[5])
      lReplayDesynced()
    end
    GameReplay.next_rand = expectedHashIdx + 1
  elseif GameRecord and GameRecord.rand_list then
    local params = {
      ...
    }
    for i = #params, 1, -1 do
      local o = params[i]
      if IsValid(o) then
        params[i] = string.format("Obj with class %s and handle %d", o.class, o:HasMember("handle") and o.handle or "N/A")
      end
    end
    GameRecord.rand_list[#GameRecord.rand_list + 1] = {
      hash,
      params,
      rolledRand,
      GameTime(),
      GetStack()
    }
  end
end
function Dbg_StringToBytesAsString(str)
  return table.concat({str}, ", ")
end
function NetHashRecordingTracker(...)
  local params = {
    ...
  }
  if GameReplayScheduled and params[1] == "NewMapLoaded" then
    ZuluStartScheduledReplay()
  end
  local playingReplay = IsGameReplayRunning()
  local recordingReplay = IsGameReplayRecording()
  if not playingReplay and not recordingReplay then
    return
  end
  if GameReplay and GameReplay.lua_rev == 327744 and (params[1] == "ResetInteractionRand" or params[1] == "InteractionRand") then
    return
  end
  if playingReplay and params and params[1] == "SyncEvent" and params[2] == "ReplayEnded" then
    return
  end
  local paramsSerialized = Serialize(params)
  local netHashVal = NetGetHashValue()
  local hash = xxhash(GameTime(), netHashVal)
  if playingReplay then
    local expectedHashIdx = GameReplay.next_hash
    local expectedHashData = GameReplay.hash_list[expectedHashIdx]
    local expectedHash = type(expectedHashData) == "table" and expectedHashData[1] or expectedHashData
    if not expectedHash and expectedHashIdx > #GameReplay.hash_list then
      return
    end
    if hash ~= expectedHash and not _replayDesynced then
      GameTestsError("Replay desynced @", GameTime(), "Hash expected", expectedHash, "but got", hash)
      lReplayDesynced()
    end
    GameReplay.next_hash = expectedHashIdx + 1
  elseif GameRecord and GameRecord.hash_list then
    GameRecord.hash_list[#GameRecord.hash_list + 1] = {
      hash,
      paramsSerialized,
      GameTime(),
      GetStack()
    }
  end
end
function SetGameRecording(val)
  config.EnableGameRecording = val
end
function CreateRecordedMapLoadRandom()
  local origInitMapLoadRandom = InitMapLoadRandom
  function InitMapLoadRandom()
    if GameTime() ~= 0 then
      return origInitMapLoadRandom()
    end
    local rand
    if GameReplayScheduled then
      rand = GameReplayScheduled.start_rand
    else
      rand = origInitMapLoadRandom()
      if mapdata and mapdata.GameLogic and config.EnableGameRecording then
        GameReplay = false
        print("Game is being recorded.")
        GameRecordScheduled = {
          start_rand = rand,
          map_name = GetMapName(),
          os_time = os.time(),
          real_time = RealTime(),
          game = Game,
          lua_rev = LuaRevision,
          assets_rev = AssetsRevision,
          handles = {},
          version = GameRecordVersion,
          hash_list = {},
          rand_list = {},
          net_update_hash = true
        }
      end
    end
    return rand
  end
end
function ZuluStartRecordingReplay()
  if GameReplayScheduled then
    return
  end
  CreateRealTimeThread(function()
    local save = GatherSessionData():str()
    SetGameRecording(true)
    LoadGameSessionData(save)
    GameRecord.start_save = save
  end)
end
local SuspendAutosave = function()
  config.AutosaveSuspended = true
end
local ResumeAutosave = function()
  config.AutosaveSuspended = false
end
OnMsg.GameReplayStart = SuspendAutosave
OnMsg.GameRecordingStarted = SuspendAutosave
OnMsg.GameReplayEnd = ResumeAutosave
OnMsg.GameReplaySaved = ResumeAutosave
if FirstLoad then
  ShowReplayUI = not not Platform.trailer
  ReplayUISpeed = false
end
function OnMsg.GameReplayStart()
  ObjModified("replay_ui")
  if ShowReplayUI then
    ReplayUISpeed = ReplayUISpeed or const.DefaultTimeFactor
    SetTimeFactor(ReplayUISpeed)
    Pause("UI")
  end
end
function OnMsg.GameReplayEnd()
  GameRecord = false
  ObjModified("replay_ui")
  Resume("UI")
  SetTimeFactor(const.DefaultTimeFactor)
end
function OnMsg.GameRecordingStarted()
  ObjModified("replay_ui")
end
function OnMsg.GameReplaySaved()
  ObjModified("replay_ui")
end
function PlaybackNetSyncEvent(eventId, ...)
  if IsGameReplayRunning() then
    NetSyncEvents[eventId](...)
  else
    NetSyncEvent(eventId, ...)
  end
end
