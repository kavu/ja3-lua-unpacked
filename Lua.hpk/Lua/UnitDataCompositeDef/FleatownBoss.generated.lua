UndefineClass("FleatownBoss")
DefineClass.FleatownBoss = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 80,
  Agility = 90,
  Dexterity = 80,
  Strength = 90,
  Wisdom = 80,
  Marksmanship = 90,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/NPCsPortraits/BossBlaubert",
  BigPortrait = "UI/NPCs/BossBlaubert",
  Name = T(815569524180, "Boss Blaubert"),
  Randomization = true,
  Affiliation = "Other",
  StartingLevel = 7,
  ImportantNPC = true,
  villain = true,
  neutral_retaliate = true,
  role = "Commander",
  MaxAttacks = 2,
  Lives = 1,
  DefeatBehavior = "Defeated",
  RetreatBehavior = "None",
  StartingPerks = {"Deadeye", "Ironclad"},
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "FleatownBoss"
    })
  },
  Equipment = {
    "FleatownBoss"
  },
  pollyvoice = "Geraint",
  gender = "Male",
  PersistentSessionId = "NPC_FleatownBoss",
  VoiceResponseId = "FleatownBoss"
}
