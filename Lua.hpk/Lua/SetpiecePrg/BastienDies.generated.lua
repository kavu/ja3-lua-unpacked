rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.BastienDies(seed, state, TriggerUnits, FoundMerc)
  local li = {
    id = "BastienDies"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 2)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 300)
  local _, LegionRaider_Jose
  prgdbg(li, 1, 3)
  _, LegionRaider_Jose = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionRaider_Jose, "", "LegionRaider_Jose", "Object", false)
  local _, Merc
  prgdbg(li, 1, 4)
  _, Merc = sprocall(SetpieceAssignFromParam.Exec, SetpieceAssignFromParam, state, rand, Merc, "Merc", FoundMerc)
  prgdbg(li, 1, 5)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, true, "", "", "ConversationKill_SubPiece", Merc, LegionRaider_Jose)
end
