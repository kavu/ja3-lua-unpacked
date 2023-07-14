rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.ConversationKill_SubPiece(seed, state, Shooter, Target)
  local li = {
    id = "ConversationKill_SubPiece"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceTeleportNear.Exec, SetpieceTeleportNear, state, Shooter, Target, 2, true)
  prgdbg(li, 1, 2)
  sprocall(SetStartCombatAnim.Exec, SetStartCombatAnim, state, rand, false, "", Target, "CinematicCamera", "camera_Standing_CombatBegin4", 8000, false)
  prgdbg(li, 1, 3)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", Target, "Crouch", "No Weapon", true)
  prgdbg(li, 1, 4)
  if not Shooter[1]:GetActiveWeapons("Firearm") then
    prgdbg(li, 2, 1)
    sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", Shooter, "Standing", "HiPower", true)
    li[2] = nil
  else
    prgdbg(li, 1, 5)
    prgdbg(li, 2, 1)
    sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", Shooter, "Standing", "Current Weapon", true)
    li[2] = nil
  end
  prgdbg(li, 1, 7)
  sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, false, "TargetDead", Shooter, "Unit", Target, "Torso", "", 1, 0, 1000, 100, 0, 0)
  prgdbg(li, 1, 8)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "TargetDead")
  prgdbg(li, 1, 9)
  sprocall(SetpieceDeath.Exec, SetpieceDeath, state, rand, true, "ActionCam", Target, false)
  prgdbg(li, 1, 10)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", Shooter, "Standing", "Current Weapon", true)
  prgdbg(li, 1, 11)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
