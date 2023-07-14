UndefineClass("LegionBrawler_SavannaCamp")
DefineClass.LegionBrawler_SavannaCamp = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 88,
  Agility = 86,
  Dexterity = 80,
  Strength = 96,
  Wisdom = 14,
  Leadership = 82,
  Marksmanship = 0,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/LegionButcher",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(634990445480, "Butcher"),
  Affiliation = "Legion",
  StartingLevel = 10,
  neutral_retaliate = true,
  archetype = "Brute",
  role = "Stormer",
  CanManEmplacements = false,
  MaxAttacks = 2,
  MaxHitPoints = 60,
  StartingPerks = {
    "MeleeTraining",
    "MinFreeMove",
    "OpportunisticKiller",
    "Shatterhand",
    "HardBlow"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Legion_Stormer"
    })
  },
  Equipment = {
    "LegionBrawler"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Name",
      "LegionMale_2"
    })
  },
  gender = "Male",
  VoiceResponseId = "LegionRaider"
}
