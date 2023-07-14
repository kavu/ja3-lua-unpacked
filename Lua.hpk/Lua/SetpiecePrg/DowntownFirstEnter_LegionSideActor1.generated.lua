rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.DowntownFirstEnter_LegionSideActor1(seed, state, MainActor, TargetActor)
  local li = {
    id = "DowntownFirstEnter_LegionSideActor1"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, LegionActor3Start
  prgdbg(li, 1, 1)
  _, LegionActor3Start = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, MainActor, "LegionActor3Start_02", true)
  prgdbg(li, 1, 2)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", MainActor, "Standing", "Current Weapon", true)
  prgdbg(li, 1, 3)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 750)
  local _, LegionSideActor1_GoTo
  prgdbg(li, 1, 4)
  _, LegionSideActor1_GoTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", MainActor, "LegionSideActor1_GoTo", true, true, false, "Crouch", false, false, "")
  prgdbg(li, 1, 5)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "PantagruelFirstEnter_SynPoint")
  local _, AttackPointLegion1
  prgdbg(li, 1, 6)
  _, AttackPointLegion1 = sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Point", TargetActor, "Arms", "AttackPointSideLegion1", 3, 500, 400, 330, 500, 0)
  prgdbg(li, 1, 7)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1500)
  local _
  prgdbg(li, 1, 8)
  _, AttackPointLegion1 = sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Point", TargetActor, "Arms", "AttackPointSideLegion1", 1, 200, 400, 100, 1000, 0)
end
