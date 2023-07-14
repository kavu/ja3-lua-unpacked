rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.BeastIntro_ActualSP(seed, state, TriggerUnits)
  local li = {
    id = "BeastIntro_ActualSP"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 4000)
  prgdbg(li, 1, 2)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 1000, 4000)
  prgdbg(li, 1, 3)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "", {
    PlaceObj("ConditionalEffect", {
      "Conditions",
      {
        PlaceObj("SetpieceIsTestMode", {})
      },
      "Effects",
      {
        PlaceObj("QuestSetVariableBool", {
          Prop = "BeastIntroTriggered",
          QuestId = "Beast"
        })
      }
    }),
    PlaceObj("MusicSetTrack", {
      Playlist = "Scripted",
      Track = "Music/Poacher's Camp"
    })
  })
  local _, Wlad
  prgdbg(li, 1, 4)
  _, Wlad = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Wlad, "SP_Wlad", "Wlad", "Object", false)
  local _, Beast
  prgdbg(li, 1, 5)
  _, Beast = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Beast, "SP_Beast", "TheBeast", "Object", false)
  local _, SP_BeastPort
  prgdbg(li, 1, 6)
  _, SP_BeastPort = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Wlad, "SP_WladPort_01", true)
  prgdbg(li, 1, 7)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Wlad, "SP_WladPort_01", true, "civ_Ambient_TinkeringBike", 1000, 9600, range(1, 1), 0, true, true, false, "")
  local _, LegionActor1
  prgdbg(li, 1, 8)
  _, LegionActor1 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionActor1, "", "BeastSP_LegionActor1", "Object", false)
  local _, LegionActor2
  prgdbg(li, 1, 9)
  _, LegionActor2 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionActor2, "", "BeastSP_LegionActor2", "Object", false)
  prgdbg(li, 1, 10)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", LegionActor1, "Standing", "Current Weapon", true)
  prgdbg(li, 1, 11)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", LegionActor2, "Standing", "Current Weapon", true)
  prgdbg(li, 1, 12)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "BeastIntro_Legion_Actors1_Walking", LegionActor1)
  prgdbg(li, 1, 13)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "BeastIntro_Legion_Actors2_Walking", LegionActor2)
  prgdbg(li, 1, 14)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", 23, "", "linear", 7500, false, false, point(115592, 139901, 13078), point(114135, 142434, 13758), point(145461, 143327, 13792), point(150057, 144682, 15221), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
  prgdbg(li, 1, 15)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 2800)
  local _, SP_Beast_WladPort
  prgdbg(li, 1, 16)
  _, SP_Beast_WladPort = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Wlad, "SP_Beast_WladPort", true)
  prgdbg(li, 1, 17)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", Wlad, "Standing", "No Weapon", true)
  local _, SP_Beast_LActor1Port
  prgdbg(li, 1, 18)
  _, SP_Beast_LActor1Port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, LegionActor1, "SP_Beast_LActor1Port", true)
  prgdbg(li, 1, 19)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", LegionActor1, "Standing", "Current Weapon", true)
  local _, SP_Beast_LActor2Port
  prgdbg(li, 1, 20)
  _, SP_Beast_LActor2Port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, LegionActor2, "SP_Beast_LActor2Port", true)
  prgdbg(li, 1, 21)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", LegionActor2, "Standing", "Current Weapon", true)
  prgdbg(li, 1, 22)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5)
  prgdbg(li, 1, 23)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 5000)
  prgdbg(li, 1, 24)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Wlad, "SP_Beast_WladPort", true, "civ_Standing_Idle2", 1000, 10000, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 25)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5)
  prgdbg(li, 1, 26)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", LegionActor1, "SP_Beast_LActor1Port", true, "civ_Talking3", 1000, 10000, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 27)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5)
  prgdbg(li, 1, 28)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", LegionActor2, "SP_Beast_LActor2Port", true, "ar_Standing_IdlePassive5", 900, 18000, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 29)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "BeasIntro_BridgeRun", Beast)
  prgdbg(li, 1, 30)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5)
  prgdbg(li, 1, 31)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 5000, false, false, point(136872, 145871, 11603), point(139431, 147420, 11843), point(137673, 121152, 12959), point(139759, 125687, 13244), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
  prgdbg(li, 1, 32)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 2000)
  prgdbg(li, 1, 33)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "IlleMoratMarauders_EffigyLitNight_setpiece"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 34)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 6000)
  prgdbg(li, 1, 35)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 2500)
  prgdbg(li, 1, 36)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 1200)
  local _
  prgdbg(li, 1, 37)
  _, SP_BeastPort = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Beast, "SP_BeastPort", true)
  local _, SP_BeastGoTo
  prgdbg(li, 1, 38)
  _, SP_BeastGoTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Beast, "SP_BeastGoTo", true, false, false, "Crouch", false, false, "")
  prgdbg(li, 1, 39)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", "", "", "linear", 5000, false, false, point(96253, 155761, 21379), point(93229, 159211, 23367), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
  prgdbg(li, 1, 40)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 2200)
  prgdbg(li, 1, 41)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5)
  prgdbg(li, 1, 42)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 2200)
  prgdbg(li, 1, 43)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "BeasIntro_BeastAiming", Beast)
  prgdbg(li, 1, 44)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", LegionActor1, "Standing", "Current Weapon", true)
  prgdbg(li, 1, 45)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", LegionActor2, "Standing", "Current Weapon", true)
  prgdbg(li, 1, 46)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Beast, "SP_BeastAim", true, "ar_Crouch_Aim", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 47)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5)
  prgdbg(li, 1, 48)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Wlad, "SP_Beast_WladPort", true, "civ_Standing_Idle2", 1000, 10000, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 49)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5)
  prgdbg(li, 1, 50)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", LegionActor1, "SP_Beast_LActor1Port", true, "civ_Talking3", 1000, 10000, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 51)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5)
  prgdbg(li, 1, 52)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", LegionActor2, "SP_Beast_LActor2Port", true, "ar_Standing_Suspicious", 800, 30000, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 53)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", 5, "", "linear", 10000, false, false, point(138909, 136905, 11473), point(142875, 133867, 11691), point(113605, 157261, 16419), point(118263, 155703, 17356), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
  prgdbg(li, 1, 54)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 14000)
  prgdbg(li, 1, 55)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 5000)
  prgdbg(li, 1, 56)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
