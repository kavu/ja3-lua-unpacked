UndefineClass("Beast_Hyena")
DefineClass.Beast_Hyena = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 32,
  Agility = 79,
  Dexterity = 73,
  Strength = 45,
  Wisdom = 9,
  Leadership = 9,
  Marksmanship = 82,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/Hyena",
  Name = T(334856929639, "Hyena"),
  Randomization = true,
  Affiliation = "Beast",
  neutral_retaliate = true,
  archetype = "Beast_Hyena",
  role = "Beast",
  CanManEmplacements = false,
  MaxAttacks = 1,
  MaxHitPoints = 60,
  StartingPerks = {
    "MartialArts"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Hyena_Base"}),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Hyena_Base_1"
    })
  },
  Equipment = {
    "Beast_Hyena"
  },
  species = "Hyena",
  body_type = "Small animal"
}
