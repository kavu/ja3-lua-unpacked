UndefineClass("Butler")
DefineClass.Butler = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 50,
  Agility = 40,
  Strength = 50,
  Wisdom = 50,
  Leadership = 20,
  Marksmanship = 40,
  Mechanical = 40,
  Explosives = 65,
  Medical = 20,
  Portrait = "UI/NPCsPortraits/TheButler",
  BigPortrait = "UI/NPCs/TheButler",
  Name = T(709528182137, "Ghost"),
  Randomization = true,
  Affiliation = "Civilian",
  ImportantNPC = true,
  MaxAttacks = 2,
  RewardExperience = 0,
  MaxHitPoints = 60,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Butler"})
  },
  pollyvoice = "Matthew",
  gender = "Male",
  PersistentSessionId = "NPC_Butler"
}
