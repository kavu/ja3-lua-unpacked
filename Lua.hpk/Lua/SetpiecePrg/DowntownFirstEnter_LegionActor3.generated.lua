rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.DowntownFirstEnter_LegionActor3(seed, state, MainActor, TargetActor)
  local li = {
    id = "DowntownFirstEnter_LegionActor3"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, LegionActor3Start
  prgdbg(li, 1, 1)
  _, LegionActor3Start = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, MainActor, "LegionActor3Start_01", true)
  prgdbg(li, 1, 2)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", MainActor, "Crouch", "Current Weapon", true)
  prgdbg(li, 1, 3)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1200)
  local _, LegionActor3MoveTo
  prgdbg(li, 1, 4)
  _, LegionActor3MoveTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", MainActor, "LegionActor3MoveTo_01", true, true, false, "Crouch", true, false, "")
  prgdbg(li, 1, 5)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "PantagruelFirstEnter_SynPoint")
  prgdbg(li, 1, 6)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1200)
  local _, WallShoot
  prgdbg(li, 1, 7)
  _, WallShoot = sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Point", TargetActor, "Arms", "AttackPointLegion3", 2, 600, 0, 100, 800, 0)
  prgdbg(li, 1, 8)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 800)
  local _
  prgdbg(li, 1, 9)
  _, WallShoot = sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Point", TargetActor, "Arms", "AttackPointLegion3", 1, 1500, 0, 100, 1000, 0)
end
