rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.Landsbach_BounceAttack(seed, state, TriggerUnits)
  local li = {
    id = "Landsbach_BounceAttack"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  prgdbg(li, 1, 2)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("UnitsDespawnAmbientLife", {})
  })
  prgdbg(li, 1, 3)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("ConditionalEffect", {
      "Conditions",
      {
        PlaceObj("SetpieceIsTestMode", {})
      },
      "Effects",
      {
        PlaceObj("QuestSetVariableBool", {
          Prop = "BounceBattle",
          QuestId = "Landsbach"
        })
      }
    })
  })
  prgdbg(li, 1, 4)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("MusicSetTrack", {
      Playlist = "Scripted",
      Track = "Music/The Stage is set"
    })
  })
  local _, Merc1
  prgdbg(li, 1, 5)
  _, Merc1 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc1, "", 1, 1)
  local _, Merc2
  prgdbg(li, 1, 6)
  _, Merc2 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc2, "", 1, 2)
  local _, Merc3
  prgdbg(li, 1, 7)
  _, Merc3 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc3, "", 1, 3)
  local _, Merc4
  prgdbg(li, 1, 8)
  _, Merc4 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc4, "", 1, 4)
  local _, Merc5
  prgdbg(li, 1, 9)
  _, Merc5 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc5, "", 1, 5)
  local _, Merc6
  prgdbg(li, 1, 10)
  _, Merc6 = sprocall(SetpieceAssignFromSquad.Exec, SetpieceAssignFromSquad, state, rand, Merc6, "", 1, 6)
  prgdbg(li, 1, 11)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc1, "Merc1_Start_Loc", true)
  prgdbg(li, 1, 12)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc2, "Merc2_Start_Loc", true)
  prgdbg(li, 1, 13)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc3, "Merc3_Start_Loc", true)
  prgdbg(li, 1, 14)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc4, "Merc4_Start_Loc", true)
  prgdbg(li, 1, 15)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc5, "Merc5_Start_Loc", true)
  prgdbg(li, 1, 16)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Merc6, "Merc6_Start_Loc", true)
  local _, Bounce
  prgdbg(li, 1, 17)
  _, Bounce = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Bounce, "", "BounceDiesel", "Object", false)
  local _, Doorknob
  prgdbg(li, 1, 18)
  _, Doorknob = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Doorknob, "", "DoorknobDiesel", "Object", false)
  local _, OldMan_Guard1
  prgdbg(li, 1, 19)
  _, OldMan_Guard1 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, OldMan_Guard1, "", "OldMan_Guard1", "Object", false)
  local _, OldMan_Guard2
  prgdbg(li, 1, 20)
  _, OldMan_Guard2 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, OldMan_Guard2, "", "OldMan_Guard2", "Object", false)
  local _, OldMan_Guard3
  prgdbg(li, 1, 21)
  _, OldMan_Guard3 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, OldMan_Guard3, "", "OldMan_Guard3", "Object", false)
  local _, OldMan_Guard4
  prgdbg(li, 1, 22)
  _, OldMan_Guard4 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, OldMan_Guard4, "", "OldMan_Guard4", "Object", false)
  local _, OldMan_Guard5
  prgdbg(li, 1, 23)
  _, OldMan_Guard5 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, OldMan_Guard5, "", "OldMan_Guard5", "Object", false)
  prgdbg(li, 1, 24)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, OldMan_Guard1, "OldMan_Guard_01", true)
  prgdbg(li, 1, 25)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, OldMan_Guard2, "OldMan_Guard_02", true)
  prgdbg(li, 1, 26)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, OldMan_Guard3, "OldMan_Guard_03", true)
  prgdbg(li, 1, 27)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, OldMan_Guard4, "OldMan_Guard_04", true)
  prgdbg(li, 1, 28)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, OldMan_Guard5, "OldMan_Guard_05", true)
  local _, NightClubThug1
  prgdbg(li, 1, 29)
  _, NightClubThug1 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NightClubThug1, "", "NightClubThugDiesel1", "Object", false)
  local _, NightClubThug2
  prgdbg(li, 1, 30)
  _, NightClubThug2 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NightClubThug2, "", "NightClubThugDiesel2", "Object", false)
  local _, NightClubThug3
  prgdbg(li, 1, 31)
  _, NightClubThug3 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NightClubThug3, "", "NightClubThugDiesel3", "Object", false)
  local _, NightClubThug4
  prgdbg(li, 1, 32)
  _, NightClubThug4 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NightClubThug4, "", "NightClubThugDiesel4", "Object", false)
  local _, NightClubThug5
  prgdbg(li, 1, 33)
  _, NightClubThug5 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NightClubThug5, "", "NightClubThugDiesel5", "Object", false)
  local _, NightClubThug6
  prgdbg(li, 1, 34)
  _, NightClubThug6 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NightClubThug6, "", "NightClubThugDiesel6", "Object", false)
  local _, NightClubThug7
  prgdbg(li, 1, 35)
  _, NightClubThug7 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NightClubThug7, "", "NightClubThugDiesel7", "Object", false)
  local _, NightClubThug8
  prgdbg(li, 1, 36)
  _, NightClubThug8 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NightClubThug8, "", "NightClubThugDiesel8", "Object", false)
  prgdbg(li, 1, 37)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Merc1, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 38)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Merc2, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 39)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Merc3, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 40)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Merc4, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 41)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Merc5, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 42)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Merc6, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 43)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Bounce, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 44)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Doorknob, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 45)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NightClubThug1, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 46)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NightClubThug2, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 47)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NightClubThug3, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 48)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NightClubThug4, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 49)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NightClubThug5, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 50)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NightClubThug6, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 51)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NightClubThug7, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 52)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NightClubThug8, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 53)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "Landsbach_Bounce02"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 54)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "1st Scene", 0, 5000)
  prgdbg(li, 1, 55)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "1st Scene", "Max", "", "linear", "linear", 6500, false, false, point(139911, 160134, 10462), point(135205, 158569, 11095), point(139911, 160134, 10462), point(135205, 158569, 11095), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 56)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "1st Scene")
  prgdbg(li, 1, 57)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "harmonic", "linear", 8000, false, false, point(139911, 160134, 10462), point(135205, 158569, 11095), point(142396, 160422, 10047), point(137602, 159187, 10745), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
  local _, SmileyRunOut
  prgdbg(li, 1, 58)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Bounce, "Bounce_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 59)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Doorknob, "Doorknob_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 60)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NightClubThug1, "NightClubThug1_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 61)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NightClubThug2, "NightClubThug2_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 62)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NightClubThug3, "NightClubThug3_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 63)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NightClubThug4, "NightClubThug4_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 64)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NightClubThug5, "NightClubThug5_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 65)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NightClubThug6, "NightClubThug6_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 66)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NightClubThug7, "NightClubThug7_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 67)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NightClubThug8, "NightClubThug8_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 68)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Merc1, "Merc1_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 69)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Merc2, "Merc2_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 70)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Merc3, "Merc3_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 71)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Merc4, "Merc4_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 72)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Merc5, "Merc5_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 73)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Merc6, "Merc6_Go_To_01", true, false, false, "Crouch", false, false, "")
  prgdbg(li, 1, 74)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 8000)
  prgdbg(li, 1, 75)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "2nd Scene", "Max", "", "harmonic", "linear", 11500, false, false, point(184448, 165707, 12987), point(187168, 169452, 14879), point(187919, 163346, 12670), point(190638, 167090, 14562), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
  prgdbg(li, 1, 76)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "2nd Scene", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "Landsbach_Bounce03"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 77)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "2nd Scene")
  prgdbg(li, 1, 78)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", Bounce, "Point", nil, "Torso", "OldMan_Guard_01", 3, 0, 0, 100, 0, 0)
  prgdbg(li, 1, 79)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", Doorknob, "Point", nil, "Torso", "OldMan_Guard_05", 3, 0, 0, 100, 0, 0)
  prgdbg(li, 1, 80)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 2000)
  prgdbg(li, 1, 81)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 500)
  prgdbg(li, 1, 82)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("ForceResetAmbientLife", {})
  })
  prgdbg(li, 1, 83)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
