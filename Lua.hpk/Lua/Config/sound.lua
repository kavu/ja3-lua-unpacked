config.Music = 1
config.Sound = 1
config.Voice = 1
config.SoundGroups = {
  "Sound",
  "Music",
  "Voice",
  "UI",
  "Ambience"
}
config.SoundOptionGroups = {
  Sound = {"Sound"},
  UI = {"UI"},
  Ambience = {"Ambience"},
  Music = {"Music"},
  Voice = {"Voice"}
}
config.SoundVoiceReduce = {
  "Ambience",
  "AmbientLife",
  "Music"
}
config.SoundVoiceReduceVolume = 500
config.SoundVoiceReduceTime = 500
DefaultMusicSilenceDuration = 20000
listener = {
  UpdateTime = 16,
  ViewListenMask = 1,
  ViewFollowMask = 1,
  MainView = 0,
  CameraTacVerticalOffset = "1.0",
  DistanceFromCamera = "0.8",
  SoundPosZFactor = "1",
  Radius = "150",
  HeightRadiusIncrease = "0",
  LowHeight = "2",
  HighHeight = "20",
  PlayThreshold = "8",
  StopHysteresis = "2",
  LeavingSoundsFadeOutTime = 2500,
  EnteringSoundsFadeInTime = 0,
  DebugVolumeVectorOffset = 3,
  DebugVolumeVectorLength = 5
}
SetupVarTable(listener, "listener.")
config.UseReverb = Platform.developer
config.DopplerFactor = "1"
const.MusicMaxVolume = 480
const.MusicDefaultVolume = 400
const.MasterMaxVolume = 1000
const.MasterDefaultVolume = 1000
const.VoiceMaxVolume = 1200
const.VoiceDefaultVolume = 1000
const.SoundMaxVolume = 1200
const.SoundDefaultVolume = 1000
const.UIMaxVolume = 1200
const.UIDefaultVolume = 1000
const.AmbienceMaxVolume = 1200
const.AmbienceDefaultVolume = 1000
