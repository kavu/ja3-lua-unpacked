UndefineClass("GangWilma")
DefineClass.GangWilma = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 61,
  Agility = 57,
  Dexterity = 52,
  Strength = 49,
  Wisdom = 30,
  Leadership = 20,
  Marksmanship = 86,
  Mechanical = 0,
  Explosives = 0,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/RebelSniper",
  Name = T(267693313965, "Gal Wilma"),
  Randomization = true,
  Affiliation = "Other",
  StartingLevel = 7,
  ImportantNPC = true,
  neutral_retaliate = true,
  AIKeywords = {"Flank", "MobileShot"},
  archetype = "Skirmisher",
  role = "Recon",
  AlwaysUseOpeningAttack = true,
  MaxAttacks = 2,
  MaxHitPoints = 50,
  StartingPerks = {
    "MinFreeMove"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "GangWilma"})
  },
  Equipment = {"GangWilma"},
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
  PersistentSessionId = "NPC_Wilma",
  VoiceResponseId = "GangTrudy",
  FallbackMissingVR = "AnneLeMitrailleur"
}
