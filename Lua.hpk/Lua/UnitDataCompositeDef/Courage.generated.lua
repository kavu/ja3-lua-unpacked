UndefineClass("Courage")
DefineClass.Courage = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 42,
  Agility = 79,
  Dexterity = 73,
  Strength = 45,
  Wisdom = 90,
  Leadership = 9,
  Marksmanship = 8,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/Hyena_Courage",
  Name = T(729787129622, "Courage"),
  Randomization = true,
  Affiliation = "Beast",
  neutral_retaliate = true,
  archetype = "Beast_Hyena",
  role = "Stormer",
  CanManEmplacements = false,
  MaxAttacks = 1,
  MaxHitPoints = 60,
  StartingPerks = {"LightStep"},
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Courage"})
  },
  Equipment = {
    "Beast_Hyena",
    "CourageDiamond"
  },
  species = "Hyena",
  body_type = "Small animal"
}
