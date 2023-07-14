UndefineClass("SanatoriumNPC_Doctor")
DefineClass.SanatoriumNPC_Doctor = {
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
  Name = T(313977334522, "Doctor"),
  Randomization = true,
  Affiliation = "Civilian",
  archetype = "Medic",
  role = "Medic",
  MaxAttacks = 2,
  RewardExperience = 0,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "Doctor_01"}),
    PlaceObj("AppearanceWeight", {"Preset", "Doctor_02"})
  },
  Equipment = {
    "Civilian_Unarmed",
    "MercFirstAid"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Exclusive",
      true,
      "Name",
      "DoctorMale_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Exclusive",
      true,
      "Name",
      "DoctorMale_2"
    }),
    PlaceObj("AdditionalGroup", {"Name", "DoctorMale"})
  },
  pollyvoice = "Matthew",
  gender = "Male"
}
