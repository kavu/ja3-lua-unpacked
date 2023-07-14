rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.RefugeeCamp_FirstEnter(seed, state, TriggerUnits)
  local li = {
    id = "RefugeeCamp_FirstEnter"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  local _, Shaman
  prgdbg(li, 1, 2)
  _, Shaman = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Shaman, "", "Shaman", "Object", false)
  local _, LegionActor1
  prgdbg(li, 1, 3)
  _, LegionActor1 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionActor1, "LegionActor1", "LegionActor_Male_1", "Object", false)
  local _, LegionActor2
  prgdbg(li, 1, 4)
  _, LegionActor2 = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, LegionActor2, "LegionActor2", "LegionActor_Male_2", "Object", false)
  local _, SP_ShamanPort
  prgdbg(li, 1, 5)
  _, SP_ShamanPort = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Shaman, "SP_ShamanPort", true)
  prgdbg(li, 1, 6)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", LegionActor1, "Standing", "Current Weapon", false)
  prgdbg(li, 1, 7)
  sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, false, "", LegionActor2, "Standing", "Current Weapon", false)
  local _, Shaman_Drumming
  prgdbg(li, 1, 8)
  _, Shaman_Drumming = sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Shaman, "Shaman_Drumming", true, "civ_Ambient_Drums_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 9)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 3000, false, false, point(130342, 137271, 13096), point(127492, 136483, 12592), false, false, 4200, 2000, false, 0, 40, 0, 30000, 0, 800, "Default", 100)
  prgdbg(li, 1, 10)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 3000)
  prgdbg(li, 1, 11)
  sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "Shaman_Walking", LegionActor1, "Legion_01", true, false, false, "", false, false, "")
  local _, Legion_02
  prgdbg(li, 1, 12)
  _, Legion_02 = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "Shaman_Walking", LegionActor2, "Legion_02", true, false, false, "", false, false, "")
  prgdbg(li, 1, 13)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "Shaman_Walking")
  prgdbg(li, 1, 14)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", LegionActor2, "Legion_02", true, "civ_Standing_IdlePassive2", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 15)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 3000, false, false, point(140460, 141039, 13488), point(145438, 140753, 13858), false, false, 4200, 2000, false, 0, 35, 0, 20000, 0, 400, "Default", 100)
  prgdbg(li, 1, 16)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 2500)
  prgdbg(li, 1, 17)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", LegionActor2, "Legion_02", true, "civ_Talk_HandsOnHips_Start", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 18)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", LegionActor1, "Legion_01", true, "civ_Standing_IdlePassive3", 1000, 10, range(1, 1), 0, false, true, false, "")
  local _
  prgdbg(li, 1, 19)
  _, Shaman_Drumming = sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "Shaman_Stading", Shaman, "Shaman_Drumming", true, "civ_Ambient_Drums_End", 700, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 20)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, false, "Shaman_Stading", 500)
  prgdbg(li, 1, 21)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "Shaman_Stading")
  prgdbg(li, 1, 22)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Shaman, "Shaman_Talk", true)
  prgdbg(li, 1, 23)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", 21, "", "linear", 500, false, false, point(130652, 143942, 16893), point(126782, 146015, 19286), point(131471, 143903, 16594), point(129002, 144688, 18107), 4200, 8000, {floor = 0}, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 24)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 0, 300)
  local _
  prgdbg(li, 1, 25)
  _, Shaman_Drumming = sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Shaman, "Shaman_Talk", true, "civ_Talk_ArmsDown2", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 26)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", LegionActor1, "Legion_01", true, "civ_Talk_HandsOnHips4", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 27)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", LegionActor2, "Legion_02", true, "civ_Ambient_Angry", 1000, 0, range(1, 1), 0, true, true, false, "")
  prgdbg(li, 1, 28)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "RefugeeCamp_Raiders"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 29)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 2000)
  prgdbg(li, 1, 30)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 900)
end
