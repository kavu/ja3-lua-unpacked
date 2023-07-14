UndefineClass("WorkingGuy")
DefineClass.WorkingGuy = {
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
  Name = T(167830818449, "Working Guy"),
  Affiliation = "Civilian",
  MaxAttacks = 1,
  RewardExperience = 0,
  MaxHitPoints = 50,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "WorkingGuy01",
      "Weight",
      25
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "WorkingGuy02",
      "Weight",
      25
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "WorkingGuy03",
      "Weight",
      25
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "WorkingGuy04",
      "Weight",
      25
    })
  },
  pollyvoice = "Matthew",
  gender = "Male"
}
