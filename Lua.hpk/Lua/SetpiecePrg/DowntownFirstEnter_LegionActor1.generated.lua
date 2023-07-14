rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.DowntownFirstEnter_LegionActor1(seed, state, MainActor, TargetActor)
  local li = {
    id = "DowntownFirstEnter_LegionActor1"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, LegionActor3Start
  prgdbg(li, 1, 1)
  _, LegionActor3Start = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, MainActor, "LegionActor1Start", true)
  prgdbg(li, 1, 2)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", MainActor, "Standing", "Current Weapon", true)
  prgdbg(li, 1, 3)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", MainActor, "", true, "ar_Standing_CombatBegin3", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 4)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 800)
  prgdbg(li, 1, 5)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "PantagruelFirstEnter_SynPoint")
  local _, AttackPointLegion1
  prgdbg(li, 1, 6)
  _, AttackPointLegion1 = sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Point", TargetActor, "Arms", "AttackPointLegion1", 1, 0, 300, 100, 800, 0)
  prgdbg(li, 1, 7)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 200)
  prgdbg(li, 1, 8)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Unit", TargetActor, "Arms", "", 2, 0, 400, 400, 0, 0)
  prgdbg(li, 1, 9)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 300)
  prgdbg(li, 1, 10)
  sprocall(SetpieceDeath.Exec, SetpieceDeath, state, rand, true, "", MainActor, false)
end
