rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.Trailer_01(seed, state, TriggerUnits)
  local li = {id = "Trailer_01"}
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  prgdbg(li, 1, 2)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 700)
  local _, Ghost
  prgdbg(li, 1, 3)
  _, Ghost = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Ghost, "Ghost", "Ghost", "Object", false)
  prgdbg(li, 1, 4)
  sprocall(SetpieceTacCamera.Exec, SetpieceTacCamera, state, rand, false, "FirstScene", Ghost, 0, true, true, 75, false, 1)
  prgdbg(li, 1, 5)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", Ghost, "Standing", "No Weapon", false)
  prgdbg(li, 1, 6)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "FirstScene", Ghost, "", true, "dw_Standing_CombatBegin", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 7)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "FirstScene", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "GhostStories_Clue_Ghost"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 8)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "FirstScene")
  prgdbg(li, 1, 9)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", 0, "linear", "linear", 10000, true, false, point(124387, 164047, 19199), point(121879, 166941, 22413), point(129154, 150847, 21668), point(126645, 153741, 24882), 4200, 1300, {floor = 0}, 0, 0, 0, 0, 0, 0, "Default", 100)
  local _, GhostStartPos
  prgdbg(li, 1, 10)
  _, GhostStartPos = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Ghost, "GhostStartPos", true)
  local _, Hypo
  prgdbg(li, 1, 11)
  _, Hypo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", Ghost, "Hypo", true, true, false, "", false, false, "")
  prgdbg(li, 1, 12)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", Ghost, "", true, "civ_Open_Door", 1000, 0, range(1, 1), 0, false, true, false, "")
  local _, TrapDoor
  prgdbg(li, 1, 13)
  _, TrapDoor = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", Ghost, "TrapDoor", true, true, true, "", false, false, "")
  prgdbg(li, 1, 14)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", Ghost, "", true, "civ_Standing_To_Crouch", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 15)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 400, 700)
  prgdbg(li, 1, 16)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, Ghost)
end
