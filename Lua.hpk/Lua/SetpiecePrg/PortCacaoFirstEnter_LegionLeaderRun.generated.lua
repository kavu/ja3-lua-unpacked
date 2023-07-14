rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.PortCacaoFirstEnter_LegionLeaderRun(seed, state, MainActor, TargetActor)
  local li = {
    id = "PortCacaoFirstEnter_LegionLeaderRun"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, LegionLeaderStartRun
  prgdbg(li, 1, 1)
  _, LegionLeaderStartRun = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, MainActor, "LegionLeaderStartRun", true)
  prgdbg(li, 1, 2)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", MainActor, "Standing", "Current Weapon", true)
  local _, LegionLeaderHide
  prgdbg(li, 1, 3)
  _, LegionLeaderHide = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", MainActor, "LegionLeaderHide", true, true, false, "Standing", true, false, "")
end
