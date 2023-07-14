rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.Dump_LosingHen(seed, state, TriggerUnits)
  local li = {
    id = "Dump_LosingHen"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 400)
  local _, SP_RedHenForward
  prgdbg(li, 1, 2)
  _, SP_RedHenForward = sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", TriggerUnits, "", true, "fly", 1000, 0, range(1, 1), 0, false, true, false, "")
  local _, SP_RedHenBack
  prgdbg(li, 1, 3)
  _, SP_RedHenBack = sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", TriggerUnits, "", true, "fly", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 4)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", TriggerUnits, "", true, "fly", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 5)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", TriggerUnits, "", true, "fly", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 6)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", TriggerUnits, "", true, "idle_EggHatching", 1000, 0, range(1, 1), 0, false, true, false, "")
end
