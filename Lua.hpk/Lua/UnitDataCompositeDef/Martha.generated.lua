UndefineClass("Martha")
DefineClass.Martha = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 50,
  Strength = 40,
  Wisdom = 40,
  Leadership = 50,
  Marksmanship = 30,
  Mechanical = 0,
  Explosives = 0,
  Medical = 10,
  Portrait = "UI/NPCsPortraits/Martha",
  BigPortrait = "UI/NPCs/Martha",
  Name = T(545930786101, "Martha"),
  Randomization = true,
  Affiliation = "Civilian",
  immortal = true,
  ImportantNPC = true,
  MaxAttacks = 1,
  RewardExperience = 0,
  MaxHitPoints = 60,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Martha"})
  },
  pollyvoice = "Kendra",
  gender = "Female",
  PersistentSessionId = "NPC_Martha",
  FallbackMissingVR = "VillagerFemale"
}
