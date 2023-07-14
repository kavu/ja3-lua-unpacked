rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.KaylaStrike(seed, state, TriggerUnits)
  local li = {
    id = "KaylaStrike"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Tac", "", "", "linear", 1000, true, false, point(161144, 141268, 8370), point(171709, 129640, 19370), false, false, 4200, 1300, {floor = 0}, 0, 0, 0, 0, 0, 0, "Default", 100)
  local _, Kayla
  prgdbg(li, 1, 2)
  _, Kayla = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Kayla, "", "GangKayla", "Object", false)
  local _, Merc
  prgdbg(li, 1, 3)
  _, Merc = sprocall(SetpieceAssignFromParam.Exec, SetpieceAssignFromParam, state, rand, Merc, "", TriggerUnits)
  prgdbg(li, 1, 4)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", Kayla, "", true, "mk_Standing_Machete_Attack_Forward", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 5)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", Merc, "", true, "nw_Standing_IdlePassive_Pain", 500, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 6)
  sprocall(SetpiecePlayAwarenessAnim.Exec, SetpiecePlayAwarenessAnim, state, rand, true, "", Merc)
end
