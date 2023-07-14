UndefineClass("RebelGunner")
DefineClass.RebelGunner = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 62,
  Agility = 47,
  Dexterity = 39,
  Strength = 59,
  Wisdom = 30,
  Leadership = 20,
  Marksmanship = 55,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/RebelHeavy",
  Name = T(778303002105, "Ambusher"),
  Randomization = true,
  Affiliation = "Rebel",
  StartingLevel = 2,
  neutral_retaliate = true,
  archetype = "HeavyGunner",
  role = "Heavy",
  MaxAttacks = 2,
  MaxHitPoints = 85,
  StartingPerks = {
    "AutoWeapons",
    "HeavyWeaponsTraining",
    "MinFreeMove",
    "NightOps"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Heavy_Rebels"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Heavy_Rebels_02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Heavy_Rebels_03"
    })
  },
  Equipment = {
    "RebelGunner"
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
