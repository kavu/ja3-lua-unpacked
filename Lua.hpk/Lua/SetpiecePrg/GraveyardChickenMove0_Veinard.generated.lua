rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.GraveyardChickenMove0_Veinard(seed, state, TriggerUnits)
  local li = {
    id = "GraveyardChickenMove0_Veinard"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, LuckyVeinard
  prgdbg(li, 1, 1)
  _, LuckyVeinard = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LuckyVeinard, "", "Veinard", "Object", false)
  prgdbg(li, 1, 2)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 3000)
  local _, veinard0
  prgdbg(li, 1, 3)
  _, veinard0 = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", LuckyVeinard, "veinard0", true, false, false, "", false, true, "")
end
