UndefineClass("LegionMedic")
DefineClass.LegionMedic = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 42,
  Agility = 94,
  Dexterity = 41,
  Strength = 42,
  Wisdom = 35,
  Leadership = 20,
  Marksmanship = 24,
  Mechanical = 12,
  Explosives = 5,
  Medical = 75,
  Portrait = "UI/EnemiesPortraits/LegionMedic",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(813539739670, "Medic"),
  Randomization = true,
  Affiliation = "Legion",
  StartingLevel = 3,
  neutral_retaliate = true,
  archetype = "Medic",
  role = "Medic",
  CanManEmplacements = false,
  MaxAttacks = 1,
  MaxHitPoints = 80,
  StartingPerks = {
    "MinFreeMove"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_WitchDoctor"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_WitchDoctor02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_WitchDoctor03"
    })
  },
  Equipment = {
    "LegionMedic"
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
