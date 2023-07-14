UndefineClass("LegionMarauder_Tutorial")
DefineClass.LegionMarauder_Tutorial = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 35,
  Agility = 50,
  Dexterity = 40,
  Strength = 40,
  Wisdom = 24,
  Leadership = 10,
  Marksmanship = 40,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionRaider",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(679129946064, "Marauder"),
  Affiliation = "Legion",
  neutral_retaliate = true,
  AIKeywords = {"Soldier"},
  role = "Soldier",
  OpeningAttackType = "Overwatch",
  MaxAttacks = 2,
  MaxHitPoints = 50,
  StartingPerks = {
    "AutoWeapons"
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
    "LegionRaiders"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Name",
      "LegionMale_1"
    })
  },
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "LegionRaider"
}
