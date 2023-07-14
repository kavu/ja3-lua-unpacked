rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.PortCacaoFirstEnter_Rocket(seed, state, TriggerUnits, SecondActor)
  local li = {
    id = "PortCacaoFirstEnter_Rocket"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 2)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "PortCacaoCity_FirstBanterDone")
  prgdbg(li, 1, 3)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 3250)
  prgdbg(li, 1, 4)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "PortCacaoCity_RocketBoom", {
    PlaceObj("Explosion", {
      Damage = 200,
      ExplosionType = "FragGrenade",
      LocationGroup = "SP_RocketExplosion",
      Noise = 0
    })
  })
  prgdbg(li, 1, 5)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 10)
  prgdbg(li, 1, 6)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", SecondActor, "", true, "civ_Standing_RoamStop_BirdPoo_L", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 7)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "PortCacaoCity_RocketBoom")
end
