rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.MangelCombat_Infected3(seed, state, MainActor)
  local li = {
    id = "MangelCombat_Infected3"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MainActor, "", true, "inf_Standing_IdlePassive3", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 2)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 4650)
  prgdbg(li, 1, 3)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", MainActor, "SP_FallenInfected3_GoTo", true, "mk_Standing_TurnLeft", 1000, 1200, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 4)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", MainActor, "", true, "inf_Standing_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
end
