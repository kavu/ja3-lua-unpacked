UndefineClass("GangHannah")
DefineClass.GangHannah = {
  __parents = {"UnitData"},
  __generated_by_class = "UnitDataCompositeDef",
  object_class = "UnitData",
  Health = 61,
  Agility = 49,
  Dexterity = 30,
  Wisdom = 30,
  Leadership = 30,
  Marksmanship = 59,
  Mechanical = 0,
  Explosives = 90,
  Medical = 0,
  Portrait = "UI/EnemiesPortraits/MilitiaDemo",
  Name = T(568115671722, "Mad Hannah"),
  Randomization = true,
  Affiliation = "Other",
  StartingLevel = 7,
  ImportantNPC = true,
  neutral_retaliate = true,
  AIKeywords = {"Explosives"},
  archetype = "Skirmisher",
  role = "Demolitions",
  AlwaysUseOpeningAttack = true,
  MaxAttacks = 2,
  MaxHitPoints = 50,
  StartingPerks = {
    "Throwing",
    "MinFreeMove"
  },
  AppearancesList = {
    PlaceObj("AppearanceWeight", {"Preset", "GangHannah"})
  },
  Equipment = {"GangHannah"},
  AdditionalGroups = {
    PlaceObj("AdditionalGroup", {
      "Name",
      "ThugFemale_1"
    })
  },
  pollyvoice = "Nicole",
  gender = "Female",
  PersistentSessionId = "NPC_Hannah",
  VoiceResponseId = "GangTrudy",
  FallbackMissingVR = "AnneLeMitrailleur"
}
