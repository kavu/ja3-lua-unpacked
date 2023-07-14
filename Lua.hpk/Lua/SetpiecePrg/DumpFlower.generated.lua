rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.DumpFlower(seed, state, TriggerUnits)
  local li = {id = "DumpFlower"}
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 300)
  prgdbg(li, 1, 2)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 400, 700)
  prgdbg(li, 1, 3)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Tac", 6, "", "linear", 4000, true, false, point(170776, 160307, 7104), point(161895, 150663, 18104), point(170776, 160307, 7104), point(161895, 150663, 18104), 4200, 650, {floor = 0}, 0, 0, 0, 0, 0, 0, "Default", 100)
end
