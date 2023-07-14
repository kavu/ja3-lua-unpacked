UndefineClass("Maman")
DefineClass.Maman = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Agility = 30,
  Strength = 50,
  Wisdom = 70,
  Leadership = 70,
  Marksmanship = 10,
  Mechanical = 0,
  Explosives = 0,
  Medical = 50,
  Portrait = "UI/NPCsPortraits/Maman",
  BigPortrait = "UI/NPCs/Maman",
  Name = T(303418313332, "Maman Liliane"),
  Randomization = true,
  Affiliation = "Civilian",
  immortal = true,
  ImportantNPC = true,
  MaxAttacks = 2,
  RewardExperience = 0,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Maman"})
  },
  pollyvoice = "Kendra",
  gender = "Female",
  PersistentSessionId = "NPC_Maman"
}
