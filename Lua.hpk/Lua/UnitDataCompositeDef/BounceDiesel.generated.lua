UndefineClass("BounceDiesel")
DefineClass.BounceDiesel = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 75,
  Agility = 72,
  Dexterity = 80,
  Strength = 61,
  Wisdom = 82,
  Leadership = 0,
  Marksmanship = 80,
  Mechanical = 0,
  Explosives = 0,
  Medical = 49,
  Portrait = "UI/NPCsPortraits/Bounce",
  BigPortrait = "UI/NPCs/Bounce",
  Name = T(253173158925, "Bounce"),
  Randomization = true,
  Affiliation = "Other",
  StartingLevel = 5,
  ImportantNPC = true,
  neutral_retaliate = true,
  AIKeywords = {"Soldier"},
  MaxAttacks = 2,
  RewardExperience = 0,
  MaxHitPoints = 60,
  StartingPerks = {
    "AutoWeapons",
    "Berserker",
    "DieselPerk",
    "BeefedUp"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Bounce"})
  },
  Equipment = {
    "LegionRaider_Stronger_Elite"
  },
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "Bounce"
}
