rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.MangelCombat_Infected2(seed, state, MainActor)
  local li = {
    id = "MangelCombat_Infected2"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1100)
  prgdbg(li, 1, 2)
  sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", MainActor, "SP_FallenInfected2_GoTo", true, false, false, "", false, false, "")
  prgdbg(li, 1, 3)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", MainActor, "", true, "inf_Standing_IdlePassive2", 1300, 0, range(1, 1), 0, false, true, false, "")
end
