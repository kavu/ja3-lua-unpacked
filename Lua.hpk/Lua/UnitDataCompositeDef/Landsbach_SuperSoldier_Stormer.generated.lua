UndefineClass("Landsbach_SuperSoldier_Stormer")
DefineClass.Landsbach_SuperSoldier_Stormer = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 96,
  Agility = 97,
  Dexterity = 83,
  Strength = 47,
  Wisdom = 77,
  Leadership = 20,
  Marksmanship = 70,
  Mechanical = 56,
  Explosives = 38,
  Medical = 55,
  Portrait = "UI/EnemiesPortraits/ThugHeavy",
  Name = T(517867471402, "Siegfried's Guard"),
  Randomization = true,
  elite = true,
  eliteCategory = "Foreigners",
  Affiliation = "Other",
  StartingLevel = 8,
  neutral_retaliate = true,
  AIKeywords = {"Flank"},
  archetype = "Skirmisher",
  role = "Stormer",
  AlwaysUseOpeningAttack = true,
  CustomEquipGear = function(self, items)
    self:TryLoadAmmo("Handheld A", "Shotgun", "_12gauge_Breacher")
  end,
  MaxHitPoints = 50,
  StartingPerks = {
    "Berserker",
    "BattleFocus",
    "SteadyBreathing",
    "BeefedUp",
    "DieselPerk"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Landsbach_SuperSoldier_Stormer"
    })
  },
  Equipment = {
    "Landsbach_SuperSoldier_Stormer"
  },
  AdditionalGroups = {},
  Tier = "Veteran",
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "AdonisAssault"
}
