rawset(_G, "SetpiecePrgs", rawget(_G, "SetpiecePrgs") or {})
function SetpiecePrgs.ErnieReturn_FirstEnter(seed, state, TriggerUnits)
  local li = {
    id = "ErnieReturn_FirstEnter"
  }
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 0)
  prgdbg(li, 1, 2)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("ConditionalEffect", {
      "Conditions",
      {
        PlaceObj("SetpieceIsTestMode", {})
      },
      "Effects",
      {
        PlaceObj("UnitsDespawnAmbientLife", {}),
        PlaceObj("QuestSetVariableBool", {
          Prop = "WorldFlipDone",
          QuestId = "04_Betrayal"
        }),
        PlaceObj("QuestSetVariableBool", {
          Prop = "Pierre_SpawnErnie",
          QuestId = "ErnieSideQuests_WorldFlip"
        }),
        PlaceObj("QuestSetVariableBool", {
          Prop = "Ernie_ExtraMilitia",
          QuestId = "ErnieSideQuests_WorldFlip"
        }),
        PlaceObj("QuestSetVariableBool", {
          Prop = "Basil_ErniePartisan",
          QuestId = "ErnieSideQuests_WorldFlip"
        }),
        PlaceObj("QuestSetVariableBool", {
          Prop = "BillyBoy_ErniePartisan",
          QuestId = "ErnieSideQuests_WorldFlip"
        })
      }
    }),
    PlaceObj("ConditionalEffect", {
      "Conditions",
      {
        PlaceObj("SetpieceIsTestMode", {Negate = true})
      },
      "Effects",
      {
        PlaceObj("GroupSetSide", {Side = "ally", TargetUnit = "BillyBoy"}),
        PlaceObj("GroupSetSide", {
          Side = "ally",
          TargetUnit = "GreasyBasil"
        })
      }
    })
  })
  prgdbg(li, 1, 3)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("MusicSetTrack", {
      Playlist = "Scripted",
      Track = "Music/Rustling Leaves"
    }),
    PlaceObj("UnitSetConflictIgnore", {
      TargetUnit = "GreasyBasil"
    }),
    PlaceObj("UnitSetConflictIgnore", {TargetUnit = "BillyBoy"})
  })
  prgdbg(li, 1, 4)
  if GetQuestVar("ErnieSideQuests_WorldFlip", "Pierre_SpawnErnie") then
    local _, Pierre
    prgdbg(li, 2, 1)
    _, Pierre = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Pierre, "", "Pierre", "Object", false)
    prgdbg(li, 2, 2)
    sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", Pierre, "Crouch", "Current Weapon", true)
    li[2] = nil
  end
  prgdbg(li, 1, 5)
  if GetQuestVar("ErnieSideQuests_WorldFlip", "BillyBoy_ErniePartisan") then
    prgdbg(li, 2, 1)
    sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
      PlaceObj("NpcUnitGiveItem", {ItemId = "AK74", TargetUnit = "BillyBoy"})
    })
    local _, BillyBoy
    prgdbg(li, 2, 2)
    _, BillyBoy = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, BillyBoy, "", "BillyBoy", "Object", false)
    prgdbg(li, 2, 3)
    sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", BillyBoy, "Crouch", "Current Weapon", true)
    local _, SP_BillyBoy_Port
    prgdbg(li, 2, 4)
    _, SP_BillyBoy_Port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, BillyBoy, "SP_BillyBoy_Port", true)
    li[2] = nil
  end
  prgdbg(li, 1, 6)
  if GetQuestVar("ErnieSideQuests_WorldFlip", "Basil_ErniePartisan") then
    prgdbg(li, 2, 1)
    sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
      PlaceObj("NpcUnitGiveItem", {
        ItemId = "AK74",
        TargetUnit = "GreasyBasil"
      })
    })
    local _, Basil
    prgdbg(li, 2, 2)
    _, Basil = sprocall(SetpieceAssignFromGroup.Exec, SetpieceAssignFromGroup, state, rand, Basil, "", "GreasyBasil", "Object", false)
    prgdbg(li, 2, 3)
    sprocall(SetpieceSetStance.Exec, SetpieceSetStance, state, rand, true, "", Basil, "Crouch", "Current Weapon", true)
    local _, SP_BillyBoy_Port
    prgdbg(li, 2, 4)
    _, SP_BillyBoy_Port = sprocall(SetpieceTeleport.Exec, SetpieceTeleport, state, Basil, "SP_Basil_Port", true)
    li[2] = nil
  end
  prgdbg(li, 1, 7)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, false, "", 0, 700)
  prgdbg(li, 1, 8)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, true, "", "Max", 0, "decelerated", "linear", 18000, false, false, point(123375, 97788, 18014), point(121027, 96328, 19178), point(115321, 114507, 17631), point(111408, 112073, 19571), 4200, 1300, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 9)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
  prgdbg(li, 1, 10)
  sprocall(SetpieceCamera.Exec, SetpieceCamera, state, rand, false, "", "Max", 6, "decelerated", "linear", 35000, false, false, point(186620, 146615, 11369), point(188918, 148211, 12455), point(184101, 144864, 10178), point(186399, 146460, 11264), 4200, 1300, false, 0, 0, 0, 0, 0, 0, "Default", 100)
  prgdbg(li, 1, 11)
  sprocall(SetpieceFadeIn.Exec, SetpieceFadeIn, state, rand, true, "", 400, 700)
  prgdbg(li, 1, 12)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 700)
  prgdbg(li, 1, 13)
  sprocall(PrgPlayEffect.Exec, PrgPlayEffect, state, rand, true, "", {
    PlaceObj("PlayBanterEffect", {
      Banters = {
        "ErnieWorldFlip01_ErnieInitial"
      },
      searchInMap = true,
      searchInMarker = false
    })
  })
  prgdbg(li, 1, 14)
  sprocall(SetpieceSleep.Exec, SetpieceSleep, state, rand, true, "", 500)
  prgdbg(li, 1, 15)
  sprocall(SetpieceFadeOut.Exec, SetpieceFadeOut, state, rand, true, "", 700)
end
