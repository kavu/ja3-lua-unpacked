rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.Landsbach_MadMax(seed, state, TriggerUnits)
  local li = {
    id = "Landsbach_MadMax"
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
        PlaceObj("QuestSetVariableBool", {Prop = "MadMax", QuestId = "Landsbach"})
      }
    })
  })
  local _, MolotovUnit
  prgdbg(li, 1, 3)
  _, MolotovUnit = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, MolotovUnit, "", "MolotovUnit", "Object", false)
  local _, MadMaxPunk1
  prgdbg(li, 1, 4)
  _, MadMaxPunk1 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, MadMaxPunk1, "", "MadMaxPunks1", "Object", false)
  local _, MadMaxPunk2
  prgdbg(li, 1, 5)
  _, MadMaxPunk2 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, MadMaxPunk2, "", "MadMaxPunks2", "Object", false)
  local _, MadMaxPunk3
  prgdbg(li, 1, 6)
  _, MadMaxPunk3 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, MadMaxPunk3, "", "MadMaxPunks3", "Object", false)
  local _, MadMaxPunk4
  prgdbg(li, 1, 7)
  _, MadMaxPunk4 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, MadMaxPunk4, "", "MadMaxPunks4", "Object", false)
  local _, MadMaxPunk5
  prgdbg(li, 1, 8)
  _, MadMaxPunk5 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, MadMaxPunk5, "", "MadMaxPunks5", "Object", false)
  local _, MadMaxPunk6
  prgdbg(li, 1, 9)
  _, MadMaxPunk6 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, MadMaxPunk6, "", "MadMaxPunks6", "Object", false)
  local _, MadMaxPunk7
  prgdbg(li, 1, 10)
  _, MadMaxPunk7 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, MadMaxPunk7, "", "MadMaxPunks7", "Object", false)
  local _, MadMaxPunk8
  prgdbg(li, 1, 11)
  _, MadMaxPunk8 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, MadMaxPunk8, "", "MadMaxPunks8", "Object", false)
  local _, MadMaxPunk9
  prgdbg(li, 1, 12)
  _, MadMaxPunk9 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, MadMaxPunk9, "", "MadMaxPunks9", "Object", false)
  local _, MadMaxPunk10
  prgdbg(li, 1, 13)
  _, MadMaxPunk10 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, MadMaxPunk10, "", "MadMaxPunks10", "Object", false)
  local _, MadMaxPunk11
  prgdbg(li, 1, 14)
  _, MadMaxPunk11 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, MadMaxPunk11, "", "MadMaxPunks11", "Object", false)
  prgdbg(li, 1, 15)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "", {
    PlaceObj("MusicSetTrack", {
      Playlist = "Scripted",
      Track = "Music/Hunters And Prey"
    })
  })
  prgdbg(li, 1, 16)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MolotovUnit, "", true, "ar_Standing_IdlePassive", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 17)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MadMaxPunk1, "", true, "civ_Ambient_FindSomething", 1000, 0, range(5, 5), 0, false, true, false, "")
  prgdbg(li, 1, 18)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MadMaxPunk3, "", true, "ar_Standing_IdlePassive3", 1000, 0, range(5, 5), 0, true, true, false, "")
  prgdbg(li, 1, 19)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MadMaxPunk4, "", true, "ar_Standing_IdlePassive4", 1000, 0, range(5, 5), 0, true, true, false, "")
  prgdbg(li, 1, 20)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MadMaxPunk5, "", true, "hg_Standing_IdlePassive5", 1000, 0, range(5, 5), 0, true, true, false, "")
  prgdbg(li, 1, 21)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MadMaxPunk6, "", true, "hg_Standing_IdlePassive6", 1000, 0, range(5, 5), 0, true, true, false, "")
  prgdbg(li, 1, 22)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MadMaxPunk7, "", true, "ar_Standing_IdlePassive", 1000, 0, range(5, 5), 0, true, true, false, "")
  prgdbg(li, 1, 23)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MadMaxPunk8, "", true, "ar_Standing_IdlePassive2", 1000, 0, range(5, 5), 0, true, true, false, "")
  prgdbg(li, 1, 24)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MadMaxPunk9, "", true, "ar_Standing_IdlePassive3", 1000, 0, range(5, 5), 0, true, true, false, "")
  prgdbg(li, 1, 25)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MadMaxPunk10, "", true, "ar_Standing_IdlePassive4", 1000, 0, range(5, 5), 0, true, true, false, "")
  prgdbg(li, 1, 26)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MadMaxPunk11, "", true, "ar_Standing_IdlePassive5", 1000, 0, range(5, 5), 0, true, true, false, "")
  prgdbg(li, 1, 27)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 500)
  prgdbg(li, 1, 28)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", 0, "linear", "linear", 12000, false, false, point(102350, 148360, 9838), point(99409, 148664, 9325), point(101790, 142972, 9838), point(98849, 143276, 9325), 4200, 650, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 29)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 2000)
  prgdbg(li, 1, 30)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 9500)
  prgdbg(li, 1, 31)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 2000)
  local _, SP_MolotovUnit_TP
  prgdbg(li, 1, 32)
  _, SP_MolotovUnit_TP = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, MolotovUnit, "SP_MolotovUnit_TP", true)
  local _, SP_MolotovUnit_GoTo
  prgdbg(li, 1, 33)
  _, SP_MolotovUnit_GoTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", MolotovUnit, "SP_MolotovUnit_GoTo", true, false, false, "Standing", true, false, "")
  prgdbg(li, 1, 34)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 750)
  prgdbg(li, 1, 35)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 3000)
  prgdbg(li, 1, 36)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", 0, "linear", "linear", 12000, false, false, point(147354, 173916, 10582), point(147161, 176904, 10377), point(158973, 174674, 10582), point(158780, 177662, 10377), 4200, 650, false, 75, 0, 15000, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 37)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 8500)
  prgdbg(li, 1, 38)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 3000)
  prgdbg(li, 1, 39)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 250)
  prgdbg(li, 1, 40)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Tac", 4, "harmonic", "linear", 10000, false, false, point(185011, 149260, 8808), point(189984, 149759, 8658), point(171807, 147941, 9203), point(174792, 148237, 9116), 4200, 650, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 41)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 750)
  prgdbg(li, 1, 42)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MolotovUnit, "", true, "ar_Standing_IdlePassive3", 200, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 43)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MadMaxPunk3, "", true, "ar_Crouch_To_Standing_Aim", 125, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 44)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MadMaxPunk4, "", true, "ar_Standing_CombatBegin3", 225, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 45)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MadMaxPunk5, "", true, "hg_Standing_To_Crouch", 50, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 46)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MadMaxPunk6, "", true, "hg_Standing_Aim", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 47)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MadMaxPunk7, "", true, "ar_Crouch_Aim", 1000, 0, range(5, 5), 0, true, true, false, "")
  prgdbg(li, 1, 48)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MadMaxPunk8, "", true, "ar_Crouch_Aim", 1000, 0, range(5, 5), 0, true, true, false, "")
  prgdbg(li, 1, 49)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MadMaxPunk9, "", true, "ar_Standing_Idle2", 325, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 50)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MadMaxPunk10, "", true, "ar_Standing_Idle3", 200, 0, range(5, 5), 0, true, true, false, "")
  prgdbg(li, 1, 51)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MadMaxPunk11, "", true, "ar_Standing_Aim", 200, 0, range(5, 5), 0, false, true, false, "")
  prgdbg(li, 1, 52)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 2000)
  prgdbg(li, 1, 53)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Tac", 4, "harmonic", "linear", 9600, false, false, point(185011, 149260, 8808), point(189984, 149759, 8658), point(171807, 147941, 9203), point(174792, 148237, 9116), 4200, 650, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 54)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 9000)
  prgdbg(li, 1, 55)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 2000)
  prgdbg(li, 1, 56)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 750)
  prgdbg(li, 1, 57)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
