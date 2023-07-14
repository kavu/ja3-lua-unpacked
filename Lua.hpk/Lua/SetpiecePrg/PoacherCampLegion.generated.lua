rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.PoacherCampLegion(seed, state, TriggerUnits)
  local li = {
    id = "PoacherCampLegion"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  prgdbg(li, 1, 2)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("ConditionalEffect", {
      "Conditions",
      {
        PlaceObj("SetpieceIsTestMode", {})
      },
      "Effects",
      {
        PlaceObj("UnitSetConflictIgnore", {
          TargetUnit = "AbuserPoacher_All"
        }),
        PlaceObj("UnitSetConflictIgnore", {
          TargetUnit = "Poachers_All"
        }),
        PlaceObj("UnitSetConflictIgnore", {
          TargetUnit = "PoacherRifles"
        })
      }
    })
  })
  prgdbg(li, 1, 3)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 50)
  prgdbg(li, 1, 4)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 0, false, false, point(128664, 165644, 9574), point(126210, 165705, 7847), false, false, 4200, 2000, {floor = 0}, 0, 0, 0, 0, 0, 0, "Default", 100)
  local _, Poacher01
  prgdbg(li, 1, 5)
  _, Poacher01 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Poacher01, "", "PoacherActor01", "Object", false)
  local _, SP_Poacher01_TP
  prgdbg(li, 1, 6)
  _, SP_Poacher01_TP = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Poacher01, "SP_Poacher01_TP", true)
  prgdbg(li, 1, 7)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Poacher01, "SP_Poacher01_TP", true, "civ_Wall_Idle", 1000, 30, range(1, 1), 0, false, true, false, "")
  local _, Poacher02
  prgdbg(li, 1, 8)
  _, Poacher02 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Poacher02, "", "PoacherActor02", "Object", false)
  local _, SP_Poacher02_TP
  prgdbg(li, 1, 9)
  _, SP_Poacher02_TP = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Poacher02, "SP_Poacher02_TP", true)
  prgdbg(li, 1, 10)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Poacher02, "SP_Poacher02_TP", true, "civ_Talk_HandsOnHips", 1000, 30, range(1, 1), 0, false, true, false, "")
  local _, Poacher03
  prgdbg(li, 1, 11)
  _, Poacher03 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Poacher03, "", "PoacherActor03", "Object", false)
  local _, SP_Poacher03_TP
  prgdbg(li, 1, 12)
  _, SP_Poacher03_TP = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Poacher03, "SP_Poacher03_TP", true)
  prgdbg(li, 1, 13)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Poacher03, "SP_Poacher03_TP", true, "civ_Talk_ArmsDown", 1000, 30, range(1, 1), 0, false, true, false, "")
  local _, Poacher04
  prgdbg(li, 1, 14)
  _, Poacher04 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Poacher04, "", "PoacherActor04", "Object", false)
  local _, SP_Poacher04_TP
  prgdbg(li, 1, 15)
  _, SP_Poacher04_TP = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Poacher04, "SP_Poacher04_TP", true)
  prgdbg(li, 1, 16)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Poacher04, "SP_Poacher04_TP", true, "civ_Ambient_Weeding", 1000, 30, range(1, 1), 0, false, true, false, "")
  local _, Poacher05
  prgdbg(li, 1, 17)
  _, Poacher05 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Poacher05, "", "PoacherActor05", "Object", false)
  local _, SP_Poacher05_TP
  prgdbg(li, 1, 18)
  _, SP_Poacher05_TP = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Poacher05, "SP_Poacher05_TP", true)
  prgdbg(li, 1, 19)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Poacher05, "SP_Poacher05_TP", true, "civ_Ambient_LeanAgainstWall_RHand", 1000, 30, range(1, 1), 0, false, true, false, "")
  local _, Hyena
  prgdbg(li, 1, 20)
  _, Hyena = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Hyena, "", "Hyena", "Object", false)
  local _, SetPiece_HeynaStart
  prgdbg(li, 1, 21)
  _, SetPiece_HeynaStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Hyena, "SetPiece_HeynaStart", true)
  prgdbg(li, 1, 22)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Hyena, "", true, "civ_Talk_ArmsDown5", 1000, 0, range(1, 1), 0, false, true, false, "")
  local _, LegionLeader_Male
  prgdbg(li, 1, 23)
  _, LegionLeader_Male = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionLeader_Male, "LegionLeader", "LegionLeader_Male", "Object", false)
  local _, SetPiece_LegionLeaderStart
  prgdbg(li, 1, 24)
  _, SetPiece_LegionLeaderStart = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, LegionLeader_Male, "SetPiece_LegionLeaderStart", true)
  prgdbg(li, 1, 25)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", LegionLeader_Male, "", true, "civ_Talk_FootOnChair", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 26)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 100, 1500)
  prgdbg(li, 1, 27)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 3500)
  prgdbg(li, 1, 28)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 1500)
  prgdbg(li, 1, 29)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", "", "", "linear", 400, false, false, point(178407, 155888, 14523), point(180409, 158087, 14915), false, false, 4200, 2000, {floor = 0}, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 30)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 100, 1500)
  prgdbg(li, 1, 31)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 3700)
  prgdbg(li, 1, 32)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 1500)
  prgdbg(li, 1, 33)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Hyena, "", true, "civ_Talk_HandsOnHips6", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 34)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Tac", 9, "", "linear", 100, false, false, point(166784, 143854, 10126), point(163629, 147415, 11667), point(165837, 144923, 10588), point(162682, 148483, 12129), 4200, 1300, {floor = 0}, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 35)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 800)
  prgdbg(li, 1, 36)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 1500)
  prgdbg(li, 1, 37)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 2000)
  prgdbg(li, 1, 38)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "PoacherCamp_Legion"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 39)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1000)
  prgdbg(li, 1, 40)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 1000)
  prgdbg(li, 1, 41)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 100)
  prgdbg(li, 1, 42)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
