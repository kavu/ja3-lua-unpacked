UndefineClass("Gunther")
DefineClass.Gunther = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 50,
  Agility = 40,
  Dexterity = 90,
  Strength = 25,
  Wisdom = 96,
  Leadership = 94,
  Marksmanship = 88,
  Mechanical = 7,
  Explosives = 5,
  Medical = 87,
  Portrait = "UI/NPCsPortraits/GuntherEsser",
  BigPortrait = "UI/NPCs/GuntherEsser",
  Name = T(529499353870, "Siegfried von Essen"),
  Affiliation = "Other",
  StartingLevel = 10,
  ImportantNPC = true,
  neutral_retaliate = true,
  role = "Commander",
  PinnedDownChance = 100,
  MaxAttacks = 2,
  MaxHitPoints = 50,
  StartingPerks = {
    "BeefedUp",
    "Deadeye",
    "DeathFromAbove",
    "Berserker"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Gunther"})
  },
  Equipment = {
    "Siegfried_LandsbachMine"
  },
  pollyvoice = "Joey",
  gender = "Male",
  PersistentSessionId = "NPC_Siegfried",
  VoiceResponseId = "Gunther"
}
