UndefineClass("Mollie")
DefineClass.Mollie = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 40,
  Dexterity = 50,
  Strength = 25,
  Wisdom = 10,
  Leadership = 0,
  Marksmanship = 10,
  Mechanical = 0,
  Explosives = 0,
  Medical = 10,
  Portrait = "UI/NPCsPortraits/Mollie",
  BigPortrait = "UI/NPCs/Mollie",
  Name = T(367788038613, "Mollie"),
  Randomization = true,
  Affiliation = "Civilian",
  ImportantNPC = true,
  MaxAttacks = 2,
  RewardExperience = 0,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Mollie"})
  },
  pollyvoice = "Amy",
  gender = "Female",
  PersistentSessionId = "NPC_Mollie",
  FallbackMissingVR = "VillagerFemale"
}
