UndefineClass("LegionRaidLeader")
DefineClass.LegionRaidLeader = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 66,
  Agility = 80,
  Dexterity = 44,
  Strength = 40,
  Wisdom = 41,
  Leadership = 81,
  Marksmanship = 50,
  Mechanical = 11,
  Explosives = 10,
  Medical = 9,
  Portrait = "UI/EnemiesPortraits/LegionOfficer",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(248210272230, "Raid Leader"),
  Randomization = true,
  Affiliation = "Legion",
  StartingLevel = 5,
  neutral_retaliate = true,
  AIKeywords = {"Control"},
  role = "Commander",
  AlwaysUseOpeningAttack = true,
  OpeningAttackType = "Overwatch",
  MaxAttacks = 2,
  MaxHitPoints = 80,
  StartingPerks = {
    "OpportunisticKiller",
    "Hobbler"
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
    "LegionSentry"
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
