MapVar("Players", false)
MapVar("UIPlayer", false)
function OnMsg.NewMap()
  if not mapdata.GameLogic then
    return
  end
  Players = CreatePlayerObjects()
  UIPlayer = Players[1]
  Msg("PlayerObjectCreated", UIPlayer)
end
function CreatePlayerObjects()
  return {
    CooldownObj:new()
  }
end
