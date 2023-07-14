rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.BeasIntro_BeastAiming(seed, state, TriggerUnits)
  local li = {
    id = "BeasIntro_BeastAiming"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, TriggerUnits, "SP_BeastPort_01", true)
  prgdbg(li, 1, 2)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", TriggerUnits, "Crouch", "Current Weapon", true)
  local _, SP_BeastGoTo
  prgdbg(li, 1, 3)
  _, SP_BeastGoTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", TriggerUnits, "SP_BeastGoTo_01", true, true, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 4)
  _, SP_BeastGoTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", TriggerUnits, "SP_BeastAim", true, false, false, "Crouch", true, false, "")
  prgdbg(li, 1, 5)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5)
  prgdbg(li, 1, 6)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", TriggerUnits, "", true, "ar_Crouch_Aim", 1000, 10000, range(1, 1), 0, false, true, false, "")
end
