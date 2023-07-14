rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.DowntownFirstEnter_LegionSideActor2(seed, state, MainActor, TargetActor)
  local li = {
    id = "DowntownFirstEnter_LegionSideActor2"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, LegionActor3Start
  prgdbg(li, 1, 1)
  _, LegionActor3Start = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, MainActor, "LegionSideActor2Start", true)
  prgdbg(li, 1, 2)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", MainActor, "Standing", "Current Weapon", true)
  prgdbg(li, 1, 3)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1200)
  local _, LegionSideActor1_GoTo
  prgdbg(li, 1, 4)
  _, LegionSideActor1_GoTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", MainActor, "LegionSideActor2_GoTo", true, true, false, "Standing", true, false, "")
  prgdbg(li, 1, 5)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 900)
  prgdbg(li, 1, 6)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "PantagruelFirstEnter_SynPoint")
  local _, AttackPointLegion1
  prgdbg(li, 1, 7)
  _, AttackPointLegion1 = sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Point", TargetActor, "Arms", "AttackPointLegionSide2", 2, 400, 600, 100, 700, 0)
  prgdbg(li, 1, 8)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 4000)
  local _, LegionSideActor2_GoTo2
  prgdbg(li, 1, 9)
  _, LegionSideActor2_GoTo2 = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", MainActor, "LegionSideActor2_GoTo2", true, true, false, "Standing", true, false, "")
end
