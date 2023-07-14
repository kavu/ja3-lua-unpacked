UndefineClass("LegionSniper_Tutorial")
DefineClass.LegionSniper_Tutorial = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 33,
  Agility = 44,
  Dexterity = 45,
  Strength = 41,
  Wisdom = 48,
  Leadership = 33,
  Marksmanship = 55,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionSniper",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(829515616485, "Sniper"),
  Affiliation = "Legion",
  StartingLevel = 3,
  neutral_retaliate = true,
  AIKeywords = {"Sniper"},
  role = "Marksman",
  AlwaysUseOpeningAttack = true,
  OpeningAttackType = "PinDown",
  MaxAttacks = 1,
  MaxHitPoints = 50,
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
      "Name",
      "LegionMale_2"
    })
  },
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "LegionRaider"
}
