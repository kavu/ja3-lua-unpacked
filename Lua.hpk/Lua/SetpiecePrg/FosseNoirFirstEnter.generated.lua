rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.FosseNoirFirstEnter(seed, state, TriggerUnits)
  local li = {
    id = "FosseNoirFirstEnter"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  prgdbg(li, 1, 2)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("MusicSetTrack", {
      Playlist = "Scripted",
      Track = "Music/11 59"
    })
  })
  local _, LegionActor1
  prgdbg(li, 1, 3)
  _, LegionActor1 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionActor1, "", "SP_LegionActor1", "Object", false)
  local _, LegionActor2
  prgdbg(li, 1, 4)
  _, LegionActor2 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionActor2, "", "SP_LegionActor2", "Object", false)
  local _, LegionActor3
  prgdbg(li, 1, 5)
  _, LegionActor3 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionActor3, "LegionActor3", "SP_LegionActor3", "Object", false)
  local _, LegionActor4
  prgdbg(li, 1, 6)
  _, LegionActor4 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionActor4, "LegionActor4", "SP_LegionActor4", "Object", false)
  local _, LegionActor5
  prgdbg(li, 1, 7)
  _, LegionActor5 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionActor5, "LegionActor5", "SP_LegionActor5", "Object", false)
  local _, RebelActor1
  prgdbg(li, 1, 8)
  _, RebelActor1 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, RebelActor1, "", "RebelActor1", "Object", true)
  local _, RebelActor2
  prgdbg(li, 1, 9)
  _, RebelActor2 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, RebelActor2, "", "SashaGrise", "Object", true)
  local _, Merc1
  prgdbg(li, 1, 10)
  _, Merc1 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc1, "", 1, 1)
  local _, Merc2
  prgdbg(li, 1, 11)
  _, Merc2 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc2, "", 1, 2)
  local _, Merc3
  prgdbg(li, 1, 12)
  _, Merc3 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc3, "", 1, 3)
  local _, Merc4
  prgdbg(li, 1, 13)
  _, Merc4 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc4, "", 1, 4)
  local _, Merc5
  prgdbg(li, 1, 14)
  _, Merc5 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc5, "", 1, 5)
  local _, Merc6
  prgdbg(li, 1, 15)
  _, Merc6 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc6, "", 1, 6)
  prgdbg(li, 1, 16)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Tac", "", "", "linear", 0, false, false, point(122778, 167294, 9602), point(119739, 171217, 8991), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 17)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", LegionActor1, "Crouch", "Current Weapon", false)
  prgdbg(li, 1, 18)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", LegionActor2, "Crouch", "FAMAS", false)
  prgdbg(li, 1, 19)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", LegionActor4, "Crouch", "Current Weapon", false)
  prgdbg(li, 1, 20)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", LegionActor5, "Crouch", "Current Weapon", false)
  prgdbg(li, 1, 21)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", RebelActor1, "Standing", "Current Weapon", false)
  prgdbg(li, 1, 22)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", RebelActor2, "Standing", "Current Weapon", false)
  prgdbg(li, 1, 23)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", LegionActor3, "Prone", "Current Weapon", false)
  local _, LegionActor1_port
  prgdbg(li, 1, 24)
  _, LegionActor1_port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, LegionActor1, "LegionActor1_port", true)
  local _
  prgdbg(li, 1, 25)
  _, LegionActor1_port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, LegionActor2, "LegionActor2_port", true)
  local _
  prgdbg(li, 1, 26)
  _, LegionActor1_port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, LegionActor3, "SP_LegionActor3_port", true)
  prgdbg(li, 1, 27)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, LegionActor4, "SP_LegionActor4_port", true)
  local _
  prgdbg(li, 1, 28)
  _, LegionActor1_port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, LegionActor5, "SP_LegionActor5_port", true)
  prgdbg(li, 1, 29)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, RebelActor1, "SP_RebelActor1_Port", true)
  prgdbg(li, 1, 30)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, RebelActor2, "SP_RebelActor2_Port", true)
  local _, SP_Merc1_TP
  prgdbg(li, 1, 31)
  _, SP_Merc1_TP = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc1, "SP_Merc1_TP", true)
  local _, SP_Merc2_TP
  prgdbg(li, 1, 32)
  _, SP_Merc2_TP = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc2, "SP_Merc2_TP", true)
  local _, SP_Merc3_TP
  prgdbg(li, 1, 33)
  _, SP_Merc3_TP = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc3, "SP_Merc3_TP", true)
  local _, SP_Merc4_TP
  prgdbg(li, 1, 34)
  _, SP_Merc4_TP = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc4, "SP_Merc4_TP", true)
  local _, SP_Merc5_TP
  prgdbg(li, 1, 35)
  _, SP_Merc5_TP = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc5, "SP_Merc5_TP", true)
  local _, SP_Merc6_TP
  prgdbg(li, 1, 36)
  _, SP_Merc6_TP = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc6, "SP_Merc6_TP", true)
  local _, SP_LegionActor1_GoTo_Prim
  prgdbg(li, 1, 37)
  _, SP_LegionActor1_GoTo_Prim = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", LegionActor1, "SP_LegionActor1_GoTo", true, false, false, "Crouch", false, true, "")
  local _
  prgdbg(li, 1, 38)
  _, SP_LegionActor1_GoTo_Prim = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", LegionActor3, "SP_LegionActor3_goto1", true, false, false, "Prone", false, true, "")
  prgdbg(li, 1, 39)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "FosseNoir_LegionActor4_1", LegionActor4)
  prgdbg(li, 1, 40)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "FosseNoir_LegionActor5", LegionActor5, RebelActor1)
  prgdbg(li, 1, 41)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 1500)
  prgdbg(li, 1, 42)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 400)
  local _
  prgdbg(li, 1, 43)
  _, SP_LegionActor1_GoTo_Prim = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", LegionActor2, "SP_LegionActor2_GoTo", true, false, true, "Crouch", true, true, "")
  prgdbg(li, 1, 44)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 4100)
  prgdbg(li, 1, 45)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "", {
    PlaceObj("Explosion", {
      Damage = 0,
      LocationGroup = "LegionActor1_Landmine",
      Noise = 0
    })
  })
  prgdbg(li, 1, 46)
  sprocall(SetpieceDeath.Exec, SetpieceDeath, state, rand, false, "", LegionActor1, "civ_DeathOnSpot_R")
  prgdbg(li, 1, 47)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 100)
  prgdbg(li, 1, 48)
  sprocall(SetpieceDeath.Exec, SetpieceDeath, state, rand, false, "", LegionActor2, "civ_DeathOnSpot_L")
  prgdbg(li, 1, 49)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 200)
  prgdbg(li, 1, 50)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", RebelActor1, "", true, "ar_Standing_CombatBegin3", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 51)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", RebelActor2, "", true, "ar_Standing_CombatBegin2", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 52)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", LegionActor3, "Prone", "Current Weapon", true)
  prgdbg(li, 1, 53)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 2000)
  prgdbg(li, 1, 54)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  prgdbg(li, 1, 55)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 400)
  prgdbg(li, 1, 56)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, RebelActor2, "SP_RebelActor2_Port2", true)
  prgdbg(li, 1, 57)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Tac", "", "", "linear", 0, false, false, point(144497, 154451, 13707), point(140761, 157205, 11849), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 58)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 500)
  prgdbg(li, 1, 59)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", RebelActor2, "", true, "ar_Standing_CombatBegin", 1100, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 60)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", RebelActor2, "", true, "ar_Standing_Aim", 1600, 5000, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 61)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 500)
  prgdbg(li, 1, 62)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  prgdbg(li, 1, 63)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 150)
  prgdbg(li, 1, 64)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Tac", "", "linear", "linear", 0, false, false, point(157230, 169243, 16279), point(159631, 170792, 17197), point(142802, 157909, 6950), point(151329, 171103, 17950), 4200, 4000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 65)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "FosseNoir_LegionActor3", LegionActor3, RebelActor1)
  prgdbg(li, 1, 66)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "FosseNoir_LegionActor4", LegionActor4, RebelActor1)
  prgdbg(li, 1, 67)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "FosseNoir_RebelActor1", RebelActor1, LegionActor3, LegionActor5)
  prgdbg(li, 1, 68)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "FosseNoir_LegionActor5_2", LegionActor5, RebelActor1)
  prgdbg(li, 1, 69)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "FosseNoir_RebelActor2", RebelActor2, LegionActor3, LegionActor5)
  prgdbg(li, 1, 70)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 400)
  prgdbg(li, 1, 71)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 7000)
  prgdbg(li, 1, 72)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 73)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, LegionActor3)
  prgdbg(li, 1, 74)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, LegionActor4)
  prgdbg(li, 1, 75)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
