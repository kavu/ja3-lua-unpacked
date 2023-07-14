UndefineClass("DrKronenberg")
DefineClass.DrKronenberg = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 100,
  Agility = 100,
  Dexterity = 70,
  Strength = 50,
  Wisdom = 80,
  Leadership = 70,
  Marksmanship = 10,
  Mechanical = 0,
  Explosives = 0,
  Medical = 90,
  Portrait = "UI/NPCsPortraits/DoctorKronenberg",
  BigPortrait = "UI/NPCs/DoctorKronenberg",
  Name = T(304965029745, "Dr. Kronenberg"),
  Randomization = true,
  Affiliation = "Civilian",
  ImportantNPC = true,
  neutral_retaliate = true,
  MaxAttacks = 2,
  RewardExperience = 0,
  StartingPerks = {
    "Berserker",
    "ZombiePerk",
    "MinFreeMove",
    "StealthKillDefense"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "DoctorMangel"
    })
  },
  Equipment = {
    "Infected_Equipment",
    "DrMangel"
  },
  pollyvoice = "Kendra",
  gender = "Female",
  VoiceResponseId = "DrKronenberg",
  FallbackMissingVR = "VillagerFemale"
}
