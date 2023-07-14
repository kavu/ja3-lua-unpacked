UndefineClass("ArmyHeavy")
DefineClass.ArmyHeavy = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 62,
  Agility = 72,
  Dexterity = 39,
  Strength = 90,
  Wisdom = 30,
  Leadership = 20,
  Marksmanship = 82,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/ArmyHeavy",
  Name = T(160073217247, "Support Gunner"),
  Randomization = true,
  Affiliation = "Army",
  StartingLevel = 5,
  neutral_retaliate = true,
  archetype = "HeavyGunner",
  role = "Heavy",
  MaxAttacks = 2,
  MaxHitPoints = 85,
  StartingPerks = {
    "AutoWeapons",
    "Ironclad"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "GrandChien_Heavy"
    })
  },
  Equipment = {"ArmyHeavy"},
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
  Tier = "Veteran",
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "ArmySoldier"
}
