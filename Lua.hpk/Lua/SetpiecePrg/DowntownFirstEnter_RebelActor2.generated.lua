rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.DowntownFirstEnter_RebelActor2(seed, state, MainActor, TargetActor)
  local li = {
    id = "DowntownFirstEnter_RebelActor2"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", MainActor, "Standing", "Current Weapon", true)
  prgdbg(li, 1, 2)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1200)
  local _, RebelActor2_GoTo
  prgdbg(li, 1, 3)
  _, RebelActor2_GoTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "PantagruelFirstEnter_SynPoint", MainActor, "RebelActor2_GoTo", true, true, false, "", false, false, "")
  prgdbg(li, 1, 4)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "PantagruelFirstEnter_SynPoint")
  prgdbg(li, 1, 5)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", MainActor, "Crouch", "Current Weapon", true)
  prgdbg(li, 1, 6)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1200)
  prgdbg(li, 1, 7)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Unit", TargetActor, "Torso", "", 1, 0, 200, 100, 0, 0)
end
