rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.DocksLost(seed, state, TriggerUnits)
  local li = {id = "DocksLost"}
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  prgdbg(li, 1, 2)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "", {
    PlaceObj("EffectsWithCondition", {
      Conditions = {
        PlaceObj("SetpieceIsTestMode", {})
      },
      Effects = {
        PlaceObj("QuestSetVariableBool", {Prop = "BombsArmed", QuestId = "Docks"}),
        PlaceObj("QuestSetVariableBool", {Prop = "DocksLost", QuestId = "Docks"})
      }
    })
  })
  prgdbg(li, 1, 3)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Tac", "", "", "linear", 0, false, false, point(146989, 128240, 11900), point(133749, 136695, 22900), false, false, 4200, 2000, {floor = 1}, 0, 0, 0, 0, 0, 0, "Show all", 100)
  prgdbg(li, 1, 4)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 400, 700)
  prgdbg(li, 1, 5)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Tac", "", "", "linear", 4300, false, false, point(146989, 128240, 11900), point(133749, 136695, 22900), point(149668, 127500, 11900), point(136428, 135955, 22900), 4200, 2000, {floor = 1}, 0, 0, 0, 0, 0, 0, "Show all", 100)
  prgdbg(li, 1, 6)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 7)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", 0, "linear", "linear", 4600, false, false, point(151049, 126780, 10142), point(149431, 129211, 10831), point(152666, 124349, 9453), point(149970, 128400, 10601), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
  prgdbg(li, 1, 8)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 400, 700)
  prgdbg(li, 1, 9)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 3000)
  prgdbg(li, 1, 10)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 11)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", 0, "linear", "linear", 4600, false, false, point(159860, 129876, 12001), point(157597, 131620, 12918), point(162121, 128132, 11082), point(158351, 131038, 12612), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
  prgdbg(li, 1, 12)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 400, 700)
  prgdbg(li, 1, 13)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 3000)
  prgdbg(li, 1, 14)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 15)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
