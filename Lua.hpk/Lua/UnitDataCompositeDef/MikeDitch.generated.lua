UndefineClass("MikeDitch")
DefineClass.MikeDitch = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 50,
  Agility = 50,
  Strength = 50,
  Wisdom = 80,
  Marksmanship = 20,
  Mechanical = 20,
  Explosives = 0,
  Medical = 20,
  Portrait = "UI/NPCsPortraits/MikeDitch",
  BigPortrait = "UI/NPCs/MikeDitch",
  Name = T(641821969746, "Hermit"),
  Randomization = true,
  Affiliation = "Civilian",
  ImportantNPC = true,
  MaxAttacks = 2,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "MikeDitch"})
  },
  pollyvoice = "Joey",
  gender = "Male",
  PersistentSessionId = "NPC_Hermit"
}
