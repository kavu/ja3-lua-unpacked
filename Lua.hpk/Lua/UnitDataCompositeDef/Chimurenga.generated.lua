UndefineClass("Chimurenga")
DefineClass.Chimurenga = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 85,
  Agility = 90,
  Dexterity = 90,
  Strength = 90,
  Wisdom = 80,
  Leadership = 90,
  Marksmanship = 85,
  Mechanical = 0,
  Explosives = 40,
  Medical = 25,
  Portrait = "UI/NPCsPortraits/Chimurenga",
  BigPortrait = "UI/NPCs/Chimurenga",
  Name = T(645169637501, "Chimurenga"),
  Randomization = true,
  Affiliation = "Rebel",
  StartingLevel = 7,
  ImportantNPC = true,
  villain = true,
  AIKeywords = {"Control"},
  role = "Commander",
  MaxAttacks = 2,
  RewardExperience = 0,
  DefeatBehavior = "Defeated",
  RetreatBehavior = "None",
  StartingPerks = {
    "AutoWeapons",
    "BattleFocus",
    "Ironclad",
    "HoldPosition"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Chimurenga"})
  },
  Equipment = {"Chimurenga"},
  gender = "Male",
  PersistentSessionId = "NPC_Chimurenga",
  VoiceResponseId = "Chimurenga"
}
