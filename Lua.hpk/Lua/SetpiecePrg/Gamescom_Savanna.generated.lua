rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.Gamescom_Savanna(seed, state, TriggerUnits)
  local li = {
    id = "Gamescom_Savanna"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  prgdbg(li, 1, 2)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 700)
  local _, Merc1
  prgdbg(li, 1, 3)
  _, Merc1 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Merc1, "", "Meltdown", "Object", false)
  local _, Merc2
  prgdbg(li, 1, 4)
  _, Merc2 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Merc2, "", "Gus", "Object", false)
  local _, Merc3
  prgdbg(li, 1, 5)
  _, Merc3 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Merc3, "", "Grizzly", "Object", false)
  local _, Merc4
  prgdbg(li, 1, 6)
  _, Merc4 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Merc4, "", "Fauda", "Object", false)
  local _
  prgdbg(li, 1, 7)
  _, Merc1 = sprocall(SetpieceSpawn.Exec, SetpieceSpawn, state, rand, Merc1, "Merc1")
  local _
  prgdbg(li, 1, 8)
  _, Merc2 = sprocall(SetpieceSpawn.Exec, SetpieceSpawn, state, rand, Merc2, "Merc2")
  local _
  prgdbg(li, 1, 9)
  _, Merc3 = sprocall(SetpieceSpawn.Exec, SetpieceSpawn, state, rand, Merc3, "Merc3")
  local _
  prgdbg(li, 1, 10)
  _, Merc4 = sprocall(SetpieceSpawn.Exec, SetpieceSpawn, state, rand, Merc4, "Merc4")
  prgdbg(li, 1, 11)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "Gamescom_Savanna_Merc1", Merc1)
  prgdbg(li, 1, 12)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "Gamescom_Savanna_Merc2", Merc2)
  prgdbg(li, 1, 13)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "Gamescom_Savanna_Merc3", Merc3)
  prgdbg(li, 1, 14)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "Gamescom_Savanna_Merc4", Merc4)
  prgdbg(li, 1, 15)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", "", "decelerated", "linear", 10000, false, false, point(226881, 76633, 19722), point(228601, 72042, 20704), point(224989, 81683, 18642), point(226709, 77092, 19624), 4800, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 16)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 3500)
  prgdbg(li, 1, 17)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 18)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
