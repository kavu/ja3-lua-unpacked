UndefineClass("Shaman")
DefineClass.Shaman = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 50,
  Agility = 30,
  Dexterity = 50,
  Strength = 40,
  Wisdom = 90,
  Marksmanship = 30,
  Mechanical = 0,
  Explosives = 0,
  Medical = 70,
  Portrait = "UI/NPCsPortraits/SangomaTheShaman",
  BigPortrait = "UI/NPCs/SangomaTheShaman",
  Name = T(993555393219, "Sangoma"),
  Randomization = true,
  Affiliation = "Civilian",
  ImportantNPC = true,
  MaxAttacks = 2,
  RewardExperience = 0,
  MaxHitPoints = 60,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Shaman"})
  },
  gender = "Male",
  PersistentSessionId = "NPC_Shaman"
}
