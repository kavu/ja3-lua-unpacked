rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.ClaudetteDies(seed, state, TriggerUnits)
  local li = {
    id = "ClaudetteDies"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 2)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 300)
  local _, civ_Claudette
  prgdbg(li, 1, 3)
  _, civ_Claudette = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, civ_Claudette, "", "civ_Claudette", "Object", false)
  local _, LegionKidnapper_2
  prgdbg(li, 1, 4)
  _, LegionKidnapper_2 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionKidnapper_2, "", "LegionKidnapper_2", "Object", false)
  prgdbg(li, 1, 5)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, true, "", "", "ConversationKill_SubPiece", LegionKidnapper_2, civ_Claudette)
end
