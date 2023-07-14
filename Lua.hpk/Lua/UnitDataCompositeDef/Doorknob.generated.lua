UndefineClass("Doorknob")
DefineClass.Doorknob = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 90,
  Agility = 80,
  Dexterity = 70,
  Strength = 90,
  Wisdom = 50,
  Leadership = 40,
  Marksmanship = 75,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Name = T(718157864108, "Doorknob"),
  Affiliation = "Other",
  StartingLevel = 4,
  ImportantNPC = true,
  neutral_retaliate = true,
  archetype = "Skirmisher",
  MaxAttacks = 1,
  StartingPerks = {
    "MinFreeMove"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Doorknob"})
  },
  Equipment = {
    "LegionBerserker_Stronger"
  },
  pollyvoice = "Matthew",
  gender = "Male",
  PersistentSessionId = "NPC_Doorknob",
  VoiceResponseId = "Doorknob"
}
