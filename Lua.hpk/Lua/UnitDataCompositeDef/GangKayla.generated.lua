UndefineClass("GangKayla")
DefineClass.GangKayla = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 82,
  Agility = 96,
  Dexterity = 91,
  Strength = 81,
  Wisdom = 79,
  Leadership = 9,
  Marksmanship = 48,
  Mechanical = 0,
  Explosives = 11,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/RebelHeavy",
  Name = T(610974891781, "Kayla the Cutter"),
  Randomization = true,
  Affiliation = "Other",
  StartingLevel = 7,
  ImportantNPC = true,
  neutral_retaliate = true,
  archetype = "Brute",
  role = "Stormer",
  AlwaysUseOpeningAttack = true,
  MaxAttacks = 2,
  MaxHitPoints = 60,
  StartingPerks = {
    "MinFreeMove",
    "LightningReactionNPC",
    "TrueGrit"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "GangKayla"})
  },
  Equipment = {"GangKayla"},
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
  PersistentSessionId = "NPC_Kayla",
  VoiceResponseId = "GangTrudy",
  FallbackMissingVR = "AnneLeMitrailleur"
}
