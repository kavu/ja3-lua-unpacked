UndefineClass("Mole")
DefineClass.Mole = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Agility = 50,
  Wisdom = 50,
  Leadership = 35,
  Marksmanship = 55,
  Mechanical = 25,
  Explosives = 20,
  Medical = 0,
  Name = T(279475763814, "The Mole"),
  Randomization = true,
  Affiliation = "Other",
  ImportantNPC = true,
  neutral_retaliate = true,
  MaxAttacks = 1,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Mole"})
  },
  Equipment = {
    "ThugEnforcer"
  },
  pollyvoice = "Geraint",
  gender = "Male"
}
