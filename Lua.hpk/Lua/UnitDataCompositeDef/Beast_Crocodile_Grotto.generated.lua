UndefineClass("Beast_Crocodile_Grotto")
DefineClass.Beast_Crocodile_Grotto = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 100,
  Agility = 74,
  Dexterity = 69,
  Strength = 100,
  Wisdom = 64,
  Leadership = 9,
  Marksmanship = 0,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Name = T(860963795535, "Crocodile"),
  Randomization = true,
  Affiliation = "Beast",
  StartingLevel = 5,
  neutral_retaliate = true,
  archetype = "Beast_Crocodile",
  role = "Beast",
  CanManEmplacements = false,
  MaxAttacks = 1,
  MaxHitPoints = 60,
  StartingPerks = {
    "MeleeTraining",
    "BloodScent",
    "StealthKillDefense"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Crocodile_Base"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Crocodile_Base_1"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Crocodile_Base_2"
    })
  },
  Equipment = {
    "Beast_Crocodile"
  },
  species = "Crocodile",
  body_type = "Large animal"
}
