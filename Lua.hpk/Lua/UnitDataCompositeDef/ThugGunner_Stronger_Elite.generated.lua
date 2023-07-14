UndefineClass("ThugGunner_Stronger_Elite")
DefineClass.ThugGunner_Stronger_Elite = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 62,
  Agility = 77,
  Dexterity = 39,
  Strength = 82,
  Wisdom = 30,
  Leadership = 20,
  Marksmanship = 84,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/ThugHeavy",
  Name = T(786003785968, "Badass Gun-runner"),
  Randomization = true,
  Affiliation = "Thugs",
  StartingLevel = 7,
  neutral_retaliate = true,
  archetype = "HeavyGunner",
  role = "Heavy",
  MaxAttacks = 2,
  MaxHitPoints = 85,
  StartingPerks = {
    "HeavyWeaponsTraining",
    "AutoWeapons",
    "Killzone"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Thug_Heavy"}),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Thug_Heavy_1"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Thug_Heavy_2"
    })
  },
  Equipment = {
    "ThugGunner_Stronger"
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
