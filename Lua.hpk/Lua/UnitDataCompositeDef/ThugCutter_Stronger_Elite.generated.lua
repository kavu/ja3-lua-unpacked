UndefineClass("ThugCutter_Stronger_Elite")
DefineClass.ThugCutter_Stronger_Elite = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 88,
  Agility = 96,
  Dexterity = 91,
  Strength = 91,
  Wisdom = 79,
  Leadership = 9,
  Marksmanship = 38,
  Mechanical = 0,
  Explosives = 11,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/ThugRecon",
  Name = T(438547917615, "Badass Slasher"),
  Randomization = true,
  Affiliation = "Thugs",
  StartingLevel = 8,
  neutral_retaliate = true,
  archetype = "Brute",
  role = "Stormer",
  MaxAttacks = 2,
  MaxHitPoints = 60,
  StartingPerks = {
    "MinFreeMove",
    "HardBlow",
    "InstantAutopsy",
    "ColdHeart",
    "TrueGrit"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Thug_Recon"}),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Thug_Recon_1"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Thug_Recon_2"
    })
  },
  Equipment = {
    "ThugCutter_Stronger"
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
  gender = "Male",
  VoiceResponseId = "ThugGunner"
}
