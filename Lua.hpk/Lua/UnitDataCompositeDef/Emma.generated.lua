UndefineClass("Emma")
DefineClass.Emma = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Agility = 80,
  Dexterity = 70,
  Strength = 50,
  Wisdom = 80,
  Leadership = 80,
  Marksmanship = 50,
  Mechanical = 0,
  Explosives = 0,
  Medical = 20,
  Portrait = "UI/NPCsPortraits/Emma",
  BigPortrait = "UI/NPCs/Emma",
  Name = T(490022190044, "Emma LaFontaine"),
  Randomization = true,
  Affiliation = "Civilian",
  immortal = true,
  ImportantNPC = true,
  MaxAttacks = 2,
  MaxHitPoints = 100,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Emma"})
  },
  pollyvoice = "Nicole",
  gender = "Female",
  PersistentSessionId = "NPC_Emma",
  FallbackMissingVR = "VillagerFemale"
}
