UndefineClass("MERCSurvivor")
DefineClass.MERCSurvivor = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 57,
  Agility = 48,
  Dexterity = 40,
  Strength = 53,
  Wisdom = 40,
  Leadership = 10,
  Marksmanship = 63,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/MilitiaSoldier",
  Name = T(654093019578, "M.E.R.C. Survivor"),
  Randomization = true,
  StartingLevel = 2,
  neutral_retaliate = true,
  AIKeywords = {"Soldier"},
  role = "Soldier",
  MaxAttacks = 2,
  RewardExperience = 0,
  MaxHitPoints = 50,
  StartingPerks = {
    "AutoWeapons"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "ForeignMerc_01",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "ForeignMerc_02",
      "Weight",
      100
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "ForeignMerc_03",
      "Weight",
      100
    })
  },
  Equipment = {
    "MERCSurvivor"
  },
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "MERCSurvivor"
}
