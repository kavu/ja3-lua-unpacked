UndefineClass("President")
DefineClass.President = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 86,
  Agility = 74,
  Dexterity = 63,
  Strength = 83,
  Wisdom = 92,
  Leadership = 85,
  Marksmanship = 82,
  Mechanical = 9,
  Explosives = 23,
  Medical = 14,
  Portrait = "UI/NPCsPortraits/President",
  BigPortrait = "UI/NPCs/President",
  Name = T(724264061360, "President LaFontaine"),
  Randomization = true,
  Affiliation = "Legion",
  StartingLevel = 7,
  ImportantNPC = true,
  CanManEmplacements = false,
  MaxAttacks = 2,
  RetreatBehavior = "None",
  StartingPerks = {
    "BeefedUp",
    "Ironclad",
    "TrueGrit"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "President"})
  },
  Equipment = {
    "PresidentGear"
  },
  Tier = "Veteran",
  gender = "Male",
  PersistentSessionId = "NPC_President"
}
