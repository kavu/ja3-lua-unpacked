UndefineClass("Flay_Pet_Hyena")
DefineClass.Flay_Pet_Hyena = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 46,
  Agility = 84,
  Dexterity = 77,
  Strength = 64,
  Wisdom = 85,
  Leadership = 40,
  Marksmanship = 0,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/Hyena_Legion",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(128873559048, "Gudboi"),
  Randomization = true,
  archetype = "Beast_Hyena",
  role = "Beast",
  CanManEmplacements = false,
  MaxAttacks = 2,
  MaxHitPoints = 60,
  StartingPerks = {
    "MartialArts"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Hyena_Base_6"
    })
  },
  Equipment = {
    "Beast_Hyena"
  },
  species = "Hyena",
  body_type = "Small animal"
}
