rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.FosseNoir_RebelActor1(seed, state, MainActor, TargetActor1, TargetActor2)
  local li = {
    id = "FosseNoir_RebelActor1"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Unit", TargetActor1, "Torso", "", 3, 70, 1000, 280, 0, 2)
  prgdbg(li, 1, 2)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Unit", TargetActor1, "Torso", "", 5, 70, 1400, 280, 0, 4)
  prgdbg(li, 1, 3)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Unit", TargetActor1, "Torso", "", 2, 350, 1200, 280, 0, 0)
end
