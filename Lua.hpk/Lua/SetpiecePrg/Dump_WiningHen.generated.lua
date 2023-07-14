rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.Dump_WiningHen(seed, state, TriggerUnits)
  local li = {
    id = "Dump_WiningHen"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", TriggerUnits, "", true, "fly", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 2)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", TriggerUnits, "", true, "fly", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 3)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", TriggerUnits, "", true, "fly", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 4)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", TriggerUnits, "", true, "fly", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 5)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", TriggerUnits, "", true, "idle2", 1000, 0, range(1, 1), 0, false, true, false, "")
end
