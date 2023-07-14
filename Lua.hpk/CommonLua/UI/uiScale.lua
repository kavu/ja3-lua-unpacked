function GetUIScale(res)
  local screen_size = Platform.ged and UIL.GetOSScreenSize() or res or UIL.GetScreenSize()
  local xrez, yrez = screen_size:xy()
  local scale_x, scale_y = 1000 * xrez / 1920, 1000 * yrez / 1080
  local scale = (scale_x + scale_y) / 2
  scale = Min(scale, scale_x * 120 / 100)
  scale = Min(scale, scale_y * 120 / 100)
  if 1000 < scale then
    scale = 1000 + (scale - 1000) * 900 / 1000
  end
  local controller_scale = table.get(AccountStorage, "Options", "Gamepad") and IsXInputControllerConnected() and const.ControllerUIScale or 100
  return MulDivRound(scale, GetUserUIScale(scale) * controller_scale, 10000)
end
function GetUserUIScale(scale)
  if Platform.ged then
    return 100
  end
  local user_scale = EngineOptions.UIScale or 100
  if Platform.playstation then
    user_scale = Min(user_scale, MapRange(GetDisplayAreaMargin(), const.MinUserUIScale, const.MaxUserUIScaleHighRes, const.MaxDisplayAreaMargin, const.MinDisplayAreaMargin))
  end
  if scale then
    local low = const.MaxUserUIScaleLowRes
    local high = const.MaxUserUIScaleHighRes
    user_scale = Min(user_scale, Clamp(low + (scale - 650) * (high - low) / 350, low, high))
  end
  return user_scale
end
