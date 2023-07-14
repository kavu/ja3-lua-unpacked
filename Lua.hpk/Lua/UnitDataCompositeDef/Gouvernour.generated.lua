UndefineClass("Gouvernour")
DefineClass.Gouvernour = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 65,
  Agility = 35,
  Dexterity = 45,
  Strength = 50,
  Wisdom = 40,
  Marksmanship = 20,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Name = T(965646561060, "Gouverneur Le Pingouin"),
  Randomization = true,
  Affiliation = "Civilian",
  MaxAttacks = 1,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Gouvernour"})
  },
  PersistentSessionId = "NPC_Gouvernour"
}
