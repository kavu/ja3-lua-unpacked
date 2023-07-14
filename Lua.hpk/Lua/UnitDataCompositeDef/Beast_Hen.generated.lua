UndefineClass("Beast_Hen")
DefineClass.Beast_Hen = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 1,
  Agility = 7,
  Dexterity = 7,
  Strength = 8,
  Wisdom = 9,
  Leadership = 9,
  Marksmanship = 8,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Name = T(781515266695, "Chicken"),
  Affiliation = "Civilian",
  archetype = "Beast_Hyena",
  CanManEmplacements = false,
  MaxAttacks = 1,
  MaxHitPoints = 60,
  StartingPerks = {"LightStep"},
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Animal_Hen_01"
    })
  },
  Equipment = {
    "Beast_Hyena"
  },
  species = "Hen",
  body_type = "Small animal"
}
