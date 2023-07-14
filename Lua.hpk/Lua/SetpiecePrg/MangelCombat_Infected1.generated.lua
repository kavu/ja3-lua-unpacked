rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.MangelCombat_Infected1(seed, state, MainActor)
  local li = {
    id = "MangelCombat_Infected1"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 2550)
  prgdbg(li, 1, 2)
  sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", MainActor, "SP_FallenInfected1_GoTo", true, false, false, "", false, false, "")
end
