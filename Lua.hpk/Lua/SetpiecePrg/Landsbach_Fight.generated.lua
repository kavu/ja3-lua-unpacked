rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.Landsbach_Fight(seed, state, TriggerUnits)
  local li = {
    id = "Landsbach_Fight"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  prgdbg(li, 1, 2)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", TriggerUnits, "", true, "civ_Ambient_Cheering", 1000, 0, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 3)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 500)
  prgdbg(li, 1, 4)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 5500)
  prgdbg(li, 1, 5)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "", {
    PlaceObj("MusicSetTrack", {
      Playlist = "Scripted",
      Track = "Music/Gunpowder and Tobacco"
    })
  })
  prgdbg(li, 1, 6)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", 2, "decelerated", "spherical", 27000, false, false, point(151304, 149305, 14432), point(147097, 149297, 17134), point(155819, 149134, 12216), point(153271, 149129, 13802), 4200, 1300, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
  prgdbg(li, 1, 7)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 3000)
  prgdbg(li, 1, 8)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "Landsbach_Referee01"
      },
      searchInMap = true,
      searchInMarker = false
    }),
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "Landsbach_Referee04"
      },
      searchInMap = true,
      searchInMarker = false
    }),
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "Landsbach_Referee05"
      },
      searchInMap = true,
      searchInMarker = false
    }),
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "Landsbach_Referee06"
      },
      searchInMap = true,
      searchInMarker = false
    }),
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "Landsbach_Referee08"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 9)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "Landsbach_Referee02"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 10)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "Landsbach_Fight_Camera2", nil)
  prgdbg(li, 1, 11)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "Landsbach_Referee03"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 12)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", TriggerUnits, "Standing", "Current Weapon", false)
  prgdbg(li, 1, 13)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 1500)
  prgdbg(li, 1, 14)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Tac", "", "", "linear", 0, false, false, point(163246, 149824, 6960), point(147536, 149776, 17960), false, false, 4200, 2000, {floor = 0}, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 15)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 500)
  prgdbg(li, 1, 16)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
