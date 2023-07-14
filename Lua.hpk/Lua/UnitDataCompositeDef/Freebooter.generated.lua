UndefineClass("Freebooter")
DefineClass.Freebooter = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 74,
  Agility = 81,
  Dexterity = 71,
  Strength = 68,
  Leadership = 59,
  Marksmanship = 80,
  Mechanical = 7,
  Explosives = 5,
  Medical = 16,
  Portrait = "UI/EnemiesPortraits/RebelOfficer",
  Name = T(403488978303, "Freebooter"),
  Randomization = true,
  Affiliation = "Civilian",
  StartingLevel = 6,
  neutral_retaliate = true,
  AIKeywords = {"Soldier"},
  role = "Soldier",
  PinnedDownChance = 100,
  MaxAttacks = 2,
  MaxHitPoints = 50,
  StartingPerks = {
    "AutoWeapons"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "ForeignMerc_01"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "ForeignMerc_03"
    })
  },
  Equipment = {
    "ArmySoldier"
  },
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "LegionRaider"
}
