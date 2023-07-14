rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.PortCacaoFirstEnter_LegionActor2(seed, state, MainActor, TargetActor)
  local li = {
    id = "PortCacaoFirstEnter_LegionActor2"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 900)
  local _, AttackPointLegion1
  prgdbg(li, 1, 2)
  _, AttackPointLegion1 = sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Unit", TargetActor, "Arms", "AttackPointLegion1", 1, 0, 0, 200, 0, 0)
  prgdbg(li, 1, 3)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 400)
  local _
  prgdbg(li, 1, 4)
  _, AttackPointLegion1 = sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Point", TargetActor, "Neck", "StairsShoot", 2, 100, 200, 200, 0, 0)
end
