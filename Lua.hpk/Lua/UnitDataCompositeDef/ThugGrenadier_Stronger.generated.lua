UndefineClass("ThugGrenadier_Stronger")
DefineClass.ThugGrenadier_Stronger = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 61,
  Agility = 80,
  Dexterity = 30,
  Strength = 78,
  Wisdom = 30,
  Leadership = 30,
  Marksmanship = 50,
  Mechanical = 0,
  Explosives = 70,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/ThugDemo",
  Name = T(233631704830, "Tough Demo"),
  Randomization = true,
  Affiliation = "Thugs",
  StartingLevel = 4,
  neutral_retaliate = true,
  AIKeywords = {"Explosives"},
  archetype = "Skirmisher",
  role = "Demolitions",
  MaxAttacks = 2,
  MaxHitPoints = 50,
  StartingPerks = {
    "Throwing",
    "CollateralDamage"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Thug_Demolishion"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Thug_Demolishion_1"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Thug_Demolishion_2"
    })
  },
  Equipment = {
    "ThugGrenadier_Stronger"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "ThugMale_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "ThugMale_2"
    })
  },
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "ThugGunner"
}
