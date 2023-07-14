if not Platform.xbox then
  return
end
function GetRichPresenceData()
  return false
end
if FirstLoad then
  g_RichPresenceData = false
  g_RichPresenceThread = false
end
CreateRealTimeThread(function()
  local lastPresenceData = false
  while true do
    if g_RichPresenceData and Xbox.IsUserSigned() then
      local presence_data = g_RichPresenceData
      g_RichPresenceData = false
      if presence_data.xbox_id ~= lastPresenceData then
        CreateRealTimeThread(XboxSetRichPresenceAsync, presence_data.xbox_id, presence_data.xbox_tokens)
        lastPresenceData = presence_data.xbox_id
      end
    end
    Sleep(7137)
  end
end)
UpdatePresenceInfo = empty_func
function OnMsg.DataLoaded()
  function UpdatePresenceInfo()
    g_RichPresenceData = GetRichPresenceData() or false
  end
end
function UpdatePresenceInfoDefer()
  UpdatePresenceInfo()
end
OnMsg.Start = UpdatePresenceInfoDefer
OnMsg.ChangeMapDone = UpdatePresenceInfoDefer
OnMsg.NewMapLoaded = UpdatePresenceInfoDefer
OnMsg.LoadGame = UpdatePresenceInfoDefer
OnMsg.GameStateChangedNotify = UpdatePresenceInfoDefer
