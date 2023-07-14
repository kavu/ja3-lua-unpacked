rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.Dump_HenFight(seed, state, TriggerUnits)
  local li = {
    id = "Dump_HenFight"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  local _, RedHen
  prgdbg(li, 1, 2)
  _, RedHen = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, RedHen, "", "Hen_RedFighter", "Object", false)
  local _, BlueHen
  prgdbg(li, 1, 3)
  _, BlueHen = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, BlueHen, "", "Hen_BlueFighter", "Object", false)
  prgdbg(li, 1, 4)
  if GetQuestVar("PortCacaoSideQuests", "RedHenWins") then
    prgdbg(li, 2, 1)
    sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "Dump_LosingHen", BlueHen)
    prgdbg(li, 2, 2)
    sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "Dump_WiningHen", RedHen)
    li[2] = nil
  else
    prgdbg(li, 1, 5)
    prgdbg(li, 2, 1)
    sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "Dump_LosingHen", RedHen)
    prgdbg(li, 2, 2)
    sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "Dump_WiningHen", BlueHen)
    li[2] = nil
  end
  prgdbg(li, 1, 6)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "linear", "linear", 5000, false, false, point(175228, 121366, 18615), point(179079, 122919, 21400), point(174073, 120901, 17779), point(177924, 122453, 20565), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 7)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 100, 400)
  prgdbg(li, 1, 8)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5500)
  prgdbg(li, 1, 9)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "linear", "linear", 5000, false, false, point(175227, 121366, 18615), point(179079, 122919, 21400), point(176225, 119753, 18370), point(180500, 119913, 20957), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 10)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5000)
  prgdbg(li, 1, 11)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
