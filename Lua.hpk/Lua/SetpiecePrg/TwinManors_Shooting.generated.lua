rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.TwinManors_Shooting(seed, state, TriggerUnits)
  local li = {
    id = "TwinManors_Shooting"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 2)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 300)
  local _, Doctor
  prgdbg(li, 1, 3)
  _, Doctor = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Doctor, "", "DrLEnfer", "Object", false)
  local _, Abraham
  prgdbg(li, 1, 4)
  _, Abraham = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Abraham, "", "Abraham", "Object", false)
  prgdbg(li, 1, 5)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", Abraham, "Standing", "Bereta92", true)
  prgdbg(li, 1, 6)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", Abraham, "Unit", Doctor, "Head", "", 1, 0, 300, 100, 0, 0)
  prgdbg(li, 1, 7)
  sprocall(SetpieceDeath.Exec, SetpieceDeath, state, rand, false, "", Doctor, false)
  prgdbg(li, 1, 8)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 4000, false, false, point(152070, 174957, 6949), point(147016, 160083, 17949), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
end
