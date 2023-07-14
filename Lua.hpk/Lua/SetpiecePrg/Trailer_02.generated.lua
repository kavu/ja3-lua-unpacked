rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.Trailer_02(seed, state, TriggerUnits)
  local li = {id = "Trailer_02"}
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, Thug1
  prgdbg(li, 1, 1)
  _, Thug1 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Thug1, "Thug1", "ThugActor1", "Object", false)
  local _, Thug2
  prgdbg(li, 1, 2)
  _, Thug2 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Thug2, "Thug2", "ThugActor2", "Object", false)
  local _, Thug3
  prgdbg(li, 1, 3)
  _, Thug3 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Thug3, "Thug3", "ThugActor3", "Object", false)
  local _, Thug1_Start
  prgdbg(li, 1, 4)
  _, Thug1_Start = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Thug1, "Thug1_Start", true)
  local _
  prgdbg(li, 1, 5)
  _, Thug1_Start = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Thug2, "Thug2_Start", true)
  local _
  prgdbg(li, 1, 6)
  _, Thug1_Start = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Thug3, "Thug3_Start", true)
  local _, Thug1_WalkTo
  prgdbg(li, 1, 7)
  _, Thug1_WalkTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Thug1, "Thug1_WalkTo", true, false, false, "", false, false, "")
  local _, Thug2_WalkTo
  prgdbg(li, 1, 8)
  _, Thug2_WalkTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Thug2, "Thug2_WalkTo", true, false, false, "", false, false, "")
  local _, Thug3_WalkTo
  prgdbg(li, 1, 9)
  _, Thug3_WalkTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Thug3, "Thug3_WalkTo", true, false, false, "", false, false, "")
  prgdbg(li, 1, 10)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Tac", 0, "", "linear", 3000, false, false, point(139920, 139189, 9410), point(148913, 148726, 20410), point(137628, 136759, 9107), point(146621, 146296, 20107), 4200, 1300, {floor = 1}, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 11)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Tac", 0, "", "linear", 6000, false, false, point(137628, 136759, 9107), point(146621, 146296, 20107), point(137628, 136759, 9107), point(146621, 146296, 20107), 4200, 1300, {floor = 1}, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 12)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "GhostStoriesMansion_Thugs_02"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
end
