UndefineClass("GangTrudy")
DefineClass.GangTrudy = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 75,
  Agility = 69,
  Dexterity = 93,
  Strength = 95,
  Wisdom = 16,
  Leadership = 65,
  Marksmanship = 63,
  Mechanical = 0,
  Explosives = 33,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/RebelDemo",
  Name = T(260693332567, "Rude Trudy"),
  Randomization = true,
  Affiliation = "Other",
  StartingLevel = 7,
  ImportantNPC = true,
  neutral_retaliate = true,
  AIKeywords = {"Flank"},
  archetype = "Skirmisher",
  role = "Stormer",
  AlwaysUseOpeningAttack = true,
  MaxAttacks = 2,
  MaxHitPoints = 100,
  StartingPerks = {
    "Berserker",
    "BeefedUp",
    "MinFreeMove"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "GangTrudy"})
  },
  Equipment = {"GangTrudy"},
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
  PersistentSessionId = "NPC_Trudy",
  VoiceResponseId = "GangTrudy",
  FallbackMissingVR = "AnneLeMitrailleur"
}
