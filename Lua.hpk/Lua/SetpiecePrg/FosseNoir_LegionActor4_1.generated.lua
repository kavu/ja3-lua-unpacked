rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.FosseNoir_LegionActor4_1(seed, state, MainActor)
  local li = {
    id = "FosseNoir_LegionActor4_1"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, SP_LegionActor4_GoTo1
  prgdbg(li, 1, 1)
  _, SP_LegionActor4_GoTo1 = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", MainActor, "SP_LegionActor4_GoTo1", true, false, false, "Crouch", true, true, "")
  prgdbg(li, 1, 2)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", MainActor, "", true, "hg_Crouch_Aim", 1000, 900, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 3)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", MainActor, "", true, "hg_Crouch_Dodge", 1800, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 4)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", MainActor, "", true, "hg_Crouch_Aim", 1000, 0, range(1, 1), 0, false, true, false, "")
end
