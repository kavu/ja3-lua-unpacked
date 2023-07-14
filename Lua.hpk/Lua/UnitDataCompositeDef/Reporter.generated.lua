UndefineClass("Reporter")
DefineClass.Reporter = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 70,
  Agility = 70,
  Strength = 55,
  Wisdom = 85,
  Leadership = 30,
  Marksmanship = 50,
  Mechanical = 0,
  Explosives = 0,
  Medical = 30,
  Portrait = "UI/NPCsPortraits/Reporter",
  BigPortrait = "UI/NPCs/Reporter",
  Name = T(280526269044, "Cary Verdad"),
  Randomization = true,
  Affiliation = "Civilian",
  ImportantNPC = true,
  MaxAttacks = 2,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Reporter"})
  },
  pollyvoice = "Emma",
  gender = "Female",
  FallbackMissingVR = "VillagerFemale"
}
