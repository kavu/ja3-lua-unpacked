rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.BeasIntro_BridgeRun(seed, state, TriggerUnits)
  local li = {
    id = "BeasIntro_BridgeRun"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, SP_BeastPort
  prgdbg(li, 1, 1)
  _, SP_BeastPort = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, TriggerUnits, "SP_BeastPort", true)
  prgdbg(li, 1, 2)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", TriggerUnits, "Crouch", "Current Weapon", true)
  prgdbg(li, 1, 3)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 6800)
  local _, SP_BeastGoTo
  prgdbg(li, 1, 4)
  _, SP_BeastGoTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", TriggerUnits, "SP_BeastGoTo", true, true, false, "Crouch", false, false, "")
end
