rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.ShootingTest(seed, state, TriggerUnits)
  local li = {
    id = "ShootingTest"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  prgdbg(li, 1, 2)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", "", "", "linear", 1, false, false, point(142586, 166035, 18043), point(142354, 169519, 21622), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  local _, ShooterTester
  prgdbg(li, 1, 3)
  _, ShooterTester = sprocall(SetpieceSpawn.Exec, SetpieceSpawn, state, rand, ShooterTester, "ShooterTester")
  local _, SniperSpot
  prgdbg(li, 1, 4)
  _, SniperSpot = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, ShooterTester, "ShooterTesterSpawn", true)
  prgdbg(li, 1, 5)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", ShooterTester, "Standing", "AK47", true)
  local _, TargetUnitTester
  prgdbg(li, 1, 6)
  _, TargetUnitTester = sprocall(SetpieceSpawn.Exec, SetpieceSpawn, state, rand, TargetUnitTester, "TargetUnitTester")
  local _
  prgdbg(li, 1, 7)
  _, SniperSpot = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, TargetUnitTester, "TargetUnitSpawn", true)
  prgdbg(li, 1, 8)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 0, 700)
  prgdbg(li, 1, 9)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 2000)
  prgdbg(li, 1, 10)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", ShooterTester, "Unit", TargetUnitTester, "Torso", "", 5, 0, 0, 100, 0, 0)
  prgdbg(li, 1, 11)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1500)
  local _, TargetPointTester
  prgdbg(li, 1, 12)
  _, TargetPointTester = sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", ShooterTester, "Point", TargetUnitTester, "Torso", "TargetPointTester", 3, 200, 100, 100, 0, 0)
  prgdbg(li, 1, 13)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1000)
  prgdbg(li, 1, 14)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
end
