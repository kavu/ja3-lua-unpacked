rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.Landsbach_SigfriedAttack(seed, state, TriggerUnits)
  local li = {
    id = "Landsbach_SigfriedAttack"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 300)
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
          Prop = "SigfriedBattle",
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
  prgdbg(li, 1, 5)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 300)
  local _, Bounce
  prgdbg(li, 1, 6)
  _, Bounce = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Bounce, "", "BounceEnemy", "Object", false)
  local _, Gunther
  prgdbg(li, 1, 7)
  _, Gunther = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Gunther, "", "Gunther", "Object", false)
  local _, Doorknob
  prgdbg(li, 1, 8)
  _, Doorknob = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Doorknob, "", "DoorknobEnemy", "Object", false)
  local _, NightClubThug1
  prgdbg(li, 1, 9)
  _, NightClubThug1 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NightClubThug1, "", "NightClubThug1", "Object", false)
  local _, NightClubThug2
  prgdbg(li, 1, 10)
  _, NightClubThug2 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NightClubThug2, "", "NightClubThug2", "Object", false)
  local _, NightClubThug3
  prgdbg(li, 1, 11)
  _, NightClubThug3 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NightClubThug3, "", "NightClubThug3", "Object", false)
  local _, NightClubThug4
  prgdbg(li, 1, 12)
  _, NightClubThug4 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NightClubThug4, "", "NightClubThug4", "Object", false)
  local _, NightClubThug5
  prgdbg(li, 1, 13)
  _, NightClubThug5 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NightClubThug5, "", "NightClubThug5", "Object", false)
  local _, NightClubThug6
  prgdbg(li, 1, 14)
  _, NightClubThug6 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NightClubThug6, "", "NightClubThug6", "Object", false)
  local _, NightClubThug7
  prgdbg(li, 1, 15)
  _, NightClubThug7 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NightClubThug7, "", "NightClubThug7", "Object", false)
  local _, NightClubThug8
  prgdbg(li, 1, 16)
  _, NightClubThug8 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NightClubThug8, "", "NightClubThug8", "Object", false)
  prgdbg(li, 1, 17)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Bounce, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 18)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Doorknob, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 19)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NightClubThug1, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 20)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NightClubThug2, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 21)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NightClubThug3, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 22)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NightClubThug4, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 23)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NightClubThug5, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 24)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NightClubThug6, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 25)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NightClubThug7, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 26)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", NightClubThug8, "", true, "ar_Crouch_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 27)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "1st Scene", 0, 5000)
  prgdbg(li, 1, 28)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "1st Scene", "Max", "", "harmonic", "linear", 5500, false, false, point(139911, 160134, 10462), point(135205, 158569, 11095), point(142396, 160422, 10047), point(137602, 159187, 10745), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
  local _, SmileyRunOut
  prgdbg(li, 1, 29)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Bounce, "Bounce_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 30)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Doorknob, "Doorknob_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 31)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NightClubThug1, "Merc3_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 32)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NightClubThug2, "Merc1_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 33)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NightClubThug3, "NightClubThug6_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 34)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NightClubThug4, "NightClubThug2_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 35)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NightClubThug5, "NightClubThug7_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 36)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NightClubThug6, "Merc6_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 37)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NightClubThug4, "NightClubThug4_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 38)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NightClubThug7, "Merc4_Go_To_01", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 39)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NightClubThug8, "NightClubThug3_Go_To_01", true, false, false, "Crouch", false, false, "")
  prgdbg(li, 1, 40)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5500)
  prgdbg(li, 1, 41)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "2nd Scene", "Max", "", "harmonic", "linear", 10000, false, false, point(177493, 164540, 8999), point(182007, 166303, 10228), point(184744, 160549, 8434), point(189259, 162312, 9664), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
  prgdbg(li, 1, 42)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "2nd Scene", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "Landsbach_Bounce03"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 43)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "2nd Scene")
  prgdbg(li, 1, 44)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "3rd Scene", "Tac", "", "harmonic", "linear", 1700, false, false, point(185121, 166277, 12853), point(187430, 170344, 14623), point(185121, 166276, 12853), point(187430, 170344, 14623), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
  prgdbg(li, 1, 45)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1700)
  prgdbg(li, 1, 46)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, false, "BouneShooting", Bounce, "Point", nil, "Torso", "BounceShooting", 3, 0, 0, 100, 0, 0)
  prgdbg(li, 1, 47)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 500)
  prgdbg(li, 1, 48)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", Doorknob, "Point", nil, "Torso", "DoorknobShooting", 3, 0, 0, 100, 0, 0)
  prgdbg(li, 1, 49)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", NightClubThug1, "Point", nil, "Torso", "Thug_01Shooting", 3, 0, 0, 100, 0, 0)
  prgdbg(li, 1, 50)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", NightClubThug2, "Point", nil, "Torso", "DoorknobShooting", 3, 0, 0, 100, 0, 0)
  prgdbg(li, 1, 51)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1)
  prgdbg(li, 1, 52)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, false, "", Doorknob, "Point", nil, "Torso", "DoorknobShooting", 3, 0, 0, 100, 0, 0)
  prgdbg(li, 1, 53)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "BouneShooting")
  prgdbg(li, 1, 54)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 2000)
  prgdbg(li, 1, 55)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 500)
  prgdbg(li, 1, 56)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("ForceResetAmbientLife", {})
  })
  prgdbg(li, 1, 57)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
