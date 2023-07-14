rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.RefugeeCamp_Betrayal_FirstEnter(seed, state, TriggerUnits)
  local li = {
    id = "RefugeeCamp_Betrayal_FirstEnter"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 2)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 400, 700)
  prgdbg(li, 1, 3)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 3000, false, false, point(130342, 137271, 13096), point(127492, 136483, 12592), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
end
