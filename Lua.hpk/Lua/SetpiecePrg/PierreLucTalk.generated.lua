rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.PierreLucTalk(seed, state, TriggerUnits)
  local li = {
    id = "PierreLucTalk"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  local _, Pierre_02
  prgdbg(li, 1, 2)
  _, Pierre_02 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Pierre_02, "", "Pierre", "Object", false)
  local _
  prgdbg(li, 1, 3)
  _, Pierre_02 = sprocall(SetpieceSpawn.Exec, SetpieceSpawn, state, rand, Pierre_02, "Pierre_02")
  local _, Luc_02
  prgdbg(li, 1, 4)
  _, Luc_02 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Luc_02, "", "Luc", "Object", false)
  prgdbg(li, 1, 5)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", Luc_02, "Standing", "No Weapon", true)
  prgdbg(li, 1, 6)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Luc_02, "LucTalk", true)
  prgdbg(li, 1, 7)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Luc_02, "LucTalk", true, "civ_Talking2", 1000, 0, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 8)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "SubPierreTalk", Pierre_02)
  prgdbg(li, 1, 9)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "decelerated", "linear", 58000, false, false, point(125712, 148992, 15955), point(124488, 151143, 17654), point(127451, 145939, 13541), point(126227, 148090, 15240), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
  prgdbg(li, 1, 10)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 400, 700)
  prgdbg(li, 1, 11)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "PierreSecondIdle", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "PierrLucTalk"
      },
      searchInMap = true,
      searchInMarker = false
    }),
    PlaceObj("QuestSetVariableBool", {
      Prop = "PierreMet",
      QuestId = "02_LiberateErnie"
    })
  })
  prgdbg(li, 1, 12)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 13)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 5000, false, false, point(125435, 135206, 11934), point(123389, 133195, 12807), point(127451, 145939, 13541), point(126227, 148090, 15240), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
  prgdbg(li, 1, 14)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Luc_02, "LucTalk_Cry", true)
  prgdbg(li, 1, 15)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Luc_02, "", true, "civ_Ambient_SadCrying", 1000, 0, range(1, 1), 0, false, true, false, "")
  local _, Despawn
  prgdbg(li, 1, 16)
  _, Despawn = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Pierre_02, "Despawn", true, false, false, "", false, false, "")
  prgdbg(li, 1, 17)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 300, 700)
  prgdbg(li, 1, 18)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 4000)
  prgdbg(li, 1, 19)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 20)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, Pierre_02)
  prgdbg(li, 1, 21)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
