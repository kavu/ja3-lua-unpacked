UndefineClass("AnneLeMitrailleur")
DefineClass.AnneLeMitrailleur = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 62,
  Agility = 47,
  Dexterity = 39,
  Strength = 59,
  Wisdom = 30,
  Leadership = 20,
  Marksmanship = 40,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/RebelStormer",
  Name = T(313818019736, "Anne la Mitrailleuse"),
  Randomization = true,
  Affiliation = "Rebel",
  StartingLevel = 2,
  neutral_retaliate = true,
  archetype = "HeavyGunner",
  role = "Heavy",
  MaxAttacks = 2,
  MaxHitPoints = 85,
  StartingPerks = {
    "AutoWeapons",
    "MinFreeMove"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {
      "Preset",
      "RebelFemaleSniper"
    })
  },
  Equipment = {
    "AnneLeMitrailleur"
  },
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Name",
      "MaquisFemale_1"
    })
  },
  pollyvoice = "Kendra",
  gender = "Female",
  VoiceResponseId = "AnneLeMitrailleur",
  FallbackMissingVR = "VillagerFemale"
}
