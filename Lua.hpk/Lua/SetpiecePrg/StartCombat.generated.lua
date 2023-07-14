rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.StartCombat(seed, state, TriggerUnits)
  local li = {
    id = "StartCombat"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  prgdbg(li, 1, 2)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 300)
  local _, Alerted
  prgdbg(li, 1, 3)
  _, Alerted = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Alerted, "", "AlertedUnits", "Object", false)
  prgdbg(li, 1, 4)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", TriggerUnits, "Standing", "Current Weapon", true)
  prgdbg(li, 1, 5)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", Alerted, "Standing", "Current Weapon", true)
  prgdbg(li, 1, 6)
  sprocall(SetpiecePlayAwarenessAnim.Exec, SetpiecePlayAwarenessAnim, state, rand, false, "", Alerted)
  prgdbg(li, 1, 7)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "", {
    PlaceObj("PlayActionFX", {
      ActionFX = "CombatIntroStart"
    })
  })
  prgdbg(li, 1, 8)
  sprocall(SetStartCombatAnim.Exec, SetStartCombatAnim, state, rand, true, "", TriggerUnits, "CinematicCamera", false, false, true)
end
