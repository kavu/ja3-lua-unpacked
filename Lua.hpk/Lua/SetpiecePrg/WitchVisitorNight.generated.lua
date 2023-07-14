rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.WitchVisitorNight(seed, state, TriggerUnits)
  local li = {
    id = "WitchVisitorNight"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 2)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("MusicSetTrack", {
      Playlist = "Scripted",
      Track = "Music/Bloody Rocks"
    })
  })
  local _, NightVisitor
  prgdbg(li, 1, 3)
  _, NightVisitor = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, NightVisitor, "", "VillagerMale_2", "Object", false)
  local _
  prgdbg(li, 1, 4)
  _, NightVisitor = sprocall(SetpieceSpawn.Exec, SetpieceSpawn, state, rand, NightVisitor, "NightVisitorSpawn")
  local _, Witch
  prgdbg(li, 1, 5)
  _, Witch = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Witch, "", "Witch", "Unit", false)
  local _, WitchCauldron
  prgdbg(li, 1, 6)
  _, WitchCauldron = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Witch, "WitchCauldronPos", true)
  prgdbg(li, 1, 7)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 50)
  prgdbg(li, 1, 8)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Witch, "", true, "civ_Sit_Idle", 1000, 0, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 9)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 3000, false, false, point(184246, 159718, 17723), point(186752, 161024, 18735), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 10)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 400, 1500)
  local _, NightVisitorCauldronPos
  prgdbg(li, 1, 11)
  _, NightVisitorCauldronPos = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NightVisitor, "NightVisitorCauldronPos", true, false, false, "Standing", false, false, "")
  prgdbg(li, 1, 12)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5400)
  prgdbg(li, 1, 13)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 800)
  prgdbg(li, 1, 14)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 5000, false, false, point(182667, 146854, 12843), point(184787, 145215, 14191), false, false, 4200, 2000, false, 0, 40, 2000, 10000, 550, 450, "Default", 100)
  local _
  prgdbg(li, 1, 15)
  _, WitchCauldron = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, NightVisitor, "NightVisitorCauldronPos", true)
  prgdbg(li, 1, 16)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 400)
  prgdbg(li, 1, 17)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 400, 1000)
  prgdbg(li, 1, 18)
  sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, true, "", NightVisitor, "", true, "civ_Ambient_Begging", 1000, 3500, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 19)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 2500)
  prgdbg(li, 1, 20)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 2500)
  prgdbg(li, 1, 21)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 400, 700)
  prgdbg(li, 1, 22)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 10000, false, false, point(163503, 141172, 18714), point(161528, 139438, 20164), false, false, 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  local _, ShackPos
  prgdbg(li, 1, 23)
  _, ShackPos = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", Witch, "NightVisitorLastPos", true, false, false, "Standing", false, false, "")
  local _
  prgdbg(li, 1, 24)
  _, ShackPos = sprocall(SetpieceGotoPosition.Exec, SetpieceGotoPosition, state, rand, false, "", NightVisitor, "NightVisitorLastPos", true, false, false, "Standing", false, false, "")
  prgdbg(li, 1, 25)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5000)
  prgdbg(li, 1, 26)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 2500)
  prgdbg(li, 1, 27)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, NightVisitor)
  prgdbg(li, 1, 28)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
