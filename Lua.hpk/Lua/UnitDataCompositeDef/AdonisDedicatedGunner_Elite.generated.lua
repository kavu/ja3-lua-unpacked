UndefineClass("AdonisDedicatedGunner_Elite")
DefineClass.AdonisDedicatedGunner_Elite = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 75,
  Agility = 85,
  Dexterity = 75,
  Strength = 95,
  Wisdom = 56,
  Leadership = 50,
  Marksmanship = 90,
  Mechanical = 50,
  Explosives = 39,
  Medical = 52,
  Portrait = "UI/EnemiesPortraits/AdonisHeavy",
  Name = T(188933600963, "Gunner"),
  Randomization = true,
  elite = true,
  Affiliation = "Adonis",
  StartingLevel = 6,
  neutral_retaliate = true,
  role = "Heavy",
  MaxAttacks = 4,
  MaxHitPoints = 50,
  StartingPerks = {
    "AutoWeapons",
    "HeavyWeaponsTraining",
    "CollateralDamage"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Adonis_Soldier"
    })
  },
  Equipment = {
    "AdonisAssault_Elite"
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
