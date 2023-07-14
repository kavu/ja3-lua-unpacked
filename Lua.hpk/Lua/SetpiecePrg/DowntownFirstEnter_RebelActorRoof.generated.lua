rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.DowntownFirstEnter_RebelActorRoof(seed, state, MainActor)
  local li = {
    id = "DowntownFirstEnter_RebelActorRoof"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", MainActor, "Standing", "Current Weapon", true)
  prgdbg(li, 1, 2)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 4000)
  prgdbg(li, 1, 3)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", MainActor, "Crouch", "Current Weapon", true)
  prgdbg(li, 1, 4)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "PantagruelFirstEnter_SynPoint")
  prgdbg(li, 1, 5)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1200)
  local _, RebelActorTarget
  prgdbg(li, 1, 6)
  _, RebelActorTarget = sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Point", nil, "Torso", "RebelActorTarget", 1, 300, 100, 100, 1000, 0)
  prgdbg(li, 1, 7)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 4500)
  local _
  prgdbg(li, 1, 8)
  _, RebelActorTarget = sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Point", nil, "Torso", "RebelActorTarget", 1, 300, 100, 100, 500, 0)
end
