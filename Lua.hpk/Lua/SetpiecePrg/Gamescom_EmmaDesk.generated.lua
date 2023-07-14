rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.Gamescom_EmmaDesk(seed, state, TriggerUnits)
  local li = {
    id = "Gamescom_EmmaDesk"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  prgdbg(li, 1, 2)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 700)
  prgdbg(li, 1, 3)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", "", "", "linear", 3000, false, false, point(116792, 140806, 16675), point(114619, 138798, 17167), point(118655, 144036, 15578), point(117207, 141585, 16522), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 4)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", "", "harmonic", "linear", 12000, false, false, point(116792, 140806, 16675), point(114619, 138798, 17167), point(119532, 145604, 14927), point(117163, 141511, 16549), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 5)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 2000)
  prgdbg(li, 1, 6)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 900)
end
