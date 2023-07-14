UndefineClass("MaBaxter")
DefineClass.MaBaxter = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 50,
  Strength = 40,
  Wisdom = 75,
  Leadership = 50,
  Marksmanship = 75,
  Mechanical = 0,
  Explosives = 0,
  Medical = 25,
  Name = T(102991120413, "Ma Baxter"),
  Randomization = true,
  Affiliation = "Other",
  immortal = true,
  MaxAttacks = 1,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "MaBaxter"})
  },
  pollyvoice = "Joey",
  gender = "Female",
  FallbackMissingVR = "VillagerFemale"
}
