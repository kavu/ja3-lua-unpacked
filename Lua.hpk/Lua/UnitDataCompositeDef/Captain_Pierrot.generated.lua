UndefineClass("Captain_Pierrot")
DefineClass.Captain_Pierrot = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Agility = 85,
  Dexterity = 70,
  Strength = 50,
  Wisdom = 40,
  Leadership = 75,
  Mechanical = 0,
  Explosives = 50,
  Medical = 0,
  Name = T(610796194636, "Captain Jacques Pierrot"),
  Randomization = true,
  Affiliation = "Civilian",
  ImportantNPC = true,
  neutral_retaliate = true,
  AIKeywords = {"Explosives"},
  archetype = "Brute",
  MaxAttacks = 1,
  RewardExperience = 0,
  MaxHitPoints = 60,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Captain_Pierrot"
    })
  },
  Equipment = {"ThugCutter"},
  pollyvoice = "Matthew",
  gender = "Male",
  PersistentSessionId = "NPC_CaptainPierrot"
}
