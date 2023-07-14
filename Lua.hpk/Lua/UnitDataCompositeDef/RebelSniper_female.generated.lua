UndefineClass("RebelSniper_female")
DefineClass.RebelSniper_female = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 41,
  Agility = 44,
  Dexterity = 89,
  Strength = 41,
  Wisdom = 48,
  Leadership = 33,
  Marksmanship = 91,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/RebelSniper",
  Name = T(145791344419, "Deadeye"),
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
      "RebelFemaleSniper"
    })
  },
  Equipment = {
    "RebelSniper"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Name",
      "MaquisFemale_1"
    })
  },
  pollyvoice = "Kendra",
  gender = "Female",
  VoiceResponseId = "AnneLeMitrailleur"
}
