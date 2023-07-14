UndefineClass("ArmyScout")
DefineClass.ArmyScout = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 55,
  Agility = 90,
  Dexterity = 73,
  Strength = 48,
  Wisdom = 71,
  Leadership = 29,
  Marksmanship = 70,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/ArmyRecon",
  Name = T(771262338628, "Recon"),
  Randomization = true,
  Affiliation = "Army",
  StartingLevel = 3,
  neutral_retaliate = true,
  AIKeywords = {"Flank", "RunAndGun"},
  archetype = "Skirmisher",
  role = "Recon",
  OpeningAttackType = "Overwatch",
  MaxAttacks = 2,
  MaxHitPoints = 50,
  StartingPerks = {
    "AutoWeapons"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "GrandChien_Recon"
    })
  },
  Equipment = {"ArmyScout"},
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
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "ArmySoldier"
}
