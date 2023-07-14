rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.SubPierreTalk(seed, state, MainActor)
  local li = {
    id = "SubPierreTalk"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, MainActor, "PierreTalk", true)
  prgdbg(li, 1, 2)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", MainActor, "PierreTalk", true, "civ_Standing_Idle2", 1000, 0, range(2, 2), 0, false, true, false, "")
  prgdbg(li, 1, 3)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", MainActor, "PierreTalk", true, "civ_Standing_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
end
