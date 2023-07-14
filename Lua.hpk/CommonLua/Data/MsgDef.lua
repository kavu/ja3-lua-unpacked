PlaceObj("MsgDef", {
  Params = "prop, old_value, new_value",
  group = "Msg",
  id = "ConstValueChanged",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Description = "An object's cooldown has expired, send only for cooldowns with ExpireMsg = ture",
  Params = "obj, cooldown_id, cooldown_def",
  group = "Msg",
  id = "CooldownExpired",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Description = "An object's cooldown became active",
  Params = "obj, cooldown_id, cooldown_def",
  group = "Msg",
  id = "CooldownSet",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "obj",
  group = "Msg",
  id = "FallingDebrisCrash",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "achievement_id",
  group = "Msg - Achievements",
  id = "AchievementProgress",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "achievement_id",
  group = "Msg - Achievements",
  id = "AchievementUnlocked",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "query, request",
  group = "Msg - Game",
  id = "CanSaveGameQuery",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Description = "The current game is being destroyed",
  Params = "game",
  group = "Msg - Game",
  id = "DoneGame",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  group = "Msg - Game",
  id = "GameOver",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Description = "One or more GameState (global) values have changed",
  Params = "new_state",
  group = "Msg - Game",
  id = "GameStateChanged",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  group = "Msg - Game",
  id = "GameStateChangedNotify",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  group = "Msg - Game",
  id = "GameTimeStart",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Description = "Game loaded",
  Params = "game",
  group = "Msg - Game",
  id = "LoadGame",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Description = "New game created",
  Params = "game",
  group = "Msg - Game",
  id = "NewGame",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "reason",
  group = "Msg - Game",
  id = "Pause",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "metadata, version",
  group = "Msg - Game",
  id = "PostLoadGame",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "metadata",
  group = "Msg - Game",
  id = "PreLoadGame",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  group = "Msg - Game",
  id = "QuitGame",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "reason",
  group = "Msg - Game",
  id = "Resume",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  group = "Msg - Game",
  id = "Start",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "view, lightmodel, time, prev_lm, from_override",
  group = "Msg - Map",
  id = "AfterLightmodelChange",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Description = "The current map is about to be changed",
  Params = "map",
  group = "Msg - Map",
  id = "ChangeMap",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "map",
  group = "Msg - Map",
  id = "ChangeMapDone",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Description = "The current map is being destroyed",
  group = "Msg - Map",
  id = "DoneMap",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "view, lightmodel, time, prev_lm, from_override",
  group = "Msg - Map",
  id = "LightmodelChange",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Description = "New map is about to be loaded",
  Params = "map, mapdata",
  group = "Msg - Map",
  id = "NewMap",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Description = "Map grids and objects are loaded but passability is not calculated yet",
  group = "Msg - Map",
  id = "NewMapLoaded",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  group = "Msg - Map",
  id = "PostDoneMap",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Description = "Map loading is complete. Passability is calculated and GameInit methods of objects are called.",
  group = "Msg - Map",
  id = "PostNewMapLoaded",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  group = "Msg - Map",
  id = "PostSaveMap",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "map, mapdata",
  group = "Msg - Map",
  id = "PreNewMap",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  group = "Msg - Map",
  id = "PreSaveMap",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "obj, prev",
  group = "Msg - Map",
  id = "SelectedObjChange",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "obj",
  group = "Msg - Map",
  id = "SelectionAdded",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  group = "Msg - Map",
  id = "SelectionChange",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "obj",
  group = "Msg - Map",
  id = "SelectionRemoved",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  group = "Msg - PhotoMode",
  id = "PhotoModeBegin",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  group = "Msg - PhotoMode",
  id = "PhotoModeEnd",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  group = "Msg - PhotoMode",
  id = "PhotoModeFreeCameraActivated",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  group = "Msg - PhotoMode",
  id = "PhotoModeFreeCameraDeactivated",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  group = "Msg - PhotoMode",
  id = "PhotoModeScreenshotTaken",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  group = "Msg - Setpiece",
  id = "SetPieceDoneWaitingLS",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "actor",
  group = "Msg - Setpiece",
  id = "SetpieceActorRegistered",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "actor",
  group = "Msg - Setpiece",
  id = "SetpieceActorUnegistered",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "state, thread, statement",
  group = "Msg - Setpiece",
  id = "SetpieceCommandCompleted",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  group = "Msg - Setpiece",
  id = "SetpieceDialogClosed",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "setpiece, state",
  group = "Msg - Setpiece",
  id = "SetpieceEndExecution",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "setpiece",
  group = "Msg - Setpiece",
  id = "SetpieceEnded",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "setpiece",
  group = "Msg - Setpiece",
  id = "SetpieceEnding",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "setpiece",
  group = "Msg - Setpiece",
  id = "SetpieceStartExecution",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  group = "Msg - Setpiece",
  id = "SetpieceStarted",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "setpiece",
  group = "Msg - Setpiece",
  id = "SetpieceStarting",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "storybit_id, storybit_state",
  group = "Msg - StoryBit",
  id = "StoryBitActivated",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "storybit_id, storybit_state",
  group = "Msg - StoryBit",
  id = "StoryBitCompleted",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "storybit_id, storybit_state",
  group = "Msg - StoryBit",
  id = "StoryBitPopup",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "storybit_id, storybit_state, reply_counter",
  group = "Msg - StoryBit",
  id = "StoryBitReplyActivated",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "new_mode",
  group = "Msg - UI",
  id = "IGIModeChanged",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "old_mode, new_mode",
  group = "Msg - UI",
  id = "IGIModeChanging",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Params = "inGameInterface",
  group = "Msg - UI",
  id = "InGameInterfaceCreated",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  group = "Msg - UI",
  id = "InGameMenuClose",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  group = "Msg - UI",
  id = "InGameMenuOpen",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Description = "Closed the pregame menu.",
  group = "Msg - UI",
  id = "PreGameMenuClose",
  save_in = "Common"
})
PlaceObj("MsgDef", {
  Description = "Opened the pregame menu.",
  group = "Msg - UI",
  id = "PreGameMenuOpen",
  save_in = "Common"
})
