rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.Colorizations(seed, state, TriggerUnits)
  local li = {
    id = "Colorizations"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", "", "", "linear", 5000, false, false, point(142072, 168118, 58136), point(139389, 170852, 61350), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
end
