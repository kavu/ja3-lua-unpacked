local CameraThread = function()
  local time_factor = 5000
  SetTimeFactor(time_factor)
  while true do
    local target = AsyncRand(MapGet("map") or empty_table)
    ViewObject(target, 500)
    Sleep(2000)
    SetTimeFactor(time_factor)
  end
end
local start_on_loading_screen_close = false
function RunPGOTrain()
  local trainMap = config.TrainMap or "TrainMap.savegame.sav"
  local PgoDataFolder = string.match(GetAppCmdLine(), "-PGOTrain=([^ ]*)")
  if not PgoDataFolder or not io.exists(PgoDataFolder) then
    quit(1)
  end
  PgoDataFolder = SlashTerminate(PgoDataFolder)
  config.PgoTrainDataFolder = PgoDataFolder
  PgoDataFolder = PgoDataFolder .. "saves:/"
  if not io.exists(PgoDataFolder .. trainMap) then
    print("Savefile not found!")
    quit(1)
  end
  function GetPCSaveFolder()
    return PgoDataFolder
  end
  start_on_loading_screen_close = true
  LoadGame(trainMap)
end
function OnMsg.LoadingScreenPreClose()
  if start_on_loading_screen_close and Platform.pgo_train and config.PgoTrainDataFolder then
    start_on_loading_screen_close = false
    DebugPrint("Starting up PGO threads\n")
    CreateRealTimeThread(CameraThread)
    CreateRealTimeThread(function()
      Sleep(60000)
      DebugPrint("Sweeping and exiting.\n")
      PgoAutoSweep("PGOResult")
      Sleep(2000)
      quit(0)
    end)
  end
end
