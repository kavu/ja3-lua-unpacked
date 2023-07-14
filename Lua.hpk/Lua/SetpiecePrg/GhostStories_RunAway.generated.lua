rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.GhostStories_RunAway(seed, state, TriggerUnits)
  local li = {
    id = "GhostStories_RunAway"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 300)
  prgdbg(li, 1, 2)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 400, 1000)
  local _, Ghost
  prgdbg(li, 1, 3)
  _, Ghost = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Ghost, "Ghost", "Ghost", "Object", false)
  prgdbg(li, 1, 4)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", Ghost, "Standing", "No Weapon", false)
  prgdbg(li, 1, 5)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Ghost, "", true, "dw_Standing_CombatBegin", 800, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 6)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "FirstScene", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "GhostStories_Clue_Ghost"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 7)
  sprocall(SetStartCombatAnim.Exec, SetStartCombatAnim, state, rand, false, "", Ghost, "CinematicCamera", "camera_Standing_CombatBegin4", 6500, false)
  prgdbg(li, 1, 8)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 6200)
  prgdbg(li, 1, 9)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 300)
  local _, GhostStartPos
  prgdbg(li, 1, 10)
  _, GhostStartPos = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Ghost, "GhostStartPos", true)
  prgdbg(li, 1, 11)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 200)
  prgdbg(li, 1, 12)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Tac", "", "linear", "linear", 7000, false, false, point(128552, 163140, 16533), point(125792, 166110, 19459), false, false, 4200, 1150, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
  prgdbg(li, 1, 13)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 300)
  prgdbg(li, 1, 14)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", Ghost, "GhostStartPos_01", true, "civ_Standing_Run", 900, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 15)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", Ghost, "GhostPos_A", true, "civ_Standing_Run", 900, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 16)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 10)
  local _, Hypo
  prgdbg(li, 1, 17)
  _, Hypo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", Ghost, "Hypo", true, true, false, "Standing", true, false, "Run_RainHeavy")
  prgdbg(li, 1, 18)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 10)
  prgdbg(li, 1, 19)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", Ghost, "", true, "dw_Open_Door", 300, 0, range(1, 1), 0, false, true, false, "nw_Standing_CombatBegin2")
  prgdbg(li, 1, 20)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 10)
  prgdbg(li, 1, 21)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Ghost, "", false, "nw_Standing_CombatBegin2", 400, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 22)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 1200)
  local _
  prgdbg(li, 1, 23)
  _, GhostStartPos = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Ghost, "GhostPos_B_01", true)
  prgdbg(li, 1, 24)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 200)
  prgdbg(li, 1, 25)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Tac", "", "", "linear", 4000, false, false, point(134702, 130334, 9512), point(130494, 127811, 10475), false, false, 4200, 1150, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
  prgdbg(li, 1, 26)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 200, 400)
  prgdbg(li, 1, 27)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 600)
  prgdbg(li, 1, 28)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", Ghost, "GhostPos_B", true, "civ_Standing_Run", 800, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 29)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, false, "Final run", 1800)
  prgdbg(li, 1, 30)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "Final run", Ghost, "TrapDoor", true, "civ_Standing_Run", 800, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 31)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "Final run")
  prgdbg(li, 1, 32)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, Ghost)
  prgdbg(li, 1, 33)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
