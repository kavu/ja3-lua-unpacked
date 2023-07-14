UndefineClass("LegionGrenadier")
DefineClass.LegionGrenadier = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 53,
  Agility = 80,
  Dexterity = 30,
  Strength = 53,
  Wisdom = 14,
  Leadership = 14,
  Marksmanship = 43,
  Mechanical = 0,
  Explosives = 25,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionDemo",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(524575421238, "Grenadier"),
  Randomization = true,
  Affiliation = "Legion",
  StartingLevel = 2,
  neutral_retaliate = true,
  AIKeywords = {"Explosives", "MobileShot"},
  archetype = "Skirmisher",
  role = "Demolitions",
  CanManEmplacements = false,
  MaxAttacks = 1,
  MaxHitPoints = 50,
  StartingPerks = {
    "Throwing",
    "MinFreeMove"
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
    "LegionGrenadier"
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
