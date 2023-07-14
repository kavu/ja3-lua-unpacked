rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.EncounterHerman(seed, state, TriggerUnits)
  local li = {
    id = "EncounterHerman"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  local _, Herman
  prgdbg(li, 1, 2)
  _, Herman = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Herman, "", "Herman", "Object", false)
  local _, Shooter
  prgdbg(li, 1, 3)
  _, Shooter = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Shooter, "", "SceneShooter", "Object", false)
  local _, Raider01
  prgdbg(li, 1, 4)
  _, Raider01 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Raider01, "", "RaiderActor01", "Object", false)
  prgdbg(li, 1, 5)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Raider01, "RaiderActor01", true)
  prgdbg(li, 1, 6)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", Herman, "Standing", "No Weapon", true)
  prgdbg(li, 1, 7)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Herman, "HermanShacking", true, "civ_Fear_Standing", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 8)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Shooter, "Shooter_01", true, "ar_Standing_Aim", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 9)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Raider01, "RaiderActor01", true, "civ_Sit_Idle", 1000, 0, range(1, 1), 0, true, true, false, "")
  local _, Raider02
  prgdbg(li, 1, 10)
  _, Raider02 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Raider02, "", "RaiderActor02", "Object", false)
  prgdbg(li, 1, 11)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Raider02, "RaiderActor02", true)
  prgdbg(li, 1, 12)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Raider02, "RaiderActor02", true, "civ_Standing_Idle2", 1000, 0, range(1, 2), 0, false, true, false, "")
  local _, Raider03
  prgdbg(li, 1, 13)
  _, Raider03 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Raider03, "", "RaiderActor03", "Object", false)
  prgdbg(li, 1, 14)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Raider03, "RaiderActor03", true)
  prgdbg(li, 1, 15)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Raider03, "RaiderActor03", true, "ar_Standing_IdlePassive6", 1000, 0, range(1, 1), 0, false, true, false, "")
  local _, Raider04
  prgdbg(li, 1, 16)
  _, Raider04 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Raider04, "", "RaiderActor04", "Object", false)
  prgdbg(li, 1, 17)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Raider04, "RaiderActor04", true)
  prgdbg(li, 1, 18)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Raider04, "RaiderActor04", true, "civ_Ambient_LeanAgainstHighProp3", 1000, 0, range(1, 1), 0, true, true, false, "")
  local _, Raider05
  prgdbg(li, 1, 19)
  _, Raider05 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Raider05, "", "RaiderActor05", "Object", false)
  prgdbg(li, 1, 20)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Raider05, "RaiderActor05", true)
  prgdbg(li, 1, 21)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Raider05, "RaiderActor05", true, "civ_Ambient_LookingWall", 1000, 0, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 22)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 2600)
  prgdbg(li, 1, 23)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "Herman_BanterDone", "", "EncounterHerman_Camera")
  prgdbg(li, 1, 24)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "Herman_BanterDone", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "Raiders_AproachingHerman"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 25)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "Herman_BanterDone")
  local _, HermansFeet
  prgdbg(li, 1, 26)
  _, HermansFeet = sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, true, "", Shooter, "Point", Herman, "Torso", "HermansFeet", 1, 0, 400, 80, 0, 0)
  prgdbg(li, 1, 27)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Raider05, "RaiderActor05", true, "civ_Ambient_Cheering", 1250, 0, range(1, 1), 0, true, false, false, "")
  prgdbg(li, 1, 28)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Raider02, "RaiderActor02", true, "civ_Ambient_Cheering", 1150, 0, range(1, 1), 0, false, false, false, "")
  prgdbg(li, 1, 29)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1800)
  prgdbg(li, 1, 30)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 1200)
  prgdbg(li, 1, 31)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
