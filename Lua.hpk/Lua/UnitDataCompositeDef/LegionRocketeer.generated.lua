UndefineClass("LegionRocketeer")
DefineClass.LegionRocketeer = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 28,
  Agility = 83,
  Dexterity = 8,
  Strength = 88,
  Wisdom = 14,
  Leadership = 10,
  Marksmanship = 12,
  Mechanical = 0,
  Explosives = 41,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionArtillery",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(309329193529, "Rocket Man"),
  Randomization = true,
  Affiliation = "Legion",
  neutral_retaliate = true,
  AIKeywords = {"Ordnance"},
  role = "Artillery",
  CanManEmplacements = false,
  MaxAttacks = 1,
  MaxHitPoints = 50,
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Artillery"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Artillery02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Artillery03"
    })
  },
  Equipment = {
    "LegionRocketeer"
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
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "LegionRaider"
}
