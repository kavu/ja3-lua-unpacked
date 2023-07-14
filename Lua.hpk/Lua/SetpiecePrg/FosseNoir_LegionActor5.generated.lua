rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.FosseNoir_LegionActor5(seed, state, MainActor, TargetActor)
  local li = {
    id = "FosseNoir_LegionActor5"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, SP_LegionActor1_GoTo_Prim
  prgdbg(li, 1, 1)
  _, SP_LegionActor1_GoTo_Prim = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", MainActor, "SP_LegionActor5_goto", true, false, false, "Crouch", true, true, "")
  prgdbg(li, 1, 2)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", MainActor, "", true, "hg_Crouch_To_Standing", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 3)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", MainActor, "", true, "hg_Standing_CombatBegin", 1000, 0, range(1, 1), 0, false, true, false, "")
end
