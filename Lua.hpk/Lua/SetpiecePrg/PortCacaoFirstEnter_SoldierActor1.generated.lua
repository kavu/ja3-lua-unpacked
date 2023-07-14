rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.PortCacaoFirstEnter_SoldierActor1(seed, state, MainActor, TargetActor)
  local li = {
    id = "PortCacaoFirstEnter_SoldierActor1"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, LegionActor3Start
  prgdbg(li, 1, 1)
  _, LegionActor3Start = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, MainActor, "SoldierActor1Cover", true)
  prgdbg(li, 1, 2)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", MainActor, "Crouch", "Current Weapon", true)
  prgdbg(li, 1, 3)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1500)
  local _, AttackPointLegion1
  prgdbg(li, 1, 4)
  _, AttackPointLegion1 = sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Unit", TargetActor, "Torso", "AttackPointLegion1", 1, 0, 300, 150, 0, 0)
  prgdbg(li, 1, 5)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 200)
  prgdbg(li, 1, 6)
  sprocall(SetpieceDeath.Exec, SetpieceDeath, state, rand, true, "", TargetActor, false)
end
