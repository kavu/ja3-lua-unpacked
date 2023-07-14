UndefineClass("Bella")
DefineClass.Bella = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 100,
  Dexterity = 30,
  Strength = 80,
  Wisdom = 0,
  Leadership = 0,
  Marksmanship = 0,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Name = T(122366219972, "Bella"),
  Randomization = true,
  Affiliation = "Beast",
  neutral_retaliate = true,
  archetype = "Brute",
  role = "Stormer",
  MaxAttacks = 2,
  StartingPerks = {
    "Berserker",
    "ZombiePerk",
    "MinFreeMove"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Bella"})
  },
  Equipment = {
    "Infected_Equipment"
  },
  pollyvoice = "Joanna",
  gender = "Female",
  infected = true
}
