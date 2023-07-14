UndefineClass("ArmySoldier")
DefineClass.ArmySoldier = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 64,
  Agility = 77,
  Dexterity = 40,
  Strength = 53,
  Wisdom = 31,
  Leadership = 10,
  Marksmanship = 70,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/ArmySoldier",
  Name = T(554900329939, "Trooper"),
  Randomization = true,
  Affiliation = "Army",
  StartingLevel = 4,
  neutral_retaliate = true,
  AIKeywords = {"Soldier"},
  role = "Soldier",
  MaxAttacks = 2,
  MaxHitPoints = 50,
  StartingPerks = {
    "AutoWeapons",
    "MinFreeMove",
    "Hotblood"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "GrandChien_Soldier"
    })
  },
  Equipment = {
    "ArmySoldier"
  },
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
  Tier = "Elite",
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "ArmySoldier"
}
