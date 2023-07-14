UndefineClass("Bulldozer")
DefineClass.Bulldozer = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 80,
  Agility = 70,
  Dexterity = 70,
  Strength = 100,
  Wisdom = 50,
  Leadership = 0,
  Marksmanship = 0,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Name = T(723142004913, "Bulldozer"),
  Affiliation = "Other",
  StartingLevel = 4,
  neutral_retaliate = true,
  archetype = "Brute",
  MaxAttacks = 1,
  StartingPerks = {
    "OptimalPerformance",
    "Berserker",
    "TrueGrit",
    "LineBreaker"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Bulldozer"})
  },
  Equipment = {
    "Civilian_Unarmed"
  },
  pollyvoice = "Russell",
  gender = "Male",
  PersistentSessionId = "NPC_Bulldozer"
}
