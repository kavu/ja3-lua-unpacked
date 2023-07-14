UndefineClass("ArmyDemo")
DefineClass.ArmyDemo = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 65,
  Agility = 71,
  Dexterity = 30,
  Strength = 53,
  Wisdom = 14,
  Leadership = 14,
  Marksmanship = 43,
  Mechanical = 0,
  Explosives = 84,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/ArmyDemo",
  Name = T(404535204537, "Siege Engineer"),
  Randomization = true,
  Affiliation = "Army",
  StartingLevel = 4,
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
