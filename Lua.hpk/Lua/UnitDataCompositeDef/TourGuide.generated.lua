UndefineClass("TourGuide")
DefineClass.TourGuide = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Name = T(500914031207, "Clarke"),
  Affiliation = "Other",
  ImportantNPC = true,
  MaxAttacks = 1,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "TourGuide"})
  },
  FallbackMissingVR = "VillagerFemale"
}
