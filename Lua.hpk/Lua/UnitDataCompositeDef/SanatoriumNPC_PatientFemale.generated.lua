UndefineClass("SanatoriumNPC_PatientFemale")
DefineClass.SanatoriumNPC_PatientFemale = {
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
  Medical = 13,
  Portrait = "UI/MercsPortraits/unknown",
  Name = T(736028452964, "Patient"),
  Randomization = true,
  Affiliation = "Civilian",
  archetype = "ActiveCivilian",
  MaxAttacks = 2,
  RewardExperience = 0,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "VillagerFemale_01",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "VillagerFemale_02",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "VillagerFemale_03",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "VillagerFemale_04",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "VillagerFemale_05",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "VillagerFemale_06",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "VillagerFemale_07",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "VillagerFemale_08",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "VillagerFemale_09",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "VillagerFemale_10",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "VillagerFemale_11",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "VillagerFemale_12",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "VillagerFemale_13",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "VillagerFemale_14",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "VillagerFemale_15",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "VillagerFemale_16",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "VillagerFemale_17",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "VillagerFemale_18",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "VillagerFemale_19",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "VillagerFemale_20",
      "Weight",
      100
    })
  },
  Equipment = {
    "Civilian_Unarmed"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Exclusive",
      true,
      "Name",
      "CivilianFemalePatient"
    }),
    PlaceObj("AdditionalGroup", {
      "Name",
      "CivilianFemale_2"
    })
  },
  pollyvoice = "Salli",
  gender = "Female",
  FallbackMissingVR = "VillagerFemale"
}
