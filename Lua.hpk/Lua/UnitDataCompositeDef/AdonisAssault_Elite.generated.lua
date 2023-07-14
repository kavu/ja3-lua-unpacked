UndefineClass("AdonisAssault_Elite")
DefineClass.AdonisAssault_Elite = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 75,
  Agility = 75,
  Dexterity = 75,
  Strength = 85,
  Wisdom = 56,
  Leadership = 50,
  Marksmanship = 70,
  Mechanical = 50,
  Explosives = 39,
  Medical = 52,
  Portrait = "UI/EnemiesPortraits/AdonisSoldier",
  Name = T(851001503402, "Elite Guard"),
  Randomization = true,
  elite = true,
  eliteCategory = "Foreigners",
  Affiliation = "Adonis",
  StartingLevel = 6,
  neutral_retaliate = true,
  AIKeywords = {
    "Soldier",
    "Ordnance",
    "Explosives"
  },
  role = "Soldier",
  MaxAttacks = 2,
  PickCustomArchetype = function(self, proto_context)
  end,
  CustomEquipGear = function(self, items)
    self:TryLoadAmmo("Handheld A", "AssaultRifle", "_762NATO_Tracer")
    self:TryLoadAmmo("Handheld A", "GrenadeLauncher", "_40mmFlashbangGrenade")
  end,
  MaxHitPoints = 50,
  StartingPerks = {
    "AutoWeapons",
    "LightningReactionNPC",
    "StressManagement"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Adonis_Soldier"
    })
  },
  Equipment = {
    "AdonisAssault_Elite"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "AdonisMale_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Weight",
      50,
      "Exclusive",
      true,
      "Name",
      "AdonisMale_2"
    })
  },
  Tier = "Elite",
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "AdonisAssault"
}
