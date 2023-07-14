UndefineClass("AdonisAssault")
DefineClass.AdonisAssault = {
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
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/AdonisSoldier",
  Name = T(866900508893, "Guard"),
  Randomization = true,
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
  CustomEquipGear = function(self, items)
    self:TryLoadAmmo("Handheld A", "AssaultRifle", "_762NATO_Tracer")
    self:TryLoadAmmo("Handheld A", "GrenadeLauncher", "_40mmFlashbangGrenade")
  end,
  unitPowerModifier = 75,
  MaxHitPoints = 50,
  StartingPerks = {
    "AutoWeapons",
    "LightningReactionNPC"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Adonis_Soldier"
    })
  },
  Equipment = {
    "AdonisAssault"
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
