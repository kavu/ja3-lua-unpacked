UndefineClass("SanatoriumNPC_InfectedMale")
DefineClass.SanatoriumNPC_InfectedMale = {
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
  Portrait = "UI/EnemiesPortraits/InfectedMale01",
  BigPortrait = "UI/Enemies/LegionRaider",
  Name = T(452912359484, "Patient"),
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
      "Faction_Infected_Male_01"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Faction_Infected_Male_02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Faction_Infected_Male_03"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Faction_Infected_Male_04"
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
      "CivilianMale_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Exclusive",
      true,
      "Name",
      "CivilianMale_2"
    }),
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Name",
      "CivilianMale_3"
    }),
    PlaceObj("AdditionalGroup", {
      "Name",
      "CivilianMalePatient"
    })
  },
  gender = "Male",
  infected = true
}
