UndefineClass("civ_Claudette")
DefineClass.civ_Claudette = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 50,
  Strength = 50,
  Wisdom = 40,
  Leadership = 30,
  Marksmanship = 20,
  Mechanical = 0,
  Explosives = 0,
  Medical = 10,
  Portrait = "UI/MercsPortraits/unknown",
  Name = T(313186586962, "Claudette"),
  Randomization = true,
  Affiliation = "Civilian",
  ImportantNPC = true,
  neutral_retaliate = true,
  MaxAttacks = 1,
  RewardExperience = 0,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "civ_Claudette"
    })
  },
  Equipment = {"Claudette"},
  pollyvoice = "Aditi",
  gender = "Female",
  PersistentSessionId = "NPC_Claudette",
  VoiceResponseId = "civ_Claudette",
  FallbackMissingVR = "VillagerFemale"
}
