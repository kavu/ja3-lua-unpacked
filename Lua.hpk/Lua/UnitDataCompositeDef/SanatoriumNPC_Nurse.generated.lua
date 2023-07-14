UndefineClass("SanatoriumNPC_Nurse")
DefineClass.SanatoriumNPC_Nurse = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 43,
  Agility = 45,
  Dexterity = 36,
  Strength = 33,
  Wisdom = 39,
  Leadership = 26,
  Marksmanship = 16,
  Mechanical = 0,
  Explosives = 0,
  Medical = 96,
  Portrait = "UI/MercsPortraits/unknown",
  Name = T(212311446348, "Nurse"),
  Randomization = true,
  Affiliation = "Civilian",
  archetype = "Medic",
  role = "Medic",
  MaxAttacks = 2,
  RewardExperience = 0,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Nurse_01"}),
    PlaceObj("AppearanceWeight", {"Preset", "Nurse_02"})
  },
  Equipment = {
    "Civilian_Unarmed",
    "MercFirstAid"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Name",
      "NurseFemale"
    })
  },
  pollyvoice = "Amy",
  gender = "Female",
  FallbackMissingVR = "VillagerFemale"
}
