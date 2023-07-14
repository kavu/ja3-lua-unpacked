UndefineClass("Baronne")
DefineClass.Baronne = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 70,
  Agility = 80,
  Dexterity = 70,
  Strength = 80,
  Wisdom = 80,
  Leadership = 90,
  Marksmanship = 70,
  Mechanical = 30,
  Explosives = 30,
  Medical = 10,
  Name = T(895345705426, "Baronne des Ordures"),
  Affiliation = "Civilian",
  StartingLevel = 3,
  ImportantNPC = true,
  neutral_retaliate = true,
  AIKeywords = {"Sniper"},
  MaxAttacks = 1,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Baronne"})
  },
  Equipment = {"Baronne"},
  pollyvoice = "Salli",
  gender = "Female",
  PersistentSessionId = "NPC_Baronne",
  FallbackMissingVR = "VillagerFemale"
}
