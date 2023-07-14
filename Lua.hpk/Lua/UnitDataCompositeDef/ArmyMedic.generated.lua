UndefineClass("ArmyMedic")
DefineClass.ArmyMedic = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 51,
  Agility = 75,
  Dexterity = 41,
  Strength = 42,
  Wisdom = 35,
  Leadership = 20,
  Marksmanship = 65,
  Mechanical = 12,
  Explosives = 5,
  Medical = 53,
  Portrait = "UI/EnemiesPortraits/ArmyMedic",
  Name = T(242992790400, "Medic"),
  Randomization = true,
  Affiliation = "Army",
  StartingLevel = 5,
  neutral_retaliate = true,
  archetype = "Medic",
  role = "Medic",
  MaxAttacks = 1,
  MaxHitPoints = 80,
  StartingPerks = {
    "MinFreeMove"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "GrandChien_Medic"
    })
  },
  Equipment = {"ArmyMedic"},
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
