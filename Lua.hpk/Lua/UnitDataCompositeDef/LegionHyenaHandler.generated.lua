UndefineClass("LegionHyenaHandler")
DefineClass.LegionHyenaHandler = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 66,
  Agility = 85,
  Dexterity = 44,
  Strength = 40,
  Wisdom = 41,
  Leadership = 81,
  Marksmanship = 50,
  Mechanical = 11,
  Explosives = 10,
  Medical = 9,
  Portrait = "UI/EnemiesPortraits/LegionStormer",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(476314414335, "Hyena Handler"),
  Randomization = true,
  Affiliation = "Legion",
  StartingLevel = 5,
  neutral_retaliate = true,
  archetype = "Skirmisher",
  role = "Commander",
  AlwaysUseOpeningAttack = true,
  OpeningAttackType = "Overwatch",
  MaxAttacks = 2,
  MaxHitPoints = 80,
  StartingPerks = {
    "BeefedUp",
    "MinFreeMove",
    "RelentlessAdvance",
    "Hotblood"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Stormer"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Stormer02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Stormer03"
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
