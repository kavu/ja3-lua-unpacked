UndefineClass("LegionButcher_Stronger")
DefineClass.LegionButcher_Stronger = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 50,
  Agility = 90,
  Dexterity = 86,
  Strength = 47,
  Wisdom = 19,
  Leadership = 9,
  Marksmanship = 15,
  Mechanical = 0,
  Explosives = 11,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionStormer",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(624376306020, "Veteran Butcher"),
  Randomization = true,
  Affiliation = "Legion",
  StartingLevel = 5,
  neutral_retaliate = true,
  AIKeywords = {"Explosives"},
  archetype = "Brute",
  role = "Stormer",
  CanManEmplacements = false,
  MaxAttacks = 2,
  MaxHitPoints = 60,
  StartingPerks = {
    "MeleeTraining",
    "MinFreeMove",
    "HardBlow",
    "InstantAutopsy"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Stormer"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Stormer02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Stormer03"
    })
  },
  Equipment = {
    "LegionMeleeFighter_Stronger"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "LegionMale_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "LegionMale_2"
    })
  },
  gender = "Male",
  VoiceResponseId = "LegionRaider"
}
