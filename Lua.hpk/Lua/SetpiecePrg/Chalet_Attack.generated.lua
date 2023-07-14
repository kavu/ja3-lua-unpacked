rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.Chalet_Attack(seed, state, TriggerUnits)
  local li = {
    id = "Chalet_Attack"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 2500)
  prgdbg(li, 1, 2)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("MusicSetTrack", {
      Playlist = "Scripted",
      Track = "Music/Entering The Village"
    })
  })
  prgdbg(li, 1, 3)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", "", "", "linear", 1, false, false, point(197085, 154692, 12184), point(201503, 156919, 12904), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  local _, DocRobert
  prgdbg(li, 1, 4)
  _, DocRobert = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, DocRobert, "", "DocRobert", "Object", false)
  local _, ChaletAttacker01
  prgdbg(li, 1, 5)
  _, ChaletAttacker01 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, ChaletAttacker01, "", "ChaletAttacker01", "Object", false)
  local _, ChaletAttacker02
  prgdbg(li, 1, 6)
  _, ChaletAttacker02 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, ChaletAttacker02, "", "ChaletAttacker02", "Object", false)
  local _, ChaletAttacker03
  prgdbg(li, 1, 7)
  _, ChaletAttacker03 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, ChaletAttacker03, "", "ChaletAttacker03", "Object", false)
  local _, ChaletAttacker04
  prgdbg(li, 1, 8)
  _, ChaletAttacker04 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, ChaletAttacker04, "", "ChaletAttacker04", "Object", false)
  local _, ChaletAttacker05
  prgdbg(li, 1, 9)
  _, ChaletAttacker05 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, ChaletAttacker05, "", "ChaletAttacker05", "Object", false)
  local _, SmileyRunOut
  prgdbg(li, 1, 10)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", ChaletAttacker04, "ChaletAttackerPos_04", true, false, false, "Crouch", false, false, "")
  local _
  prgdbg(li, 1, 11)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", ChaletAttacker05, "ChaletAttackerPos_05_A", true, false, false, "Crouch", false, false, "")
  prgdbg(li, 1, 12)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 350)
  prgdbg(li, 1, 13)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 450)
  prgdbg(li, 1, 14)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "1st Scene", 0, 2000)
  prgdbg(li, 1, 15)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "1st Scene", "Tac", "", "", "linear", 3500, false, false, point(195760, 154024, 11968), point(200178, 156251, 12688), false, false, 4200, 1300, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 17)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "1st Scene")
  local _
  prgdbg(li, 1, 18)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", ChaletAttacker01, "ChaletAttackerPos_01", true, false, false, "Crouch", false, false, "")
  prgdbg(li, 1, 19)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 350)
  local _
  prgdbg(li, 1, 20)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", ChaletAttacker02, "ChaletAttackerPos_02", true, false, false, "Crouch", false, false, "")
  prgdbg(li, 1, 21)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 450)
  local _
  prgdbg(li, 1, 22)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", ChaletAttacker03, "ChaletAttackerPos_03", true, false, false, "Crouch", false, false, "")
  prgdbg(li, 1, 23)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 1500)
  local _
  prgdbg(li, 1, 24)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", ChaletAttacker05, "ChaletAttackerPos_05_B", true, false, false, "Crouch", false, false, "")
  prgdbg(li, 1, 25)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 350)
  prgdbg(li, 1, 26)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 450)
  prgdbg(li, 1, 27)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "2nd Scene", 0, 2000)
  prgdbg(li, 1, 28)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "2nd Scene", "Tac", "", "", "linear", 5000, false, false, point(154063, 96469, 9999), point(158494, 94331, 10889), false, false, 4200, 1300, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 31)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 1500)
  prgdbg(li, 1, 32)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "2nd Scene")
  prgdbg(li, 1, 33)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "2nd Scene", 0, 2000)
  prgdbg(li, 1, 34)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "3nd Scene", "Tac", "", "", "linear", 4500, false, false, point(133926, 117799, 14356), point(130763, 114322, 16061), false, false, 4200, 1300, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 36)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "3nd Scene")
  prgdbg(li, 1, 37)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 38)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
