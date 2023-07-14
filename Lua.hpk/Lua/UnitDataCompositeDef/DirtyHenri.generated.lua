UndefineClass("DirtyHenri")
DefineClass.DirtyHenri = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 75,
  Agility = 90,
  Dexterity = 85,
  Strength = 80,
  Wisdom = 70,
  Leadership = 50,
  Marksmanship = 95,
  Mechanical = 10,
  Explosives = 10,
  Medical = 5,
  Name = T(485170553683, "Dirty Henri"),
  Affiliation = "Civilian",
  StartingLevel = 8,
  ImportantNPC = true,
  neutral_retaliate = true,
  AIKeywords = {"MobileShot"},
  archetype = "Skirmisher",
  AlwaysUseOpeningAttack = true,
  OpeningAttackType = "Overwatch",
  StartingPerks = {
    "CQCTraining",
    "Hotblood",
    "TrueGrit",
    "InstantAutopsy",
    "Hobbler"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "DirtyHenri"})
  },
  Equipment = {"DirtyHenry"},
  gender = "Male",
  PersistentSessionId = "NPC_DirtyHenri"
}
