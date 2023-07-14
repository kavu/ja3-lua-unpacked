rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.GraveyardChickenMove2_Veinard(seed, state, TriggerUnits)
  local li = {
    id = "GraveyardChickenMove2_Veinard"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, LuckyVeinard
  prgdbg(li, 1, 1)
  _, LuckyVeinard = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LuckyVeinard, "", "Veinard", "Object", false)
  prgdbg(li, 1, 2)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 2000)
  prgdbg(li, 1, 3)
  sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", LuckyVeinard, "Waypoint2_03", true, true, false, "", false, true, "")
end
