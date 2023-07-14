UndefineClass("Landsbach_Thug_Diesel")
DefineClass.Landsbach_Thug_Diesel = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 75,
  Agility = 75,
  Dexterity = 75,
  Strength = 85,
  Wisdom = 56,
  Leadership = 50,
  Marksmanship = 80,
  Mechanical = 50,
  Explosives = 39,
  Medical = 52,
  Portrait = "UI/EnemiesPortraits/RebelRecon",
  Name = T(573934830682, "Night Club Guard"),
  Randomization = true,
  elite = true,
  eliteCategory = "Foreigners",
  Affiliation = "Other",
  StartingLevel = 4,
  neutral_retaliate = true,
  role = "Soldier",
  MaxAttacks = 2,
  PickCustomArchetype = function(self, proto_context)
  end,
  MaxHitPoints = 50,
  StartingPerks = {
    "AutoWeapons",
    "Berserker",
    "DieselPerk",
    "BeefedUp"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Recon_Rebels"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Recon_Rebels_02"
    }),
    PlaceObj("AppearanceWeight", {
      "Preset",
      "Recon_Rebels_03"
    })
  },
  Equipment = {
    "LegionRaider_Stronger"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Name",
      "NightClubThugDiesel"
    })
  },
  Tier = "Elite",
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "AdonisAssault"
}
