UndefineClass("BellaLover")
DefineClass.BellaLover = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 80,
  Dexterity = 10,
  Strength = 80,
  Wisdom = 0,
  Leadership = 0,
  Marksmanship = 0,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Name = T(535285989770, "Bella's lover"),
  Randomization = true,
  Affiliation = "Beast",
  neutral_retaliate = true,
  archetype = "Brute",
  role = "Stormer",
  CanManEmplacements = false,
  MaxAttacks = 2,
  StartingPerks = {
    "Berserker",
    "ZombiePerk",
    "MinFreeMove"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "BellaLover"})
  },
  Equipment = {
    "Infected_Equipment"
  },
  gender = "Male",
  infected = true
}
