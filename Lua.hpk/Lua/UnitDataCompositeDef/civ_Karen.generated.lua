UndefineClass("civ_Karen")
DefineClass.civ_Karen = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 50,
  Agility = 30,
  Dexterity = 30,
  Strength = 30,
  Wisdom = 0,
  Leadership = 0,
  Marksmanship = 0,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/MercsPortraits/unknown",
  Name = T(788515498003, "Karen Gosling"),
  Randomization = true,
  Affiliation = "Civilian",
  ImportantNPC = true,
  MaxAttacks = 1,
  RewardExperience = 0,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "civ_Karen"})
  },
  Equipment = {"Karen"},
  pollyvoice = "Amy",
  gender = "Female",
  PersistentSessionId = "NPC_Karen",
  VoiceResponseId = "civ_Karen",
  FallbackMissingVR = "VillagerFemale"
}
