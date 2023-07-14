UndefineClass("SanatoriumNPC_Infected")
DefineClass.SanatoriumNPC_Infected = {
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
  Name = T(476896309486, "Infected"),
  Randomization = true,
  Affiliation = "Beast",
  neutral_retaliate = true,
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
    }),
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
  gender = "Male",
  infected = true
}
