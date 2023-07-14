UndefineClass("GangVinnie")
DefineClass.GangVinnie = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 62,
  Agility = 47,
  Dexterity = 39,
  Strength = 59,
  Wisdom = 30,
  Leadership = 20,
  Marksmanship = 67,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/AdonisSniper",
  Name = T(323513379527, "Old Vinnie"),
  Randomization = true,
  Affiliation = "Other",
  StartingLevel = 7,
  ImportantNPC = true,
  neutral_retaliate = true,
  archetype = "HeavyGunner",
  role = "Heavy",
  AlwaysUseOpeningAttack = true,
  MaxAttacks = 2,
  MaxHitPoints = 85,
  StartingPerks = {
    "HeavyWeaponsTraining",
    "AutoWeapons",
    "MinFreeMove"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "GangVinnie"})
  },
  Equipment = {"GangVinnie"},
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Name",
      "ThugFemale_1"
    }),
    PlaceObj("AdditionalGroup", {
      "Name",
      "ThugFemale_2"
    })
  },
  pollyvoice = "Nicole",
  gender = "Female",
  PersistentSessionId = "NPC_Vinnie",
  VoiceResponseId = "GangTrudy",
  FallbackMissingVR = "AnneLeMitrailleur"
}
