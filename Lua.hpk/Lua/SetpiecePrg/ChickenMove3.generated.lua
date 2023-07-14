rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.ChickenMove3(seed, state, TriggerUnits)
  local li = {
    id = "ChickenMove3"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, Schliemann
  prgdbg(li, 1, 1)
  _, Schliemann = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Schliemann, "", "chicken", "Object", false)
  local _, LuckyVeinard
  prgdbg(li, 1, 2)
  _, LuckyVeinard = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LuckyVeinard, "", "Veinard", "Object", false)
  prgdbg(li, 1, 3)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "ChickenMove3_Schliemann", nil)
  prgdbg(li, 1, 4)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "ChickenMove3_Veinard", nil)
end
