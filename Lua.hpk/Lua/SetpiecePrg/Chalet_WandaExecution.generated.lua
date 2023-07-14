rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.Chalet_WandaExecution(seed, state, TriggerUnits)
  local li = {
    id = "Chalet_WandaExecution"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 2500)
  prgdbg(li, 1, 2)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 500, 1000)
  local _, Merc1
  prgdbg(li, 1, 3)
  _, Merc1 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc1, "", 1, 1)
  local _, Merc2
  prgdbg(li, 1, 4)
  _, Merc2 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc2, "", 1, 2)
  local _, Merc3
  prgdbg(li, 1, 5)
  _, Merc3 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc3, "", 1, 3)
  local _, Merc4
  prgdbg(li, 1, 6)
  _, Merc4 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc4, "", 1, 4)
  local _, Merc5
  prgdbg(li, 1, 7)
  _, Merc5 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc5, "", 1, 5)
  local _, Merc6
  prgdbg(li, 1, 8)
  _, Merc6 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc6, "", 1, 6)
  local _, SP_GrannyStart
  prgdbg(li, 1, 9)
  _, SP_GrannyStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc1, "SP_Merc1", true)
  prgdbg(li, 1, 10)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", Merc1, "Standing", "Current Weapon", false)
  local _
  prgdbg(li, 1, 11)
  _, SP_GrannyStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc2, "SP_Merc2", true)
  prgdbg(li, 1, 12)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", Merc2, "Standing", "Current Weapon", false)
  prgdbg(li, 1, 13)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Merc2, "", true, "ar_Standing_Idle6", 1000, 6200, range(1, 1), 0, false, true, false, "")
  local _
  prgdbg(li, 1, 14)
  _, SP_GrannyStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc3, "SP_Merc3", true)
  prgdbg(li, 1, 15)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Merc3, "", true, "civ_Talking2", 1000, 6200, range(1, 1), 0, false, true, false, "")
  local _
  prgdbg(li, 1, 16)
  _, SP_GrannyStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc4, "SP_Merc4", true)
  prgdbg(li, 1, 17)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Merc4, "", true, "civ_Talking3", 1000, 6200, range(1, 1), 0, false, true, false, "")
  local _
  prgdbg(li, 1, 18)
  _, SP_GrannyStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc5, "SP_Merc5", true)
  local _
  prgdbg(li, 1, 19)
  _, SP_GrannyStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc6, "SP_Merc6", true)
  local _, Wanda
  prgdbg(li, 1, 20)
  _, Wanda = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Wanda, "", "Wanda", "Object", false)
  local _, DocRobert
  prgdbg(li, 1, 21)
  _, DocRobert = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, DocRobert, "", "DocRobert", "Object", false)
  local _, DocRobertExecution
  prgdbg(li, 1, 22)
  _, DocRobertExecution = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, DocRobert, "DocRobertExecution", true)
  prgdbg(li, 1, 23)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 20)
  prgdbg(li, 1, 25)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", DocRobert, "DocRobertExecution_01", true, "nw_Cinematic_Walk", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 26)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Tac", "", "", "linear", 6000, false, false, point(124766, 142259, 8855), point(120514, 144874, 9136), false, false, 4200, 1150, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
  prgdbg(li, 1, 27)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 3000)
  local _, DocRobertAfter
  prgdbg(li, 1, 28)
  _, DocRobertAfter = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", DocRobert, "DocRobertExecution_01", true, false, true, "Standing", false, false, "Walk_Fast_Neutral")
  prgdbg(li, 1, 29)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 1000, 2000)
  prgdbg(li, 1, 30)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5)
  local _
  prgdbg(li, 1, 31)
  _, DocRobertExecution = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, DocRobert, "DocRobertExecution_02", true)
  local _, WandaExecution
  prgdbg(li, 1, 32)
  _, WandaExecution = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Wanda, "WandaExecution_01", true)
  prgdbg(li, 1, 33)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5)
  local _
  prgdbg(li, 1, 34)
  _, DocRobertAfter = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Wanda, "WandaExecution", true, false, true, "Standing", false, false, "Walk_Normal_Neutral")
  prgdbg(li, 1, 35)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", Wanda, "Standing", "Current Weapon", false)
  prgdbg(li, 1, 36)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", DocRobert, "Standing", "DesertEagle", false)
  prgdbg(li, 1, 37)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Tac", "", "", "linear", 5000, false, false, point(121309, 144804, 11113), point(117959, 148064, 12888), false, false, 4200, 1150, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
  prgdbg(li, 1, 38)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", DocRobert, "Point", Wanda, "Head", "WandaExecution", 1, 0, 3000, 100, 0, 0)
  prgdbg(li, 1, 39)
  sprocall(SetpieceDeath.Exec, SetpieceDeath, state, rand, true, "", Wanda, "civ_DeathBlow_B")
  prgdbg(li, 1, 40)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 2200)
  prgdbg(li, 1, 41)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 500, 1000)
  prgdbg(li, 1, 42)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Tac", "", "", "linear", 4000, false, false, point(125064, 147315, 7457), point(126580, 150963, 10521), false, false, 4200, 1150, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 43)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 500)
end
