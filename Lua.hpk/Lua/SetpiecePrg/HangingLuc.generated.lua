rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.HangingLuc(seed, state, TriggerUnits)
  local li = {id = "HangingLuc"}
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 2)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("QuestSetVariableBool", {
      Prop = "HangingSetpiecePlaying",
      QuestId = "RescueHerMan"
    }),
    PlaceObj("ConditionalEffect", {
      "Conditions",
      {
        PlaceObj("SetpieceIsTestMode", {})
      },
      "Effects",
      {
        PlaceObj("CustomCodeEffect", {
          custom_code = "ErnyTown_HangUnit(\"Luc\")"
        })
      }
    }),
    PlaceObj("ConditionalEffect", {
      "Conditions",
      {
        PlaceObj("QuestIsVariableBool", {
          QuestId = "RescueHerMan",
          Vars = set("HangLuc")
        })
      },
      "Effects",
      {
        PlaceObj("CustomCodeEffect", {
          custom_code = "ErnyTown_HangUnit(\"Hanging_Luc\")"
        })
      },
      "EffectsElse",
      {
        PlaceObj("ConditionalEffect", {
          "Conditions",
          {
            PlaceObj("QuestIsVariableBool", {
              QuestId = "RescueHerMan",
              Vars = set("HangHerman")
            })
          },
          "Effects",
          {
            PlaceObj("CustomCodeEffect", {
              custom_code = "ErnyTown_HangUnit(\"Hanging_Herman\")"
            })
          }
        })
      }
    }),
    PlaceObj("ResetAmbientLife", {ForceImmediateKick = true, KickPerpetualUnits = true}),
    PlaceObj("UnitsKickFromPerpetualMarkers", {}),
    PlaceObj("SetBehaviorVisitAL", {
      ActorGroup = "VillagerFemale",
      MarkerGroup = "SP_HaningCrying_01"
    }),
    PlaceObj("SetBehaviorVisitAL", {
      ActorGroup = "VillagerFemale",
      MarkerGroup = "SP_HaningCrying_02"
    }),
    PlaceObj("SetBehaviorVisitAL", {
      ActorGroup = "VillagerMale",
      MarkerGroup = "SP_HaningCrying_03"
    }),
    PlaceObj("SetBehaviorVisitAL", {
      ActorGroup = "VillagerFemale_2",
      MarkerGroup = "SP_HaningCrying_04"
    }),
    PlaceObj("SetBehaviorVisitAL", {
      ActorGroup = "VillagerFemale",
      MarkerGroup = "SP_HaningCrying_05"
    }),
    PlaceObj("SetBehaviorVisitAL", {
      ActorGroup = "VillagerFemale",
      MarkerGroup = "SP_HaningCrying_06"
    })
  })
  prgdbg(li, 1, 3)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 400, 700)
  prgdbg(li, 1, 4)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", "", "", "linear", 0, false, false, point(148100, 121220, 8732), point(152619, 119920, 7032), point(154310, 137357, 10538), point(152980, 141761, 12495), 4200, 2000, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 5)
  sprocall(PrgPlaySetpiece.Exec, PrgPlaySetpiece, state, rand, false, "", "", "HangingLucPedestrian", nil)
  prgdbg(li, 1, 6)
  sprocall(SetpieceCameraFloat.Exec, SetpieceCameraFloat, state, rand, false, "HangingFloatCamera", 0, 7000, "horizontal", 1600, 40, false)
  prgdbg(li, 1, 7)
  sprocall(SetpieceWaitCheckpoint.Exec, SetpieceWaitCheckpoint, state, rand, "HangingFloatCamera")
end
