UndefineClass("civ_Pepe")
DefineClass.civ_Pepe = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 50,
  Agility = 40,
  Strength = 50,
  Wisdom = 30,
  Leadership = 0,
  Marksmanship = 30,
  Mechanical = 30,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/ThugSoldier",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(938262049888, "Pepe"),
  Randomization = true,
  Affiliation = "Civilian",
  ImportantNPC = true,
  MaxAttacks = 1,
  RewardExperience = 0,
  MaxHitPoints = 60,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "civ_Pepe"})
  },
  pollyvoice = "Matthew",
  gender = "Male",
  PersistentSessionId = "NPC_Pepe"
}
