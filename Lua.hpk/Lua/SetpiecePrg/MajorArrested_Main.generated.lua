rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.MajorArrested_Main(seed, state, TriggerUnits)
  local li = {
    id = "MajorArrested_Main"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 300)
  prgdbg(li, 1, 2)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("ConditionalEffect", {
      "Conditions",
      {
        PlaceObj("SetpieceIsTestMode", {})
      },
      "Effects",
      {
        PlaceObj("QuestSetVariableBool", {
          Prop = "MajorJail",
          QuestId = "05_TakeDownMajor"
        })
      }
    })
  })
  prgdbg(li, 1, 3)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("MusicSetTrack", {
      Playlist = "Scripted",
      Track = "Music/Walled Garden"
    }),
    PlaceObj("NpcUnitTakeItem", {ItemId = "AK74", TargetUnit = "TheMajor"})
  })
  prgdbg(li, 1, 4)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 0, false, false, point(139786, 123195, 13831), point(134783, 138085, 24831), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
  local _, Major
  prgdbg(li, 1, 5)
  _, Major = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Major, "Major", "TheMajor", "Object", false)
  prgdbg(li, 1, 6)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", Major, "Standing", "No Weapon", false)
  local _, SP_MajorPort
  prgdbg(li, 1, 7)
  _, SP_MajorPort = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Major, "SP_MajorPort", true)
  prgdbg(li, 1, 8)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Major, "SP_MajorGoTo", false, "civ_Standing_Walk4", 600, 7000, range(1, 1), 0, true, true, false, "")
  local _, MilitiaGuardA
  prgdbg(li, 1, 9)
  _, MilitiaGuardA = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, MilitiaGuardA, "", "MajorArrested_GuardA", "Object", false)
  local _, MilitiaGuardB
  prgdbg(li, 1, 10)
  _, MilitiaGuardB = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, MilitiaGuardB, "", "MajorArrested_GuardB", "Object", false)
  local _, MilitiaGuardC
  prgdbg(li, 1, 11)
  _, MilitiaGuardC = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, MilitiaGuardC, "", "MajorArrested_GuardC", "Object", false)
  prgdbg(li, 1, 12)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", MilitiaGuardA, "Standing", "AR15", true)
  prgdbg(li, 1, 13)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", MilitiaGuardC, "Standing", "AR15", true)
  prgdbg(li, 1, 14)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", MilitiaGuardB, "Standing", "FAMAS", true)
  local _, SP_GuardB_AimSpot
  prgdbg(li, 1, 15)
  _, SP_GuardB_AimSpot = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, MilitiaGuardB, "SP_GuardB_AimSpot", true)
  local _, SP_GuardA_Port
  prgdbg(li, 1, 16)
  _, SP_GuardA_Port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, MilitiaGuardA, "SP_GuardA_Port", true)
  local _, SP_GuardC_Port
  prgdbg(li, 1, 17)
  _, SP_GuardC_Port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, MilitiaGuardC, "SP_GuardC_Port", true)
  prgdbg(li, 1, 18)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MilitiaGuardB, "", true, "ar_Standing_Aim", 1000, 0, range(1, 1), 0, false, true, false, "")
  local _, SP_GuardB_EscortEnd
  prgdbg(li, 1, 19)
  _, SP_GuardB_EscortEnd = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", MilitiaGuardB, "SP_GuardB_EscortEnd", true, false, false, "Standing", true, true, "")
  prgdbg(li, 1, 20)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 1500)
  prgdbg(li, 1, 21)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", 0, "linear", "linear", 6000, false, false, point(139786, 123195, 13831), point(134783, 138085, 24831), point(141784, 118200, 12786), point(136781, 133090, 23786), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 22)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 23)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 0, false, false, point(144948, 115804, 14168), point(147789, 116255, 15018), false, false, 4200, 1300, {floor = 0}, 0, 0, 0, 0, 0, 0, "Show all", 100)
  local _, SP_MajorTied
  prgdbg(li, 1, 24)
  _, SP_MajorTied = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Major, "SP_MajorTied", true)
  local _, SP_GuardB_ArmoryPos
  prgdbg(li, 1, 25)
  _, SP_GuardB_ArmoryPos = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, MilitiaGuardA, "SP_GuardB_ArmoryPos", true)
  prgdbg(li, 1, 26)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Major, "", true, "civ_Tied_IdlePassive", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 27)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", MilitiaGuardA, "", true, "ar_Standing_IdlePassive3", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 28)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 2500)
  prgdbg(li, 1, 29)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 3000)
  prgdbg(li, 1, 30)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 2500)
  prgdbg(li, 1, 31)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Tac", "", "", "linear", 0, false, false, point(139786, 123195, 13831), point(134783, 138085, 24831), false, false, 4200, 1300, {floor = 0}, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 32)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
