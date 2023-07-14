rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.FosseNoir_LegionActor3(seed, state, MainActor, TargetActor)
  local li = {
    id = "FosseNoir_LegionActor3"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 900)
  prgdbg(li, 1, 2)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Unit", TargetActor, "Torso", "", 3, 400, 800, 130, 0, 1)
  local _, SP_LegionActor3_goto2
  prgdbg(li, 1, 3)
  _, SP_LegionActor3_goto2 = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", MainActor, "SP_LegionActor3_goto2", true, true, false, "Standing", false, false, "")
end
