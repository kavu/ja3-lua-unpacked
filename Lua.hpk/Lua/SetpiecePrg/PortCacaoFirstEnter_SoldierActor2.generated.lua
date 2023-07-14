rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.PortCacaoFirstEnter_SoldierActor2(seed, state, MainActor, TargetActor)
  local li = {
    id = "PortCacaoFirstEnter_SoldierActor2"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, LegionActor3Start
  prgdbg(li, 1, 1)
  _, LegionActor3Start = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, MainActor, "SoldierActor2Cover", true)
  prgdbg(li, 1, 2)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", MainActor, "Crouch", "Current Weapon", true)
  prgdbg(li, 1, 3)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 600)
  local _, AttackPointLegion1
  prgdbg(li, 1, 4)
  _, AttackPointLegion1 = sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Unit", TargetActor, "Torso", "AttackPointLegion1", 1, 0, 0, 200, 0, 0)
  prgdbg(li, 1, 5)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 300)
  local _
  prgdbg(li, 1, 6)
  _, AttackPointLegion1 = sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Unit", TargetActor, "Neck", "AttackPointLegion1", 2, 200, 300, 300, 0, 0)
  prgdbg(li, 1, 7)
  sprocall(SetpieceDeath.Exec, SetpieceDeath, state, rand, true, "", TargetActor, false)
end
