rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.GraffDies(seed, state, TriggerUnits, FoundMerc)
  local li = {id = "GraffDies"}
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 2)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 300)
  local _, Graff
  prgdbg(li, 1, 3)
  _, Graff = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Graff, "SP_Boss", "DiamondRedBoss", "Object", false)
  prgdbg(li, 1, 4)
  local Shooter = FoundMerc or TriggerUnits
  local _, Merc
  prgdbg(li, 1, 5)
  _, Merc = sprocall(SetpieceAssignFromParam.Exec, SetpieceAssignFromParam, state, rand, Merc, "Merc", Shooter)
  prgdbg(li, 1, 6)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, true, "", "", "ConversationKill_SubPiece", Merc, Graff)
end
