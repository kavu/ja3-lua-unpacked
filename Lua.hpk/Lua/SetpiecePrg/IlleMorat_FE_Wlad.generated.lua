rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.IlleMorat_FE_Wlad(seed, state, MainActor)
  local li = {
    id = "IlleMorat_FE_Wlad"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, LegionActor3Start
  prgdbg(li, 1, 1)
  _, LegionActor3Start = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, MainActor, "SP_WladPort", true)
  prgdbg(li, 1, 2)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", MainActor, "Standing", "No Weapon", false)
  prgdbg(li, 1, 3)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", MainActor, "", true, "civ_Ambient_Weeding", 1000, 0, range(1, 1), 0, false, true, false, "")
end
