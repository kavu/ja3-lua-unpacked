rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.ChickenMove2_Schliemann(seed, state, TriggerUnits)
  local li = {
    id = "ChickenMove2_Schliemann"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, Schliemann
  prgdbg(li, 1, 1)
  _, Schliemann = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Schliemann, "", "chicken", "Object", false)
  prgdbg(li, 1, 2)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 500)
  prgdbg(li, 1, 3)
  sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Schliemann, "Waypoint2", true, true, false, "", false, true, "")
end
