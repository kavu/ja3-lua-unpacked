rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.ExplodingBoat(seed, state, TriggerUnits)
  local li = {
    id = "ExplodingBoat"
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
      Track = "Music/Whispers In The Rain"
    })
  })
  local _, Boat
  prgdbg(li, 1, 3)
  _, Boat = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Boat, "", "ExplosiveBoat", "Object", false)
  prgdbg(li, 1, 4)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 500)
  prgdbg(li, 1, 5)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "", "linear", 8500, false, false, point(127296, 176809, 9044), point(128399, 179541, 9616), point(123216, 158281, 13160), point(125676, 162028, 15376), 4200, 1298, false, 0, 30, 25000, 45000, 0, 0, "Default", 100)
  local _, SP_Boat_GoTo
  prgdbg(li, 1, 6)
  _, SP_Boat_GoTo = sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Boat, "WP1", true, "idle", 1000, 11000, range(1, 1), 0, false, false, false, "")
  prgdbg(li, 1, 7)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 100, 2000)
  prgdbg(li, 1, 8)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 4500)
  prgdbg(li, 1, 9)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 2000)
  prgdbg(li, 1, 10)
  sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Boat, "WP1_02", true)
  prgdbg(li, 1, 11)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", "", "linear", "linear", 10000, false, false, point(123216, 158281, 13160), point(125676, 162028, 15376), point(123260, 137706, 12341), point(125251, 139673, 13420), 4200, 1298, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 12)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 1000)
  prgdbg(li, 1, 13)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 100, 2000)
  local _
  prgdbg(li, 1, 14)
  _, SP_Boat_GoTo = sprocall(SetpieceAnimation.Exec, SetpieceAnimation, state, rand, false, "", Boat, "WP1_04", true, "idle", 1000, 9000, range(1, 1), 0, false, false, false, "")
  prgdbg(li, 1, 15)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 5750)
  prgdbg(li, 1, 16)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 2000)
  prgdbg(li, 1, 17)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 500)
  prgdbg(li, 1, 18)
  sprocall(PrgForceStopSetpiece.Exec, PrgForceStopSetpiece, state, rand, "")
end
