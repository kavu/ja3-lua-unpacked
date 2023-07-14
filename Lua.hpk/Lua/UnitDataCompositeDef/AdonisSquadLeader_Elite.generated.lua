UndefineClass("AdonisSquadLeader_Elite")
DefineClass.AdonisSquadLeader_Elite = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 80,
  Agility = 90,
  Dexterity = 75,
  Strength = 85,
  Wisdom = 80,
  Leadership = 20,
  Marksmanship = 95,
  Mechanical = 52,
  Explosives = 48,
  Medical = 50,
  Portrait = "UI/EnemiesPortraits/AdonisOfficer",
  Name = T(146062606598, "Leader Elite"),
  Randomization = true,
  elite = true,
  eliteCategory = "Foreigners",
  Affiliation = "Adonis",
  StartingLevel = 7,
  neutral_retaliate = true,
  AIKeywords = {"Control", "Explosives"},
  role = "Commander",
  AlwaysUseOpeningAttack = true,
  OpeningAttackType = "Overwatch",
  MaxAttacks = 2,
  MaxHitPoints = 80,
  StartingPerks = {
    "OpportunisticKiller",
    "AutoWeapons"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Adonis_Officer"
    })
  },
  Equipment = {
    "AdonisSquadLeader"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "AdonisMale_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "AdonisMale_2"
    })
  },
  Tier = "Elite",
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "AdonisAssault"
}
