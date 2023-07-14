UndefineClass("Broker")
DefineClass.Broker = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 50,
  Agility = 70,
  Dexterity = 90,
  Strength = 50,
  Wisdom = 50,
  Marksmanship = 40,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/NPCsPortraits/LaleetheBroker",
  BigPortrait = "UI/NPCs/LaleetheBroker",
  Name = T(340835423981, "Lalee Leewaylender"),
  Randomization = true,
  Affiliation = "Thugs",
  ImportantNPC = true,
  neutral_retaliate = true,
  AIKeywords = {"Soldier"},
  MaxAttacks = 2,
  RewardExperience = 0,
  MaxHitPoints = 60,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Broker"})
  },
  Equipment = {
    "LegionRaiderBastien",
    "Broker_Stash",
    "LootBox05_ammo"
  },
  pollyvoice = "Joey",
  gender = "Male",
  PersistentSessionId = "NPC_Lalee"
}
