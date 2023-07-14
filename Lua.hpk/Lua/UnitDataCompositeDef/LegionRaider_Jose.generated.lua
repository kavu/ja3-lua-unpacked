UndefineClass("LegionRaider_Jose")
DefineClass.LegionRaider_Jose = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 79,
  Agility = 72,
  Dexterity = 81,
  Strength = 44,
  Wisdom = 24,
  Leadership = 10,
  Marksmanship = 76,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/NPCsPortraits/Bastien",
  BigPortrait = "UI/NPCs/Bastien",
  Name = T(786119642903, "Bastien"),
  Randomization = true,
  Affiliation = "Legion",
  ImportantNPC = true,
  neutral_retaliate = true,
  AIKeywords = {"Explosives"},
  MaxAttacks = 2,
  MaxHitPoints = 50,
  StartingPerks = {
    "AutoWeapons",
    "MinFreeMove",
    "OpportunisticKiller",
    "BattleFocus"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Bastien"})
  },
  Equipment = {
    "LegionRaiderBastien"
  },
  pollyvoice = "Geraint",
  gender = "Male",
  PersistentSessionId = "NPC_Bastien",
  VoiceResponseId = "LegionRaider_Jose"
}
