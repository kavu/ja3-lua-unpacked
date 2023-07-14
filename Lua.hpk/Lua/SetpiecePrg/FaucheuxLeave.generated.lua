rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.FaucheuxLeave(seed, state, TriggerUnits)
  local li = {
    id = "FaucheuxLeave"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
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
          Prop = "Given",
          QuestId = "04_Betrayal"
        })
      }
    })
  })
  prgdbg(li, 1, 3)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Tac", 8, "", "linear", 3000, false, false, point(131543, 139068, 17052), point(129077, 138016, 18400), point(131543, 139068, 17052), point(129077, 138016, 18400), 4200, 1300, {floor = 0}, 0, 0, 0, 0, 0, 0, "Default", 100)
  local _, Faucheux
  prgdbg(li, 1, 4)
  _, Faucheux = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Faucheux, "", "Faucheux", "Object", false)
  prgdbg(li, 1, 5)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", Faucheux, "Standing", "Current Weapon", true)
  local _, FL_Faucheux_01
  prgdbg(li, 1, 6)
  _, FL_Faucheux_01 = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Faucheux, "FL_Faucheux_01", true)
  prgdbg(li, 1, 7)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Faucheux, "", true, "civ_Talk_ArmsDown3", 1000, 0, range(1, 1), 0, false, true, false, "")
  local _, Lieutenant
  prgdbg(li, 1, 8)
  _, Lieutenant = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Lieutenant, "", "Lieutenant", "Object", false)
  local _, FL_Liutenant_01
  prgdbg(li, 1, 9)
  _, FL_Liutenant_01 = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Lieutenant, "FL_Liutenant_01", true)
  prgdbg(li, 1, 10)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Lieutenant, "", true, "ar_Standing_IdlePassive", 1000, 0, range(1, 1), 0, false, true, false, "")
  local _, Soldier01
  prgdbg(li, 1, 11)
  _, Soldier01 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Soldier01, "", "Soldier01", "Object", false)
  local _, FL_Soldier01_01
  prgdbg(li, 1, 12)
  _, FL_Soldier01_01 = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Soldier01, "FL_Soldier01_01", true)
  prgdbg(li, 1, 13)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", Soldier01, "Standing", "Current Weapon", true)
  local _, Soldier02
  prgdbg(li, 1, 14)
  _, Soldier02 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Soldier02, "", "Soldier02", "Object", false)
  local _, FL_Soldier02_01
  prgdbg(li, 1, 15)
  _, FL_Soldier02_01 = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Soldier02, "FL_Soldier02_01", true)
  prgdbg(li, 1, 16)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", Soldier02, "Standing", "Current Weapon", true)
  local _, UAZ
  prgdbg(li, 1, 17)
  _, UAZ = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, UAZ, "", "SP_FaucheuxLeave_UAZ", "Object", false)
  prgdbg(li, 1, 18)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 0, 1500)
  prgdbg(li, 1, 19)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "Betrayal_Faucheux_SetpieceLeave"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 20)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", Faucheux, "FL_Faucheux_04", true, "civ_WalkNormal_Neutral_Start", 1000, 175, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 21)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Faucheux, "FL_Faucheux_03", true, "civ_WalkNormal_Neutral_Base", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 22)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 800)
  local _, SP_FaucheuxLeave_Soldier02_01
  prgdbg(li, 1, 23)
  _, SP_FaucheuxLeave_Soldier02_01 = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Soldier02, "SP_FaucheuxLeave_Soldier02_01", true, false, false, "", false, false, "")
  prgdbg(li, 1, 24)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 200)
  local _, SP_FaucheuxLeave_Soldier01_01
  prgdbg(li, 1, 25)
  _, SP_FaucheuxLeave_Soldier01_01 = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Soldier01, "SP_FaucheuxLeave_Soldier01_01", true, false, false, "", false, false, "")
  prgdbg(li, 1, 26)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 1000)
  prgdbg(li, 1, 27)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 0, false, false, point(170362, 130391, 10363), point(172041, 132745, 11170), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  local _, FL_Faucheux_02
  prgdbg(li, 1, 28)
  _, FL_Faucheux_02 = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Faucheux, "FL_Faucheux_02", true)
  local _, FL_Soldier01_02
  prgdbg(li, 1, 29)
  _, FL_Soldier01_02 = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Soldier01, "FL_Soldier01_02", true)
  local _, FL_Soldier02_02
  prgdbg(li, 1, 30)
  _, FL_Soldier02_02 = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Soldier02, "FL_Soldier02_02", true)
  prgdbg(li, 1, 31)
  sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Faucheux, "SP_FaucheuxLeave_02", true, false, false, "", false, false, "")
  local _, SP_FaucheuxLeave_Soldier01_03
  prgdbg(li, 1, 32)
  _, SP_FaucheuxLeave_Soldier01_03 = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Soldier01, "SP_FaucheuxLeave_Soldier01_03", true, false, false, "", false, false, "")
  local _, SP_FaucheuxLeave_Soldier02_03
  prgdbg(li, 1, 33)
  _, SP_FaucheuxLeave_Soldier02_03 = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Soldier02, "SP_FaucheuxLeave_Soldier02_03", true, false, false, "", false, false, "")
  prgdbg(li, 1, 34)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1200)
  prgdbg(li, 1, 35)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 0, 1500)
  prgdbg(li, 1, 36)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1000)
  local _, SP_FaucheuxLeave_Soldier02_04
  prgdbg(li, 1, 37)
  _, SP_FaucheuxLeave_Soldier02_04 = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Soldier02, "SP_FaucheuxLeave_Soldier02_04", true, false, false, "", false, false, "")
  prgdbg(li, 1, 38)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 700)
  prgdbg(li, 1, 39)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 1000)
  prgdbg(li, 1, 40)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, Faucheux)
  prgdbg(li, 1, 41)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, Soldier01)
  prgdbg(li, 1, 42)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, Soldier02)
  prgdbg(li, 1, 43)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, UAZ)
  prgdbg(li, 1, 44)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
