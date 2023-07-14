DefineClass.SplashScreen = {
  __parents = {"XDialog"},
  Background = RGB(0, 0, 0),
  HandleMouse = true,
  MouseCursor = const.DefaultMouseCursor
}
function SplashScreen:Init()
  XAspectWindow:new({
    Id = "idContent",
    Fit = "FitInSafeArea"
  }, self)
end
function SplashScreen:OnShortcut(shortcut, source, ...)
  if shortcut == "ButtonB" or shortcut == "Escape" or shortcut == "MouseL" then
    self:Close()
    return "break"
  end
  XDialog.OnShortcut(self, shortcut, source, ...)
end
DefineClass.XSplashImage = {
  __parents = {
    "SplashScreen"
  },
  Id = "idXSplashScreenImage"
}
function XSplashImage:Init()
  XImage:new({
    Id = "idImage",
    Image = self.image,
    HAlign = "center",
    VAlign = "center",
    ImageFit = "smallest",
    FadeInTime = self.fadeInTime,
    FadeOutTime = self.fadeOutTime
  }, self.idContent)
  self:CreateThread("wait", function()
    Sleep(self.fadeInTime)
    Sleep(self.time)
    self.idImage:Close()
    Sleep(self.fadeOutTime)
    self:Close()
  end)
end
DefineClass.XSplashMovie = {
  __parents = {
    "SplashScreen"
  },
  Id = "idXSplashScreenMovie"
}
function XSplashMovie:Init()
  local video = XVideo:new({
    Id = "idMovie",
    ZOrder = -1,
    FileName = self.movie,
    Sound = self.movie
  }, self.idContent)
  video:SetAutoPlay(true)
  function video.OnEnd()
    self:Close()
  end
end
function SplashImage(image, fadeInTime, fadeOutTime, time, aspect)
  local dlg = XSplashImage:new({
    image = image,
    fadeInTime = fadeInTime,
    fadeOutTime = fadeOutTime,
    time = time,
    aspect = aspect
  }, terminal.desktop)
  dlg:Open()
  return dlg
end
function SplashMovie(movie, aspect)
  local dlg = XSplashMovie:new({movie = movie, aspect = aspect}, terminal.desktop)
  dlg:Open()
  return dlg
end
DefineClass.XSplashText = {
  __parents = {
    "SplashScreen"
  },
  Id = "idXSplashScreenText"
}
function XSplashText:Init()
  XText:new({
    Id = "idText",
    Text = self.text,
    TextStyle = self.style,
    Translate = true,
    TextHAlign = "center",
    HAlign = "center",
    VAlign = "center",
    Margins = box(300, 0, 300, 0),
    FadeInTime = self.fadeInTime,
    FadeOutTime = self.fadeOutTime
  }, self.idContent)
  self:CreateThread("wait", function()
    Sleep(self.fadeInTime)
    Sleep(self.time)
    self.idText:Close()
    Sleep(self.fadeOutTime)
    self:Close()
  end)
end
function SplashText(text, style, fadeInTime, fadeOutTime, time)
  local dlg = XSplashText:new({
    style = style,
    fadeInTime = fadeInTime,
    fadeOutTime = fadeOutTime,
    time = time
  }, terminal.desktop)
  dlg:Open()
  dlg.idText:SetText(text)
  return dlg
end
