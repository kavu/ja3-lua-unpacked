rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.IlleMorat_FirstEnter(seed, state, TriggerUnits)
  local li = {
    id = "IlleMorat_FirstEnter"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  prgdbg(li, 1, 2)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 400)
  local _, Wlad
  prgdbg(li, 1, 3)
  _, Wlad = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Wlad, "SP_Wlad", "Wlad", "Object", false)
  local _, LegionActor1
  prgdbg(li, 1, 4)
  _, LegionActor1 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionActor1, "SP_LegionActor1Spawn", "LegionActor1", "Object", false)
  local _, LegionActor2
  prgdbg(li, 1, 5)
  _, LegionActor2 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionActor2, "SP_LegionActor2Spawn", "LegionActor2", "Object", false)
  prgdbg(li, 1, 6)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "IlleMorat_FE_Wlad", Wlad)
  prgdbg(li, 1, 7)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "IlleMorat_FE_LegionActor1", LegionActor1)
  prgdbg(li, 1, 8)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "IlleMorat_FE_LegionActor2", LegionActor2)
  prgdbg(li, 1, 9)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "BanterDone", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "IlleMoratMarauders_approach"
      },
      searchInMap = true,
      searchInMarker = false
    }),
    PlaceObj("QuestSetVariableBool", {Prop = "Given", QuestId = "Beast"})
  })
  prgdbg(li, 1, 10)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "BanterDone", "Tac", 0, "", "linear", 8000, false, false, point(119573, 133100, 8358), point(107844, 122648, 19358), point(119573, 133100, 8358), point(107844, 122648, 19358), 4200, 1300, {floor = 0}, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 11)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "BanterDone")
  prgdbg(li, 1, 12)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
