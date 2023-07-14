rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.EncounterHerman_Camera(seed, state)
  local li = {
    id = "EncounterHerman_Camera"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", "", "linear", "linear", 10000, false, false, point(163613, 167094, 10153), point(166601, 167208, 9887), point(166548, 151282, 9943), point(169536, 151393, 9680), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
  prgdbg(li, 1, 2)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 500)
  prgdbg(li, 1, 3)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", "", "", "linear", 100, false, false, point(134814, 147617, 8610), point(137262, 146043, 9334), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
  prgdbg(li, 1, 4)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 0, 800)
  prgdbg(li, 1, 5)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 800)
end
