UndefineClass("WorkingGirl")
DefineClass.WorkingGirl = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 15,
  Agility = 50,
  Dexterity = 20,
  Strength = 20,
  Wisdom = 20,
  Leadership = 0,
  Marksmanship = 15,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/MercsPortraits/unknown",
  Name = T(604442574361, "Working Girl"),
  Affiliation = "Civilian",
  MaxAttacks = 1,
  RewardExperience = 0,
  MaxHitPoints = 50,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "WorkingGirl01",
      "Weight",
      25
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "WorkingGirl02",
      "Weight",
      25
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "WorkingGirl03",
      "Weight",
      25
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "WorkingGirl04",
      "Weight",
      25
    })
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Name",
      "CivilianFemaleFlirty"
    })
  },
  pollyvoice = "Kimberly",
  gender = "Female",
  FallbackMissingVR = "VillagerFemale"
}
