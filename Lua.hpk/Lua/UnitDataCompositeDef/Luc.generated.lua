UndefineClass("Luc")
DefineClass.Luc = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 50,
  Agility = 50,
  Strength = 40,
  Wisdom = 80,
  Leadership = 40,
  Marksmanship = 40,
  Mechanical = 40,
  Explosives = 0,
  Medical = 20,
  Portrait = "UI/NPCsPortraits/luc",
  BigPortrait = "UI/NPCs/Luc",
  Name = T(862625679718, "Luc"),
  Randomization = true,
  Affiliation = "Civilian",
  immortal = true,
  ImportantNPC = true,
  MaxAttacks = 2,
  RewardExperience = 0,
  MaxHitPoints = 50,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Luc"})
  },
  pollyvoice = "Matthew",
  gender = "Male",
  PersistentSessionId = "NPC_Luc"
}
