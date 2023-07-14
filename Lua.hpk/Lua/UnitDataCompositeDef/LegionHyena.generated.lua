UndefineClass("LegionHyena")
DefineClass.LegionHyena = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 27,
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
  Name = T(568117501199, "Trained Hyena"),
  Randomization = true,
  Affiliation = "Legion",
  neutral_retaliate = true,
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
      "Hyena_Base_2"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Hyena_Base_4"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Hyena_Base_5"
    })
  },
  Equipment = {
    "Beast_Hyena"
  },
  species = "Hyena",
  body_type = "Small animal"
}
