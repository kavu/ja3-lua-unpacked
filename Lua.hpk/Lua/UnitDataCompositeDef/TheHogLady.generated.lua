UndefineClass("TheHogLady")
DefineClass.TheHogLady = {
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
  Name = T(603188479199, "The Hog Lady"),
  Randomization = true,
  Affiliation = "Other",
  ImportantNPC = true,
  MaxAttacks = 1,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "TheHogLady"})
  },
  pollyvoice = "Nicole",
  gender = "Female",
  FallbackMissingVR = "GangTrudy"
}
