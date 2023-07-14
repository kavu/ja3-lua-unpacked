UndefineClass("Beast_Crocodile")
DefineClass.Beast_Crocodile = {
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
  Name = T(185881314945, "Crocodile"),
  Randomization = true,
  Affiliation = "Beast",
  StartingLevel = 4,
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
