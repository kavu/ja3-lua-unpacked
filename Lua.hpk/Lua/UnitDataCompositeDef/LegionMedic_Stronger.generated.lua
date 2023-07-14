UndefineClass("LegionMedic_Stronger")
DefineClass.LegionMedic_Stronger = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 42,
  Agility = 93,
  Dexterity = 41,
  Strength = 42,
  Wisdom = 35,
  Leadership = 20,
  Marksmanship = 74,
  Mechanical = 12,
  Explosives = 5,
  Medical = 93,
  Portrait = "UI/EnemiesPortraits/LegionMedic",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(453944463138, "Veteran Medic"),
  Randomization = true,
  Affiliation = "Legion",
  StartingLevel = 5,
  neutral_retaliate = true,
  archetype = "Medic",
  role = "Medic",
  CanManEmplacements = false,
  MaxAttacks = 1,
  MaxHitPoints = 80,
  StartingPerks = {
    "MinFreeMove",
    "Caretaker"
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
    "LegionMedic_Stronger"
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
