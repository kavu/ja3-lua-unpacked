UndefineClass("RebelSniper")
DefineClass.RebelSniper = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 49,
  Agility = 44,
  Dexterity = 76,
  Strength = 41,
  Wisdom = 48,
  Leadership = 33,
  Marksmanship = 88,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/RebelSniper",
  Name = T(782796459960, "Deadeye"),
  Randomization = true,
  Affiliation = "Rebel",
  StartingLevel = 3,
  neutral_retaliate = true,
  AIKeywords = {"Sniper"},
  role = "Marksman",
  AlwaysUseOpeningAttack = true,
  OpeningAttackType = "PinDown",
  MaxAttacks = 1,
  MaxHitPoints = 50,
  StartingPerks = {
    "Deadeye",
    "MinFreeMove",
    "NightOps"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Marksman_Rebels"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Marksman_Rebels_02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Marksman_Rebels_03"
    })
  },
  Equipment = {
    "RebelSniper"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "MaquisMale_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "MaquisMale_2"
    })
  },
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "RebelSoldier"
}
