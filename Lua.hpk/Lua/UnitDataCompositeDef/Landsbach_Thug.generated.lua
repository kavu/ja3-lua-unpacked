UndefineClass("Landsbach_Thug")
DefineClass.Landsbach_Thug = {
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
  Name = T(631807055173, "Night Club Guard"),
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
    "AutoWeapons"
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
      "NightClubThug"
    })
  },
  Tier = "Elite",
  pollyvoice = "Joey",
  gender = "Male",
  VoiceResponseId = "AdonisAssault"
}
