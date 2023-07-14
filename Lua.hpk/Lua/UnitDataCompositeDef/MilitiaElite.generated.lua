UndefineClass("MilitiaElite")
DefineClass.MilitiaElite = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 70,
  Agility = 85,
  Dexterity = 80,
  Strength = 80,
  Wisdom = 35,
  Leadership = 10,
  Marksmanship = 85,
  Mechanical = 5,
  Explosives = 5,
  Medical = 15,
  Portrait = "UI/EnemiesPortraits/MilitiaHeavy",
  Name = T(143342976831, "Elite"),
  StartingLevel = 6,
  militia = true,
  neutral_retaliate = true,
  MaxAttacks = 2,
  RewardExperience = 0,
  StartingPerks = {
    "AutoWeapons",
    "TakeAim"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Militia_Heavy"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Militia_Artillery"
    })
  },
  Equipment = {
    "MilitiaRookie"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Exclusive",
      true,
      "Name",
      "Militia_2"
    }),
    PlaceObj("AdditionalGroup", {
      "Name",
      "MilitiaElite"
    })
  },
  gender = "Male",
  VoiceResponseId = "MilitiaRookie"
}
