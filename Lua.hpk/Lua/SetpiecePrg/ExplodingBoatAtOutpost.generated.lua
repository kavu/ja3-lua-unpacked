rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.ExplodingBoatAtOutpost(seed, state, TriggerUnits)
  local li = {
    id = "ExplodingBoatAtOutpost"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  prgdbg(li, 1, 2)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("ExecuteCode", {
      Code = function(self, obj)
        SetupBoatForSetpiece()
      end,
      FuncCode = "SetupBoatForSetpiece()"
    }),
    PlaceObj("MusicSetTrack", {
      Playlist = "Scripted",
      Track = "Music/Sign of Civilization"
    })
  })
  local _, Boat
  prgdbg(li, 1, 3)
  _, Boat = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Boat, "", "ExplosiveBoat", "Object", false)
  local _, SP_Boat_TP
  prgdbg(li, 1, 4)
  _, SP_Boat_TP = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Boat, "SP_Boat_TP", true)
  prgdbg(li, 1, 5)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 500)
  local _, SP_Boat_WP1
  prgdbg(li, 1, 6)
  _, SP_Boat_WP1 = sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Boat, "SP_Boat_WP1", true, "idle", 1000, 11500, range(1, 1), 0, false, true, false, "")
  prgdbg(li, 1, 7)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", "", "", "linear", 100, false, false, point(129271, 196921, 11156), point(134156, 196547, 12158), point(123216, 158281, 13160), point(125676, 162028, 15376), 4200, 1298, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 8)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 100, 2500)
  prgdbg(li, 1, 9)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 7000)
  prgdbg(li, 1, 10)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 1500)
  prgdbg(li, 1, 11)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("QuestSetVariableBool", {
      Prop = "BoatPushedSetpieceToggle",
      QuestId = "ReduceBarrierCampStrength"
    })
  })
  prgdbg(li, 1, 12)
  sprocall(SetpieceDespawn.Exec, SetpieceDespawn, Boat)
  prgdbg(li, 1, 13)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "", {
    PlaceObj("CustomCodeEffect", {
      custom_code = "PlaySound(\"explosion_cistern\")"
    })
  })
  prgdbg(li, 1, 14)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 750)
  prgdbg(li, 1, 15)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "", {
    PlaceObj("CustomCodeEffect", {
      custom_code = "PlaySound(\"Grenade_explosion-water\")"
    })
  })
  prgdbg(li, 1, 16)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 350)
  prgdbg(li, 1, 17)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "", {
    PlaceObj("CustomCodeEffect", {
      custom_code = "PlaySound(\"GrenadeBasic_drop-water\")"
    })
  })
  prgdbg(li, 1, 18)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 100)
  prgdbg(li, 1, 19)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, false, "", {
    PlaceObj("CustomCodeEffect", {
      custom_code = "PlaySound(\"Grenade_explosion-sand\")"
    })
  })
  prgdbg(li, 1, 20)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 2500)
  prgdbg(li, 1, 22)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "linear", "linear", 8000, false, false, point(104465, 189918, 10925), point(102205, 191875, 11195), point(106272, 190955, 10769), point(104268, 193165, 11103), 4200, 1298, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 23)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 2000)
  prgdbg(li, 1, 24)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5750)
  prgdbg(li, 1, 25)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 2000)
  prgdbg(li, 1, 26)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 500)
  prgdbg(li, 1, 27)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
