rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.FosseNoir_RebelActor2(seed, state, MainActor, TargetActor1, TargetActor2)
  local li = {
    id = "FosseNoir_RebelActor2"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Unit", TargetActor2, "Head", "", 1, 0, 3450, 100, 0, 0)
  prgdbg(li, 1, 2)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", MainActor, "", true, "ar_Standing_Idle", 1000, 1000, range(1, 1), 0, false, true, false, "")
  local _, SP_RebelActor2_Shot
  prgdbg(li, 1, 3)
  _, SP_RebelActor2_Shot = sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Point", TargetActor1, "Legs", "SP_RebelActor2_Shot", 1, 1000, 2000, 100, 0, 0)
end
