rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.SmileyChurchFight_noPastor(seed, state, TriggerUnits)
  local li = {
    id = "SmileyChurchFight_noPastor"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 2)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("MusicSetTrack", {
      Playlist = "Scripted",
      Track = "Music/Rustling Leaves"
    })
  })
  local _, Smiley
  prgdbg(li, 1, 3)
  _, Smiley = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Smiley, "Smiley", "SmileyNPC", "Object", false)
  local _, ChurchFight_SmileyTeleport
  prgdbg(li, 1, 4)
  _, ChurchFight_SmileyTeleport = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Smiley, "ChurchFight_SmileyTeleport", true)
  local _, Enforcer
  prgdbg(li, 1, 5)
  _, Enforcer = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Enforcer, "Enforcer", "SmileyThugs_SetpieceEnforcer", "Object", false)
  local _, Goon
  prgdbg(li, 1, 6)
  _, Goon = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Goon, "Goon", "SmileyThugs_SetpieceGoon", "Object", false)
  local _, Gunner
  prgdbg(li, 1, 7)
  _, Gunner = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Gunner, "Gunner", "SmileyThugs_SetpieceGunner", "Object", false)
  local _, Grenedier
  prgdbg(li, 1, 8)
  _, Grenedier = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Grenedier, "Grenedier", "SmileyThugs_SetpieceGrenedier", "Object", false)
  local _, Sniper
  prgdbg(li, 1, 9)
  _, Sniper = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Sniper, "Sniper", "SmileyThugs_SetpieceSniper", "Object", false)
  prgdbg(li, 1, 10)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "MainCamera", "Max", "", "harmonic", "linear", 8000, false, false, point(145075, 127892, 18155), point(143199, 124553, 21369), point(144930, 131779, 22107), point(143053, 128440, 25321), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 11)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 800)
  local _, SmileyRunOut
  prgdbg(li, 1, 12)
  _, SmileyRunOut = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Smiley, "SmileyRunOut", true, false, false, "", false, false, "")
  local _, ChurchFight_SniperRun
  prgdbg(li, 1, 13)
  _, ChurchFight_SniperRun = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Sniper, "ChurchFight_SniperRun", true, false, false, "", false, false, "")
  prgdbg(li, 1, 14)
  sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Enforcer, "ChurchFightEnfircerRun", true, false, false, "", false, false, "")
  prgdbg(li, 1, 15)
  sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Goon, "ChurchFightGoonRun", true, false, false, "", false, false, "")
  prgdbg(li, 1, 16)
  sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Gunner, "ChurchFightGunnerRun", true, false, false, "", false, false, "")
  local _, ChurchFight_GrenedierRun
  prgdbg(li, 1, 17)
  _, ChurchFight_GrenedierRun = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, true, "", Grenedier, "ChurchFight_GrenedierRun", true, false, false, "", false, false, "")
  prgdbg(li, 1, 18)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 19)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "decelerated", "linear", 33000, false, false, point(157362, 152668, 9548), point(158570, 155345, 10163), point(155405, 153551, 9548), point(156613, 156228, 10163), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 20)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 400, 1000)
  prgdbg(li, 1, 21)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "Standoff", Smiley, "", true, "ar_Standing_Aim", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 22)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "Standoff", Grenedier, "ChurchFight_GrenedierRun", true, "ar_Standing_Aim", 1000, 2000, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 23)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "Standoff", Sniper, "ChurchFight_SniperRun", true, "ar_Standing_Idle7", 1000, 2000, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 24)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "Standoff", Enforcer, "ChurchFightEnfircerRun", true, "ar_Standing_Aim", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 25)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "Standoff", Goon, "ChurchFightGoonRun", true, "ar_Standing_Aim", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 26)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "Standoff", Gunner, "ChurchFightGunnerRun", true, "ar_Standing_Aim", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 27)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "Standoff", {
    PlaceObj("ConditionalEffect", {
      "Conditions",
      {
        PlaceObj("QuestIsVariableBool", {
          QuestId = "Smiley",
          Vars = set("BossDead")
        })
      },
      "Effects",
      {
        PlaceObj("PlayBanterEffect", {
          Banters = {
            "Fleatown_Thugs_02"
          },
          searchInMap = true,
          searchInMarker = false
        })
      },
      "EffectsElse",
      {
        PlaceObj("PlayBanterEffect", {
          Banters = {
            "Fleatown_Thugs_01"
          },
          searchInMap = true,
          searchInMarker = false
        })
      }
    })
  })
  prgdbg(li, 1, 28)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "Standoff")
  local _, AttackPointLegion1
  prgdbg(li, 1, 29)
  _, AttackPointLegion1 = sprocall(SetpieceShoot.Exec, SetpieceShoot, state, rand, false, "ShootGrenadier", Smiley, "Unit", Grenedier, "Arms", "ChurchFight_GrenedierRun", 2, 0, 300, 100, 0, 2)
  prgdbg(li, 1, 30)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "ShootGrenadier", Grenedier, "ChurchFightGrenedierRetreat", true, "ar_Standing_Dodge", 1000, 2000, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 31)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "ShootGrenadier", Sniper, "ChurchFightSniperRetreat", true, "ar_Standing_Dodge", 1000, 2000, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 32)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "ShootGrenadier", Enforcer, "", true, "ar_Standing_Aim_To_Crouch", 1000, 0, range(1, 1), 0, false, true, false, "ar_Crouch_To_Prone")
  prgdbg(li, 1, 33)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "ShootGrenadier", Goon, "ChurchFightGoonRetreat", true, "ar_Standing_Dodge", 800, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 34)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "ShootGrenadier", Gunner, "ChurchFightGunnerRun", true, "ar_Crouch_Dodge", 750, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 35)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "ShootGrenadier")
  prgdbg(li, 1, 36)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 37)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
