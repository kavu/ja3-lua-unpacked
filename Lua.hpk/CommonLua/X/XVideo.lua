if FirstLoad then
  Videos = {}
end
DefineClass.XVideo = {
  __parents = {"XControl"},
  [true] = false,
  soundHandle = false,
  properties = {
    {
      category = "Video",
      id = "VideoDefId",
      editor = "preset_id",
      default = "",
      preset_class = "VideoDef"
    },
    {
      category = "Video",
      id = "FileName",
      editor = "text",
      default = ""
    },
    {
      category = "Video",
      id = "Sound",
      editor = "text",
      default = ""
    },
    {
      category = "Video",
      id = "SoundType",
      editor = "preset_id",
      default = "Voiceover",
      preset_class = "SoundTypePreset"
    },
    {
      category = "Video",
      id = "Looping",
      editor = "bool",
      default = false
    },
    {
      category = "Video",
      id = "AutoPlay",
      editor = "bool",
      default = false
    },
    {
      category = "Video",
      id = "Desaturate",
      editor = "number",
      min = 0,
      max = 255,
      default = 0
    },
    {
      category = "Video",
      id = "Gamma",
      editor = "number",
      min = 100,
      max = 10000,
      default = 1000
    }
  },
  resolution = false,
  state = "stopped"
}
video_print = CreatePrint({
  "video",
  format = "printf",
  output = DebugPrint
})
function XVideo:SetVideoDefId(value)
  if not value or value == "" then
    return
  end
  local video_def = VideoDefs[value]
  if not video_def then
    video_print("Video not found in base or activated DLCs. %s", value)
    return
  end
  local ext
  if Platform.desktop then
    ext = "desktop"
  end
  if Platform.xbox_one then
    ext = "xbox_one"
  end
  if Platform.xbox_series then
    ext = "xbox_series"
  end
  if Platform.ps4 then
    ext = "ps4"
  end
  if Platform.ps5 then
    ext = "ps5"
  end
  if Platform.switch then
    ext = "switch"
  end
  if not ext then
    video_print("Video bad ext %s", value)
    return
  end
  local props = video_def:GetPropsForPlatform(ext)
  if not props.present then
    video_print("Video not marked as present. %s", value)
    return
  end
  self.FileName = props.video_game_path or ""
  self.Sound = props.sound_game_path or ""
  self.resolution = props.resolution or point(1920, 1080)
  self.VideoDefId = value
end
function XVideo:Done()
  self:ClearVideo()
end
function XVideo:SetAutoPlay(autoplay)
  self.AutoPlay = autoplay
  if autoplay then
    self:Play()
  else
    self:Stop()
  end
end
function XVideo:SoundStart()
  if (self.Sound or "") ~= "" then
    self.soundHandle = PlaySound(self.Sound, self.SoundType)
  end
end
function XVideo:SoundPause()
  print("pause per sound channel not implemented")
  self:SoundStop()
end
function XVideo:SoundStop()
  StopSound(self.soundHandle)
end
function XVideo:SetFileName(file_name)
  self.FileName = file_name or ""
  self:ClearVideo()
end
function XVideo:SetDesaturate(n)
  if not self[true] or self.Desaturate == n then
    return
  end
  self.Desaturate = n
  self:Invalidate()
end
function XVideo:SetGamma(n)
  if not self[true] or self.Gamma == n then
    return
  end
  self.Gamma = n
  self:Invalidate()
end
function XVideo:OnEnd()
end
function XVideo:Wait()
  WaitMsg(self)
end
function XVideo:_DoStartPlay()
  UIL.videoPlay(self[true])
  self:SoundStart()
  self:Invalidate()
  self.state = "playing"
end
function XVideo:Play()
  local err = self:LoadVideo()
  if err then
    return err
  end
  if GetGameBlockingLoadingScreen() then
    CreateRealTimeThread(function()
      WaitLoadingScreenClose()
      if self[true] and self.state ~= "playing" then
        return self:_DoStartPlay()
      end
    end)
    return
  end
  return self:_DoStartPlay()
end
function XVideo:Pause()
  UIL.videoPause(self[true])
  self.state = "paused"
end
function XVideo:Stop()
  UIL.videoStop(self[true])
  self:SoundStop()
  self.state = "stopped"
end
function XVideo:ClearVideo()
  local video = self[true]
  if video then
    UIL.videoDestroy(video)
    Videos[video] = nil
    self[true] = nil
    self:Invalidate()
  end
  self:SoundStop()
end
function XVideo:LoadVideo()
  if self.FileName ~= "" and not self[true] then
    local dir, filepath, ext = SplitPath(self.FileName)
    if Platform.xbox or Platform.switch then
      ext = ".mp4"
    elseif Platform.playstation then
      ext = ".bsf"
    else
      ext = ".ivf"
    end
    local movie_path = dir .. filepath .. ext
    if Platform.playstation then
      movie_path = GetPreloadedFile(movie_path)
    end
    if Platform.developer and not io.exists(movie_path) then
      print("Missing movie", movie_path)
    end
    local video, err
    if self.resolution then
      video, err = UIL.videoNew(movie_path, self.resolution:xy())
    else
      video, err = UIL.videoNew(movie_path)
    end
    if video then
      self[true] = video
      self:SetDesaturate(const.MovieCorrectionDesaturation)
      self:SetGamma(const.MovieCorrectionGamma)
      Videos[video] = self
      self:Invalidate()
    else
      return err
    end
  end
end
function XVideo:GetVideoSize()
  return UIL.videoGetSize(self[true])
end
function XVideo:GetCurrentFrame()
  return UIL.videoGetCurrentFrame(self[true])
end
function XVideo:GetDuration()
  return UIL.videoGetDuration(self[true])
end
function XVideo:GetFrameCount()
  return UIL.videoGetFrameCount(self[true])
end
function XVideo:Measure(preferred_width, preferred_height)
  local width, height = 1920, 1080
  if width * preferred_height >= preferred_width * height then
    width, height = preferred_width, MulDivRound(height, preferred_width, width)
  end
  local cwidth, cheight = XControl.Measure(self, preferred_width, preferred_height)
  return Max(width, cwidth), Max(height, cheight)
end
function XVideo:DrawContent()
  UIL.videoDraw(self[true], self.content_box, self.Desaturate, self.Gamma)
end
function videoOnEnd(video)
  local videoObj = Videos[video]
  if videoObj then
    videoObj:SoundStop()
    if videoObj.Looping then
      UIL.videoStop(video)
      UIL.videoPlay(video)
      videoObj:SoundStart()
    else
      videoObj.state = "stopped"
    end
    Msg(videoObj)
    videoObj:OnEnd()
  end
end
function StopVideoBracket(global_name)
  local old_func = _G[global_name]
  _G[global_name] = function(...)
    local videos_playing
    for _, window in pairs(Videos) do
      window:ClearVideo()
      videos_playing = videos_playing or {}
      videos_playing[#videos_playing + 1] = window
    end
    local results = pack_params(old_func(...))
    if videos_playing then
      CreateRealTimeThread(function(videos_playing)
        for _, window in ipairs(videos_playing) do
          if window.window_state == "open" then
            window:Play()
          end
        end
      end, videos_playing)
    end
    return unpack_params(results)
  end
end
StopVideoBracket("LoadMetadataCallback")
StopVideoBracket("ChangeMap")
