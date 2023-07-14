rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.FortressBasement_FirstEnter(seed, state, TriggerUnits)
  local li = {
    id = "FortressBasement_FirstEnter"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  prgdbg(li, 1, 2)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("MusicSetTrack", {
      Playlist = "Scripted",
      Track = "Music/Cat & Mouse"
    })
  })
  local _, Corazone
  prgdbg(li, 1, 3)
  _, Corazone = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Corazone, "", "CorazonSantiago", "Object", false)
  local _, Guard1
  prgdbg(li, 1, 4)
  _, Guard1 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Guard1, "", "AdonisActor1", "Object", false)
  local _, Guard2
  prgdbg(li, 1, 5)
  _, Guard2 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Guard2, "", "AdonisActor2", "Object", false)
  local _, Guard3
  prgdbg(li, 1, 6)
  _, Guard3 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Guard3, "", "AdonisActor3", "Object", false)
  local _, SP_CorazonePortStart
  prgdbg(li, 1, 7)
  _, SP_CorazonePortStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Corazone, "SP_CorazonePortStart", true)
  prgdbg(li, 1, 8)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Corazone, "", true, "ar_Standing_Suspicious", 1250, 0, range(1, 1), 0, false, true, false, "")
  local _, SP_Guard1PortStart
  prgdbg(li, 1, 9)
  _, SP_Guard1PortStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Guard1, "SP_Guard1PortStart", true)
  local _, SP_Guard2PortStart
  prgdbg(li, 1, 10)
  _, SP_Guard2PortStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Guard2, "SP_Guard2PortStart", true)
  prgdbg(li, 1, 11)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Tac", 8, "", "linear", 8000, false, false, point(149750, 113400, 6950), point(154087, 98301, 17950), point(148462, 117886, 6950), point(152798, 102788, 17950), 4200, 1000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 12)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 0, 1500)
  prgdbg(li, 1, 13)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 2000)
  prgdbg(li, 1, 14)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "FortCorazon03_setpiece"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 15)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 6000)
  prgdbg(li, 1, 16)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Corazone, "", true, "ar_Standing_CombatBegin3", 1250, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 17)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Guard3, "", true, "ar_Standing_Aim", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 18)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1700)
  prgdbg(li, 1, 19)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 1200)
  prgdbg(li, 1, 20)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Tac", 22, "", "linear", 8000, false, false, point(151069, 124318, 6950), point(155405, 109220, 17950), point(150734, 137183, 6950), point(155070, 122085, 17950), 4200, 1000, {floor = 0}, 0, 0, 0, 0, 0, 0, "Default", 100)
  local _, SP_Corazone_TP
  prgdbg(li, 1, 21)
  _, SP_Corazone_TP = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Corazone, "SP_Corazone_TP", true)
  local _, SP_CorazoneGoTo
  prgdbg(li, 1, 22)
  _, SP_CorazoneGoTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Corazone, "SP_CorazoneGoTo", true, true, false, "Standing", true, false, "")
  prgdbg(li, 1, 23)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 400)
  local _, SP_Guard1GoTo
  prgdbg(li, 1, 24)
  _, SP_Guard1GoTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Guard1, "SP_Guard1GoTo", true, true, false, "Standing", false, false, "")
  local _, SP_Guard2GoTo
  prgdbg(li, 1, 25)
  _, SP_Guard2GoTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Guard2, "SP_Guard2GoTo", true, true, false, "", false, false, "")
  prgdbg(li, 1, 26)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 600)
  prgdbg(li, 1, 27)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 0, 1500)
  prgdbg(li, 1, 28)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 200)
  prgdbg(li, 1, 29)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Guard1, "", true, "ar_Standing_Aim", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 30)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 250)
  prgdbg(li, 1, 31)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Guard2, "", true, "ar_Standing_Aim", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 32)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "FortCorazon04_setpiece"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 33)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 3700)
  prgdbg(li, 1, 34)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Corazone, "", true, "ar_Standing_Suspicious", 900, 35000, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 35)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 15000)
  prgdbg(li, 1, 36)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  local _, SP_CorazonePortEnd
  prgdbg(li, 1, 37)
  _, SP_CorazonePortEnd = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Corazone, "SP_CorazonePortEnd", true)
  prgdbg(li, 1, 38)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
