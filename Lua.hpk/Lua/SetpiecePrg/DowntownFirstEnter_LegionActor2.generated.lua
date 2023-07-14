rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.DowntownFirstEnter_LegionActor2(seed, state, MainActor, TargetActor)
  local li = {
    id = "DowntownFirstEnter_LegionActor2"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, LegionActor3Start
  prgdbg(li, 1, 1)
  _, LegionActor3Start = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, MainActor, "LegionActor2Start", true)
  prgdbg(li, 1, 2)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", MainActor, "Crouch", "Current Weapon", true)
  local _, LegionActor3MoveTo
  prgdbg(li, 1, 4)
  _, LegionActor3MoveTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", MainActor, "LegionActor2MoveTo", true, true, false, "Crouch", true, false, "")
  prgdbg(li, 1, 5)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1800)
  prgdbg(li, 1, 6)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "PantagruelFirstEnter_SynPoint")
  prgdbg(li, 1, 7)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Point", TargetActor, "Arms", "AttackPointLegion2", 1, 500, 0, 100, 1000, 0)
  prgdbg(li, 1, 8)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 300)
  prgdbg(li, 1, 9)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Point", TargetActor, "Arms", "AttackPointLegion2", 2, 300, 0, 100, 800, 0)
end
