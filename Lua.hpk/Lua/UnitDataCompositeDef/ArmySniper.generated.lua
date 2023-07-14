UndefineClass("ArmySniper")
DefineClass.ArmySniper = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 40,
  Agility = 70,
  Strength = 41,
  Wisdom = 48,
  Leadership = 33,
  Marksmanship = 90,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/ArmySniper",
  Name = T(970171510103, "Sniper"),
  Randomization = true,
  Affiliation = "Army",
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
      "GrandChien_Marksman"
    })
  },
  Equipment = {"ArmySniper"},
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "ArmyMale_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "ArmyMale_2"
    })
  },
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "ArmySoldier"
}
