rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.SmileyKillsPastor(seed, state, TriggerUnits)
  local li = {
    id = "SmileyKillsPastor"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 2)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 300)
  local _, Smiley
  prgdbg(li, 1, 3)
  _, Smiley = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Smiley, "", "SmileyNPC", "Object", false)
  local _, SmileyKillPastorSpawn
  prgdbg(li, 1, 4)
  _, SmileyKillPastorSpawn = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Smiley, "SmileyKillPastorSpawn", true)
  local _, Pastor
  prgdbg(li, 1, 5)
  _, Pastor = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Pastor, "", "Pastor", "Object", false)
  prgdbg(li, 1, 6)
  sprocall(SetpieceTacCamera.Exec, SetpieceTacCamera, state, rand, false, "ActionCam", Pastor, 0, true, false, 97, false, 0)
  prgdbg(li, 1, 7)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 300)
  prgdbg(li, 1, 8)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", Smiley, "Unit", Pastor, "Head", "", 1, 0, 0, 100, 0, 0)
  prgdbg(li, 1, 9)
  sprocall(SetpieceDeath.Exec, SetpieceDeath, state, rand, true, "", Pastor, false)
  prgdbg(li, 1, 10)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 800)
  prgdbg(li, 1, 11)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "ActionCam")
end
