DefineClass.XSetpieceDlg = {
  __parents = {"XDialog"},
  ZOrder = 99,
  HandleMouse = true,
  skippable = true,
  openedAt = false,
  skipDelay = 250,
  setpiece = false,
  setpiece_seed = 0,
  testMode = false,
  triggerUnits = false,
  extra_params = false,
  setpieceInstance = false,
  fadeDlg = false,
  lifecycle_thread = false,
  skipping_setpiece = false
}
function XSetpieceDlg:Init(parent, context)
  self.setpiece = context and context.setpiece or "MoveTest"
  self.testMode = context and context.testMode
  self.triggerUnits = context and context.triggerUnits
  self.extra_params = context and context.extra_params or empty_table
  NetUpdateHash("SetpieceStateStart")
  ChangeGameState("setpiece_playing", true)
end
function XSetpieceDlg:Open(...)
  XDialog.Open(self, ...)
  self.openedAt = GameTime()
  if rawget(self, "idSkipHint") then
    if GetUIStyleGamepad(nil, self) then
      self.idSkipHint:SetText(T(576896503712, "<ButtonB> Skip"))
    else
      self.idSkipHint:SetText(T(696052205292, "<style SkipHint>Escape: Skip</style>"))
    end
  end
  self.lifecycle_thread = CreateGameTimeThread(XSetpieceDlg.Lifecycle, self)
end
DefineClass.XMovieBlackBars = {
  __parents = {"XDialog"},
  top = false,
  bottom = false
}
function XMovieBlackBars:Open()
  XDialog.Open(self)
  local top = XTemplateSpawn("XWindow", self)
  top:SetDock("top")
  top:SetBackground(RGBA(0, 0, 0, 255))
  top:Open()
  self.top = top
  local bottom = XTemplateSpawn("XWindow", self)
  bottom:SetDock("bottom")
  bottom:SetBackground(RGBA(0, 0, 0, 255))
  bottom:Open()
  self.bottom = bottom
  local left = XTemplateSpawn("XWindow", self)
  left:SetDock("left")
  left:SetBackground(RGBA(0, 0, 0, 255))
  left:Open()
  self.left = left
  local right = XTemplateSpawn("XWindow", self)
  right:SetDock("right")
  right:SetBackground(RGBA(0, 0, 0, 255))
  right:Open()
  self.right = right
end
function XMovieBlackBars:SetLayoutSpace(x, y, width, height)
  local targetRatio = MulDivRound(16, 100, 9)
  local aspectWidth = width
  local aspectHeight = MulDivRound(width, 100, targetRatio)
  if height < aspectHeight then
    aspectWidth = MulDivRound(height, targetRatio, 100)
    local blackBarWidth = (width - aspectWidth) / 2
    local blackBarWidth = Max(blackBarWidth, 100)
    self.left:SetMinWidth(blackBarWidth)
    self.right:SetMinWidth(blackBarWidth)
    self.top:SetVisible(false)
    self.bottom:SetVisible(false)
  else
    aspectWidth = MulDivRound(height, targetRatio, 100)
    aspectHeight = MulDivRound(aspectWidth, 100, targetRatio)
    local blackBarHeight = (height - aspectHeight) / 2
    blackBarHeight = Max(blackBarHeight, 100)
    self.top:SetMinHeight(blackBarHeight)
    self.bottom:SetMinHeight(blackBarHeight)
    self.left:SetVisible(false)
    self.right:SetVisible(false)
  end
  return XWindow.SetLayoutSpace(self, x, y, width, height)
end
function OnMsg.Autorun()
  NetSyncEvents.SetPieceDoneWaitingLS = SetPieceDoneWaitingLS
end
function SetPieceDoneWaitingLS()
  Msg("SetPieceDoneWaitingLS")
end
function XSetpieceDlg:Lifecycle()
  local loadingScreenDlg = GetDialog("XZuluLoadingScreen")
  local reasonsOpen = loadingScreenDlg and loadingScreenDlg:GetOpenReasons()
  if reasonsOpen and (reasonsOpen["load savegame"] or reasonsOpen["load game data"]) then
    SectorLoadingScreenClose("idLoadingScreen", "load savegame")
    SectorLoadingScreenClose("idLoadingScreen", "load game data")
  end
  local setpiece = Setpieces[self.setpiece]
  Msg("SetpieceStarting", setpiece)
  OnSetpieceStarted(setpiece)
  local camera = {
    GetCamera()
  }
  XTemplateSpawn("XCameraLockLayer", self):Open()
  XHideDialogs:new({
    Id = "idHideDialogs",
    LeaveDialogIds = self:HasMember("LeaveDialogsOpen") and self.LeaveDialogsOpen or false
  }, self):Open()
  local blackbars = XTemplateSpawn("XMovieBlackBars", self)
  blackbars:Open()
  if not netInGame or table.count(netGamePlayers) <= 1 then
    WaitLoadingScreenClose()
  else
    if NetIsHost() then
      local dlg = GetLoadingScreenDialog()
      if dlg then
        WaitLoadingScreenClose()
      end
      NetSyncEvent("SetPieceDoneWaitingLS")
    end
    WaitMsg("SetPieceDoneWaitingLS", 60000)
  end
  NetUpdateHash("XSetpieceDlg:Lifecycle_Starting")
  local uiChildren = XTemplateSpawn("XWindow", self)
  uiChildren:SetId("idSetpieceUI")
  uiChildren:Open()
  uiChildren:SetZOrder(0)
  self.setpieceInstance = StartSetpiece(self.setpiece, self.testMode, self.setpiece_seed, self.triggerUnits, unpack_params(self.extra_params))
  Msg("SetpieceStarted", setpiece)
  self:WaitSetpieceCompletion()
  Msg("SetpieceEnding", setpiece)
  local skipHint = rawget(self, "idSkipHint")
  if skipHint then
    skipHint:Close()
  end
  if setpiece.RestoreCamera then
    SetCamera(unpack_params(camera))
  else
    SetupInitialCamera("dont_move_camera")
  end
  NetUpdateHash("SetpieceStateDone")
  ChangeGameState("setpiece_playing", false)
  sprocall(EndSetpiece, self.setpiece)
  Msg("SetpieceEnded", setpiece)
  WaitNextFrame(7)
  self:Close()
end
function XSetpieceDlg:GetFadeWin()
  if not self.fadeDlg then
    local fadeWin = XWindow:new({
      Visible = false,
      Background = RGBA(0, 0, 0, 255)
    }, self)
    fadeWin:Open()
    self.fadeDlg = fadeWin
  end
  return self.fadeDlg
end
function GetSetpieceTimeFactor()
  return IsGameReplayRunning() and const.DefaultTimeFactor or GetTimeFactor()
end
function XSetpieceDlg:FadeOut(fadeOutTime)
  if self.skipping_setpiece then
    return
  end
  local fade_win = self:GetFadeWin()
  local fade_time = MulDivRound(fadeOutTime, 1000, GetSetpieceTimeFactor())
  if 0 < fade_time then
    if fade_win:GetVisible() then
      return
    end
    fade_win.FadeInTime = fade_time
    fade_win:SetVisible(true)
    Sleep(fade_time)
  else
    fade_win:SetVisible(true, "instant")
  end
end
function XSetpieceDlg:FadeIn(fadeInDelay, fadeInTime)
  if self.skipping_setpiece then
    return
  end
  local fade_win = self:GetFadeWin()
  fade_win.FadeOutTime = MulDivRound(fadeInTime, 1000, GetSetpieceTimeFactor())
  fade_win:SetVisible(true, "instant")
  Sleep(fadeInDelay or self.fadeOutDelay)
  fade_win:SetVisible(false)
  Sleep(fade_win.FadeOutTime)
end
function XSetpieceDlg:WaitSetpieceCompletion()
  while not self.setpieceInstance do
    WaitMsg("SetpieceStarted", 300)
  end
  self.setpieceInstance:WaitCompletion()
end
function SkipSetpiece(setpieceInstance)
  setpieceInstance:Skip()
end
function XSetpieceDlg:OnShortcut(shortcut, source, ...)
  if GameTime() - self.openedAt < self.skipDelay then
    return "break"
  end
  if RealTime() - terminal.activate_time < self.skipDelay then
    return "break"
  end
  if rawget(self, "skip_input_done") then
    return
  end
  if rawget(self, "idSkipHint") and not self.idSkipHint:GetVisible() then
    self.idSkipHint:SetVisible(true)
    return "break"
  end
  if shortcut ~= "Escape" and shortcut ~= "ButtonB" and shortcut ~= "MouseL" then
    return
  end
  if self.skippable and self.setpieceInstance and (not IsRecording() or shortcut == "Escape") then
    local skipHint = rawget(self, "idSkipHint")
    if skipHint then
      skipHint:SetVisible(false)
    end
    rawset(self, "skip_input_done", true)
    SkipSetpiece(self.setpieceInstance)
    return "break"
  end
end
function SkipAnySetpieces()
  local dlg = GetDialog("XSetpieceDlg")
  if dlg and dlg.setpieceInstance then
    dlg.setpieceInstance:Skip()
    dlg:WaitSetpieceCompletion()
    while GameState.setpiece_playing do
      WaitMsg("SetpieceEnded", 100)
    end
  end
end
function IsSetpiecePlaying()
  return GameState.setpiece_playing
end
function IsSetpieceTestMode()
  local dlg = GetDialog("XSetpieceDlg")
  return dlg and dlg.testMode
end
function WaitPlayingSetpiece()
  local dlg = GetDialog("XSetpieceDlg")
  if dlg then
    dlg:Wait()
  end
end
function OnMsg.SetpieceStarted()
  ObjModified("setpiece_observe")
end
function OnMsg.SetpieceDialogClosed()
  ObjModified("setpiece_observe")
end
function MovieRecordSetpiece(id, duration, quality, shutter)
  quality = quality or 64
  shutter = shutter or 0
  OpenDialog("XSetpieceDlg", false, {setpiece = id})
  RecordMovie(id .. ".tga", 0, 60, duration, quality, shutter, function()
    return not IsSetpiecePlaying()
  end)
end
