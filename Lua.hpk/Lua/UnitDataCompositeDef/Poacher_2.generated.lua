UndefineClass("Poacher_2")
DefineClass.Poacher_2 = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 14,
  Agility = 70,
  Dexterity = 50,
  Strength = 40,
  Wisdom = 40,
  Leadership = 0,
  Marksmanship = 50,
  Mechanical = 20,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/MercsPortraits/unknown",
  Name = T(462588043062, "Braconnier"),
  Affiliation = "Other",
  neutral_retaliate = true,
  MaxAttacks = 2,
  RewardExperience = 0,
  MaxHitPoints = 50,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Poacher_02"})
  },
  Equipment = {"HyenaNPC"},
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Exclusive",
      true,
      "Name",
      "ThugMalePoacher_2"
    }),
    PlaceObj("AdditionalGroup", {
      "Name",
      "CivilianMale_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Name",
      "CivilianMale_2"
    })
  },
  pollyvoice = "Russell",
  gender = "Male",
  VoiceResponseId = "ThugGunner"
}
