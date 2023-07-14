UndefineClass("LegionGrenadier_Tutorial")
DefineClass.LegionGrenadier_Tutorial = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 40,
  Agility = 71,
  Dexterity = 30,
  Strength = 53,
  Wisdom = 14,
  Leadership = 14,
  Marksmanship = 43,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionGrenadier",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(856646336914, "Grenadier"),
  Randomization = true,
  Affiliation = "Legion",
  StartingLevel = 2,
  neutral_retaliate = true,
  AIKeywords = {"Explosives"},
  archetype = "Skirmisher",
  role = "Demolitions",
  CanManEmplacements = false,
  MaxAttacks = 1,
  MaxHitPoints = 50,
  StartingPerks = {"Throwing"},
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Demolishion"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Demolishion02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Demolishion03"
    })
  },
  Equipment = {
    "LegionGrenadier"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Name",
      "LegionMale_2"
    })
  },
  pollyvoice = "Russell",
  gender = "Male",
  VoiceResponseId = "LegionRaider"
}
