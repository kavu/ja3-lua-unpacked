UndefineClass("Beast_Crocodile_test")
DefineClass.Beast_Crocodile_test = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 100,
  Agility = 74,
  Dexterity = 69,
  Strength = 100,
  Wisdom = 2,
  Leadership = 9,
  Marksmanship = 0,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Name = T(855393572604, "Crocodile"),
  Affiliation = "Beast",
  neutral_retaliate = true,
  archetype = "Beast_Crocodile",
  role = "Beast",
  CanManEmplacements = false,
  MaxAttacks = 1,
  MaxHitPoints = 60,
  StartingPerks = {
    "MeleeTraining",
    "BloodScent"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Animal_Crocodile"
    })
  },
  Equipment = {
    "Beast_Crocodile"
  },
  species = "Crocodile",
  body_type = "Large animal"
}
