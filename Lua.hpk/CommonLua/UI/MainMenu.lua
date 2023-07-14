function OpenPreGameMainMenu(mode, context)
  LoadingScreenOpen("idLoadingScreen", "pregame menu")
  ResetGameSession()
  local dlg = OpenDialog("PreGameMenu")
  if dlg and mode then
    dlg:SetMode(mode, context)
  end
  LoadingScreenClose("idLoadingScreen", "pregame menu")
  if ChangingMap then
    WaitMsg("ChangeMapDone")
  end
  TryConnectToServer()
  Msg("PreGameMenuOpen")
end
function GetPreGameMainMenu()
  return GetDialog("PreGameMenu")
end
function ResetGameSession()
  Msg("ResetGameSession")
  CloseAllDialogs()
  if GetMap() ~= "" then
    ChangeMap("")
  end
  DoneGame()
end
function OpenIngameMainMenu()
  if IsSetpiecePlaying() then
    return
  end
  if not GameState.pregame_menu then
    local menu = GetInGameMainMenu()
    if menu then
      CloseIngameMainMenu()
    else
      Msg("InGameMenuOpen")
      return OpenDialog("InGameMenu")
    end
  end
end
function GetInGameMainMenu()
  return GetDialog("InGameMenu")
end
function CloseIngameMainMenu()
  CloseDialog("InGameMenu")
end
function CloseMenuDialogs()
  local menu = GetPreGameMainMenu() or GetInGameMainMenu()
  if menu and menu.window_state ~= "destroying" then
    CloseDialog(menu)
  end
end
