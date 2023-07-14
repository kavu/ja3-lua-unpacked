rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.SubMoveTest(seed, state, Actor)
  local li = {
    id = "SubMoveTest"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", Actor, "TreeDest", true, true, false, "", false, false, "")
  prgdbg(li, 1, 2)
  sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", Actor, "TreeDest2", true, true, false, "", false, false, "")
  prgdbg(li, 1, 3)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", Actor, "Standing", "Current Weapon", true)
end
