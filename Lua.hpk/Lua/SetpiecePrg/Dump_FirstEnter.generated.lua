rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.Dump_FirstEnter(seed, state, TriggerUnits)
  local li = {
    id = "Dump_FirstEnter"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  prgdbg(li, 1, 2)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("MusicSetTrack", {
      Playlist = "Scripted",
      Track = "Music/Wandering Paths"
    })
  })
  prgdbg(li, 1, 3)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 50)
  prgdbg(li, 1, 4)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Tac", "", "", "linear", 0, false, false, point(173887, 192720, 3689), point(176244, 194564, 3490), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  local _, Baronne
  prgdbg(li, 1, 5)
  _, Baronne = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Baronne, "", "Baronne", "Object", false)
  local _, Henri
  prgdbg(li, 1, 6)
  _, Henri = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Henri, "", "DirtyHenri", "Object", false)
  local _, SP_BaronnePort_Initial
  prgdbg(li, 1, 7)
  _, SP_BaronnePort_Initial = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Baronne, "SP_BaronnePort_Initial", true)
  local _, SP_HenriPort_Initial
  prgdbg(li, 1, 8)
  _, SP_HenriPort_Initial = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Henri, "SP_HenriPort_Initial", true)
  prgdbg(li, 1, 9)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Baronne, "", true, "civ_Talking2", 1000, 0, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 10)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Henri, "", true, "civ_Talk_HandsOnHips", 1000, 0, range(1, 1), 0, true, true, false, "")
  local _, NoblesActor1
  prgdbg(li, 1, 11)
  _, NoblesActor1 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NoblesActor1, "", "NoblesActor1", "Object", false)
  local _, SP_NoblesActor1
  prgdbg(li, 1, 12)
  _, SP_NoblesActor1 = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, NoblesActor1, "SP_NoblesActor1_Port", true)
  local _, NoblesActor2
  prgdbg(li, 1, 13)
  _, NoblesActor2 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NoblesActor2, "", "NoblesActor2", "Object", false)
  local _, SP_NoblesActor2_Port
  prgdbg(li, 1, 14)
  _, SP_NoblesActor2_Port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, NoblesActor2, "SP_NoblesActor2_Port", true)
  local _, NoblesActor3
  prgdbg(li, 1, 15)
  _, NoblesActor3 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NoblesActor3, "", "NoblesActor3", "Object", false)
  prgdbg(li, 1, 16)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, NoblesActor3, "SP_NoblesActor3_Port", true)
  local _, NoblesActor4
  prgdbg(li, 1, 17)
  _, NoblesActor4 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NoblesActor4, "", "NoblesActor4", "Object", false)
  local _, SP_NoblesActor4_Port
  prgdbg(li, 1, 18)
  _, SP_NoblesActor4_Port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, NoblesActor4, "SP_NoblesActor4_Port", true)
  local _, NoblesActor5
  prgdbg(li, 1, 19)
  _, NoblesActor5 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NoblesActor5, "", "NoblesActor5", "Object", false)
  local _, SP_NoblesActor5_Port
  prgdbg(li, 1, 20)
  _, SP_NoblesActor5_Port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, NoblesActor5, "SP_NoblesActor5_Port", true)
  local _, NoblesActor6
  prgdbg(li, 1, 21)
  _, NoblesActor6 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NoblesActor6, "", "NoblesActor6", "Object", false)
  local _, SP_NoblesActor6_Port
  prgdbg(li, 1, 22)
  _, SP_NoblesActor6_Port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, NoblesActor6, "SP_NoblesActor6_Port", true)
  local _, KnightsActor1
  prgdbg(li, 1, 23)
  _, KnightsActor1 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, KnightsActor1, "", "KnightsActor1", "Object", false)
  local _, SP_KnightsActor1_Port
  prgdbg(li, 1, 24)
  _, SP_KnightsActor1_Port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, KnightsActor1, "SP_KnightsActor1_Port", true)
  local _, KnightsActor2
  prgdbg(li, 1, 25)
  _, KnightsActor2 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, KnightsActor2, "", "KnightsActor2", "Object", false)
  local _, SP_KnightsActor2_Port
  prgdbg(li, 1, 26)
  _, SP_KnightsActor2_Port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, KnightsActor2, "SP_KnightsActor2_Port", true)
  local _, KnightsActor3
  prgdbg(li, 1, 27)
  _, KnightsActor3 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, KnightsActor3, "", "KnightsActor3", "Object", false)
  local _, SP_KnightsActor3_Port
  prgdbg(li, 1, 28)
  _, SP_KnightsActor3_Port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, KnightsActor3, "SP_KnightsActor3_Port", true)
  local _, KnightsActor4
  prgdbg(li, 1, 29)
  _, KnightsActor4 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, KnightsActor4, "", "KnightsActor4", "Object", false)
  local _, SP_KnightsActor4_Port
  prgdbg(li, 1, 30)
  _, SP_KnightsActor4_Port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, KnightsActor4, "SP_KnightsActor4_Port", true)
  local _, KnightsActor5
  prgdbg(li, 1, 31)
  _, KnightsActor5 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, KnightsActor5, "", "KnightsActor5", "Object", false)
  local _, SP_KnightsActor5_Port
  prgdbg(li, 1, 32)
  _, SP_KnightsActor5_Port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, KnightsActor5, "SP_KnightsActor5_Port", true)
  local _, KnightsActor6
  prgdbg(li, 1, 33)
  _, KnightsActor6 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, KnightsActor6, "", "KnightsActor6", "Object", false)
  local _, SP_KnightsActor6_Port
  prgdbg(li, 1, 34)
  _, SP_KnightsActor6_Port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, KnightsActor6, "SP_KnightsActor6_Port", true)
  local _, KnightsActor7
  prgdbg(li, 1, 35)
  _, KnightsActor7 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, KnightsActor7, "", "KnightsActor7", "Object", false)
  local _, SP_KnightsActor7_Port
  prgdbg(li, 1, 36)
  _, SP_KnightsActor7_Port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, KnightsActor7, "SP_KnightsActor7_Port", true)
  prgdbg(li, 1, 37)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", KnightsActor1, "Standing", "No Weapon", false)
  prgdbg(li, 1, 38)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", KnightsActor2, "Standing", "No Weapon", false)
  prgdbg(li, 1, 39)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", KnightsActor3, "Standing", "No Weapon", false)
  prgdbg(li, 1, 40)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", KnightsActor4, "Standing", "No Weapon", false)
  prgdbg(li, 1, 41)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", KnightsActor5, "Standing", "No Weapon", false)
  prgdbg(li, 1, 42)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", KnightsActor6, "Standing", "No Weapon", false)
  prgdbg(li, 1, 43)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", KnightsActor7, "Standing", "No Weapon", false)
  prgdbg(li, 1, 44)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", NoblesActor1, "Standing", "No Weapon", false)
  prgdbg(li, 1, 45)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", NoblesActor2, "Standing", "No Weapon", false)
  prgdbg(li, 1, 46)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", NoblesActor3, "Standing", "No Weapon", false)
  prgdbg(li, 1, 47)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", NoblesActor4, "Standing", "No Weapon", false)
  prgdbg(li, 1, 48)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", NoblesActor5, "Standing", "No Weapon", false)
  prgdbg(li, 1, 49)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", NoblesActor6, "Standing", "No Weapon", false)
  prgdbg(li, 1, 50)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 100)
  prgdbg(li, 1, 51)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NoblesActor1, "", true, "civ_Ambient_Angry", 1000, 0, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 52)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NoblesActor2, "", true, "civ_Ambient_Cheering", 1000, 0, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 53)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NoblesActor3, "", true, "civ_Talk_HandsOnHips", 1000, 0, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 54)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NoblesActor4, "", true, "civ_Ambient_LookingWall", 1000, 0, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 55)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NoblesActor5, "", true, "civ_Ambient_Angry", 1050, 0, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 56)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NoblesActor6, "", true, "civ_Ambient_Angry", 950, 0, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 57)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", KnightsActor1, "", true, "civ_Ambient_Angry", 1050, 0, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 58)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", KnightsActor2, "", true, "civ_Ambient_LookingWall", 1000, 0, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 59)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", KnightsActor3, "", true, "civ_Ambient_Cheering", 1050, 0, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 60)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", KnightsActor4, "", true, "civ_Ambient_Angry", 1000, 0, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 61)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", KnightsActor5, "", true, "civ_Ambient_Smoking", 1000, 0, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 62)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", KnightsActor6, "", true, "civ_Ambient_Cheering", 1000, 0, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 63)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", KnightsActor7, "", true, "civ_Ambient_LookingWall", 1000, 0, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 64)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 50, 3500)
  prgdbg(li, 1, 65)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Tac", 2, "", "linear", 12000, false, false, point(172316, 191488, 3824), point(176244, 194564, 3490), point(181744, 182683, 3689), point(184101, 184527, 3490), 4200, 1300, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 66)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 6800)
  prgdbg(li, 1, 67)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "Dump_FirstEnter_Banter"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 68)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5225)
  prgdbg(li, 1, 69)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 300)
  prgdbg(li, 1, 70)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 50)
  prgdbg(li, 1, 71)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Tac", "", "", "linear", 0, false, false, point(161607, 166841, 5285), point(162273, 169477, 6558), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 72)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 50, 50)
  prgdbg(li, 1, 73)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 36000)
  prgdbg(li, 1, 74)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 1500)
  prgdbg(li, 1, 75)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 50)
  local _, SP_KnightsActor1_ExitPort
  prgdbg(li, 1, 76)
  _, SP_KnightsActor1_ExitPort = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, KnightsActor1, "SP_KnightsActor1_ExitPort", true)
  local _, SP_KnightsActor3_ExitPort
  prgdbg(li, 1, 77)
  _, SP_KnightsActor3_ExitPort = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, KnightsActor3, "SP_KnightsActor3_ExitPort", true)
  local _, SP_KnightsActor5_ExitPort
  prgdbg(li, 1, 78)
  _, SP_KnightsActor5_ExitPort = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, KnightsActor5, "SP_KnightsActor5_ExitPort", true)
  local _, SP_Henri_ExitPort
  prgdbg(li, 1, 79)
  _, SP_Henri_ExitPort = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Henri, "SP_Henri_ExitPort", true)
  local _, SP_Henri_GoTo
  prgdbg(li, 1, 80)
  _, SP_Henri_GoTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Henri, "SP_Henri_Exit", true, false, false, "Standing", false, false, "Walk_Slow_Neutral")
  local _
  prgdbg(li, 1, 81)
  _, SP_Henri_GoTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", KnightsActor1, "SP_Henri_Exit", true, false, false, "", false, false, "Walk_Fast_Neutral")
  local _
  prgdbg(li, 1, 82)
  _, SP_Henri_GoTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", KnightsActor2, "SP_Henri_Exit", true, false, false, "", false, false, "Walk_Fast_Paranoid")
  local _, SP_Knights_Exit1
  prgdbg(li, 1, 83)
  _, SP_Knights_Exit1 = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", KnightsActor3, "SP_Knights_Exit1", true, false, false, "", false, false, "Walk_Fast_Neutral")
  local _, SP_Knights_Exit2
  prgdbg(li, 1, 84)
  _, SP_Knights_Exit2 = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", KnightsActor4, "SP_Knights_Exit2", true, false, false, "", false, false, "Walk_Fast_Paranoid")
  prgdbg(li, 1, 85)
  sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", KnightsActor5, "SP_Knights_Exit1", true, false, false, "", false, false, "Walk_Slow_Neutral")
  prgdbg(li, 1, 86)
  sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", KnightsActor6, "SP_Knights_Exit2", true, false, false, "", false, false, "Walk_Normal_Neutral")
  prgdbg(li, 1, 87)
  sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", KnightsActor7, "SP_Knights_Exit2", true, false, false, "", false, false, "Walk_Slow_Neutral")
  local _, SP_Baronne_GoTo
  prgdbg(li, 1, 88)
  _, SP_Baronne_GoTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Baronne, "SP_Baronne_Exit", true, false, false, "Standing", false, false, "Walk_Slow_Neutral")
  local _
  prgdbg(li, 1, 89)
  _, SP_Baronne_GoTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NoblesActor1, "SP_Baronne_Exit", true, false, false, "", false, false, "Walk_Slow_Neutral")
  local _
  prgdbg(li, 1, 90)
  _, SP_Baronne_GoTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NoblesActor2, "SP_Baronne_Exit", true, false, false, "", false, false, "Walk_Normal_Neutral")
  local _, SP_Nobles_Exit1
  prgdbg(li, 1, 91)
  _, SP_Nobles_Exit1 = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NoblesActor3, "SP_Nobles_Exit1", true, false, false, "", false, false, "Walk_Normal_Neutral")
  prgdbg(li, 1, 92)
  sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NoblesActor4, "SP_Nobles_Exit1", true, false, false, "", false, false, "Walk_Fast_Paranoid")
  prgdbg(li, 1, 93)
  sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NoblesActor5, "SP_Nobles_Exit1", true, false, false, "", false, false, "Walk_Normal_Neutral")
  prgdbg(li, 1, 94)
  sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NoblesActor6, "SP_Baronne_Exit", true, false, false, "", false, false, "Walk_Fast_Neutral")
  prgdbg(li, 1, 95)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Tac", "", "", "linear", 0, false, false, point(161666, 181293, 20836), point(162237, 183559, 22718), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 96)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 100, 1500)
  prgdbg(li, 1, 97)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 2500)
  prgdbg(li, 1, 98)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 1500)
  prgdbg(li, 1, 99)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
