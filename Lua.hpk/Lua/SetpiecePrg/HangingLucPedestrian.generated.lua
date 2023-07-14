rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.HangingLucPedestrian(seed, state, TriggerUnits)
  local li = {
    id = "HangingLucPedestrian"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, Pedestrian01
  prgdbg(li, 1, 1)
  _, Pedestrian01 = sprocall(SetpieceSpawn.Exec, SetpieceSpawn, state, rand, Pedestrian01, "SpawnPedestrian_01")
  prgdbg(li, 1, 2)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", Pedestrian01, "Pedestrian01LookRight", true, "civ_Standing_WalkSlow", 1000, 3500, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 3)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", Pedestrian01, "Pedestrian01WalkTo", true, "civ_WalkSlow_Neutral_LookRight", 1000, 3500, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 4)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "HangingFloatCamera")
  prgdbg(li, 1, 5)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, Pedestrian01)
end
