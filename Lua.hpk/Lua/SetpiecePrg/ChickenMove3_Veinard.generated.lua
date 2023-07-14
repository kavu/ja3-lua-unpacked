rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.ChickenMove3_Veinard(seed, state, TriggerUnits)
  local li = {
    id = "ChickenMove3_Veinard"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, LuckyVeinard
  prgdbg(li, 1, 1)
  _, LuckyVeinard = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LuckyVeinard, "", "Veinard", "Object", false)
  prgdbg(li, 1, 2)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1500)
  prgdbg(li, 1, 3)
  sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", LuckyVeinard, "Waypoint3_03", true, true, false, "", false, true, "")
  prgdbg(li, 1, 4)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("QuestSetVariableBool", {
      Prop = "foundcorn",
      QuestId = "TreasureHunting"
    }),
    PlaceObj("QuestSetVariableNum", {
      Amount = 1,
      Prop = "treasures",
      QuestId = "TreasureHunting"
    })
  })
end
