rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.FaucheuxRetreat(seed, state, TriggerUnits)
  local li = {
    id = "FaucheuxRetreat"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 300)
  prgdbg(li, 1, 2)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 400, 700)
  prgdbg(li, 1, 3)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", "", "", "linear", 1000, false, false, point(145616, 114695, 11191), point(142046, 118192, 11021), false, false, 4800, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 4)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 800)
  local _, Faucheux
  prgdbg(li, 1, 5)
  _, Faucheux = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Faucheux, "Faucheux", "FaucheuxEnemy", "Object", false)
  local _, SP_Faucheux_Port
  prgdbg(li, 1, 6)
  _, SP_Faucheux_Port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Faucheux, "SP_Faucheux_Port", true)
  local _, Boat
  prgdbg(li, 1, 7)
  _, Boat = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Boat, "", "BoatActor", "Object", false)
  prgdbg(li, 1, 8)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", "", "", "linear", 0, false, false, point(145616, 114695, 11191), point(142046, 118192, 11021), false, false, 4800, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 9)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "accelerated", "linear", 12000, false, false, point(144189, 116093, 11123), point(142046, 118192, 11021), point(145074, 114496, 10950), point(143172, 116817, 10994), 4800, 2000, false, 60, 40, 10000, 90000, 400, 400, "Default", 100)
  local _, SP_Faucheux_GoTo
  prgdbg(li, 1, 10)
  _, SP_Faucheux_GoTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", Faucheux, "SP_Faucheux_GoTo", true, true, false, "Standing", false, false, "")
  prgdbg(li, 1, 11)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 300)
  prgdbg(li, 1, 12)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 0, false, false, point(158907, 113962, 13547), point(159102, 118797, 14808), false, false, 4800, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 13)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, Faucheux)
  prgdbg(li, 1, 14)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 400, 700)
  local _, SP_Boat_GoTo
  prgdbg(li, 1, 15)
  _, SP_Boat_GoTo = sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Boat, "SP_Boat_GoTo", true, "idle", 1000, 12000, range(1, 1), 0, false, false, false, "")
  prgdbg(li, 1, 16)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", "", "linear", "linear", 8000, false, false, point(158985, 115894, 14051), point(159102, 118797, 14808), point(157064, 116677, 14210), point(159102, 118797, 14808), 4800, 2000, false, 80, 0, 10000, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 17)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 18)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
