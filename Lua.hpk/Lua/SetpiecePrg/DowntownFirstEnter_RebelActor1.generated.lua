rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.DowntownFirstEnter_RebelActor1(seed, state, MainActor, TargetActor)
  local li = {
    id = "DowntownFirstEnter_RebelActor1"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", MainActor, "Standing", "Current Weapon", true)
  prgdbg(li, 1, 2)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 3300)
  prgdbg(li, 1, 3)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", MainActor, "Crouch", "Current Weapon", true)
  prgdbg(li, 1, 4)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1800)
  prgdbg(li, 1, 5)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "PantagruelFirstEnter_SynPoint")
  prgdbg(li, 1, 6)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Point", TargetActor, "Torso", "AttackPointRebel1", 3, 300, 400, 200, 1000, 0)
end
