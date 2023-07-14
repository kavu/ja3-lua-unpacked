if FirstLoad then
  MovieSubtitles = {
    English = {}
  }
end
function GetMovieSubtitles(movie)
  local lang1 = MovieSubtitles[GetVoiceLanguage() or ""]
  local lang2 = MovieSubtitles.English
  return lang1 and lang1[movie] or lang2 and lang2[movie]
end
DefineClass.XFullscreenMovieDlg = {
  __parents = {"XDialog"},
  skippable = true,
  sound_type = "Voiceover",
  fade_in = false,
  fadeout_music = false,
  open_time = false,
  movie_path = false,
  subtitles = false,
  text_style = false
}
function XFullscreenMovieDlg:Init(parent, context)
  self.skippable = context.skippable or true
  self.sound_type = context.sound_type or "Voiceover"
  self.fade_in = context.fade_in
  self.movie_path = context.movie_path
  self.subtitles = context.subtitles
  self.fadeout_music = context.fadeout_music
  self.text_style = context.text_style
end
function XFullscreenMovieDlg:Open(...)
  XDialog.Open(self, ...)
  self.open_time = RealTime()
  if self.text_style then
    self.idSubtitles:SetTextStyle(self.text_style)
  end
  if GetUIStyleGamepad(nil, self) then
    self.idSkipHint:SetText(T(576896503712, "<ButtonB> Skip"))
  else
    self.idSkipHint:SetText(T(696052205292, "<style SkipHint>Escape: Skip</style>"))
  end
  local sound_type = self.sound_type
  self.idVideoPlayer.FileName = self.movie_path
  self.idVideoPlayer.Sound = self.movie_path
  self.idVideoPlayer.SoundType = sound_type
  self.idVideoPlayer.Desaturate = const.MovieCorrectionDesaturation
  self.idVideoPlayer.Gamma = const.MovieCorrectionGamma
  function self.idVideoPlayer.OnEnd()
    self:Close()
  end
  self:PlayMovie()
end
function XFullscreenMovieDlg:StopMovie()
  DeleteThread("FadePlayback")
  self.idSubtitles:SetText("")
  self.idVideoPlayer:Stop()
  if Music and self.fadeout_music then
    Music:SetVolume(1000, 300)
  end
end
function XFullscreenMovieDlg:PlayMovie()
  if self.fadeout_music and Music then
    Music:SetVolume(0, 300)
  end
  self:CreateThread("FadePlayback", function()
    if self.fade_in then
      Sleep(self.fade_in)
    end
    self.idVideoPlayer:Play()
    if self.subtitles then
      local time_start = now()
      for i = 1, #self.subtitles do
        local sub = self.subtitles[i]
        local wait = time_start + sub.start_time - now()
        Sleep(wait)
        self.idSubtitles:SetText(sub.text)
        Sleep(sub.duration)
        self.idSubtitles:SetText("")
      end
    end
  end)
end
function XFullscreenMovieDlg:OnShortcut(shortcut, source, ...)
  if RealTime() - self.open_time < 250 then
    return "break"
  end
  if 250 > RealTime() - terminal.activate_time then
    return "break"
  end
  if self.skippable then
    if not self.idSkipHint:GetVisible() then
      self.idSkipHint:SetVisible(true)
    elseif shortcut == "Escape" or shortcut == "ButtonB" then
      self:Close()
    end
    return "break"
  end
end
function XFullscreenMovieDlg:Close()
  self:StopMovie()
  g_FullscreenMovieDlg = false
  XDialog.Close(self)
end
MapVar("g_FullscreenMovieDlg", false)
function OpenSubtitledMovieDlg(content)
  content = content or {
    movie_path = "Movies/Haemimont",
    skippable = true,
    fade_in = 250,
    subtitles = MovieSubtitles.English,
    fadeout_music = false
  }
  if not g_FullscreenMovieDlg then
    g_FullscreenMovieDlg = OpenDialog("XFullscreenMovieDlg", terminal.desktop, content)
  end
  return g_FullscreenMovieDlg
end
