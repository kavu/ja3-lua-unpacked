UndefineClass("SanatoriumNPC_InfectedFemale")
DefineClass.SanatoriumNPC_InfectedFemale = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 90,
  Agility = 95,
  Dexterity = 61,
  Strength = 97,
  Wisdom = 2,
  Leadership = 98,
  Marksmanship = 0,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/InfectedFemale01",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(170578694628, "Patient"),
  Randomization = true,
  Affiliation = "Civilian",
  archetype = "Brute",
  role = "Stormer",
  CanManEmplacements = false,
  PinnedDownChance = 100,
  MaxAttacks = 2,
  MaxHitPoints = 60,
  StartingPerks = {
    "Berserker",
    "ZombiePerk",
    "MinFreeMove"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Faction_Infected_Female_01"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Faction_Infected_Female_02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Faction_Infected_Female_03"
    })
  },
  Equipment = {
    "Infected_Equipment"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Exclusive",
      true,
      "Name",
      "CivilianFemale_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Exclusive",
      true,
      "Name",
      "CivilianFemale_2"
    }),
    PlaceObj("AdditionalGroup", {
      "Name",
      "CivilianFemalePatient"
    })
  },
  pollyvoice = "Raveena",
  gender = "Female",
  infected = true,
  FallbackMissingVR = "VillagerFemale"
}
