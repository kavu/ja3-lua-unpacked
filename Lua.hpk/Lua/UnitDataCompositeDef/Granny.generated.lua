UndefineClass("Granny")
DefineClass.Granny = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 70,
  Agility = 80,
  Dexterity = 34,
  Strength = 70,
  Wisdom = 24,
  Leadership = 10,
  Marksmanship = 80,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/NPCsPortraits/Granny",
  BigPortrait = "UI/NPCs/GrannyCohani",
  Name = T(894404972599, "Granny Cohani"),
  Affiliation = "Civilian",
  StartingLevel = 7,
  ImportantNPC = true,
  neutral_retaliate = true,
  AIKeywords = {"Soldier"},
  role = "Commander",
  MaxAttacks = 2,
  StartingPerks = {
    "AutoWeapons",
    "MinFreeMove",
    "OpportunisticKiller"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Granny"})
  },
  Equipment = {"GangGranny"},
  pollyvoice = "Aditi",
  gender = "Female",
  PersistentSessionId = "NPC_Granny"
}
