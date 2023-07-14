UndefineClass("LegionRaider_Stronger")
DefineClass.LegionRaider_Stronger = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 70,
  Agility = 80,
  Dexterity = 34,
  Strength = 70,
  Wisdom = 24,
  Leadership = 10,
  Marksmanship = 80,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionSoldier",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(819205448916, "Veteran Marauder"),
  Randomization = true,
  Affiliation = "Legion",
  StartingLevel = 4,
  neutral_retaliate = true,
  AIKeywords = {"Soldier"},
  role = "Soldier",
  MaxAttacks = 2,
  MaxHitPoints = 50,
  StartingPerks = {
    "AutoWeapons",
    "MinFreeMove",
    "OpportunisticKiller"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier03"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier04"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier05"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Soldier06"
    })
  },
  Equipment = {
    "LegionRaider_Stronger"
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
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "LegionRaider"
}
