rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.Landsbach_Fight_Camera2(seed, state, TriggerUnits)
  local li = {
    id = "Landsbach_Fight_Camera2"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 3600)
  prgdbg(li, 1, 2)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", 1, "accelerated", "linear", 13500, false, false, false, false, point(149813, 149098, 15811), point(145478, 149069, 18302), 4200, 1300, false, 0, 0, 0, 0, 0, 0, "Show all", 100)
end
