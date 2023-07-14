UndefineClass("Peta")
DefineClass.Peta = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 50,
  Agility = 50,
  Dexterity = 40,
  Strength = 45,
  Wisdom = 10,
  Leadership = 0,
  Marksmanship = 0,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Name = T(314006281572, "Petta"),
  Randomization = true,
  Affiliation = "Civilian",
  ImportantNPC = true,
  MaxAttacks = 1,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Peta"})
  },
  Equipment = {"Petta_Loot"},
  pollyvoice = "Amy",
  gender = "Female",
  PersistentSessionId = "NPC_Peta",
  FallbackMissingVR = "VillagerFemale"
}
