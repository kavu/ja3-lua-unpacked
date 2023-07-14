UndefineClass("AdonisHeavy")
DefineClass.AdonisHeavy = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 70,
  Agility = 67,
  Dexterity = 75,
  Strength = 95,
  Wisdom = 56,
  Leadership = 50,
  Marksmanship = 70,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/AdonisHeavy",
  Name = T(295570316172, "Guard"),
  Randomization = true,
  Affiliation = "Adonis",
  StartingLevel = 6,
  neutral_retaliate = true,
  archetype = "HeavyGunner",
  role = "Heavy",
  MaxAttacks = 2,
  unitPowerModifier = 75,
  MaxHitPoints = 50,
  StartingPerks = {
    "AutoWeapons",
    "HeavyWeaponsTraining"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Adonis_Heavy"
    })
  },
  Equipment = {
    "AdonisHeavy"
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
