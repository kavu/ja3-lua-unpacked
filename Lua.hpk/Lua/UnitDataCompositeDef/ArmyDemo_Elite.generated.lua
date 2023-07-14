UndefineClass("ArmyDemo_Elite")
DefineClass.ArmyDemo_Elite = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 94,
  Agility = 84,
  Dexterity = 30,
  Strength = 53,
  Wisdom = 14,
  Leadership = 14,
  Marksmanship = 43,
  Mechanical = 0,
  Explosives = 91,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/ArmyDemo",
  Name = T(266253718474, "Elite Siege Engineer"),
  Randomization = true,
  elite = true,
  Affiliation = "Army",
  StartingLevel = 6,
  neutral_retaliate = true,
  AIKeywords = {"Explosives"},
  archetype = "Skirmisher",
  role = "Demolitions",
  MaxAttacks = 1,
  MaxHitPoints = 50,
  StartingPerks = {"Throwing"},
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "GrandChien_Demolition"
    })
  },
  Equipment = {"ArmyDemo"},
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
  pollyvoice = "Russell",
  gender = "Male",
  VoiceResponseId = "ArmySoldier"
}
