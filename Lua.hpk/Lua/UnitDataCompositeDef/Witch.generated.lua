UndefineClass("Witch")
DefineClass.Witch = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 70,
  Agility = 80,
  Dexterity = 80,
  Strength = 70,
  Wisdom = 80,
  Marksmanship = 20,
  Mechanical = 0,
  Explosives = 0,
  Medical = 70,
  Portrait = "UI/NPCsPortraits/LamitheWitch",
  BigPortrait = "UI/NPCs/LamitheWitch",
  Name = T(997615208330, "Lami the Witch"),
  Randomization = true,
  Affiliation = "Civilian",
  ImportantNPC = true,
  MaxAttacks = 2,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Lami"})
  },
  Equipment = {"Witch_Loot"},
  pollyvoice = "Nicole",
  gender = "Female",
  PersistentSessionId = "NPC_Witch"
}
