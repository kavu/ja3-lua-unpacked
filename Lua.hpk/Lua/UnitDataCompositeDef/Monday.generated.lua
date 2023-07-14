UndefineClass("Monday")
DefineClass.Monday = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 50,
  Agility = 30,
  Dexterity = 10,
  Strength = 50,
  Wisdom = 30,
  Leadership = 0,
  Marksmanship = 0,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/NPCsPortraits/Monday",
  BigPortrait = "UI/NPCs/Monday",
  Name = T(428482195213, "Monday the Drunk"),
  Randomization = true,
  Affiliation = "Civilian",
  ImportantNPC = true,
  MaxAttacks = 1,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Monday"})
  },
  gender = "Male",
  PersistentSessionId = "NPC_Monday"
}
