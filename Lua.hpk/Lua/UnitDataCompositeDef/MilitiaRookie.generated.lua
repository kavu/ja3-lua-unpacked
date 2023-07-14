UndefineClass("MilitiaRookie")
DefineClass.MilitiaRookie = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 55,
  Agility = 70,
  Strength = 70,
  Wisdom = 35,
  Leadership = 10,
  Marksmanship = 75,
  Mechanical = 5,
  Explosives = 5,
  Medical = 15,
  Portrait = "UI/EnemiesPortraits/MilitiaStormer",
  Name = T(146662481558, "Recruit"),
  StartingLevel = 2,
  militia = true,
  neutral_retaliate = true,
  MaxAttacks = 1,
  RewardExperience = 0,
  StartingPerks = {
    "AutoWeapons"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Militia_Marksman"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Militia_Recon"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Militia_Stormer"
    })
  },
  Equipment = {
    "MilitiaRookie"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Weight",
      75,
      "Exclusive",
      true,
      "Name",
      "Militia_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Weight",
      25,
      "Exclusive",
      true,
      "Name",
      "Militia_2"
    }),
    PlaceObj("AdditionalGroup", {
      "Name",
      "MilitiaRookie"
    }),
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Name",
      "CivilianMale_3"
    })
  },
  gender = "Male",
  VoiceResponseId = "MilitiaRookie"
}
