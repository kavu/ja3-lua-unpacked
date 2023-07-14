UndefineClass("MrsGouvernour")
DefineClass.MrsGouvernour = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 65,
  Agility = 30,
  Dexterity = 10,
  Strength = 20,
  Wisdom = 10,
  Leadership = 0,
  Marksmanship = 0,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Name = T(799267891617, "Mrs. Le Pingouin"),
  Randomization = true,
  Affiliation = "Civilian",
  MaxAttacks = 1,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "MrsGouvernour"
    })
  },
  pollyvoice = "Aditi",
  gender = "Female",
  PersistentSessionId = "NPC_MrsGouvernour",
  FallbackMissingVR = "VillagerFemale"
}
