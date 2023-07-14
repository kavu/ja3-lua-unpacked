rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.LurchsMom(seed, state, TriggerUnits)
  local li = {id = "LurchsMom"}
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 2)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("UnitsDespawnAmbientLife", {})
  })
  prgdbg(li, 1, 3)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("MusicSetTrack", {
      Playlist = "Scripted",
      Track = "Music/Carnival Queen"
    })
  })
  local _, Lurch
  prgdbg(li, 1, 4)
  _, Lurch = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Lurch, "", "Lurch", "Object", false)
  local _, Granny
  prgdbg(li, 1, 5)
  _, Granny = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Granny, "", "MaBaxter", "Object", false)
  local _, SP_GrannyStart
  prgdbg(li, 1, 6)
  _, SP_GrannyStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Granny, "SP_GrannyStart", true)
  local _, Hue
  prgdbg(li, 1, 7)
  _, Hue = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Hue, "", "HeadshotHue", "Object", false)
  local _, BarClient1
  prgdbg(li, 1, 8)
  _, BarClient1 = sprocall(SetpieceSpawn.Exec, SetpieceSpawn, state, rand, BarClient1, "BarClient1")
  local _, BarClient2
  prgdbg(li, 1, 9)
  _, BarClient2 = sprocall(SetpieceSpawn.Exec, SetpieceSpawn, state, rand, BarClient2, "BarClient2")
  local _, BarClient3
  prgdbg(li, 1, 10)
  _, BarClient3 = sprocall(SetpieceSpawn.Exec, SetpieceSpawn, state, rand, BarClient3, "BarClient3")
  local _, BarClient4
  prgdbg(li, 1, 11)
  _, BarClient4 = sprocall(SetpieceSpawn.Exec, SetpieceSpawn, state, rand, BarClient4, "BarClient4")
  local _, BarClient5
  prgdbg(li, 1, 12)
  _, BarClient5 = sprocall(SetpieceSpawn.Exec, SetpieceSpawn, state, rand, BarClient5, "BarClient5")
  local _, Merc1
  prgdbg(li, 1, 13)
  _, Merc1 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc1, "", 1, 1)
  local _, Merc2
  prgdbg(li, 1, 14)
  _, Merc2 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc2, "", 1, 2)
  local _, Merc3
  prgdbg(li, 1, 15)
  _, Merc3 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc3, "", 1, 3)
  local _, Merc4
  prgdbg(li, 1, 16)
  _, Merc4 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc4, "", 1, 4)
  local _, Merc5
  prgdbg(li, 1, 17)
  _, Merc5 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc5, "", 1, 5)
  local _, Merc6
  prgdbg(li, 1, 18)
  _, Merc6 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc6, "", 1, 6)
  prgdbg(li, 1, 19)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 2000, false, false, point(145892, 155818, 13094), point(143816, 153798, 13876), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 20)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 400, 700)
  prgdbg(li, 1, 21)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", BarClient1, "", true, "civ_Wall_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 22)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", BarClient2, "", true, "civ_Ambient_DrinkingAtTable", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 23)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", BarClient3, "", true, "civ_Ambient_SleepingAtTable", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 24)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", BarClient4, "", true, "civ_Ambient_DrinkingAtTable2", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 25)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", BarClient5, "", true, "civ_Ambient_DrinkingAtTable", 1000, 0, range(1, 1), 0, false, true, false, "")
  local _, SP_GranyToBar
  prgdbg(li, 1, 26)
  _, SP_GranyToBar = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Hue, "SP_HueExit", true, false, false, "", true, false, "")
  prgdbg(li, 1, 27)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5000)
  prgdbg(li, 1, 28)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  local _
  prgdbg(li, 1, 29)
  _, SP_GrannyStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc1, "SP_Merc1", true)
  local _
  prgdbg(li, 1, 30)
  _, SP_GrannyStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc2, "SP_Merc2", true)
  local _
  prgdbg(li, 1, 31)
  _, SP_GrannyStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc3, "SP_Merc3", true)
  local _
  prgdbg(li, 1, 32)
  _, SP_GrannyStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc4, "SP_Merc4", true)
  local _
  prgdbg(li, 1, 33)
  _, SP_GrannyStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc5, "SP_Merc5", true)
  local _
  prgdbg(li, 1, 34)
  _, SP_GrannyStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc6, "SP_Merc6", true)
  local _
  prgdbg(li, 1, 35)
  _, Granny = sprocall(SetpieceSpawn.Exec, SetpieceSpawn, state, rand, Granny, "Granny")
  prgdbg(li, 1, 36)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 3000, false, false, point(152211, 169668, 9572), point(149191, 173443, 10845), false, false, 4300, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  local _
  prgdbg(li, 1, 37)
  _, SP_GranyToBar = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", Lurch, "SP_LurchMomConv", true, false, true, "Standing", true, false, "")
  prgdbg(li, 1, 38)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 400, 700)
  local _
  prgdbg(li, 1, 39)
  _, SP_GranyToBar = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", Granny, "SP_GranyToBar", true, false, false, "", true, false, "")
  prgdbg(li, 1, 40)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 750)
  prgdbg(li, 1, 41)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Granny, "SP_GranyToBar", true, "civ_Ambient_Angry", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 42)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "PortCacaoDocks_LurchMom_SetPiece"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 43)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 44)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "Granny Exit", "Max", "", "", "linear", 500, false, false, point(156206, 168603, 9992), point(158206, 170734, 10666), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 45)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("NpcUnitGiveItem", {
      ItemId = "Auto5_quest",
      TargetUnit = "HeadshotHue"
    }),
    PlaceObj("NpcUnitGiveItem", {
      DontDrop = true,
      ItemId = "Auto5_quest",
      TargetUnit = "MaBaxter"
    })
  })
  prgdbg(li, 1, 46)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "Granny Exit")
  prgdbg(li, 1, 47)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 400, 700)
  local _, SP_GrannyExit
  prgdbg(li, 1, 48)
  _, SP_GrannyExit = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "Granny Exit", Granny, "SP_GrannyExit", true, false, false, "", false, false, "")
  prgdbg(li, 1, 49)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5800)
  prgdbg(li, 1, 50)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, Granny)
  prgdbg(li, 1, 51)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 52)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1000)
  prgdbg(li, 1, 53)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 400, 700)
  local _, SP_HueReturn
  prgdbg(li, 1, 54)
  _, SP_HueReturn = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Hue, "SP_HueReturn", true, false, true, "", false, false, "")
  prgdbg(li, 1, 55)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 6000)
  prgdbg(li, 1, 56)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 1500)
  local _
  prgdbg(li, 1, 57)
  _, SP_GrannyStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc1, "SP_Merc1_End", true)
  local _
  prgdbg(li, 1, 58)
  _, SP_GrannyStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc2, "SP_Merc2_End", true)
  local _
  prgdbg(li, 1, 59)
  _, SP_GrannyStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc3, "SP_Merc3_End", true)
  local _
  prgdbg(li, 1, 60)
  _, SP_GrannyStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc4, "SP_Merc4_End", true)
  local _
  prgdbg(li, 1, 61)
  _, SP_GrannyStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc5, "SP_Merc5_End", true)
  local _
  prgdbg(li, 1, 62)
  _, SP_GrannyStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc6, "SP_Merc6_End", true)
  prgdbg(li, 1, 63)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, BarClient1)
  prgdbg(li, 1, 64)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, BarClient2)
  prgdbg(li, 1, 65)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, BarClient3)
  prgdbg(li, 1, 66)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, BarClient4)
  prgdbg(li, 1, 67)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, BarClient5)
  prgdbg(li, 1, 68)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("ForceResetAmbientLife", {})
  })
  prgdbg(li, 1, 69)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
