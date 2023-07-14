UndefineClass("LegionSniper")
DefineClass.LegionSniper = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 28,
  Agility = 70,
  Strength = 41,
  Wisdom = 48,
  Leadership = 33,
  Marksmanship = 70,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionSniper",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(417676355091, "Sniper"),
  Randomization = true,
  Affiliation = "Legion",
  StartingLevel = 3,
  neutral_retaliate = true,
  AIKeywords = {"Sniper"},
  role = "Marksman",
  AlwaysUseOpeningAttack = true,
  OpeningAttackType = "PinDown",
  MaxAttacks = 1,
  MaxHitPoints = 50,
  StartingPerks = {"HitTheDeck"},
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
    "LegionSniper"
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
