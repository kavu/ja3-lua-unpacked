rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.PortCacaoFirstEnter_LegionActor1(seed, state, MainActor)
  local li = {
    id = "PortCacaoFirstEnter_LegionActor1"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, LegionActor1_Port
  prgdbg(li, 1, 1)
  _, LegionActor1_Port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, MainActor, "LegionActor1_Port", true)
  prgdbg(li, 1, 2)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", MainActor, "Standing", "Current Weapon", true)
  local _, SP_LegionActor1_GoTo
  prgdbg(li, 1, 3)
  _, SP_LegionActor1_GoTo = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", MainActor, "SP_LegionActor1_GoTo", true, false, false, "", false, false, "")
  prgdbg(li, 1, 4)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "PortCacaoCity_FirstBanterDone")
  prgdbg(li, 1, 5)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 500)
  prgdbg(li, 1, 6)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", MainActor, "Crouch", "Current Weapon", true)
  local _, RocketImpact
  prgdbg(li, 1, 7)
  _, RocketImpact = sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", MainActor, "Point", nil, "Torso", "RocketImpact", 1, 0, 1000, 100, 0, 0)
  prgdbg(li, 1, 8)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "PortCacaoCity_SecondBanterDone")
  prgdbg(li, 1, 9)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 200)
end
