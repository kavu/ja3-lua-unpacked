if FirstLoad then
  LoadingScreenTipsRate = 10000
  LoadingScreenLog = {}
end
LoadingScreenOrgSize = point(1920, 1080)
local lsprintf = CreatePrint({format = "printf", timestamp = true})
function LoadingScreenGetClassById(id)
  if id == "idSaveProfile" then
    return "BaseSavingScreen"
  elseif id == "idAutosaveScreen" then
    return "AutosaveScreen"
  elseif id == "idQuickSaveScreen" then
    return "QuickSaveScreen"
  end
  return "XLoadingScreen"
end
function GetLoadingScreenDialog()
  return GetDialog(LoadingScreenLog[#LoadingScreenLog])
end
local LoadingScreenCreate = function(class, id, reason, info_text, metadata)
  lsprintf("Creating: class = %s, id = %s, reason = %s", class, tostring(id), tostring(reason))
  table.insert(LoadingScreenLog, class)
  local dlg = OpenDialog(class, nil, {
    id = id,
    reason = reason,
    info_text = info_text,
    metadata = metadata
  }, reason)
  if dlg.game_blocking then
    Pause(dlg)
    LockCamera(dlg)
    ChangeGameState("loading", true)
    if info_text and rawget(dlg, "idInfoText") then
      dlg.idInfoText:SetText(info_text)
    end
    local atTips = dlg.show_tips and not rawget(dlg, "idTips") and rawget(dlg, "idContainer") and rawget(dlg.idContainer, "idTips")
    if atTips and tips.InitTips() then
      do
        local last_tip_id = 0
        local selected_tips = {}
        for i = 1, 5 do
          local tip, id
          repeat
            tip, id = tips.GetNextTip()
          until id ~= last_tip_id
          last_tip_id = id
          selected_tips[#selected_tips + 1] = _InternalTranslate(tip)
        end
        dlg:CreateThread(function()
          local idx = 1
          while true do
            atTips:SetText(Untranslated(selected_tips[idx]))
            idx = idx + 1 > #selected_tips and 1 or idx + 1
            Sleep(LoadingScreenTipsRate)
          end
        end)
      end
    end
  end
  dlg.clock_opened = GetClock()
  return dlg
end
function LoadingScreenExecute(id, reason, func)
  LoadingScreenOpen(id, reason)
  local result = func()
  LoadingScreenClose(id, reason)
  return result
end
function LoadingScreenOpen(id, reason, first_tip, metadata)
  lsprintf("Opening %s, reason = %s", tostring(id), tostring(reason))
  local class = LoadingScreenGetClassById(id)
  if not class then
    return
  end
  local dlg = GetDialog(class)
  if dlg and dlg.window_state == "closing" then
    local modifier = dlg:FindModifier("fade")
    if modifier then
      function modifier.on_complete()
      end
    end
    dlg:delete()
    dlg = nil
  end
  dlg = dlg or LoadingScreenCreate(class, id, reason, first_tip, metadata)
  dlg:AddOpenReason(reason)
  lsprintf("Opened %s, reason = %s", tostring(id), tostring(reason))
  if dlg.game_blocking then
    WaitNextFrame(5)
  end
end
function LoadingScreenClose(id, reason)
  lsprintf("Closing %s, reason = %s", tostring(id), tostring(reason))
  local class = LoadingScreenGetClassById(id)
  local dlg = class and GetDialog(class)
  if not dlg then
    lsprintf("Closing %s cancelled, no dialog", tostring(id))
    return
  end
  if not dlg:GetOpenReasons()[reason] then
    print("Trying to close a Loading/Saving screen with id/reason that aren't used for opening: " .. tostring(reason))
    print("Active reasons:", table.concat(table.keys2(dlg:GetOpenReasons()), " "))
    lsprintf("Closing %s cancelled, no reason", tostring(id))
    return
  end
  if dlg:RemoveOpenReason(reason) then
    lsprintf("Closing %s, no reasons left", tostring(id))
    dlg:AddOpenReason(reason)
    local parent_thread = CurrentThread()
    local game_blocking = dlg.game_blocking
    CreateRealTimeThread(function()
      while dlg.clock_opened == 0 do
        Sleep(17)
      end
      local clock_closed = dlg.clock_opened
      if dlg.saving then
        clock_closed = clock_closed + 3141
      elseif game_blocking then
        clock_closed = clock_closed + (dlg.close_delay or 1200)
      end
      lsprintf("Closing %s, waiting clock", tostring(id))
      while 0 > GetClock() - clock_closed do
        Sleep(30)
      end
      lsprintf("Closing %s, checking for reopen", tostring(id))
      if dlg:RemoveOpenReason(reason) then
        lsprintf("Closing %s, final closing", tostring(id))
        if game_blocking then
          local dlgs = ListDialogs()
          local unblock = true
          for i = 1, #dlgs do
            local d = GetDialog(dlgs[i])
            if d ~= dlg and d:IsKindOf("BaseLoadingScreen") and d.game_blocking then
              unblock = false
              break
            end
          end
          if unblock and GetMap() ~= "" and not dlg.saving then
            WaitNextFrame(3)
            SetupViews()
          end
          ChangeGameState("loading", not unblock)
          UnlockCamera(dlg)
          Resume(dlg)
        end
        if not next(dlg:GetOpenReasons()) then
          Msg("LoadingScreenPreClose")
          WaitNextFrame()
          if not next(dlg:GetOpenReasons()) then
            if dlg.window_state ~= "destroying" then
              dlg:Close("final")
              table.remove_entry(LoadingScreenLog, class)
            end
            lsprintf("Closed %s, reason = %s", tostring(id), tostring(reason))
          end
        end
        if next(dlg:GetOpenReasons()) then
          lsprintf("Cancelled closing, we have a new reason to live", next(dlg:GetOpenReasons()))
        end
      end
      if game_blocking then
        Wakeup(parent_thread)
      end
    end)
    if game_blocking then
      WaitWakeup()
    end
  end
end
DefineClass.BaseLoadingScreen = {
  __parents = {"XDialog"},
  properties = {
    {
      category = "LoadingScreen",
      id = "game_blocking",
      editor = "bool",
      default = true
    }
  },
  clock_opened = 0,
  close_delay = false,
  saving = false,
  show_tips = true,
  ZOrder = 1000000000,
  MouseCursor = "CommonAssets/UI/waitcursor.tga",
  HandleMouse = true,
  image = "UI/SplashScreen.tga",
  transparent = false,
  FocusOnOpen = ""
}
function BaseLoadingScreen:Open(...)
  XDialog.Open(self, ...)
  ShowMouseCursor("Loading screen")
  if self.game_blocking then
    self:SetModal()
    self:SetFocus()
  end
  if self.transparent then
    self:SetMouseCursor(false)
    self.HandleMouse = false
    self.ChildrenHandleMouse = false
  end
  if rawget(self, "idImage") then
    self.idImage:SetImage(self.image)
  end
end
function BaseLoadingScreen:OnShortcut(shortcut, source, ...)
  if (Platform.publisher or Platform.developer) and shortcut == "Ctrl-F1" then
    return "continue"
  end
  if self.game_blocking and not AreMessageBoxesOpen() then
    return "break"
  end
end
function BaseLoadingScreen:Close(result)
  if result == "final" then
    HideMouseCursor("Loading screen")
    XWindow.Close(self)
  end
end
DefineClass.BaseSavingScreen = {
  __parents = {
    "BaseLoadingScreen"
  },
  saving = true,
  game_blocking = false,
  image = false,
  transparent = true
}
function GetOpenLoadingScreen(id)
  local class = LoadingScreenGetClassById(id)
  return class and GetDialog(class) and true or false
end
function DrawSplashScreen()
  local screen = UIL.GetScreenSize()
  local size = ScaleToFit(LoadingScreenOrgSize, screen, false)
  local pos = (screen - size) / 2
  local rc = box(pos, pos + size)
  UIL.DrawSolidRect(box(point20, screen), RGB(0, 0, 0))
  UIL.DrawImage("UI/SplashScreen.tga", rc)
end
DefineClass.XLoadingScreenClass = {
  __parents = {
    "BaseLoadingScreen"
  },
  FadeOutTime = 300,
  Background = RGB(0, 0, 0)
}
g_LoadingScreens = {
  "UI/SplashScreen.tga"
}
if FirstLoad then
  g_FirstLoadingScreen = true
end
function XLoadingScreenClass:Open(...)
  self.image = g_FirstLoadingScreen and "UI/SplashScreen.tga" or table.rand(g_LoadingScreens)
  g_FirstLoadingScreen = false
  BaseLoadingScreen.Open(self, ...)
end
function GetGameBlockingLoadingScreen()
  for _, d in pairs(Dialogs) do
    if d and IsKindOf(d, "BaseLoadingScreen") and d.game_blocking then
      return d
    end
  end
end
function WaitLoadingScreenClose()
  while GetGameBlockingLoadingScreen() do
    WaitNextFrame()
  end
end
