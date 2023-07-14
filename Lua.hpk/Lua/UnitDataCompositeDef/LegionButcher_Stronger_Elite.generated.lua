UndefineClass("LegionButcher_Stronger_Elite")
DefineClass.LegionButcher_Stronger_Elite = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 71,
  Agility = 96,
  Dexterity = 86,
  Strength = 90,
  Wisdom = 19,
  Leadership = 9,
  Marksmanship = 15,
  Mechanical = 0,
  Explosives = 11,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionStormer",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(712934079592, "Elite Butcher"),
  Randomization = true,
  elite = true,
  eliteCategory = "Legion",
  Affiliation = "Legion",
  StartingLevel = 8,
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
    "Berserker",
    "BeefedUp"
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
    "LegionMeleeFighter_Stronger_Elite"
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
