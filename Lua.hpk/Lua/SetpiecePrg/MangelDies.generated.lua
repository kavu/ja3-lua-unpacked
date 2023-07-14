rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.MangelDies(seed, state, TriggerUnits)
  local li = {id = "MangelDies"}
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 2)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 300)
  local _, DrKronenberg
  prgdbg(li, 1, 3)
  _, DrKronenberg = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, DrKronenberg, "", "DrKronenberg", "Object", false)
  local _, Merc
  prgdbg(li, 1, 4)
  _, Merc = sprocall(SetpieceAssignFromParam.Exec, SetpieceAssignFromParam, state, rand, Merc, "", TriggerUnits)
  prgdbg(li, 1, 5)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, true, "", "", "ConversationKill_SubPiece", Merc, DrKronenberg)
end
