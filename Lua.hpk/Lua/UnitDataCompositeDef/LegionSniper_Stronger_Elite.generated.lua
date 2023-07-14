UndefineClass("LegionSniper_Stronger_Elite")
DefineClass.LegionSniper_Stronger_Elite = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 46,
  Agility = 85,
  Dexterity = 95,
  Strength = 41,
  Wisdom = 48,
  Leadership = 33,
  Marksmanship = 75,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionSniper",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(865931797288, "Elite Sniper"),
  Randomization = true,
  elite = true,
  eliteCategory = "Legion",
  Affiliation = "Legion",
  StartingLevel = 7,
  neutral_retaliate = true,
  AIKeywords = {"Sniper"},
  role = "Marksman",
  AlwaysUseOpeningAttack = true,
  OpeningAttackType = "PinDown",
  MaxAttacks = 2,
  MaxHitPoints = 50,
  StartingPerks = {
    "Deadeye",
    "Hotblood",
    "DeathFromAbove",
    "HitTheDeck"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Marksman"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Marksman02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Marksman03"
    })
  },
  Equipment = {
    "LegionSniper_Stronger_Elite"
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
