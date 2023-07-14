UndefineClass("Manny")
DefineClass.Manny = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Agility = 50,
  Strength = 65,
  Wisdom = 55,
  Leadership = 10,
  Marksmanship = 40,
  Mechanical = 10,
  Explosives = 0,
  Medical = 15,
  Portrait = "UI/EnemiesPortraits/ThugSoldier",
  Name = T(455331394478, "Manny"),
  Randomization = true,
  Affiliation = "Civilian",
  ImportantNPC = true,
  MaxAttacks = 1,
  RewardExperience = 0,
  MaxHitPoints = 60,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Manny"})
  },
  pollyvoice = "Matthew",
  gender = "Male",
  PersistentSessionId = "NPC_Manny"
}
