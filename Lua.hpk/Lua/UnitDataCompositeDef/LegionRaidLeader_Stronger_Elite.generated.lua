UndefineClass("LegionRaidLeader_Stronger_Elite")
DefineClass.LegionRaidLeader_Stronger_Elite = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 95,
  Agility = 87,
  Dexterity = 44,
  Strength = 87,
  Wisdom = 85,
  Leadership = 81,
  Marksmanship = 72,
  Mechanical = 11,
  Explosives = 10,
  Medical = 9,
  Portrait = "UI/EnemiesPortraits/LegionOfficer",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(751928274669, "Elite Raid Leader"),
  Randomization = true,
  elite = true,
  eliteCategory = "Legion",
  Affiliation = "Legion",
  StartingLevel = 8,
  neutral_retaliate = true,
  AIKeywords = {"Control"},
  role = "Commander",
  AlwaysUseOpeningAttack = true,
  OpeningAttackType = "Overwatch",
  MaxAttacks = 2,
  MaxHitPoints = 80,
  StartingPerks = {
    "OpportunisticKiller",
    "Hobbler",
    "HoldPosition"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Shaman"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Shaman02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Shaman03"
    })
  },
  Equipment = {
    "LegionSentry_Stronger_Elite"
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
