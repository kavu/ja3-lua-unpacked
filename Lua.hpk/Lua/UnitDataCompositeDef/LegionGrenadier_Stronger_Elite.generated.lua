UndefineClass("LegionGrenadier_Stronger_Elite")
DefineClass.LegionGrenadier_Stronger_Elite = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 80,
  Agility = 90,
  Dexterity = 30,
  Strength = 53,
  Wisdom = 40,
  Leadership = 14,
  Marksmanship = 43,
  Mechanical = 0,
  Explosives = 30,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionDemo",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(386494859840, "Elite Grenadier"),
  Randomization = true,
  elite = true,
  eliteCategory = "Legion",
  Affiliation = "Legion",
  StartingLevel = 2,
  neutral_retaliate = true,
  AIKeywords = {"Explosives", "MobileShot"},
  archetype = "Skirmisher",
  role = "Demolitions",
  CanManEmplacements = false,
  MaxAttacks = 2,
  MaxHitPoints = 50,
  StartingPerks = {
    "Throwing",
    "MinFreeMove",
    "BreachAndClear",
    "RelentlessAdvance",
    "Berserker"
  },
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
    "LegionGrenadier_Stronger_Elite"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "LegionMale_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "LegionMale_2"
    })
  },
  pollyvoice = "Russell",
  gender = "Male",
  VoiceResponseId = "LegionRaider"
}
