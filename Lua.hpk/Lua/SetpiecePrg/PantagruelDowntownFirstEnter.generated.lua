rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.PantagruelDowntownFirstEnter(seed, state)
  local li = {
    id = "PantagruelDowntownFirstEnter"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  prgdbg(li, 1, 2)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "", {
    PlaceObj("ConditionalEffect", {
      "Conditions",
      {
        PlaceObj("SetpieceIsTestMode", {})
      },
      "Effects",
      {
        PlaceObj("UnitsDespawnAmbientLife", {})
      }
    })
  })
  prgdbg(li, 1, 3)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("MusicSetTrack", {
      Playlist = "Scripted",
      Track = "Music/The Stage is set"
    })
  })
  local _, Chimurenga
  prgdbg(li, 1, 4)
  _, Chimurenga = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Chimurenga, "", "Chimurenga", "Object", false)
  local _, RebelActorRoof
  prgdbg(li, 1, 5)
  _, RebelActorRoof = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, RebelActorRoof, "", "RebelActorRoof", "Object", false)
  local _, RebelActor1
  prgdbg(li, 1, 6)
  _, RebelActor1 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, RebelActor1, "", "RebelActor1", "Object", false)
  local _, RebelActor2
  prgdbg(li, 1, 7)
  _, RebelActor2 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, RebelActor2, "", "RebelActor2", "Object", false)
  local _, LegionActor3
  prgdbg(li, 1, 8)
  _, LegionActor3 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionActor3, "LegionActor3", "LegionFrontActor3", "Object", false)
  local _, LegionActor2
  prgdbg(li, 1, 9)
  _, LegionActor2 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionActor2, "LegionActor2", "LegionFrontActor2", "Object", false)
  local _, LegionActor1
  prgdbg(li, 1, 10)
  _, LegionActor1 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionActor1, "LegionActor1", "LegionFrontActor1", "Object", false)
  local _, LegionSideActor1
  prgdbg(li, 1, 11)
  _, LegionSideActor1 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionSideActor1, "LegionSideActor1", "LegionSideActor1", "Object", false)
  local _, LegionSideActor2
  prgdbg(li, 1, 12)
  _, LegionSideActor2 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionSideActor2, "LegionSideActor2", "LegionSideActor2", "Object", false)
  local _, LegionActor3Start
  prgdbg(li, 1, 13)
  _, LegionActor3Start = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Chimurenga, "ChimurengaPort", true)
  local _
  prgdbg(li, 1, 14)
  _, LegionActor3Start = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, RebelActorRoof, "RebelActorRoofPort", true)
  local _
  prgdbg(li, 1, 15)
  _, LegionActor3Start = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, RebelActor1, "RebelActor1Port", true)
  local _
  prgdbg(li, 1, 16)
  _, LegionActor3Start = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, RebelActor2, "RebelActor2Port", true)
  local _
  prgdbg(li, 1, 17)
  _, LegionActor3Start = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, LegionActor1, "LegionActor1StartRun", true)
  local _
  prgdbg(li, 1, 18)
  _, LegionActor3Start = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, LegionActor2, "LegionActor2StartRun", true)
  local _
  prgdbg(li, 1, 19)
  _, LegionActor3Start = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, LegionActor3, "LegionActor3StartRun", true)
  prgdbg(li, 1, 20)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", "", "", "linear", 0, false, false, point(174140, 177423, 8676), point(177034, 178208, 8763), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 21)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 100)
  local _, LegionActor3MoveTo
  prgdbg(li, 1, 22)
  _, LegionActor3MoveTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", LegionActor1, "LegionActor1Run", true, true, false, "Standing", false, false, "")
  local _
  prgdbg(li, 1, 23)
  _, LegionActor3MoveTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", LegionActor2, "LegionActor2Run", true, true, false, "Standing", false, false, "")
  local _
  prgdbg(li, 1, 24)
  _, LegionActor3MoveTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", LegionActor3, "LegionActor3Run", true, true, false, "Standing", false, false, "")
  prgdbg(li, 1, 25)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1000)
  prgdbg(li, 1, 26)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 400, 700)
  prgdbg(li, 1, 27)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5000)
  prgdbg(li, 1, 28)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 29)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Tac", "", "", "linear", 500, false, false, point(159945, 141103, 6950), point(147118, 155933, 17950), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 30)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 100)
  prgdbg(li, 1, 31)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "DowntownFirstEnter_Chimurenga", Chimurenga, LegionActor3, LegionActor2)
  prgdbg(li, 1, 32)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "DowntownFirstEnter_RebelActor1", RebelActor1, LegionActor2)
  prgdbg(li, 1, 33)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "DowntownFirstEnter_RebelActor2", RebelActor2, LegionActor1)
  prgdbg(li, 1, 34)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "DowntownFirstEnter_LegionActor3", LegionActor3, Chimurenga)
  prgdbg(li, 1, 35)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "DowntownFirstEnter_LegionActor2", LegionActor2, RebelActor1)
  prgdbg(li, 1, 36)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "DowntownFirstEnter_LegionActor1", LegionActor1, RebelActor1)
  prgdbg(li, 1, 37)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "DowntownFirstEnter_LegionSideActor1", LegionSideActor1, RebelActor2)
  prgdbg(li, 1, 38)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "DowntownFirstEnter_LegionSideActor2", LegionSideActor2, RebelActor1)
  prgdbg(li, 1, 39)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "DowntownFirstEnter_RebelActorRoof", RebelActorRoof)
  prgdbg(li, 1, 40)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 6000, false, false, point(150695, 151795, 18813), point(148189, 154692, 22027), false, false, 4200, 1300, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 41)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 500)
  prgdbg(li, 1, 42)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "PantagruelFirstEnter_BanterDone", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "PantagruelChimurenga_Setpiece"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 45)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "PantagruelFirstEnter_BanterDone")
  prgdbg(li, 1, 46)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 100)
  prgdbg(li, 1, 47)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 48)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
