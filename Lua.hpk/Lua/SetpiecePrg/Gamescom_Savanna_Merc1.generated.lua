rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.Gamescom_Savanna_Merc1(seed, state, MainActor)
  local li = {
    id = "Gamescom_Savanna_Merc1"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", MainActor, "Standing", "AK47", true)
  local _, SP_Actor1_GoTo
  prgdbg(li, 1, 2)
  _, SP_Actor1_GoTo = sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", MainActor, "SP_Actor1_GoTo", false, "ar_Standing_Walk2", 850, 8250, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 3)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", MainActor, "", true, "ar_Standing_IdlePassive2", 1000, 0, range(1, 1), 0, false, true, false, "")
end
