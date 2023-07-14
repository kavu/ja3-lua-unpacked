rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.PierreRetreat(seed, state, TriggerUnits)
  local li = {
    id = "PierreRetreat"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 300)
  local _, Pierre
  prgdbg(li, 1, 2)
  _, Pierre = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Pierre, "", "Pierre", "Object", false)
  local _, PierreGuard01
  prgdbg(li, 1, 3)
  _, PierreGuard01 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, PierreGuard01, "", "PierreGuard01", "Object", false)
  local _, PierreGuard02
  prgdbg(li, 1, 4)
  _, PierreGuard02 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, PierreGuard02, "", "PierreGuard02", "Object", false)
  local _, SP_PierrePort
  prgdbg(li, 1, 5)
  _, SP_PierrePort = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Pierre, "SP_PierrePort", true)
  prgdbg(li, 1, 6)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", Pierre, "Standing", "No Weapon", true)
  prgdbg(li, 1, 7)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, PierreGuard01, "Guard01", true)
  prgdbg(li, 1, 8)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, PierreGuard02, "Guard02", true)
  prgdbg(li, 1, 9)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", PierreGuard01, "Standing", "Current Weapon", true)
  prgdbg(li, 1, 10)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", PierreGuard02, "Standing", "Current Weapon", true)
  prgdbg(li, 1, 11)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 0, false, false, point(126394, 160539, 44844), point(121979, 159523, 46958), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 12)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 400, 700)
  prgdbg(li, 1, 13)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Pierre, "", true, "civ_Talking", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 14)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", "", "", "linear", 2200, false, false, point(126394, 160539, 44844), point(121979, 159523, 46958), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 15)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "PierreRetreat_BanterDone", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "Pierre_Retreat"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 16)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "PierreRetreat_BanterDone")
  prgdbg(li, 1, 17)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1000)
  prgdbg(li, 1, 18)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 19)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", Pierre, "Standing", "AK74", true)
  local _, PierreRetreatInside
  prgdbg(li, 1, 20)
  _, PierreRetreatInside = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Pierre, "PierreRetreatWalkTo", true, false, false, "", false, true, "")
  prgdbg(li, 1, 21)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 900)
  local _
  prgdbg(li, 1, 22)
  _, PierreRetreatInside = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", PierreGuard01, "PierreRetreatWalkTo_02", true, false, false, "", false, true, "")
  prgdbg(li, 1, 23)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 400)
  local _
  prgdbg(li, 1, 24)
  _, PierreRetreatInside = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", PierreGuard02, "PierreRetreatWalkTo_01", true, false, false, "", false, true, "")
  prgdbg(li, 1, 25)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 0, false, false, point(148701, 162474, 48121), point(152758, 163548, 50839), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 26)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 0, 900)
  prgdbg(li, 1, 27)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", "", "", "linear", 4000, false, false, point(148701, 162474, 48121), point(152758, 163548, 50839), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 28)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 1700)
  prgdbg(li, 1, 29)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Pierre, "PierreRetreatInside", true)
  prgdbg(li, 1, 30)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, PierreGuard01, "PierreRetreatInside_Guard1", true)
  prgdbg(li, 1, 31)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, PierreGuard02, "PierreRetreatInside_Guard2", true)
  prgdbg(li, 1, 32)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
