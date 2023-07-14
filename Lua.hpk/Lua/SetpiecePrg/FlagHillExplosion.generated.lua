rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.FlagHillExplosion(seed, state, TriggerUnits)
  local li = {
    id = "FlagHillExplosion"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  prgdbg(li, 1, 2)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 700)
  prgdbg(li, 1, 3)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", 2, "decelerated", "linear", 14000, false, false, point(132315, 148439, 24314), point(136185, 150352, 26835), point(135798, 150161, 26583), point(139669, 152074, 29104), 4200, 1300, {floor = 0}, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 4)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 2000)
  prgdbg(li, 1, 5)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "", {
    PlaceObj("Explosion", {
      AreaOfEffect = 2,
      Damage = 90,
      ExplosionType = "ProximityC4",
      LocationGroup = "SP_Explosion1"
    })
  })
  prgdbg(li, 1, 6)
  sprocall(SetpieceCameraShake.Exec, SetpieceCameraShake, state, rand, false, "", 0, 460, 250, 120, 180)
  local _, SP_Particle1
  prgdbg(li, 1, 7)
  _, SP_Particle1 = sprocall(SetpieceSpawnParticles.Exec, SetpieceSpawnParticles, state, rand, SP_Particle1, "SP_Particle1")
  prgdbg(li, 1, 8)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 3000)
  prgdbg(li, 1, 9)
  sprocall(SetpieceCameraShake.Exec, SetpieceCameraShake, state, rand, false, "", 0, 460, 250, 120, 180)
  prgdbg(li, 1, 10)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "", {
    PlaceObj("Explosion", {
      AreaOfEffect = 2,
      Damage = 90,
      ExplosionType = "ProximityC4",
      LocationGroup = "SP_Explosion2"
    })
  })
  local _
  prgdbg(li, 1, 11)
  _, SP_Particle1 = sprocall(SetpieceSpawnParticles.Exec, SetpieceSpawnParticles, state, rand, SP_Particle1, "SP_Particle3")
  prgdbg(li, 1, 12)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 2000)
  local _
  prgdbg(li, 1, 13)
  _, SP_Particle1 = sprocall(SetpieceSpawnParticles.Exec, SetpieceSpawnParticles, state, rand, SP_Particle1, "SP_Particle2")
  prgdbg(li, 1, 14)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "", {
    PlaceObj("Explosion", {
      AreaOfEffect = 2,
      Damage = 90,
      ExplosionType = "ProximityC4",
      LocationGroup = "SP_Explosion4"
    })
  })
  prgdbg(li, 1, 15)
  sprocall(SetpieceCameraShake.Exec, SetpieceCameraShake, state, rand, false, "", 0, 460, 250, 120, 180)
  prgdbg(li, 1, 16)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1000)
  prgdbg(li, 1, 17)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 18)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
