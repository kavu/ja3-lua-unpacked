UndefineClass("GreasyBasil")
DefineClass.GreasyBasil = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 70,
  Agility = 50,
  Dexterity = 65,
  Strength = 70,
  Wisdom = 50,
  Leadership = 50,
  Marksmanship = 45,
  Mechanical = 70,
  Explosives = 10,
  Medical = 0,
  Portrait = "UI/NPCsPortraits/GreasyBasil",
  BigPortrait = "UI/NPCs/GreasyBasil",
  Name = T(593419416390, "Greasy Basil"),
  Randomization = true,
  Affiliation = "Civilian",
  immortal = true,
  ImportantNPC = true,
  MaxAttacks = 1,
  RewardExperience = 0,
  MaxHitPoints = 60,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "GreasyBasil"
    })
  },
  pollyvoice = "Russell",
  gender = "Male",
  PersistentSessionId = "NPC_GreasyBasil"
}
