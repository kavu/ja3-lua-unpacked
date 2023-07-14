UndefineClass("Landsbach_SuperSoldier_Skirmisher")
DefineClass.Landsbach_SuperSoldier_Skirmisher = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 70,
  Agility = 99,
  Dexterity = 83,
  Strength = 47,
  Wisdom = 77,
  Leadership = 20,
  Marksmanship = 82,
  Mechanical = 56,
  Explosives = 38,
  Medical = 55,
  Portrait = "UI/EnemiesPortraits/ArmyRecon",
  Name = T(864753506665, "Siegfried's Guard"),
  Randomization = true,
  elite = true,
  eliteCategory = "Foreigners",
  Affiliation = "Other",
  StartingLevel = 5,
  neutral_retaliate = true,
  AIKeywords = {"Explosives"},
  archetype = "Skirmisher",
  role = "Recon",
  AlwaysUseOpeningAttack = true,
  MaxAttacks = 2,
  CustomEquipGear = function(self, items)
    self:TryLoadAmmo("Handheld A", "SubmachineGun", "_9mm_HP")
  end,
  MaxHitPoints = 50,
  StartingPerks = {
    "AutoWeapons",
    "Berserker",
    "ColdHeart",
    "SteadyBreathing",
    "DieselPerk"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Landsbach_SuperSoldier_Skirmisher"
    })
  },
  Equipment = {
    "Landsbach_SuperSoldier_Skirmisher"
  },
  AdditionalGroups = {},
  Tier = "Veteran",
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "AdonisAssault"
}
