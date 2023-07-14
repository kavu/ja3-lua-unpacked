rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.PortCacaoCity_FirstEnter(seed, state, TriggerUnits)
  local li = {
    id = "PortCacaoCity_FirstEnter"
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
  _, LegionActor1 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionActor1, "", "LegionActor1", "Object", false)
  local _, LegionActor2
  prgdbg(li, 1, 4)
  _, LegionActor2 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionActor2, "", "LegionActor2", "Object", false)
  local _, LegionActor3
  prgdbg(li, 1, 5)
  _, LegionActor3 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionActor3, "", "LegionActor3", "Object", false)
  local _, LegionActorLeader
  prgdbg(li, 1, 6)
  _, LegionActorLeader = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionActorLeader, "", "LegionActorLeader", "Object", false)
  local _, SoldierActor1
  prgdbg(li, 1, 7)
  _, SoldierActor1 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, SoldierActor1, "", "SoldierActor1", "Object", false)
  local _, SoldierActor2
  prgdbg(li, 1, 8)
  _, SoldierActor2 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, SoldierActor2, "", "SoldierActor2", "Object", false)
  local _, SoldierActorSniper
  prgdbg(li, 1, 9)
  _, SoldierActorSniper = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, SoldierActorSniper, "", "SoldierSniperActor", "Object", false)
  local _, Governor
  prgdbg(li, 1, 10)
  _, Governor = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Governor, "", "Gouvernour", "Object", false)
  prgdbg(li, 1, 11)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", Governor, "Standing", "No Weapon", true)
  local _, SoldierActor1Cover
  prgdbg(li, 1, 12)
  _, SoldierActor1Cover = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, LegionActor2, "LegionActor2Shoot", true)
  prgdbg(li, 1, 13)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", LegionActor2, "", false, "ar_Standing_IdlePassive", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 14)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", LegionActor3, "", false, "ar_Standing_IdlePassive2", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 15)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", LegionActorLeader, "", false, "ar_Standing_IdlePassive", 1000, 0, range(1, 1), 0, false, true, false, "")
  local _
  prgdbg(li, 1, 16)
  _, SoldierActor1Cover = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, SoldierActor1, "SoldierActor1Cover", true)
  local _
  prgdbg(li, 1, 17)
  _, SoldierActor1Cover = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, SoldierActor2, "SoldierActor2Cover", true)
  local _, SP_GovernorPort
  prgdbg(li, 1, 18)
  _, SP_GovernorPort = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Governor, "SP_GovernorPort", true)
  prgdbg(li, 1, 19)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5)
  prgdbg(li, 1, 20)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Governor, "", false, "civ_Talk_ArmsDown3", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 21)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", SoldierActor1, "SoldierActor1Cover", true, "ar_Standing_Aim", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 22)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", SoldierActor2, "SoldierActor2Cover", true, "ar_Standing_Aim", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 23)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "PortCacaoFirstEnter_LegionActor1", LegionActor1)
  prgdbg(li, 1, 24)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "PortCacaoFirstEnter_Rocket", nil, Governor)
  prgdbg(li, 1, 25)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "PortCacaoFirstEnter_Sniper", SoldierActorSniper, LegionActor1, LegionActor2, LegionActor3, LegionActorLeader)
  prgdbg(li, 1, 26)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 0, false, false, point(172962, 180697, 15266), point(175117, 185207, 15125), false, false, 4800, 1300, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 27)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 400, 700)
  prgdbg(li, 1, 28)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", 0, "decelerated", "linear", 25000, false, false, point(173824, 182501, 15210), point(175117, 185207, 15125), point(168995, 172397, 15532), point(171150, 176906, 15389), 4800, 1300, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 29)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 300)
  prgdbg(li, 1, 30)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "PortCacaoCity_FirstBanterDone", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "PortCacaoCity_Gouverneur_01_InitialSetPiece"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 31)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "PortCacaoCity_FirstBanterDone")
  prgdbg(li, 1, 32)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 33)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 700)
  prgdbg(li, 1, 34)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", 0, "linear", "linear", 12000, false, false, point(179346, 164802, 22976), point(182751, 167078, 25844), point(179346, 164802, 22976), point(182751, 167078, 25844), 4800, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 35)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "PortCacaoCity_RocketBoom")
  prgdbg(li, 1, 36)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 700)
  prgdbg(li, 1, 37)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "PortCacaoCity_SecondBanterDone", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "PortCacaoCity_Gouverneur_02_SetPieceFollowUp"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 38)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "PortCacaoCity_SecondBanterDone")
  local _, SP_Governor_Exit
  prgdbg(li, 1, 39)
  _, SP_Governor_Exit = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Governor, "SP_Governor_Exit", true, true, false, "", false, false, "")
  prgdbg(li, 1, 40)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1300)
  prgdbg(li, 1, 41)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 300)
  prgdbg(li, 1, 42)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 0, false, false, point(161280, 151380, 17434), point(159560, 146887, 18796), false, false, 4200, 1300, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 43)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 700, 500)
  prgdbg(li, 1, 44)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 3200)
  prgdbg(li, 1, 45)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 300)
  prgdbg(li, 1, 46)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", LegionActor2, "", false, "ar_Standing_Aim", 1000, 0, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 47)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", LegionActor3, "", false, "ar_Standing_Aim", 1000, 0, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 48)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", LegionActorLeader, "", false, "ar_Standing_Suspicious", 1000, 0, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 49)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 200)
  prgdbg(li, 1, 50)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "PortCacaoFirstEnter_LegionActor2", LegionActor2, SoldierActor2)
  prgdbg(li, 1, 51)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "PortCacaoFirstEnter_LegionLeaderRun", LegionActorLeader, nil)
  prgdbg(li, 1, 52)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "PortCacaoFirstEnter_SoldierActor2", SoldierActor2, LegionActor3)
  prgdbg(li, 1, 53)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "PortCacaoFirstEnter_SoldierActor1", SoldierActor1, LegionActor2)
  prgdbg(li, 1, 54)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", 0, "", "linear", 1000, false, false, point(174308, 151714, 23326), point(177603, 149421, 26305), false, false, 4800, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 55)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 0, 700)
  prgdbg(li, 1, 56)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 4800)
  prgdbg(li, 1, 57)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 58)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, LegionActor2)
  prgdbg(li, 1, 59)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, LegionActor3)
  prgdbg(li, 1, 60)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, LegionActorLeader)
  prgdbg(li, 1, 61)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
